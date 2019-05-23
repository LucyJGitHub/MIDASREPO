     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Additional SWIFT Detail for Trade Maint.')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETSSIDSP - Display Additional SWIFT details for Trade       *
      *              maintenance                                      *
      *                                                               *
      *  Function:  This module will be called by SESSISIN to process *
      *             additional SWIFT details for trade                *
      *                                                               *
      *  Component of: SESSISIN - Standard Settlement Additional      *
      *                           Information                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR642262           Date 14Sep10               *
      *                 AR636523           Date 02Sep10               *
      *                 AR635847           Date 31Aug10               *
      *                 AR634357           Date 27Aug10               *
      *                 AR589197           Date 11Aug10               *
      *                 AR588640           Date 06Aug10               *
      *                 AR579549           Date 16Jul10               *
      *                 AR580857           Date 21Jul10               *
      *                 AR579693           Date 20Jul10               *
      *                 AR578911           Date 15Jul10               *
      *                 AR574149           Date 07Jul10               *
      *                 AR570983           Date 01Jul10               *
      *                 AR571002           Date 01Jul10               *
      *                 AR325342           Date 19May10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12357           Date 04Nov06               *
      *                 CSW206E            Date 24Aug06               *
      *                 CSW206D            Date 24Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 214012             Date 06Mar03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209934             Date 06Nov02               *
      *                 209247             Date 08Oct02               *
      *                 210278             Date 09Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 205141             Date 10May02               *
      *                 205663             Date 08May02               *
      *                 CSE034             Date 30Apr02               *
      *                 204804             Date 12Apr02               *
      *                 204585             Date 11Apr02               *
      *                 204751             Date 10Apr02               *
      *                 204704             Date 10Apr02               *
      *                 204753             Date 10Apr02               *
      *                 204364             Date 27Mar02               *
      *                 201429             Date 17Jan02               *
      *                 201486             Date 02Jan02               *
      *                 201190             Date 01Nov01               *
      *                 199797             Date 01Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028  *CREATE    Date 06Jun01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR642262 - Error in IBAN validation                          *
      *  AR636523 - Incorrect error message on some fields            *
      *  AR635847 - Acct for Payment, Acct w/ Institution, and        *
      *             Beneficiary of Money  were unable to display      *
      *             customer upon using '?'                           *
      *  AR634357 - Selected Customer is not displayed on the field   *
      *  AR589197 - The input validation of //xx has been removed if  *
      *             ISO15022 is switched on, it should be reapplied   *
      *             as the code is still used                         *
      *  AR588640 - Debtor: The second line is limited to 34          *
      *             characters if the first line contains a valid     *
      *             codeword                                          *
      *  AR579549 - Warning message for Swift entry in Debtor Address *
      *         Line 1 is not set on the screen                       *
      *  AR580857 - QFIN label is erroneous (Recompile)               *
      *  AR579693 - Customer has valid SWIFT address but has error    *
      *             during confirmation message request               *
      *  AR578911 - Remove slash and embedded blanks on IBAN input    *
      *  AR574149 - Confusing warning message for ISO Country code    *
      *             for IBAN                                          *
      *  AR570983 - Fields Intermediary 3 to 9 are displayed in the   *
      *             settlement details even if CSW206 is *ON          *
      *  AR571002 - SEST- Debtor address 1 inserted /DSS/ error       *
      *             message: SWIFT identifier was not found.          *
      *  AR325342 - Clearing correspondent field must not be displayed*
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  BUG12357 - Garbled screen being displayed.                   *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSW206D - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  214012 - Replace CALLB SEDORFRTV by CALL                     *
      *  209934 - Intermediary 9 field is independent of Intermediary *
      *           8 field                                             *
      *  209247 - Add Custodian and Safe A/c narrative                *
      *  210278 - MMM in SEST when Extended Settlement Instruction    *
      *           not in line with ISO                                *
      *  205141 - Intermediaries to be converted to SWIFT ID.         *
      *  205663 - Additional Screen for Customer SSI.                 *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  204804 - Clearing correspondent should accept customer no.   *
      *  204585 - Deliverer of Securities validation.                 *
      *  204751 - '?' processing for clearing correspondent.          *
      *  204704 - Intermediary field not validating 12th character.   *
      *  204753 - '?' not working properly in Deliverer of Securities *
      *  204364 - Clearing correspondent should also be validated     *
      *           against the BIC file.                               *
      *  201429 - New validation needed for ISO15022 in               *
      *           extended settlement screen.                         *
      *  201486 - Additional defaulting added for A/C lines.          *
      *  201190 - DBase error when amending Standard Settlement       *
      *           Information.                                        *
      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
      *  CSE028  -  Standing Settlement Instructions Enhancement      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Record not found                                *
      *    03         Roll Up is on                                   *
      *    04         Roll down is on                                 *
      *                                                               *
      ** Error Indicators                                             *
      *                                                               *
      ** Screen one for internal customer                             *
      *                                                               *
      *    10         Error on a/c with institution number            *
      *    11         Error on a/c with institution line              *
      *    12         Error on a/c for payment number                 *
      *    13         Error on a/c for payment line                   *
      *    14         Error on beneficiary of money number            *
      *    15         Error on beneficiary of money line 1            *
      *    16         Error on beneficiary of money line 2            *
      *    17         Error on sender to receiver info line 1         *
      *    18         Error on sender to receiver info line 2         *
      *    19         Error on sender to receiver info line 3         *
      *    20         Error on narrative for cash parties line 1      *
      *    21         Error on narrative for cash parties line 2      *
      *                                                               *
      ** Screen one for non-internal customer                         *
      *                                                               *
      *    22         Error on settlement message request             *
      *    23         Error on confirmation message request           *
      *    24         Error on instruction type                       *
      *    25         Error on instruction sub-type                   *
      *    26         Error on requested priority                     *
      *    27         Error on guaranteed delivery                    *
      *    28         Error on sender's role                          *
      *    29         Error on stamp status                           *
      *    30         Error on charity identifier                     *
      *    31         Error on transaction report maker               *
      *    32         Error on settlement against payment/free        *
      *                                                               *
      ** Screen two for trade purchase                                *
      *                                                               *
      *    33         Error on clearing correspondents                *
      *    34         Error on deliverer of securities number         *
      *    35         Error on deliverer of securities line 1         *
      *    36         Error on deliverer of securities line 2         *
      *    37         Error on deliverer of securities line 3         *
      *    38         Error on deliverer of securities line 4         *
      *    39         Error on further information line 1             *
      *    40         Error on further information line 2             *
      *    41         Error on registration details line 1            *
      *    42         Error on registration details line 2            *
      *    43         Error on narrative line 1                       *
      *    44         Error on narrative line 2                       *
      *                                                               *
      ** Screen two for trade sale                                    *
      *                                                               *
      *    45         Error on clearing correspondents                *
      *    46         Error on deliverer of securities number         *
      *    47         Error on deliverer of securities line 1         *
      *    48         Error on deliverer of securities line 2         *
      *    49         Error on deliverer of securities line 3         *
      *    50         Error on deliverer of securities line 4         *
      *    51         Error on beneficiaries securities number        *
      *    52         Error on beneficiaries securities line 1        *
      *    53         Error on beneficiaries securities line 2        *
      *    54         Error on further information line 1             *
      *    55         Error on further information line 2             *
      *    56         Error on registration details line 1            *
      *    57         Error on registration details line 2            *
      *    58         Error on narrative line 1                       *
      *    59         Error on narrative line 2                       *
      *                                                               *
      ** Screen three                                                 *
      *                                                               *
      *    60         Error on settlement party 1                     *
      *    61         Error on safekeeping account 1                  *
      *    62         Error on settlement party 2                     *
      *    63         Error on safekeeping account 2                  *
      *    64         Error on settlement party 3                     *
      *    65         Error on safekeeping account 3                  *
      *    66         Error on settlement party 4                     *
      *    67         Error on safekeeping account 4                  *
      *    68         Error on settlement party 5                     *
      *    69         Error on safekeeping account 5                  *
      *    70         Error on settlement party 6                     *
      *    71         Error on safekeeping account 6                  *
      *    72         Error on settlement party 7                     *
      *    73         Error on safekeeping account 7                  *
      *    74         Error on settlement party 8                     *
      *    75         Error on safekeeping account 8                  *
      *    76         Error on settlement party 9                     *
      *    77         Error on safekeeping account 9                  *
      *    78         Error on place of settlement                    *
      *    79         Protect settlement against payment/free field   *
      *    80         Trade Purchase displayed (trades sale if off)   *
      *    81         Display customer (if off, display book)         *
      *    82         Protect all input capable fields                *
      *    83         Display fields if ISOMsg is 'Y'                 *
      *    84         Display portfolio reference                     *
      *    86         Look up found                                   *
      *    87         Error variable                                  *
      *    88         Display roll up                                 *
      *    89         Display roll down                               *
      *                                                               *
      *    90         CSE029 is on                                    *                       209247
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit       -  Initial Processing                           *
      *  SRDefault    -  Setup default template                       *
      *  SRRetrieve   -  Retrieve existing details                    *
      *  SRSetScnFld1 -  Set-up screen 1 display fields               *
      *  SRSetScnFld2 -  Set-up screen 2 display fields               *
      *  SRSetScnFld3 -  Set-up screen 3 display fields               *
      *  SRDisplay0   -  Display additional SSI for swift screen 0    *                       205663
      *  SRDisplay1   -  Display additional SSI for swift screen 1    *
      *  SRDisplay2   -  Display additional SSI for swift screen 2    *
      *  SRDisplay3   -  Display additional SSI for swift screen 3    *
      *  SRValidate1  -  Validate screen 1 fields                     *
      *  SRValidate2  -  Validate screen 2 fields                     *
      *  SRValidate3  -  Validate screen 3 fields                     *
      *  SRUpdate     -  Update additional standard settlement        *
      *                  instructions                                 *
      *  SRReturn     -  Return to calling program                    *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSETSSIDSDFCF   E             WORKSTN INFSR(*PSSR)

      ** Midas SD Customers by unique SWIFT ID                                                199797
     FSDCUSTL7  IF   E           K DISK    RENAME(@CUSTGE:SDCUSTSW)                           199797
                                                                                              199797
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

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
      **    False      logical = *off (for indicator processing)
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

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.

     D/COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY includes the MM standard declares:

     D/COPY ZACPYSRC,STDDECLARE

      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.

     D/COPY ZACPYSRC,MSGHNDDCL

      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.

     D/COPY ZACPYSRC,APICTLARR

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

      **********/COPY FTCPYSRC,SFTVALCSLL                                            CSW210 AR570983
      * Named Constant used to determine if a field contains invalid                        AR570983
      * characters for Telex and S.W.I.F.T.                                                 AR570983
                                                                                            AR570983
     D ISO             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-                     AR570983
     D                                      abcdefghijklmnopqrstuvwxyz-                     AR570983
     D                                      1234567890 /+-?:().,'''                         AR570983
                                                                                            AR570983
      * Named Constant used to determine if a field is alphabetic                           AR570983
                                                                                            AR570983
     D ALPHAB          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                     AR570983
                                                                                            AR570983
      * Named Constant used to determine if a field is alphabetic                           AR570983
      * with numbers                                                                        AR570983
                                                                                            AR570983
     D ALPHAN          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-                     AR570983
     D                                     1234567890'                                      AR570983
                                                                                              CSW210
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             02     02
     D  RollUp                03     03
     D  RollDn                04     04
     D  PrtSAPfld             79     79
     D  DspPuch               80     80
     D  DspCustomer           81     81
     D  PrtFlds               82     82
     D  DspISOMsgFlds         83     83
     D  DspPortF              84     84
     D  LookUpFnd             86     86
     D  ErrVar                87     87
     D  DspRollUp             88     88
     D  DspRollDn             89     89

     D CCTNArr         S              1    DIM(12)
     D WErrIndArr      S              1    DIM(69)
     D WIMDArr         S             12    DIM(9)

     D WInzIndArr      S              1    DIM(69) CTDATA PERRCD(69)
     D WInzOkFlags     S              1    DIM(69) CTDATA PERRCD(69)

      ** Array for alphanumber validations
     D VA0             S              1    DIM(36) CTDATA PERRCD(36)

      ** Array for Instructions type validation (alphabetic)
     D VA1             S              3    DIM(10) CTDATA PERRCD(10)

      ** IBAN character test arrays                                                           CSW210
     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)                          CSW210
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)                          CSW210
                                                                                              CSW210
     D PrevMsg         S             52A   DIM(PrevArray)                                     CSW210
     D PrevFlg         S              1A                                                      CSW210
     D IBANFlg         S              1A                                                      CSW210
                                                                                              CSW210
     D MsgLine         DS            52                                                       CSW210
     D  WFldNam                1     10                                                       CSW210
     D  WMsgID                11     17                                                       CSW210
     D  WFldVal               18     52                                                       CSW210
                                                                                              CSW210
      ** External DS branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** External DS customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFC1        E                     EXTFLD(QQDFAC)                                     CGL029

      ** External DS security customer details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)

      ** External DS for book code details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)

      ** External DS for currency code details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for counterparty nostro details
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)

      ** External DS for BIC directory details
     DMEBICD         E DS                  EXTNAME(MEBICDPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** DS for STDADSED to passed to SETSSIDSP or SEDSSIDSP
     D PAddSetD      E DS                  EXTNAME(STDADSED)
     D                                     Prefix(PA:2)

      * Validation Work Fields                                                                CSW210
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)                                CSW210
                                                                                              CSW210
      **********/COPY FTCPYSRC,SFTADDRILE                                            CSW210 AR570983
     D                 DS                                                                   AR570983
                                                                                            AR570983
      * Data Structure redefining Address fields                                            AR570983
     D  ADDRSS                 1    140                                                     AR570983
     D  ADCHK1                 1     35                                                     AR570983
     D  ADCHK2                36     70                                                     AR570983
     D  ADCHK3                71    105                                                     AR570983
     D  ADCHK4               106    140                                                     AR570983
                                                                                            AR570983
      * Blank Line Analysis data structure                                                  AR570983
     D  ADCH26                36    140                                                     AR570983
     D  ADCH36                71    140                                                     AR570983
                                                                                            AR570983
      * SWIFT Address Analysis data structure                                               AR570983
     D  ADSLSH                 1      1                                                     AR570983
     D  ADEXSW                12     35                                                     AR570983
                                                                                              CSW210
     D SACBDS          DS           140                                                       CSW210
     D  DSACB1Pos1             1      1                                                       CSW210
     D  DSACB1                 1     35                                                       CSW210
     D  DSACB2                36     70                                                       CSW210
     D  DSACB234              70     70                                                     AR588640
     D  DSACB3                71    105                                                       CSW210
     D  DSACB4               106    140                                                       CSW210
      ** CODEWORD Analysis Data Structure                                                     CSW210
     D  CDEWRD                 2      9                                                       CSW210
     D  DSACB1Pos2             2      2                                                       CSW210
     D  DSACB1Po10            10     10                                                       CSW210
     D  DSACB1Excs            11     35                                                       CSW210
                                                                                              CSW210
     DCLSWTK           DS                                                                     CSW210
     D SW                      1     12                                                       CSW210
                                                                                              CSW210
      ** OK Flags
     D OkFlags         DS            69

      ** Screen 1 for internal
     D  AWINOK                 1      1                                         Ind 10
     D  AWILOK                 2      2                                         Ind 11
     D  AFPNOK                 3      3                                         Ind 12
     D  AFPLOk                 4      4                                         Ind 13
     D  BOFNOk                 5      5                                         Ind 14
     D  BOF1Ok                 6      6                                         Ind 15
     D  BOF2Ok                 7      7                                         Ind 16
     D  SRL1Ok                 8      8                                         Ind 17
     D  SRL2Ok                 9      9                                         Ind 18
     D  SRL3Ok                10     10                                         Ind 19
     D  NAC1Ok                11     11                                         Ind 20
     D  NAC2Ok                12     12                                         Ind 21

      ** Screen 1 for non-internal
     D  GMESOk                13     13                                         Ind 22
     D  CONGOk                14     14                                         Ind 23
     D  INSTOK                15     15                                         Ind 24
     D  INSSOK                16     16                                         Ind 25
     D  RPTYOK                17     17                                         Ind 26
     D  GDELOk                18     18                                         Ind 27
     D  SROLOk                19     19                                         Ind 28
     D  STMPOk                20     20                                         Ind 29
     D  CHIDOk                21     21                                         Ind 30
     D  TRRMOk                22     22                                         Ind 31
     D  FINDOk                23     23                                         Ind 32

      ** Screen 2 for purchase
     D  PCCTNOk               24     24                                         Ind 33
     D  PDRSNOk               25     25                                         Ind 34
     D  PDRS1Ok               26     26                                         Ind 35
     D  PDRS2Ok               27     27                                         Ind 36
     D  PDRS3Ok               28     28                                         Ind 37
     D  PDRS4Ok               29     29                                         Ind 38
     D  PFIN1Ok               30     30                                         Ind 39
     D  PFIN2Ok               31     31                                         Ind 40
     D  PRED1Ok               32     32                                         Ind 41
     D  PRED2Ok               33     33                                         Ind 42
     D  PNAS1Ok               34     34                                         Ind 43
     D  PNAS2Ok               35     35                                         Ind 44

      ** Screen 2 for sale
     D  SCCTNOk               36     36                                         Ind 45
     D  SDRSNOk               37     37                                         Ind 46
     D  SDRS1Ok               38     38                                         Ind 47
     D  SDRS2Ok               39     39                                         Ind 48
     D  SDRS3Ok               40     40                                         Ind 49
     D  SDRS4Ok               41     41                                         Ind 50
     D  BSSNOK                42     42                                         Ind 51
     D  BSS1OK                43     43                                         Ind 52
     D  BSS2OK                44     44                                         Ind 53
     D  SFIN1Ok               45     45                                         Ind 54
     D  SFIN2Ok               46     46                                         Ind 55
     D  SRED1Ok               47     47                                         Ind 56
     D  SRED2Ok               48     48                                         Ind 57
     D  SNAS1Ok               49     49                                         Ind 58
     D  SNAS2Ok               50     50                                         Ind 59

      ** Screen 3
     D  IMMD1Ok               51     51                                         Ind 60
     D  IMSA1Ok               52     52                                         Ind 61
     D  IMMD2Ok               53     53                                         Ind 62
     D  IMSA2Ok               54     54                                         Ind 63
     D***IMMD3Ok               55     55                                         Ind 64      CSW206D
     D***IMSA3Ok               56     56                                         Ind 65      CSW206D
     D***IMMD4Ok               57     57                                         Ind 66      CSW206D
     D***IMSA4Ok               58     58                                         Ind 67      CSW206D
     D***IMMD5Ok               59     59                                         Ind 68      CSW206D
     D***IMSA5Ok               60     60                                         Ind 69      CSW206D
     D***IMMD6Ok               61     61                                         Ind 70      CSW206D
     D***IMSA6Ok               62     62                                         Ind 71      CSW206D
     D***IMMD7Ok               63     63                                         Ind 72      CSW206D
     D***IMSA7Ok               64     64                                         Ind 73      CSW206D
     D***IMMD8Ok               65     65                                         Ind 74      CSW206D
     D***IMSA8Ok               66     66                                         Ind 75      CSW206D
     D***IMMD9Ok               67     67                                         Ind 76      CSW206D
     D***IMSA9Ok               68     68                                         Ind 77      CSW206D
     D***PSETOk*               69     69                                         Ind 78      CSW206D
     D***PSETOk*              55     55                                      8       CSW206D CSW206E
     D  IMMD3Ok               55     55                                         Ind 64       CSW206E
     D  IMSA3Ok               56     56                                         Ind 65       CSW206E
     D  IMMD4Ok               57     57                                         Ind 66       CSW206E
     D  IMSA4Ok               58     58                                         Ind 67       CSW206E
     D  IMMD5Ok               59     59                                         Ind 68       CSW206E
     D  IMSA5Ok               60     60                                         Ind 69       CSW206E
     D  IMMD6Ok               61     61                                         Ind 70       CSW206E
     D  IMSA6Ok               62     62                                         Ind 71       CSW206E
     D  IMMD7Ok               63     63                                         Ind 72       CSW206E
     D  IMSA7Ok               64     64                                         Ind 73       CSW206E
     D  IMMD8Ok               65     65                                         Ind 74       CSW206E
     D  IMSA8Ok               66     66                                         Ind 75       CSW206E
     D  IMMD9Ok               67     67                                         Ind 76       CSW206E
     D  IMSA9Ok               68     68                                         Ind 77       CSW206E
     D  PSETOk                69     69                                         Ind 78       CSW206E

      ** DS for breakdown of 35 char line
     D  DSLen35        DS            35
     D   WWLI35                1     35
     D   WW0507                5      7
     D   WW0510                5     10
     D   WW0512                5     12
     D   WW0513                5     13
     D   WW0535                5     35
     D   WW0835                8     35
     D   WW1135               11     35
     D   WW1335               13     35
     D   WW1435               14     35

      ** DS for input parm of ME9940
      ** ============================
     D**DSIParm        DS           512                                                       CGL029
     D  DSIParm        DS           514                                                       CGL029
      ** Field to be validated
     D   I#VFLD                1      5
      ** Pay/Receive settlement (PAY/REC)
     D   I#PR                  6      8
      ** Customer/Counterparty Nostro /BIC indentified type
      **    C           X              S  X-> C'party Nostro or Customer
      ** Customer/Counterparty/BIC indentified
     D   I#PRTT                9      9
     D   I#PRTY               10     20
      ** Pay Currency
      ** Receive Currency
     D   I#PCCY               21     23
     D   I#RCCY               24     26
      ** Account Line
      ** Account Line Character 1
      ** Account Line Character 2
      ** Account Line Character 3
      ** Account Line first 4 characters
     D   I#ACLN               27     61
     D   I#ACC1               27     27
     D   I#ACC2               28     28
     D   I#ACC3               29     29
     D   I#ACCL               27     30
      ** Account Line Clearing System
      ** Account Line No account data
      ** Message Type
     D   I#ACCS               29     30
     D   I#SPC1               31     61
     D   I#MTYP               62     64
      ** Intermediary Institution for Bank to Bank validation
     D   I#INBT               65     65
     D   I#INBK               66     76
      ** Account with Institution for Bank to Bank validation
     D   I#AWBT               77     77
     D   I#AWBK               78     88
      ** Beneficiary for Bank to Bank validation
     D   I#BENT               89     89
     D   I#BENF               90    100
      ** Pay and Receive Settlement Methods
     D   I#RSTM              101    102
     D   I#PSTM              103    104
      ** Field 53 and 54 Entered
      ** Midas Module
     D   I#5354              105    105
     D   I#MMOD              106    107
      ** Pay and Receive Settlement Accounts
     D***I#PYAC*             108    125                                                       CGL029
     D***I#RCAC*             126    143                                                       CGL029
     D   QQPYAC              108    125                                                       CGL029
     D   QQRCAC              126    143                                                       CGL029
      ** Transaction Type
      ** Cover required
     D   I#TTYP              144    145
     D   I#COVR              146    146
      ** Bank to Bank Information
     D   I#BTB               257    466
     D   I#BTB1              257    291
     D   I#BTB2              292    326
     D   I#BTB3              327    361
     D   I#BTB4              362    396
     D   I#BTB5              397    431
     D   I#BTB6              432    466
     D   I#PYAC              467    490                                                       CGL029
     D   I#RCAC              491    514                                                       CGL029

      ** DS for output parm of ME9940
      ** ============================
     D**DSOParm        DS           512                                                       CGL029
     D  DSOParm        DS           514                                                       CGL029
      ** Account Line modified
     D   O#ACLN                1     35
      ** Bank to Bank Information
     D   O#BTB               257    466
     D   O#BTB1              257    291
     D   O#BTB2              292    326
     D   O#BTB3              327    361
     D   O#BTB4              362    396
     D   O#BTB5              397    431
     D   O#BTB6              432    466

      ** DS for error parm of ME9940
      ** ============================
     D  DSEParm        DS           256
      ** Calling program
      ** Error message sent
      ** Warning message sent
      ** Error index
     D   E#CPGM                1     10
     D   E#ERRM               12     12
     D   E#WARN               13     13
     D   E#INDX               14     18S 0
      ** Message text to prefix error message
     D   E#MSGD               19     25
     D   E#MSGF               26     35
      ** Error codes array
     D   E#ERCD               51    200
     D   O#E                  51    200

      ** KMGECO data structure
     D                 DS
     D  W_GECO                 1     20
     D  W_DEST                 1      5
     D  W_INST                 6     12
     D  W_INSS                13     20

      ** DS for Intermediary Fields

     D WInterMed       DS
     D #5IMMD1                 1     12
     D #5IMMD2                13     24
     D***#5IMMD3                25     36                                                    CSW206D
     D***#5IMMD4                37     48                                                    CSW206D
     D***#5IMMD5                49     60                                                    CSW206D
     D***#5IMMD6                61     72                                                    CSW206D
     D***#5IMMD7                73     84                                                    CSW206D
     D***#5IMMD8                85     96                                                    CSW206D
     D***#5IMMD9                97    108                                                    CSW206D
     D #5IMMD3                25     36                                                      CSW206E
     D #5IMMD4                37     48                                                      CSW206E
     D #5IMMD5                49     60                                                      CSW206E
     D #5IMMD6                61     72                                                      CSW206E
     D #5IMMD7                73     84                                                      CSW206E
     D #5IMMD8                85     96                                                      CSW206E
     D #5IMMD9                97    108                                                      CSW206E

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     ** Entry Parameter
     D PAdDType        S              1A
     D PBranch         S              3A
     D PCustomer       S              6A
     D*PCustNum*       S              6S 0                                                    CSD027
     D PCustNum        S              6A                                                      CSD027
     D PCustKey        S             10A
     D PKeySts         S              7A
     D PBook           S              2A
     D PCcy            S              3A
     D PMktCtr         S              2A                                                      CSE034
     D PInvType        S              3A
     D PPorRef         S              4A
     D PCBInd          S              1A
     D PDescrptn       S             20A
     D PISOMsgI        S              1A
     D PForDpmI        S              1A
     D PBJMRDT         S              7A
     D PBGPFMG         S              1A
     D PBGN4ST         S              1A
     D PBFCLAS         S              1A
     D PCSW014         S              1A
     D PCSW098         S              1A
     D PCSW210         S              1A                                                      CSW210
     D PCFT004         S              1A                                                      CSW210
     D PCFT007         S              1A
     D PCSE029         S              1A                                                      209247
     D PCSW202         S              1A                                                    AR325342
     D PCSW201         S              1A                                                    AR571002

     D PMode           S              1A
     D POType          S              1A
     D PRetCode        S                   LIKE(ReturnCode)

     D WCnBk           S              4A
     D W#ISCD          S              4A
     D WZ#Parm         S            256A
     D WACLN           S             35A
     D WAWBK           S             35A
     D WBENF           S             35A
     D WBNBI           S              1A
     D WCSID           S             12A
     D WFWCD           S              9S 0
     D WCustType       S              1A
     D WErrImmd        S              1A
     D WErrImsa        S              1A
     D WErr35          S              1A
     D WErr35Msg       S              7A
     D WICNIL          S              1A
     D WKBICC          S              1A
     D WKBICI          S              1A
     D WKBICS          S              1A
     D WKCCTN          S             12A
     D WKCSID8         S              8A
     D WKCSID4         S              4A
     D WKCSID3         S              3A
     D WKDRSN          S             10A
     D WKDRS1          S             35A
     D WKDRS2          S             35A
     D WKDRS3          S             35A
     D WKDRS4          S             35A
     D WKFIN1          S             35A
     D WKFIN2          S             35A
     D WKRED1          S             35A
     D WKRED2          S             35A
     D WKNAS1          S             35A
     D WKNAS2          S             35A
     D WKSRL1          S              1A
     D WWSRL1          S              1A
     D WWSRL2          S              1A
     D WWSRL3          S              1A
     D WWVALI          S              1A
     D WWAFPL          S              1A
     D WWALP3          S              3A
     D WWALP6          S              6A
     D WWALP8          S              8A
     D WWALP9          S              9A
     D WWAWIL          S              1A
     D WWBLCD          S              8A
     D WWBNBI          S              1A
     D WWCABA          S              3S 0
     D WWCHID          S              6S 0
     D WWCHSC          S              6S 0
     D WWCSID          S             12A
     D WWFWCD          S              9A
     D WWBOF1          S              1A
     D WWBOF2          S              1A
     D WWBSS1          S              1A
     D WWBSS2          S              1A
     D WWDRS1          S              1A
     D WWDRS2          S              1A
     D WWDRS3          S              1A
     D WWDRS4          S              1A
     D WWFIN1          S              1A
     D WWFIN2          S              1A
     D WWIMMD          S             12A
     D WWIMSA          S             20A
     D WWLI01          S              1A
     D WWLI02          S              2A
     D WWLI04          S              4A
     D WWLI05          S              5A
     D WWLI19          S             19A
     D WWLI33          S             33A
     D WWLI34          S             34A
     D WWNAC1          S              1A
     D WWNAC2          S              1A
     D WWNAS1          S              1A
     D WWNAS2          S              1A
     D WWRED1          S              1A
     D WWRED2          S              1A
     D WWSAFA1         S              1A
     D WWNUM4          S              4S 0
     D WWNUM7          S              7S 0
     D WWNUM9          S              9S 0
     D WWNU10          S             10S 0
     D WWSR04          S              4A
     D WWSR06          S              6A
     D WWSR07          S              7A
     D WWSR08          S              8A
     D WWSR10          S             10A
     D WInit           S              1A
     D***WPInterMed      S            108A                                                   CSW206D
     D***WPInterMed      S             24A                                           CSW206D CSW206E
     D WPInterMed      S            108A                                                     CSW206E
     D WPPSET          S             12A
     D WPQFIN          S             12A                                                    AR634357
     D WWPCL1          S             12A                                                    AR634357
     D WWDBTR          S             12A                                                    AR634357
     D WWAFPN          S             12A                                                    AR635847
     D WWAWIN          S             12A                                                    AR635847
     D WWBOFN          S             12A                                                    AR635847
     DCSW206           S              1                                                      CSW206E

      ** Index for arrays of error message ids
     D Idx             S              3P 0
     D WIdx            S              3P 0                                                    CSW210
     D WCtr1           S              3P 0
     D WCtr2           S              3P 0
     D WCtr3           S              3P 0

      ** Return Code                                                                          201486
     D PReturnCode     S             10                                                       201486
                                                                                              201486
      ** Entry Depot Customer Number                                                          201486
     D PDepotCnum      S              6                                                       201486
                                                                                              201486
      ** Entry Counterparty Customer Number                                                   201486
     D PCntrPCNum      S              6                                                       201486
                                                                                              201486
      ** Safekeeping Account Reference                                                        201486
     D PSKALRef        S             20                                                       201486
                                                                                              201486
     D OkDRSN          S              1    INZ(*BLANKS)                                       201486
     D WAGNA           S              1    INZ(*BLANKS)                                       201486
     D WANGA           S              1    INZ(*BLANKS)                                       201486
     D WAANG           S              1    INZ(*BLANKS)                                       201486
     D T1AWIN          S                   LIKE(#1AWIN) INZ(*BLANKS)                          201486
     D T1AFPN          S                   LIKE(#1AFPN) INZ(*BLANKS)                          201486
     D T1BOFN          S                   LIKE(#1BOFN) INZ(*BLANKS)                          201486
     D T4BSSN          S                   LIKE(#4BSSN) INZ(*BLANKS)                          201486
     D TkDRSN          S                   LIKE(WkDRSN) INZ(*BLANKS)                          201486
     D TWIMMD          S                   LIKE(WWIMMD) INZ(*BLANKS)                          201486
     D T5IMMD1         S                   LIKE(WWIMMD) INZ(*BLANKS)                          201486
     D T5IMMD2         S                   LIKE(WWIMMD) INZ(*BLANKS)                          201486
     D T5IMMD3         S                   LIKE(WWIMMD) INZ(*BLANKS)                          201486
     D T5IMMD4         S                   LIKE(WWIMMD) INZ(*BLANKS)                          201486
     D T5IMMD5         S                   LIKE(WWIMMD) INZ(*BLANKS)                          201486
     D T5IMMD6         S                   LIKE(WWIMMD) INZ(*BLANKS)                          201486
     D T5IMMD7         S                   LIKE(WWIMMD) INZ(*BLANKS)                          201486
     D T5IMMD8         S                   LIKE(WWIMMD) INZ(*BLANKS)                          201486
     D T5IMMD9         S                   LIKE(WWIMMD) INZ(*BLANKS)                          201486
                                                                                              201486
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))

     D ADLINE          S              1                                                       CSW210
     D ADSLON          S              1                                                       CSW210
     D ##CSID          S              1A                                                      CSW210
     D C#RTCD          S              7                                                       CSW210
     D C#OPTN          S              7                                                       CSW210
     D C#CNUM          S             10                                                       CSW210
     D C#KYST          S              7                                                       CSW210
                                                                                              CSW210
      ** SWIFT 2010 Additional Fields OK Flags                                                CSW210
                                                                                              CSW210
      ** For Screen 1                                                                         CSW210
                                                                                              CSW210
     D DbtrOk          S              1A                                                      CSW210
     D DActOk          S              1A                                                      CSW210
     D DAd1Ok          S              1A                                                      CSW210
     D DAd2Ok          S              1A                                                      CSW210
     D DAd3Ok          S              1A                                                      CSW210
     D DAd4Ok          S              1A                                                      CSW210
                                                                                              CSW210
      ** For Screen 3                                                                         CSW210
                                                                                              CSW210
     D ReD1Ok          S              1A                                                      CSW210
     D ReD2Ok          S              1A                                                      CSW210
     D PClrOk          S              1A                                                      CSW210
     D QFInOk          S              1A                                                      CSW210
                                                                                              CSW210
     D***PrevArray       C                   Const(4)                                CSW210 AR579549
     D PrevArray       C                   Const(5)                                         AR579549
     D XAFPL           C                   Const('A/c for Payment Account +                   CSW210
     D**********                                  Line 1')                           CSW210 AR574149
     D                                            Line')                                    AR574149
     D XDACL           C                   Const('Debtor Account Line')                       CSW210
     D XAWIL           C                   Const('A/c with Institution +                      CSW210
     D                                              Account Line')                            CSW210
     D XBOF1           C                   Const('Beneficiary of Money +                      CSW210
     D                                            Account Line')                              CSW210
     D W@              S              5S 0                                                  AR571002
     D W@L             S              5S 0                                                  AR571002
     D W@P             S              5S 0                                                  AR571002
     D W@SBBL          S             32A                                                    AR571002
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

      *********************************************************************
      * Main Procedure                                                    *
      *********************************************************************

      ** Initial processing

     C                   IF        WInit = ' '
     C                   EXSR      SRInit
     C                   ENDIF
                                                                                              205663
      ** Do while screen: Screen                                                              205663
                                                                                              205663
     C                   DOW       PMode = '0'                                                205663
     C                   EXSR      SRDisplay0                                                 205663
     C                   ENDDO                                                                205663

      ** Do while screen: Screen 1

     C                   DOW       PMode = '1'
     C                   EXSR      SRDisplay1
     C                   ENDDO

      ** Do while screen: Screen 2

     C                   DOW       PMode = '2'
     C                   EXSR      SRDisplay2
     C                   ENDDO

      ** Do while screen: Screen 3

     C                   DOW       PMode = '3'
     C                   EXSR      SRDisplay3
     C                   ENDDO

      ** Update

     C                   IF        PMode = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF

      **  Return

     C                   IF        PMode = 'R'
     C                   EXSR      SRReturn
     C                   ENDIF

      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      *                                                               *
      *  SRInit - Initial Processing                                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR

      *                                                                                     AR571002
      ** Check to see if switchable feature CSW201 is on                                    AR571002
      *                                                                                     AR571002
     C                   CALL      'SWIF2001'                                               AR571002
     C                   PARM      *BLANKS       PRetrnCde         7                        AR571002
                                                                                            AR571002
     C                   IF        PRetrnCde = 'CSW2001'                                    AR571002
     C                   EVAL      PCSW201 = 'Y'                                            AR571002
     C                   ELSE                                                               AR571002
     C                   EVAL      PCSW201 = 'N'                                            AR571002
     C                   ENDIF                                                              AR571002
      ** Check if SWIFT Changes 2010 (CSW210) is installed                                    CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
     C                   EVAL      *IN98 = *ON                                                CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      *IN98 = *OFF                                               CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EVAL      WInit = 'Y'
     C                   EVAL      WAGNA = *BLANKS                                            201486
     C                   EVAL      WANGA = *BLANKS                                            201486
     C                   EVAL      WAANG = *BLANKS                                            201486
     C                   EVAL      T1AWIN = *BLANKS                                           201486
     C                   EVAL      T1AFPN = *BLANKS                                           201486
     C                   EVAL      T1BOFN = *BLANKS                                           201486
     C                   EVAL      T4BSSN = *BLANKS                                           201486
     C                   EVAL      TkDRSN = *BLANKS                                           201486
     C                   EVAL      TWIMMD = *BLANKS                                           201486
     C                   EVAL      T5IMMD1 = *BLANKS                                          201486
     C                   EVAL      T5IMMD2 = *BLANKS                                          201486
     C                   EVAL      T5IMMD3 = *BLANKS                                          201486
     C                   EVAL      T5IMMD4 = *BLANKS                                          201486
     C                   EVAL      T5IMMD5 = *BLANKS                                          201486
     C                   EVAL      T5IMMD6 = *BLANKS                                          201486
     C                   EVAL      T5IMMD7 = *BLANKS                                          201486
     C                   EVAL      T5IMMD8 = *BLANKS                                          201486
     C                   EVAL      T5IMMD9 = *BLANKS                                          201486
     C                   EVAL      PSKALReF = *BLANKS                                         201486
     C                   EVAL      PDepotCNum = *BLANKS                                       201486
     C                   EVAL      PCntrPCNum = *BLANKS                                       201486
                                                                                              201486
     C**********         CALLB     'AOBRCHR0'                                          201486 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD             7                          201486
     C                   PARM      '*KEY   '     POPTN             7                          201486
     C                   PARM      PBranch       PBA               3                          201486
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 201486 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029

      ** Condition display/non-display of customer or book field,
      ** only one field should appear

     C                   IF        PCBInd = 'C'
     C                   EVAL      DspCustomer = True
     C                   ELSE
     C                   EVAL      DspCustomer = False
     C                   ENDIF

      ** Display Custodian and Safe A/C                                                       209247
     C                   EVAL      *IN90 = *OFF                                               209247
     C                   IF        PCSE029 = 'Y'                                              209247
     C                   EVAL      *IN90 = *ON                                                209247
     C                   ENDIF                                                                209247
     C*                                                                                       209247
     C                   IF        PCSW202 = 'Y'                                            AR325342
     C                   EVAL      *IN08 = '1'                                              AR325342
     C                   ELSE                                                               AR325342
     C                   EVAL      *IN08 = '0'                                              AR325342
     C                   ENDIF                                                              AR325342
                                                                                            AR325342
      ** Condition display/non-diplay of "Portfolio" field

     C                   IF        PBGPFMG = 'Y' OR PBGN4ST = 'Y'
     C                   EVAL      DspPortF = True
     C                   IF        PBFCLAS = 'I' OR PCBInd = 'B'
     C                   EVAL      DspPortF = False
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DspPortF = False
     C                   ENDIF

      ** Check if proceesing is for trade purchase or trade sale

     C                   IF        PAdDType = 'P'
     C                   EVAL      DspPuch = True
     C                   ELSE
     C                   EVAL      DspPuch = False
     C                   ENDIF

      ** Check if ISO15022 message indicator is set to 'Y'

     C                   IF        PISOMsgI = 'Y'
     C                   EVAL      DspISOMSgFlds = True
     C                   ELSE
     C                   EVAL      DspISOMSgFlds = False
     C                   ENDIF

      ** Check if To be used for depot movement is set to 'Y'

     C                   IF        PForDpmI = 'N'
     C                   EVAL      PrtSAPfld = True
     C                   ELSE
     C                   EVAL      PrtSAPfld = False
     C                   ENDIF

     C                   EVAL      #1BRCH = PBranch
     C                   EVAL      #1CUST = PCustomer
     C                   EVAL      #1BOOK = PBook
     C                   EVAL      #1DESC = PDescrptn
     C                   EVAL      #1CCY  = PCcy
     C                   EVAL      #1MKCT = PMktCtr                                           CSE034
     C                   EVAL      #1INVT = PInvType
     C                   EVAL      #1PORF = PPorRef
     C                   EVAL      #2DEPT = PForDpmI

     C                   IF        ActionCode = 'E'
     C                   EVAL      PrtFlds = True
     C                   ELSE
     C                   EVAL      PrtFlds = False
     C                   ENDIF

      ** Initialise values of screen details from input parm

     C                   EXSR      SRSetScnFld1
     C                   EXSR      SRSetScnFld2
     C                   EXSR      SRSetScnFld3

     C                   EVAL      WPInterMed = *BLANKS
     C                   EVAL      WPPSET = *BLANKS
     C                   EVAL      WPQFIN = *BLANKS                                         AR634357
     C                   EVAL      WWPCL1 = *BLANKS                                         AR634357
     C                   EVAL      WWDBTR = *BLANKS                                         AR634357
     C                   EVAL      WWAFPN = *BLANKS                                         AR635847
     C                   EVAL      WWAWIN = *BLANKS                                         AR635847
     C                   EVAL      WWBOFN = *BLANKS                                         AR635847
     C                   IF        PCBInd = 'B'                                               205663
     C                   EVAL      PMode = '1'
     C                   ELSE                                                                 205663
     C                   EVAL      PMode = '0'                                                205663
     C                   ENDIF                                                                205663
     C                   EVAL      PRetCode = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetScnFld1 - Move PAddSetD to screen1                       *
      *                                                               *
      * Called by: SRInit, SRDisplay1                                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSetScnFld1  BEGSR

     C                   EVAL      #1AWIN  = PAAWIN
     C                   EVAL      #1AWIL  = PAAWIL
     C                   EVAL      #1AFPN  = PAAFPN
     C                   EVAL      #1AFPL  = PAAFPL
     C                   EVAL      #1BOFN  = PABOFN
     C                   EVAL      #1BOF1  = PABOF1
     C                   EVAL      #1BOF2  = PABOF2
     C                   EVAL      #1SRL1  = PASRL1
     C                   EVAL      #1SRL2  = PASRL2
     C                   EVAL      #1SRL3  = PASRL3
     C                   EVAL      #1NAC1  = PANAC1
     C                   EVAL      #1NAC2  = PANAC2

     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
     C                   EVAL      @DEBTR1 = PADIDN                                           CSW210
     C                   EVAL      @DACNT1 = PADLIN                                           CSW210
     C                   EVAL      @DADDR1 = PADAD1                                           CSW210
     C                   EVAL      @DADDR2 = PADAD2                                           CSW210
     C                   EVAL      @DADDR3 = PADAD3                                           CSW210
     C                   EVAL      @DADDR4 = PADAD4                                           CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EVAL      #2GMES  = PAGMES
     C                   EVAL      #2CONG  = PACONG
     C                   EVAL      #2INST  = PAINST
     C                   EVAL      #2INSS  = PAINSS
     C                   EVAL      #2RPTY  = PARPTY
     C                   EVAL      #2GDEL  = PAGDEL
     C                   EVAL      #2SROL  = PASROL
     C                   EVAL      #2FIND  = PAFIND
     C                   EVAL      #2STMP  = PASTMP
     C                   EVAL      #2CHID  = PACHID
     C                   EVAL      #2TRRM  = PATRRM

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetScnFld2 - Move PAddSetD to screen2                       *
      *                                                               *
      * Called by: SRInit, SRDisplay2                                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSetScnFld2  BEGSR

     C                   IF        PAdDType = 'P'
     C                   EVAL      #3CCTN  = PACCTN
     C                   EVAL      #3DRSN  = PADRSN
     C                   EVAL      #3DRS1  = PADRS1
     C                   EVAL      #3DRS2  = PADRS2
     C                   EVAL      #3DRS3  = PADRS3
     C                   EVAL      #3DRS4  = PADRS4
     C                   EVAL      #3FIN1  = PAFIN1
     C                   EVAL      #3FIN2  = PAFIN2
     C**********         EVAL      #3RED1  = PARED1                                           CSW210
     C**********         EVAL      #3RED2  = PARED2                                           CSW210
     C                   EVAL      #3NAS1  = PANAS1
     C                   EVAL      #3NAS2  = PANAS2
     C                   ELSE
     C                   EVAL      #4CCTN  = PACCTN
     C                   EVAL      #4DRSN  = PADRSN
     C                   EVAL      #4DRS1  = PADRS1
     C                   EVAL      #4DRS2  = PADRS2
     C                   EVAL      #4DRS3  = PADRS3
     C                   EVAL      #4DRS4  = PADRS4
     C                   EVAL      #4BSSN  = PABSSN
     C                   EVAL      #4BSS1  = PABSS1
     C                   EVAL      #4BSS2  = PABSS2
     C                   EVAL      #4FIN1  = PAFIN1
     C                   EVAL      #4FIN2  = PAFIN2
     C**********         EVAL      #4RED1  = PARED1                                           CSW210
     C**********         EVAL      #4RED2  = PARED2                                           CSW210
     C                   EVAL      #4NAS1  = PANAS1
     C                   EVAL      #4NAS2  = PANAS2
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetScnFld3 - Move PAddSetD to screen3                       *
      *                                                               *
      * Called by: SRInit, SRDisplay3                                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSetScnFld3  BEGSR

     C                   EVAL      #5IMMD1 = PAIMD1
     C                   EVAL      #5IMMD2 = PAIMD2
     C**********         EVAL      #5IMMD3 = PAIMD3                                          CSW206D
     C**********         EVAL      #5IMMD4 = PAIMD4                                          CSW206D
     C**********         EVAL      #5IMMD5 = PAIMD5                                          CSW206D
     C**********         EVAL      #5IMMD6 = PAIMD6                                          CSW206D
     C**********         EVAL      #5IMMD7 = PAIMD7                                          CSW206D
     C**********         EVAL      #5IMMD8 = PAIMD8                                          CSW206D
     C**********         EVAL      #5IMMD9 = PAIMD9                                          CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      #5IMMD3 = PAIMD3                                          CSW206E
     C                   EVAL      #5IMMD4 = PAIMD4                                          CSW206E
     C                   EVAL      #5IMMD5 = PAIMD5                                          CSW206E
     C                   EVAL      #5IMMD6 = PAIMD6                                          CSW206E
     C                   EVAL      #5IMMD7 = PAIMD7                                          CSW206E
     C                   EVAL      #5IMMD8 = PAIMD8                                          CSW206E
     C                   EVAL      #5IMMD9 = PAIMD9                                          CSW206E
     C                   ENDIF                                                               CSW206E
     C                   EVAL      #5IMSA1 = PAIMS1
     C                   EVAL      #5IMSA2 = PAIMS2
     C**********         EVAL      #5IMSA3 = PAIMS3                                          CSW206D
     C**********         EVAL      #5IMSA4 = PAIMS4                                          CSW206D
     C**********         EVAL      #5IMSA5 = PAIMS5                                          CSW206D
     C**********         EVAL      #5IMSA6 = PAIMS6                                          CSW206D
     C**********         EVAL      #5IMSA7 = PAIMS7                                          CSW206D
     C**********         EVAL      #5IMSA8 = PAIMS8                                          CSW206D
     C**********         EVAL      #5IMSA9 = PAIMS9                                          CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      #5IMSA3 = PAIMS3                                          CSW206E
     C                   EVAL      #5IMSA4 = PAIMS4                                          CSW206E
     C                   EVAL      #5IMSA5 = PAIMS5                                          CSW206E
     C                   EVAL      #5IMSA6 = PAIMS6                                          CSW206E
     C                   EVAL      #5IMSA7 = PAIMS7                                          CSW206E
     C                   EVAL      #5IMSA8 = PAIMS8                                          CSW206E
     C                   EVAL      #5IMSA9 = PAIMS9                                          CSW206E
     C                   EVAL      #5PSET  = PAPSET
     C                   ELSE                                                                CSW206E
     C                   EVAL      #5PSET1 = PAPSET                                          CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
     C                   EVAL      #5PSET1 = PAPSET                                           CSW210
     C                   EVAL      #5PCL1  = PAPCLR                                           CSW210
     C                   EVAL      #5QFI1  = PAQFIN                                           CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      #5PSET  = PAPSET                                           CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EVAL      #5RED1  = PARED1                                           CSW210
     C                   EVAL      #5RED2  = PARED2                                           CSW210

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       205663
      *                                                               *                       205663
      *  SRDisplay0 - Display Initial screen of add'l information     *                       205663
      *                                                               *                       205663
      * Called by: Main processing                                    *                       205663
      *                                                               *                       205663
      * Calls:                                                        *                       205663
      *                                                               *                       205663
      *****************************************************************                       205663
     C     SRDisplay0    BEGSR                                                                205663
                                                                                              205663
      ** Move 'OK' flags into array for checking                                              205663
                                                                                              205663
     C                   MOVEA     OkFlags       WErrIndArr                                   205663
                                                                                              205663
      ** Set screen error indicators according to status of 'OK' flags                        205663
                                                                                              205663
     C                   Z-ADD     1             WCtr1                                        205663
     C                   Z-ADD     10            WCtr2                                        205663
                                                                                              205663
     C                   DOU       WCtr1 > 23                                                 205663
                                                                                              205663
     C                   IF        WErrIndArr(WCtr1) = 'N' OR                                 205663
     C                             WErrIndArr(WCtr1) = 'W'                                    205663
     C                   EVAL      *IN(WCtr2) = '1'                                           205663
     C                   ENDIF                                                                205663
                                                                                              205663
     C                   EVAL      WCtr1 = WCtr1 + 1                                          205663
     C                   EVAL      WCtr2 = WCtr2 + 1                                          205663
                                                                                              205663
     C                   ENDDO                                                                205663
                                                                                              205663
      ** OKFlags for SWIFT 2010 Changes                                                       CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
     C                   IF        DbtrOk = 'N' OR                                            CSW210
     C                             DbtrOk = 'W'                                               CSW210
     C                   EVAL      *IN86 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DActOk = 'N' OR                                            CSW210
     C                             DActOk = 'W'                                               CSW210
     C                   EVAL      *IN87 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd1Ok = 'N' OR                                            CSW210
     C                             DAd1Ok = 'W'                                               CSW210
     C                   EVAL      *IN92 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd2Ok = 'N' OR                                            CSW210
     C                             DAd2Ok = 'W'                                               CSW210
     C                   EVAL      *IN93 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd3Ok = 'N' OR                                            CSW210
     C                             DAd3Ok = 'W'                                               CSW210
     C                   EVAL      *IN94 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd4Ok = 'N' OR                                            CSW210
     C                             DAd4Ok = 'W'                                               CSW210
     C                   EVAL      *IN95 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** The following /COPY line includes processing for the error and                       205663
      ** warning messages.                                                                    205663
                                                                                              205663
      /COPY ZACPYSRC,MSGHNDDSP1                                                               205663
                                                                                              205663
      ** Write message subfile, details and footer screen                                     205663
                                                                                              205663
     C                   EVAL      DspRollUp = True                                           205663
     C                   EVAL      DspRollDn = False                                          205663
     C                   WRITE     SETSSIDSF6                                                 205663
     C                   WRITE     SETSSIDSC1                                                 205663
                                                                                              205663
     C                   EXFMT     SETSSIDSF1                                                 205663
                                                                                              205663
      ** Clear message subfile                                                                205663
                                                                                              205663
     C                   CALL      'ZA0250'                                                   205663
                                                                                              205663
      ** Reset error fields                                                                   205663
                                                                                              205663
     C                   EVAL      Idx = 0                                                    205663
     C                   EVAL      WIdx = 0                                                   CSW210
     C                   CLEAR                   MsgIdArr                                     205663
     C                   CLEAR                   FldNameArr                                   205663
     C                   CLEAR                   WMsgIdArr                                    205663
     C                   CLEAR                   WFldNamArr                                   CSW210
                                                                                              205663
      ** Set screen error indicators off                                                      205663
                                                                                              205663
     C                   MOVEA     WInzIndArr    *IN(10)                                      205663
     C                   MOVEA     WInzOkFlags   OkFlags                                      205663
                                                                                              205663
      ** Reset OKFlags for SWIFT 2010 Changes                                                 CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
     C                   MOVEA     '00'          *IN(86)                                      CSW210
     C                   MOVEA     '0000'        *IN(92)                                      CSW210
     C                   EVAL      DbtrOk = 'Y'                                               CSW210
     C                   EVAL      DActOk = 'Y'                                               CSW210
     C                   EVAL      DAd1Ok = 'Y'                                               CSW210
     C                   EVAL      DAd2Ok = 'Y'                                               CSW210
     C                   EVAL      DAd3Ok = 'Y'                                               CSW210
     C                   EVAL      DAd4Ok = 'Y'                                               CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Select processing type                                                               205663
                                                                                              205663
     C                   SELECT                                                               205663
                                                                                              205663
      ** F3 Pressed                                                                           205663
                                                                                              205663
     C                   WHEN      *INKC = *ON                                                205663
     C                   EVAL      PRetCode = 'SE10000'                                       205663
     C                   EVAL      PMode = 'R'                                                205663
                                                                                              205663
      ** F5 Pressed                                                                           205663
                                                                                              205663
     C                   WHEN      *INKE = *ON                                                205663
     C                   EXSR      SRSetScnFld1                                               205663
                                                                                              205663
      ** F12 Pressed                                                                          205663
                                                                                              205663
     C                   WHEN      *INKL = *ON                                                205663
     C                   EVAL      PRetCode = 'SE10001'                                       205663
     C                   EVAL      PMode = 'R'                                                205663
                                                                                              205663
     C                   OTHER                                                                205663
                                                                                              205663
      ** Validate inputs if not enquire                                                       205663
                                                                                              205663
     C                   IF        ActionCode <> 'E'                                          205663
                                                                                              205663
     C                   EXSR      SRValidate1                                                205663
                                                                                              205663
      ** If no errors found, proceed to next screen                                           205663
     C                   IF        Idx = 0                                                    205663
     C                             AND @DEBTR1 = WWDBTR                                     AR634357
     C                             AND #1AFPN = WWAFPN                                      AR635847
     C                             AND #1AWIN = WWAWIN                                      AR635847
     C                             AND #1BOFN = WWBOFN                                      AR635847
                                                                                              205663
     C                   EVAL      PMode = '1'                                                205663
                                                                                              205663
      ** Else, re-display screen                                                              205663
     C                   ELSE                                                                 205663
                                                                                              205663
     C                   EVAL      PMode = '0'                                                205663
                                                                                              205663
     C                   ENDIF                                                                205663
                                                                                              CSW210
     C                   IF        PrevFlg = 'Y'                                              CSW210
     C                   EVAL      PMode = '0'                                                CSW210
     C                   EVAL      PrevFlg = 'N'                                              CSW210
     C                   EndIf                                                                CSW210
                                                                                              205663
      ** Proceed directly to next screen if enquire                                           205663
     C                   ELSE                                                                 205663
                                                                                              205663
     C                   EVAL      PMode = '1'                                                205663
                                                                                              205663
     C                   ENDIF                                                                205663
                                                                                              205663
     C                   ENDSL                                                                205663
                                                                                              205663
     C                   ENDSR                                                                205663
      *****************************************************************                       205663
      /EJECT                                                                                  205663
      *****************************************************************
      *                                                               *
      *  SRDisplay1 - Display 1st screen of additional information    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRDisplay1    BEGSR

      ** Move 'OK' flags into array for checking

     C                   MOVEA     OkFlags       WErrIndArr

      ** Set screen error indicators according to status of 'OK' flags

     C                   Z-ADD     1             WCtr1
     C                   Z-ADD     10            WCtr2

     C                   DOU       WCtr1 > 23

     C                   IF        WErrIndArr(WCtr1) = 'N' OR
     C                             WErrIndArr(WCtr1) = 'W'
     C                   EVAL      *IN(WCtr2) = '1'
     C                   ENDIF

     C                   EVAL      WCtr1 = WCtr1 + 1
     C                   EVAL      WCtr2 = WCtr2 + 1

     C                   ENDDO

      ** OKFlags for SWIFT 2010 Changes                                                       CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
     C                   IF        DbtrOk = 'N' OR                                            CSW210
     C                             DbtrOk = 'W'                                               CSW210
     C                   EVAL      *IN86 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DActOk = 'N' OR                                            CSW210
     C                             DActOk = 'W'                                               CSW210
     C                   EVAL      *IN87 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd1Ok = 'N' OR                                            CSW210
     C                             DAd1Ok = 'W'                                               CSW210
     C                   EVAL      *IN92 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd2Ok = 'N' OR                                            CSW210
     C                             DAd2Ok = 'W'                                               CSW210
     C                   EVAL      *IN93 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd3Ok = 'N' OR                                            CSW210
     C                             DAd3Ok = 'W'                                               CSW210
     C                   EVAL      *IN94 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd4Ok = 'N' OR                                            CSW210
     C                             DAd4Ok = 'W'                                               CSW210
     C                   EVAL      *IN95 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** The following /COPY line includes processing for the error and
      ** warning messages.

      /COPY ZACPYSRC,MSGHNDDSP1

      ** Write message subfile, details and footer screen

     C                   EVAL      DspRollUp = True
     C                   IF        PCBInd = 'B'                                               205663
     C                   EVAL      DspRollDn = False
     C                   ELSE                                                                 205663
     C                   EVAL      DspRollDn = True                                           205663
     C                   ENDIF                                                                205663
     C                   WRITE     SETSSIDSF6
     C                   WRITE     SETSSIDSC1

     C**********         IF        PBFCLAS = 'I' OR PCBInd = 'B'                              205663
     C                   IF        PCBInd = 'B'                                               205663
     C                   EXFMT     SETSSIDSF1
     C                   ELSE
     C                   EXFMT     SETSSIDSF2
     C                   ENDIF

      ** Clear message subfile

     C                   CALL      'ZA0250'

      ** Reset error fields

     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0                                                   CSW210
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WFldNamArr                                   CSW210

      ** Set screen error indicators off

     C                   MOVEA     WInzIndArr    *IN(10)
     C                   MOVEA     WInzOkFlags   OkFlags

      ** Reset OKFlags for SWIFT 2010 Changes                                                 CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
     C                   MOVEA     '00'          *IN(86)                                      CSW210
     C                   MOVEA     '0000'        *IN(92)                                      CSW210
     C                   EVAL      DbtrOk = 'Y'                                               CSW210
     C                   EVAL      DActOk = 'Y'                                               CSW210
     C                   EVAL      DAd1Ok = 'Y'                                               CSW210
     C                   EVAL      DAd2Ok = 'Y'                                               CSW210
     C                   EVAL      DAd3Ok = 'Y'                                               CSW210
     C                   EVAL      DAd4Ok = 'Y'                                               CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Select processing type

     C                   SELECT

      ** F3 Pressed

     C                   WHEN      *INKC = *ON
     C                   EVAL      PRetCode = 'SE10000'
     C                   EVAL      PMode = 'R'

      ** F5 Pressed

     C                   WHEN      *INKE = *ON
     C                   EXSR      SRSetScnFld1

      ** F12 Pressed

     C                   WHEN      *INKL = *ON
     C                   EVAL      PRetCode = 'SE10001'
     C                   EVAL      PMode = 'R'

      ** Roll Down                                                                            205663
                                                                                              205663
     C                   WHEN      RollDn = True                                              205663
     C                   EVAL      PMode = '0'                                                205663
                                                                                              205663
     C                   OTHER

      ** Validate inputs if not enquire

     C                   IF        ActionCode <> 'E'

     C                   EXSR      SRValidate1

      ** If no errors found, proceed to next screen
     C                   IF        Idx = 0

     C                   EVAL      PMode = '2'

      ** Else, re-display screen
     C                   ELSE

     C                   EVAL      PMode = '1'

     C                   ENDIF

      ** Proceed directly to next screen if enquire
     C                   ELSE

     C                   EVAL      PMode = '2'

     C                   ENDIF

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate1 - Validate screen1 fields                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRValidate1   BEGSR

     C**********         IF        PBFCLAS = 'I' OR PCBInd = 'B'                              205663
     C                   IF        PMode = '0' OR PCBInd = 'B'                                205663

      ** Validate screen 1 of internal customer
      ** ======================================
                                                                                              CSW210
      ** Validate a/c for payment number                                                      CSW210
      ** -------------------------------                                                      CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   MOVEL     #1AFPN        WWAFPN                                     AR635847
     C                   IF        #1AFPN <> *BLANKS                                          CSW210
                                                                                              CSW210
     C                   MOVEL     #1AFPN        PCustKey                                     CSW210
                                                                                              CSW210
      ** Validate Customer Number/Shortname/Nostro                                            CSW210
                                                                                              CSW210
     C                   EXSR      SRCust                                                     CSW210
                                                                                              CSW210
     C                   IF        WCustType <> 'C' AND WCustType <> 'S' AND                  CSW210
     C                             WCustType <> 'N'                                           CSW210
     C                   EVAL      AFPNOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '#1AFPN'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5205'                                  CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
      ** If customer or shortame a/c must be a bank                                           CSW210
                                                                                              CSW210
     C**********         IF        WCustType = 'C' AND WCustType = 'S'               CSW210 AR634357
     C                   IF        WCustType = 'C' OR WCustType = 'S'                       AR634357
     C                   EVAL      #1AFPN = BBCUST                                            CSW210
                                                                                              CSW210
      ** Entry is Nostro                                                                      CSW210
                                                                                              CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
     C                   IF        WCustType = 'N'                                            CSW210
     C                   EVAL      #1AFPN = AWCPNC                                            CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Either SWIFT Field 53 or (57 AND 58) can be Entered                                  CSW210
                                                                                              CSW210
     C                   IF        PAdDType = 'S' AND #1AFPN <> *BLANKS                       CSW210
     C                   IF        #1AWIN <> *BLANKS OR #1AWIL <> *BLANKS OR                  CSW210
     C                             #1BOFN <> *BLANKS OR #1BOF1 <> *BLANKS OR                  CSW210
     C                             #1BOF2 <> *BLANKS                                          CSW210
     C                   EVAL      AFPNOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '#1AFPN'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5215'                                  CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Validate a/c for payment line                                                        CSW210
      ** -----------------------------                                                        CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   IF        PISOMsgI <> 'Y'                                            CSW210
     C                   MOVEL     #1AFPL        WWAFPL                                       CSW210
     C                   IF        #1AFPL <> *BLANKS AND WWAFPL <> '#'                        CSW210
                                                                                              CSW210
     C                   MOVEL     #1AFPL        WWLI01                                       CSW210
     C                   IF        WWLI01 <> '/'                                              CSW210
     C                   EVAL      AFPLOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '#1AFPL'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5210'                                  CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   MOVEL     #1AFPL        WWLI02                                       CSW210
     C                   IF        WWLI02 = '//'                                              CSW210
     C                   EVAL      AFPLOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '#1AFPL'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5211'                                  CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   MOVE      #1AFPL        WWLI34                                       CSW210
     C                   IF        WWLI01 = '/' AND WWLI34 = *BLANKS                          CSW210
     C                   EVAL      AFPLOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '#1AFPL'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5212'                                  CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Either SWIFT Field 53 or (57 AND 58) can be Entered                                  CSW210
                                                                                              CSW210
     C                   IF        PAdDType = 'S' AND #1AFPL <> *BLANKS                       CSW210
     C                   IF        #1AWIN <> *BLANKS OR #1AWIL <> *BLANKS OR                  CSW210
     C                             #1BOFN <> *BLANKS OR #1BOF1 <> *BLANKS OR                  CSW210
     C                             #1BOF2 <> *BLANKS                                          CSW210
     C                   EVAL      AFPLOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '#1AFPL'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5215'                                  CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                                                                                        CSW210
     C                   IF        PCFT004 = 'Y' AND                                          CSW210
     C                             PCSW210 = 'Y'                                              CSW210
     C                   EVAL      MsgLine = *Blank                                           CSW210
     C                   EVAL      DSACB1 = #1AFPL                                            CSW210
     C                   EXSR      SRIBAN                                                     CSW210
     C                   IF        IBANFlg = 'Y'                                            AR578911
     C                   EVAL      #1AFPL = DSACB1                                          AR578911
     C                   ENDIF                                                              AR578911
                                                                                              CSW210
     C                   IF        @Rcode <> *Blanks AND                                      CSW210
     C                             IBANFlg = 'Y'                                              CSW210
     C                   MOVEL     '#1AFPL'      WFldNam                                      CSW210
     C                   EVAL      WMsgID = WMsgIdArr(WIdx)                                   CSW210
     C                   EVAL      WFldVal = #1AFPL                                           CSW210
                                                                                              CSW210
     C                   IF        MsgLine = PrevMsg(1)                                       CSW210
     C                   EVAL      AFPLOk = 'Y'                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WMsgIdArr(WIdx) = *Blank                                   CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WIdx = WIdx - 1                                            CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      AFPLOk = 'W'                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = '#1AFPL    '                            CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = XAFPL                                   CSW210
     C                   MOVE      MsgLine       PrevMsg(1)                                   CSW210
     C                   EVAL      PrevFlg = 'Y'                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
      ** Validate debtor identification                                                       CSW210
      ** ------------------------------                                                       CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   MOVEL     @DEBTR1       WWDBTR                                     AR635847
     C                   IF        @DEBTR1 <> *BLANKS                                         CSW210
                                                                                              CSW210
     C**********         MOVEL     @DEBTR1       WWDBTR                            AR634357 AR635847
     C                   IF        #2FIND = 'F'                                               CSW210
     C                   EVAL      DbtrOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DEBTR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00112'                                  CSW210
                                                                                              CSW210
     C                   ELSE                                                                 CSW210
     C                   MOVEL     @DEBTR1       PCustKey                                     CSW210
                                                                                              CSW210
      ** Validate Customer Number/Shortname/Nostro                                            CSW210
                                                                                              CSW210
     C                   EXSR      SRCust                                                     CSW210
                                                                                              CSW210
     C                   IF        WCustType <> 'C' AND WCustType <> 'S' AND                  CSW210
     C                             WCustType <> 'N'                                           CSW210
     C                   EVAL      DbtrOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DEBTR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00077'                                  CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
      ** If customer or shortame a/c must be a bank                                           CSW210
                                                                                              CSW210
     C**********         IF        WCustType = 'C' AND WCustType = 'S'               CSW210 AR634357
     C**********         IF        WBNBI = 'Y'                                       CSW210 AR634357
     C                   IF        WCustType = 'C' OR WCustType = 'S'                       AR634357
     C**********         IF        WWBNBI = 'Y'                                    AR634357 AR636523
     C                   EVAL      @DEBTR1 = BBCUST                                           CSW210
     C**********         ELSE                                                        CSW210 AR636523
      **********                                                                     CSW210 AR636523
      ***Customer is non-bank                                                        CSW210 AR636523
      **********                                                                     CSW210 AR636523
     C**********         EVAL      @DEBTR1 = BBCUST                                AR634357 AR636523
     C**********         EVAL      DbtrOk = 'N'                                      CSW210 AR636523
     C**********         EVAL      Idx = Idx + 1                                     CSW210 AR636523
     C**********         EVAL      FldNameArr(Idx) = '@DEBTR1'                       CSW210 AR636523
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5225'                         CSW210 AR636523
     C**********         ENDIF                                                       CSW210 AR636523
                                                                                              CSW210
      ** Entry is Nostro                                                                      CSW210
                                                                                              CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
     C                   IF        WCustType = 'N'                                            CSW210
     C                   EVAL      @DEBTR1 = AWCPNC                                           CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Validate debtor address lines                                                        CSW210
      ** -----------------------------                                                        CSW210
                                                                                              CSW210
     C                   EXSR      SRDBTA                                                     CSW210
                                                                                              CSW210
      ** Validate debtor account line                                                         CSW210
      ** ----------------------------                                                         CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   IF        @DACNT1 <> *BLANKS                                         CSW210
                                                                                              CSW210
     C                   IF        #2FIND = 'F'                                               CSW210
     C                   EVAL      DActOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DACNT1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00112'                                  CSW210
     C                   ELSE                                                                 CSW210
     C                   IF        @DEBTR1 = *BLANKS AND                                      CSW210
     C                             SACBDS  = *BLANKS                                          CSW210
     C                   EVAL      DbtrOk = 'N'                                               CSW210
     C                   EVAL      DAd1Ok = 'N'                                               CSW210
     C                   EVAL      DAd2Ok = 'N'                                               CSW210
     C                   EVAL      DAd3Ok = 'N'                                               CSW210
     C                   EVAL      DAd4Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DACNT1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00082'                                  CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                                                                                        CSW210
     C                   IF        PCFT004 = 'Y'                                              CSW210
     C                   EVAL      MsgLine = *Blank                                           CSW210
     C                   EVAL      DSACB1 = @DACNT1                                           CSW210
     C                   EXSR      SRIBAN                                                     CSW210
     C                   IF        IBANFlg = 'Y'                                            AR578911
     C                   EVAL      @DACNT1 = DSACB1                                         AR578911
     C                   ENDIF                                                              AR578911
                                                                                              CSW210
     C                   IF        @Rcode <> *Blanks AND                                      CSW210
     C                             IBANFlg = 'Y'                                              CSW210
     C                   MOVEL     '@DACNT1'     WFldNam                                      CSW210
     C                   EVAL      WMsgID = WMsgIdArr(WIdx)                                   CSW210
     C                   EVAL      WFldVal = @DACNT1                                          CSW210
                                                                                              CSW210
     C                   IF        MsgLine = PrevMsg(2)                                       CSW210
     C                   EVAL      DActOk = 'Y'                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WMsgIdArr(WIdx) = *Blank                                   CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WIdx = WIdx - 1                                            CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      DActOk = 'W'                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = '@DACNT1   '                            CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = XDACL                                   CSW210
     C                   MOVE      MsgLine       PrevMsg(2)                                   CSW210
     C                   EVAL      PrevFlg = 'Y'                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210

      ** Validate a/c with institution number
      ** ------------------------------------

      ** Validate if not blank

     C                   MOVEL     #1AWIN        WWAWIN                                     AR635847
     C                   IF        #1AWIN <> *BLANKS
     C                   MOVEL     #1AWIN        PCustKey

      ** Validate Customer Number/Shortname/Nostro

     C                   EXSR      SRCust

     C                   IF        WCustType <> 'C' AND WCustType <> 'S' AND
     C                             WCustType <> 'N'
     C                   EVAL      AWINOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1AWIN'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5205'
     C                   ELSE

      ** If customer or shortame a/c must be a bank

     C**********         IF        WCustType = 'C' AND WCustType = 'S'                      AR634357
     C**********         IF        WBNBI = 'Y'                                              AR634357
     C                   IF        WCustType = 'C' OR WCustType = 'S'                       AR634357
     C                   IF        WWBNBI = 'Y'                                             AR634357
     C                   EVAL      #1AWIN = BBCUST
     C                   ELSE

      ** Customer is non-bank

     C                   EVAL      #1AWIN = BBCUST                                          AR634357
     C                   EVAL      AWINOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1AWIN'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5225'
     C                   ENDIF

      ** Entry is Nostro

     C                   ELSE

     C                   IF        WCustType = 'N'
     C                   EVAL      #1AWIN = AWCPNC
     C                   ENDIF
     C                   ENDIF

      ** Beneficiary of money number must no be blank

     C                   IF        #1BOFN = *BLANKS
     C                   EVAL      AWINOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1AWIN'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5226'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
                                                                                              201486
     C                   EVAL      WAGNA = 'Y'                                                201486
                                                                                              201486
     C                   IF        #1AWIN = T1AWIN and #1AWIL = *BLANKS                       201486
     C                   EVAL      WAGNA = *BLANKS                                            201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   IF        AWINOk <> 'N' and #1AWIN <> *BLANKS and                    201486
     C                             #1AWIL = *BLANKS and WAGNA <> *BLANKS                      201486
                                                                                              201486
     C                   EVAL      T1AWIN = #1AWIN                                            201486
     C                   EVAL      PDepotCNum = #1AWIN                                        201486
                                                                                              201486
     C                   IF        PCBInd = 'C'                                               201486
     C                   EVAL      PCntrPCNum = PCustomer                                     201486
     C                   ELSE                                                                 201486
     C                   EVAL      PCntrPCNum = A8BICN                                        201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   EXSR      SRDORF                                                     201486
                                                                                              201486
     C                   IF        PSKALREF <> *BLANKS                                        201486
                                                                                              201486
     C                   EVAL      #1AWIL = PSKALRef                                          201486
     C                   EVAL      WAGNA = 'N'                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486

      ** Validate a/c with institution line
      ** ----------------------------------

      ** Validate if not blank

     C                   MOVEL     #1AWIL        WWLI02                                     AR589197
     C                   IF        PISOMsgI <> 'Y'                                            210278
     C                             OR WWLI02 = '//'                                         AR589197
     C                   MOVEL     #1AWIL        WWAWIL
     C                   IF        #1AWIL <> *BLANKS AND WWAWIL <> '#'

     C                   IF        #1AWIN = *BLANKS
     C                   EVAL      AWILOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1AWIL'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5230'
     C                   ELSE
     C                   MOVEL     #1AWIL        WWLI01
     C                   MOVEL     #1AWIL        WWLI02
     C                   MOVEL     #1AWIL        WWLI04
     C                   MOVEL     #1AWIL        WWLI05
     C                   MOVEL     #1AWIL        WWLI35

     C                   EVAL      WErr35 = 'N'
     C                   IF        PCSW098 <> 'Y'
     C                   EXSR      SRLine35
     C                   ELSE

      ** Set up parameters for call to ME9940

     C                   CLEAR                   DSIParm
     C                   EVAL      I#VFLD = 'AWBK '
     C                   EVAL      I#PR   = 'PAY'

     C                   IF        WCustType = 'N'
     C                   EVAL      I#PRTT = 'X'
     C                   ELSE
     C                   EVAL      I#PRTT = WCustType
     C                   ENDIF

     C                   MOVEL     #1AWIN        I#PRTY
     C                   MOVEL     PCcy          I#PCCY
     C                   MOVEL     PCcy          I#RCCY
     C                   MOVEL     WWLI35        I#ACLN
     C                   MOVEL     '5XX'         I#MTYP                                     AR589197

     C                   CLEAR                   DSOParm
     C                   CLEAR                   DSEParm
     C                   EVAL      E#CPGM  = 'SETSSIDSP'
     C                   EVAL      E#MSGD  = 'MEC0017'
     C                   EVAL      E#MSGF  = 'MEMSG'

     C                   MOVEL     WAWBK         WACLN

     C                   EXSR      SRME9940

      ** If no issuer code defined for the currency clearing system,
      ** set flag to display warning message for later display.

     C                   IF        WICNIL = 'Y'
     C                   EVAL      AWILOk = 'W'
     C**********         EVAL      Idx = Idx + 1                                            AR589197
     C**********         EVAL      FldNameArr(Idx) = '#1AWIL'                               AR589197
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5176'                                AR589197
     C                   EVAL      WIdx = WIdx + 1                                          AR589197
     C                   EVAL      WFldNamArr(WIdx) = '#1AWIL'                              AR589197
     C                   EVAL      WMsgIdArr(WIdx) = 'SEW5176'                              AR589197
     C                   EVAL      WICNIL = *BLANK
     C                   ENDIF

     C                   MOVEL     WWLI35        WAWBK

     C                   ENDIF

     C                   IF        WErr35 <> 'Y'
     C                   MOVEL     WWLI35        #1AWIL
     C                   ELSE
     C                   EVAL      AWILOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1AWIL'
     C                   EVAL      MsgIdArr(Idx) = WErr35Msg
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                210278
     C                                                                                        CSW210
     C                   IF        PCFT004 = 'Y' AND                                          CSW210
     C                             PCSW210 = 'Y'                                              CSW210
     C                   EVAL      MsgLine = *Blank                                           CSW210
     C                   EVAL      DSACB1 = #1AWIL                                            CSW210
     C                   EXSR      SRIBAN                                                     CSW210
     C                   IF        IBANFlg = 'Y'                                            AR578911
     C                   EVAL      #1AWIL = DSACB1                                          AR578911
     C                   ENDIF                                                              AR578911
                                                                                              CSW210
     C                   IF        @Rcode <> *Blanks AND                                      CSW210
     C                             IBANFlg = 'Y'                                              CSW210
     C                   MOVEL     '#1AWIL'      WFldNam                                      CSW210
     C                   EVAL      WMsgID = WMsgIdArr(WIdx)                                   CSW210
     C                   EVAL      WFldVal = #1AWIL                                           CSW210
                                                                                              CSW210
     C                   IF        MsgLine = PrevMsg(3)                                       CSW210
     C                   EVAL      AWILOk = 'Y'                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WMsgIdArr(WIdx) = *Blank                                   CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WIdx = WIdx - 1                                            CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      AWILOk = 'W'                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = '#1AWIL    '                            CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = XAWIL                                   CSW210
     C                   MOVE      MsgLine       PrevMsg(3)                                   CSW210
     C                   EVAL      PrevFlg = 'Y'                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210

      ***Validate*a/c*for*payment*number**                                                    CSW210
      ***-------------------------------**                                                    CSW210

      ***Validate*if*not*blank**                                                              CSW210

     C**********         IF        #1AFPN <> *BLANKS                                          CSW210

     C**********         MOVEL     #1AFPN        PCustKey                                     CSW210

      ***Validate*Customer*Number/Shortname/Nostro**                                          CSW210

     C**********         EXSR      SRCust                                                     CSW210

     C**********         IF        WCustType <> 'C' AND WCustType <> 'S' AND                  CSW210
     C**********                   WCustType <> 'N'                                           CSW210
     C**********         EVAL      AFPNOk = 'N'                                               CSW210
     C**********         EVAL      Idx = Idx + 1                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#1AFPN'                                 CSW210
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5205'                                  CSW210
     C**********         ELSE                                                                 CSW210

      ***If*customer*or*shortame*a/c*must*be*a*bank**                                         CSW210

     C**********         IF        WCustType = 'C' AND WCustType = 'S'                        CSW210
     C**********         EVAL      #1AFPN = BBCUST                                            CSW210

      ***Entry*is*Nostro**                                                                    CSW210

     C**********         ELSE                                                                 CSW210

     C**********         IF        WCustType = 'N'                                            CSW210
     C**********         EVAL      #1AFPN = AWCPNC                                            CSW210
     C**********         ENDIF                                                                CSW210
     C**********         ENDIF                                                                CSW210

     C**********         ENDIF                                                                CSW210

      ***Either*SWIFT*Field*53*or*(57*AND*58)*can*be*Entered**                                CSW210

     C**********         IF        PAdDType = 'S' AND #1AFPN <> *BLANKS                       CSW210
     C**********         IF        #1AWIN <> *BLANKS OR #1AWIL <> *BLANKS OR                  CSW210
     C**********                   #1BOFN <> *BLANKS OR #1BOF1 <> *BLANKS OR                  CSW210
     C**********                   #1BOF2 <> *BLANKS                                          CSW210
     C**********         EVAL      AFPNOk = 'N'                                               CSW210
     C**********         EVAL      Idx = Idx + 1                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#1AFPN'                                 CSW210
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5215'                                  CSW210
     C**********         ENDIF                                                                CSW210
     C**********         ENDIF                                                                CSW210
     C**********         ENDIF                                                                CSW210
                                                                                              201486
     C**********         EVAL      WANGA = 'Y'                                         201486 CSW210
                                                                                              201486
     C**********         IF        #1AFPN = T1AFPN and #1AFPL = *BLANKS                201486 CSW210
     C**********         EVAL      WANGA = *BLANKS                                     201486 CSW210
     C**********         ENDIF                                                         201486 CSW210
                                                                                              201486
     C**********         IF        AFPNOk <> 'N' and #1AFPN <> *BLANKS and             201486 CSW210
     C**********                   #1AFPL = *BLANKS and WANGA <> *BLANKS               201486 CSW210
                                                                                              201486
     C**********         EVAL      T1AFPN = #1AFPN                                     201486 CSW210
     C**********         EVAL      PDepotCNum = #1AFPN                                 201486 CSW210
                                                                                              201486
     C**********         IF        PCBInd = 'C'                                        201486 CSW210
     C**********         EVAL      PCntrPCNum = PCustomer                              201486 CSW210
     C**********         ELSE                                                          201486 CSW210
     C**********         EVAL      PCntrPCNum = A8BICN                                 201486 CSW210
     C**********         ENDIF                                                         201486 CSW210
                                                                                              201486
     C**********         EXSR      SRDORF                                              201486 CSW210
                                                                                              201486
     C**********         IF        PSKALREF <> *BLANKS                                 201486 CSW210
                                                                                              201486
     C**********         EVAL      #1AFPL = PSKALRef                                   201486 CSW210
     C**********         EVAL      WAGNA = 'N'                                         201486 CSW210
                                                                                              201486
     C**********         ENDIF                                                         201486 CSW210
                                                                                              201486
     C**********         ENDIF                                                         201486 CSW210

      ***Validate*a/c*for*payment*line**                                                      CSW210
      ***-----------------------------**                                                      CSW210

      ***Validate*if*not*blank**                                                              CSW210

     C**********         IF        PISOMsgI <> 'Y'                                     210278 CSW210
     C**********         MOVEL     #1AFPL        WWAFPL                                       CSW210
     C**********         IF        #1AFPL <> *BLANKS AND WWAFPL <> '#'                        CSW210

     C**********         MOVEL     #1AFPL        WWLI01                                       CSW210
     C**********         IF        WWLI01 <> '/'                                              CSW210
     C**********         EVAL      AFPLOk = 'N'                                               CSW210
     C**********         EVAL      Idx = Idx + 1                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#1AFPL'                                 CSW210
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5210'                                  CSW210
     C**********         ENDIF                                                                CSW210

     C**********         MOVEL     #1AFPL        WWLI02                                       CSW210
     C**********         IF        WWLI02 = '//'                                              CSW210
     C**********         EVAL      AFPLOk = 'N'                                               CSW210
     C**********         EVAL      Idx = Idx + 1                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#1AFPL'                                 CSW210
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5211'                                  CSW210
     C**********         ENDIF                                                                CSW210

     C**********         MOVE      #1AFPL        WWLI34                                       CSW210
     C**********         IF        WWLI01 = '/' AND WWLI34 = *BLANKS                          CSW210
     C**********         EVAL      AFPLOk = 'N'                                               CSW210
     C**********         EVAL      Idx = Idx + 1                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#1AFPL'                                 CSW210
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5212'                                  CSW210
     C**********         ENDIF                                                                CSW210

     C**********         ENDIF                                                                CSW210
     C**********         ENDIF                                                         210278 CSW210

      ***Either*SWIFT*Field*53*or*(57*AND*58)*can*be*Entered**                                CSW210

     C**********         IF        PAdDType = 'S' AND #1AFPL <> *BLANKS                       CSW210
     C**********         IF        #1AWIN <> *BLANKS OR #1AWIL <> *BLANKS OR                  CSW210
     C**********                   #1BOFN <> *BLANKS OR #1BOF1 <> *BLANKS OR                  CSW210
     C**********                   #1BOF2 <> *BLANKS                                          CSW210
     C**********         EVAL      AFPLOk = 'N'                                               CSW210
     C**********         EVAL      Idx = Idx + 1                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#1AFPL'                                 CSW210
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5215'                                  CSW210
     C**********         ENDIF                                                                CSW210
     C**********         ENDIF                                                                CSW210

      ** Validate beneficiary of money number
      ** ------------------------------------

      ** Validate if not blank

     C                   MOVEL     #1BOFN        WWBOFN                                     AR635847
     C                   IF        #1BOFN <> *BLANKS
     C                   MOVEL     #1BOFN        PCustKey

      ** Validate Customer Number/Shortname/Nostro

     C                   EXSR      SRCust

     C                   IF        WCustType <> 'C' AND WCustType <> 'S' AND
     C                             WCustType <> 'N'
     C                   EVAL      BOFNOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BOFN'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5205'
     C                   ELSE

      ** If customer or shortame a/c must be a bank

     C**********         IF        WCustType = 'C' AND WCustType = 'S'                      AR634357
     C                   IF        WCustType = 'C' OR WCustType = 'S'                       AR634357
     C                   EVAL      #1BOFN = BBCUST

      ** Entry is Nostro

     C                   ELSE

     C                   IF        WCustType = 'N'
     C                   EVAL      #1BOFN = AWCPNC
     C                   ENDIF
     C                   ENDIF

      ** Account with institution must not be blank

     C                   IF        #1AWIN = *BLANKS
     C                   EVAL      BOFNOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BOFN'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5245'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
                                                                                              201486
     C                   EVAL      WAANG = 'Y'                                                201486
                                                                                              201486
     C                   IF        #1BOFN = T1BOFN and #1BOF1 = *BLANKS                       201486
     C                   EVAL      WAANG = *BLANKS                                            201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   IF        BOFNOk <> 'N' and #1BOFN <> *BLANKS and                    201486
     C                             #1BOF1 = *BLANKS and WAANG <> *BLANKS                      201486
                                                                                              201486
     C                   EVAL      T1BOFN = #1BOFN                                            201486
     C                   EVAL      PDepotCNum = #1BOFN                                        201486
                                                                                              201486
     C                   IF        PCBInd = 'C'                                               201486
     C                   EVAL      PCntrPCNum = PCustomer                                     201486
     C                   ELSE                                                                 201486
     C                   EVAL      PCntrPCNum = A8BICN                                        201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   EXSR      SRDORF                                                     201486
                                                                                              201486
     C                   IF        PSKALREF <> *BLANKS                                        201486
                                                                                              201486
     C                   EVAL      #1BOF1 = PSKALRef                                          201486
     C                   EVAL      WAGNA = 'N'                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486

      ** Validate beneficiary of money line
      ** ----------------------------------

      ** Validate if not blank

     C                   MOVEL     #1BOF1        WWLI02                                     AR589197
     C                   IF        PISOMsgI <> 'Y'                                            210278
     C                             OR WWLI02 = '//'                                         AR589197
     C                   MOVEL     #1BOF1        WWBOF1
     C                   IF        #1BOF1 <> *BLANKS AND WWBOF1 <> '#'

     C                   IF        #1BOFN = *BLANKS
     C                   EVAL      BOF1Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BOF1'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5230'
     C                   ELSE
     C                   MOVEL     #1BOF1        WWLI01
     C                   MOVEL     #1BOF1        WWLI02
     C                   MOVEL     #1BOF1        WWLI04
     C                   MOVEL     #1BOF1        WWLI05
     C                   MOVEL     #1BOF1        WWLI35

     C                   IF        WWLI02 = '//' AND WCustType = 'C' AND
     C                             WWBNBI = 'N' OR WWLI02 = '//' AND
     C                             WCustType = 'S' AND WWBNBI = 'N'
     C                   EVAL      BOF1Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BOF1'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5250'

     C                   ELSE

     C                   EVAL      WErr35 = 'N'
     C                   IF        PCSW098 <> 'Y'
     C                   EXSR      SRLine35
     C                   ELSE

      ** Set up parameters for call to ME9940

     C                   CLEAR                   DSIParm
     C                   EVAL      I#VFLD = 'BENF '
     C                   EVAL      I#PR   = 'PAY'

     C                   IF        WCustType = 'N'
     C                   EVAL      I#PRTT = 'X'
     C                   ELSE
     C                   EVAL      I#PRTT = WCustType
     C                   ENDIF

     C                   MOVEL     #1BOFN        I#PRTY
     C                   MOVEL     PCcy          I#PCCY
     C                   MOVEL     PCcy          I#RCCY
     C                   MOVEL     WWLI35        I#ACLN
     C                   MOVEL     '5XX'         I#MTYP                                     AR589197

     C                   CLEAR                   DSOParm
     C                   CLEAR                   DSEParm
     C                   EVAL      E#CPGM  = 'SETSSIDSP'
     C                   EVAL      E#MSGD  = 'MEC0018'
     C                   EVAL      E#MSGF  = 'MEMSG'

     C                   MOVEL     WBENF         WACLN

     C                   EXSR      SRME9940

      ** If no issuer code defined for the currency clearing system,
      ** set flag to display warning message for later display.

     C                   IF        WICNIL = 'Y'
     C                   EVAL      BOF1Ok = 'W'
     C**********         EVAL      Idx = Idx + 1                                            AR589197
     C**********         EVAL      FldNameArr(Idx) = '#1BOF1'                               AR589197
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5176'                                AR589197
     C                   EVAL      WIdx = WIdx + 1                                          AR589197
     C                   EVAL      WFldNamArr(WIdx) = '#1BOF1'                              AR589197
     C                   EVAL      WMsgIdArr(WIdx) = 'SEW5176'                              AR589197
     C                   EVAL      WICNIL = *BLANK
     C                   ENDIF

     C                   MOVEL     WWLI35        WBENF

     C                   ENDIF

     C                   IF        WErr35 <> 'Y'
     C                   MOVEL     WWLI35        #1BOF1
     C                   ELSE
     C                   EVAL      BOF1Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BOF1'
     C                   EVAL      MsgIdArr(Idx) = WErr35Msg
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Validate beneficiary of money line (2nd line)
      ** ---------------------------------------------

      ** Validate if not blank and #1BOF1 not in error

     C                   MOVEL     #1BOF2        WWBOF2
     C                   IF        #1BOF2 <> *BLANKS AND WWBOF2 <> '#' AND
     C                             BOF1Ok <> 'N'

     C                   IF        #1BOF1 = *BLANKS
     C                   EVAL      BOF2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BOF2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   ENDIF

     C                   IF        WWBOF1 <> '/' AND WWBOF2 = '/'
     C                   EVAL      BOF2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BOF2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5256'
     C                   ENDIF

     C                   MOVEL     #1BOF2        WWLI02
     C                   IF        WWBOF2 = '/' AND WWLI02 <> '//'
     C                   EVAL      BOF2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BOF2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5257'
     C                   ENDIF

     C                   IF        #1BOF1 = #1BOF2
     C                   EVAL      BOF2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BOF2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF                                                                210278
     C                                                                                        CSW210
     C                   IF        PCFT004 = 'Y' AND                                          CSW210
     C                             PCSW210 = 'Y'                                              CSW210
     C                   EVAL      MsgLine = *Blank                                           CSW210
     C                   EVAL      DSACB1 = #1BOF1                                            CSW210
     C                   EXSR      SRIBAN                                                     CSW210
     C                   IF        IBANFlg = 'Y'                                            AR578911
     C                   EVAL      #1BOF1 = DSACB1                                          AR578911
     C                   ENDIF                                                              AR578911
                                                                                              CSW210
     C                   IF        @Rcode <> *Blanks AND                                      CSW210
     C                             IBANFlg = 'Y'                                              CSW210
     C                   MOVEL     '#1BOF1'      WFldNam                                      CSW210
     C                   EVAL      WMsgID = WMsgIdArr(WIdx)                                   CSW210
     C                   EVAL      WFldVal = #1BOF1                                           CSW210
                                                                                              CSW210
     C                   IF        MsgLine = PrevMsg(4)                                       CSW210
     C                   EVAL      BOF1Ok = 'Y'                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WMsgIdArr(WIdx) = *Blank                                   CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WIdx = WIdx - 1                                            CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      BOF1Ok = 'W'                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = '#1BOF1    '                            CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = XBOF1                                   CSW210
     C                   MOVE      MsgLine       PrevMsg(4)                                   CSW210
     C                   EVAL      PrevFlg = 'Y'                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210

      ** Validate sender to receiver info (line 1)
      ** -----------------------------------------

     C                   EVAL      WKSRL1 = *BLANK
     C                   EVAL      WWSRL1 = *BLANK
     C                   EVAL      WWVALI = *BLANK

      ** Validate if not blank

     C                   IF        #1SRL1 <> *BLANKS

     C                   MOVEL     #1SRL1        WWSRL1
     C                   IF        WWSRL1 = '/'

     C                   IF        PAdDType = 'S'
     C                   MOVEL     #1SRL1        WWSR10
     C                   MOVEL     WWSR10        WWSR06
     C                   MOVE      WWSR10        WWSR04

     C                   IF        WWSR06 = '/PRIOR' AND WWSR04 = 'REQ/'
     C                   EVAL      WWVALI = 'Y'
     C                   EVAL      WKSRL1 = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        PAdDType = 'P'
     C                   MOVEL     #1SRL1        WWSR10
     C                   MOVEL     WWSR10        WWSR06
     C                   MOVE      WWSR10        WWSR04

     C                   IF        WWSR06 = '/TRADE' AND WWSR04 = 'CP/ '
     C                   EVAL      WWVALI = 'Y'
     C                   EVAL      WKSRL1 = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   MOVEL     #1SRL1        WWSR06
     C                   MOVEL     #1SRL1        WWSR07
     C                   MOVEL     #1SRL1        WWSR08
     C                   IF        WWSR06 = '/AGEN/' OR  WWSR06 = '/PRIN/' OR
     C                             WWSR06 = '/PHON/'
     C                   EVAL      WWVALI = 'Y'
     C                   ENDIF

     C                   IF        WWSR07 = '/TELEX/'
     C                   EVAL      WWVALI = 'Y'
     C                   ENDIF

     C                   IF        WWSR08 = '/BROKER/'
     C                   EVAL      WWVALI = 'Y'
     C                   ENDIF

     C                   IF        PCSW014 = 'Y'
     C                   MOVEL     #1SRL1        WWSR06
     C                   IF        WWSR06 = '/OCMT/'
     C                   EVAL      WWVALI = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        WWVALI <> 'Y'
     C                   EVAL      SRL1Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL1'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5265'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Validate sender to receiver info (line 2)
      ** -----------------------------------------

     C                   EVAL      WWSRL2 = *BLANK
     C                   EVAL      WWVALI = *BLANK

      ** Validate if not blank

     C                   IF        #1SRL2 <> *BLANKS

     C                   IF        #1SRL1 = *BLANK
     C                   EVAL      SRL2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   ENDIF


     C                   MOVEL     #1SRL2        WWSRL2
     C                   IF        WWSRL1 <> '/' AND WWSRL2 = '/'
     C                   EVAL      SRL2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5256'
     C                   ENDIF

     C                   MOVEL     #1SRL2        WWLI02
     C                   IF        WKSRL1 = *BLANK AND WWSRL1 = '/' AND
     C                             WWLI02 <> '//'
     C                   EVAL      SRL2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5214'
     C                   ENDIF

     C                   IF        WWSRL2 = '/' AND WWLI02 <> '//'
     C                   EVAL      SRL2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5257'
     C                   ENDIF

     C                   MOVE      #1SRL2        WWLI33
     C                   IF        WWLI02 = '//' AND WWLI33 = *BLANKS
     C                   EVAL      SRL2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   ENDIF

     C                   IF        #1SRL2 = #1SRL1
     C                   EVAL      SRL2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   ENDIF

     C                   IF        WKSRL1 <> *BLANK AND #1SRL2 <> *BLANKS
     C                   EVAL      SRL2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5259'
     C                   ENDIF

     C                   ENDIF

      ** Validate sender to receiver info (line 3)
      ** -----------------------------------------

     C                   EVAL      WWSRL3 = *BLANK

      ** Validate if not blank

     C                   IF        #1SRL3 <> *BLANKS

     C                   IF        #1SRL2 = *BLANK
     C                   EVAL      SRL3Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL3'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   ENDIF

     C                   MOVEL     #1SRL3        WWSRL3
     C                   IF        WWSRL2 <> '/' AND WWSRL3 = '/'
     C                   EVAL      SRL3Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL3'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5256'
     C                   ENDIF

     C                   MOVEL     #1SRL3        WWLI02
     C                   IF        WWSRL2 = '/' AND WWLI02 <> '//'
     C                   EVAL      SRL3Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL3'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5214'
     C                   ENDIF

     C                   IF        WWSRL2 = '/' AND WWLI02 <> '//'
     C                   EVAL      SRL3Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL3'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5257'
     C                   ENDIF

     C                   MOVE      #1SRL3        WWLI33
     C                   IF        WWLI02 = '//' AND WWLI33 = *BLANKS
     C                   EVAL      SRL3Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL3'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   ENDIF

     C                   IF        #1SRL3 = #1SRL2
     C                   EVAL      SRL3Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1SRL3'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   ENDIF

     C                   ENDIF

      ** Validate narrative (line 1)
      ** ---------------------------

     C                   EVAL      WWNAC1 = *BLANK

      ** Validate if not blank

     C                   IF        #1NAC1 <> *BLANKS

     C                   MOVEL     #1NAC1        WWNAC1
     C                   MOVE      #1NAC1        WWLI34
     C                   IF        WWNAC1 = '/' AND WWLI34 = *BLANKS
     C                   EVAL      NAC1Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1NAC1'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5263'
     C                   ENDIF

     C                   ENDIF

      ** Validate narrative (line 2)
      ** ---------------------------

     C                   EVAL      WWNAC2 = *BLANK

      ** Validate if not blank

     C                   IF        #1NAC2 <> *BLANKS

     C                   IF        #1NAC1 = *BLANKS
     C                   EVAL      NAC2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1NAC2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   ENDIF

     C                   MOVEL     #1NAC2        WWNAC2
     C                   IF        WWNAC1 <> '/' AND WWNAC2 = '/'
     C                   EVAL      NAC2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1NAC2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5256'
     C                   ENDIF

     C                   MOVEL     #1NAC2        WWLI02
     C                   IF        WWNAC1 = '/' AND WWLI02 <> '//'
     C                   EVAL      NAC2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1NAC2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5214'
     C                   ENDIF

     C                   IF        WWNAC2 = '/' AND WWLI02 <> '//'
     C                   EVAL      NAC2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1NAC2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5257'
     C                   ENDIF

     C                   MOVE      #1NAC2        WWLI33
     C                   IF        WWLI02 = '//' AND WWLI33 = *BLANKS
     C                   EVAL      NAC2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1NAC2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   ENDIF

     C                   IF        #1NAC2 = #1NAC1
     C                   EVAL      NAC2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1NAC2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   ENDIF

      ** May not be blank as a continuation line

     C                   ELSE

     C                   MOVEL     #1NAC2        WWLI02
     C                   IF        WWNAC1 = '/' AND WWLI02 <> '//'
     C                   EVAL      NAC2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1NAC2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5214'
     C                   ENDIF

     C                   ENDIF

      ** End of validation for screen1 of internal customer
      ** ==================================================

     C                   ELSE

      ** Validate screen 1 of non-internal customer
      ** ==========================================

      ** Validate settlement message request
      ** -----------------------------------

      ** If #2GMES is not 'Y', 'N', or blank

     C                   IF        #2GMES <> 'Y' AND #2GMES <> 'N' AND
     C                             #2GMES <> *BLANKS
     C                   EVAL      GMESOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#2GMES'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5101'
     C                   ENDIF

      ** Validate confirmation message request
      ** -------------------------------------

      ** If #2CONG is not 'Y' , 'N' or blank

     C                   IF        #2CONG <> 'Y' AND #2CONG <> 'N' AND
     C                             #2CONG <> *BLANKS
     C                   EVAL      CONGOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#2CONG'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5101'
     C                   ENDIF

      **  If #2CONG is 'Y' then check that the counterparty has a STTX
      **  or SWIFT ADDRESS or TELEX ADDRESS.

     C                   IF        #2CONG = 'Y'
     C**********         MOVEL     PACUST        PCustKey                                     201190
     C**********         MOVEL     #1CUST        PCustKey                            201190 AR579693
     C                   EVAL      PCustKey = #1CUST                                        AR579693
     C                   EXSR      SRCUST

     C                   IF        BBCSID = *BLANKS AND BBSTAD = *BLANKS AND
     C                             BBTXA1 = *BLANKS
     C                   EVAL      CONGOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#2CONG'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5127'
     C                   ENDIF
     C                   ENDIF

      ** Validate instructions type if not blank
      ** ---------------------------------------

     C                   IF        #2INST <> *BLANKS

      ** Check instructions type as a alpha input field

     C     #2INST        LOOKUP    VA1                                    86

     C                   ENDIF

      ** Validate instructions sub-type if not blank
      ** -------------------------------------------

     C                   IF        #2INSS <> *BLANKS

      ** Check internal of bridge instruction sub-type

     C                   IF        #2INST = 'INT' OR #2INST = 'BRG'

     C                   IF        #2INSS <> 'SETTL' AND #2INSS <> 'MATCH' AND
     C                             #2INSS <> 'TRANS'
     C                   EVAL      INSSOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#2INSS'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5104'
     C                   ENDIF
     C                   ENDIF

     C                   IF        #2INST = 'EXT'

     C                   IF        #2INSS <> 'BOOK ' AND #2INSS <> ' BOOK' AND
     C                             #2INSS <> 'PHYSI'
     C                   EVAL      INSSOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#2INSS'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5105'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   IF        PISOMsgI <> 'Y'                                            199797
                                                                                              199797
      ** Validate requested priority
      ** ---------------------------

      ** If #2RPTY  not '1', '2', '3', '4', or blank

     C                   IF        #2RPTY <> '1' AND #2RPTY <> '2' AND
     C                             #2RPTY <> '3' AND #2RPTY <> '4' AND
     C                             #2RPTY <> *BLANK
     C                   EVAL      RPTYOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#2RPTY'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5125'
     C                   ENDIF

      ** Validate guaranteed delivery
      ** ----------------------------

      ** If #2GDEL not 'G' or blank

     C                   IF        #2GDEL <> 'G' AND #2GDEL <> *BLANK
     C                   EVAL      GDELOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#2GDEL'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5150'
     C                   ENDIF

      ** Validate sender's role
      ** ----------------------

      ** If #2SROL not 'AGEN', 'CUST', 'PRIN', or blank

     C                   IF        #2SROL <> 'AGEN' AND #2SROL <> 'CUST' AND
     C                             #2SROL <> 'PRIN' AND #2SROL <> *BLANKS
     C                   EVAL      SROLOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#2SROL'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5165'
     C                   ENDIF
                                                                                              199797
     C                   ENDIF                                                                199797

      ** Validate stamp status
      ** ---------------------

     C                   EVAL      STMPOk = 'Y'

      ** Validate charity identifier
      ** ---------------------------

     C                   EVAL      CHIDOk = 'Y'

      ** Validate transaction report maker
      ** ---------------------------------

     C                   EVAL      TRRMOk = 'Y'

      ** Validate settlement against payment/free
      ** ----------------------------------------

      ** If #2FIND is not 'F' or 'A', or blanks

     C                   IF        #2FIND <> 'F' AND #2FIND <> 'A' AND
     C                             #2FIND <> *BLANKS
     C                   EVAL      FINDOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#2FIND'
     C                   EVAL      MsgIdArr(Idx) = 'SE10032'
     C                   ENDIF

      ** End of validation for screen1 of non-internal customer
      ** ======================================================

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay2 - Display 2nd screen of additional information    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRDisplay2    BEGSR

      ** Move 'OK' flags into array for checking

     C                   MOVEA     OkFlags       WErrIndArr

      ** Set screen error indicators according to status of 'OK' flags

     C                   Z-ADD     24            WCtr1
     C                   Z-ADD     33            WCtr2

     C                   DOU       WCtr1 > 50

     C                   IF        WErrIndArr(WCtr1) = 'N' OR
     C                             WErrIndArr(WCtr1) = 'W'
     C                   EVAL      *IN(WCtr2) = '1'
     C                   ENDIF

     C                   EVAL      WCtr1 = WCtr1 + 1
     C                   EVAL      WCtr2 = WCtr2 + 1

     C                   ENDDO

      ** The following /COPY line includes processing for the error and
      ** warning messages.

      /COPY ZACPYSRC,MSGHNDDSP1

      ** Write message subfile, details and footer screen

     C                   EVAL      DspRollDn = True

     C                   IF        PISOMsgI = 'Y'
     C                   EVAL      DspRollUp = True
     C                   ELSE
     C                   EVAL      DspRollUp = False
     C                   ENDIF

     C                   WRITE     SETSSIDSF6
     C                   WRITE     SETSSIDSC1

     C                   IF        PAdDType = 'P'
     C                   EXFMT     SETSSIDSF3
     C                   ELSE
     C                   EXFMT     SETSSIDSF4
     C                   ENDIF

      ** Clear message subfile

     C                   CALL      'ZA0250'

      ** Reset error fields

     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0                                                   CSW210
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WFldNamArr                                   CSW210

      ** Set screen error indicators off

     C                   MOVEA     WInzIndArr    *IN(10)
     C                   MOVEA     WInzOkFlags   OkFlags

      ** Select processing type

     C                   SELECT

      ** F3 Pressed

     C                   WHEN      *INKC = *ON
     C                   EVAL      PRetCode = 'SE10000'
     C                   EVAL      PMode = 'R'

      ** F5 Pressed

     C                   WHEN      *INKE = *ON
     C                   EXSR      SRSetScnFld2

      ** F12 Pressed

     C                   WHEN      *INKL = *ON
     C                   EVAL      PRetCode = 'SE10001'
     C                   EVAL      PMode = 'R'

      ** Roll Down

     C                   WHEN      RollDn = True
     C                   EVAL      PMode = '1'

     C                   OTHER

      ** Validate inputs

     C                   IF        ActionCode <> 'E'

     C                   EXSR      SRValidate2

     C                   IF        Idx = 0

     C                   IF        PISOMsgI = 'Y'
     C                   IF        WAGNA <> 'N'                                               201486
     C                   EVAL      PMode = '3'
     C                   ENDIF                                                                201486
     C                   ELSE
     C                   IF        WAGNA <> 'N'                                               201486
     C                   EVAL      PMode = 'U'
     C                   ENDIF                                                                201486
     C                   ENDIF

     C                   ELSE

     C                   EVAL      PMode = '2'

     C                   ENDIF

     C                   ELSE

     C                   IF        PISOMsgI = 'Y'
     C                   EVAL      PMode = '3'
     C                   ELSE
     C                   EVAL      PMode = 'R'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate2 - Validate screen2 fields                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRValidate2   BEGSR

      ** Validate clearing correspondent
      ** -------------------------------

     C                   IF        PAdDType = 'P'
     C                   EVAL      WkCCTN = #3CCTN
     C                   ELSE
     C                   EVAL      WkCCTN= #4CCTN
     C                   ENDIF

      ** Validate if not blank

     C                   IF        WkCCTN <> *BLANKS
      **********                                                                              199797
      ** Check entry is alphanumeric with no embedded blanks                                  199797
      **********                                                                              199797
     C**********         MOVEA     WkCCTN        CCTNArr                                      199797
     C**********         EVAL      *IN86 = '0'                                                199797
     C**********         EVAL      *IN87 = '0'                                                199797
     C**********         EVAL      WCtr1 = 1                                                  199797
      **********                                                                              199797
     C**********         DOW       WCtr1 <= 12 AND *IN87  = *OFF                              199797
      **********                                                                              199797
     C**********         IF        CCTNArr(WCtr1) = ' '                                       199797
     C**********         EVAL      *IN87 = *ON                                                199797
     C**********         ELSE                                                                 199797
      **********                                                                              199797
     C*****CCTNArr(WCtr1)LOOKUP    VA0                                    86                  199797
     C**********         IF        *IN86 = *OFF                                               199797
     C**********         EVAL      *IN87 = *ON                                                199797
     C**********         ENDIF                                                                199797
      **********                                                                              199797
     C**********         ENDIF                                                                199797
      **********                                                                              199797
     C**********         EVAL      WCtr1 = WCtr1 + 1                                          199797
      **********                                                                              199797
     C**********         ENDDO                                                                199797
     C***********        MOVEL     WkCCTN        WkVar1            1                   204751 204804
     C                   MOVEL     WkCCTN        WkVar10          10                          204751
     C***********        IF        WkVar1 = '?'                                        204751 204804
     C*                                                                                       204751
     C                   CALLB     'AOCUSTR0'                                                 204751
     C                   PARM      *BLANKS       WkRtCd            7                          204751
     C                   PARM      '*KEY   '     WkOptn            7                          204751
     C                   PARM                    WkVar10                                      204751
     C                   PARM                    WkKeySts          7                          204751
     C     SDCUST        PARM      SDCUST        DSSDY                                        204751
                                                                                              204751
     C                   IF        WkRtCd = *BLANK AND                                        204751
     C                             WkKeySts <> '*ERROR'                                       204751
     C                   IF        PAdDType = 'P'                                             204751
     C                   EVAL      #3CCTN = BBCSID                                            204751
     C                   ELSE                                                                 204751
     C                   EVAL      #4CCTN = BBCSID                                            204751
     C**********         ENDIF                                                         204751 204804
     C                   ENDIF                                                                204751
                                                                                              204751
     C                   ELSE                                                                 204751
                                                                                              199797
     C     *LOVAL        SETLL     SDCUSTSW                                                   199797
     C     WkCCTN        CHAIN     SDCUSTSW                           99                      199797

     C**********         IF        *IN87 = *ON                                                199797
     C                   IF        *IN99 = '1'                                                199797
      *                                                                                       204364
      ** Check if SWIFT Address exist in BIC file                                             204364
      *                                                                                       204364
     C                   CALL      'AOBICDV0'                                                 204364
     C                   PARM      *BLANKS       @CRtCd            7                          204364
     C                   PARM                    WkCCTN                                       204364
     C                   PARM                    @CType            7                          204364
     C                   PARM                    DSSDY                                        204364
                                                                                              204364
     C                   MOVE      WkCCTN        WkVar1            1                          204704
                                                                                              204704
     C                   IF        @CRtCd <> '*BICFND' AND                                    204364
     C                             @CType <> '*BIC'                                           204364
     C                             OR WkVar1 <> ' '                                           204704
     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PCCTNOk = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3CCTN'
     C                   ELSE
     C                   EVAL      SCCTNOk = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4CCTN'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5276'
     C                   ENDIF
     C                   ENDIF                                                                204364
     C                   ENDIF                                                                204751

     C                   ENDIF

      ** Validate deliverer/receiver of securities
      ** -----------------------------------------

     C                   IF        PAdDType = 'P'
     C                   EVAL      WkDRSN = #3DRSN
     C                   ELSE
     C                   EVAL      WkDRSN= #4DRSN
     C                   ENDIF

      ***********                                                                      201429 204585
      ***Field*is*mandatory*for*Depot-in*and*settlement*message********                201429 204585
      ***requested*is*'Y'*and*ISO15022*is*set*to*'Y'.******************                201429 204585
      ***********                                                                      201429 204585
     C***********        IF        #2GMES = 'Y' AND PISOMsgI = 'Y'                     201429 204585
     C***********                  AND WkDRSN = *BLANKS                                201429 204585
     C***********        EVAL      Idx = Idx + 1                                       201429 204585
     C***********        EVAL      OkDRSN = 'N'                                        201429 204585
     C***********        IF        PAdDType = 'P'                                      201429 204585
     C***********        EVAL      PDRSNOk = 'N'                                       201429 204585
     C***********        EVAL      MsgIdArr(Idx) = 'SEW9003'                           201429 204585
     C***********        EVAL      FldNameArr(Idx) = '#3DRSN'                          201429 204585
     C***********        ELSE                                                          201429 204585
     C***********        EVAL      SDRSNOk = 'N'                                       201429 204585
     C***********        EVAL      MsgIdArr(Idx) = 'SEW9006'                           201429 204585
     C***********        EVAL      FldNameArr(Idx) = '#4DRSN'                          201429 204585
     C***********        ENDIF                                                         201429 204585
     C***********        ENDIF                                                         201429 204585
                                                                                              201429
      ** Validate if not blank

     C                   IF        WkDRSN <> *BLANKS
     C                   MOVEL     WkDRSN        PCustKey

      ** Validate Customer Number/Shortname/Nostro

     C                   EXSR      SRCust

     C                   EVAL      OkDRSN = *BLANKS                                           201486
                                                                                              201486
     C                   IF        WCustType <> 'C' AND WCustType <> 'S' AND
     C                             WCustType <> 'N'
     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRSNOk = 'N'
     C                   EVAL      OkDRSN = 'N'                                               201486
     C                   EVAL      FldNameArr(Idx) = '#3DRSN'
     C                   ELSE
     C                   EVAL      SDRSNOk = 'N'
     C                   EVAL      OkDRSN = 'N'                                               201486
     C                   EVAL      FldNameArr(Idx) = '#4DRSN'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5205'
     C                   ELSE

      ** If customer or shortame

     C**********         IF        WCustType = 'C' AND WCustType = 'S'                        204753
     C                   IF        WCustType = 'C' OR WCustType = 'S'                         204753
     C                   IF        PAdDType = 'P'
     C                   EVAL      #3DRSN = BBCUST
     C                   ELSE
     C                   EVAL      #4DRSN = BBCUST
     C                   ENDIF

      ** Entry is Nostro

     C                   ELSE

     C                   IF        WCustType = 'N'
     C                   IF        PAdDType = 'P'
     C                   EVAL      #3DRSN = AWCPNC
     C                   ELSE
     C                   EVAL      #4DRSN = AWCPNC
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
                                                                                              201486
     C                   IF        PAdDType = 'P'                                             201486
     C                   EVAL      WkDRSN = #3DRSN                                            201486
     C                   EVAL      WkDRS1 = #3DRS1                                            201486
     C                   ELSE                                                                 201486
     C                   EVAL      WkDRSN = #4DRSN                                            201486
     C                   EVAL      WkDRS1 = #4DRS1                                            201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   EVAL      WAGNA = 'Y'                                                201486
                                                                                              201486
     C                   IF        WkDRSN = TkDRSN and WkDRS1 = *BLANKS                       201486
     C                   EVAL      WAGNA = *BLANKS                                            201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   IF        OkDRSN <> 'N' and WkDRSN <> *BLANKS and                    201486
     C                             WkDRS1  = *BLANKS and WAGNA <> *BLANKS                     201486
                                                                                              201486
     C                   EVAL      TkDRSN = WkDRSN                                            201486
     C                   EVAL      PDepotCNum = WkDRSN                                        201486
                                                                                              201486
     C                   IF        PCBInd = 'C'                                               201486
     C                   EVAL      PCntrPCNum = PCustomer                                     201486
     C                   ELSE                                                                 201486
     C                   EVAL      PCntrPCNum = A8BICN                                        201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   EXSR      SRDORF                                                     201486
                                                                                              201486
     C                   IF        PSKALREF <> *BLANKS                                        201486
                                                                                              201486
     C                   EVAL      WkDRS1 = PSKALRef                                          201486
     C                   EVAL      WAGNA = 'N'                                                201486
                                                                                              201486
     C                   IF        PAdDType = 'P'                                             201486
     C                   EVAL      #3DRS1 = WkDRS1                                            201486
     C                   ELSE                                                                 201486
     C                   EVAL      #4DRS1 = WkDRS1                                            201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486

      ** Validate deliverer/receiver of securities line 1
      ** ------------------------------------------------

     C                   IF        PISOMsgI <> 'Y'                                            199797
                                                                                              199797
     C                   IF        PAdDType = 'P'
     C                   EVAL      WkDRS1 = #3DRS1
     C                   ELSE
     C                   EVAL      WkDRS1= #4DRS1
     C                   ENDIF

      ** Validate if not blank

     C                   MOVEL     WkDRS1        WWDRS1
     C                   IF        WkDRS1 <> *BLANKS AND WWDRS1 <> '#'

     C                   IF        WWDRS1 <> '/'

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS1'
     C                   ELSE
     C                   EVAL      SDRS1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS1'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5210'

     C                   ENDIF

     C                   MOVEL     WkDRS1        WWLI02
     C                   IF        WWLI02 = '//'

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS1'
     C                   ELSE
     C                   EVAL      SDRS1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS1'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5211'

     C                   ENDIF

     C                   MOVE      WkDRS1        WWLI34
     C                   IF        WWDRS1 = '/' AND WWLI34 = *BLANKS

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS1'
     C                   ELSE
     C                   EVAL      SDRS1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS1'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5212'

     C                   ENDIF

     C                   ENDIF

      ** Validate deliverer/receiver of securities line 2
      ** ------------------------------------------------

     C                   IF        PAdDType = 'P'
     C                   EVAL      WkDRS2 = #3DRS2
     C                   ELSE
     C                   EVAL      WkDRS2= #4DRS2
     C                   ENDIF

      ** Validate if not blank

     C                   MOVEL     WkDRS2        WWDRS2
     C                   IF        WkDRS2 <> *BLANKS AND WWDRS2 <> '#' AND
     C                             PDRS1Ok <> 'N' AND SDRS1Ok <> 'N'

     C                   IF        WkDRS1 = *BLANKS

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS2'
     C                   ELSE
     C                   EVAL      SDRS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'

     C                   ENDIF

     C                   IF        WkDRS2 = WkDRS1

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS2'
     C                   ELSE
     C                   EVAL      SDRS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'

     C                   ENDIF

     C                   MOVEL     WkDRS2        WWLI02
     C                   MOVE      WkDRS2        WWLI33
     C                   IF        WWLI02 <> '//' OR WWLI33 = *BLANKS

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS2'
     C                   ELSE
     C                   EVAL      SDRS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'

     C                   ENDIF

     C                   ENDIF

      ** Validate deliverer/receiver of securities line 3
      ** ------------------------------------------------

     C                   IF        PAdDType = 'P'
     C                   EVAL      WkDRS3 = #3DRS3
     C                   ELSE
     C                   EVAL      WkDRS3= #4DRS3
     C                   ENDIF

      ** Validate if not blank

     C                   MOVEL     WkDRS3        WWDRS3
     C                   IF        WkDRS3 <> *BLANKS AND WWDRS3 <> '#' AND
     C                             PDRS1Ok <> 'N' AND SDRS1Ok <> 'N'  AND
     C                             PDRS2Ok <> 'N' AND SDRS2Ok <> 'N'

     C                   IF        WkDRS2 = *BLANKS

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS3Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS3'
     C                   ELSE
     C                   EVAL      SDRS3Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS3'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'

     C                   ENDIF

     C                   IF        WkDRS3 = WkDRS1 OR WkDRS3 = WkDRS2

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS3Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS3'
     C                   ELSE
     C                   EVAL      SDRS3Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS3'
     C                   ENDIF

     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   ENDIF

     C                   MOVEL     WkDRS3        WWLI02
     C                   MOVE      WkDRS3        WWLI33
     C                   IF        WWLI02 <> '//' OR WWLI33 = *BLANKS

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS3Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS3'
     C                   ELSE
     C                   EVAL      SDRS3Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS3'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'

     C                   ENDIF

     C                   ENDIF

      ** Validate deliverer/receiver of securities line 4
      ** ------------------------------------------------

     C                   IF        PAdDType = 'P'
     C                   EVAL      WkDRS4 = #3DRS4
     C                   ELSE
     C                   EVAL      WkDRS4= #4DRS4
     C                   ENDIF

      ** Validate if not blank

     C                   MOVEL     WkDRS4        WWDRS4
     C                   IF        WkDRS4 <> *BLANKS AND WWDRS4 <> '#' AND
     C                             PDRS1Ok <> 'N' AND SDRS1Ok <> 'N'  AND
     C                             PDRS2Ok <> 'N' AND SDRS2Ok <> 'N'  AND
     C                             PDRS3Ok <> 'N' AND SDRS3Ok <> 'N'

     C                   IF        WkDRS3 = *BLANKS

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS4Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS4'
     C                   ELSE
     C                   EVAL      SDRS4Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS4'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'

     C                   ENDIF

     C                   IF        WkDRS4 = WkDRS1 OR WkDRS4 = WkDRS2 OR
     C                             WkDRS4 = WkDRS3

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS4Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS4'
     C                   ELSE
     C                   EVAL      SDRS4Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS4'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'

     C                   ENDIF

     C                   MOVEL     WkDRS4        WWLI02
     C                   MOVE      WkDRS4        WWLI33
     C                   IF        WWLI02 <> '//' OR WWLI33 = *BLANKS

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PDRS4Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3DRS4'
     C                   ELSE
     C                   EVAL      SDRS4Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4DRS4'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'

     C                   ENDIF

     C                   ENDIF
                                                                                              199797
     C                   ENDIF                                                                199797

      ** Validate beneficiary securities
      ** -------------------------------

     C                   IF        PAdDType = 'S'

      ** Validate beneficiary securities number
      ** --------------------------------------

      ** Validate if not blank

     C                   IF        #4BSSN <> *BLANKS
     C                   MOVEL     #4BSSN        PCustKey

      ** Validate Customer Number/Shortname/Nostro

     C                   EXSR      SRCust

     C                   IF        WCustType <> 'C' AND WCustType <> 'S' AND
     C                             WCustType <> 'N'
     C                   EVAL      BSSNOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#4BSSN'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5205'
     C                   ELSE

      ** If customer or shortame a/c must be a bank

     C**********         IF        WCustType = 'C' AND WCustType = 'S'                      AR634357
     C                   IF        WCustType = 'C' OR WCustType = 'S'                       AR634357
     C                   EVAL      #4BSSN = BBCUST

      ** Entry is Nostro

     C                   ELSE

     C                   IF        WCustType = 'N'
     C                   EVAL      #4BSSN = AWCPNC
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   EVAL      WANGA = 'Y'                                                201486
                                                                                              201486
     C                   IF        #4BSSN = T4BSSN and #4BSS1 = *BLANKS                       201486
     C                   EVAL      WANGA = *BLANKS                                            201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   IF        BSSNOk <> 'N' and #4BSSN <> *BLANKS and                    201486
     C                             #4BSS1  = *BLANKS and WANGA <> *BLANKS                     201486
                                                                                              201486
     C                   EVAL      T4BSSN = #4BSSN                                            201486
     C                   EVAL      PDepotCNum = #4BSSN                                        201486
                                                                                              201486
     C                   IF        PCBInd = 'C'                                               201486
     C                   EVAL      PCntrPCNum = PCustomer                                     201486
     C                   ELSE                                                                 201486
     C                   EVAL      PCntrPCNum = A8BICN                                        201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   EXSR      SRDORF                                                     201486
                                                                                              201486
     C                   IF        PSKALREF <> *BLANKS                                        201486
                                                                                              201486
     C                   EVAL      #4BSS1 = PSKALRef                                          201486
     C                   EVAL      WAGNA = 'N'                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
      ** Validate beneficiary securities account line 1
      ** ----------------------------------------------

     C                   IF        PISOMsgI <> 'Y'                                            199797
                                                                                              199797
     C                   MOVEL     #4BSS1        WWBSS1
     C                   IF        #4BSS1 <> *BLANKS AND WWBSS1 <> '#'

     C                   IF        WWBSS1 <> '/'
     C                   EVAL      BSS1Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#4BSS1'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5210'
     C                   ENDIF

     C                   MOVEL     #4BSS1        WWLI02
     C                   IF        WWLI02 = '//'
     C                   EVAL      BSS1Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#4BSS1'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5211'
     C                   ENDIF

     C                   MOVE      #4BSS1        WWLI34
     C                   IF        WWBSS1 = '/' AND WWLI34 = *BLANKS
     C                   EVAL      BSS1Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#4BSS1'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5212'
     C                   ENDIF

     C                   ENDIF

      ** Validate beneficiary securities account line 2
      ** ----------------------------------------------

     C                   MOVEL     #4BSS2        WWBSS2
     C                   IF        #4BSS2 <> *BLANKS AND WWBSS2 <> '#' AND
     C                             BSS1Ok <> 'N'

     C                   IF        #4BSS1 = *BLANKS
     C                   EVAL      BSS2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#4BSS2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   ENDIF

     C                   IF        #4BSS2 = #4BSS1
     C                   EVAL      BSS2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#4BSS2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   ENDIF

     C                   MOVEL     #4BSS2        WWLI02
     C                   MOVE      #4BSS2        WWLI33
     C                   IF        WWLI02 <> '//' OR WWLI33 = *BLANKS
     C                   EVAL      BSS2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#4BSS2'
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   ENDIF

     C                   ENDIF
                                                                                              199797
     C                   ENDIF                                                                199797

      ** End validation of beneficiary of securities
      ** -------------------------------------------

     C                   ENDIF


      ** Validate further information line 1
      ** -----------------------------------

     C                   IF        PAdDType = 'P'
     C                   EVAL      WkFIN1 = #3FIN1
     C                   ELSE
     C                   EVAL      WkFIN1= #4FIN1
     C                   ENDIF

      ** Validate if not blank

     C                   MOVEL     WkFIN1        WWFIN1
     C                   IF        WkFIN1 <> *BLANKS

     C                   IF        WWFIN1 = '/'

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PFIN1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3FIN1'
     C                   ELSE
     C                   EVAL      SFIN1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4FIN1'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5285'

     C                   ENDIF

     C                   ENDIF

      ** Validate further information line 2
      ** -----------------------------------

     C                   IF        PAdDType = 'P'
     C                   EVAL      WkFIN2 = #3FIN2
     C                   ELSE
     C                   EVAL      WkFIN2= #4FIN2
     C                   ENDIF

      ** Validate if not blank

     C                   MOVEL     WkFIN2        WWFIN2
     C                   IF        WkFIN2 <> *BLANKS  AND PFIN1OK <> 'N' AND
     C                             SFIN1OK <> 'N'

     C                   IF        WkFIN1 = *BLANKS

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PFIN2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3FIN2'
     C                   ELSE
     C                   EVAL      SFIN2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4FIN2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'

     C                   ENDIF

     C                   IF        WkFIN2 = WkFIN1

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PFIN2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3FIN2'
     C                   ELSE
     C                   EVAL      SFIN2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4FIN2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'

     C                   ENDIF


     C                   IF        WWFIN2 = '/'

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PFIN2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3FIN2'
     C                   ELSE
     C                   EVAL      SFIN2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4FIN2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5285'

     C                   ENDIF

     C                   ENDIF

      ***Validate*registration*details*line*1**                                               CSW210
      ***------------------------------------**                                               CSW210

     C**********         IF        PAdDType = 'P'                                             CSW210
     C**********         EVAL      WkRED1 = #3RED1                                            CSW210
     C**********         ELSE                                                                 CSW210
     C**********         EVAL      WkRED1= #4RED1                                             CSW210
     C**********         ENDIF                                                                CSW210

      ***Validate*if*not*blank**                                                              CSW210

     C**********         MOVEL     WkRED1        WWRED1                                       CSW210
     C**********         IF        WkRED1 <> *BLANKS                                          CSW210

     C**********         IF        WWRED1 = '/'                                               CSW210

     C**********         EVAL      Idx = Idx + 1                                              CSW210
     C**********         IF        PAdDType = 'P'                                             CSW210
     C**********         EVAL      PRED1Ok = 'N'                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#3RED1'                                 CSW210
     C**********         ELSE                                                                 CSW210
     C**********         EVAL      SRED1Ok = 'N'                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#4RED1'                                 CSW210
     C**********         ENDIF                                                                CSW210
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5285'                                  CSW210

     C**********         ENDIF                                                                CSW210

     C**********         ENDIF                                                                CSW210

      ***Validate*registration*details*line*2**                                               CSW210
      ***------------------------------------**                                               CSW210

     C**********         IF        PAdDType = 'P'                                             CSW210
     C**********         EVAL      WkRED2 = #3RED2                                            CSW210
     C**********         ELSE                                                                 CSW210
     C**********         EVAL      WkRED2= #4RED2                                             CSW210
     C**********         ENDIF                                                                CSW210

      ***Validate*if*not*blank**                                                              CSW210

     C**********         MOVEL     WkRED2        WWRED2                                       CSW210
     C**********         IF        WkRED2 <> *BLANKS  AND PRED1OK <> 'N' AND                  CSW210
     C**********                   SRED1OK <> 'N'                                             CSW210

     C**********         IF        WkRED1 = *BLANKS                                           CSW210

     C**********         EVAL      Idx = Idx + 1                                              CSW210
     C**********         IF        PAdDType = 'P'                                             CSW210
     C**********         EVAL      PRED2Ok = 'N'                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#3RED2'                                 CSW210
     C**********         ELSE                                                                 CSW210
     C**********         EVAL      SRED2Ok = 'N'                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#4RED2'                                 CSW210
     C**********         ENDIF                                                                CSW210
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5255'                                  CSW210

     C**********         ENDIF                                                                CSW210

     C**********         IF        WkRED2 = WkRED1                                            CSW210

     C**********         EVAL      Idx = Idx + 1                                              CSW210
     C**********         IF        PAdDType = 'P'                                             CSW210
     C**********         EVAL      PRED2Ok = 'N'                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#3RED2'                                 CSW210
     C**********         ELSE                                                                 CSW210
     C**********         EVAL      SRED2Ok = 'N'                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#4RED2'                                 CSW210
     C**********         ENDIF                                                                CSW210
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5258'                                  CSW210

     C**********         ENDIF                                                                CSW210


     C**********         IF        WWRED2 = '/'                                               CSW210

     C**********         EVAL      Idx = Idx + 1                                              CSW210
     C**********         IF        PAdDType = 'P'                                             CSW210
     C**********         EVAL      PRED2Ok = 'N'                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#3RED2'                                 CSW210
     C**********         ELSE                                                                 CSW210
     C**********         EVAL      SRED2Ok = 'N'                                              CSW210
     C**********         EVAL      FldNameArr(Idx) = '#4RED2'                                 CSW210
     C**********         ENDIF                                                                CSW210
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5285'                                  CSW210

     C**********         ENDIF                                                                CSW210

     C**********         ENDIF                                                                CSW210


      ** Validate narrative line 1
      ** -------------------------

     C                   IF        PAdDType = 'P'
     C                   EVAL      WkNAS1 = #3NAS1
     C                   ELSE
     C                   EVAL      WkNAS1= #4NAS1
     C                   ENDIF

      ** Validate if not blank

     C                   MOVEL     WkNAS1        WWNAS1
     C                   MOVE      WkNAS1        WWLI34
     C                   IF        WkNAS1 <> *BLANKS

     C                   IF        WWNAS1 = '/' AND WWLI34 = *BLANKS

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PNAS1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3NAS1'
     C                   ELSE
     C                   EVAL      SNAS1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4NAS1'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5263'

     C                   ENDIF

     C                   ENDIF

      ** Validate narrative line 2
      ** -------------------------

     C                   IF        PAdDType = 'P'
     C                   EVAL      WkNAS2 = #3NAS2
     C                   ELSE
     C                   EVAL      WkNAS2= #4NAS2
     C                   ENDIF

      ** Validate if not blank

     C                   IF        WkNAS2 <> *BLANKS  AND PNAS1OK <> 'N' AND
     C                             SNAS1OK <> 'N'

     C                   IF        WkNAS1 = *BLANKS

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3NAS2'
     C                   ELSE
     C                   EVAL      SNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4NAS2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'

     C                   ENDIF

     C                   IF        WkNAS2 = WkNAS1

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3NAS2'
     C                   ELSE
     C                   EVAL      SNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4NAS2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'

     C                   ENDIF

     C                   MOVEL     WkNAS2        WWNAS2
     C                   IF        WWNAS1 <> '/' AND WWNAS2 = '/'

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3NAS2'
     C                   ELSE
     C                   EVAL      SNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4NAS2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5256'

     C                   ENDIF

     C                   MOVEL     WkNAS2        WWLI02
     C                   IF        WWNAS1 = '/' AND WWLI02 <> '//'

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3NAS2'
     C                   ELSE
     C                   EVAL      SNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4NAS2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5214'

     C                   ENDIF

     C                   IF        WWNAS2 = '/' AND WWLI02 <> '//'

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3NAS2'
     C                   ELSE
     C                   EVAL      SNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4NAS2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5257'

     C                   ENDIF

     C                   MOVE      WkNAS2        WWLI33
     C                   IF        WWLI02 = '//' AND WWLI33 = *BLANKS

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3NAS2'
     C                   ELSE
     C                   EVAL      SNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4NAS2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'

     C                   ENDIF

     C                   ELSE

      ** May not be blank as a continuation line

     C                   MOVEL     WkNAS2        WWLI02
     C                   IF        WWNAS1 = '/' AND WWLI02 <> '//'

     C                   EVAL      Idx = Idx + 1
     C                   IF        PAdDType = 'P'
     C                   EVAL      PNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#3NAS2'
     C                   ELSE
     C                   EVAL      SNAS2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#4NAS2'
     C                   ENDIF
     C                   EVAL      MsgIdArr(Idx) = 'SEW5214'

     C                   ENDIF

     C                   ENDIF

      ** End of validation for screen2
      ** =============================

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay3 - Display 3rd screen of additional information    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRDisplay3    BEGSR

      ** Move 'OK' flags into array for checking

     C                   MOVEA     OkFlags       WErrIndArr

      ** Set screen error indicators according to status of 'OK' flags


     C                   Z-ADD     51            WCtr1
     C                   Z-ADD     60            WCtr2

     C                   DOU       WCtr1 > 69

     C                   IF        WErrIndArr(WCtr1) = 'N' OR
     C                             WErrIndArr(WCtr1) = 'W'
     C                   EVAL      *IN(WCtr2) = '1'
     C                   ENDIF

     C                   EVAL      WCtr1 = WCtr1 + 1
     C                   EVAL      WCtr2 = WCtr2 + 1

     C                   ENDDO

      ** OKFlags for SWIFT 2010 Changes                                                       CSW210
                                                                                              CSW210
     C                   IF        ReD1Ok = 'N' OR                                            CSW210
     C                             ReD1Ok = 'W'                                               CSW210
     C                   EVAL      *IN41 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        ReD2Ok = 'N' OR                                            CSW210
     C                             ReD2Ok = 'W'                                               CSW210
     C                   EVAL      *IN42 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        PClrOk = 'N' OR                                            CSW210
     C                             PClrOk = 'W'                                               CSW210
     C                   EVAL      *IN56 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        QFInOk = 'N' OR                                            CSW210
     C                             QFInOk = 'W'                                               CSW210
     C                   EVAL      *IN57 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** The following /COPY line includes processing for the error and
      ** warning messages.

      /COPY ZACPYSRC,MSGHNDDSP1

     C                   IF        CSW206 = 'Y'                                              CSW206E
     C                   EVAL      *IN85 = '1'                                               CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      *IN85 = '0'                                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
      ** Write message subfile, details and footer screen

     C                   EVAL      DspRollUp = False
     C                   EVAL      DspRollDn = True

     C                   WRITE     SETSSIDSF6
     C                   WRITE     SETSSIDSC1

     C                   EXFMT     SETSSIDSF5

      ** Clear message subfile

     C                   CALL      'ZA0250'

      ** Reset error fields

     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0                                                   CSW210
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WFldNamArr                                   CSW210

      ** Set screen error indicators off

     C                   MOVEA     WInzIndArr    *IN(10)
     C                   MOVEA     WInzOkFlags   OkFlags

      ** Reset OKFlags for SWIFT 2010 Changes                                                 CSW210
                                                                                              CSW210
     C                   MOVEA     '00'          *IN(41)                                      CSW210
     C                   MOVEA     '00'          *IN(56)                                      CSW210
     C                   EVAL      ReD1Ok = 'Y'                                               CSW210
     C                   EVAL      ReD2Ok = 'Y'                                               CSW210
     C                   EVAL      PClrOk = 'Y'                                               CSW210
     C                   EVAL      QFInOk = 'Y'                                               CSW210
                                                                                              CSW210
      ** Select processing type

     C                   SELECT

      ** F3 Pressed

     C                   WHEN      *INKC = *ON
     C                   EVAL      PRetCode = 'SE10000'
     C                   EVAL      PMode = 'R'

      ** F5 Pressed

     C                   WHEN      *INKE = *ON
     C                   EXSR      SRSetScnFld3

      ** F12 Pressed

     C                   WHEN      *INKL = *ON
     C                   EVAL      PRetCode = 'SE10001'
     C                   EVAL      PMode = 'R'

      ** Roll Down

     C                   WHEN      RollDn = True
     C                   EVAL      PMode = '2'

     C                   OTHER

      ** Validate inputs

     C                   IF        ActionCode <> 'E'

     C                   EXSR      SRValidate3

     C                   IF        Idx = 0 AND
     C                             WInterMed = WPInterMed AND
     C                             #5PSET = WPPSET
     C                             AND #5QFI1 = WPQFIN                                      AR634357
     C                             AND #5PCL1 = WWPCL1                                      AR634357
     C                   IF        WAGNA <> 'N'                                               201486
     C                   EVAL      PMode = 'U'
     C                   ENDIF                                                                201486
     C                   ELSE
     C                   EVAL      PMode = '3'
     C                   ENDIF

     C                   ELSE

     C                   EVAL      PMode = 'R'

     C                   ENDIF

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate3 - Validate screen3 fields                        *
      *                                                               *
      * Called by: SRDisplay3                                         *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRValidate3   BEGSR

      ** Clear Intermediary array variable

     C                   CLEAR                   WIMDArr
     C                   EVAL      WPInterMed = WInterMed
     C                   EVAL      WAGNA = 'Y'                                                201486

      ** Validate intermediary 1
      ** -----------------------

     C                   IF        #5IMMD1 <> *BLANKS

     C                   EVAL      WWIMMD = #5IMMD1
     C                   EVAL      TWIMMD = T5IMMD1                                           201486
     C                   EVAL      WWIMSA = #5IMSA1
     C                   EXSR      SRValImdF
     C                   EVAL      #5IMMD1 = WWIMMD
     C                   EVAL      #5IMSA1 = WWIMSA                                           201486
     C                   EVAL      T5IMMD1 = TWIMMD                                           201486

     C                   IF        WErrIMMD = 'Y'
     C                   EVAL      IMMD1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#5IMMD1'
     C                   ENDIF

     C                   IF        WErrIMSA = 'Y'
     C                   EVAL      IMSA1Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#5IMSA1'
     C                   ENDIF

     C                   ELSE

     C                   IF        #5IMSA1 <> *BLANK
     C                   EVAL      IMSA1Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#5IMSA1'
     C                   EVAL      MsgIdArr(Idx) = 'SE10009'
     C                   ENDIF

     C                   ENDIF

      ** Validate intermediary 2
      ** -----------------------

     C                   IF        #5IMMD2 <> *BLANKS

     C                   IF        #5IMMD1 = *BLANKS
     C                   EVAL      IMMD2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#5IMMD2'
     C                   EVAL      MsgIdArr(Idx) = 'SE10025'

     C                   ELSE

     C                   EVAL      WWIMMD = #5IMMD2
     C                   EVAL      WWIMSA = #5IMSA2
     C                   EVAL      TWIMMD = T5IMMD2                                           201486
     C                   EXSR      SRValImdF
     C                   EVAL      #5IMMD2 = WWIMMD
     C                   EVAL      #5IMSA2 = WWIMSA                                           201486
     C                   EVAL      T5IMMD2 = TWIMMD                                           201486

     C                   IF        WErrIMMD = 'Y'
     C                   EVAL      IMMD2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#5IMMD2'
     C                   ENDIF

     C                   IF        WErrIMSA = 'Y'
     C                   EVAL      IMSA2Ok = 'N'
     C                   EVAL      FldNameArr(Idx) = '#5IMSA2'
     C                   ENDIF

     C                   ENDIF

     C                   ELSE

     C                   IF        #5IMSA2 <> *BLANK
     C                   EVAL      IMSA2Ok = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#5IMSA2'
     C                   EVAL      MsgIdArr(Idx) = 'SE10010'
     C                   ENDIF

     C                   ENDIF

     C                   IF        CSW206 = 'N'                                              CSW206E
      ** Validate intermediary 3
      ** -----------------------

     C**********         IF        #5IMMD3 <> *BLANKS                                        CSW206D

     C**********         IF        #5IMMD2 = *BLANKS                                         CSW206D
     C**********         EVAL      IMMD3Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD3'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10024'                                 CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         EVAL      WWIMMD = #5IMMD3                                          CSW206D
     C**********         EVAL      WWIMSA = #5IMSA3                                          CSW206D
     C**********         EVAL      TWIMMD = T5IMMD3                                   201486 CSW206D
     C**********         EXSR      SRValImdF                                                 CSW206D
     C**********         EVAL      #5IMMD3 = WWIMMD                                          CSW206D
     C**********         EVAL      #5IMSA3 = WWIMSA                                   201486 CSW206D
     C**********         EVAL      T5IMMD3 = TWIMMD                                   201486 CSW206D

     C**********         IF        WErrIMMD = 'Y'                                            CSW206D
     C**********         EVAL      IMMD3Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD3'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        WErrIMSA = 'Y'                                            CSW206D
     C**********         EVAL      IMSA3Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA3'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         IF        #5IMSA3 <> *BLANK                                         CSW206D
     C**********         EVAL      IMSA3Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA3'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10011'                                 CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D
     C                   IF        #5IMMD3 <> *BLANKS                                        CSW206E
                                                                                             CSW206E
     C                   IF        #5IMMD2 = *BLANKS                                         CSW206E
     C                   EVAL      IMMD3Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD3'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10024'                                 CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   EVAL      WWIMMD = #5IMMD3                                          CSW206E
     C                   EVAL      WWIMSA = #5IMSA3                                          CSW206E
     C                   EVAL      TWIMMD = T5IMMD3                                          CSW206E
     C                   EXSR      SRValImdF                                                 CSW206E
     C                   EVAL      #5IMMD3 = WWIMMD                                          CSW206E
     C                   EVAL      #5IMSA3 = WWIMSA                                          CSW206E
     C                   EVAL      T5IMMD3 = TWIMMD                                          CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMMD = 'Y'                                            CSW206E
     C                   EVAL      IMMD3Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD3'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMSA = 'Y'                                            CSW206E
     C                   EVAL      IMSA3Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA3'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   IF        #5IMSA3 <> *BLANK                                         CSW206E
     C                   EVAL      IMSA3Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA3'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10011'                                 CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E

      ** Validate intermediary 4
      ** -----------------------

     C**********         IF        #5IMMD4 <> *BLANKS                                        CSW206D

     C**********         IF        #5IMMD3 = *BLANKS                                         CSW206D
     C**********         EVAL      IMMD4Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD4'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10023'                                 CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         EVAL      WWIMMD = #5IMMD4                                          CSW206D
     C**********         EVAL      WWIMSA = #5IMSA4                                          CSW206D
     C**********         EVAL      TWIMMD = T5IMMD4                                   201486 CSW206D
     C**********         EXSR      SRValImdF                                                 CSW206D
     C**********         EVAL      #5IMMD4 = WWIMMD                                          CSW206D
     C**********         EVAL      #5IMSA4 = WWIMSA                                   201486 CSW206D
     C**********         EVAL      T5IMMD4 = TWIMMD                                   201486 CSW206D

     C**********         IF        WErrIMMD = 'Y'                                            CSW206D
     C**********         EVAL      IMMD4Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD4'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        WErrIMSA = 'Y'                                            CSW206D
     C**********         EVAL      IMSA4Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA4'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         IF        #5IMSA4 <> *BLANK                                         CSW206D
     C**********         EVAL      IMSA4Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA4'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10012'                                 CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D
     C                   IF        #5IMMD4 <> *BLANKS                                        CSW206E
                                                                                             CSW206E
     C                   IF        #5IMMD3 = *BLANKS                                         CSW206E
     C                   EVAL      IMMD4Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD4'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10023'                                 CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   EVAL      WWIMMD = #5IMMD4                                          CSW206E
     C                   EVAL      WWIMSA = #5IMSA4                                          CSW206E
     C                   EVAL      TWIMMD = T5IMMD4                                          CSW206E
     C                   EXSR      SRValImdF                                                 CSW206E
     C                   EVAL      #5IMMD4 = WWIMMD                                          CSW206E
     C                   EVAL      #5IMSA4 = WWIMSA                                          CSW206E
     C                   EVAL      T5IMMD4 = TWIMMD                                          CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMMD = 'Y'                                            CSW206E
     C                   EVAL      IMMD4Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD4'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMSA = 'Y'                                            CSW206E
     C                   EVAL      IMSA4Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA4'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   IF        #5IMSA4 <> *BLANK                                         CSW206E
     C                   EVAL      IMSA4Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA4'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10012'                                 CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E

      ** Validate intermediary 5
      ** -----------------------

     C**********         IF        #5IMMD5 <> *BLANKS                                        CSW206D

     C**********         IF        #5IMMD4 = *BLANKS                                         CSW206D
     C**********         EVAL      IMMD5Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD5'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10022'                                 CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         EVAL      WWIMMD = #5IMMD5                                          CSW206D
     C**********         EVAL      WWIMSA = #5IMSA5                                          CSW206D
     C**********         EVAL      TWIMMD = T5IMMD5                                   201486 CSW206D
     C**********         EXSR      SRValImdF                                                 CSW206D
     C**********         EVAL      #5IMMD5 = WWIMMD                                          CSW206D
     C**********         EVAL      #5IMSA5 = WWIMSA                                   201486 CSW206D
     C**********         EVAL      T5IMMD5 = TWIMMD                                   201486 CSW206D

     C**********         IF        WErrIMMD = 'Y'                                            CSW206D
     C**********         EVAL      IMMD5Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD5'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        WErrIMSA = 'Y'                                            CSW206D
     C**********         EVAL      IMSA5Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA5'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         IF        #5IMSA5 <> *BLANK                                         CSW206D
     C**********         EVAL      IMSA5Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA5'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10013'                                 CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D
     C                   IF        #5IMMD5 <> *BLANKS                                        CSW206E
                                                                                             CSW206E
     C                   IF        #5IMMD4 = *BLANKS                                         CSW206E
     C                   EVAL      IMMD5Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD5'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10022'                                 CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   EVAL      WWIMMD = #5IMMD5                                          CSW206E
     C                   EVAL      WWIMSA = #5IMSA5                                          CSW206E
     C                   EVAL      TWIMMD = T5IMMD5                                          CSW206E
     C                   EXSR      SRValImdF                                                 CSW206E
     C                   EVAL      #5IMMD5 = WWIMMD                                          CSW206E
     C                   EVAL      #5IMSA5 = WWIMSA                                          CSW206E
     C                   EVAL      T5IMMD5 = TWIMMD                                          CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMMD = 'Y'                                            CSW206E
     C                   EVAL      IMMD5Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD5'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMSA = 'Y'                                            CSW206E
     C                   EVAL      IMSA5Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA5'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   IF        #5IMSA5 <> *BLANK                                         CSW206E
     C                   EVAL      IMSA5Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA5'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10013'                                 CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E

      ** Validate intermediary 6
      ** -----------------------

     C**********         IF        #5IMMD6 <> *BLANKS                                        CSW206D

     C**********         IF        #5IMMD5 = *BLANKS                                         CSW206D
     C**********         EVAL      IMMD6Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD6'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10021'                                 CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         EVAL      WWIMMD = #5IMMD6                                          CSW206D
     C**********         EVAL      WWIMSA = #5IMSA6                                          CSW206D
     C**********         EVAL      TWIMMD = T5IMMD6                                   201486 CSW206D
     C**********         EXSR      SRValImdF                                                 CSW206D
     C**********         EVAL      #5IMMD6 = WWIMMD                                          CSW206D
     C**********         EVAL      #5IMSA6 = WWIMSA                                   201486 CSW206D
     C**********         EVAL      T5IMMD6 = TWIMMD                                   201486 CSW206D

     C**********         IF        WErrIMMD = 'Y'                                            CSW206D
     C**********         EVAL      IMMD6Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD6'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        WErrIMSA = 'Y'                                            CSW206D
     C**********         EVAL      IMSA6Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA6'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         IF        #5IMSA6 <> *BLANK                                         CSW206D
     C**********         EVAL      IMSA6Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA6'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10014'                                 CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D
     C                   IF        #5IMMD6 <> *BLANKS                                        CSW206E
                                                                                             CSW206E
     C                   IF        #5IMMD5 = *BLANKS                                         CSW206E
     C                   EVAL      IMMD6Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD6'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10021'                                 CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   EVAL      WWIMMD = #5IMMD6                                          CSW206E
     C                   EVAL      WWIMSA = #5IMSA6                                          CSW206E
     C                   EVAL      TWIMMD = T5IMMD6                                          CSW206E
     C                   EXSR      SRValImdF                                                 CSW206E
     C                   EVAL      #5IMMD6 = WWIMMD                                          CSW206E
     C                   EVAL      #5IMSA6 = WWIMSA                                          CSW206E
     C                   EVAL      T5IMMD6 = TWIMMD                                          CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMMD = 'Y'                                            CSW206E
     C                   EVAL      IMMD6Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD6'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMSA = 'Y'                                            CSW206E
     C                   EVAL      IMSA6Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA6'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   IF        #5IMSA6 <> *BLANK                                         CSW206E
     C                   EVAL      IMSA6Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA6'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10014'                                 CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E

      ** Validate intermediary 7
      ** -----------------------

     C**********         IF        #5IMMD7 <> *BLANKS                                        CSW206D

     C**********         IF        #5IMMD6 = *BLANKS                                         CSW206D
     C**********         EVAL      IMMD7Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD7'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10020'                                 CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         EVAL      WWIMMD = #5IMMD7                                          CSW206D
     C**********         EVAL      WWIMSA = #5IMSA7                                          CSW206D
     C**********         EVAL      TWIMMD = T5IMMD7                                   201486 CSW206D
     C**********         EXSR      SRValImdF                                                 CSW206D
     C**********         EVAL      #5IMMD7 = WWIMMD                                          CSW206D
     C**********         EVAL      #5IMSA7 = WWIMSA                                   201486 CSW206D
     C**********         EVAL      T5IMMD7 = TWIMMD                                   201486 CSW206D

     C**********         IF        WErrIMMD = 'Y'                                            CSW206D
     C**********         EVAL      IMMD7Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD7'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        WErrIMSA = 'Y'                                            CSW206D
     C**********         EVAL      IMSA7Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA7'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         IF        #5IMSA7 <> *BLANK                                         CSW206D
     C**********         EVAL      IMSA7Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA7'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10015'                                 CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D
     C                   IF        #5IMMD7 <> *BLANKS                                        CSW206E
                                                                                             CSW206E
     C                   IF        #5IMMD6 = *BLANKS                                         CSW206E
     C                   EVAL      IMMD7Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD7'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10020'                                 CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   EVAL      WWIMMD = #5IMMD7                                          CSW206E
     C                   EVAL      WWIMSA = #5IMSA7                                          CSW206E
     C                   EVAL      TWIMMD = T5IMMD7                                          CSW206E
     C                   EXSR      SRValImdF                                                 CSW206E
     C                   EVAL      #5IMMD7 = WWIMMD                                          CSW206E
     C                   EVAL      #5IMSA7 = WWIMSA                                          CSW206E
     C                   EVAL      T5IMMD7 = TWIMMD                                          CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMMD = 'Y'                                            CSW206E
     C                   EVAL      IMMD7Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD7'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMSA = 'Y'                                            CSW206E
     C                   EVAL      IMSA7Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA7'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   IF        #5IMSA7 <> *BLANK                                         CSW206E
     C                   EVAL      IMSA7Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA7'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10015'                                 CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E

      ** Validate intermediary 8
      ** -----------------------

     C**********         IF        #5IMMD8 <> *BLANKS                                        CSW206D

     C**********         IF        #5IMMD7 = *BLANKS                                         CSW206D
     C**********         EVAL      IMMD8Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD8'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10019'                                 CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         EVAL      WWIMMD = #5IMMD8                                          CSW206D
     C**********         EVAL      WWIMSA = #5IMSA8                                          CSW206D
     C**********         EVAL      TWIMMD = T5IMMD8                                   201486 CSW206D
     C**********         EXSR      SRValImdF                                                 CSW206D
     C**********         EVAL      #5IMMD8 = WWIMMD                                          CSW206D
     C**********         EVAL      #5IMSA8 = WWIMSA                                   201486 CSW206D
     C**********         EVAL      T5IMMD8 = TWIMMD                                   201486 CSW206D

     C**********         IF        WErrIMMD = 'Y'                                            CSW206D
     C**********         EVAL      IMMD8Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD8'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        WErrIMSA = 'Y'                                            CSW206D
     C**********         EVAL      IMSA8Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA8'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D

     C**********         ELSE                                                                CSW206D

     C**********         IF        #5IMSA8 <> *BLANK                                         CSW206D
     C**********         EVAL      IMSA8Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA8'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10018'                                 CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D
     C                   IF        #5IMMD8 <> *BLANKS                                        CSW206E
                                                                                             CSW206E
     C                   IF        #5IMMD7 = *BLANKS                                         CSW206E
     C                   EVAL      IMMD8Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD8'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10019'                                 CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   EVAL      WWIMMD = #5IMMD8                                          CSW206E
     C                   EVAL      WWIMSA = #5IMSA8                                          CSW206E
     C                   EVAL      TWIMMD = T5IMMD8                                          CSW206E
     C                   EXSR      SRValImdF                                                 CSW206E
     C                   EVAL      #5IMMD8 = WWIMMD                                          CSW206E
     C                   EVAL      #5IMSA8 = WWIMSA                                          CSW206E
     C                   EVAL      T5IMMD8 = TWIMMD                                          CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMMD = 'Y'                                            CSW206E
     C                   EVAL      IMMD8Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD8'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMSA = 'Y'                                            CSW206E
     C                   EVAL      IMSA8Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA8'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   IF        #5IMSA8 <> *BLANK                                         CSW206E
     C                   EVAL      IMSA8Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA8'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10018'                                 CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E

      ** Validate intermediary 9
      ** -----------------------

     C**********         IF        #5IMMD9 <> *BLANKS                                        CSW206D
     C                   IF        #5IMMD9 <> *BLANKS                                        CSW206E

     C**********         IF        #5IMMD8 = *BLANKS                                          209934
     C**********         EVAL      IMMD9Ok = 'N'                                              209934
     C**********         EVAL      Idx = Idx + 1                                              209934
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD9'                                209934
     C**********         EVAL      MsgIdArr(Idx) = 'SE10018'                                  209934
      **********                                                                              209934
     C**********         ELSE                                                                 209934

     C**********         EVAL      WWIMMD = #5IMMD9                                          CSW206D
     C**********         EVAL      WWIMSA = #5IMSA9                                          CSW206D
     C**********         EVAL      TWIMMD = T5IMMD9                                   201486 CSW206D
     C**********         EXSR      SRValImdF                                                 CSW206D
     C**********         EVAL      #5IMMD9 = WWIMMD                                          CSW206D
     C**********         EVAL      #5IMSA9 = WWIMSA                                   201486 CSW206D
     C**********         EVAL      T5IMMD9 = TWIMMD                                   201486 CSW206D

     C**********         IF        WErrIMMD = 'Y'                                            CSW206D
     C**********         EVAL      IMMD9Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMMD9'                               CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        WErrIMSA = 'Y'                                            CSW206D
     C**********         EVAL      IMSA9Ok = 'N'                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA9'                               CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   EVAL      WWIMMD = #5IMMD9                                          CSW206E
     C                   EVAL      WWIMSA = #5IMSA9                                          CSW206E
     C                   EVAL      TWIMMD = T5IMMD9                                          CSW206E
     C                   EXSR      SRValImdF                                                 CSW206E
     C                   EVAL      #5IMMD9 = WWIMMD                                          CSW206E
     C                   EVAL      #5IMSA9 = WWIMSA                                          CSW206E
     C                   EVAL      T5IMMD9 = TWIMMD                                          CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMMD = 'Y'                                            CSW206E
     C                   EVAL      IMMD9Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMMD9'                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        WErrIMSA = 'Y'                                            CSW206E
     C                   EVAL      IMSA9Ok = 'N'                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA9'                               CSW206E
     C                   ENDIF                                                               CSW206E

     C**********         ENDIF                                                                209934

     C**********         ELSE                                                                CSW206D

     C**********         IF        #5IMSA9 <> *BLANK                                         CSW206D
     C**********         EVAL      IMSA9Ok = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#5IMSA9'                               CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10017'                                 CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         ENDIF                                                               CSW206D
     C                   ELSE                                                                CSW206E
                                                                                             CSW206E
     C                   IF        #5IMSA9 <> *BLANK                                         CSW206E
     C                   EVAL      IMSA9Ok = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      FldNameArr(Idx) = '#5IMSA9'                               CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10017'                                 CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E
     C                   ENDIF                                                               CSW206E

      ** Validate place of settlement
      ** ----------------------------
                                                                                             CSW206E
     C**********         IF        CSW206 = 'Y'                                       CSW206E CSW210
     C                   IF        CSW206 = 'Y' OR PCSW210 = 'Y'                              CSW210
     C                   EVAL      #5PSET = #5PSET1                                          CSW206E
     C                   ENDIF                                                               CSW206E

     C                   EVAL      WPPSET = #5PSET

     C                   IF        #5PSET <> *BLANKS

     C                   MOVEL     #5PSET        PCustKey
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCustKey
     C                   PARM      *BLANKS       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY

      ** If Return code is not blank then check if entry is a valid BIC code

     C                   IF        @RtCd <> *BLANKS

     C                   EVAL      PSETOk = 'N'

     C**********         IF        PCFT007 = 'Y'                                              199797

     C                   MOVEL     #5PSET        WKCSID8
     C                   MOVE      #5PSET        WKCSID4
     C                   MOVEL     WKCSID4       WKCSID3


      ** Call program to validate ID

     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    WKCSID8
     C                   PARM                    WKCSID3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       WKBICC
     C                   PARM      *BLANKS       WKBICS
     C                   PARM      *BLANKS       WKBICI


      ** BIC identifier not found
     C                   MOVE      #5PSET        WkVar1            1                          204704

     C                   IF        @RtCd = 'Y2U0005' OR @RtCd = 'MIN0246'
     C                             OR WkVar1 <> ' '                                           204704
     C                   EVAL      PSETOk = 'N'
     C                   ELSE
     C                   EVAL      PSETOk = 'Y'
     C                   ENDIF
     C**********         ENDIF                                                                199797

     C                   IF        PSETOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#5PSET'
     C                   EVAL      MsgIdArr(Idx) = 'SE10031'
     C                   ENDIF

     C                   ELSE

     C                   EVAL      #5PSET = BBCUST

     C                   ENDIF

     C                   ENDIF
                                                                                             CSW206E
     C**********         IF        CSW206 = 'Y'                                       CSW206E CSW210
     C                   IF        CSW206 = 'Y' OR PCSW210 = 'Y'                              CSW210
     C                   EVAL      #5PSET1 = #5PSET                                          CSW206E
     C                   ENDIF                                                               CSW206E

      ** Validate registration details line 1                                                 CSW210
      ** ------------------------------------                                                 CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   EVAL      WkRED1 = #5RED1                                            CSW210
     C                   MOVEL     WkRED1        WWRED1                                       CSW210
                                                                                              CSW210
     C                   IF        WkRED1 <> *BLANKS                                          CSW210
                                                                                              CSW210
     C                   IF        WWRED1 = '/'                                               CSW210
                                                                                              CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      ReD1Ok = 'N'                                               CSW210
     C                   EVAL      FldNameArr(Idx) = '#5RED1'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5285'                                  CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Validate registration details line 2                                                 CSW210
      ** ------------------------------------                                                 CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   EVAL      WkRED2 = #5RED2                                            CSW210
     C                   MOVEL     WkRED2        WWRED2                                       CSW210
                                                                                              CSW210
     C                   IF        WkRED2 <> *BLANKS  AND ReD1Ok <> 'N'                       CSW210
                                                                                              CSW210
     C                   IF        WkRED1 = *BLANKS                                           CSW210
                                                                                              CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      ReD2Ok = 'N'                                               CSW210
     C                   EVAL      FldNameArr(Idx) = '#5RED2'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'                                  CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        WkRED2 = WkRED1                                            CSW210
                                                                                              CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      ReD2Ok = 'N'                                               CSW210
     C                   EVAL      FldNameArr(Idx) = '#5RED2'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'                                  CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
                                                                                              CSW210
     C                   IF        WWRED2 = '/'                                               CSW210
                                                                                              CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      ReD2Ok = 'N'                                               CSW210
     C                   EVAL      FldNameArr(Idx) = '#5RED2'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5285'                                  CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
      ** Validate Place of Clearing                                                           CSW210
      ** --------------------------                                                           CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   MOVEL     #5PCL1        WWPCL1                                     AR635847
     C                   IF        #5PCL1 <> *BLANKS                                          CSW210
     C                   MOVEL     #5PCL1        PCustKey                                     CSW210
     C**********         MOVEL     #5PCL1        WWPCL1                            AR634357 AR635847
                                                                                              CSW210
      ** Validate Customer Number/Shortname/Nostro                                            CSW210
                                                                                              CSW210
     C                   EXSR      SRCust                                                     CSW210
                                                                                              CSW210
     C                   IF        WCustType <> 'C' AND WCustType <> 'S' AND                  CSW210
     C                             WCustType <> 'N'                                           CSW210
     C                   EVAL      PClrOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '#5PCL1'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00084'                                  CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
      ** If customer or shortame a/c must be a bank                                           CSW210
                                                                                              CSW210
     C**********         IF        WCustType = 'C' AND WCustType = 'S'               CSW210 AR634357
     C**********         IF        WBNBI = 'Y'                                       CSW210 AR634357
     C                   IF        WCustType = 'C' OR WCustType = 'S'                       AR634357
     C**********         IF        WWBNBI = 'Y'                                    AR634357 AR636523
     C                   EVAL      #5PCL1 = BBCUST                                            CSW210
     C**********         ELSE                                                        CSW210 AR636523
      **********                                                                     CSW210 AR636523
      ***Customer is non-bank                                                        CSW210 AR636523
      **********                                                                     CSW210 AR636523
     C**********         EVAL      #5PCL1 = BBCUST                                 AR634357 AR636523
     C**********         EVAL      PClrOk = 'N'                                      CSW210 AR636523
     C**********         EVAL      Idx = Idx + 1                                     CSW210 AR636523
     C**********         EVAL      FldNameArr(Idx) = '#5PCL1'                        CSW210 AR636523
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5225'                         CSW210 AR636523
     C**********         ENDIF                                                       CSW210 AR636523
                                                                                              CSW210
      ** Entry is Nostro                                                                      CSW210
                                                                                              CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
     C                   IF        WCustType = 'N'                                            CSW210
     C                   EVAL      #5PCL1 = AWCPNC                                            CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Validate Qualified Foreign Intermediary                                              CSW210
      ** ---------------------------------------                                              CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   MOVEL     #5QFI1        WPQFIN                                     AR635847
     C                   IF        #5QFI1 <> *BLANKS                                          CSW210
     C                   MOVEL     #5QFI1        PCustKey                                     CSW210
     C**********         MOVEL     #5QFI1        WPQFIN                            AR634357 AR635847
                                                                                              CSW210
      ** Validate Customer Number/Shortname/Nostro                                            CSW210
                                                                                              CSW210
     C                   EXSR      SRCust                                                     CSW210
                                                                                              CSW210
     C                   IF        WCustType <> 'C' AND WCustType <> 'S' AND                  CSW210
     C                             WCustType <> 'N'                                           CSW210
     C                   EVAL      QFInOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '#5QFI1'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00083'                                  CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
      ** If customer or shortame a/c must be a bank                                           CSW210
                                                                                              CSW210
     C**********         IF        WCustType = 'C' AND WCustType = 'S'               CSW210 AR634357
     C**********         IF        WBNBI = 'Y'                                       CSW210 AR634357
     C                   IF        WCustType = 'C' OR WCustType = 'S'                       AR634357
     C**********         IF        WWBNBI = 'Y'                                    AR634357 AR636523
     C                   EVAL      #5QFI1 = BBCUST                                            CSW210
     C**********         ELSE                                                        CSW210 AR636523
      **********                                                                     CSW210 AR636523
      ***Customer is non-bank                                                        CSW210 AR636523
      **********                                                                     CSW210 AR636523
     C**********         EVAL      #5QFI1 = BBCUST                                 AR634357 AR636523
     C**********         EVAL      QFInOk = 'N'                                      CSW210 AR636523
     C**********         EVAL      Idx = Idx + 1                                     CSW210 AR636523
     C**********         EVAL      FldNameArr(Idx) = '#5QFI1'                        CSW210 AR636523
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5225'                         CSW210 AR636523
     C**********         ENDIF                                                       CSW210 AR636523
                                                                                              CSW210
      ** Entry is Nostro                                                                      CSW210
                                                                                              CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
     C                   IF        WCustType = 'N'                                            CSW210
     C                   EVAL      #5QFI1 = AWCPNC                                            CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** End of screen 3 validation
      ** ==========================

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCust - Validate Customer Number/Shortname/Nostro            *
      *                                                               *
      * Called by: SRValidate1 - Validate Screen 1 Details            *
      *            SRValidate2 - Validate Screen 2 Details            *
      *            SRValidate3 - Validate Screen 3 Details            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRCUST        BEGSR

     C                   EVAL      WCustType = *BLANK

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCustKey
     C                   PARM                    PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY

      ** If Return code is blank then set WCustType to 'C' if Customer
      ** Number; to 'S' if Customer Shortname.

     C                   IF        @RtCd = *BLANK AND PKeySts <> '*ERROR'

     C                   IF        PKeySts = '*CNUM'
     C                   EVAL      WCustType = 'C'
     C                   ELSE
     C                   EVAL      WCustType = 'S'
     C                   ENDIF

      ** If Customer Number or Shortname then save file fields.

     C                   EVAL      WWCABA = BBCABA
     C                   EVAL      WWCSID = BBCSID
     C                   EVAL      WWBLCD = BBBLCD
     C                   EVAL      WWCHID = BBCHID
     C                   EVAL      WWCHSC = BBCHSC
     C                   EVAL      WWBNBI = BBBNBI
     C                   MOVE      BBFWCD        WWFWCD

      ** Else (error on Customer file) may be a Counterparty Nostro

     C                   ELSE

     C                   MOVEL     PCustKey      PNost

     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PNost             8
     C     SDCNST        PARM      SDCNST        DSFDY

      ** If Counterparty Nostro found set WCustType to 'N'.

     C                   IF        @RtCd = *BLANK
     C                   EVAL      WCustType = 'N'
     C                   EVAL      WCSID = AWSWID
     C                   EVAL      WFWCD = AWFWCD
     C                   EVAL      WBNBI = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      *  SRDBTA - Validate Debtor Address                             *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRValidate1                                        *                       CSW210
      *                                                               *                       CSW210
      * Calls:                                                        *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
     C     SRDBTA        BEGSR                                                                CSW210
                                                                                              CSW210
     C                   Eval      DSACB1 = @DADDR1                                           CSW210
     C                   Eval      DSACB2 = @DADDR2                                           CSW210
     C                   Eval      DSACB3 = @DADDR3                                           CSW210
     C                   Eval      DSACB4 = @DADDR4                                           CSW210
     C                   Eval      @ACBT = *Blanks                                            CSW210
                                                                                              CSW210
     C                   If        SACBDS  <> *Blanks                                         CSW210
                                                                                              CSW210
     C                   IF        #2FIND = 'F'                                               CSW210
     C                   EVAL      DAd1Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00112'                                  CSW210
     C                   ELSE                                                                 CSW210
     C                   IF        @DEBTR1 <> *BLANKS                                         CSW210
     C                   EVAL      DbtrOk = 'N'                                               CSW210
     C                   EVAL      DAd1Ok = 'N'                                               CSW210
     C                   EVAL      DAd2Ok = 'N'                                               CSW210
     C                   EVAL      DAd3Ok = 'N'                                               CSW210
     C                   EVAL      DAd4Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00113'                                  CSW210
     C                   EndIf                                                                CSW210
                                                                                              CSW210
     C                   EndIf                                                                CSW210
                                                                                              CSW210
      ** No Error                                                                             CSW210
                                                                                              CSW210
     C                   If        DAd1Ok <> 'N' and                                          CSW210
     C                             @ACBT = *Blanks                                            CSW210
                                                                                              CSW210
     C                   Movel(P)  SACBDS        ADDRSS                                       CSW210
                                                                                              CSW210
      *  If 1st 11 Chars of 1st line then SWIFT address assumed                               CSW210
      *  Or first is '/' and second is SWIFT Address                                          CSW210
                                                                                              CSW210
      *  If field does not begin with '/' and is not longer than 11                           CSW210
      *  characters, validate as a S.W.I.F.T. Address                                         CSW210
     C                   If        ADCH26 = *Blanks and                                       CSW210
     C                             ADEXSW = *Blanks and                                       CSW210
     C                             ADSLSH <> '/'                                            AR570983
     C**********                   ADSLSH <> '/' or                                  CSW210 AR570983
     C**********                   ADCH36 = *Blanks and                              CSW210 AR570983
     C**********                   ADEXS2 = *Blanks and                              CSW210 AR570983
     C**********                   ADCHK2 <> *Blanks and                             CSW210 AR570983
     C**********                   ADSLSH = '/' and                                  CSW210 AR570983
     C**********                   ADSLS2 <> '/'                                     CSW210 AR570983
                                                                                              CSW210
      *  First 11 characters should be key for CLSWT.                                         CSW210
     C**********         If        ADSLSH <> '/'                                     CSW210 AR570983
     C                   Movel     ADCHK1        CLSWTK                                       CSW210
     C**********         Else                                                        CSW210 AR570983
     C**********         Movel     ADCHK2        CLSWTK                              CSW210 AR570983
     C**********         End                                                         CSW210 AR570983
                                                                                              CSW210
     C                   Exsr      SWIFT                                                      CSW210
                                                                                              CSW210
     C                   If        ##CSID = 'Y'                                               CSW210
                                                                                              CSW210
     C                   If        *IN31 = *On                                                CSW210
      * Send error to screen                                                                  CSW210
     C                   Add       1             Idx                                          CSW210
     C**********         If        ADSLSH <> '/'                                     CSW210 AR570983
     C                   Move      'N'           DAd1Ok                                       CSW210
     C                   Eval      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C**********         Else                                                        CSW210 AR570983
     C**********         Move      'N'           DAd2Ok                              CSW210 AR570983
     C**********         Eval      FldNameArr(Idx) = '@DADDR2'                       CSW210 AR570983
     C**********         End                                                         CSW210 AR570983
     C                   Movel     'ST00078'     MsgIdArr(Idx)                                CSW210
                                                                                              CSW210
     C                   Else                                                                 CSW210
     C                   Eval      @ACBT = 'S'                                                CSW210
      *                                                                                       CSW210
      *  No SWIFT address record.                                                             CSW210
     C**********         If        *IN32 = *On and                                   CSW210 AR579549
     C                   If        *IN91 = *On and                                          AR579549
     C                             *IN31 = *Off                                               CSW210
                                                                                              CSW210
      *  If text changed then warning needs to be changed                                     CSW210
     C**********         If        ADSLSH <> '/'                                     CSW210 AR570983
     C                   Movel     CLSWTK        @ACB1                                        CSW210
      *                                                                                     AR579549
     C                   EVAL      WIdx = WIdx + 1                                          AR579549
     C                   EVAL      WMsgIdArr(WIdx) = 'ST00079'                              AR579549
     C                   MOVEL     '@DADDR1'     WFldNam                                    AR579549
     C                   EVAL      WMsgID = WMsgIdArr(WIdx)                                 AR579549
     C                   EVAL      WFldVal = @DADDR1                                        AR579549
      * Send warning to screen                                                                CSW210
     C                   IF        MsgLine = PrevMsg(5)                                     AR579549
     C                   EVAL      DAd1Ok = 'Y'                                             AR579549
     C                   EVAL      WFldNamArr(WIdx) = *Blank                                AR579549
     C                   EVAL      WMsgIdArr(WIdx) = *Blank                                 AR579549
     C                   EVAL      WMsgDtaArr(WIdx) = *Blank                                AR579549
     C                   EVAL      WIdx = WIdx - 1                                          AR579549
     C                   ELSE                                                               AR579549
     C                   Move      'W'           DAd1Ok                                       CSW210
     C**********         Add       1             WIdx                                CSW210 AR579549
     C                   Eval      WMsgIDArr(WIdx) = 'ST00079'                                CSW210
     C                   Eval      WFldNamArr(WIdx) = '@DADDR1'                               CSW210
     C                   MOVE      MsgLine       PrevMsg(5)                                 AR579549
     C                   EVAL      PrevFlg = 'Y'                                            AR579549
     C                   ENDIF                                                              AR579549
                                                                                              CSW210
     C**********         Else                                                        CSW210 AR570983
     C**********         Movel     CLSWTK        @Acb2                               CSW210 AR570983
      **Send*warning to screen                                                       CSW210 AR570983
     C**********         Move      'W'           DAd2Ok                              CSW210 AR570983
     C**********         Add       1             WIdx                                CSW210 AR570983
     C**********         Eval      WMsgIDArr(WIdx) = 'ST00079'                       CSW210 AR570983
     C**********         Eval      WFldNamArr(WIdx) = '@DADDR2'                      CSW210 AR570983
      **********                                                                     CSW210 AR570983
     C**********         End                                                         CSW210 AR570983
                                                                                              CSW210
     C                   End                                                                  CSW210
     C                   End                                                                  CSW210
     C                   End                                                                  CSW210
     C                   End                                                                  CSW210
     C                   End                                                                  CSW210
                                                                                              CSW210
     C                   If        DAd1Ok <> 'N' and                                          CSW210
     C                             @ACBT = *Blanks                                            CSW210
                                                                                              CSW210
      ** CODEWORD                                                                             CSW210
     C                   IF        DSACB1Pos1 = '/'                                           CSW210
                                                                                              CSW210
     C                   EXSR      SRCODE                                                     CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   If        DAd1Ok <> 'N' and                                          CSW210
     C                             @ACBT = *Blanks                                            CSW210
      * Validate as an address                                                                CSW210
     C                   Eval      ADLINE = 'Y'                                               CSW210
     C                   Exsr      ADCHK                                                      CSW210
      *                                                                                       CSW210
     C                   If        *IN92 = *On                                                CSW210
      * Send error to screen                                                                  CSW210
     C                   Move      'N'           DAd1Ok                                       CSW210
     C                   Move      'N'           DAd2Ok                                       CSW210
     C                   Move      'N'           DAd3Ok                                       CSW210
     C                   Move      'N'           DAd4Ok                                       CSW210
     C                   Add       1             Idx                                          CSW210
     C                   Eval      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C                   Movel     'ST00080'     MsgIdArr(Idx)                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   If        AD#1 = 'Y'                                                 CSW210
     C                   Move      'N'           DAd1Ok                                       CSW210
     C                   Add       1             Idx                                          CSW210
     C                   Eval      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C                   Movel     'ST00081'     MsgIdArr(Idx)                                CSW210
     C                   End                                                                  CSW210
                                                                                              CSW210
     C                   If        AD#2 = 'Y'                                                 CSW210
     C                   Move      'N'           DAd2Ok                                       CSW210
     C                   Add       1             Idx                                          CSW210
     C                   Eval      FldNameArr(Idx) = '@DADDR2'                                CSW210
     C                   Movel     'ST00081'     MsgIdArr(Idx)                                CSW210
     C                   End                                                                  CSW210
                                                                                              CSW210
     C                   If        AD#3 = 'Y'                                                 CSW210
     C                   Move      'N'           DAd3Ok                                       CSW210
     C                   Add       1             Idx                                          CSW210
     C                   Eval      FldNameArr(Idx) = '@DADDR3'                                CSW210
     C                   Movel     'ST00081'     MsgIdArr(Idx)                                CSW210
     C                   End                                                                  CSW210
                                                                                              CSW210
     C                   If        AD#4 = 'Y'                                                 CSW210
     C                   Move      'N'           DAd4Ok                                       CSW210
     C                   Add       1             Idx                                          CSW210
     C                   Eval      FldNameArr(Idx) = '@DADDR4'                                CSW210
     C                   Movel     'ST00081'     MsgIdArr(Idx)                                CSW210
     C                   End                                                                  CSW210
                                                                                              CSW210
      *  If no errors then customer is an address                                             CSW210
     C                   If        DAd1Ok = 'Y'and                                            CSW210
     C                             DAd2Ok = 'Y'and                                            CSW210
     C                             DAd3Ok = 'Y'and                                            CSW210
     C                             DAd4Ok = 'Y'and                                            CSW210
     C                             @ACBT = *Blanks                                            CSW210
     C                   Eval      @ACBT = 'A'                                                CSW210
     C                   EndIf                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EndIf                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      *  SRCODE - Validate CODEWORD                                   *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRDBTA                                             *                       CSW210
      *                                                               *                       CSW210
      * Calls:                                                        *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
     C     SRCODE        BEGSR                                                                CSW210
                                                                                              CSW210
      ** CODEWORD ends with '/'                                                               CSW210
     C     '/'           SCAN      DSACB1:2      W@                       50                AR571002
                                                                                              CSW210
     C**********         IF        DSACB1Po10 <> '/'                                 CSW210 AR571002
     C                   IF        *IN50 = *OFF                                             AR571002
     C                   EVAL      DAd1Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00115'                                  CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Double Slash ('//') entry                                                            CSW210
                                                                                              CSW210
     C                   IF        DAd1Ok <> 'N' AND                                          CSW210
     C                             DSACB1Pos2 = '/'                                           CSW210
     C                   EVAL      DAd1Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00116'                                  CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      *                                                                                     AR571002
      ** If '/' is in posn. 11 or greater - error: codeword should be                       AR571002
      ** 8 characters or fewer.                                                             AR571002
     C                   IF        W@ > 10                                                  AR571002
      *                                                                                     AR571002
     C                   IF        PCSW201 = 'Y'                                            AR571002
     C                   EVAL      DAd1Ok = 'N'                                             AR571002
     C                   EVAL      IDx = IDx + 1                                            AR571002
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                              AR571002
     C                   EVAL      MsgIdArr(Idx) = 'ST00120'                                AR571002
     C                   ELSE                                                               AR571002
     C                   EVAL      DAd1Ok = 'N'                                             AR571002
     C                   EVAL      IDx = IDx + 1                                            AR571002
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                              AR571002
     C                   EVAL      MsgIdArr(Idx) = 'ST00117'                                AR571002
     C                   ENDIF                                                              AR571002
     C                   ENDIF                                                              AR571002
      ** Character after CODEWORD                                                             CSW210
                                                                                              CSW210
      *                                                                                     AR571002
      ** If any characters after second '/' - error: should be blank                        AR571002
      *                                                                                     AR571002
     C     35            SUB       W@            W@L                                        AR571002
     C     W@            ADD       1             W@P                                        AR571002
     C     W@L           SUBST     DSACB1:W@P    W@SBBL                                     AR571002
     C                   IF        DAd1Ok <> 'N' AND                                          CSW210
     C**********                   DSACB1Excs <> *Blank                              CSW210 AR571002
     C                             W@SBBL <> *BLANKS                                        AR571002
     C                   EVAL      DAd1Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00118'                                  CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Lowercase character exists in CODEWORD                                               CSW210
                                                                                              CSW210
     C                   IF        DAd1Ok <> 'N'                                              CSW210
      *                                                                                     AR571002
      ** If codeword contains non-upper case or non-numeric characters                      AR571002
      *                                                                                     AR571002
     C                   IF        PCSW201 = 'Y'                                            AR571002
      *                                                                                     AR571002
     C     ALPHAN        CHECK     DSACB1:2      W@L                                        AR571002
     C                   IF        W@L < W@                                                 AR571002
     C                   EVAL      DAd1Ok = 'N'                                             AR571002
     C                   EVAL      IDx = IDx + 1                                            AR571002
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                              AR571002
     C                   EVAL      MsgIdArr(Idx) = 'ST00121'                                AR571002
     C                   ENDIF                                                              AR571002
     C                   ELSE                                                               AR571002
     C     ALPHAB        CHECK     CDEWRD        CD#               3 0                        CSW210
     C                   IF        %FOUND                                                     CSW210
     C                   EVAL      DAd1Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00119'                                  CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                              AR571002
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** CODEWORD is valid and second line is blank                                           CSW210
                                                                                              CSW210
     C                   IF        DAd1Ok <> 'N'                                              CSW210
     C                   IF        DSACB2 = *Blank                                            CSW210
     C                   EVAL      DAd1Ok = 'N'                                               CSW210
     C                   EVAL      DAd2Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00122'                                  CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      FLD = DSACB2                                               CSW210
     C                   EXSR      SWSET                                                      CSW210
     C                   IF        *IN99 = *ON                                                CSW210
     C                   EVAL      DAd1Ok = 'N'                                               CSW210
     C                   EVAL      DAd2Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00081'                                  CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                            AR588640
      ** CODEWORD is valid and second line is more than 34 characters                       AR588640
                                                                                            AR588640
     C                   IF        DAd1Ok <> 'N'                                            AR588640
     C                   IF        DSACB234 <> *Blank                                       AR588640
     C                   EVAL      DAd1Ok = 'N'                                             AR588640
     C                   EVAL      DAd2Ok = 'N'                                             AR588640
     C                   EVAL      Idx = Idx + 1                                            AR588640
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                              AR588640
     C                   EVAL      MsgIdArr(Idx) = 'ST00124'                                AR588640
     C                   ENDIF                                                              AR588640
     C                   ENDIF                                                              AR588640
                                                                                              CSW210
      ** CODEWORD is valid and third and fouth line are not blank                             CSW210
                                                                                              CSW210
     C                   IF        DAd1Ok <> 'N'                                              CSW210
     C                   IF        DSACB3 <> *Blank OR                                        CSW210
     C                             DSACB4 <> *Blank                                           CSW210
     C                   EVAL      DAd1Ok = 'N'                                               CSW210
     C                   EVAL      DAd2Ok = 'N'                                               CSW210
     C                   EVAL      DAd3Ok = 'N'                                               CSW210
     C                   EVAL      DAd4Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DADDR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00123'                                  CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** Entry is a valid CODEWORD                                                            CSW210
                                                                                              CSW210
     C                   IF        DAd1Ok <> 'N'                                              CSW210
     C                   EVAL      @ACBT = 'R'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      *  SRIBAN - Validate IBAN                                       *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRValidate1                                        *                       CSW210
      *                                                               *                       CSW210
      * Calls:                                                        *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
     C     SRIBAN        BEGSR                                                                CSW210
                                                                                              CSW210
      *  Remove '/' from first position                                                       CSW210
                                                                                              CSW210
     C                   IF        DSACB1Pos1 = '/'                                           CSW210
     C     34            SUBST     DSACB1:2      PIBAN                                        CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      PIBAN = DSACB1                                             CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      *  Format field, removing blanks and IBAN prefix                                        CSW210
                                                                                              CSW210
     C                   CALL      'AOIBANR3'                                                 CSW210
     C                   PARM                    @Rcode            7                          CSW210
     C                   PARM                    PIBAN            47                          CSW210
     C                   PARM                    POWith           47                          CSW210
     C     P@IBAN        PARM                    PONobl           34                          CSW210
                                                                                              CSW210
      *  If first four characters are 'AANN', proceed with IBAN validn                        CSW210
                                                                                              CSW210
     C     1             SUBST     P@IBAN:1      IBCTY1            1                          CSW210
     C     1             SUBST     P@IBAN:2      IBCTY2            1                          CSW210
     C     1             SUBST     P@IBAN:3      IBCHK1            1                          CSW210
     C     1             SUBST     P@IBAN:4      IBCHK2            1                          CSW210
     C     IBCTY1        LOOKUP    Alpha                                  85                  CSW210
     C   85IBCTY2        LOOKUP    Alpha                                  85                  CSW210
     C   85IBCHK1        LOOKUP    Numeric                                85                  CSW210
     C   85IBCHK2        LOOKUP    Numeric                                85                  CSW210
                                                                                              CSW210
     C                   IF        *IN85 = *ON                                                CSW210
                                                                                              CSW210
     C                   EVAL      IBANFlg = 'Y'                                              CSW210
                                                                                              CSW210
     C                   CALL      'AOIBANR5'                           09                    CSW210
     C                   PARM      *Blanks       @Rcode                                       CSW210
     C                   PARM                    P@IBAN           34                          CSW210
                                                                                              CSW210
      *  If no warnings, prefix IBAN with '/'                                                 CSW210
                                                                                              CSW210
     C                   IF        *IN09 = *Off and @Rcode = *Blanks                          CSW210
     C**********'/'      CAT       P@IBAN        DSACB1                              CSW210 AR578911
     C                   MOVEL(P)  P@IBAN        DSACB1                                     AR578911
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
      *  Warnings:                                                                            CSW210
                                                                                              CSW210
     C                   EVAL      WIdx = WIdx + 1                                            CSW210
                                                                                              CSW210
     C                   SELECT                                                               CSW210
                                                                                              CSW210
      *  Invalid ISO country code                                                             CSW210
                                                                                              CSW210
     C                   WHEN      @Rcode = '      1'                                         CSW210
     C                   EVAL      WMsgIdArr(WIdx) = 'ST00102'                                CSW210
                                                                                              CSW210
      *  Invalid BBAN length                                                                  CSW210
                                                                                              CSW210
     C                   WHEN      @Rcode = '      2'                                         CSW210
     C                   EVAL      WMsgIdArr(WIdx) = 'ST00103'                                CSW210
                                                                                              CSW210
      *  Invalid character                                                                    CSW210
                                                                                              CSW210
     C                   WHEN      @Rcode = '      3'                                         CSW210
     C                   EVAL      WMsgIdArr(WIdx) = 'ST00104'                                CSW210
                                                                                              CSW210
      *  Invalid IBAN length                                                                  CSW210
                                                                                              CSW210
     C                   WHEN      @Rcode = '      4'                                         CSW210
     C                   EVAL      WMsgIdArr(WIdx) = 'ST00105'                                CSW210
                                                                                              CSW210
      *  Invalid check digit                                                                  CSW210
                                                                                              CSW210
     C                   WHEN      @Rcode = '      5'                                         CSW210
     C                   EVAL      WMsgIdArr(WIdx) = 'ST00106'                                CSW210
                                                                                              CSW210
      *  Other/non-specific warning                                                           CSW210
                                                                                              CSW210
     C                   OTHER                                                                CSW210
     C                   EVAL      WMsgIdArr(WIdx) = 'ST00107'                                CSW210
     C                   ENDSL                                                                CSW210
     C**********         IF        DSACB1Pos1 = '/'                                AR578911 AR642262
     C*****'/'**         CAT       P@IBAN        DSACB1                            AR578911 AR642262
     C**********         ENDIF                                                     AR578911 AR642262
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      IBANFlg = 'N'                                              CSW210
     C                   ENDIF                                                                CSW210
     C                                                                                        CSW210
     C                   ENDSR                                                                CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************
      *                                                               *
      *  SRLine35 - Validate a 35 Alpha Input Field                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRLine35      BEGSR

      ** Validate First Character

     C                   IF        WWLI01 <> '/'
     C                   EVAL      WErr35 = 'Y'
     C                   ENDIF

      ** Validate First 2 Characters

     C                   IF        WWLI02 = '//' AND
     C                             WWLI04 <> '//BL' AND WWLI04 <> '//CH' AND
     C                             WWLI04 <> '//CP' AND WWLI04 <> '//FW' AND
     C                             WWLI04 <> '//SC'
     C                   EVAL      WErr35 = 'Y'
     C                   ENDIF

      ** Validate First 4 Characters

     C                   IF        PACCY <> 'USD' AND
     C                             WWLI04 <> '//CH' AND WWLI04 <> '//CP' AND
     C                             WWLI04 <> '//FW'
     C                   EVAL      WErr35 = 'Y'
     C                   ENDIF

     C                   IF        PACCY <> 'DEM' AND
     C                             WWLI04 = '//BL'
     C                   EVAL      WErr35 = 'Y'
     C                   ENDIF


      ** Invalid Entry

     C                   IF        WErr35 = 'Y'
     C                   EVAL      WErr35Msg = 'SEW5235'
     C                   GOTO      EVal35
     C                   ENDIF

      ** Validate First 5 Characters

     C                   IF        WWLI05 = '//CP'

     C                   IF        WCustType = 'C' OR WCustType = 'S'

      ** If //CP is followed by Blanks then Default this to the
      ** Customer CHIPS Participant

     C                   IF        WWBNBI = 'Y' AND WW0535 = *BLANKS
     C                   MOVEL     WWCABA        WW0507
     C                   ENDIF
     C                   ENDIF

      ** Error If ' //CP' is not followed by a 3 Digit Number
      ** followed by Blanks

     C                   MOVEL     WW0507        WWNUM4
     C                   MOVEL     WWNUM4        WWALP3
     C                   IF        WW0507 <> WWALP3 OR WW0835 <> *BLANKS
     C                   EVAL      WErr35 = 'Y'
     C                   EVAL      WErr35Msg = 'SEW5236'
     C                   GOTO      EVal35
     C                   ENDIF
     C                   ENDIF

      ** If Leftmost 4 Chars are '//FW' followed by Blanks and
      ** Customer SWIFT Id is Blank then Set Up Fedwire Account

     C                   IF        WWLI04 = '//FW'

     C                   IF        WW0535 = *BLANKS AND WWCSID = *BLANKS
     C                   MOVEL     WWFWCD        WW0513
     C                   ENDIF

      ** Error If Positions 14 -35 of WWLI35 are not Blank

     C                   IF        WW1435 <> *BLANKS
     C                   EVAL      WErr35 = 'Y'
     C                   EVAL      WErr35Msg = 'SEW5237'
     C                   GOTO      EVal35
     C                   ENDIF

      ** Fedwire Account may only be Blank for a Bank with a Valid
      ** SWIFT Address

     C                   IF        WW0513 = *BLANKS
     C                   IF        WCustType <> 'C' OR WCustType <> 'S' OR
     C                             WWBNBI = 'N' OR WWCSID = *BLANKS
     C                   EVAL      WErr35 = 'Y'
     C                   EVAL      WErr35Msg = 'SEW5237'
     C                   GOTO      EVal35
     C                   ENDIF

      ** Else, must be A 9 Digit Number

     C                   ELSE

     C                   MOVEL     WW0513        WWNU10
     C                   MOVEL     WWNU10        WWALP9
     C                   IF        WW0513 <> WWALP9
     C                   EVAL      WErr35 = 'Y'
     C                   EVAL      WErr35Msg = 'SEW5239'
     C                   GOTO      EVal35
     C                   ENDIF

     C                   ENDIF

      ** Customer or Bank must have a SWIFT Address or a Fedwire A/c

     C                   IF        WWCSID = *BLANKS AND WWFWCD = *BLANKS
     C                   EVAL      WErr35 = 'Y'
     C                   EVAL      WErr35Msg = 'SEW5240'
     C                   GOTO      EVal35
     C                   ENDIF

     C                   ENDIF

      ** If Leftmost 4 Chars of WWLI35 are '//BL' followed by Blanks
      ** Set Up the Bankleitzahl Code

     C                   IF        WWLI04 = '//BL'

     C                   IF        WCustType = 'C' OR WCustType = 'S'
     C                   IF        WWBNBI = 'Y' AND WW0535 = *BLANKS
     C                   MOVEL     WWBLCD        WW0512
     C                   ENDIF
     C                   ENDIF

      ** Error If '//BL' not followed by 8 Digits Number followed by
      ** Blanks

     C                   MOVEL     WW0512        WWNUM9
     C                   MOVEL     WWNUM9        WWALP8
     C                   IF        WW0512 <> WWALP8 OR WW1335 <> *BLANKS
     C                   EVAL      WErr35 = 'Y'
     C                   EVAL      WErr35Msg = 'SEW5241'
     C                   GOTO      EVal35
     C                   ENDIF

     C                   ENDIF

      ** If Leftmost 4 Chars of WWLI35 are '//CH' followed by Blanks
      ** Set Up Customer CHIPS Universal Id

     C                   IF        WWLI04 = '//CH'

     C                   IF        WCustType = 'C' OR WCustType = 'S'
     C                   IF        WWBNBI = 'Y' AND WW0535 = *BLANKS
     C                   MOVEL     WWCHID        WW0510
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** If Leftmost 4 Chars of WWLI35 are '//SC' followed by Blanks
      ** Set Up CHAPS Sort Code

     C                   IF        WWLI04 = '//SC'

     C                   IF        WCustType = 'C' OR WCustType = 'S'
     C                   IF        WWBNBI = 'Y' AND WW0535 = *BLANKS
     C                   MOVEL     WWCHSC        WW0510
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** Error If '//CH' or '//SC' are not followed by a 6 Digit Number

     C                   IF        WWLI04 = '//CH' OR WWLI04 = '//SC'

     C                   MOVEL     WW0510        WWNUM7
     C                   MOVEL     WWNUM7        WWALP6
     C                   IF        WW0510 <> WWALP6 OR WW1135 <> *BLANKS
     C                   EVAL      WErr35 = 'Y'
     C                   EVAL      WErr35Msg = 'SEW5242'
     C                   GOTO      EVal35
     C                   ENDIF

     C                   ENDIF

     C     EVal35        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRME9940 - Validate account with line via ME9940             *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRME9940      BEGSR

     C                   CALL      'ME9940'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    DSIParm
     C                   PARM                    DSOParm
     C                   PARM                    DSEParm
     C                   PARM                    WZ#Parm

     C                   MOVEL     O#ACLN        WWLI35
     C                   IF        E#ERRM <> *BLANKS
     C                   EVAL      WErr35 = 'Y'
     C                   ELSE

      ** Check whether Issuer Code has been defined for the currency
      ** clearing system. If not, set flag on to issue warning message
      ** for later display (SEW5176).

     C                   MOVEL     WZ#PARM       W#ISCD
     C                   IF        WWLI02 = '//' AND W#ISCD = *BLANKS AND
     C                             O#ACLN <> WACLN
     C                   EVAL      WICNIL = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValImdF - Validate Intermidiary fields                      *
      *                                                               *
      * Called by: SRValidate3                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRValImdF     BEGSR

     C                   EVAL      WErrImmd = 'N'
     C                   EVAL      WErrImsa = 'N'

      ** Validate Settlement parties
      ** ---------------------------

     C                   MOVEL     WWIMMD        PCustKey
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCustKey
     C                   PARM      *BLANKS       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY

      ** If Return code is not blank then check if entry is a valid BIC code

     C                   IF        @RtCd <> *BLANKS

     C                   EVAL      WErrImmd = 'Y'

     C**********         IF        PCFT007 = 'Y'                                              199797

     C                   MOVEL     WWIMMD        WKCSID8
     C                   MOVE      WWIMMD        WKCSID4
     C                   MOVEL     WKCSID4       WKCSID3


      ** Call program to validate ID

     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    WKCSID8
     C                   PARM                    WKCSID3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       WKBICC
     C                   PARM      *BLANKS       WKBICS
     C                   PARM      *BLANKS       WKBICI


      ** BIC identifier not found

     C                   IF        @RtCd = 'Y2U0005' OR @RtCd = 'MIN0246'
     C                   EVAL      WErrImmd = 'Y'
     C                   ELSE
     C                   EVAL      WErrImmd = 'N'
     C                   ENDIF

     C**********         ENDIF                                                                199797
     C                   MOVE      WWIMMD        WKCSID1           1                          204704
     C                   IF        WKCSID1 <> ' '                                             204704
     C                   EVAL      WErrImmd = 'Y'                                             204704
     C**********         ELSE                                                          204704 205141
     C**********         EVAL      WErrImmd = 'N'                                      204704 205141
     C                   ENDIF                                                                204704

     C                   IF        WErrImmd = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10026'
     C                   ENDIF

     C                   ELSE

     C**********         EVAL      WWIMMD = BBCUST                                            205141
     C                   EVAL      WWIMMD = BBCSID                                            205141
     C                   IF        WWIMMD = *BLANKS                                           209934
     C                   EVAL      WWIMMD = BBCUST                                            209934
     C                   ENDIF                                                                209934

     C                   ENDIF

      ** Check settlement amount is unique

     C                   IF        WErrImmd = 'N'
     C                   EVAL      WCtr3 = 1

     C                   DOW       WCtr3 <= 9

     C                   IF        WIMDArr(WCtr3) = *BLANKS
     C                   MOVEL     WWIMMD        WIMDArr(WCtr3)
     C                   LEAVE
     C                   ELSE

     C                   IF        WIMDArr(WCtr3) = WWIMMD
     C                   EVAL      WErrImmd = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#5IMMD'
     C                   EVAL      MsgIdArr(Idx) = 'SE10038'
     C                   LEAVE
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      WCtr3 = WCtr3 + 1
     C                   ENDDO

     C                   ENDIF

     C                   EXSR      SRDOORS                                                    201486
                                                                                              201486
      ** Validate Safekeeping account
      ** ----------------------------

      ** A settlement message is requested

     C                   IF        #2GMES = 'Y'
                                                                                              199797
     C                   IF        PISOMsgI <> 'Y'                                            199797

      ** Safekeeping account must start with a slash "/"

     C                   MOVEL     WWIMSA        WWSAFA1
     C                   IF        WWSAFA1 <> '/'
     C                   EVAL      WErrImsa = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5210'
     C                   ENDIF

     C                   MOVEL     WWIMSA        WWLI02
     C                   IF        WWLI02 = '//'
     C                   EVAL      WErrImsa = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5211'
     C                   ENDIF

     C                   MOVE      WWIMSA        WWLI19
     C                   IF        WWSAFA1 = '/' AND WWLI19 = *BLANKS
     C                   EVAL      WErrImsa = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5212'
     C                   ENDIF

     C                   ENDIF
                                                                                              199797
     C                   ENDIF                                                                199797

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       201486
      *                                                               *                       201486
      * SRDORF - Retrive Depot A/C Reference for defaulting           *                       201486
      *                                                               *                       201486
      * Called by: *Many                                              *                       201486
      *                                                               *                       201486
      * Calls: SEDORFRTV                                              *                       201486
      *                                                               *                       201486
      *****************************************************************                       201486
                                                                                              201486
     C     SRDORF        BEGSR                                                                201486
                                                                                              201486
     C                   EVAL      PReturnCode = *BLANKS                                      201486
     C                   EVAL      PSKALRef = *BLANKS                                         201486
                                                                                              201486
     C**********         CALLB     'SEDORFRTV'                                         201486 214012
     C                   CALL      'SEDORFRTV'                                                214012
     C                   PARM                    PReturnCode                                  201486
     C                   PARM                    PDepotCNum                                   201486
     C                   PARM                    PCntrPCNum                                   201486
     C                   PARM                    PSKALRef                                     201486
                                                                                              201486
     C                   ENDSR                                                                201486
                                                                                              201486
      *****************************************************************                       201486
      /EJECT                                                                                  201486
      *****************************************************************                       201486
      *                                                               *                       201486
      * SRDOORS - Default SafeKeeping A/C if necessary                *                       201486
      *                                                               *                       201486
      * Called by: SRINTM                                             *                       201486
      *                                                               *                       201486
      * Calls: SRDORF                                                 *                       201486
      *                                                               *                       201486
      *****************************************************************                       201486
                                                                                              201486
     C     SRDOORS       BEGSR                                                                201486
                                                                                              201486
     C                   IF        WWIMMD = TWIMMD and WWIMSA = *BLANKS and                   201486
     C                             WAGNA <> 'N'                                               201486
     C                   EVAL      WAGNA = *BLANKS                                            201486
     C                   ELSE                                                                 201486
     C                   EVAL      WAGNA = WAGNA                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   IF        WErrImmd <> 'Y' and WWIMSA = *BLANKS and                   201486
     C                             WWIMMD <> *BLANKS and WAGNA <> *BLANKS                     201486
                                                                                              201486
     C                   EVAL      TWIMMD = WWIMMD                                            201486
     C                   EVAL      PDepotCNum = WWIMMD                                        201486
                                                                                              201486
     C                   IF        PCBInd = 'C'                                               201486
     C                   EVAL      PCntrPCNum = PCustomer                                     201486
     C                   ELSE                                                                 201486
     C                   EVAL      PCntrPCNum = A8BICN                                        201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   EXSR      SRDORF                                                     201486
                                                                                              201486
     C                   IF        PSKALREF <> *BLANKS                                        201486
     C                   EVAL      WWIMSA = PSKALRef                                          201486
     C                   EVAL      WAGNA = 'N'                                                201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDSR                                                                201486
                                                                                              201486
      *****************************************************************                       201486
      /EJECT                                                                                  201486
      *****************************************************************
      *                                                               *
      * SRUpdate - Update additional standard settlement instructions *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRUpdate      BEGSR

     C**********         IF        PABCH = *BLANKS AND PACUST = 0 AND                         199797
     C**********                   PABK = *BLANKS AND PACCY = *BLANKS AND                     199797
     C**********                   PAINV = *BLANKS AND PAPREF = *BLANKS                       199797

     C                   EVAL      PABCH   = #1BRCH
     C                   MOVE      #1CUST        PACUST
     C                   EVAL      PABK    = #1BOOK
     C                   EVAL      PACCY   = #1CCY
     C                   EVAL      PAMKT   = #1MKCT                                           CSE034
     C                   EVAL      PAINV   = #1INVT
     C                   EVAL      PAPREF  = #1PORF

     C**********         ENDIF                                                                199797

     C                   IF        PAdDType = 'P'
     C                   EVAL      PATYPE  = 'P'
     C                   ELSE
     C                   EVAL      PATYPE  = 'S'
     C                   ENDIF

     C                   EVAL      PAGMES  = #2GMES
     C                   EVAL      PACONG  = #2CONG
     C                   EVAL      PAINST  = #2INST
     C                   EVAL      PAINSS  = #2INSS
     C                   EVAL      PARPTY  = #2RPTY
     C                   EVAL      PAGDEL  = #2GDEL
     C                   EVAL      PASROL  = #2SROL
     C                   EVAL      PAFIND  = #2FIND

     C                   IF        PAdDType = 'P'
     C                   EVAL      PACCTN  = #3CCTN
     C                   EVAL      PADRSN  = #3DRSN
     C                   EVAL      PADRS1  = #3DRS1
     C                   EVAL      PADRS2  = #3DRS2
     C                   EVAL      PADRS3  = #3DRS3
     C                   EVAL      PADRS4  = #3DRS4
     C                   EVAL      PAFIN1  = #3FIN1
     C                   EVAL      PAFIN2  = #3FIN2
     C**********         EVAL      PARED1  = #3RED1                                           CSW210
     C**********         EVAL      PARED2  = #3RED2                                           CSW210
     C                   EVAL      PANAS1  = #3NAS1
     C                   EVAL      PANAS2  = #3NAS2
     C                   ELSE
     C                   EVAL      PACCTN  = #4CCTN
     C                   EVAL      PADRSN  = #4DRSN
     C                   EVAL      PADRS1  = #4DRS1
     C                   EVAL      PADRS2  = #4DRS2
     C                   EVAL      PADRS3  = #4DRS3
     C                   EVAL      PADRS4  = #4DRS4
     C                   EVAL      PABSSN  = #4BSSN
     C                   EVAL      PABSS1  = #4BSS1
     C                   EVAL      PABSS2  = #4BSS2
     C                   EVAL      PAFIN1  = #4FIN1
     C                   EVAL      PAFIN2  = #4FIN2
     C**********         EVAL      PARED1  = #4RED1                                           CSW210
     C**********         EVAL      PARED2  = #4RED2                                           CSW210
     C                   EVAL      PANAS1  = #4NAS1
     C                   EVAL      PANAS2  = #4NAS2
     C                   ENDIF

     C                   EVAL      PAIMD1 = #5IMMD1
     C                   EVAL      PAIMD2 = #5IMMD2
     C**********         EVAL      PAIMD3 = #5IMMD3                                          CSW206D
     C**********         EVAL      PAIMD4 = #5IMMD4                                          CSW206D
     C**********         EVAL      PAIMD5 = #5IMMD5                                          CSW206D
     C**********         EVAL      PAIMD6 = #5IMMD6                                          CSW206D
     C**********         EVAL      PAIMD7 = #5IMMD7                                          CSW206D
     C**********         EVAL      PAIMD8 = #5IMMD8                                          CSW206D
     C**********         EVAL      PAIMD9 = #5IMMD9                                          CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      PAIMD3 = #5IMMD3                                          CSW206E
     C                   EVAL      PAIMD4 = #5IMMD4                                          CSW206E
     C                   EVAL      PAIMD5 = #5IMMD5                                          CSW206E
     C                   EVAL      PAIMD6 = #5IMMD6                                          CSW206E
     C                   EVAL      PAIMD7 = #5IMMD7                                          CSW206E
     C                   EVAL      PAIMD8 = #5IMMD8                                          CSW206E
     C                   EVAL      PAIMD9 = #5IMMD9                                          CSW206E
     C                   ENDIF                                                               CSW206E
     C                   EVAL      PAIMS1 = #5IMSA1
     C                   EVAL      PAIMS2 = #5IMSA2
     C**********         EVAL      PAIMS3 = #5IMSA3                                          CSW206D
     C**********         EVAL      PAIMS4 = #5IMSA4                                          CSW206D
     C**********         EVAL      PAIMS5 = #5IMSA5                                          CSW206D
     C**********         EVAL      PAIMS6 = #5IMSA6                                          CSW206D
     C**********         EVAL      PAIMS7 = #5IMSA7                                          CSW206D
     C**********         EVAL      PAIMS8 = #5IMSA8                                          CSW206D
     C**********         EVAL      PAIMS9 = #5IMSA9                                          CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      PAIMS3 = #5IMSA3                                          CSW206E
     C                   EVAL      PAIMS4 = #5IMSA4                                          CSW206E
     C                   EVAL      PAIMS5 = #5IMSA5                                          CSW206E
     C                   EVAL      PAIMS6 = #5IMSA6                                          CSW206E
     C                   EVAL      PAIMS7 = #5IMSA7                                          CSW206E
     C                   EVAL      PAIMS8 = #5IMSA8                                          CSW206E
     C                   EVAL      PAIMS9 = #5IMSA9                                          CSW206E
     C                   EVAL      PAPSET  = #5PSET
     C                   ELSE                                                                CSW206E
     C                   EVAL      PAPSET  = #5PSET1                                         CSW206E
     C                   ENDIF                                                               CSW206E

     C                   IF        PCSW210 = 'Y'                                              CSW210
     C                   EVAL      PAPSET  = #5PSET1                                          CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      PAPSET  = #5PSET                                           CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EVAL      PARED1  = #5RED1                                           CSW210
     C                   EVAL      PARED2  = #5RED2                                           CSW210
     C                   EVAL      PAQFIN  = #5QFI1                                           CSW210
     C                   EVAL      PAPCLR  = #5PCL1                                           CSW210
     C                   EVAL      PAAWIN  = #1AWIN
     C                   EVAL      PAAWIL  = #1AWIL
     C                   EVAL      PAAFPN  = #1AFPN
     C                   EVAL      PAAFPL  = #1AFPL
     C                   EVAL      PABOFN  = #1BOFN
     C                   EVAL      PABOF1  = #1BOF1
     C                   EVAL      PABOF2  = #1BOF2
     C                   EVAL      PASRL1  = #1SRL1
     C                   EVAL      PASRL2  = #1SRL2
     C                   EVAL      PASRL3  = #1SRL3
     C                   EVAL      PANAC1  = #1NAC1
     C                   EVAL      PANAC2  = #1NAC2
                                                                                              CSW210
     C                   EVAL      PADIDN  = @DEBTR1                                          CSW210
     C                   EVAL      PADLIN  = @DACNT1                                          CSW210
     C                   EVAL      PADAD1  = @DADDR1                                          CSW210
     C                   EVAL      PADAD2  = @DADDR2                                          CSW210
     C                   EVAL      PADAD3  = @DADDR3                                          CSW210
     C                   EVAL      PADAD4  = @DADDR4                                          CSW210

     C                   EVAL      PASTMP  = #2STMP
     C                   EVAL      PACHID  = #2CHID
     C                   EVAL      PATRRM  = #2TRRM

     C                   EVAL      PMODE = 'R'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return to calling program                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRReturn      BEGSR

     C                   EVAL      WInit = ' '
     C                   EVAL      RetCodeOut = PRetCode
     C                   CLEAR                   PrevMsg                                      CSW210
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.

     C/COPY ZACPYSRC,MSGHNDDSP2

      ***Subroutine SWIFT                                                            CSW210 AR570983
      **********                                                                     CSW210 AR570983
      **********/COPY FTCPYSRC,SFTSWFTCLE                                            CSW210 AR570983
      **********                                                                     CSW210 AR570983
      ***Subroutine ADCHK                                                            CSW210 AR570983
      **********                                                                     CSW210 AR570983
      **********/COPY FTCPYSRC,SFTADDRCLE                                            CSW210 AR570983
      **********                                                                     CSW210 AR570983
      ***Subroutine SWSET                                                            CSW210 AR570983
      **********                                                                     CSW210 AR570983
      **********/COPY FTCPYSRC,SFTADDRSC1                                            CSW210 AR570983
      **********                                                                     CSW210 AR570983
      *****************************************************************                     AR570983
      *                                                               *                     AR570983
      * SWIFT - Validate SWIFT                                        *                     AR570983
      *                                                               *                     AR570983
      * Called by: SRDBTA                                             *                     AR570983
      *                                                               *                     AR570983
      * Calls: None                                                   *                     AR570983
      *                                                               *                     AR570983
      *****************************************************************                     AR570983
                                                                                            AR570983
     C     SWIFT         BEGSR                                                              AR570983
                                                                                            AR570983
     C                   SETOFF                                       31                    AR570983
                                                                                            AR570983
      *  Test positions 1-8 for valid SWIFT Characters                                      AR570983
                                                                                            AR570983
      *  Check how many characters are alphanumeric                                         AR570983
     C                   MOVEL     *BLANKS       FLD                                        AR570983
     C                   MOVEL     CLSWTK        FLD              35                        AR570983
     C     ALPHAN        CHECK     FLD           X#                3 0                      AR570983
                                                                                            AR570983
      * If the first 8 or 11 are ok proceed                                                 AR570983
     C                   IF        %FOUND AND                                               AR570983
     C                             X# = 9      OR                                           AR570983
     C                             %FOUND AND                                               AR570983
     C                             X# = 12                                                  AR570983
     C     ' '           CHECK     FLD:X#                                 90                AR570983
                                                                                            AR570983
      * Check for blanks if before 8 or 11 then assume address                              AR570983
     C                   IF        %FOUND AND                                               AR570983
     C                             X# = 11                                                  AR570983
     C                   EVAL      *IN31 = *ON                                              AR570983
     C                   EVAL      ##CSID = 'Y'                                             AR570983
     C                   GOTO      EXSWFT                                                   AR570983
     C                   ENDIF                                                              AR570983
     C                   ENDIF                                                              AR570983
                                                                                            AR570983
      *  Invalid format - Not a S.W.I.F.T.                                                  AR570983
     C                   IF        %FOUND                                                   AR570983
     C                   EVAL      ##CSID = 'N'                                             AR570983
     C                   GOTO      EXSWFT                                                   AR570983
     C                   ENDIF                                                              AR570983
                                                                                            AR570983
      *  Call Access object to validate identifier                                          AR570983
     C                   MOVEL     FLD           W9BICC                                     AR570983
     C     3             SUBST     FLD:9         W9BICB                                     AR570983
                                                                                            AR570983
     C                   CALL      'ME1400'                                                 AR570983
     C                   PARM      *BLANKS       W9RTN             7                        AR570983
     C                   PARM                    W9BICC            8                        AR570983
     C                   PARM                    W9BICB            3                        AR570983
     C                   PARM                    SDCUST                                     AR570983
     C                   PARM                    SDCNST                                     AR570983
     C                   PARM                    MEBICD                                     AR570983
     C                   PARM      *BLANKS       W9CUST            1                        AR570983
     C                   PARM      *BLANKS       W9CNST            1                        AR570983
     C                   PARM      *BLANKS       W9BICD            1                        AR570983
                                                                                            AR570983
     C                   SELECT                                                             AR570983
                                                                                            AR570983
      *  Record not found on directory but found on others                                  AR570983
      *  - BIC directory has data so error                                                  AR570983
     C                   WHEN      W9RTN = 'MIN0244' OR                                     AR570983
     C                             W9RTN = 'MIN0245' OR                                     AR570983
     C                             W9RTN = 'MIN0246'                                        AR570983
     C                   EVAL      *IN31 = *ON                                              AR570983
     C                   EVAL      ##CSID = 'Y'                                             AR570983
                                                                                            AR570983
      *  Record not found - S.W.I.F.T does not exist                                        AR570983
     C                   WHEN      W9RTN = 'Y2U0005'                                        AR570983
     C**********         EVAL      *IN32 = *ON                                     AR570983 AR579549
     C                   EVAL      *IN91 = *ON                                              AR579549
     C                   EVAL      ##CSID = 'Y'                                             AR570983
                                                                                            AR570983
      *  Record found - BIC exists                                                          AR570983
     C                   WHEN      W9RTN = *BLANKS                                          AR570983
     C                   EVAL      ##CSID = 'Y'                                             AR570983
                                                                                            AR570983
     C                   ENDSL                                                              AR570983
                                                                                            AR570983
     CSR   EXSWFT        ENDSR                                                              AR570983
      *****************************************************************                     AR570983
      /EJECT                                                                                AR570983
      *****************************************************************                     AR570983
      *                                                               *                     AR570983
      * ADCHK - Validate Standard Address                             *                     AR570983
      *                                                               *                     AR570983
      * Called by: SRDBTA                                             *                     AR570983
      *                                                               *                     AR570983
      * Calls: None                                                   *                     AR570983
      *                                                               *                     AR570983
      *****************************************************************                     AR570983
                                                                                            AR570983
     C     ADCHK         BEGSR                                                              AR570983
                                                                                            AR570983
      *  Set off indicators & error flags                                                   AR570983
                                                                                            AR570983
     C                   SETOFF                                       92                    AR570983
     C                   EVAL      AD#1 = 'N'                                               AR570983
     C                   EVAL      AD#2 = 'N'                                               AR570983
     C                   EVAL      AD#3 = 'N'                                               AR570983
     C                   EVAL      AD#4 = 'N'                                               AR570983
     C                   MOVE      *BLANKS       FLD              35                        AR570983
                                                                                            AR570983
      * There should be no embedded spaces                                                  AR570983
                                                                                            AR570983
     C                   IF        ADCHK1 = *BLANKS  AND                                    AR570983
     C                             ADCHK2 <> *BLANKS OR                                     AR570983
                                                                                            AR570983
     C                             ADCHK1 = *BLANKS  AND                                    AR570983
     C                             ADCHK3 <> *BLANKS OR                                     AR570983
                                                                                            AR570983
     C                             ADCHK1 = *BLANKS  AND                                    AR570983
     C                             ADCHK4 <> *BLANKS OR                                     AR570983
                                                                                            AR570983
     C                             ADCHK2 = *BLANKS  AND                                    AR570983
     C                             ADCHK3 <> *BLANKS OR                                     AR570983
                                                                                            AR570983
     C                             ADCHK2 = *BLANKS  AND                                    AR570983
     C                             ADCHK4 <> *BLANKS OR                                     AR570983
                                                                                            AR570983
     C                             ADCHK3 = *BLANKS  AND                                    AR570983
     C                             ADCHK4 <> *BLANKS                                        AR570983
                                                                                            AR570983
     C                   EVAL      *IN92 = *ON                                              AR570983
     C                   ENDIF                                                              AR570983
                                                                                            AR570983
      *                                                                                     AR570983
      *                                                                                     AR570983
      ** Check for non-valid SWIFT characters                                               AR570983
     C                   IF        ADCHK1 <> *BLANKS                                        AR570983
     C                   EVAL      FLD = ADCHK1                                             AR570983
     C                   EXSR      SWSET                                                    AR570983
                                                                                            AR570983
     C                   IF        *IN99 = *ON                                              AR570983
      * Send error to screen                                                                AR570983
     C                   MOVE      'Y'           AD#1              1                        AR570983
     C                   ENDIF                                                              AR570983
                                                                                            AR570983
     C                   ENDIF                                                              AR570983
                                                                                            AR570983
     C                   IF        ADCHK2 <> *BLANKS                                        AR570983
     C                   EVAL      FLD = ADCHK2                                             AR570983
     C                   EXSR      SWSET                                                    AR570983
                                                                                            AR570983
     C                   IF        *IN99 = *ON                                              AR570983
      * Send error to screen                                                                AR570983
     C                   MOVE      'Y'           AD#2              1                        AR570983
     C                   ENDIF                                                              AR570983
                                                                                            AR570983
     C                   ENDIF                                                              AR570983
                                                                                            AR570983
     C                   IF        ADCHK3 <> *BLANKS                                        AR570983
     C                   EVAL      FLD = ADCHK3                                             AR570983
     C                   EXSR      SWSET                                                    AR570983
                                                                                            AR570983
     C                   IF        *IN99 = *ON                                              AR570983
      * Send error to screen                                                                AR570983
     C                   MOVE      'Y'           AD#3              1                        AR570983
     C                   ENDIF                                                              AR570983
                                                                                            AR570983
     C                   ENDIF                                                              AR570983
                                                                                            AR570983
     C                   IF        ADCHK4 <> *BLANKS                                        AR570983
     C                   EVAL      FLD = ADCHK4                                             AR570983
     C                   EXSR      SWSET                                                    AR570983
                                                                                            AR570983
     C                   IF        *IN99 = *ON                                              AR570983
      * Send error to screen                                                                AR570983
     C                   MOVE      'Y'           AD#4              1                        AR570983
     C                   ENDIF                                                              AR570983
                                                                                            AR570983
     C                   ENDIF                                                              AR570983
                                                                                            AR570983
     CSR                 ENDSR                                                              AR570983
      *****************************************************************                     AR570983
      /EJECT                                                                                AR570983
      *****************************************************************                     AR570983
      *                                                               *                     AR570983
      * SWSET - Check for invalid characters                          *                     AR570983
      *                                                               *                     AR570983
      * Called by: SRDBTA                                             *                     AR570983
      *                                                               *                     AR570983
      * Calls: None                                                   *                     AR570983
      *                                                               *                     AR570983
      *****************************************************************                     AR570983
                                                                                            AR570983
     C     SWSET         BEGSR                                                              AR570983
                                                                                            AR570983
     C                   EVAL      *IN99 = *OFF                                             AR570983
                                                                                            AR570983
     C     ISO           CHECK     FLD           X#                3 0    99                AR570983
      *                                                                                     AR570983
     CSR                 ENDSR                                                              AR570983
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR

      ** Receive entry parameters.

     C     *ENTRY        PLIST

      ** Input Parameters
      ** ================
      ** Action Code
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
      ** Customer/Book description
      ** Additional detail type
      ** Customer/Book indicator
      ** ISO15022 message indicator
      ** To be used for depot movement

     C                   PARM                    ActionCode
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
     C                   PARM                    PDescrptn
     C                   PARM                    PAdDType
     C                   PARM                    PCBInd
     C                   PARM                    PISOMsgI
     C                   PARM                    PForDpmI

      ** SDBANKPD
      ** ========
      ** Rundate

     C                   PARM                    PBJMRDT

      ** SDMMODPD
      ** ========
      ** Portfolio Management
      ** Private Banking

     C                   PARM                    PBGPFMG
     C                   PARM                    PBGN4ST

      ** SDSECSPD
      ** ========
      ** Customer classification

     C                   PARM                    PBFCLAS

      ** SCSARDPD
      ** ========
      ** ERI
      ** SWIFT 1998 changes
      ** BIC database plus
      ** ISO15022 Data Export                                                                 209247
      ** SWIFT 2010 changes                                                                   CSW210
      ** IBAN                                                                                 CSW210

     C                   PARM                    PCSW014
     C                   PARM                    PCSW098
     C                   PARM                    PCFT007
     C                   PARM                    PCSE029                                      209247
     C                   PARM                    CSW206                                     BUG12357
     C                   PARM                    PCSW210                                      CSW210
     C                   PARM                    PCFT004                                      CSW210
     C                   PARM                    PCSW202                                    AR325342

      ** Input-Output Parameters
      ** =======================
      ** Data Structure for additional settlement details

     C                   PARM                    PAddSetD

      ** Output Parameters
      ** =================
      ** Return code

     C                   PARM                    RetCodeOut

      ** Move workstation ID to screen field.

     C                   EVAL      #1USER = PsUser
     C                   EVAL      #1WID  = PsJobName
     C                   EVAL      #1DATE = PBJMRDT

      ** Initialise the fixed parameters for ZAMSGHNDLE.

     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'

      ** Set up the prime and secondary message files for
      ** finding message IDs.

     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'

      ** Message subfile control

     C                   EVAL      *IN97 =  '1'
     C                   EVAL      #1PGMQ = '*'

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

     C/COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
      /EJECT
      *****************************************************************

**  CPY@
(c) Finastra International Limited 2001
** WInzIndArr
000000000000000000000000000000000000000000000000000000000000000000000
** WInzOkFlags
YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
**  VA0  - All Numeric Chars
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
**  VA1  - INSTRUCTIONS TYPE VALIDATIONS (ALPAHABETIC)
INTBRIEXT#####################
**  Alpha - Array of alphabetic characters                                                    CSW210
ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                    CSW210
**  Numeric - Array of numeric characters                                                     CSW210
0123456789                                                                                    CSW210
