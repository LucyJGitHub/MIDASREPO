     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT FT001000 n & Formatting for 50F')             *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT001000  - FT Validation and Formatting for 50F             *
      *                                                               *
      *  Function:  This module accepts Customer Number, Message Type *
      *             for the access of Outgoing message management     *
      *             table via AOOUFMR0. The output coming from the    *
      *             table will be validated by this module and once   *
      *             valid will be formatted using available details   *
      *             for Customer Details file, Additional Customer    *
      *             Details file, Country Code etc.                   *
      *             It checks whether all fields are valid and if     *
      *             not returns error messages to the calling process.*
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CMG008             Date 20Feb20               *
      *                 MD050730           Date 25Nov19               *
      *                 CER050             Date 16Jun19               *
      *                 MD037229           Date 03Sep18               *
      *                 MD046248           Date 27Oct17               *
      *                 CSW216             Date 14Mar16               *
      *                 MD037941           Date 25May16               *
      *                 MD036262           Date 28Oct15               *
      *                 MD034516           Date 26May15               *
      *                 CSW215             Date 06Apr15               *
      *                 AR874231           Date 25Nov11               *
      *                 AR845543           Date 25Nov14               *
      *                 CER070             Date 19Aug14               *
      *                 CSW214             Date 25Nov14               *
      *                 CGL132             Date 01May13               *
      *                 CFT050             Date 03Jun13               *
      *                 CLE134             Date 01Aug12               *
      *                 CRE075             Date 06Dec10               *
      *                 263378             Date 29Dec09               *
      *                 BUG26795           Date 25Nov09               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260033             Date 14May09               *
      *                 BUG26229           Date 29Sep09               *
      *                 BUG26127           Date 29Sep09               *
      *                 BUG26183           Date 25Sep09               *
      *                 BUG25973           Date 17Sep09               *
      *                 BUG26154           Date 23Sep09               *
      *                 BUG26129           Date 22Sep09               *
      *                 BUG26053           Date 17Sep09               *
      *                 BUG26043           Date 16Sep09               *
      *                 BUG26024           Date 15Sep09               *
      *                 BUG25101           Date 03Sep09               *
      *                 BUG25894           Date 09Sep09               *
      *                 BUG25893           Date 04Sep09               *
      *                 BUG25848           Date 04Sep09               *
      *                 BUG25356           Date 06Aug09               *
      *                 BUG25721           Date 28Aug09               *
      *                 BUG25689           Date 21Aug09               *
      *                 BUG25323           Date 05Aug09               *
      *                 BUG24666           Date 30Jun09               *
      *                 BUG24555           Date 26Jun09               *
      *                 BUG24509           Date 25Jun09               *
      *                 BUG24554           Date 24Jun09               *
      *                 BUG25028           Date 21Jul09               *
      *                 BUG24601           Date 26Jun09               *
      *                 BUG24490           Date 22Jun09               *
      *                 BUG24657           Date 29Jun09               *
      *                 BUG24466           Date 06Aug09               *
      *                 BUG24352           Date 16Jun09               *
      *                 BUG24297           Date 17Jun09               *
      *                 BUG25000           Date 17Jul09               *
      *                 BUG24617           Date 30Jun09               *
      *                 BUG24614           Date 02Jul09               *
      *                 BUG24643           Date 30Jun09               *
      *                 CSW209             Date 01Apr09               *
      *                 257786             Date 18Nov08               *
      *                 256834             Date 30Sep08               *
      *                 252903             Date 25Apr08               *
      *                 252910             Date 20Feb08               *
      *                 252878             Date 19Feb08               *
      *                 BUG24150           Date 01Apr09               *
      *                 255628A            Date 30Oct08               *
      *                 257938             Date 28Nov08               *
      *                 257361             Date 12Nov08               *
      *                 252494             Date 21Jan09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG21064           Date 15Sep08               *
      *                 BUG21024           Date 11Sep08               *
      *                 BUG21276           Date 07Oct08               *
      *                 BUG21178           Date 23Sep08               *
      *                 BUG21029           Date 11Sep08               *
      *                 CSW208             Date 15Apr08               *
      *                 BUG15149A          Date 12Nov07               *
      *                 BUG15250           Date 06Nov07               *
      *                 BUG15178           Date 30Oct07               *
      *                 BUG15209           Date 02Nov07               *
      *                 BUG15252           Date 06Nov07               *
      *                 BUG15185           Date 29Oct07               *
      *                 BUG15124           Date 26Oct07               *
      *                 BUG15149           Date 25Oct07               *
      *                 BUG15090           Date 24Oct07               *
      *                 BUG15081           Date 23Oct07               *
      *                 BUG15065           Date 21Oct07               *
      *                 BUG15045           Date 19Oct07               *
      *                 BUG15010           Date 17Oct07               *
      *                 BUG15035           Date 17Oct07               *
      *                 250804A            Date 11Oct07               *
      *                 BUG15003           Date 12Oct07               *
      *                 250600             Date 05Oct07               *
      *                 BUG14893           Date 24Sep07               *
      *                 BUG14856           Date 14Sep07               *
      *                 BUG14755           Date 31Aug07               *
      *                 BUG14593           Date 12Aug07               *
      *                 CSW207A            Date 26Jul07               *
      *                 CSW207  *CREATE    Date 07Jun07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD050730 - Output 1/ and 2/ depending on the current setup   *
      *             of system value Fld50FAddCustDtl                  *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD037229 - Remove the validation of town after ISO code in   *
      *             first occurrence of 3/                            *
      *           - Applied for MD-51750                              *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  MD037941 - Invalid ISO country code used in code 3           *
      *  MD036262 - MT103 field 50F has incomplete data               *
      *  MD034516 - Allow entry of ISO code without town/country on   *
      *             1st occurence of code 3 when previous code is 1   *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  AR874231 - If the ordering customer is a swift BIC, it       *
      *             might be unlinked to a Midas customer; only       *
      *             access customer details if there is a linked      *
      *             customer. (Child: AR874232)                       *
      *  AR845543 - Check all characters from the 3rd character to    *
      *             the last position of the line for codes 1/ and 2/ *
      *             (Child: AR845544)                                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  263378 - CSW209: IP FT input ends up with database error.    *
      *           skip validation when BIC entered does not have      *
      *           corresponding record in customers file.             *
      *  BUG26795 - APISERVER creates a DUMP and no transactions      *
      *             were processed                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  260033 - Warning message for Telex is switchable.            *
      *  BUG26229 - 50K format is rejected in Ordering customer field *
      *             even if OMFM is set to W                          *
      *  BUG26127 - Transaction with an invalid format for ordering   *
      *             customer was allowed                              *
      *  BUG26183 - Reverse fix for BUG26154                          *
      *  BUG25973 - When Ordering Customer L1 is equal to valid IBAN  *
      *             without slash followed by 1/, 6/, 6/ the system   *
      *             accepts the transaction                           *
      *  BUG26154 - Expected Error Message did not encounter          *
      *  BUG26129 - FTS0081 error message not displayed.              *
      *  BUG26053 - 50K formatted instead of 50F                      *
      *  BUG26043 - Repeated code 8 / must be rejected                *
      *  BUG26024 - Error message FTS0008 is misleading               *
      *  BUG25101 - CSW209 FDS2.01 Changes                            *
      *  BUG25894 - Error message appeared is not the expected        *
      *  BUG25893 - Error message should be returned                  *
      *             even if OMFM flag is set to 'W'.                  *
      *  BUG25848 - Warning appeared in a valid trasaction            *
      *  BUG25356 - Repeated code 2/ is not accepted                  *
      *  BUG25721 - Incorrect error message displayed                 *
      *  BUG25689 - ISO country code is incorrect in 5/               *
      *  BUG25323 - Error message is incorrect                        *
      *  BUG24666 - Incorrect CUST/ formatting                        *
      *  BUG24555 - Code word DRLC-EMPL-CUST with blank issuing       *
      *             authority was not rejected                        *
      *  BUG24509 - Embedded slash - Issuer Code is invalid.          *
      *  BUG24554 - Line no6 with blank issuing authority was not     *
      *             rejected.                                         *
      *  BUG25028 - Difference in the value of line "6/" Subfield 2   *
      *             of 50F and subfield 1 which used "CUST/" as ID    *
      *             type                                              *
      *  BUG24601 - Code 6/ generated value is incorrect.             *
      *  BUG24490 - 2/ is accepted without 3/.                        *
      *  BUG24657 - Wrong 50F format generated                        *
      *  BUG24466 - Invalid Format for Line#6 was not rejected.       *
      *  BUG24352 - Applied missing fix of BUG21064.                  *
      *  BUG24297 - Each lines can have several '/' whatever the      *
      *             first digit in the line                           *
      *  BUG25000 - Unexpected warning message issued.                *
      *  BUG24617 - 8/ can be used if first line starts with a SWIFT  *
      *             code.                                             *
      *  BUG24614 - OMFM Sequence against Ordering Customer Codes     *
      *             matching validation.                              *
      *  BUG24643 - Incorrect 8/ error message                        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  257786 - :50F: cannot be formated for 1st line starting      *
      *           by / if issuer country code is blanks               *
      *  256834 - Check for other field formats in OMFM.              *
      *  252903 - SDCUST and WSWCD is not being populated when there  *
      *           is no additional customer details.                  *
      *  252910 - When using 50F format on ordering customer field:   *
      *           prevent validating Lines 2 - 5 of the ordering      *
      *           customer when OMFM tag is 'O' optional              *
      *  252878 - 50F validation is enforced even when OMFM flag is   *
      *           optional. Retrieve OMFM data prior to input         *
      *           validation.                                         *
      *  BUG24150 - Embedded '/' for 2/ and 3/ will be allowed.       *
      *  255628A- 50K is generated when no additional customer        *
      *           details.  Applied fix 251920 and 252366.            *
      *  257938 - Incorrect validation for ordering customer for 50K  *
      *           case with 8/F (8th floor).                          *
      *  257361 - Warning message ('Warning: network TELEX must be    *
      *           defined in Standing data') appears for Settlement   *
      *           type '02' (cheques)                                 *
      *  252494   - Allow syntax '1/ Customer ..' on IP Ord Cust.     *
      *             where 3rd character is BLANK. This was accepted   *
      *             pre SWIFT 2007                                    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG21064 - OMFM 2/ 4/ validation error                       *
      *  BUG21024 - 50K generated for MT103                           *
      *           - Applied fixed of BUG21024A                        *
      *  BUG21024A - 50K generated for MT103 (Reopen)                 *
      *  BUG21276 - Applied fix 19193 and 19193A                      *
      *  BUG19193A - No validation done on 3/                         *
      *  BUG19193 - No validation done on 3/                          *
      *  BUG21178 - FTS0052: ERROR-Message not found                  *
      *  BUG21029 - Incorrect message ID used in 50F validation       *
      *             program                                           *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *  BUG15149A - Retrieve SDMMODPD value first before validate.   *
      *  BUG15250 - Incorrect :50: format in MT102                    *
      *  BUG15178 - No validation to check the line with 4/ in a 50F  *
      *  BUG15209 - The customer number is not defined in the ACUD    *
      *             but still generates 50F format                    *
      *  BUG15252 - Include error message for identification type     *
      *             SOSE and TXID validation.                         *
      *  BUG15185 - Wrong extraction of country in format 5/          *
      *  BUG15124 - Invalid input of 50F is accepted                  *
      *  BUG15149 - DBASE 001 as SDRETLPD is empty.                   *
      *  BUG15090 - Incomplete MT101 details if ordering customer     *
      *             came from the details.                            *
      *  BUG15081 - Customer swift ID as ordering customer become     *
      *             blank after completion.                           *
      *             Update missing annotations for CSW207A            *
      *  BUG15065 - Error for SOSE identification type                *
      *  BUG15045 - Missing Ordering Customer field in MT103          *
      *  BUG15010 - Warning message to be displayed in                *
      *             Incoming Payment                                  *
      *  BUG15035 - The system accepts wrong input for                *
      *             Ordering Customer field                           *
      *  250804A - Fix error on CSW207                                *
      *  BUG15003 - Incorrect error message                           *
      *  250600 - Fix error on CSW207                                 *
      *  BUG14893 - Error in using Corporate BEI field                *
      *  BUG14856 - Missing/blank data is allowed in                  *
      *             "Ordering Customer" format                        *
      *  BUG14755 - MT 101 generated is 50H for retail number under   *
      *             ordering customer                                 *
      *  BUG14593 - Swift 2007 error in SP08                          *
      *  CSW207A - Swift 2007 Standard Changes                        *
      *  CSW207 - Swift 2007 Standard Changes                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * Midas SD Identification Types
     FSDIDTPL1  IF   E           K Disk    INFSR(*PSSR)
      * Midas SD Identification Types - index by IDSWCD
     FSDIDTPL2  IF   E           K Disk    INFSR(*PSSR)
     F                                     Rename(SDIDTPD0:SDIDTPD2)
     F                                     Prefix(ID2)
      * Midas SD Identification Types - index by IDSWCD
     FSDCUSTL1  IF   E           K Disk    INFSR(*PSSR)
     F                                     Prefix(L1)
      * Midas ME SWIFT ISO Country - index by M3ISOC
     FMEISOCL0  IF   E           K Disk    INFSR(*PSSR)
      * Midas GL Account details                                                             CSW207A
     FACCNTL6   IF   E           K Disk                                                      CSW207A
      * Midas GL Account details                                                             CSW207A
     FSDNAHOl1  IF   E           K Disk                                                      CSW207A

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

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

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

      * Constant to hold input parameter for AOSVALR0.                                        260033
     D PSysVal1        C                   Const('Network Telex')                             260033
     D PSysVal2        C                   Const('Fld50FAddCustDtl')                        MD050730
                                                                                              260033
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D IdCode          S              4    DIM(9) CTDATA PERRCD(9)                            250600
      ** Input Parameters
     D PMReturnCode    S              7A
     D PMMsgID         S              7A
     D PMErrType       S              1A
     D PMValType       S              4A
     D PMInpParm1      S             35A
     D PMInpParm2      S             35A
     D PMInpParm3      S             35A
     D PMInpParm4      S             35A
     D PMInpParm5      S             35A
     D PMInpType       S              1A
     D PMAccount       S             34A
     D PMCustNo        S              6A
     D PMNonAcctHldr   S             10A
     D PMNetwork       S              6A
     D PMMsgType       S              3A
     D PMMsgTag        S              5A
     D PMCountry       S              2A
     D PMBranch        S              3A
     D PMBranch4A      S              4A
     D PMCurrCode      S              3A
     D PMNostro        S              2A
     D PMModInd        S              2A
     D PMOutParm1      S             35A
     D PMOutParm2      S             35A
     D PMOutParm3      S             35A
     D PMOutParm4      S             35A
     D PMOutParm5      S             35A
     D PMCountryP      S              2A                                                      250600
     D PMBranchP       S              3A                                                      250600
     D PMCcyCode       S              3A                                                      250600
     D PMNostroP       S              2A                                                      250600
      ** Input Parameters for access objects
     D PMAcct          S             10A
     D PMAcctSeq       S              2A
     D PMAccCode       S              4A
     D PMAction        S             10A
     D PMAction2       S             10A
     D PMCtry4A        S              4A
     D PMCustNo10A     S             10A
     D PMCustSName     S             10A
     D PMISOC          S              2A
     D PMMidasDate     S              5P 0
     D PMOption        S              7A
     D PMPNostro       S              1A
     D PMRetail        S             10A
     D PMSAR           S              6A
     D PMStatus        S              7A
     D PMYYYYMMDD      S              8S 0
     D PMYMDRetC       S              1A
      ** Program variables
     D CFT004          S              1A
     D CSW024          S              1A
     D CSW207          S              1A
     D CSW208          S              1A                                                      CSW208
     D PRTCD           S              7A                                                      CSW208
     D CSW209          S              1A                                                      CSW209
     D CSW215          S              1A                                                      CSW215
     D WBlankCol       S              1A
     D WChar1to1       S              1A
     D WCNA1           S             70A
     D WCNA2           S             70A
     D WCNA3           S             35A
     D WCNA4           S             35A
     D WCNA2Flag       S              1A
     D WCode           S              4A
     D WContinue       S              1A
     D WStr            S              5S 0
     D WLen            S              5S 0
     D WCtr            S              2S 0
     D WCtr01          S              2S 0
     D WCtr02          S              2S 0
     D WCtr03          S              3S 0
     D WCtr04          S              3S 0
     D WDummy          S             35A
     D WFirst          S              1A
     D WIBAN           S             34A
     D WIBEI           S             11A
     D WInpNCode       S              1A
     D Fld50F          S              1A                                                    MD050730

     D*WInpParm********S*            35A                                                    BUG25101
     D WInpParm        S             70A                                                    BUG25101
     D WParm1          S             35A
     D WParm2          S             35A
     D WParm3          S             35A
     D WParm4          S             35A
     D WParm5          S             35A
     D WParmSav        S             35A                                                    BUG25101
     D Line8           S             35A                                                    BUG25101
     D CtrSwf67        S              1S 0                                                  BUG25101

     D WNostroFlag     S              1A
     D WSlash1         S              1A
     D WSlash2         S              1A
     D WSlash3         S              1A
     D WSlashCtr       S              1S 0
     D WSlashFlag      S              1A
     D WTRANFlag       S              1A

     D WNCode          S              1A
     D WNCodeN         S              1S 0                                                    CSW209
     D WNDesc          S              1A
     D WSwiftCode      S              4A
     D WISOCode        S              2A
     D WISODesc        S              1A
     D WIssFlag        S              1A
     D WIssDesc        S              1A
     D W#ISOC          S              2A                                                     CSW207A
     D W#Curr          S              3A                                                    BUG14593
     D W#Nostro        S              2A                                                    BUG14593
     D WMsgID          S              7A   INZ(*BLANKS)                                     BUG14856

     D WOrgValType     S              4A

     D WIDTP           S              2A
     D WISCD           S             35A
     D WISOC           S              2A
     D WLN             S             35A
     D WLN1            S            150A
     D WLN2            S            150A
     D WMTag           S              5A
     D WNAHOFlag       S              1A
     D WOMFLAGA        S              1A
     D WOMFLAGF        S              1A
     D WPrevNCode      S              1A
     D WNextNCode      S              1A                                                    BUG25323
     D WPrevC          S              1A                                                      CSW215
     D WNextC          S              1A                                                      CSW215
     D CtrN3           S              1S 0                                                    CSW215
     D WPtr            S              3S 0
     D WPtr1           S              3S 0
     D WPtr2           S              3S 0
     D WPtr3           S              3S 0
     D WPtr4           S              3S 0
     D WINUM           S              3S 0                                                  BUG24555
     D WRetailFlag     S              1A
     D WSWCD           S              4A
     D WSWCDSave       S              4A                                                      250600
     D WExcsLine       S              1S 0                                                  BUG15045
     D WExcsLine1      S             35A                                                    BUG15045
     D WExcsLine6      S             35A                                                      CSW209
     D WExcsLine7      S             35A                                                      CSW209
     D WExcsLine3      S              1A                                                      CSW215
     D WSlash          S              1A
     D WStr01          S              3S 0
     D Idx             S              2S 0
     D Ndx             S              2S 0
     D WYYYYMMDD       S              8A                                                     CSW207A
     D WSwiftFlag      S              1A                                                     CSW207A
     D W#Accnt         S             34A                                                    BUG14755
     D W_WIsoCoLc      S              2A                                                      250600
     D W_CIsoCoLc      S              2A                                                      250600
     D W_CIsoCitz      S              2A                                                    BUG15045
     D C_CIsoCoLc      S              2A                                                      250600
     D CustIssuer      S             20A                                                      250600
     D FromOtherDtl    S              1A                                                      250600
     D W_IBEI          S             35A                                                      250600
     D W_NIDN          S             35A                                                      250600
     D W_CUST          S             35A                                                      250600
     D W_NAHO          S             35A                                                      250600
     D W#Cust          S              6A                                                      250600
                                                                                              250600
     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)                          250600
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)                          250600
     D IBCHK1          S              1                                                       250600
     D IBCHK2          S              1                                                       250600
     D IBCTY1          S              1                                                       250600
     D IBCTY2          S              1                                                       250600
     D ACISOC          S              2                                                     BUG15185
     D NHISOC          S              2                                                     BUG25689
                                                                                              CSW209
     D BDDayNo         S              5P 0                                                    CSW209
                                                                                            BUG24614
     D varInput1       S              4A                                                    BUG24614
     D varInput2       S              2A                                                    BUG24614
     D varInput3       S              2A                                                    BUG24614
     D varInput4       S              2A                                                    BUG24614
     D varInput5       S              2A                                                    BUG24614
     D WISOChk         S              1A                                                    MD034516

     D PSysVal01       S             20A                                                      260033
     D PCurSet01       S            200A                                                      260033
     D PSysVal02       S             20A                                                      260033
     D PCurSet02       S            200A                                                      260033
     D PSysVal03       S             20A                                                      260033
     D PCurSet03       S            200A                                                      260033
     D PSysVal04       S             20A                                                      260033
     D PCurSet04       S            200A                                                      260033
     D PSysVal05       S             20A                                                      260033
     D PCurSet05       S            200A                                                      260033
     D PSysVal06       S             20A                                                      260033
     D PCurSet06       S            200A                                                      260033
     D PSysVal07       S             20A                                                      260033
     D PCurSet07       S            200A                                                      260033
     D PSysVal08       S             20A                                                      260033
     D PCurSet08       S            200A                                                      260033
     D PSysVal09       S             20A                                                      260033
     D PCurSet09       S            200A                                                      260033
     D PSysVal10       S             20A                                                      260033
     D PCurSet10       S            200A                                                      260033
                                                                                              260033
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Temporary array
     D wSeqArr         S              1S 0 DIM(5)

      ** Input parameter for ZDATE10                                                          CSW209
     D                 DS                                                                     CSW209
     D PDateIn                 1      8  0                                                    CSW209
                                                                                              CSW209
      ** Parameters for ZDATE10                                                               CSW209
      *(PDateIn)                                                                              CSW209
     D PMDNO           S              5P 0                                                    CSW209
                                                                                              CSW209
     D SDRETL        E DS                  Extname(SDRETLPD)
     D**QQACD1**     E                     ExtFld(QQACCD)                                     250600
     D MEOUFM        E DS                  Extname(MEOUFMPD)
     D AI_MEOUFM     E DS                  Extname(MEOUFMPD)
     D                                     Prefix(AI_)
     D SDACCT        E DS                  Extname(ACCNTAB)
     D SDACUS        E DS                  Extname(SDACUSPD)
     D W_SDACUS      E DS                  Extname(SDACUSPD)
     D                                     Prefix(W_)
     D SDCUST        E DS                  Extname(SDCUSTPD)
     D W_SDCUST      E DS                  Extname(SDCUSTPD)
     D                                     Prefix(W_)
      * Customer details of the branch passed as parameter                                    250600
     D B_SDCUST      E DS                  Extname(SDCUSTPD)                                  250600
     D                                     Prefix(B_)                                         250600
      * Customer details of the branch linked to the customer                                 250600
     D C_SDCUST      E DS                  Extname(SDCUSTPD)                                  250600
     D                                     Prefix(C_)                                         250600
      * Customer details parameter ME1400                                                   BUG15045
     D D_SDCUST      E DS                  Extname(SDCUSTPD)                                BUG15045
     D                                     Prefix(D_)                                       BUG15045
      * Counterparty Nostro parameter ME1400                                                BUG15045
     D SDCNST        E DS                  Extname(SDCNSTPD)                                BUG15045
      *                                                                                     BUG15045
      * BIC directory parameter ME1400                                                      BUG15045
     D MEBICD        E DS                  Extname(MEBICDPD)                                BUG15045
      *                                                                                     BUG15045
     D SDCSSW        E DS                  Extname(SDCSSWPD)
      * Detail of branch passsed as parameter                                                 250600
     D SDBRCH        E DS                  Extname(SDBRCHPD)
     D  QQDFA1       E                     ExtFld(QQDFAC)
      * Detail of branch linked to the customer                                               250600
     D C_SDBRCH      E DS                  Extname(SDBRCHPD)                                  250600
     D                                     Prefix(C_)                                         250600
     D  C_QQDFA1     E                     ExtFld(QQDFAC)                                     250600
      ** Externally described DS for Bank details                                             CSW209
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CSW209
      *                                                                                     BUG15149
      ** Midas SD Midas modules Data Structure                                              BUG15149
      *                                                                                     BUG15149
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                BUG15149
     D SDLOCN        E DS                  Extname(SDLOCNPD)
     D SDCTRY        E DS                  Extname(SDCTRYPD)
     D SDNAHO        E DS                  Extname(SDNAHOPD)
     D SDNOST        E DS                  Extname(SDNOSTPD)
     D  QQACC1       E                     ExtFld(QQACCD)                                     250600
     D SDNWRK        E DS                  Extname(SDNWRKPD)
     D SDMTAG        E DS                  Extname(SDMTAGPD)
     D DSFDY         E DS                  Extname(DSFDY)
     D DSLDY         E DS                  Extname(DSLDY)
     D DSSDY         E DS                  Extname(DSSDY)
      ** External DS for bank details

     D OMF1            DS
     D  F1C1                         15A
     D  F1C2                         15A
     D  F1C3                         15A
     D  F1C4                         15A
     D  F1C5                         15A
     D OMF2            DS
     D  F2C1                         15A
     D  F2C2                         15A
     D  F2C3                         15A
     D  F2C4                         15A
     D  F2C5                         15A
     D OMF3            DS
     D  F3C1                         15A
     D  F3C2                         15A
     D  F3C3                         15A
     D  F3C4                         15A
     D  F3C5                         15A
     D OMF4            DS
     D  F4C1                         15A
     D  F4C2                         15A
     D  F4C3                         15A
     D  F4C4                         15A
     D  F4C5                         15A
     D OMF5            DS
     D  F5C1                         15A
     D  F5C2                         15A
     D  F5C3                         15A
     D  F5C4                         15A
     D  F5C5                         15A
     D WOMF            DS
     D  WFC1                         15A
     D  WFC2                         15A
     D  WFC3                         15A
     D  WFC4                         15A
     D  WFC5                         15A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *Inzsr  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *
      ** Validate validation type against Swift 2007
      *
     C                   If        CSW207 = 'N'
     C                   Select

     C                   When      PMValType = 'OMFM'
     C                   Eval      PMMsgID = 'FTS0016'
     C**********         Eval      PMErrType = 'E'                                           250804A

     C                   When      PMValType = 'TRAN'
     C                             Or PMValType = 'FRMT'
     C                   Eval      PMMsgID = 'FTS0016'
     C**********         Eval      PMErrType = 'E'                                           250804A

     C                   EndSL

     C                   Else

     C                   Eval      WSaveCode = ' '                                           CSW207A
     C                   Eval      WSaveInp = 'A'                                            CSW207A
                                                                                             CSW207A
     C                   Select

     C                   When      PMValType = 'OMFM'

     C                   Exsr      SRVOMFM
     C                   Return

     C                   When      PMValType = 'TRAN'
      *                                                                                     BUG25000
      ** Exit 50F validation program if input is equal to MT202                             BUG25000
      *                                                                                     BUG25000
     C                   IF        PMInpParm1 = 'MT202'                                     BUG25000
     C                   EVAL      PMReturnCode = '*ERROR'                                  BUG25000
     C                   EVAL      *INLR = *ON                                              BUG25000
     C                   RETURN                                                             BUG25000
     C                   ENDIF                                                              BUG25000
                                                                                            BUG25000
     C                   ExSr      ValSwiftMEOUFM                                             252910
     C                   EVAL      PMReturnCode  = *BLANKS                                  BUG25848
     C                   EVAL      PMMsgID = *BLANKS                                        BUG25848
     C                   EVAL      PMErrType  = *BLANKS                                     BUG25848
     C                   Exsr      Val50F                                                   BUG15045
     C                   Eval      WOrgValType = 'TRAN'
     C                   Exsr      ValInputType
     C                   If        PMInpType = ' '                                          BUG15045
     C                             OR PMInpType = 'A'                                       BUG15045
     C                             And WContinue = 'Y'                                      BUG15045
     C                   Eval      PMOutParm1 = PMInpParm1                                  BUG15045
     C                   Eval      PMOutParm2 = PMInpParm2                                  BUG15045
     C                   Eval      PMOutParm3 = PMInpParm3                                  BUG15045
     C                   Eval      PMOutParm4 = PMInpParm4                                  BUG15045
     C                   Eval      PMOutParm5 = PMInpParm5                                  BUG15045
     C                   EndIf                                                              BUG15045

     C                   When      PMValType = 'FRMT'
     C                   Eval      WOrgValType = 'FRMT'
     C                   Exsr      ValInputType
     C                   If        PMInpType = ' '                                           CSW207A
     C                             OR PMInpType = 'A'                                         250600
     C                             And WContinue = 'Y'                                       CSW207A
     C                   Eval      PMOutParm1 = PMInpParm1                                   CSW207A
     C                   Eval      PMOutParm2 = PMInpParm2                                   CSW207A
     C                   Eval      PMOutParm3 = PMInpParm3                                   CSW207A
     C                   Eval      PMOutParm4 = PMInpParm4                                   CSW207A
     C                   Eval      PMOutParm5 = PMInpParm5                                   CSW207A
     C                   EndIf                                                               CSW207A

     C                   EndSL

     C                   If        WContinue = 'N'
     C**********                   OR PMMsgID <> *Blanks                           BUG25101 BUG26127
     C                             OR PMMsgID = 'FTS0079'                                   BUG26127
     C                             AND WOrgValType <> 'FRMT'                                BUG26053
     C                             OR PMMsgID = 'FTS0080'                                   BUG26127
     C                             AND WOrgValType <> 'FRMT'                                BUG26127

     C**********         If        PMErrType = 'W'                                          BUG14856
     C**********                   And WOrgValType = 'FRMT'                                 BUG14856
     C**********         Eval      PMReturnCode = *Blanks                                   BUG14856
     C**********         Else                                                               BUG14856
     C                   Eval      PMReturnCode = '*ERROR'
     C**********         EndIf                                                              BUG14856

     C                   Else
     C                   Eval      PMReturnCode = *Blanks
     C                   EndIf

     C                   EndIf

     C                   If        PMReturnCode = *Blanks                                    CSW207A
     C                             And WOrgValType = 'FRMT'                                  CSW207A
     C                             And PMOutParm1 = *Blanks                                  CSW207A
     C                             And PMOutParm2 = *Blanks                                  CSW207A
     C                             And PMOutParm3 = *Blanks                                  CSW207A
     C                             And PMOutParm4 = *Blanks                                  CSW207A
     C                             And PMOutParm5 = *Blanks                                  CSW207A
     C                   Eval      PMReturnCode = '*ERROR'                                   CSW207A
     C                   EndIf                                                               CSW207A
      *                                                                                       CSW208
      ** SWIFT 2008 Changes                                                                   CSW208
      *                                                                                       CSW208
     C                   IF        CSW208 = 'Y'                                               CSW208
     C**********                   AND PMReturnCode = *BLANKS                        CSW208 BUG26154
     C                             AND PMReturnCode = *BLANKS                               BUG26183
     C**********                   AND PMErrType <> 'E'                            BUG26154 BUG26183
     C                             AND PMOutParm1 <> *BLANKS                                  CSW208
     C                             AND %SUBST(PMInpParm2:2:1) = '/'                           CSW208
      *                                                                                       CSW208
      ** If 1st line ordering customer is '/' get OMFM flag                                   CSW208
      *                                                                                       CSW208
     C                   IF        %SUBST(PMInpParm1:1:1) = '/'                               CSW208
     C                             AND WOrgValType = 'TRAN'                                   CSW208
     C                   EVAL      WSwiftCode = '/'                                           CSW208
     C                   EXSR      ValSwiftMEOUFM                                             CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
      ** Validate 2nd line of Ordering Customer, must start by 1/                             CSW208
      *                                                                                       CSW208
     C                   IF        %SUBST(PMInpParm2:1:1) <> '1'                              CSW208
     C                   EVAL      PMMsgID = 'FTS0056'                                        CSW208
      *                                                                                       CSW209
      ** Swift 2009 Changes                                                                   CSW209
     C                   If        (PMMsgType = '202' Or                                      CSW209
     C                             PMMsgType = '205') And                                     CSW209
     C                             CSW209 = 'Y'                                               CSW209
     C                   EVAL      PMErrType = 'E'                                            CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   EVAL      PMReturnCode='*ERROR'                                      CSW208
     C                   EXSR      SetError                                                   CSW208
     C                   IF        PMModInd = 'IN'                                          BUG26127
     C                             Or PMModInd = 'BI'                                       BUG26127
     C                             Or PMModInd = 'RI'                                       BUG26127
     C                   EVAL      PMErrType = 'W'                                          BUG26127
     C                   ELSE                                                               BUG26127
     C                   EVAL      PMErrType = 'E'                                          BUG25893
     C                   ENDIF                                                              BUG26127
      *                                                                                       CSW208
      ** If OMFM flag = 'O' send Warning message                                              CSW208
      *                                                                                       CSW208
     C                   IF        WOMFLAGF = 'O'                                             CSW208
     C                   EVAL      PMMsgID = 'FTS0057'                                        CSW208
     C                   EVAL      PMErrType = 'W'                                            CSW208
     C                   ENDIF                                                                CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
      ** No Action to be done if OMFM Flag equals to 'O'                                    BUG14856
     C                   If        WOMFLAGF = 'O'                                           BUG14856
     C                             And WOrgValType = 'TRAN'                                 BUG14856
     C                             And PMMsgID <> *Blanks                                   BUG14856
      *                                                                                       CSW208
      ** Send Warning message if FTS0057                                                      CSW208
      *                                                                                       CSW208
     C                             AND PMMsgID <> 'FTS0057'                                   CSW208
     C                   Eval      PMErrType = *Blanks                                      BUG14856
     C                   Eval      PMReturnCode = *Blanks                                   BUG14856
     C                   Eval      PMMsgID  = *Blanks                                       BUG14856
     C                   EndIf                                                              BUG14856
     C                   If        WMsgID <> *Blanks                                        BUG14856
     C                             And PMMsgID <> *Blanks                                   BUG14856
     C                   Eval      PMMsgID  = WMsgID                                        BUG14856
     C                   EndIf                                                              BUG14856
      ** Restore customer number if non-account holder                                       CSW207A
     C**********         If        PMInpType = 'O'                                           CSW207A
     C                   If        W#Cust <> *Blanks                                         CSW207A
     C                   Movel     W#Cust        PMCustNo                                    CSW207A
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
      ** Send error if SWIFT code is not setup                                              BUG15010
     C                   If        PMMsgID = 'FTS0055' And                                  BUG15010
     C                             WSwiftFlag = 'N'                                         BUG15010
     C                   Eval      PMReturnCode = '*ERROR'                                  BUG15010
     C                   Exsr      SetError                                                 BUG15010
     C                   EndIf                                                              BUG15010
                                                                                            BUG15010
     C                   Eval      *INLR = *ON
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      * Process - Process FRMT                                        *
      *****************************************************************
     C     ProcessFRMT   BegSR
      *
      **  Validate ID type
      *
     C                   Exsr      ValIDType
      *
      **  Initialize defaults
      *
     C                   Exsr      InitDefaults
      *
      **  Call AOUMFR0 for ACOUNTIBAN
      *
     C                   Eval      PMAction = 'ACOUNTIBAN'
     C                   Eval      PMOption = '*KEY  '
     C                   Exsr      ValAOOUFMR0
      *
      **  Call AOUMFR0 for FORMAT
      *
     C                   If        PMReturnCode <> '*NRF'
     C                             And PMReturnCode <> '*ERROR'

     C                   Eval      PMAction = '*FORMAT'
     C                   Eval      PMOption = '*KEY  '
     C                   Exsr      ValAOOUFMR0

     C                   If        PMReturnCode <> '*NRF'
     C                             And PMReturnCode <> '*ERROR'
      *
      **  Check Outgoing Message input
      *
     C                   If        WContinue = 'Y'

     C                   Exsr      ValFRMTParm

     C                   EndIf

     C                   EndIf

     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * InitDefaults - Initiliase defaults                            *
      *****************************************************************
     C     InitDefaults  BegSR

     C                   Eval      PMReturnCode = *Blanks
     C                   Eval      PMMsgID = *Blanks
     C                   Eval      PMErrType = *Blanks
     C                   Eval      PMOutParm1 = *Blanks
     C                   Eval      PMOutParm2 = *Blanks
     C                   Eval      PMOutParm3 = *Blanks
     C                   Eval      PMOutParm4 = *Blanks
     C                   Eval      PMOutParm5 = *Blanks

     C                   Eval      WContinue = 'Y'
     C                   Eval      WNAHOFlag = 'N'
     C                   Eval      WRetailFlag = 'N'
      *
      ** Get Branch code
      *
     C                   If        PMBranch = *Blanks
     C**********         If        PMInpType = 'I'                                    CSW207A 250600
     C                   If        PMAccount <> *Blanks                                       250600
     C                   Eval      PMBranch = %Subst(PMAccount:1:3)
     C                   EndIf                                                               CSW207A
     C                   If        PMBranch = *Blanks
     C                   Eval      PMBranch = W_BBBRCD
     C                   EndIf
     C                   EndIf
      *
      ** Validate Branch code
      *
     C**********         If        PMInpType <> *Blanks                             CSW207A BUG14593
     C                   If        PMBranch <> *Blanks
     C                   Call      'AOBRCHR1'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*KEY'        PMOption
     C                   Parm                    PMBranch
     C     SDBRCH        Parm      SDBRCH        DSLDY

     C                   If        PMReturnCode <> *Blanks
     C                   EVAL      PMMsgID = 'RFV0027'                                      BUG26795
     C                   EVAL      PMErrType = 'E'                                          BUG26795
     C                   EVAL      PMReturnCode = '*ERROR'                                  BUG26795
     C                   SETON                                        LR                    BUG26795
     C                   RETURN                                                             BUG26795
     C**********         Eval      DbFile = 'SDBRCHPD'                                      BUG26795
     C**********         Eval      Dbase  = 09                                              BUG26795
     C**********         Exsr      *PSSR                                                    BUG26795

     C                   Else
     C                   Movel(P)  A8BICN        @KEY1                                        250600
     C                   CALL      'AOCUSTR1'                                                 250600
     C                   PARM      '*BLANKS'     @RTCD             7                          250600
     C                   PARM      '*KEY   '     PMOption                                     250600
     C                   PARM                    @KEY1            10                          250600
     C                   PARM      *BLANKS       @KYST             7                          250600
     C     B_SDCUST      PARM      B_SDCUST      DSLDY                                        250600
      *                                                                                       250600
     C                   If        A8LCCD <> *Blanks
     C                   Call      'AOLOCNR0'
     C                   Parm      *BLANKS       PMReturnCode
     C                   Parm      '*KEY   '     PMOption
     C                   Parm                    A8LCCD
     C     SDLOCN        Parm      SDLOCN        DSLDY

     C                   If        PMReturnCode <> *Blanks
     C                   Eval      DbFile = 'SDLOCNPD'
     C                   Eval      Dbase  = 09
     C                   Exsr      *PSSR
     C                   EndIf

     C                   EndIf

     C                   EndIf

     C**********         EndIf                                                              BUG14593
      *
     C                   Eval      PMBranch4A = PMBranch
      *
     C                   If        A8LCCD <> *Blanks
     C                   Eval      PMISOC = DVCNCD
     C                   Else
     C**********         Eval      PMISOC = W_BBCOLC                                          250600
     C                   Eval      PMISOC = B_BBCOLC                                          250600
     C                   EndIf
      *
     C                   Exsr      GetISOCode
     C                   EndIf                                                               CSW207A
      *
      ** Set default and validate network
      *
     C**********         If        PMNetwork = *Blanks                                      BUG15045
     C**********         Eval      PMNetwork = 'SWIFT'                                      BUG15045
     C**********         EndIf                                                              BUG15045
                                                                                            BUG15045
     C**********         If        PMNetwork = 'PAPER'                               BUG15045 257361
     C**********         Eval      PMNetwork =  'TELEX'                              BUG15045 257361
     C**********         EndIf                                                       BUG15045 257361

     C                   Call      'AONWRKR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*KEY'        PMOption
     C                   Parm                    PMNetwork
     C     SDNWRK        Parm      SDNWRK        DSLDY
                                                                                              260033
      ** Access Midas System values via access program                                        260033
     C                   CALLB     'AOSVALR0'                                                 260033
     C                   PARM      *BLANKS       PRtCd                                        260033
     C                   PARM      PSysVal1      PSysVal01                                    260033
     C                   PARM                    PCurSet01                                    260033
     C**********         PARM                    PSysVal02                           260033 MD050730
     C                   PARM      PSysVal2      PSysVal02                                  MD050730
     C                   PARM                    PCurSet02                                    260033
     C                   PARM                    PSysVal03                                    260033
     C                   PARM                    PCurSet03                                    260033
     C                   PARM                    PSysVal04                                    260033
     C                   PARM                    PCurSet04                                    260033
     C                   PARM                    PSysVal05                                    260033
     C                   PARM                    PCurSet05                                    260033
     C                   PARM                    PSysVal06                                    260033
     C                   PARM                    PCurSet06                                    260033
     C                   PARM                    PSysVal07                                    260033
     C                   PARM                    PCurSet07                                    260033
     C                   PARM                    PSysVal08                                    260033
     C                   PARM                    PCurSet08                                    260033
     C                   PARM                    PSysVal09                                    260033
     C                   PARM                    PCurSet09                                    260033
     C                   PARM                    PSysVal10                                    260033
     C                   PARM                    PCurSet10                                    260033
                                                                                              260033

     C**********         If        PMReturnCode <> *Blanks                                    260033
     C                   If        PMReturnCode <> *Blanks and PCurSet01 = 'Y'                260033
     C**********         Eval      DbFile = 'SDNWRKPD'                                       250804A
     C**********         Eval      Dbase  = 10                                               250804A
     C**********         Exsr      *PSSR                                                     250804A
     C                   Eval      PMMsgID  = 'FTS0053'                                      250804A
     C                   Eval      PMErrType = 'W'                                           250804A
     C                   Eval      PMReturnCode = '*ERROR'                                   250804A
     C                   Eval      *INLR = *ON                                               250804A
     C                   Return                                                              250804A
     C                   EndIf
                                                                                            MD050730
     C                   IF        PRtCd <> *BLANKS                                         MD050730
     C                   EVAL      DbFile = 'SDSVALPD'                                      MD050730
     C                   EVAL      Dbase  = 19                                              MD050730
     C                   EXSR      *PSSR                                                    MD050730
     C                   ELSE                                                               MD050730
     C                   EVAL      Fld50F = PCurSet02                                       MD050730
     C                   ENDIF                                                              MD050730
      *
      ** Set default and validate message tag
      *
     C                   If        PMMsgTag = *Blanks
     C                   Eval      PMMsgTag =  ':50F:'
     C                   EndIf

     C                   Call      'AOMTAGR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*KEY'        PMOption
     C                   Parm                    PMMsgTag
     C                   Parm                    PMMsgType
     C     SDMTAG        Parm      SDMTAG        DSLDY

     C                   If        PMReturnCode <> *Blanks
     C**********         Eval      DbFile = 'SDMTAGPD'                                       250804A
     C**********         Eval      Dbase  = 09                                               250804A
     C**********         Exsr      *PSSR                                                     250804A
     C                   Eval      PMMsgID  = 'FTS0054'                                      250804A
     C                   Eval      PMErrType = 'W'                                           250804A
     C                   Eval      PMReturnCode = '*ERROR'                                   250804A
     C                   Eval      *INLR = *ON                                               250804A
     C                   Return                                                              250804A
     C                   EndIf

     C**********         If        PMCountry = *Blanks                                        250600
     C**********         If        PMNostro <> *Blanks                                        250600
     C**********                   And PMCurrCode <> *Blanks                                  250600
     C**********         Eval      PMCountry = W_BBCOLC                                       250600
     C**********         EndIf                                                                250600
     C**********         EndIf                                                                250600
      *
     C                   If        PMCountry = *Blanks
     C                   Eval      PMCountry = WISOC
     C                   EndIf
      *
     C                   If        PMCountry = *Blanks                                        250600
     C                   If        PMNonAcctHldr <> *Blanks
     C                   Eval      PMISOC    = NHCOLC                                         250600
     C                   Exsr      GetISOCode                                                 250600
     C**********         Eval      PMCountry = NHCOLC                                         250600
     C                   Eval      PMCountry = WISOC                                          250600
     C                   EndIf
     C                   EndIf                                                                250600

     C                   Eval      PMCtry4A = PMCountry
      *                                                                                       250600
     C                   Eval      P@IBAN = *Blanks                                           250600
      *                                                                                       250600
     C                   IF        CFT004 = 'Y'                                               250600
     C                   IF        @@SLASH = '/' and PMInpType = 'C'                          250600
     C                             or @@SLASH = '/' and PMInpType = 'S'                       250600
     C                                and PMCustNo   <> *Blanks                               250600
     C                             Or @@SLASH = '/' and PMInpType = 'A'                       250600
     C                   EVAL      PIBAN = %SUBST(PMInpParm1:2:34)                            250600
      *                                                                                       250600
     C                   CALL      'AOIBANR3'                                                 250600
     C                   PARM                    @Rcode            7                          250600
     C                   PARM                    PIBAN            47                          250600
     C                   PARM                    POWith           47                          250600
     C     P@IBAN        PARM                    PONobl           34                          250600
      *                                                                                       250600
      ** If first four characters are 'AANN', proceed with IBAN                               250600
      ** validation.                                                                          250600
      *                                                                                       250600
     C                   EVAL      IBCTY1 = %SUBST(P@IBAN:1:1)                                250600
     C                   EVAL      IBCTY2 = %SUBST(P@IBAN:2:1)                                250600
     C                   EVAL      IBCHK1 = %SUBST(P@IBAN:3:1)                                250600
     C                   EVAL      IBCHK2 = %SUBST(P@IBAN:4:1)                                250600
     C     IBCTY1        LOOKUP    Alpha                                  94                  250600
     C   94IBCTY2        LOOKUP    Alpha                                  94                  250600
     C   94IBCHK1        LOOKUP    Numeric                                94                  250600
     C   94IBCHK2        LOOKUP    Numeric                                94                  250600
      *                                                                                       250600
     C                   IF        *IN94 = *ON                                                250600
      *                                                                                       250600
     C                   CALL      'AOIBANR5'                           90                    250600
     C                   PARM      *BLANKS       @Rcode                                       250600
     C                   PARM                    P@IBAN           34                          250600
      *                                                                                       250600
     C                   IF        *IN90 = *OFF AND @Rcode = *BLANKS                          250600
     C                   Else                                                                 250600
     C                   Eval      P@IBAN = *Blanks                                           250600
     C                   ENDIF                                                                250600
     C                   ENDIF                                                                250600
     C                   ENDIF                                                                250600
     C                   ENDIF                                                                250600

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * InitPgmVar - Initialise program variables                     *
      *****************************************************************
     C     InitPgmVar    BegSR

     C                   Eval      WCode = *Blanks
     C                   Eval      WContinue = 'Y'
     C                   Eval      WCNA2Flag = 'N'
     C                   Eval      WFirst = 'Y'
     C                   Eval      WIBAN = *Blanks
     C                   Eval      WISOCode = *Blanks
     C                   Eval      WPrevNCode = *Blanks
     C                   Eval      WSlash = 'N'
     C                   Eval      PMOutParm1 = *Blanks
     C                   Eval      PMOutParm2 = *Blanks
     C                   Eval      PMOutParm3 = *Blanks
     C                   Eval      PMOutParm4 = *Blanks
     C                   Eval      PMOUtParm5 = *Blanks

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValOutMsgFile - Validate input parameters on MEOUFMPD         *
      *****************************************************************
     C     ValAOOUFMR0   BegSR

     C**********         Eval      W#Nostro = *Blanks                                BUG14593 250600
     C**********         Eval      W#Curr = *Blanks                                  BUG14593 250600
     C**********         If        PMOption = '*NEXT'                                BUG14593 250600
      ***save*parameters                                                             BUG14593 250600
     C**********         Eval      W#Nostro = PMNostro                               BUG14593 250600
     C**********         Eval      W#Curr = PMCurrCode                               BUG14593 250600
     C**********         Eval      PMBranch4A = OMSBRC                               BUG14593 250600
     C**********         Eval      PMCtry4A = OMCTRY                                 BUG14593 250600
     C**********         Eval      PMCurrCode = OMCURR                               BUG14593 250600
     C**********         Eval      PMNostro = OMNOST                                 BUG14593 250600
     C**********         Endif                                                       BUG14593 250600
      **********                                                                     BUG14593 250600
      *                                                                                       CSW209
      ** If PMMsgType = '202' or '205', the Ordering Customer (Cover)                         CSW209
      ** will not be validated against OMFM table.                                            CSW209
      *                                                                                       CSW209
     C                   If        (PMMsgType = '202' Or                                      CSW209
     C                             PMMsgType = '205') And                                     CSW209
     C                             CSW209 = 'Y'                                               CSW209
     C                   Eval      PMReturnCode = '*NRF'                                      CSW209
     C                   Else                                                                 CSW209
     C                   Call      'AOOUFMR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm                    PMOption
     C                   Parm                    PMNetwork
     C                   Parm                    PMMsgType
     C                   Parm                    PMMsgTag
     C                   Parm                    PMBranch4A
     C                   Parm                    PMCtry4A
     C                   Parm                    PMCurrCode
     C                   Parm                    PMNostro
     C                   Parm                    PMAction
     C     MEOUFM        Parm      MEOUFM        DSSDY
     C                   EndIf                                                                CSW209
      *                                                                                       250600
      ** If no record found at first call,                                *NRF                250600
      ** If at least one record is found, but none can be used formatting *EOF                250600
      ** If a record is found,                                            *BLANKS             250600
      ** IF error found                                                   *ERROR              250600
      *                                                                                       250600

     C                   If        PMReturnCode = '*NRF'
     C                             Or PMReturnCode = '*ERROR'

     C                   If        PMAction <> 'ACOUNTIBAN'                                   250600
     C**********         Eval      PMMsgID   = 'FTS0016'                                      250600
      *                                                                                       250600
      ** If no record is found, it is not a blocking error, that only means that no           250600
      ** formating must be process for this type of conbination                               250600
      *                                                                                       250600
     C**********         Eval      PMErrType = 'E'                                            250600
     C                   Eval      PMErrType = ' '                                            250600
     C                   Eval      WSwiftFlag = 'Y'                                         BUG15045
      *                                                                                       250600
      ** even if not formatting is requesting it, a full address must be tested to be valid   250600
      ** or not to let know the calling process  if an error occurs in the formating          250600
      ** (TRAN) or if a 50F has to be formatted or not during message generation  (FRMT)      250600
      *                                                                                       250600
     C                   If        PMInpType <> 'A'                                           250600
     C                             And PMInpType <> ' '                                     BUG15003
     C                   Eval      WContinue = 'N'
     C                   Endif                                                                250600
     C                   ELSE                                                                 250600
     C                   Eval      PMReturnCode = *Blanks                                     250600
     C                   Eval      WOMFLAGA = 'O'                                             250600
     C                   EndIf                                                                250600

     C                   Else

     C                   If        PMReturnCode <> '*EOF'                                   BUG14856
     C                   If        PMAction = 'ACOUNTIBAN'
     C                   Eval      WOMFLAGA = OMFLAG
     C                   Eval      AI_MEOUFM = MEOUFM
      * Decrease the level of requirement of IBAN for non FT Modules as no account are set    250600
      * for non FT Module                                                                     250600
     C                   If        PMModInd <> 'FT'                                           250600
     C                             and PMModInd <> 'IN'                                     BUG25973
     C                             and PMModInd <> 'OP'                                     BUG25973
     C                             and PMModInd <> 'BI'                                     BUG25973
     C                             and PMModInd <> 'BO'                                     BUG25973
     C                             and PMModInd <> 'RI'                                     BUG25973
     C                             and PMModInd <> 'RO'                                     BUG25973
     C                             and OMFLAG = 'M'                                           250600
     C**********         Eval      OMFLAG = 'W'                                      250600 BUG15045
     C                   Eval      OMFLAG = 'O'                                             BUG15045
     C                   EndIf                                                                250600
     C                   Else
     C                   Eval      WOMFLAGF = OMFLAG
     C                   EndIf
     C                   Else                                                                 250600
      *                                                                                       250600
      * If at least a definition has been found but no formating has been found               250600
      * send error/warning if required, flag to be used is the one of the previous call       250600
      *                                                                                       250600
     C                   If        WOMFLAGF  = 'W'                                            250600
     C                             or WOMFLAGF  = 'E'                                         250600
     C                   Eval      PMErrType = WOMFLAGF                                       250600
     C                   Eval      PMMsgID   = 'FTS0016'                                      250600
     C**********         Eval      PMReturnCode = '*ERROR'                         BUG15045 BUG15081
     C                   EndIf                                                                250600
     C                   EndIf                                                              BUG14856

     C                   EndIf

     C**********         If        W#Curr <> *Blanks                                 BUG14593 250600
     C**********                   Or W#Nostro <> *Blanks                            BUG14593 250600
      ***restore*parameters                                                          BUG14593 250600
     C**********         Eval      PMCurrCode = W#Curr                               BUG14593 250600
     C**********         Eval      PMNostro = W#Nostro                               BUG14593 250600
     C**********         EndIf                                                       BUG14593 250600
      **********                                                                     BUG14593 250600
     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValCustomer - Validate customer number                        *
      *****************************************************************
     C     ValCustomer   BegSR

     C                   Call      'AOACUSR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*KEY'        PMOption
     C                   Parm                    PMCustNo
     C     SDACUS        Parm      SDACUS        DSLDY

     C**********         If        PMReturnCode <> *Blanks                                   255628A
     C**********         Eval      PMReturnCode = '*ERROR'                                   255628A
     C**********         Eval      PMMsgID = 'FTS0041'                               CSW207A 255628A
     C**********         Exsr      SetError                                          CSW207A 255628A
     C**********         Eval      PMErrType = 'W'                                  BUG15045 255628A
     C**********         Eval      PMMsgID = 'FTS0002'                                       CSW207A
     C**********         Eval      DbFile = 'SDACUSPD'                                       CSW207A
     C**********         Eval      Dbase  = 02                                               CSW207A
     C**********         Exsr      *PSSR                                                     CSW207A

     C**********         Else                                                                255628A
      *
     C                   If        PMReturnCode <> *Blanks                                   255628A
     C                   Clear                   SDACUS                                      255628A
     C                   EndIf                                                               255628A
      *                                                                                      255628A
     C                   Eval      W_SDACUS = SDACUS
                                                                                            BUG15185
     C                   Eval      PMISOC = E5BTHC                                          BUG15185
     C                   Exsr      GetISOCode                                               BUG15185
     C                   Eval      ACISOC = WISOC                                           BUG15185
                                                                                            BUG15185
     C                   Exsr      GetCustDtls
     C                   Eval      WIDTP = E5IDTP
      *
     C**********         EndIf                                                               255628A
                                                                                              252903
     C                   If        W_SDCUST =  *Blanks                                        252903
     C                   Exsr      GetCustDtls                                                252903
     C                   EndIf                                                                252903

      *                                                                                    BUG21024A
      ** Customer with no Additional Customer details can output 50F                       BUG21024A
      *                                                                                    BUG21024A
     C                   If        PMReturnCode <> *Blanks                                 BUG21024A
     C                   Movel     PMCustNo      @KEY1                                     BUG21024A
     C                   CALL      'AOCUSTR1'                                              BUG21024A
     C                   PARM      '*BLANKS'     @RTCD             7                       BUG21024A
     C                   PARM      '*KEY   '     PMOption                                  BUG21024A
     C                   PARM                    @KEY1            10                       BUG21024A
     C                   PARM      *BLANKS       @KYST             7                       BUG21024A
     C     SDCUST        PARM      SDCUST        DSLDY                                     BUG21024A
      *                                                                                    BUG21024A
     C                   If        @RTCD = *Blanks                                         BUG21024A
     C                   Eval      PMReturnCode = *Blanks                                  BUG21024A
     C                   EVal      PMMsgID = *Blanks                                       BUG21024A
     C                   Eval      PMErrType = *Blanks                                     BUG21024A
     C                   Eval      WContinue = *Blanks                                     BUG21024A
     C                   Eval      WCtr01 = 00                                             BUG21024A
     C                   Exsr      GetCustDtls                                             BUG21024A
     C                   Endif                                                             BUG21024A
     C                   Endif                                                             BUG21024A
      *                                                                                    BUG21024A
     C                   If        W_BBBRCD   <> *Blanks                                      250600
     C                   Call      'AOBRCHR1'                                                 250600
     C                   Parm      *Blanks       PMReturnCode                                 250600
     C                   Parm      '*KEY'        PMOption                                     250600
     C                   Parm                    BBBRCD                                       250600
     C     C_SDBRCH      Parm      C_SDBRCH      DSLDY                                        250600
      *                                                                                       250600
     C                   If        PMReturnCode <> *Blanks                                    250600
     C                   EVAL      PMMsgID = 'RFV0027'                                      BUG26795
     C                   EVAL      PMErrType = 'E'                                          BUG26795
     C                   EVAL      PMReturnCode = '*ERROR'                                  BUG26795
     C                   SETON                                        LR                    BUG26795
     C                   RETURN                                                             BUG26795
     C**********         Eval      DbFile = 'SDBRCHPD'                               250600 BUG26795
     C**********         Eval      Dbase  = 10                                       250600 BUG26795
     C**********         Exsr      *PSSR                                             250600 BUG26795
      *                                                                                       250600
     C                   Else                                                                 250600
     C                   Movel(P)  C_A8BICN      @KEY1                                        250600
     C                   CALL      'AOCUSTR1'                                                 250600
     C                   PARM      '*BLANKS'     @RTCD                                        250600
     C                   PARM      '*KEY   '     PMOption                                     250600
     C                   PARM                    @KEY1                                        250600
     C                   PARM      *BLANKS       @KYST                                        250600
     C     C_SDCUST      PARM      C_SDCUST      DSLDY                                        250600
      *                                                                                       250600
     C                   If        C_A8LCCD <> *Blanks                                        250600
     C                   Call      'AOLOCNR0'                                                 250600
     C                   Parm      *BLANKS       PMReturnCode                                 250600
     C                   Parm      '*KEY   '     PMOption                                     250600
     C                   Parm                    C_A8LCCD                                     250600
     C     SDLOCN        Parm      SDLOCN        DSLDY                                        250600
      *                                                                                       250600
     C                   If        PMReturnCode <> *Blanks                                    250600
     C                   Eval      DbFile = 'SDLOCNPD'                                        250600
     C                   Eval      Dbase  = 09                                                250600
     C                   Exsr      *PSSR                                                      250600
     C                   EndIf                                                                250600
      *                                                                                       250600
     C                   EndIf                                                                250600
      *                                                                                       250600
     C                   EndIf                                                                250600
      *                                                                                       250600
     C                   If        C_A8LCCD <> *Blanks                                        250600
     C                   Eval      PMISOC = DVCNCD                                            250600
     C                   Else                                                                 250600
     C                   Eval      PMISOC = C_BBCOLC                                          250600
     C                   EndIf                                                                250600
      *                                                                                       250600
     C                   Exsr      GetISOCode                                                 250600
     C                   Eval      C_CIsoCoLc = WISOC                                         250600
      *                                                                                       250600
     C                   EndIf                                                                250600
                                                                                              250600
     C                   Eval      PMISOC = W_BBCOLC                                          250600
     C                   Exsr      GetISOCode                                                 250600
     C                   Eval      W_CIsoCoLc = WISOC                                         250600
      *                                                                                       250600
     C                   Eval      PMISOC = W_BBCNCZ                                        BUG15045
     C                   Exsr      GetISOCode                                               BUG15045
     C                   Eval      W_CIsoCitz = WISOC                                       BUG15045
      *                                                                                     BUG15045
     C                   EVAL      W_IBEI = *BLANKS                                           250600
     C                   EVAL      W_NIDN = *BLANKS                                           250600
     C                   EVAL      W_CUST = *BLANKS                                           250600
      *                                                                                       250600
     C                   If        CSW209 <> 'Y'                                              CSW209
     C                   If        CSIBEI <> *Blanks                                          250600
     C                   Eval      W_IBEI = 'IBEI/'                                           250600
     C                             + %Trim(CSIBEI)                                            250600
     C                   EndIf                                                                250600
     C                   EndIf                                                                CSW209
      *                                                                                       250600
      * NIDN can be set either in specific field xxIDNO or in Tax iD if required by           250600
      * tax authorities                                                                       250600
     C                   If        W_E5IDNO <> *Blanks                                        250600
     C**********         Eval      W_NIDN = 'NIDN/' + W_CIsoCoLc + '/'               250600 BUG15045
     C                   Eval      W_NIDN = 'NIDN/' + W_CIsoCitz + '/'                      BUG15045
     C                             + %Trim(W_E5IDNO)                                          250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   If        C_BBCSID <> *Blanks                                        250600
     C                   Eval      CustIssuer = C_BBCSID                                      250600
     C                   Else                                                                 250600
     C                   If        C_A8BTID <> *Blanks                                        250600
     C                   If        %subst(C_A8BTID:10:3) = 'XXX'                            BUG25028
     C                   Eval      CustIssuer = %subst(C_A8BTID:1:8)                        BUG25028
     C                   Else                                                               BUG25028
     C                   Eval      CustIssuer = %subst(C_A8BTID:1:8)                          250600
     C                              + %subst(C_A8BTID:10:3)                                   250600
     C                   Endif                                                              BUG25028
     C                   Else                                                                 250600
     C                   Eval      CustIssuer = %Trim(C_BBCRNM)                               250600
     C                   Endif                                                                250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   Eval      W_CUST = 'CUST/' + C_CIsoCoLc + '/' +                      250600
     C                             %Trim(CustIssuer) + '/' + W_BBCUST                         250600
      *                                                                                       250600

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValNonAcctHldr - Validate Non Account Holder                  *
      *****************************************************************
     C     ValNonAcctHldrBegSR

     C                   Call      'AONAHOR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*KEY'        PMOption
     C                   Parm                    PMNonAcctHldr
     C     SDNAHO        Parm      SDNAHO        DSSDY

     C                   If        PMReturnCode <> *Blanks
     C                   Eval      PMReturnCode = '*ERROR'
     C                   Eval      PMMsgID = 'FTS0035'
     C                   Eval      DbFile = 'SDNAHOPD'
     C                   Eval      Dbase  = 03
     C                   Exsr      *PSSR

     C                   Else
     C                   Movel     PMNonAcctHldr W#Naho           10                         CSW207A
     C     W#Naho        Chain     SDNAHOl1                           65                     CSW207A
     C                   Eval      WNAHOFlag = 'Y'
     C                   Eval      W_E5TINO = NHTINO
     C                   Eval      W_E5CNA1 = NHCNA1
     C                   Eval      W_E5CNA2 = NHCNA2
     C                   Eval      W_E5CNA3 = NHCNA3
     C                   Eval      W_E5CNA4 = NHCNA4
     C                   Eval      W_BBCOLC = NHCOLC
     C                   Eval      W_E5CITY = NHCITY
     C                   Eval      W_E5ZIPC = NHZIPC
     C                   Eval      W_E5BTHC = NHBTHC
     C                   Eval      W_E5BTHT = NHBTHT
      *
     C                   Eval      WIDTP = NHIDTP
     C                   Eval      PMCountry = NHISCT
     C                   Eval      W_E5ISCD = NHISAU                                         CSW207A
     C**********         Movel     PMCustNo      W#Cust            6                  CSW207A 250600
     C**********         Eval      PMCustNo = *Blanks                                 CSW207A 250600
      *                                                                                     BUG25689
     C                   EVAL      NHISOC = *BLANKS                                         BUG25689
     C                   EVAL      PMISOC = NHBTHC                                          BUG25689
     C                   EXSR      GetISOCode                                               BUG25689
     C                   EVAL      NHISOC = WISOC                                           BUG25689
      *                                                                                     BUG25689
      *
      *                                                                                       250600
      * As the Non account holder has no linked branch, used the one of the linked customer   250600
      * if any                                                                                250600
     C                   Eval      W_NAHO = *Blanks                                           250600
     C                   If        C_CIsoCoLc   <> *Blanks                                    250600
     C                             and PMCustNo <> *Blanks                                    250600
     C                   Eval      W_CUST = 'CUST/' + C_CIsoCoLc +                            250600
     C                             %Trim(CustIssuer) + '/' + W#Naho                           250600
     C                   EndIf                                                                250600
      *                                                                                       250600
     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValNostro - Validate Nostro                                   *
      *****************************************************************
     C     ValNostro     BegSR

     C                   Eval      PMCurrCode = %Subst(PMInpParm1:2:3)
     C                   Eval      PMNostro = %Subst(PMInpParm1:5:2)
     C                   Call      'AONOSTR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*KEY'        PMOption
     C                   Parm      *Blanks       PMCustNo
     C                   Parm                    PMCurrCode
     C                   Parm                    PMAccCode
     C                   Parm                    PMAcctSeq
     C                   Parm                    PMNostro
     C                   Parm                    PMBranch
     C                   Parm                    PMCustSName
     C                   Parm                    PMPNostro
     C     SDNOST        Parm      SDNOST        DSSDY

     C                   If        PMReturnCode <> *Blanks
     C                   Eval      DbFile = 'SDNOSTPD'
     C                   Eval      Dbase = 04
     C                   Exsr      *PSSR
     C                   Else
     C                   Eval      PMCustNo = A7CUST
     C                   Exsr      ValCustomer

     C                   Eval      PMAcct = A7ACCD
     C                   Move      A7ACSN        PMAcctSeq
     C                   Eval      PMBranch = A7BRCD
     C                   Exsr      ValAccountNo
     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValAccountNo - Validate account number                        *
      *****************************************************************
     C     ValAccountNo  BegSR

     C**********         If        PMInpType <> 'N'                                           250600
     C**********                   And PMInpType <> 'R'                             CSW207A BUG14755
     C                   Eval      PMBranch = %Subst(PMAccount:1:3)
     C                   Eval      PMCustNo = %Subst(PMAccount:4:6)
     C                   Eval      PMCurrCode = %Subst(PMAccount:10:3)
     C                   Eval      PMAcct = %Subst(PMAccount:13:10)
     C                   Eval      PMAcctSeq = %Subst(PMAccount:23:2)
     C**********         EndIf                                                                250600

     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*KEY'        PMOption
     C                   Parm                    PMRetail
     C                   Parm                    PMCustno
     C                   Parm                    PMCurrCode
     C                   Parm                    PMAcct
     C                   Parm                    PMAcctSeq
     C                   Parm                    PMBranch
     C     SDACCT        Parm      SDACCT        DSSDY

     C                   If        PMReturnCode <> *Blanks
     C                             And PMReturnCode <> '*KEY'                                CSW207A
     C                   Eval      PMReturnCode = '*ERROR'
     C                   Eval      DbFile = 'ACCNTAB'
     C                   Eval      Dbase  = 05
     C                   Exsr      *PSSR
     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * GetCustDtls - Get Customer Details                            *
      *****************************************************************
     C     GetCustDtls   BegSR

     C                   Move      PMCustNo      PMCustNo10A
     C                   Call      'AOCSSWR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*KEY'        PMOption
     C                   Parm                    PMCustNo10A
     C                   Parm                    PMStatus
     C                   Parm                    DSLDY

     C                   If        PMReturnCode <> *Blanks
     C                   Eval      PMReturnCode = '*ERROR'
     C                   Eval      DbFile = 'SDCSSWPD'
     C                   Eval      Dbase  = 06
     C                   Exsr      *PSSR
     C                   Else

     C                   Eval      WStr = %Len(SDCUST) + 1
     C                   Eval      WLen = %Len(SDCSSW)
     C                   Eval      SDCUST = DSLDY
     C                   Eval      SDCSSW = %Subst(DSLDY:WStr:WLen)
     C                   Eval      W_SDCUST = SDCUST

     C                   EndIf
      *                                                                                       250600
     C                   Eval      PMISOC = W_BBCOLC                                          250600
     C                   Exsr      GetISOCode                                                 250600
     C                   Eval      W_WIsoCoLc = WISOC                                         250600

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValInputType01 - validate input type                          *
      *****************************************************************
     C     ValInputType  BegSR

     C**********         If        PMInpType <> 'C'                                   CSW207A 250600
     C                   If        PMCustNo <> *BLANKS                                        250600
     C                   Movel     PMCustNo      W#Cust                                      CSW207A
     C**********         Movel     *Blanks       PMCustNo                             CSW207A 250600
     C                   Endif                                                               CSW207A
                                                                                             CSW207A
     C**********         If        PMInpType = 'I'                                    CSW207A 250600
     C**********         Movel     PMInpParm1    W#Accnt                              CSW207A 250600
     C*****W#Accnt       Chain     AccntL6                            65              CSW207A 250600
     C**********         If        *IN65 = *OFF                                       CSW207A 250600
     C**********         Eval      PMMsgID = 'FTS0032'                                CSW207A 250600
     C**********         Eval      PMErrType = 'E'                                    CSW207A 250600
     C**********         Exsr      SetError                                           CSW207A 250600
     C**********         LeaveSR                                                      CSW207A 250600
     C**********         Endif                                                        CSW207A 250600
     C**********         Endif                                                        CSW207A 250600
      **********                                                                    CSW207A BUG14755
     C**********         If        PMInpType = ' '                                  CSW207A BUG14755
     C**********                   And PMValType = 'FRMT'                           CSW207A BUG14755
      ***If*IBAN*account*display*only*the*account*number                            CSW207A BUG14755
     C**********         If        %Subst(PMInpParm1:1:1) = '/'                     CSW207A BUG14755
     C**********         Eval      W#Accnt = %Subst(PMInpParm1:2)                   CSW207A BUG14755
     C**********         Else                                                       CSW207A BUG14755
     C**********         Movel     PMInpParm1    W#Accnt          34                CSW207A BUG14755
     C**********         EndIf                                                      CSW207A BUG14755
     C*****W#Accnt       Chain     AccntL6                            65            CSW207A BUG14755
     C**********         If        *IN65 = *OFF                                     CSW207A BUG14755
     C**********         Eval      PMOutParm1 = PMInpParm1                          CSW207A BUG14755
     C**********         Eval      WContinue = 'Y'                                  CSW207A BUG14755
     C**********         LeaveSR                                                    CSW207A BUG14755
     C**********         EndIf                                                      CSW207A BUG14755
     C**********         EndIf                                                      CSW207A BUG14755
      **********                                                                    CSW207A BUG14755
     C                   If        PMAccount <> *Blanks                                      250600
     C                   Exsr      ValAccountNo                                              250600
     C                   Endif                                                               250600
      *                                                                                      250600
     C                   If        PMInpType = 'C' Or                                        250600
     C                             PMInpType = 'P' Or                                        250600
     C                             PMInpType = 'G'                                           250600
     C                   If        PMCustNo = *Blanks                                        250600
     C                   Movel     PMInpParm1    PMCustNo                                    250600
     C                   EndIf                                                               250600
     C                   EndIf                                                               250600
      *                                                                                      250600
     C                   If        PMInpType = 'S'                                         BUG15045
     C                   Movel     PMInpParm1    W9BICC                                    BUG15045
     C                   CALL      'ME1400'                                                BUG15045
     C                   PARM      *BLANKS       W9RTN             7                       BUG15045
     C                   PARM                    W9BICC            8                       BUG15045
     C                   PARM      *BLANKS       W9BICB            3                       BUG15045
     C                   PARM                    D_SDCUST                                  BUG15045
     C                   PARM                    SDCNST                                    BUG15045
     C                   PARM                    MEBICD                                    BUG15045
     C                   PARM      *BLANKS       W9CUST            1                       BUG15045
     C                   PARM      *BLANKS       W9CNST            1                       BUG15045
     C                   PARM      *BLANKS       W9BICD            1                       BUG15045
      *                                                                                    BUG15045
     C                   If        W9RTN = *BLANKS                                         BUG15045
     C                             And W9CUST = 'Y'                                          263378
     C                   Eval      PMCustNo = D_BBCUST                                     BUG15045
      *                                                                                     AR874231
      ** If swift address from other bank-customer = *Blanks,                               AR874231
      ** do not validate customer                                                           AR874231
      *                                                                                     AR874231
     C                   IF        W9CUST  = 'Y'                                              CFT050
     C                   If        PMCustNo  <> *Blank                                      AR874231
     C                   Exsr      ValCustomer                                             BUG15045
     C                   Endif                                                              AR874231
     C                   ELSE                                                                 CFT050
     C                   RETURN                                                               CFT050
     C                   ENDIF                                                                CFT050
     C                   Eval      PMCustNo = *BLANKS                                      BUG15045
     C                   EndIf                                                             BUG15045
      *                                                                                    BUG15045
     C                   EndIf                                                             BUG15045
                                                                                           BUG15045
     C                   If        PMCustNo  <> *Blanks                                      250600
     C                   Exsr      ValCustomer                                               250600
     C                   Endif                                                               250600
      *                                                                                      250600
     C                   Select

     C                   When      PMInpType = ' '
     C                             OR PMInpType = 'A'                                        250600
      *                                                                                      252878
     C                   Eval      PMAction = '*FORMAT'                                      252878
     C                   Eval      PMOption = '*KEY  '                                       252878
     C                   If        PMNetwork = *Blanks                                       252878
     C                   Eval      PMNetwork = 'SWIFT'                                       252878
     C                   EndIf                                                               252878
     C                   Exsr      ValAOOUFMR0                                               252878
      *                                                                                      252878
     C                   Eval      WContinue = 'Y'
     C**********         Eval      PMValType  = 'TRAN'                                      BUG15090
     C                   Exsr      ValInputParm
      *
      ** Validate customer no
      *
     C**********         When      PMInpType = 'C'                                            250600
     C**********         If        PMCustNo = *Blanks                                BUG14856 250600
     C**********         Movel     PMInpParm1    PMCustNo                            BUG14856 250600
     C**********         EndIf                                                       BUG14856 250600
     C**********         Exsr      ValCustomer                                                250600
     C**********         Eval      PMValType  = 'FRMT'                                        250600
     C**********         Eval      WContinue = 'Y'                                            250600
     C**********         Exsr      ProcessFRMT                                                250600
      *
      ** Validate account no(Ledger) or IBAN
      *
     C**********         When      PMInpType = 'G'                                            250600
     C**********                   Or PMInpType = 'I'                                         250600
     C**********                   Or PMInpType = 'R'                                         250600
     C**********         Exsr      ValAccountNo                                               250600
     C**********         Exsr      ValCustomer                                                250600
     C**********         Eval      PMValType  = 'FRMT'                                        250600
     C**********         Eval      WContinue = 'Y'                                            250600
     C**********         Exsr      ProcessFRMT                                                250600
      *
      ** Validate Nostro
      *
     C***********        When      PMInpType = 'N'                                            250600
     C***********        Exsr      ValNostro                                                  250600
     C***********        Eval      PMValType  = 'FRMT'                                        250600
     C***********        Eval      WContinue = 'Y'                                            250600
     C***********        Exsr      ProcessFRMT                                                250600
      *
      ** Validate Non-account holder
      *
     C**********         When      PMInpType = 'O'                                            250600
     C                   Other                                                                250600
     C                   If        PMInpType = 'O'                                            250600
     C                   Exsr      ValNonAcctHldr
     C                   Endif                                                                250600
     C                   Eval      PMValType  = 'FRMT'
     C                   Eval      WContinue = 'Y'
     C                   Exsr      ProcessFRMT

     C                   EndSL

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * GetISOCode - Get ISO code                                     *
      *****************************************************************
     C     GetISOCode    BegSR

     C                   Call      'AOCTRYR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*KEY'        PMOption
     C                   Parm                    PMISOC
     C     SDCTRY        Parm      SDCTRY        DSFDY

     C                   If        PMReturnCode <> *Blanks
     C                   Eval      PMReturnCode = '*ERROR'
     C                   Eval      PMMsgID = 'FTS0004'                                       CSW207A
     C                   Exsr      SetError                                                  CSW207A
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C**********         Eval      DbFile = 'SDCTRYPD'                                       CSW207A
     C**********         Eval      Dbase = 07                                                CSW207A
     C**********         Exsr      *PSSR                                                     CSW207A
     C                   Else
     C                   Eval      WISOC = A4ISOC
     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValIDType - Validate identification type                      *
      *****************************************************************
     C     ValIDType     BegSR

     C     WIDTP         Ifne      *Blanks                                                    250600
     C     WIDTP         Chain     SDIDTPL1
     C                   If        Not %Found(SDIDTPL1)
     C**********                   And PMInpType <> 'R'                              BUG14755 250600
     C**********                   And PMInpType <> 'I'                              BUG14755 250600
     C                             And PMInpType <> 'A'                                       250600
     C                   Eval      PMReturnCode = '*ERROR'
     C                   Eval      PMMsgID = 'FTS0041'                                       CSW207A
     C                   Exsr      SetError                                                  CSW207A
     C**********         Eval      DbFile = 'SDIDTPPD'                                       CSW207A
     C**********         Eval      Dbase  = 08                                               CSW207A
     C**********         Exsr      *PSSR                                                     CSW207A
     C                   Else
     C                   Eval      WSWCD = IDSWCD
     C                   EndIf
     C                   EndIf                                                                250600

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVOMFM - Validate OMFM Type                                  *
      *****************************************************************
     C     SRVOMFM       BegSR
      *                                                                                     BUG25721
      *** Validate fields 2 to 5                                                            BUG25721
      *                                                                                     BUG25721
     C                   IF        PMInpParm1 = *Blanks                                     BUG25721
     C**********                   Or (PMInpParm2 = *Blanks)                       BUG25721 BUG25894
     C                             Or (PMInpParm2 = *Blanks                                 BUG25894
     C                             And PMInpParm3 <> *Blanks)                               BUG25894
     C                             Or (PMInpParm3 = *Blanks                                 BUG25721
     C                             And PMInpParm4 <> *Blanks)                               BUG25721
     C                             Or (PMInpParm4 = *Blanks                                 BUG25721
     C                             And PMInpParm5 <> *Blanks)                               BUG25721
     C                   EVAL      PMReturnCode = '*ERROR'                                  BUG25721
     C                   EVAL      PMMsgID = 'ME00163'                                      BUG25721
     C                   LEAVESR                                                            BUG25721
     C                   ENDIF                                                              BUG25721
      *
      *** If first line starts with "/"
      *** check next 2 characters if valid ISO country code
      *
     C                   IF        PMInpParm1 <> *BLANKS
      *
     C                   IF        %Subst(PMInpParm1:1:1) = '/'
     C                   IF        %Subst(PMInpParm1:2:34) <> *Blanks
     C                   EVAL      wISOC = %Subst(PMInpParm1:2:2)
     C     wISOC         CHAIN     MEISOCL0
      *
     C                   IF        NOT %FOUND(MEISOCL0)
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00155'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDIF
      *                                                                                     BUG24352
     C                   IF        %SUBST(PMInpParm1:4:32) <> *BLANKS                       BUG24352
     C                   EVAL      PMReturnCode = '*ERROR'                                  BUG24352
     C                   EVAL      PMMsgID = 'ME00154'                                      BUG24352
     C                   LEAVESR                                                            BUG24352
     C                   ENDIF                                                              BUG24352
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      wSWCD = %Subst(PMInpParm1:1:4)
     C                   SETON                                        94                      250600
     C     WSWCD         LOOKUP    IdCode                                 94                  250600
     C                   IF        *IN94 = *OFF                                               250600
     C     WSWCD         CHAIN     SDIDTPL2
     C                   IF        NOT %FOUND(SDIDTPL2)                                       250600
     C                   SETOFF                                       94                      250600
     C                   Endif                                                                250600
     C                   Endif                                                                250600
      *
     C**********         IF        NOT %FOUND(SDIDTPL2) OR                                    250600
     C                   IF        *IN94 = *OFF         OR                                    250600
     C                             %Subst(PMInpParm1:5:1) <> '/'
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00154'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
      *
      *** If record is found, check next character is "/" and
      *** followed by a valid ISO country code then a "/"
      *
     C                   ELSE
     C                   IF        wSWCD = 'ARNU' OR
     C                             wSWCD = 'CCPT' OR
     C                             wSWCD = 'CUST' OR
     C                             wSWCD = 'DRLC' OR
     C                             wSWCD = 'EMPL' OR
     C                             wSWCD = 'NIDN' OR
     C                             wSWCD = 'SOSE' OR
     C                             wSWCD = 'TXID'
     C                   EVAL      wISOC = %Subst(PMInpParm1:6:2)
      * Country definition is not mandatory at definition level                               250600
     C                   If        wISOC <> *Blanks                                           250600
     C     wISOC         CHAIN     MEISOCL0
      *
     C                   IF        NOT %FOUND(MEISOCL0)     OR
     C                             %Subst(PMInpParm1:5:1) <> '/' OR
     C                             %Subst(PMInpParm1:8:1) <> '/' OR
     C                             %Subst(PMInpParm1:9:27) <> *BLANKS
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00155'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDIF
      *
     C                   Else                                                                 250600
     C                   If        %Subst(PMInpParm1:6:30) <> *BLANKS                         250600
     C                   EVAL      PMReturnCode = '*ERROR'                                    250600
     C                   EVAL      PMMsgID = 'ME00155'                                        250600
     C**********         EVAL      PMErrType = 'E'                                    250600 250804A
     C                   LEAVESR                                                              250600
     C                   ENDIF                                                                250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C                   ENDIF
      ** IBEI should not be accepted in OMFM if CSW209 is ON                                  CSW209
     C                   If        CSW209 = 'Y' and                                           CSW209
     C                             wSWCD = 'IBEI'                                             CSW209
     C                   EVAL      PMReturnCode = '*ERROR'                                    CSW209
     C                   EVAL      PMMsgID = 'ME00154'                                        CSW209
     C                   LEAVESR                                                              CSW209
     C                   EndIf                                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If code 2/ is used, the last line starting by 2/
      ** must be followed by a line starting with 3/
      *
     C                   MOVE      *ZEROS        wSeqArr
      *
     C                   IF        %Subst(PMInpParm2:1:1) <> *BLANKS
     C                   EVAL      wChar1to1 = %Subst(PMInpParm2:1:1)
     C                   MOVE      wChar1to1     wSeqArr(2)
     C                   ENDif
      *                                                                                       CSW208
      ** SWIFT 2008 Changes                                                                   CSW208
      ** Validate 2nd line of Ordering Customer, must start by 1/                             CSW208
      *                                                                                       CSW208
     C                   IF        CSW208 = 'Y'                                               CSW208
     C                             AND %SUBST(PMInpParm2:1:1) <> '1'                          CSW208
     C                   EVAL      PMReturnCode = '*ERROR'                                    CSW208
     C**********         EVAL      PMMsgID = 'ME00166'                               CSW208 BUG21029
     C                   EVAL      PMMsgID = 'ME00168'                                      BUG21029
     C                   LEAVESR                                                              CSW208
     C                   ENDIF                                                                CSW208
      *
     C                   IF        %Subst(PMInpParm2:1:1) = '5'
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00162'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDif
      *
     C                   If        CSW209 <> 'Y'                                              CSW209
     C                   IF        %Subst(PMInpParm2:1:1) = '3'
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00165'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDif
     C                   EndIf                                                                CSW209
      *
     C                   IF        %Subst(PMInpParm3:1:1) <> *BLANKS
     C                   EVAL      wChar1to1 = %Subst(PMInpParm3:1:1)
     C                   MOVE      wChar1to1     wSeqArr(3)
     C                   ENDif
      *
     C                   IF        %Subst(PMInpParm4:1:1) <> *BLANKS
     C                   EVAL      wChar1to1 = %Subst(PMInpParm4:1:1)
     C                   MOVE      wChar1to1     wSeqArr(4)
     C                   ENDif
      *
     C                   IF        %Subst(PMInpParm5:1:1) <> *BLANKS
     C                   EVAL      wChar1to1 = %Subst(PMInpParm5:1:1)
     C                   MOVE      wChar1to1     wSeqArr(5)
     C                   ENDif
      *
     C                   EVAL      Idx = 2
     C                   EVAL      Ndx = 3
      *
     C                   DOW       Idx < 5
      *
     C                   IF        wSeqArr(Idx) = 2  And
     C**********                   wSeqArr(Ndx) <> 3 And                                    BUG21064
     C                             wSeqArr(Ndx) <> 3                                        BUG21064
     C**********                   wSeqArr(Ndx) <> 0                                        BUG21064
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00157'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDif
      *
      ** If code 4/ is used, the next line must start with 5/
      *
     C                   IF        wSeqArr(Idx) = 4  And
     C                             wSeqArr(Ndx) <> 5
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00158'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDif
      *
      ** If code 5/ is used, previous line must start with 4/
      *
     C                   IF        wSeqArr(Ndx) = 5  And
     C                             wSeqArr(Idx) <> 4
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00162'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDif
      *
      ** If code 3/ is used, previous line must start with 2/
      *
     C                   If        CSW209 <> 'Y'                                              CSW209
     C                   IF        wSeqArr(Ndx) = 3  And
     C                             wSeqArr(Idx) <> 2
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00165'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDif
     C                   EndIf                                                                CSW209
      *
      ** Field 2 to 5 must appear in increasing numerical order
      *
     C                   IF        wSeqArr(Idx) <> 0 And
     C                             wSeqArr(Ndx) <> 0 And
     C                             wSeqArr(Idx)  > wSeqArr(Ndx)
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00159'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDif
      *
     C                   If        CSW209 = 'Y'                                               CSW209
      ** No line may be repeated.                                                             CSW209
     C                   IF        wSeqArr(Idx) > 0 AND                                       CSW209
     C                             wSeqArr(Idx) = wSeqArr(Ndx)                                CSW209
     C                   EVAL      PMReturnCode = '*ERROR'                                    CSW209
     C                   EVAL      PMMsgID = 'ME00256'                                        CSW209
     C                   EVAL      PMErrType = 'E'                                            CSW209
     C                   ENDIF                                                                CSW209
     C                   EndIf                                                                CSW209
      *                                                                                       CSW209
     C                   Eval      Idx = Idx + 1
     C                   Eval      Ndx = Ndx + 1
     C                   ENDdo
      *                                                                                     BUG21064
      ** If code 4/ is used, the next line must start with 5/                               BUG21064
      *                                                                                     BUG21064
     C                   IF        wSeqArr(Idx) = 4                                         BUG21064
     C                   EVAL      PMReturnCode = '*ERROR'                                  BUG21064
     C                   EVAL      PMMsgID = 'ME00158'                                      BUG21064
     C                   LEAVESR                                                            BUG21064
     C                   ENDIF                                                              BUG21064
      **********                                                                            BUG25721
      ****Validate fields 2 to 5                                                            BUG25721
      **********                                                                            BUG25721
     C**********         IF        PMInpParm1 = *Blanks                                     BUG25721
     C**********                   Or (PMInpParm2 = *Blanks)                                BUG25721
     C**********                   Or (PMInpParm3 = *Blanks                                 BUG25721
     C**********                   And PMInpParm4 <> *Blanks)                               BUG25721
     C**********                   Or (PMInpParm4 = *Blanks                                 BUG25721
     C**********                   And PMInpParm5 <> *Blanks)                               BUG25721
     C**********         EVAL      PMReturnCode = '*ERROR'                                  BUG25721
     C**********         EVAL      PMMsgID = 'ME00163'                                      BUG25721
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C**********         LEAVESR                                                            BUG25721
     C**********         ENDIF                                                              BUG25721
      *
     C                   EVAL      wDUMMY = PMInpParm2
     C                   EXSR      SRVF2to5
      *
     C                   EVAL      wDUMMY = PMInpParm3
     C                   EXSR      SRVF2to5
      *
     C                   EVAL      wDUMMY = PMInpParm4
     C                   EXSR      SRVF2to5
      *
     C                   EVAL      wDUMMY = PMInpParm5
     C                   EXSR      SRVF2to5
      *
     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVF2to5   - Validate Fields 2 to 5                           *
      *****************************************************************
     C     SRVF2to5      BegSR
      *
     C                   IF        wDUMMY <> *BLANKS
      *
      *** Line starting with n/ should be in range 1 to 7
      *
     C                   IF        %Subst(wDUMMY:1:1) < '1' OR
     C                             %Subst(wDUMMY:1:1) > '7' OR
     C                             %Subst(wDUMMY:2:1) <> '/'
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00154'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        (%Subst(wDUMMY:1:2) = '1/' OR
     C                             %Subst(wDUMMY:1:2) = '2/' OR
     C                             %Subst(wDUMMY:1:2) = '4/' OR
     C                             %Subst(wDUMMY:1:2) = '8/') AND
     C                             %Subst(wDUMMY:3) <> *Blanks
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00154'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDIF
      *
      *** For line starting by 3/, 5/, 6/, 7/ and followed by a character,
      *** next 2 character should be valid ISO country code
      *
     C                   IF        %Subst(wDUMMY:1:2) = '3/' OR
     C                             %Subst(wDUMMY:1:2) = '5/' OR
     C                             %Subst(wDUMMY:1:2) = '6/' OR
     C                             %Subst(wDUMMY:1:2) = '7/'
      *
     C                   IF        %Subst(wDUMMY:3:33) <> *BLANKS
     C                   EVAL      wISOC = %Subst(wDUMMY:3:2)
     C     wISOC         CHAIN     MEISOCL0
      *
     C                   IF        NOT %FOUND(MEISOCL0) OR
     C                             %Subst(wDUMMY:5:1) <> '/' OR
     C                             %Subst(wDUMMY:6:30) <> *BLANKS
     C                   EVAL      PMReturnCode = '*ERROR'
     C                   EVAL      PMMsgID = 'ME00155'
     C**********         EVAL      PMErrType = 'E'                                           250804A
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValInputParm - validate Input parameter                       *
      *****************************************************************
     C     ValInputParm  BegSR

     C                   Exsr      ValBlankCol

     C                   If        WBlankCol = 'N'
     C                             And WContinue = 'Y'

     C                   Eval      WCtr01 = 0
     C                   Eval      WSlashFlag = 'N'
     C                   Eval      WFirst = 'Y'
     C                   Eval      CtrSwf67 = 0                                             BUG25101
     C                   Eval      CtrN3    = 0                                               CSW215
     C                   EVAL      WISOChk = *BLANK                                         MD034516
     C                   DoW       WCtr01 < 5
     C                             And WContinue = 'Y'

     C**********         Eval      WCtr01 += 1                                              BUG15045
     C                   Eval      WCtr01 = WCtr01 + 1                                      BUG15045

     C                   Select

     C                   When      WCtr01 = 1
     C                   Eval      WInpParm = PMInpParm1
     C                   EVAL      WNextNCode = %Subst(PMInpParm2:1:1)                      BUG25323

     C                   When      WCtr01 = 2
     C                   Eval      WInpParm = PMInpParm2
     C                   EVAL      WNextNCode = %Subst(PMInpParm3:1:1)                      BUG25323

     C                   When      WCtr01 = 3
     C                   Eval      WInpParm = PMInpParm3
     C                   EVAL      WNextNCode = %Subst(PMInpParm4:1:1)                      BUG25323

     C                   When      WCtr01 = 4
     C                   Eval      WInpParm = PMInpParm4
     C                   EVAL      WNextNCode = %Subst(PMInpParm5:1:1)                      BUG25323

     C                   When      WCtr01 = 5
     C                   Eval      WInpParm = PMInpParm5
     C                   EVAL      WNextNCode = *BLANKS                                     BUG25356

     C                   EndSL

     C                   If        WInpParm <> *Blanks
     C                   Exsr      ValCol1to5
     C                   If        WContinue = 'Y'                                           CSW207A
     C                             And WNcode = '5'                                          CSW207A
     C                             And WSaveCode <> '4'                                      CSW207A
     C                             Or WContinue = 'Y'                                        CSW207A
     C                             And WNcode <> '5'                                         CSW207A
     C                             And WSaveCode = '4'                                       CSW207A
     C                   Eval      PMMsgID = 'FTS0027'                                       CSW207A
     C                   Exsr      SetError                                                  CSW207A
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndIf                                                               CSW207A
      *                                                                                       CSW209
     C                   If        CSW209 <> 'Y'                                              CSW209
     C                   IF        WContinue = 'Y'                                            CSW209
     C                             AND WNcode = '3'                                           CSW209
     C                             AND WSaveCode <> '2'                                       CSW209
     C                             AND WSaveCode <> '3'                                       CSW209
     C                   EVAL      PMMsgID = 'FTS0026'                                        CSW209
     C                   EXSR      SetError                                                   CSW209
     C                   EVAL      PMErrType = 'E'                                            CSW209
     C                   ENDIF                                                                CSW209
     C                   EndIf                                                                CSW209
                                                                                             CSW207A
      ** Don't accept embedded blanks                                                        CSW207A
     C                   If        WContinue = 'Y'                                           CSW207A
     C                             And WSaveInp = *Blanks                                    CSW207A
     C                   Eval      PMMsgID = 'FTS0040'                                       CSW207A
     C                   Exsr      SetError                                                  CSW207A
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
      ** Insert excess characters in there are lines available                              BUG15045
     C                   Else                                                               BUG15045
     C                   If        WExcsLine1 <> *Blanks                                    BUG15045
     C                   Eval      WLN = WExcsLine1                                         BUG15045
     C                   Exsr      MovePMMsg2to5                                            BUG15045
     C                   EndIf                                                              BUG15045
      *                                                                                     BUG15045
     C                   EndIf
     C                   Movel     WNcode        WSaveCode         1                         CSW207A
     C                   Movel     WInpParm      WSaveInp         35                         CSW207A

     C                   EndDo
                                                                                            BUG25101
      ** CSW209 FDS2.01 Changes                                                             BUG25101
                                                                                            BUG25101
     C                   If        Line8 <> *Blanks                                         BUG25101
                                                                                            BUG25101
     C                   If        *In94 = *On                                              BUG25101
     C                   Eval      CtrSwf67 = CtrSwf67 + 1                                  BUG25101
     C                   EndIf                                                              BUG25101
                                                                                            BUG25101
     C                   If        CtrSwf67 > 1                                             BUG25101
     C                             And WContinue = 'Y'                                      BUG26043
     C                   EVAL      PMMsgID = 'FTS0080'                                      BUG25101
     C                   EVAL      PMErrType = 'W'                                          BUG25101
     C                   EndIf                                                              BUG25101
                                                                                            BUG25101
     C                   EndIf                                                              BUG25101

     C                   If        WContinue = 'Y'
     C                   Select
     C                   When      WPrevNCode = '2'
     C                   Eval      PMMsgID = 'FTS0026'
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   When      WPrevNCode = '4'
     C                   Eval      PMMsgID = 'FTS0027'
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndSL
     C                   EndIf

     C                   EndIf

     C**********         If        WContinue = 'N'                                           250804A
     C**********                   And PMErrType = *Blanks                                   250804A
     C**********         Eval      PMErrType = 'E'                                           250804A
     C**********         EndIf                                                               250804A

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValFRMTParm - validate FRMT validation type                   *
      *****************************************************************
     C     ValFRMTParm   BegSR

     C                   DoW       PMReturnCode <> '*EOF'

     C                   Eval      WFC1 = OM50F1
     C                   Eval      WFC2 = OM50F2
     C                   Eval      WFC3 = OM50F3
     C                   Eval      WFC4 = OM50F4
     C                   Eval      WFC5 = OM50F5
      ** Compute for Excess Lines                                                           BUG15045
     C                   Eval      WExcsLine = 0                                            BUG15045
     C                   Select                                                             BUG15045
     C                   When      OM50F2 = *Blanks                                         BUG15045
     C                   Eval      WExcsLine = 4                                            BUG15045
     C                   When      OM50F3 = *Blanks                                         BUG15045
     C                   Eval      WExcsLine = 3                                            BUG15045
     C                   When      OM50F4 = *Blanks                                         BUG15045
     C                   Eval      WExcsLine = 2                                            BUG15045
     C                   When      OM50F5 = *Blanks                                         BUG15045
     C                   Eval      WExcsLine = 1                                            BUG15045
     C                   EndSl                                                              BUG15045

     C                   Exsr      ValBlankCol

     C                   If        WBlankCol = 'N'

     C                   Eval      WCtr01 = 0
     C                   Eval      WSlashFlag = 'N'
     C                   Eval      WFirst = 'Y'
     C                   Eval      CtrSwf67 = 0                                             BUG25101
     C                   DoW       WCtr01 < 5

     C**********         Eval      WCtr01 += 1                                              BUG15045
     C                   Eval      WCtr01 = WCtr01 + 1                                      BUG15045

     C                   Select

     C                   When      WCtr01 = 1
     C                   Eval      WInpParm = WFC1

     C                   When      WCtr01 = 2
     C                   Eval      WInpParm = WFC2

     C                   When      WCtr01 = 3
     C                   Eval      WInpParm = WFC3

     C                   When      WCtr01 = 4
     C                   Eval      WInpParm = WFC4

     C                   When      WCtr01 = 5
     C                   Eval      WInpParm = WFC5

     C                   EndSL

     C                   If        WInpParm <> *Blanks
     C                   Eval      WContinue = 'Y'
     C                   Exsr      ValCol1to5

     C                   If        WContinue = 'Y'
     C                   Select
     C                   When      PMValType = 'FRMT'
     C**********                   And WOrgValType = 'FRMT'                                 BUG14856
     C                   Eval      PMMsgID = *Blanks                                        BUG14856
     C                   Exsr      FormatOutParm
     C                   EndSL

     C                   Else
     C                   Leave
     C                   EndIf

     C                   EndIf

     C                   EndDo
                                                                                            BUG25101
      ** CSW209 FDS2.01 Changes                                                             BUG25101
                                                                                            BUG25101
     C                   If        Line8 <> *Blanks                                         BUG25101
                                                                                            BUG25101
     C                   If        *In94 = *On                                              BUG25101
     C                   Eval      CtrSwf67 = CtrSwf67 + 1                                  BUG25101
     C                   EndIf                                                              BUG25101
                                                                                            BUG25101
     C                   If        CtrSwf67 > 1                                             BUG25101
     C                   EVAL      PMMsgID = 'FTS0080'                                      BUG25101
     C                   EVAL      PMErrType = 'W'                                          BUG25101
     C                   EndIf                                                              BUG25101
                                                                                            BUG25101
     C                   EndIf                                                              BUG25101

      ** Process excess lines for Sub-field 1, 6/ and 7/.                                     CSW209
      *                                                                                       CSW209
     C                   If        CSW209 = 'Y'                                               CSW209
     C                   SELECT                                                               CSW209
     C                   WHEN      WExcsLine1 <> *BLANKS                                      CSW209
     C                   EVAL      WLN = WExcsLine1                                           CSW209
     C                   EXSR      MovePMMsg2to5                                              CSW209
     C                   EVAL      WExcsLine1 = *Blanks                                       CSW209
      *                                                                                       CSW209
     C                   WHEN      WExcsLine6 <> *BLANKS                                      CSW209
     C                   EVAL      WLN = WExcsLine6                                           CSW209
     C                   EXSR      MovePMMsg2to5                                              CSW209
     C                   EVAL      WExcsLine6 = *Blanks                                       CSW209
      *                                                                                       CSW209
     C                   WHEN      WExcsLine7 <> *BLANKS                                      CSW209
     C                   EVAL      WLN = WExcsLine7                                           CSW209
     C                   EXSR      MovePMMsg2to5                                              CSW209
     C                   EVAL      WExcsLine7 = *Blanks                                       CSW209
     C                   ENDSL                                                                CSW209
     C                   EndIf                                                                CSW209
      *                                                                                       CSW209
     C                   If        WContinue = 'Y'
     C                   Select
     C                   When      WPrevNCode = '2'
     C                   If        CSW209 <> 'Y'                                              CSW209
     C                   Eval      PMMsgID = 'FTS0026'
     C                   Eval      WContinue = 'N'
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndIf                                                                CSW209
     C                   When      WPrevNCode = '4'
     C                   Eval      PMMsgID = 'FTS0027'
     C                   Eval      WContinue = 'N'
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndSL

     C                   If        WContinue = 'Y'
     C                   Eval      PMMsgID = *Blanks
     C                   Eval      PMErrType = *Blanks
     C                   Leave
     C                   EndIf

     C                   EndIf

     C                   If        WContinue = 'N'
     C**********         Eval      PMErrType = *Blanks                              CSW207A BUG14856
     C**********         Eval      PMReturnCode = *Blanks                           CSW207A BUG14856
     C**********         Eval      WContinue = 'Y'                                  CSW207A BUG14856
     C**********         Eval      PMMsgID  = *Blanks                               CSW207A BUG14856
     C                   Eval      PMAction = '*FORMAT'
     C**********         Eval      PMOption = '*NEXT '                                        250600
     C                   Eval      PMOption = '*NEXTEQ'                                       250600
     C                   Exsr      ValAOOUFMR0
     C                   EndIf

     C                   EndIf

     C                   EndDo

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValCol1to5 - validate columns 1 to 5                          *
      *****************************************************************
     C     ValCol1to5    BegSR

      ** CSW209 FDS2.01 Changes                                                             BUG25101
                                                                                            BUG25101
     C                   EXSR      SRLINE8                                                  BUG25101
                                                                                            BUG25101
     C                   Eval      WPtr1 = 0
     C                   Eval      WPtr2 = 0
     C                   Eval      WPtr3 = 0
     C                   Eval      WSlash1 = *Blanks
     C                   Eval      WSlash2 = *Blanks
     C                   Eval      WSlash3 = *Blanks

     C                   Eval      WSwiftCode = *Blanks
     C                   Eval      WNCode     = *Blanks
     C                   Eval      WISOCode   = *Blanks

     C                   Eval      WISODesc   = 'N'
     C                   Eval      WIssFlag   = 'N'
     C                   Eval      WIssDesc   = 'N'
      *                                                                                       250600
     C                   If        WSWCDSave <> *Blanks                                       250600
     C                   Eval      WSWCD = WSWCDSave                                          250600
     C                   Eval      WSWCDSave = *Blanks                                        250600
     C                   Endif                                                                250600

     C                   If        %Subst(WInpParm:1:1) = '/'
     C**********                   Or PMInpType = 'I' and WCtr01 = 1                        BUG14755
     C                             And WCtr01 = 1                                           BUG14755
     C**********                   And (PMInpType = 'R'                              BUG14755 250600
     C**********                   Or  PMInpType = 'I')                              BUG14755 250600

     C                   Exsr      ValSlash
      ** Not /
     C                   Else
     C                   Eval      WSwiftCode = %Subst(WInpParm:1:4)
     C                   Eval      W#ISOC = %Subst(WInpParm:6:2)                             CSW207A

     C                   SETON                                        94                      250600
     C                   If        WSwiftCode <> *Blanks                                      250600
     C     WSwiftCode    LOOKUP    IdCode                                 94                  250600
     C                   IF        *IN94 = *OFF                                               250600
     C*****WSwiftCode    Chain     SDIDTPL2                                                   250600
     C     WSwiftCode    Chain     SDIDTPL2                           94                      250600
     C                   IF        *IN94 = *OFF                                               250600
     C                   SETON                                        94                      250600
     C                   Else                                                               BUG15035
     C                   SETOFF                                       94                    BUG15035
     C                   Endif                                                                250600
     C                   Endif                                                                250600
     C                   Else                                                                 250600
     C                   SETOFF                                       94                      250600
     C                   Endif                                                                250600
     C**********         If        %Found(SDIDTPL2)                                           250600
                                                                                              252903
      ** CSW209 FDS2.01 Changes                                                             BUG25101
                                                                                            BUG25101
     C                   If        %SUBST(WInpParm:5:1) <> '/'                              BUG25101
     C                             AND WCtr01 = 1                                           BUG25101
     C                             And *In94 = *On                                          BUG25101
     C                   SETOFF                                       94                    BUG25101
     C                   EndIf                                                              BUG25101
                                                                                            BUG25101
     C                   If        WIDTP = *Blanks                                            252903
     C                             And WSWCD = *Blanks                                        252903
     C                             And *IN94 = *On                                            252903
     C                   Select                                                               252903
     C                   When      IDSWCD <> *Blanks                                          252903
     C                   Eval      WSWCD = IDSWCD                                             252903
     C                   Other                                                                252903
     C                   Eval      WSWCD = WSwiftCode                                         252903
     C                   Endsl                                                                252903
     C                   EndIf                                                                252903
                                                                                              252903
     C                   If        *IN94 = *ON                                                250600
     C                             And WSwiftCode = WSWCD                                    CSW207A
     C                             And PMValType = 'FRMT'
     C                             And WCtr01 = 1                                            CSW207A
     C                             And %Subst(PmInpParm1:1:1) <> '/'                        BUG15250
      *                                                                                     BUG15250
     C                             Or *IN94 = *ON                                           BUG15250
     C                             And WSwiftCode = WSWCD                                   BUG15250
     C                             And PMValType = 'FRMT'                                   BUG15250
     C                             And WCtr01 = 1                                           BUG15250
     C                             And (PMInpType = 'R' or PMInpType = 'I')                 BUG15250
     C                             And %Subst(PmInpParm1:1:1) = '/'                         BUG15250
      *                                                                                       250600
     C                             Or *IN94 = *ON                                             250600
     C                             And WSwiftCode = 'IBEI'                                    250600
     C**********                   And CSIBEI <> *Blanks                             250600 BUG15178
     C**********                   And PMNonAcctHldr = *Blanks                       250600 BUG15178
     C                             And PMValType = 'FRMT'                                     250600
     C                             And WCtr01 = 1                                             250600
     C                             And (PMInpType = 'A' or PMInpType = ' ')                 BUG15178
     C                             AND CSW209 <> 'Y'                                          CSW209
      *                                                                                       250600
     C                             Or *IN94 = *ON                                             250600
     C                             And WSwiftCode = 'NIDN'                                    250600
     C**********                   And W_E5IDNO <> *Blanks                           250600 BUG15178
     C**********                   And PMNonAcctHldr = *Blanks                       250600 BUG15178
     C                             And PMValType = 'FRMT'                                     250600
     C                             And WCtr01 = 1                                             250600
     C                             And (PMInpType = 'A' or PMInpType = ' ')                 BUG15178
      *                                                                                     BUG21024
     C                             Or *IN94 = *ON                                           BUG21024
     C                             And WSwiftCode = 'CUST'                                  BUG21024
     C                             And PMValType = 'FRMT'                                   BUG21024
     C                             And WCtr01 = 1                                           BUG21024
     C                             And (PMInpType = 'C' or PMInpType = ' ')                 BUG21024
      *                                                                                       250600
     C                             Or *IN94 = *ON                                             250600
     C                             And WSwiftCode = 'CUST'                                    250600
     C                             And PMValType = 'FRMT'                                     250600
     C                             And WCtr01 = 1                                             250600
     C                             And (PMInpType = 'A' or PMInpType = ' ')                 BUG15178
      *                                                                                       250600
     C                             OR *IN94 = *ON                                             CSW209
     C                             AND (WSwiftCode = 'CUST' Or                                CSW209
     C                                  WSwiftCode = 'NIDN')                                  CSW209
     C                             AND PMValType = 'FRMT'                                     CSW209
     C                             AND WCtr01 = 1                                             CSW209
     C                             AND PMInpType = 'C'                                        CSW209
     C                             AND CSW209 = 'Y'                                           CSW209
      *                                                                                       CSW209
     C**********                   And PMInpType <> 'I'                              BUG14755 250600
     C**********                   And PMInpType <> 'R'                              BUG14755 250600
     C**********                   And W#ISOC = WISOC                                CSW207A CSW207A
     C**********                   Or %Found(SDIDTPL2)                                        250600
     C                             Or *IN94 = *ON                                             250600
     C                             And PMValType = 'TRAN'
     C                             And WCtr01 = 1                                            CSW207A
                                                                                            BUG15090
     C                             Or *IN94 = *ON                                           BUG15090
     C                             And WSwiftCode = 'ARNU'                                  BUG15090
     C                             And PMValType = 'FRMT'                                   BUG15090
     C                             And WCtr01 = 1                                           BUG15090
     C                             And (PMInpType = 'A' or PMInpType = ' ')                 BUG15178
                                                                                            BUG15090
     C                             Or *IN94 = *ON                                           BUG15090
     C                             And WSwiftCode = 'CCPT'                                  BUG15090
     C                             And PMValType = 'FRMT'                                   BUG15090
     C                             And WCtr01 = 1                                           BUG15090
     C                             And (PMInpType = 'A' or PMInpType = ' ')                 BUG15178
                                                                                            BUG15090
     C                             Or *IN94 = *ON                                           BUG15090
     C                             And WSwiftCode = 'DRLC'                                  BUG15090
     C                             And PMValType = 'FRMT'                                   BUG15090
     C                             And WCtr01 = 1                                           BUG15090
     C                             And (PMInpType = 'A' or PMInpType = ' ')                 BUG15178
                                                                                            BUG15090
     C                             Or *IN94 = *ON                                           BUG15090
     C                             And WSwiftCode = 'EMPL'                                  BUG15090
     C                             And PMValType = 'FRMT'                                   BUG15090
     C                             And WCtr01 = 1                                           BUG15090
     C                             And (PMInpType = 'A' or PMInpType = ' ')                 BUG15178
                                                                                            BUG15090
     C                             Or *IN94 = *ON                                           BUG15090
     C                             And WSwiftCode = 'SOSE'                                  BUG15090
     C                             And PMValType = 'FRMT'                                   BUG15090
     C                             And WCtr01 = 1                                           BUG15090
     C                             And (PMInpType = 'A' or PMInpType = ' ')                 BUG15178
                                                                                            BUG15090
     C                             Or *IN94 = *ON                                           BUG15090
     C                             And WSwiftCode = 'TXID'                                  BUG15090
     C                             And PMValType = 'FRMT'                                   BUG15090
     C                             And WCtr01 = 1                                           BUG15090
     C                             And (PMInpType = 'A' or PMInpType = ' ')                 BUG15178
                                                                                            BUG25101
      ** CSW209 FDS2.01 Changes                                                             BUG25101
                                                                                            BUG25101
     C                   If        Line8 <> *Blanks                                         BUG25101
     C                   Eval      WParmSav = WInpParm                                      BUG25101
     C                   Eval      WInpParm = %TrimR(WInpParm) +                            BUG25101
     C                                        Line8                                         BUG25101
     C                   EndIf                                                              BUG25101

     C                   Exsr      ValSwift

      ** CSW209 FDS2.01 Changes                                                             BUG25101
                                                                                            BUG25101
     C                   If        WParmSav <> *Blanks                                      BUG25101
     C                   Eval      WInpParm = WParmSav                                      BUG25101
     C                   Eval      WParmSav = *Blanks                                       BUG25101
     C                   EndIf                                                              BUG25101
                                                                                            BUG25101
     C                   Else

     C                   Eval      WNCode = %Subst(WInpParm:1:1)
     C                   If        WNCode >= '1'
     C                             And WNCode <= '8'                                         CSW207A
     C                             And %Subst(WInpParm:2:1) = '/'
     C                             And WCtr01 > 1                                            CSW207A
                                                                                            BUG25101
      ** CSW209 FDS2.01 Changes                                                             BUG25101
                                                                                            BUG25101
     C                   IF        Line8 <> *Blanks And                                     BUG25101
     C                             WNCode = '6'                                             BUG25101
     C                   Eval      WParmSav = WInpParm                                      BUG25101
     C                   Eval      WInpParm = %TrimR(WInpParm) +                            BUG25101
     C                                        Line8                                         BUG25101
     C                   Eval      CtrSwf67 = CtrSwf67 + 1                                  BUG25101
     C                   EndIf                                                              BUG25101

     C                   Exsr      ValNCode

      ** CSW209 FDS2.01 Changes                                                             BUG25101
                                                                                            BUG25101
     C                   If        WParmSav <> *Blanks                                      BUG25101
     C                   Eval      WInpParm = WParmSav                                      BUG25101
     C                   Eval      WParmSav = *Blanks                                       BUG25101
     C                   EndIf                                                              BUG25101
                                                                                            BUG25101
     C                   Else
      ** Check if Valid Customer                                                             CSW207A
     C**********         If        PMInpType <> 'C'                                  BUG14593 250600
     C**********                   And PMInpType <> 'R'                              BUG14755 250600
     C**********                   And PMInpType <> 'I'                              BUG14755 250600
     C**********         If        PMCustNo = *Blanks                                 CSW207A 250600
     C**********         Movel     WInpParm      WCustNo                              CSW207A 250600
     C**********         Else                                                         CSW207A 250600
     C**********         Movel     PMCustNo      WCustNo                              CSW207A 250600
     C**********         EndIf                                                        CSW207A 250600
     C**********         Call      'AOACUSR0'                                         CSW207A 250600
     C**********         Parm      *Blanks       PMReturnCode                         CSW207A 250600
     C**********         Parm      '*KEY'        PMOption                             CSW207A 250600
     C**********         Parm                    PMCustNo                            CSW207A CSW207A
     C**********         Parm                    WCustNo           6                  CSW207A 250600
     C*****SDACUS        Parm      SDACUS        DSLDY                                CSW207A 250600
     C**********         If        PMReturnCode = *Blanks                             CSW207A 250600
     C**********         LEAVESR                                                      CSW207A 250600
     C**********         EndIf                                                        CSW207A 250600
     C**********         EndIf                                                       BUG14593 250600
                                                                                             CSW207A
     C                   If        WCtr01 = 1                                                CSW207A
     C**********         If        %Subst(WInpParm:1:1) >= '1'                      CSW207A BUG15065
     C**********                   And %Subst(WInpParm:1:1) <= '8'                  CSW207A BUG15065
     C**********         Eval      PMMsgId = 'FTS0038'                              CSW207A BUG15065
     C**********         Else                                                       CSW207A BUG15065
     C                   Eval      PMMsgID = 'FTS0016'                                       CSW207A
     C**********         EndIf                                                      CSW207A BUG15065
     C                   Eval      PMErrType = 'E'                                          BUG15035
     C                   Exsr      SetError                                                  CSW207A
                                                                                            BUG25973
      *                                                                                     BUG26229
      ** Set error type to 'E'rror for OP, BO and RO when ordering customer                 BUG26229
      ** input is 50F format                                                                BUG26229
      *                                                                                     BUG26229
     C                   If        PMModInd = 'OP'                                          BUG25973
     C                             Or PMModInd = 'BO'                                       BUG25973
     C                             Or PMModInd = 'RO'                                       BUG25973
     C                   If        %SUBST(PMInpParm2:1:2) = '1/'                            BUG26229
     C                   Eval      PMErrType = 'E'                                          BUG25973
     C                   EndIf                                                              BUG26229
     C                   EndIf                                                              BUG25973
                                                                                            BUG25973
     C                   Else                                                                CSW207A
      ** '/' and Swift code is missing
     C                   If        %SUBST(PMInpParm1:1:1) = '/'                               257938
     C                             And %SUBST(PMInpParm2:1:2) <> '1/'                         257938
     C                             And WOMFLAGF <>'M'                                         257938
     C                   Eval      PMMsgID = 'FTS0060'                                        257938
     C                   Exsr      SetError                                                   257938
     C                   Eval      PMErrType = 'W'                                            257938
     C                   Else                                                                 257938
     C                   Eval      PMMsgID = 'FTS0003'
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndIf                                                                257938
     C                   EndIf                                                               CSW207A
     C                   EndIf
     C                   EndIf

     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValSlash  - validate slash                                    *
      *****************************************************************
     C     ValSlash      BegSR

     C**********         If        PMInpType = 'I'                                            250600
     C**********                   And %Subst(WInpParm:1:1) <> '/'                            250600
     C                   If        %Subst(WInpParm:1:1) = '/'                                 250600
     C                             and PMAccount = *Blanks                                    250600
     C                             and P@IBAN = *Blanks                                       250600
     C**********                   and @@SLASH   <> '/'                               250600 250804A
     C                             and PMInpType <> 'A'                                      250804A
     C                             and PMInpType <> 'C'                                      250804A
     C                             and PMInpType <> 'S'                                      250804A
     C                             AND PMInpType <> ' '                                     BUG19193
      *                                                                                     BUG15178
     C                             Or %Subst(PMInpParm1:1:1) <> '/'                         BUG15178
     C                             And (PMInpType = 'C' Or PMInpType = 'S')                 BUG15178
     C                             And PMValType = 'FRMT'                                   BUG15178
      *                                                                                     BUG15178
     C                             Or %Subst(PMInpParm1:1:1) = '/'                          BUG15209
     C                             And PMInpParm2 = *Blanks                                 BUG15209
     C                             And (PMInpType = 'A' Or PMInpType = ' ')                 BUG15209
     C                             And PMValType = 'FRMT'                                   BUG15209
      *                                                                                     BUG15209
     C                   Eval      PMMsgID = 'FTS0032'
     C                   Exsr      SetError

     C                   Else
     C                   Eval      WSlashFlag = 'Y'
     C**********         If        PMInpType = 'G'                                            250600
     C**********                   Or PMInpType = 'P'                                         250600
     C**********                   Or PMInpType = 'F'                                         250600
     C**********                   Or PMInpType = 'R'                                         250600
     C**********                   Or PMInpType = 'I'                                         250600

     C**********         If        %Subst(WInpParm:2:1) <> *Blanks                          BUG14755
      *                                                                                       250600
     C                   If        PMAccount <> *Blanks                                       250600
     C                             Or P@IBAN <> *Blanks                                       250600

     C                   Exsr      ValACOUNTIBAN

     C**********         Else                                                               BUG14755
     C**********         Eval      PMMsgID = 'FTS0032'                                      BUG14755
     C**********         Exsr      SetError                                                 BUG14755
     C**********         EndIf                                                              BUG14755

     C**********         Else                                                                250804A
     C**********         Eval      PMMsgID = 'FTS0032'                                      BUG14593
     C**********         Eval      PMMsgID = 'FTS0051'                              BUG14593 250804A
     C**********         Exsr      SetError                                                  250804A
     C                   EndIf

     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValSwift - validate swift code                                *
      *****************************************************************
     C     ValSwift      BegSR

     C**********         If        PMInpType = *Blanks                               BUG14856 250600
      *                                                                                       250600
     C                   Eval      FromOtherDtl = 'N'                                         250600
      *                                                                                       250600
     C                   If        PMInpType = *Blanks OR  PMInpType = 'A'                    250600
     C                   If        PMValType = 'TRAN'                                       BUG15090
     C                   Exsr      ValSwiftMEOUFM                                            CSW207A
     C                   EndIf                                                              BUG15090
     C                   EndIf                                                              BUG14856
      *                                                                                       250600
     C                   If        PMValType = 'FRMT'                                         250600
     C                             and WSwiftCode <> WSWCD                                    250600
      *                                                                                       250600
     C                   If        WSwiftCode = 'IBEI' and                                    250600
     C                             CSW209 <> 'Y' AND                                          CSW209
     C                             W_IBEI <> *Blanks or                                       250600
     C                             WSwiftCode = 'NIDN' and                                    250600
     C                             W_NIDN <> *Blanks or                                       250600
     C                             WSwiftCode = 'CUST' and                                    250600
     C                             W_CUST <> *Blanks and                                      250600
     C                             PMNonAcctHldr = *Blanks  or                                250600
     C                             WSwiftCode = 'CUST' and                                    250600
     C                             W_NAHO <> *Blanks and                                      250600
     C                             PMNonAcctHldr <> *Blanks                                   250600
      *                                                                                       250600
     C                   Eval      FromOtherDtl = 'Y'                                         250600
      *                                                                                       250600
     C                   Goto      Ex_ValSwift                                                250600
      *                                                                                       250600
     C                   Endif                                                                250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   If        WContinue = 'Y'                                           CSW207A
                                                                                             CSW207A
     C                   Exsr      GetSlash

     C                   Select

     C                   When      WSlash3 = '/'
     C                   Exsr      ValSYYYYXXCCC

     C                   When      WSlash2 = '/'
     C                   Exsr      ValSYYYYXX

     C                   When      WSlash1 = '/'
     C                   Exsr      ValSYYYY

     C                   EndSL
                                                                                             CSW207A
     C                   EndIf                                                               CSW207A

     C     Ex_ValSwift   Tag                                                                  250600
     C                   EndSR

      *****************************************************************                      CSW207A
      /EJECT                                                                                 CSW207A
      *****************************************************************                      CSW207A
      * ValSwiftMEOUFM - Validate Swift code on MEOUFMPD              *                      CSW207A
      *****************************************************************                      CSW207A
     C     ValSwiftMEOUFMBegSR                                                               CSW207A
                                                                                             CSW207A
     C                   Exsr      InitDefaults                                              CSW207A
                                                                                             CSW207A
      *                                                                                      CSW207A
      **  Call AOUMFR0 for *FORMAT                                                           CSW207A
      *                                                                                      CSW207A
     C                   Eval      WSwiftFlag = 'N'                                          CSW207A
     C                   Eval      PMAction = '*FORMAT'                                      CSW207A
     C                   Eval      PMOption = '*KEY  '                                       CSW207A
     C                   Exsr      ValAOOUFMR0                                               CSW207A
                                                                                             CSW207A
     C                   DoW       PMReturnCode <> '*EOF'                                    CSW207A
     C                             And PMReturnCode <> '*ERROR'                             BUG15045
     C                             And PMReturnCode <> '*NRF'                               BUG15045
      *                                                                                     BUG24614
     C                   If        CSW209 = 'Y'                                             BUG24614
      *                                                                                     BUG24614
     C                   Exsr      ValOMFMSeq                                               BUG24614
      *                                                                                     BUG24614
     C                   IF        %SUBST(OM50F1:1:4) = varInput1 And                       BUG24614
     C                             %SubSt(OM50F2:1:2) = varInput2 And                       BUG24614
     C                             %SubSt(OM50F3:1:2) = varInput3 And                       BUG24614
     C                             %SubSt(OM50F4:1:2) = varInput4 And                       BUG24614
     C                             %SubSt(OM50F5:1:2) = varInput5                           BUG24614
     C                   EVAL      WSwiftFlag = 'Y'                                         BUG24614
     C                   LEAVE                                                              BUG24614
     C                   ENDIF                                                              BUG24614
      *                                                                                     BUG24614
     C                   Else                                                               BUG24614
                                                                                             CSW207A
     C                   If        WSwiftCode = %SubSt(OM50F1:1:4)                           CSW207A
     C                             AND %SubSt(OM50F2:1:2)                                     256834
     C                              = %SubSt(PMinpParm2:1:2)                                  256834
     C                             AND %SubSt(OM50F3:1:2)                                     256834
     C                              = %SubSt(PMinpParm3:1:2)                                  256834
     C                             AND %SubSt(OM50F4:1:2)                                     256834
     C                              = %SubSt(PMinpParm4:1:2)                                  256834
     C                             AND %SubSt(OM50F5:1:2)                                     256834
     C                              = %SubSt(PMinpParm5:1:2)                                  256834
     C                   Eval      WSwiftFlag = 'Y'                                          CSW207A
     C                   Leave                                                               CSW207A
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
     C                   EndIf                                                              BUG24614
      *                                                                                     BUG24614
      ** If the access to AOOUFMR0 find a definition for IBEI set-up before current           250600
      ** identification type and IBEI is not blanks, use IBEI definition                      250600
      ** If next lines do no match setup requirements, must be restored to initial value,     250600
      ** Save it                                                                              250600
     C                   Eval      WSWCDSave = WSWCD                                          250600
      *                                                                                       CSW209
     C                   If        CSW209 <> 'Y'                                              CSW209
     C                   If        %SubSt(OM50F1:1:4) = 'IBEI'                                250600
     C                             and CSIBEI <> *Blanks                                      250600
     C                   Eval      WSWCD = 'IBEI'                                             250600
     C                   Eval      WSwiftFlag = 'Y'                                           250600
     C                   Leave                                                                250600
     C                   EndIf                                                                250600
     C                   EndIf                                                                CSW209
      *                                                                                       250600
      ** Same test for NIDN                                                                   250600
     C                   If        %SubSt(OM50F1:1:4) = 'NIDN'                                250600
     C                             and W_E5IDNO <> *Blanks                                    250600
     C                   Eval      WSWCD = 'NIDN'                                             250600
     C                   Eval      WSwiftFlag = 'Y'                                           250600
     C                   Leave                                                                250600
     C                   EndIf                                                                250600
      *                                                                                       250600
     C**********         Eval      PMOption = '*NEXT '                                CSW207A 250600
     C                   Eval      PMOption = '*NEXTEQ'                               CSW207A 250600
     C                   Exsr      ValAOOUFMR0                                               CSW207A
                                                                                             CSW207A
     C                   EndDo                                                               CSW207A
                                                                                             CSW207A
     C                   If        WSwiftFlag = 'N'                                          CSW207A
     C                             And WContinue = 'Y'                                       CSW207A
     C**********                   And (PMInpType <> 'A' And PMInpType <> ' ')     BUG15003 BUG15010
     C**********         Eval      PMMsgId = 'FTS0016'                              CSW207A BUG15010
     C                   Eval      PMMsgId = 'FTS0055'                                      BUG15010
     C**********         Eval      PMErrType = 'E'                                   CSW207A 250804A
     C**********         Eval      WContinue = 'N'                                  CSW207A BUG15010
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
     C                   EndSR                                                               CSW207A
                                                                                             CSW207A
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValNCode - validate number code                               *
      *****************************************************************
     C     ValNCode      BegSR

     C                   Exsr      GetSlash

     C                   Eval      WNDesc   = 'N'
     C                   Eval      WISOCode = *Blanks
     C                   Eval      WISODesc = 'N'
     C                   Eval      WIssFlag = 'N'
     C                   Eval      WIssDesc = 'N'
      *                                                                                       CSW215
     C                   IF        CSW215 = 'Y' AND Wncode = '3'                              CSW215
     C                   EVAL      CtrN3  = CtrN3 + 1                                         CSW215
     C                   ENDIF                                                                CSW215

     C                   Select

     C                   When      WSlash3 = '/'
     C                   Exsr      ValNXXCCC

     C                   When      WSlash2 = '/'
     C                   Exsr      ValNXX

     C                   When      WSlash1 = '/'
     C                   Exsr      ValN

     C                   EndSL

     C                   If        WContinue = 'Y'
     C                   Exsr      ValColAsc
     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * GetSlash - get slash per column                               *
      *****************************************************************
     C     GetSlash      BegSR

     C                   Eval      WPtr  = 0
     C                   Eval      WSlashCtr = 0
     C     '/'           Scan      WInpParm:1    WPtr
     C                   If        WPtr > 0
     C**********         Eval      WSlashCtr += 1                                           BUG15045
     C                   Eval      WSlashCtr = WSlashCtr + 1                                BUG15045
     C                   Eval      WSlash1 = %Subst(WInpParm:WPtr:1)
     C                   Eval      WPtr1 = WPtr + 1
     C                   Eval      WPtr  = 0
     C     '/'           Scan      WInpParm:WPtr1WPtr
     C                   If        WPtr > 0
     C**********         Eval      WSlashCtr += 1                                           BUG15045
     C                   Eval      WSlashCtr = WSlashCtr + 1                                BUG15045
     C                   Eval      WSlash2 = %Subst(WInpParm:WPtr:1)
     C                   Eval      WPtr2 = WPtr + 1
     C                   Eval      WPtr  = 0
     C     '/'           Scan      WInpParm:WPtr2WPtr
     C                   If        WPtr > 0
     C**********         Eval      WSlashCtr += 1                                           BUG15045
     C                   Eval      WSlashCtr = WSlashCtr + 1                                BUG15045
     C                   Eval      WSlash3 = %Subst(WInpParm:WPtr:1)
     C                   Eval      WPtr3 = WPtr
     C                   Else
     C                   EndIf
     C                   Else
     C                   EndIf
     C                   EndIf

     C                   If        WPtr1 > 0
     C**********         Eval      WPtr1 -= 1                                               BUG15045
     C                   Eval      WPtr1 = WPtr1 - 1                                        BUG15045
     C                   EndIf

     C                   If        WPtr2 > 0
     C**********         Eval      WPtr2 -= 1                                               BUG15045
     C                   Eval      WPtr2 = WPtr2 - 1                                        BUG15045
     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValSYYYYXXCCC - validate swift code, ISO code and issuer code *
      *****************************************************************
     C     ValSYYYYXXCCC BegSR

     C                   If        WSwiftCode =  'CUST'                                     BUG15045
     C                             Or  WSwiftCode =  'DRLC'                                 BUG15045
     C                             Or  WSwiftCode =  'EMPL'                                 BUG15045
                                                                                            BUG15045
     C                   If        %Subst(PMInpParm1:8:2) = '//'                            BUG15045
     C                             AND PMMsgID = *BLANKS                                    BUG25101
     C**********         SELECT                                                    BUG15045 BUG25101
     C**********         When      WSwiftCode = 'CUST'                             BUG15045 BUG25101
     C**********         Eval      PMMsgID = 'FTS0043'                             BUG15045 BUG25101
     C**********         When      WSwiftCode = 'DRLC'                             BUG15045 BUG25101
     C**********         Eval      PMMsgID = 'FTS0045'                             BUG15045 BUG25101
     C**********         When      WSwiftCode = 'EMPL'                             BUG15045 BUG25101
     C**********         Eval      PMMsgID = 'FTS0046'                             BUG15045 BUG25101
     C**********         ENDSL                                                     BUG15045 BUG25101
                                                                                            BUG15045
     C**********         Exsr      SetError                                        BUG15045 BUG25101
     C**********         Eval      PMErrType = 'E'                                 BUG15045 BUG25101
     C                   Eval      PMMsgID = 'FTS0079'                                      BUG25101
     C                   Eval      PMErrType = 'W'                                          BUG25101
     C                   EndIf                                                              BUG15045
     C                   EndIf                                                              BUG15045
                                                                                            BUG15045
      *                                                                                     BUG24297
      ** If 1st line starts with valid SWIFT Code                                           BUG24297
      ** it can have several '/'                                                            BUG24297
      *                                                                                     BUG24297
     C**********         If        WSwiftCode <> 'CUST'                                     BUG24297
     C**********                   And WSwiftCode <> 'DRLC'                                 BUG24297
     C**********                   And WSwiftCode <> 'EMPL'                                 BUG24297
      **********                                                                            BUG24297
     C**********         Eval      PMMsgID = 'FTS0019'                                       CSW207A
     C**********         SELECT                                                     CSW207A BUG24297
     C**********         When      WSwiftCode = 'ARNU'                              CSW207A BUG24297
     C**********         Eval      PMMsgID = 'FTS0042'                              CSW207A BUG24297
     C**********         When      WSwiftCode = 'CCPT'                              CSW207A BUG24297
     C**********         Eval      PMMsgID = 'FTS0044'                              CSW207A BUG24297
     C**********         When      WSwiftCode = 'IBEI'                              CSW207A BUG24297
     C**********         IF        CSW209 <> 'Y'                                     CSW209 BUG24297
     C**********         Eval      PMMsgID = 'FTS0047'                              CSW207A BUG24297
     C**********         ENDIF                                                       CSW209 BUG24297
     C**********         When      WSwiftCode = 'NIDN'                              CSW207A BUG24297
     C**********         Eval      PMMsgID = 'FTS0048'                              CSW207A BUG24297
     C**********         When      WSwiftCode = 'SOSE'                              CSW207A BUG24297
     C**********         Eval      PMMsgID = 'FTS0049'                              CSW207A BUG24297
     C**********         When      WSwiftCode = 'TXID'                              CSW207A BUG24297
     C**********         Eval      PMMsgID = 'FTS0050'                              CSW207A BUG24297
     C**********         ENDSL                                                      CSW207A BUG24297
      **********                                                                    CSW207A BUG24297
     C**********         Exsr      SetError                                                 BUG24297
     C**********         Eval      PMErrType = 'E'                                 BUG15045 BUG24297
      **********                                                                            BUG24297
     C**********         Else                                                               BUG24297
     C                   Eval      WISOCode = %Subst(WInpParm:WPtr1+1:2)
     C                   Eval      WIssFlag = 'Y'

     C                   If        PMMsgID = *BLANKS                                        BUG25101
     C                   Select
     C                   When      PMValType = 'TRAN'
      *
      ** Issuer description should not blanks
      *
     C                   EVAL      WINUM = (WPTR3 - WPTR2) - 1                              BUG24555
     C                   IF        WSwiftCode =  'CUST'                                     BUG24555
     C                             OR  WSwiftCode =  'DRLC'                                 BUG24555
     C                             OR  WSwiftCode =  'EMPL'                                 BUG24555
     C                   IF        %SUBST(WInpParm:WPtr2+1:WINUM) <> *BLANKS                BUG24555
     C                             AND %SUBST(WInpParm:WPtr3+1:1) <> *BLANKS                BUG26129
     C                   EVAL      WIssDesc = 'Y'                                           BUG24555
     C                   ELSE                                                               BUG24555
     C**********         EVAL      PMMsgID = 'FTS0007'                             BUG24555 BUG26024
     C                   EVAL      PMMsgID = 'FTS0081'                                      BUG26024
     C                   EXSR      SetError                                                 BUG24555
     C                   EVAL      PMErrType = 'E'                                          BUG24555
     C                   ENDIF                                                              BUG24555
     C                   ELSE                                                               BUG24555
     C**********         If        %Subst(WInpParm:WPtr3+1:1) <> *Blanks                    BUG24555
     C**********         Eval      WIssDesc = 'Y'                                           BUG24555
     C**********         Else                                                               BUG24555
     C                   IF        %SUBST(WInpParm:WPtr3+1:1) = *BLANKS                     BUG24555
     C                             AND %SUBST(WInpParm:WPtr2+1:WINUM) = *BLANKS             BUG24555
     C                   Eval      PMMsgID = 'FTS0007'
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   ELSE                                                               BUG24555
     C                   EVAL      WIssDesc = 'Y'                                           BUG24555
     C                   ENDIF                                                              BUG24555
     C                   EndIf

     C**********         When      PMValType = 'FRMT'                                       BUG15090
      **********                                                                            BUG15090
      ***Issuer*should*be*blanks                                                            BUG15090
      **********                                                                            BUG15090
     C**********         If        %Subst(WInpParm:WPtr3+1:1) <> *Blanks                    BUG15090
     C**********         Eval      PMMsgID = 'FTS0007'                                      BUG15090
     C**********         Exsr      SetError                                                 BUG15090
     C**********         Eval      PMErrType = 'E'                                 BUG15045 BUG15090
     C**********         EndIf                                                              BUG15090

     C                   EndSL
     C                   EndIf                                                              BUG25101

     C                   If        WContinue = 'Y'
     C                   Exsr      ValISOCode
     C                   EndIf

     C**********         EndIf                                                              BUG24297

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValSYYYYXX - validate swift code and ISO code                 *
      *****************************************************************
     C     ValSYYYYXX    BegSR

     C**********         If        WSwiftCode = 'CUST'                               CSW207A CSW207A
     C                   If        (WSwiftCode = 'CUST'                                      CSW207A
     C                             OR WSwiftCode = 'DRLC'                                    CSW207A
     C**********                   OR WSwiftCode = 'EMPL'                            CSW207A CSW207A
     C                             OR WSwiftCode = 'EMPL')                                   CSW207A
     C                             AND PMValType = 'TRAN'                                    CSW207A
     C                             AND PMMsgID = *BLANKS                                    BUG25101
                                                                                             CSW207A
     C**********         SELECT                                                     CSW207A BUG25101
     C**********         When      WSwiftCode = 'CUST'                              CSW207A BUG25101
     C**********         Eval      PMMsgID = 'FTS0043'                              CSW207A BUG25101
     C**********         When      WSwiftCode = 'DRLC'                              CSW207A BUG25101
     C**********         Eval      PMMsgID = 'FTS0045'                              CSW207A BUG25101
     C**********         When      WSwiftCode = 'EMPL'                              CSW207A BUG25101
     C**********         Eval      PMMsgID = 'FTS0046'                              CSW207A BUG25101
     C**********         ENDSL                                                      CSW207A BUG25101
                                                                                             CSW207A
     C**********         Exsr      SetError                                         CSW207A BUG25101
     C**********         Eval      PMErrType = 'E'                                 BUG15045 BUG25101
     C                   Eval      PMMsgID = 'FTS0079'                                      BUG25101
     C                   Eval      PMErrType = 'W'                                          BUG25101
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
     C                   If        WSwiftCode = 'IBEI'
     C                   If        CSW209 <> 'Y'                                              CSW209
     C                   Eval      PMMsgID = 'FTS0028'
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15178
     C                   EndIf                                                                CSW209

     C                   Else
     C                   Eval      WISOCode = %Subst(WInpParm:WPtr1+1:2)

     C                   Select
     C                   When      PMValType = 'TRAN'
      *
      ** ISO code description should not blanks
      *
     C                   If        %Subst(WInpParm:WPtr2+1:1) <> *Blanks
     C                   Eval      WISODesc = 'Y'
     C                   Else
     C                   Select
     C                   When      %Subst(WInpParm:1:4)='ARNU'
     C                   Eval      PMMsgID = 'FTS0005'
     C                   When      %Subst(WInpParm:1:4)='CCPT'
     C                   Eval      PMMsgID = 'FTS0006'
     C                   When      %Subst(WInpParm:1:4)='CUST'
     C                             Or %Subst(WInpParm:1:4)='DRLC'                           BUG26024
     C                             Or %Subst(WInpParm:1:4)='EMPL'                           BUG26024
     C                   Eval      PMMsgID = 'FTS0081'                                      BUG26024
     C**********         Eval      PMMsgID = 'FTS0002'                                      BUG26024
     C**********         When      %Subst(WInpParm:1:4)='DRLC'                              BUG26024
     C**********         Eval      PMMsgID = 'FTS0008'                                      BUG26024
     C**********         When      %Subst(WInpParm:1:4)='EMPL'                              BUG26024
     C**********         Eval      PMMsgID = 'FTS0011'                                      BUG26024
     C                   When      %Subst(WInpParm:1:4)='NIDN'
     C                   Eval      PMMsgID = 'FTS0013'
     C                   When      %Subst(WInpParm:1:4)='SOSE'                              BUG15252
     C                   Eval      PMMsgID = 'FTS0014'                                      BUG15252
     C                   When      %Subst(WInpParm:1:4)='TXID'                              BUG15252
     C                   Eval      PMMsgID = 'FTS0015'                                      BUG15252
     C                   EndSl
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndIf

     C**********         When      PMValType = 'FRMT'                                       BUG15090
      **********                                                                            BUG15090
      ***ISO*code*description*should*be*blanks                                              BUG15090
      **********                                                                            BUG15090
     C**********         If        %Subst(WInpParm:WPtr2+1:1) <> *Blanks                    BUG15090
     C**********         Select                                                             BUG15090
     C**********         When      %Subst(WInpParm:1:4)='ARNU'                              BUG15090
     C**********         Eval      PMMsgID = 'FTS0005'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:4)='CCPT'                              BUG15090
     C**********         Eval      PMMsgID = 'FTS0006'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:4)='CUST'                              BUG15090
     C**********         Eval      PMMsgID = 'FTS0002'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:4)='DRLC'                              BUG15090
     C**********         Eval      PMMsgID = 'FTS0008'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:4)='EMPL'                              BUG15090
     C**********         Eval      PMMsgID = 'FTS0011'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:4)='NIDN'                              BUG15090
     C**********         Eval      PMMsgID = 'FTS0013'                                      BUG15090
     C**********         EndSl                                                              BUG15090
     C**********         Exsr      SetError                                                 BUG15090
     C**********         Eval      PMErrType = 'E'                                 BUG15045 BUG15090
     C**********         EndIf                                                              BUG15090

     C                   EndSL

     C                   If        WContinue = 'Y'
     C                   Exsr      ValISOCode
     C                   EndIf

     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValSYYYY- validate Swift code                                 *
      *****************************************************************
     C     ValSYYYY      BegSR

     C                   Eval      WISOCode = %Subst(WInpParm:WPtr1+1:2)

     C                   Select
     C                   When      PMValType = 'TRAN'
      *
      ** ISO code description should be blanks
      *
     C**********         If        %Subst(WInpParm:WPtr1+1:1) <> *Blanks                    BUG25101
     C**********                   And WSwiftCode <> 'IBEI'                        BUG15065 BUG25101
     C                   If        WSwiftCode <> 'IBEI'                                     BUG25101
     C                   Eval      PMMsgID = 'FTS0004'
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndIf
     C                   If        CSW209 <> 'Y'                                              CSW209
     C                   If        WSwiftCode = 'IBEI'                                      BUG15045
     C                             And %Subst(WInpParm:WPtr1+1:1) = *Blanks                 BUG15045
     C                   Eval      PMMsgID = 'FTS0004'                                      BUG15045
     C                   Exsr      SetError                                                 BUG15045
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndIf                                                              BUG15045
     C                   EndIf                                                                CSW209

     C**********         When      PMValType = 'FRMT'                                       BUG15090
      **********                                                                            BUG15090
      ***ISO*code*description*should*be*blanks                                              BUG15090
      **********                                                                            BUG15090
     C**********         If        %Subst(WInpParm:WPtr2+1:1) <> *Blanks                      250600
     C**********         If        %Subst(WInpParm:WPtr1+1:1) <> *Blanks             250600 BUG15090
     C**********         Eval      PMMsgID = 'FTS0004'                                      BUG15090
     C**********         Exsr      SetError                                                 BUG15090
     C**********         Eval      PMErrType = 'E'                                 BUG15045 BUG15090
     C**********         EndIf                                                              BUG15090

     C                   EndSL

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValNXXCCC - validate n code, ISO code and issuer code         *
      *****************************************************************
     C     ValNXXCCC     BegSR
      *                                                                                       CSW215
      ** If not 1st occurence of 3, issue format error as required value                      CSW215
      ** should be additional details when CSW215 is enabled                                  CSW215
      *                                                                                       CSW215
     C                   IF        CSW215 = 'Y' AND WNCode = '3'                              CSW215
     C                             AND WPrevNCode = '3'                                       CSW215
     C                             AND PMValType = 'TRAN'                                     CSW215
     C                   EVAL      PMMsgID = 'FTS0083'                                        CSW215
     C                   EXSR      SetError                                                   CSW215
     C                   EVAL      PMErrType = 'E'                                            CSW215
     C                   LEAVESR                                                              CSW215
     C                   ENDIF                                                                CSW215

      *                                                                                     BUG24297
      ** Each lines can have several '/' whatever the                                       BUG24297
      ** first digit in the line                                                            BUG24297
      *                                                                                     BUG24297
     C**********         If        WNCode <> '6'                                            BUG24297
     C**********                   And WNCode <> '3'                               BUG24150 BUG24297
     C**********         Eval      PMMsgID = 'FTS0022'                                      BUG24297
     C**********         Exsr      SetError                                                 BUG24297
     C**********         Eval      PMErrType = 'E'                                 BUG15045 BUG24297
      **********                                                                            BUG24297
     C**********         Else                                                               BUG24297
     C                   Eval      WISOCode = %Subst(WInpParm:WPtr1+1:2)
     C                   Eval      WIssFlag = 'Y'
      *
      ** Issuer description should not be blanks
      *
     C                   IF        %SUBST(WInpParm:1:1) = '6'                               BUG24509
     C                   Select
     C                   When      PMValType = 'TRAN'
     C                   If        %Subst(WInpParm:WPtr3+1:1) <> *Blanks
     C                             Or %SUBST(WInpParm:5:2) = '//'                           BUG25101
     C                   Eval      WIssDesc = 'Y'
     C                   Else
     C**********         Eval      PMMsgID = 'FTS0007'                                      BUG26024
     C                   Eval      PMMsgID = 'FTS0081'                                      BUG26024
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndIf

      *                                                                                     BUG24466
      ** Issuer description should not start with '/' for 6/.                               BUG24466
      *                                                                                     BUG24466
     C                   IF        %SUBST(WInpParm:1:1) = '6' And                           BUG24466
     C                             %SUBST(WInpParm:6:1) <> ' ' And                          BUG24554
     C                             %SUBST(WInpParm:6:1) <> '/'                              BUG24466
     C                   EVAL      WIssDesc = 'Y'                                           BUG24466
     C                   ELSE                                                               BUG24466
     C                   If        PMMsgID = *BLANKS                                        BUG25101
     C**********         EVAL      PMMsgID = 'FTS0007'                             BUG24466 BUG25101
     C**********         EXSR      SetError                                        BUG24466 BUG25101
     C**********         EVAL      PMErrType = 'E'                                 BUG24466 BUG25101
     C                   Eval      PMMsgID = 'FTS0079'                                      BUG25101
     C                   Eval      PMErrType = 'W'                                          BUG25101
     C                   EndIf                                                              BUG25101
     C                   ENDIF                                                              BUG24466
                                                                                            BUG24466
     C**********         When      PMValType = 'FRMT'                                       BUG15090
      **********                                                                            BUG15090
     C**********         If        %Subst(WInpParm:WPtr3+1:1) <> *Blanks                    BUG15090
     C**********         Eval      PMMsgID = 'FTS0007'                                      BUG15090
     C**********         Exsr      SetError                                                 BUG15090
     C**********         Eval      PMErrType = 'E'                                 BUG15045 BUG15090
     C**********         EndIf                                                              BUG15090

     C                   EndSL
     C                   ENDIF                                                              BUG24509

      *                                                                                     BUG24297
      ** Validate ISO code if line starts with 3/, 5/, 6/ or 7/                             BUG24297
      *                                                                                     BUG24297
     C                   If        WContinue = 'Y'
     C                             AND                                                      BUG24297
     C                             (WNCode = '3' OR                                         BUG24297
     C                              WNCode = '5' OR                                         BUG24297
     C                              WNCode = '6' OR                                         BUG24297
     C                              WNCode = '7')                                           BUG24297
     C                   Exsr      ValISOCode
     C                   EndIf
      *                                                                                       CSW215
      ** When previous number is 2, require number 3 to have                                  CSW215
      ** additional details                                                                   CSW215
      *                                                                                       CSW215
     C                   IF        CSW215 = 'Y' AND WNCode = '3'                              CSW215
     C                             AND WPrevNCode = '2' AND                                   CSW215
     C                             %Subst(WInpParm:6:30) = *BLANKS                            CSW215
     C                             AND PMValType = 'TRAN'                                     CSW215
     C                   EVAL      PMMsgID = 'FTS0084'                                        CSW215
     C                   EXSR      SetError                                                   CSW215
     C                   EVAL      PMErrType = 'E'                                            CSW215
     C                   ENDIF                                                                CSW215

     C**********         EndIf                                                              BUG24297

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValNXX - validate n code and ISO code                         *
      *****************************************************************
     C     ValNXX        BegSR

      *                                                                                       CSW215
      ** If not 1st occurence of 3, issue format error as required value                      CSW215
      ** should be additional details when CSW215 is enabled                                  CSW215
      *                                                                                       CSW215
     C                   IF        CSW215 = 'Y' AND WNCode = '3'                              CSW215
     C                             AND WPrevNCode = '3'                                       CSW215
     C                             AND PMValType = 'TRAN'                                     CSW215
     C                   EVAL      PMMsgID = 'FTS0083'                                        CSW215
     C                   EXSR      SetError                                                   CSW215
     C                   EVAL      PMErrType = 'E'                                            CSW215
     C                   LEAVESR                                                              CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   If        WNCode <> '3'
     C                             And WNCode <> '5'
     C                             And WNCode <> '6'
     C                             And WNCode <> '7'

      ** Free format for code 1/, 2/, 4/ or 8/                                              BUG15045
     C**********         Eval      PMMsgID = 'FTS0023'                                      BUG15045
     C**********         Exsr      SetError                                                 BUG15045
     C                   Else
     C                   Eval      WISOCode = %Subst(WInpParm:WPtr1+1:2)
      *
      ** TINO should not be blanks
      *
     C                   Select
     C                   When      PMValType = 'TRAN'
     C**********         If        %Subst(WInpParm:WPtr2+1:1) <> *Blanks                    BUG15045
     C                   If        %Subst(WInpParm:WPtr2+1) <> *Blanks                      BUG15045
     C                   Eval      WISODesc = 'Y'
     C                   If        WnCode = '6'                                              CSW207A
     C                             And PMMsgID = *BLANKS                                    BUG25101
     C**********         Eval      PMMsgID = 'FTS0039'                              CSW207A BUG25101
     C**********         Eval      PMErrType = 'E'                                  CSW207A BUG25101
     C**********         Exsr      SetError                                        BUG15045 BUG25101
     C                   Eval      PMMsgID = 'FTS0079'                                      BUG25101
     C                   Eval      PMErrType = 'W'                                          BUG25101
     C                   EndIf                                                               CSW207A
     C                   Else
     C                   Select
     C                   When      %Subst(WInpParm:1:1) = '1'
     C**********         Eval      PMMsgID = 'FTS0036'                                       CSW207A
     C                   Eval      PMMsgID = 'FTS0020'                                       CSW207A
     C                   When      %Subst(WInpParm:1:1) = '2'
     C                   Eval      PMMsgID = 'FTS0021'
     C                   When      %Subst(WInpParm:1:1) = '3'
     C                   IF        CSW215 = 'Y' AND WNCode = '3'                              CSW215
     C                   EVAL      PMMsgID = 'FTS0084'                                        CSW215
     C                   ELSE                                                                 CSW215
     C                   Eval      PMMsgID = 'FTS0030'
     C                   ENDIF                                                                CSW215
     C                   When      %Subst(WInpParm:1:1) = '4'
     C                   Eval      PMMsgID = 'FTS0018'
     C                   When      %Subst(WInpParm:1:1) = '5'
     C                   Eval      PMMsgID = 'FTS0031'
     C                   When      %Subst(WInpParm:1:1) = '6'
     C                   Eval      PMMsgID = 'FTS0002'
     C                   When      %Subst(WInpParm:1:1) = '7'
     C                   Eval      PMMsgID = 'FTS0013'
     C                   When      %Subst(WInpParm:1:1) = '8'
     C                   Eval      PMMsgID = 'FTS0024'
     C                   EndSl
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndIf

     C**********         When      PMValType = 'FRMT'                                       BUG15090
      **********                                                                            BUG15090
     C**********         If        %Subst(WInpParm:WPtr2+1:1) <> *Blanks                    BUG15090
     C**********         Select                                                             BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '1'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0036'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '2'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0036'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '3'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0029'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '4'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0036'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '5'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0029'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '6'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0029'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '7'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0029'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '8'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0024'                                      BUG15090
     C**********         EndSl                                                              BUG15090
     C**********         Exsr      SetError                                                 BUG15090
     C**********         Eval      PMErrType = 'E'                                 BUG15045 BUG15090
     C**********         EndIf                                                              BUG15090

     C                   EndSL

     C                   If        WContinue = 'Y'
     C                   Exsr      ValISOCode
     C                   EndIf

     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValN - validate n code                                        *
      *****************************************************************
     C     ValN          BegSR

     C                   IF        CSW215 = 'Y' AND WNCode = '3'                              CSW215
     C                             AND PMValType = 'TRAN'                                     CSW215
      *                                                                                       CSW215
      ** Check if number code is 3 with valid ISO country code                                CSW215
      *                                                                                       CSW215
     C**********         IF        WPrevNCode = '1' AND                              CSW215 MD037229
     C**********                   %Subst(WInpParm:5:30) = *BLANKS                   CSW215 MD037229
     C                   IF        WPrevNCode <> '3'                                        MD037229
     C                   EVAL      WISOCode = %SUBST(WInpParm:3:2)                            CSW215
     C     WISOCode      CHAIN     MEISOCL0                                                   CSW215
     C                   IF        NOT %FOUND(MEISOCL0)                                       CSW215
     C                   EVAL      PMMsgID = 'FTS0082'                                        CSW215
     C                   EXSR      SetError                                                   CSW215
     C                   EVAL      PMErrType = 'E'                                            CSW215
     C                   LEAVESR                                                              CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      WISOChk = 'Y'                                            MD034516
     C                   LEAVESR                                                              CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
      ** Check if additional details is required                                              CSW215
      *                                                                                       CSW215
     C**********         IF        WPrevNCode = '3' AND                              CSW215 MD037229
     C**********                   %SUBST(WSaveInp:5:1) <> '/' AND                   CSW215 MD037229
     C**********                   CtrN3 = 2                                         CSW215 MD034516
     C**********                   CtrN3 = 2 AND WISOChk <> 'Y'                    MD034516 MD037229
     C**********         EVAL      PMMsgID = 'FTS0082'                               CSW215 MD037229
     C**********         EXSR      SetError                                          CSW215 MD037229
     C**********         EVAL      PMErrType = 'E'                                   CSW215 MD037229
     C**********         ENDIF                                                       CSW215 MD037229
      *                                                                                       CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C**********         If        WNCode = '3'                                              CSW207A
     C**********         If        (WNCode = '3'                                      CSW207A CSW215
     C                   IF        ((WNCode = '3' AND CSW215 = 'N')                           CSW215
     C                             OR (WNCode = '3' AND CSW215 = 'Y'                          CSW215
     C                             AND WPrevNCode <> '3')                                     CSW215
     C                             Or WNCode = '5'
     C                             Or WNCode = '6'
     C**********                   Or WNCode =  '7'                                          CSW207A
     C                             Or WNCode =  '7')                                         CSW207A
     C                             And PMValType ='TRAN'                                     CSW207A

     C**********         Eval      PMMsgID = 'FTS0029'                                       CSW207A
     C**********         Exsr      SetError                                                  CSW207A
     C**********         IF        CSW215 = 'Y' AND WNCode = '3'                     CSW215 MD037229
     C**********         EVAL      PMMsgID = 'FTS0082'                               CSW215 MD037229
     C**********         ELSE                                                        CSW215 MD037229
     C                   Eval      PMMsgID = 'FTS0029'                                       CSW207A
     C**********         ENDIF                                                       CSW215 MD037229
     C                   Exsr      SetError                                                  CSW207A
     C                   Eval      PMErrType = 'E'                                          BUG15045

     C                   Else
      *
      ** Address should not be blanks
      *
     C                   Select
     C                   When      PMValType = 'TRAN'
      * Ordering Cust can have syntax '2/ CUSTOMER NAME ' WPtr1 = 2                           252494
      * Need to add 2 not 1                                                                   252494
     C**********         If        %Subst(WInpParm:WPtr1+1:1) <> *Blanks                      252494
     C**********         If        %Subst(WInpParm:WPtr1+2:1) <> *Blanks             252494 AR845543
     C                   MOVE      'N'           CMPLTE            1                        AR845543
     C                   Z-ADD     1             M                 2 0                      AR845543
     C     'Y'           DOWNE     CMPLTE                                                   AR845543
     C                   IF        %Subst(WInpParm:WPtr1+M:1) <> *Blanks                    AR845543
     C                             and (M < 36)                                             AR845543
     C                   MOVE      'Y'           CMPLTE                                     AR845543
     C                   MOVE      'Y'           ACCPTABLE         1                        AR845543
     C                   Else                                                               AR845543
     C                   ADD       1             M                                          AR845543
     C                   IF        M = 36                                                   AR845543
     C                   MOVE      'Y'           CMPLTE                                     AR845543
     C                   MOVE      'N'           ACCPTABLE                                  AR845543
     C                   ENDIF                                                              AR845543
     C                   ENDIF                                                              AR845543
     C                   ENDDO                                                              AR845543
     C                   IF        ACCPTABLE = 'Y'                                          AR845543
     C                   Eval      WNDesc = 'Y'
                                                                                             CSW207A
     C                   Select                                                              CSW207A
     C                   When      %Subst(WInpParm:1:1) = '4'                                CSW207A
                                                                                             CSW207A
     C                   If        %Subst(WInpParm:WPtr1+9:1) <> *Blanks                     CSW207A
     C                   Eval      PMMsgID = 'FTS0017'                                       CSW207A
     C                   Exsr      SetError                                                  CSW207A
     C                   Eval      PMErrType = 'E'                                          BUG15045
                                                                                             CSW207A
     C                   Else                                                                CSW207A
     C                   Eval      WYYYYMMDD = %Subst(WInpParm:WPtr1+1:8)                    CSW207A
     C                   TestN                   WYYYYMMDD            98                     CSW207A
                                                                                             CSW207A
     C                   If        *IN98 = *On                                               CSW207A
     C                   Move      WYYYYMMDD     PMYYYYMMDD                                  CSW207A
     C     *ISO          Test(D)                 PMYYYYMMDD             98                   CSW207A
     C                   If        *IN98 = *On                                               CSW207A
     C                   Eval      PMMsgID = 'FTS0017'                                       CSW207A
     C                   Exsr      SetError                                                  CSW207A
     C                   Eval      PMErrType = 'E'                                          BUG15045
      *                                                                                       CSW209
     C                   ELSE                                                                 CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVE      PMYYYYMMDD    PDateIn                                      CSW209
     C                   EXSR      SRZDate10                                                  CSW209
     C                   Z-ADD     PMDNO         BDDayNo                                      CSW209
      *                                                                                       CSW209
      ** The date in line starting by number 4 cannot be later than the Midas Rundate         CSW209
     C                   IF        BDDayNo > BJRDNB                                           CSW209
     C                   EVAL      PMMsgID = 'FTS0066'                                        CSW209
     C                   EXSR      SetError                                                   CSW209
     C                   EVAL      PMErrType = 'E'                                            CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
     C                   Else                                                                CSW207A
     C                   Eval      PMMsgID = 'FTS0017'                                       CSW207A
     C                   Exsr      SetError                                                  CSW207A
     C                   Eval      PMErrType = 'E'                                          BUG15045
                                                                                             CSW207A
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
     C                   EndIf                                                               CSW207A
                                                                                             CSW207A
     C                   EndSl                                                               CSW207A
                                                                                             CSW207A
     C                   Else
     C                   Select
     C                   When      %Subst(WInpParm:1:1) = '1'
     C**********         Eval      PMMsgID = 'FTS0036'                                       CSW207A
     C                   Eval      PMMsgID = 'FTS0020'                                       CSW207A
     C                   When      %Subst(WInpParm:1:1) = '2'
     C                   Eval      PMMsgID = 'FTS0021'
     C                   When      %Subst(WInpParm:1:1) = '3'
     C                   IF        CSW215 = 'Y' AND WNCode = '3'                              CSW215
     C                   EVAL      PMMsgID = 'FTS0084'                                        CSW215
     C                   ELSE                                                                 CSW215
     C                   Eval      PMMsgID = 'FTS0036'
     C                   ENDIF                                                                CSW215
     C                   When      %Subst(WInpParm:1:1) = '4'
     C                   Eval      PMMsgID = 'FTS0018'
     C                   When      %Subst(WInpParm:1:1) = '5'
     C                   Eval      PMMsgID = 'FTS0036'
     C                   When      %Subst(WInpParm:1:1) = '6'
     C                   Eval      PMMsgID = 'FTS0036'
     C                   When      %Subst(WInpParm:1:1) = '7'
     C                   Eval      PMMsgID = 'FTS0036'
     C                   When      %Subst(WInpParm:1:1) = '8'
     C                   Eval      PMMsgID = 'FTS0024'
     C                   EndSl
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndIf

     C**********         When      PMValType = 'FRMT'                                       BUG15090
      **********                                                                            BUG15090
     C**********         If        %Subst(WInpParm:WPtr1+1:1) <> *Blanks                    BUG15090
     C**********         Select                                                             BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '1'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0036'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '2'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0021'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '3'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0030'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '4'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0018'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '5'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0031'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '6'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0002'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '7'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0013'                                      BUG15090
     C**********         When      %Subst(WInpParm:1:1) = '8'                               BUG15090
     C**********         Eval      PMMsgID = 'FTS0024'                                      BUG15090
     C**********         EndSl                                                              BUG15090
     C**********         Exsr      SetError                                                 BUG15090
     C**********         EndIf                                                              BUG15090

     C                   EndSL

     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValColAsc - validate column in ascending                      *
      *****************************************************************
     C     ValColAsc     BegSR

     C                   If        WFirst = 'Y'
     C                   Eval      WPrevNCode = WNCode
     C                   Eval      WFirst = 'N'
     C                   Else
     C                   If        WNCode < WPrevNCode
     C                   Eval      PMMsgID = 'FTS0025'
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   Else
     C                   If        WPrevNCode = '2'
     C                             And (WNCode <> '2'
     C                             AND WNCode <> '3')                                       BUG24490
     C**********                   And WNCode <> '3'                                        BUG24490
     C**********                   And WNCode <> '8')                                       BUG24490
     C                   Eval      PMMsgID = 'FTS0026'
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   Else
      *                                                                                       CSW209
      ** If code 8/ is used, previous line must start with either 6/ or 7/                    CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   IF        WNCode = '8'                                               CSW209
     C                   EVAL      WSWCD = %SUBST(PMInpParm1:1:4)                           BUG24617
     C     WSWCD         LOOKUP    IdCode                                 94                BUG24617
     C                   IF        WPrevNCode <> '6' AND                                      CSW209
     C                             WPrevNCode <> '7' AND                                      CSW209
     C                             WPrevNCode <> '8' AND                                    BUG24643
     C                             PMValType = 'TRAN' AND                                     CSW209
     C**********                   WSwiftFlag <> 'Y'                                 CSW209 BUG24617
     C                              *IN94 = *OFF                                            BUG24617
     C                   EVAL      PMMsgID = 'FTS0068'                                        CSW209
     C                   EXSR      SetError                                                   CSW209
     C                   EVAL      PMErrType = 'E'                                            CSW209
     C                   LEAVESR                                                              CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Only Lines starting with numbers 1 and 2 may be repeated.                            CSW209
      ** Lines starting with 3,4,5,6,7 and 8 must not be repeated.                            CSW209
     C                   Move      WNCode        WNCodeN                                      CSW209
     C**********         IF        WNCodeN > 2 AND                                   CSW209 BUG25323
     C**********         IF        WNCodeN > 2                                       BUG25323 CSW215
     C**********                   WNCode = WPrevNCode                               CSW209 BUG25323
     C                   IF        (WNCodeN > 2 AND CSW215 = 'N') OR                          CSW215
     C                             (WNCodeN > 3 AND CSW215 = 'Y')                             CSW215
     C                   IF        WNCode = WPrevNCode Or                                   BUG25323
     C                             WNCode = WNextNCode                                      BUG25323
     C                   EVAL      PMMsgID = 'FTS0067'                                        CSW209
     C                   EXSR      SetError                                                   CSW209
     C                   EVAL      PMErrType = 'E'                                            CSW209
     C                   LEAVESR                                                              CSW209
     C                   ENDIF                                                              BUG25323
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   If        WPrevNCode = '4'
     C                             And (WNCode <> '4'
     C                             And WNCode <> '5'
     C                             And WNCode <> '8')
     C                   Eval      PMMsgID = 'FTS0027'
     C                   Exsr      SetError
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   Else
     C                   If        WNCode <> '8'
     C                   Eval      WPrevNCode = WNCode
     C                   ELSE                                                               BUG24352
     C                   IF        CSW209 = 'Y'                                             BUG24352
     C                   EVAL      WPrevNCode = WNCode                                      BUG24352
     C                   ENDIF                                                              BUG24352
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValBlankCol - Validate blank in-between columns               *
      *****************************************************************
     C     ValBlankCol   BegSR

     C                   Select
     C                   When      PMValType = 'TRAN'
     C                             And WOrgValType = 'TRAN'
     C                   When      PMValType = 'TRAN'                                        250804A
     C                             And WOrgValType = 'FRMT'                                  250804A

     C                   Eval      WParm1 = PMInpParm1
     C                   Eval      WParm2 = PMInpParm2
     C                   Eval      WParm3 = PMInpParm3
     C                   Eval      WParm4 = PMInpParm4
     C                   Eval      WParm5 = PMInpParm5

     C                   When      PMValType = 'FRMT'
     C                             And WOrgValType = 'FRMT'
     C                             Or PMValType = 'FRMT'
     C                             And WOrgValType = 'TRAN'

     C                   Eval      WParm1 = WFC1
     C                   Eval      WParm2 = WFC2
     C                   Eval      WParm3 = WFC3
     C                   Eval      WParm4 = WFC4
     C                   Eval      WParm5 = WFC5

     C                   EndSL

     C                   Eval      WBlankCol = 'N'
     C                   Select

     C                   When      WParm5 <> *Blanks
     C                   If        WParm4 = *Blanks
     C                             Or WParm3 = *Blanks
     C                             Or WParm2 = *Blanks
     C                   Eval      WBlankCol = 'Y'
     C                   EndIf

     C                   When      WParm4 <> *Blanks
     C                   If        WParm3 = *Blanks
     C                             Or WParm2 = *Blanks
     C                   Eval      WBlankCol = 'Y'
     C                   EndIf

     C                   When      WParm3 <> *Blanks
     C                   If        WParm2 = *Blanks
     C                   Eval      WBlankCol = 'Y'
     C                   EndIf

     C                   When      WParm2 <> *Blanks
     C                   If        WParm1 = *Blanks
     C                   Eval      WBlankCol = 'Y'
     C                   EndIf

     C                   EndSL

     C                   If        WBlankCol = 'Y'
     C                   Eval      PMMsgID = 'FTS0016'
     C                   Exsr      SetError
     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValACOUNTIBAN - Validate Account IBAN                         *
      *****************************************************************
     C     ValACOUNTIBAN BegSR

     C                   Eval      WIBAN = *Blanks
     C                   Eval      WRetailFlag = *Blanks
      * Check for valid Retail, to determine later the way to output the                      250600
      * Account                                                                               250600
     C                   If        PMAccount <> *Blanks                                       250600
     C                   Exsr      ValRetail                                                  250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   If        IBAN = *Blanks and P@IBAN <> *Blanks                       250600
     C                   Eval      IBAN = P@IBAN                                              250600
     C                   EndIf                                                                250600
      *                                                                                       250600
     C                   If        PMAccount = *Blanks
     C                             and IBAN = *Blanks                                         250600
     C                             and @@Slash <> '/'                                         250600
     C                   Eval      PMMsgID = 'FTS0034'
     C                   Exsr      SetError
     C                   Else
     C                   Eval      WISOCode = %Subst(WInpParm:2:2)
     C                   If        CFT004 = 'Y'
     C                             And WOMFLAGA <> 'P'
     C                             And IBAN <> *Blanks                                        250600
      *                                                                                       250600
     C                   If        %Subst(IBAN:1:2) = WISOCode
     C                             Or WISOCode = *Blanks                                      250600
     C                   Eval      WIBAN = IBAN
     C                   Else                                                                 250600
     C                   Eval      PMMsgID = 'FTS0032'                                        250600
     C                   Exsr      SetError                                                   250600
     C                   EndIf
      *                                                                                       250600
     C                   Else
     C                   If        CFT004 = 'N'
     C**********                   And WOMFLAGA = 'P'                                         250600
     C                             Or WOMFLAGA = 'P'                                          250600
     C                             Or @@Slash = '/'                                           250600
     C**********         Exsr      ValRetail                                                  250600

     C                   Else
     C                   If        WOMFLAGA = 'M' or                                          250600
     C                             %Subst(IBAN:1:2) <> WISOCode                               250600
     C                             and WISOCode <> *Blanks                                    250600
     C                             Or IBAN = *Blanks                                          250600
     C                   Eval      PMMsgID = 'FTS0032'
     C                   Exsr      SetError
     C                   EndIf                                                                250600
     C                   EndIf

     C                   EndIf
     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValISOCode - Validate ISO Code                                *
      *****************************************************************
     C     ValISOCode    BegSR

     C**********         If        WISOCode <> WISOC                                         CSW207A
     C**********                   And WISOCode <> *Blanks                                   CSW207A
     C**********                   And PMValType = 'FRMT'                                    CSW207A
     C**********         Eval      PMMsgID = 'FTS0004'                                       CSW207A
     C**********         Exsr      SetError                                                  CSW207A
     C**********         EndIf                                                               CSW207A
      ** Check if ISO Country code is valid for TRAN type                                    CSW207A
     C                   If        PMValType = 'TRAN'                                        CSW207A
     C     WISOCode      CHAIN     MEISOCL0                                                  CSW207A
     C                   If        NOT %FOUND(MEISOCL0)                                      CSW207A
     C                   IF        CSW215 = 'Y' AND WNCode = '3'                              CSW215
     C                   EVAL      PMMsgID = 'FTS0082'                                        CSW215
     C                   ELSE                                                                 CSW215
     C                   Eval      PMMsgID = 'FTS0004'                                       CSW207A
     C                   ENDIF                                                                CSW215
     C                   Exsr      SetError                                                  CSW207A
     C                   Eval      PMErrType = 'E'                                          BUG15045
     C                   EndIf                                                               CSW207A
     C                   EndIf                                                               CSW207A
      *                                                                                    BUG19193A
      ** ISO country code should have 2 characters only for code 3, 5, 6 and 7             BUG19193A
      *                                                                                    BUG19193A
     C                   IF        WNCode = '3' OR                                         BUG19193A
     C                             WNCode = '5' OR                                         BUG19193A
     C                             WNCode = '6' OR                                         BUG19193A
     C                             WNCode = '7'                                            BUG19193A
     C                   IF        %SUBST(WInpParm:5:1) <> '/'                             BUG19193A
     C                   IF        CSW215 = 'Y' AND WNCode = '3'                              CSW215
     C                   EVAL      PMMsgID = 'FTS0082'                                        CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      PMMsgID = 'FTS0004'                                     BUG19193A
     C                   ENDIF                                                                CSW215
     C                   EXSR      SetError                                                BUG19193A
     C                   EVAL      PMErrType = 'E'                                         BUG19193A
     C                   ENDIF                                                             BUG19193A
     C                   ENDIF                                                             BUG19193A
      *                                                                                    BUG19193A
      ** If valid SWIFT Code, ISO code should be followed by '/'                            BUG24297
      *                                                                                     BUG24297
     C     WSwiftCode    LOOKUP    IdCode                                 94                BUG24297
     C                   IF        *IN94 = *ON AND                                          BUG24297
     C                             %SUBST(WInpParm:8:1) <> '/'                              BUG24297
     C                   EVAL      PMMsgID = 'FTS0004'                                      BUG24297
     C                   EXSR      SetError                                                 BUG24297
     C                   EVAL      PMErrType = 'E'                                          BUG24297
     C                   ENDIF                                                              BUG24297

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ValRetail - Validate Retail                                   *
      *****************************************************************
     C     ValRetail     BegSR

     C                   If        BMRANR = 'Y' And ACNO > 0
     C                   Eval      WRetailFlag = 'Y'
     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * FormatOutParm
      *****************************************************************
     C     FormatOutParm BegSR

     C                   EVAL      WExcsLine3 = 'N'                                           CSW215
      ** Message Line 1
     C                   If        WCtr01 = 1
      ** Initialise Output Parameters
     C                   Eval      PMOutParm1 = *Blanks
     C                   Eval      PMOutParm2 = *Blanks
     C                   Eval      PMOutParm3 = *Blanks
     C                   Eval      PMOutParm4 = *Blanks
     C                   Eval      PMOutParm5 = *Blanks

      ** Get ISO country code from Issuing country                                           255628A
     C                   If        PMNonAcctHldr <> *Blanks                                  255628A
     C                   Eval      PMISOC    = NHISCT                                        255628A
     C                   Else                                                                255628A
     C                   Eval      PMISOC    = W_E5ISCT                                      255628A
     C                   EndIf                                                               255628A
                                                                                             255628A
     C                   If        (NHISCT <> *Blanks) or                                    255628A
     C                             (W_E5ISCT <> *Blanks)                                     255628A
     C                   Exsr      GetISOCode                                                255628A
     C                   Else                                                                 257786
     C                   Eval      WISOC = *Blanks                                            257786
     C                   EndIf                                                               255628A
                                                                                             255628A
     C                   If        WSlashFlag = 'N'

     C                   If        PMNonAcctHldr <> *Blanks                                  CSW207A
     C                   Eval      W_E5TINO = NHTINO                                         CSW207A
     C                   Eval      W_E5ISCD = NHISAU                                         CSW207A
     C                   Endif                                                               CSW207A
                                                                                             CSW207A
     C                   Select

     C                   When      WSwiftCode = 'ARNU'
     C                   Eval      WLN1 = WSwiftCode + '/'
     C                             + %Trim(WISOC) + '/'
     C                             + %Trim(W_E5TINO)

     C                   When      WSwiftCode = 'CCPT'
     C                   Eval      WLN1 = WSwiftCode + '/'
     C                             + %Trim(WISOC) + '/'
     C                             + %Trim(W_E5TINO)

     C                   When      WSwiftCode = 'CUST'
     C**********         If        FromOtherDtl = 'N'                                250600 BUG24666
     C**********                   And W_E5ISCD <> *Blanks                           252903 BUG24666
     C                   IF        W_E5ISCD <> *Blanks                                      BUG24666
     C                             AND W_E5TINO <> *Blanks                                    252903
     C                   Eval      WLN1 = WSwiftCode + '/'
     C                             + %Trim(WISOC) + '/'
     C                             + %Trim(W_E5ISCD) + '/'
     C                             + %Trim(W_E5TINO)
     C                   Else                                                                 250600
     C                   IF        FromOtherDtl = 'Y'                                       BUG24666
     C                   Eval      WLN1 = W_Cust                                              250600
     C                   ENDIF                                                              BUG24666
     C                   If        PMNonAcctHldr <> *Blanks                                   250600
     C                   Eval      WLN1 = W_NAHO                                              250600
     C                   Endif                                                                250600
     C                   Endif                                                                250600

     C                   When      WSwiftCode = 'DRLC'
     C                   Eval      WLN1 = WSwiftCode + '/'
     C                             + %Trim(WISOC) + '/'
     C                             + %Trim(W_E5ISCD) + '/'
     C                             + %Trim(W_E5TINO)

     C                   When      WSwiftCode = 'EMPL'
     C                   Eval      WLN1 = WSwiftCode + '/'
     C                             + %Trim(WISOC) + '/'
     C                             + %Trim(W_E5ISCD) + '/'
     C                             + %Trim(W_E5TINO)

      * Note: No specific field for non account holder                                        250600
     C                   When      WSwiftCode = 'IBEI'
     C**********         If        BBCBEI <> *Blanks                                        BUG14893
     C                   If        CSW209 <> 'Y'                                              CSW209
     C                   If        CSIBEI <> *Blanks                                        BUG14893
     C                   Eval      WLN1 = WSwiftCode + '/'
     C                             + %Trim(CSIBEI)
     C                   Else
     C**********         Eval      WLn1 = WSwiftCode + '/'                                  BUG14893
     C**********                   + %Trim(W_E5TINO)                                        BUG14893
      * IBEI can be set either in specific field CSIBEI or in Tax iD if required by           250600
      * tax authorities                                                                       250600
     C                   Eval      WLn1 = WSwiftCode + '/'                                    250600
     C                             + %Trim(W_E5TINO)                                          250600
     C**********         Eval      PMMsgID = 'FTS0052'                               BUG14893 250600
     C**********         Exsr      SetError                                          BUG14893 250600
     C                   EndIf
     C                   EndIf                                                                CSW209

      * NIDN can be set either in specific field xxIDNO or in Tax iD if required by           250600
      * tax authorities                                                                       250600
      * Note: No specific field for non account holder                                        250600
     C                   When      WSwiftCode = 'NIDN'
     C                   If        W_E5IDNO <> *Blanks                                        250600
     C                   Eval      WLN1 = WSwiftCode + '/'                                    250600
     C**********                   + W_CIsoCoLc + '/'                                250600 BUG15045
     C                             + W_CIsoCitz + '/'                                       BUG15045
     C                             + %Trim(W_E5IDNO)                                          250600
     C                   Else                                                                 250600
     C                   Eval      WLN1 = WSwiftCode + '/'
     C                             + %Trim(WISOC) + '/'
     C**********                   + %Trim(W_E5IDNO)                                         CSW207A
     C                             + %Trim(W_E5TINO)                                         CSW207A
     C                   Endif                                                                250600

     C                   When      WSwiftCode = 'SOSE'
     C                   Eval      WLN1 = WSwiftCode + '/'
     C                             + %Trim(WISOC) + '/'
     C                             + %Trim(W_E5TINO)

     C                   When      WSwiftCode = 'TXID'
     C                   Eval      WLN1 = WSwiftCode + '/'
     C                             + %Trim(WISOC) + '/'
     C                             + %Trim(W_E5TINO)

     C                   EndSL
     C                   Eval      PMOutParm1 = %Trim(WLN1)
      ** Set error if customer details is blanks                                            BUG14856
     C                   If        %Subst(WLN1:9) = *Blanks                                 BUG14856
     C                   Eval      PMMsgID = 'FTS0052'                                      BUG14856
     C                   Exsr      SetError                                                 BUG14856
     C                   EndIf                                                              BUG14856
                                                                                            BUG15045
      ** Check if line 1 exceeds 35 chars                                                   BUG15045
      ** If yes and 1 line is available, output the exceeding characters using 8/           BUG15045
     C                   Eval      WExcsLine1 = *Blanks                                     BUG15045
     C                   If        %Subst(WLN1:36) <> *Blanks                               BUG15045
     C                             And WExcsLine > 0                                        BUG15045
     C                   Eval      WExcsLine = WExcsLine - 1                                BUG15045
     C                   Eval      WExcsLine1 = '8/' + %Subst(WLN1:36:33)                   BUG15045
     C                   EndIf                                                              BUG15045
                                                                                            BUG15045
      ** For '/'
     C                   Else

     C**********         If        WIBAN <> *Blanks                                         BUG14755
     C**********         Eval      PMOutParm1 = '/' + %Trim(WIBAN)                          BUG14755
      **********                                                                            BUG14755
     C**********         Else                                                               BUG14755
     C**********         If        WRetailFlag = 'Y'                                        BUG14755
     C**********         Eval      PMOutParm1 = '/' + %Char(ACNO)                           BUG14755
      **********                                                                            BUG14755
     C**********         Else                                                               BUG14755
     C**********         Eval      PMOutParm1 = '/' + %Trim(PMAccount)                      BUG14755
     C**********         EndIf                                                              BUG14755
      **********                                                                            BUG14755
     C**********         EndIf                                                              BUG14755
     C**********         If        %Subst(PMInpParm1:1:1) <> '/'                     BUG14755 250600
     C**********         Eval      PMInpParm1 = '/' + %Trim(PMInpParm1)              BUG14755 250600
     C**********         Endif                                                       BUG14755 250600
     C**********         Eval      PMOutParm1 = PMInpParm1                           BUG14755 250600
      *                                                                                       250600
     C                   Select                                                               250600
     C                   When      WIBAN <> *Blanks                                           250600
     C                   Eval      PMOutParm1 = '/' + WIBAN                                   250600
      *                                                                                       250600
     C                   When      WRetailFlag = 'Y'                                          250600
     C                   Movel     ACNO          WACNO            10                          250600
     C                   Eval      PMOutParm1 = '/' + WACNO                                   250600
      *                                                                                       250600
     C                   When      PMAccount <> *Blanks                                       250600
     C                   Eval      PMOutParm1 = '/' + PMAccount                               250600
      *                                                                                       250600
     C                   When      @@Slash = '/'                                              250600
     C                   Eval      PMOutParm1 = PMInpParm1                                    250600
      *                                                                                       250600
     C                   When      PMCustNo  <> *Blanks                                       250600
     C                   Eval      PMOutParm1 = '/' + PMCustNo                                250600
      *                                                                                       250600
     C                   Other                                                                250600
     C                   Eval      PMMsgID = 'FTS0016'                                        250600
     C                   Exsr      SetError                                                   250600
      *                                                                                       250600
     C                   Endsl                                                                250600

     C                   EndIF

     C                   Else
      ** Message Line 2 to 5

     C                   Eval      WLN2 = *Blanks
     C                   Select

     C                   When      WNCode = '1'

     C**********         If        PMCustNo <> *Blanks                                      BUG14755
     C**********                   And PMNonAcctHldr = *Blanks                      CSW207A BUG14755
     C                   If        PMNonAcctHldr = *Blanks                                  BUG14755

     C**********         If        W_E5IDNO <> *Blanks                             BUG21024 BUG24657
     C**********         If        W_E5CNA2 <> *Blanks                                      MD050730
                                                                                            MD050730
      ** If Fld50FDetails is set to "A", 1/ should contain                                  MD050730
      ** E5CNA1 only if not blanks.                                                         MD050730
      ** If Fld50F Details is set to "D", 1/ should contain the                             MD050730
      ** default address lines 1 and 2 (E5CNA1, E5CNA2) if not blanks                       MD050730
     C                   IF        W_E5CNA2 <> *BLANKS and Fld50F = 'D'                     MD050730
     C                   Eval      WLN2 = WNcode + '/' + %Trim(W_E5CNA1)
     C                             + ' ' + %Trim(W_E5CNA2)
     C                   Eval      WCNA2Flag = 'Y'
     C                   Else
     C                   If        W_E5CNA1 <> *Blanks                                      BUG15045
     C                   Eval      WLN2 = WNCode + '/' + %Trim(W_E5CNA1)
     C                   Else                                                               BUG15045
     C                   Eval      WLN2 = WNCode + '/' + %Trim(W_BBCNA1)                    BUG15045
     C                   Endif                                                              BUG15045
     C                   EndIf
     C**********         Else                                                      BUG21024 BUG24657
     C**********         Eval      WLN2 = WNCode + '/' + %Trim(W_BBCNA1)           BUG21024 BUG24657
     C**********         Endif                                                     BUG21024 BUG24657

     C                   Else
     C                   If        PMNonAcctHldr <> *Blanks
     C**********         If        NHIDE1 <> *Blanks                                         CSW207A
     C**********                   Or NHIDE2 <> *Blanks                                      CSW207A
     C                   Eval      WLN2 = WNCode + '/' + %Trim(NHIDE1)
     C                                    + ' ' + %Trim(NHIDE2)
     C**********         EndIf                                                               CSW207A
     C                   EndIf
     C                   EndIf
      ** Set error if customer details is blanks                                            BUG14856
     C                   If        %Subst(WLN2:3) = *Blanks                                 BUG14856
     C                   Eval      PMMsgID = 'FTS0052'                                      BUG14856
     C                   Exsr      SetError                                                 BUG14856
     C                   EndIf                                                              BUG14856

     C                   When      WNCode = '2'

     C**********         If        PMCustNo <> *Blanks                                      BUG14755
     C**********                   And PMNonAcctHldr = *Blanks                      CSW207A BUG14755
     C                   If        PMNonAcctHldr = *Blanks                                  BUG14755

     C**********         If        WCNA2Flag = 'Y'                                          BUG15045

     C**********         If        W_E5IDNO <> *Blanks                             BUG21024 BUG24657
      *                                                                                     MD050730
      ** If Fld50FDetails is set to "A", 2/ should contain                                  MD050730
      ** lines 2 to 4 (E5CNA2-E5CNA4) of Additional Customer                                MD050730
      ** details if not blanks                                                              MD050730
     C                   IF        Fld50F = 'A' AND W_E5CNA2 <> *BLANKS                     MD050730
     C                   EVAL      WLN2 = WNCode + '/' + %TRIM(W_E5CNA2)                    MD050730
     C                             + ' ' +   %Trim(W_E5CNA3)                                MD050730
     C                             + ' ' +   %Trim(W_E5CNA4)                                MD050730
                                                                                            MD050730
     C                   ELSE                                                               MD050730
      ** else Fld50FDetails = "D", use the default address                                  MD050730
      ** lines E5CNA3 and E5CNA4, if not blanks                                             MD050730
     C                   If        W_E5CNA3 = *Blanks
     C                   Eval      WLN2 = WNCode + '/'
     C**********                   + ' ' + %Trim(W_BBCNA2)                                  BUG15045
     C                             + %Trim(W_BBCNA2)                                        BUG15045
     C                             + ' ' +   %Trim(W_BBCNA3)                                MD036262
     C                             + ' ' +   %Trim(W_BBCNA4)                                MD036262
     C                   Else
     C                   Eval      WLN2 = WNcode + '/'
     C**********                   + ' ' + %Trim(W_E5CNA3)                                  BUG15045
     C                             + %Trim(W_E5CNA3)                                        BUG15045
     C                             + ' ' + %Trim(W_E5CNA4)                                  BUG15045
     C                   EndIf
     C                   ENDIF                                                              MD050730
     C**********         Else                                                      BUG21024 BUG24657
     C**********         Eval      WLN2 = WNCode + '/'                             BUG21024 BUG24657
     C**********                   + %Trim(W_BBCNA2)                               BUG21024 BUG24657
     C**********         EndIf                                                     BUG21024 BUG24657

     C**********         Else                                                               BUG15045
     C**********         If        W_E5CNA3 = *Blanks                                       BUG15045
     C**********         Eval      WLN2 = WNCode + '/' + %Trim(W_E5CNA2)                    BUG15045
     C**********                   + ' ' + %Trim(W_BBCNA2)                                  BUG15045
     C**********         Else                                                               BUG15045
     C**********         Eval      WLN2 = WNCode + '/' + %Trim(W_E5CNA2)                    BUG15045
     C**********                   + ' ' + %Trim(W_E5CNA3)                                  BUG15045
     C**********         EndIf                                                              BUG15045
      **********                                                                            BUG15045
     C**********         EndIf                                                              BUG15045

     C                   Else
     C                   If        PMNonAcctHldr <> *Blanks
     C**********         If        NHIDE3 <> *Blanks                                         CSW207A
     C**********                   Or NHIDE4 <> *Blanks                                      CSW207A
     C                   Eval      WLN2 = WNCode + '/' + %Trim(NHIDE3)
     C                                    + ' ' + %Trim(NHIDE4)
     C**********         EndIf                                                               CSW207A
     C                   EndIf
     C                   EndIf
      ** Set error if customer details (Address) is blanks                                  BUG14856
     C                   If        %Subst(WLN2:3) = *Blanks                                 BUG14856
     C                   Eval      PMMsgID = 'FTS0052'                                      BUG14856
     C                   Exsr      SetError                                                 BUG14856
     C                   EndIf                                                              BUG14856

     C                   When      WNCode = '3'

     C**********         If        PMCustno <> *Blanks                                      BUG14755
     C**********                   And PMNonAcctHldr = *Blanks                      CSW207A BUG14755
     C                   If        PMNonAcctHldr = *Blanks                                  BUG14755

     C                   If        W_E5CITY <> *Blanks
     C**********         Eval      WLN2 = WNCode + '/' + %Trim(W_BBCOLC)                    MD037941
     C                   EVAL      WLN2 = WNCode + '/' + %Trim(W_CIsoCoLc)                  MD037941
     C                             + '/' + %Trim(W_E5CITY)
     C**********                   + '/' + %Trim(W_E5ZIPC)                                  BUG14755
     C                             + ' ' + %Trim(W_E5ZIPC)                                  BUG14755
     C                   Else
     C**********         Eval      WLN2 = WNCode + '/' + %Trim(W_BBCOLC)                    MD037941
     C                   EVAL      WLN2 = WNCode + '/' + %Trim(W_CIsoCoLc)                  MD037941
     C**********                   + '/' + %Trim(W_BBCNA3)                                  BUG15045
     C                             + '/' + %Trim(W_BBCRTN)                                  BUG15045
     C                   EndIf

     C                   Else
     C                   If        PMNonAcctHldr <> *Blanks

     C**********         If        NHCITY <> *Blanks                                         CSW207A
     C**********                   And NHCOLC <> *Blanks                                     CSW207A
     C                   Eval      WLN2 = WNCode + '/' + %Trim(WISOC)
     C**********                   + %Trim(NHCITY) + ' ' + %Trim(NHZIPC)                     CSW207A
     C                             + '/' + %Trim(NHCITY) + ' ' + %Trim(NHZIPC)               CSW207A
     C**********         EndIf                                                               CSW207A

     C                   EndIf

     C                   EndIf
      ** Set error if customer details (CITY) is blanks                                     BUG14856
     C                   If        %Subst(WLN2:6) = *Blanks                                 BUG14856
     C                   Eval      PMMsgID = 'FTS0052'                                      BUG14856
     C                   Exsr      SetError                                                 BUG14856
     C                   EndIf                                                              BUG14856
      *                                                                                       CSW215
      ** Check if line 3 exceeds 35 chars                                                     CSW215
      ** If yes and a line is available, output the exceeding characters using 3/             CSW215
      *                                                                                       CSW215
     C                   IF        CSW215 = 'Y'                                               CSW215
     C                   IF        %SUBST(WLN2:36) <> *BLANKS                                 CSW215
     C                             AND WExcsLine > 0                                          CSW215
     C                   EVAL      WExcsLine3 = 'Y'                                           CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215

     C                   When      WNCode = '4'
     C**********         If        WNAHOFlag = 'N'                                           CSW207A
     C                   If        PMNonAcctHldr = *Blanks                                   CSW207A
     C**********         If        W_E5BRTH > 0                                              CSW207A
      *                                                                                     BUG21178
      ** Get Birth date                                                                     BUG21178
      *                                                                                     BUG21178
     C                   EVAL      W_E5DBTH = W_E5BRT2 +                                    BUG21178
     C                                        %SUBST(W_E5BRT1:5:2) +                        BUG21178
     C                                        %SUBST(W_E5BRT1:3:2) +                        BUG21178
     C                                        %SUBST(W_E5BRT1:1:2)                          BUG21178
      *                                                                                     BUG21178
     C                   If        W_E5DBTH <> *BLANKS                                       CSW207A

     C**********         CallB     'ZDATE9'                                                  CSW207A
     C**********         Parm      W_E5BRTH      PMMidasDate                                 CSW207A
     C**********         Parm      W_E5DBTH      PMMidasDate                                 CSW207A
     C**********         Parm                    PMYYYYMMDD                                  CSW207A
     C**********         Parm      *Blanks       PMYMDRetC                                   CSW207A

     C**********         Eval      WLN2 = WNCode + '/' + %Char(PMYYYYMMDD)                   CSW207A
     C                   Eval      WLN2 = WNCode + '/' + W_E5DBTH                            CSW207A

     C**********         Else                                                               BUG14856
     C**********         Eval      WLN2 = WNCode                                             CSW207A
     C**********         Eval      WLN2 = WNCode + '/'                              CSW207A BUG14856
     C                   EndIf

     C                   Else
     C                   Eval      WLN2 = WNCode + '/' + NHDBTH
     C                   EndIf
      ** Set error if Birth Date is blanks                                                  BUG14856
     C                   If        %Subst(WLN2:3) = *Blanks                                 BUG14856
     C                   Eval      PMMsgID = 'FTS0052'                                      BUG14856
     C                   Exsr      SetError                                                 BUG14856
     C                   EndIf                                                              BUG14856

     C                   When      WNCode = '5'

     C**********         If        PMCustNo <> *Blanks                                      BUG14755
     C**********                   And PMNonAcctHldr = *Blanks                      CSW207A BUG14755
     C                   If        PMNonAcctHldr = *Blanks                                  BUG14755

     C**********         Eval      WLN2 = WNCode + '/' + %Trim(WISOC)                       BUG15185
     C                   Eval      WLN2 = WNCode + '/' + %Trim(ACISOC)                      BUG15185
     C**********                   + '/' + %Trim(W_E5BTHC)                                  BUG14755
     C                             + '/' + %Trim(W_E5BTHT)


     C                   Else
     C**********         If        PMNonAcctHldr <> *Blanks                                  CSW207A
     C**********         If        NHBTHC <> *Blanks                                         CSW207A
     C**********         Eval      WLN2 = WNCode + '/' + %Trim(WISOC)                       BUG25689
     C                   Eval      WLN2 = WNCode + '/' + %Trim(NHISOC)                      BUG25689
     C**********                   + %Trim(NHBTHC)                                           CSW207A
     C                             + '/' + %Trim(NHBTHT)                                     CSW207A
     C**********         EndIf                                                               CSW207A
     C**********         EndIf                                                               CSW207A

     C                   EndIf
      ** Set error if Birth Place is blanks                                                 BUG14856
     C                   If        %Subst(WLN2:3) = *Blanks                                 BUG14856
     C                   Eval      PMMsgID = 'FTS0052'                                      BUG14856
     C                   Exsr      SetError                                                 BUG14856
     C                   EndIf                                                              BUG14856

     C                   When      WNCode = '6'

      * This code is the internal cutomer number of the customer or non account holder        250600
      * The country of location is the one of the customer                                    250600
      * The issuer is the branch in which  the customer is registered                         250600
     C**********         If        PMCustNo <> *Blanks                                      BUG14755
     C**********                   And PMNonAcctHldr = *Blanks                      CSW207A BUG14755
     C                   If        PMNonAcctHldr = *Blanks                                  BUG14755
     C                             And PMCustNo <> *Blanks                                    250600

     C**********         Eval      WLN2 = WNCode + '/' + %Trim(WISOC)                         250600
     C**********                   + '/' + %Trim(W_E5ISCD)                                    250600
     C**********                   + '/' + %Trim(W_E5IDNO)                                    250600
                                                                                            BUG24601
     C                   IF        W_E5ISCD = *BLANKS                                       BUG24601
     C                             OR W_E5TINO = *BLANKS                                    BUG24601
                                                                                            BUG24601
     C**********         MOVEL     *BLANKS       T_BBCRNM          8               BUG24601 BUG25028
     C**********         IF        B_BBCSID <> *BLANKS                             BUG24601 BUG25028
     C**********         MOVEL     B_BBCSID      T_BBCRNM                          BUG24601 BUG25028
     C**********         ELSE                                                      BUG24601 BUG25028
     C**********         IF        A8BTID <> *BLANKS                               BUG24601 BUG25028
     C**********         MOVEL     A8BTID        T_BBCRNM                          BUG24601 BUG25028
     C**********         ELSE                                                      BUG24601 BUG25028
     C**********         MOVEL     B_BBCRNM      T_BBCRNM                          BUG24601 BUG25028
     C**********         ENDIF                                                     BUG24601 BUG25028
     C**********         ENDIF                                                     BUG24601 BUG25028
                                                                                            BUG24601
     C**********         Eval      WLN2 = WNCode + '/' + %Trim(W_WIsoCoLc)           250600 BUG25028
     C**********                   + '/' + %TRIM(B_BBCRNM)                           250600 BUG24601
     C**********                   + '/' + %TRIM(T_BBCRNM)                         BUG24601 BUG25028
     C**********                   + '/' + %TRIM(W_BBCUST)                           250600 BUG25028
     C                   Eval      WLN2 = '6/' + C_CIsoCoLc + '/' +                         BUG25028
     C                             %Trim(CustIssuer) + '/' + W_BBCUST                       BUG25028
     C                   ELSE                                                               BUG24601
     C                   EVAL      WLN2 = WNCode + '/' + %TRIM(WISOC)                       BUG24601
     C                             + '/' + %TRIM(W_E5ISCD)                                  BUG24601
     C                             + '/' + %TRIM(W_E5TINO)                                  BUG24601
     C                   ENDIF                                                              BUG24601
                                                                                            BUG24601
      ** Set error if Customer details is blanks                                            BUG14856
     C**********         If        W_E5ISCD = *Blanks                                BUG14856 250600
     C**********                   Or W_E5IDNO = *Blanks                             BUG14856 250600
     C**********         Eval      PMMsgID = 'FTS0052'                               BUG14856 250600
     C**********         Exsr      SetError                                          BUG14856 250600
     C**********         EndIf                                                       BUG14856 250600

     C                   Else
     C                   If        PMNonAcctHldr <> *Blanks
     C                   Eval      WLN2 = WNCode + '/' + %Trim(WISOC)
     C**********                   + '/' + %Trim(BBCRNM)                                     CSW207A
     C                             + '/' + %Trim(%Subst(BBCRNM:1:18))                        CSW207A
     C                             + '/' + %Trim(PMNonAcctHldr)
      ** Set error if Customer details is blanks                                            BUG14856
     C                   If        BBCRNM = *Blanks                                         BUG14856
     C                   Eval      PMMsgID = 'FTS0052'                                      BUG14856
     C                   Exsr      SetError                                                 BUG14856
     C                   EndIf                                                              BUG14856
     C                   EndIf

     C                   EndIf

      ** Check if line 6 exceeds 35 chars                                                     CSW209
      ** If yes and a line is available, output the exceeding characters using 8/             CSW209
     C                   If        CSW209 = 'Y'                                               CSW209
     C                   EVAL      WExcsLine6 = *BLANKS                                       CSW209
     C                   IF        %SUBST(WLN2:36) <> *BLANKS                                 CSW209
     C                             AND WExcsLine > 0                                          CSW209
     C                   EVAL      WExcsLine = WExcsLine - 1                                  CSW209
     C                   EVAL      WExcsLine6 = '8/' + %SUBST(WLN2:36:33)                     CSW209
     C                   ENDIF                                                                CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
     C                   When      WNCode = '7'

     C**********         If        PMCustNo <> *Blanks                                      BUG14755
     C**********                   And PMNonAcctHldr = *Blanks                      CSW207A BUG14755
     C                   If        PMNonAcctHldr = *Blanks                                  BUG14755

     C**********         Eval      WLN2 = WNCode + '/' + %Trim(WISOC)                       BUG15045
     C                   Eval      WLN2 = WNCode + '/' + %Trim(W_CIsoCitz)                  BUG15045
     C                             +'/' + %Trim(W_E5IDNO)

     C                   Else
     C                   If        PMNonAcctHldr <> *Blanks
     C**********         If        WISOC <> *Blanks                                          CSW207A
     C**********                   And NHTINO <> *Blanks                                     CSW207A
     C**********                   And WSwiftCode = 'NIDN'                                   CSW207A
     C                   Eval      WLN2 = WNCode + '/' + %Trim(WISOC)
     C                             +'/' + %Trim(NHTINO)
     C**********         EndIf                                                               CSW207A
     C                   EndIf

     C                   EndIf
      ** Set error if Customer details is blanks                                            BUG14856
     C                   If        %Subst(WLN2:3) = *Blanks                                 BUG14856
     C                             Or  %Subst(WLN2:6) = *Blanks                             BUG15010
     C                   Eval      PMMsgID = 'FTS0052'                                      BUG14856
     C                   Exsr      SetError                                                 BUG14856
     C                   EndIf                                                              BUG14856
                                                                                              CSW209
      ** Check if line 7 exceeds 35 chars                                                     CSW209
      ** If yes and a line is available, output the exceeding characters using 8/             CSW209
     C                   If        CSW209 = 'Y'                                               CSW209
     C                   EVAL      WExcsLine7 = *BLANKS                                       CSW209
     C                   IF        %SUBST(WLN2:36) <> *BLANKS                                 CSW209
     C                             AND WExcsLine > 0                                          CSW209
     C                   EVAL      WExcsLine = WExcsLine - 1                                  CSW209
     C                   EVAL      WExcsLine7 = '8/' + %SUBST(WLN2:36:33)                     CSW209
     C                   ENDIF                                                                CSW209
     C                   EndIf                                                                CSW209

     C                   EndSL

     C                   If        PMMsgID <> *Blanks                                       BUG14856
     C                   Movel     PMMsgID       WMsgID                                     BUG14856
     C                   LeaveSR                                                            BUG14856
     C                   EndIf                                                              BUG14856
     C                   Eval      WLN = WLN2
     C                   Exsr      MovePMMsg2to5

     C                   If        CSW209 = 'Y'                                               CSW209
     C                   IF        WnCode = '1'  or                                           CSW209
     C                             WExcsLine3 = 'Y' OR                                        CSW215
     C                             WnCode = '2'                                               CSW209
     C                   EXSR      ChkExcsChar                                                CSW209
     C                   ENDIF                                                                CSW209
     C                   Else                                                                 CSW209
     C                   Exsr      ChkExcsChar
     C                   EndIf                                                                CSW209

     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * ChkExcsChar - Check excess character                          *
      *****************************************************************
     C     ChkExcsChar   BegSR

     C                   Eval      WPtr1 = 0
     C                   Eval      WStr01 = 35

     C     ' '           CheckR    WLN2          WPtr1

     C                   If        WPtr1 > 35

     C                   Eval      WCtr03 = 0
     C                   DoW       WCtr03 < 3
     C**********         Eval      WCtr03 += 1                                              BUG15045
     C                   Eval      WCtr03 = WCtr03 + 1                                      BUG15045

     C                   Eval      WDummy = *Blanks
      *                                                                                     BUG15045
     C                   If        WnCode <> '3' And                                        BUG15045
     C                             WnCode <> '5'                                            BUG15045

     C                   Eval      WDummy = %SubSt(WLN2:WStr01+1:33)

     C                   If        WDummy <> *Blanks

     C                   Eval      WLN = WNCode + '/' + %Trim(WDummy)
     C                   If        WExcsLine > 0                                            BUG15045
     C                   Exsr      MovePMMsg2to5
     C                   Eval      WExcsLine = WExcsLine - 1                                BUG15045
     C                   EndIf                                                              BUG15045

     C                   EndIf

     C                   Eval      WStr01 = WStr01 + 33
      *                                                                                     BUG15045
     C                   Else                                                               BUG15045
      *                                                                                     BUG15045
     C                   Eval      WDummy = %SubSt(WLN2:WStr01+1:30)                        BUG15045
      *                                                                                     BUG15045
     C                   If        WDummy <> *Blanks                                        BUG15045
      *                                                                                     BUG15045
     C                   Eval      WLN = WNCode + '/' + %Trim(W_BBCOLC)                     BUG15045
     C                             + '/' + %Trim(WDummy)                                    BUG15045
     C                   IF        CSW215 = 'Y' AND                                           CSW215
     C                             WnCOde = '3'                                               CSW215
     C                   EVAL      WLN = *BLANKS                                              CSW215
     C                   EVAL      WLN = WNCode + '/' + %TRIM(WDummy)                         CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                     BUG15045
     C                   Eval      WStr01 = WStr01 + 30                                     BUG15045
      *                                                                                     BUG15045
     C                   If        WExcsLine > 0                                            BUG15045
     C                   Exsr      MovePMMsg2to5                                            BUG15045
     C                   Eval      WExcsLine = WExcsLine - 1                                BUG15045
     C                   EndIf                                                              BUG15045
      *                                                                                     BUG15045
     C                   EndIf                                                              BUG15045
      *                                                                                     BUG15045
     C                   Endif                                                              BUG15045

     C                   EndDo

     C                   EndIf

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * MovePMMsg2to5 - Move parameter message 2 to 5                 *
      *****************************************************************
     C     MovePMMsg2to5 BegSR

     C                   Select
     C                   When      PMOutParm2 = *Blanks
     C                   Eval      PMOutParm2 = WLN

     C                   When      PMOutParm3 = *Blanks
     C                   Eval      PMOutParm3 = WLN

     C                   When      PMOutParm4 = *Blanks
     C                   Eval      PMOutParm4 = WLN

     C                   When      PMOutParm5 = *Blanks
     C                   Eval      PMOutParm5 = WLN

     C                   EndSL

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * SetError - Set error message                                  *
      *****************************************************************
     C     SetError      BegSR

     C                   Eval      WContinue = 'N'
     C                   Eval      WCtr01 = 5                                               BUG14856
     C                   Eval      PMOutParm1 = *Blanks                                     BUG14856
     C                   Eval      PMOutParm2 = *Blanks                                     BUG14856
     C                   Eval      PMOutParm3 = *Blanks                                     BUG14856
     C                   Eval      PMOutParm4 = *Blanks                                     BUG14856
     C                   Eval      PMOutParm5 = *Blanks                                     BUG14856

     C                   Select
     C                   When      WOMFLAGF = 'P'
     C                             or WOMFLAGF = 'M'
     C                   Eval      PMErrType = 'E'

     C                   When      WOMFLAGF = 'W'
      ** If flag is otional, no special set-up is done, field 50K will be produced            250600
     C**********                   or WOMFLAGF = 'O'                                          250600
     C                   Eval      PMErrType = 'W'
      *                                                                                       250600
     C                   When      WOMFLAGF = 'O'                                             250600
     C                             or WOMFLAGF = 'O'                                         250804A
     C                   Eval      PMErrType = ' '                                            250600

     C                   EndSL

     C                   EndSR

      *****************************************************************
      /EJECT
      *****************************************************************                     BUG15045
      * Val50F - Check if OK to validate 50F                          *                     BUG15045
      *****************************************************************                     BUG15045
     C     Val50F        BegSR                                                              BUG15045
                                                                                            BUG15045
      ** check only if input type is Full Address                                           BUG15045
     C                   If        PMInpType = 'A' Or                                       BUG15045
     C                             PMInpType = ' '                                          BUG15045
                                                                                            BUG15045
     C                   Eval      WSwiftCode = %Subst(PMInpParm1:1:4)                      BUG15045
     C     WSwiftCode    LookUp    IdCode                                 94                BUG15045
     C                   If        *IN94 = *ON                                              BUG15045
     C                             And %Subst(PMInpParm1:5:1) = '/'                         BUG15045
     C                             And WOMFLAGF <> 'O'                                        252910
      *                                                                                     BUG15124
     C                   If        PMInpParm2 = *Blanks and                                 BUG15124
     C                             PMInpParm3 = *Blanks and                                 BUG15124
     C                             PMInpParm4 = *Blanks and                                 BUG15124
     C                             PMInpParm5 = *Blanks                                     BUG15124
     C                   Eval      PMReturnCode='*ERROR'                                    BUG15124
     C                   Eval      PMErrType ='E'                                           BUG15124
     C                   Eval      PMMsgID = 'FTS0016'                                      BUG15124
     C                   Eval      *INLR = *ON                                              BUG15124
     C                   Return                                                             BUG15124
     C                   Else                                                                 CSW209
      *                                                                                       CSW209
     C                   If        CSW209 = 'Y' And                                           CSW209
     C                             WSwiftCode = 'IBEI'                                        CSW209
     C                   EVAL      PMReturnCode='*ERROR'                                      CSW209
     C                   EVAL      PMErrType ='E'                                             CSW209
     C                   EVAL      PMMsgID = 'FTS0016'                                        CSW209
     C                   EVAL      *INLR = *ON                                                CSW209
     C                   RETURN                                                               CSW209
      *                                                                                       CSW209
     C                   Else                                                               BUG15124
     C                   LeaveSR                                                            BUG15045
     C                   EndIf                                                              BUG15124
      *                                                                                     BUG15124
     C                   EndIf                                                                CSW209
      *                                                                                       CSW209
     C                   Else                                                               BUG15045
                                                                                            BUG15045
     C                   If        %Subst(PMInpParm2:1:1) >= '1'                            BUG15045
     C                             And %Subst(PMInpParm2:1:1) <= '9'                        BUG15045
     C                             And %Subst(PMInpParm2:2:1) = '/'                         BUG15045
                                                                                            BUG15045
     C                             Or %Subst(PMInpParm3:1:1) >= '1'                         BUG15045
     C                             And %Subst(PMInpParm3:1:1) <= '9'                        BUG15045
     C                             And %Subst(PMInpParm3:2:1) = '/'                         BUG15045
                                                                                            BUG15045
     C                             Or %Subst(PMInpParm4:1:1) >= '1'                         BUG15045
     C                             And %Subst(PMInpParm4:1:1) <= '9'                        BUG15045
     C                             And %Subst(PMInpParm4:2:1) = '/'                         BUG15045
                                                                                            BUG15045
     C                             Or %Subst(PMInpParm5:1:1) >= '1'                         BUG15045
     C                             And %Subst(PMInpParm5:1:1) <= '9'                        BUG15045
     C                             And %Subst(PMInpParm5:2:1) = '/'                         BUG15045
                                                                                            BUG25000
     C                   IF        CSW209 = 'Y'  AND                                        BUG25000
     C                             (PMMsgType = '202' OR                                    BUG25000
     C                             PMMsgType = '205') AND                                   BUG25000
     C                             %SUBST(PMInpParm2:1:2) <> '1/'                           BUG25000
     C                   RETURN                                                             BUG25000
     C                   ELSE                                                               BUG25000
                                                                                            BUG25000
      ** continue validation                                                                BUG15045
     C                   LeaveSR                                                            BUG15045
                                                                                            BUG15045
     C                   ENDIF                                                              BUG25000
     C                   EndIf                                                              BUG15045
                                                                                            BUG15045
     C                   EndIf                                                              BUG15045
      ** end program                                                                        BUG15045
     C                   Return                                                             BUG15045
     C                   EndIf                                                              BUG15045
                                                                                            BUG15045
     C                   EndSR                                                              BUG15045
                                                                                            BUG15045
      *****************************************************************                     BUG15045
      /EJECT                                                                                BUG15045
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SRZDate10 - Convert YYYYMMDD Format Date to Midas Day No.     *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
      *                                                                                       CSW209
     C     SRZDate10     BEGSR                                                                CSW209
      *                                                                                       CSW209
     C                   CALLB     'ZDATE10'                                                  CSW209
     C                   PARM                    PDateIN                                      CSW209
     C                   PARM                    PMDNO                                        CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *                                                                                       CSW209
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      *****************************************************************                     BUG24614
      *                                                               *                     BUG24614
      * ValOMFMSeq - OMFM Sequence against Ordering Customer Codes    *                     BUG24614
      *              matching validation                              *                     BUG24614
      *                                                               *                     BUG24614
      *****************************************************************                     BUG24614
      *                                                                                     BUG24614
     C     ValOMFMSeq    BEGSR                                                              BUG24614
      *                                                                                     BUG24614
      ** reset varInputs fields                                                             BUG24614
      *                                                                                     BUG24614
     C                   eval      varInput1 = *blank                                       BUG24614
     C                   eval      varInput2 = *blank                                       BUG24614
     C                   eval      varInput3 = *blank                                       BUG24614
     C                   eval      varInput4 = *blank                                       BUG24614
     C                   eval      varInput5 = *blank                                       BUG24614
      *                                                                                     BUG24614
     C                   If        %SubSt(PMinpParm1:1:1) <> '/'                            BUG25101
     C                   eval      varInput1 = WSwiftCode                                   BUG24614
     C                   Else                                                               BUG25101
     C                   Eval      varInput1 = %SubSt(PMinpParm1:1:1)                       BUG25101
     C                   EndIf                                                              BUG25101
     C                   eval      varInput2 = %SubSt(PMinpParm2:1:2)                       BUG24614
      *                                                                                     BUG24614
     C                   Select                                                             BUG24614
     C                   When      %SubSt(PMinpParm5:1:2) = '1/'                            BUG24614
      *                  Nothing follows                                                    BUG24614
     C                   When      %SubSt(PMinpParm5:1:2) = '3/' AND                          CSW215
     C                             %SubSt(PMinpParm4:1:2) = '3/' AND                          CSW215
     C                             CSW215 = 'Y'                                               CSW215
      ** Fields 4&5 is '3/'                                                                   CSW215
     C                   IF        %SubSt(PMinpParm4:1:2) = '3/' AND                          CSW215
     C                             %SubSt(PMinpParm3:1:2) = '3/'                              CSW215
      ** Fields 3&4 is '3/'                                                                   CSW215
     C                   EVAL      varInput3 = %SubSt(PMinpParm3:1:2)                         CSW215
     C                   EVAL      varInput4 = *BLANKS                                        CSW215
     C                   EVAL      varInput5 = *BLANKS                                        CSW215
      ** Fields 3&4 not '3/'                                                                  CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      varInput4 = %SubSt(PMinpParm4:1:2)                         CSW215
     C                   ENDIF                                                                CSW215
     C                   EVAL      varInput5 = *BLANKS                                        CSW215
      ** Fields 1&3 is equal                                                                  CSW215
     C                   IF        %SubSt(PMinpParm2:1:2) =                                   CSW215
     C                             %SubSt(PMinpParm3:1:2)                                     CSW215
     C                   EVAL      varInput3  = varInput4                                     CSW215
     C                   EVAL      varInput4  = *BLANKS                                       CSW215
     C                   ELSE                                                                 CSW215
      ** Fields 1&3 not equal                                                                 CSW215
     C                   EVAL      varInput3 = %SubSt(PMinpParm3:1:2)                         CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   When      %SubSt(PMinpParm4:1:2) = '3/' AND                          CSW215
     C                             %SubSt(PMinpParm3:1:2) = '3/' AND                          CSW215
     C                             CSW215 = 'Y'                                               CSW215
      ** Fields 3&4 is '3/'                                                                   CSW215
     C                   EVAL      varInput3 = %SubSt(PMinpParm3:1:2)                         CSW215
      ** Field 5 not blanks                                                                   CSW215
     C                   IF        PMinpParm5 <> *BLANKS                                      CSW215
     C                   EVAL      varInput4 = %SubSt(PMinpParm5:1:2)                         CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      varInput4  = *BLANKS                                       CSW215
     C                   ENDIF                                                                CSW215
     C                   EVAL      varInput5  = *BLANKS                                       CSW215
      *                                                                                       CSW215
     C                   When      %SubSt(PMinpParm4:1:2) = '1/'                            BUG24614
     C                   If        %SubSt(PMinpParm5:1:2) <> '8/'                           BUG24614
     C                   Eval      varInput3 = %SubSt(PMinpParm5:1:2)                       BUG24614
     C                   EndIf                                                              BUG24614
     C                   When      %SubSt(PMinpParm3:1:2) = '1/'                            BUG24614
     C                   If        %SubSt(PMinpParm4:1:2) <> '8/'                           BUG24614
     C                   Eval      varInput3 = %SubSt(PMinpParm4:1:2)                       BUG24614
     C                   EndIf                                                              BUG24614
     C                   If        %SubSt(PMinpParm5:1:2) <> '8/'                           BUG24614
     C                   Eval      varInput4 = %SubSt(PMinpParm5:1:2)                       BUG24614
     C                   EndIf                                                              BUG24614
     C                   When      %SubSt(PMinpParm2:1:2) = '1/'                            BUG24614
     C                   If        %SubSt(PMinpParm3:1:2) <> '8/'                           BUG24614
     C                   Eval      varInput3 = %SubSt(PMinpParm3:1:2)                       BUG24614
     C                   EndIf                                                              BUG24614
     C                   If        %SubSt(PMinpParm4:1:2) <> '8/'                           BUG24614
     C                   If        %SubSt(PMinpParm4:1:2) <>                                BUG24614
     C                             %SubSt(PMinpParm3:1:2)                                   BUG24614
     C                   Eval      varInput4 = %SubSt(PMinpParm4:1:2)                       BUG24614
     C                   If        %SubSt(PMinpParm5:1:2) <> '8/' And                       BUG24614
     C                             %SubSt(PMinpParm5:1:2) <>                                BUG24614
     C                             %SubSt(PMinpParm4:1:2)                                   BUG24614
     C                   Eval      varInput5 = %SubSt(PMinpParm5:1:2)                       BUG24614
     C                   Endif                                                              BUG24614
     C                   Else                                                               BUG24614
     C                   Eval      varInput4 = %SubSt(PMinpParm5:1:2)                       BUG24614
     C                   EndIf                                                              BUG24614
     C                   EndIf                                                              BUG24614
     C                   End                                                                BUG24614
      *                                                                                     BUG24614
     C                   ENDSR                                                              BUG24614
      *                                                                                     BUG24614
      *****************************************************************                     BUG24614
      /EJECT                                                                                BUG24614
      *****************************************************************                     BUG25101
      *                                                               *                     BUG25101
      * SRLINE8 - Processing of line starting with 8/                 *                     BUG25101
      *           CSW209 FDS2.01 Changes                              *                     BUG25101
      *                                                               *                     BUG25101
      *****************************************************************                     BUG25101
      *                                                                                     BUG25101
     C     SRLINE8       BEGSR                                                              BUG25101
      *                                                                                     BUG25101
     C                   Eval      Line8 = *Blanks                                          BUG25101
      *                                                                                     BUG25101
     C                   Select                                                             BUG25101
      *                                                                                     BUG25101
     C                   When      %SUBST(PmInpParm3:1:2) = '8/'                            BUG25101
     C                   Eval      Line8 = %SUBST(PmInpParm3:3)                             BUG25101
      *                                                                                     BUG25101
     C                   When      %SUBST(PmInpParm4:1:2) = '8/'                            BUG25101
     C                   Eval      Line8 = %SUBST(PmInpParm4:3)                             BUG25101
      *                                                                                     BUG25101
     C                   When      %SUBST(PmInpParm5:1:2) = '8/'                            BUG25101
     C                   Eval      Line8 = %SUBST(PmInpParm5:3)                             BUG25101
      *                                                                                     BUG25101
     C                   End                                                                BUG25101
      *                                                                                     BUG25101
     C                   ENDSR                                                              BUG25101
      *                                                                                     BUG25101
      *****************************************************************                     BUG25101
      /EJECT                                                                                BUG25101
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *Inzsr        BegSR

     C     *ENTRY        PLIST
      *
      ** Return Code
      *
     C                   Parm                    PMReturnCode
      *
      ** Message ID
      *
     C                   Parm                    PMMsgID
      *
      ** Error Type
      *
     C                   Parm                    PMErrType
      *
      ** Validation Type
      *
     C                   Parm                    PMValType
      *
      ** Input Parameter 1
      *
     C                   Parm                    PMInpParm1
      *
      ** Input Parameter 2
      *
     C                   Parm                    PMInpParm2
      *
      ** Input Parameter 3
      *
     C                   Parm                    PMInpParm3
      *
      ** Input Parameter 4
      *
     C                   Parm                    PMInpParm4
      *
      ** Input Parameter 5
      *
     C                   Parm                    PMInpParm5
      *
      ** Input Type
      *
     C                   Parm                    PMInpType
      *
      ** Account
      *
     C                   Parm                    PMAccount
      *
      ** Customer Number
      *
     C                   Parm                    PMCustNo
      *
      ** Non Account Holder
      *
     C                   Parm                    PMNonAcctHldr
      *
      ** Network
      *
     C                   Parm                    PMNetwork
      *
      ** Message Type
      *
     C                   Parm                    PMMsgType
      *
      ** Message Tag
      *
     C                   Parm                    PMMsgTag
      *
      ** Country
      *
     C**********         Parm                    PMCountry                                    250600
     C     PMCountryP    Parm      PMCountryP    PMCountry                                    250600
      *
      ** Branch Code
      *
     C**********         Parm                    PMBranch                                     250600
     C     PMBranchP     Parm      PMBranchP     PMBranch                                     250600
      *
      ** Currency Code
      *
     C**********         Parm                    PMCurrCode                                   250600
     C     PMCcyCode     Parm      PMCcyCode     PMCurrCode                                   250600
      *
      ** Nostro Flag
      *
     C**********         Parm                    PMNostro                                     250600
     C     PMNostroP     Parm      PMNostroP     PMNostro                                     250600
      *
      ** Module Indicator
      *
     C                   Parm                    PMModInd
      *
      ** Message Line 1
      *
     C                   Parm                    PMOutParm1
      *
      ** Message Line 2
      *
     C                   Parm                    PMOutParm2
      *
      ** Message Line 3
      *
     C                   Parm                    PMOutParm3
      *
      ** Message Line 4
      *
     C                   Parm                    PMOutParm4
      *
      ** Message Line 5
      *
     C                   Parm                    PMOutParm5

      *
      ** Check if SWIFT2007 is installed
      *
     C                   Call      'SWIF2007'
     C                   Parm      *Blanks       PMReturnCode

     C                   If        PMReturnCode = 'CSW2007'
     C                   Eval      CSW207 = 'Y'
     C                   Else
     C                   Eval      CSW207 = 'N'
     C                   EndIf
      *                                                                                       CSW208
      ** Check if SWIFT2008 is installed                                                      CSW208
      *                                                                                       CSW208
     C                   EVAL      CSW208 = 'N'                                               CSW208
     C                   CALL      'SWIF2008'                                                 CSW208
     C                   PARM      *BLANKS       PRTCD                                        CSW208
                                                                                              CSW208
     C                   IF        PRTCD = 'CSW2008'                                          CSW208
     C                   EVAL      CSW208 = 'Y'                                               CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW209
      * Check if CSW209 is installed                                                          CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM      *BLANKS       PMReturnCode                                 CSW209
      *                                                                                       CSW209
     C                   IF        PMReturnCode = 'CSW2009'                                   CSW209
     C                   EVAL      CSW209 = 'Y'                                               CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
     C                   ENDIF                                                                CSW209
      *
      ** International Bank Account Number
      *
     C                   Eval      CFT004 = 'N'
     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*VERIFY'     PMOption
     C                   Parm      'CFT004'      PMSAR

     C                   If        PMReturnCode = *Blanks
     C                   Eval      CFT004 = 'Y'
     C                   EndIf
      *
      ** S.W.I.F.T. MT3xx Field 82/83/87
      *
     C                   Eval      CSW024 = 'N'
     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*VERIFY'     PMOption
     C                   Parm      'CSW024'      PMSAR

     C                   If        PMReturnCode = *Blanks
     C                   Eval      CSW024 = 'Y'
     C                   EndIf
      *                                                                                       CSW215
      ** Check if SWIFT2015 is enabled                                                        CSW215
      *                                                                                       CSW215
     C                   EVAL      CSW215 = 'N'                                               CSW215
     C                   CALL      'SWIF2015'                                                 CSW215
     C                   PARM      *BLANKS       PMReturnCode                                 CSW215
      *                                                                                       CSW215
     C                   IF        PMReturnCode = 'CSW2015'                                   CSW215
     C                   EVAL      CSW215 = 'Y'                                               CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      CSW215 = 'N'                                               CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                    BUG15149A
      ** Check if Private Banking is switched on:                                          BUG15149A
      *                                                                                    BUG15149A
     C                   CALL      'AOMMODR0'                                              BUG15149A
     C                   PARM      '*DBERR'      PMReturnCode                              BUG15149A
     C                   PARM      '*FIRST '     PMoption                                  BUG15149A
     C     SDMMOD        PARM      SDMMOD        DSFDY                                     BUG15149A
                                                                                           BUG15149A
     C                   IF        PMReturnCode <> *BLANKS                                 BUG15149A
     C                   Eval      DbFile = 'SDMMODPD'                                     BUG15149A
     C                   Eval      Dbase  = 11                                             BUG15149A
     C                   Exsr      *PSSR                                                   BUG15149A
     C                   ENDIF                                                             BUG15149A
      *
      ** Standing data of Retail
      *
     C     BGRTBN        IFEQ      'Y'                                                      BUG15149
     C                   Call      'AORETLR0'
     C                   Parm      *Blanks       PMReturnCode
     C                   Parm      '*FIRST'      PMOption
     C     SDRETL        Parm      SDRETL        DSSDY

     C                   If        PMReturnCode <> *Blanks
     C                   Eval      DbFile = 'SDRETLPD'
     C                   Eval      Dbase  = 01
     C                   Exsr      *PSSR
     C                   EndIf
     C                   ELSE                                                               BUG15149
     C                   MOVEL     'N'           BMRANR                                     BUG15149
     C                   ENDIF                                                              BUG15149
                                                                                             CSW207A
      ** Access Bank details.                                                                 CSW209
     C                   CALLB     'AOBANKR0'                                                 CSW209
     C                   PARM      *BLANKS       PRTCD             7                          CSW209
     C                   PARM      '*FIRST '     POPTN             7                          CSW209
     C     SDBANK        PARM      SDBANK        DSFDY                                        CSW209
      *                                                                                       CSW209
      ** Database error.                                                                      CSW209
      *                                                                                       CSW209
     C     PRTCD         IFNE      *BLANKS                                                    CSW209
     C                   MOVEL     POPTN         DBKEY                                        CSW209
     C                   MOVEL     'SDBANKPD'    DBFILE                                       CSW209
     C                   Z-ADD     001           DBASE                                        CSW209
     C                   EXSR      *PSSR                                                      CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Input parameter does only contain Customer number is 6 first position                250600
      ** for Customer number if no / in first position and Partial account if                 250600
      ** no / in first position, this test must be removed, if a customer number              250600
      ** is linked to the input, it MUST be passed by the Customer number field               250600
      ***Retrieve*Customer*details                                                    CSW207A 250600
     C**********         Movel     PMInpParm1    @KEY1                                CSW207A 250600
     C**********         CALL      'AOCUSTR1'                                         CSW207A 250600
     C**********         PARM      '*BLANKS'     @RTCD                                CSW207A 250600
     C**********         PARM      '*KEY   '     PMOption                             CSW207A 250600
     C**********         PARM                    @KEY1                                CSW207A 250600
     C**********         PARM      *BLANKS       @KYST                                CSW207A 250600
     C*****SDCUST        PARM      SDCUST        DSLDY                                CSW207A 250600
      **********                                                                      CSW207A 250600
     C**********         IF        PMCustNo <> *Blanks                                CSW207A 250600
     C**********         Movel     PMCustNo      @KEY1                                CSW207A 250600
     C**********         CALL      'AOCUSTR1'                                         CSW207A 250600
     C**********         PARM      '*BLANKS'     @RTCD             7                  CSW207A 250600
     C**********         PARM      '*KEY   '     PMOption                             CSW207A 250600
     C**********         PARM                    @KEY1            10                  CSW207A 250600
     C**********         PARM      *BLANKS       @KYST             7                  CSW207A 250600
     C*****SDCUST        PARM      SDCUST        DSLDY                                CSW207A 250600
     C**********         EndIf                                                        CSW207A 250600
      *                                                                                       250600
     C                   MOVEL     PMInpParm1    @@SLASH           1                          250600
     C                   Eval      IBAN = *Blanks                                             250600
      *                                                                                       250600
     C                   If        PMInpParm1 = 'MT202'                                       250600
     C                   Eval      PMReturnCode = '*ERROR'                                    250600
     C                   Eval      *INLR = *ON                                                250600
     C                   Return                                                               250600
     C                   EndIf                                                                250600
      **********                                                                  BUG15149 BUG15149A
      ***Check*if*Private*Banking*is*switched*on:*                                BUG15149 BUG15149A
      **********                                                                  BUG15149 BUG15149A
     C**********         CALL      'AOMMODR0'                                     BUG15149 BUG15149A
     C**********         PARM      '*DBERR'      PMReturnCode                     BUG15149 BUG15149A
     C**********         PARM      '*FIRST '     PMoption                         BUG15149 BUG15149A
     C*****SDMMOD*****   PARM      SDMMOD        DSFDY                            BUG15149 BUG15149A
     C**********                                                                  BUG15149 BUG15149A
     C**********         IF        PMReturnCode <> *BLANKS                        BUG15149 BUG15149A
     C**********         Eval      DbFile = 'SDMMODPD'                            BUG15149 BUG15149A
     C**********         Eval      Dbase  = 11                                    BUG15149 BUG15149A
     C**********         Exsr      *PSSR                                          BUG15149 BUG15149A
     C**********         ENDIF                                                    BUG15149 BUG15149A

     C                   EndSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2007
**  IdCode         - SWIFT Code                                                               250600
ARNUCCPTCUSTDRLCEMPLIBEINIDNSOSETXID                                                          250600
**  Alpha - Array of alphabetic characters                                                    250600
ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                    250600
**  Numeric - Array of numeric characters                                                     250600
0123456789                                                                                    250600
