     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate order customer')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVODCS  - Validate Ordering Customer                        *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD055570           Date 15May20               *
      *                 MD051978           Date 14Oct19               *
      *                 MD039547           Date 20Sep16               *
      *                 MD046248           Date 27Oct17               *
      *                 MD037223           Date 20Jul17               *
      *                 MD045920           Date 31May17               *
      *                 MD044074           Date 19Apr17               *
      *                 CFT142             Date 20Feb15               *
      *                 AR924563           Date 05Nov14               *
      *                 MD000091           Date 15May13               *
      *                 AR924725           Date 14Dec12               *
      *                 259953A            Date 23Jan13               *
      *                 259953             Date 23Jan13               *
      *                 CFT148             Date 23Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR863288           Date 11Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      *                 BUG26794           Date 25Nov09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25973           Date 17Sep09               *
      *                 BUG26175           Date 24Sep09               *
      *                 BUG26002           Date 14Sep09               *
      *                 BUG25904A          Date 11Sep09               *
      *                 BUG25859           Date 04Sep09               *
      *                 BUG25676           Date 24Aug09               *
      *                 BUG24975           Date 17Jul09               *
      *                 BUG24898           Date 13Jul09               *
      *                 BUG24666           Date 30Jun09               *
      *                 BUG25228           Date 29Jul09               *
      *                 BUG25042           Date 23Jul09               *
      *                 BUG25041           Date 23Jul09               *
      *                 BUG25040           Date 22Jul09               *
      *                 BUG24679           Date 01Jul09               *
      *                 BUG24828           Date 10Jul09               *
      *                 257361             Date 12Nov08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 255286A            Date 21Jul08               *
      *                 255286             Date 07Jul08               *
      *                 BUG21272           Date 07Oct08               *
      *                 BUG21131           Date 22Sep08               *
      *                 BUG13798           Date 24Apr07               *
      *                 BUG15217           Date 02Nov07               *
      *                 BUG15059           Date 26Oct07               *
      *                 BUG15088           Date 23Oct07               *
      *                 BUG15065           Date 16Oct07               *
      *                 BUG15045           Date 19Oct07               *
      *                 BUG15037           Date 16Oct07               *
      *                 250804A            Date 11Oct07               *
      *                 250600             Date 07Oct07               *
      *                 BUG14968           Date 09Oct07               *
      *                 BUG14771A          Date 18Sep07               *
      *                 BUG14771           Date 12Aug07               *
      *                 BUG14809           Date 06Sep07               *
      *                 BUG14716A          Date 04Sep07               *
      *                 BUG14716           Date 24Aug07               *
      *                 BUG14593           Date 12Aug07               *
      *                 249652             Date 09Jul07               *
      *                 BUG14538           Date 02Aug07               *
      *                 CSW207A            Date 26Jul07               *
      *                 CSW207             Date 07Jun07               *
      *                 247142             Date 23Jul07               *
      *                 BUG14042           Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13455           Date 20Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12796           Date 05Dec06               *
      *                 BUG12692           Date 15Nov06               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 240689             Date 13Jul06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4581            Date 20Oct04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 210863             Date 13Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 179732             Date 06Jun00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 12Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD055570 - Payment with account blocked (CR/DR) can be       *
      *             inserted.                                         *
      *  MD051978 - ':' should not be present in first character of   *
      *             address lines (except the first address line)     *
      *  MD039547 - Referred account is not properly validated.       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037223 - Retrieve DACO for all types of account to be used *
      *             in validation.                                    *
      *  MD045920 - Ordering Customer account number is missing from  *
      *             FT SWIFT payment.                                 *
      *           - Validation of ACOUNTLINE for OMFM is not being    *
      *             invoked.                                          *
      *  MD044074 - Serious Midas Error in Outgoing Payment.          *
      *  CFT142 - OPAY msg validation (LCO044)                        *
      *  AR924563 - '-' should not be present in 1st character of     *
      *             outgoing payments fields 50, 57D, 59, 70 and 72.  *
      *             Recompile due to change in /copy SFTADDRCLE       *
      *             (Child: AR924564)                                 *
      *  MD000091 - Event Codes Substitution                          *
      *  AR924725 - Profit center is blank in the confirmation screen *
      *             even if user entered a value. Amended so that the *
      *             profit center will not be overwritten.            *
      *             Fix patterned to 261177. (Child: AR924728)        *
      *  259953A - CFT148 : Remove IBAN validation for 50F            *
      *            Added hook: CFT148_026                             *
      *  259953 - CFT148 : FT Cannot view IPAY on enquiry screen      *
      *           Amended hooks: CFT148_027 (Recompile)               *
      *  CFT148 - FT Remove Validation on Field 50F                   *
      *           Added hooks: CFT148_025, CFT148_027, CFT148_028     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR863288 - Ordering Customer with partial account input      *
      *             is considered as an address                       *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  BUG26794 - Consider Settlement 14 in setting Network field   *
      *  BUG25973 - When Ordering Customer L1 is equal to valid IBAN  *
      *             without slash followed by 1/, 6/, 6/ the system   *
      *             accepts the transaction                           *
      *  BUG26175 - Error encountered if Partial Account is entered   *
      *             in Ordering Customer Field                        *
      *  BUG26002 - Error encountered on valid insert                 *
      *  BUG25904A - Error encountered during valid insert of IBAN    *
      *              Ordering Customer.                               *
      *  BUG25859 - Invalid error message appear                      *
      *  BUG25676 - Ordering Customer lines 2-5 must be blank if      *
      *             MT202 is used.                                    *
      *  BUG24975 - Error message and warning message shown if        *
      *             ordering customer IBAN contains invalid SWIFT     *
      *             values.                                           *
      *  BUG24898 - Incorrect error message was displayed             *
      *  BUG24666 - Valid IBAN is rejected in the Ordering customer   *
      *  BUG25228 - System should not accept fifth line in ordering   *
      *             customer if line 1 doesn't start with a "/" or    *
      *             valid 4 chars code word                           *
      *  BUG25042 - Remove the warning message appeared               *
      *  BUG25041 - Remove the other error message. Applied BUG25092. *
      *  BUG25040 - No error message appeared for external account not*
      *             defined in ACCNTAB                                *
      *  BUG25092 - Incorrect error message appear                    *
      *  BUG24679 - 50K should be 50F                                 *
