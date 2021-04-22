     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Addnl SWIFT details for depot movement')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEDSSIDSP - Additional SWIFT Details for Depot Movement      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR642262           Date 14Sep10               *
      *                 AR636523           Date 02Sep10               *
      *                 AR635847           Date 31Aug10               *
      *                 AR634357           Date 27Aug10               *
      *                 AR589197           Date 11Aug10               *
      *                 AR588640           Date 06Aug10               *
      *                 AR579549           Date 16Jul10               *
      *                 AR580857           Date 21Jul10               *
      *                 AR579600           Date 19Jul10               *
      *                 AR578911           Date 15Jul10               *
      *                 AR574149           Date 07Jul10               *
      *                 AR570983           Date 01Jul10               *
      *                 AR571002           Date 01Jul10               *
      *                 AR568778           Date 25Jun10               *
      *                 AR325342           Date 19May10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
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
      *                 BUG2395            Date 18May04               *
      *                 CGL029             Date 01Sep03               *
      *                 214012             Date 06Mar03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209934             Date 07Nov02               *
      *                 209247             Date 08Oct02               *
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
      *                 199797             Date 01Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028  *CREATE    Date 06Jun01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
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
      *  AR579600 - Remove slash on valid IBAN input                  *
      *  AR578911 - Remove slash and embedded blanks on IBAN input    *
      *  AR574149 - Confusing warning message for ISO Country code    *
      *             for IBAN                                          *
      *  AR570983 - Fields Intermediary 3 to 9 are displayed in the   *
      *             settlement details even if CSW206 is *ON          *
      *  AR571002 - SEST- Debtor address 1 inserted /DSS/ error       *
      *             message: SWIFT identifier was not found.          *
      *  AR568778 - Depot In and Depot Out displays different error   *
      *           message in A/c for Payment Account Line Field       *
      *  AR325342 - Clearing correspondent field must not be displayed*
      *  CSW210 - SWIFT 2010 Changes                                  *
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
      *  BUG2395 - Deliverer of Securities field should not be        *
      *            mandatory. Apply fix 205885.                       *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  214012 - Replace CALLB SEDORFRTV by CALL                     *
      *  209934 - Intermediary 9 field is independent of Intermediary *
      *           8 field                                             *
      *  209247 - Add Custodian and Safe A/c narrative                *
      *  205141 - Intermediaries to be converted to SWIFT ID.         *
      *  205663 - Additional Screen for Customer SSI.                 *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  204804 - Clearing correspondent should accept customer no.   *
      *  204585 - Deliverer of Securities validation.                 *
      *  204751 - '?' processing for clearing correspondent.          *
      *  204753 - '?' not working properly in Deliverer of Securities *
      *  204704 - Intermediary field not validating 12th character.   *
      *  204364 - Clearing correspondent should also be validated     *
      *           against the BIC file.                               *
      *  201429 - New validation needed for ISO15022 in               *
      *           extended settlement screen.                         *
      *  201486 - Additional defaulting added for A/C lines.          *
      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    10         Depot In/Depot Out Indicator                    *
      *                                                               *
      * ** Screen one for internal customer                           *
      *                                                               *
      *    11         Error on a/c with institution number            *
      *    12         Error on a/c with institution line              *
      *    13         Error on a/c for payment number                 *
      *    14         Error on a/c for payment line                   *
      *    15         Error on beneficiary of money number            *
      *    16         Error on beneficiary of money line 1            *
      *    17         Error on beneficiary of money line 2            *
      *    18         Error on sender to receiver info line 1         *
      *    19         Error on sender to receiver info line 2         *
      *    20         Error on sender to receiver info line 3         *
      *    21         Error on narrative for cash parties line 1      *
      *    22         Error on narrative for cash parties line 2      *
      *                                                               *
      * ** Screen one for non-internal customer                       *
      *                                                               *
      *    23         Error on settlement message request             *
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
      * ** Screen two for depot in/depot out                          *
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
      *    45         Error on beneficiaries securities number        *
      *    46         Error on beneficiaries securities line 1        *
      *    47         Error on beneficiaries securities line 2        *
      *                                                               *
      * ** Screen three                                               *
      *                                                               *
      *    48         Error on settlement party 1                     *
      *    49         Error on safekeeping account 1                  *
      *    50         Error on settlement party 2                     *
      *    51         Error on safekeeping account 2                  *
      *    52         Error on settlement party 3                     *
      *    53         Error on safekeeping account 3                  *
      *    54         Error on settlement party 4                     *
      *    55         Error on safekeeping account 4                  *
      *    56         Error on settlement party 5                     *
      *    57         Error on safekeeping account 5                  *
      *    58         Error on settlement party 6                     *
      *    59         Error on safekeeping account 6                  *
      *    60         Error on settlement party 7                     *
      *    61         Error on safekeeping account 7                  *
      *    62         Error on settlement party 8                     *
      *    63         Error on safekeeping account 8                  *
      *    64         Error on settlement party 9                     *
      *    65         Error on safekeeping account 9                  *
      *    66         Error on place of settlement                    *
      *                                                               *
      *    68         Customer/Book Indicator                         *
      *    69         Internal/Non-Internal Indicator                 *
      *    70         Protect/Underline Indicator                     *
      *    71         Display fields if ISOMsg is 'Y'                 *
      *    74         Rollup Indicator                                *
      *    75         Rolldown Indicator                              *
      *    76         Display 1st Screen                              *
      *    77         Display 2nd Screen                              *
      *    78         Display 3rd Screen                              *
      *    80         CSE029 is on                                    *                       209247
      *    82         Lookup Indicator                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMain       -  Program Main Processing                      *
      *  SRInit       -  Initial Processing                           *
      *  SRResetScrn1 -  Set-up screen 1 display fields               *
      *  SRResetScrn2 -  Set-up screen 2 display fields               *
      *  SRResetScrn3 -  Set-up screen 3 display fields               *
      *  SRDisplay0   -  Display additional SSI for swift screen 0    *                       205663
      *  SRDisplay1   -  Display additional SSI for swift screen 1    *
      *  SRDisplay2   -  Display additional SSI for swift screen 2    *
      *  SRDisplay3   -  Display additional SSI for swift screen 3    *
      *  SRValidate1  -  Validate screen 1 fields                     *
      *  SRValidate2  -  Validate screen 2 fields                     *
      *  SRValidate3  -  Validate screen 3 fields                     *
      *  SRCust       -  Validate Customer Number/Shortname/Nostro    *
      *  SRCust2      -  Check Intermediary Field                     *
      *  SRLI35       -  Validate a 35A Input Field                   *
      *  SRME99       -  Validate Account with Line via ME9940        *
      *  SRAWIN       -  Validate Account with Institution            *
      *  SRAWIL       -  Validate Account with Institution A/C        *
      *  SRAFPN       -  Validate Account for Payment                 *
      *  SRAFPL       -  Validate Account for Payment A/C Line        *
      *  SRBOFN       -  Validate Beneficiary of Money                *
      *  SRBOF1       -  Validate Beneficiary of Money A/C Line 1     *
      *  SRBOF2       -  Validate Beneficiary of Money A/C Line 2     *
      *  SRSRL1       -  Validate Sender to Receiver Information 1    *
      *  SRSRL2       -  Validate Sender to Receiver Information 2    *
      *  SRSRL3       -  Validate Sender to Receiver Information 3    *
      *  SRGMES       -  Validate Settlement Message Request          *
      *  SRINST       -  Validate Instruction Type                    *
      *  SRINSS       -  Validate Instruction Sub-Type                *
      *  SRRPTY       -  Validate Requested Priority                  *
      *  SRGDEL       -  Validate Guaranteed Delivery                 *
      *  SRSROL       -  Validate Sender's Role                       *
      *  SRFIND       -  Validate Free or Against Payment             *
      *  SRCCTN       -  Validate Clearing Correspondent              *
      *  SRDRSN       -  Validate Deliverer/Receiver of Securities    *
      *  SRDRS1       -  Validate Deliverer/Receiver of Securities 1  *
      *  SRDRS2       -  Validate Deliverer/Receiver of Securities 2  *
      *  SRDRS3       -  Validate Deliverer/Receiver of Securities 3  *
      *  SRDRS4       -  Validate Deliverer/Receiver of Securities 4  *
      *  SRFIN1       -  Validate Further Information 1               *
      *  SRFIN2       -  Validate Further Information 2               *
      *  SRRED1       -  Validate Registration Details 1              *
      *  SRRED2       -  Validate Registration Details 2              *
      *  SRNAS1       -  Validate Narrative 1                         *
      *  SRNAS2       -  Validate Narrative 2                         *
      *  SRBSSN       -  Validate Beneficiary of Securities           *
      *  SRBSS1       -  Validate Beneficiary of Securities 1         *
      *  SRBSS2       -  Validate Beneficiary of Securities 2         *
      *  SRINTM       -  Validate Intermediary Fields                 *
      *  SRSAFE       -  Validate Safekeeping Account                 *
      *  SRPSET       -  Validate Place of Settlement                 *
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

     FSEDSSIDSDFCF   E             WORKSTN INFSR(*PSSR)

      ** Midas SD Customers by unique SWIFT ID                                                199797
     FSDCUSTL7  IF   E           K DISK    RENAME(@CUSTGE:SDCUSTSW)                           199797
                                                                                              199797
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

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

     D @EI             S              1    DIM(20)
     D CCO             S              1    DIM(12)
     D @Z0             S              1    DIM(56) CTDATA PERRCD(56)
     D VA0             S              1    DIM(36) CTDATA PERRCD(36)
     D VA1             S              3    DIM(10) CTDATA PERRCD(10)
     D***@IM****         S             12    DIM(9)                                          CSW206D
     D***@IM****         S             12    DIM(2)                                  CSW206D CSW206E
     D***@TA****         S             12    DIM(9)                                   201486 CSW206D
     D***@TA****         S             12    DIM(2)                                  CSW206D CSW206E
     D***@SA****          S             20    DIM(9)                                         CSW206D
     D***@SA****         S             20    DIM(2)                                  CSW206D CSW206E
     D @IM             S             12    DIM(9)                                            CSW206E
     D @TA             S             12    DIM(9)                                            CSW206E
     D @SA             S             20    DIM(9)                                            CSW206E
     D WIMDArr         S             12    DIM(9)

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
      ** External DS for Standard Additional Settlement Details

     D PDepot        E DS                  EXTNAME(STDADSED)

      ** Customer details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** BIC Directory

     D MEBICD        E DS                  EXTNAME(MEBICDPD)

      ** Counterparty Details

     DSDCNST         E DS                  EXTNAME(SDCNSTPD)

      ** Branch details                                                                       201486
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  201486
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
                                                                                              201486
      ** First Data Structure for Access Objects

     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second Data Structure for Access Objects

     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Validation Work Fields                                                               CSW210
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
      ** DS for Screen 1 (for non-internal or book)

     D OkSCRN1         DS
     D OkAWIN                  1      1
     D OkAWIL                  2      2
     D OkAFPN                  3      3
     D OkAFPL                  4      4
     D OkBOFN                  5      5
     D OkBOF1                  6      6
     D OkBOF2                  7      7
     D OkSRL1                  8      8
     D OkSRL2                  9      9
     D OkSRL3                 10     10
     D OkNAC1                 11     11
     D OkNAC2                 12     12
     D DbtrOk                 13     13                                                       CSW210
     D DActOk                 14     14                                                       CSW210
     D DAd1Ok                 15     15                                                       CSW210
     D DAd2Ok                 16     16                                                       CSW210
     D DAd3Ok                 17     17                                                       CSW210
     D DAd4Ok                 18     18                                                       CSW210

      ** DS for Screen 1 (for internal customer)

     D OkSCRN2         DS
     D OkGMES                  1      1
     D OkINST                  2      2
     D OkINSS                  3      3
     D OkRPTY                  4      4
     D OkGDEL                  5      5
     D OkSROL                  6      6
     D OkSTMP                  7      7
     D OkCHID                  8      8
     D OkTRRM                  9      9
     D OkFIND                 10     10

      ** DS for Screen 2

     D OkSCRN3         DS
     D OkCCTN                  1      1
     D OkDRSN                  2      2
     D OkDRS1                  3      3
     D OkDRS2                  4      4
     D OkDRS3                  5      5
     D OkDRS4                  6      6
     D OkFIN1                  7      7
     D OkFIN2                  8      8
     D OkRED1                  9      9
     D OkRED2                 10     10
     D OkNAS1                 11     11
     D OkNAS2                 12     12
     D OkBSSN                 13     13
     D OkBSN1                 14     14
     D OkBSN2                 15     15

      ** DS for Screen 3

     D OkSCRN4         DS
     D OkIMD1                  1      1
     D OkIMS1                  2      2
     D OkIMD2                  3      3
     D OkIMS2                  4      4
     D***OkIMD3*                 5      5                                                    CSW206D
     D***OkIMS3*                 6      6                                                    CSW206D
     D***OkIMD4*                 7      7                                                    CSW206D
     D***OkIMS4*                 8      8                                                    CSW206D
     D***OkIMD5*                 9      9                                                    CSW206D
     D***OkIMS5*                10     10                                                    CSW206D
     D***OkIMD6*                11     11                                                    CSW206D
     D***OkIMS6*                12     12                                                    CSW206D
     D***OkIMD7*                13     13                                                    CSW206D
     D***OkIMS7*                14     14                                                    CSW206D
     D***OkIMD8*                15     15                                                    CSW206D
     D***OkIMS8*                16     16                                                    CSW206D
     D***OkIMD9*                17     17                                                    CSW206D
     D***OkIMS9*                18     18                                                    CSW206D
     D***OkPSET*                19     19                                                    CSW206D
     D***OkPSET*                 5      5                                            CSW206D CSW206E
     D OkIMD3                  5      5                                                      CSW206E
     D OkIMS3                  6      6                                                      CSW206E
     D OkIMD4                  7      7                                                      CSW206E
     D OkIMS4                  8      8                                                      CSW206E
     D OkIMD5                  9      9                                                      CSW206E
     D OkIMS5                 10     10                                                      CSW206E
     D OkIMD6                 11     11                                                      CSW206E
     D OkIMS6                 12     12                                                      CSW206E
     D OkIMD7                 13     13                                                      CSW206E
     D OkIMS7                 14     14                                                      CSW206E
     D OkIMD8                 15     15                                                      CSW206E
     D OkIMS8                 16     16                                                      CSW206E
     D OkIMD9                 17     17                                                      CSW206E
     D OkIMS9                 18     18                                                      CSW206E
     D OkPSET                 19     19                                                      CSW206E
     D ReD1Ok                 20     20                                                       CSW210
     D ReD2Ok                 21     21                                                       CSW210
     D PClrOk                 22     22                                                       CSW210
     D QFInOk                 23     23                                                       CSW210
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

      ** DS for Intermediary

     D WInterMed       DS
     D #4IMMD1                 1     12
     D #4IMMD2                13     24
     D***#4IMMD3                25     36                                                    CSW206D
     D***#4IMMD4                37     48                                                    CSW206D
     D***#4IMMD5                49     60                                                    CSW206D
     D***#4IMMD6                61     72                                                    CSW206D
     D***#4IMMD7                73     84                                                    CSW206D
     D***#4IMMD8                85     96                                                    CSW206D
     D***#4IMMD9                97    108                                                    CSW206D
     D #4IMMD3                25     36                                                      CSW206E
     D #4IMMD4                37     48                                                      CSW206E
     D #4IMMD5                49     60                                                      CSW206E
     D #4IMMD6                61     72                                                      CSW206E
     D #4IMMD7                73     84                                                      CSW206E
     D #4IMMD8                85     96                                                      CSW206E
     D #4IMMD9                97    108                                                      CSW206E

      ** DS for Safekeeping Account

     D WSafeAcct       DS
     D #4IMSA1                 1     20
     D #4IMSA2                21     40
     D***#4IMSA3                41     60                                                    CSW206D
     D***#4IMSA4                61     80                                                    CSW206D
     D***#4IMSA5                81    100                                                    CSW206D
     D***#4IMSA6               101    120                                                    CSW206D
     D***#4IMSA7               121    140                                                    CSW206D
     D***#4IMSA8               141    160                                                    CSW206D
     D***#4IMSA9               161    180                                                    CSW206D
     D #4IMSA3                41     60                                                      CSW206E
     D #4IMSA4                61     80                                                      CSW206E
     D #4IMSA5                81    100                                                      CSW206E
     D #4IMSA6               101    120                                                      CSW206E
     D #4IMSA7               121    140                                                      CSW206E
     D #4IMSA8               141    160                                                      CSW206E
     D #4IMSA9               161    180                                                      CSW206E

      ** Input Parameters

     D***I#PARM*          DS           512                                                    CGL029
     DI#PARM           DS           514                                                       CGL029
     DI#VFLD                   1      5
     DI#PR                     6      8
     DI#PRTT                   9      9
     DI#PRTY                  10     20
     DI#PCCY                  21     23
     DI#RCCY                  24     26
     DI#ACLN                  27     61
     DI#ACC1                  27     27
     DI#ACC2                  28     28
     DI#ACC3                  29     29
     DI#ACCL                  27     30
     DI#ACCS                  29     30
     DI#SPC1                  31     61
     DI#MTYP                  62     64
     DI#INBT                  65     65
     DI#INBK                  66     76
     DI#AWBT                  77     77
     DI#AWBK                  78     88
     DI#BENT                  89     89
     DI#BENF                  90    100
     DI#RSTM                 101    102
     DI#PSTM                 103    104
     DI#5354                 105    105
     DI#MMOD                 106    107
     D***I#PYAC*                108    125                                                    CGL029
     D***I#RCAC*                126    143                                                    CGL029
     DQQPYAC                 108    125                                                       CGL029
     DQQRCAC                 126    143                                                       CGL029
     DI#TTYP                 144    145
     DI#COVR                 146    146
     DI#BTB                  257    466
     DI#BTB1                 257    291
     DI#BTB2                 292    326
     DI#BTB3                 327    361
     DI#BTB4                 362    396
     DI#BTB5                 397    431
     DI#BTB6                 432    466
     DI#PYAC                 467    490                                                       CGL029
     DI#RCAC                 491    514                                                       CGL029

      ** Output Parameters

     D***O#PARM*          DS           512                                                    CGL029
     DO#PARM           DS           514                                                       CGL029
     DO#ACLN                   1     35
     DO#BTB                  257    466
     DO#BTB1                 257    291
     DO#BTB2                 292    326
     DO#BTB3                 327    361
     DO#BTB4                 362    396
     DO#BTB5                 397    431
     DO#BTB6                 432    446

      * Error Parameters

     DE#PARM           DS           256
     DE#CPGM                   1     10
     DE#ERRM                  12     12
     DE#WARN                  13     13
     DE#INDX                  14     18  0
     DE#MSGD                  19     25
     DE#MSGF                  26     35
     DE#ERCD                  51    200
     DO#E                     51    200

     DWWDS1            DS            35
     DWWLI35                   1     35
     DWW0507                   5      7
     DWW0510                   5     10
     DWW0512                   5     12
     DWW0513                   5     13
     DWW0535                   5     35
     DWW0835                   8     35
     DWW1135                  11     35
     DWW1335                  13     35
     DWW1435                  14     35

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     DPMode            S              1A

      ** Entry Parameters

     DPBranch          S              3A
     DPCustomer        S              6A
     DPBook            S              2A
     DPCcy             S              3A
     DPMktCtr          S              2A                                                      CSE034
     DPInvType         S              3A
     DPPorRef          S              4A
     DPDescrptn        S             20A
     DPAdDType         S              1A
     DPCBInd           S              1A
     DPISOMsg          S              1A
     DPBJMRDT          S              7A
     DPBFCLAS          S              1A
     DPCSW014          S              1A
     DPCSW098          S              1A
     D PCSW210         S              1A                                                      CSW210
     D PCFT004         S              1A                                                      CSW210
     D PCSW201         S              1A                                                    AR571002
     DPCFT007          S              1A
     DPCSE029          S              1A                                                      209247
     DPCSW202          S              1A                                                    AR325342

      ** Parameters for SDCUSTPD

     DPKEY1            S             10A
     DPKYST            S              7A

      ** Variables for SDCNSTPD

     DPKEY2            S              8A
     DWWNOST           S              8A

      ** Parameter for ME9940

     DZ#PARM           S            256A

      ** Parameters for ME1400

     DPBICR            S              7A
     DPCSID8           S              8A
     DPCSID4           S              4A
     DPCSID3           S              3A
     DPBICC            S              1A
     DPBICS            S              1A
     DPBICI            S              1A

      ** Variable used for validation

     DIdx              S              3P 0
     D WIdx            S              3P 0                                                    CSW210
     DWERROR           S              1A
     DWINIT            S              1A
     DWFldNum          S              1A
     DWFIELD           S              7A
     DWFIELD2          S              7A
     DWWFWCD           S              9A
     DWCLAS            S              1A
     DWWCUSS           S              1A
     DWWER35           S              1A
     DWWLI01           S              1A
     DWWLI02           S              2A
     DWWLI04           S              4A
     DWWLI05           S              5A
     DWWLI19           S             19A
     DWWLI33           S             33A
     DWWLI34           S             34A
     DWWSR06           S              6A
     DWWSR07           S              7A
     DWWSR08           S              8A
     DWWALP3           S              3A
     DWWALP6           S              6A
     DWWALP8           S              8A
     DWWALP9           S              9A
     DWWAWIL           S              1A
     DWWAFPL           S              1A
     DWWNAL1           S              1A
     DWWNAL2           S              1A
     DWWBOF1           S              1A
     DWWBOF2           S              1A
     DWWBSS1           S              1A
     DWWBSS2           S              1A
     DWWDRS1           S              1A
     DWWDRS2           S              1A
     DWWDRS3           S              1A
     DWWDRS4           S              1A
     DWWSKAL           S              1A
     DWWSRL1           S              1A
     DWWSRL2           S              1A
     DWWSRL3           S              1A
     DIAWBK            S              1A
     DIBENF            S              1A
     DWICNIL           S              1A
     DW#ISCD           S              4A
     DWACLN            S             35A
     DWAWBK            S             35A
     DWBENF            S             35A
     DWWNUM4           S              4P 0
     DWWNUM7           S              7P 0
     DWWNUM9           S              9P 0
     DWWNU10           S             10P 0
     DWCtr             S              3P 0
     DWIMFlg           S              1A
     DWUnqeFlg         S              1A
     DWWIMMD           S             12A
     DJFIMMD           S             12A                                                      205141
     D***WPInterMed       S            108A                                                  CSW206D
     D***WPInterMed       S             24A                                          CSW206D CSW206E
     DWPInterMed       S            108A                                                     CSW206E
     DWPPSET           S             12A
     DWPQFIN           S             12A                                                    AR634357
     DWWPCL1           S             12A                                                    AR634357
     DWWDBTR           S             12A                                                    AR634357
     DWWAFPN           S             12A                                                    AR635847
     DWWAWIN           S             12A                                                    AR635847
     DWWBOFN           S             12A                                                    AR635847

     DWWCABA           S                   LIKE(BBCABA) INZ(*Blanks)
     DWWCSID           S                   LIKE(BBCSID) INZ(*Blanks)
     DWWBLCD           S                   LIKE(BBBLCD) INZ(*Blanks)
     DWWCHID           S                   LIKE(BBCHID) INZ(*Blanks)
     DWWCHSC           S                   LIKE(BBCHSC) INZ(*Blanks)
     DWWBNBI           S                   LIKE(BBBNBI) INZ(*Blanks)
     DWCCTN            S                   LIKE(#2CCTN) INZ(*Blanks)
     DWDRSN            S                   LIKE(#2DRSN) INZ(*Blanks)
     DWDRS1            S                   LIKE(#2DRS1) INZ(*Blanks)
     DWDRS2            S                   LIKE(#2DRS2) INZ(*Blanks)
     DWDRS3            S                   LIKE(#2DRS3) INZ(*Blanks)
     DWDRS4            S                   LIKE(#2DRS4) INZ(*Blanks)
     DWFIN1            S                   LIKE(#2FIN1) INZ(*Blanks)
     DWFIN2            S                   LIKE(#2FIN2) INZ(*Blanks)
     D**WRED1***         S                   LIKE(#2RED1) INZ(*Blanks)                        CSW210
     D**WRED2***         S                   LIKE(#2RED2) INZ(*Blanks)                        CSW210
     DWRED1            S                   LIKE(#4RED1) INZ(*Blanks)                          CSW210
     DWRED2            S                   LIKE(#4RED2) INZ(*Blanks)                          CSW210
     DWNAS1            S                   LIKE(#2NAS1) INZ(*Blanks)
     DWNAS2            S                   LIKE(#2NAS2) INZ(*Blanks)
     DWAWIN            S                   LIKE(#0AWIN) INZ(*Blanks)
     DWBOFN            S                   LIKE(#0BOFN) INZ(*Blanks)

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
     D WAGNA           S              1    INZ(*BLANK)                                        201486
     D WANGA           S              1    INZ(*BLANK)                                        201486
     D WAANG           S              1    INZ(*BLANK)                                        201486
     D TDRSN           S                   LIKE(WDRSN) INZ(*BLANKS)                           201486
     D T0AWIN          S                   LIKE(#0AWIN) INZ(*BLANKS)                          201486
     D T0AFPN          S                   LIKE(#0AFPN) INZ(*BLANKS)                          201486
     D T0BOFN          S                   LIKE(#0BOFN) INZ(*BLANKS)                          201486
     D T3BSSN          S                   LIKE(#3BSSN) INZ(*BLANKS)                          201486
                                                                                              201486
     D ADLINE          S              1                                                       CSW210
     D ADSLON          S              1                                                       CSW210
     D ##CSID          S              1A                                                      CSW210
     D C#RTCD          S              7                                                       CSW210
     D C#OPTN          S              7                                                       CSW210
     D C#CNUM          S             10                                                       CSW210
     D C#KYST          S              7                                                       CSW210
                                                                                              CSW210
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

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

     C                   EXSR      SRMAIN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN - Program Main Processing                              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRINIT     - Initial Processing                        *
      *        SRDISPLAY1 - Display Screen 1 Details                  *
      *        SRDISPLAY2 - Display Screen 2 Details                  *
      *        SRDISPLAY3 - Display Screen 3 Details                  *
      *        SRUPDATE   - Update Add'l Standard Settlement Ins.     *
      *        SRRETURN   - Return to Calling Program                 *
      *                                                               *
      *****************************************************************

     C     SRMAIN        BEGSR

     C                   IF        WINIT = ' '
     C                   EXSR      SRINIT
     C                   ENDIF
                                                                                              205663
     C                   DOW       PMode = '0'                                                205663
     C                   EXSR      SRDISPLAY0                                                 205663
     C                   ENDDO                                                                205663

     C                   DOW       PMode = '1'
     C                   EXSR      SRDISPLAY1
     C                   ENDDO

     C                   DOW       PMode = '2'
     C                   EXSR      SRDISPLAY2
     C                   ENDDO

     C                   DOW       PMode = '3'
     C                   EXSR      SRDISPLAY3
     C                   ENDDO

     C                   IF        PMode = 'U'
     C                   EXSR      SRUPDATE
     C                   ENDIF

     C                   IF        PMode = 'R'
     C                   EXSR      SRRETURN
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initial Processing                                   *
      *                                                               *
      * Called by: SRMAIN - Program Main Processing                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRINIT        BEGSR

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
     C                   EVAL      WINIT = 'Y'
     C                   EVAL      @TA = *BLANKS                                              201486
     C                   EVAL      WAGNA = *BLANKS                                            201486
     C                   EVAL      WANGA = *BLANKS                                            201486
     C                   EVAL      WAANG = *BLANKS                                            201486
     C                   EVAL      TDRSN = *BLANKS                                            201486
     C                   EVAL      T0AWIN = *BLANKS                                           201486
     C                   EVAL      T0AFPN = *BLANKS                                           201486
     C                   EVAL      T0BOFN = *BLANKS                                           201486
     C                   EVAL      T3BSSN = *BLANKS                                           201486
     C                   EVAL      PSKALReF = *BLANKS                                         201486
     C                   EVAL      PDepotCNum = *BLANKS                                       201486
     C                   EVAL      PCntrPCNum = *BLANKS                                       201486

      ** Determine if Depot In or Depot Out

     C                   IF        PAdDType = 'I'
     C                   EVAL      *IN10 = *ON
     C                   ELSE
     C                   EVAL      *IN10 = *OFF
     C                   ENDIF

      ** Display Custodian and Safe A/C                                                       209247
     C                   EVAL      *IN80 = *OFF                                               209247
     C                   IF        PCSE029 = 'Y'                                              209247
     C                   EVAL      *IN80 = *ON                                                209247
     C                   ENDIF                                                                209247
     C*                                                                                       209247
     C                   IF        PCSW202 = 'Y'                                            AR325342
     C                   EVAL      *IN08 = '1'                                              AR325342
     C                   ELSE                                                               AR325342
     C                   EVAL      *IN08 = '0'                                              AR325342
     C                   ENDIF                                                              AR325342
                                                                                            AR325342
      ** Condition display of Customer or Book field

     C                   IF        PCBInd = 'C'
     C                   EVAL      *IN68 = *ON
     C                   ELSE
     C                   EVAL      *IN68 = *OFF
                                                                                              201486
     C**********         CALLB     'AOBRCHR0'                                          201486 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD             7                          201486
     C                   PARM      '*KEY   '     POPTN             7                          201486
     C                   PARM      PBranch       PBA               3                          201486
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 201486 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
                                                                                              201486
     C                   ENDIF

      ** Condition display of fields when ISO15022 is 'Y'

     C                   IF        PISOMsg = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ELSE
     C                   EVAL      *IN71 = *OFF
     C                   ENDIF

      ** Condition protect of fields

     C                   IF        ActionCode = 'E'
     C                   EVAL      *IN70 = *ON
     C                   ELSE
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF

      ** Move file fields to screen output fields

     C                   EVAL      #6BRCA = PBranch
     C                   EVAL      #6CUST = PCustomer
     C                   EVAL      #6BOOK = PBook
     C                   EVAL      #6DESC = PDescrptn
     C                   EVAL      #6CCY = PCcy
     C                   EVAL      #6MKCT = PMktCtr                                           CSE034
     C                   EVAL      #6INVT = PInvType
     C                   EVAL      #6PTFR = PPorRef
     C                   EVAL      WPInterMed = *BLANKS
     C                   EVAL      WPPSET = *BLANKS
     C                   EVAL      WPQFIN = *BLANKS                                         AR634357
     C                   EVAL      WWPCL1 = *BLANKS                                         AR634357
     C                   EVAL      WWDBTR = *BLANKS                                         AR634357
     C                   EVAL      WWAFPN = *BLANKS                                         AR635847
     C                   EVAL      WWAWIN = *BLANKS                                         AR635847
     C                   EVAL      WWBOFN = *BLANKS                                         AR635847

      ** Initialise values of screen details from input parm

     C                   EXSR      SRResetScrn1
     C                   EXSR      SRResetScrn2
     C                   EXSR      SRResetScrn3

     C                   IF        PCBInd = 'B'                                               205663
     C                   EVAL      PMode = '1'
     C                   ELSE                                                                 205663
     C                   EVAL      PMode = '0'                                                205663
     C                   ENDIF                                                                205663

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************                       205663
      *                                                               *                       205663
      * SRDISPLAY0 - Display Initial Screen Details                   *                       205663
      *                                                               *                       205663
      * Called by: SRMAIN - Program Main Processing                   *                       205663
      *                                                               *                       205663
      * Calls: SRVALIDATE1 - Validate Screen 1 Details                *                       205663
      *                                                               *                       205663
      *****************************************************************                       205663
                                                                                              205663
     C     SRDISPLAY0    BEGSR                                                                205663
                                                                                              205663
      ** Move 'OK' flags into array (for checking)                                            205663
                                                                                              205663
     C                   MOVEA     OKSCRN1       @EI                                          205663
                                                                                              205663
      ** Set screen error indicators according to status of 'OK' flags                        205663
                                                                                              205663
     C                   Z-ADD     1             C                 2 0                        205663
     C                   Z-ADD     11            E                 2 0                        205663
                                                                                              205663
     C     C             DOUGT     13                                                         205663
     C     @EI(C)        IFEQ      'N'                                                        205663
     C     @EI(C)        OREQ      'W'                                                        205663
     C                   MOVEL     '1'           *IN(E)                                       205663
     C                   ENDIF                                                                205663
     C                   ADD       1             C                                            205663
     C                   ADD       1             E                                            205663
     C                   ENDDO                                                                205663
                                                                                              205663
      ** OKFlags for SWIFT 2010 Changes                                                       CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
     C                   IF        DbtrOk = 'N' OR                                            CSW210
     C                             DbtrOk = 'W'                                               CSW210
     C                   EVAL      *IN84 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DActOk = 'N' OR                                            CSW210
     C                             DActOk = 'W'                                               CSW210
     C                   EVAL      *IN85 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd1Ok = 'N' OR                                            CSW210
     C                             DAd1Ok = 'W'                                               CSW210
     C**********         EVAL      *IN88 = '1'                                       CSW210 AR579549
     C                   EVAL      *IN67 = '1'                                              AR579549
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd2Ok = 'N' OR                                            CSW210
     C                             DAd2Ok = 'W'                                               CSW210
     C                   EVAL      *IN89 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd3Ok = 'N' OR                                            CSW210
     C                             DAd3Ok = 'W'                                               CSW210
     C                   EVAL      *IN06 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd4Ok = 'N' OR                                            CSW210
     C                             DAd4Ok = 'W'                                               CSW210
     C                   EVAL      *IN07 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** The following /COPY line includes processing for the error and                       205663
      ** warning messages.                                                                    205663
                                                                                              205663
     C/COPY ZACPYSRC,MSGHNDDSP1                                                               205663
                                                                                              205663
     C                   EVAL      *IN76 = *ON                                                205663
     C                   EVAL      *IN77 = *OFF                                               205663
     C                   EVAL      *IN78 = *OFF                                               205663
     C                   EVAL      *IN69 = *ON                                                205663
                                                                                              205663
     C                   WRITE     SEDSSIPS0                                                  205663
     C                   WRITE     SEDSSIPF5                                                  205663
     C                   WRITE     SEDSSIPF6                                                  205663
     C                   EXFMT     SEDSSIPF0                                                  205663
                                                                                              205663
      ** Clear messages from screen message subfile                                           205663
                                                                                              205663
     C                   CALL      'ZA0250'                                                   205663
                                                                                              205663
      ** Set screen error indicators off                                                      205663
                                                                                              205663
     C                   MOVEA     @Z0           *IN(11)                                      205663
                                                                                              205663
     C                   EVAL      OkScrn1 = *BLANKS                                          205663
     C                   EVAL      OkScrn2 = *BLANKS                                          205663
     C                   EVAL      Idx = 0                                                    205663
     C                   EVAL      WIdx = 0                                                   CSW210
     C                   CLEAR                   MsgIdArr                                     205663
     C                   CLEAR                   FldNameArr                                   205663
     C                   CLEAR                   WMsgIdArr                                    205663
     C                   CLEAR                   WFldNamArr                                   CSW210
                                                                                              205663
      ** Reset OKFlags for SWIFT 2010 Changes                                                 CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
     C                   MOVEA     '00'          *IN(84)                                      CSW210
     C**********         MOVEA     '00'          *IN(88)                             CSW210 AR579549
     C                   SETOFF                                       6789                  AR579549
     C                   MOVEA     '00'          *IN(06)                                      CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   SELECT                                                               205663
                                                                                              205663
      ** F3 Pressed                                                                           205663
                                                                                              205663
     C                   WHEN      *INKC = *ON                                                205663
     C                   EVAL      RetCodeOut = 'SE10000'                                     205663
     C                   EVAL      PMode = 'R'                                                205663
                                                                                              205663
      ** F5 Pressed                                                                           205663
                                                                                              205663
     C                   WHEN      *INKE = *ON                                                205663
     C                   EXSR      SRRESETSCRN1                                               205663
     C                   EVAL      PMode = '0'                                                205663
                                                                                              205663
      ** F12 Pressed                                                                          205663
                                                                                              205663
     C                   WHEN      *INKL = *ON                                                205663
     C                   EVAL      RetCodeOut = 'SE10001'                                     205663
     C                   EVAL      PMode = 'R'                                                205663
                                                                                              205663
     C                   OTHER                                                                205663
                                                                                              205663
     C                   IF        ActionCode <> 'E'                                          205663
     C                   EXSR      SRVALIDATE1                                                205663
     C                   ELSE                                                                 205663
     C                   EVAL      PMode = '1'                                                205663
     C                   ENDIF                                                                205663
                                                                                              205663
     C                   ENDSL                                                                205663
                                                                                              205663
     C                   ENDSR                                                                205663
                                                                                              205663
      *****************************************************************                       205663
      /EJECT                                                                                  205663
      *****************************************************************
      *                                                               *
      * SRDISPLAY1 - Display Screen 1 Details                         *
      *                                                               *
      * Called by: SRMAIN - Program Main Processing                   *
      *                                                               *
      * Calls: SRVALIDATE1 - Validate Screen 1 Details                *
      *                                                               *
      *****************************************************************

     C     SRDISPLAY1    BEGSR

     C**********         IF        PBFCLAS = 'I' or  PCBInd = 'B'                             205663
     C                   IF        PCBInd = 'B'                                               205663

      ** Move 'OK' flags into array (for checking)

     C                   MOVEA     OKSCRN1       @EI

      ** Set screen error indicators according to status of 'OK' flags

     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     11            E                 2 0

     C     C             DOUGT     13
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO

      ** OKFlags for SWIFT 2010 Changes                                                       CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
     C                   IF        DbtrOk = 'N' OR                                            CSW210
     C                             DbtrOk = 'W'                                               CSW210
     C                   EVAL      *IN84 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DActOk = 'N' OR                                            CSW210
     C                             DActOk = 'W'                                               CSW210
     C                   EVAL      *IN85 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd1Ok = 'N' OR                                            CSW210
     C                             DAd1Ok = 'W'                                               CSW210
     C**********         EVAL      *IN88 = '1'                                       CSW210 AR579549
     C                   EVAL      *IN67 = '1'                                              AR579549
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd2Ok = 'N' OR                                            CSW210
     C                             DAd2Ok = 'W'                                               CSW210
     C                   EVAL      *IN89 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd3Ok = 'N' OR                                            CSW210
     C                             DAd3Ok = 'W'                                               CSW210
     C                   EVAL      *IN06 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        DAd4Ok = 'N' OR                                            CSW210
     C                             DAd4Ok = 'W'                                               CSW210
     C                   EVAL      *IN07 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ELSE

      ** Move 'OK' flags into array (for checking)

     C                   MOVEA     OKSCRN2       @EI

      ** Set screen error indicators according to status of 'OK' flags

     C                   Z-ADD     1             C
     C                   Z-ADD     23            E

     C     C             DOUGT     11
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO

     C                   ENDIF

      ** The following /COPY line includes processing for the error and
      ** warning messages.

     C/COPY ZACPYSRC,MSGHNDDSP1

     C                   EVAL      *IN76 = *ON
     C                   EVAL      *IN77 = *OFF
     C                   EVAL      *IN78 = *OFF
     C                   EVAL      *IN75 = *OFF                                               205663

     C**********         IF        PBFCLAS = 'I' or  PCBInd = 'B'                             205663
     C                   IF        PCBInd = 'B'                                               205663
     C                   EVAL      *IN79 = *OFF                                               205663
     C                   EVAL      *IN69 = *ON
     C                   WRITE     SEDSSIPS0
     C                   WRITE     SEDSSIPF5
     C                   WRITE     SEDSSIPF6
     C                   EXFMT     SEDSSIPF0
     C                   ELSE
     C                   EVAL      *IN79 = *ON                                                205663
     C                   EVAL      *IN69 = *OFF
     C                   WRITE     SEDSSIPS0
     C                   WRITE     SEDSSIPF5
     C                   WRITE     SEDSSIPF6
     C                   EXFMT     SEDSSIPF1
     C                   ENDIF

      ** Clear messages from screen message subfile

     C                   CALL      'ZA0250'

      ** Set screen error indicators off

     C                   MOVEA     @Z0           *IN(11)

     C                   EVAL      OkScrn1 = *BLANKS
     C                   EVAL      OkScrn2 = *BLANKS
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0                                                   CSW210
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WFldNamArr                                   CSW210
                                                                                              CSW210
      ** Reset OKFlags for SWIFT 2010 Changes                                                 CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
     C                   MOVEA     '00'          *IN(84)                                      CSW210
     C**********         MOVEA     '00'          *IN(88)                             CSW210 AR579549
     C                   SETOFF                                       6789                  AR579549
     C                   MOVEA     '00'          *IN(06)                                      CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210

     C                   SELECT

      ** F3 Pressed

     C                   WHEN      *INKC = *ON
     C                   EVAL      RetCodeOut = 'SE10000'
     C                   EVAL      PMode = 'R'

      ** F5 Pressed

     C                   WHEN      *INKE = *ON
     C                   EXSR      SRRESETSCRN1
     C                   EVAL      PMode = '1'

      ** F12 Pressed

     C                   WHEN      *INKL = *ON
     C                   EVAL      RetCodeOut = 'SE10001'
     C                   EVAL      PMode = 'R'

      ** RollDown Pressed                                                                     205663
                                                                                              205663
     C                   WHEN      *IN75 = *ON                                                205663
     C                   EVAL      PMode = '0'                                                205663
                                                                                              205663
     C                   OTHER

     C                   IF        ActionCode <> 'E'
     C                   EXSR      SRVALIDATE1
     C                   ELSE
     C                   EVAL      PMode = '2'
     C                   ENDIF

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALIDATE1 - Validate Screen 1 Details                       *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRVALIDATE1   BEGSR

      ** Perform field validations

     C**********         IF        PBFCLAS = 'I' or  PCBInd = 'B'                             205663
     C                   EXSR      SRAFPN                                                     CSW210
                                                                                              CSW210
     C                   EVAL      WANGA = 'Y'                                                CSW210
                                                                                              CSW210
     C                   IF        #0AFPN = T0AFPN and #0AFPL = *BLANKS                       CSW210
     C                   EVAL      WANGA = *BLANKS                                            CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        OkAFPN <> 'N' and #0AFPN <> *BLANKS and                    CSW210
     C                             #0AFPL = *BLANKS and WANGA <> *BLANKS                      CSW210
                                                                                              CSW210
     C                   EVAL      T0AFPN = #0AFPN                                            CSW210
     C                   EVAL      PDepotCNum = #0AFPN                                        CSW210
                                                                                              CSW210
     C                   IF        PCBInd = 'C'                                               CSW210
     C                   EVAL      PCntrPCNum = PCustomer                                     CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      PCntrPCNum = A8BICN                                        CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EXSR      SRDORF                                                     CSW210
                                                                                              CSW210
     C                   IF        PSKALREF <> *BLANKS                                        CSW210
                                                                                              CSW210
     C                   EVAL      #0AFPL = PSKALRef                                          CSW210
     C                   EVAL      WAGNA = 'N'                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EXSR      SRAFPL                                                     CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
     C                   EXSR      SRDBTR                                                     CSW210
     C                   EXSR      SRDBAD                                                     CSW210
     C                   EXSR      SRDBLN                                                     CSW210
     C                   ENDIF                                                                CSW210

     C                   EXSR      SRAWIN
                                                                                              201486
     C                   EVAL      WAGNA = 'Y'                                                201486
                                                                                              201486
     C                   IF        #0AWIN = T0AWIN and #0AWIL = *BLANKS                       201486
     C                   EVAL      WAGNA = *BLANKS                                            201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   IF        OkAWIN <> 'N' and #0AWIN <> *BLANKS and                    201486
     C                             #0AWIL = *BLANKS and WAGNA <> *BLANKS                      201486
                                                                                              201486
     C                   EVAL      T0AWIN = #0AWIN                                            201486
     C                   EVAL      PDepotCNum = #0AWIN                                        201486
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
     C                   EVAL      #0AWIL = PSKALRef                                          201486
     C                   EVAL      WAGNA = 'N'                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   EXSR      SRAWIL
     C**********         EXSR      SRAFPN                                                     CSW210
      **********                                                                       201486 CSW210
     C**********         EVAL      WANGA = 'Y'                                         201486 CSW210
      **********                                                                       201486 CSW210
     C**********         IF        #0AFPN = T0AFPN and #0AFPL = *BLANKS                201486 CSW210
     C**********         EVAL      WANGA = *BLANKS                                     201486 CSW210
     C**********         ENDIF                                                         201486 CSW210
      **********                                                                       201486 CSW210
     C**********         IF        OkAFPN <> 'N' and #0AFPN <> *BLANKS and             201486 CSW210
     C**********                   #0AFPL = *BLANKS and WANGA <> *BLANKS               201486 CSW210
      **********                                                                       201486 CSW210
     C**********         EVAL      T0AFPN = #0AFPN                                     201486 CSW210
     C**********         EVAL      PDepotCNum = #0AFPN                                 201486 CSW210
      **********                                                                       201486 CSW210
     C**********         IF        PCBInd = 'C'                                        201486 CSW210
     C**********         EVAL      PCntrPCNum = PCustomer                              201486 CSW210
     C**********         ELSE                                                          201486 CSW210
     C**********         EVAL      PCntrPCNum = A8BICN                                 201486 CSW210
     C**********         ENDIF                                                         201486 CSW210
      **********                                                                       201486 CSW210
     C**********         EXSR      SRDORF                                              201486 CSW210
      **********                                                                       201486 CSW210
     C**********         IF        PSKALREF <> *BLANKS                                 201486 CSW210
      **********                                                                       201486 CSW210
     C**********         EVAL      #0AFPL = PSKALRef                                   201486 CSW210
     C**********         EVAL      WAGNA = 'N'                                         201486 CSW210
      **********                                                                       201486 CSW210
     C**********         ENDIF                                                         201486 CSW210
      **********                                                                       201486 CSW210
     C**********         ENDIF                                                         201486 CSW210
      **********                                                                       201486 CSW210
     C**********         EXSR      SRAFPL                                                     CSW210
     C                   EXSR      SRBOFN
                                                                                              201486
     C                   EVAL      WAANG = 'Y'                                                201486
                                                                                              201486
     C                   IF        #0BOFN = T0BOFN and #0BOF1 = *BLANKS                       201486
     C                   EVAL      WAANG = *BLANKS                                            201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   IF        OkBOFN <> 'N' and #0BOFN <> *BLANKS and                    201486
     C                             #0BOF1 = *BLANKS and WAANG <> *BLANKS                      201486
                                                                                              201486
     C                   EVAL      T0BOFN = #0BOFN                                            201486
     C                   EVAL      PDepotCNum = #0BOFN                                        201486
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
     C                   EVAL      #0BOF1 = PSKALRef                                          201486
     C                   EVAL      WAGNA = 'N'                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   EXSR      SRBOF1
     C**********         EXSR      SRBOF2                                                     CSW210
     C                   EXSR      SRSRL1
     C                   EXSR      SRSRL2
     C                   EXSR      SRSRL3

     C                   EVAL      WNAS1 = #0NAC1
     C                   EVAL      WNAS2 = #0NAC2

     C                   EXSR      SRNAS1
     C                   EXSR      SRNAS2

     C**********         ELSE                                                                 205663

     C                   EXSR      SRGMES
     C                   EXSR      SRINST
     C                   EXSR      SRINSS
                                                                                              199797
     C                   IF        PISOMsg <> 'Y'                                             199797
     C                   EXSR      SRRPTY
     C                   EXSR      SRGDEL
     C                   EXSR      SRSROL
     C                   ENDIF                                                                199797
                                                                                              199797
     C                   EXSR      SRFIND

     C**********         ENDIF                                                                205663

     C                   IF        OkScrn1 = *BLANKS AND
     C                             OkScrn2 = *BLANKS
     C                   IF        WAGNA <> 'N'                                               201486
     C                   IF        PMode = '1'                                                205663
     C                   EVAL      PMode = '2'
     C                   ENDIF                                                                205663
     C                   IF        PMode = '0'                                                205663
     C                   EVAL      PMode = '1'                                                205663
     C                   ENDIF                                                                205663
     C                   ENDIF                                                                201486
     C**********         ELSE                                                                 205663
     C**********         EVAL      PMode = '1'                                                205663
     C                   IF        @DEBTR1 <> WWDBTR                                        AR634357
     C                             OR #0AFPN <> WWAFPN                                      AR635847
     C                             OR #0AWIN <> WWAWIN                                      AR635847
     C                             OR #0BOFN <> WWBOFN                                      AR635847
     C                   EVAL      PMode = '0'                                              AR634357
     C                   ENDIF                                                              AR634357
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDISPLAY2 - Display Screen 2 Details                         *
      *                                                               *
      * Called by: SRMAIN - Program Main Processing                   *
      *                                                               *
      * Calls: SRVALIDATE2 - Validate Screen 2 Details                *
      *                                                               *
      *****************************************************************

     C     SRDISPLAY2    BEGSR

      ** Move 'OK' flags into array (for checking)

     C                   MOVEA     OKSCRN3       @EI

      ** Set screen error indicators according to status of 'OK' flags

     C                   Z-ADD     1             C
     C                   Z-ADD     33            E

     C     C             DOUGT     16
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO

      ** The following /COPY line includes processing for the error and
      ** warning messages.

     C/COPY ZACPYSRC,MSGHNDDSP1

     C                   EVAL      *IN74 = *OFF
     C                   EVAL      *IN75 = *OFF
     C                   EVAL      *IN76 = *OFF
     C                   EVAL      *IN77 = *ON
     C                   EVAL      *IN78 = *OFF

     C                   WRITE     SEDSSIPS0
     C                   WRITE     SEDSSIPF5

     C                   IF        PAdDType = 'I'
     C                   EXFMT     SEDSSIPF2
     C                   ELSE
     C                   EXFMT     SEDSSIPF3
     C                   ENDIF

      ** Clear messages from screen message subfile

     C                   CALL      'ZA0250'

      ** Set screen error indicators off

     C                   MOVEA     @Z0           *IN(11)

     C                   EVAL      OkScrn3 = *BLANKS
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0                                                   CSW210
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WFldNamArr                                   CSW210

     C                   SELECT

      ** F3 Pressed

     C                   WHEN      *INKC = *ON
     C                   EVAL      RetCodeOut = 'SE10000'
     C                   EVAL      PMode = 'R'

      ** F5 Pressed

     C                   WHEN      *INKE = *ON
     C                   EXSR      SRRESETSCRN2
     C                   EVAL      PMode = '2'

      ** F12 Pressed

     C                   WHEN      *INKL = *ON
     C                   EVAL      RetCodeOut = 'SE10001'
     C                   EVAL      PMode = 'R'

      ** RollDown Pressed

     C                   WHEN      *IN75 = *ON
     C                   EVAL      PMode = '1'

     C                   OTHER

     C                   IF        ActionCode <> 'E'

     C                   EXSR      SRVALIDATE2

     C                   ELSE

     C                   IF        PISOMsg = 'Y'
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
      * SRVALIDATE2 - Validate Screen 2 Details                       *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRVALIDATE2   BEGSR

      ** Perform field validation

     C                   IF        *IN10 = *ON
     C                   EVAL      WCCTN = #2CCTN
     C                   EVAL      WDRSN = #2DRSN
     C                   EVAL      WDRS1 = #2DRS1
     C                   EVAL      WDRS2 = #2DRS2
     C                   EVAL      WDRS3 = #2DRS3
     C                   EVAL      WDRS4 = #2DRS4
     C                   EVAL      WFIN1 = #2FIN1
     C                   EVAL      WFIN2 = #2FIN2
     C**********         EVAL      WRED1 = #2RED1                                             CSW210
     C**********         EVAL      WRED2 = #2RED2                                             CSW210
     C                   EVAL      WNAS1 = #2NAS1
     C                   EVAL      WNAS2 = #2NAS2
     C                   EVAL      WFIELD = '#2CCTN'
     C                   EVAL      WFIELD = '#2DRSN'
     C                   EVAL      WFIELD = '#2DRS1'
     C                   EVAL      WFIELD = '#2DRS2'
     C                   EVAL      WFIELD = '#2DRS3'
     C                   EVAL      WFIELD = '#2DRS4'
     C                   EVAL      WFIELD = '#2FIN1'
     C                   EVAL      WFIELD = '#2FIN2'
     C**********         EVAL      WFIELD = '#2RED1'                                          CSW210
     C**********         EVAL      WFIELD = '#2RED2'                                          CSW210
     C                   EVAL      WFIELD = '#2NAS1'
     C                   EVAL      WFIELD = '#2NAS2'
     C                   ELSE
     C                   EVAL      WCCTN = #3CCTN
     C                   EVAL      WDRSN = #3DRSN
     C                   EVAL      WDRS1 = #3DRS1
     C                   EVAL      WDRS2 = #3DRS2
     C                   EVAL      WDRS3 = #3DRS3
     C                   EVAL      WDRS4 = #3DRS4
     C                   EVAL      WFIN1 = #3FIN1
     C                   EVAL      WFIN2 = #3FIN2
     C**********         EVAL      WRED1 = #3RED1                                             CSW210
     C**********         EVAL      WRED2 = #3RED2                                             CSW210
     C                   EVAL      WNAS1 = #3NAS1
     C                   EVAL      WNAS2 = #3NAS2
     C                   EVAL      WFIELD = '#3CCTN'
     C                   EVAL      WFIELD = '#3DRSN'
     C                   EVAL      WFIELD = '#3DRS1'
     C                   EVAL      WFIELD = '#3DRS2'
     C                   EVAL      WFIELD = '#3DRS3'
     C                   EVAL      WFIELD = '#3DRS4'
     C                   EVAL      WFIELD = '#3FIN1'
     C                   EVAL      WFIELD = '#3FIN2'
     C**********         EVAL      WFIELD = '#3RED1'                                          CSW210
     C**********         EVAL      WFIELD = '#3RED2'                                          CSW210
     C                   EVAL      WFIELD = '#3NAS1'
     C                   EVAL      WFIELD = '#3NAS2'
     C                   ENDIF

     C                   EXSR      SRCCTN
     C                   EXSR      SRDRSN
                                                                                              201486
     C                   EVAL      WAGNA = 'Y'                                                201486
                                                                                              201486
     C                   IF        WDRSN = TDRSN and WDRS1 = *BLANKS                          201486
     C                   EVAL      WAGNA = *BLANKS                                            201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   IF        OkDRSN <> 'N' and WDRSN <> *BLANKS and                     201486
     C                             WDRS1  = *BLANKS and WAGNA <> *BLANKS                      201486
                                                                                              201486
     C                   EVAL      TDRSN = WDRSN                                              201486
     C                   EVAL      PDepotCNum = WDRSN                                         201486
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
     C                   EVAL      WDRS1 = PSKALRef                                           201486
     C                   EVAL      WAGNA = 'N'                                                201486
                                                                                              201486
     C                   IF        *IN10 = *ON                                                201486
     C                   EVAL      #2DRS1 = WDRS1                                             201486
     C                   ELSE                                                                 201486
     C                   EVAL      #3DRS1 = WDRS1                                             201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              199797
     C                   IF        PISOMsg <> 'Y'                                             199797
     C                   EXSR      SRDRS1
     C                   EXSR      SRDRS2
     C                   EXSR      SRDRS3
     C                   EXSR      SRDRS4
     C                   ENDIF                                                                199797
                                                                                              199797
     C                   EXSR      SRFIN1
     C                   EXSR      SRFIN2
     C**********         EXSR      SRRED1                                                     CSW210
     C**********         EXSR      SRRED2                                                     CSW210
     C                   EXSR      SRNAS1
     C                   EXSR      SRNAS2

     C                   IF        *IN10 = *OFF
     C                   EXSR      SRBSSN
                                                                                              201486
     C                   EVAL      WANGA = 'Y'                                                201486
                                                                                              201486
     C                   IF        #3BSSN = T3BSSN and #3BSS1 = *BLANKS                       201486
     C                   EVAL      WANGA = *BLANKS                                            201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   IF        OkBSSN <> 'N' and #3BSSN <> *BLANKS and                    201486
     C                             #3BSS1  = *BLANKS and WANGA <> *BLANKS                     201486
                                                                                              201486
     C                   EVAL      T3BSSN = #3BSSN                                            201486
     C                   EVAL      PDepotCNum = #3BSSN                                        201486
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
     C                   EVAL      #3BSS1 = PSKALRef                                          201486
     C                   EVAL      WAGNA = 'N'                                                201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   ENDIF                                                                201486
                                                                                              199797
     C                   IF        PISOMsg <> 'Y'                                             199797
     C                   EXSR      SRBSS1
     C                   EXSR      SRBSS2
     C                   ENDIF                                                                199797
                                                                                              199797
     C                   ENDIF

     C                   IF        OkScrn3 = *BLANKS

     C                   IF        PISOMsg = 'Y'
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

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDISPLAY3 - Display Screen 3 Details                         *
      *                                                               *
      * Called by: SRMAIN - Program Main Processing                   *
      *                                                               *
      * Calls: SRVALIDATE3 - Validate Screen 3 Details                *
      *                                                               *
      *****************************************************************

     C     SRDISPLAY3    BEGSR

      ** Move 'OK' flags into array (for checking)

     C                   MOVEA     OKSCRN4       @EI

      ** Set screen error indicators according to status of 'OK' flags

     C                   Z-ADD     1             C
     C                   Z-ADD     48            E

     C     C             DOUGT     20
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
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
     C                   EVAL      *IN81 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        QFInOk = 'N' OR                                            CSW210
     C                             QFInOk = 'W'                                               CSW210
     C                   EVAL      *IN82 = '1'                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
      ** The following /COPY line includes processing for the error and
      ** warning messages.

     C/COPY ZACPYSRC,MSGHNDDSP1

     C                   IF        CSW206 = 'Y'                                              CSW206E
     C                   EVAL      *IN88 = '1'                                               CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      *IN88 = '0'                                               CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   EVAL      *IN74 = *OFF
     C                   EVAL      *IN75 = *OFF
     C                   EVAL      *IN76 = *OFF
     C                   EVAL      *IN77 = *OFF
     C                   EVAL      *IN78 = *ON

     C                   WRITE     SEDSSIPS0
     C                   WRITE     SEDSSIPF5
     C                   EXFMT     SEDSSIPF4

      ** Clear messages from screen messages subfile

     C                   CALL      'ZA0250'

      ** Set screen error indicators off

     C                   MOVEA     @Z0           *IN(11)

     C                   EVAL      OkScrn4 = *BLANKS
     C                   EVAL      WERROR = 'N'
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0                                                   CSW210
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WFldNamArr                                   CSW210

      ** Reset OKFlags for SWIFT 2010 Changes                                                 CSW210
                                                                                              CSW210
     C                   MOVEA     '00'          *IN(41)                                      CSW210
     C                   MOVEA     '00'          *IN(81)                                      CSW210
                                                                                              CSW210
     C                   SELECT

      ** F3 Pressed

     C                   WHEN      *INKC = *ON
     C                   EVAL      RetCodeOut = 'SE10000'
     C                   EVAL      PMode = 'R'

      ** F5 Pressed

     C                   WHEN      *INKE = *ON
     C                   EXSR      SRRESETSCRN3
     C                   EVAL      PMode = '3'

      ** F12 Pressed

     C                   WHEN      *INKL = *ON
     C                   EVAL      RetCodeOut = 'SE10001'
     C                   EVAL      PMode = 'R'

     C                   WHEN      *IN75 = *ON
     C                   EVAL      PMode = '2'

     C                   OTHER

     C                   IF        ActionCode <> 'E'
     C                   EXSR      SRVALIDATE3
     C                   ELSE
     C                   EVAL      PMode = 'R'
     C                   ENDIF

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALIDATE3 - Validate Screen 3 Details                       *
      *                                                               *
      * Called by: SRDISPLAY3 - Display Screen 3 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRVALIDATE3   BEGSR

     C                   EXSR      SRINTM
     C                   EXSR      SRSAFE
     C                   EXSR      SRPSET
     C                   EXSR      SRRED1                                                     CSW210
     C                   EXSR      SRRED2                                                     CSW210
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
     C                   EXSR      SRPCLR                                                     CSW210
     C                   EXSR      SRQFIN                                                     CSW210
     C                   ENDIF                                                                CSW210

     C                   IF        OkScrn4 = *BLANKS AND
     C                             WInterMed = WPInterMed AND
     C                             #4PSET = WPPSET
     C                             AND #4QFI1 = WPQFIN                                      AR634357
     C                             AND #4PCL1 = WWPCL1                                      AR634357
     C                   IF        WAGNA <> 'N'                                               201486
     C                   EVAL      PMode = 'U'
     C                   ENDIF                                                                201486
     C                   ELSE
     C                   EVAL      PMode = '3'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESETSCRN1 - Move PDepot to Screen 1                        *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRRESETSCRN1  BEGSR

     C                   EVAL      #0AWIN  = SAAWIN
     C                   EVAL      #0AWIL  = SAAWIL
     C                   EVAL      #0AFPN  = SAAFPN
     C                   EVAL      #0AFPL  = SAAFPL
     C                   EVAL      #0BOFN  = SABOFN
     C                   EVAL      #0BOF1  = SABOF1
     C                   EVAL      #0BOF2  = SABOF2
     C                   EVAL      #0SRL1  = SASRL1
     C                   EVAL      #0SRL2  = SASRL2
     C                   EVAL      #0SRL3  = SASRL3
     C                   EVAL      #0NAC1  = SANAC1
     C                   EVAL      #0NAC2  = SANAC2

     C                   IF        PCSW210 = 'Y'                                              CSW210
                                                                                              CSW210
     C                   EVAL      @DEBTR1 = SADIDN                                           CSW210
     C                   EVAL      @DACNT1 = SADLIN                                           CSW210
     C                   EVAL      @DADDR1 = SADAD1                                           CSW210
     C                   EVAL      @DADDR2 = SADAD2                                           CSW210
     C                   EVAL      @DADDR3 = SADAD3                                           CSW210
     C                   EVAL      @DADDR4 = SADAD4                                           CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EVAL      #1GMES  = SAGMES
     C                   EVAL      #1INST  = SAINST
     C                   EVAL      #1INSS  = SAINSS
     C                   EVAL      #1RPTY  = SARPTY
     C                   EVAL      #1GDEL  = SAGDEL
     C                   EVAL      #1SROL  = SASROL
     C                   EVAL      #1FIND  = SAFIND
     C                   EVAL      #1STMP  = SASTMP
     C                   EVAL      #1CHID  = SACHID
     C                   EVAL      #1TRRM  = SATRRM

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESETSCRN2 - Move PDepot to Screen 2                        *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRRESETSCRN2  BEGSR

     C                   IF        PAdDType = 'I'
     C                   EVAL      #2CCTN  = SACCTN
     C                   EVAL      #2DRSN  = SADRSN
     C                   EVAL      #2DRS1  = SADRS1
     C                   EVAL      #2DRS2  = SADRS2
     C                   EVAL      #2DRS3  = SADRS3
     C                   EVAL      #2DRS4  = SADRS4
     C                   EVAL      #2FIN1  = SAFIN1
     C                   EVAL      #2FIN2  = SAFIN2
     C**********         EVAL      #2RED1  = SARED1                                           CSW210
     C**********         EVAL      #2RED2  = SARED2                                           CSW210
     C                   EVAL      #2NAS1  = SANAS1
     C                   EVAL      #2NAS2  = SANAS2
     C                   ELSE
     C                   EVAL      #3CCTN  = SACCTN
     C                   EVAL      #3DRSN  = SADRSN
     C                   EVAL      #3DRS1  = SADRS1
     C                   EVAL      #3DRS2  = SADRS2
     C                   EVAL      #3DRS3  = SADRS3
     C                   EVAL      #3DRS4  = SADRS4
     C                   EVAL      #3BSSN  = SABSSN
     C                   EVAL      #3BSS1  = SABSS1
     C                   EVAL      #3BSS2  = SABSS2
     C                   EVAL      #3FIN1  = SAFIN1
     C                   EVAL      #3FIN2  = SAFIN2
     C**********         EVAL      #3RED1  = SARED1                                           CSW210
     C**********         EVAL      #3RED2  = SARED2                                           CSW210
     C                   EVAL      #3NAS1  = SANAS1
     C                   EVAL      #3NAS2  = SANAS2
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESETSCRN3 - Move PDepot to Screen 3                        *
      *                                                               *
      * Called by: SRDISPLAY3 - Display Screen 3 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRRESETSCRN3  BEGSR

     C                   EVAL      #4IMMD1 = SAIMD1
     C                   EVAL      #4IMMD2 = SAIMD2
     C**********         EVAL      #4IMMD3 = SAIMD3                                          CSW206D
     C**********         EVAL      #4IMMD4 = SAIMD4                                          CSW206D
     C**********         EVAL      #4IMMD5 = SAIMD5                                          CSW206D
     C**********         EVAL      #4IMMD6 = SAIMD6                                          CSW206D
     C**********         EVAL      #4IMMD7 = SAIMD7                                          CSW206D
     C**********         EVAL      #4IMMD8 = SAIMD8                                          CSW206D
     C**********         EVAL      #4IMMD9 = SAIMD9                                          CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      #4IMMD3 = SAIMD3                                          CSW206E
     C                   EVAL      #4IMMD4 = SAIMD4                                          CSW206E
     C                   EVAL      #4IMMD5 = SAIMD5                                          CSW206E
     C                   EVAL      #4IMMD6 = SAIMD6                                          CSW206E
     C                   EVAL      #4IMMD7 = SAIMD7                                          CSW206E
     C                   EVAL      #4IMMD8 = SAIMD8                                          CSW206E
     C                   EVAL      #4IMMD9 = SAIMD9                                          CSW206E
     C                   ENDIF                                                               CSW206E
     C                   EVAL      #4IMSA1 = SAIMS1
     C                   EVAL      #4IMSA2 = SAIMS2
     C**********         EVAL      #4IMSA3 = SAIMS3                                          CSW206D
     C**********         EVAL      #4IMSA4 = SAIMS4                                          CSW206D
     C**********         EVAL      #4IMSA5 = SAIMS5                                          CSW206D
     C**********         EVAL      #4IMSA6 = SAIMS6                                          CSW206D
     C**********         EVAL      #4IMSA7 = SAIMS7                                          CSW206D
     C**********         EVAL      #4IMSA8 = SAIMS8                                          CSW206D
     C**********         EVAL      #4IMSA9 = SAIMS9                                          CSW206D
     C**********         EVAL      #4PSET  = SAPSET                                          CSW206E
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      #4IMSA3 = SAIMS3                                          CSW206E
     C                   EVAL      #4IMSA4 = SAIMS4                                          CSW206E
     C                   EVAL      #4IMSA5 = SAIMS5                                          CSW206E
     C                   EVAL      #4IMSA6 = SAIMS6                                          CSW206E
     C                   EVAL      #4IMSA7 = SAIMS7                                          CSW206E
     C                   EVAL      #4IMSA8 = SAIMS8                                          CSW206E
     C                   EVAL      #4IMSA9 = SAIMS9                                          CSW206E
     C                   EVAL      #4PSET  = SAPSET                                          CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      #4PSET1 = SAPSET                                          CSW206E
     C                   ENDIF                                                               CSW206E
     C                                                                                        CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
     C                   EVAL      #4PSET1 = SAPSET                                           CSW210
     C                   EVAL      #4PCL1  = SAPCLR                                           CSW210
     C                   EVAL      #4QFI1  = SAQFIN                                           CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      #4PSET  = SAPSET                                           CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EVAL      #4RED1  = SARED1                                           CSW210
     C                   EVAL      #4RED2  = SARED2                                           CSW210

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUST - Validate Customer Number/Shortname/Nostro            *
      *                                                               *
      * Called by: SRVALIDATE1 - Validate Screen 1 Details            *
      *            SRVALIDATE2 - Validate Screen 2 Details            *
      *            SRVALIDATE3 - Validate Screen 3 Details            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRCUST        BEGSR

     C                   EVAL      WWCUSS = *BLANKS

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    PKEY1
     C                   PARM                    PKYST
     C     SDCUST        PARM      SDCUST        DSSDY

      ** If Return code is blank then set WWCUSS to 'C' if Customer
      ** Number; to 'S' if Customer Shortname.

     C                   IF        @RTCD = *BLANK and PKYST <> '*ERROR'

     C                   IF        PKYST = '*CNUM'
     C                   EVAL      WWCUSS = 'C'
     C                   ELSE
     C                   EVAL      WWCUSS = 'S'
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

     C                   EVAL      WWNOST = PKEY1

     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WWNOST        PKEY2
     C     SDCNST        PARM      SDCNST        DSFDY

      ** If Counterparty Nostro found set WWCUSS to 'N'.

     C                   IF        @RTCD = *BLANK
     C                   EVAL      WWCUSS = 'N'
     C                   EVAL      WWCSID = AWSWID
     C                   EVAL      WWBNBI = 'Y'
     C                   MOVE      AWFWCD        WWFWCD
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUST2 - Check Intermediary Field                            *
      *                                                               *
      * Called by: SRINTM - Validate Intermediary Fields              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRCUST2       BEGSR

     C                   EVAL      WCLAS = 'C'
     C                   EVAL      PKEY1 = WWIMMD
     C                   EVAL      WUnqeFlg = 'N'
     C                   EVAL      JFIMMD = *BLANKS                                           205141

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    PKEY1
     C                   PARM                    PKYST
     C     SDCUST        PARM      SDCUST        DSSDY

      ** If Return code is not blank then check if entry is a valid BIC code

     C**********         IF        @RTCD <> *BLANKS and PCFT007 = 'Y'                         199797
     C                   IF        @RTCD <> *BLANKS                                           199797

     C                   MOVEL     WWIMMD        PCSID8
     C                   MOVE      WWIMMD        PCSID4
     C                   MOVEL     PCSID4        PCSID3

     C                   EVAL      WCLAS = 'B'

     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       PBICR
     C                   PARM                    PCSID8
     C                   PARM                    PCSID3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       PBICC
     C                   PARM      *BLANKS       PBICS
     C                   PARM      *BLANKS       PBICI

     C                   IF        PBICR = *BLANKS                                            199797
     C                             OR PBICR = 'MIN0244' AND                                   205141
     C                             PBICC = 'Y'                                                205141
     C                   EVAL      @RTCD = *BLANKS                                            199797
     C                   ENDIF                                                                199797
                                                                                              199797
     C                   ELSE

     C                   EVAL      WWIMMD = BBCUST
     C                   EVAL      JFIMMD = BBCSID                                            205141

     C                   ENDIF
                                                                                              204704
     C                   MOVE      WWIMMD        PCSID1            1                          204704
     C                   IF        PCSID1 <> ' '                                              204704
     C                   MOVE      '*ERR'        @RTCD                                        204704
     C                   ENDIF                                                                204704

      ** Check settlement amount is unique

     C                   IF        WImFlg = 'Y'

     C                   EVAL      WCtr = 1

     C                   DOW       WCtr <= 9

     C                   IF        WIMDArr(WCtr) = *BLANKS
     C                   MOVEL     WWIMMD        WIMDArr(WCtr)
     C                   LEAVE
     C                   ELSE

     C                   IF        WIMDArr(WCtr) = WWIMMD
     C                   EVAL      WUnqeFlg = 'Y'
     C                   LEAVE
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLI35 - Validate a 35A Input Field                           *
      *                                                               *
      * Called by: SRAWIL - Validate Account with Institution A/C     *
      *            SRBOF1 - Validate Beneficiary of Money A/C Line 1  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRLI35        BEGSR

      ** Initialise Flag to Send Error Message If 35A Fields not
      ** correctly Formatted.

     C                   EVAL      WWER35 = *BLANKS

      ** Validate First Character

     C                   IF        WWLI01 <> '/'
     C                   EVAL      WWER35 = 'Y'
     C                   ENDIF

      ** Validate First 2 Characters

     C                   IF        WWLI02 = '//' and WWLI04 <> '//BL' and
     C                             WWLI04 <> '//CH' and WWLI04 <> '//CP' and
     C                             WWLI04 <> '//FW' and WWLI04 <> '//SC'
     C                   EVAL      WWER35 = 'Y'
     C                   ENDIF

      ** Validate First 4 Characters

     C                   IF        SACCY <> 'USD'
     C                   IF        WWLI04 = '//CH' or WWLI04 = '//CP' or
     C                             WWLI04 = '//FW'
     C                   EVAL      WWER35 = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        SACCY <> 'DEM' and WWLI04 = '//BL'
     C                   EVAL      WWER35 = 'Y'
     C                   ENDIF

      ** Invalid Entry

     C                   IF        WWER35 = 'Y'

     C                   EVAL      WWER35 = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5235'

     C                   IF        WFIELD = '#0AWIL'
     C                   EVAL      OkAWIL = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0AWIL'
     C                   ELSE
     C                   EVAL      OkBOF1 = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0BOF1'
     C                   ENDIF

     C                   ENDIF

      ** Validate First 5 Characters

     C                   IF        WWLI05 = '//CP '

     C                   IF        WWCUSS = 'C' or WWCUSS = 'S'

      ** If //CP is followed by Blanks then Default this to the
      ** Customer CHIPS Participant

     C                   IF        WWBNBI = 'Y' and WW0535 = *BLANKS
     C                   MOVEL     WWCABA        WW0507
     C                   ENDIF

     C                   ENDIF

      ** Error If ' //CP' is not followed by a 3 Digit Number
      ** followed by Blanks

     C                   MOVEL     WW0507        WWNUM4
     C                   MOVEL     WWNUM4        WWALP3

     C                   IF        WW0507 <> WWALP3 or WW0835 <> *BLANKS

     C                   EVAL      WWER35 = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5236'

     C                   IF        WFIELD = '#0AWIL'
     C                   EVAL      OkAWIL = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0AWIL'
     C                   ELSE
     C                   EVAL      OkBOF1 = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0BOF1'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** If Leftmost 4 Chars are '//FW' followed by Blanks and
      ** Customer SWIFT Id is Blank then Set Up Fedwire Account

     C                   IF        WWLI04 = '//FW'

     C                   IF        WW0535 = *BLANKS and WWCSID = *BLANKS
     C                   MOVEL     WWFWCD        WW0513
     C                   ENDIF

      ** Error If Positions 14 -35 of WWLI35 are not Blank

     C                   IF        WW1435 <> *BLANKS

     C                   EVAL      WWER35 = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5237'

     C                   IF        WFIELD = '#0AWIL'
     C                   EVAL      OkAWIL = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0AWIL'
     C                   ELSE
     C                   EVAL      OkBOF1 = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0BOF1'
     C                   ENDIF
     C                   ENDIF

      ** Fedwire Account may only be Blank for a Bank with a Valid
      ** SWIFT Address

     C                   IF        WW0513 = *BLANKS

     C                   IF        WWCUSS <> 'C' and WWCUSS <> 'S' or
     C                             WWBNBI = 'N' or WWCSID = *BLANKS

     C                   EVAL      WWER35 = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5238'

     C                   IF        WFIELD = '#0AWIL'
     C                   EVAL      OkAWIL = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0AWIL'
     C                   ELSE
     C                   EVAL      OkBOF1 = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0BOF1'
     C                   ENDIF

     C                   ENDIF

     C                   ELSE

      ** Else, must be A 9 Digit Number

     C                   MOVEL     WW0513        WWNU10
     C                   MOVEL     WWNU10        WWALP9

     C                   IF        WW0513 <> WWALP9

     C                   EVAL      WWER35 = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5239'

     C                   IF        WFIELD = '#0AWIL'
     C                   EVAL      OkAWIL = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0AWIL'
     C                   ELSE
     C                   EVAL      OkBOF1 = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0BOF1'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Customer or Bank must have a SWIFT Address or a Fedwire A/c

     C                   IF        WWCSID = *BLANKS and WWFWCD = *BLANKS

     C                   EVAL      WWER35 = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5240'

     C                   IF        WFIELD = '#0AWIL'
     C                   EVAL      OkAWIL = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0AWIL'
     C                   ELSE
     C                   EVAL      OkBOF1 = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0BOF1'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** If Leftmost 4 Chars of WWLI35 are '//BL' followed by Blanks
      ** Set Up the Bankleitzahl Code

     C                   IF        WWLI04 = '//BL'

     C                   IF        WWCUSS = 'C' or WWCUSS = 'S'
     C                   IF        WWBNBI = 'Y' and WW0535 = *BLANKS
     C                   MOVEL     WWBLCD        WW0512
     C                   ENDIF
     C                   ENDIF

      ** Error If '//BL' not followed by 8 Digits Number followed by
      ** Blanks

     C                   MOVEL     WW0512        WWNUM9
     C                   MOVEL     WWNUM9        WWALP8

     C                   IF        WW0512 <> WWALP8 or WW1335 <> *BLANKS

     C                   EVAL      WWER35 = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5241'

     C                   IF        WFIELD = '#0AWIL'
     C                   EVAL      OkAWIL = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0AWIL'
     C                   ELSE
     C                   EVAL      OkBOF1 = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0BOF1'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** If Leftmost 4 Chars of WWLI35 are '//CH' followed by Blanks
      ** Set Up Customer CHIPS Universal Id

     C                   IF        WWLI04 = '//CH'

     C                   IF        WWCUSS = 'C' or WWCUSS = 'S'
     C                   IF        WWBNBI = 'Y' or WW0535 = *BLANKS
     C                   MOVEL     WWCHID        WW0510
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** If Leftmost 4 Chars of WWLI35 are '//SC' followed by Blanks
      ** Set Up CHAPS Sort Code

     C                   IF        WWLI04 = '//SC'

     C                   IF        WWCUSS = 'C' or WWCUSS = 'S'
     C                   IF        WWBNBI = 'Y' and WW0535 = *BLANKS
     C                   MOVEL     WWCHSC        WW0510
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** Error If '//CH' or '//SC' are not followed by a 6 Digit Number

     C                   IF        WWLI04 = '//CH' or WWLI04 = '//SC'

     C                   MOVEL     WW0510        WWNUM7
     C                   MOVEL     WWNUM7        WWALP6

     C                   IF        WW0510 <> WWALP6 or WW1135 <> *BLANKS

     C                   EVAL      WWER35 = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5242'

     C                   IF        WFIELD = '#0AWIL'
     C                   EVAL      OkAWIL = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0AWIL'
     C                   ELSE
     C                   EVAL      OkBOF1 = 'N'
     C                   EVAL      FldNameArr(Idx) = '#0BOF1'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRME99 - Validate Account with Line via ME9940                *
      *                                                               *
      * Called by: SRAWIL - Validate Account with Institution A/C     *
      *            SRBOF1 - Validate Beneficiary of Money A/C Line 1  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRME99        BEGSR

     C                   CALL      'ME9940'
     C                   PARM                    @RTCD
     C                   PARM                    I#PARM
     C                   PARM                    O#PARM
     C                   PARM                    E#PARM
     C                   PARM                    Z#PARM

     C                   MOVEL     O#ACLN        WWLI35

     C                   IF        E#ERRM <> *BLANKS
     C                   EVAL      WWER35 = 'Y'
     C                   ELSE

      ** Check whether Issuer Code has been defined for the currency
      ** clearing system. If not, set flag on to issue warning message
      ** for later display (SEW5176).

     C                   MOVEL     Z#PARM        W#ISCD

     C                   IF        WWLI02 = '//' and
     C                             W#ISCD = *BLANKS and
     C                             O#ACLN <> WACLN
     C                   EVAL      WICNIL = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAWIN - Validate Account with Institution                    *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRAWIN        BEGSR

     C                   MOVEL     #0AWIN        WWAWIN                                     AR635847
     C                   IF        #0AWIN <> *BLANKS

     C                   EVAL      PKEY1 = #0AWIN
     C                   EXSR      SRCUST

     C                   IF        WWCUSS <> 'C' and WWCUSS <> 'S' and
     C                             WWCUSS <> 'N'
     C                   EVAL      OkAWIN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5205'
     C                   EVAL      FldNameArr(Idx) = '#0AWIN'
     C                   ELSE

     C                   IF        WWCUSS = 'C' or WWCUSS = 'S'

      ** A/c must be a Bank

     C                   IF        WWBNBI <> 'Y'
     C                   EVAL      #0AWIN = BBCUST                                          AR634357
     C                   EVAL      OkAWIN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5225'
     C                   EVAL      FldNameArr(Idx) = '#0AWIN'
     C                   ELSE
     C                   EVAL      #0AWIN = BBCUST
     C                   ENDIF

     C                   ELSE

      ** Nostro

     C                   IF         WWCUSS = 'N'
     C                   EVAL       #0AWIN = AWCPNC
     C                   ENDIF

     C                   ENDIF

     C                   IF        PCSW098 = 'Y'
     C                   EVAL      WAWIN = #0AWIN
     C                   ENDIF

      ** Either #0BOFN must not be left Blank

     C                   IF        #0BOFN = *BLANKS
     C                   EVAL      OkAWIN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5226'
     C                   EVAL      FldNameArr(Idx) = '#0AWIN'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAWIL - Validate Account with Institution A/C                *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRAWIL        BEGSR

     C                   MOVEL     #0AWIL        WWAWIL
     C                   MOVEL     #0AWIL        WWLI02                                     AR589197
     C                   EVAL      WFIELD = '#0AWIL'

     C                   IF        PISOMsg <> 'Y'                                           AR568778
     C                             OR WWLI02 = '//'                                         AR589197
     C                   IF        #0AWIL <> *BLANKS AND WWAWIL <> '#'

     C                   IF        #0AWIN = *BLANKS
     C                   EVAL      OkAWIL = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5230'
     C                   EVAL      FldNameArr(Idx) = '#0AWIL'
     C                   ELSE
     C                   MOVEL     #0AWIL        WWLI01
     C                   MOVEL     #0AWIL        WWLI02
     C                   MOVEL     #0AWIL        WWLI04
     C                   MOVEL     #0AWIL        WWLI05
     C                   MOVEL     #0AWIL        WWLI35

     C                   EVAL      WWER35 = 'N'                                             AR589197
     C                   IF        PCSW098 <> 'Y'
     C                   EXSR      SRLI35
     C                   ELSE

      ** Set up parameters for call to ME9940

     C                   EVAL      @RTCD = *BLANKS
     C                   EVAL      I#PARM = *BLANKS
     C                   MOVEL     'AWBK '       I#VFLD
     C                   MOVEL     'PAY'         I#PR

     C                   IF        WWCUSS = 'N'
     C                   MOVEL     'X'           I#PRTT
     C                   ELSE
     C                   MOVEL     WWCUSS        I#PRTT
     C                   ENDIF

     C                   MOVEL     WAWIN         I#PRTY
     C**********         MOVEL     SACCY         I#PCCY                                     AR589197
     C**********         MOVEL     SACCY         I#RCCY                                     AR589197
     C                   MOVEL     PCCY          I#PCCY                                     AR589197
     C                   MOVEL     PCCY          I#RCCY                                     AR589197
     C                   MOVEL     WWLI35        I#ACLN
     C                   MOVEL     '5XX'         I#MTYP                                     AR589197
     C                   EVAL      O#PARM = *BLANKS
     C                   EVAL      E#PARM = *BLANKS
     C                   MOVEL     'SEDSSIDSP'   E#CPGM
     C                   MOVEL     'MEC0017'     E#MSGD
     C                   MOVEL     'MEMSG'       E#MSGF
     C                   MOVEL     WAWBK         WACLN

     C                   EXSR      SRME99

     C                   IF        E#ERRM <> *BLANKS
     C                   EVAL      OkAWIL = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5176'                                AR589197
     C                   EVAL      FldNameArr(Idx) = '#0AWIL'
     C                   ENDIF

      ** If no issuer code defined for the currency clearing system,
      ** set flag to display warning message for later display.

     C                   IF        WICNIL = 'Y'
     C                   MOVEL     'Y'           IAWBK
     C                   MOVEL     *BLANKS       WICNIL
     C                   ENDIF

     C                   MOVEL     WWLI35        WAWBK

     C                   ENDIF

     C                   IF        WWER35 <> 'Y'
     C                   MOVEL     WWLI35        #0AWIL
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF
     C                   ENDIF                                                              AR568778

     C                                                                                        CSW210
     C                   IF        PCFT004 = 'Y' AND                                          CSW210
     C                             PCSW210 = 'Y'                                              CSW210
     C                   EVAL      MsgLine = *Blank                                           CSW210
     C                   EVAL      DSACB1 = #0AWIL                                            CSW210
     C                   EXSR      SRIBAN                                                     CSW210
     C                   IF        IBANFlg = 'Y'                                            AR578911
     C                   EVAL      #0AWIL = DSACB1                                          AR578911
     C                   ENDIF                                                              AR578911
                                                                                              CSW210
     C                   IF        @Rcode <> *Blanks AND                                      CSW210
     C                             IBANFlg = 'Y'                                              CSW210
     C                   MOVEL     '#0AWIL'      WFldNam                                      CSW210
     C                   EVAL      WMsgID = WMsgIdArr(WIdx)                                   CSW210
     C                   EVAL      WFldVal = #0AWIL                                           CSW210
                                                                                              CSW210
     C                   IF        MsgLine = PrevMsg(3)                                       CSW210
     C                   EVAL      OkAWIL = ' '                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WMsgIdArr(WIdx) = *Blank                                   CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WIdx = WIdx - 1                                            CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      OkAWIL = 'W'                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = '#0AWIL    '                            CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = XAWIL                                   CSW210
     C                   MOVE      MsgLine       PrevMsg(3)                                   CSW210
     C                   EVAL      PrevFlg = 'Y'                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAFPN - Validate Account for Payment                         *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRAFPN        BEGSR

     C                   MOVEL     #0AFPN        WWAFPN                                     AR635847
     C                   IF        #0AFPN <> *BLANKS

     C                   EVAL      PKEY1 = #0AFPN
     C                   EXSR      SRCUST

     C                   IF        WWCUSS <> 'C' and WWCUSS <> 'S' and
     C                             WWCUSS <> 'N'
     C                   EVAL      OkAFPN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5205'
     C                   EVAL      FldNameArr(Idx) = '#0AFPN'
     C                   ENDIF

     C                   IF        WWCUSS = 'C' or WWCUSS = 'S'
     C                   EVAL      #0AFPN = BBCUST
     C                   ENDIF

      ** Nostro

     C                   IF         WWCUSS = 'N'
     C                   EVAL       #0AFPN = AWCPNC
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAFPL - Validate Account for Payment A/C Line                *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRAFPL        BEGSR

     C                   MOVEL     #0AFPL        WWAFPL

     C                   IF        PISOMsg <> 'Y'                                           AR568778
     C                   IF        #0AFPL <> *BLANKS AND WWAFPL <> '#'

     C                   MOVEL     #0AFPL        WWLI01

     C                   IF        WWLI01 <> '/'
     C                   EVAL      OkAFPL = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5210'
     C                   EVAL      FldNameArr(Idx) = '#0AFPL'
     C                   ENDIF

     C                   MOVEL     #0AFPL        WWLI02

     C                   IF        WWLI02 =  '//'
     C                   EVAL      OkAFPL = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5211'
     C                   EVAL      FldNameArr(Idx) = '#0AFPL'
     C                   ENDIF

     C                   MOVE      #0AFPL        WWLI34

     C                   IF        WWLI01 =  '/' and WWLI34 = *BLANKS
     C                   EVAL      OkAFPL = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5212'
     C                   EVAL      FldNameArr(Idx) = '#0AFPL'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF                                                              AR568778
     C                                                                                        CSW210
     C                   IF        PCFT004 = 'Y' AND                                          CSW210
     C                             PCSW210 = 'Y'                                              CSW210
     C                   EVAL      MsgLine = *Blank                                           CSW210
     C                   EVAL      DSACB1 = #0AFPL                                            CSW210
     C                   EXSR      SRIBAN                                                     CSW210
     C                   IF        IBANFlg = 'Y'                                            AR578911
     C                   EVAL      #0AFPL = DSACB1                                          AR578911
     C                   ENDIF                                                              AR578911
                                                                                              CSW210
     C                   IF        @Rcode <> *Blanks AND                                      CSW210
     C                             IBANFlg = 'Y'                                              CSW210
     C                   MOVEL     '#0AFPL'      WFldNam                                      CSW210
     C                   EVAL      WMsgID = WMsgIdArr(WIdx)                                   CSW210
     C                   EVAL      WFldVal = #0AFPL                                           CSW210
                                                                                              CSW210
     C                   IF        MsgLine = PrevMsg(1)                                       CSW210
     C                   EVAL      OkAFPL = ' '                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WMsgIdArr(WIdx) = *Blank                                   CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WIdx = WIdx - 1                                            CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      OkAFPL = 'W'                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = '#0AFPL    '                            CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = XAFPL                                   CSW210
     C                   MOVE      MsgLine       PrevMsg(1)                                   CSW210
     C                   EVAL      PrevFlg = 'Y'                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      * SRDBTR - Validate Debtor Identification                       *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *                       CSW210
      *                                                               *                       CSW210
      * Calls: None                                                   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRDBTR        BEGSR                                                                CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   MOVEL     @DEBTR1       WWDBTR                                     AR635847
     C                   IF        @DEBTR1 <> *BLANKS                                         CSW210
     C**********         MOVEL     @DEBTR1       WWDBTR                            AR634357 AR635847
                                                                                              CSW210
     C                   IF        #1FIND = 'F'                                               CSW210
     C                   EVAL      DbtrOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DEBTR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00112'                                  CSW210
                                                                                              CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
     C                   MOVEL     @DEBTR1       PKEY1                                        CSW210
                                                                                              CSW210
      ** Validate Customer Number/Shortname/Nostro                                            CSW210
                                                                                              CSW210
     C                   EXSR      SRCust                                                     CSW210
                                                                                              CSW210
     C                   IF        WWCUSS <> 'C' AND WWCUSS <> 'S' AND                        CSW210
     C                             WWCUSS <> 'N'                                              CSW210
     C                   EVAL      DbtrOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '@DEBTR1'                                CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00077'                                  CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
      ** If customer or shortame a/c must be a bank                                           CSW210
                                                                                              CSW210
     C**********         IF        WWCUSS = 'C' AND WWCUSS = 'S'                     CSW210 AR634357
     C                   IF        WWCUSS = 'C' OR WWCUSS = 'S'                             AR634357
     C**********         IF        WWBNBI = 'Y'                                      CSW210 AR636523
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
     C                   IF        WWCUSS = 'N'                                               CSW210
     C                   EVAL      @DEBTR1 = AWCPNC                                           CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      * SRDBAD - Validate Debtor Address                              *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *                       CSW210
      *                                                               *                       CSW210
      * Calls: None                                                   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRDBAD        BEGSR                                                                CSW210
                                                                                              CSW210
     C                   Eval      DSACB1 = @DADDR1                                           CSW210
     C                   Eval      DSACB2 = @DADDR2                                           CSW210
     C                   Eval      DSACB3 = @DADDR3                                           CSW210
     C                   Eval      DSACB4 = @DADDR4                                           CSW210
     C                   Eval      @ACBT = *Blanks                                            CSW210
                                                                                              CSW210
     C                   If        SACBDS  <> *Blanks                                         CSW210
                                                                                              CSW210
     C                   IF        #1FIND = 'F'                                               CSW210
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
      *                                                                                       CSW210
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
     C                   EVAL      DAd1Ok = ' '                                             AR579549
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
     C                   ENDIF                                                                CSW210
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
     C                   If        DAd1Ok = *Blanks And                                       CSW210
     C                             DAd2Ok = *Blanks And                                       CSW210
     C                             DAd3Ok = *Blanks And                                       CSW210
     C                             DAd4Ok = *Blanks And                                       CSW210
     C                             @ACBT = *Blanks                                            CSW210
     C                   Eval      @ACBT = 'A'                                                CSW210
     C                   EndIf                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EndIf                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      * SRDBLN - Validate Debtor Account Line                         *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *                       CSW210
      *                                                               *                       CSW210
      * Calls: None                                                   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRDBLN        BEGSR                                                                CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   IF        @DACNT1 <> *BLANKS                                         CSW210
                                                                                              CSW210
     C                   IF        #1FIND = 'F'                                               CSW210
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
     C                   EVAL      DActOk = ' '                                               CSW210
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
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      *  SRCODE - Validate CODEWORD                                   *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRDBAD                                             *                       CSW210
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
     C     IBCTY1        LOOKUP    Alpha                                  87                  CSW210
     C   87IBCTY2        LOOKUP    Alpha                                  87                  CSW210
     C   87IBCHK1        LOOKUP    Numeric                                87                  CSW210
     C   87IBCHK2        LOOKUP    Numeric                                87                  CSW210
                                                                                              CSW210
     C                   IF        *IN87 = *ON                                                CSW210
                                                                                              CSW210
     C                   EVAL      IBANFlg = 'Y'                                              CSW210
                                                                                              CSW210
     C                   CALL      'AOIBANR5'                           83                    CSW210
     C                   PARM      *Blanks       @Rcode                                       CSW210
     C                   PARM                    P@IBAN           34                          CSW210
                                                                                              CSW210
      *  If no warnings, prefix IBAN with '/'                                                 CSW210
                                                                                              CSW210
     C                   IF        *IN83 = *Off and @Rcode = *Blanks                          CSW210
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
      * SRBOFN - Validate Beneficiary of Money                        *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRBOFN        BEGSR

     C                   MOVEL     #0BOFN        WWBOFN                                     AR635847
     C                   IF        #0BOFN <> *BLANKS

     C                   EVAL      PKEY1 = #0BOFN
     C                   EXSR      SRCUST

     C                   IF        WWCUSS <> 'C' and WWCUSS <> 'S' and
     C                             WWCUSS <> 'N'
     C                   EVAL      OkBOFN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5205'
     C                   EVAL      FldNameArr(Idx) = '#0BOFN'
     C                   ELSE

     C                   IF        WWCUSS = 'C' or WWCUSS = 'S'
     C                   EVAL      #0BOFN = BBCUST
     C                   ELSE

      ** Nostro

     C                   IF         WWCUSS = 'N'
     C                   EVAL       #0BOFN = AWCPNC
     C                   ENDIF

     C                   ENDIF

     C                   IF        PCSW098 = 'Y'
     C                   MOVEL     #0BOFN        WBOFN
     C                   ENDIF

      ** Either #0AWIN must be Non-Blank

     C                   IF        #0AWIN = *BLANKS
     C                   EVAL      OkBOFN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5245'
     C                   EVAL      FldNameArr(Idx) = '#0BOFN'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBOF1 - Validate Beneficiary of Money A/C Line 1             *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRBOF1        BEGSR

     C                   MOVEL     #0BOF1        WWBOF1
     C                   MOVEL     #0BOF1        WWLI02                                     AR589197
     C                   EVAL      WFIELD = '#0BOF1'

     C                   IF        PISOMsg <> 'Y'                                           AR568778
     C                             OR WWLI02 = '//'                                         AR589197
     C                   IF        #0BOF1 <> *BLANKS AND WWBOF1 <> '#'

     C                   IF        #0BOFN = *BLANKS
     C                   EVAL      OkBOF1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5230'
     C                   EVAL      FldNameArr(Idx) = '#0BOF1'
     C                   ELSE
     C                   MOVEL     #0BOF1        WWLI01
     C                   MOVEL     #0BOF1        WWLI02
     C                   MOVEL     #0BOF1        WWLI04
     C                   MOVEL     #0BOF1        WWLI05
     C                   MOVEL     #0BOF1        WWLI35

     C                   IF        (WWLI02 = '//' and WWCUSS = 'C' and
     C                             WWBNBI = 'N') or (WWLI02 = '//' and
     C                             WWCUSS = 'S' and WWBNBI = 'N')
     C                   EVAL      OkBOF1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5250'
     C                   EVAL      FldNameArr(Idx) = '#0BOF1'
     C                   ELSE

     C                   EVAL      WWER35 = 'N'                                             AR589197
     C                   IF        PCSW098 <> 'Y'
     C                   EXSR      SRLI35
     C                   ELSE

      ** Set up parameters for call to ME9940

     C                   EVAL      @RTCD = *BLANKS
     C                   EVAL      I#PARM = *BLANKS
     C                   MOVEL     'BENF '       I#VFLD
     C                   MOVEL     'PAY'         I#PR

     C                   IF        WWCUSS = 'N'
     C                   MOVEL     'X'           I#PRTT
     C                   ELSE
     C                   MOVEL     WWCUSS        I#PRTT
     C                   ENDIF

     C                   MOVEL     WBOFN         I#PRTY
     C**********         MOVEL     SACCY         I#PCCY                                     AR589197
     C**********         MOVEL     SACCY         I#RCCY                                     AR589197
     C                   MOVEL     PCCY          I#PCCY                                     AR589197
     C                   MOVEL     PCCY          I#RCCY                                     AR589197
     C                   MOVEL     WWLI35        I#ACLN
     C                   MOVEL     '5XX'         I#MTYP                                     AR589197
     C                   EVAL      O#PARM = *BLANKS
     C                   EVAL      E#PARM = *BLANKS
     C                   MOVEL     'SEDSSIDSP'   E#CPGM
     C**********         MOVEL     'MEC0017'     E#MSGD                                     AR589197
     C                   MOVEL     'MEC0018'     E#MSGD                                     AR589197
     C                   MOVEL     'MEMSG'       E#MSGF
     C                   MOVEL     WBENF         WACLN

     C                   EXSR      SRME99

      ** If no issuer code defined for the currency clearing system,
      ** set flag to display warning message for later display.

     C                   IF        WICNIL = 'Y'
     C                   MOVEL     'Y'           IBENF
     C                   MOVEL     *BLANKS       WICNIL
     C                   ENDIF

     C                   MOVEL     WWLI35        WBENF

     C                   ENDIF

     C                   IF        E#ERRM <> *BLANKS
     C                   EVAL      OkBOF1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5176'                                AR589197
     C                   EVAL      FldNameArr(Idx) = '#0BOF1'
     C                   ENDIF

      ** If no issuer code defined for the currency clearing system,
      ** set flag to display warning message for later display.

     C                   IF        WICNIL = 'Y'
     C                   EVAL      IBENF = 'Y'
     C                   EVAL      WICNIL = *BLANKS
     C                   ENDIF

     C                   MOVEL     WWLI35        WBENF

     C                   ENDIF

     C                   IF        WWER35 <> 'Y'
     C                   MOVEL     WWLI35        #0BOF1
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF
     C                   ENDIF                                                              AR568778
     C                                                                                        CSW210
     C                   IF        PCFT004 = 'Y' AND                                          CSW210
     C                             PCSW210 = 'Y'                                              CSW210
     C                   EVAL      MsgLine = *Blank                                           CSW210
     C                   EVAL      DSACB1 = #0BOF1                                            CSW210
     C                   EXSR      SRIBAN                                                     CSW210
     C                   IF        IBANFlg = 'Y'                                            AR579600
     C                   EVAL      #0BOF1 = DSACB1                                          AR579600
     C                   ENDIF                                                              AR579600
                                                                                              CSW210
     C                   IF        @Rcode <> *Blanks AND                                      CSW210
     C                             IBANFlg = 'Y'                                              CSW210
     C                   MOVEL     '#0BOF1'      WFldNam                                      CSW210
     C                   EVAL      WMsgID = WMsgIdArr(WIdx)                                   CSW210
     C                   EVAL      WFldVal = #0BOF1                                           CSW210
                                                                                              CSW210
     C                   IF        MsgLine = PrevMsg(4)                                       CSW210
     C                   EVAL      OkBOF1 = ' '                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WMsgIdArr(WIdx) = *Blank                                   CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = *Blank                                  CSW210
     C                   EVAL      WIdx = WIdx - 1                                            CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      OkBOF1 = 'W'                                               CSW210
     C                   EVAL      WFldNamArr(WIdx) = '#0BOF1    '                            CSW210
     C                   EVAL      WMsgDtaArr(WIdx) = XBOF1                                   CSW210
     C                   MOVE      MsgLine       PrevMsg(4)                                   CSW210
     C                   EVAL      PrevFlg = 'Y'                                              CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBOF2 - Validate Beneficiary of Money A/C Line 2             *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRBOF2        BEGSR

     C                   MOVEL     #0BOF2        WWBOF2

     C                   IF        #0BOF2 <> *BLANKS AND WWBOF2 <> '#'

     C                   IF        #0BOF1 = *BLANKS
     C                   EVAL      OkBOF2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   EVAL      FldNameArr(Idx) = '#0BOF2'
     C                   ENDIF

     C                   IF        WWBOF1 <> '/' and WWBOF2 = '/'
     C                   EVAL      OkBOF2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5256'
     C                   EVAL      FldNameArr(Idx) = '#0BOF2'
     C                   ENDIF

     C                   MOVEL     #0BOF2        WWLI02

     C                   IF        WWBOF2 = '/' and WWLI02 <> '//'
     C                   EVAL      OkBOF2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5257'
     C                   EVAL      FldNameArr(Idx) = '#0BOF2'
     C                   ENDIF

     C                   IF        #0BOF2 = #0BOF1
     C                   EVAL      OkBOF2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   EVAL      FldNameArr(Idx) = '#0BOF2'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSRL1 - Validate Sender to Receiver Information 1            *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSRL1        BEGSR

     C                   EVAL      WERROR = *BLANKS

     C                   IF        #0SRL1 <> *BLANKS

     C                   MOVEL     #0SRL1        WWSRL1

     C                   IF        WWSRL1 = '/'

     C                   MOVEL     #0SRL1        WWSR06
     C                   MOVEL     #0SRL1        WWSR07
     C                   MOVEL     #0SRL1        WWSR08

     C                   IF        WWSR06 = '/AGEN/' or
     C                             WWSR06 = '/PRIN/' or
     C                             WWSR06 = '/PHON/'
     C                   EVAL      WERROR = 'N'
     C                   ENDIF
     C                   IF        WWSR07 = '/TELEX/'
     C                   EVAL      WERROR = 'N'
     C                   ENDIF
     C                   IF        WWSR08 = '/BROKER/'
     C                   EVAL      WERROR = 'N'
     C                   ENDIF

     C                   IF        PCSW014 = 'N'
     C                   MOVEL     #0SRL1        WWSR06
     C                   IF        WWSR06 = '/OCMT/'
     C                   EVAL      WERROR = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   IF        WERROR <> 'N'
     C                   EVAL      OkSRL1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5265'
     C                   EVAL      FldNameArr(Idx) = '#0SRL1'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSRL2 - Validate Sender to Receiver Information 2            *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSRL2        BEGSR

     C                   EVAL      WERROR = *BLANKS

     C                   IF        #0SRL2 <> *BLANKS

     C                   IF        #0SRL1 = *BLANKS
     C                   EVAL      OkSRL2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   EVAL      FldNameArr(Idx) = '#0SRL2'
     C                   ENDIF

     C                   MOVEL     #0SRL2        WWSRL2

     C                   IF        WWSRL1 <> '/' and WWSRL2 = '/'
     C                   EVAL      OkSRL2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5256'
     C                   EVAL      FldNameArr(Idx) = '#0SRL2'
     C                   ENDIF

     C                   MOVEL     #0SRL2        WWLI02

     C                   IF        WWSRL1 = '/' and WWLI02 <> '//'
     C                   EVAL      OkSRL2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5214'
     C                   EVAL      FldNameArr(Idx) = '#0SRL2'
     C                   ENDIF

     C                   IF        WWSRL2 = '/' and WWLI02 <> '//'
     C                   EVAL      OkSRL2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5257'
     C                   EVAL      FldNameArr(Idx) = '#0SRL2'
     C                   ENDIF

     C                   MOVE      #0SRL2        WWLI33

     C                   IF        WWLI02 = '//' and WWLI33 = *BLANKS
     C                   EVAL      OkSRL2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   EVAL      FldNameArr(Idx) = '#0SRL2'
     C                   ENDIF

     C                   IF        #0SRL2 = #0SRL1
     C                   EVAL      OkSRL2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   EVAL      FldNameArr(Idx) = '#0SRL2'
     C                   ENDIF

     C                   ELSE
     C                   MOVEL     #0SRL2        WWLI02
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSRL3 - Validate Sender to Receiver Information 3            *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSRL3        BEGSR

     C                   IF        #0SRL3 <> *BLANKS

     C                   IF        #0SRL2 = *BLANKS
     C                   EVAL      OkSRL3 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   EVAL      FldNameArr(Idx) = '#0SRL3'
     C                   ENDIF

     C                   MOVEL     #0SRL3        WWSRL3

     C                   IF        WWSRL2 <> '/' and WWSRL3 = '/'
     C                   EVAL      OkSRL3 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5256'
     C                   EVAL      FldNameArr(Idx) = '#0SRL3'
     C                   ENDIF

     C                   MOVEL     #0SRL3        WWLI02

     C                   IF        WWSRL2 = '/' and WWLI02 <> '//'
     C                   EVAL      OkSRL3 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5214'
     C                   EVAL      FldNameArr(Idx) = '#0SRL3'
     C                   ENDIF

     C                   IF        WWSRL2 = '/' and WWLI02 <> '//'
     C                   EVAL      OkSRL3 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5257'
     C                   EVAL      FldNameArr(Idx) = '#0SRL3'
     C                   ENDIF

     C                   MOVE      #0SRL3        WWLI33

     C                   IF        WWLI02 = '//' and WWLI33 = *BLANKS
     C                   EVAL      OkSRL3 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   EVAL      FldNameArr(Idx) = '#0SRL3'
     C                   ENDIF

     C                   IF        #0SRL3 = #0SRL2
     C                   EVAL      OkSRL3 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   EVAL      FldNameArr(Idx) = '#0SRL3'
     C                   ENDIF

     C                   ELSE
     C                   MOVEL     #0SRL3        WWLI02
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGMES - Validate Settlement Message Request                  *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRGMES        BEGSR

      ** If #1GMES is not 'Y' or 'N'

     C                   IF        #1GMES <> 'Y' and #1GMES <> 'N' and
     C                             #1GMES <> *BLANKS
     C                   EVAL      OkGMES = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5101'
     C                   EVAL      FldNameArr(Idx) = '#1GMES'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINST - Validate Instruction Type                            *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRINST        BEGSR

     C                   IF        #1INST <> *BLANKS

      ** Check instructions type as a alpha input field

     C     #1INST        LOOKUP    VA1                                    86

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINSS - Validate Instruction Sub-Type                        *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRINSS        BEGSR

     C                   IF        #1INSS <> *BLANKS

      ** Check internal or bridge instructions sub-type

     C                   IF        #1INST = 'INT' or #1INST = 'BRI'

     C                   IF        #1INSS <> 'SETTL' and
     C                             #1INSS <> 'MATCH' and
     C                             #1INSS <> 'TRANS'
     C                   EVAL      OkINSS = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5104'
     C                   EVAL      FldNameArr(Idx) = '#1INSS'
     C                   ENDIF

     C                   ENDIF

      ** Check external sub-type

     C                   IF        #1INST = 'EXT'

     C                   IF        #1INSS <> 'BOOK ' and
     C                             #1INSS <> ' BOOK' and
     C                             #1INSS <> 'PHYSI'
     C                   EVAL      OkINSS = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5105'
     C                   EVAL      FldNameArr(Idx) = '#1INSS'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRPTY - Validate Requested Priority                          *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRRPTY        BEGSR

      ** If #1RPTY is not '1', '2', '3' , '4' or blank

     C                   IF        #1RPTY <> '1' and #1RPTY <> '2' and
     C                             #1RPTY <> '3' and #1RPTY <> '4' and
     C                             #1RPTY <> '5' and #1RPTY <> *BLANKS
     C                   EVAL      OkRPTY = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5125'
     C                   EVAL      FldNameArr(Idx) = '#1RPTY'
     C                   ENDIF

     C                   IF        PBFCLAS = 'C' and #1RPTY = '4'
     C                   EVAL      OkRPTY = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5126'
     C                   EVAL      FldNameArr(Idx) = '#1RPTY'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGDEL - Validate Guaranteed Delivery                         *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRGDEL        BEGSR

      ** If #1GDEL is not 'G' or blank

     C                   IF        #1GDEL <> 'G' and #1GDEL <> *BLANKS
     C                   EVAL      OkGDEL = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5150'
     C                   EVAL      FldNameArr(Idx) = '#1GDEL'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSROL - Validate Sender's Role                               *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSROL        BEGSR

     C                   IF        #1SROL <> *BLANKS

      ** If #1SROL is not AGEN, CUST, PRIN or blank

     C                   IF        #1SROL <> 'AGEN' and
     C                             #1SROL <> 'CUST' and
     C                             #1SROL <> 'PRIN' and
     C                             #1SROL <> *BLANKS
     C                   EVAL      OkSROL = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5165'
     C                   EVAL      FldNameArr(Idx) = '#1SROL'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFIND - Validate Free or Against Payment                     *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRFIND        BEGSR

     C                   IF        #1FIND <> 'F' and #1FIND <> 'A' and
     C                             #1FIND <> *BLANK
     C                   EVAL      OkFIND = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW7009'
     C                   EVAL      FldNameArr(Idx) = '#1FIND'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCCTN - Validate Clearing Correspondent                      *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRCCTN        BEGSR

     C                   IF        WCCTN <> *BLANKS
      **********                                                                              199797
      ***Check*Entry is Alphanumeric with no embedded Blanks                                  199797
      **********                                                                              199797
     C**********         MOVEA     WCCTN         CCO                                          199797
     C**********         Z-ADD     0             I                 2 0                        199797
     C**********         EVAL      WERROR = 'N'                                               199797
      **********                                                                              199797
     C**********         DOW       I <= 7 and WERROR = 'N'                                    199797
     C**********         ADD       1             I                                            199797
     C**********         IF        CCO(I) = ' '                                               199797
     C**********         EVAL      WERROR = 'Y'                                               199797
     C**********         ELSE                                                                 199797
     C*****CCO(I)        LOOKUP    VA0                                    82                  199797
     C**********         IF        *IN82 = *OFF                                               199797
     C**********         EVAL      WERROR = 'Y'                                               199797
     C**********         ENDIF                                                                199797
     C**********         ENDIF                                                                199797
     C**********         ENDDO                                                                199797
     C***********        MOVEL     WCCTN         WkVar1            1                   204751 204804
     C                   MOVEL     WCCTN         WkVar10          10                          204751
     C***********        IF        WkVar1 = '?'                                        204751 204804
     C                                                                                        204751
     C                   CALLB     'AOCUSTR0'                                                 204751
     C                   PARM      *BLANKS       WkRtCd            7                          204751
     C                   PARM      '*KEY   '     WkOptn            7                          204751
     C                   PARM                    WkVar10                                      204751
     C                   PARM                    WkKeySts          7                          204751
     C     SDCUST        PARM      SDCUST        DSSDY                                        204751
                                                                                              204751
     C                   IF        WkRtCd = *BLANK AND                                        204751
     C                             WkKeySts <> '*ERROR'                                       204751
     C                   IF        *IN10 = *ON                                                204804
     C                   EVAL      #2CCTN = BBCSID                                            204751
     C                   ELSE                                                                 204804
     C                   EVAL      #3CCTN = BBCSID                                            204804
     C                   ENDIF                                                                204804
     C                                                                                        204804
     C***********        ENDIF                                                         204751 204804
                                                                                              204751
     C                   ELSE                                                                 204751
                                                                                              199797
     C     *LOVAL        SETLL     SDCUSTSW                                                   199797
     C     WCCTN         CHAIN     SDCUSTSW                           99                      199797

     C**********         IF        WERROR = 'Y'                                               199797
     C                   IF        *IN99 = '1'                                                199797
      *                                                                                       204364
      ** Check if SWIFT Address exist in BIC file                                             204364
      *                                                                                       204364
     C                   CALL      'AOBICDV0'                                                 204364
     C                   PARM      *BLANKS       @CRtCd            7                          204364
     C                   PARM                    WCCTN                                        204364
     C                   PARM                    @CType            7                          204364
     C                   PARM                    DSSDY                                        204364
                                                                                              204364
     C                   MOVE      WCCTN         WkVar1            1                          204704
                                                                                              204704
     C                   IF        @CRtCd <> '*BICFND' AND                                    204364
     C                             @CType <> '*BIC'                                           204364
     C                             OR WkVar1 <> ' '                                           204704
     C                   EVAL      OkCCTN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5276'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF                                                                204364
     C                   ENDIF
     C                   ENDIF                                                                204751

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDRSN - Validate Deliverer/Receiver of Securities            *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRDRSN        BEGSR

      ***********                                                                      201429 204585
      ***Field*is*mandatory*for*Depot-in*and*settlement*message********                201429 204585
      ***requested*is*'Y'*and*ISO15022*is*set*to*'Y'.******************                201429 204585
      ***********                                                                      201429 204585
     C***********        IF        #1GMES = 'Y' AND PISOMsg = 'Y'                      201429 204585
     C***********                  AND WDRSN = *BLANKS                                 201429 204585
     C***********        EVAL      OkDRSN = 'N'                                        201429 204585
     C***********        EVAL      Idx = Idx + 1                                       201429 204585
     C***********        IF        *IN10                                               201429 204585
     C***********        EVAL      MsgIdArr(Idx) = 'SEW9003'                           201429 204585
     C***********        ELSE                                                          201429 204585
     C***********        EVAL      MsgIdArr(Idx) = 'SEW9006'                           201429 204585
     C***********        ENDIF                                                         201429 204585
     C***********        EVAL      FldNameArr(Idx) = WFIELD                            201429 204585
     C***********        ENDIF                                                         201429 204585
                                                                                              201429
     C                   IF        WDRSN <> *BLANKS

     C                   EVAL      PKEY1 = WDRSN
     C                   EXSR      SRCUST

     C                   IF        WWCUSS <> 'C' and WWCUSS <> 'S' and
     C                             WWCUSS <> 'N'
     C                   EVAL      OkDRSN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5205'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   IF        WWCUSS = 'C' or WWCUSS = 'S'
     C                   EVAL      WDRSN = BBCUST
     C                   IF        *IN10 = *ON                                                204753
     C                   EVAL      #2DRSN = BBCUST                                            204753
     C                   ELSE                                                                 204753
     C                   EVAL      #3DRSN = BBCUST                                            204753
     C                   ENDIF                                                                204753
     C                   ENDIF

      ** Nostro

     C                   IF         WWCUSS = 'N'
     C                   EVAL       WDRSN = AWCPNC
     C                   ENDIF

     C                   ELSE

      ***if*screen*field*is*blank*but*account*line*1*is*not*blank*******                      205885
      ***it*is*an*error.************************************************                      205885

     C**********         IF        WDRSN = *BLANKS and WDRS1 <> *BLANKS                       205885
     C**********                   and *IN10 = *ON                                            205885
     C**********         EVAL      OkDRSN = 'N'                                               205885
     C**********         EVAL      Idx = Idx + 1                                              205885
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5208'                                  205885
     C**********         EVAL      FldNameArr(Idx) = WFIELD                                   205885
     C**********         ENDIF                                                                205885

     C                   EVAL      WDRSN = *BLANKS

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDRS1 - Validate Deliverer/Receiver of Securities 1          *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRDRS1        BEGSR

     C                   MOVEL     WDRS1         WWDRS1

     C                   IF        WDRS1 <> *BLANKS AND WWDRS1 <> '#'

     C                   IF        WWDRS1 <> '/'
     C                   EVAL      OkDRS1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5210'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVEL     WDRS1         WWLI02

     C                   IF        WWLI02 = '//'
     C                   EVAL      OkDRS1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5211'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVE      WDRS1         WWLI34

     C                   IF        WDRS1 =  '/' and WWLI34 = *BLANKS
     C                   EVAL      OkDRS1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5212'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDRS2 - Validate Deliverer/Receiver of Securities 2          *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRDRS2        BEGSR

     C                   MOVEL     WDRS2         WWDRS2

     C                   IF        WDRS2 <> *BLANKS AND WWDRS2 <> '#'

     C                   IF        WDRS1 = *BLANKS
     C                   EVAL      OkDRS2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   IF        WDRS2 = WDRS1
     C                   EVAL      OkDRS2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVEL     WDRS2         WWLI02
     C                   MOVE      WDRS2         WWLI33

     C                   IF        WWLI02 <> '//' or WWLI33 = *BLANKS
     C                   EVAL      OkDRS2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDRS3 - Validate Deliverer/Receiver of Securities 3          *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRDRS3        BEGSR

     C                   MOVEL     WDRS3         WWDRS3

     C                   IF        WDRS3 <> *BLANKS AND WWDRS3 <> '#'

     C                   IF        WDRS2 = *BLANKS
     C                   EVAL      OkDRS3 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   IF        WDRS3 = WDRS2
     C                   EVAL      OkDRS3 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVEL     WDRS3         WWLI02
     C                   MOVE      WDRS3         WWLI33

     C                   IF        WWLI02 <> '//' or WWLI33 = *BLANKS
     C                   EVAL      OkDRS3 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDRS4 - Validate Deliverer/Receiver of Securities 4          *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRDRS4        BEGSR

     C                   MOVEL     WDRS4         WWDRS4

     C                   IF        WDRS4 <> *BLANKS AND WWDRS4 <> '#'

     C                   IF        WDRS3 = *BLANKS
     C                   EVAL      OkDRS4 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   IF        WDRS4 = WDRS3
     C                   EVAL      OkDRS4 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVEL     WDRS4         WWLI02
     C                   MOVE      WDRS4         WWLI33

     C                   IF        WWLI02 <> '//' or WWLI33 = *BLANKS
     C                   EVAL      OkDRS4 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFIN1 - Validate Further Information 1                       *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRFIN1        BEGSR

     C                   IF        WFIN1 <> *BLANKS

     C                   MOVEL     WFIN1         WWLI01

     C                   IF        WWLI01 = '/'
     C                   EVAL      OkFIN1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5285'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFIN2 - Validate Further Information 2                       *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRFIN2        BEGSR

     C                   IF        WFIN2 <> *BLANKS

     C                   IF        WFIN1 = *BLANKS
     C                   EVAL      OkFIN2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   IF        WFIN2 = WFIN1
     C                   EVAL      OkFIN2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVEL     WFIN2         WWLI01

     C                   IF        WWLI01 = '/'
     C                   EVAL      OkFIN2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5285'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRED1 - Validate Registration Details 1                      *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRRED1        BEGSR

     C                   EVAL      WRED1 = #4RED1                                             CSW210
     C                   EVAL      WFIELD = '#4RED1'                                          CSW210
                                                                                              CSW210
     C                   IF        WRED1 <> *BLANKS

     C                   MOVEL     WRED1         WWLI01

     C                   IF        WWLI01 = '/'
     C**********         EVAL      OkRED1 = 'N'                                               CSW210
     C                   EVAL      ReD1Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5285'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRED2 - Validate Registration Details 2                      *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRRED2        BEGSR

     C                   EVAL      WRED2 = #4RED2                                             CSW210
     C                   EVAL      WFIELD = '#4RED2'                                          CSW210
                                                                                              CSW210
     C                   IF        WRED2 <> *BLANKS

     C                   IF        WRED1 = *BLANKS
     C**********         EVAL      OkRED2 = 'N'                                               CSW210
     C                   EVAL      ReD2Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   IF        WRED2 = WRED1
     C**********         EVAL      OkRED2 = 'N'                                               CSW210
     C                   EVAL      ReD2Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVEL     WRED2         WWLI01

     C                   IF        WWLI01 = '/'
     C**********         EVAL      OkRED2 = 'N'                                               CSW210
     C                   EVAL      ReD2Ok = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5285'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      * SRPCLR - Validate Place of Clearing                           *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRVALIDATE3 - Validate screen 3 fields             *                       CSW210
      *                                                               *                       CSW210
      * Calls: None                                                   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRPCLR        BEGSR                                                                CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   MOVEL     #4PCL1        WWPCL1                                     AR635847
     C                   IF        #4PCL1 <> *BLANKS                                          CSW210
     C                   MOVEL     #4PCL1        PKEY1                                        CSW210
     C**********         MOVEL     #4PCL1        WWPCL1                            AR634357 AR635847
                                                                                              CSW210
      ** Validate Customer Number/Shortname/Nostro                                            CSW210
                                                                                              CSW210
     C                   EXSR      SRCust                                                     CSW210
                                                                                              CSW210
     C                   IF        WWCUSS <> 'C' AND WWCUSS <> 'S' AND                        CSW210
     C                             WWCUSS <> 'N'                                              CSW210
     C                   EVAL      PClrOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '#4PCL1'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00084'                                  CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
      ** If customer or shortame a/c must be a bank                                           CSW210
                                                                                              CSW210
     C**********         IF        WWCUSS = 'C' AND WWCUSS = 'S'                     CSW210 AR634357
     C                   IF        WWCUSS = 'C' OR WWCUSS = 'S'                             AR634357
     C**********         IF        WWBNBI = 'Y'                                      CSW210 AR636523
     C                   EVAL      #4PCL1 = BBCUST                                            CSW210
     C**********         ELSE                                                        CSW210 AR636523
      **********                                                                     CSW210 AR636523
      ***Customer is non-bank                                                        CSW210 AR636523
      **********                                                                     CSW210 AR636523
     C**********         EVAL      #4PCL1 = BBCUST                                 AR634357 AR636523
     C**********         EVAL      PClrOk = 'N'                                      CSW210 AR636523
     C**********         EVAL      Idx = Idx + 1                                     CSW210 AR636523
     C**********         EVAL      FldNameArr(Idx) = '#4PCL1'                        CSW210 AR636523
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5225'                         CSW210 AR636523
     C**********         ENDIF                                                       CSW210 AR636523
                                                                                              CSW210
      ** Entry is Nostro                                                                      CSW210
                                                                                              CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
     C                   IF        WWCUSS = 'N'                                               CSW210
     C                   EVAL      #4PCL1 = AWCPNC                                            CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      * SRQFIN - Validate Qualified Foreign Inst                      *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRVALIDATE3 - Validate screen 3 fields             *                       CSW210
      *                                                               *                       CSW210
      * Calls: None                                                   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRQFIN        BEGSR                                                                CSW210
                                                                                              CSW210
      ** Validate if not blank                                                                CSW210
                                                                                              CSW210
     C                   MOVEL     #4QFI1        WPQFIN                                     AR635847
     C                   IF        #4QFI1 <> *BLANKS                                          CSW210
     C                   MOVEL     #4QFI1        PKEY1                                        CSW210
     C**********         MOVEL     #4QFI1        WPQFIN                            AR634357 AR635847
                                                                                              CSW210
      ** Validate Customer Number/Shortname/Nostro                                            CSW210
                                                                                              CSW210
     C                   EXSR      SRCust                                                     CSW210
                                                                                              CSW210
     C                   IF        WWCUSS <> 'C' AND WWCUSS <> 'S' AND                        CSW210
     C                             WWCUSS <> 'N'                                              CSW210
     C                   EVAL      QFInOk = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      FldNameArr(Idx) = '#4QFI1'                                 CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00083'                                  CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
      ** If customer or shortame a/c must be a bank                                           CSW210
                                                                                              CSW210
     C**********         IF        WWCUSS = 'C' AND WWCUSS = 'S'                     CSW210 AR634357
     C                   IF        WWCUSS = 'C' OR WWCUSS = 'S'                             AR634357
     C**********         IF        WWBNBI = 'Y'                                      CSW210 AR636523
     C                   EVAL      #4QFI1 = BBCUST                                            CSW210
     C**********         ELSE                                                        CSW210 AR636523
      **********                                                                     CSW210 AR636523
      ***Customer is non-bank                                                        CSW210 AR636523
      **********                                                                     CSW210 AR636523
     C**********         EVAL      #4QFI1 = BBCUST                                 AR634357 AR636523
     C**********         EVAL      QFInOk = 'N'                                      CSW210 AR636523
     C**********         EVAL      Idx = Idx + 1                                     CSW210 AR636523
     C**********         EVAL      FldNameArr(Idx) = '#4QFI1'                        CSW210 AR636523
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5225'                         CSW210 AR636523
     C**********         ENDIF                                                       CSW210 AR636523
                                                                                              CSW210
      ** Entry is Nostro                                                                      CSW210
                                                                                              CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
     C                   IF        WWCUSS = 'N'                                               CSW210
     C                   EVAL      #4QFI1 = AWCPNC                                            CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************
      *                                                               *
      * SRNAS1 - Validate Narrative 1                                 *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *            SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRNAS1        BEGSR

     C                   EVAL      WFIELD2 = *BLANKS
     C                   EVAL      WWNAL1 = *BLANKS

     C                   IF        WNAS1 <> *BLANKS

     C                   MOVEL     WNAS1         WWNAL1
     C                   MOVE      WNAS1         WWLI34

     C                   IF        *IN76 = *ON
     C                   EVAL      WFIELD = '#0NAC1'
     C                   ENDIF

     C                   IF        WWNAL1 = '/' and WWLI34 = *BLANKS
     C                   EVAL      WFIELD2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5263'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   IF        *IN76 = *ON
     C                   EVAL      OkNAC1 = WFIELD2
     C                   ELSE
     C                   EVAL      OkNAS1 = WFIELD2
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNAS2 - Validate Narrative 2                                 *
      *                                                               *
      * Called by: SRDISPLAY1 - Display Screen 1 Details              *
      *            SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRNAS2        BEGSR

     C                   EVAL      WFIELD2 = *BLANKS

     C                   IF        WNAS2 <> *BLANKS

     C                   IF        *IN76 = *ON
     C                   EVAL      WFIELD = '#0NAC2'
     C                   ENDIF

     C                   IF        WNAS1 = *BLANKS
     C                   EVAL      WFIELD2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVEL     WNAS2         WWNAL2

     C                   IF        WWNAL1 <> '/' and WWNAL2 = '/'
     C                   EVAL      WFIELD2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5256'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVEL     WNAS2         WWLI02

     C                   IF        WWNAL1 = '/' and WWLI02 <> '//'
     C                   EVAL      WFIELD2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5214'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   IF        WWNAL2 = '/' and WWLI02 <> '//'
     C                   EVAL      WFIELD2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5257'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVE      WNAS2         WWLI33

     C                   IF        WWLI02 = '//' and WWLI33 = *BLANKS
     C                   EVAL      WFIELD2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   IF        WNAS2 = WNAS1
     C                   EVAL      WFIELD2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   ELSE

     C                   MOVEL     WNAS2         WWLI02

     C                   IF        WWNAL1 = '/' and WWLI02 <> '//'
     C                   EVAL      WFIELD2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5214'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   ENDIF

     C                   IF        *IN76 = *ON
     C                   EVAL      OkNAC2 = WFIELD2
     C                   ELSE
     C                   EVAL      OkNAS2 = WFIELD2
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBSSN - Validate Beneficiary of Securities                   *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRBSSN        BEGSR

      *                                                                                       201429
      ** Field is mandatory for Depot-out and settlement message                              201429
      ** requested is 'Y' and ISO15022 is set to 'Y'.                                         201429
      *                                                                                       201429
     C                   IF        #1GMES = 'Y' AND PISOMsg = 'Y'                             201429
     C                             AND #3BSSN = *BLANKS                                       201429
     C                   EVAL      OkBSSN = 'N'                                               201429
     C                   EVAL      Idx = Idx + 1                                              201429
     C                   EVAL      MsgIdArr(Idx) = 'SEW9005'                                  201429
     C                   EVAL      FldNameArr(Idx) = '#3BSSN'                                 201429
     C                   ENDIF                                                                201429
                                                                                              201429
     C                   IF        #3BSSN <> *BLANKS

     C                   EVAL      PKEY1 = #3BSSN
     C                   EXSR      SRCUST

     C                   IF        WWCUSS <> 'C' and WWCUSS <> 'S' and
     C                             WWCUSS <> 'N'
     C                   EVAL      OkBSSN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5205'
     C                   EVAL      FldNameArr(Idx) = '#3BSSN'
     C                   ENDIF

     C                   IF        WWCUSS = 'C' or WWCUSS = 'S'
     C                   EVAL      #3BSSN = BBCUST
     C                   ENDIF

      ** Nostro

     C                   IF         WWCUSS = 'N'
     C                   EVAL       #3BSSN = AWCPNC
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBSS1 - Validate Beneficiary of Securities 1                 *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRBSS1        BEGSR

     C                   MOVEL     #3BSS1        WWBSS1

     C                   IF        #3BSS1 <> *BLANKS AND WWBSS1 <> '#'

     C                   IF        WWBSS1 <> '/'
     C                   EVAL      OkBSN1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5210'
     C                   EVAL      FldNameArr(Idx) = '#3BSS1'
     C                   ENDIF

     C                   MOVEL     #3BSS1        WWLI02

     C                   IF        WWLI02 = '//'
     C                   EVAL      OkBSN1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5211'
     C                   EVAL      FldNameArr(Idx) = '#3BSS1'
     C                   ENDIF

     C                   MOVE      #3BSS1        WWLI34

     C                   IF        WWBSS1 = '/' and WWLI34 = *BLANKS
     C                   EVAL      OkBSN1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5212'
     C                   EVAL      FldNameArr(Idx) = '#3BSS1'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBSS2 - Validate Beneficiary of Securities 2                 *
      *                                                               *
      * Called by: SRDISPLAY2 - Display Screen 2 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRBSS2        BEGSR

     C                   MOVEL     #3BSS2        WWBSS2

     C                   IF        #3BSS2 <> *BLANKS AND WWBSS2 <> '#'

     C                   IF        #3BSS1 = *BLANKS
     C                   EVAL      OkBSN2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   EVAL      FldNameArr(Idx) = '#3BSS2'
     C                   ENDIF

     C                   IF        #3BSS2 = #3BSS1
     C                   EVAL      OkBSN2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   EVAL      FldNameArr(Idx) = '#3BSS2'
     C                   ENDIF

     C                   MOVEL     #3BSS2        WWLI02
     C                   MOVE      #3BSS2        WWLI33

     C                   IF        WWLI02 <> '//' or WWLI33 = *BLANKS
     C                   EVAL      OkBSN2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   EVAL      FldNameArr(Idx) = '#3BSS2'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINTM - Validate Intermediary Fields                         *
      *                                                               *
      * Called by: SRDISPLAY3 - Display Screen 3 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRINTM        BEGSR

     C                   EVAL      WERROR = 'N'
     C                   EVAL      WImFlg = 'Y'
     C                   CLEAR                   WIMDArr

     C                   IF        #4IMMD1 = *BLANKS and #4IMMD2 <> *BLANKS
     C                   EVAL      OkIMD1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10025'
     C                   EVAL      FldNameArr(Idx) = '#4IMMD1'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF

     C**********         IF        #4IMMD2 = *BLANKS and #4IMMD3 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      OkIMD2 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10024'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMMD2'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        #4IMMD3 = *BLANKS and #4IMMD4 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      OkIMD3 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10023'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMMD3'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        #4IMMD4 = *BLANKS and #4IMMD5 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      OkIMD4 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10022'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMMD4'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        #4IMMD5 = *BLANKS and #4IMMD6 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      OkIMD5 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10021'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMMD5'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        #4IMMD6 = *BLANKS and #4IMMD7 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      OkIMD6 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10020'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMMD6'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        #4IMMD7 = *BLANKS and #4IMMD8 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      OkIMD7 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10019'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMMD7'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
                                                                                             CSW206E
     C                   IF        #4IMMD2 = *BLANKS and #4IMMD3 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      OkIMD2 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10024'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMMD2'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        #4IMMD3 = *BLANKS and #4IMMD4 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      OkIMD3 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10023'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMMD3'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        #4IMMD4 = *BLANKS and #4IMMD5 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      OkIMD4 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10022'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMMD4'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        #4IMMD5 = *BLANKS and #4IMMD6 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      OkIMD5 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10021'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMMD5'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        #4IMMD6 = *BLANKS and #4IMMD7 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      OkIMD6 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10020'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMMD6'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        #4IMMD7 = *BLANKS and #4IMMD8 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      OkIMD7 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10019'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMMD7'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E

     C**********         IF        #4IMMD8 = *BLANKS and #4IMMD9 <> *BLANKS and               209934
     C**********                   WERROR <> 'Y'                                              209934
     C**********         EVAL      OkIMD8 = 'N'                                               209934
     C**********         EVAL      Idx = Idx + 1                                              209934
     C**********         EVAL      MsgIdArr(Idx) = 'SE10018'                                  209934
     C**********         EVAL      FldNameArr(Idx) = '#4IMMD8'                                209934
     C**********         EVAL      WERROR = 'Y'                                               209934
     C**********         ENDIF                                                                209934

      ** Check if Intermediary is valid

     C                   IF        WERROR = 'N'

     C                   MOVEA     WInterMed     @IM
     C                   MOVEA     WSafeAcct     @SA                                          201486
     C                   EVAL      WAGNA = 'Y'                                                201486
     C                   EVAL      WPInterMed = WInterMed
     C                   Z-ADD     1             X                 2 0
     C                   Z-ADD     1             C

     C**********         DOW       X < 10                                                    CSW206D
     C**********         DOW       X < 3                                             CSW206D CSW206E
     C                   DOW       X < 10                                                    CSW206E

     C                   IF        @IM(X) <> *BLANKS
     C                   EVAL      WWIMMD = @IM(X)
     C                   EXSR      SRCUST2
     C                   IF        JFIMMD <> *BLANKS                                          205141
     C                   EVAL      WWIMMD = JFIMMD                                            205141
     C                   ENDIF                                                                205141
     C                   EXSR      SRDOORS                                                    201486
     C                   EVAL      @IM(X) = WWIMMD

     C**********         IF        (@RTCD = 'MIN0244' and WCLAS = 'B') or                     199797
     C**********                   (@RTCD = 'MIN0245' and WCLAS = 'B') or                     199797
     C**********                   (@RTCD = 'MIN0246' and WCLAS = 'B') or                     199797
     C**********                   @RTCD <> *BLANKS or WUnqeFlg = 'Y'                         199797
     C                   IF        (PBICR = 'MIN0246' and WCLAS = 'B') or                     199797
     C                             (@RTCD <> *BLANKS) or (WUnqeFlg = 'Y')                     199797

     C                   MOVE      X             WFldNum
     C     '#4IMMD'      CAT       WFldNum       WFIELD

      ** Select OK flag to set to 'N'

     C                   SELECT
     C                   WHEN      C = 1
     C                   EVAL      OkIMD1 = 'N'
     C                   WHEN      C = 3
     C                   EVAL      OkIMD2 = 'N'
     C**********         WHEN      C = 5                                                     CSW206D
     C**********         EVAL      OkIMD3 = 'N'                                              CSW206D
     C**********         WHEN      C = 7                                                     CSW206D
     C**********         EVAL      OkIMD4 = 'N'                                              CSW206D
     C**********         WHEN      C = 9                                                     CSW206D
     C**********         EVAL      OkIMD5 = 'N'                                              CSW206D
     C**********         WHEN      C = 11                                                    CSW206D
     C**********         EVAL      OkIMD6 = 'N'                                              CSW206D
     C**********         WHEN      C = 13                                                    CSW206D
     C**********         EVAL      OkIMD7 = 'N'                                              CSW206D
     C**********         WHEN      C = 15                                                    CSW206D
     C**********         EVAL      OkIMD8 = 'N'                                              CSW206D
     C**********         WHEN      C = 17                                                    CSW206D
     C**********         EVAL      OkIMD9 = 'N'                                              CSW206D
     C                   WHEN      C = 5                                                     CSW206E
     C                   EVAL      OkIMD3 = 'N'                                              CSW206E
     C                   WHEN      C = 7                                                     CSW206E
     C                   EVAL      OkIMD4 = 'N'                                              CSW206E
     C                   WHEN      C = 9                                                     CSW206E
     C                   EVAL      OkIMD5 = 'N'                                              CSW206E
     C                   WHEN      C = 11                                                    CSW206E
     C                   EVAL      OkIMD6 = 'N'                                              CSW206E
     C                   WHEN      C = 13                                                    CSW206E
     C                   EVAL      OkIMD7 = 'N'                                              CSW206E
     C                   WHEN      C = 15                                                    CSW206E
     C                   EVAL      OkIMD8 = 'N'                                              CSW206E
     C                   WHEN      C = 17                                                    CSW206E
     C                   EVAL      OkIMD9 = 'N'                                              CSW206E
     C                   ENDSL

     C                   EVAL      Idx = Idx + 1
     C                   IF        WUnqeFlg = 'Y'
     C                   EVAL      MsgIdArr(Idx) = 'SE10038'
     C                   ELSE
     C                   EVAL      MsgIdArr(Idx) = 'SE10026'
     C                   ENDIF
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   ENDIF

     C                   ADD       2             C
     C                   ADD       1             X
                                                                                             CSW206E
     C                   IF        CSW206 = 'Y' and X = 3                                    CSW206E
     C                   EVAL      X = 10                                                    CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDDO

     C                   MOVEA     @IM           WInterMed
     C                   MOVEA     @SA           WSafeAcct                                    201486
     C                   MOVEA     @IM           @TA                                          201486
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSAFE - Validate Safekeeping Account                         *
      *                                                               *
      * Called by: SRDISPLAY3 - Display Screen 3 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSAFE        BEGSR

     C                   EVAL      WERROR = 'N'

     C                   IF        #4IMSA1 <> *BLANKS and #4IMMD1 = *BLANKS
     C                   EVAL      OkIMS1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10009'
     C                   EVAL      FldNameArr(Idx) = '#4IMSA1'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF

     C                   IF        #4IMSA2 <> *BLANKS and #4IMMD2 = *BLANKS
     C                   EVAL      OkIMS2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10010'
     C                   EVAL      FldNameArr(Idx) = '#4IMSA2'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF

     C**********         IF        #4IMSA3 <> *BLANKS and #4IMMD3 = *BLANKS                  CSW206D
     C**********         EVAL      OkIMS3 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10011'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMSA3'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        #4IMSA4 <> *BLANKS and #4IMMD4 = *BLANKS                  CSW206D
     C**********         EVAL      OkIMS4 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10012'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMSA4'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        #4IMSA5 <> *BLANKS and #4IMMD5 = *BLANKS                  CSW206D
     C**********         EVAL      OkIMS5 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10013'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMSA5'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        #4IMSA6 <> *BLANKS and #4IMMD6 = *BLANKS                  CSW206D
     C**********         EVAL      OkIMS6 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10014'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMSA6'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        #4IMSA7 <> *BLANKS and #4IMMD7 = *BLANKS                  CSW206D
     C**********         EVAL      OkIMS7 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10015'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMSA7'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        #4IMSA8 <> *BLANKS and #4IMMD8 = *BLANKS                  CSW206D
     C**********         EVAL      OkIMS8 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10016'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMSA8'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D

     C**********         IF        #4IMSA9 <> *BLANKS and #4IMMD9 = *BLANKS                  CSW206D
     C**********         EVAL      OkIMS9 = 'N'                                              CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdArr(Idx) = 'SE10017'                                 CSW206D
     C**********         EVAL      FldNameArr(Idx) = '#4IMSA9'                               CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
                                                                                             CSW206E
     C                   IF        #4IMSA3 <> *BLANKS and #4IMMD3 = *BLANKS                  CSW206E
     C                   EVAL      OkIMS3 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10011'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMSA3'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        #4IMSA4 <> *BLANKS and #4IMMD4 = *BLANKS                  CSW206E
     C                   EVAL      OkIMS4 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10012'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMSA4'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        #4IMSA5 <> *BLANKS and #4IMMD5 = *BLANKS                  CSW206E
     C                   EVAL      OkIMS5 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10013'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMSA5'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        #4IMSA6 <> *BLANKS and #4IMMD6 = *BLANKS                  CSW206E
     C                   EVAL      OkIMS6 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10014'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMSA6'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        #4IMSA7 <> *BLANKS and #4IMMD7 = *BLANKS                  CSW206E
     C                   EVAL      OkIMS7 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10015'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMSA7'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        #4IMSA8 <> *BLANKS and #4IMMD8 = *BLANKS                  CSW206E
     C                   EVAL      OkIMS8 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10016'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMSA8'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   IF        #4IMSA9 <> *BLANKS and #4IMMD9 = *BLANKS                  CSW206E
     C                   EVAL      OkIMS9 = 'N'                                              CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdArr(Idx) = 'SE10017'                                 CSW206E
     C                   EVAL      FldNameArr(Idx) = '#4IMSA9'                               CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDIF                                                               CSW206E

     C                   IF        WERROR = 'N'
                                                                                              199797
     C                   IF        PISOMsg <> 'Y'                                             199797

     C                   MOVEA     WSafeAcct     @SA
     C                   Z-ADD     1             X
     C                   Z-ADD     2             C

     C                   DOW       X < 10

     C                   IF        @SA(X) <> *BLANKS

     C                   MOVE      X             WFldNum

     C                   MOVEL     @SA(X)        WWSKAL
     C                   IF        WWSKAL <> '/'
     C                   EVAL      WERROR = 'Y'
     C     '#4IMSA'      CAT       WFldNum       WFIELD
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5210'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVEL     @SA(X)        WWLI02
     C                   IF        WWLI02 = '//'
     C                   EVAL      WERROR = 'Y'
     C     '#4IMSA'      CAT       WFldNum       WFIELD
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5211'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

     C                   MOVE      @SA(X)        WWLI19
     C                   IF        WWSKAL = '/' and WWLI19 = *BLANKS
     C                   EVAL      WERROR = 'Y'
     C     '#4IMSA'      CAT       WFldNum       WFIELD
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5212'
     C                   EVAL      FldNameArr(Idx) = WFIELD
     C                   ENDIF

      ** Select OK flag to set to 'N'

     C                   IF        WERROR = 'Y'

     C                   SELECT
     C                   WHEN      C = 2
     C                   EVAL      OkIMS1 = 'N'
     C                   WHEN      C = 4
     C                   EVAL      OkIMS2 = 'N'
     C**********         WHEN      C = 6                                                     CSW206D
     C**********         EVAL      OkIMS3 = 'N'                                              CSW206D
     C**********         WHEN      C = 8                                                     CSW206D
     C**********         EVAL      OkIMS4 = 'N'                                              CSW206D
     C**********         WHEN      C = 10                                                    CSW206D
     C**********         EVAL      OkIMS5 = 'N'                                              CSW206D
     C**********         WHEN      C = 12                                                    CSW206D
     C**********         EVAL      OkIMS6 = 'N'                                              CSW206D
     C**********         WHEN      C = 14                                                    CSW206D
     C**********         EVAL      OkIMS7 = 'N'                                              CSW206D
     C**********         WHEN      C = 16                                                    CSW206D
     C**********         EVAL      OkIMS8 = 'N'                                              CSW206D
     C**********         WHEN      C = 18                                                    CSW206D
     C**********         EVAL      OkIMS9 = 'N'                                              CSW206D
     C                   WHEN      C = 6                                                     CSW206E
     C                   EVAL      OkIMS3 = 'N'                                              CSW206E
     C                   WHEN      C = 8                                                     CSW206E
     C                   EVAL      OkIMS4 = 'N'                                              CSW206E
     C                   WHEN      C = 10                                                    CSW206E
     C                   EVAL      OkIMS5 = 'N'                                              CSW206E
     C                   WHEN      C = 12                                                    CSW206E
     C                   EVAL      OkIMS6 = 'N'                                              CSW206E
     C                   WHEN      C = 14                                                    CSW206E
     C                   EVAL      OkIMS7 = 'N'                                              CSW206E
     C                   WHEN      C = 16                                                    CSW206E
     C                   EVAL      OkIMS8 = 'N'                                              CSW206E
     C                   WHEN      C = 18                                                    CSW206E
     C                   EVAL      OkIMS9 = 'N'                                              CSW206E
     C                   ENDSL

     C                   ENDIF

     C                   ENDIF

     C                   ADD       2             C
     C                   ADD       1             X
                                                                                             CSW206E
     C                   IF        CSW206 = 'Y' and X = 3                                    CSW206E
     C                   EVAL      X = 10                                                    CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDDO

     C                   ENDIF                                                                199797
                                                                                              199797
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPSET - Validate Place of Settlement                         *
      *                                                               *
      * Called by: SRDISPLAY3 - Display Screen 3 Details              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRPSET        BEGSR
                                                                                             CSW206E
     C**********         IF        CSW206 = 'Y'                                       CSW206E CSW210
     C                   IF        CSW206 = 'Y' OR PCSW210 = 'Y'                              CSW210
     C                   EVAL      #4PSET = #4PSET1                                          CSW206E
     C                   ENDIF                                                               CSW206E

     C                   EVAL      WImFlg = 'Y'
     C                   IF        #4PSET <> *BLANKS

     C                   EVAL      WWIMMD = #4PSET
     C                   EVAL      WPPSET = #4PSET
     C                   EXSR      SRCUST2
     C                   EVAL      #4PSET = WWIMMD

     C**********         IF        (@RTCD = 'MIN0244' and WCLAS = 'B') or                     199797
     C**********                   (@RTCD = 'MIN0245' and WCLAS = 'B') or                     199797
     C**********                   (@RTCD = 'MIN0246' and WCLAS = 'B') or                     199797
     C**********                   @RTCD <> *BLANKS                                           199797
     C                   IF        (PBICR = 'MIN0246' and WCLAS = 'B') or                     199797
     C                             (@RTCD <> *BLANKS)                                         199797
     C                   EVAL      OkPSET = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10031'
     C                   EVAL      FldNameArr(Idx) = #4PSET
     C                   ENDIF

     C                   ENDIF
                                                                                             CSW206E
     C**********         IF        CSW206 = 'Y'                                       CSW206E CSW210
     C                   IF        CSW206 = 'Y' OR PCSW210 = 'Y'                              CSW210
     C                   EVAL      #4PSET1 = #4PSET                                          CSW206E
     C                   ENDIF                                                               CSW206E

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
     C                   IF        @IM(X) = @TA(X) and @SA(X) = *BLANKS and                   201486
     C                             WAGNA <> 'N'                                               201486
     C                   EVAL      WAGNA = *BLANKS                                            201486
     C                   ELSE                                                                 201486
     C                   EVAL      WAGNA = WAGNA                                              201486
     C                   ENDIF                                                                201486
                                                                                              201486
     C                   IF        @RTCD = *BLANKS and @SA(X) = *BLANKS and                   201486
     C                             WCLAS = 'C' and WWIMMD <> *BLANKS and                      201486
     C                             WAGNA <> *BLANKS                                           201486
                                                                                              201486
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
     C                   EVAL      @SA(X) = PSKALRef                                          201486
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
      * SRUPDATE - Update Add'l Standard Settlement Instructions      *
      *                                                               *
      * Called by: SRMAIN - Program Main Processing                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRUPDATE      BEGSR

     C**********         IF        SABCH = *BLANKS AND SACUST = 0 AND                         199797
     C**********                   SABK = *BLANKS AND SACCY = *BLANKS AND                     199797
     C**********                   SAINV = *BLANKS AND SAPREF = *BLANKS                       199797

     C                   EVAL      SABCH   = #6BRCA
     C                   MOVE      #6CUST        SACUST
     C                   EVAL      SABK    = #6BOOK
     C                   EVAL      SACCY   = #6CCY
     C                   EVAL      SAMKT   = #6MKCT                                           CSE034
     C                   EVAL      SAINV   = #6INVT
     C                   EVAL      SAPREF  = #6PTFR

     C**********         ENDIF                                                                199797

      ** Move screen 1 fields to file

     C**********         IF        PBFCLAS = 'I' or PCBInd = 'B'                              205663
     C                   IF        PCBInd = 'B'                                               205663
     C                   EVAL      SAAWIN = #0AWIN
     C                   EVAL      SAAWIL = #0AWIL
     C                   EVAL      SAAFPN = #0AFPN
     C                   EVAL      SAAFPL = #0AFPL
     C                   EVAL      SABOFN = #0BOFN
     C                   EVAL      SABOF1 = #0BOF1
     C                   EVAL      SABOF2 = #0BOF2
     C                   EVAL      SASRL1 = #0SRL1
     C                   EVAL      SASRL2 = #0SRL2
     C                   EVAL      SASRL3 = #0SRL3
     C                   EVAL      SANAC1 = #0NAC1
     C                   EVAL      SANAC2 = #0NAC2
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
     C                   EVAL      SADIDN  = @DEBTR1                                          CSW210
     C                   EVAL      SADLIN  = @DACNT1                                          CSW210
     C                   EVAL      SADAD1  = @DADDR1                                          CSW210
     C                   EVAL      SADAD2  = @DADDR2                                          CSW210
     C                   EVAL      SADAD3  = @DADDR3                                          CSW210
     C                   EVAL      SADAD4  = @DADDR4                                          CSW210
     C                   ENDIF                                                                CSW210

     C                   ELSE

     C                   EVAL      SAAWIN = #0AWIN                                            205663
     C                   EVAL      SAAWIL = #0AWIL                                            205663
     C                   EVAL      SAAFPN = #0AFPN                                            205663
     C                   EVAL      SAAFPL = #0AFPL                                            205663
     C                   EVAL      SABOFN = #0BOFN                                            205663
     C                   EVAL      SABOF1 = #0BOF1                                            205663
     C                   EVAL      SABOF2 = #0BOF2                                            205663
     C                   EVAL      SASRL1 = #0SRL1                                            205663
     C                   EVAL      SASRL2 = #0SRL2                                            205663
     C                   EVAL      SASRL3 = #0SRL3                                            205663
     C                   EVAL      SANAC1 = #0NAC1                                            205663
     C                   EVAL      SANAC2 = #0NAC2                                            205663
                                                                                              CSW210
     C                   IF        PCSW210 = 'Y'                                              CSW210
     C                   EVAL      SADIDN  = @DEBTR1                                          CSW210
     C                   EVAL      SADLIN  = @DACNT1                                          CSW210
     C                   EVAL      SADAD1  = @DADDR1                                          CSW210
     C                   EVAL      SADAD2  = @DADDR2                                          CSW210
     C                   EVAL      SADAD3  = @DADDR3                                          CSW210
     C                   EVAL      SADAD4  = @DADDR4                                          CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EVAL      SAGMES = #1GMES
     C                   EVAL      SAINST = #1INST
     C                   EVAL      SAINSS = #1INSS
     C                   EVAL      SARPTY = #1RPTY
     C                   EVAL      SAGDEL = #1GDEL
     C                   EVAL      SASROL = #1SROL
     C                   EVAL      SAFIND = #1FIND

     C**********         IF        *IN28 = *ON                                                199797
     C                   EVAL      SASTMP = #1STMP
     C                   EVAL      SACHID = #1CHID
     C                   EVAL      SATRRM = #1TRRM
     C**********         ENDIF                                                                199797

      ** Move screen 2 fields to file

     C                   IF        *IN10 = *ON
     C                   EVAL      SACCTN = #2CCTN
     C                   EVAL      SADRSN = #2DRSN
     C                   EVAL      SADRS1 = #2DRS1
     C                   EVAL      SADRS2 = #2DRS2
     C                   EVAL      SADRS3 = #2DRS3
     C                   EVAL      SADRS4 = #2DRS4
     C                   EVAL      SAFIN1 = #2FIN1
     C                   EVAL      SAFIN2 = #2FIN2
     C**********         EVAL      SARED1 = #2RED1                                            CSW210
     C**********         EVAL      SARED2 = #2RED2                                            CSW210
     C                   EVAL      SANAS1 = #2NAS1
     C                   EVAL      SANAS2 = #2NAS2

     C                   ELSE

     C                   EVAL      SACCTN = #3CCTN
     C                   EVAL      SADRSN = #3DRSN
     C                   EVAL      SADRS1 = #3DRS1
     C                   EVAL      SADRS2 = #3DRS2
     C                   EVAL      SADRS3 = #3DRS3
     C                   EVAL      SADRS4 = #3DRS4
     C                   EVAL      SABSSN = #3BSSN
     C                   EVAL      SABSS1 = #3BSS1
     C                   EVAL      SABSS2 = #3BSS2
     C                   EVAL      SAFIN1 = #3FIN1
     C                   EVAL      SAFIN2 = #3FIN2
     C**********         EVAL      SARED1 = #3RED1                                            CSW210
     C**********         EVAL      SARED2 = #3RED2                                            CSW210
     C                   EVAL      SANAS1 = #3NAS1
     C                   EVAL      SANAS2 = #3NAS2

     C                   ENDIF

      ** Move screen 3 fields to file

     C                   EVAL      SAIMD1 = #4IMMD1
     C                   EVAL      SAIMD2 = #4IMMD2
     C**********         EVAL      SAIMD3 = #4IMMD3                                          CSW206D
     C**********         EVAL      SAIMD4 = #4IMMD4                                          CSW206D
     C**********         EVAL      SAIMD5 = #4IMMD5                                          CSW206D
     C**********         EVAL      SAIMD6 = #4IMMD6                                          CSW206D
     C**********         EVAL      SAIMD7 = #4IMMD7                                          CSW206D
     C**********         EVAL      SAIMD8 = #4IMMD8                                          CSW206D
     C**********         EVAL      SAIMD9 = #4IMMD9                                          CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      SAIMD3 = #4IMMD3                                          CSW206E
     C                   EVAL      SAIMD4 = #4IMMD4                                          CSW206E
     C                   EVAL      SAIMD5 = #4IMMD5                                          CSW206E
     C                   EVAL      SAIMD6 = #4IMMD6                                          CSW206E
     C                   EVAL      SAIMD7 = #4IMMD7                                          CSW206E
     C                   EVAL      SAIMD8 = #4IMMD8                                          CSW206E
     C                   EVAL      SAIMD9 = #4IMMD9                                          CSW206E
     C                   ENDIF                                                               CSW206E
     C                   EVAL      SAIMS1 = #4IMSA1
     C                   EVAL      SAIMS2 = #4IMSA2
     C**********         EVAL      SAIMS3 = #4IMSA3                                          CSW206D
     C**********         EVAL      SAIMS4 = #4IMSA4                                          CSW206D
     C**********         EVAL      SAIMS5 = #4IMSA5                                          CSW206D
     C**********         EVAL      SAIMS6 = #4IMSA6                                          CSW206D
     C**********         EVAL      SAIMS7 = #4IMSA7                                          CSW206D
     C**********         EVAL      SAIMS8 = #4IMSA8                                          CSW206D
     C**********         EVAL      SAIMS9 = #4IMSA9                                          CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      SAIMS3 = #4IMSA3                                          CSW206E
     C                   EVAL      SAIMS4 = #4IMSA4                                          CSW206E
     C                   EVAL      SAIMS5 = #4IMSA5                                          CSW206E
     C                   EVAL      SAIMS6 = #4IMSA6                                          CSW206E
     C                   EVAL      SAIMS7 = #4IMSA7                                          CSW206E
     C                   EVAL      SAIMS8 = #4IMSA8                                          CSW206E
     C                   EVAL      SAIMS9 = #4IMSA9                                          CSW206E
                                                                                             CSW206E
     C                   EVAL      SAPSET = #4PSET                                           CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      SAPSET = #4PSET1                                          CSW206E
     C                   ENDIF                                                               CSW206E

     C**********         EVAL      SAPSET = #4PSET                                           CSW206E
     C                   IF        PCSW210 = 'Y'                                              CSW210
     C                   EVAL      SAPSET = #4PSET1                                           CSW210
     C                   EVAL      SAPCLR = #4PCL1                                            CSW210
     C                   EVAL      SAQFIN = #4QFI1                                            CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      SAPSET = #4PSET                                            CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EVAL      SARED1 = #4RED1                                            CSW210
     C                   EVAL      SARED2 = #4RED2                                            CSW210

     C                   ENDIF

     C                   EVAL      PMode = 'R'

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRETURN - Return to Calling Program                          *
      *                                                               *
      * Called by: SRMAIN - Program Main Processing                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRRETURN      BEGSR

     C                   EVAL      WINIT = ' '
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
      * Called by: SRDBAD                                             *                     AR570983
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
     C     ' '           CHECK     FLD:X#                                                   AR570983
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
     C**********         IF        *IN90 = *ON                                     AR570983 AR579600
     C                   IF        %FOUND                                                   AR579600
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
      * Called by: SRDBAD                                             *                     AR570983
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
     C                   Move      'Y'           AD#3              1                        AR570983
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
      * Called by: SRDBAD                                             *                     AR570983
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
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Parameters

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
      ** Customer/Book Description
      ** Additional Detail Type
      ** Customer/Book Indicator
      ** ISO15022 message indicator

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
     C                   PARM                    PISOMsg

      ** Rundate

     C                   PARM                    PBJMRDT

      ** Customer Classification

     C                   PARM                    PBFCLAS

      ** ERI
      ** SWIFT 1998 changes
      ** BIC Database Plus
      ** ISO15022 Data Export                                                                 209247
      ** SWIFT 2010 changes                                                                   CSW210
      ** IBAN                                                                                 CSW210

     C                   PARM                    PCSW014
     C                   PARM                    PCSW098
     C                   PARM                    PCFT007
     C                   PARM                    PCSE029                                      209247
     C                   PARM                    CSW206            1                         CSW206E
     C                   PARM                    PCSW210                                      CSW210
     C                   PARM                    PCFT004                                      CSW210
     C                   PARM                    PCSW202                                    AR325342

      ** Input/Output DS (PF/STDADSED)

     C                   PARM                    PDepot

      ** Return Code

     C                   PARM                    RetCodeOut

      ** Move workstation ID to screen field.

     C                   MOVEL     PsUser        #5USER
     C                   MOVEL     PsJobName     #5WSID
     C                   MOVEL     PBJMRDT       #5RUNA

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

     C                   EVAL      *IN97 = *ON
     C                   EVAL      DDPGMQ = '*'

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

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @Z0
00000000000000000000000000000000000000000000000000000000
**  VA0  - All Numeric Chars
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
**  VA1  - INSTRUCTIONS TYPE VALIDATIONS (ALPAHABETIC)
INTBRIEXT#####################
**  Alpha - Array of alphabetic characters                                                    CSW210
ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                    CSW210
**  Numeric - Array of numeric characters                                                     CSW210
0123456789                                                                                    CSW210
