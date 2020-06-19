000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2003')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas MM Loans/deposits validate and update')          *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Money Market Dealing Module                          *
000900200529      *                                                               *
001000200529      *  MMLDNIVU - Deal Loans and deposits validate and update       *
001100200529      *                                                               *
001200200529      *  Function: This Program Validates MM Loans and deposits for   *
001300200529      *            into the Midas database and updates if required    *
001400200529      *            Processes executed controlled by input Action Code *
001500200529      *            - For I (=Insert)                                  *
001600200529      *              - If ALL of the settlement fields are blank, set *
001700200529      *                them up from standard settlement instructions  *
001800200529      *            - For I (=Insert) or A (=Amend)                    *
001900200529      *              - Validate the deal fields                       *
002000200529      *              - Validate the settlement fields                 *
002100200529      *            - For A (=Amend) if it is valid, call a separate   *
002200200529      *              function to check whether it is a valid amendment*
002300200529      *            - For X (=Authorise) call a separate function to   *
002400200529      *              process this deal and bypass remaining validation*
002500200529      *              bypass the field validation                      *
002600200529      *            - For D (=Delete) call a separate function to      *
002700200529      *              process this deal and bypass the rest of the     *
002800200529      *              validation                                       *
002900200529      *            For all action codes, the decision to as to        *
003000200529      *            whether to write to the Valid or Invalid file and  *
003100200529      *            the call to the Message Handler will take place    *
003200200529      *            in this module                                     *
003300200529      *                                                               *
003400200529      *  (c) Finastra International Limited 2003                      *
003500200529      *                                                               *
003600200604      *  Last Amend No. 250161             Date 22May20               *
003700200529      *  Prev Amend No. MD054028           Date 05Sep19               *
003800200529      *                 CER050             Date 16Jun19               *
003900200529      *                 MD039547           Date 20Sep16               *
004000200529      *                 MD049048           Date 20Dec17               *
004100200529      *                 MD046248           Date 27Oct17               *
004200200529      *                 CDL099             Date 06Oct17               *
004300200529      *                 MD024884A          Date 04Jul17               *
004400200529      *                 MD044873           Date 23Mar17               *
004500200529      *                 MD042711           Date 22Nov16               *
004600200529      *                 MD033924           Date 27Mar15               *
004700200529      *                 AR701789           Date 26Sep16               *
004800200529      *                 MD037869A          Date 28Mar16               *
004900200529      *                 MD038485           Date 10Aug16               *
005000200529      *                 CGL165             Date 23Feb15               *
005100200529      *                 CDL096             Date 22Sep14               *
005200200529      *                 MD030436           Date 01Oct14               *
005300200529      *                 MD027337A          Date 01Oct14               *
005400200529      *                 CDL094             Date 01Sep14               *
005500200529      *                 MD027415           Date 19Aug14               *
005600200529      *                 MD027337           Date 05Jun14               *
005700200529      *                 MD024884           Date 07Feb14               *
005800200529      *                 CSD095             Date 08Apr14               *
005900200529      *                 MD022849           Date 13Oct13               *
006000200529      *                 MD022656           Date 01Oct13               *
006100200529      *                 AR751620           Date 12Jun13               *
006200200529      *                 MD000091           Date 14May13               *
006300200529      *                 AR1060863          Date 06Apr13               *
006400200529      *                 AR665113           Date 28Nov12               *
006500200529      *                 AR971184A          Date 22Jun12               *
006600200529      *                 CSF011A            Date 28Nov11               *
006700200529      *                 AR863263           Date 11Nov11               *
006800200529      *                 CSF011             Date 12Sep11               *
006900200529      *                 AR819540A          Date 30Aug11               *
007000200529      *                 CER049             Date 06Dec10               *
007100200529      *                 CRE073             Date 06Dec10               *
007200200529      *                 259924A            Date 28May09               *
007300200529      *                 CER059             Date 19Jul10               *
007400200529      *                 CER054             Date 07Apr09               *
007500200529      *                 BUG23519           Date 24Mar09               *
007600200529      *                 CER020             Date 19May08               *
007700200529      *                 CER043             Date 19May08               *
007800200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
007900200529      *                 260428A            Date 10Jun09               *
008000200529      *                 260428             Date 28May09               *
008100200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
008200200529      *                 256638             Date 21Oct08               *
008300200529      *                 256564             Date 17Sep08               *
008400200529      *                 248297             Date 05Jun07               *
008500200529      *                 244784             Date 11JAN07               *
008600200529      * Midas Plus 1.4 Base ------------------------------------------*
008700200529      *                 244537             Date 17Aug05               *
008800200529      *                 BUG5169            Date 04Oct06               *
008900200529      * Midas Plus 1.3 ----------- Base ------------------------------*
009000200529      *                 BUG12967           Date 21Dec06               *
009100200529      *                 241685             Date 18Sep06               *
009200200529      *                 BUG12589           Date 15Nov06               *
009300200529      *                 BUG12551           Date 09Nov06               *
009400200529      *                 CDL049             Date 11Jul06               *
009500200529      *                 239400             Date 26Jun06               *
009600200529      *                 CSD027A            Date 09May06               *
009700200529      *                 CSD027             Date 09Dec05               *
009800200529      *                 BUG10943           Date 27Mar06               *
009900200529      *                 BUG10718           Date 03Mar06               *
010000200529      *                 BUG10725           Date 02Mar06               *
010100200529      *                 BUG10695           Date 25Feb06               *
010200200529      *                 BUG10677           Date 23Feb06               *
010300200529      *                 BUG10341           Date 07Feb06               *
010400200529      *                 BUG10563           Date 14Feb06               *
010500200529      *                 BUG9827            Date 10Jan06               *
010600200529      *                 BUG10296           Date 07Feb06               *
010700200529      *                 CAP087             Date 02Sep05               *
010800200529      *                 CER001             Date 25Apr05               *
010900200529      *                 BUG8119            Date 20Oct05               *
011000200529      *                 CLE031             Date 26Apr05               *
011100200529      *                 CDL038             Date 10May05               *
011200200529      *                 CDL033             Date 10Feb05               *
011300200529      *                 BUG6512            Date 21Apr05               *
011400200529      *                 BUG6164            Date 01Apr05               *
011500200529      *                 BUG4808            Date 16Nov04               *
011600200529      *                 BUG4728            Date 05Nov04               *
011700200529      *                 BUG3992            Date 01Oct04               *
011800200529      *                 BUG4482            Date 29Sep04               *
011900200529      *                 BUG3792            Date 28Sep04               *
012000200529      *                 BUG4380            Date 29Sep04               *
012100200529      *                 BUG4068            Date 03Sep04               *
012200200529      *                 BUG4097            Date 01Sep04               *
012300200529      *                 BUG3684            Date 18Aug04               *
012400200529      *                 BUG3986            Date 13Aug04               *
012500200529      *                 CMM105             Date 22Jun04               *
012600200529      *                 BUG3869            Date 26Jul04               *
012700200529      *                 CLE025             Date 20Oct03               *
012800200529      *                 TCA002             Date 26Mar04               *
012900200529      *                 CSC022             Date 24Feb04               *
013000200529      *                 CGL029             Date 01Sep03               *
013100200529      *                 CDL020             Date 03Feb04               *
013200200529      *                 CDL019             Date 03Feb04               *
013300200529      *                 CDL018             Date 03Feb04               *
013400200529      *                 CDL017             Date 03Feb04               *
013500200529      *                 CDL016             Date 03Feb04               *
013600200529      *                 222727             Date 05Nov03               *
013700200529      *                 CAP084  *CREATE    Date 17Jun03               *
013800200529      *                                                               *
013900200529      *---------------------------------------------------------------*
014000200529      *                                                               *
014100200529      *  250161 - Ensure that maturity date and value date of deals   *
014200200529      *           is validated against DACO of ACCNTAB.               *
014300200529      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
014400200529      *             being updated                                     *
014500200529      *  CER050 - Annualised Percentage Rate                          *
014600200529      *  CSD102 - Password Length Extension (Recompile)               *
014700200529      *  MD039547 - Referred account is not properly validated.       *
014800200529      *  MD049048 - LDNI inserted through SOAP cannot be amended due  *
014900200529      *             to Front Office ID being blank.                   *
015000200529      *  MD046248 - Finastra Rebranding                               *
015100200529      *  CDL099 - Split Value Date (Recompile)                        *
015200200529      *  MD024884A - Incorrect Payment and Receipt accounts           *
015300200529      *  MD044873 - Serious Midas Error is encountered when completing*
015400200529      *             transaction in LDNI. Reverse MD042711.            *
015500200529      *  MD042711 - Database error and serious midas error encountered*
015600200529      *             during insert of Fiduciary Deals                  *
015700200529      *  MD033924 - Cannot Insert Fiduciary Fixed-Term Placing        *
015800200529      *             and Call Placing                                  *
015900200529      *  AR701789 - Unable to reject a deal amendment. Add a new      *
016000200529      *             parameter to indicate reject transaction.         *
016100200529      *             Applied for MD041482                              *
016200200529      *  MD037869A - Unable to authorise deal in LDNI after updating  *
016300200529      *              base rate.                                       *
016400200529      *  MD038485 - Correct mapping of Stamp Tax fields (CER049).     *
016500200529      *  CGL165 - Dual Withholding Tax                                *
016600200529      *  CDL096 - Business Day Conventions on MM Deals                *
016700200529      *  MD030436 - Enhance fix MD027337A to the cater defaulting of  *
016800200529      *             settlement from '00' to SSI details.              *
016900200529      *  MD027337A - Settlement details are not being re-defaulted    *
017000200529      *              during amend.                                    *
017100200529      *            - Applied for MD030436.                            *
017200200529      *  CDL094 - Enhance Receive Settlement Instructions             *
017300200529      *  MD027415 - Unexpected validation of settlement instruction   *
017400200529      *             during 'EDIT' of a deal after it's value date.    *
017500200529      *           - Correct the validation of the field. Check        *
017600200529      *             counterparty nostro as well.                      *
017700200529      *  MD027337 - Settlement details are not being defaulted during *
017800200529      *             amend.                                            *
017900200529      *  MD024884 - Incorrect Payment and Receipt accounts            *
018000200529      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
018100200529      *  MD022849 - Settlement Payment Fields cannot be amended error *
018200200529      *  MD022656 - Amendment is allowed for protected settlement     *
018300200529      *             fields                                            *
018400200529      *  AR751620 - Serious midas error encountered when processing   *
018500200529      *             a deal that has a different timestamp from file.  *
018600200529      *             Amend program to show an error message instead.   *
018700200529      *             (Child: AR751621)                                 *
018800200529      *  MD000091 - Event Codes Substitution                          *
018900200529      *  AR1060863 - Deal irregular interest schedules lost           *
019000200529      *            - Applied for AR1097090                            *
019100200529      *  AR665113 - Check deal number for the existing associated     *
019200200529      *             rollover deals.(Child: AR665114)                  *
019300200529      *  AR971184A- During Amend Front Ofc Id must be updated with the*
019400200529      *             new one                                           *
019500200529      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
019600200529      *          - Some codes of CSF011 will be physically deleted    *
019700200529      *  AR863263 - Further Pay/Receipt Settlement Accounts are       *
019800200529      *             reset to blanks                                   *
019900200529      *  CSF011 - Customer Name on Inputs                             *
020000200529      *  AR819540A - Mapping error encountered in LDNI                *
020100200529      *  CER049 - Stamp Tax                                           *
020200200529      *  CRE073 - Interest Rate Rounding                              *
020300200529      *  259924A- Amended so that system can get the front office ID  *
020400200529      *           from Java.                                          *
020500200529      *  CER059 - German Feature Upgrade to Delhi                     *
020600200529      *  CER054 - German Features - Church Tax (Recompile)            *
020700200529      *  BUG23519 - Warning messages with the same text are displayed *
020800200529      *             at the same time (Recompile)                      *
020900200529      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
021000200529      *           Midas Plus (Recompile)                              *
021100200529      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
021200200529      *  260428A - Always protect fields for validation if Authorise  *
021300200529      *  260428 - Skip validation on receipt side / pay side if       *
021400200529      *           accounting has taken place already in the past.     *
021500200529      *  256638 - Add the parameters needed to prevent Serious Midas  *
021600200529      *           Error message in Java screen.                       *
021700200529      *  256564 - Recompile due to PF changes done by fix 256330      *
021800200529      *  248297 - EXTDTA is no more part of Output buffers            *
021900200529      *           - Add DS in Buffer2                                 *
022000200529      *           - Ensure MMLDNIR also use it                        *
022100200529      *           - ROLLBACK updates in case of Problem               *
022200200529      *  244784 - Lux fields are lost. Remove BUG10943 because        *
022300200529      *           inconsistent with processing in APTRANVU            *
022400200529      *  244537 - To avoid overriding front office identifier.        *
022500200529      *  BUG5169 - Validate CDL020 fields on MMLDNIVLP.               *
022600200529      *  BUG12967 - MM LDNI crashes with serious Midas Error          *
022700200529      *  241685 - Extended Settlements are not defaulted. Default     *
022800200529      *           when Pay/Receipt Settlement is blank and Currency   *
022900200529      *           Code and Customer are NOT blank.                    *
023000200529      *  BUG12589 - When short term rate is specified, it is not      *
023100200529      *             reflected as actual interest rate in the files    *
023200200529      *             due to recalculation in calling MMLDNIVLP.        *
023300200529      *  BUG12551 - LDNI was unable to amend transaction.             *
023400200529      *             Serious Midas Plus error occurred.                *
023500200529      *             Reference Rate field was not updated properly.    *
023600200529      *  CDL049 - Addition of a Reference Rate field (recompile)      *
023700200529      *  239400 - Add Front Office ID to be used by SOAP Interface    *
023800200529      *  CSD027A - Conversion Of Customer Number to Alpha             *
023900200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
024000200529      *  BUG10943 - Interest Rate Change Schedule not displayed       *
024100200529      *  BUG10718 - Deletion of Fiduciary Placing Associated Takings  *
024200200529      *             not deleted, no warning message.                  *
024300200529      *  BUG10725 - Fiduciary code/charges are not updated during     *
024400200529      *             insertion thereby causing Midasplus error in      *
024500200529      *             deal amendments                                   *
024600200529      *  BUG10695 - Wrong Total Interest being computed for           *
024700200529      *             fiduciary deals.  (Recompile)                     *
024800200529      *  BUG10677- Do not delete associated takings when the placing  *
024900200529      *            being deleted is authorised.  Also send appropriate*
025000200529      *            warning messages when deleting fiduciary deals.    *
025100200529      *  BUG10341-Indicate which row on edit table is in error        *
025200200529      *  BUG10563-Resolve conflict between BUG10296 and 9827          *
025300200529      *  BUG9827 - Fiduciary deal changes for Midas Plus              *
025400200529      *  BUG10296 - LUX extension fields are missing                  *
025500200529      *  CAP087  - REPO JAVA changes                                  *
025600200529      *  CER001 - LUX Upgrade to MidasPlus                            *
025700200529      *  BUG8119 - Fields returned incorrectly from API if update     *
025800200529      *            flag set to 'Y' but data is invalid.               *
025900200529      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
026000200529      *  CDL038 - Extended Deal Sub Type                              *
026100200529      *  CDL033  - Floating Rate CDs Issued.                          *
026200200529      *  BUG6512 - Retrieve TRAM details                              *
026300200529      *  BUG6164 - For WIP authorise cannot call ValidateAc before    *
026400200529      *            ValidateTr as HK* fields are not always retrieved. *
026500200529      *  BUG4808 - Unable to authorise transaction because WIP do     *
026600200529      *            not have correct Timestamp.                        *
026700200529      *  BUG4728 - Serious Midas error with blank timestamp when      *
026800200529      *            authorising insert of transaction.                 *
026900200529      *  BUG3992- Call new program MMLDNIVLP to perform post          *
027000200529      *           settlement detail validation. Revalidate dates.     *
027100200529      *  BUG4482- Authorise should call Validate to show all the      *
027200200529      *           warning errors.                                     *
027300200529      *  BUG3792- Only allow Block/Unblock on Deposits.               *
027400200529      *  BUG4380- Clear Multiple Sett Account fields if not selected  *
027500200529      *  BUG4068- Deal number range for Fixed Loan/Deposit            *
027600200529      *  BUG4097 - Ensure Block/Unblock action leaves deal authorised *
027700200529      *  BUG3684 - Set up action field for Block/Unblock              *
027800200529      *  BUG3986- Pass the status and TimeStamp out to the MidasPlus *
027900200529      *  CMM105 - Core changes for GBO005                             *
028000200529      *         - Fixed Deposits Held Under Lien                      *
028100200529      *                  - Upgrade to Midasplus                       *
028200200529      *           Core hooks added: MMLDNIXD01,MMLDNIXC01,            *
028300200529      *                             MMLDNIXC03,MMLDNIXC04,MMLDNIXC05, *
028400200529      *                             MMLDNIXC06                        *
028500200529      *           Core hooks amended:MMLDNIM01                        *
028600200529      *  BUG3869 - Records lost from DLFSACPD on authorization        *
028700200529      *  CLE025 - Credit Lines (Recompile)                            *
028800200529      *  TCA002 - 10-Digit Account Code Errors - Retrieve a/c details.*
028900200529      *  CSC022 - Commitment Control Changes for MidasPlus            *
029000200529      *  CGL029 - Increase Account Code to 10 digits                  *
029100200529      *  CDL020 - Apply Base Rate at Value Date                       *
029200200529      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
029300200529      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
029400200529      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
029500200529      *           (Recompile)                                         *
029600200529      *  CDL016 - Automatic Rollover of Fixed Term Loan/Deposit       *
029700200529      *  222727 - Release 5.0 errors (recompile).                     *
029800200529      *  CAP084 - API Wrapper project                                 *
029900200529      *                                                               *
030000200529      *****************************************************************
030100200529      ** +--------------------------------------+
030200200529      ** ¦ F-specs                              ¦
030300200529      ** ¦ =======                              ¦
030400200529      ** +--------------------------------------+
030500200529      *****************************************************************
030600200529
030700200529     FSDFDDRL0  UF   E           K DISK    INFSR(*PSSR)                                      BUG4068
030800200529     F                                     COMMIT                                            BUG4068
030900200529      ** Fixed Loan/Deposit Deal Number Range file                                           BUG4068
031000200529      *                                                                                      BUG4068
031100200529     F***MMDEALLL  IF   E           K DISK    INFSR(*PSSR)                          BUG4068 AR665113
031200200529     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)                                     AR665113
031300200529     FDEALSCL1  IF   E           K DISK    INFSR(*PSSR)                                     AR665113
031400200529     F                                     RENAME(DEALSDCF:DEALSRCF)                        AR665113
031500200529      *                                                                                      BUG4068
031600200529     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
031700200529     FDLFRSCL0  UF A E           K DISK    INFSR(*PSSR)                                       CDL033
031800200529     F                                     COMMIT                                             CDL033
031900200529     FSDCCGRL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG9827
032000200529     FDLCCGDL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG9827
032100200529     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG9827
032200200529
032300200529      *****************************************************************
032400200529      ** +--------------------------------------+
032500200529      ** ¦ Automatically included D-specs       ¦
032600200529      ** ¦ ==============================       ¦
032700200529      ** +--------------------------------------+
032800200529      **
032900200529      ** Standard D-specs
033000200529      ** ================
033100200529      **
033200200529      ** The following /COPY line includes the LDA layout,
033300200529      ** the copyright array definition,
033400200529      ** and the following named constants:
033500200529      **    True       logical = *on (for indicator processing)
033600200529      **    False      logical = *off (for indicator processing)
033700200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
033800200529      **                                    handler)
033900200529      ** and the following variables:
034000200529      **    RunBefore  1A (for the PSSR)
034100200529
034200200529     D/COPY ZACPYSRC,STD_D_SPEC
034300200529
034400200529      ** Include the MM standard declares
034500200529     D/COPY ZACPYSRC,STDDECLARE
034600200529
034700200529      ** Program Status Data Structure
034800200529      ** =============================
034900200529      ** The following /COPY line includes all the defined fields in the
035000200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
035100200529
035200200529     D/COPY ZACPYSRC,PSDS
035300200529      ** The following /COPY line includes definitions for the above fields
035400200529      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
035500200529      ** corresponding fields in the PSDS /COPY member, so that member
035600200529      ** must be included where this one is used.
035700200529
035800200529     D/COPY ZACPYSRC,PROCPARMS
035900200529
036000200529      **--------------------------------------------------------------------------------------------
036100200529      ** The following /COPY line includes the definitions for error and
036200200529      ** warning message arrays.
036300200529     D/COPY ZACPYSRC,ERR_ARRAYS
036400200529      **--------------------------------------------------------------------------------------------
036500200529
036600200529      **--------------------------------------------------------------------------------------------
036700200529      ** The following /COPY line includes the definitions for arrays
036800200529      ** specific to API *CTL modules.
036900200529     D/COPY ZACPYSRC,APICTLARR
037000200529      **--------------------------------------------------------------------------------------------
037100200529
037200200529      **-----------------------------------------------------------------------
037300200529      ** The following /COPY line includes the definitions for fields
037400200529      ** used in checking whether there are messages on the data queue.
037500200529     D/COPY ZACPYSRC,DTAQCHKDCL
037600200529      **-----------------------------------------------------------------------
037700200529
037800200529      ** +--------------------------------------+
037900200529      ** ¦ End of automatically included D-specs¦
038000200529      ** ¦ =====================================¦
038100200529      ** +--------------------------------------+
038200200529
038300200529      *****************************************************************
038400200529      /EJECT
038500200529      *****************************************************************
038600200529
038700200529      ** +--------------------------------------+
038800200529      ** ¦ Manually included D-specs            ¦
038900200529      ** ¦ =========================            ¦
039000200529      ** +--------------------------------------+
039100200529
039200200529      ** +--------------------------------------+
039300200529      ** ¦ Named constants                      ¦
039400200529      ** ¦ ===============                      ¦
039500200529      ** +--------------------------------------+
039600200529
039700200529      ** String for error messages to the operator
039800200529     D ProcErr         C                   CONST('Error in module')
039900200529
040000200529      ** +--------------------------------------+
040100200529      ** ¦ Arrays and Data Structures           ¦
040200200529      ** ¦ ==========================           ¦
040300200529      ** +--------------------------------------+
040400200529
040500200529      ** Array of Fields in error.                                                           BUG4808
040600200529     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG4808
040700200529                                                                                             BUG4808
040800200529      ** Array of error message IDs                                                          BUG4808
040900200529     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG4808
041000200529     D                                     LIKE(#MsgID)                                      BUG4808
041100200529                                                                                             BUG4808
041200200529      ** Array of error message data.                                                        BUG4808
041300200529     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG4808
041400200529     D                                     LIKE(#MsgData)                                    BUG4808
041500200529                                                                                             BUG4808
041600200529      ** Array of message files to check                                                     BUG4808
041700200529     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG4808
041800200529                                                                                             BUG4808
041900200529     D OLDMSG          S             10A   DIM(16) PERRCD(1) CTDATA                         BUG10341
042000200529     D NEWMSG          S             10A   DIM(16) ALT(OLDMSG)                              BUG10341
042100200529      * Incoming Header
042200200529     D HeadIn        E DS                  EXTNAME(APHEADPD)
042300200529
042400200529      * Incoming transaction in screen format
042500200529     D TranIn        E DS                  EXTNAME(MMLDNIPD)
042600200529
042700200529     D TranQExt      E DS                  EXTNAME(DLSTMPPD)                                  CER049
042800200529     ** Incoming stamp tax details screen format                                              CER049
042900200529                                                                                              CER049
043000200529      * Valid file layout
043100200529     D ValidDeal     E DS                  EXTNAME(MMVLDNIPD)
043200200529     D***LDNIRecIns           456    524                                                      CGL029
043300200529     D***LDNIPayIns           525   1083                                                      CGL029
043400200529     D LDNIRecIns            470    524                                                       CGL029
043500200529     D LDNIPayIns            539   1083                                                       CGL029
043600200529
043700200529      * Current transaction record in file format
043800200529     D DealFilFmt    E DS                  EXTNAME(MMDELDPP)
043900200529     D  QQDORI1      E                     EXTFLD(QQDORI)                                     CGL029
044000200529     D  QQMORI1      E                     EXTFLD(QQMORI)                                     CGL029
044100200529     D  QQDOPI1      E                     EXTFLD(QQDOPI)                                     CGL029
044200200529     D  QQMOPI1      E                     EXTFLD(QQMOPI)                                     CGL029
044300200529     D  QQRONS1      E                     EXTFLD(QQRONS)                                     CGL029
044400200529     D  QQPONS1      E                     EXTFLD(QQPONS)                                     CGL029
044500200529     D  QQINSA1      E                     EXTFLD(QQINSA)                                     CGL029
044600200529     D***DELDRecIns           456    524                                                      CGL029
044700200529     D***DELDPayIns           525   1083                                                      CGL029
044800200529     D DELDRecIns            470    524                                                       CGL029
044900200529     D DELDPayIns            539   1083                                                       CGL029
045000200529
045100200529      * Current transaction in screen format
045200200529     D DealScnFmt    E DS                  EXTNAME(MMLDNIPD)
045300200529     D                                     PREFIX(@)
045400200529
045500200529      * Pay settlement instructions in screen format
045600200529     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
045700200529
045800200529      * Receive settlement instructions in screen format
045900200529     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
046000200529
046100200529      * FRA/IRS settlement instructions in screen format
046200200529     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
046300200529
046400200529      * Pay settlement instructions - current
046500200529     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
046600200529
046700200529      * Receive settlement instructions - current
046800200529     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
046900200529
047000200529      * FRA/IRS settlement instructions - current
047100200529     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
047200200529
047300200529      * Pay settlement instructions in file format
047400200529     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
047500200529     D FLPAY2                 21    565                                                       CGL029
047600200529
047700200529      * Receive settlement instructions in file format
047800200529     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
047900200529     D FLREC2                 21     75                                                       CGL029
048000200529
048100200529      * FRA/IRS settlement instructions in file format
048200200529     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
048300200529
048400200529     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  CDL018
048500200529      * Receive Further Settlement Instructions in file format                                CDL018
048600200529                                                                                              CDL018
048700200529     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  CDL018
048800200529      * Payment Further Settlement Instructions in file format                                CDL018
048900200529                                                                                              CDL018
049000200529     D #FRECS        E DS                  EXTNAME(SDFSSRPD)                                  CDL018
049100200529      * Receive Further Settlement instructions in screen format                              CDL018
049200200529                                                                                              CDL018
049300200529     D #FPAYS        E DS                  EXTNAME(SDFSSPPD)                                  CDL018
049400200529      * Payment Further Settlement instructions in screen format                              CDL018
049500200529                                                                                              CDL018
049600200529     D #FRECE        E DS                  EXTNAME(SDFSERPD)                                  CDL018
049700200529      * Errors - Receive Further Settlement Instructions                                      CDL018
049800200529                                                                                              CDL018
049900200529     D #FPAYE        E DS                  EXTNAME(SDFSEPPD)                                  CDL018
050000200529      * Errors - Payment Further Settlement Instructions                                      CDL018
050100200529                                                                                              CDL018
050200200529      * Extra data in file format - Class 1 data
050300200529     D InfData       E DS                  EXTNAME(MMLDIFPD)
050400200529     D                                     PREFIX(IF_)
050500200529
050600200529      * Extra data in file format
050700200529     D ExtData       E DS                  EXTNAME(MMLDEXPD)
050800200529      *                                                                                       CER001
050900200529      ** Regional data in file format                                                         CER001
051000200529      *                                                                                       CER001
051100200529     D RegData       E DS                  EXTNAME(MMLDRXPD)                                  CER001
051200200529
051300200529      * External DS for bank details
051400200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
051500200529
051600200529      * External DS for API ICD
051700200529     D SDAPI         E DS                  EXTNAME(SDAPIPD)
051800200529
051900200529      * External DS for SAR details
052000200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
052100200529     D SCA_LCD       E                     EXTFLD(LCD)
052200200529                                                                                             BUG9827
052300200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                 BUG9827
052400200529      ** External DS for Midas Modules                                                       BUG9827
052500200529     D SDPORT        E DS                  EXTNAME(SDPORTPD)                                 BUG9827
052600200529      ** External DS for Portfolio Management ICD                                            BUG9827
052700200529     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG9827
052800200529      ** External DS for Customer Details                                                    BUG9827
052900200529     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                 BUG9827
053000200529      ** External DS for Portfolio Management ICD                                            BUG9827
053100200529     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                 BUG9827
053200200529      ** External DS for dealing ICD                                                         BUG9827
053300200529
053400200529      * First DS for access programs - short data structure
053500200529     D DSFDY         E DS                  EXTNAME(DSFDY)
053600200529
053700200529      * Second DS for access programs - long data structure
053800200529     D DSSDY         E DS                  EXTNAME(DSSDY)
053900200529                                                                                             BUG9827
054000200529     D DSLDY         E DS                  EXTNAME(DSLDY)                                    BUG9827
054100200529
054200200529     D ValidLUX      E DS                  EXTNAME(MMVLDLX1PD)                                CER001
054300200529                                                                                              CER001
054400200529     D SVRCD         E DS                  EXTNAME(MMDLX1PD)                                  CER001
054500200529     D                                     PREFIX(SV)                                         CER001
054600200529                                                                                              CER001
054700200529     D OkFlags       E DS                  EXTNAME(MMELDLX1PD)                                CER001
054800200529                                                                                              CER001
054900200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
055000200529      ** 24X7 status dataarea
055100200529
055200200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
055300200529      ** SD data area
055400200529
055500200529     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
055600200529     D  WCMTJOBS               4    103A                                                      CSC022
055700200529      ** Commitment Control dataarea                                                          CSC022
055800200529                                                                                              CSC022
055900200529      ** Array to hold commitment jobs name                                                   CSC022
056000200529     D WCMT            S             10A   DIM(10)                                            CSC022
056100200529                                                                                              CSC022
056200200529     D ZMUSER          DS            17                                                      BUG9827
056300200529     D  ZMBRCA                11     13                                                      BUG9827
056400200529     D  ZMDEPT                14     16                                                      BUG9827
056500200529                                                                                             BUG9827
056600200529     D MMLDNIUPC       DS             1    DTAARA(MMLDNIUPC)
056700200529
056800200529     D                 DS
056900200529     D  @@YEAR                 1      4  0
057000200529     D  @@MNTH                 5      6  0
057100200529     D  @@DAY                  7      8  0
057200200529     D  @@DTIN                 1      8  0
057300200529
057400200529     D                 DS                                                                    CSF011A
057500200529     D  A#OURA                 1     21                                                      CSF011A
057600200529     D  A#NOST                 1      2                                                      CSF011A
057700200529     D  A#CNUM                 1      6                                                      CSF011A
057800200529     D  A#RENO                 1     10                                                      CSF011A
057900200529     D  A#ACOD                 7     16                                                      CSF011A
058000200529     D  A#ACAS                 7     18                                                      CSF011A
058100200529     D  A#ACSQ                17     18                                                      CSF011A
058200200529     D  A#REST                 3     18                                                      CSF011A
058300200529     D  A#RES2                11     18                                                      CSF011A
058400200529     D  A#BRCA                19     21                                                      CSF011A
058500200529                                                                                             CSF011A
058600200529      ***Customers*Extension*Screen*Format*based*on*SDCUCUPD                           CER043 CSF011
058700200529     D***TranInCust    E DS                  EXTNAME(SDCUCUPD)                         CER043 CSF011
058800200529                                                                                              CSF011
058900200529     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSF011
059000200529     D                                     PREFIX(NO_)                                        CSF011
059100200529     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CSF011
059200200529     D                                     PREFIX(AC_)                                        CSF011
059300200529     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                                  CSF011
059400200529     D @TYPE           S              7                                                      CSF011A
059500200529     D @ACID           S             10                                                      CSF011A
059600200529     D @CYCD           S              3                                                      CSF011A
059700200529     D @ACCD           S             10                                                      CSF011A
059800200529     D @ACSN           S              2                                                      CSF011A
059900200529     D @BRCA           S              3                                                      CSF011A
060000200529     D @NOSN           S              2                                                      CSF011A
060100200529     D @CUST           S              6                                                      CSF011A
060200200529     D @PNOI           S              1                                                      CSF011A
060300200529     D @CSSN           S             10                                                      CSF011A
060400200529     D #TRCCY          S              3A                                                     CSF011A
060500200529     D #TPCCY          S              3A                                                     CSF011A
060600200529      *                                                                                       CER043
060700200529     D DDAPRC          S              1A                                                    MD054028
060800200529     D DDAPRR          S              8A                                                    MD054028
060900200529      ** +--------------------------------------+
061000200529      ** ¦ Declared variables                   ¦
061100200529      ** ¦ ==================                   ¦
061200200529      ** +--------------------------------------+
061300200529
061400200529      ** Error message field(s)
061500200529     D     Msg1        S                   LIKE(#MsgID)
061600200529
061700200529      ** Index for arrays of error message ids etc
061800200529     D Idx             S              3P 0
061900200529
062000200529      ** Index for arrays of warning message ids etc
062100200529     D WIdx            S              3P 0
062200200529
062300200529      ** Field (500A) to receive the incoming transaction
062400200529     D***Trans500        S            500A                                                   CSF011A
062500200529     D Trans500        S           1000A                                                     CSF011A
062600200529
062700200529      ***Field*(500A)*to*receive*the*incoming*Settelement*details                      CER043 CSF011
062800200529     D***Trans500C       S            500A                                             CER043 CSF011
062900200529      *                                                                                       CER043
063000200529      ** Field (500A) to receive the incoming Extra Data
063100200529     D InfData500      S            500A
063200200529
063300200529      ** Field (500A) to receive the incoming Stamp Tax data                                  CER049
063400200529     D TransQ500       S            500A                                                      CER049
063500200529                                                                                              CER049
063600200529      ** Field (500A) to receive the incoming Extra Data
063700200529     D ExtData500      S            500A
063800200529      *                                                                                       CER001
063900200529      ** Field (500A) to receive the incoming Extra Data                                      CER001
064000200529      *                                                                                       CER001
064100200529     D RegData500      S            500A                                                      CER001
064200200529
064300200529      ** Index for arrays of error message ids etc in Amend validation
064400200529     D AmIdx           S              3P 0
064500200529
064600200529      ** Indices for arrays used to set up corresponding sequence numbers
064700200529      **  for the fields that are in error
064800200529     D Ix              S              3P 0
064900200529     D Iy              S              3P 0
065000200529
065100200529     D MMELDN        E DS                  EXTNAME(MMELDNIPD)
065200200529      * Error indicators
065300200529
065400200529     D MMELDN2       E DS                  EXTNAME(MMELDN2PD)                                 CDL016
065500200529      * Error indicators screen 2                                                             CDL016
065600200529                                                                                              CDL016
065700200529      ** Flags to indicate whether Pay Settlement instruction fields
065800200529      **  are valid
065900200529     D OKPayInsDS      DS
066000200529     D  DDPscyOK                      1A   INZ('Y')
066100200529     D  DDPstmOK                      1A   INZ('Y')
066200200529     D  DDPonxOK                      1A   INZ('Y')
066300200529     D  DDRvnoOK                      1A   INZ('Y')
066400200529     D  DDCvmrOK                      1A   INZ('Y')
066500200529     D  DDPocnOK                      1A   INZ('Y')
066600200529     D  DDPobnOK                      1A   INZ('Y')
066700200529     D  DDRcrnOK                      1A   INZ('Y')
066800200529     D  DDRcraOK                      1A   INZ('Y')
066900200529     D  DDPibnOK                      1A   INZ('Y')
067000200529     D  DDPibaOK                      1A   INZ('Y')
067100200529     D  DDAwbnOK                      1A   INZ('Y')
067200200529     D  DDAwbaOK                      1A   INZ('Y')
067300200529     D  DDBennOK                      1A   INZ('Y')
067400200529     D  DDBenaOK                      1A   INZ('Y')
067500200529     D  DDDtp1OK                      1A   INZ('Y')
067600200529     D  DDDtp2OK                      1A   INZ('Y')
067700200529     D  DDDtp3OK                      1A   INZ('Y')
067800200529     D  DDDtp4OK                      1A   INZ('Y')
067900200529     D  DDDchgOK                      1A   INZ('Y')
068000200529     D  DDIc72OK                      1A   INZ('Y')
068100200529     D  DDBtb1OK                      1A   INZ('Y')
068200200529     D  DDBtb2OK                      1A   INZ('Y')
068300200529     D  DDBtb3OK                      1A   INZ('Y')
068400200529     D  DDBtb4OK                      1A   INZ('Y')
068500200529     D  DDBtb5OK                      1A   INZ('Y')
068600200529     D  DDBtb6OK                      1A   INZ('Y')
068700200529     D  DDPmacOK                      1A   INZ('Y')                                           CDL018
068800200529
068900200529      ** Flags to indicate whether Receive Settlement instruction fields
069000200529      **  are valid
069100200529     D OKRecInsDS      DS
069200200529     D  DDRscyOK                      1A   INZ('Y')
069300200529     D  DDRstmOK                      1A   INZ('Y')
069400200529     D  DDRonxOK                      1A   INZ('Y')
069500200529     D  DDRocnOK                      1A   INZ('Y')
069600200529     D  DDRobnOK                      1A   INZ('Y')
069700200529     D  DDRibnOK                      1A   INZ('Y')
069800200529     D  DDRibaOK                      1A   INZ('Y')
069900200529     D  DDRmacOK                      1A   INZ('Y')                                           CDL018
070000200529
070100200529     D  DDRexrOK                      1A   INZ('Y')                                           CDL094
070200200529     D  DDRexiOK                      1A   INZ('Y')                                           CDL094
070300200529     D  DDRbb1OK                      1A   INZ('Y')                                           CDL094
070400200529     D  DDRbb2OK                      1A   INZ('Y')                                           CDL094
070500200529     D  DDRbb3OK                      1A   INZ('Y')                                           CDL094
070600200529     D  DDRbb4OK                      1A   INZ('Y')                                           CDL094
070700200529     D  DDRbb5OK                      1A   INZ('Y')                                           CDL094
070800200529     D  DDRbb6OK                      1A   INZ('Y')                                           CDL094
070900200529
071000200529      ** Flags to indicate whether FRA/IRS instruction fields are valid
071100200529     D OKFRAInsDS      DS
071200200529     D  DDDsr1OK                      1A   INZ('Y')
071300200529     D  DDDsr2OK                      1A   INZ('Y')
071400200529     D  DDDsr3OK                      1A   INZ('Y')
071500200529     D  DDDsr4OK                      1A   INZ('Y')
071600200529     D  DDDsr5OK                      1A   INZ('Y')
071700200529     D  DDDsr6OK                      1A   INZ('Y')
071800200529     D  DDSsr1OK                      1A   INZ('Y')
071900200529     D  DDSsr2OK                      1A   INZ('Y')
072000200529     D  DDSsr3OK                      1A   INZ('Y')
072100200529     D  DDSsr4OK                      1A   INZ('Y')
072200200529     D  DDSsr5OK                      1A   INZ('Y')
072300200529     D  DDSsr6OK                      1A   INZ('Y')
072400200529     D  DDCnd1OK                      1A   INZ('Y')
072500200529     D  DDCnd2OK                      1A   INZ('Y')
072600200529     D  DDCnd3OK                      1A   INZ('Y')
072700200529     D  DDCnd4OK                      1A   INZ('Y')
072800200529     D  DDCnd5OK                      1A   INZ('Y')
072900200529     D  DDCnd6OK                      1A   INZ('Y')
073000200529     D  DDIsdaOK                      1A   INZ('Y')
073100200529     D  DDAgtyOK                      1A   INZ('Y')
073200200529     D  DDAgdtOK                      1A   INZ('Y')
073300200529     D  DDAgvvOK                      1A   INZ('Y')
073400200529
073500200529     D DATALUX         DS          1024                                                       CER001
073600200529     D  #1FLD1                 1      6  0                                                    CER001
073700200529     D  #1DN38                 1      6                                                       CER001
073800200529     D  #1DLTP                 7      8                                                       CER001
073900200529     D  #1CNUM                 9     14                                                       CER001
074000200529     D  #1CCY                 15     17                                                       CER001
074100200529     D  #1AMNT                18     32  0                                                    CER001
074200200529     D  #1VDAT                33     38                                                       CER001
074300200529     D  #1MDAT                39     44                                                       CER001
074400200529     D  #1FOTR                45     64                                                       CER001
074500200529     D  #1TMST                65     90Z                                                      CER001
074600200529                                                                                              CER001
074700200529     D WFIDTDTL        DS            48                                                      BUG9827
074800200529     D  SFDLNO                 1      6                                                      BUG9827
074900200529     D  SFCNUM                 7     16                                                      BUG9827
075000200529     D  SFPTFR                17     20                                                      BUG9827
075100200529     D  SFAMNT                21     35                                                      BUG9827
075200200529     D  SFACOD                36     45                                                      BUG9827
075300200529     D  SFACSQ                46     47                                                      BUG9827
075400200529     D  SFTRAS                48     48                                                      BUG9827
075500200529                                                                                             BUG9827
075600200529     D VFIDTDTL        DS            48                                                      BUG9827
075700200529     D  VSFDLNO                1      6                                                      BUG9827
075800200529     D  VSFCNUM                7     16                                                      BUG9827
075900200529     D  VSFPTFR               17     20                                                      BUG9827
076000200529     D  VSFAMNT               21     35                                                      BUG9827
076100200529     D  VSFACOD               36     45                                                      BUG9827
076200200529     D  VSFACSQ               46     47                                                      BUG9827
076300200529     D  VSFTRAS               48     48                                                      BUG9827
076400200529                                                                                             BUG9827
076500200529     D WDUMMY          S             90A                                                    BUG10563
076600200529     D FIDTScnRpt      S           4752A                                                     BUG9827
076700200529     D FIDTScnRstN     S            240A                                                     BUG9827
076800200529     D FIDTVScnFmt     S           4752A                                                     BUG9827
076900200529                                                                                             BUG9827
077000200529      ** Flag to indicate outcome of call to lower level module
077100200529     D AmendOK         S              1A   INZ('Y')
077200200529
077300200529      ** A code to indicate the calling function to the lower level modules
077400200529     D LDNI            S              4A   INZ('LDNI')
077500200529
077600200529      ** Payment & Receipt dates, passed to Settlements Validation routine.
077700200529      ** spaces in parameter list not used by this function
077800200529     D PayDat          S              5P 0 INZ(99999)
077900200529     D RecDat          S              5P 0 INZ(99999)
078000200529     D LOD             S              1A   INZ(*Blanks)                                       250161
078100200529      ** Value Date as a Midas Day Number to be placed in either Payment
078200200529      **  or Receipt Date
078300200529     D ValDateMDN      S              5P 0
078400200529
078500200529      ** Blank fields, passed to Settlements Defaulting routine, to fill
078600200529      ** spaces in parameter list not used by this function
078700200529     D Blank2          S              2A   INZ(*BLANKS)
078800200529     D Blank3          S              3A   INZ(*BLANKS)
078900200529     D Blank4          S              4A   INZ(*BLANKS)
079000200529     D Blank6          S              6A   INZ(*BLANKS)
079100200529
079200200529      ** Error Flag for call to Standard routines (equates to *IN99)
079300200529     D ErrorFlag       S              1A   INZ('N')
079400200529
079500200529      ** Timestamp for the transaction
079600200529     D TimeStamp       S               Z
079700200529                                                                                              CDL033
079800200529      ** Interest Rate Change or Interest Payment                                             CDL033
079900200529     D IntRate         S              1A                                                      CDL033
080000200529
080100200529      ** Receive / Pay Settlement Currency, Method & Nostro
080200200529     D RecSetCcy       S              3A
080300200529     D RecSetMeth      S              2S 0
080400200529     D RecNostro       S             18A                                                      CDL038
080500200529     D*RecNostro*******S             12A                                                      CDL038
080600200529     D PaySetCcy       S              3A
080700200529     D PaySetMeth      S              2S 0
080800200529     D PayNostro       S             18A                                                      CDL038
080900200529     D*PayNostro*******S             12A                                                      CDL038
081000200529
081100200529     D OLD_MATD        S              5P 0
081200200529     D WProcDate       S                   LIKE(BJRDNB)
081300200529     D CSC011          S              1A   INZ('N')
081400200529
081500200529      ** Midas Day number
081600200529     D @@DAYN          S              5P 0
081700200529
081800200529      ** Formatted date field for use in the parameter list
081900200529     D DateOut         S              8S 0
082000200529
082100200529      ** Fields for enhancement CSC022                                                        CSC022
082200200529     D CSC022          S              1A   INZ('N')                                           CSC022
082300200529     D WCmtSk          S              1A                                                      CSC022
082400200529                                                                                              CDL033
082500200529     DBuffer2          DS          3999                                                       CDL033
082600200529     DBufferEx2        DS          9999                                                       CDL033
082700200529     D***SfBuff20               1   4800                                            CDL033 AR1060863
082800200529     D***SfBuff21            4801   9600                                            CDL033 AR1060863
082900200529     D  SfBuff20            2282   7081                                                    AR1060863
083000200529     DBufferEx3        DS          9999                                                       CSF011
083100200529     D  SfBuff21            2283   7082                                                    AR1060863
083200200529     DPInDates         DS          3600                                                       CDL033
083300200529     DRinDates         DS          3600                                                       CDL033
083400200529     DRatDATEADS       DS                                                                     CDL033
083500200529     D RatDATEA                       8A   DIM(600)                                           CDL033
083600200529     D  RatDate                       6A   OVERLAY(RatDATEA:1)                                CDL033
083700200529     D  RatIndtr                      1A   OVERLAY(RatDATEA:7)                                CDL033
083800200529     D  RatProc                       1A   OVERLAY(RatDATEA:8)                                CDL033
083900200529     DPayDATEADS       DS                                                                     CDL033
084000200529     DPayDATEA                        8A   DIM(600)                                           CDL033
084100200529     D  PayDate                       6A   OVERLAY(PayDATEA:1)                                CDL033
084200200529     D  PayIndtr                      1A   OVERLAY(PayDATEA:7)                                CDL033
084300200529     D  PayProc                       1A   OVERLAY(PayDATEA:8)                                CDL033
084400200529     DRatDAYA                         5S 0 DIM(600)                                           CDL033
084500200529     DPayDAYA                         5S 0 DIM(600)                                           CDL033
084600200529     D                 DS                                                                     CDL033
084700200529     D  XCharA                        3A                                                      CDL033
084800200529     D  XNumP                         5P 0 OVERLAY(XCharA)                                    CDL033
084900200529     DRatDateDS        DS          4800                                                       CDL033
085000200529     DPayDateDS        DS          4800                                                       CDL033
085100200529     DRPConfHol        DS           600                                                       CDL033
085200200529     DRProcInd         DS           600                                                       CDL033
085300200529     DPPConfHol        DS           600                                                       CDL033
085400200529     DPProcInd         DS           600                                                       CDL033
085500200529     DRFormula         S              8A                                                      CDL033
085600200529     DPFormula         S              8A                                                      CDL033
085700200529     DPvalueDate       S              5P 0                                                    CDL033
085800200529     DPmaturityDate    S              5P 0                                                    CDL033
085900200529     DPControlDate     S              5P 0                                                    CDL033
086000200529     DPaction          S              1A                                                      CDL033
086100200529     DPDealNo          S              6A                                                      CDL033
086200200529     DPPrevDate        S              5P 0                                                    CDL033
086300200529     DOPrevDate        S              5P 0                                                    CDL033
086400200529     DPcurrency        S              3A                                                      CDL033
086500200529     DRDatesIn         DS          3600                                                       CDL033
086600200529     DOKInRatCal       S            600A                                                      CDL033
086700200529     DRValDateOut      S           1800                                                       CDL033
086800200529     DPValDateOut      S           1800                                                       CDL033
086900200529     DPFrequency       S              1A                                                      CDL033
087000200529     DPfreqForm        S              7A                                                      CDL033
087100200529     DValDateIn        S           1800                                                       CDL033
087200200529     DARdx             S              3S 0                                                    CDL033
087300200529     DARelmt           S              5S 0                                                    CDL033
087400200529     DXResult          S              9S 4                                                    CDL033
087500200529     DXRemand          S              3S 0                                                    CDL033
087600200529     DPDatesIn         DS          3600                                                       CDL033
087700200529     D PDateIn         S              6A                                                      CDL033
087800200529     D PDayNoOut       S              5P 0                                                    CDL033
087900200529     D PErrorFlg       S              1A                                                      CDL033
088000200529     D I               S              5S 0                                                    CDL033
088100200529     D J               S              5S 0                                                    CDL033
088200200529     D N               S              5S 0                                                    CDL033
088300200529     D S               S              5S 0                                                    CDL033
088400200529     D T               S              5S 0                                                    CDL033
088500200529     DVDLNO            S              6S 0                                                    CDL033
088600200529     DSRate            S             11P 7                                                    CDL033
088700200529     D #N              S              5S 0                                                    CDL033
088800200529     D #X              S              5S 0                                                    CDL033
088900200529     D #Y              S              5S 0                                                    CDL033
089000200529     DZDAYNO           S              5P 0                                                    CDL033
089100200529     DZDATE            S              6P 0                                                    CDL033
089200200529     DZADATE           S              7A                                                      CDL033
089300200529     D@ACDLNO          S              7A                                                      CDL033
089400200529     D ACTN            S              1                                                       CER001
089500200529     D WFIND           S              1                                                       CER001
089600200529     D @@ER91          S              1                                                       CER001
089700200529     D ULX600          S              1A                                                      CER001
089800200529     D CER043          S              1A                                                      CER043
089900200529      ***This*field*should*be*reduced*everytime*a*core*field*is*added              BUG10296 BUG10563
090000200529     D*LDNIFil*        S           3953A                                           BUG10296 BUG10563
090100200529                                                                                              CSC022
090200200529     D WTAmount        S             15S 0                                                   BUG9827
090300200529     D WAmount         S             15S 0                                                   BUG9827
090400200529     D OKFIDTDTL       S              1A                                                     BUG9827
090500200529     D Tkg             S              3  0                                                   BUG9827
090600200529     D TkgA            S              3A                                                    BUG10341
090700200529     D Str             S              4  0                                                   BUG9827
090800200529     D FIDTLen         S              2  0 INZ(48)                                           BUG9827
090900200529     D*Filler**        S           2523A                                              BUG9827 CER043
091000200529     D*Filler***       S           2072A                                               CER043 CDL096
091100200529     D*Filler**        S           2038A                                               CDL096 CGL165
091200200529     D Filler          S           2034A                                                      CGL165
091300200529     D NoOfTakingsIns  S              2  0 INZ(0)                                            BUG9827
091400200529     D S01468          S              1A                                                     BUG9827
091500200529     D NNDCSP          S              1A                                                     BUG9827
091600200529     D PCYDP           S              1S 0                                                   BUG9827
091700200529     D PDLNO           S                   LIKE(DDDLNO)                                      BUG9827
091800200529     D PNTCE           S              3S 0                                                   BUG9827
091900200529     D PDDMDAT         S              6A                                                     BUG9827
092000200529     D PDDNTCE         S              3A                                                     BUG9827
092100200529     D PKEY1           S             10A                                                     BUG9827
092200200529     D PKYST           S              7A                                                     BUG9827
092300200529     D PTOTI           S             14A                                                     BUG9827
092400200529     D PTRTP           S              5A                                                     BUG9827
092500200529     D ZADEC           S              1P 0                                                   BUG9827
092600200529     D ZADIG           S              2P 0                                                   BUG9827
092700200529     D ZALIGNOK        S              1A                                                     BUG9827
092800200529     D ZFIELD          S             16A                                                     BUG9827
092900200529     D ZFLD15          S             15P 0                                                   BUG9827
093000200529     D ZOUT21          S             21A                                                     BUG9827
093100200529     D ZECODE          S              1A                                                     BUG9827
093200200529     D ZDECS           S              1P 0                                                   BUG9827
093300200529     D PRDLNO          S                   LIKE(DDDLNO)                                      BUG9827
093400200529     D ErrTot          S              3  0                                                  BUG10341
093500200529     D NewErrTot       S              3  0                                                  BUG10341
093600200529     D ErrID           S              2  0                                                  BUG10341
093700200529     D St              S              3  0                                                  BUG10341
093800200529     D Le              S              3  0                                                  BUG10341
093900200529     D m               S              3  0                                                  BUG10341
094000200529     D pos             S              3  0                                                  BUG10341
094100200529                                                                                            MD000091
094200200529      **                                                                                    MD000091
094300200529     D BChar           DS                                                                   MD000091
094400200529     D   BLen                  1      2B 0                                                  MD000091
094500200529     D   LenStr                1      2                                                     MD000091
094600200529
094700200529     D @@STRT          S                   LIKE(IKINTR)                                     BUG12589
094800200529      ** +--------------------------------------+
094900200529      ** ¦ End of D-specs                       ¦
095000200529      ** ¦ ==============                       ¦
095100200529      ** +--------------------------------------+
095200200529
095300200529      ** +----------------------------------------+
095400200529      ** ¦ Hook for non-core D-specs (all types)  ¦
095500200529      ** ¦ also any I-specs (if necessary)        ¦
095600200529      ** ¦ =====================================  ¦
095700200529      ** +----------------------------------------+
095800200529
095900200529     D SREMK           S             35                                                       CMM105
096000200529      *                                                                                       CER043
096100200529      ** Parameters for Calling AOCUSTR0                                                      CER043
096200200529     D PCNum           S             10A                                                      CER043
096300200529     D PKey7           S              7A                                                      CER043
096400200529      *                                                                                       CER043
096500200529     D W#RONX          S             21                                                     MD022656
096600200529     D W#PONX          S             21                                                     MD022656
096700200529     D W#PSTM          S              2                                                     MD022656
096800200529     D W#RSTM          S              2                                                     MD022656
096900200529     D W#CCY           S              3                                                     MD022656
097000200529     D W#CNT           S              3P 0                                                  MD022656
097100200529     D W#ROBN          S             10    INZ(*BLANKS)                                     MD022656
097200200529     D W#ROCN          S             10    INZ(*BLANKS)                                     MD022656
097300200529     D W#POBN          S             10    INZ(*BLANKS)                                     MD022656
097400200529     D W#POCN          S             10    INZ(*BLANKS)                                     MD022656
097500200529     D W#ITER          S              1  0                                                  MD022656
097600200529     D W#RCRN          S             10    INZ(*BLANKS)                                     MD022849
097700200529     D W#RVNO          S             10    INZ(*BLANKS)                                     MD022849
097800200529     D W#AWBN          S             10    INZ(*BLANKS)                                     MD022849
097900200529     D W#PIBN          S             10    INZ(*BLANKS)                                     MD022849
098000200529     D W#BENN          S             10    INZ(*BLANKS)                                     MD022849
098100200529     D W#RIBN          S             10    INZ(*BLANKS)                                     MD022849
098200200529     D**ValueDate        S              5P 0                                      MD027337 MD027337A
098300200529     D/COPY WNCPYSRC,MMLDNIXD01
098400200529      *****************************************************************
098500200529      /EJECT
098600200529      *****************************************************************
098700200529      ** +--- Start of Main processing -----------------------------------+
098800200529      ** ¦                                                                ¦
098900200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
099000200529      ** ¦ executed at program activation.                                ¦
099100200529      ** ¦                                                                ¦
099200200529      ** +----------------------------------------------------------------+
099300200529
099400200529      * Incoming transaction is broken into 500A fields, so that a common CL
099500200529      * can be used between this module and the one that read the MQ queue.
099600200529      * This module needs to break these 500A fields by loading them into
099700200529      * the appropriate (externally described) data structure.
099800200529     C                   MOVEL     Trans500      TranIn
099900200529     C**********         MOVEL     Trans500C     TranInCust                            CER043 CSF011
100000200529     C                   MOVEL     TransQ500     TranQExt                                     CER049
100100200529                                                                                             BUG9827
100200200529      *-----------------------------------------------------------------------------         BUG9827
100300200529      * Buffer layout .......  please update when making future changes to buffer            BUG9827
100400200529      *                        or whenever a file layout changes                             BUG9827
100500200529      * ----------------------------------------------------------------------------         BUG9827
100600200529      * Field / DS  ¦ Start   ¦ End     ¦ Length   ¦                                         BUG9827
100700200529      * -------------------------------------------                                          BUG9827
100800200529      **MMLDNIPD****¦****1****¦**407****¦**407*****¦                                  BUG9827 CSF011
100900200529      **MMLDIFPD****¦**408****¦**457****¦***50*****¦                                  BUG9827 CSF011
101000200529      **RFormula****¦**458****¦**465****¦****8*****¦                                  BUG9827 CSF011
101100200529      **PFormula****¦**466****¦**483****¦****8*****¦                                BUG9827 BUG10563
101200200529      **SREMK*******¦**484****¦**518****¦***35*****¦                                BUG9827 BUG10563
101300200529      **DDSTS*******¦**519****¦**542****¦***24*****¦                                BUG9827 BUG10563
101400200529      **DDCSTS******¦**543****¦**552****¦***10*****¦                                BUG9827 BUG10563
101500200529      **CPST********¦**553****¦**554****¦****2*****¦                                BUG9827 BUG10563
101600200529      **DSPCP*******¦**555****¦**555****¦****1*****¦                                BUG9827 BUG10563
101700200529      **BKST********¦**556****¦**557****¦****2*****¦                                BUG9827 BUG10563
101800200529      **DSPBK*******¦**558****¦**558****¦****1*****¦                                BUG9827 BUG10563
101900200529      **@TimeStamp**¦**559****¦**584****¦***26*****¦                                BUG9827 BUG10563
102000200529      **DDACTC******¦**585****¦**585****¦****1*****¦                                BUG9827 BUG10563
102100200529      **PLATAK******¦**586****¦**586****¦****1*****¦                                BUG9827 BUG10563
102200200529      **SDFSSPPD****¦**587****¦*1137****¦**551*****¦                                BUG9827 BUG10563
102300200529      **SDFSSRPD****¦*1138****¦*1688****¦**551*****¦                                BUG9827 BUG10563
102400200529      **SDESSPPD****¦*1689****¦*2282****¦**594*****¦                                BUG9827 BUG10563
102500200529      **SDESSRPD****¦*2283****¦*2374****¦***92*****¦                                BUG9827 BUG10563
102600200529      **MMLDRXPD****¦*2375****¦*2434****¦***60*****¦                                BUG9827 BUG10563
102700200529      **MMLDEXPD****¦*2435****¦*2484****¦***50*****¦                                BUG9827 BUG10563
102800200529      **PFormula****¦**466****¦**473****¦****8*****¦                                 BUG10563 CSF011
102900200529      **SREMK*******¦**484****¦**508****¦***35*****¦                                 BUG10563 CSF011
103000200529      **DDSTS*******¦**519****¦**532****¦***24*****¦                                 BUG10563 CSF011
103100200529      **DDCST*******¦**543****¦**542****¦***10*****¦                                 BUG10563 CSF011
103200200529      **CPST********¦**553****¦**544****¦****2*****¦                                 BUG10563 CSF011
103300200529      **DSPCP*******¦**555****¦**545****¦****1*****¦                                 BUG10563 CSF011
103400200529      **BKST********¦**556****¦**547****¦****2*****¦                                 BUG10563 CSF011
103500200529      **DSPBK*******¦**558****¦**548****¦****1*****¦                                 BUG10563 CSF011
103600200529      **@TimeStamp**¦**559****¦**574****¦***26*****¦                                 BUG10563 CSF011
103700200529      **DDACTC******¦**585****¦**575****¦****1*****¦                                 BUG10563 CSF011
103800200529      **PLATAK******¦**586****¦**576****¦****1*****¦                                 BUG10563 CSF011
103900200529      **SDFSSPPD****¦**587****¦*1127****¦**551*****¦                                 BUG10563 CSF011
104000200529      **SDFSSRPD****¦*1138****¦*1678****¦**551*****¦                                 BUG10563 CSF011
104100200529      **SDESSPPD****¦*1689****¦*2287****¦**609*****¦                                 BUG10563 CSF011
104200200529      **SDESSRPD****¦*2283****¦*2394****¦**107*****¦                                 BUG10563 CSF011
104300200529      **WDUMMY******¦*2395****¦*2484****¦***90*****¦                                 BUG10563 CSF011
104400200529      **FIDTScnRstN*¦*2485****¦*2724****¦**240*****¦                                  BUG9827 CSF011
104500200529      **Filler******¦*2725****¦*5247****¦*2523*****¦                                  BUG9827 CSF011
104600200529      **FIDTScnRpt**¦*5248****¦*6000****¦**********¦                                  BUG9827 CSF011
104700200529      ***End*of*buffer*(6000)*start*of*Buffer2*(3999)                                 BUG9827 CSF011
104800200529      *...FIDTScnRpt¦****1****¦*3999****¦*4752*****¦                                  BUG9827 CSF011
104900200529      ***End*of*buffer2*(3999)*start*of*BufferEx2                                     BUG9827 CSF011
105000200529      **SfBuff20****¦****1****¦*4800****¦*4800*****¦                                  BUG9827 CSF011
105100200529      **SfBuff21****¦*4801****¦*9600****¦*4800*****¦                                  BUG9827 CSF011
105200200529      **MMLDRXPD****¦*9601****¦*9640****¦***40*****¦                                 BUG10563 CSF011
105300200529      **MMLDEXPD****¦*9641    ¦ 9690    ¦   50     ¦                                          248297
105400200529      **MMLDEXPD****¦*9641****¦*9730****¦***90*****¦                                   248297 CSF011
105500200529                                                                                              CDL096
105600200529      **MMLDNIPD****¦****1****¦**666****¦**666*****¦                                  CSF011A CDL096
105700200529      **MMLDIFPD****¦**667****¦**716****¦***50*****¦                                  CSF011A CDL096
105800200529      **RFormula****¦**717****¦**724****¦****8*****¦                                  CSF011A CDL096
105900200529      **PFormula****¦**725****¦**732****¦****8*****¦                                  CSF011A CDL096
106000200529      **SREMK*******¦**733****¦**767****¦***35*****¦                                  CSF011A CDL096
106100200529      **DDSTS*******¦**768****¦**791****¦***24*****¦                                  CSF011A CDL096
106200200529      **DDCSTS******¦**792****¦**801****¦***10*****¦                                  CSF011A CDL096
106300200529      **CPST********¦**802****¦**803****¦****2*****¦                                  CSF011A CDL096
106400200529      **DSPCP*******¦**804****¦**804****¦****1*****¦                                  CSF011A CDL096
106500200529      **BKST********¦**805****¦**806****¦****2*****¦                                  CSF011A CDL096
106600200529      **DSPBK*******¦**807****¦**807****¦****1*****¦                                  CSF011A CDL096
106700200529      **@TimeStamp**¦**808****¦**833****¦***26*****¦                                  CSF011A CDL096
106800200529      **DDACTC******¦**834****¦**834****¦****1*****¦                                  CSF011A CDL096
106900200529      **PLATAK******¦**835****¦**835****¦****1*****¦                                  CSF011A CDL096
107000200529      **DDFOIDPD****¦**836****¦*1855****¦***20*****¦                                  CSF011A CDL096
107100200529      **SDFSSRPD****¦*1856****¦*2270****¦*1415*****¦                                  CSF011A CDL096
107200200529      **SDFSSPPD****¦*2271****¦*3685****¦*1415*****¦                                  CSF011A CDL096
107300200529      **SDESSRPD****¦*3686****¦*4020****¦**335*****¦                                  CSF011A CDL096
107400200529      **SDESSPPD****¦*4021****¦*5065****¦*1045*****¦                                  CSF011A CDL096
107500200529      **WDUMMYPD****¦*5066****¦*5155****¦***90*****¦                                  CSF011A CDL096
107600200529      **FIDTScnRstN*¦*5156****¦*5395****¦**240*****¦                                  CSF011A CDL096
107700200529      **Filler******¦*5396****¦*6000****¦**********¦                                  CSF011A CDL096
107800200529                                                                                      CDL096  CGL165
107900200529      **MMLDNIPD****¦*   1    ¦  700    ¦  700     ¦                                  CDL096  CGL165
108000200529      **MMLDIFPD****¦* 701    ¦  750    ¦   50     ¦                                  CDL096  CGL165
108100200529      **RFormula****¦* 751    ¦  758    ¦    8     ¦                                  CDL096  CGL165
108200200529      **PFormula****¦* 759    ¦  766    ¦    8     ¦                                  CDL096  CGL165
108300200529      **SREMK*******¦* 767    ¦  801    ¦   35     ¦                                  CDL096  CGL165
108400200529      **DDSTS*******¦* 802    ¦  825    ¦   24     ¦                                  CDL096  CGL165
108500200529      **DDCSTS******¦* 826    ¦  835    ¦   10     ¦                                  CDL096  CGL165
108600200529      **CPST********¦* 836    ¦  837    ¦    2     ¦                                  CDL096  CGL165
108700200529      **DSPCP*******¦* 838    ¦  838    ¦    1     ¦                                  CDL096  CGL165
108800200529      **BKST********¦* 839    ¦  840    ¦    2     ¦                                  CDL096  CGL165
108900200529      **DSPBK*******¦* 841    ¦  841    ¦    1     ¦                                  CDL096  CGL165
109000200529      **@TimeStamp**¦* 842    ¦  867    ¦   26     ¦                                  CDL096  CGL165
109100200529      **DDACTC******¦* 868    ¦  868    ¦    1     ¦                                  CDL096  CGL165
109200200529      **PLATAK******¦* 869    ¦  869    ¦    1     ¦                                  CDL096  CGL165
109300200529      **DDFOIDPD****¦* 870    ¦  889    ¦   20     ¦                                  CDL096  CGL165
109400200529      **SDFSSRPD****¦* 890    ¦ 2304    ¦ 1415     ¦                                  CDL096  CGL165
109500200529      **SDFSSPPD****¦*2305    ¦ 3719    ¦ 1415     ¦                                  CDL096  CGL165
109600200529      **SDESSRPD****¦*3720    ¦ 4054    ¦  335     ¦                                  CDL096  CGL165
109700200529      **SDESSPPD****¦*4055    ¦ 5099    ¦ 1045     ¦                                  CDL096  CGL165
109800200529      **WDUMMY******¦*5100    ¦ 5189    ¦   90     ¦                                  CDL096  CGL165
109900200529      **FIDTScnRstN*¦*5190    ¦ 5429    ¦  240     ¦                                  CDL096  CGL165
110000200529      **Filler******¦ 5430    ¦ 6000    ¦          ¦                                  CDL096  CGL165
110100200529                                                                                              CGL165
110200200529      * MMLDNIPD    ¦    1    ¦  704    ¦  700     ¦                                          CGL165
110300200529      * MMLDIFPD    ¦  705    ¦  754    ¦   50     ¦                                          CGL165
110400200529      * RFormula    ¦  755    ¦  762    ¦    8     ¦                                          CGL165
110500200529      * PFormula    ¦  763    ¦  770    ¦    8     ¦                                          CGL165
110600200529      * SREMK       ¦  771    ¦  805    ¦   35     ¦                                          CGL165
110700200529      * DDSTS       ¦  806    ¦  829    ¦   24     ¦                                          CGL165
110800200529      * DDCST       ¦  830    ¦  839    ¦   10     ¦                                          CGL165
110900200529      * CPST        ¦  840    ¦  841    ¦    2     ¦                                          CGL165
111000200529      * DSPCP       ¦  842    ¦  842    ¦    1     ¦                                          CGL165
111100200529      * BKST        ¦  843    ¦  844    ¦    2     ¦                                          CGL165
111200200529      * DSPBK       ¦  845    ¦  845    ¦    1     ¦                                          CGL165
111300200529      * @TimeStamp  ¦  846    ¦  871    ¦   26     ¦                                          CGL165
111400200529      * DDACTC      ¦  872    ¦  872    ¦    1     ¦                                          CGL165
111500200529      * PLATAK      ¦  873    ¦  873    ¦    1     ¦                                          CGL165
111600200529      * DDFOID      ¦  874    ¦  893    ¦   20     ¦                                          CGL165
111700200529      * SDFSSRPD    ¦  894    ¦ 2308    ¦ 1415     ¦                                          CGL165
111800200529      * SDFSSPPD    ¦ 2309    ¦ 3723    ¦ 1415     ¦                                          CGL165
111900200529      * SDESSRPD    ¦ 3724    ¦ 4058    ¦  335     ¦                                          CGL165
112000200529      * SDESSPPD    ¦ 4059    ¦ 5103    ¦ 1045     ¦                                          CGL165
112100200529      * WDUMMY      ¦ 5104    ¦ 5193    ¦   90     ¦                                          CGL165
112200200529      * FIDTScnRstN ¦ 5194    ¦ 5433    ¦  240     ¦                                          CGL165
112300200529      * Filler      ¦ 5434    ¦ 6000    ¦          ¦                                          CGL165
112400200529      ** End of buffer (6000) start of Buffer2 (3999)                                         CSF011
112500200529      ****Filler****¦****1****¦*1467****¦*2072*****¦                                   CSF011 CDL096
112600200529      ****Filler****¦    1    ¦ 1467    ¦ 2038     ¦                                   CDL096 CGL165
112700200529      *...Filler    ¦    1    ¦ 1467    ¦ 2034     ¦                                          CGL165
112800200529      * TranQExt    ¦ 1468    ¦ 1562    ¦   95     ¦                                          CSF011
112900200529      * FIDTScnRpt  ¦ 1563    ¦ 3999    ¦          ¦                                          CSF011
113000200529      ** End of buffer2 (3999) start of BufferEx2                                             CSF011
113100200529      *...FIDTScnRpt¦    1    ¦ 2315    ¦ 4752     ¦                                          CSF011
113200200529      * SfBuff20    ¦ 2316    ¦ 7115    ¦ 4800     ¦                                          CSF011
113300200529      * SfBuff21    ¦ 7116    ¦ 9999    ¦          ¦                                          CSF011
113400200529      ** End of BufferEx2(9999) start of BufferEx3                                            CSF011
113500200529      *...SfBuff21  ¦    1    ¦ 1916    ¦ 4800     ¦                                          CSF011
113600200529      * MMLDRXPD    ¦ 1917    ¦ 1956    ¦   40     ¦                                          CSF011
113700200529      * MMLDEXPD    ¦ 1957    ¦ 2006    ¦   50     ¦                                          CSF011
113800200529                                                                                             BUG9827
113900200529     C                   Eval      APFOTranID = DDFOID                                      MD049048
114000200529      * Extract the CDL006 fields from buffer and buffer2                                    BUG9827
114100200529     C                   If        CDL006 = 'Y'                                              BUG9827
114200200529     C**********         Eval      FIDTScnRstN = %SUBST(Buffer:2484:240)              BUG9827 CSF011
114300200529     C**********         Eval      FIDTScnRpt = %SUBST(Buffer:5248) + Buffer2         BUG9827 CSF011
114400200529     C**********         EVAL      FIDTScnRstN = %SUBST(Buffer:5156:240)               CSF011 CDL096
114500200529     C**********         EVAL      FIDTScnRstN = %SUBST(Buffer:5190:240)               CDL096 CGL165
114600200529     C                   EVAL      FIDTScnRstN = %SUBST(Buffer:5194:240)                      CGL165
114700200529     C**********         EVAL      FIDTScnRpt = %SUBST(Buffer2:1563) +               CSF011 MD042711
114800200529     C**********         EVAL      FIDTScnRpt = %SUBST(Buffer2:1777) +             MD042711 MD044873
114900200529     C**********         EVAL      FIDTScnRpt = %SUBST(Buffer2:1563) +             MD044873 MD054028
115000200529     C                   EVAL      FIDTScnRpt = %SUBST(Buffer2:1783) +                      MD054028
115100200529     C**********                                %SUBST(BufferEx2:1:2315)             CSF011 MD054028
115200200529     C                                          BufferEx2                                   MD054028
115300200529     C                   EndIf                                                               BUG9827
115400200529     C                   IF        CER050 = 'Y'                                             MD054028
115500200529     C                   EVAL      DDAPRC = %SUBST(Buffer2:1774)                            MD054028
115600200529     C                   ENDIF                                                              MD054028
115700200529     C                   IF        CDL033 = 'Y'                                               CDL033
115800200529     C**********         EVAL      RFormula = %SUBST(Buffer:454:8)                    CDL033 BUG9827
115900200529     C**********         EVAL      PFormula = %SUBST(Buffer:462:8)                    CDL033 BUG9827
116000200529     C**********         EVAL      RFormula = %SUBST(Buffer:458:8)                    BUG9827 CSF011
116100200529     C**********         EVAL      PFormula = %SUBST(Buffer:466:8)                    BUG9827 CSF011
116200200529     C**********         EVAL      RFormula = %SUBST(Buffer:717:8)                    CSF011A CDL096
116300200529     C**********         EVAL      PFormula = %SUBST(Buffer:725:8)                    CSF011A CDL096
116400200529     C**********         EVAL      RFormula = %SUBST(Buffer:751:8)                    CDL096  CGL165
116500200529     C**********         EVAL      PFormula = %SUBST(Buffer:759:8)                    CDL096  CGL165
116600200529     C                   EVAL      RFormula = %SUBST(Buffer:755:8)                            CGL165
116700200529     C                   EVAL      PFormula = %SUBST(Buffer:763:8)                            CGL165
116800200529     C                   MOVEA     SfBuff20      RatDATEA                                     CDL033
116900200529     C                   MOVEA     SfBuff21      PayDATEA                                     CDL033
117000200529     C                   DO        600           N                                            CDL033
117100200529     C                   EVAL      S = (N - 1) * 6 + 1                                        CDL033
117200200529     C                   IF        RatDATEA(N) = *BLANK                                       CDL033
117300200529     C                   LEAVE                                                                CDL033
117400200529     C                   ENDIF                                                                CDL033
117500200529     C                   EVAL      %Subst(Rindates:S:6) =                                     CDL033
117600200529     C                             RatDate(N)                                                 CDL033
117700200529     C                   EVAL      %Subst(RPConfHol:N:1) =                                    CDL033
117800200529     C                             RatIndtr(N)                                                CDL033
117900200529     C                   EVAL      %Subst(RProcInd:N:1) =                                     CDL033
118000200529     C                             RatProc(N)                                                 CDL033
118100200529     C                   ENDDO                                                                CDL033
118200200529      *                                                                                       CDL033
118300200529     C                   DO        600           N                                            CDL033
118400200529     C                   EVAL      S = (N - 1) * 6 + 1                                        CDL033
118500200529     C                   IF        PayDATEA(N) = *BLANK                                       CDL033
118600200529     C                   LEAVE                                                                CDL033
118700200529     C                   ENDIF                                                                CDL033
118800200529     C                   EVAL      %Subst(Pindates:S:6) =                                     CDL033
118900200529     C                             PayDate(N)                                                 CDL033
119000200529     C                   EVAL      %Subst(PPConfHol:N:1) =                                    CDL033
119100200529     C                             PayIndtr(N)                                                CDL033
119200200529     C                   EVAL      %Subst(PProcInd:N:1) =                                     CDL033
119300200529     C                             PayProc(N)                                                 CDL033
119400200529     C                   ENDDO                                                                CDL033
119500200529      *                                                                                       CDL033
119600200529     C                   ENDIF                                                                CDL033
119700200529     C                   MOVEL     Infdata500    Infdata
119800200529     C/COPY WNCPYSRC,MMLDNIXC01
119900200529     C                   MOVEL     Extdata500    Extdata
120000200529     C                   MOVEL     RegData500    RegData                                      CER001
120100200529     C**********         EVAL      APFOTranID = DDFOID                             259924A AR971184A
120200200529     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
120300200529     C                   EVAL      DDFOID = APFOTranID                                     AR971184A
120400200529     C                   ENDIF                                                             AR971184A
120500200529                                                                                              CAP087
120600200529     C                   Eval      RepoFlag = 'N'                                             CAP087
120700200529     C                   If        DDDRID <> *Blanks                                          CAP087
120800200529     C                             AND CSE006 = 'Y'                                           CAP087
120900200529     C                   Eval      RepoFlag = 'Y'                                             CAP087
121000200529     C                   Endif                                                                CAP087
121100200529                                                                                             BUG3684
121200200529      * Reset the Action code to B or U if this is caled from the Block or Unblock           BUG3684
121300200529      * buttons on the input form or pre-confirmation screen.                                BUG3684
121400200529     C     DDACTC        IFEQ      'B'                                                       BUG3684
121500200529     C                   MOVE      'B'           DDACTN                                      BUG3684
121600200529     C                   ENDIF                                                               BUG3684
121700200529                                                                                             BUG3684
121800200529     C     DDACTC        IFEQ      'U'                                                       BUG3684
121900200529     C                   MOVE      'U'           DDACTN                                      BUG3684
122000200529     C                   ENDIF                                                               BUG3684
122100200529
122200200529      ** Generate a timestamp for this transaction
122300200529     C                   CALLB     'ZAGENTMSTM'
122400200529     C                   PARM                    TimeStamp
122500200529
122600200529      * Reset variables gradually updated
122700200529
122800200529     C                   EXSR      RESETCYCLE
122900200529
123000200529      *  Validate Action Code
123100200529
123200200529     C**********         IF        DDACTN <> 'X'                                   BUG6164 MD037869A
123300200529     C                   EXSR      ValidateAc
123400200529     C**********         END                                                       BUG6164 MD037869A
123500200529
123600200529      *  If error in validation of action code, fail this input
123700200529      *
123800200529     C     Idx           IFNE      0
123900200529     C                   GOTO      INVALID
124000200529     C                   END
124100200529                                                                                             BUG6512
124200200529      *                                                                                      BUG6512
124300200529      * Retrieve TRAM details                                                                BUG6512
124400200529      *                                                                                      BUG6512
124500200529     C                   EXSR      ZACFFEERTV                                                BUG6512
124600200529
124700200529      *  Processing depends upon Action Code
124800200529
124900200529     C                   SELECT
125000200529
125100200529     C                   WHEN      DDACTN = 'I'
125200200529      *  Processing for Inserts
125300200529     C                   EXSR      DftSettmts
125400200529     C                   EXSR      ValidateTr
125500200529     C                   EXSR      ValidateSt
125600200529     C                   IF        CDL033 = 'Y'                                               CDL033
125700200529     C                   IF        Idx = 0                                                    CDL033
125800200529     C                   EXSR      ValidateRC                                                 CDL033
125900200529     C                   IF        Idx = 0                                                    CDL033
126000200529     C                   EXSR      ValidatePC                                                 CDL033
126100200529     C                   ENDIF                                                                CDL033
126200200529     C                   IF        DDSTRT <> *BLANKS                                        BUG12589
126300200529     C                   EVAL      @@STRT = IKINTR                                          BUG12589
126400200529     C                   ENDIF                                                              BUG12589
126500200529     C                   ENDIF                                                                CDL033
126600200529     C                   ENDIF                                                                CDL033
126700200529      *                                                                                     BUG12967
126800200529      *  Do not validate if error occurs in previous validation                             BUG12967
126900200529     C                   IF        Idx = 0                                                  BUG12967
127000200529     C                   EXSR      ValidateLP                                                BUG3992
127100200529     C                   Endif                                                              BUG12967
127200200529                                                                                            BUG12589
127300200529      ** For Insert:                                                                        BUG12589
127400200529      ** If CDL033 is on and short term rate was specified, ensure                          BUG12589
127500200529      ** this becomes the prevailing rate as IKINTR value is reset in                       BUG12589
127600200529      ** SR/ValidateLP when calling ZAVSPRRATE program                                      BUG12589
127700200529     C                   IF        CDL033 = 'Y' and DDSTRT <> *BLANKS                       BUG12589
127800200529     C                   EVAL      IKINTR = @@STRT                                          BUG12589
127900200529     C                   ENDIF                                                              BUG12589
128000200529                                                                                             BUG9827
128100200529      * If dealtype is a fiduciary placing then do SR/ValidateFD                             BUG9827
128200200529     C                   IF        CDL006 = 'Y' and Idx = 0                                  BUG9827
128300200529     C                   IF        DDTYPE = 'FL' or DDTYPE = 'DP' or                         BUG9827
128400200529     C                             DDTYPE = 'LP'                                             BUG9827
128500200529     C                   EXSR      ValidateFD                                                BUG9827
128600200529     C                   EndIf                                                               BUG9827
128700200529     C                   EndIf                                                               BUG9827
128800200529
128900200529     C                   WHEN      DDACTN = 'A'
129000200529      *  Processing for Amends
129100200529     C                   IF        CDL033 = 'Y'                                               CDL033
129200200529     C                   IF        Idx = 0                                                    CDL033
129300200529     C                   EXSR      ValidateRC                                                 CDL033
129400200529     C                   IF        Idx = 0                                                    CDL033
129500200529     C                   EXSR      ValidatePC                                                 CDL033
129600200529     C                   ENDIF                                                                CDL033
129700200529     C                   IF        DDSTRT <> *BLANKS                                        BUG12589
129800200529     C                   EVAL      @@STRT = IKINTR                                          BUG12589
129900200529     C                   ENDIF                                                              BUG12589
130000200529     C                   ENDIF                                                                CDL033
130100200529     C                   ENDIF                                                                CDL033
130200200529     C     GHSUBS        ifne      *blank
130300200529     C     GHSUBS        scan      TranIn                                 99
130400200529     C     *in99         ifeq      *on
130500200529     C                   EXSR      TDtDtaSubs
130600200529     C                   endif
130700200529     C                   endif
130800200529     C                   EXSR      SetupAmend
130900200529     C                   EXSR      ValidateTr
131000200529     C                   EXSR      ValidateSt
131100200529     C                   EXSR      ValidateLP                                                BUG3992
131200200529                                                                                            BUG12589
131300200529      ** For Amend:                                                                         BUG12589
131400200529      ** If CDL033 is on and short term rate was specified, ensure                          BUG12589
131500200529      ** this becomes the prevailing rate as IKINTR value is reset in                       BUG12589
131600200529      ** SR/ValidateLP when calling ZAVSPRRATE program                                      BUG12589
131700200529     C                   IF        CDL033 = 'Y' and DDSTRT <> *BLANKS                       BUG12589
131800200529     C                   EVAL      IKINTR = @@STRT                                          BUG12589
131900200529     C                   ENDIF                                                              BUG12589
132000200529     C                   EXSR      ValdateAmd
132100200529                                                                                             BUG4482
132200200529     C                   WHEN      DDACTN = 'X'                                              BUG4482
132300200529      *  Processing for Authorises                                                           BUG4482
132400200529     C                   EVAL      IKINTR = HKINTR                                         MD037869A
132500200529     C                   EVAL      IKSPRD = HKSPRD                                         MD037869A
132600200529     C                   EXSR      ValidateTr                                                BUG4482
132700200529     C**********         EXSR      ValidateAc                                      BUG6164 MD037869A
132800200529     C                   EXSR      ValidateSt                                                BUG4482
132900200529     C                   EXSR      ValidateLP                                                BUG3992
133000200529     C                   IF        CDL033 = 'Y'                                               CDL033
133100200529     C                   IF        Idx = 0                                                    CDL033
133200200529     C                   EXSR      ValidateRC                                                 CDL033
133300200529     C                   IF        Idx = 0                                                    CDL033
133400200529     C                   EXSR      ValidatePC                                                 CDL033
133500200529     C                   ENDIF                                                                CDL033
133600200529     C                   ENDIF                                                                CDL033
133700200529     C                   ENDIF                                                                CDL033
133800200529                                                                                             BUG9827
133900200529      * If dealtype is a fiduciary placing then do SR/ValidateFD                             BUG9827
134000200529     C                   IF        CDL006 = 'Y' and Idx = 0                                  BUG9827
134100200529     C                   IF        DDTYPE = 'FL' or DDTYPE = 'DP' or                         BUG9827
134200200529     C                             DDTYPE = 'LP'                                             BUG9827
134300200529     C                   EXSR      ValidateFD                                                BUG9827
134400200529     C                   EndIf                                                               BUG9827
134500200529     C                   EndIf                                                               BUG9827
134600200529                                                                                             BUG9827
134700200529     C                   WHEN      DDACTN = 'D'                                              BUG9827
134800200529      * If dealtype is a fiduciary placing then do SR/ValidateFD                             BUG9827
134900200529     C                   IF        CDL006 = 'Y' and Idx = 0                                  BUG9827
135000200529     C                   IF        DDTYPE = 'FL' or DDTYPE = 'DP' or                         BUG9827
135100200529     C                             DDTYPE = 'LP'                                             BUG9827
135200200529     C                   EXSR      ValidateFD                                                BUG9827
135300200529     C                   EndIf                                                               BUG9827
135400200529     C                   EndIf                                                               BUG9827
135500200529
135600200529     C                   ENDSL
135700200529      *                                                                                       CER043
135800200529      ***Population*of*Customer*Details                                                CER043 CSF011
135900200529     C**********         IF        CER043 = 'Y'                                        CER043 CSF011
136000200529     C**********         EXSR      SrPopCust                                           CER043 CSF011
136100200529     C**********         ENDIF                                                         CER043 CSF011
136200200529      *
136300200529     C     INVALID       TAG
136400200529
136500200529      ** Populate Customer Name Inputs                                                        CSF011
136600200529                                                                                              CSF011
136700200529     C                   EXSR      SrCustActN                                                 CSF011
136800200529                                                                                              CSF011
136900200529      *  Write to database
137000200529
137100200529     C     UpdateYN      IFEQ      'Y'
137200200529     C     Idx           ANDEQ     0
137300200529     C                   EXSR      WriteToDB
137400200529     C                   IF        CDL033 = 'Y'                                              CDL033
137500200529     C                   EXSR      SupVALIRC                                                 CDL033
137600200529     C                   ENDIF                                                               CDL033
137700200529     C                   ENDIF
137800200529
137900200529     C                   SETON                                        LR
138000200529     C                   IF        CDL033 = 'Y'                                              CDL033
138100200529     C                   MOVEA     RatDATEA      RatDateDS                                   CDL033
138200200529     C                   MOVEA     PayDATEA      PayDateDS                                   CDL033
138300200529     C                   ENDIF                                                               CDL033
138400200529     C                   IF        CER050 = 'Y'                                             MD054028
138500200529     C     DDAPRC        IFEQ      *BLANKS                                                  MD054028
138600200529     C                   MOVE      'N'           DDAPRC                                     MD054028
138700200529     C                   ENDIF                                                              MD054028
138800200529     C                   ENDIF                                                              MD054028
138900200529                                                                                              CER050
139000200529     C     DDAPRC        Ifeq      'N'                                                        CER050
139100200529     C     DDAPRR        andne     *Blanks                                                    CER050
139200200529     C                   Move      *Blanks       DDAPRR                                       CER050
139300200529     C                   Endif                                                                CER050
139400200529     C     DDAPRC        Ifeq      'Y'                                                        CER050
139500200529     C     DDAPRR        andeq     *Blanks                                                    CER050
139600200529     C     @DDAPRR       andne     *Blanks                                                    CER050
139700200529     C                   Move      @DDAPRR       DDAPRR                                       CER050
139800200529     C                   Endif                                                                CER050
139900200529                                                                                              CER050
140000200529      ** If action is for Update, get the correct record information                         BUG4808
140100200529      ** from file                                                                           BUG4808
140200200529     C                   IF        UpdateYN = 'Y'                                            BUG4808
140300200529     C                             AND Idx = 0                                               BUG8119
140400200529     C                   MOVE      IKDN38        DDDLNO_In                                   BUG4808
140500200529     C                   IF        CER050 = 'Y'                                             MD054028
140600200529     C                   MOVE      DDAPRC        HKAPRC                                     MD054028
140700200529     C                   MOVE      DDAPRC        IKAPRC                                     MD054028
140800200529     C                   ENDIF                                                              MD054028
140900200529     C                   CALL      'MMLDNIR'                                                 BUG4808
141000200529     C                   PARM                    @AuthComp         1                         BUG4808
141100200529     C                   PARM                    @FwdBck           1                         BUG4808
141200200529     C                   PARM                    DDDLNO_In         6                         BUG4808
141300200529     C                   PARM                    Buffer                                      BUG4808
141400200529     C                   PARM                    Buffer2                                      CDL033
141500200529     C                   PARM                    BufferEx2                                    CDL033
141600200529     C                   PARM                    BufferEx3                                    CSF011
141700200529     C                   PARM                    @FldNameArr                                 BUG4808
141800200529     C                   PARM                    @MsgIDArr                                   BUG4808
141900200529     C                   PARM                    @MsgDtaArr                                  BUG4808
142000200529     C                   PARM                    @MsgFArray                                  BUG4808
142100200529     C                   PARM                    @APIRetC          1                         BUG4808
142200200529     C**********         PARM                    ACTRJ                             AR701789 MD042711
142300200529     C                   PARM                    ACTRJ                                      MD044873
142400200529     C                   MOVEL     DDACTN        Buffer                                      BUG4808
142500200529     C                   MOVE      IKDN38        @ACDLNO                                      CDL033
142600200529     C                   MOVEL     DDACTN        @ACDLNO                                      CDL033
142700200529     C                   MOVEL     @ACDLNO       Buffer                                       CDL033
142800200529     C                   ELSE                                                                BUG4808
142900200529     C*******************EVAL                    Buffer = TranIN                              TCA002
143000200529     C                   EVAL                    Buffer = TranIN + InfData                    TCA002
143100200529     C                                           + RFormula                                   CDL033
143200200529     C                                           + PFormula                                   CDL033
143300200529     C                                           + SREMK                                      CMM105
143400200529     C                                           + DDSTS + DDCSTS                            BUG3986
143500200529     C                                           + CPST     + DSPCP                          BUG6512
143600200529     C                                           + BKST     + DSPBK                          BUG6512
143700200529     C**********                                 + @TimeStamp                        BUG3986 BUG3684
143800200529     C**********                                 + @TimeStamp + DDACTC               BUG3684 BUG3792
143900200529     C                                           + @TimeStamp + DDACTC + PLATAK              BUG3792
144000200529     C**********                                 + ACTRJ                           AR701789 MD042711
144100200529     C                                           + ACTRJ                                    MD044873
144200200529     C                                           + DDFOID                                     239400
144300200529     C                                           + #FRECS + #FPAYS                            CDL018
144400200529     C                                           + InRecSttmt + InPaySttmt
144500200529     C**********                                 + ExtData                                    CER001
144600200529     C**********                                 + RegData + ExtData                 CER001 BUG10296
144700200529     C                                           + WDUMMY                                   BUG10563
144800200529     C                                           + FIDTScnRstN + Filler                      BUG9827
144900200529     C**********                                 + TranQExt                         CER049 AR819540A
145000200529     C**********                                 + TranInCust                          CER043 CSF011
145100200529     C**********                                 + TranQExt                         AR819540A CSF011
145200200529     C**********                                 + FIDTScnRpt                         BUG9827 CSF011
145300200529                                                                                              CDL033
145400200529     C**********         EVAL      Buffer2 = *BLANK                                   CDL033 BUG9827
145500200529     C**********         EVAL      Buffer2 = LDNIFil + RegData                      BUG10296 BUG9827
145600200529     C****               EVAL      Buffer2 = %SUBST(FIDTScnMft:3516)                         BUG9827
145700200529     C**********         EVAL      Buffer2 = %SUBST(FIDTScnRpt:754)                   BUG9827 CSF011
145800200529     C**********         EVAL      Buffer2 = %SUBST(Filler:606)                        CSF011 CDL096
145900200529     C**********         EVAL      Buffer2 = %SUBST(Filler:572)                        CDL096 CGL165
146000200529     C**********         EVAL      Buffer2 = %SUBST(Filler:568)                      CGL165 MD038485
146100200529     C**********         EVAL      Buffer2 = %SUBST(Filler:354)                    MD038485 MD054028
146200200529     C                   EVAL      Buffer2 = %SUBST(Filler:357)                             MD054028
146300200529     C                                       + TranQExt                                       CSF011
146400200529     C                                       + DDAPRC + DDAPRR                              MD054028
146500200529     C                                       + FIDTScnRpt                                     CSF011
146600200529     C**********         EVAL      BufferEx2 = RatDateDS + PayDateDS                 CDL033 BUG10943
146700200529     C**********                              + RegData                            BUG10563 BUG10943
146800200529     C******             EVAL      BufferEx2 = RegData + RatDateDS                 BUG10943 244784
146900200529     C******                                  + PayDateDS                          BUG10943 244784
147000200529     C**********         EVAL      BufferEx2 = RatDateDS + PayDateDS                   244784 CSF011
147100200529     C**********                              + RegData                                244784 CSF011
147200200529     C**********                              + ExtData                                248297 CSF011
147300200529     C                   EVAL      BufferEx2 = %SUBST(FIDTScnRpt:2438)                        CSF011
147400200529     C                                        + RatDateDS + PayDateDS                         CSF011
147500200529     C                   EVAL      BufferEx3 = %SUBST(PayDateDS:2885)                         CSF011
147600200529     C                                        + RegData + ExtData                             CSF011
147700200529     C                   ENDIF                                                               BUG4808
147800200529
147900200529     C                   RETURN
148000200529
148100200529      *****************************************************************
148200200529      /EJECT                                                                                  CSF011
148300200529      *****************************************************************                       CSF011
148400200529      *                                                               *                       CSF011
148500200529      * SrCustActN - Get the Customer or Account Details              *                       CSF011
148600200529      *                                                               *                       CSF011
148700200529      *****************************************************************                       CSF011
148800200529     C     SrCustActN    BEGSR                                                                CSF011
148900200529                                                                                              CSF011
149000200529      ** Customer Number                                                                     CSF011A
149100200529                                                                                             CSF011A
149200200529     C                   IF        DDCUST <> *BLANKS                                         CSF011A
149300200529     C                   EVAL      PCNum = DDCUST                                            CSF011A
149400200529     C                   EXSR      SrRtvCust                                                 CSF011A
149500200529     C                   IF        PRtcd = *BLANKS                                           CSF011A
149600200529     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
149700200529     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
149800200529     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
149900200529     C                   ENDIF                                                               CSF011A
150000200529     C                   ENDIF                                                               CSF011A
150100200529                                                                                             CSF011A
150200200529      ** Interest Settlement Account                                                         CSF011A
150300200529                                                                                             CSF011A
150400200529     C                   IF        DDINSA <> *BLANKS                                         CSF011A
150500200529                                                                                             CSF011A
150600200529     C                   MOVEL     *BLANKS       A#OURA                                      CSF011A
150700200529     C                   MOVEL     DDINSA        A#OURA                                      CSF011A
150800200529     C                   IF        DDISCY <> *BLANKS                                         CSF011A
150900200529     C                   MOVE      DDISCY        @CYCD                                       CSF011A
151000200529     C                   ELSE                                                                CSF011A
151100200529     C                   MOVE      DDCCY         @CYCD                                       CSF011A
151200200529     C                   ENDIF                                                               CSF011A
151300200529     C                   EXSR      CNIRTV                                                    CSF011A
151400200529     C                   IF        PRtcd = *BLANKS                                           CSF011A
151500200529     C                   EVAL      DDIASN = BBCSSN                                           CSF011A
151600200529     C                   EVAL      DDIANM = BBCRNM                                           CSF011A
151700200529     C                   EVAL      DDIATN = BBCRTN                                           CSF011A
151800200529     C                   EVAL      DDIAAN = AC_ANAM                                          CSF011A
151900200529     C                   EVAL      DDIASW = BBCSID                                           CSF011A
152000200529     C                   ENDIF                                                               CSF011A
152100200529     C                   ENDIF                                                               CSF011A
152200200529                                                                                             CSF011A
152300200529      ** Interest Counterparty Nostro                                                        CSF011A
152400200529                                                                                             CSF011A
152500200529     C                   IF        DDINOS <> *BLANKS                                         CSF011A
152600200529     C                   EVAL      PCNUm = DDINOS                                            CSF011A
152700200529     C                   EXSR      SrRtvCust                                                 CSF011A
152800200529     C                   IF        PRtcd = *BLANKS                                           CSF011A
152900200529     C                   EVAL      DDINSN = BBCSSN                                           CSF011A
153000200529     C                   EVAL      DDINNM = BBCRNM                                           CSF011A
153100200529     C                   EVAL      DDINTN = BBCRTN                                           CSF011A
153200200529     C                   EVAL      DDINSW = BBCSID                                           CSF011A
153300200529     C                   ELSE                                                                CSF011A
153400200529     C                   EXSR      ACCNST                                                    CSF011A
153500200529     C                   IF        PRtcd = *BLANKS                                           CSF011A
153600200529     C                   EVAL      DDINSN = AWCSN1 + AWCSN2                                  CSF011A
153700200529     C                   EVAL      DDINNM = AWCPNM                                           CSF011A
153800200529     C                   EVAL      DDINTN = AWCNTN                                           CSF011A
153900200529     C                   EVAL      DDINSW = AWSWID                                           CSF011A
154000200529     C                   ENDIF                                                               CSF011A
154100200529     C                   ENDIF                                                               CSF011A
154200200529     C                   ENDIF                                                               CSF011A
154300200529                                                                                             CSF011A
154400200529      ** Current Holder of CD                                                                CSF011A
154500200529                                                                                             CSF011A
154600200529     C                   IF        DDCDCH <> *BLANKS                                         CSF011A
154700200529     C                   EVAL      PCNum = DDCDCH                                            CSF011A
154800200529     C                   EXSR      SrRtvCust                                                 CSF011A
154900200529     C                   IF        PRtcd = *BLANKS                                           CSF011A
155000200529     C                   EVAL      DDCDSN = BBCSSN                                           CSF011A
155100200529     C                   EVAL      DDCDNM = BBCRNM                                           CSF011A
155200200529     C                   EVAL      DDCDTN = BBCRTN                                           CSF011A
155300200529     C                   ENDIF                                                               CSF011A
155400200529     C                   ENDIF                                                               CSF011A
155500200529                                                                                              CSF011
155600200529     C                   ENDSR                                                                CSF011
155700200529      *****************************************************************                       CSF011
155800200529      /EJECT                                                                                 CSF011A
155900200529      *****************************************************************                      CSF011A
156000200529      *                                                               *                      CSF011A
156100200529      * ACNOST - Access Nostro Details                                *                      CSF011A
156200200529      *                                                               *                      CSF011A
156300200529      *****************************************************************                      CSF011A
156400200529     C     ACNOST        BEGSR                                                               CSF011A
156500200529                                                                                             CSF011A
156600200529     C                   CALL      'AONOSTR0'                                                CSF011A
156700200529     C                   PARM      *BLANKS       PRtcd                                       CSF011A
156800200529     C                   PARM      '*KEY   '     POptn                                       CSF011A
156900200529     C                   PARM      *BLANKS       @CUST                                       CSF011A
157000200529     C                   PARM                    @CYCD                                       CSF011A
157100200529     C                   PARM      *BLANKS       @ACCD                                       CSF011A
157200200529     C                   PARM      *BLANKS       @ACSN                                       CSF011A
157300200529     C                   PARM                    @NOSN                                       CSF011A
157400200529     C                   PARM      *BLANKS       @BRCA                                       CSF011A
157500200529     C                   PARM      *BLANKS       @CSSN                                       CSF011A
157600200529     C                   PARM      *BLANKS       @PNOI                                       CSF011A
157700200529     C     SDNOST        PARM      SDNOST        DSSDY                                       CSF011A
157800200529                                                                                             CSF011A
157900200529     C                   ENDSR                                                               CSF011A
158000200529      *****************************************************************                      CSF011A
158100200529      /EJECT                                                                                 CSF011A
158200200529      *****************************************************************                      CSF011A
158300200529      *                                                               *                      CSF011A
158400200529      * ACACCT - Access Account Details                               *                      CSF011A
158500200529      *                                                               *                      CSF011A
158600200529      *****************************************************************                      CSF011A
158700200529     C     ACACCT        BEGSR                                                               CSF011A
158800200529                                                                                             CSF011A
158900200529     C                   CALL      'AOACCTV0'                                                CSF011A
159000200529     C                   PARM      *BLANKS       PRtcd                                       CSF011A
159100200529     C                   PARM                    @ACID                                       CSF011A
159200200529     C                   PARM                    @CYCD                                       CSF011A
159300200529     C                   PARM                    @ACCD                                       CSF011A
159400200529     C                   PARM                    @ACSN                                       CSF011A
159500200529     C                   PARM                    @BRCA                                       CSF011A
159600200529     C                   PARM                    @TYPE                                       CSF011A
159700200529     C                   PARM                    @NOSN                                       CSF011A
159800200529     C     ACCNT         PARM      ACCNT         DSSDY                                       CSF011A
159900200529     C                                                                                       CSF011A
160000200529                                                                                             CSF011A
160100200529     C                   ENDSR                                                               CSF011A
160200200529      *****************************************************************                      CSF011A
160300200529      /EJECT                                                                                 CSF011A
160400200529      *****************************************************************                      CSF011A
160500200529      *                                                               *                      CSF011A
160600200529      * ACCNST - Access Counterparty Nostro Details                   *                      CSF011A
160700200529      *                                                               *                      CSF011A
160800200529      *****************************************************************                      CSF011A
160900200529     C     ACCNST        BEGSR                                                               CSF011A
161000200529                                                                                             CSF011A
161100200529     C                   CALL      'AOCNSTR0'                                                CSF011A
161200200529     C                   PARM      *BLANKS       PRtcd                                       CSF011A
161300200529     C                   PARM      '*KEY   '     POptn                                       CSF011A
161400200529     C                   PARM                    PCNum                                       CSF011A
161500200529     C     SDCNST        PARM      SDCNST        DSSDY                                       CSF011A
161600200529                                                                                             CSF011A
161700200529     C                   ENDSR                                                               CSF011A
161800200529      *****************************************************************                      CSF011A
161900200529      /EJECT                                                                                 CSF011A
162000200529      *****************************************************************                      CSF011A
162100200529      *                                                               *                      CSF011A
162200200529      * CNIRTV - Retrive Customer and Account Details                 *                      CSF011A
162300200529      *                                                               *                      CSF011A
162400200529      *****************************************************************                      CSF011A
162500200529     C     CNIRTV        BEGSR                                                               CSF011A
162600200529                                                                                             CSF011A
162700200529     C                   SETOFF                                       515253                 CSF011A
162800200529     C                   SETOFF                                       54                     CSF011A
162900200529                                                                                             CSF011A
163000200529     C                   CLEAR                   ACCNT                                       CSF011A
163100200529     C                   CLEAR                   SDCUST                                      CSF011A
163200200529                                                                                             CSF011A
163300200529     C                   TESTN                   A#NOST               51        Nostro       CSF011A
163400200529     C                   TESTN                   A#ACOD               52        Ledger       CSF011A
163500200529     C   52              TESTN                   A#ACSQ               52        Ledger       CSF011A
163600200529     C                   TESTN                   A#RENO               53        Retail       CSF011A
163700200529                                                                                             CSF011A
163800200529     C                   SELECT                                                              CSF011A
163900200529     C                   WHEN      A#CNUM <> *BLANKS AND A#ACAS = *BLANKS                    CSF011A
164000200529     C                             AND %LEN(A#CNUM) = 6 AND *IN51 = *OFF                     CSF011A
164100200529     C                   EVAL      *IN54 = *ON                                               CSF011A
164200200529     C                   EVAL      PCNum = A#CNUM                                            CSF011A
164300200529                                                                                             CSF011A
164400200529     C                   WHEN      *IN51 = *ON AND A#REST = *BLANKS                          CSF011A
164500200529     C                   MOVE      A#NOST        @NOSN                                       CSF011A
164600200529     C                   EXSR      ACNOST                                                    CSF011A
164700200529     C                   MOVEL     *BLANKS       @ACID                                       CSF011A
164800200529     C                   MOVEL     NO_A7CUST     @ACID                                       CSF011A
164900200529     C                   MOVE      NO_A7ACCD     @ACCD                                       CSF011A
165000200529     C                   MOVE      NO_A7ACSN     @ACSN                                       CSF011A
165100200529     C                   MOVE      NO_A7BRCD     @BRCA                                       CSF011A
165200200529     C                   IF        @RTCD <> *BLANKS                                          CSF011A
165300200529     C                   EVAL      *IN54 = *ON                                               CSF011A
165400200529     C                   ENDIF                                                               CSF011A
165500200529                                                                                             CSF011A
165600200529     C                   WHEN      *IN52 = *ON                                               CSF011A
165700200529     C                   MOVEL     *BLANKS       @ACID                                       CSF011A
165800200529     C                   MOVEL     A#CNUM        @ACID                                       CSF011A
165900200529     C                   MOVE      A#ACSQ        @ACSN                                       CSF011A
166000200529     C                   MOVE      A#ACOD        @ACCD                                       CSF011A
166100200529     C                   MOVE      A#BRCA        @BRCA                                       CSF011A
166200200529                                                                                             CSF011A
166300200529     C                   WHEN      *IN53 = *ON                                               CSF011A
166400200529     C                   MOVEL     A#RENO        @ACID                                       CSF011A
166500200529     C                   MOVE      *BLANKS       @CYCD                                       CSF011A
166600200529     C                   MOVE      *BLANKS       @ACSN                                       CSF011A
166700200529     C                   MOVE      *BLANKS       @ACCD                                       CSF011A
166800200529     C                   MOVE      *BLANKS       @BRCA                                       CSF011A
166900200529                                                                                             CSF011A
167000200529     C                   ENDSL                                                               CSF011A
167100200529                                                                                             CSF011A
167200200529     C  N54              EXSR      ACACCT                                                    CSF011A
167300200529     C                   IF        PRtcd = *BLANKS                                           CSF011A
167400200529     C                   EVAL      PCNum = AC_CNUM                                           CSF011A
167500200529     C                   EXSR      SrRtvCust                                                 CSF011A
167600200529     C                   ENDIF                                                               CSF011A
167700200529                                                                                             CSF011A
167800200529     C                   ENDSR                                                               CSF011A
167900200529      ******************************************************************                     CSF011A
168000200529      /EJECT
168100200529      *****************************************************************
168200200529      *                                                               *
168300200529      * *INZSR - Program Initialisation routine                       *
168400200529      *                                                               *
168500200529      *****************************************************************
168600200529
168700200529     C     *INZSR        BEGSR
168800200529
168900200529     C     *ENTRY        PLIST
169000200529      * Common header information (DS) from source system
169100200529     C                   PARM                    HeadIn
169200200529      * Transaction information in a single large field from source system
169300200529     C                   PARM                    Trans500
169400200529     C                   PARM                    InfData500
169500200529     C                   PARM                    TransQ500                                    CER049
169600200529     C**********         PARM                    Trans500C                             CER043 CSF011
169700200529      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
169800200529     C                   PARM                    #FPAYS                                       CDL018
169900200529     C                   PARM                    #FRECS                                       CDL018
170000200529     C                   PARM                    InPaySttmt
170100200529     C                   PARM                    InRecSttmt
170200200529     C                   PARM                    InFRASttmt
170300200529     C                   PARM                    RegData500                                   CER001
170400200529     C                   PARM                    ExtData500
170500200529     C                   PARM                    FldNameArr
170600200529     C                   PARM                    MsgIDArr
170700200529     C                   PARM                    MsgDtaArr
170800200529     C                   PARM                    WFldNamArr
170900200529     C                   PARM                    WMsgIDArr
171000200529     C                   PARM                    WMsgDtaArr
171100200529     C                   PARM                    MsgFArray
171200200529     C                   PARM                    UpdateYN          1
171300200529     C                   PARM                    Buffer         6000
171400200529     C                   PARM                    Buffer2                                      CDL033
171500200529     C                   PARM                    BufferEx2                                    CDL033
171600200529     C                   PARM                    BufferEx3                                    CSF011
171700200529     C                   PARM                    APIRetc           1
171800200529     C                   PARM                    @TimeStamp       26                         BUG3986
171900200529     C                   PARM                    DDACTC            1                         BUG3684
172000200529     C                   PARM                    PLATAK            1                         BUG3792
172100200529     C**********         PARM                    ACTRJ             1               AR701789 MD042711
172200200529     C                   PARM                    ACTRJ             1                        MD044873
172300200529     C                   PARM                    DDFOID           20                          239400
172400200529
172500200529      * Set up the name of the primary and secondary message files from
172600200529      * which the message handler will get the messages
172700200529     C                   EVAL      MsgFArray(1) = 'DRSMM'
172800200529     C                   EVAL      MsgFArray(2) = 'SDUSRMSG'                                  CRE073
172900200529
173000200529      *  Hook to enable non-core message files to be included
173100200529     C/COPY WNCPYSRC,MMLDNIM01
173200200529
173300200529      ** Access Bank details via access program
173400200529      *  (database error handling done in access program)
173500200529     C                   CALLB     'AOBANKR0'
173600200529     C                   PARM      '*DBERR '     @RTCD             7
173700200529     C                   PARM      '*FIRST '     @OPTN             7
173800200529     C     SDBANK        PARM      SDBANK        DSFDY
173900200529
174000200529      ** Access API ICD via access program
174100200529      *  (database error handling done in access program)
174200200529     C                   CALLB     'AOAPIR0'
174300200529     C                   PARM      '*DBERR '     @RTCD             7
174400200529     C                   PARM      '*FIRST '     @OPTN             7
174500200529     C     SDAPI         PARM      SDAPI         DSFDY
174600200529
174700200529      ** Access SAR details file to determine if
174800200529      ** Deposit Breakdown Penalty is installed
174900200529      *
175000200529     C                   MOVEL     'N'           CDL007            1
175100200529     C                   CALL      'AOSARDR0'
175200200529     C                   PARM      *BLANKS       @RTCD
175300200529     C                   PARM      '*VERIFY'     @OPTN
175400200529     C                   PARM      'CDL007'      @SARD
175500200529     C     SCSARD        PARM      SCSARD        DSFDY
175600200529      *
175700200529     C     @RTCD         IFEQ      *BLANK
175800200529     C                   MOVEL     'Y'           CDL007
175900200529     C                   ENDIF
176000200529      *
176100200529      ** Access SAR details file to determine if
176200200529      ** Automatic Authorisation (MM Part) is installed
176300200529      *
176400200529     C                   MOVEL     'N'           CAP051            1
176500200529     C                   CALL      'AOSARDR0'
176600200529     C                   PARM      *BLANKS       @RTCD
176700200529     C                   PARM      '*VERIFY'     @OPTN
176800200529     C                   PARM      'CAP051'      @SARD
176900200529     C     SCSARD        PARM      SCSARD        DSFDY
177000200529      *
177100200529     C     @RTCD         IFEQ      *BLANK
177200200529     C                   MOVEL     'Y'           CAP051
177300200529     C                   ENDIF
177400200529                                                                                              CDL016
177500200529      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
177600200529      ** (Automatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
177700200529                                                                                              CDL016
177800200529     C                   CallB     'AOSARDR0'                                                 CDL016
177900200529     C                   Parm      *Blanks       @RTCD                                        CDL016
178000200529     C                   Parm      '*VERIFY'     @OPTN                                        CDL016
178100200529     C                   Parm      'CDL016'      @SARD                                        CDL016
178200200529     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL016
178300200529      *                                                                                       CDL016
178400200529     C                   Move      'N'           CDL016            1                          CDL016
178500200529     C                   If        @RTCD = *Blanks                                            CDL016
178600200529     C                   Eval      CDL016 = 'Y'                                               CDL016
178700200529     C                   Endif                                                                CDL016
178800200529                                                                                              CDL018
178900200529      ** Access SAR details file to determine if CDL018 is switched on                        CDL018
179000200529      ** (Multiple Settlement Accounts on Loans/Deposit)                                      CDL018
179100200529                                                                                              CDL018
179200200529     C                   CallB     'AOSARDR0'                                                 CDL018
179300200529     C                   Parm      *Blanks       PRTCD             7                          CDL018
179400200529     C                   Parm      '*VERIFY'     POPTN             7                          CDL018
179500200529     C                   Parm      'CDL018'      PSARD             6                          CDL018
179600200529     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL018
179700200529      *                                                                                       CDL018
179800200529     C                   Move      'N'           CDL018            1                          CDL018
179900200529     C                   If        PRTCD = *Blanks                                            CDL018
180000200529     C                   Eval      CDL018 = 'Y'                                               CDL018
180100200529     C                   Endif                                                                CDL018
180200200529                                                                                              CDL019
180300200529      ** Access SAR details file to determine if CDL019 is switched on                        CDL019
180400200529      ** (Allow Base Rate Changes on Fixed Deposits/Loans)                                    CDL019
180500200529                                                                                              CDL019
180600200529     C                   CallB     'AOSARDR0'                                                 CDL019
180700200529     C                   Parm      *Blanks       @RTCD                                        CDL019
180800200529     C                   Parm      '*VERIFY'     @OPTN                                        CDL019
180900200529     C                   Parm      'CDL019'      @SARD                                        CDL019
181000200529     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL019
181100200529      *                                                                                       CDL019
181200200529     C                   Move      'N'           CDL019            1                          CDL019
181300200529     C                   If        @RTCD = *Blanks                                            CDL019
181400200529     C                   Eval      CDL019 = 'Y'                                               CDL019
181500200529     C                   Endif                                                                CDL019
181600200529                                                                                              CDL020
181700200529      ** Access SAR details file to determine if CDL020 is switched on                        CDL020
181800200529      ** (Apply Base Rate at Value Date)                                                      CDL020
181900200529                                                                                              CDL020
182000200529     C                   CallB     'AOSARDR0'                                                 CDL020
182100200529     C                   Parm      *Blanks       PRTCD                                        CDL020
182200200529     C                   Parm      '*VERIFY'     POPTN                                        CDL020
182300200529     C                   Parm      'CDL020'      PSARD                                        CDL020
182400200529     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL020
182500200529      *                                                                                       CDL020
182600200529     C                   Move      'N'           CDL020            1                          CDL020
182700200529     C                   If        PRTCD = *Blanks                                            CDL020
182800200529     C                   Eval      CDL020 = 'Y'                                               CDL020
182900200529     C                   Endif                                                                CDL020
183000200529      *
183100200529      * Access SAR details file to determine if CSC011 switchable feature
183200200529      * is switched on
183300200529
183400200529     C                   CALLB     'AOSARDR0'
183500200529     C                   PARM      *BLANKS       @RTCD
183600200529     C                   PARM      '*VERIFY'     @OPTN
183700200529     C                   PARM      'CSC011'      @SARD
183800200529     C     SCSARD        PARM      SCSARD        DSFDY
183900200529
184000200529     C                   IF        @RTCD = *Blanks
184100200529
184200200529     C                   EVAL      CSC011 = 'Y'
184300200529
184400200529     C                   IN        SC24X7
184500200529     C                   IN        SDSTAT
184600200529
184700200529      ** If 24X7 Midas availability is installed and support system is
184800200529      ** active, used processing date from dataarea SC24X7 as the
184900200529      ** rundate.
185000200529
185100200529     C                   IF        CSC011 = 'Y' AND
185200200529     C                             S1SUPP = LIBR
185300200529     C                   EVAL      WProcDate = S1DATE
185400200529     C                   ELSE
185500200529     C                   EVAL      WProcDate = BJRDNB
185600200529     C                   ENDIF
185700200529
185800200529     C                   ELSE
185900200529      ** Database error
186000200529
186100200529     C                   IF        @RTCD <> '*NRF'
186200200529     C     *LOCK         IN        LDA
186300200529     C                   EVAL      DBKEY = 'CSC011'
186400200529     C                   EVAL      DBFILE = 'SCSARDPD'
186500200529     C                   EVAL      DBASE = 900
186600200529     C                   OUT       LDA
186700200529     C                   EXSR      *PSSR
186800200529     C                   ENDIF
186900200529
187000200529     C                   ENDIF
187100200529      *                                                                                       CSC022
187200200529      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
187300200529      ** is switched on                                                                       CSC022
187400200529      *                                                                                       CSC022
187500200529     C                   CALLB     'AOSARDR0'                                                 CSC022
187600200529     C                   PARM      *BLANKS       @RTCD                                        CSC022
187700200529     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
187800200529     C                   PARM      'CSC022'      @SARD                                        CSC022
187900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
188000200529                                                                                              CSC022
188100200529     C                   IF        @RTCD = *Blanks                                            CSC022
188200200529                                                                                              CSC022
188300200529     C                   EVAL      CSC022 = 'Y'                                               CSC022
188400200529     C                   EVAL      WCMTSK = 'N'                                               CSC022
188500200529                                                                                              CSC022
188600200529     C                   IN        SCCMTJOB                                                   CSC022
188700200529                                                                                              CSC022
188800200529     C                   IF        COMITNUM > 0                                               CSC022
188900200529                                                                                              CSC022
189000200529     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
189100200529                                                                                              CSC022
189200200529     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
189300200529     C                   EVAL      WCMTSK = 'Y'                                               CSC022
189400200529     C                   ENDIF                                                                CSC022
189500200529                                                                                              CSC022
189600200529     C                   ENDIF                                                                CSC022
189700200529                                                                                              CSC022
189800200529     C                   ELSE                                                                 CSC022
189900200529     C                   IF        @RTCD <> '*NRF'                                            CSC022
190000200529     C     *LOCK         IN        LDA                                                        CSC022
190100200529     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
190200200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
190300200529     C                   EVAL      DBASE = 901                                                CSC022
190400200529     C                   OUT       LDA                                                        CSC022
190500200529     C                   EXSR      *PSSR                                                      CSC022
190600200529     C                   ENDIF                                                                CSC022
190700200529                                                                                              CSC022
190800200529     C                   ENDIF                                                                CSC022
190900200529      *                                                                                       CDL033
191000200529      ** Access SAR details file to determine if CDL033 is switch on                          CDL033
191100200529      *                                                                                       CDL033
191200200529     C                   MOVEL     'N'           CDL033            1                          CDL033
191300200529     C                   CALL      'AOSARDR0'                                                 CDL033
191400200529     C                   PARM      *BLANKS       @RTCD                                        CDL033
191500200529     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
191600200529     C                   PARM      'CDL033'      @SARD                                        CDL033
191700200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
191800200529      *                                                                                       CDL033
191900200529     C     @RTCD         IFEQ      *BLANK                                                     CDL033
192000200529     C                   MOVEL     'Y'           CDL033                                       CDL033
192100200529     C                   ELSE                                                                 CDL033
192200200529      ** Database Error, if Return Code is not blanks or *NRF                                 CDL033
192300200529     C     @RTCD         IFNE      '*NRF'                                                     CDL033
192400200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
192500200529     C                   MOVEL     '009'         DBASE                                        CDL033
192600200529     C                   MOVEL     'CDL033'      DBKEY                                        CDL033
192700200529     C                   EXSR      *PSSR                                                      CDL033
192800200529     C                   ENDIF                                                                CDL033
192900200529     C                   ENDIF                                                                CDL033
193000200529                                                                                              CDL033
193100200529      ** Verify if Hedge Accounting Enhancement is on.                                        CDL033
193200200529                                                                                              CDL033
193300200529     C                   CALLB     'AOSARDR0'                                                 CDL033
193400200529     C                   PARM      *BLANKS       @RTCD                                        CDL033
193500200529     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
193600200529     C                   PARM      'CAS005'      @SARD                                        CDL033
193700200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
193800200529     C                   SELECT                                                               CDL033
193900200529     C                   WHEN      @RTCD = *BLANKS                                            CDL033
194000200529     C                   MOVE      'Y'           CAS005            1                          CDL033
194100200529     C                   WHEN      @RTCD <> '*NRF   '                                         CDL033
194200200529     C     *LOCK         IN        LDA                                                        CDL033
194300200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL033
194400200529     C                   EVAL      DBASE = 902                                                CDL033
194500200529     C                   EVAL      DBKEY = @SARD                                              CDL033
194600200529     C                   OUT       LDA                                                        CDL033
194700200529     C                   EXSR      *PSSR                                                      CDL033
194800200529     C                   OTHER                                                                CDL033
194900200529     C                   MOVE      'N'           CAS005                                       CDL033
195000200529     C                   ENDSL                                                                CDL033
195100200529                                                                                              CDL033
195200200529      *                                                                                       CER001
195300200529      * Check if Switch ULX600 is on                                                          CER001
195400200529      *                                                                                       CER001
195500200529     C                   CALL      'AOSARDR0'                                                 CER001
195600200529     C                   PARM      *BLANKS       PRTCD                                        CER001
195700200529     C                   PARM      '*VERIFY'     POPTN                                        CER001
195800200529     C                   PARM      'ULX600'      PSARD                                        CER001
195900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
196000200529                                                                                              CER001
196100200529     C                   IF        PRTCD = *BLANKS                                            CER001
196200200529     C                   EVAL      ULX600 = 'Y'                                               CER001
196300200529     C                   ELSE                                                                 CER001
196400200529     C                   EVAL      ULX600 = 'N'                                               CER001
196500200529                                                                                              CER001
196600200529     C                   IF        PRTCD <> '*NRF'                                            CER001
196700200529     C     *LOCK         IN        LDA                                                        CER001
196800200529     C                   EVAL      DBKEY = 'ULX600'                                           CER001
196900200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
197000200529     C                   EVAL      DBASE = 909                                                CER001
197100200529     C                   OUT       LDA                                                        CER001
197200200529     C                   EXSR      *PSSR                                                      CER001
197300200529     C                   ENDIF                                                                CER001
197400200529                                                                                              CER001
197500200529     C                   ENDIF                                                                CER001
197600200529      *                                                                                       CER001
197700200529      *                                                                                      BUG9827
197800200529      ** Access SAR details file to determine if CDL006 is switch on                         BUG9827
197900200529      *                                                                                      BUG9827
198000200529     C                   MOVEL     'N'           CDL006            1                         BUG9827
198100200529     C                   CALL      'AOSARDR0'                                                BUG9827
198200200529     C                   PARM      *BLANKS       @RTCD                                       BUG9827
198300200529     C                   PARM      '*VERIFY'     @OPTN                                       BUG9827
198400200529     C                   PARM      'CDL006'      @SARD                                       BUG9827
198500200529     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9827
198600200529      *                                                                                      BUG9827
198700200529     C     @RTCD         IFEQ      *BLANK                                                    BUG9827
198800200529     C                   MOVEL     'Y'           CDL006                                      BUG9827
198900200529     C                   ELSE                                                                BUG9827
199000200529      ** Database Error, if Return Code is not blanks or *NRF                                BUG9827
199100200529     C     @RTCD         IFNE      '*NRF'                                                    BUG9827
199200200529     C                   MOVEL     'SCSARDPD'    DBFILE                                      BUG9827
199300200529     C                   MOVEL     '010'         DBASE                                       BUG9827
199400200529     C                   MOVEL     'CDL006'      DBKEY                                       BUG9827
199500200529     C                   EXSR      *PSSR                                                     BUG9827
199600200529     C                   ENDIF                                                               BUG9827
199700200529     C                   ENDIF                                                               BUG9827
199800200529      ** Modules Details                                                                     BUG9827
199900200529                                                                                             BUG9827
200000200529     C                   CALLB     'AOMMODR0'                                                BUG9827
200100200529     C                   PARM      '*DBERR '     @RTCD                                       BUG9827
200200200529     C                   PARM      '*FIRST '     @OPTN                                       BUG9827
200300200529     C     SDMMOD        PARM      SDMMOD        DSFDY                                       BUG9827
200400200529                                                                                             BUG9827
200500200529     C                   IF        @RTCD <> *BLANKS                                          BUG9827
200600200529     C     *LOCK         IN        LDA                                                       BUG9827
200700200529     C                   EVAL      DBKEY = '*FIRST'                                          BUG9827
200800200529     C                   EVAL      DBFILE = 'SDMMODPD'                                       BUG9827
200900200529     C                   EVAL      DBASE = 011                                               BUG9827
201000200529     C                   OUT       LDA                                                       BUG9827
201100200529     C                   EXSR      *PSSR                                                     BUG9827
201200200529     C                   ENDIF                                                               BUG9827
201300200529                                                                                             BUG9827
201400200529      ** ICD Portfolio Management                                                            BUG9827
201500200529                                                                                             BUG9827
201600200529     C     BGPFMG        IFEQ      'Y'                                                       BUG9827
201700200529     C                   CALLB     'AOPORTR0'                                                BUG9827
201800200529     C                   PARM      *BLANKS       @RTCD                                       BUG9827
201900200529     C                   PARM      '*FIRST '     @OPTN                                       BUG9827
202000200529     C     SDPORT        PARM      SDPORT        DSFDY                                       BUG9827
202100200529     C                   IF        @RTCD <> *BLANKS                                          BUG9827
202200200529     C     *LOCK         IN        LDA                                                       BUG9827
202300200529     C                   EVAL      DBKEY = '*FIRST'                                          BUG9827
202400200529     C                   EVAL      DBFILE = 'SDPORTPD'                                       BUG9827
202500200529     C                   EVAL      DBASE = 012                                               BUG9827
202600200529     C                   OUT       LDA                                                       BUG9827
202700200529     C                   EXSR      *PSSR                                                     BUG9827
202800200529     C                   ENDIF                                                               BUG9827
202900200529     C                   ENDIF                                                               BUG9827
203000200529                                                                                             BUG9827
203100200529      ** Access to Deal ICD file to retrieve Placing and Taking range                        BUG9827
203200200529     C                   CALLB     'AODEALR1'                                                BUG9827
203300200529     C                   PARM      '*DBERR '     @RTCD                                       BUG9827
203400200529     C                   PARM      '*FIRST '     @OPTN                                       BUG9827
203500200529     C     SDDEAL        PARM      SDDEAL        DSFDY                                      BUG10725
203600200529                                                                                             BUG9827
203700200529     C     @RTCD         IFNE      *BLANKS                                                   BUG9827
203800200529     C     *LOCK         IN        LDA                                                       BUG9827
203900200529     C                   MOVE      *ON           *INU7                                       BUG9827
204000200529     C                   MOVE      *ON           *INU8                                       BUG9827
204100200529     C                   Z-ADD     014           DBASE                                       BUG9827
204200200529     C                   MOVEL     'SDDEALPD'    DBFILE                                      BUG9827
204300200529     C                   MOVEL     '*FIRST'      DBKEY                                       BUG9827
204400200529     C                   OUT       LDA                                                       BUG9827
204500200529     C                   EXSR      *PSSR                                                     BUG9827
204600200529     C                   ENDIF                                                               BUG9827
204700200529                                                                                             BUG9827
204800200529      ** Check if S01468 is installed                                                        BUG9827
204900200529                                                                                             BUG9827
205000200529     C                   CALL      'AOSARDR0'                                                BUG9827
205100200529     C                   PARM      *BLANKS       PRTCD                                       BUG9827
205200200529     C                   PARM      '*VERIFY'     POPTN                                       BUG9827
205300200529     C                   PARM      'S01468'      PSARD                                       BUG9827
205400200529     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9827
205500200529                                                                                             BUG9827
205600200529     C                   IF        PRTCD = *BLANKS                                           BUG9827
205700200529     C                   EVAL      S01468 = 'Y'                                              BUG9827
205800200529     C                   ELSE                                                                BUG9827
205900200529     C                   EVAL      S01468 = 'N'                                              BUG9827
206000200529                                                                                             BUG9827
206100200529     C                   IF        PRTCD <> '*NRF'                                           BUG9827
206200200529     C     *LOCK         IN        LDA                                                       BUG9827
206300200529     C                   EVAL      DBKEY = 'S01468'                                          BUG9827
206400200529     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9827
206500200529     C                   EVAL      DBASE = 013                                               BUG9827
206600200529     C                   OUT       LDA                                                       BUG9827
206700200529     C                   EXSR      *PSSR                                                     BUG9827
206800200529     C                   ENDIF                                                               BUG9827
206900200529     C                   ENDIF                                                               BUG9827
207000200529                                                                                             BUG9827
207100200529      ** Define KLIST to access DLCCGDL0                                                     BUG9827
207200200529                                                                                             BUG9827
207300200529     C     WWDLCC        KLIST                                                               BUG9827
207400200529     C                   KFLD                    WWCCY             3                         BUG9827
207500200529     C                   KFLD                    FDCCOM                                      BUG9827
207600200529                                                                                              CAP087
207700200529      ** Access SAR details file to determine if CSE006 is switched on                        CAP087
207800200529                                                                                              CAP087
207900200529     C                   CallB     'AOSARDR0'                                                 CAP087
208000200529     C                   Parm      *Blanks       PRTCD                                        CAP087
208100200529     C                   Parm      '*VERIFY'     POPTN                                        CAP087
208200200529     C                   Parm      'CSE006'      PSARD                                        CAP087
208300200529     C     SCSARD        Parm      SCSARD        DSFDY                                        CAP087
208400200529      *                                                                                       CAP087
208500200529     C                   Move      'N'           CSE006            1                          CAP087
208600200529     C                   If        PRTCD = *Blanks                                            CAP087
208700200529     C                   Eval      CSE006 = 'Y'                                               CAP087
208800200529     C                   Endif                                                                CAP087
208900200529      *                                                                                       CER043
209000200529      ** Check if CER043 is switched on                                                       CER043
209100200529                                                                                              CER043
209200200529     C                   CALL      'AOSARDR0'                                                 CER043
209300200529     C                   PARM      *BLANKS       PRTCD                                        CER043
209400200529     C                   PARM      '*VERIFY'     POPTN                                        CER043
209500200529     C                   PARM      'CER043'      PSARD                                        CER043
209600200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
209700200529                                                                                              CER043
209800200529     C                   IF        PRTCD = *BLANKS                                            CER043
209900200529     C                   EVAL      CER043 = 'Y'                                               CER043
210000200529     C                   ELSE                                                                 CER043
210100200529     C                   EVAL      CER043 = 'N'                                               CER043
210200200529                                                                                              CER043
210300200529     C                   IF        PRTCD <> '*NRF'                                            CER043
210400200529     C     *LOCK         IN        LDA                                                        CER043
210500200529     C                   EVAL      DBKEY = 'CER043'                                           CER043
210600200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
210700200529     C                   EVAL      DBASE = 907                                                CER043
210800200529     C                   OUT       LDA                                                        CER043
210900200529     C                   EXSR      *PSSR                                                      CER043
211000200529     C                   ENDIF                                                                CER043
211100200529                                                                                              CER043
211200200529     C                   ENDIF                                                                CER043
211300200529      *                                                                                     MD054028
211400200529      ** Check if CER050 is ON                                                              MD054028
211500200529     C                   CallB     'AOSARDR0'                                               MD054028
211600200529     C                   Parm      *Blanks       PRTCD                                      MD054028
211700200529     C                   Parm      '*VERIFY'     POPTN                                      MD054028
211800200529     C                   Parm      'CER050'      PSARD                                      MD054028
211900200529     C     SCSARD        Parm      SCSARD        DSFDY                                      MD054028
212000200529      *                                                                                     MD054028
212100200529     C                   Move      'N'           CER050            1                        MD054028
212200200529     C                   If        PRTCD = *Blanks                                          MD054028
212300200529     C                   Eval      CER050 = 'Y'                                             MD054028
212400200529     C                   Endif                                                              MD054028
212500200529     C/COPY WNCPYSRC,MMLDNIXC03
212600200529
212700200529     C                   ENDSR
212800200529      *****************************************************************
212900200529      /EJECT
213000200529      *****************************************************************
213100200529      *                                                               *
213200200529      * ValidateAc - Routine to validate action code versus the       *
213300200529      *    transaction IDs supplied                                   *
213400200529      *                                                               *
213500200529      *****************************************************************
213600200529
213700200529     C     ValidateAc    BEGSR
213800200529
213900200529      * Validate action code versus transaction IDs supplied
214000200529      * This function will set the Midas deal number and the Midas
214100200529      * associated deal number.
214200200529      * The deal in file format from the MM database is retrieved as well.
214300200529
214400200529     C                   RESET                   ReturnCode
214500200529     C                   CALLB     'MMLDNIRTV'
214600200529
214700200529      * INPUTS
214800200529      * Return code
214900200529     C                   PARM                    ReturnCode
215000200529
215100200529      * Mode = '*FRONT' (Front Office transaction interface)
215200200529      * Mode = '      ' (Not Front Office transaction interface)
215300200529     C                   PARM      '      '      ModeofOp          6
215400200529      *
215500200529      * Response mode
215600200529     C                   PARM      'S'           APRESPMODE
215700200529
215800200529      * Action Code
215900200529     C                   PARM                    DDACTN
216000200529
216100200529      * Front Office Transaction ID
216200200529     C                   PARM                    APFOTranID
216300200529
216400200529      * Front Office Associated Transaction Id
216500200529     C                   PARM                    APFOAsocID
216600200529
216700200529      * (Midas) Deal Number
216800200529     C                   PARM                    DDDLNO
216900200529
217000200529      * (Midas) Depot Movement Reference
217100200529
217200200529     C                   PARM                    DDDDMR            6
217300200529
217400200529      * (Midas) Associated Deal Number
217500200529     C                   PARM                    DDDADN
217600200529
217700200529      * Booking branch
217800200529     C                   PARM                    DDBRCA
217900200529
218000200529      * REPO Flag
218100200529     C                   PARM                    RepoFlag          1
218200200529
218300200529      * OUTPUTS
218400200529      * (Current) deal in file format
218500200529     C                   PARM                    DealFilFmt
218600200529      *                                                                                     AR701789
218700200529     C**********         PARM                    ACTRJ                             AR701789 MD042711
218800200529     C                   PARM                    ACTRJ                                      MD044873
218900200529
219000200529      * OK - Action code
219100200529     C                   PARM                    OKACTN
219200200529
219300200529      * OK - Deal Number
219400200529     C                   PARM                    OKDLNO
219500200529
219600200529      * OK - Booking branch
219700200529     C                   PARM                    OKBRCA
219800200529                                                                                              CDL016
219900200529      * Blocked/Unblock Action                                                                CDL016
220000200529     C                   PARM                    BUACT             1                          CDL016
220100200529
220200200529      * Error fields/message IDs/message data (arrays) from/to caller
220300200529     C                   PARM                    FldNameArr
220400200529     C                   PARM                    MsgIDArr
220500200529     C                   PARM                    MsgDtaArr
220600200529
220700200529      * Array index (3P0) from/to caller
220800200529     C                   PARM                    Idx
220900200529
221000200529      ** Warning flds/message IDs/message data (arrays) from/to caller
221100200529
221200200529     C                   PARM                    WFldNamArr
221300200529     C                   PARM                    WMsgIdArr
221400200529     C                   PARM                    WMsgDtaArr
221500200529
221600200529      ** Array index (3P0) from/to caller
221700200529
221800200529     C                   PARM                    WIdx
221900200529     C/COPY WNCPYSRC,MMLDNIXC06
222000200529      *
222100200529      ** Default current system date to Deal Date when inserting
222200200529      ** a new transaction.
222300200529      *
222400200529     C     DDACTN        IFEQ      *BLANK
222500200529     C                   EXSR      SetupDDAT
222600200529     C                   ENDIF
222700200529      *                                                                                     BUG10677
222800200529      ** Call MMLDNIWRN where necessary when deleting fiduciary deals                       BUG10677
222900200529      *                                                                                     BUG10677
223000200529     C                   IF        CDL006 = 'Y' and DDACTN = 'D'                            BUG10677
223100200529      *                                                                                     BUG10677
223200200529     C                   IF        DDTYPE = 'FL' or DDTYPE = 'DP' or                        BUG10677
223300200529     C                             DDTYPE = 'LP'                                            BUG10677
223400200529     C**********         IF        HKDSTS = 'C'                                    BUG10677 BUG10718
223500200529     C                   IF        HKDSTS = 'C' or                                          BUG10718
223600200529     C                             HKDSTS = 'A'                                             BUG10718
223700200529     C                   CALLB     'MMLDNIWRN'                                              BUG10677
223800200529     C                   PARM                    DDDLNO                                     BUG10677
223900200529     C                   PARM                    DDTYPE                                     BUG10677
224000200529     C                   PARM                    WFldNamArr                                 BUG10677
224100200529     C                   PARM                    WMsgIdArr                                  BUG10677
224200200529     C                   PARM                    WMsgDtaArr                                 BUG10677
224300200529     C                   PARM                    WIdx                                       BUG10677
224400200529     C                   ENDIF                                                              BUG10677
224500200529     C                   ENDIF                                                              BUG10677
224600200529      *                                                                                     BUG10677
224700200529     C                   IF        DDTYPE = 'FT' or DDTYPE = 'DT' or                        BUG10677
224800200529     C                             DDTYPE = 'LT'                                            BUG10677
224900200529     C                   CALLB     'MMLDNIWRN'                                              BUG10677
225000200529     C                   PARM                    DDDLNO                                     BUG10677
225100200529     C                   PARM                    DDTYPE                                     BUG10677
225200200529     C                   PARM                    WFldNamArr                                 BUG10677
225300200529     C                   PARM                    WMsgIdArr                                  BUG10677
225400200529     C                   PARM                    WMsgDtaArr                                 BUG10677
225500200529     C                   PARM                    WIdx                                       BUG10677
225600200529     C                   ENDIF                                                              BUG10677
225700200529      *                                                                                     BUG10677
225800200529     C                   ENDIF                                                              BUG10677
225900200529
226000200529     C                   ENDSR
226100200529      *****************************************************************
226200200529      /EJECT
226300200529      *****************************************************************
226400200529      *                                                               *
226500200529      * DftSettmts - Routine to apply default settlement instructions *
226600200529      *    if none have been supplied                                 *
226700200529      *                                                               *
226800200529      *****************************************************************
226900200529
227000200529     C     DftSettmts    BEGSR
227100200529
227200200529      * If ANY of the Settlements fields have been entered, bypass this
227300200529      *  routine.
227400200529      * Otherwise, use modules which will use Standard Settlement
227500200529      *  Instructions to apply defaults.
227600200529
227700200529     C**********         IF            (InRecSttmt = *blank)                                MD027337
227800200529     C**********                   AND (InPaySttmt = *blank)                                MD027337
227900200529     C                   IF            (DDRSTM = *blank)                                    MD027337
228000200529     C                             AND (DDPSTM = *blank)                                    MD027337
228100200529     C                             AND DDCcy  <> *BLANK                                       241685
228200200529     C                             AND DDCust <> *BLANK                                       241685
228300200529     C                             AND DDACTN = 'I'                                        MD027337A
228400200529     C                             OR  DDACTN = 'A'                                        MD027337A
228500200529     C                             AND DDCcy  <> *BLANK                                    MD027337A
228600200529     C                             AND DDCust <> *BLANK                                    MD027337A
228700200529     C                             AND (DDRSTM = *blank                                    MD027337A
228800200529     C                             OR  DDPSTM = *blank)                                    MD027337A
228900200529
229000200529     C/COPY WNCPYSRC,MMH00034
229100200529     C                   CALLB     'ZASETINDFT'
229200200529
229300200529      ** Output
229400200529      ** Calling function type
229500200529     C                   PARM                    LDNI
229600200529      ** Payment currency (or deal cuurency if only one currency on deal)
229700200529     C                   PARM                    DDCcy
229800200529      ** Receive currency (only if deal has two currencies)
229900200529     C                   PARM                    DDCcy
230000200529      ** Customer (shortname or number)
230100200529     C                   PARM                    DDCust
230200200529      ** Deal type
230300200529     C                   PARM                    DDType
230400200529      ** Federal Funds Ind.
230500200529     C                   PARM                    DDFedF
230600200529      ** ISDA Rules for FRA/IRS deals only
230700200529      ** Version of ISDA Rules govern
230800200529     C                   PARM                    Blank4
230900200529      ** Type of ISDA agreement
231000200529     C                   PARM                    Blank6
231100200529      ** Date of ISDA Agreement
231200200529     C                   PARM                    Blank6
231300200529      ** Version of ISDA Agreement
231400200529     C                   PARM                    Blank2
231500200529      ** Version of ISDA Agreement century
231600200529     C                   PARM                    Blank2
231700200529      ** Deal Subtype                                                                         CSD095
231800200529     C                   PARM                    DDSTYP                                       CSD095
231900200529      ** Branch                                                                               CSD095
232000200529     C                   PARM                    DDBRCA                                       CSD095
232100200529      *
232200200529      ** Return
232300200529      ** Defaulted Payment Settlement Instruction in file format
232400200529     C                   PARM                    DBPaySttmt
232500200529      ** Defaulted Receipt Settlement Instruction in file format
232600200529     C                   PARM                    DBRecSttmt
232700200529      ** Defaulted FRA/IRS Settlement Instruction in file format
232800200529     C                   PARM                    DBFRASttmt
232900200529     C/COPY WNCPYSRC,MMH00035
233000200529
233100200529      *  The defaulted instructions are in file format, but the
233200200529      *   Settlements validation requires that they are in the input format.
233300200529      *  Therefore run them through a conversion module.
233400200529
233500200529     C                   CALLB     'ZASETINCVT'
233600200529      ** Defaulted Settlement Instructions in file format
233700200529     C                   PARM                    DBPaySttmt
233800200529     C                   PARM                    DBRecSttmt
233900200529     C                   PARM                    DBFRASttmt
234000200529
234100200529      ** Current Settlement Instruction in input format
234200200529     C                   PARM                    CrPaySttmt
234300200529     C                   PARM                    CrRecSttmt
234400200529     C                   PARM                    CrFRASttmt
234500200529     C                   PARM      DDCCY         #TRCCY                                      CSF011A
234600200529     C                   PARM      DDCCY         #TPCCY                                      CSF011A
234700200529
234800200529      *  If no Payment or Receive instructions have been supplied
234900200529      *  Default them to those currently on the deal.
235000200529
235100200529     C**********         IF            (InPaySttmt = *blank)                                MD027337
235200200529     C                   IF            (DDPSTM = *blank)                                    MD027337
235300200529     C                   EVAL      InPaySttmt = CrPaySttmt
235400200529     C                   ENDIF
235500200529
235600200529     C**********         IF            (InRecSttmt = *blank)                                MD027337
235700200529     C                   IF            (DDRSTM = *blank)                                    MD027337
235800200529     C                   EVAL      InRecSttmt = CrRecSttmt
235900200529     C                   ENDIF
236000200529
236100200529      * Do data substitution for Settlement Instructions
236200200529
236300200529     C     GHSUBS        ifne      *blank
236400200529     C     GHSUBS        scan      InPaySttmt                             99
236500200529     C  N99GHSUBS        scan      InRecSttmt                             99
236600200529     C     *in99         ifeq      *on
236700200529     C                   EXSR      SDtDtaSubs
236800200529     C                   endif
236900200529     C                   endif
237000200529
237100200529     C                   ENDIF
237200200529
237300200529     C                   ENDSR
237400200529      *****************************************************************
237500200529      /EJECT
237600200529      *****************************************************************
237700200529      *                                                               *
237800200529      * SETUPAMEND - Set up fields that are needed in the validation  *
237900200529      *    of Amendments.                                             *
238000200529      *                                                               *
238100200529      *****************************************************************
238200200529
238300200529     C     SetupAmend    BEGSR
238400200529
238500200529      * For Amends, put the complete (pre-existing) deal into the Valid
238600200529      *  file record - fields in this will be updated during  processing
238700200529     C                   MOVEL     DealFilFmt    ValidDeal
238800200529     C     DDAPRC        Ifeq      *Blank                                                     CER050
238900200529     C     DDACTN        andeq     'A'                                                        CER050
239000200529     C                   Eval      DDAPRC     = HKAPRC                                        CER050
239100200529     C                   Endif                                                                CER050
239200200529     C                   Z-ADD     HKRRAT        IKRRAT                                     BUG12551
239300200529     C                   Z-ADD     HKMATD        OLD_MATD
239400200529      *****************************************************************           MD027337 MD027337A
239500200529      ***Convert*DDVDAT*to*Midas*Day*number****************************           MD027337 MD027337A
239600200529      *****************************************************************           MD027337 MD027337A
239700200529     C**********         CALLB     'ZDATE1'                                       MD027337 MD027337A
239800200529     C**********         PARM                    DDVDAT                           MD027337 MD027337A
239900200529     C**********         PARM                    ValueDate                        MD027337 MD027337A
240000200529     C**********         PARM                    BJDFIN                           MD027337 MD027337A
240100200529     C**********         PARM                    ErrorFlag                        MD027337 MD027337A
240200200529
240300200529      *  The Settlement Instructions fields may not be supplied for an
240400200529      *  amendment. If none of the pay/receive instructions were
240500200529      *  supplied (i.e. all are blank), default the existing database
240600200529      *  values into the special DB Settlement Instructions DSs ....
240700200529
240800200529     C**********         IF            (InRecSttmt = *blank)                                MD027337
240900200529     C**********                   AND (InPaySttmt = *blank)                                MD027337
241000200529     C**********         IF            (DDRSTM = *blank)                          MD027337 MD027337A
241100200529     C**********                   AND ValueDate < BJRDNB                         MD027337 MD027337A
241200200529     C**********                   OR  (DDPSTM = *blank)                          MD027337 MD027337A
241300200529     C**********                   AND ValueDate < BJRDNB                         MD027337 MD027337A
241400200529     C                   IF            (InRecSttmt = *blank)                               MD027337A
241500200529     C                             AND (InPaySttmt = *blank)                               MD027337A
241600200529     C                             AND (FLPSTM <> 00 and FLRSTM <> 00)                      MD030436
241700200529
241800200529     C**********         EVAL      DBRecSttmt = DELDRecIns + HKROBR                           CGL029
241900200529     C                   EVAL      FLRSTM     = HKRSTM                                        CGL029
242000200529     C                   EVAL      FLRONS     = HKRONS                                        CGL029
242100200529     C                   EVAL      FLREC2     = DELDRecIns                                    CGL029
242200200529     C                   EVAL      FLROBR     = HKROBR                                        CGL029
242300200529     C                   EVAL      FLRSCY     = HKSTCY
242400200529     C                   EVAL      FLRMAC     = HKRMAC                                        CDL018
242500200529     C**********         EVAL      DBPaySttmt = DELDPayIns + HKPOBR + HKCVMR                  CGL029
242600200529     C                   EVAL      FLPSTM     = HKPSTM                                        CGL029
242700200529     C                   EVAL      FLPONS     = HKPONS                                        CGL029
242800200529     C                   EVAL      FLPAY2     = DELDPayIns                                    CGL029
242900200529     C                   EVAL      FLPOBR     = HKPOBR                                        CGL029
243000200529     C                   EVAL      FLCVMR     = HKCVMR                                        CGL029
243100200529     C                   EVAL      FLPSCY     = HKSTCY
243200200529     C                   EVAL      FLIC72     = HKIC72
243300200529     C                   EVAL      FLPMAC     = HKPMAC                                        CDL018
243400200529     C                   EVAL      FLRBB1     = HKRBB1                                        CDL094
243500200529     C                   EVAL      FLRBB2     = HKRBB2                                        CDL094
243600200529     C                   EVAL      FLRBB3     = HKRBB3                                        CDL094
243700200529     C                   EVAL      FLRBB4     = HKRBB4                                        CDL094
243800200529     C                   EVAL      FLRBB5     = HKRBB5                                        CDL094
243900200529     C                   EVAL      FLRBB6     = HKRBB6                                        CDL094
244000200529
244100200529      *  .... and then convert these to the screen format
244200200529     C                   CALLB     'ZASETINCVT'
244300200529
244400200529      ** Defaulted Settlement Instructions in file format
244500200529     C                   PARM                    DBPaySttmt
244600200529     C                   PARM                    DBRecSttmt
244700200529     C                   PARM                    DBFRASttmt
244800200529
244900200529      ** Defaulted Settlement Instruction in input format
245000200529     C                   PARM                    InPaySttmt
245100200529     C                   PARM                    InRecSttmt
245200200529     C                   PARM                    InFRASttmt
245300200529     C                   PARM      HKCCY         #TRCCY                                      CSF011A
245400200529     C                   PARM      HKCCY         #TPCCY                                      CSF011A
245500200529
245600200529     C                   ELSE                                                               MD027337
245700200529     C                   IF        DDRSTM = *BLANK                                         MD027337A
245800200529     C                             OR DDPSTM = *BLANK                                      MD027337A
245900200529     C                   EXSR      DftSettmts                                               MD027337
246000200529     C                   ENDIF                                                             MD027337A
246100200529     C                   ENDIF
246200200529
246300200529      * Do data substitution for Settlement Instructions
246400200529
246500200529     C     GHSUBS        IFNE      *BLANK
246600200529     C     GHSUBS        SCAN      InPaySttmt                             99
246700200529     C  N99GHSUBS        SCAN      InRecSttmt                             99
246800200529     C     *IN99         IFEQ      *ON
246900200529     C                   EXSR      SDtDtaSubs
247000200529     C                   ENDIF
247100200529     C                   ENDIF
247200200529
247300200529     C                   ENDSR
247400200529      *****************************************************************
247500200529      /EJECT
247600200529      *****************************************************************
247700200529      *                                                               *
247800200529      * ValidateTr - Routine to validate the main tranaction details  *
247900200529      *                                                               *
248000200529      *****************************************************************
248100200529
248200200529     C     ValidateTr    BEGSR
248300200529
248400200529     C                   CALLB     'MMLDNIVAL'
248500200529      * Response mode (1A), from source system common header
248600200529     C                   PARM      'S'           APRespMode
248700200529      * Transaction information (DS) from source system
248800200529     C                   PARM                    TranIn
248900200529     C**********         PARM                    ACTRJ                             AR701789 MD042711
249000200529     C                   PARM                    ACTRJ                                      MD044873
249100200529     C                   PARM                    InfData
249200200529      * Receive Settlement Currency, Method & Nostro and
249300200529      * Payment Settlement Currency, Method & Nostro
249400200529      * Extra Data
249500200529     C                   PARM      *BLANK        RecSetCcy
249600200529     C                   PARM      *ZERO         RecSetMeth
249700200529     C                   PARM                    RecNostro
249800200529     C                   PARM      *BLANK        PaySetCcy
249900200529     C                   PARM      *ZERO         PaySetMeth
250000200529     C                   PARM                    PayNostro
250100200529     C                   PARM      HKFRNT        @@FRNT           20
250200200529     C                   PARM                    ExtData
250300200529     C                   PARM                    DDAPRC            1                        MD054028
250400200529     C                   PARM                    DDAPRR            8                        MD054028
250500200529      * Field OK flags (DS) from/to caller
250600200529     C                   PARM                    MMELDN
250700200529      * Error fields/message IDs/message data (arrays) from/to caller
250800200529     C                   PARM                    FldNameArr
250900200529     C                   PARM                    MsgIDArr
251000200529     C                   PARM                    MsgDtaArr
251100200529      * Array index (3P0) from/to caller
251200200529     C                   PARM                    Idx
251300200529      * Warning fields/message IDs/message data (arrays) from/to caller
251400200529     C                   PARM                    WFldNamArr
251500200529     C                   PARM                    WMsgIDArr
251600200529     C                   PARM                    WMsgDtaArr
251700200529      * Array index (3P0) from/to caller
251800200529     C                   PARM                    WIdx
251900200529      * Valid Deals layout (DS) from/to caller
252000200529     C                   PARM                    ValidDeal
252100200529     C*******************PARM      'N'           RepoFlag          1                          CAP087
252200200529     C                   PARM                    RepoFlag          1                          CAP087
252300200529     C/COPY WNCPYSRC,MMLDNIXC04
252400200529      *                                                                                       CDL016
252500200529      * If errors bypass Screen 2 validation                                                  CDL016
252600200529      *                                                                                       CDL016
252700200529     C                   IF        Idx <> *ZERO                                               CDL016
252800200529     C                   GOTO      EValTr                                                     CDL016
252900200529     C                   ENDIF                                                                CDL016
253000200529      *                                                                                       CDL016
253100200529      * Validate screen 2 if feature is on and Fixed Deposit Deal                             CDL016
253200200529      *                                                                                       CDL016
253300200529     C     CDL016        IFEQ      'Y'                                                        CDL016
253400200529     C     CDL019        OREQ      'Y'                                                        CDL019
253500200529     C     CDL020        OREQ      'Y'                                                        CDL020
253600200529     C     CDL033        OREQ      'Y'                                                        CDL033
253700200529     C     DDType        ANDEQ     'CF'                                                       CDL033
253800200529     C     CDL033        OREQ      'Y'                                                        CDL033
253900200529     C     DDType        ANDEQ     'CI'                                                       CDL033
254000200529     C     CDL033        OREQ      'Y'                                                        CDL033
254100200529     C     DDType        ANDEQ     'IP'                                                       CDL033
254200200529     C     CDL033        OREQ      'Y'                                                        CDL033
254300200529     C     DDType        ANDEQ     'IT'                                                       CDL033
254400200529     C     CDL033        OREQ      'Y'                                                        CDL033
254500200529     C     DDType        ANDEQ     'TI'                                                       CDL033
254600200529     C     CDL033        OREQ      'Y'                                                        CDL033
254700200529     C     DDType        ANDEQ     'TD'                                                       CDL033
254800200529      *                                                                                       CDL016
254900200529     C                   CALLB     'MMLDNIVL2'                                                CDL016
255000200529      * Response mode (1A), from source system common header                                  CDL016
255100200529     C                   PARM                    APRespMode                                   CDL016
255200200529      * Transaction information (DS) from source system                                       CDL016
255300200529     C                   PARM                    TranIn                                       CDL016
255400200529     C                   PARM                    InfData                                      CDL016
255500200529      * Receive Settlement Currency, Method & Nostro and                                      CDL016
255600200529      * Payment Settlement Currency, Method & Nostro                                          CDL016
255700200529      * Extra Data                                                                            CDL016
255800200529     C                   PARM      *BLANK        RecSetCcy                                    CDL016
255900200529     C                   PARM      *ZERO         RecSetMeth                                   CDL016
256000200529     C                   PARM                    RecNostro                                    CDL016
256100200529     C                   PARM      *BLANK        PaySetCcy                                    CDL016
256200200529     C                   PARM      *ZERO         PaySetMeth                                   CDL016
256300200529     C                   PARM                    PayNostro                                    CDL016
256400200529     C                   PARM      HKFRNT        @@FRNT                                       CDL016
256500200529     C                   PARM                    ExtData                                      CDL016
256600200529      * Field OK flags (DS) from/to caller                                                    CDL016
256700200529     C                   PARM                    MMELDN2                                      CDL016
256800200529      * Error fields/message IDs/message data (arrays) from/to caller                         CDL016
256900200529     C                   PARM                    FldNameArr                                   CDL016
257000200529     C                   PARM                    MsgIDArr                                     CDL016
257100200529     C                   PARM                    MsgDtaArr                                    CDL016
257200200529      * Array index (3P0) from/to caller                                                      CDL016
257300200529     C                   PARM                    Idx                                          CDL016
257400200529      * Warning fields/message IDs/message data (arrays) from/to caller                       CDL016
257500200529     C                   PARM                    WFldNamArr                                   CDL016
257600200529     C                   PARM                    WMsgIDArr                                    CDL016
257700200529     C                   PARM                    WMsgDtaArr                                   CDL016
257800200529      * Array index (3P0) from/to caller                                                      CDL016
257900200529     C                   PARM                    WIdx                                         CDL016
258000200529      * Valid Deals layout (DS) from/to caller                                                CDL016
258100200529     C                   PARM                    ValidDeal                                    CDL016
258200200529     C                   PARM      'N'           RepoFlag          1                          CDL016
258300200529     C                   PARM                    CDL016                                       CDL016
258400200529     C                   PARM                    CDL019                                       CDL019
258500200529     C                   PARM                    CDL020                                       CDL020
258600200529     C                   PARM                    CAS005                                       CDL033
258700200529     C                   PARM                    CDL033                                       CDL033
258800200529     C                   PARM      IKINTR        SRate                                        CDL033
258900200529                                                                                              CDL016
259000200529     C                   ENDIF                                                                CDL016
259100200529                                                                                              CDL016
259200200529     C                   IF        ULX600 = 'Y'                                               CER001
259300200529     C                   EXSR      ValidateLUX                                                CER001
259400200529                                                                                              CER001
259500200529     C     Ix            IFNE      0                                                          CER001
259600200529     C                   GOTO      EValTr                                                     CER001
259700200529     C                   ENDIF                                                                CER001
259800200529     C                   ENDIF                                                                CER001
259900200529                                                                                              CER001
260000200529     C     EValTr        TAG                                                                  CDL016
260100200529
260200200529     C                   ENDSR
260300200529      *****************************************************************
260400200529      /EJECT
260500200529      *****************************************************************                      BUG3992
260600200529      *                                                               *                      BUG3992
260700200529      * ValidateLP - Re-Validate dates after the settlement details   *                      BUG3992
260800200529      *              have been determined.                            *                      BUG3992
260900200529      *                                                               *                      BUG3992
261000200529      *****************************************************************                      BUG3992
261100200529                                                                                             BUG3992
261200200529     C     ValidateLP    BEGSR                                                               BUG3992
261300200529                                                                                             BUG3992
261400200529      * Initialise parameter fields                                                          BUG3992
261500200529     C                   MOVEL     DDRSTM        RecSetMeth                                  BUG3992
261600200529     C                   MOVEL     DDPSTM        PaySetMeth                                  BUG3992
261700200529     C                   MOVEL     DDRONX        RecNostro                                   BUG3992
261800200529     C                   MOVEL     DDPONX        PayNostro                                   BUG3992
261900200529                                                                                             BUG3992
262000200529     C                   CALLB     'MMLDNIVLP'                                               BUG3992
262100200529      * Response mode (1A), from source system common header                                 BUG3992
262200200529     C                   PARM      'S'           APRespMode                                  BUG3992
262300200529      * Transaction information (DS) from source system                                      BUG3992
262400200529     C                   PARM                    TranIn                                      BUG3992
262500200529     C                   PARM                    InfData                                     BUG3992
262600200529      * Receive Settlement Currency, Method & Nostro and                                     BUG3992
262700200529      * Payment Settlement Currency, Method & Nostro                                         BUG3992
262800200529      * Extra Data                                                                           BUG3992
262900200529     C                   PARM      DDRSCY        RecSetCcy                                   BUG3992
263000200529     C                   PARM                    RecSetMeth                                  BUG3992
263100200529     C                   PARM                    RecNostro                                   BUG3992
263200200529     C                   PARM      DDPSCY        PaySetCcy                                   BUG3992
263300200529     C                   PARM                    PaySetMeth                                  BUG3992
263400200529     C                   PARM                    PayNostro                                   BUG3992
263500200529     C                   PARM      HKFRNT        @@FRNT           20                         BUG3992
263600200529     C                   PARM                    ExtData                                     BUG3992
263700200529      * Field OK flags (DS) from/to caller                                                   BUG3992
263800200529     C                   PARM                    MMELDN                                      BUG3992
263900200529     C                   PARM                    MMELDN2                                     BUG5169
264000200529      * Error fields/message IDs/message data (arrays) from/to caller                        BUG3992
264100200529     C                   PARM                    FldNameArr                                  BUG3992
264200200529     C                   PARM                    MsgIDArr                                    BUG3992
264300200529     C                   PARM                    MsgDtaArr                                   BUG3992
264400200529      * Array index (3P0) from/to caller                                                     BUG3992
264500200529     C                   PARM                    Idx                                         BUG3992
264600200529      * Warning fields/message IDs/message data (arrays) from/to caller                      BUG3992
264700200529     C                   PARM                    WFldNamArr                                  BUG3992
264800200529     C                   PARM                    WMsgIDArr                                   BUG3992
264900200529     C                   PARM                    WMsgDtaArr                                  BUG3992
265000200529      * Array index (3P0) from/to caller                                                     BUG3992
265100200529     C                   PARM                    WIdx                                        BUG3992
265200200529      * Valid Deals layout (DS) from/to caller                                               BUG3992
265300200529     C                   PARM                    ValidDeal                                   BUG3992
265400200529     C                   PARM      'N'           RepoFlag          1                         BUG3992
265500200529     C/COPY WNCPYSRC,MMLDNIXC07                                                              BUG3992
265600200529                                                                                             BUG3992
265700200529     C                   ENDSR                                                               BUG3992
265800200529                                                                                             BUG3992
265900200529      *****************************************************************                      BUG3992
266000200529      /EJECT                                                                                 BUG3992
266100200529      *****************************************************************
266200200529      *                                                               *
266300200529      * ValidateSt - Routine to validate the settlemnt instructions   *
266400200529      *                                                               *
266500200529      *****************************************************************
266600200529
266700200529     C     ValidateSt    BEGSR
266800200529
266900200529      * The called module requires that the customer number/name is valid,
267000200529      *  if it is not, exit from this subroutine.
267100200529     C                   IF        NOT (OKCUST = 'Y')
267200200529     C                   GOTO      ValSetExit
267300200529     C                   ENDIF
267400200529
267500200529      * The called module uses the value date in Midas Day Number format,
267600200529      *  which will not have been returned from the overall validation
267700200529      *  routine, so it needs to be converetd here.
267800200529
267900200529     C                   IF        OKVDAT <> 'N'
268000200529
268100200529     C**********         CALLB     'ZDATE1'                                                   250161
268200200529     C**********         PARM                    DDVDAT                                       250161
268300200529     C**********         PARM                    ValDateMDN                                   250161
268400200529     C**********         PARM                    BJDFIN                                       250161
268500200529     C**********         PARM                    ErrorFlag                                    250161
268600200529
268700200529      * If the Deal Type is for a Loan,    set the Pay Date = Value Date
268800200529      * If the Deal Type is for a Deposit, set the Receive Date = Value Date
268900200529     C                   IF           DDType = 'IP' OR DDType = 'TI'
269000200529     C                             OR DDType = 'CL' OR DDType = 'LN'
269100200529     C                             OR DDType = 'DL'
269200200529     C**********         EVAL      PayDat = ValDateMDN                                        250161
269300200529     C                   EVAL      LOD = 'L'                                                  250161
269400200529     C                   ELSE
269500200529     C**********         EVAL      RecDat = ValDateMDN                                        250161
269600200529     C                   EVAL      LOD = 'D'                                                  250161
269700200529     C                   ENDIF
269800200529      *                                                                                       260428
269900200529     C     DDACTN        IFNE      'I'                                                        260428
270000200529      *                                                                                       260428
270100200529      * Convert Transaction Date to a Midas Day Number                                        260428
270200200529      *                                                                                       260428
270300200529     C                   Z-ADD     IKDTYY        @@YEAR                                       260428
270400200529     C                   Z-ADD     IKDTMM        @@MNTH                                       260428
270500200529     C                   Z-ADD     IKDTDD        @@DAY                                        260428
270600200529     C     @@DTIN        IFEQ      0                                                          260428
270700200529     C                   Z-ADD     BJRDNB        TransDate                                    260428
270800200529     C                   ELSE                                                                 260428
270900200529     C                   CALLB     'ZDATE10'                                                  260428
271000200529     C                   PARM                    @@DTIN                                       260428
271100200529     C                   PARM                    ZZMDNO            5 0                        260428
271200200529     C                   MOVE      ZZMDNO        TransDate         5 0                        260428
271300200529     C                   ENDIF                                                                260428
271400200529      *                                                                                       260428
271500200529      * Protect Payment/Receive instructions if dates                                         260428
271600200529      * are in the past and the deal was not done today                                       260428
271700200529      *                                                                                       260428
271800200529     C                   EVAL      W#CCY = *BLANKS                                          MD022656
271900200529     C     PayDat        IFLT      BJRDNB                                                     260428
272000200529     C     TransDate     ANDNE     BJRDNB                                                     260428
272100200529     C     DDACTN        OREQ      'X'                                                       260428A
272200200529     C                   MOVEL     'Y'           ##PPAY                                       260428
272300200529     C                   IF        DDACTN = 'A'                                             MD022656
272400200529     C**********                   AND ModeofOp = '*FRONT'                        MD022656 MD024884A
272500200529     C                   EXSR      SrPayAmnd                                                MD022656
272600200529     C                   ENDIF                                                              MD022656
272700200529     C                   ELSE                                                                 260428
272800200529     C                   MOVEL     'N'           ##PPAY                                       260428
272900200529     C                   ENDIF                                                                260428
273000200529     C     RecDat        IFLT      BJRDNB                                                     260428
273100200529     C     TransDate     ANDNE     BJRDNB                                                     260428
273200200529     C     DDACTN        OREQ      'X'                                                       260428A
273300200529     C                   MOVEL     'Y'           ##PREC                                       260428
273400200529     C                   IF        DDACTN = 'A'                                             MD022656
273500200529     C**********                   AND ModeofOp = '*FRONT'                        MD022656 MD024884A
273600200529     C                   EXSR      SrRecAmnd                                                MD022656
273700200529     C                   ENDIF                                                              MD022656
273800200529     C                   ELSE                                                                 260428
273900200529     C                   MOVEL     'N'           ##PREC                                       260428
274000200529     C                   ENDIF                                                                260428
274100200529     C                   ENDIF                                                                260428
274200200529
274300200529                                                                                              250161
274400200529      ** Payment date = value date for loan, maturity date for deposit                        250161
274500200529     C                   IF        LOD = 'L'                                                  250161
274600200529     C                   CALLB     'ZDATE1'                                                   250161
274700200529     C                   PARM                    DDVDAT                                       250161
274800200529     C                   PARM                    ValDateMDN                                   250161
274900200529     C                   PARM                    BJDFIN                                       250161
275000200529     C                   PARM                    ErrorFlag                                    250161
275100200529     C                   EVAL      PayDat = ValDateMDN                                        250161
275200200529     C                   ELSE                                                                 250161
275300200529     C                   CALLB     'ZDATE1'                                                   250161
275400200529     C                   PARM                    DDMDAT                                       250161
275500200529     C                   PARM                    ValDateMDN                                   250161
275600200529     C                   PARM                    BJDFIN                                       250161
275700200529     C                   PARM                    ErrorFlag                                    250161
275800200529     C                   EVAL      PayDat = ValDateMDN                                        250161
275900200529     C                   Endif                                                                250161
276000200529                                                                                              250161
276100200529      ** Receive date = maturity date for loan, value date for deposit                        250161
276200200529     C                   IF        LOD = 'L'                                                  250161
276300200529     C                   CALLB     'ZDATE1'                                                   250161
276400200529     C                   PARM                    DDMDAT                                       250161
276500200529     C                   PARM                    ValDateMDN                                   250161
276600200529     C                   PARM                    BJDFIN                                       250161
276700200529     C                   PARM                    ErrorFlag                                    250161
276800200529     C                   EVAL      RecDat = ValDateMDN                                        250161
276900200529     C                   ELSE                                                                 250161
277000200529     C                   CALLB     'ZDATE1'                                                   250161
277100200529     C                   PARM                    DDVDAT                                       250161
277200200529     C                   PARM                    ValDateMDN                                   250161
277300200529     C                   PARM                    BJDFIN                                       250161
277400200529     C                   PARM                    ErrorFlag                                    250161
277500200529     C                   EVAL      RecDat = ValDateMDN                                        250161
277600200529     C                   Endif                                                                250161
277700200529
277800200529     C                   ENDIF
277900200529
278000200529     C                   RESET                   ReturnCode
278100200529     C                   CALLB     'ZASETINVAL'
278200200529
278300200529      ** Return Code
278400200529     C                   PARM                    ReturnCode
278500200529      ** Following parameters are output to called module
278600200529      ** Calling function type
278700200529     C                   PARM                    LDNI
278800200529      ** Transaction Fields
278900200529      ** Payment currency (or deal currency if only one currency on deal)
279000200529     C                   PARM                    DDCCY
279100200529      ** Receive currency (or deal currency if only one currency on deal)
279200200529     C                   PARM                    DDCCY
279300200529      ** Customer (shortname or number)
279400200529     C                   PARM                    DDCUST
279500200529      ** Deal type
279600200529     C                   PARM                    DDTYPE
279700200529      ** Federal Funds Ind.
279800200529     C                   PARM                    DDFEDF
279900200529      ** Booking Branch
280000200529     C                   PARM                    DDBrCA
280100200529      ** Receipt Date
280200200529     C                   PARM                    RecDat
280300200529      ** Payment Date
280400200529     C                   PARM                    Paydat
280500200529      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
280600200529     C                   PARM                    InPaySttmt
280700200529     C                   PARM                    InRecSttmt
280800200529     C                   PARM                    InFRASttmt
280900200529      * Action Code
281000200529     C                   PARM                    DDACTN
281100200529      * Protect Payment Field
281200200529     C                   PARM                    ##PPAY            1
281300200529      * Protect Receipt Field
281400200529     C                   PARM                    ##PREC            1
281500200529
281600200529      ** Following parameters are returned by called module
281700200529      ** Payment Instruction OK flag
281800200529     C                   PARM                    OKPayInsDS
281900200529      ** Receive Instruction OK flag
282000200529     C                   PARM                    OKRecInsDS
282100200529      ** FRA/IRS Instruction OK flag
282200200529     C                   PARM                    OKFRAInsDS
282300200529      * Error fields/message IDs (arrays) from/to caller
282400200529     C                   PARM                    FldNameArr
282500200529     C                   PARM                    MsgIDArr
282600200529      * Array index (3P0) from/to caller
282700200529     C                   PARM                    Idx
282800200529      ** Warning fields/message IDs/message data (arrays) from/to caller
282900200529     C                   PARM                    WFldNamArr
283000200529     C                   PARM                    WMsgIDArr
283100200529     C                   PARM                    WMsgDtaArr
283200200529      ** Array index (3P0) from/to caller
283300200529     C                   PARM                    WIdx
283400200529      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
283500200529     C                   PARM                    DBPaySttmt
283600200529     C                   PARM                    DBRecSttmt
283700200529     C                   PARM                    DBFRASttmt
283800200529      ** Extra Input
283900200529      ** Action Code used
284000200529     C                   PARM      DDACTN        ##ACTN            1
284100200529      ** Validation Iteration
284200200529     C                   PARM      '1ST'         ##ValIter         3
284300200529      *                                                                                     MD039547
284400200529      ** Call account referred validation.                                                  MD039547
284500200529      *                                                                                     MD039547
284600200529     C                   CALL      'ZASETINVL2'                                             MD039547
284700200529     C                   PARM                    ReturnCode                                 MD039547
284800200529     C                   PARM                    LDNI                                       MD039547
284900200529     C                   PARM                    DDCCY                                      MD039547
285000200529     C                   PARM                    DDCCY                                      MD039547
285100200529     C                   PARM                    DDCUST                                     MD039547
285200200529     C                   PARM                    DDBRCA                                     MD039547
285300200529     C                   PARM                    InPaySttmt                                 MD039547
285400200529     C                   PARM                    InRecSttmt                                 MD039547
285500200529     C                   PARM                    DDACTN                                     MD039547
285600200529     C                   PARM                    ##PPAY                                     MD039547
285700200529     C                   PARM                    ##PREC                                     MD039547
285800200529     C                   PARM                    OKPayInsDS                                 MD039547
285900200529     C                   PARM                    OKRecInsDS                                 MD039547
286000200529     C                   PARM                    FldNameArr                                 MD039547
286100200529     C                   PARM                    MsgIDArr                                   MD039547
286200200529     C                   PARM                    Idx                                        MD039547
286300200529     C                   PARM                    WFldNamArr                                 MD039547
286400200529     C                   PARM                    WMsgIdArr                                  MD039547
286500200529     C                   PARM                    WMsgDtaArr                                 MD039547
286600200529     C                   PARM                    WIdx                                       MD039547
286700200529                                                                                              CDL018
286800200529      ** Validate Further Settlement Instructions                                             CDL018
286900200529                                                                                              CDL018
287000200529     C     CDL018        IFEQ      'Y'                                                        CDL018
287100200529     C     Idx           ANDEQ     0                                                          CDL018
287200200529      *                                                                                       CDL018
287300200529     C     DDTYPE        IFEQ      'IT'                                                       CDL018
287400200529     C     DDTYPE        OREQ      'IP'                                                       CDL018
287500200529     C     DDTYPE        OREQ      'TD'                                                       CDL018
287600200529     C     DDTYPE        OREQ      'TI'                                                       CDL018
287700200529      *                                                                                       CDL018
287800200529     C     DDRMAC        IFEQ      'Y'                                                        CDL018
287900200529     C     DDPMAC        OREQ      'Y'                                                        CDL018
288000200529      *                                                                                       CDL018
288100200529     C                   CALLB     'ZAFSETIVAL'                                               CDL018
288200200529      *                                                                                       CDL018
288300200529      ** INPUTS                                                                               CDL018
288400200529      ** Return Code                                                                          CDL018
288500200529     C                   PARM      *BLANKS       ReturnCode                                   CDL018
288600200529      *                                                                                       CDL018
288700200529      ** Calling program                                                                      CDL018
288800200529     C                   PARM                    LDNI                                         CDL018
288900200529      *                                                                                       CDL018
289000200529      ** Payment currency                                                                     CDL018
289100200529     C                   PARM                    DDCCY                                        CDL018
289200200529      *                                                                                       CDL018
289300200529      ** Receive currency                                                                     CDL018
289400200529     C                   PARM                    DDCCY                                        CDL018
289500200529      *                                                                                       CDL018
289600200529      ** Transaction Type                                                                     CDL018
289700200529     C                   PARM                    DDTYPE                                       CDL018
289800200529      *                                                                                       CDL018
289900200529      ** Booking branch                                                                       CDL018
290000200529     C                   PARM                    DDBrCA                                       CDL018
290100200529      *                                                                                       CDL018
290200200529      ** Receipt Date                                                                         CDL018
290300200529      ** (must = 99999 if no back valuation validation to be done)                            CDL018
290400200529     C                   PARM                    RecDat                                       CDL018
290500200529      *                                                                                       CDL018
290600200529      ** Payment Date                                                                         CDL018
290700200529      ** (must = 99999 if no back valuation validation to be done)                            CDL018
290800200529     C                   PARM                    Paydat                                       CDL018
290900200529      *                                                                                       CDL018
291000200529      ** Payment - Settle instructions - Screen format                                        CDL018
291100200529     C                   PARM                    InPaySttmt                                   CDL018
291200200529      *                                                                                       CDL018
291300200529      ** Receive - Settle instructions - Screen format                                        CDL018
291400200529     C                   PARM                    InRecSttmt                                   CDL018
291500200529      *                                                                                       CDL018
291600200529      ** Payment - Further Settle instructions - Screen format                                CDL018
291700200529     C                   PARM                    #FPAYS                                       CDL018
291800200529      *                                                                                       CDL018
291900200529      ** Receive - Further Settle instructions - Screen format                                CDL018
292000200529     C                   PARM                    #FRECS                                       CDL018
292100200529      *                                                                                       CDL018
292200200529      ** Action Code                                                                          CDL018
292300200529     C                   PARM                    ##ACTN                                       CDL018
292400200529      *                                                                                       CDL018
292500200529      ** Protect Payment Field                                                                CDL018
292600200529     C                   PARM                    ##PPAY                                       CDL018
292700200529      *                                                                                       CDL018
292800200529      ** Protect Receipt Field                                                                CDL018
292900200529     C                   PARM                    ##PREC                                       CDL018
293000200529      *                                                                                       CDL018
293100200529      ** LDNI Deal details                                                                    CDL018
293200200529     C                   PARM                    ValidDeal                                    CDL018
293300200529      *                                                                                       CDL018
293400200529      ** OUTPUTS                                                                              CDL018
293500200529      ** Errors in Payment further settle instructions                                        CDL018
293600200529     C                   PARM                    #FPAYE                                       CDL018
293700200529      *                                                                                       CDL018
293800200529      ** Errors in Receive further settle instructions                                        CDL018
293900200529     C                   PARM                    #FRECE                                       CDL018
294000200529      *                                                                                       CDL018
294100200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CDL018
294200200529     C                   PARM                    FldNameArr                                   CDL018
294300200529     C                   PARM                    MsgIDArr                                     CDL018
294400200529      *                                                                                       CDL018
294500200529      ** Array index (3P0) from/to caller                                                     CDL018
294600200529     C                   PARM                    Idx                                          CDL018
294700200529      *                                                                                       CDL018
294800200529      ** Warning Messages                                                                     CDL018
294900200529     C                   PARM                    WFldNamArr                                   CDL018
295000200529     C                   PARM                    WMsgIDArr                                    CDL018
295100200529     C                   PARM                    WMsgDtaArr                                   CDL018
295200200529     C                   PARM                    WIdx                                         CDL018
295300200529      *                                                                                       CDL018
295400200529      ** Payment - Further Settle instructions - File format                                  CDL018
295500200529     C                   PARM                    #FPAYF                                       CDL018
295600200529      *                                                                                       CDL018
295700200529      ** Receive - Further Settle instructions - File format                                  CDL018
295800200529     C                   PARM                    #FRECF                                       CDL018
295900200529      *                                                                                       CDL018
296000200529     C                   ELSE                                                                BUG4380
296100200529     C                   CLEAR                   #FPAYS                                      BUG4380
296200200529     C                   CLEAR                   #FRECS                                      BUG4380
296300200529     C                   ENDIF                                                                CDL018
296400200529     C                   ENDIF                                                                CDL018
296500200529     C                   ENDIF                                                                CDL018
296600200529
296700200529     C     ValSetExit    TAG
296800200529
296900200529     C                   ENDSR
297000200529      *****************************************************************
297100200529      /EJECT
297200200529      *****************************************************************
297300200529      *                                                               *
297400200529      * TDtDtaSubs - Transaction Details Data Substitution            *
297500200529      *                                                               *
297600200529      *****************************************************************
297700200529
297800200529     C     TDtDtaSubs    BEGSR
297900200529
298000200529      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
298100200529
298200200529     C                   RESET                   ReturnCode
298300200529     C                   CALLB     'MMLDNICVT'
298400200529
298500200529      * INPUTS
298600200529      * Return Code
298700200529     C                   PARM                    ReturnCode
298800200529      * (Current) Deal in file format
298900200529     C                   PARM                    DealFilfmt
299000200529
299100200529     C                   PARM                    DDAPRC            1                        MD054028
299200200529     C                   PARM                    DDAPRR            8                        MD054028
299300200529      * OUTPUTS
299400200529      * (Current) Deal in screen format
299500200529     C                   PARM                    DealScnfmt
299600200529      * Deal Status
299700200529     C                   PARM                    DDSTS
299800200529      *
299900200529      ** Collateral Status
300000200529     C                   PARM                    DDCSTS           10
300100200529
300200200529     C                   MOVE      DDAPRC        @DDAPRC           1                        MD054028
300300200529     C                   MOVE      DDAPRR        @DDAPRR           8                        MD054028
300400200529      ** DATA SUBSTITUTION
300500200529
300600200529     C                   RESET                   ReturnCode
300700200529     C                   CALLB     'APDTASUBS'
300800200529
300900200529      * Return Code
301000200529     C                   PARM                    ReturnCode       10
301100200529      * Substitution character
301200200529     C                   PARM      GHSUBS        SubsChar          1
301300200529      * Incoming Data
301400200529     C                   PARM      TranIn        IncDATA        2000
301500200529      * Current Data
301600200529     C                   PARM      DealScnfmt    CurDATA        2000
301700200529
301800200529     C                   MOVEL     IncDATA       TranIn
301900200529
302000200529     C                   ENDSR
302100200529      *****************************************************************
302200200529      /EJECT
302300200529      *****************************************************************
302400200529      *                                                               *
302500200529      * SDtDtaSubs - Settlement Details Data Substitution             *
302600200529      *                                                               *
302700200529      *****************************************************************
302800200529
302900200529     C     SDtDtaSubs    BEGSR
303000200529
303100200529      ** PAYMENT INSTRUCTIONS
303200200529     C                   RESET                   ReturnCode
303300200529     C                   CALLB     'APDTASUBS'
303400200529
303500200529      * Return Code
303600200529     C                   PARM                    ReturnCode
303700200529      * Substitution character
303800200529     C                   PARM      GHSUBS        SubsChar
303900200529      * Incoming Data
304000200529     C                   PARM      InPaySttmt    IncDATA
304100200529      * Current Data
304200200529     C                   PARM      CrPaySttmt    CurDATA
304300200529
304400200529     C                   MOVEL     IncDATA       InPaySttmt
304500200529
304600200529      ** RECEIPT INSTRUCTIONS
304700200529     C                   RESET                   ReturnCode
304800200529     C                   CALLB     'APDTASUBS'
304900200529
305000200529      * Return Code
305100200529     C                   PARM                    ReturnCode
305200200529      * Substitution character
305300200529     C                   PARM      GHSUBS        SubsChar
305400200529      * Incoming Data
305500200529     C                   PARM      InRecSttmt    IncDATA
305600200529      * Current Data
305700200529     C                   PARM      CrRecSttmt    CurDATA
305800200529
305900200529     C                   MOVEL     IncDATA       InRecSttmt
306000200529
306100200529     C                   ENDSR
306200200529      *****************************************************************
306300200529      /EJECT
306400200529      *****************************************************************
306500200529      *                                                               *
306600200529      * ValdateAmd - Routine to check whether the fields amended      *
306700200529      *    are amendable.                                             *
306800200529      *                                                               *
306900200529      *****************************************************************
307000200529
307100200529     C     ValdateAmd    BEGSR
307200200529
307300200529      ** This subroutine calls a procedure which checks whether it
307400200529      ** was valid to amend any of the fields which have been
307500200529      ** changed.  Some are never amendable and some depend upon ICD
307600200529      ** settings as to whether they are amendable.
307700200529
307800200529      ** To determine what fields have changed, the current fields
307900200529      ** on file must be converted to a 'screen' format.
308000200529
308100200529      ** These fields are then compared with the fields on the input
308200200529      ** transaction.
308300200529
308400200529      ** Any errors detected by the called procedure take precedence
308500200529      ** over any errors found during the validation of the complete
308600200529      ** transaction.  The errors from the called procedure are kept
308700200529      ** separately and, if any are found, these errors will REPLACE
308800200529      ** the normal validation errors.
308900200529
309000200529      * Convert file format to screen format
309100200529
309200200529     C                   RESET                   ReturnCode
309300200529     C                   IF        CER050 = 'Y'                                             MD054028
309400200529     C                   MOVE      DDAPRC        HKAPRC                                     MD054028
309500200529     C                   MOVE      DDAPRC        IKAPRC                                     MD054028
309600200529     C                   ENDIF                                                              MD054028
309700200529     C                   CALLB     'MMLDNICVT'
309800200529
309900200529      * INPUTS
310000200529      * Return Code
310100200529     C                   PARM                    ReturnCode
310200200529      * (Current) Deal in file format
310300200529     C                   PARM                    DealFilfmt
310400200529
310500200529     C                   PARM                    DDAPRC            1                        MD054028
310600200529     C                   PARM                    DDAPRR            8                        MD054028
310700200529      * OUTPUTS
310800200529      * (Current) Deal in screen format
310900200529     C                   PARM                    DealScnfmt
311000200529      * Deal Status
311100200529     C                   PARM                    DDSTS            24
311200200529      *
311300200529      ** Collateral Status
311400200529     C                   PARM                    DDCSTS           10
311500200529
311600200529     C                   MOVE      DDAPRC        @DDAPRC                                    MD054028
311700200529     C                   MOVE      DDAPRR        @DDAPRR                                    MD054028
311800200529      ** AMEND CHECKING
311900200529     C                   RESET                   ReturnCode
312000200529     C                   CALLB     'MMLDNIAMD'
312100200529
312200200529      * INPUTS
312300200529      * Return Code
312400200529     C                   PARM                    ReturnCode
312500200529      * New Deal in Screen Format (Incoming Transaction)
312600200529     C                   PARM                    TranIn
312700200529      * (Current) Deal in Screen Format
312800200529     C                   PARM                    DealScnfmt
312900200529      * (Current) Deal in file format
313000200529     C                   PARM                    DealFilfmt
313100200529
313200200529      * OUTPUTS
313300200529      * Field OK flags (DS) from/to caller
313400200529     C                   PARM                    MMELDN
313500200529      * Error fields/message IDs/message data (arrays) from/to caller
313600200529     C                   PARM                    AmFldNamAr
313700200529     C                   PARM                    AmMsgIdArr
313800200529     C                   PARM                    AmMsgDtaAr
313900200529      * Array index (3P0) from/to caller
314000200529     C                   PARM                    AmIdx
314100200529      * Amendments OK
314200200529     C                   PARM                    AmendOk           1
314300200529      * Reset of Fields in Error Required (Y/N)
314400200529     C                   PARM      'Y'           ResetErrs         1                          CDL038
314500200529     C*******************PARM      'N'           ResetErrs         1                          CDL038
314600200529
314700200529      ** If any errors overwrite previous error information
314800200529
314900200529     C                   IF        AmIdx <> 0
315000200529     C                   MOVEA     AmMsgIdArr    MsgidArr
315100200529     C                   MOVEA     AmFldNamAr    FldNameArr
315200200529     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
315300200529     C                   Z-ADD     AmIdx         Idx
315400200529     C                   ENDIF
315500200529
315600200529     C                   ENDSR
315700200529      *****************************************************************
315800200529      /EJECT
315900200529      *****************************************************************
316000200529     C     WriteToDB     BEGSR
316100200529
316200200529     C                   IF        DDACTN = 'I'
316300200529     C                   EXSR      SETUPDEALN
316400200529     C                   ENDIF
316500200529
316600200529     C                   EXSR      SETUPVALID
316700200529     C                   EXSR      UpdateDB
316800200529
316900200529     C                   ENDSR
317000200529      *****************************************************************
317100200529      /EJECT
317200200529      *****************************************************************
317300200529      *                                                               *
317400200529      * UPDATEDB - Update Database                                    *
317500200529      *                                                               *
317600200529      *****************************************************************
317700200529
317800200529     C     UPDATEDB      BEGSR
317900200529      *                                                                                       CDL016
318000200529      * Update Valid Deal: Blocked Indicator                                                  CDL016
318100200529      *                                                                                       CDL016
318200200529     C     CDL016        IFEQ      'Y'                                                        CDL016
318300200529      *                                                                                       CDL016
318400200529     C     BUACT         IFEQ      'B'                                                        CDL016
318500200529     C                   MOVE      'Y'           IKBLKA                                       CDL016
318600200529     C                   ENDIF                                                                CDL016
318700200529      *                                                                                       CDL016
318800200529     C     BUACT         IFEQ      'U'                                                        CDL016
318900200529     C     DDACTN        OREQ      'I'                                                        CDL016
319000200529     C                   MOVE      'N'           IKBLKA                                       CDL016
319100200529     C                   ENDIF                                                                CDL016
319200200529      *                                                                                       CDL016
319300200529     C                   ENDIF                                                                CDL016
319400200529      *
319500200529      * Money Market updates
319600200529      *
319700200529      * Setup parameters for Block, Unblock action.                                          BUG4097
319800200529      * Borrow the return code parameter to send the Block, Unblock condition.               BUG4097
319900200529     C                   MOVE      *BLANKS       @RTCD                                       BUG4097
320000200529     C     DDACTC        IFEQ      'B'                                                       BUG4097
320100200529     C                   MOVE      'BLOCK  '     @RTCD                                       BUG4097
320200200529     C                   END                                                                 BUG4097
320300200529     C     DDACTC        IFEQ      'U'                                                       BUG4097
320400200529     C                   MOVE      'UNBLOCK'     @RTCD                                       BUG4097
320500200529     C                   END                                                                 BUG4097
320600200529      *                                                                                      BUG4097
320700200529     C                   CALLB     'MMLDNIUPM'
320800200529     C**********         PARM      *BLANK        @RTCD             7                         BUG4097
320900200529     C                   PARM                    @RTCD             7                         BUG4097
321000200529     C                   PARM                    ValidDeal
321100200529     C                   PARM                    #FPAYF                                       CDL018
321200200529     C                   PARM                    #FRECF                                       CDL018
321300200529      ** FRCD Issued Extension details before update                                          256638
321400200529     C                   PARM                    PBFRCD          100                          256638
321500200529      ** FRCD Issued Extension details after update                                           256638
321600200529     C                   PARM                    PAFRCD          100                          256638
321700200529     C                   PARM                    TranQExt                                     CER049
321800200529      *                                                                                       256638
321900200529     C/COPY WNCPYSRC,MMLDNIXC05
322000200529      *
322100200529      * Deals updates
322200200529      *
322300200529     C     @RTCD         IFEQ      *BLANK
322400200529     C                   CALLB     'MMLDNIUPD'
322500200529     C                   PARM                    @RTCD
322600200529     C                   PARM                    ValidDeal
322700200529     C                   PARM                    #FPAYF                                     AR863263
322800200529     C                   PARM                    #FRECF                                     AR863263
322900200529     C                   PARM                    PBFRCD                                     AR863263
323000200529     C                   PARM                    PAFRCD                                     AR863263
323100200529     C                   END
323200200529      *                                                                                       CDL018
323300200529      * Further Settlement Instructions updates                                               CDL018
323400200529      *                                                                                       CDL018
323500200529     C     CDL018        IFEQ      'Y'                                                        CDL018
323600200529     C     @RTCD         ANDEQ     *BLANK                                                     CDL018
323700200529     C     DDACTN        IFEQ      'I'                                                       BUG3869
323800200529     C     DDACTN        OREQ      'A'                                                       BUG3869
323900200529     C                   CALLB     'ZAFSETIUPD'                                               CDL018
324000200529     C                   PARM                    @RTCD                                        CDL018
324100200529     C                   PARM                    DDDLNO                                       CDL018
324200200529     C**********         PARM                    FLRMAC                               CDL018 BUG3869
324300200529     C**********         PARM                    FLPMAC                               CDL018 BUG3869
324400200529     C                   PARM                    IKRMAC                                      BUG3869
324500200529     C                   PARM                    IKPMAC                                      BUG3869
324600200529     C                   PARM                    #FPAYF                                       CDL018
324700200529     C                   PARM                    #FRECF                                       CDL018
324800200529     C                   ENDIF                                                               BUG3869
324900200529     C                   ENDIF                                                                CDL018
325000200529      *                                                                                       CER001
325100200529      ** Update LUX extension detail file                                                     CER001
325200200529      *                                                                                       CER001
325300200529     C                   IF        @RTCD = *Blanks and                                        CER001
325400200529     C                             ULX600 = 'Y'                                               CER001
325500200529     C                   EVAL      #6LXVLDN38 = IKDN38                                        CER001
325600200529     C                   CALLB     'MMLDNI2UP'                                                CER001
325700200529     C                   PARM      DDACTN        ACTN                                         CER001
325800200529     C                   PARM                    @RTCD                                        CER001
325900200529     C                   PARM      'Y'           WFIND                                        CER001
326000200529     C                   PARM                    ValidLUX                                     CER001
326100200529     C                   PARM                    SVRCD                                        CER001
326200200529     C                   ENDIF                                                                CER001
326300200529                                                                                             BUG9827
326400200529     C                   IF        CDL006 = 'Y' and DDACTN <> 'A'                            BUG9827
326500200529     C                   IF        DDTYPE = 'FL' or DDTYPE = 'DP' or                         BUG9827
326600200529     C                             DDTYPE = 'LP'                                             BUG9827
326700200529     C**********         IF        HKDSTS <> 'R'                                    BUG9827 BUG10677
326800200529      * Only delete/authorise associated takings if status is not 'R' or 'A'                BUG10677
326900200529      * else could be left could be with outstanding records on WIP file.                   BUG10677
327000200529     C                   IF        HKDSTS <> 'R' and HKDSTS <> 'A'                          BUG10677
327100200529     C                   EXSR      SupFIDT                                                   BUG9827
327200200529     C                   ENDIF                                                               BUG9827
327300200529     C                   ENDIF                                                               BUG9827
327400200529     C                   ENDIF                                                               BUG9827
327500200529      *
327600200529      * If there were any errors in the update functions, rollback any
327700200529      * updates (done in *PSSR) and end this program. Otherwise commit.
327800200529     C     @RTCD         IFNE      *BLANK
327900200529     C**** @RTCD         ANDNE     '*RECUPD'                                                  248297
328000200529     C**********         MOVEL     '0'           APIRetc                                    AR751620
328100200529     C                   IF        (CSC022 = 'N')                                             CSC022
328200200529     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
328300200529     C                   ROLBK
328400200529     C                   ENDIF                                                                CSC022
328500200529     C     @RTCD         IFNE      '*RECUPD'                                                AR751620
328600200529     C                   MOVEL     '0'           APIRetc                                    AR751620
328700200529     C                   EXSR      *PSSR
328800200529     C                   ENDIF                                                              AR751620
328900200529     C                   ELSE
329000200529     C                   IF        (CSC022 = 'N')                                             CSC022
329100200529     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
329200200529     C                   COMMIT
329300200529     C                   ENDIF                                                                CSC022
329400200529     C                   END
329500200529      *
329600200529      ** If update not done due to record being updated by another
329700200529      *  workstation send message to screen.
329800200529     C
329900200529     C     @RTCD         IFEQ      '*RECUPD'
330000200529     C
330100200529     C                   ADD       1             Idx                                        AR751620
330200200529     C                   MOVEL     '*ANY'        FldNameArr(1)
330300200529     C**********         MOVEL     'MMM1067'     MsgIdArr(1)                                AR751620
330400200529     C                   MOVEL     'MMM1099'     MsgIdArr(1)                                AR751620
330500200529     C
330600200529     C                   END
330700200529
330800200529     C                   ENDSR
330900200529      *****************************************************************
331000200529      /EJECT
331100200529      *****************************************************************
331200200529      *                                                               *
331300200529      * RESETCYCLE- Reset error information that is gradually         *
331400200529      *    updated during each run of this program                    *
331500200529      *                                                               *
331600200529      *****************************************************************
331700200529
331800200529     C     RESETCYCLE    BEGSR
331900200529
332000200529     C                   RESET                   FldNameArr
332100200529     C                   RESET                   MsgIDArr
332200200529     C                   RESET                   MsgDtaArr
332300200529     C                   RESET                   Idx
332400200529
332500200529     C                   RESET                   WFldNamArr
332600200529     C                   RESET                   WMsgIDArr
332700200529     C                   RESET                   WMsgDtaArr
332800200529     C                   RESET                   WIdx
332900200529
333000200529     C                   RESET                   AmFldNamAr
333100200529     C                   RESET                   AmMsgIDArr
333200200529     C                   RESET                   AmMsgDtaAr
333300200529     C                   RESET                   AmIdx
333400200529
333500200529     C                   RESET                   FldNoArr
333600200529
333700200529     C                   MOVE      *ALL'Y'       MMELDN
333800200529     C                   MOVE      *ALL'Y'       MMELDN2                                     BUG5169
333900200529
334000200529     C                   RESET                   AmendOK
334100200529
334200200529     C                   RESET                   OKPayInsDS
334300200529     C                   RESET                   OKRecInsDS
334400200529     C                   RESET                   OKFRAInsDS
334500200529
334600200529     C                   RESET                   PayDat
334700200529     C                   RESET                   RecDat
334800200529
334900200529     C                   CLEAR                   ValidDeal
335000200529      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
335100200529      ** there are long alpha fileds overlapping these which cause the
335200200529      ** CLEAR to put blanks in the numeric fields
335300200529     C                   Z-ADD     *ZERO         IKRSTM
335400200529     C**********         Z-ADD     *ZERO         IKROBN                                       CSD027
335500200529     C**********         Z-ADD     *ZERO         IKROCN                                       CSD027
335600200529     C                   EVAL      IKROBN = *BLANKS                                           CSD027
335700200529     C                   EVAL      IKROCN = *BLANKS                                           CSD027
335800200529     C                   Z-ADD     *ZERO         IKPSTM
335900200529     C**********         Z-ADD     *ZERO         IKPOBN                                       CSD027
336000200529     C**********         Z-ADD     *ZERO         IKPOCN                                       CSD027
336100200529     C                   EVAL      IKPOBN = *BLANKS                                           CSD027
336200200529     C                   EVAL      IKPOCN = *BLANKS                                           CSD027
336300200529     C                   Z-ADD     *ZERO         IKOMDT
336400200529
336500200529      ** Have to clear the settlement data structure, or the packed numeric
336600200529      ** fields are not initialised correctly.
336700200529     C                   CLEAR                   DBPaySttmt
336800200529     C                   CLEAR                   DBRecSttmt
336900200529     C                   CLEAR                   DBFRASttmt
337000200529
337100200529      ** Initalise Customer name on Input fields                                             CSF011A
337200200529                                                                                             CSF011A
337300200529     C                   EVAL      DDCRSN = *BLANKS                                          CSF011A
337400200529     C                   EVAL      DDCRNM = *BLANKS                                          CSF011A
337500200529     C                   EVAL      DDCRTN = *BLANKS                                          CSF011A
337600200529     C                   EVAL      DDIASN = *BLANKS                                          CSF011A
337700200529     C                   EVAL      DDIANM = *BLANKS                                          CSF011A
337800200529     C                   EVAL      DDIATN = *BLANKS                                          CSF011A
337900200529     C                   EVAL      DDIAAN = *BLANKS                                          CSF011A
338000200529     C                   EVAL      DDIASW = *BLANKS                                          CSF011A
338100200529     C                   EVAL      DDINSN = *BLANKS                                          CSF011A
338200200529     C                   EVAL      DDINNM = *BLANKS                                          CSF011A
338300200529     C                   EVAL      DDINTN = *BLANKS                                          CSF011A
338400200529     C                   EVAL      DDINSW = *BLANKS                                          CSF011A
338500200529     C                   EVAL      DDCDSN = *BLANKS                                          CSF011A
338600200529     C                   EVAL      DDCDNM = *BLANKS                                          CSF011A
338700200529     C                   EVAL      DDCDTN = *BLANKS                                          CSF011A
338800200529                                                                                             CSF011A
338900200529     C                   ENDSR
339000200529      *****************************************************************
339100200529      /EJECT
339200200529      *****************************************************************
339300200529      *                                                               *
339400200529      * SETUPDEALN - Set up Deal Number for Inserts                   *
339500200529      *                                                               *
339600200529      *****************************************************************
339700200529
339800200529     C     SETUPDEALN    BEGSR
339900200529
340000200529      ** For Fixed Loan/Deposit get next deal number from the                                BUG4068
340100200529      ** fixed loan/deposit deal number range if set up.                                     BUG4068
340200200529                                                                                             BUG4068
340300200529     C     CDL016        IFEQ      'Y'                                                       BUG4068
340400200529                                                                                             BUG4068
340500200529     C     DDDLNO        IFEQ      *blanks                                                   BUG4068
340600200529     C     DDDLNO        OREQ      *zeros                                                    BUG4068
340700200529                                                                                             BUG4068
340800200529     C     DDTYPE        IFEQ      'TD'                                                      BUG4068
340900200529     C     DDTYPE        OREQ      'TI'                                                      BUG4068
341000200529     C     DDTYPE        OREQ      'IT'                                                      BUG4068
341100200529     C     DDTYPE        OREQ      'IP'                                                      BUG4068
341200200529                                                                                             BUG4068
341300200529      ** Lock the deal no. record in SDFDDRL0 so that other users do                         BUG4068
341400200529      ** not update it.                                                                      BUG4068
341500200529     C     KFDDR         KLIST                                                               BUG4068
341600200529     C                   KFLD                    DDBRCA                                      BUG4068
341700200529     C                   KFLD                    DDTYPE                                      BUG4068
341800200529                                                                                             BUG4068
341900200529     C     KFDDR         CHAIN     SDFDDRL0                           22                     BUG4068
342000200529                                                                                             BUG4068
342100200529     C     *IN22         IFEQ      '0'                                                       BUG4068
342200200529     C                   MOVE      MMCU          @NEWDL            6 0                       BUG4068
342300200529     C                   SETOFF                                       65                     BUG4068
342400200529                                                                                             BUG4068
342500200529     C     *IN65         DOUEQ     '1'                                                       BUG4068
342600200529     C*****@NEWDL        CHAIN     MMDEALLL                           65            BUG4068 AR665113
342700200529     C     @NEWDL        CHAIN     DEALSALL                           65                    AR665113
342800200529                                                                                            AR665113
342900200529     C                   IF        *IN65 = '1'                                              AR665113
343000200529     C     @NEWDL        CHAIN     DEALSCL1                           65                    AR665113
343100200529     C                   ENDIF                                                              AR665113
343200200529                                                                                             BUG4068
343300200529     C     *IN65         IFEQ      '0'                                                       BUG4068
343400200529     C                   ADD       1             @NEWDL                                      BUG4068
343500200529     C                   ELSE                                                                BUG4068
343600200529     C     @NEWDL        IFGT      MMLS                                                      BUG4068
343700200529     C                   Z-ADD     MMIN          @NEWDL                                      BUG4068
343800200529     C                   SETOFF                                       65                     BUG4068
343900200529     C                   ELSE                                                                BUG4068
344000200529     C                   Z-ADD     @NEWDL        MMCU                                        BUG4068
344100200529     C                   ENDIF                                                               BUG4068
344200200529     C                   ENDIF                                                               BUG4068
344300200529                                                                                             BUG4068
344400200529     C                   ENDDO                                                               BUG4068
344500200529     C                   MOVE      MMCU          DDDLNO                                      BUG4068
344600200529     C                   UPDATE    SDFDDRD0                                                  BUG4068
344700200529     C                   ENDIF                                                               BUG4068
344800200529                                                                                             BUG4068
344900200529     C                   ENDIF                                                               BUG4068
345000200529     C                   ENDIF                                                               BUG4068
345100200529     C                   ENDIF                                                               BUG4068
345200200529      *                                                                                      BUG4068
345300200529     C                   IF           DDDLNO = *blanks
345400200529     C                             OR DDDLNO = *zeros
345500200529
345600200529     C                   RESET                   ReturnCode
345700200529     C                   CALLB     'CAGETNXTDL'
345800200529     C                   PARM                    ReturnCode
345900200529     C                   PARM                    MSG1
346000200529     C                   PARM                    DDDLNO
346100200529     C                   PARM      *ZEROS        IKDN38
346200200529
346300200529     C     MSG1          IFNE      *BLANK
346400200529     C                   ADD       1             Idx
346500200529     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
346600200529     C                   EVAL      MsgIDArr(Idx) = MSG1
346700200529     C                   ENDIF
346800200529
346900200529      ** Use the return code's value to set the field's OK flag
347000200529     C                   CALLB     'ZASETOKFLG'
347100200529     C                   PARM                    OKDLNO
347200200529     C                   PARM                    ReturnCode
347300200529     C                   PARM                    WarnGlobal
347400200529
347500200529      ** If deal number was entered, put it in the file field
347600200529     C                   ELSE
347700200529     C                   MOVE      DDDLNO        IKDN38
347800200529
347900200529     C                   ENDIF
348000200529      *                                                                                       CER001
348100200529     C                   IF        DDDRID <> ' ' AND DDDDMR = *BLANKS                         CAP087
348200200529     C                   MOVE      IKDN38        IKDDMR                                       CAP087
348300200529     C                   ENDIF                                                                CAP087
348400200529                                                                                              CAP087
348500200529      ** Pass Deal Number to Update Program of extension file (MMLDNI2UP)                     CER001
348600200529      *                                                                                       CER001
348700200529     C                   IF        ULX600 = 'Y'                                               CER001
348800200529     C                   MOVE      DDDLNO        #6LXVLDN38                                   CER001
348900200529     C                   ENDIF
349000200529
349100200529     C                   ENDSR
349200200529      *****************************************************************
349300200529      /EJECT
349400200529      *****************************************************************
349500200529      *                                                               *
349600200529      * SetupDDAT - Default Midas rundate as Deal Date.               *
349700200529      *                                                               *
349800200529      *****************************************************************
349900200529
350000200529     C     SetupDDAT     BEGSR
350100200529
350200200529      *
350300200529      ** Convert day number to YYYYMMDD format
350400200529      *
350500200529     C                   EVAL      @@DAYN = BJRDNB
350600200529     C                   CALLB     'ZDATE9'
350700200529     C                   PARM                    @@DAYN
350800200529     C                   PARM                    DateOut
350900200529     C                   PARM                    @@RETC           10
351000200529
351100200529      *
351200200529      ** ZDATE9 assigns a value of '0' for non-zero/non-negative date
351300200529      ** so test it here. Otherwise, value of '1' returns (if so just
351400200529      ** default a blank deal date on the screen).
351500200529      *
351600200529     C                   IF        @@RETC = '0'
351700200529     C                   EVAL      @@DTIN = DateOut
351800200529     C                   CALLB     'ZA0770'
351900200529     C                   PARM                    @@RETC
352000200529     C                   PARM                    @@DTIN
352100200529     C                   PARM                    BJDFIN
352200200529     C                   PARM      *ZERO         @@DTOU            6 0
352300200529     C                   MOVEL     @@DTOU        DDDLDT
352400200529     C                   ELSE
352500200529     C                   MOVEL     *BLANK        DDDLDT
352600200529     C                   ENDIF
352700200529
352800200529     C                   ENDSR
352900200529      *****************************************************************
353000200529      /EJECT
353100200529      *****************************************************************
353200200529      *                                                               *
353300200529      * SETUPVALID - Set up additional fields that are needed on the  *
353400200529      *    Valid file record.                                         *
353500200529      *                                                               *
353600200529      *****************************************************************
353700200529
353800200529     C     SETUPVALID    BEGSR
353900200529
354000200529      * For Inserts and Amends, put the Settlement Instructions (input or
354100200529      * defaulted) into the Valid file record.
354200200529      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
354300200529      * in contiguous areas, which must be placed into the correct parts
354400200529      * of the Valid file record
354500200529     C                   IF        DDACTN = 'I'
354600200529     C                             OR (DDACTN = 'A')
354700200529     C**********         MOVEL     DBPaySttmt    LDNIPayIns                                   CGL029
354800200529     C**********         MOVEL     DBRecSttmt    LDNIRecIns                                   CGL029
354900200529     C                   MOVEL     FLRSTM        IKRSTM                                       CGL029
355000200529     C                   MOVEL     FLRONS        IKRONS                                       CGL029
355100200529     C                   MOVEL     FLRMAC        IKRMAC                                       CDL018
355200200529     C                   MOVEL     FLREC2        LDNIRecIns                                   CGL029
355300200529     C                   MOVEL     FLPSTM        IKPSTM                                       CGL029
355400200529     C                   MOVEL     FLPONS        IKPONS                                       CGL029
355500200529     C                   MOVEL     FLPAY2        LDNIPayIns                                   CGL029
355600200529     C                   MOVE      FLPOBR        IKPOBR
355700200529     C                   MOVE      FLROBR        IKROBR
355800200529     C                   MOVE      FLCVMR        IKCVMR
355900200529     C                   MOVE      FLPSCY        IKSTCY
356000200529     C                   MOVE      FLIC72        IKIC72
356100200529     C                   MOVEL     FLPMAC        IKPMAC                                       CDL018
356200200529     C                   MOVEL     FLRBB1        IKRBB1                                       CDL094
356300200529     C                   MOVEL     FLRBB2        IKRBB2                                       CDL094
356400200529     C                   MOVEL     FLRBB3        IKRBB3                                       CDL094
356500200529     C                   MOVEL     FLRBB4        IKRBB4                                       CDL094
356600200529     C                   MOVEL     FLRBB5        IKRBB5                                       CDL094
356700200529     C                   MOVEL     FLRBB6        IKRBB6                                       CDL094
356800200529     C
356900200529     C                   ENDIF
357000200529
357100200529      * For Deletes & Authorises, put the complete (pre-existing) deal
357200200529      * into the Valid file record
357300200529     C                   IF           DDACTN = 'D'
357400200529     C                             OR DDACTN = 'X'
357500200529     C                   MOVEL     DealFilFmt    ValidDeal
357600200529     C                   ENDIF
357700200529
357800200529      * Set Valid file field(s) that are needed for all Action Codes
357900200529     C                   EVAL      IKLACT = DDACTN
358000200529
358100200529      * Include Header fields that need to be o/p to the Valid file
358200200529                                                                                              244537
358300200529      * Do not override header fields from existing transaction.                              244537
358400200529     C**********         IF        DDACTN = 'I'                                     244537 AR971184A
358500200529     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
358600200529                                                                                              244537
358700200529     C                   EVAL      IKFRNT = APFOTranID
358800200529     C                   EVAL      IKAFRT = APFOAsocID
358900200529     C                   EVAL      IKREPA = APRprLocn
359000200529     C**********         IF        DDFOID <> *BLANKS                                239400 AR971184A
359100200529     C**********         EVAL      IKFRNT = DDFOID                                  239400 AR971184A
359200200529     C**********         END                                                        239400 AR971184A
359300200529     C                   EVAL      DDFOID = APFOTranID                                     AR971184A
359400200529                                                                                              244537
359500200529     C                   ENDIF                                                                244537
359600200529
359700200529      * Information needed to broken down
359800200529     C                   IF        CDL007 = 'Y'
359900200529     C                                AND DDACTN = 'A'
360000200529
360100200529      * Update Breakdown User Id with Last Breakdown User Id
360200200529     C                   EVAL      IKBUSR = IF_BUSR
360300200529
360400200529      * Update The Original Maturity Date
360500200529     C                   IF        IKMATD < OLD_MATD
360600200529     C                             AND DDTYPE = 'TD'
360700200529     C                             OR IKMATD < OLD_MATD
360800200529     C                             AND DDTYPE = 'TI'
360900200529     C                   EVAL      IKOMDT = OLD_MATD
361000200529     C                   EVAL      IKPRIN = *BLANKS
361100200529     C                   ENDIF
361200200529     C                   ENDIF
361300200529
361400200529      * Automatic Authorisation flag
361500200529     C                   IF        CAP051 = 'Y'
361600200529     C                   EVAL      IKAUTH = IF_AUTH
361700200529     C                   ENDIF
361800200529                                                                                             BUG3986
361900200529      * Restore Timestamp from the original record                                           BUG3986
362000200529     C                   IF        DDACTN <> 'I'                                             BUG3986
362100200529     C*****************            AND DDACTN <> 'X'                                 BUG4808 BUG4808
362200200529     C                             AND DDACTN <> 'X'                                          256638
362300200529     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
362400200529     C                   MOVEL     @TimeStamp    IKTMESTMP                                   BUG3986
362500200529     C                   ENDIF                                                               BUG3986
362600200529
362700200529     C                   ENDSR
362800200529      **********************************************************************                 BUG6512
362900200529     C     ZACFFEERTV    BEGSR                                                               BUG6512
363000200529                                                                                             BUG6512
363100200529     C                   CALLB     'ZACFFEERTV'                                              BUG6512
363200200529      *                                                                                      BUG6512
363300200529      * INPUTS                                                                               BUG6512
363400200529      *                                                                                      BUG6512
363500200529      * Return code                                                                          BUG6512
363600200529     C                   PARM      *BLANK        RetCodeIn        10                         BUG6512
363700200529      *                                                                                      BUG6512
363800200529      * Action Code                                                                          BUG6512
363900200529     C                   PARM                    DDACTN            1                         BUG6512
364000200529      *                                                                                      BUG6512
364100200529      * (Midas) Deal Number                                                                  BUG6512
364200200529     C                   PARM                    DDDLNO            6                         BUG6512
364300200529      *                                                                                      BUG6512
364400200529      * Broker                                                                               BUG6512
364500200529     C                   PARM                    DDBKCD            4                         BUG6512
364600200529      *                                                                                      BUG6512
364700200529      * OUTPUTS                                                                              BUG6512
364800200529      *                                                                                      BUG6512
364900200529      * OK - Action code                                                                     BUG6512
365000200529     C                   PARM      'Y'           DDActnOK          1                         BUG6512
365100200529      *                                                                                      BUG6512
365200200529      * Counterparty Status                                                                  BUG6512
365300200529     C                   PARM                    CPST              2                         BUG6512
365400200529     C                   PARM                    DSPCP             1                         BUG6512
365500200529      *                                                                                      BUG6512
365600200529      * Broker Status                                                                        BUG6512
365700200529     C                   PARM                    BKST              2                         BUG6512
365800200529     C                   PARM                    DSPBK             1                         BUG6512
365900200529      *                                                                                      BUG6512
366000200529      * Error fields/message IDs/message data (arrays) from/to caller                        BUG6512
366100200529     C                   PARM                    FldNameArr                                  BUG6512
366200200529     C                   PARM                    MsgIdArr                                    BUG6512
366300200529     C                   PARM                    MsgDtaArr                                   BUG6512
366400200529      *                                                                                      BUG6512
366500200529      * Array index (3P0) from/to caller                                                     BUG6512
366600200529     C                   PARM                    Idx                                         BUG6512
366700200529                                                                                             BUG6512
366800200529      ** Warning error fields/message IDs/message data (arrays) from/to caller               BUG6512
366900200529                                                                                             BUG6512
367000200529     C**********         PARM      *BLANKS       WFldNamArr                         BUG6512 BUG10677
367100200529     C**********         PARM      *BLANKS       WMsgIdArr                          BUG6512 BUG10677
367200200529     C**********         PARM      *BLANKS       WMsgDtaArr                         BUG6512 BUG10677
367300200529     C                   PARM                    WFldNamArr                                 BUG10677
367400200529     C                   PARM                    WMsgIdArr                                  BUG10677
367500200529     C                   PARM                    WMsgDtaArr                                 BUG10677
367600200529                                                                                             BUG6512
367700200529      ** Warning array index (3P0) from/to caller                                            BUG6512
367800200529                                                                                             BUG6512
367900200529     C**********         PARM      *ZEROS        WIdx                               BUG6512 BUG10677
368000200529     C                   PARM                    WIdx                                       BUG10677
368100200529                                                                                             BUG6512
368200200529     C                   ENDSR                                                               BUG6512
368300200529      **********************************************************************                 BUG6512
368400200529      *****************************************************************                       CER001
368500200529      /EJECT                                                                                  CER001
368600200529      *****************************************************************                       CER001
368700200529      *                                                               *                       CER001
368800200529      * ValidateLUX - Validate LUX extension file                     *                       CER001
368900200529      *                                                               *                       CER001
369000200529      *****************************************************************                       CER001
369100200529                                                                                              CER001
369200200529     C     ValidateLUX   BEGSR                                                                CER001
369300200529                                                                                              CER001
369400200529     C                   EVAL      #1DN38 = DDDLNO                                            CER001
369500200529     C                   EVAL      #1CCY  = DDCCY                                             CER001
369600200529     C                   Z-ADD     IKAMNP        #1AMNT                                       CER001
369700200529                                                                                              CER001
369800200529     C                   CALLB     'MMLDNI2VL'                                                CER001
369900200529     C                   PARM      DDACTN        ACTN                                         CER001
370000200529     C                   PARM                    DATALUX                                      CER001
370100200529     C                   PARM                    RegData                                      CER001
370200200529     C                   PARM                    OKFlags                                      CER001
370300200529     C                   PARM                    FldNameArr                                   CER001
370400200529     C                   PARM                    MsgIDArr                                     CER001
370500200529     C                   PARM                    MsgDtaArr                                    CER001
370600200529     C                   PARM                    Idx                                          CER001
370700200529     C                   PARM                    WFldNamArr                                   CER001
370800200529     C                   PARM                    WMsgIDArr                                    CER001
370900200529     C                   PARM                    WMsgDtaArr                                   CER001
371000200529     C                   PARM                    WIdx                                         CER001
371100200529     C                   PARM                    ValidLUX                                     CER001
371200200529     C                   PARM                    @@ER91                                       CER001
371300200529                                                                                              CER001
371400200529     C                   ENDSR                                                                CER001
371500200529      *****************************************************************                       CER001
371600200529      *****************************************************************
371700200529      /EJECT
371800200529     C/COPY ZACPYSRC,PSSR_ILE
371900200529      ********************************************************************
372000200529      /EJECT                                                                                  CDL033
372100200529      *****************************************************************                       CDL033
372200200529      *                                                               *                       CDL033
372300200529      * ValidateRC - Routine to validate the Rate Change Frequency    *                       CDL033
372400200529      *                                                               *                       CDL033
372500200529      *****************************************************************                       CDL033
372600200529      *                                                                                       CDL033
372700200529     C     ValidateRC    BEGSR                                                                CDL033
372800200529      *                                                                                       CDL033
372900200529      ** Check if at least one date exist in array RatDATEA() and                             CDL033
373000200529      ** Rate Change                                                                          CDL033
373100200529      *                                                                                       CDL033
373200200529     C                   IF        SfBuff20 <> *BLANK AND                                     CDL033
373300200529     C                             DDRCFR   <> 'Z'                                            CDL033
373400200529     C                   ADD       1             Idx                                          CDL033
373500200529     C                   EVAL      FldNameArr(Idx) = 'DDRCFR'                                 CDL033
373600200529     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CDL033
373700200529     C                   LEAVESR                                                              CDL033
373800200529     C                   ENDIF                                                                CDL033
373900200529      *                                                                                       CDL033
374000200529      ** If Frequency is 'Z' and no date specified on the schedule,                           CDL033
374100200529      ** always put the rate change date on top of the array                                  CDL033
374200200529      *                                                                                       CDL033
374300200529     C                   IF        SfBuff20 = *BLANK AND                                      CDL033
374400200529     C                             DDRCFR = 'Z'                                               CDL033
374500200529     C                   EVAL      RatDATEA(1) = DDRCDT                                       CDL033
374600200529     C                   EVAL      %Subst(Rindates:1:6) = DDRCDT                              CDL033
374700200529     C                   ENDIF                                                                CDL033
374800200529      *                                                                                       CDL033
374900200529     C                   IF        DDRCFR = 'Z'                                               CDL033
375000200529      *                                                                                       CDL033
375100200529      ** convert maturity date screen format to MIDAS day no.                                 CDL033
375200200529      *                                                                                       CDL033
375300200529     C                   CALLB     'ZDATE1'                                                   CDL033
375400200529     C                   PARM      DDVDAT        PDateIn                                      CDL033
375500200529     C     PvalueDate    PARM                    PDayNoOut                                    CDL033
375600200529     C                   PARM                    BJDFIN                                       CDL033
375700200529     C                   PARM                    PErrorFlg                                    CDL033
375800200529      *                                                                                       CDL033
375900200529     C                   CALLB     'ZDATE1'                                                   CDL033
376000200529     C                   PARM      DDMDAT        PDateIn                                      CDL033
376100200529     C     PmaturityDate PARM                    PDayNoOut                                    CDL033
376200200529     C                   PARM                    BJDFIN                                       CDL033
376300200529     C                   PARM                    PErrorFlg                                    CDL033
376400200529      *                                                                                       CDL033
376500200529     C                   CALLB     'ZDATE1'                                                   CDL033
376600200529     C                   PARM      DDRCDT        PDateIn                                      CDL033
376700200529     C     PControlDate  PARM                    PDayNoOut                                    CDL033
376800200529     C                   PARM                    BJDFIN                                       CDL033
376900200529     C                   PARM                    PErrorFlg                                    CDL033
377000200529      *                                                                                       CDL033
377100200529     C                   EVAL      PPrevDate = PvalueDate                                     CDL033
377200200529      *                                                                                       CDL033
377300200529     C                   CALLB     'MMVMRCHG'                                                 CDL033
377400200529     C                   PARM      *BLANKS       ReturnCode                                   CDL033
377500200529     C                   PARM                    PvalueDate                                   CDL033
377600200529     C                   PARM                    PmaturityDate                                CDL033
377700200529     C                   PARM                    PControlDate                                 CDL033
377800200529     C                   PARM                    BJDFIN                                       CDL033
377900200529     C                   PARM      DDACTN        Paction                                      CDL033
378000200529     C                   PARM      DDDLNO        PDealNo                                      CDL033
378100200529     C                   PARM                    PPrevDate                                    CDL033
378200200529     C                   PARM      DDCCY         Pcurrency                                    CDL033
378300200529     C                   PARM      RinDates      RDatesIn                                     CDL033
378400200529     C                   PARM                    RPConfHol                                    CDL033
378500200529     C                   PARM                    OKInRatCal                                   CDL033
378600200529     C                   PARM      *BLANKS       FldNameArr                                   CDL033
378700200529     C                   PARM      *BLANKS       MsgIDArr                                     CDL033
378800200529     C                   PARM                    Idx                                          CDL033
378900200529     C                   PARM      'Y'           IntRate                                      CDL033
379000200529     C                   PARM                    RValDateOut                                  CDL033
379100200529                                                                                              CDL033
379200200529     C                   ENDIF                                                                CDL033
379300200529      *                                                                                       CDL033
379400200529      ** If no error encountered, validate the formula and generate                           CDL033
379500200529      ** the dates based from the formula.                                                    CDL033
379600200529      *                                                                                       CDL033
379700200529     C                   IF        Idx = 0                                                    CDL033
379800200529     C                             AND DDRCFR = 'Z'                                           CDL033
379900200529     C                   EVAL      PFrequency = %SUBST(Rformula:1:1)                          CDL033
380000200529     C                   EVAL      PfreqForm  = %SUBST(Rformula:2:7)                          CDL033
380100200529      *                                                                                       CDL033
380200200529     C                   CALLB     'MMVFORMLA'                                                CDL033
380300200529     C                   PARM                    ReturnCode                                   CDL033
380400200529     C                   PARM                    PFrequency                                   CDL033
380500200529     C                   PARM                    PfreqForm                                    CDL033
380600200529     C                   PARM                    PControlDate                                 CDL033
380700200529     C                   PARM                    PmaturityDate                                CDL033
380800200529     C                   PARM      DDCCY         PCurrency                                    CDL033
380900200529     C                   PARM                    BJDFIN                                       CDL033
381000200529     C                   PARM      RvalDateOut   ValDateIn                                    CDL033
381100200529     C                   PARM      *BLANKS       FldNameArr                                   CDL033
381200200529     C                   PARM      *BLANKS       MsgIDArr                                     CDL033
381300200529     C                   PARM                    Idx                                          CDL033
381400200529     C                   ENDIF                                                                CDL033
381500200529      *                                                                                       CDL033
381600200529      ** If no error encountered, check each dates in ValDateIn if it                         CDL033
381700200529      ** falls on Saturday or Sunday.                                                         CDL033
381800200529      *                                                                                       CDL033
381900200529     C                   IF        Idx = 0                                                    CDL033
382000200529     C                             AND DDRCFR = 'Z'                                           CDL033
382100200529     C                   EVAL      #X = 1                                                     CDL033
382200200529     C                   EVAL      #N = 1                                                     CDL033
382300200529      *                                                                                       CDL033
382400200529     C                   DO        600                                                        CDL033
382500200529     C                   EVAL      XCharA = %SUBST(ValDateIn:#N:3)                            CDL033
382600200529     C                   IF        XCharA = *BLANK                                            CDL033
382700200529     C                   LEAVE                                                                CDL033
382800200529     C                   ENDIF                                                                CDL033
382900200529     C                   EVAL      RatDAYA(#X) = XNumP                                        CDL033
383000200529     C                   EVAL      #N = #N + 3                                                CDL033
383100200529     C                   EVAL      #X = #X + 1                                                CDL033
383200200529     C                   ENDDO                                                                CDL033
383300200529      *                                                                                       CDL033
383400200529     C                   EVAL      ARdx = 1                                                   CDL033
383500200529     C                   DO        600           Ardx                                         CDL033
383600200529     C                   MoveA     RatDAYA(ARdx) XNumP                                        CDL033
383700200529     C                   IF        XNumP =  *ZEROS                                            CDL033
383800200529     C                   LEAVE                                                                CDL033
383900200529     C                   ENDIF                                                                CDL033
384000200529     C                   EVAL      ZDAYNO = XNumP                                             CDL033
384100200529     C                   CALLB     'ZDATE2'                                                   CDL033
384200200529     C                   PARM                    ZDAYNO                                       CDL033
384300200529     C                   PARM                    BJDFIN                                       CDL033
384400200529     C                   PARM      *ZEROS        ZDATE                                        CDL033
384500200529     C                   PARM      *BLANKS       ZADATE                                       CDL033
384600200529     C                   MOVE      ZDATE         RatDate(ARdx)                                CDL033
384700200529     C                   ENDDO                                                                CDL033
384800200529     C                   ENDIF                                                                CDL033
384900200529      *                                                                                       CDL033
385000200529     C                   ENDSR                                                                CDL033
385100200529      *****************************************************************                       CDL033
385200200529      /EJECT                                                                                  CDL033
385300200529      *****************************************************************                       CDL033
385400200529      *                                                               *                       CDL033
385500200529      * ValidatePC - Routine to validate the Interest Payment         *                       CDL033
385600200529      *              Frequency                                        *                       CDL033
385700200529      *                                                               *                       CDL033
385800200529      *****************************************************************                       CDL033
385900200529      *                                                                                       CDL033
386000200529     C     ValidatePC    BEGSR                                                                CDL033
386100200529      *                                                                                       CDL033
386200200529      ** Check if at least one date exist in array PayDATEA() and                             CDL033
386300200529      ** Interest Payment Frequency                                                           CDL033
386400200529      *                                                                                       CDL033
386500200529     C                   IF        SfBuff21 <> *BLANK AND                                     CDL033
386600200529     C                             DDIPFQ <> 'Z'                                              CDL033
386700200529     C                   ADD       1             Idx                                          CDL033
386800200529     C                   EVAL      FldNameArr(Idx) = 'DDIPFQ'                                 CDL033
386900200529     C                   EVAL      MsgIDArr(Idx) = 'MMA0678'                                  CDL033
387000200529     C                   LEAVESR                                                              CDL033
387100200529     C                   ENDIF                                                                CDL033
387200200529      *                                                                                       CDL033
387300200529      ** If Frequency is 'Z' and no date specified on the schedule,                           CDL033
387400200529      ** always put the rate change date on top of the array                                  CDL033
387500200529      *                                                                                       CDL033
387600200529     C                   IF        SfBuff21 = *BLANK AND                                      CDL033
387700200529     C                             DDIPFQ = 'Z'                                               CDL033
387800200529     C                   EVAL      PayDATEA(1) = DDNDAT                                       CDL033
387900200529     C                   EVAL      %Subst(Pindates:1:6) = DDNDAT                              CDL033
388000200529     C                   ENDIF                                                                CDL033
388100200529      *                                                                                       CDL033
388200200529     C                   IF        DDIPFQ = 'Z'                                               CDL033
388300200529      *                                                                                       CDL033
388400200529      ** convert maturity date screen format to MIDAS day no.                                 CDL033
388500200529      *                                                                                       CDL033
388600200529     C                   CALLB     'ZDATE1'                                                   CDL033
388700200529     C                   PARM      DDVDAT        PDateIn                                      CDL033
388800200529     C     PvalueDate    PARM                    PDayNoOut                                    CDL033
388900200529     C                   PARM                    BJDFIN                                       CDL033
389000200529     C                   PARM                    PErrorFlg                                    CDL033
389100200529      *                                                                                       CDL033
389200200529     C                   CALLB     'ZDATE1'                                                   CDL033
389300200529     C                   PARM      DDMDAT        PDateIn                                      CDL033
389400200529     C     PmaturityDate PARM                    PDayNoOut                                    CDL033
389500200529     C                   PARM                    BJDFIN                                       CDL033
389600200529     C                   PARM                    PErrorFlg                                    CDL033
389700200529      *                                                                                       CDL033
389800200529     C                   CALLB     'ZDATE1'                                                   CDL033
389900200529     C                   PARM      DDNDAT        PDateIn                                      CDL033
390000200529     C     PControlDate  PARM                    PDayNoOut                                    CDL033
390100200529     C                   PARM                    BJDFIN                                       CDL033
390200200529     C                   PARM                    PErrorFlg                                    CDL033
390300200529      *                                                                                       CDL033
390400200529     C                   EVAL      PPrevDate = PvalueDate                                     CDL033
390500200529      *                                                                                       CDL033
390600200529     C                   CALLB     'MMVMRCHG'                                                 CDL033
390700200529     C                   PARM      *BLANKS       ReturnCode                                   CDL033
390800200529     C                   PARM                    PvalueDate                                   CDL033
390900200529     C                   PARM                    PmaturityDate                                CDL033
391000200529     C                   PARM                    PControlDate                                 CDL033
391100200529     C                   PARM                    BJDFIN                                       CDL033
391200200529     C                   PARM      DDACTN        Paction                                      CDL033
391300200529     C                   PARM      DDDLNO        PDealNo                                      CDL033
391400200529     C                   PARM                    PPrevDate                                    CDL033
391500200529     C                   PARM      DDCCY         Pcurrency                                    CDL033
391600200529     C                   PARM      PinDates      PDatesIn                                     CDL033
391700200529     C                   PARM                    PPConfHol                                    CDL033
391800200529     C                   PARM                    OKInRatCal                                   CDL033
391900200529     C                   PARM      *BLANKS       FldNameArr                                   CDL033
392000200529     C                   PARM      *BLANKS       MsgIDArr                                     CDL033
392100200529     C                   PARM                    Idx                                          CDL033
392200200529     C                   PARM      ' '           IntRate                                      CDL033
392300200529     C                   PARM                    PValDateOut                                  CDL033
392400200529                                                                                              CDL033
392500200529     C                   ENDIF                                                                CDL033
392600200529      *                                                                                       CDL033
392700200529      ** If no error encountered, validate the formula and generate                           CDL033
392800200529      ** the dates based from the formula.                                                    CDL033
392900200529      *                                                                                       CDL033
393000200529     C                   IF        Idx = 0                                                    CDL033
393100200529     C                             AND DDIPFQ = 'Z'                                           CDL033
393200200529     C                   EVAL      PFrequency = %SUBST(PFormula:1:1)                          CDL033
393300200529     C                   EVAL      PfreqForm  = %SUBST(PFormula:2:7)                          CDL033
393400200529      *                                                                                       CDL033
393500200529     C                   CALLB     'MMVFORMLA'                                                CDL033
393600200529     C                   PARM                    ReturnCode                                   CDL033
393700200529     C                   PARM                    PFrequency                                   CDL033
393800200529     C                   PARM                    PfreqForm                                    CDL033
393900200529     C                   PARM                    PControlDate                                 CDL033
394000200529     C                   PARM                    PmaturityDate                                CDL033
394100200529     C                   PARM      DDCCY         PCurrency                                    CDL033
394200200529     C                   PARM                    BJDFIN                                       CDL033
394300200529     C                   PARM      PValDateOut   ValDateIn                                    CDL033
394400200529     C                   PARM      *Blanks       FldNameArr                                   CDL033
394500200529     C                   PARM      *Blanks       MsgIDArr                                     CDL033
394600200529     C                   PARM                    Idx                                          CDL033
394700200529     C                   ENDIF                                                                CDL033
394800200529      *                                                                                       CDL033
394900200529      ** If no error encountered, check each dates in ValDateIn if it                         CDL033
395000200529      ** falls on Saturday or Sunday.                                                         CDL033
395100200529      *                                                                                       CDL033
395200200529     C                   IF        Idx = 0                                                    CDL033
395300200529     C                             AND DDIPFQ = 'Z'                                           CDL033
395400200529     C                   EVAL      #X = 1                                                     CDL033
395500200529     C                   EVAL      #N = 1                                                     CDL033
395600200529      *                                                                                       CDL033
395700200529     C                   DO        600                                                        CDL033
395800200529     C                   EVAL      XCharA = %SUBST(ValDateIn:#N:3)                            CDL033
395900200529     C                   IF        XCharA = *BLANK                                            CDL033
396000200529     C                   LEAVE                                                                CDL033
396100200529     C                   ENDIF                                                                CDL033
396200200529     C                   EVAL      PayDAYA(#X) = XNumP                                        CDL033
396300200529     C                   EVAL      #N = #N + 3                                                CDL033
396400200529     C                   EVAL      #X = #X + 1                                                CDL033
396500200529     C                   ENDDO                                                                CDL033
396600200529      *                                                                                       CDL033
396700200529     C                   EVAL      ARdx = 1                                                   CDL033
396800200529     C                   DO        600           Ardx                                         CDL033
396900200529     C                   MoveA     PayDAYA(ARdx) XNumP                                        CDL033
397000200529     C                   IF        XNumP =  *ZEROS                                            CDL033
397100200529     C                   LEAVE                                                                CDL033
397200200529     C                   ENDIF                                                                CDL033
397300200529     C                   EVAL      ZDAYNO = XNumP                                             CDL033
397400200529     C                   CALLB     'ZDATE2'                                                   CDL033
397500200529     C                   PARM                    ZDAYNO                                       CDL033
397600200529     C                   PARM                    BJDFIN                                       CDL033
397700200529     C                   PARM      *ZEROS        ZDATE                                        CDL033
397800200529     C                   PARM      *BLANKS       ZADATE                                       CDL033
397900200529     C                   MOVE      ZDATE         PayDate(ARdx)                                CDL033
398000200529     C                   ENDDO                                                                CDL033
398100200529     C                   ENDIF                                                                CDL033
398200200529      *                                                                                       CDL033
398300200529     C                   ENDSR                                                                CDL033
398400200529      *****************************************************************                       CDL033
398500200529      /EJECT                                                                                  CDL033
398600200529      *****************************************************************                       CDL033
398700200529      *                                                               *                       CDL033
398800200529      * SUpVALIRC - Routine to validate  the Rate Change              *                       CDL033
398900200529      *                                                               *                       CDL033
399000200529      *****************************************************************                       CDL033
399100200529      *                                                                                       CDL033
399200200529     C     SUpVALIRC     BEGSR                                                                CDL033
399300200529     C                   IF        DDACTN = 'A'                                               CDL033
399400200529     C                             OR DDACTN = 'R'                                            CDL033
399500200529     C                   MOVE      DDDLNO        VDLNO                                        CDL033
399600200529     C     VDLNO         SETLL     DLFRSCL0
399700200529     C                   READ      DLFRSCL0                               60                  CDL033
399800200529     C     *IN60         DOWEQ     *OFF                                                       CDL033
399900200529     C     HHDLNO        ANDEQ     VDLNO                                                      CDL033
400000200529      *                                                                                       CDL033
400100200529     C                   IF        HHDTPR <> 'Y'                                              CDL033
400200200529     C                             OR HHDTPR <> 'y'                                           CDL033
400300200529     C                   DELETE    DLFRSCD0                                                   CDL033
400400200529     C                   ENDIF                                                                CDL033
400500200529      *                                                                                       CDL033
400600200529     C                   READ      DLFRSCL0                               60                  CDL033
400700200529     C                   ENDDO                                                                CDL033
400800200529     C                   ENDIF                                                                CDL033
400900200529      *                                                                                       CDL033
401000200529     C                   IF        DDACTN = 'I'                                               CDL033
401100200529     C                             OR DDACTN = 'A'                                            CDL033
401200200529      *                                                                                       CDL033
401300200529     C                   IF        DDIPFQ = 'Z'                                               CDL033
401400200529     C                   EVAL      HHRCIP = 'P'                                               CDL033
401500200529     C                   DO        600           T                                            CDL033
401600200529     C                   EVAL      HHPRDT = PayDAYA(T)                                        CDL033
401700200529     C                   IF        HHPRDT = 0                                                 CDL033
401800200529     C                   LEAVE                                                                CDL033
401900200529     C                   ENDIF                                                                CDL033
402000200529     C                   IF        PayProc(T) <> 'Y'                                          CDL033
402100200529     C                             OR PayProc(T) <> 'y'                                       CDL033
402200200529     C                   MOVE      DDDLNO        HHDLNO                                       CDL033
402300200529     C                   EVAL      HHRCIP = 'P'                                               CDL033
402400200529     C                   EVAL      HHCOHO = PayIndtr(T)                                       CDL033
402500200529     C                   EVAL      HHDTPR = PayProc(T)                                        CDL033
402600200529     C                   WRITE     DLFRSCD0                                                   CDL033
402700200529     C                   ENDIF                                                                CDL033
402800200529     C                   ENDDO                                                                CDL033
402900200529     C                   ENDIF                                                                CDL033
403000200529      *                                                                                       CDL033
403100200529     C                   IF        DDRCFR = 'Z'                                               CDL033
403200200529     C                   Z-ADD     1             T                                            CDL033
403300200529     C                   EVAL      HHRCIP = 'R'                                               CDL033
403400200529     C                   DO        600           T                                            CDL033
403500200529      *                                                                                       CDL033
403600200529     C                   EVAL      HHPRDT = RatDAYA(T)                                        CDL033
403700200529     C                   IF        HHPRDT = 0                                                 CDL033
403800200529     C                   LEAVE                                                                CDL033
403900200529     C                   ENDIF                                                                CDL033
404000200529     C                   IF        RatProc(T) <> 'Y'                                          CDL033
404100200529     C                             OR RatProc(T) <> 'y'                                       CDL033
404200200529     C                   MOVE      DDDLNO        HHDLNO                                       CDL033
404300200529     C                   EVAL      HHRCIP = 'R'                                               CDL033
404400200529     C                   EVAL      HHCOHO = RatIndtr(T)                                       CDL033
404500200529     C                   EVAL      HHDTPR = RatProc(T)                                        CDL033
404600200529     C                   WRITE     DLFRSCD0                                                   CDL033
404700200529     C                   ENDIF                                                                CDL033
404800200529     C                   ENDDO                                                                CDL033
404900200529     C                   ENDIF                                                                CDL033
405000200529      *                                                                                       CDL033
405100200529     C                   ENDIF                                                                CDL033
405200200529      *                                                                                       CDL033
405300200529     C                   ENDSR                                                                CDL033
405400200529      *****************************************************************                       CDL033
405500200529      /EJECT
405600200529      *****************************************************************
405700200529      *                                                               *                      BUG9827
405800200529      * VALIDATEFD - Routine to Validate Fiduciary Takings            *                      BUG9827
405900200529      *                                                               *                      BUG9827
406000200529      *****************************************************************                      BUG9827
406100200529     C     ValidateFD    BEGSR                                                               BUG9827
406200200529                                                                                             BUG9827
406300200529     C                   Eval      Tkg = 1                                                   BUG9827
406400200529     C                   Eval      Str = 1                                                   BUG9827
406500200529     C                   Eval      NoOfTakingsIns = 0                                        BUG9827
406600200529     C                   Eval      WTAmount = 0                                              BUG9827
406700200529     C                   DOW       Tkg <= 99                                                 BUG9827
406800200529                                                                                             BUG9827
406900200529     C                   Eval      WFIDTDTL = %SUBST(FIDTScnRpt:Str:FIDTLen)                 BUG9827
407000200529                                                                                             BUG9827
407100200529     C                   If        WFIDTDTL = *blanks                                        BUG9827
407200200529     C                   Leave                                                               BUG9827
407300200529     C                   EndIf                                                               BUG9827
407400200529                                                                                             BUG9827
407500200529     C                   If        DDTYPE = 'DP' and Tkg > 1 or                              BUG9827
407600200529     C                             DDTYPE = 'LP' and Tkg > 1                                 BUG9827
407700200529     C                   ADD       1             Idx                                         BUG9827
407800200529     C                   Eval      FldNameArr(Idx) = 'DDDLNO'                                BUG9827
407900200529     C                   Eval      MsgIDArr(Idx) = 'MMM9039'                                 BUG9827
408000200529     C                   Leave                                                               BUG9827
408100200529     C                   EndIf                                                               BUG9827
408200200529                                                                                             BUG9827
408300200529      * No need to call validate module in delete mode                                       BUG9827
408400200529     C                   If        DDACTN <> 'D'                                             BUG9827
408500200529                                                                                            BUG10341
408600200529     C                   Eval      ErrTot = Idx                                             BUG10341
408700200529     C                   MOVE      Tkg           TkgA                                       MD033924
408800200529     C                   CALLB     'MMFIDTVAL'                                               BUG9827
408900200529     C**********         PARM      *blanks       ReturnCode                         BUG9827 MD033924
409000200529     C                   PARM      TkgA          ReturnCode                                 MD033924
409100200529     C                   PARM                    DDACTN                                      BUG9827
409200200529     C                   PARM                    DDDLNO                                      BUG9827
409300200529     C                   PARM                    DDBRCA                                      BUG9827
409400200529     C                   PARM                    DDCCY                                       BUG9827
409500200529     C                   PARM                    DDTYPE                                      BUG9827
409600200529     C                   PARM                    DDCUST                                      BUG9827
409700200529     C                   PARM                    WFIDTDTL                                    BUG9827
409800200529     C                   PARM                    BGPFMG                                      BUG9827
409900200529     C                   PARM                    SDPORT                                      BUG9827
410000200529     C                   PARM                    WTAmount                                    BUG9827
410100200529     C                   PARM      'Y'           OKFIDTDTL                                   BUG9827
410200200529     C                   PARM                    FldNameArr                                  BUG9827
410300200529     C                   PARM                    MsgIDArr                                    BUG9827
410400200529     C                   PARM                    MsgDtaArr                                   BUG9827
410500200529     C**********         PARM      0             Idx                                BUG9827 BUG10341
410600200529     C                   PARM                    Idx                                        BUG10341
410700200529     C                   PARM      *BLANKS       VFIDTDTL                                    BUG9827
410800200529                                                                                            BUG10341
410900200529     C                   Eval      NewErrTot = Idx                                          BUG10341
411000200529     C                   If        NewErrTot <> ErrTot                                      BUG10341
411100200529     C                   EXSR      FIDTERRMSG                                               BUG10341
411200200529     C                   EndIf                                                              BUG10341
411300200529                                                                                            BUG10341
411400200529     C                   EndIf                                                               BUG9827
411500200529                                                                                             BUG9827
411600200529      * If delete, then valid details not setup                                              BUG9827
411700200529     C                   If        DDACTN <> 'D'                                             BUG9827
411800200529     C                   Eval      %SUBST(FIDTVScnFmt:Str) = VFIDTDTL                        BUG9827
411900200529     C                   Else                                                                BUG9827
412000200529     C                   Eval      %subst(FIDTVScnFmt:Str) = WFIDTDTL                        BUG9827
412100200529     C                   EndIf                                                               BUG9827
412200200529                                                                                             BUG9827
412300200529     C                   Eval      NoOfTakingsIns = Tkg                                      BUG9827
412400200529     C                   Eval      Tkg = Tkg + 1                                             BUG9827
412500200529     C                   Eval      Str = Str + FIDTLen                                       BUG9827
412600200529     C                   ENDDO                                                               BUG9827
412700200529                                                                                             BUG9827
412800200529      ** Total amounts of takings deals must match the placing deal amount                   BUG9827
412900200529                                                                                             BUG9827
413000200529     C                   If        DDACTN <> 'D'                                             BUG9827
413100200529     C                   CALLB     'AOCURRR0'                                                BUG9827
413200200529     C                   PARM      *BLANKS       PRTCD                                       BUG9827
413300200529     C                   PARM      '*KEY   '     POPTN                                       BUG9827
413400200529     C                   PARM      DDCCY         PCCY              3                         BUG9827
413500200529     C     SDCURR        PARM      SDCURR        DSSDY                                       BUG9827
413600200529     C                   If        PRTCD <> *Blanks                                          BUG9827
413700200529     C     *LOCK         IN        LDA                                                       BUG9827
413800200529     C                   EVAL      DBKEY = DDCCY                                             BUG9827
413900200529     C                   EVAL      DBFILE = 'SDCUSTPD'                                       BUG9827
414000200529     C                   EVAL      DBASE = 015                                               BUG9827
414100200529     C                   OUT       LDA                                                       BUG9827
414200200529     C                   EXSR      *PSSR                                                     BUG9827
414300200529     C                   EndIf                                                               BUG9827
414400200529                                                                                             BUG9827
414500200529     C                   Eval      PCYDP = A6NBDP                                            BUG9827
414600200529     C                   MOVE      *BLANKS       ZFIELD                                      BUG9827
414700200529                                                                                             BUG9827
414800200529     C                   CALLB     'ZALIGN'                                                  BUG9827
414900200529     C                   PARM                    ZALIGNOK                                    BUG9827
415000200529     C                   PARM      DDAMNP        ZFIELD                                      BUG9827
415100200529     C                   PARM      PCYDP         ZADEC                                       BUG9827
415200200529     C                   PARM      12            ZADIG                                       BUG9827
415300200529                                                                                             BUG9827
415400200529     C                   MOVE      ZFIELD        WAmount                                     BUG9827
415500200529     C                   If        WTAmount <> WAmount                                       BUG9827
415600200529     C                   MOVE      *BLANKS       ZFLD15                                      BUG9827
415700200529                                                                                             BUG9827
415800200529     C                   CALLB     'ZSEDIT'                                                  BUG9827
415900200529     C                   PARM      WTAmount      ZFLD15                                      BUG9827
416000200529     C                   PARM      PCYDP         ZDECS                                       BUG9827
416100200529     C                   PARM      *BLANKS       ZECODE                                      BUG9827
416200200529     C                   PARM                    ZOUT21                                      BUG9827
416300200529     C                   ADD       1             Idx                                         BUG9827
416400200529     C                   Eval      FldNameArr(Idx) = 'DDAMNP'                                BUG9827
416500200529     C                   Eval      MsgIDArr(Idx) = 'MMA0579'                                 BUG9827
416600200529     C**********         Eval      MsgDtaArr(Idx) = ZOUT21                          BUG9827 MD000091
416700200529     C                   EVAL      BLen = %Len(%Trim(ZOUT21))                               MD000091
416800200529     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(ZOUT21)                   MD000091
416900200529     C                   EndIf                                                               BUG9827
417000200529                                                                                             BUG9827
417100200529     C                   EndIf                                                               BUG9827
417200200529                                                                                             BUG9827
417300200529     C                   ENDSR                                                               BUG9827
417400200529      *****************************************************************                      BUG9827
417500200529      *                                                               *                      BUG9827
417600200529      * SupFIDT - Call update modules for Fiduciary takings           *                      BUG9827
417700200529      *                                                               *                      BUG9827
417800200529      *****************************************************************                      BUG9827
417900200529     C     SupFIDT       BEGSR                                                               BUG9827
418000200529      *                                                                                      BUG9827
418100200529      ** Loop through and write deals                                                        BUG9827
418200200529     C                   MOVE      IKDN38        PRDLNO                                      BUG9827
418300200529     C                   Eval      Tkg = 1                                                   BUG9827
418400200529     C                   Eval      Str = 1                                                   BUG9827
418500200529     C                   DOW       Tkg <= NoOfTakingsIns                                     BUG9827
418600200529     C                   Eval      VFIDTDTL = %subst(FIDTVScnFmt:Str:FIDTLen)                BUG9827
418700200529      ** Setup valid deal file details                                                       BUG9827
418800200529     C                   Eval      DDDLNO = *blanks                                          BUG9827
418900200529     C                   If        DDACTN = 'I'                                              BUG9827
419000200529     C                   EXSR      SETUPVFIDTI                                               BUG9827
419100200529     C                   Else                                                                BUG9827
419200200529     C                   Eval      DDDLNO = VSFDLNO                                          BUG9827
419300200529     C                   EXSR      ValidateAc                                                BUG9827
419400200529     C                   MOVEL     DealFilFmt    ValidDeal                                   BUG9827
419500200529      * Set Valid file field(s) that are needed for all Action Codes                         BUG9827
419600200529      * Include Header fields that need to be o/p to the Valid file                          BUG9827
419700200529     C                   EVAL      IKLACT = DDACTN                                           BUG9827
419800200529     C                   EVAL      IKFRNT = APFOTranID                                       BUG9827
419900200529     C                   EVAL      IKAFRT = APFOAsocID                                       BUG9827
420000200529     C                   EVAL      IKREPA = APRprLocn                                        BUG9827
420100200529     C                   EndIf                                                               BUG9827
420200200529                                                                                             BUG9827
420300200529     C                   EXSR      UPDATEFIDT                                                BUG9827
420400200529     C                   MOVE      IKDN38        IKDN38A           6                         BUG9827
420500200529     C                   Eval      %SUBST(FIDTScnRpt:Str:6) = IKDN38A                        BUG9827
420600200529     C                   Eval      Tkg = Tkg + 1                                             BUG9827
420700200529     C                   Eval      Str = Str + FIDTLen                                       BUG9827
420800200529     C                   EndDo                                                               BUG9827
420900200529                                                                                             BUG9827
421000200529      * Put original deal number back in screen field                                        BUG9827
421100200529     C                   Eval      DDDLNO = PRDLNO                                           BUG9827
421200200529     C                   MOVE      PRDLNO        IKDN38                                      BUG9827
421300200529                                                                                             BUG9827
421400200529     C                   ENDSR                                                               BUG9827
421500200529      *****************************************************************                      BUG9827
421600200529      /EJECT                                                                                 BUG9827
421700200529      *****************************************************************                      BUG9827
421800200529      *                                                               *                      BUG9827
421900200529      * SETUPVFIDTI - Setup Valid file for Fiduciary takings (Insert) *                      BUG9827
422000200529      *                                                               *                      BUG9827
422100200529      *****************************************************************                      BUG9827
422200200529     C     SETUPVFIDTI   BEGSR                                                               BUG9827
422300200529      *                                                                                      BUG9827
422400200529      ** Use current deals valid format, replacing necessary details for the taking          BUG9827
422500200529                                                                                             BUG9827
422600200529     C                   CALLB     'AOCUSTR1'                                                BUG9827
422700200529     C                   PARM      *BLANKS       PRTCD                                       BUG9827
422800200529     C                   PARM      '*KEY   '     POPTN                                       BUG9827
422900200529     C                   PARM      VSFCNUM       PKEY1                                       BUG9827
423000200529     C                   PARM      *BLANKS       PKYST                                       BUG9827
423100200529     C     SDCUST        PARM      SDCUST        DSLDY                                       BUG9827
423200200529                                                                                             BUG9827
423300200529     C                   IF        PRTCD <> *BLANKS                                          BUG9827
423400200529     C     *LOCK         IN        LDA                                                       BUG9827
423500200529     C                   EVAL      DBKEY = VSFCNUM                                           BUG9827
423600200529     C                   EVAL      DBFILE = 'SDCUSTPD'                                       BUG9827
423700200529     C                   EVAL      DBASE = 016                                               BUG9827
423800200529     C                   OUT       LDA                                                       BUG9827
423900200529     C                   EXSR      *PSSR                                                     BUG9827
424000200529     C                   ENDIF                                                               BUG9827
424100200529                                                                                             BUG9827
424200200529      ** Setup Timestamp                                                                     BUG9827
424300200529     C                   Eval      IKTMESTMP = TimeStamp                                     BUG9827
424400200529      ** Linked Deal Number                                                                  BUG9827
424500200529     C                   MOVE      PRDLNO        IKLNKN                                      BUG9827
424600200529     C                   IF        DDTYPE = 'FL'                                             BUG9827
424700200529     C                   MOVEL     'FT'          IKTYPE                                      BUG9827
424800200529     C                   ELSE                                                                BUG9827
424900200529     C                   IF        DDTYPE = 'DP'                                             BUG9827
425000200529     C                   MOVEL     'DT'          IKTYPE                                      BUG9827
425100200529     C                   ELSE                                                                BUG9827
425200200529     C                   IF        DDTYPE = 'LP'                                             BUG9827
425300200529     C                   MOVEL     'LT'          IKTYPE                                      BUG9827
425400200529     C                   ENDIF                                                               BUG9827
425500200529     C                   ENDIF                                                               BUG9827
425600200529     C                   ENDIF                                                               BUG9827
425700200529                                                                                             BUG9827
425800200529     C                   MOVEL     BBCSSN        IKCSNM                                      BUG9827
425900200529     C                   MOVE      BBCUST        IKCNUM                                      BUG9827
426000200529     C                   MOVEL     *BLANKS       ZFIELD                                      BUG9827
426100200529                                                                                             BUG9827
426200200529     C                   CALLB     'ZALIGN'                                                  BUG9827
426300200529     C                   PARM                    ZALIGNOK                                    BUG9827
426400200529     C                   PARM      VSFAMNT       ZFIELD                                      BUG9827
426500200529     C                   PARM      A6NBDP        ZADEC                                       BUG9827
426600200529     C                   PARM      12            ZADIG                                       BUG9827
426700200529                                                                                             BUG9827
426800200529     C                   MOVE      ZFIELD        IKAMNP                                      BUG9827
426900200529     C                   MOVEL     DDACTN        IKLACT                                      BUG9827
427000200529     C                   MOVEL     *BLANKS       IKCPTI                                      BUG9827
427100200529     C                   MOVE      VSFACSQ       IKACSQ                                      BUG9827
427200200529     C                   MOVEL     'MAIL'        IKBKCD                                      BUG9827
427300200529     C                   MOVEL     'N'           IKMTAX                                      BUG9827
427400200529                                                                                             BUG9827
427500200529     C                   MOVEL     'MACC '       IKDORM                                      BUG9827
427600200529     C                   MOVE      05            IKORCM                                      BUG9827
427700200529     C                   EVAL      IKDORI = BBCUST + VSFACOD + VSFACSQ                       BUG9827
427800200529     C                   EVAL      IKMORI = BBCUST + VSFACOD + VSFACSQ                       BUG9827
427900200529     C                   MOVEL     'MACC '       IKDOPM                                      BUG9827
428000200529     C                   MOVE      05            IKMOPM                                      BUG9827
428100200529     C                   EVAL      IKDOPI = BBCUST + VSFACOD + VSFACSQ                       BUG9827
428200200529     C                   EVAL      IKMOPI = BBCUST + VSFACOD + VSFACSQ                       BUG9827
428300200529     C                   MOVE      05            IKRSTM                                      BUG9827
428400200529     C                   EVAL      IKRONS = BBCUST + VSFACOD + VSFACSQ                       BUG9827
428500200529     C                   MOVE      05            IKPSTM                                      BUG9827
428600200529     C                   EVAL      IKPONS = BBCUST + VSFACOD + VSFACSQ                       BUG9827
428700200529                                                                                             BUG9827
428800200529     C                   CALLB     'AOPRFMR0'                                                BUG9827
428900200529     C                   PARM      *BLANKS       PRTCD                                       BUG9827
429000200529     C                   PARM      IKBOKC        PBOOK             2                         BUG9827
429100200529     C                   PARM      IKTYPE        PTRTP                                       BUG9827
429200200529     C                   PARM      IKSTYP        PSUTP             2                         BUG9827
429300200529     C                   PARM      IKBRCA        PBRAN             3                         BUG9827
429400200529     C                   PARM      ZMDEPT        PDEPT1            2                         BUG9827
429500200529     C                   PARM      PSUSER        PUSER            10                         BUG9827
429600200529     C                   PARM      BBACOC        PACOF             2                         BUG9827
429700200529     C                   PARM      BBCUST        PCUST             6                         BUG9827
429800200529     C                   PARM                    PPRFC             4                         BUG9827
429900200529                                                                                             BUG9827
430000200529     C                   IF        PRTCD = *BLANKS                                           BUG9827
430100200529     C                   MOVEL     PPRFC         IKPRFC                                      BUG9827
430200200529     C                   ENDIF                                                               BUG9827
430300200529                                                                                             BUG9827
430400200529     C                   MOVEL     DDBRCA        IKPOBR                                      BUG9827
430500200529     C                   MOVEL     DDBRCA        IKROBR                                      BUG9827
430600200529     C                   MOVE      VSFTRAS       IKFTST                                      BUG9827
430700200529                                                                                             BUG9827
430800200529     C                   IF        DDTYPE = 'LP'                                             BUG9827
430900200529     C                   ELSE                                                                BUG9827
431000200529     C                   MOVE      *BLANKS       IKFRN1                                      BUG9827
431100200529     C                   MOVE      *BLANKS       IKFRN2                                      BUG9827
431200200529     C                   MOVE      *BLANKS       IKFRN3                                      BUG9827
431300200529     C                   MOVE      *BLANKS       IKFRN4                                      BUG9827
431400200529     C                   ENDIF                                                               BUG9827
431500200529                                                                                             BUG9827
431600200529     C                   IF        BGPFMG  = 'Y'                                             BUG9827
431700200529     C                   IF        VSFPTFR = FCR997                                          BUG9827
431800200529     C                   MOVE      '9997'        IKPTFR                                      BUG9827
431900200529     C                   ELSE                                                                BUG9827
432000200529     C                   MOVEL     VSFPTFR       IKPTFR                                      BUG9827
432100200529     C                   ENDIF                                                               BUG9827
432200200529     C                   ELSE                                                                BUG9827
432300200529     C                   MOVE      *BLANKS       IKPTFR                                      BUG9827
432400200529     C                   ENDIF                                                               BUG9827
432500200529      ** Calculate total interest of the taking deal                                         BUG9827
432600200529                                                                                             BUG9827
432700200529     C                   Z-ADD     IKCYDP        PCYDP                                       BUG9827
432800200529     C                   Z-ADD     IKNTCE        PNTCE                                       BUG9827
432900200529                                                                                             BUG9827
433000200529     C                   CALLB     'ZAVTOTINT'                                               BUG9827
433100200529     C                   PARM      *Blanks       ReturnCode                                  BUG9827
433200200529     C                   PARM      *Blanks       MsgIDArr                                    BUG9827
433300200529      ** Action Code (1A, from caller)                                                       BUG9827
433400200529     C                   PARM                    DDACTN                                      BUG9827
433500200529      ** Message data (45A)                                                                  BUG9827
433600200529     C                   PARM      *BLANKS       #MsgData                                    BUG9827
433700200529      ** Total interest amount returned from this module (15,0P)                             BUG9827
433800200529     C                   PARM      *ZERO         IKMTTI                                      BUG9827
433900200529      ** Total interest amount (14A, from transaction)                                       BUG9827
434000200529     C                   PARM      '*'           PTOTI                                       BUG9827
434100200529      ** Default interest for CL and CD deals with zero notice days                          BUG9827
434200200529      ** feature flag (1A, from SCSARDPD)                                                    BUG9827
434300200529     C                   PARM                    S01468                                      BUG9827
434400200529      ** Deal notice days (3A, from transaction)                                             BUG9827
434500200529     C                   PARM                    PDDNTCE                                     BUG9827
434600200529      ** Deal type (2A, from transaction)                                                    BUG9827
434700200529     C                   PARM                    IKTYPE                                      BUG9827
434800200529      ** Interest rate (11,7P)                                                               BUG9827
434900200529     C                   PARM                    IKINTR                                      BUG9827
435000200529      ** Deal amount (15,0P, from caller)                                                    BUG9827
435100200529     C                   PARM                    IKAMNP                                      BUG9827
435200200529      ** Interest calculation method (1A, from transaction)                                  BUG9827
435300200529     C                   PARM                    IKICMT                                      BUG9827
435400200529      ** Deal value date in Midas day number format (5,0P)                                   BUG9827
435500200529     C                   PARM                    IKDVSD                                      BUG9827
435600200529      ** Currency FldNameArr OK flag (1A)                                                    BUG9827
435700200529     C                   PARM      'Y'           DDCCYOK           1                         BUG9827
435800200529      ** Number of decimal places in deal currency (1,0S, from SDCURRPD)                     BUG9827
435900200529     C                   PARM                    PCYDP                                       BUG9827
436000200529      ** Value date field OK (1A)                                                            BUG9827
436100200529     C                   PARM      'Y'           DDVDATOK          1                         BUG9827
436200200529      ** Notice days field OK (1A)                                                           BUG9827
436300200529     C                   PARM      'Y'           DDNTCEOK          1                         BUG9827
436400200529      ** Amount field OK (1A)                                                                BUG9827
436500200529     C                   PARM      'Y'           DDAMNPOK          1                         BUG9827
436600200529      ** Base Rate field OK (1A)                                                             BUG9827
436700200529     C                   PARM      'Y'           DDBSRCOK          1                         BUG9827
436800200529      ** Spread/Rate field OK (1A)                                                           BUG9827
436900200529     C                   PARM      'Y'           DDSPRTOK          1                         BUG9827
437000200529      ** Calculation method field OK (1A)                                                    BUG9827
437100200529     C                   PARM      'Y'           DDICMTOK          1                         BUG9827
437200200529      ** Maturity date (6A, from transaction)                                                BUG9827
437300200529     C                   PARM                    PDDMDAT                                     BUG9827
437400200529      ** Maturity date in Midas day number format (5,0P)                                     BUG9827
437500200529     C                   PARM                    IKMATD                                      BUG9827
437600200529      ** Maturity date field OK (1A)                                                         BUG9827
437700200529     C                   PARM      'Y'           DDMDATOK          1                         BUG9827
437800200529      ** Notice days (3,0S)                                                                  BUG9827
437900200529     C                   PARM                    PNTCE                                       BUG9827
438000200529      ** First and last day interest flag (1A, from transaction)                             BUG9827
438100200529     C                   PARM                    IKFLID                                      BUG9827
438200200529      ** Round-down interest flag (1A, from transaction)                                     BUG9827
438300200529     C                   PARM                    IKRDFC                                      BUG9827
438400200529      ** Decimal separator (1A, from SDDEALPD)                                               BUG9827
438500200529     C                   PARM      *blanks       NNDCSP                                      BUG9827
438600200529                                                                                             BUG9827
438700200529     C                   IF        ReturnCode <> *BLANKS                                     BUG9827
438800200529     C     *LOCK         IN        LDA                                                       BUG9827
438900200529     C                   EVAL      DBASE = 905                                               BUG9827
439000200529     C                   EVAL      DBFILE = 'ZAVTOTINT'                                      BUG9827
439100200529     C                   OUT       LDA                                                       BUG9827
439200200529     C                   EXSR      *PSSR                                                     BUG9827
439300200529     C                   ENDIF                                                               BUG9827
439400200529                                                                                             BUG9827
439500200529     C                   ENDSR                                                               BUG9827
439600200529      *****************************************************************                      BUG9827
439700200529      /EJECT                                                                                 BUG9827
439800200529      *****************************************************************                      BUG9827
439900200529      *                                                               *                      BUG9827
440000200529      * UPDATEFIDT  - Call update module to update database for       *                      BUG9827
440100200529      *               fiduciary takings                               *                      BUG9827
440200200529      *                                                               *                      BUG9827
440300200529      *****************************************************************                      BUG9827
440400200529     C     UPDATEFIDT    BEGSR                                                               BUG9827
440500200529                                                                                             BUG9827
440600200529      ** Deal Number                                                                         BUG9827
440700200529     C                   IF        VSFDLNO <> *blanks                                        BUG9827
440800200529     C                   MOVE      VSFDLNO       IKDN38                                      BUG9827
440900200529     C                   ELSE                                                                BUG9827
441000200529     C                   EXSR      SETUPDEALN                                                BUG9827
441100200529     C                   ENDIF                                                               BUG9827
441200200529      *                                                                                      BUG9827
441300200529      * Charges and Commissions                                                              BUG9827
441400200529      *                                                                                      BUG9827
441500200529     C                   If        DDACTN = 'I'                                              BUG9827
441600200529     C                   EXSR      SETCHGCOM                                                 BUG9827
441700200529     C                   EndIf                                                               BUG9827
441800200529      *                                                                                      BUG9827
441900200529      * Deals updates                                                                        BUG9827
442000200529      *                                                                                      BUG9827
442100200529     C                   CALLB     'MMLDNIUPM'                                               BUG9827
442200200529     C                   PARM                    @RTCD                                       BUG9827
442300200529     C                   PARM                    ValidDeal                                   BUG9827
442400200529     C                   PARM                    #FPAYF                                      BUG9827
442500200529     C                   PARM                    #FRECF                                      BUG9827
442600200529      ** FRCD Issued Extension details before update                                          256638
442700200529     C                   PARM                    PBFRCD          100                          256638
442800200529      ** FRCD Issued Extension details after update                                           256638
442900200529     C                   PARM                    PAFRCD          100                          256638
443000200529      *                                                                                       256638
443100200529      *                                                                                      BUG9827
443200200529     C     @RTCD         IFEQ      *BLANK                                                    BUG9827
443300200529     C                   CALLB     'MMLDNIUPD'                                               BUG9827
443400200529     C                   PARM                    @RTCD                                       BUG9827
443500200529     C                   PARM                    ValidDeal                                   BUG9827
443600200529     C                   END                                                                 BUG9827
443700200529      *                                                                                      BUG9827
443800200529                                                                                             BUG9827
443900200529     C                   ENDSR                                                               BUG9827
444000200529      *****************************************************************                      BUG9827
444100200529      /EJECT                                                                                 BUG9827
444200200529      *****************************************************************                      BUG9827
444300200529      *                                                               *                      BUG9827
444400200529      * SETCHGCOM   - Setup Charges and Commissinons for deal         *                      BUG9827
444500200529      *                                                               *                      BUG9827
444600200529      *****************************************************************                      BUG9827
444700200529     C     SETCHGCOM     BEGSR                                                               BUG9827
444800200529      *                                                                                      BUG9827
444900200529     C                   MOVE      IKDN38        PDLNO                                       BUG9827
445000200529     C                   MOVE      IKCNUM        WWCNUM            6                         BUG9827
445100200529     C     WWCNUM        CHAIN     SDCUSTL1                           91                     BUG9827
445200200529      *                                                                                      BUG9827
445300200529      ** ------------------- **                                                              BUG9827
445400200529      ** Charges calculation **                                                              BUG9827
445500200529      ** ------------------- **                                                              BUG9827
445600200529      *                                                                                      BUG9827
445700200529     C                   MOVE      *BLANKS       CHGCDE                                      BUG9827
445800200529     C                   MOVE      *BLANKS       IKFCGC                                      BUG9827
445900200529     C                   MOVE      *BLANKS       IKFCGD                                      BUG9827
446000200529     C                   Z-ADD     0             IKFCGA                                      BUG9827
446100200529     C                   Z-ADD     0             IKFCGT                                      BUG9827
446200200529                                                                                             BUG9827
446300200529     C     BNCHTK        IFEQ      'Y'                                                       BUG9827
446400200529     C     BBCHRG        ANDNE     *BLANKS                                                   BUG9827
446500200529     C     *IN91         ANDEQ     *OFF                                                      BUG9827
446600200529                                                                                             BUG9827
446700200529     C     BBCHRG        CHAIN     SDCCGRL0                           90                     BUG9827
446800200529     C     *IN90         IFEQ      *OFF                                                      BUG9827
446900200529     C     CCRECI        ANDEQ     'D'                                                       BUG9827
447000200529     C                   MOVEL     CCCHOD        CHGCDE                                      BUG9827
447100200529     C                   MOVEL     IKCCY         WWCCY                                       BUG9827
447200200529     C     BNCTBC        IFEQ      'Y'                                                       BUG9827
447300200529     C                   MOVE      BJCYCD        WWCCY                                       BUG9827
447400200529     C                   ENDIF                                                               BUG9827
447500200529     C                   MOVEL     CHGCDE        FDCCOM                                      BUG9827
447600200529                                                                                             BUG9827
447700200529     C     WWDLCC        CHAIN     DLCCGDL0                           90                     BUG9827
447800200529     C     *IN90         IFEQ      *OFF                                                      BUG9827
447900200529     C                   CALLB     'MMFIDTCHG'                                               BUG9827
448000200529     C                   PARM                    PSProcName                                  BUG9827
448100200529     C                   PARM                    DDACTN                                      BUG9827
448200200529     C                   PARM                    PDLNO                                       BUG9827
448300200529     C*******************PARM      IKCNUM        PCustNo           6 0               BUG9827 CSD027A
448400200529     C                   PARM      IKCNUM        PCustNo           6                         CSD027A
448500200529     C                   PARM                    IKCCY                                       BUG9827
448600200529     C                   PARM      IKAMNP        PAMNP            13 0                       BUG9827
448700200529     C                   PARM                    CHGCDE           20                         BUG9827
448800200529     C                   PARM      *BLANKS       PFCGD            20                         BUG9827
448900200529     C                   PARM      *ZERO         PFCGA            13 0                       BUG9827
449000200529     C                   PARM      *BLANKS       PRTCD             7                         BUG9827
449100200529                                                                                             BUG9827
449200200529     C     PRTCD         IFEQ      *BLANKS                                                   BUG9827
449300200529     C**********         MOVE      CHGCDE        IKFCGC                             BUG9827 BUG10725
449400200529     C                   MOVEL     CHGCDE        IKFCGC                                     BUG10725
449500200529     C                   MOVE      PFCGD         IKFCGD                                      BUG9827
449600200529     C                   Z-ADD     PFCGA         IKFCGA                                      BUG9827
449700200529     C                   ENDIF                                                               BUG9827
449800200529     C                   ENDIF                                                               BUG9827
449900200529     C                   ENDIF                                                               BUG9827
450000200529     C                   ENDIF                                                               BUG9827
450100200529      *                                                                                      BUG9827
450200200529      ** ---------------------- **                                                           BUG9827
450300200529      ** Commission calculation **                                                           BUG9827
450400200529      ** ---------------------- **                                                           BUG9827
450500200529      *                                                                                      BUG9827
450600200529                                                                                             BUG9827
450700200529     C                   MOVEL     *BLANKS       CMCCDE                                      BUG9827
450800200529     C                   MOVEL     *BLANKS       IKFCMC                                      BUG9827
450900200529     C                   MOVE      *BLANKS       IKFCMD                                      BUG9827
451000200529     C                   Z-ADD     0             IKFCMA                                      BUG9827
451100200529     C                   Z-ADD     0             IKFCMT                                      BUG9827
451200200529     C     BNCOTK        IFEQ      'Y'                                                       BUG9827
451300200529     C     *IN91         ANDEQ     *OFF                                                      BUG9827
451400200529     C     BBCOMG        ANDNE     *BLANKS                                                   BUG9827
451500200529     C     IKMATD        ANDNE     *ZEROS                                                    BUG9827
451600200529                                                                                             BUG9827
451700200529     C     BBCOMG        CHAIN     SDCCGRL0                           90                     BUG9827
451800200529     C     *IN90         IFEQ      *OFF                                                      BUG9827
451900200529     C     CCRECI        ANDEQ     'D'                                                       BUG9827
452000200529     C                   MOVEL     CCCCOD        CMCCDE                                      BUG9827
452100200529     C                   MOVEL     IKCCY         WWCCY                                       BUG9827
452200200529     C     BNCTBC        IFEQ      'Y'                                                       BUG9827
452300200529     C                   MOVE      BJCYCD        WWCCY                                       BUG9827
452400200529     C                   ENDIF                                                               BUG9827
452500200529     C                   MOVEL     CMCCDE        FDCCOM                                      BUG9827
452600200529     C     WWDLCC        CHAIN     DLCCGDL0                           90                     BUG9827
452700200529                                                                                             BUG9827
452800200529     C     *IN90         IFEQ      *OFF                                                      BUG9827
452900200529     C                   CALLB     'MMFIDTCOM'                                               BUG9827
453000200529     C                   PARM                    PSProcName                                  BUG9827
453100200529     C                   PARM                    DDACTN                                      BUG9827
453200200529     C                   PARM                    PDLNO                                       BUG9827
453300200529     C                   PARM      IKCNUM        PCustNo                                     BUG9827
453400200529     C                   PARM                    IKCCY                                       BUG9827
453500200529     C                   PARM                    IKTYPE                                      BUG9827
453600200529     C                   PARM      HKMATD        PMATD             5 0                       BUG9827
453700200529     C                   PARM      HKVDDD        PVDDD             2 0                       BUG9827
453800200529     C                   PARM      HKVDMM        PVDMM             2 0                       BUG9827
453900200529     C                   PARM      HKVDYY        PVDYY             2 0                       BUG9827
454000200529     C                   PARM                    HKRDFC                                      BUG9827
454100200529     C                   PARM                    HKICMT                                      BUG9827
454200200529     C                   PARM      IKAMNP        PAMNP15          15 0                       BUG9827
454300200529     C                   PARM                    CMCCDE           20                         BUG9827
454400200529     C                   PARM      *BLANKS       PFCMD            20                         BUG9827
454500200529     C                   PARM      *ZEROS        PFCMA            13 0                       BUG9827
454600200529     C                   PARM      *BLANKS       PRTCD                                       BUG9827
454700200529     C     PRTCD         IFEQ      *BLANKS                                                   BUG9827
454800200529     C                   MOVE      HKFCMC        IKFCMC                                      BUG9827
454900200529     C                   MOVE      PFCMD         IKFCMD                                      BUG9827
455000200529     C                   Z-ADD     PFCMA         IKFCMA                                      BUG9827
455100200529     C                   EndIF                                                               BUG9827
455200200529     C                   ENDIF                                                               BUG9827
455300200529     C                   ENDIF                                                               BUG9827
455400200529     C                   ENDIF                                                               BUG9827
455500200529                                                                                             BUG9827
455600200529     C                   ENDSR                                                               BUG9827
455700200529      *****************************************************************                      BUG9827
455800200529      /EJECT                                                                                 BUG9827
455900200529      *****************************************************************                      BUG9827
456000200529      *                                                               *                     BUG10341
456100200529      * FIDTERRMSG  - Setup Error messages for Fid. Taking Edittable  *                     BUG10341
456200200529      *                                                               *                     BUG10341
456300200529      *****************************************************************                     BUG10341
456400200529     C     FIDTERRMSG    BEGSR                                                              BUG10341
456500200529      *                                                                                     BUG10341
456600200529      * Need to go through error array, changing the old error msg code to the new          BUG10341
456700200529      * error msg code, setting the equivalent MsgDtaArr to be the row number               BUG10341
456800200529      *                                                                                     BUG10341
456900200529     C                   Eval      St = ErrTot + 1                                          BUG10341
457000200529     C                   Eval      Le = NewErrTot - ErrTot                                  BUG10341
457100200529     C                   Eval      pos = 0                                                  BUG10341
457200200529     C                   Eval      m = 0                                                    BUG10341
457300200529     C                   Eval      errID = 1                                                BUG10341
457400200529                                                                                            BUG10341
457500200529     C                   DOW       errID <= 16                                              BUG10341
457600200529                                                                                            BUG10341
457700200529     C                   Eval      pos = %lookup(OLDMSG(errID):MsgIDArr:St:Le)              BUG10341
457800200529     C                   If        pos <> 0                                                 BUG10341
457900200529     C                   MOVE      Tkg           TkgA                                       BUG10341
458000200529     C**********         Eval      MsgDtaArr(pos) = TkgA                           BUG10341 MD000091
458100200529     C                   EVAL      BLen = %Len(%Trim(TkgA))                                 MD000091
458200200529     C                   EVAL      MsgDtaArr(pos) = LenStr +%TRIM(TkgA)                     MD000091
458300200529     C                   Eval      MsgIDArr(pos) = NEWMSG(errID)                            BUG10341
458400200529     C                   Eval      m = m + 1                                                BUG10341
458500200529     C                   EndIf                                                              BUG10341
458600200529                                                                                            BUG10341
458700200529     C                   If        m = Le                                                   BUG10341
458800200529     C                   Leave                                                              BUG10341
458900200529     C                   EndIf                                                              BUG10341
459000200529     C                   Eval      ErrID = ErrID + 1                                        BUG10341
459100200529                                                                                            BUG10341
459200200529     C                   ENDDO                                                              BUG10341
459300200529                                                                                            BUG10341
459400200529     C                   ENDSR                                                              BUG10341
459500200529      *****************************************************************                     BUG10341
459600200529      /EJECT                                                                                BUG10341
459700200529      *****************************************************************                     BUG10341
459800200529      *                                                               *                       CER043
459900200529      *  SrPopCust - Subroutine to Populate Customer Details          *                       CER043
460000200529      *                                                               *                       CER043
460100200529      *  Called by: MAIN Processing                                   *                       CER043
460200200529      *                                                               *                       CER043
460300200529      *  Calls: SrRtvCust                                             *                       CER043
460400200529      *                                                               *                       CER043
460500200529      *****************************************************************                       CER043
460600200529      **********                                                                       CER043 CSF011
460700200529     C*****SrPopCust     BEGSR                                                         CER043 CSF011
460800200529      **********                                                                       CER043 CSF011
460900200529     C**********         CLEAR                   TranInCust                            CER043 CSF011
461000200529      **********                                                                       CER043 CSF011
461100200529      ***Retrieve Customer Details                                                     CER043 CSF011
461200200529     C**********         IF        DDCUST <> *BLANKS                                   CER043 CSF011
461300200529     C**********         EVAL      PCNum = DDCUST                                      CER043 CSF011
461400200529      **********                                                                       CER043 CSF011
461500200529     C**********         EXSR      SrRtvCust                                           CER043 CSF011
461600200529     C**********         IF        PRtcd = *BLANKS                                     CER043 CSF011
461700200529     C**********         EVAL      DDCSSN = BBCSSN                                     CER043 CSF011
461800200529     C**********         EVAL      DDCRNM = BBCRNM                                     CER043 CSF011
461900200529     C**********         EVAL      DDCRTN = BBCRTN                                     CER043 CSF011
462000200529     C**********         ENDIF                                                         CER043 CSF011
462100200529      **********                                                                       CER043 CSF011
462200200529     C**********         ENDIF                                                         CER043 CSF011
462300200529      **********                                                                       CER043 CSF011
462400200529     C**********         ENDSR                                                         CER043 CSF011
462500200529      *****************************************************************                       CER043
462600200529      /EJECT                                                                                  CER043
462700200529      *****************************************************************                       CER043
462800200529      *                                                               *                       CER043
462900200529      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CER043
463000200529      *                                                               *                       CER043
463100200529      *  Called by: SrPopCust                                         *                       CER043
463200200529      *                                                               *                       CER043
463300200529      *  Calls: None                                                  *                       CER043
463400200529      *                                                               *                       CER043
463500200529      *****************************************************************                       CER043
463600200529     C     SrRtvCust     BEGSR                                                                CER043
463700200529      *                                                                                       CER043
463800200529      ** Call AOCUSTR0 to get Customer Details                                                CER043
463900200529     C                   CALLB     'AOCUSTR0'                                                 CER043
464000200529     C                   PARM      *BLANKS       PRtcd                                        CER043
464100200529     C                   PARM      '*KEY   '     POptn                                        CER043
464200200529     C                   PARM                    PCNum                                        CER043
464300200529     C                   PARM      *BLANKS       PKey7                                        CER043
464400200529     C     SDCUST        PARM      SDCUST        DSSDY                                        CER043
464500200529      *                                                                                       CER043
464600200529     C                   ENDSR                                                                CER043
464700200529      *****************************************************************                       CER043
464800200529      /EJECT                                                                                  CER043
464900200529      *****************************************************************                       CER043
465000200529      *                                                               *                     MD022656
465100200529      *  SrPayAmnd - Check if Payment Settlements are amended         *                     MD022656
465200200529      *                                                               *                     MD022656
465300200529      *****************************************************************                     MD022656
465400200529     C     SrPayAmnd     BEGSR                                                              MD022656
465500200529                                                                                            MD022656
465600200529      ** Convert some file format fields in screen format to match                          MD022656
465700200529                                                                                            MD022656
465800200529     C                   EVAL      W#PONX = IKPONS                                          MD022656
465900200529     C                   MOVEL     IKPSTM        W#PSTM                                     MD022656
466000200529                                                                                            MD022656
466100200529     C                   IF        %LEN(%TRIM(DDPONX)) = 21                                 MD024884
466200200529     C                             OR %LEN(%TRIM(DDPONX)) = 18                              MD024884
466300200529     C                   MOVE      IKPONS        W#PONX                                     MD024884
466400200529     C                   MOVEL     IKPOBR        W#PONX                                     MD024884
466500200529     C                   ENDIF                                                              MD024884
466600200529                                                                                            MD024884
466700200529     C                   IF        DDPSCY <> *BLANKS                                        MD022656
466800200529     C                   EVAL      W#CCY = IKCCY                                            MD022656
466900200529     C                   ENDIF                                                              MD022656
467000200529                                                                                            MD022656
467100200529     C                   IF        DDPOBN <> *BLANKS                                        MD022656
467200200529     C                   EVAL      PCNum = DDPOBN                                           MD022656
467300200529     C                   EXSR      SrRtvCust                                                MD022656
467400200529     C                   EVAL      W#POBN = BBCUST                                          MD022656
467500200529     C                   ENDIF                                                              MD022656
467600200529                                                                                            MD022656
467700200529     C                   IF        DDPOCN <> *BLANKS                                        MD022656
467800200529     C                   EVAL      PCNum = DDPOCN                                           MD022656
467900200529     C                   EXSR      SrRtvCust                                                MD022656
468000200529     C                   EVAL      W#POCN = BBCUST                                          MD022656
468100200529     C                   ENDIF                                                              MD022656
468200200529     C                                                                                      MD022656
468300200529     C                   IF        DDRCRN <> *BLANKS                                        MD022849
468400200529     C                   EVAL      PCNum = DDRCRN                                           MD022849
468500200529     C                   EXSR      SrRtvCust                                                MD022849
468600200529      ** If valid customer number, move BBCUST (customer number)                            MD027415
468700200529      ** Else, need to check if it's a valid Counterparty Nostro.                           MD027415
468800200529     C                   IF        PRtcd = *BLANKS                                          MD027415
468900200529     C                   EVAL      W#RCRN = BBCUST                                          MD022849
469000200529     C                   ELSE                                                               MD027415
469100200529     C                   EXSR      ACCNST                                                   MD027415
469200200529     C                   IF        PRtcd = *BLANKS                                          MD027415
469300200529     C                   EVAL      W#RCRN = AWCPNC                                          MD027415
469400200529     C                   ELSE                                                               MD027415
469500200529     C                   EVAL      W#RCRN = *BLANKS                                         MD027415
469600200529     C                   ENDIF                                                              MD027415
469700200529     C                   ENDIF                                                              MD027415
469800200529     C                   ENDIF                                                              MD022849
469900200529     C                                                                                      MD022849
470000200529     C                   IF        DDRVNO <> *BLANKS                                        MD022849
470100200529     C                   EVAL      PCNum = DDRVNO                                           MD022849
470200200529     C                   EXSR      SrRtvCust                                                MD022849
470300200529     C                   EVAL      W#RVNO = BBCUST                                          MD022849
470400200529     C                   ENDIF                                                              MD022849
470500200529     C                                                                                      MD022849
470600200529     C                   IF        DDAWBN <> *BLANKS                                        MD022849
470700200529     C                   EVAL      PCNum = DDAWBN                                           MD022849
470800200529     C                   EXSR      SrRtvCust                                                MD022849
470900200529      ** If valid customer number, move BBCUST (customer number)                            MD027415
471000200529      ** Else, need to check if it's a valid Counterparty Nostro.                           MD027415
471100200529     C                   IF        PRtcd = *BLANKS                                          MD027415
471200200529     C                   EVAL      W#AWBN = BBCUST                                          MD022849
471300200529     C                   ELSE                                                               MD027415
471400200529     C                   EXSR      ACCNST                                                   MD027415
471500200529     C                   IF        PRtcd = *BLANKS                                          MD027415
471600200529     C                   EVAL      W#AWBN = AWCPNC                                          MD027415
471700200529     C                   ELSE                                                               MD027415
471800200529     C                   EVAL      W#AWBN = *BLANKS                                         MD027415
471900200529     C                   ENDIF                                                              MD027415
472000200529     C                   ENDIF                                                              MD027415
472100200529     C                   ENDIF                                                              MD022849
472200200529     C                                                                                      MD022849
472300200529     C                   IF        DDPIBN <> *BLANKS                                        MD022849
472400200529     C                   EVAL      PCNum = DDPIBN                                           MD022849
472500200529     C                   EXSR      SrRtvCust                                                MD022849
472600200529      ** If valid customer number, move BBCUST (customer number)                            MD027415
472700200529      ** Else, need to check if it's a valid Counterparty Nostro.                           MD027415
472800200529     C                   IF        PRtcd = *BLANKS                                          MD027415
472900200529     C                   EVAL      W#PIBN = BBCUST                                          MD022849
473000200529     C                   ELSE                                                               MD027415
473100200529     C                   EXSR      ACCNST                                                   MD027415
473200200529     C                   IF        PRtcd = *BLANKS                                          MD027415
473300200529     C                   EVAL      W#PIBN = AWCPNC                                          MD027415
473400200529     C                   ELSE                                                               MD027415
473500200529     C                   EVAL      W#PIBN = *BLANKS                                         MD027415
473600200529     C                   ENDIF                                                              MD027415
473700200529     C                   ENDIF                                                              MD027415
473800200529     C                   ENDIF                                                              MD022849
473900200529     C                                                                                      MD022849
474000200529     C                   IF        DDBENN <> *BLANKS                                        MD022849
474100200529     C                   EVAL      PCNum = DDBENN                                           MD022849
474200200529     C                   EXSR      SrRtvCust                                                MD022849
474300200529      ** If valid customer number, move BBCUST (customer number)                            MD027415
474400200529      ** Else, need to check if it's a valid Counterparty Nostro.                           MD027415
474500200529     C                   IF        PRtcd = *BLANKS                                          MD027415
474600200529     C                   EVAL      W#BENN = BBCUST                                          MD022849
474700200529     C                   ELSE                                                               MD027415
474800200529     C                   EXSR      ACCNST                                                   MD027415
474900200529     C                   IF        PRtcd = *BLANKS                                          MD027415
475000200529     C                   EVAL      W#BENN = AWCPNC                                          MD027415
475100200529     C                   ELSE                                                               MD027415
475200200529     C                   EVAL      W#BENN = *BLANKS                                         MD027415
475300200529     C                   ENDIF                                                              MD027415
475400200529     C                   ENDIF                                                              MD027415
475500200529     C                   ENDIF                                                              MD022849
475600200529     C                                                                                      MD022849
475700200529                                                                                            MD022656
475800200529      ** Compare Payment settlement fields                                                  MD022656
475900200529                                                                                            MD022656
476000200529     C                   Z-ADD     Idx           W#CNT                                      MD022656
476100200529                                                                                            MD022656
476200200529     C                   SELECT                                                             MD022656
476300200529     C                   WHEN      DDPSCY <> W#CCY                                          MD022656
476400200529     C                   ADD       1             Idx                                        MD022656
476500200529     C                   EVAL      FldNameArr(Idx) = 'DDPSCY'                               MD022656
476600200529                                                                                            MD022656
476700200529     C                   WHEN      DDPSTM <> W#PSTM                                         MD022656
476800200529     C                             AND W#CNT = Idx                                          MD022656
476900200529     C                   ADD       1             Idx                                        MD022656
477000200529     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'                               MD022656
477100200529                                                                                            MD022656
477200200529     C                   WHEN      DDPONX <> W#PONX                                         MD022656
477300200529     C                             AND W#CNT = Idx                                          MD022656
477400200529     C                   ADD       1             Idx                                        MD022656
477500200529     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                               MD022656
477600200529                                                                                            MD022656
477700200529     C**********         WHEN      DDRVNO <> IKRVNO                                MD022656 MD022849
477800200529     C                   WHEN      W#RVNO <> IKRVNO                                         MD022849
477900200529     C                             AND W#CNT = Idx                                          MD022656
478000200529     C                   ADD       1             Idx                                        MD022656
478100200529     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'                               MD022656
478200200529                                                                                            MD022656
478300200529     C                   WHEN      DDCVMR <> IKCVMR                                         MD022656
478400200529     C                             AND W#CNT = Idx                                          MD022656
478500200529     C                   ADD       1             Idx                                        MD022656
478600200529     C                   EVAL      FldNameArr(Idx) = 'DDCVMR'                               MD022656
478700200529                                                                                            MD022656
478800200529     C                   WHEN      W#POCN <> IKPOCN                                         MD022656
478900200529     C                             AND W#CNT = Idx                                          MD022656
479000200529     C                   ADD       1             Idx                                        MD022656
479100200529     C                   EVAL      FldNameArr(Idx) = 'DDPOCN'                               MD022656
479200200529                                                                                            MD022656
479300200529     C                   WHEN      W#POBN <> IKPOBN                                         MD022656
479400200529     C                             AND W#CNT = Idx                                          MD022656
479500200529     C                   ADD       1             Idx                                        MD022656
479600200529     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'                               MD022656
479700200529                                                                                            MD022656
479800200529     C**********         WHEN      DDRCRN <> IKRCRN                                MD022656 MD022849
479900200529     C                   WHEN      W#RCRN <> IKRCRN                                         MD022849
480000200529     C                             AND W#CNT = Idx                                          MD022656
480100200529     C                   ADD       1             Idx                                        MD022656
480200200529     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'                               MD022656
480300200529                                                                                            MD022656
480400200529     C                   WHEN      DDRCRA <> IKRCRA                                         MD022656
480500200529     C                             AND W#CNT = Idx                                          MD022656
480600200529     C                   ADD       1             Idx                                        MD022656
480700200529     C                   EVAL      FldNameArr(Idx) = 'DDRCRA'                               MD022656
480800200529                                                                                            MD022656
480900200529     C**********         WHEN      DDPIBN <> IKPIBN                                MD022656 MD022849
481000200529     C                   WHEN      W#PIBN <> IKPIBN                                         MD022849
481100200529     C                             AND W#CNT = Idx                                          MD022656
481200200529     C                   ADD       1             Idx                                        MD022656
481300200529     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'                               MD022656
481400200529                                                                                            MD022656
481500200529     C                   WHEN      DDPIBA <> IKPIBA                                         MD022656
481600200529     C                             AND W#CNT = Idx                                          MD022656
481700200529     C                   ADD       1             Idx                                        MD022656
481800200529     C                   EVAL      FldNameArr(Idx) = 'DDPIBA'                               MD022656
481900200529                                                                                            MD022656
482000200529     C**********         WHEN      DDAWBN <> IKAWBN                                MD022656 MD022849
482100200529     C                   WHEN      W#AWBN <> IKAWBN                                         MD022849
482200200529     C                             AND W#CNT = Idx                                          MD022656
482300200529     C                   ADD       1             Idx                                        MD022656
482400200529     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'                               MD022656
482500200529                                                                                            MD022656
482600200529     C                   WHEN      DDAWBA <> IKAWBA                                         MD022656
482700200529     C                             AND W#CNT = Idx                                          MD022656
482800200529     C                   ADD       1             Idx                                        MD022656
482900200529     C                   EVAL      FldNameArr(Idx) = 'DDAWBA'                               MD022656
483000200529                                                                                            MD022656
483100200529     C**********         WHEN      DDBENN <> IKBENN                                MD022656 MD022849
483200200529     C                   WHEN      W#BENN <> IKBENN                                         MD022849
483300200529     C                             AND W#CNT = Idx                                          MD022656
483400200529     C                   ADD       1             Idx                                        MD022656
483500200529     C                   EVAL      FldNameArr(Idx) = 'DDBENN'                               MD022656
483600200529                                                                                            MD022656
483700200529     C                   WHEN      DDBENA <> IKBENA                                         MD022656
483800200529     C                             AND W#CNT = Idx                                          MD022656
483900200529     C                   ADD       1             Idx                                        MD022656
484000200529     C                   EVAL      FldNameArr(Idx) = 'DDBENA'                               MD022656
484100200529                                                                                            MD022656
484200200529     C                   WHEN      DDBENA <> IKBENA                                         MD022656
484300200529     C                             AND W#CNT = Idx                                          MD022656
484400200529     C                   ADD       1             Idx                                        MD022656
484500200529     C                   EVAL      FldNameArr(Idx) = 'DDBENA'                               MD022656
484600200529                                                                                            MD022656
484700200529     C                   WHEN      %SUBST(InPaySttmt:674:140) <>                            MD022656
484800200529     C                             %SUBST(ValidDeal:731:140)                                MD022656
484900200529     C                             AND W#CNT = Idx                                          MD022656
485000200529     C                   ADD       1             Idx                                        MD022656
485100200529     C                   EVAL      FldNameArr(Idx) = 'DDDTP1'                               MD022656
485200200529                                                                                            MD022656
485300200529     C                   WHEN      DDDCHG <> IKDCHG                                         MD022656
485400200529     C                             AND W#CNT = Idx                                          MD022656
485500200529     C                   ADD       1             Idx                                        MD022656
485600200529     C                   EVAL      FldNameArr(Idx) = 'DDDCHG'                               MD022656
485700200529                                                                                            MD022656
485800200529     C                   WHEN      DDIC72 <> IKIC72                                         MD022656
485900200529     C                             AND W#CNT = Idx                                          MD022656
486000200529     C                   ADD       1             Idx                                        MD022656
486100200529     C                   EVAL      FldNameArr(Idx) = 'DDIC72'                               MD022656
486200200529                                                                                            MD022656
486300200529     C                   WHEN      %SUBST(InPaySttmt:820:210) <>                            MD022656
486400200529     C                             %SUBST(ValidDeal:874:210)                                MD022656
486500200529     C                             AND W#CNT = Idx                                          MD022656
486600200529     C                   ADD       1             Idx                                        MD022656
486700200529     C                   EVAL      FldNameArr(Idx) = 'DDBTB1'                               MD022656
486800200529                                                                                            MD022656
486900200529     C                   WHEN      DDPMAC <> IKPMAC                                         MD022656
487000200529     C                             AND W#CNT = Idx                                          MD022656
487100200529     C                   ADD       1             Idx                                        MD022656
487200200529     C                   EVAL      FldNameArr(Idx) = 'DDPMAC'                               MD022656
487300200529     C                   ENDSL                                                              MD022656
487400200529                                                                                            MD022656
487500200529      ** If there are difference in any of the fields,                                      MD022656
487600200529      ** issue the error message                                                            MD022656
487700200529                                                                                            MD022656
487800200529     C                   IF        W#CNT <> Idx                                             MD022656
487900200529     C                   EVAL      MsgIDArr(Idx) = '5046114'                                MD022656
488000200529     C                   ENDIF                                                              MD022656
488100200529                                                                                            MD022656
488200200529     C                   ENDSR                                                              MD022656
488300200529      *****************************************************************                     MD022656
488400200529      /EJECT                                                                                MD022656
488500200529      *****************************************************************                     MD022656
488600200529      *                                                               *                     MD022656
488700200529      *  SrRecAmnd - Check if Receipt Settlements are amended         *                     MD022656
488800200529      *                                                               *                     MD022656
488900200529      *****************************************************************                     MD022656
489000200529     C     SrRecAmnd     BEGSR                                                              MD022656
489100200529     C                                                                                      MD022656
489200200529                                                                                            MD022656
489300200529      ** Convert some file format fields in screen format to match                          MD022656
489400200529                                                                                            MD022656
489500200529     C                   EVAL      W#RONX = IKRONS                                          MD022656
489600200529                                                                                            MD024884
489700200529     C                   IF        %LEN(%TRIM(DDRONX)) = 21                                 MD024884
489800200529     C                             OR %LEN(%TRIM(DDRONX)) = 18                              MD024884
489900200529     C                   MOVE      IKRONS        W#RONX                                     MD024884
490000200529     C                   MOVEL     IKROBR        W#RONX                                     MD024884
490100200529     C                   ENDIF                                                              MD024884
490200200529                                                                                            MD024884
490300200529     C                   MOVEL     IKRSTM        W#RSTM                                     MD022656
490400200529     C                   IF        DDRSCY <> *BLANKS                                        MD022656
490500200529     C                   EVAL      W#CCY = IKCCY                                            MD022656
490600200529     C                   ENDIF                                                              MD022656
490700200529                                                                                            MD022656
490800200529     C                   IF        DDROBN <> *BLANKS                                        MD022656
490900200529     C                   EVAL      PCNum = DDROBN                                           MD022656
491000200529     C                   EXSR      SrRtvCust                                                MD022656
491100200529     C                   EVAL      W#ROBN  = BBCUST                                         MD022656
491200200529     c                   ENDIF                                                              MD022656
491300200529                                                                                            MD022656
491400200529     C                   IF        DDROCN <> *BLANKS                                        MD022656
491500200529     C                   EVAL      PCNum = DDROCN                                           MD022656
491600200529     C                   EXSR      SrRtvCust                                                MD022656
491700200529     C                   EVAL      W#ROCN = BBCUST                                          MD022656
491800200529     C                   ENDIF                                                              MD022656
491900200529     C                                                                                      MD022849
492000200529     C                   IF        DDRIBN <> *BLANKS                                        MD022849
492100200529     C                   EVAL      PCNum = DDRIBN                                           MD022849
492200200529     C                   EXSR      SrRtvCust                                                MD022849
492300200529      ** If valid customer number, move BBCUST (customer number)                            MD027415
492400200529      ** Else, need to check if it's a valid Counterparty Nostro.                           MD027415
492500200529     C                   IF        PRtcd = *BLANKS                                          MD027415
492600200529     C                   EVAL      W#RIBN = BBCUST                                          MD022849
492700200529     C                   ELSE                                                               MD027415
492800200529     C                   EXSR      ACCNST                                                   MD027415
492900200529     C                   IF        PRtcd = *BLANKS                                          MD027415
493000200529     C                   EVAL      W#RIBN = AWCPNC                                          MD027415
493100200529     C                   ELSE                                                               MD027415
493200200529     C                   EVAL      W#RIBN = *BLANKS                                         MD027415
493300200529     C                   ENDIF                                                              MD027415
493400200529     C                   ENDIF                                                              MD027415
493500200529     C                   ENDIF                                                              MD022849
493600200529                                                                                            MD022656
493700200529      ** Compare Payment settlement fields                                                  MD022656
493800200529                                                                                            MD022656
493900200529     C                   Z-ADD     Idx           W#CNT                                      MD022656
494000200529     C                   SELECT                                                             MD022656
494100200529                                                                                            MD022656
494200200529     C                   WHEN      DDRSCY <> W#CCY                                          MD022656
494300200529     C                   ADD       1             Idx                                        MD022656
494400200529     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'                               MD022656
494500200529                                                                                            MD022656
494600200529     C                   WHEN      DDRSTM <> W#RSTM                                         MD022656
494700200529     C                             AND W#CNT = Idx                                          MD022656
494800200529     C                   ADD       1             Idx                                        MD022656
494900200529     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'                               MD022656
495000200529                                                                                            MD022656
495100200529     C                   WHEN      DDRONX <> W#RONX                                         MD022656
495200200529     C                             AND W#CNT = Idx                                          MD022656
495300200529     C                   ADD       1             Idx                                        MD022656
495400200529     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                               MD022656
495500200529                                                                                            MD022656
495600200529     C**********         WHEN      DDRIBN <> IKRIBN                                MD022656 MD022849
495700200529     C                   WHEN      W#RIBN <> IKRIBN                                         MD022849
495800200529     C                             AND W#CNT = Idx                                          MD022656
495900200529     C                   ADD       1             Idx                                        MD022656
496000200529     C                   EVAL      FldNameArr(Idx) = 'DDRIBN'                               MD022656
496100200529                                                                                            MD022656
496200200529     C                   WHEN      DDRIBA <> IKRIBA                                         MD022656
496300200529     C                             AND W#CNT = Idx                                          MD022656
496400200529     C                   ADD       1             Idx                                        MD022656
496500200529     C                   EVAL      FldNameArr(Idx) = 'DDRIBA'                               MD022656
496600200529                                                                                            MD022656
496700200529     C                   WHEN      W#ROBN <> IKROBN                                         MD022656
496800200529     C                             AND W#CNT = Idx                                          MD022656
496900200529     C                   ADD       1             Idx                                        MD022656
497000200529     C                   EVAL      FldNameArr(Idx) = 'DDROBN'                               MD022656
497100200529                                                                                            MD022656
497200200529     C                   WHEN      W#ROCN <> IKROCN                                         MD022656
497300200529     C                             AND W#CNT = Idx                                          MD022656
497400200529     C                   ADD       1             Idx                                        MD022656
497500200529     C                   EVAL      FldNameArr(Idx) = 'DDROCN'                               MD022656
497600200529                                                                                            MD022656
497700200529     C                   WHEN      DDRMAC <> IKRMAC                                         MD022656
497800200529     C                             AND W#CNT = Idx                                          MD022656
497900200529     C                   ADD       1             Idx                                        MD022656
498000200529     C                   EVAL      FldNameArr(Idx) = 'DDRMAC'                               MD022656
498100200529     C                   ENDSL                                                              MD022656
498200200529                                                                                            MD022656
498300200529      ** If there are difference in any of the fields,                                      MD022656
498400200529      ** issue the error message                                                            MD022656
498500200529                                                                                            MD022656
498600200529     C                   IF        W#CNT <> Idx                                             MD022656
498700200529     C                   EVAL      MsgIDArr(Idx) = '5046115'                                MD022656
498800200529     C                   ENDIF                                                              MD022656
498900200529     C                   ENDSR                                                              MD022656
499000200529      *****************************************************************                     MD022656
499100200529      /EJECT                                                                                MD022656
499200200529      *****************************************************************                     MD022656
499300200529**  CPY@
499400200529(c) Finastra International Limited 2003
499500200529**  CTDATA OLDMSG                                                                           BUG10341
499600200529MMA0568   MMA1320                                                                           BUG10341
499700200529MMA0569   MMA1321                                                                           BUG10341
499800200529MMA0582   MMA1322                                                                           BUG10341
499900200529MMA0571   MMA1323                                                                           BUG10341
500000200529MMM9010   MMA1324                                                                           BUG10341
500100200529MMM9011   MMA1325                                                                           BUG10341
500200200529MMM9012   MMA1326                                                                           BUG10341
500300200529MMA0572   MMA1327                                                                           BUG10341
500400200529MMA0573   MMA1328                                                                           BUG10341
500500200529MMA0574   MMA1329                                                                           BUG10341
500600200529MMA0575   MMA1330                                                                           BUG10341
500700200529USR8627   MMA1331                                                                           BUG10341
500800200529USR8628   MMA1332                                                                           BUG10341
500900200529MMA0576   MMA1333                                                                           BUG10341
501000200529MMA0577   MMA1334                                                                           BUG10341
501100200529MMA0578   MMA1335                                                                           BUG10341