/*    *  BUG24828 - Validation not performed for field 50F if         *
/*    *             warning message 'IBAN length is not correct in    *
/*    *             field 'Ordering Customer'.                        *
      *  257361 - Warning message ('Warning: network TELEX must be    *
      *           defined in Standing data') appears for Settelement  *
      *           type '02' (cheques)                                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  255286A- Allow lowercase characters on input                 *
      *  255286 - Allow lowercase characters on input                 *
      *  BUG21272 - MT202 not accepted in Ordering Customer field     *
      *  BUG21131 - Invalid Customer # was not rejected.              *
      *  BUG13798 - CFT032 errors. Applied by BUG14042.               *
      *  BUG15217 - Warning message occur(instead of an error msg)    *
      *             but still cannot proceed to the next screen       *
      *  BUG15059 - MT message should not be 50F because ordering     *
      *             customer is considered external.                  *
      *  BUG15088 - Incomplete validation of Ordering Customer for    *
      *             partial accounts.                                 *
      *  BUG15065 - Validation error in IPAY                          *
      *  BUG15045 - System does not accept an External account input  *
      *             in Ordering customer field                        *
      *  BUG15037 - Error message should be a warning                 *
      *  250804A - Fix various CFT032/CSW207 Errors                   *
      *  250600 - Fix various CFT032/CSW207 Errors                    *
      *  BUG14968 - MMA1414 issue where message should be an Error,   *
      *             not warning                                       *
      *  BUG14771A - Amended the input function and the message       *
      *              generation for CFT032                            *
      *  BUG14771 - Amended the input function and the message        *
      *             generation for CFT032                             *
      *  BUG14809 - Midas error when amending record from             *
      *             Outgoing Payment Template                         *
      *  BUG14716A - Reopen BUG14716 (Recompile)                      *
      *  BUG14716 - CFT032 pre-req missing CFT018 OPSI Outgoing       *
      *             Payments Template                                 *
      *  BUG14593 - SWIFT 2007 error in SP08                          *
      *  249652 - CFT032, a few problems                              *
      *  BUG14538 - CFT032 errors                                     *
      *  CSW207A - Serious midas error occurred on OPAY transaction   *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning.                  *
      *           Apply fixes 232151 and 210654.                      *
      *  232151 - DBASE error when inserting an inactive account.     *
      *           Codings under 240689.                               *
      *  210654 - Check status of Account. Codings under 240689.      *
      *  BUG14042 - CFT032 errors ; applied fix 13798                 *
      *  BUG13455 - CFT032 Parameter Mismatch for AOOUFMR0            *
      *  BUG12796 - Wrong data type passed to build-in function %INT  *
      *             causes *PSSR to be executed.                      *
      *  BUG12692 - Error when creating a new OPAY transaction        *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240689 - Applied fix 210654 + additional changes by 232151.  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4581- Check for block debits/credits                      *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  210863 - Highlight respective ordering customer fields       *
      *           correctly.                                          *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  179732 - Similar to Fix 176510 on OPM Equivalent FT0040      *
      *           Ordering customers that are Retail accounts use the *
      *           Profit centre defined on ACCNTAB/ACNUMA for the     **
      *           account.                                            **
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
      *****************************************************************

     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)

     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMAF)
                                                                                              CSW207
     F***SDJACCL4  IF   E           K DISK    INFSR(*PSSR)                            CSW207 CSW207A
     FSDJACCL5  IF   E           K DISK    INFSR(*PSSR)                                      CSW207A
                                                                                              CSW207
     FSDJACCL7  IF   E           K DISK    INFSR(*PSSR)                                       CSW207
     F                                     RENAME(SDJACCD0:SDJACCF)                           CSW207

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
      *                                                                                       CFT142
      ** Array of Fields for Payment Subtype                                                  CFT142
     D PayST           S              2A   DIM(60)                                            CFT142
     D @IPDST0         C                   'OutgoingPaySubType'                               CFT142

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
      *                                                                                       240689
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     240689
      *                                                                                       240689
      ** Array of fields with Warning.                                                        240689
      *                                                                                       240689
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        240689
      *                                                                                       240689
      ** Array of Warning message IDs                                                         240689
      *                                                                                       240689
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)                      240689
      *                                                                                       240689
      ** Array of Warning message data.                                                       240689
      *                                                                                       240689

      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)                                 CFT032

      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)

      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)

      ** Address line Swift character check array
     D TST             S              1A   DIM(35)

      ** Array of valid swift characters
     D*SWCH*****       S              1    DIM(47) CTDATA PERRCD(47)                          255286
     D SWCH            S              1    DIM(73) CTDATA PERRCD(73)                          255286

      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      * External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      * External DS for Midas SD Retail Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)

      ** External data structure for Nostro customer number
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029

      ** External data structure for Nostro customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Midas ME Outgoing Message management                                                 CFT032
                                                                                              CFT032
     D MEOUFM        E DS                  EXTNAME(MEOUFMPD)                                  CFT032
                                                                                              CFT032
      ** Midas Counterparty Nostros                                                           CFT032
                                                                                              CFT032
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                                  CFT032
                                                                                              CFT032
      ** Midas BIC Directory                                                                  CFT032
                                                                                              CFT032
     D MEBICD        E DS                  EXTNAME(MEBICDPD)                                  CFT032
                                                                                              CFT032
      ** Midas FT general address data structure                                              CFT032
                                                                                              CFT032
      ** External data structure for Account                                                  CFT032
                                                                                              CFT032
     D SDACCNT       E DS                  EXTNAME(ACCNTAB)                                   CFT032
     D   IFBRCA      E                     EXTFLD(BRCA)                                       CFT032
     D   IFCNUM      E                     EXTFLD(CNUM)                                       CFT032
     D   IFCCY       E                     EXTFLD(CCY)                                        CFT032
     D   IFACOD      E                     EXTFLD(ACOD)                                       CFT032
     D   IFACSQ      E                     EXTFLD(ACSQ)                                       CFT032
     D   IFIBAN      E                     EXTFLD(IBAN)                                       CFT032
     D   IFIBSEQN    E                     EXTFLD(IBSEQN)                                     CFT032
     D   IFRECI      E                     EXTFLD(RECI)                                       CFT032
     D   IFATYP      E                     EXTFLD(ATYP)                                       CFT032
                                                                                              CFT032
      ** External data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)                                    250804A

     D DSFDY         E DS                  EXTNAME(DSFDY)

      * External DS for Funds Transfer details                                                257361
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                                  257361
                                                                                              257361
     D**********       DS            18                                                       CGL029
     D                 DS                                                                     CGL029
     D*K#CNUM***               1      6  0                                                    CSD027
     D K#CNUM                  1      6A                                                      CSD027
     D K#CCY                   7      9
     D K#ACOD                 10     19  0                                                    CGL029
     D K#ACSQ                 20     21  0                                                    CGL029
     D K#BRCA                 22     24                                                       CGL029
     D AKEYF                   1     24                                                       CGL029
     D*K#ACOD***              10     13  0                                                    CGL029
     D*K#ACSQ***              14     15  0                                                    CGL029
     D*K#BRCA***              16     18                                                       CGL029
     D*AKEYF****               1     18                                                       CGL029

     D*ORDCST***       DS           140                                                       CFT032
     D ORDCST          DS           175                                                       CFT032
     D  #SORC1                 1     35
     D  #SORC2                36     70
     D  #SORC3                71    105
     D  #SORC4               106    140
     D  #SORC5               141    175                                                       CFT032

     D  IBAN1                  1     34                                                       CFT032
     D  IBAN2                  2     35                                                       CFT032
                                                                                              CFT032
     D*O06R*****               7    140                                                       CFT032
     D O06R                    7    175                                                       CFT032
     D*O10R*****              11    140                                                       CFT032
     D O10R                   11    175                                                       CFT032
     D*O12R*****              19    140                                                CGL029 CFT032
     D O12R                   19    175                                                       CFT032
     D*O15R*****              22    140                                                CGL029 CFT032
     D O15R                   22    175                                                       CFT032
     D*O12R*****              13    140                                                       CGL029
     D*O15R*****              16    140                                                       CGL029

     D ONUM                    1      6
     D ORET                    1     10
     D OCUS                    1     10
     D OCOD                    7     16                                                       CGL029
     D OSEQ                   17     18                                                       CGL029
     D OBRC                   19     21                                                       CGL029
     D OBRCA                  22     24                                                       250600
     D OSEQA                  18     19                                                       250600
     D*OCOD*****               7     10                                                       CGL029
     D*OSEQ*****              11     12                                                       CGL029
     D*OBRC*****              13     15                                                       CGL029

     D O06RS                   8    175                                                       CFT032
     D O10RS                  12    175                                                       CFT032
     D O12RS                  20    175                                                       CFT032
     D O15RS                  23    175                                                       CFT032
     D ONUMS                   2      7                                                       CFT032
     D ORETS                   2     11                                                       CFT032
     D OCUSS                   2     11                                                       CFT032
     D OCODS                   8     17                                                       CFT032
     D OSEQS                  18     19                                                       CFT032
     D OBRCS                  20     22                                                       CFT032
                                                                                              CFT032
      * Data structure redefining address fields
     DADDRSS           DS           175
     D ADCHK1                  1     35
     D ADCHK2                 36     70
     D ADCHK3                 71    105
     D ADCHK4                106    140
     D ADCHK5                141    175

      ** SWIFT Address Analysis data structure                                                CFT032
     D  ADSLSH                 1      1                                                       CFT032
                                                                                              CFT032
      ** Nostro Account Analysis data structure                                               CFT032
     D  ADFNNB                 4      5                                                       CFT032
                                                                                              CFT032
      ** Account Analysis data structure FULL Account                                         CFT032
     D  ADGCNM                 1      6                                                       CFT032
     D  ADGACD                10     13                                                       CFT032
     D  ADGASQ                14     15                                                       CFT032
                                                                                              CFT032
      ** Nostro Number Account Analysis data structure                                        CFT032
     D  ADNOSN                 1      2                                                       CFT032
                                                                                              CFT032
      ** Partial Account Analysis data structure                                              CFT032
     D  ADPCNM                 1      6                                                       CFT032
     D  ADPACD                 7     10                                                       CFT032
     D  ADPASQ                11     12                                                       CFT032
     D  ADPBRC                13     15                                                       CFT032
                                                                                              CFT032
      *  Define full account to be passed for FT IMM update
     D*#ORCDS***       DS            18                                                       CGL029
     D #ORCDS          DS                                                                     CGL029
     D*IMCNUM***               1      6  0                                                    CSD027
     D IMCNUM                  1      6A                                                      CSD027
     D IMCYY                   7      9
     D IMACOD                 10     19  0                                                    CGL029
     D IMACSQ                 20     21  0                                                    CGL029
     D IMBRCA                 22     24                                                       CGL029
     D*IMACOD***              10     13  0                                                    CGL029
     D*IMACSQ***              14     15  0                                                    CGL029
     D*IMBRCA***              16     18                                                       CGL029
      *
     D PfAccnt         DS            24                                                       250600
     D  PfBRCA                 1      3                                                       250600
     D  PfCNUM                 4      9                                                       250600
     D  PfCYY                 10     12                                                       250600
     D  PfACOD                13     22  0                                                    250600
     D  PfACSQ                23     24  0                                                    250600
      *                                                                                       250600
                                                                                              257361
      ** Data structure for input parameter                                                   257361
     D P@IN            DS           256                                                       257361
     D  I@SNBR                 1      3                                                       257361
     D  I@DSCN                 4      9                                                       257361
     D  I@MTPY                10     12                                                       257361
     D  I@SETT                13     14  0                                                    257361
     D  I@CONC                15     15                                                       257361
     D  I@FTCS                16     16                                                       257361
     D  I@MMOD                17     18                                                       257361
                                                                                              257361
      ** Data structure for output parameter                                                  257361
     D P@OUT           DS                                                                     257361
     D  O@CNSN                 1      6  0                                                    257361
     D  O@SWSN                 7     18                                                       257361
     D  O@NWSN                19     38                                                       257361
     D  O@SWDS                39     49                                                       257361
     D  W@96CN                46     46                                                       257361
     D  W@BIC                 47     49                                                       257361
     D  O@NWDS                50     69                                                       257361
     D  O@NWRK                70     75                                                       257361
     D  O@MGSG                76     76                                                       257361
     D  O@MGST                77     80                                                       257361
     D  O@PAIN                81     81                                                       257361
     D  O@PCNB                82     87                                                       257361
     D  O@SPRS                88     90                                                       257361
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** Midas general constant fields                                                        CFT032
                                                                                              CFT032
      /COPY FTCPYSRC,SFTVALCSLE                                                               CFT032
                                                                                              CFT032
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D/COPY OFCPYSRCZ,CFT148_025                                                              CFT148
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *                                                                                       240689
     D WIx             S              3P 0                                                    240689
      *                                                                                       240689
      ** Index for arrays of warning message ids etc                                          240689
      *                                                                                       240689

     D C#KEY1          S             10
     D C#KYST          S              7
     D C#OPTN          S              7
     D C#RTCD          S              7
     D PfCBEI          S             11                                                      250804A
     D PfCSID          S             12                                                      250804A

     D WFLD            S                   LIKE(ADCHK1)
     D WNUMA           S              6
     D*WNUML****       S              7P 0                                                    CSD027
     D WNUML           S              7A                                                      CSD027
     D WRETA           S             10
     D WRETL           S             11P 0
     D R               S              2  0
     D CODL            S             11P 0                                                    CGL029
     D CODA            S             10A                                                      CGL029

     D WSorc1          S             35A                                                      CFT032
     D*P@WTBL***       S             35A                                             CFT032 BUG14538
     D P@WTBL          S             47A                                                    BUG14538
     D*P@NOBL***       S             35A                                             CFT032 BUG14538
     D P@NOBL          S             34A                                                    BUG14538
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
     D P@IBAN3         S             47A                                                    BUG14538
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
     D P@CTRY          S              2A                                                    BUG12692
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
     D***WCountry        S              3A                                           CFT032 BUG12692
     D WCountry        S              2A                                                    BUG12692
     D WEntryType      S              1A                                                      CFT032
     D WNetwork        S             10A                                                      CFT032
     D WNostro         S              2A                                                      CFT032
     D WCust           S             10A                                                      CSW207
     D WSbrca          S              3A                                                    BUG14771
     D WNonAcct        S             10A                                                      CSW207
     D WCustomerA      S              6A                                                      CSW207
     D CSW207          S              1A                                                      CSW207
                                                                                              CFT032
     D FeatureCSW024   S               N                                                      CFT032
     D FeatureCFT004   S               N                                                      CFT032
                                                                                              CFT032
      ** SWIFT subroutine parameters/variables                                                CFT032
                                                                                              CFT032
     D CLSWTK          S             34A                                                      CFT032
     D ##CSID          S              1A                                                      CFT032
     D WCNUM           S              6A                                                      CSW207
     D WACOD           S             10A                                                      CSW207
     D WACSQ           S              2A                                                      CSW207

     D WNUMX           S              7P 0                                                  BUG26002
     D X#CNUM          S              6  0                                                  BUG26002
                                                                                            BUG26002
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
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
     C                   Eval      WFldNmXAr = *Blanks                                        240689
     C                   Eval      WMsgIDXAr  = *Blanks                                       240689
     C                   Eval      WMsgDtaXAr = *Blanks                                       240689
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0                                                    240689

      * Order Customer
      *
     C                   Exsr      VORDCUS

      ** If an error was found, set the return code appropriately
      *
     C                   If        OKOrc1 = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        OKOrc1 = 'W'                                               CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   End                                                                  CSD089
     C                   End

      * RETURN
      *
     C                   RETURN
      ******************************************************************
      /EJECT
     C******************************************************************
     C* VORDCUS - VALIDATION OF ORDERING CUSTOMER                      *
      ******************************************************************
     C*
     C     VORDCUS       BEGSR

      * Set up ORDCST data structure
     C                   Eval      #SORC1 = SORC1
     C                   Eval      #SORC2 = SORC2
     C                   Eval      #SORC3 = SORC3
     C                   Eval      #SORC4 = SORC4
     C                   Eval      #SORC5 = SORC5                                             CFT032
     C                   Eval      WSbrca = SBRCA                                           BUG14771

     C** Check for entry of '?'

     C                   Eval      *IN90 = *Off
     C     '?'           Scan      #SORC1                                 90
     C** If '?' found....
     C                   If        *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKOrc1
     C                   Add       1             Idx
     C                   Movel     'SORC1'       FldNamXAr(Idx)
     C                   Movel     'MMA0933'     MsgIdXAr(Idx)
     C                   End

     C**********         If        OKOrc1 = 'Y'                                             MD039547
     C                   If        OKOrc1 <> 'N'                                            MD039547

     C                   Eval      @ORCT = *Blank
     C                   Eval      @ACST3 = *Blank
     C                   Eval      @OCOPN = 0

      * Ordering Customer is mandatory

     C                   If        ORDCST = *Blanks
      * Send error to screen
     C                   Move      'N'           OKOrc1
     C                   Add       1             Idx
     C                   Movel     'SORC1'       FldNamXAr(Idx)
     C                   Movel     'MMA0934'     MsgIdXAr(Idx)
     C                   End

     C                   BITOFF    '01234567'    WRETB             1                          240689
     C**********         If        OKOrc1 = 'Y'                                             MD039547
     C                   If        OKOrc1 <> 'N'                                            MD039547

     C                   If        %SUBST(#SORC1:1:1) = '/'                                   CFT032
                                                                                              CFT032
      ** The following tests are performed only if the first                                  CFT032
      ** character is a '/'                                                                   CFT032
                                                                                              CFT032
      ** Check if CFT014 is installed                                                         CFT032
                                                                                              CFT032
     C                   If        @CFT014 = 'N'                                              CFT032
     C                   Eval      OKOrc1 = 'N'                                               CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SORC1'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1409'                                  CFT032
     C                   LeaveSr                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Check if a '?' is entered on the second line                                         CFT032
                                                                                              CFT032
     C                   If        %Scan('?' : #SORC2) <> 0                                   CFT032
     C                   Eval      OKOrc1 = 'N'                                               CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SORC2'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA0933'                                  CFT032
     C                   LeaveSr                                                              CFT032
     C                   EndIf                                                                CFT032
      *                                                                                     BUG24679
     C                   IF        O06RS = *Blanks                                          BUG24679
     C                             and %SUBST(#SORC1:2:6) <> *blanks                        BUG24679
     C                   Eval      OKOrc1 = 'N'                                             BUG24679
     C                   Eval      Idx = Idx + 1                                            BUG24679
     C                   Eval      FldNamXAr(Idx) = 'SORC2'                                 BUG24679
     C                   Eval      MsgIdXAr(Idx) = 'FTM2152'                                BUG24679
     C                   LeaveSr                                                            BUG24679
     C                   ENDIF                                                              BUG24679
                                                                                              CFT032
      ** Settlement type should be 08 or 01                                                   CFT032
                                                                                              CFT032
     C                   If        CFT142 = 'N'                                               CFT142
     C                   If        SSTTP <> '08' And                                          CFT032
     C                             SSTTP <> '01'                                              CFT032
     C                   Eval      OKOrc1 = 'N'                                               CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SORC1'                                   CFT032
     C**********         Eval      MsgIdXAr(Idx) = 'MMAnn11'                         CFT032 BUG14042
     C                   Eval      MsgIdXAr(Idx) = 'MMA1411'                                BUG14042
     C                   LeaveSr                                                              CFT032
     C                   EndIf                                                                CFT032
     C                   Else                                                                 CFT142
     C                   Movea     P@VL01        PayST                                        CFT142
     C     SPYST         Lookup    PayST                                  50                  CFT142
     C                   If        SSTTP <> '08' And                                          CFT142
     C                             SSTTP <> '01' And                                          CFT142
     C                             SSTTP <> '02' And                                          CFT142
     C                             SSTTP <> '12' And                                          CFT142
     C                             SSTTP <> '13' And                                          CFT142
     C                             *in50 =  *ON                                               CFT142
     C                   Eval      OKOrc1 = 'N'                                               CFT142
     C                   Eval      Idx = Idx + 1                                              CFT142
     C                   Eval      FldNamXAr(Idx) = 'SORC1'                                   CFT142
     C                   Eval      MsgIdXAr(Idx) = '5047549'                                  CFT142
     C                   LeaveSr                                                              CFT142
     C                   Endif                                                                CFT142
                                                                                              CFT142
     C                   EndIf                                                                CFT142
                                                                                              CFT032
      ** Feature CFT004 is installed and SORBK <> Blanks                                      CFT032
                                                                                              CFT032
     C**********         If        @CFT004 = 'Y' And                                 CFT032 BUG14771
     C**********                   SORBK <> *Blanks                                  CFT032 BUG14771
                                                                                              CFT032
     C**********         Eval      WSorc1 = %Subst(Sorc1:2)                          CFT032 BUG14771
     C**********         Call      'AOIBANR3'                                        CFT032 BUG14771
     C**********         Parm      *Blanks       @RtCd                               CFT032 BUG14771
     C**********         Parm      WSorc1        P@IBAN                              CFT032 BUG14538
     C**********         Parm      WSorc1        P@IBAN3                           BUG14538 BUG14771
     C**********         Parm                    P@WTBL                              CFT032 BUG14771
     C**********         Parm                    P@NOBL                              CFT032 BUG14771
                                                                                              CFT032
     C**********         Eval      WSorc1 = P@NOBL                                   CFT032 BUG14771
                                                                                              CFT032
      ** Check for IBAN: 1st 2 characters are alphabetic and                                  CFT032
      **                 next 2 characters are numeric                                        CFT032
                                                                                              CFT032
     C**********         If        %Check( %Subst( WSorc1 : 1 : 2 ) :                CFT032 BUG14538
     C**********                           ALPHAB) = 0  AND                          CFT032 BUG14538
     C**********                   %Check( %Subst( WSorc1 : 3 : 2 ) :                CFT032 BUG14538
     C**********                           DIGITS) = 0                               CFT032 BUG14538
     C**********         Eval      PAcctyp = *Blanks                                CSW207A BUG14771
     C**********         If        %Check( %Subst( WSorc1 : 1 : 2 ) :              BUG14538 BUG14771
     C**********                           ALPHAB) <> 0 AND                        BUG14538 BUG14771
     C**********                   %Check( %Subst( WSorc1 : 3 : 2 ) :              BUG14538 BUG14771
     C**********                           DIGITS) <> 0                            BUG14538 BUG14771
     C**********         Eval      PAcctyp = 'I'                                    CSW207A BUG14771
     C**********         Call      'AOIBANR5'                                        CFT032 BUG14771
     C**********         Parm      *Blanks       @RtCd                               CFT032 BUG14771
     C**********         Parm      WSorc1        P@IBAN                              CFT032 BUG14771
                                                                                              CFT032
     C**********         If        @RtCd <> *Blanks                                  CFT032 BUG14771
     C**********         Eval      MsgDtaXAr(Idx) = 'Ordering Customer'              CFT032 BUG14538
     C**********         Eval      WIx = WIx + 1                                   BUG14538 BUG14771
     C**********         Eval      OKOrc1 = 'Y'                                      CFT032 BUG14771
     C**********         Eval      Idx = Idx + 1                                     CFT032 BUG14538
     C**********         Eval      FldNamXAr(Idx) = 'SORC1'                          CFT032 BUG14538
     C**********         Eval      WMsgDtaXAr(WIx) = 'Ordering Customer'           BUG14538 BUG14771
     C**********         Eval      WFldNmXAr(WIx) = 'SORC1'                        BUG14538 BUG14771
                                                                                              CFT032
     C**********         Select                                                      CFT032 BUG14771
     C**********         When      %Trim(@RtCd) = '1'                                CFT032 BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2400'                         CFT032 BUG14538
     C**********         Eval      WMsgIdXAr(WIx) = 'FTM2400'                      BUG14538 BUG14771
     C**********         When      %Trim(@RtCd) = '2'                                CFT032 BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2401'                         CFT032 BUG14538
     C**********         Eval      WMsgIdXAr(WIx) = 'FTM2401'                      BUG14538 BUG14771
     C**********         When      %Trim(@RtCd) = '3'                                CFT032 BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2402'                         CFT032 BUG14538
     C**********         Eval      WMsgIdXAr(WIx) = 'FTM2402'                      BUG14538 BUG14771
     C**********         When      %Trim(@RtCd) = '4'                                CFT032 BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2403'                         CFT032 BUG14538
     C**********         Eval      WMsgIdXAr(WIx) = 'FTM2403'                      BUG14538 BUG14771
     C**********         When      %Trim(@RtCd) = '5'                                CFT032 BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2404'                         CFT032 BUG14538
     C**********         Eval      WMsgIdXAr(WIx) = 'FTM2404'                      BUG14538 BUG14771
     C**********         Other                                                              BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2405'                         CFT032 BUG14538
     C**********         Eval      MsgIdXAr(WIx) = 'FTM2405'                       BUG14538 BUG14771
     C**********         EndSl                                                       CFT032 BUG14771
                                                                                              CFT032
     C**********         Eval      @@IBAN = 'N'                                      CFT032 BUG14771
                                                                                              CFT032
     C**********         Else                                                        CFT032 BUG14771
                                                                                              CFT032
     C**********         Eval      @@IBAN = 'Y'                                      CFT032 BUG14771
     C**********         Eval      PAcctyp = 'I'                                    CSW207A BUG14771
                                                                                              CFT032
     C**********         EndIf                                                       CFT032 BUG14771
                                                                                              CFT032
     C**********         EndIf                                                       CFT032 BUG14771
                                                                                              CFT032
     C**********         EndIf                                                       CFT032 BUG14771
                                                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   Select
     C                   When      %SUBST(#SORC1:1:1) = '/' And                              250804A
     C                             %Subst(ORDCST:12:164) = *blanks or                        250804A
     C                             %SUBST(#SORC1:1:1) <> '/' And                             250804A
     C                             %Subst(ORDCST:11:165) = *blanks or                        250804A
     C                             %SUBST(#SORC1:1:1) = '/' And                              250804A
     C                             %Subst(ORDCST:45:130) = *blanks  And                      250804A
     C                             %Subst(ORDCST:36:10) <> *Blanks                           250804A
     C                   Exsr      VALRET                                                    250804A
      *                                                                                      250804A
B4   C**********         If        OKOrc1 = 'Y' and                                  50804A MD039547
     C                   If        OKOrc1 <> 'N' and                                        MD039547
     C                             @ORCT = *Blanks                                           250804A
     C                   Exsr      VALACC                                                    250804A
E4   C                   End                                                                 250804A
      *                                                                                      250804A
     C* If more than 10 char have been entered cannot be a retail number
     C                   When      O10RS <> *Blanks and                                      250804A
     C                             %SUBST(#SORC1:1:1) = '/' or                               250804A
     C                             O10R <> *Blanks and                                       250804A
     C                             %SUBST(#SORC1:1:1) <> '/'                                 250804A
     C**********         When      O10R <> *Blanks                                            CFT032
     C**********         When      %SUBST(#SORC1:1:1) = '/' And                       CFT032 250804A
     C**********                   #SORC2 = *Blanks   And                             250600 250804A
     C**********                   O10RS <> *Blanks  Or                               CFT032 250804A
     C**********                   %SUBST(#SORC1:1:1) <> '/' And                      CFT032 250804A
     C**********                   #SORC2 = *Blanks   And                             250600 250804A
     C**********                   O10R <> *Blanks                                    CFT032 250804A
     C**********                   Or (CSW207 = 'Y'                                    CSW207 250600
     C**********                   And #SORC1 <> *Blanks)                              CSW207 250600
     C                   Exsr      VALACC

     C**********         If        #SORC1 <> 'MT202' And                              CFT032 250804A
     C**********                   #SORC2 <> *Blanks And                              CFT032 250804A
     C**********                   #SORC3 <> *Blanks And                              CFT032 250804A
     C**********                   #SORC4 <> *Blanks And                              CFT032 250804A
     C**********                   #SORC5 <> *Blanks Or                               CFT032 250804A
     C**********                   SODMT = *Blanks                                    CFT032 250804A
     C**********                   Or (CSW207 = 'Y'                                   CSW207A 250600
     C**********                   And SODMT <> *Blanks)                              CSW207A 250600
     C**********         Exsr      SROUFM                                            CFT032 BUG14771
     C**********         EndIf                                                        CFT032 250804A
                                                                                              CFT032
     C* If not full address, validate for A/C
     C**********         When      #SORC2 = *Blanks and                                      250804A
     C**********                   #SORC3 = *Blanks and                                      250804A
     C**********                   #SORC4 = *Blanks                                         BUG14771
     C**********                   #SORC4 = *Blanks and #SORC5 = *Blanks            BUG14771 250804A
     C**********         Exsr      VALRET                                                    250804A
      **********                                                                             250804A
     C**********         If        OKOrc1 = 'Y' and                                          250804A
     C**********                   @ORCT = *Blanks                                           250804A
     C**********         Exsr      VALACC                                                    250804A
     C**********         End                                                                 250804A
     C* If not full address, validate for A/C                                               BUG14771
     C**********         When      (%SUBST(#SORC1:1:1) = '/'  and                   BUG14771 250804A
     C**********                   #SORC2 <> *Blanks and                            BUG14771 250804A
     C**********                   #SORC3 =  *Blanks and                              250600 250804A
     C**********                   #SORC4 =  *Blanks and                              250600 250804A
     C**********                   #SORC5 =  *Blanks )                                250600 250804A
     C**********                   #SORC3 =  *Blanks )                               BUG14771 250600
     C**********         Exsr      VALRET                                           BUG14771 250804A
      **********                                                                    BUG14771 250804A
B4   C**********         If        OKOrc1 = 'Y' and                                 BUG14771 250804A
     C**********                   @ORCT = *Blanks                                  BUG14771 250804A
     C**********         Exsr      VALACC                                           BUG14771 250804A
E4   C**********         End                                                        BUG14771 250804A
      **********                                                                    BUG14771 250804A
     C**********         When      (%SUBST(#SORC1:1:1) <> '/'  and                  BUG14771 250804A
     C**********                   #SORC1 <> *Blanks and                            BUG14771 250804A
     C**********                   #SORC2 <> *Blanks and                              250600 250804A
     C**********                   #SORC3 =  *Blanks and                              250600 250804A
     C**********                   #SORC4 =  *Blanks and                              250600 250804A
     C**********                   #SORC5 =  *Blanks )                                250600 250804A
     C**********                   #SORC2 <> *Blanks )                               BUG14771 250600
     C**********         Exsr      VALRET                                           BUG14771 250804A
      **********                                                                    BUG14771 250804A
B4   C**********         If        OKOrc1 = 'Y' and                                 BUG14771 250804A
     C**********                   @ORCT = *Blanks                                  BUG14771 250804A
     C**********         Exsr      VALACC                                           BUG14771 250804A
E4   C**********         End                                                        BUG14771 250804A

     C                   End
     C                   End
     C                   End
      * Set Screen fields
     C                   Eval      SORC1 = #SORC1
     C                   Eval      SORC2 = #SORC2
     C                   Eval      SORC3 = #SORC3
     C                   Eval      SORC4 = #SORC4
     C                   Eval      SORC5 = #SORC5                                           BUG14771
      *                                                                                       240689
      ** Check Status of Account                                                              240689
      *                                                                                       240689
     C*****OKOrc1        IFEQ      'Y'                                               240689 MD039547
     C     OKOrc1        IFNE      'N'                                                      MD039547
      *                                                                                       240689
      ** Blocked Debit                                                                        240689
      *                                                                                       240689
     C                   TESTB     '2'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKOrc1                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SORC1'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0014'     MsgIdXAr(Idx)                         240689 CSD089
      *                                                                                     MD055570
     C                   IF         PSJobName = 'QZDASOINIT' OR                             MD055570
     C                              PSJobName = 'QSQSRVR' OR                                MD055570
     C                              PSJobName = 'APISERVER'                                 MD055570
      *                                                                                     MD055570
     C                   MOVE      'W'           OKOrc1                                       CSD089
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SORC1'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0014'     WMsgIdXAr(WIx)                               CSD089
     C                   ELSE                                                               MD055570
      *                                                                                     MD055570
     C                   MOVE      'N'           OKOrc1                                     MD055570
     C                   ADD       1             Idx                                        MD055570
     C                   MOVEL     'SORC1'       FldNamXAr(Idx)                             MD055570
     C                   MOVEL     'FTM0014'     MsgIdXAr(Idx)                              MD055570
     C                   ENDIF                                                              MD055570
      *                                                                                     MD055570
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bankrupt/Liquidated                                                                  240689
      *                                                                                       240689
     C                   TESTB     '6'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKOrc1                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SORC1'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0015'     MsgIdXAr(Idx)                         240689 CSD089
     C                   MOVE      'W'           OKOrc1                                       CSD089
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SORC1'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0015'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bad Debt                                                                             240689
      *                                                                                       240689
     C                   TESTB     '7'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKOrc1                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SORC1'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0016'     MsgIdXAr(Idx)                         240689 CSD089
     C                   MOVE      'W'           OKOrc1                                       CSD089
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SORC1'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0016'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Inactive                                                                             240689
      *                                                                                       240689
     C                   TESTB     '4'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKOrc1                                       240689
     C     OKOrc1        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKOrc1                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'SORC1'       WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0017'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Referred Debit                                                                       240689
      *                                                                                       240689
     C                   TESTB     '0'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKOrc1                                       240689
     C     OKOrc1        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKOrc1                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'SORC1'       WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0018'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
     C                   ENDIF                                                                240689

      * If a valid account has been entered,
      * store full account details for FT Transaction Status File
      * record update.
     C**********         If        OKOrc1 = 'Y'                                             BUG24828
     C                   If        OKOrc1 <> 'N'                                            BUG24828
                                                                                            BUG14771
     C                   If        SOdmt = *Blanks                                          BUG14771
     C                   If        @ORCT = 'R' or                                             250600
     C                             @ORCT = 'P' Or                                             250600
     C                             @ORCT = 'I'                                                250600
     C                   Eval      PfCNUM = K#CNUM                                            250600
     C**********         Eval      PfCYY = @CCY                                      250600 BUG24666
     C                   Eval      PfCYY = K#CCY                                            BUG24666
     C                   Eval      PfACOD = K#ACOD                                            250600
     C                   Eval      PfACSQ = K#ACSQ                                            250600
     C                   Eval      PfBRCA = K#BRCA                                            250600
     C                   Else                                                                 250600
     C                   Eval      PfAccnt = *Blanks                                          250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   Eval      PfCBEI = *Blanks                                          250804A
     C                   Eval      PfCSID = *Blanks                                          250804A
     C                   Eval      PCust  = *Blanks                                         BUG15045
     C                   If        K#CNUM <> *Blanks                                          250600
     C                   Movel     K#CNUM        PCust                                        250600
     C                   Movel(P)  K#CNUM        C#Key1                                      250804A
     C                   CALL      'AOCUSTR1'                                                250804A
     C                   PARM      '*BLANKS'     @RtCd                                       250804A
     C                   PARM      '*KEY   '     @Optn                                       250804A
     C                   PARM                    C#Key1                                      250804A
     C                   PARM      *BLANKS       C#Kyst                                      250804A
     C     SDCUST        PARM      SDCUST        DSLDY                                       250804A
     C                   Eval      PfCBEI = BBCBEI                                           250804A
     C                   Eval      PfCSID = BBCBEI                                           250804A
      *                                                                                      250804A
     C                   Else                                                                 250600
     C                   Eval      PCust =  *Blanks                                           250600
     C                   EndIf                                                                250600
      *                                                                                       250600
     C                   Exsr      SROUFM                                                   BUG14771
     C                   Endif                                                              BUG14771
      *                                                                                       250600
      ** Save Customer number to be passed to other modules. Do  again from K#CNUM to ensure  250600
      ** No correpted                                                                         250600
     C                   If        K#CNUM <> *Blanks                                          250600
     C                   Movel     K#CNUM        @ORDCS                                       250600
     C                   Else                                                                 250600
     C                   Eval      @ORDCS = *Blanks                                           250600
     C                   Endif                                                                250600
      *                                                                                       250600
      * Set up @ORCDS
     C                   If        @ORCT = 'R' or
     C**********                   @ORCT = 'P'                                                CFT032
     C                             @ORCT = 'P' Or                                             CFT032
     C                             @ORCT = 'I'                                                CFT032
     C                   Eval      IMCNUM = K#CNUM
     C                   Eval      IMCYY = @CCY
     C                   Eval      IMACOD = K#ACOD
     C                   Eval      IMACSQ = K#ACSQ
     C                   Eval      IMBRCA = K#BRCA
     C                   Eval      @ORCDS = #ORCDS
     C                   END
     C                   END
      *
     C                   ENDSR
     C*
     C************************************************************
     C* END OF ORDERING CUSTOMER VALIDATION
     C************************************************************
     C/EJECT
     C******************************************************************
     C* VALACC  - VALIDATION OF ACCOUNT NUMBER                         *
      ******************************************************************
     C*
     C     VALACC        BEGSR

     C                   If        @CFT004 = 'Y'                                              CFT032
     C                   If        %SUBST(ORDCST:1:1) = '/'                                   CFT032
     C                   Call      'AOIBANR2'                                                 CFT032
     C                   Parm      *Blanks       @RTCd                                        CFT032
     C                   Parm      IBAN2         P@Iban                                       CFT032
     C*****SDACCNT       Parm      SDACCNT       P@Iban                              CFT032 BUG14538
     C     SDACCNT       Parm      SDACCNT       DSSDY                                      BUG14538
     C                   Else                                                                 CFT032
     C                   Call      'AOIBANR2'                                                 CFT032
     C                   Parm      *Blanks       @RTCd                                        CFT032
     C                   Parm      IBAN1         P@Iban                                       CFT032
     C*****SDACCNT       Parm      SDACCNT       P@Iban                              CFT032 BUG14538
     C     SDACCNT       Parm      SDACCNT       DSSDY                                      BUG14538
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Check if account is an IBAN                                                          CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C**********         Eval      @@IBAN = 'Y'                                      CFT032 BUG15059
     C                   Eval      K#CNUM = IFCNUM                                            CFT032
     C                   Eval      K#ACOD = IFACOD                                            CFT032
     C                   Eval      K#ACSQ = IFACSQ                                            CFT032
     C                   Eval      K#BRCA = IFBRCA                                            CFT032
     C                   If        #SORC2 = *Blanks                                         BUG15059
     C                   Eval      @@IBAN = 'Y'                                             BUG15059
     C                   Eval      @ORCT = 'I'                                                CFT032
     C                   Else                                                               BUG15059
     C                   Eval      @@IBAN = 'N'                                             BUG15059
     C                   Eval      @ORCT = 'A'                                              BUG15059
     C                   Endif                                                              BUG15059
     C                   Else                                                                 CFT032
                                                                                              CFT032
      ** Not an IBAN,                                                                         CFT032
                                                                                              CFT032
     C                   Eval      @@IBAN = 'N'                                               CFT032
      *                                                                                      CSW207A
      ** Skip the following codes if CSW207 is switched ON                                   CSW207A
      *                                                                                      CSW207A
     C                   If        CSW207 = 'N'                                              CSW207A
     C                   If        %SUBST(ORDCST:1:1) = '/'                                   CFT032
     C                   Eval      K#CNUM = ONUMS                                             CFT032
     C                   If        %Len(%Trim(OCODS)) > 0                                     250600
     C                   MOVEL     OCODS         K#ACOD                                     BUG12796
     C                   Endif                                                                250600
     C                   If        %Len(%Trim(OSEQS)) > 0                                     250600
     C                   MOVEL     OSEQS         K#ACSQ                                     BUG12796
     C                   Endif                                                                250600
     C**********         If        %Len(%Trim(OCODS)) > 0                            CFT032 BUG12796
     C**********         Eval      K#ACOD = %INT(OCODS)                              CFT032 BUG12796
     C**********         Endif                                                       CFT032 BUG12796
     C**********         If        %Len(%Trim(OSEQS)) > 0                            CFT032 BUG12796
     C**********         Eval      K#ACSQ = %INT(OSEQS)                              CFT032 BUG12796
     C**********         Endif                                                       CFT032 BUG12796
     C                   Else                                                                 CFT032
     C                   Eval      K#CNUM = ONUM                                              CFT032
     C                   If        %Len(%Trim(OCODS)) > 0                                   BUG14771
     C                   MOVEL     OCOD          K#ACOD                                     BUG12796
     C                   Endif                                                              BUG14771
     C                   If        %Len(%Trim(OSEQS)) > 0                                   BUG14771
     C                   MOVEL     OSEQ          K#ACSQ                                     BUG12796
     C                   EndIf                                                              BUG14771
     C**********         If        %Len(%Trim(OCODS)) > 0                            CFT032 BUG12796
     C**********         Eval      K#ACOD = %INT(OCODS)                              CFT032 BUG12796
     C**********         Endif                                                       CFT032 BUG12796
     C**********         If        %Len(%Trim(OSEQS)) > 0                            CFT032 BUG12796
     C**********         Eval      K#ACSQ = %INT(OSEQS)                              CFT032 BUG12796
     C**********         Endif                                                       CFT032 BUG12796
     C                   EndIf                                                                CFT032
                                                                                             CSW207A
     C                   EndIf                                                               CSW207A
                                                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      * If 15 char have been entered and multi branched , or
      * 12 characters and single branch , must be a partial account.

     C**********         IF        OKOrc1 = 'Y' AND                                AR863288 MD039547
     C                   IF        OKOrc1 <> 'N' and                                        MD039547
     C                             @ORCT = *BLANKS                                          AR863288
                                                                                            AR863288
     C                   If        @MBIN = 'Y'    and
     C**********                   O15R = *Blanks or                                        BUG15088
     C                             O15R = *Blanks and                                       BUG15088
     C                             %SUBST(ORDCST:1:1) <> '/'  or                            BUG15088
     C                             @MBIN = 'Y'    and                                       BUG15088
     C                             O15RS = *Blanks and                                      BUG15088
     C                             %SUBST(ORDCST:1:1) = '/'  or                             BUG15088
     C                             @MBIN = 'N'    and
     C**********                   O12R = *Blanks                                           BUG15088
     C                             O12R = *Blanks and                                       BUG15088
     C                             %SUBST(ORDCST:1:1) <> '/'  or                            BUG15088
     C                             @MBIN = 'N' and                                          BUG15088
     C                             %SUBST(ORDCST:1:1) = '/'  or                             BUG15088
     C                             O12RS = *Blanks                                          BUG15088
      ** Should take care of existence of "/" or not                                        BUG14771
     C                   If        %SUBST(ORDCST:1:1) = '/'                                 BUG14771
     C**********         MOVEL     ONUMS         WNUMX                             BUG26002 AR863288
     C**********         MOVEL     WNUMX         WNUML                             BUG26002 AR863288
     C**********         Movel     ONUMS         WNUML                             BUG14771 BUG26002
     C**********         Movel     WNUML         WNUMA                             BUG14771 AR863288
     C                   MOVEL     ONUMS         WNUMA                                      AR863288
     C                   Movel     OCODS         CODL                                       BUG14771
     C                   Movel     CODL          CODA                                       BUG14771
     C                   Movel     OSEQS         SEQL              3 0                      BUG14771
     C                   Movel     SEQL          SEQA              2                        BUG14771
     C**********         Movel     ONUM          WNUML                                      BUG14771
     C                   Else                                                               BUG14771
     C**********         MOVEL     ONUM          WNUMX                             BUG26002 AR863288
     C**********         MOVEL     WNUMX         WNUML                             BUG26002 AR863288
     C**********         Movel     WNUMX         WNUMA                             BUG26175 AR863288
     C                   MOVEL     ONUM          WNUMA                                      AR863288
     C**********         Movel     ONUM          WNUML                             BUG14771 BUG26002
     C**********         Movel     ONUM          WNUML                                        CSD027
     C**********         Movel     WNUML         WNUMA                                        CSD027
     C**********         Movel     OCOD          CODL              5 0                        CGL029
     C**********         Movel     CODL          CODA              4                          CGL029
     C                   MOVEL     OCOD          CODL                                         CGL029
     C                   MOVEL     CODL          CODA                                         CGL029
     C                   Movel     OSEQ          SEQL              3 0
     C                   Movel     SEQL          SEQA              2
     C                   Endif                                                              BUG14771

     C***********        If        ONUM = WNUMA and                                           CSD027
     C***********                  OCOD = CODA and                                            CSD027
     C                   If        OCOD = CODA and                                            CSD027
     C                             ONUM = WNUMA and                                        BUG25904A
     C**********                   OSEQ = SEQA                                              BUG14771
     C                             OSEQ = SEQA or                                           BUG14771
     c                             ONUMS = WNUMA and                                        BUG14771
     C                             OCODS = CODA and                                         BUG14771
     C                             OSEQS = SEQA                                             BUG14771
      ** Should take care of existence of "/" or not                                        BUG14771
     C                   If        %SUBST(ORDCST:1:1) = '/'                                 BUG14771
     C**********         MOVE      ONUMS         X#CNUM                            BUG26002 AR863288
     C**********         MOVE      X#CNUM        K#CNUM                            BUG26002 AR863288
     C                   MOVE      ONUMS         K#CNUM                                     AR863288
     C**********         Move      ONUMS         K#CNUM                            BUG14771 BUG26002
     C                   Move      SSMCY         K#CCY                                      BUG14771
     C                   Move      SSMCY         @CCY                                       BUG14771
     C                   Move      OCODS         K#ACOD                                     BUG14771
     C                   Move      OSEQS         K#ACSQ                                     BUG14771
     C                   Else                                                               BUG14771
     C**********         MOVE      ONUM          X#CNUM                            BUG26002 AR863288
     C**********         MOVE      X#CNUM        K#CNUM                            BUG26002 AR863288
     C                   MOVE      ONUM          K#CNUM                                     AR863288
     C**********         Move      ONUM          K#CNUM                                     BUG26002
     C                   Move      SSMCY         K#CCY
     C                   Move      SSMCY         @CCY
     C                   Move      OCOD          K#ACOD
     C                   Move      OSEQ          K#ACSQ
     C                   Endif                                                              BUG14771

      ** Should take care of existence of "/" or not                                        BUG14771
     C                   If        %SUBST(ORDCST:1:1) = '/'                                 BUG14771
B3   C                   If        @MBIN = 'Y'                                              BUG14771
     C                   Eval      K#BRCA = OBRCS                                           BUG14771
     C                   Else                                                               BUG14771
     C                   Eval      K#BRCA = BJSBRC                                          BUG14771
E3   C                   End                                                                BUG14771
     C                   Else                                                               BUG14771
     C**********         Eval      K#BRCA = BJSBRC                                BUG14771 BUG14771A
E3   C**********         End                                                      BUG14771 BUG14771A
     C**********         Else                                                     BUG14771 BUG14771A
     C                   If        @MBIN = 'Y'
     C                   Eval      K#BRCA = OBRC
     C                   Else
     C                   Eval      K#BRCA = BJSBRC
     C                   End
     C                   Endif                                                              BUG14771

      * Validate account exists
     C     AKEY          Chain     ACCNTABF                           90
      * Error if not found or RECI <> D
     C                   If        *in90 = *ON or
     C                             RECI <> 'D'
      * Send error to screen
     C                   Move      'N'           OKOrc1
     C                   Add       1             Idx
     C                   Movel     'SORC1'       FldNamXAr(Idx)
     C                   Movel     'MMA0935'     MsgIdXAr(Idx)

     C                   Else
      **Check*for*block*debits*on*account                                           BUG4581 MD044074
     C**********         TESTB     '2'           RETB                     51        BUG4581 MD044074
     C**********         If        *in51 = *ON                                      BUG4581 MD044074
     C**********         Move      'N'           OKOrc1                               BUG4581 CSD089
     C**********         Add       1             Idx                                  BUG4581 CSD089
     C**********         Movel     'SORC1'       FldNamXAr(Idx)                       BUG4581 CSD089
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                        BUG4581 CSD089
     C**********         Move      'W'           OKOrc1                              CSD089 MD044074
     C**********         Add       1             WIx                                 CSD089 MD044074
     C**********         Movel     'SORC1'       WFldNmXAr(WIx)                      CSD089 MD044074
     C**********         Movel     'FTM0014'     WMsgIdXAr(WIx)                      CSD089 MD044074
     C**********         End                                                        BUG4581 MD044074
     C     SORBK         IFEQ      *BLANKS                                                    240689
     C                   MOVE      RETB          WRETB                                        240689
     C                   ENDIF                                                                240689
     C                   Eval      @ORCT = 'P'
     C                   Eval      @ACST3 = ACST
                                                                                            BUG14771
     C                   If        IBAN <> ' '                                              BUG14771
     C                   Eval      @@IBAN = 'Y'                                             BUG14771
     C                   Else                                                               BUG14771
     C                   Eval      @@IBAN = 'N'                                             BUG14771
E2   C                   EndIf                                                              BUG14771

     C**********         If        ATYP ='R'                                                MD037223
     C                   Eval      @OCOPN = DACO
     C                   If        ATYP ='R'                                                MD037223
     C     SPRFC         IFEQ      *BLANKS                                                  AR924725
     C                   Eval      SPRFC = PRFC                                               179732
     C                   ENDIF                                                              AR924725

     C                   End

     C                   End
     C                   End
     C**********         End                                                                BUG14771
     C                   End                                                               BUG14771A
     C                   ENDIF                                                              AR863288

      *                                                                                     BUG24975
      ** Initialize invalid SWIFT characters found in ORC1 flag                             BUG24975
      *                                                                                     BUG24975
     C                   MOVEL     'N'           WINSWC            1                        BUG24975
     C* If nothing else must be an address
     C* Or a swift ID                                                                       BUG14771
     C**********         If        OKOrc1 = 'Y' and                                         MD039547
     C                   If        OKOrc1 <> 'N' and                                        MD039547
     C                             @ORCT = *Blanks

     C                   If        %SUBST(#SORC1:1:1) <> '/'                                  CFT032
     C                   Eval      CLSWTK = #SORC1                                            CFT032
     C                   Else                                                                 CFT032
     C                   Eval      CLSWTK = #SORC2                                            CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   Exsr      SWIFT                                                    BUG14771
     C                   Move      'N'           WCSID             1                        BUG14771
      *                                                                                     BUG15037
     C                   If        ##CSID = 'Y'                                             BUG15037
     C                   If        *IN31 = *On                                              BUG15037
      * Send error to screen                                                                BUG15037
     C**********         Add       1             Idx                                 BUG15037 CSD089
     C                   Add       1             WIx                                          CSD089
     C                   If        ADSLSH <> '/'                                            BUG15037
     C**********         Move      'N'           OKOrc1                              BUG15037 CSD089
     C**********         Movel     'SORC1'       FldNamXAr(Idx)                      BUG15037 CSD089
     C                   Move      'W'           OKOrc1                                       CSD089
     C                   Movel     'SORC1'       WFldNmXAr(WIx)                               CSD089
     C                   Else                                                               BUG15037
     C**********         Move      'N'           OKOrc2                              BUG15037 CSD089
     C**********         Movel     'SORC2'       FldNamXAr(Idx)                      BUG15037 CSD089
     C                   Move      'W'           OKOrc2                                       CSD089
     C                   Movel     'SORC2'       WFldNmXAr(WIx)                               CSD089
     C                   End                                                                BUG15037
     C**********         Movel     'MMA1428'     MsgIdXAr(Idx)                       BUG15037 CSD089
     C                   Movel     'MMA1428'     WMsgIdXAr(WIx)                               CSD089
      *                                                                                     BUG15037
     C                   Else                                                               BUG15037
     C**********         If        ##CSID = 'Y' And                                  CFT032 BUG15037
     C**********                   *IN31 = *Off And                                  CFT032 BUG15037
     C**********                   *IN32 = *Off                                      CFT032 BUG15037
     C                   Eval      @ORCT = 'S'                                                CFT032
     C                   Move      'Y'           WCSID             1                        BUG14771
      *                                                                                     BUG15037
     C                   If        W9Cust = 'Y'                                             BUG15037
     C                   Movel     BBCUST        K#CNUM                                     BUG15037
     C                   Endif                                                              BUG15037
      *                                                                                     BUG15037
     C**********         Else                                                        CFT032 BUG15037
     C**********         If        ##CSID = 'Y' And                                  CFT032 BUG15037
     C**********                   *IN32 = *On                                       CFT032 BUG15037
     C                   If        *IN32 = *On and                                          BUG15037
     C                             *IN31 = *Off                                             BUG15037
     C**********         Eval      Idx = Idx + 1                                     CFT032 BUG15037
     C                   Eval      WIx = WIx + 1                                            BUG15037
     C                   If        %SUBST(SORC1:1:1) <> '/'                                   CFT032
     C**********         Eval      FldNamXAr(Idx) = 'SORC1'                          CFT032 BUG15037
     C                   Eval      WFldNmXAr(WIx) = 'SORC1'                                 BUG15037
     C                   Eval      OkOrc1 = 'W'                                             BUG15037
     C                   Else                                                                 CFT032
     C**********         Eval      FldNamXAr(Idx) = 'SORC2'                          CFT032 BUG15037
     C                   Eval      WFldNmXAr(WIx) = 'SORC2'                                 BUG15037
     C                   Eval      OkOrc2 = 'W'                                             BUG15037
     C                   EndIf                                                                CFT032
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1425'                         CFT032 BUG15037
     C                   Eval      WMsgIdXAr(WIx) = 'MMA1039'                               BUG15037
     C**********         Eval      OkOdmt = 'N'                                      CFT032 BUG15037
     C                   EndIf                                                                CFT032
     C                   EndIf                                                                CFT032
     C                   EndIf                                                              BUG15037
                                                                                              CFT032
B5   C                   If        @CFT004 = 'Y' And                                        BUG14771
B4   C                             %SUBST(SORC1:1:1) =  '/'  and                            BUG14771
B2   C                             @ORCT = *Blanks                                          BUG14771
                                                                                            BUG14771
     C                   Eval      WSorc1 = %Subst(Sorc1:2)                                 BUG14771
     C                   MOVEL(P)  WSorc1        P@IBA1                                     BUG14771
     C                   Call      'AOIBANR3'                                               BUG14771
     C                   Parm      *Blanks       @RtCd                                      BUG14771
     C                   Parm                    P@IBA1           47                        BUG14771
     C                   Parm                    P@WTBL                                     BUG14771
     C                   Parm                    P@NOBL                                     BUG14771
                                                                                            BUG14771
     C                   Eval      WSorc1 = P@NOBL                                          BUG14771
                                                                                            BUG14771
      ** Check for IBAN: 1st 2 characters are alphabetic and                                BUG14771
      **                 next 2 characters are numeric                                      BUG14771
                                                                                            BUG14771
B6   C                   If        %Check( ALPHAB : %Subst( WSorc1 : 1 : 2 )                BUG14771
     C                                     ) = 0  AND                                       BUG14771
     C                             %Check( DIGITS :  %Subst( WSorc1 : 3 : 2 )               BUG14771
     C                                     ) = 0                                            BUG14771
     C                   MOVEL(P)  WSorc1        P@IBAN                                     BUG14771
     C                   Call      'AOIBANR5'                                               BUG14771
     C                   Parm      *Blanks       @RtCd                                      BUG14771
     C                   Parm                    P@IBAN                                     BUG14771
     C/COPY OFCPYSRCZ,CFT148_026                                                             259953A
                                                                                            BUG14771
B7   C**********         If        @RtCd <> *Blanks                                BUG14771 BUG25042
B7   C                   If        @RtCd <> *Blanks And                                     BUG25042
     C                             %Trim(@RtCd) <> '3'                                      BUG25042
     C**********         Eval      Idx = Idx + 1                                   BUG14771 BUG15217
     C**********         Eval      MsgDtaXAr(Idx) = 'Ordering Customer'            BUG14771 BUG15217
     C**********         Eval      OKOrc1 = 'N'                                    BUG14771 BUG15217
     C**********         Eval      FldNamXAr(Idx) = 'SORC1'                        BUG14771 BUG15217
     C                   If        %Trim(@RTCD) = '3'                                       BUG24975
     C                   Eval      Idx = Idx + 1                                            BUG24975
     C**********         Eval      MsgDtaXAr(Idx) = 'Ordering Customer'            BUG24975 MD000091
     C                   Eval      MsgDtaTmp = 'Ordering Customer'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   Eval      OKOrc1 = 'N'                                             BUG24975
     C                   Eval      FldNamXAr(Idx) = 'SORC1'                                 BUG24975
     C                   EVAL      WINSWC = 'Y'                                             BUG24975
     C                   Else                                                               BUG24975
     C                   Eval      Wix = Wix + 1                                            BUG15217
     C                   Eval      WFldNmXAr(WIx) = 'SORC1'                                 BUG15217
     C                   Eval      OkOrc1 = 'W'                                             BUG15217
     C                   Endif                                                              BUG24975
                                                                                            BUG15217
     ** Should be a Warning message as per design of CFT032                                 BUG15217
                                                                                            BUG14771
     C                   Select                                                             BUG14771
     C                   When      %Trim(@RtCd) = '1'                                       BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2400'                       BUG14771 BUG15217
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2400'                               BUG15217
     C                   When      %Trim(@RtCd) = '2'                                       BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2401'                       BUG14771 BUG15217
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2401'                               BUG15217
     C**********         When      %Trim(@RtCd) = '3'                              BUG14771 BUG25042
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2402'                       BUG14771 BUG15217
     C**********         Eval      WMsgIdXAr(WIx) = 'FTM2402'                      BUG15217 BUG25042
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2428'                         BUG24975 CSD089
     C                   Eval      WIx = WIx + 1                                              CSD089
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2428'                                 CSD089
     C                   When      %Trim(@RtCd) = '4'                                       BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2403'                       BUG14771 BUG15217
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2403'                               BUG15217
     C                   When      %Trim(@RtCd) = '5'                                       BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2404'                       BUG14771 BUG15217
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2404'                               BUG15217
     C                   Other                                                              BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'FTM2405'                       BUG14771 BUG15217
     C                   Eval      WMsgIdXAr(WIx) = 'FTM2405'                               BUG15217
     C                   EndSl                                                              BUG14771
                                                                                            BUG14771
     C                   Eval      @@IBAN = 'N'                                             BUG14771
                                                                                            BUG14771
X7   C                   Else                                                               BUG14771
                                                                                            BUG14771
     C                   Eval      @@IBAN = 'Y'                                             BUG14771
                                                                                            BUG14771
E7   C                   EndIf                                                              BUG14771
                                                                                            BUG14771
E6   C                   EndIf                                                              BUG14771
                                                                                            BUG14771
E6   C                   EndIf                                                              BUG14771
                                                                                            BUG14771
B2   C                   If        @ORCT = *Blanks                                          BUG14771
                                                                                            BUG14771
     C                   If        #SORC1 <> *Blanks or
     C                             #SORC2 <> *Blanks or
     C                             #SORC3 <> *Blanks or
     C**********                   #SORC4 <> *Blanks                                          CFT032
     C                             #SORC4 <> *Blanks or                                       CFT032
     C                             #SORC5 <> *Blanks                                          CFT032
     C                   Eval      @ORCT = 'A'
     C                   IF        %SUBST(#SORC1:1:1) = '/' And                             BUG25040
     C                             #SORC2 = *blanks                                         BUG25040
     C                   Eval      OKOrc1 = 'N'                                             BUG25040
     C                   Eval      Idx = Idx + 1                                            BUG25040
     C                   Eval      FldNamXAr(Idx) = 'SORC2'                                 BUG25040
     C                   Eval      MsgIdXAr(Idx) = 'FTM2152'                                BUG25040
     C                   LeaveSr                                                            BUG25040
     C                   ENDIF                                                              BUG25040
     C                   End
E2   C                   EndIf                                                              BUG14771

     C**********         If        @ORCT = 'P' And                                   CFT032 BUG14771
     C**********                   IBAN <> ' '                                       CFT032 BUG14771
B2   C                   If        @ORCT = 'P'                                              BUG14771
     C                   If        IBAN <> ' '                                              BUG14771
     C                   Eval      @@IBAN = 'Y'                                               CFT032
     C                   Else                                                                 CFT032
     C                   Eval      @@IBAN = 'N'                                               CFT032
     C                   EndIf                                                                CFT032
E2   C                   EndIf                                                              BUG14771
                                                                                              CFT032
     C                   End

      *  MT202 keyword may only be used in Ordering Customer field 1
      *  if the settlement type is '01', '02' or '08'.

     C                   If        #SORC1 = 'MT202' and
     C                             SSTTP <> '01'  and
     C                             SSTTP <> '02'  and
     C                             SSTTP <> '08'
      * Send error to screen
     C                   Move      'N'           OKOrc1
     C                   Add       1             Idx
     C                   Movel     'SORC1'       FldNamXAr(Idx)
     C                   Movel     'MMA0936'     MsgIdXAr(Idx)
     C                   End
      *                                                                                     BUG25676
      ** Ordering Customer lines 2-5 must be blanks if MT202 keyword                        BUG25676
      ** is used in Ordering Customer 1                                                     BUG25676
      *                                                                                     BUG25676
     C                   IF        #SORC1 = 'MT202'                                         BUG25676
     C                   IF        #SORC2 <> *BLANKS                                        BUG25676
     C                             OR #SORC3 <> *BLANKS                                     BUG25676
     C                             OR #SORC4 <> *BLANKS                                     BUG25676
     C                             OR #SORC5 <> *BLANKS                                     BUG25676
                                                                                            BUG25676
     C                   MOVE      'N'           OKOrc1                                     BUG25676
     C                   ADD       1             Idx                                        BUG25676
     C                   MOVEL     'SORC1'       FldNamXAr(Idx)                             BUG25676
     C                   MOVEL     'FTM7115'     MsgIdXAr(Idx)                              BUG25676
                                                                                            BUG25676
     C                   ENDIF                                                              BUG25676
     C                   ENDIF                                                              BUG25676

      * Extra validation of address fields

     C                   If        @ORCT = 'A'
     C                             Or @ORCT = 'I'                                           BUG15045
     C*
     C                   Movea     '0000'        *IN(91)
     C*
     C                   Eval      ADDRSS = *Blanks
     C                   Eval      ADCHK1 = #SORC1
     C                   Eval      ADCHK2 = #SORC2
     C                   Eval      ADCHK3 = #SORC3
     C                   Eval      ADCHK4 = #SORC4
     C                   Eval      ADCHK5 = #SORC5                                            CFT032

     C                   Exsr      ADCHK

      * Depending on the indicators highlight the field in error
      * and output the error message

     C                   If        *IN92 = *On or
     C                             *IN93 = *On
      * Send error to screen
     C                   Move      'N'           OKOrc1
     C                   Add       1             Idx
     C                   Movel     'SORC1'       FldNamXAr(Idx)
     C                   Movel     'MMA0937'     MsgIdXAr(Idx)
     C                   End
     C*
     C*
     C                   End
      *                                                                                     BUG21131
      ** Validate Ordering Customer                                                         BUG21131
      ** If Full address and does not start with a '/'                                      BUG21131
      ** second line should not be blank                                                    BUG21131
      *                                                                                     BUG21131
     C                   If        @ORCT = 'A'                                              BUG21131
     C                             And %SUBST(#SORC1:1:1) = '/'                             BUG21131
     C                             And #SORC2 = *BLANKS                                     BUG21131
     C                             And OKOrc1 <> 'N'                                        BUG21131
      * Send error to screen                                                                BUG21131
     C                   Move      'N'           OKOrc1                                     BUG21131
     C                   Add       1             Idx                                        BUG21131
     C                   Movel     'SORC1'       FldNamXAr(Idx)                             BUG21131
     C**********         Movel     'MMA1429'     MsgIdXAr(Idx)                     BUG21131 BUG24898
     C                   MOVEL     'FTM2152'     MsgIdXAr(Idx)                              BUG24898
      *                                                                                     BUG21131
     C**********         ElseIf    @ORCT = 'A'                                     BUG21131 BUG25859
     C**********                   And %SUBST(#SORC1:1:1) <> '/'                   BUG21131 BUG25859
     C**********                   And #SORC2 = *BLANKS                            BUG21131 BUG25859
     C**********                   And #SORC1 <> 'MT202'                           BUG21272 BUG25859
     C**********                   And OKOrc1 <> 'N'                               BUG21131 BUG25859
      **Send*error*to*screen*                                                      BUG21131 BUG25859
     C**********         Move      'N'           OKOrc1                            BUG21131 BUG25859
     C**********         Add       1             Idx                               BUG21131 BUG25859
     C**********         Movel     'SORC1'       FldNamXAr(Idx)                    BUG21131 BUG25859
     C**********         Movel     'MMA0935'     MsgIdXAr(Idx)                     BUG21131 BUG24898
     C**********         MOVEL     'FTM2152'     MsgIdXAr(Idx)                     BUG24898 BUG25859
     C                   EndIf                                                              BUG21131

     C                   ENDSR
     C************************************************************
     C* END OF ACCOUNT NUMBER VALIDATION
     C************************************************************
     C/EJECT
     C******************************************************************
     C* VALRET  - VALIDATION OF RETAIL ACCOUNT                         *
      ******************************************************************

     C     VALRET        BEGSR

      * Validate for Ordering Customer Number and shortname
                                                                                              CFT032
     C                   If        %SUBST(#SORC1:1:1) = '/'                                   CFT032
     C                   Eval      C#KEY1 = #SORC2                                            CFT032
     C                   Else                                                                 CFT032
     C                   Movel     #SORC1        C#KEY1
     C                   EndIf                                                                CFT032

     C                   CALLB     'AOCUSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    C#KEY1
     C                   Parm      *Blanks       C#KYST
     C     SDCUST        Parm      *Blanks       DSSDY
      *
      * If return code is blanks set to customer and translate to
      * customer number
      *
     C                   If        C#RTCD = *Blanks
     C**********         Eval      ORDCST = *Blanks                                         BUG14771
     C                   If        %SUBST(#SORC1:1:1) = '/'                                   CFT032
     C                   Eval      ORDCST = #SORC1 + BBCUST                                   CFT032
     C                   Else                                                                 CFT032
     C**********         Movel     BBCUST        ORDCST                                     BUG15037
     C                   Movel(P)  BBCUST        ORDCST                                     BUG15037
     C                   EndIf                                                                CFT032
     C                   MOvel     BBCUST        K#CNUM                                     BUG15037
     C                   Eval      @ORCT = 'C'
     C                   Else

     C                   If        %Subst(#SORC1:1:1) = '/'                                   CFT032
     C**********         Eval      WRETL = %INT(ORETS)                               CFT032 BUG12796
     C                   Movel     ORETS         WRETL                                      BUG12796
     C                   Else                                                                 CFT032
     C                   Movel     ORET          WRETL
     C                   EndIf                                                                CFT032
     C                   Movel     WRETL         WRETA
     C**********         If        OCUS = WRETA                                             BUG14771
     C                   If        OCUS = WRETA OR                                          BUG14771
     C                             OCUSS = WRETA                                            BUG14771

      * Check to see if a retail account number is allowed

     C                   If        BMRANR = 'N'
      * Send error to screen
     C                   Move      'N'           OKOrc1
     C                   Add       1             Idx
     C                   Movel     'SORC1'       FldNamXAr(Idx)
     C                   Movel     'MMA0943'     MsgIdXAr(Idx)
     C                   Else
     C*
     C                   If        %Subst(#SORC1:1:1) = '/'                                   CFT032
     C**********         Eval      ACNO = %INT(ORETS)                                CFT032 BUG12796
     C                   Move      ORETS         ACNO                                       BUG12796
     C                   Else                                                                 CFT032
     C                   Move      ORET          ACNO
     C                   EndIf                                                                CFT032
     C     ACNO          Chain     ACNUMAF                            90
      * Error if not found or RECI <> D
     C                   If        *in90 = *ON or
     C                             RECI <> 'D'
      * Send error to screen
     C                   Move      'N'           OKOrc1
     C                   Add       1             Idx
     C                   Movel     'SORC1'       FldNamXAr(Idx)
     C                   Movel     'MMA0935'     MsgIdXAr(Idx)

     C                   Else
      **Check*for*block*debits*on*account                                           BUG4581 MD044074
     C**********         TESTB     '2'           RETB                     51        BUG4581 MD044074
     C**********         If        *in51 = *ON                                      BUG4581 MD044074
     C**********         Move      'N'           OKOrc1                               BUG4581 CSD089
     C**********         Add       1             Idx                                  BUG4581 CSD089
     C**********         Movel     'SORC1'       FldNamXAr(Idx)                       BUG4581 CSD089
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                        BUG4581 CSD089
     C**********         Move      'W'           OKOrc1                              CSD089 MD044074
     C**********         Add       1             WIx                                 CSD089 MD044074
     C**********         Movel     'SORC1'       WFldNmXAr(WIx)                      CSD089 MD044074
     C**********         Movel     'FTM0014'     WMsgIdXAr(WIx)                      CSD089 MD044074
     C**********         End                                                        BUG4581 MD044074
     C     SORBK         IFEQ      *BLANKS                                                    240689
     C                   MOVE      RETB          WRETB                                        240689
     C                   ENDIF                                                                240689
     C                   Eval      @CCY = CCY
      * If Ordering Bank is blank Currency must equal Settle Currency
     C                   If        SORBK = *Blank and
     C                             @CCY <> SSMCY
      * Send error to screen
     C                   Move      'N'           OKOrc1
     C                   Add       1             Idx
     C                   Movel     'SORC1'       FldNamXAr(Idx)
     C                   Movel     'MMA0945'     MsgIdXAr(Idx)
     C                   End
     C                   End

     C**********         If        OKOrc1 = 'Y'                                             MD039547
     C                   If        OKOrc1 <> 'N'                                            MD039547

     C                   Eval      K#CNUM = CNUM
     C                   Eval      K#CCY= @CCY
     C                   Eval      K#ACOD = ACOD
     C                   Eval      K#ACSQ = ACSQ
     C                   Eval      K#BRCA = BRCA

     C                   Eval      @ORCT = 'R'
     C                   Eval      @ACST3 = ACST
                                                                                            BUG14771
     C                   If        IBAN <> ' '                                              BUG14771
     C                   Eval      @@IBAN = 'Y'                                             BUG14771
     C                   Else                                                               BUG14771
     C                   Eval      @@IBAN = 'N'                                             BUG14771
E2   C                   EndIf                                                              BUG14771

     C**********         If        ATYP = 'R'                                               MD037223
     C                   Eval      @OCOPN = DACO
     C                   If        ATYP = 'R'                                               MD037223
     C     SPRFC         IFEQ      *BLANKS                                                  AR924725
     C                   Eval      SPRFC = PRFC                                               179732
     C                   ENDIF                                                              AR924725
     C                   End
     C                   End
     C                   End
      *
     C                   End
     C                   End
      *

     C**********         If        @ORCT = 'R' And                                   CFT032 BUG14771
     C**********                   IBAN <> *Blanks                                   CFT032 BUG14771
     C                   If        @ORCT = 'R'                                              BUG14771
     C                   If        IBAN <> *Blanks                                          BUG14771
     C                   Eval      @@IBAN = 'Y'                                               CFT032
     C                   Else                                                                 CFT032
     C                   Eval      @@IBAN = 'N'                                               CFT032
     C                   EndIf                                                                CFT032
     C                   EndIf                                                              BUG14771
                                                                                              CFT032
     C                   ENDSR
     C************************************************************
     C* END OF RETAIL ACCOUNT NUMBER VALIDATION
     C************************************************************
     C/EJECT
     C*****************************************************************
     C*  ADCHK SUBROUTINE - TO VALIDATE ADDRESS FIELDS
     C*****************************************************************
     C*
     C     ADCHK         BEGSR

     C* There should be no embedded spaces

     C                   If        ADCHK1 = *Blanks  and
     C                             ADCHK2 <> *Blanks or

     C                             ADCHK1 = *Blanks  and
     C                             ADCHK3 <> *Blanks or

     C                             ADCHK1 = *Blanks  and
     C                             ADCHK4 <> *Blanks or

     C                             ADCHK1 = *Blanks  and
     C                             ADCHK5 <> *Blanks or

     C                             ADCHK2 = *Blanks  and
     C                             ADCHK3 <> *Blanks or

     C                             ADCHK2 = *Blanks  and
     C                             ADCHK4 <> *Blanks or

     C                             ADCHK2 = *Blanks  and
     C                             ADCHK5 <> *Blanks or

     C                             ADCHK3 = *Blanks  and
     C                             ADCHK4 <> *Blanks or

     C                             ADCHK3 = *Blanks  and
     C                             ADCHK5 <> *Blanks or

     C                             ADCHK4 = *Blanks  and
     C                             ADCHK5 <> *Blanks

     C                   Eval      *IN92 = *ON
     C                   End

     C** Check for non-valid Swift characters

     C                   If        ADCHK1 <> *Blanks
     C                             and WINSWC <> 'Y'                                        BUG24975
     C                   Eval      WFLD = ADCHK1
     C                   Exsr      SWSET

     C                   If        *IN94 = *Off
      * Send error to screen
     C**********         Move      'N'           OKOrc1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SORC1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA0938'     MsgIdXAr(Idx)                                CSD089
     C**********         Move      'W'           OKOrc1                              CSD089 MD051978
     C**********         Add       1             WIx                                 CSD089 MD051978
     C**********         Movel     'SORC1'       WFldNmXAr(WIx)                      CSD089 MD051978
     C**********         Movel     'MMA0938'     WMsgIdXAr(WIx)                      CSD089 MD051978
     C                   MOVE      'N'           OKOrc1                                     MD051978
     C                   ADD       1             Idx                                        MD051978
     C                   MOVEL     'SORC1'       FldNamXAr(Idx)                             MD051978
     C                   MOVEL     'MMA0938'     MsgIdXAr(Idx)                              MD051978
     C                   End
     C                   End

     C                   If        ADCHK2 <> *Blanks
     C                   Eval      WFLD = ADCHK2
     C                   Exsr      SWSET

     C                   If        *IN94 = *Off
     C                             OR %SUBST(WFLD: 1: 1) = '-'                              MD051978
     C                             OR %SUBST(WFLD: 1: 1) = ':'                              MD051978
      * Send error to screen
     C**********         Move      'N'           OKOrc1                                       210863
     C**********         Move      'N'           OKOrc2                                210863 CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SORC2'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA0939'     MsgIdXAr(Idx)                                CSD089
     C**********         Move      'W'           OKOrc2                              CSD089 MD051978
     C**********         Add       1             WIx                                 CSD089 MD051978
     C**********         Movel     'SORC2'       WFldNmXAr(WIx)                      CSD089 MD051978
     C**********         Movel     'MMA0939'     WMsgIdXAr(WIx)                      CSD089 MD051978
     C                   MOVE      'N'           OKOrc2                                     MD051978
     C                   ADD       1             Idx                                        MD051978
     C                   MOVEL     'SORC2'       FldNamXAr(Idx)                             MD051978
     C                   Movel     'MMA0939'     MsgIdXAr(Idx)                              MD051978
     C                   End
     C                   End

     C                   If        ADCHK3 <> *Blanks
     C                   Eval      WFLD = ADCHK3
     C                   Exsr      SWSET

     C                   If        *IN94 = *Off
     C                             OR %SUBST(WFLD: 1: 1) = '-'                              MD051978
     C                             OR %SUBST(WFLD: 1: 1) = ':'                              MD051978
      * Send error to screen
     C**********         Move      'N'           OKOrc1                                       210863
     C**********         Move      'N'           OKOrc3                                210863 CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SORC3'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA0940'     MsgIdXAr(Idx)                                CSD089
     C**********         Move      'W'           OKOrc3                              CSD089 MD051978
     C**********         Add       1             WIx                                 CSD089 MD051978
     C**********         Movel     'SORC3'       WFldNmXAr(WIx)                      CSD089 MD051978
     C**********         Movel     'MMA0940'     WMsgIdXAr(WIx)                      CSD089 MD051978
     C                   MOVE      'N'           OKOrc3                                     MD051978
     C                   ADD       1             Idx                                        MD051978
     C                   MOVEL     'SORC3'       FldNamXAr(Idx)                             MD051978
     C                   MOVEL     'MMA0940'     MsgIdXAr(Idx)                              MD051978
     C                   End
     C                   End

     C                   If        ADCHK4 <> *Blanks
     C                   Eval      WFLD = ADCHK4
     C                   Exsr      SWSET

     C                   If        *IN94 = *Off
     C                             OR %SUBST(WFLD: 1: 1) = '-'                              MD051978
     C                             OR %SUBST(WFLD: 1: 1) = ':'                              MD051978
      * Send error to screen
     C**********         Move      'N'           OKOrc1                                       210863
     C**********         Move      'N'           OKOrc4                                210863 CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SORC4'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA0941'     MsgIdXAr(Idx)                                CSD089
     C**********         Move      'W'           OKOrc4                              CSD089 MD051978
     C**********         Add       1             WIx                                 CSD089 MD051978
     C**********         Movel     'SORC4'       WFldNmXAr(WIx)                      CSD089 MD051978
     C**********         Movel     'MMA0941'     WMsgIdXAr(WIx)                      CSD089 MD051978
     C                   MOVE      'N'           OKOrc4                                     MD051978
     C                   ADD       1             Idx                                        MD051978
     C                   MOVEL     'SORC4'       FldNamXAr(Idx)                             MD051978
     C                   MOVEL     'MMA0941'     MsgIdXAr(Idx)                              MD051978
     C                   End
     C                   End

     C                   If        ADCHK5 <> *Blanks
     C                   Eval      WFLD = ADCHK5
     C                   Exsr      SWSET

     C                   If        *IN94 = *Off
     C                             OR %SUBST(WFLD: 1: 1) = '-'                              MD051978
     C                             OR %SUBST(WFLD: 1: 1) = ':'                              MD051978
      * Send error to screen
     C**********         Move      'N'           OKOrc1                                     BUG14771
     C**********         Move      'N'           OKOrc5                              BUG14771 CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SORC1'       FldNamXAr(Idx)                               CFT032
     C**********         Eval      FldNamXAr(Idx) = 'SORC5'                            CFT032 CSD089
     C**********         Movel     'MMA0942'     MsgIdXAr(Idx)                                CSD089
     C**********         Move      'W'           OKOrc5                              CSD089 MD051978
     C**********         Add       1             WIx                                 CSD089 MD051978
     C**********         Eval      WFldNmXAr(WIx) = 'SORC5'                          CSD089 MD051978
     C**********         Movel     'MMA0942'     WMsgIdXAr(WIx)                      CSD089 MD051978
     C                   MOVE      'N'           OKOrc5                                     MD051978
     C                   ADD       1             Idx                                        MD051978
     C                   MOVEL     'SORC5'       FldNamXAr(Idx)                             MD051978
     C                   MOVEL     'MMA0942'     MsgIdXAr(Idx)                              MD051978
     C                   End
     C                   End

     C                   If        CSW207 = 'N'                                             BUG15045
     C                   If        %SUBST(ADCHK1:1:1) <> '/'                                  CFT032
     C                   If        ADCHK5 <> *Blank                                           CFT032
      * as CFT032 is not Switchable 50K can be input with 5 lines                           BUG15037
     C**********                   And CSW207 <> 'Y'                                CSW207A BUG15037
     C                   Move      'N'           OKOrc5                                     BUG14771
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SORC5'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1410'                                  CFT032
     C                   EndIf                                                                CFT032
     C                   Else                                                               BUG15037
      * If first line is starting with a '/', the second line must be entered               BUG15037
     C                   If        ADCHK2 =  *Blank                                         BUG15037
     C                   Move      'N'           OKOrc2                                     BUG15037
     C                   Eval      Idx = Idx + 1                                            BUG15037
     C                   Eval      FldNamXAr(Idx) = 'SORC2'                                 BUG15037
     C                   Eval      MsgIdXAr(Idx) = 'MMA1429'                                BUG15037
     C                   EndIf                                                              BUG15037
     C                   EndIf                                                                CFT032
     C                   EndIf                                                              BUG15045
                                                                                              CFT032
     C                   ENDSR
     C*
     C************************************************************
     C* END OF ADDRESS VALIDATION
     C************************************************************
     C/EJECT
     C************************************************************
     C* SUBROUTINE SWSET CHECK FOR VALID SWIFT CHARACTER USED
     C************************************************************

     C     SWSET         BEGSR

     C                   Eval      R = 1
     C                   Eval      *IN94 = *On

     C                   If        WFLD <> *Blanks
     C                   Movea     WFLD          TST
     C                   Eval      R = 1
      * check each character until invalid found
     C                   DOW       R <= 35 and
     C                             *IN94 = *On
      * Validate if not blank
     C                   If        TST(R) <> *Blanks
     C     TST(R)        LOOKUP    SWCH                                   94
     C                   End

     C                   Eval      R = R + 1
     C                   End
     C                   End
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
      ************************************************************                            CFT032
      ** SROUFM -                                                                             CFT032
      ************************************************************                            CFT032
                                                                                              CFT032
     C     SROUFM        BEGSR                                                                CFT032
                                                                                              CFT032
     C**********         Eval      WEntryType = @ODMTT                               CFT032 BUG14771
     C                   Eval      WEntryType = @ORCT                                       BUG14771
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
     C**********         Eval      WFieldTag = ':50K:'                                 CFT032 250600
     C**********         If        @ODMTT = 'S' Or                                   CFT032 BUG14771
     C**********                   BBCSID <> *Blanks Or                              CFT032 BUG14771
     C**********         If        @ORCT  = 'S' Or                                   BUG14771 250600
     C**********                   WCSID = 'Y'       Or                              BUG14771 250600
     C**********                   (FeatureCSW024 = *On And BBCBEI <> *Blanks)         CFT032 250600
     C**********         Eval      WFieldTag = ':50A:'                                 CFT032 250600
     C**********         EndIf                                                         CFT032 250600
                                                                                              CFT032
     C**********         If        SSTTP = '08'                                        CFT032 257361
     C**********         Eval      WNetwork = 'SWIFT'                                  CFT032 257361
     C**********         Else                                                          CFT032 257361
     C**********         Eval      WNetwork = 'Telex'                                CFT032 BUG14716
     C**********         Eval      WNetwork = 'TELEX'                                BUG14716 257361
     C**********         EndIf                                                         CFT032 257361
     C                   Select                                                               257361
     C                   When      SSTTP = '08'                                               257361
     C                   Eval      WNetwork = 'SWIFT'                                         257361
     C                   When      SSTTP = '01'                                               257361
     C                   Eval      WNetwork = 'TELEX'                                         257361
     C                   When      SSTTP = '02' Or                                            257361
     C                             SSTTP = '12' Or                                            257361
     C**********                   SSTTP = '13'                                      257361 BUG26794
     C                             SSTTP = '13' Or                                          BUG26794
     C                             SSTTP = '14'                                             BUG26794
     C                   Eval      WNetwork = 'PAPER'                                         257361
     C                   When      SSTTP = '10'                                               257361
     C                   Eval      WNetwork = 'CHAPS'                                         257361
     C                   EndSl                                                                257361
                                                                                              CFT032
     C                   Select                                                               CFT032
     C                   When      @DSTT = 'A'                                                CFT032
     C                   Eval      WCountry = ' '                                             CFT032
     C                   When      @DSTT = 'S'                                                CFT032
     C**********         Eval      WCountry = %Subst(ORDCST:5:2)                     CFT032 BUG14771
     C                   Eval      WCountry = %Subst(SDST1:5:2)                             BUG14771
                                                                                              CFT032
     C                   Other                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOACCTV1'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      *Blanks       P@Typ                                        CFT032
     C**********         Parm      ORDCST        P@Str                               CFT032 BUG14771
     C**********         Parm      SDST1         P@Str                            BUG14771 BUG14771A
     C**********         Parm      ORDCST        P@Str                             BUG14771A 250804A
     C                   Parm      SDST1         P@Str                                       250804A
     C                   Parm                    DSSDY                                        CFT032
                                                                                              CFT032
     C**********         Eval      PAcctyp = *Blanks                                  CSW207 250804A
     C                   Eval      PAcctyp = @ORCT                                           250804A
     C                   Select                                                               CFT032
     C                   When      P@Typ = '*RETAIL' Or                                       CFT032
     C                             P@Typ = '*LEDGER'                                          CFT032
     C                   Eval      SDACCNT = DSSDY                                            CFT032
     C                   Eval      WCustomer = CNUM                                           CFT032
     C**********         If        P@Typ = '*RETAIL'                                  CSW207 250804A
     C**********         Eval      PAcctyp = 'R'                                      CSW207 250804A
     C**********         Else                                                         CSW207 250804A
     C**********         Eval      PAcctyp = 'G'                                      CSW207 250804A
     C**********         EndIf                                                        CSW207 250804A
     C**********         Move      IFCNUM        WCNUM                                CSW207 250804A
     C**********         Move      IFACOD        WACOD                                CSW207 250804A
     C**********         Move      IFACSQ        WACSQ                                CSW207 250804A
     C**********         Eval      PAcc = IFBRCA + WCNUM + IFCCY                      CSW207 250804A
     C**********                        + WACOD + WACSQ                               CSW207 250804A
     C                   When      P@Typ = '*NOSTRO'                                          CFT032
     C                   Eval      SDNOST = DSSDY                                             CFT032
     C                   Eval      WCustomer = A7CUST                                         CFT032
     C**********         Eval      PAcctyp = 'N'                                      CSW207 250804A
     C**********         Eval      PCurr = %Subst(SORC1:2:3)                          CSW207 250804A
     C**********         Eval      PNostro = %Subst(SORC1:5:2)                        CSW207 250804A
     C                   When      P@Typ = '*CUSTNO' Or                                       CFT032
     C                             P@Typ = '*SHNAME'                                          CFT032
     C                   Eval      SDCUST = DSSDY                                             CFT032
     C                   Eval      WCustomer = BBCUST                                         CFT032
     C**********         If        P@Typ = '*CUSTNO'                                  CSW207 250804A
     C**********         Eval      PAcctyp = 'C'                                      CSW207 250804A
     C**********         If        %Subst(SORC1:1:1) = '/'                            CSW207 250804A
     C**********         Eval      PCust = %Subst(SORC1:2:6)                          CSW207 250804A
     C**********         Else                                                         CSW207 250804A
     C**********         Eval      PCust = %Subst(SORC1:1:6)                          CSW207 250804A
     C**********         EndIf                                                        CSW207 250804A
     C**********         EndIf                                                        CSW207 250804A
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
     C**********         If        CSW207 = 'Y'                                       CSW207 250804A
     C**********                   And @ODMTT = 'O'                                   CSW207 CSW207A
     C**********                   And SODMT <> *Blanks                              CSW207A 250804A
      *                                                                                       CSW207
      * Retrieve joint account customer                                                       CSW207
      *                                                                                       CSW207
     C**********         Movel     SORC1         WCustomer                            CSW207 250804A
     C**********         Move      WCustomer     WCustomerA                           CSW207 250804A
     C*****WCustomerA    Chain     SDJACCL4                                           CSW207 CSW207A
     C*****WCustomerA    Chain     SDJACCL5                                          CSW207A 250804A
      *                                                                                       CSW207
     C**********         If        NOT %Found(SDJACCL4)                               CSW207 CSW207A
     C**********         If        NOT %Found(SDJACCL5)                               CSW207 250804A
     C**********         Eval      OkORC1 = 'N'                                       CSW207 250804A
     C**********         Eval      Idx = Idx + 1                                      CSW207 250804A
     C**********         Eval      FldNamXAr(Idx) = 'SORC1'                           CSW207 250804A
     C**********         Eval      MsgIdXAr(Idx) = 'MMA3000'                          CSW207 250804A
     C**********         LeaveSR                                                      CSW207 250804A
     C**********         Else                                                         CSW207 250804A
     C**********         Move      JCJANO        WJCOrdCust        6                  CSW207 250804A
     C**********         EndIf                                                        CSW207 250804A
      **********                                                                      CSW207 250804A
      **Retrieve*joint*account*customer*of*the*non-account*customer                   CSW207 250804A
      **********                                                                      CSW207 250804A
     C**********         Move      SODMT         WNonODMT         10                 CSW207A 250804A
     C**********         Movel     SODMT         WNonODMT         10                 CSW207A 250804A
     C*****WNonODMT      Chain     SDJACCL7                                           CSW207 250804A
     C**********         If        %Found(SDJACCL7)                                   CSW207 250804A
     C**********         If        JCJANO <> WJCOrdCust                               CSW207 250804A
     C**********         Eval      OkORC1 = 'N'                                       CSW207 250804A
     C**********         Eval      Idx = Idx + 1                                      CSW207 250804A
     C**********         Eval      FldNamXAr(Idx) = 'SORC1'                           CSW207 250804A
     C**********         Eval      MsgIdXAr(Idx) = 'MMA3000'                          CSW207 250804A
     C**********         LeaveSR                                                      CSW207 250804A
     C**********         EndIf                                                        CSW207 250804A
     C**********         EndIf                                                        CSW207 250804A
      **********                                                                      CSW207 250804A
     C**********         EndIf                                                        CSW207 250804A
      **********                                                                      CSW207 250804A
     C**********         EndSl                                                        CSW207 250804A
      **********                                                                      CSW207 250804A
      ** Determine from where to get Nostro: Sender Correspondent                             CFT032
      ** or Destination (1st field)                                                           CFT032
                                                                                              CFT032
     C**********         Eval      WAddress = ' '                                    CFT032 BUG14771
     C                   Eval      ADDRSS  =  ' '                                           BUG14771
     C                   If        SSNCO <> *Blanks                                           CFT032
     C**********         Eval      WAddress = SSNCO                                  CFT032 BUG14771
     C                   Eval      ADDRSS  =  SSNCO                                         BUG14771
     C                   Movel     @SNCT         WEntryType2       1                        BUG14771
     C                   Else                                                                 CFT032
     C                   If        SDST1 <> *Blanks                                           CFT032
     C**********         Eval      WAddress = SDST1                                  CFT032 BUG14771
     C                   Eval      ADDRSS  =  SDST1                                         BUG14771
     C                   Movel     @DSTT         WEntryType2       1                        BUG14771
     C                   EndIf                                                                CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Prepare to extract the nostro number                                                 CFT032
                                                                                              CFT032
     C                   Eval      WNonAcct   = *Blanks                                       CSW207
                                                                                              CSW207
     C                   Select                                                               CFT032
     C**********         When      WEntryType = 'P' Or                               CFT032 BUG14771
     C**********                   WEntryType = 'G'                                  CFT032 BUG14771
     C                   When      WEntryType2 = 'P' Or                                     BUG14771
     C                             WEntryType2 = 'G'                                        BUG14771
                                                                                              CFT032
      ** Check if multi-branch to determine how the branch is retrieved.                      CFT032
                                                                                              CFT032
     C                   If        BGMBIN = 'Y'                                               CFT032
     C                   Eval      P@Brcd = ADPBRC                                            CFT032
     C                   Else                                                                 CFT032
     C                   Eval      P@Brcd = BJSBRC                                            CFT032
     C                   EndIf                                                                CFT032
                                                                                            BUG14771
     C                   If        SPCCY <> *BLANKS                                         BUG14771
     C                   EVAL      WCurrency = SPCCY                                        BUG14771
     C                   Else                                                               BUG14771
     C                   EVAL      WCurrency = SSMCY                                        BUG14771
     C                   Endif                                                              BUG14771
                                                                                              CFT032
     C**********         If        WEntryType = 'P'                                  CFT032 BUG14771
     C                   If        WEntryType2 = 'P'                                        BUG14771
     C                   Eval      P@Cust = ADPCNM                                            CFT032
     C                   Eval      P@Accd = ADPACD                                            CFT032
     C                   Eval      P@ACSQ = ADPASQ                                            CFT032
     C**********         Eval      P@Cycd = WCurrency                                 CFT032 250804A
     C                   Eval      P@Cycd = SPCCY                                            250804A
     C                   Else                                                                 CFT032
     C                   Eval      P@Cust = ADGCNM                                            CFT032
     C                   Eval      P@Accd = ADGACD                                            CFT032
     C                   Eval      P@ACSQ = ADGASQ                                            CFT032
     C**********         Eval      P@Cycd = WCurrency                                 CFT032 250804A
     C                   Eval      P@Cycd = SPCCY                                            250804A
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C**********         When      WEntryType = 'R'                                  CFT032 BUG14771
     C                   When      WEntryType2 = 'R'                                        BUG14771
                                                                                              CFT032
     C                   Movel     ADDRSS        P@RETL                                     BUG14771
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
     C     SDACCNT       Parm      SDACCNT       DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Eval      P@CUST = CNUM                                              CFT032
     C                   Eval      P@ACCD = %EDITC(ACOD:'X')                                  CFT032
     C                   Eval      P@CYCD = CCY                                               CFT032
     C                   Eval      P@BRCD = BRCA                                              CFT032
     C                   Eval      P@ACSQ = %EDITC(ACSQ:'X')                                  CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   Movel     ADDRSS        P@IBAN                                     BUG14771
     C**********         When      WEntryType = 'I'                                  CFT032 BUG14771
     C                   When      WEntryType2 = 'I'                                        BUG14771
     C                   Call      'AOIBANR4'
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C**********         Parm      WAddress      P@IBAN                              CFT032 BUG14771
     C                   Parm                    P@IBAN                                     BUG14771
     C     SDACCNT       Parm      SDACCNT       DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Eval      P@CUST = CNUM                                              CFT032
     C                   Eval      P@ACCD = %EDITC(ACOD:'X')                                  CFT032
     C                   Eval      P@CYCD = CCY                                               CFT032
     C                   Eval      P@BRCD = BRCA                                              CFT032
     C                   Eval      P@ACSQ = %EDITC(ACSQ:'X')                                  CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C**********         When      WEntryType = 'O'                                   CSW207 250804A
     C**********                   And CSW207 = 'Y'                                   CSW207 250804A
     C**********         Move      SODMT         WNonAcct                            CSW207 Bug14809
     C**********         Movel     SODMT         WNonAcct                           BUG14809 250804A
                                                                                              CSW207
     C                   EndSl                                                                CFT032
                                                                                              CFT032
      ** Retrieve nostro number for diffent types                                             CFT032
                                                                                              CFT032
     C                   Select                                                               CFT032
                                                                                              CFT032
      ** For Entry Type 'N', just get it directly from input                                  CFT032
                                                                                              CFT032
     C**********         When      WEntryType = 'N'                                  CFT032 BUG14771
     C                   When      WEntryType2 = 'N'                                        BUG14771
     C                   Eval      WNostro = ADNOSN                                           CFT032
                                                                                              CFT032
                                                                                              CFT032
      ** For Entry Type 'F', just get it directly from input                                  CFT032
                                                                                              CFT032
     C**********         When      WEntryType = 'F'                                  CFT032 BUG14771
     C                   When      WEntryType2 = 'F'                                        BUG14771
     C                   Eval      WNostro = ADFNNB                                           CFT032
                                                                                              CFT032
      ** For other types, get it from SDNOSTPD                                                CFT032
                                                                                              CFT032
     C**********         When      WEntryType = 'P' Or                               CFT032 BUG14771
     C**********                   WEntryType = 'G' Or                               CFT032 BUG14771
     C**********                   WEntryType = 'R' Or                               CFT032 BUG14771
     C**********                   WEntryType = 'I'                                  CFT032 BUG14771
     C                   When      WEntryType2 = 'P' Or                                     BUG14771
     C                             WEntryType2 = 'G' Or                                     BUG14771
     C                             WEntryType2 = 'R' Or                                     BUG14771
     C                             WEntryType2 = 'I'                                        BUG14771
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
                                                                                            BUG14771
                                                                                             250804A
     C                   EndSl                                                               250804A
                                                                                             250804A
     C                   If        SPCCY <> *BLANKS                                         BUG14771
     C                   EVAL      WCurrency = SPCCY                                        BUG14771
     C                   Else                                                               BUG14771
     C                   EVAL      WCurrency = SSMCY                                        BUG14771
     C                   Endif                                                              BUG14771
                                                                                              CFT032
     C**********         EndSl                                                        CFT032 250804A
                                                                                              CFT032
     C                   EVAL      ADSLSH = %SUBST(#SORC1:1:1)                              BUG14771
                                                                                            BUG14771
     C                   Select                                                              250804A
     C                   When      SORC1 = 'MT202'                                           250804A
     C                   Eval      P@TYP3A = '202'                                           250804A
     C                   Other                                                               250804A
     C                   Eval      P@TYP3A = '103'                                           250804A
     C                   EndSl                                                               250804A
                                                                                             250804A
     C                   If        CSW207 = 'Y'                                               CSW207
     C                             and P@TYP3A = '103'                                       250804A
     C                   Eval      WfieldTag = ':50F:'                                        CSW207
     C                   ExSr      SRVAL50                                                    CSW207
     C                   EndIf                                                                CSW207
                                                                                              CSW207
     C                   If        P@TYP3A = '103'                                           250804A
      *                                                                                      250804A
     C**********         If        PRtCd = '*ERROR' Or                                CSW207 250804A
     C**********                   CSW207 = 'N'                                       CSW207 250804A
     C                   If        CSW207 = 'N' or                                           250804A
     C                             PFlag <> 'E'                                              250804A
     C**********                   and PRtCd <> *Blanks                             250804A MD045920
      *                                                                                      250804A
     C                   Eval      WFieldTag = ':50K:'                                       250804A
                                                                                              CSW207
     C                   If        @ORCT  = 'S' Or                                           250804A
     C                             PfCSID <> *Blanks Or                                      250804A
     C                             (FeatureCSW024 = *On And PfCBEI <> *Blanks)               250804A
     C                   Eval      WFieldTag = ':50A:'                                       250804A
     C                   EndIf                                                               250804A
                                                                                             250804A
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
     C**********         Parm      WCountry      P@CTRY                            BUG12692 BUG14042
     C                   Parm      WCountry      P@CTRY4A                                   BUG14042
     C**********         Parm      SPCCY         P@CYCD                              CFT032 BUG14771
     C**********         Parm      WCurrency     P@CYCD                            BUG14771  250804A
     C                   Parm      SPCCY         P@CYCD                                      250804A
     C                   Parm      WNostro       P@NOS                                        CFT032
     C**********         Parm      'ACCOUNTLINE' P@ACT                               CFT032 BUG14042
     C                   Parm      'ACOUNTLINE'  P@ACT                                      BUG14042
     C     MEOUFM        Parm      MEOUFM        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd <> *Blanks                                          250804A
     C                   Eval      OMFLAG = 'O'                                              250804A
     C                   Endif                                                               250804A
      *                                                                                      250804A
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Select                                                               CFT032
     C**********         When      OMAACT = ' '                                      CFT032 BUG14042
     C                   When      OMFLAG = ' '                                             BUG14042
     C**********         Eval      OMAACT = 'O'                                      CFT032 BUG14042
     C                   Eval      OMFLAG = 'O'                                             BUG14042
                                                                                              CFT032
     C**********         When      OMAACT = 'M' And                                  CFT032 BUG14042
     C                   When      OMFLAG = 'M' And                                         BUG14042
     C                             ADSLSH <> '/' And                                          CFT032
     C**********                   (@ODMTT = 'S' Or @ODMTT = 'C' Or                  CFT032 BUG14771
     C**********                    @ODMTT = 'A')                                    CFT032 BUG14771
     C                             (@ORCT  = 'S' Or @ORCT  = 'C' Or                         BUG14771
     C                              @ORCT  = 'A')                                           BUG14771
     C**********                    And PFlag = 'E'                                BUG15045 MD045920
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'ORDCST'                                  CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1412'                                  CFT032
     C**********         Eval      OkOdmt = 'N'                                      CFT032 BUG14042
     C                   Eval      OkORC1 = 'N'                                             BUG14042
     C                   Eval      @Orct = *Blanks                                           250804A
      *                                                                                      250804A
                                                                                              CFT032
     C**********         When      OMAACT = 'W' And                                  CFT032 BUG14042
     C                   When      OMFLAG = 'W' And                                         BUG14042
     C                             ADSLSH <> '/' And                                          CFT032
     C**********                   (@ODMTT = 'S' Or @ODMTT = 'C' Or                  CFT032 BUG14771
     C**********                    @ODMTT = 'A')                                    CFT032 BUG14771
     C                             (@ORCT  = 'S' Or @ORCT  = 'C' Or                         BUG14771
     C                              @ORCT  = 'A')                                           BUG14771
     C**********         Eval      Idx = Idx + 1                                     CFT032 BUG14042
     C**********         Eval      FldNamXAr(Idx) = 'ORDCST'                         CFT032 BUG14042
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1413'                         CFT032 BUG14042
     C**********         Eval      OkOdmt = 'N'                                      CFT032 BUG14042
     C                   Eval      WIx = WIx + 1                                            BUG14042
     C                   Eval      WFldNmXAr(WIx) = 'ORDCST'                                BUG14042
     C                   Eval      WMsgIdXAr(WIx) = 'MMA1413'                               BUG14042
     C                   Eval      OKORC1 = 'N'                                             BUG14042
                                                                                              CFT032
     C**********         When      OMAACT = 'P' And                                  CFT032 BUG14042
     C                   When      OMFLAG = 'P' And                                         BUG14042
     C**********                   ADSLSH <> '/'                                     CFT032 BUG14771
     C                             ADSLSH =  '/'                                            BUG14771
     C**********         Eval      Idx = Idx + 1                                     CFT032 BUG14968
     C**********         Eval      FldNamXAr(Idx) = 'ORDCST'                         CFT032 BUG14968
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1414'                         CFT032 BUG14968
     C**********         Eval      OkOdmt = 'N'                                      CFT032 BUG14042
     C                   Eval      OKORC1 = 'N'                                             BUG14042
     C                   Eval      WIx = WIx + 1                                            BUG14968
     C                   Eval      WFldNmXAr(WIx) = 'ORDCST'                                BUG14968
     C                   Eval      WMsgIdXAr(WIx) = 'MMA1414'                               BUG14968
                                                                                              CFT032
     C                   EndSl                                                                CFT032
     C                   EndIf                                                                CFT032
                                                                                              CSW207
     C**********         EndIf                                                        CSW207 250804A
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
     C                   Parm      WCountry      P@CTRY4A                                   BUG14042
     C**********         Parm      SPCCY         P@CYCD                              CFT032 BUG14771
     C**********         Parm      WCurrency     P@CYCD                             BUG14771 250804A
     C                   Parm      SPCCY         P@CYCD                                       250600
     C                   Parm      WNostro       P@NOS                                        CFT032
     C**********         Parm      'ACCOUNTIBAN' P@ACT                               CFT032 BUG14042
     C                   Parm      'ACOUNTIBAN'  P@ACT                                      BUG14042
     C     MEOUFM        Parm      MEOUFM        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd <> *Blanks                                          250804A
     C                   Eval      OMFLAG = 'O'                                              250804A
     C                   Endif                                                               250804A
      *                                                                                      250804A
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
     C**********         Eval      FldNamXAr(Idx) = 'SODMT'                          CFT032 BUG14771
     C                   Eval      FldNamXAr(Idx) = 'SORC1'                                 BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1426'                         CFT032 BUG14042
     C**********         Eval      OkOdmt = 'N'                                      CFT032 BUG14042
     C                   Eval      MsgIdXAr(Idx) = 'MMA1415'                                BUG14042
     C                   Eval      OKORC1 = 'N'                                             BUG14042
     C                   Eval      @Orct = *Blanks                                           250804A
                                                                                              CFT032
     C**********         When      OMAACT = 'W' And                                  CFT032 BUG14042
     C                   When      OMFLAG = 'W' And                                         BUG14042
     C                             @@IBAN = 'N'                                               CFT032
     C**********         Eval      Idx = Idx + 1                                     CFT032 BUG14042
     C**********         Eval      FldNamXAr(Idx) = 'SODMT'                          CFT032 BUG14042
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1427'                         CFT032 BUG14042
     C**********         Eval      OkOdmt = 'N'                                      CFT032 BUG14042
     C                   Eval      WIx = WIx + 1                                            BUG14042
     C**********         Eval      WFldNmXAr(WIx) = 'SODMT'                        BUG14042 BUG14771
     C                   Eval      WFldNmXAr(WIx) = 'SORC1'                                 BUG14771
     C**********         Eval      WMsgIdXAr(Idx) = 'MMA1416'                       BUG14042 250804A
     C                   Eval      WMsgIdXAr(WIx) = 'MMA1416'                                250804A
     C                   Eval      OKORC1 = 'N'                                             BUG14042
                                                                                              CFT032
     C                   EndSl                                                                CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   EndIf                                                                CFT032
     C                   EndIf                                                               250804A
     C                   EndIf                                                               250804A
                                                                                              CFT032
     C                   ENDSR                                                                CFT032
                                                                                              CFT032
      ************************************************************                            CFT032
      ** End                                                                                  CFT032
      ************************************************************                            CFT032
     C/EJECT
      *****************************************************************                       CSW207
      ** SRVAL50 - Validation for 50F Tag                             *                       CSW207
      *****************************************************************                       CSW207
                                                                                              CSW207
     C     SRVAL50       BEGSR                                                                CSW207
                                                                                              CSW207
     C**********         If        @@IBAN = 'Y'                                       CSW207 CSW207A
     C**********                   And PAcctyp = *Blanks                              CSW207 CSW207A
     C**********         If        PAcctyp = 'I'                                     CSW207A CSW207A
     C**********         Eval      PAcctyp = 'I'                                      CSW207 CSW207A
     C**********         If        @@IBAN = 'Y'                                      CSW207A 250804A
     C**********         Eval      PAcctyp = 'I'                                     CSW207A 250804A
     C**********         Call      'AOIBANR4'                                        CSW207A 250804A
     C**********         Parm      *Blanks       @RtCd                               CSW207A 250804A
     C**********         Parm      '*KEY'        @Optn                               CSW207A 250804A
     C**********         Parm                    P@IBAN                              CSW207A 250804A
      *****SDACCNT       Parm      SDACCNT       DSSDY                               CSW207A 250804A
     C**********                                                                     CSW207A 250804A
     C**********         If        @RtCd = *Blanks                                   CSW207A 250804A
     C**********         Move      IFCNUM        WCNUM                                CSW207 250804A
     C**********         Move      IFACOD        WACOD                                CSW207 250804A
     C**********         Move      IFACSQ        WACSQ                                CSW207 250804A
     C**********         Eval      PAcc = IFBRCA + WCNUM + IFCCY                      CSW207 250804A
     C**********                        + WACOD + WACSQ                               CSW207 250804A
     C**********         Eval      WCountry = %Subst(WSORC1:1:2)                     CSW207A 250804A
     C**********         EndIf                                                       CSW207A 250804A
      **********                                                                      CSW207 250804A
     C**********         Else                                                         CSW207 250804A
     C**********         If        SODMT <> *Blanks                                   CSW207 250804A
     C**********                   And WEntryType = 'O'                               CSW207 250804A
     C**********         Eval      PAcctyp = 'O'                                      CSW207 250804A
     C**********         EndIf                                                        CSW207 250804A
     C**********         EndIf                                                        CSW207 250804A
      *                                                                                      250804A
     C                   Eval      PAcc = PfAccnt                                            250804A
     C**********         Eval      PModI = 'FT'                                     250804A BUG25973
     C                   Eval      PModI = 'OP'                                             BUG25973
                                                                                              CSW207
     C                   Eval      PAcctyp = @ORCT                                          BUG15045
     C                   Call      'FT001000'                                                 CSW207
     C                   Parm      *Blanks       PRtCd             7                          CSW207
     C                   Parm      *Blanks       PMsgID            7                          CSW207
     C                   Parm      *Blank        PFlag             1                          CSW207
     C                   Parm      'TRAN'        PVTyp             4                          CSW207
     C                   Parm      SORC1         PFmtFld1         35                          CSW207
     C                   Parm      SORC2         PFmtFld2         35                          CSW207
     C                   Parm      SORC3         PFmtFld3         35                          CSW207
     C                   Parm      SORC4         PFmtFld4         35                          CSW207
     C                   Parm      SORC5         PFmtFld5         35                          CSW207
     C                   Parm                    PAcctyp           1                          CSW207
     C                   Parm                    PAcc             34                          CSW207
     C                   Parm                    PCust             6                          CSW207
     C**********         Parm      WNonAcct      PNAHo            10                  CSW207 250804A
     C                   Parm                    PNAHo            10                         250804A
     C                   Parm      WNetwork      PNtWrk            6                          CSW207
     C                   Parm      '103'         PMsgTp            3                          CSW207
     C                   Parm      WFieldTag     PMsgTag           5                          CSW207
     C                   Parm      WCountry      PCtry             2                          CSW207
     C**********         Parm      @BRCA         PBrch             3                 CSW207 BUG15037
     C                   Parm      WSbrca        PBrch             3                        BUG15037
     C                   Parm      SPCCY         PCurr             3                          CSW207
     C                   Parm      WNostro       PNostro           2                          CSW207
     C                   Parm                    PModI             2                          CSW207
     C                   Parm                    POut1            35                          CSW207
     C                   Parm                    POut2            35                          CSW207
     C                   Parm                    POut3            35                          CSW207
     C                   Parm                    POut4            35                          CSW207
     C                   Parm                    POut5            35                          CSW207
     C/COPY OFCPYSRCZ,CFT148_027                                                              CFT148
                                                                                              CSW207
     C                   If        PRtCd = '*ERROR'                                           CSW207
                                                                                              CSW207
     C                   If        PFlag = 'E'                                                CSW207
     C                   Eval      Idx = Idx + 1                                              CSW207
     C                   Eval      MsgIdXAr(Idx) = PMsgID                                     CSW207
     C                   Eval      RetCodeIn = 'Error'                                        CSW207
                                                                                              CSW207
     C                   Eval      OKORC1 = 'N'                                               CSW207
     C                   Eval      OKORC2 = 'N'                                               CSW207
     C                   Eval      OKORC3 = 'N'                                               CSW207
     C                   Eval      OKORC4 = 'N'                                               CSW207
     C                   Eval      OKORC5 = 'N'                                               CSW207
     C                   Eval      FldNamXAr(Idx) = 'SORC1'                                   CSW207
                                                                                              CSW207
     C                   If        %SUBST(#SORC1:1:1) <> '/'                                BUG15045
     C**********         If        #SORC5 <> *Blank                                BUG15045 BUG25092
     C                   IF        #SORC5 <> *Blank AND                                     BUG25092
     C                             %SUBST(#SORC2:1:2) <> '1/'                               BUG25092
      * as CFT032 is not Switchable 50K can be input with 5 lines                           BUG15045
     C                   Move      'N'           OKOrc5                                     BUG15045
     C                   Eval      Idx = Idx + 1                                            BUG15045
     C                   Eval      FldNamXAr(Idx) = 'SORC5'                                 BUG15045
     C                   Eval      MsgIdXAr(Idx) = 'MMA1410'                                BUG15045
     C                   EndIf                                                              BUG15045
     C                   Else                                                               BUG15045
      * If first line is starting with a '/', the second line must be entered               BUG15045
     C                   If        #SORC2 =  *Blank                                         BUG15045
     C                   Move      'N'           OKOrc2                                     BUG15045
     C                   Eval      Idx = Idx + 1                                            BUG15045
     C                   Eval      FldNamXAr(Idx) = 'SORC2'                                 BUG15045
     C                   Eval      MsgIdXAr(Idx) = 'MMA1429'                                BUG15045
     C                   EndIf                                                              BUG15045
     C                   EndIf                                                              BUG15045
                                                                                            BUG15045
     C                   ElseIf    PFlag = 'W'                                                CSW207
     C                   Eval      WIx = WIx + 1                                              CSW207
     C                   Eval      WMsgIdXAr(WIx) = PMsgID                                    CSW207
      *                                                                                      250804A
     C                   If        PMsgID = 'FTS0053'                                        250804A
     C**********         Eval      WMsgDtaXAr(WIx) =WNetwork                        250804A MD000091
     C                   EVAL      BLen = %Len(%Trim(WNetwork))                             MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = LenStr +%TRIM(WNetwork)                MD000091
     C                   ElseIf    PMsgID = 'FTS0054'                                        250804A
     C**********         Eval      WMsgDtaXAr(WIx) =WFieldTag                       250804A MD000091
     C                   EVAL      BLen = %Len(%Trim(WFieldTag))                            MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = LenStr +%TRIM(WFieldTag)               MD000091
     C                   Endif                                                               250804A
      *                                                                                      250804A
     C                   Eval      RetCodeIn = 'Error'                                        CSW207
                                                                                              CSW207
     C                   Eval      OKORC1 = 'W'                                               CSW207
     C                   Eval      OKORC2 = 'W'                                               CSW207
     C                   Eval      OKORC3 = 'W'                                               CSW207
     C                   Eval      OKORC4 = 'W'                                               CSW207
     C                   Eval      OKORC5 = 'W'                                               CSW207
     C                   Eval      WFldNmXAr(WIx) = 'SORC1'                                   CSW207
                                                                                              CSW207
     C                   EndIf                                                                CSW207
                                                                                              CSW207
     C                   EndIf                                                                CSW207
                                                                                              CSW207
     C**********         If        PRtCd = *Blanks And                             BUG15065 BUG25228
     C**********         IF        OKORC1 = 'Y' AND                                BUG25228 MD039547
     C                   IF        OKORC1 <> 'N' AND                                        MD039547
     C                             %SUBST(SORC1:1:1) <> '/' And                             BUG15065
     C                             SORC5 <> *Blank                                          BUG15065
     C                   If        %SUBST(SORC5:1:2) <> '1/' And                            BUG15065
     C                             %SUBST(SORC5:1:2) <> '2/' And                            BUG15065
     C                             %SUBST(SORC5:1:2) <> '3/' And                            BUG15065
     C                             %SUBST(SORC5:1:2) <> '4/' And                            BUG15065
     C                             %SUBST(SORC5:1:2) <> '5/' And                            BUG15065
     C                             %SUBST(SORC5:1:2) <> '6/' And                            BUG15065
     C                             %SUBST(SORC5:1:2) <> '7/' And                            BUG15065
     C                             %SUBST(SORC5:1:2) <> '8/'                                BUG15065
      * as CFT032 is not Switchable 50K can be input with 5 lines                           BUG15065
     C                   EVAL      OKORC1 = 'N'                                             BUG25228
     C                   EVAL      OKORC2 = 'N'                                             BUG25228
     C                   EVAL      OKORC3 = 'N'                                             BUG25228
     C                   EVAL      OKORC4 = 'N'                                             BUG25228
     C                   Move      'N'           OKOrc5                                     BUG15065
     C                   Eval      Idx = Idx + 1                                            BUG15065
     C                   Eval      FldNamXAr(Idx) = 'SORC5'                                 BUG15065
     C                   Eval      MsgIdXAr(Idx) = 'MMA1410'                                BUG15065
     C                   EndIf                                                              BUG15065
     C                   EndIf                                                              BUG15065
                                                                                            BUG15065
     C                   ENDSR                                                                CSW207
                                                                                              CSW207
      ************************************************************                            CSW207
      ** End                                                                                  CSW207
      ************************************************************                            CSW207
     C/EJECT                                                                                  CSW207
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
     C/COPY OFCPYSRCZ,CFT148_028                                                              CFT148

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtaXAr                                   240689
      ** OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
                                                                                              257361
      *  Funds Transfer Details                                                               257361
     C                   Parm                    SDFTFR                                       257361
     C                   Parm                    CFT142            1                          CFT142

      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Read SDRETLPD for retail details
      *  (database error handling done in access program)
      * Only if RETAIL switched on.
     C                   If        BGRTBN = 'Y'
     C                   CALLB     'AORETLR0'
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDRETL        Parm      SDRETL        DSFDY
     C                   End
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   Call      'SWIF2007'                                                 CSW207
     C                   Parm      *BLANKS       @RTCD                                        CSW207
     C                   If        @RTCD = 'CSW2007'                                          CSW207
     C                   Eval      CSW207 = 'Y'                                               CSW207
     C                   Else                                                                 CSW207
     C                   Eval      CSW207 = 'N'                                               CSW207
     C                   EndIf                                                                CSW207
     C                   Clear                   SDCUST                                      250804A

      * Key list for account validation
     C     AKEY          KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#CCY
     C                   KFLD                    K#ACOD
     C                   KFLD                    K#ACSQ
     C                   KFLD                    K#BRCA
     C                   If        CFT142 = 'Y'                                               CFT142
     C                   CALL      'AOSVALR0'                                                 CFT142
     C                   PARM      *BLANKS       @RtCd                                        CFT142
     C                   PARM      @IPDST0       P@OP01           20                          CFT142
     C                   PARM      *BLANKS       P@VL01          200                          CFT142
     C                   PARM      *BLANKS       P@OP02           20                          CFT142
     C                   PARM      *BLANKS       P@VL02          200                          CFT142
     C                   PARM      *BLANKS       P@OP03           20                          CFT142
     C                   PARM      *BLANKS       P@VL03          200                          CFT142
     C                   PARM      *BLANKS       P@OP04           20                          CFT142
     C                   PARM      *BLANKS       P@VL04          200                          CFT142
     C                   PARM      *BLANKS       P@OP05           20                          CFT142
     C                   PARM      *BLANKS       P@VL05          200                          CFT142
     C                   PARM      *BLANKS       P@OP06           20                          CFT142
     C                   PARM      *BLANKS       P@VL06          200                          CFT142
     C                   PARM      *BLANKS       P@OP07           20                          CFT142
     C                   PARM      *BLANKS       P@VL07          200                          CFT142
     C                   PARM      *BLANKS       P@OP08           20                          CFT142
     C                   PARM      *BLANKS       P@VL08          200                          CFT142
     C                   PARM      *BLANKS       P@OP09           20                          CFT142
     C                   PARM      *BLANKS       P@VL09          200                          CFT142
     C                   PARM      *BLANKS       P@OP10           20                          CFT142
     C                   PARM      *BLANKS       P@VL10          200                          CFT142
      *                                                                                       CFT142
     C                   IF        PRtcd <> *Blanks  AND                                      CFT142
     C                             PRtcd <> '*NRF   '                                         CFT142
     C                   MOVEL     'SDSVALPD'    DBFILE                                       CFT142
     C                   MOVEL     '902'         DBASE                                        CFT142
     C                   MOVEL     @IPDST0       DBKEY                                        CFT142
     C                   EXSR      *PSSR                                                      CFT142
     C                   ENDIF                                                                CFT142
     C                   ENDIF                                                                CFT142
     C*
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      *****************************************************************                       CFT032
     C/COPY FTCPYSRC,SFTSWFTCLE                                                               CFT032
      *****************************************************************                       CFT032
      /EJECT                                                                                  CFT032
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  SWCH  - Array of valid Swift characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/-?:().,'+abcdefghijklmnopqrstuvwxyz                     255286
