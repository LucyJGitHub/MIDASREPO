000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SD Customer details screen input')               *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Standing Data Module                                 *
000900200529      *                                                               *
001000200529      *  SDCUSDSIN - CUSTOMER DETAILS SCREEN INPUT                    *
001100200529      *                                                               *
001200200529      *  Function:  This is the main screen input function            *
001300200529      *             for Customer Details.                             *
001400200529      *                                                               *
001500200529      *  (c) Finastra International Limited 2001                      *
001600200529      *                                                               *
001700200604      *  Last Amend No. 252069             Date 22May20               *
001900200618      *  Prev Amend No. MD054028           Date 05Sep19               *
002000200529      *                 CER050             Date 16Jun19               *
002100200529      *                 MD046248           Date 27Oct17               *
002200200529      *                 LLN022A            Date 03Jun15               *
002300200529      *                 LLN022             Date 03Jun15               *
002400200529      *                 CER070             Date 24Nov14               *
002500200529      *                 MD030956           Date 09Oct14               *
002600200529      *                 MD022854           Date 14Oct13               *
002700200529      *                 MD022463           Date 27Sep13               *
002800200529      *                 MD022395           Date 15Sep13               *
002900200529      *                 MD022443           Date 18Sep13               *
003000200529      *                 CFT050             Date 03Jun13               *
003100200529      *                 CSW213             Date 03Jun13               *
003200200529      *                 CLE134             Date 01Aug12               *
003300200529      *                 AR787620           Date 10Jun11               *
003400200529      *                 CER059             Date 19Jul10               *
003500200529      *                 BUG26917A          Date 27Jan10               *
003600200529      *                 BUG26917           Date 20Jan10               *
003700200529      *                 BUG23518           Date 30Mar09               *
003800200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
003900200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
004000200529      *                 256564             Date 17Sep08               *
004100200529      *                 248913             Date 11Jul07               *
004200200529      *                 CSW207A            Date 08Jun07               *
004300200529      *                 CSW207             Date 08Jun07               *
004400200529      *                 249076             Date 03Aug07               *
004500200529      *                 244030             Date 28Nov06               *
004600200529      *                 CRE026             Date 24May06               *
004700200529      *                 BUG13228           Date 07Feb07               *
004800200529      * Midas Plus 1.3 ----------- Base ------------------------------*
004900200529      *                 BG12345A           Date 29Oct06               *
005000200529      *                 BUG11917           Date 18Aug06               *
005100200529      *                 BUG11907           Date 16Aug06               *
005200200529      *                 BUG11889           Date 13Aug06               *
005300200529      *                 213713             Date 06Jun06               *
005400200529      *                 BUG8425            Date 24May06               *
005500200529      *                 237595             Date 07Feb06               *
005600200529      *                 CSD031             Date 10Apr06               *
005700200529      *                 BUG8134            Date 10Oct05               *
005800200529      *                 CSD027A            Date 05May06               *
005900200529      *                 CSD027             Date 09Dec05               *
006000200529      *                 BUG10817           Date 17Mar06               *
006100200529      *                 BUG10295           Date 02Feb06               *
006200200529      *                 CER001             Date 25Apr05               *
006300200529      *                 CSD028             Date 22Aug05               *
006400200529      *                 CGL031             Date 05Jul04               *
006500200529      *                 235524             Date 26Aug05               *
006600200529      *                 CSW037A            Date 02May05               *
006700200529      *                 BUG6565            Date 05Apr05               *
006800200529      *                 BUG6198            Date 04Apr05               *
006900200529      *                 BUG5139            Date 10Mar05               *
007000200529      *                 CSD025             Date 11Jan05               *
007100200529      *                 CSW037             Date 15Dec04               *
007200200529      *                 CSW036             Date 15Dec04               *
007300200529      *                 BUG4454            Date 08Oct04               *
007400200529      *                 BUG3362            Date 28Jul04               *
007500200529      *                 CFX001             Date 20Oct03               *
007600200529      *                 CLE025             Date 20Oct03               *
007700200529      *                 BUG2664            Date 21May04               *
007800200529      *                 CSD021             Date 14Jul03               *
007900200529      *                 222373             Date 24Oct03               *
008000200529      *                 CGP001             Date 23May03               *
008100200529      *                 CSD012             Date 15Oct02               *
008200200529      * Midas Release 4.01.03 ----------------------------------------*
008300200529      *                 212263             Date 21Nov02               *
008400200529      * Midas Release 4.01.02 ----------------------------------------*
008500200529      *                 203036             Date 10May02               *
008600200529      *                 202805             Date 10May02               *
008700200529      *                 192916             Date 27Mar02               *
008800200529      * Midas Release 4.01 -------------------------------------------*
008900200529      *                 CSC011             Date 18Sep01               *
009000200529      *                 193883             Date 20Nov01               *
009100200529      *                 CSW024             Date 31Aug01               *
009200200529      *                 196149             Date 16Aug01               *
009300200529      * Midas Release 4 --------------- Base -------------------------*
009400200529      * Midas DBA 3.05 -----------------------------------------------*
009500200529      *                 CRE007             Date 01Mar01               *
009600200529      *                 185595             Date 30Oct00               *
009700200529      *                 CPB002             Date 13Dec99               *
009800200529      *                 189774             Date 13Feb01               *
009900200529      * Midas DBA 3.04 -----------------------------------------------*
010000200529      *                 CSD007             Date 28Aug00               *
010100200529      *                 CDL008             Date 02May00               *
010200200529      * Midas DBA 3.02 -----------------------------------------------*
010300200529      *                 CAP014             Date 20Dec99               *
010400200529      *                 CAP034  *CREATE    Date 25May99               *
010500200529      *                                                               *
010600200529      *---------------------------------------------------------------*
010700200529      *                                                               *
010800200529      *  252069 - Database error message occurs when there is a       *
010900200529      *           record locking issue.                               *
011600200529      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
011700200529      *             being updated                                     *
011800200529      *  CER050 - Annualised Percentage Rate (Recompile)              *
011900200529      *  MD046248 - Finastra Rebranding                               *
012000200529      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
012100200529      *            /COPY members and add switchability.               *
012200200529      *  LLN022 - BOE Upgrade to MidasPlus.                           *
012300200529      *           Recompiled over changes in /COPY                    *
012400200529      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
012500200529      *  MD030956 - Additional changes to BFM-TI enhancement          *
012600200529      *  MD022854 - No Legal entity identifier for input              *
012700200529      *  MD022463 - No screen is displayed to show Bank Directory     *
012800200529      *             Plus Detail Screen on Linked Customers during     *
012900200529      *             Amend and Enquire                                 *
013000200529      *  MD022395 - Value of Clearing System on previously checked    *
013100200529      *             customer is copied into another customer when     *
013200200529      *             amending it                                       *
013300200529      *  MD022443 - Clearing System incorrect defaulting for ISO      *
013400200529      *             Country code CA and CH                            *
013500200529      *  CFT050 - SWIFTRef Directories upload                         *
013600200529      *  CSW213 - SWIFT Changes 2013                                  *
013700200529      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
013800200529      *  AR787620 - Hooks Incorporation                               *
013900200529      *             WNCPYSRC,SDH00104                                 *
014000200529      *             WNCPYSRC,SDH00105                                 *
014100200529      *             WNCPYSRC,SDH00109                                 *
014200200529      *  CER059 - German Feature Upgrade to Delhi                     *
014300200529      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
014400200529      *  BUG26917A - Reverse fix for bug26917                         *
014500200529      *  BUG26917 - COB error when customer is declared as taxable    *
014600200529      *           w/ German features installed and no additional      *
014700200529      *           customers information is set up                     *
014800200529      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
014900200529      *             Customer Closure                                  *
015000200529      *  256564 - Recompile due to PF changes done by fix 256330      *
015100200529      *  248913 - Disable F7/F8 or Next/Previous screen option during *
015200200529      *           input or amend.                                     *
015300200529      *  CSW207A - SWIFT 2007 Changes                                 *
015400200529      *  CSW207 - SWIFT 2007 Changes                                  *
015500200529      *  249076 - Enhance error message S270004 to show character     *
015600200529      *           and position that is not allowed in SDSVALPD.       *
015700200529      *  244030 - Clear datastructure for further details to prevent  *
015800200529      *           database error during insertion of new customers.   *
015900200529      *  CRE026 - Consumer Banking (Recompile)                        *
016000200529      *  BUG13228 - Need to pass status of ULX004 to SDCUSD2SN        *
016100200529      *  BG12345A - I/O Operation was applied tp closed File SDINX10  *
016200200529      *  BUG11917 - Different error message appear when enquiring/    *
016300200529      *             accepting/deleting a record in zonal acceptance   *
016400200529      *  BUG11907 - System hangs when rejecting a customer record     *
016500200529      *             in acceptance list                                *
016600200529      *  BUG11889 - Alphanumeric customer not accepted in zonal F11   *
016700200529      *  213713 - Window processing not performed when PB module is   *
016800200529      *           switched off.  Ensure window is displayed when      *
016900200529      *           window processing is on and PB module is off.       *
017000200529      *  BUG8425 - Update customer file before proceeding to further  *
017100200529      *            details especially Securities and Futures and      *
017200200529      *            options.                                           *
017300200529      *  237595 - Amend program such that when action code is 'D',    *
017400200529      *           access is allowed to the next screens, enabling the *
017500200529      *           user to delete further customer details (i.e.,      *
017600200529      *           marketing information, etc.).  Applied fix 230859.  *
017700200529      *  CSD031 - Enhanced Centralised Static Data                    *
017800200529      *  BUG8134 - Recompiled source to fix this bug                  *
017900200529      *  CSD027A - Conversion Of Customer Number to Alpha             *
018000200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
018100200529      *  BUG10817 - DB Error upon accessing SDCUX2L0                  *
018200200529      *  BUG10295 - Customer details extension missing                *
018300200529      *  CER001 - LUX Upgrade to MidasPlus                            *
018400200529      *  CSD028 - KYC (Standing Data Authorisations )                 *
018500200529      *  CGL031 - Taxation on Savings Income                          *
018600200529      *  235524 - Show "Message Routing Maintenance" screen on enquiry*
018700200529      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
018800200529      *  BUG6565- Window processing not properly handled in SDCUSDSIN *
018900200529      *  BUG6198 - Cannot save new Details for CUSD (Recompile)       *
019000200529      *  BUG5139 - Unable to process additional customer during       *
019100200529      *            insert                                             *
019200200529      *  CSD025 - Customer De-Activation                              *
019300200529      *  CSW037 - Additional Field Data on MT300/MT320                *
019400200529      *  CSW036 - Dual SWIFT BIC held on Client Details               *
019500200529      *  BUG4454 - Database error when inserting a customer with      *
019600200529      *           additional customer details                         *
019700200529      *  BUG3362 - Added processing for TI details.                   *
019800200529      *  CFX001 - FX Margin Trading                                   *
019900200529      *  CLE025 - Credit Lines                                        *
020000200529      *  BUG2664 - Amend program such that BBTICS is not reset during *
020100200529      *            amendment of TI client.  Apply part of fix 219329. *
020200200529      *  CSD021 - System generated customer number.                   *
020300200529      *  222373 - Parameter Mismatch                                  *
020400200529      *  CGP001 - Global Processing                                   *
020500200529      *  CSD012 - Standing Data Authorisation                         *
020600200529      *  212263 - Complete CPB002 : the call of AOPLCSR0 requires     *
020700200529      *           4 parameters                                        *
020800200529      *           Condition the call : if PM is off, do not call      *
020900200529      *  203036 - If Private Banking Module is not Switched On, don't *
021000200529      *           display screen.                                     *
021100200529      *  202805 - Using API, amended FX Netting Details not updated.  *
021200200529      *  192916 - Rollback of window updates wrongly managed in Core  *
021300200529      *           API's modules RPR and SIN.                          *
021400200529      *  CSC011 - 24x7 Midas Availability                             *
021500200529      *  193883 - Recompile over changed SDCUSDUPD.                   *
021600200529      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
021700200529      *  196149 - Update BBTICS with the value of FDTICS from SD0014V.*
021800200529      *  CRE007 - Base Rate Tax 2001                                  *
021900200529      *  185595 - Impossible to input "Further Details" during Input  *
022000200529      *  CPB002 - New Private Banking Customer Processing.            *
022100200529      *  189774 - Window processing for Customer Details API program  *
022200200529      *  CSD007 - Customer Closing:                                   *
022300200529      *           Allow for action codes 'C' (closure) and 'R'        *
022400200529      *           (release).                                          *
022500200529      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
022600200529      *  CAP014 - Repair function enhancements                        *
022700200529      *  CAP034 - Conversion of SD inputs into modular structure to   *
022800200529      *           use as APIs.                                        *
022900200529      *                                                               *
023000200529      *****************************************************************
023100200529
023200200529     FSDCUSTL5  IF   E           K DISK    INFSR(*PSSR)                                       202805
023300200529      *                                                                                       CER001
023400200529     FSDCUX2L0  IF   E           K DISK    USROPN                                             CER001
023500200529     F                                     RENAME(SDCUSTF6:RTVIDXA)                           CER001
023600200529     F                                     INFSR(*PSSR)                                       CER001
023700200529     F                                     COMMIT                                             CER001
023800200529                                                                                              CER001
023900200529      ** Midas ER Institutions - Economic Sectors                                             CER001
024000200529     FSDINX1L0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
024100200529     F                                     USROPN                                             CER001
024200200529                                                                                              CER001
024300200529      ** Midas ER Country Codes - LU Ext. index                                               CER001
024400200529     FSDCTX2L0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
024500200529     F                                     USROPN                                             CER001
024600200529                                                                                              CER001
024700200529     FSDCUX1L0  IF   E           K DISK    USROPN                                             CER001
024800200529     F                                     RENAME(SDCUSTDL:RTVIDXB)                           CER001
024900200529     F                                     INFSR(*PSSR)                                       CER001
025000200529     F                                     COMMIT                                             CER001
025100200529     FSDACSTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD031
025200200529     F                                     RENAME(SDCUSTD0: SDACSTD1)                         CSD031
025300200529      ** SWIFTRef BANK DIRECTORY Plus                                                         CFT050
025400200529     FMEBIB3L0  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
025500200529      ** Country codes                                                                        CFT050
025600200529     FSDCTRYL3  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
025700200529      ** SWIFT Customer extension                                                             CFT050
025800200529     FSDCSSWL2  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
025900200529
026000200529     F/COPY WNCPYSRC,SDCUSDSF01
026100200529      *****************************************************************
026200200529      ** +--------------------------------------+
026300200529      ** ¦ Automatically included D-specs       ¦
026400200529      ** ¦ ==============================       ¦
026500200529      ** +--------------------------------------+
026600200529      **
026700200529      **--------------------------------------------------------------------------------------------
026800200529      ** The following /COPY line includes (among others) the LDA layout
026900200529      ** and the copyright array definition:
027000200529     D/COPY ZACPYSRC,STD_D_SPEC
027100200529      **--------------------------------------------------------------------------------------------
027200200529
027300200529      **--------------------------------------------------------------------------------------------
027400200529      ** The following /COPY includes the MM standard declares:
027500200529     D/COPY ZACPYSRC,STDDECLARE
027600200529      **--------------------------------------------------------------------------------------------
027700200529
027800200529      **--------------------------------------------------------------------------------------------
027900200529      ** The following /COPY line includes all the defined fields in the
028000200529      ** Program Status Data Structures.  They have meaningful
028100200529      ** names, prefixed by 'PS'.
028200200529     D/COPY ZACPYSRC,PSDS
028300200529      **--------------------------------------------------------------------------------------------
028400200529
028500200529      **--------------------------------------------------------------------------------------------
028600200529      ** The following /COPY line includes the definitions for error and
028700200529      ** warning message arrays.
028800200529     D/COPY ZACPYSRC,ERR_ARRAYS
028900200529      **--------------------------------------------------------------------------------------------
029000200529
029100200529      ** +--------------------------------------+
029200200529      ** ¦ End of automatically included D-specs¦
029300200529      ** ¦ =====================================¦
029400200529      ** +--------------------------------------+
029500200529
029600200529      *****************************************************************
029700200529      /EJECT
029800200529      *****************************************************************
029900200529
030000200529      ** +--------------------------------------+
030100200529      ** ¦ Manually included D-specs            ¦
030200200529      ** ¦ =========================            ¦
030300200529      ** +--------------------------------------+
030400200529
030500200529      ** +--------------------------------------+
030600200529      ** ¦ Named constants                      ¦
030700200529      ** ¦ ===============                      ¦
030800200529      ** +--------------------------------------+
030900200529
031000200529      ** +--------------------------------------+
031100200529      ** ¦ Arrays and Data Structures           ¦
031200200529      ** ¦ ==========================           ¦
031300200529      ** +--------------------------------------+
031400200529
031500200529      * Current Customer in File Format
031600200529     D CrCuFilFmt    E DS                  EXTNAME(SDCUSTPD)
031700200529     D                                     PREFIX(C_)
031800200529
032000200529      * Current Customer - SWIFT Details  in File Format                                      CSW207
032100200529     D CrSwFilFmt    E DS                  EXTNAME(SDCSSWPD)                                  CSW207
032200200529     D                                     PREFIX(C_)                                         CSW207
032300200529                                                                                              CSW207
032400200529     D TranInACU3    E DS                  EXTNAME (SDACU3DPD)                                CER059
032500200529     D TranInACU4    E DS                  EXTNAME (SDACU4DPD)                                CER059
032600200529     D TranInCUAH    E DS                  EXTNAME (SDCUAHDPD)                                CER059
032700200529     D                                     PREFIX(AH)                                         CER059
032800200529     D TranInCCTX    E DS                  EXTNAME (SDCCTXDPD)                                CER059
032900200529     D                                     PREFIX(TX)                                         CER059
033000200529                                                                                              CER059
033100200529      * Current Customer in File Format - Base Rate Tax Details
033200200529     D CrBrFilFmt    E DS                  EXTNAME(SDVCUBRPD)
033300200529     D                                     PREFIX(C_)
033400200529
033500200529      * Current Customer in File Format - Private Banking Details
033600200529     D CrPBFilFmt    E DS                  EXTNAME(SDVCUPBPD)
033700200529     D                                     PREFIX(C_)
033800200529      *                                                                                      BUG3362
033900200529     D CrTIFilFmt    E DS                  EXTNAME(SDVTICDPD)                                BUG3362
034000200529     D                                     PREFIX(C_)                                        BUG3362
034100200529                                                                                             BUG3362
034200200529      ** Current Customer in File Format (VF)                                                 CER001
034300200529     D CrDlFilFmt1   E DS                  EXTNAME(SDCUX2L0)                                  CER001
034400200529      ** Current Customer in File Format (VL)                                                 CER001
034500200529     D CrDlFilFmt2   E DS                  EXTNAME(SDCUX1L0)                                  CER001
034600200529      ** Current Global Customer X-Reference in File Format                                   CGP001
034700200529     D GCrCuFilFmt   E DS                  EXTNAME(GPCUSTXPD)                                 CGP001
034800200529     D                                     PREFIX(CG_)                                        CGP001
034900200529                                                                                              CGP001
035000200529      ** Marketing Information Details in File Format                                         CRE026
035100200529     D CrcmFilFmt    E DS                  EXTNAME(SDCMRKPD)                                  CRE026
035200200529      ** Additional Customer details in File Format                                           CRE026
035300200529     D CracFilFmt    E DS                  EXTNAME(SDACUSPD)                                  CRE026
035400200529      ** Service Fees Details in File Format                                                  CRE026
035500200529     D CrcfFilFmt    E DS                  EXTNAME(SDCFCDPD)                                  CRE026
035600200529     D Q_QQSMAC      E                     EXTFLD(QQSMAC)                                     CRE026
035700200529      ** Cheques and Cards Details in File Format                                             CRE026
035800200529     D CrchFilFmt    E DS                  EXTNAME(SDCHEQPD)                                  CRE026
035900200529      ** Safe details in File Format                                                          CRE026
036000200529     D CrsaFilFmt    E DS                  EXTNAME(SDSAFEPD)                                  CRE026
036100200529      ** Risk weighted assets in Valid File Format                                            CRE026
036200200529     D CrvrFilFmt    E DS                  EXTNAME(SDVRWANPD)                                 CRE026
036300200529      ** Future and option Detail in File Format                                              CRE026
036400200529     D CrfoFilFmt    E DS                  EXTNAME(SDFOCSPD)                                  CRE026
036500200529      ** Future & options European reporting in File Format                                   CRE026
036600200529     D CroxFilFmt    E DS                  EXTNAME(SDFOX1PD)                                  CRE026
036700200529      ** Fiduciary Details in File Format                                                     CRE026
036800200529     D CrplFilFmt    E DS                  EXTNAME(SDPLCSPD)                                  CRE026
036900200529     ** Lux(European Reporting) in file format                                                CRE026
037000200529     D Crx2FilFmt    E DS                  EXTNAME(SDCUX2PD)                                  CRE026
037100200529     D                                     PREFIX(C_)                                         CRE026
037200200529     ** Lux(IBLC - Extended Information) in file format                                       CRE026
037300200529     D Crx1fFilFmt   E DS                  EXTNAME(SDCUX1PD)                                  CRE026
037400200529     D                                     PREFIX(C_)                                         CRE026
037500200529      * Current Customer in Screen Format - Primary Details
037600200529     D CurCuPrim     E DS                  EXTNAME(SDCUPRPD)
037700200529     D                                     PREFIX(@)
037800200529
037900200529      * Current Customer in Screen Format - Swift Extension                                   CSW207
038000200529     D CurCuSwft     E DS                  EXTNAME(SDCUSWPD)                                  CSW207
038100200529     D                                     PREFIX(@)                                          CSW207
038200200529                                                                                              CSW207
038300200529      * Current Customer in Screen Format - Base Rate Tax Details
038400200529     D CurCuBrt      E DS                  EXTNAME(SDCUBRPD)
038500200529     D                                     PREFIX(@)
038600200529
038700200529      * Current Customer in Screen Format - Private Banking Details
038800200529     D CurCuPriv     E DS                  EXTNAME(SDCUPBPD)
038900200529     D                                     PREFIX(@)
039000200529                                                                                             BUG3362
039100200529      * Current TI details Screen Format - TI Details                                        BUG3362
039200200529     D CurTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
039300200529     D                                     PREFIX(@)                                         BUG3362
039400200529
039500200529      * Current Customer in Screen Format - Secondary Details
039600200529     D CurCuSeco     E DS                  EXTNAME(SDCUSEPD)
039700200529     D                                     PREFIX(@)
039800200529      * Current Customer in Screen Format - Message Details
039900200529     D CurCuMsg      E DS                  EXTNAME(SDCUMRPD)
040000200529     D                                     PREFIX(@)
040100200529      *                                                                                       CSW024
040200200529      ** Current Customer in Screen Format - MT3xx BEI Details                                CSW024
040300200529     D CurCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
040400200529     D                                     PREFIX(@)                                          CSW024
040500200529
040600200529      * New Customer in File Format
040700200529     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
040800200529
041000200529
041100200529                                                                                              CSW207
041200200529      * New SWIFT Detail in File Format                                                       CSW207
041300200529     D NwSwFilFmt    E DS                  EXTNAME(SDVSWSDPD)                                 CSW207
041400200529
041500200529      * New Customer in File Format - Base Rate Tax Details
041600200529     D NwBrFilFmt    E DS                  EXTNAME(SDVCUBRPD)
041700200529
041800200529      * New Customer in File Format - Private Banking Details
041900200529     D NwPBFilFmt    E DS                  EXTNAME(SDVCUPBPD)
042000200529
042100200529      * New TI Details in File Format                                                        BUG3362
042200200529     D NwTIFilFmt    E DS                  EXTNAME(SDVTICDPD)                                BUG3362
042300200529     D                                     PREFIX(V_)                                        BUG3362
042400200529                                                                                             BUG3362
042500200529      ** New Customer extension in File Format (#6LXVF)                                       CER001
042600200529     D NwDlFilFmt1   E DS                  EXTNAME(SDVCULX2PD)                                CER001
042700200529      ** New Customer extension in File Format (#LLXVL)                                       CER001
042800200529     D NwDlFilFmt2   E DS                  EXTNAME(SDVCULX1PD)                                CER001
042900200529      * New Customer in Screen Format - Primary Details
043000200529     D NewCuPrim     E DS                  EXTNAME(SDCUPRPD)
043100200529      * New Customer in Screen Format - Swift Extension                                       CSW207
043200200529     D NewCuSwft     E DS                  EXTNAME(SDCUSWPD)                                  CSW207
043300200529
043400200529      * New Customer in Screen Format - Base Rate Tax Details
043500200529     D NewCuBrt      E DS                  EXTNAME(SDCUBRPD)
043600200529
043700200529      * New Customer in Screen Format - Private Banking Details
043800200529     D NewCuPriv     E DS                  EXTNAME(SDCUPBPD)
043900200529
044000200529      * New TI Details in Screen Format - TI Details                                         BUG3362
044100200529     D NewTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
044200200529     D                                     PREFIX(N_)                                        BUG3362
044300200529                                                                                             BUG3362
044400200529      * New Customer in Screen Format - Secondary Details
044500200529     D NewCuSeco     E DS                  EXTNAME(SDCUSEPD)
044600200529
044700200529      * New Customer in Screen Format - Message Details
044800200529     D NewCuMsg      E DS                  EXTNAME(SDCUMRPD)
044900200529      *                                                                                       CSW024
045000200529      ** New Customer in Screen Format - MT3xx BEI Details                                    CSW024
045100200529     D NewCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
045200200529
045300200529
045400200529
045500200529      * Previous Customer in Screen Format - Primary Details
045600200529     D PrvCuPrim     E DS                  EXTNAME(SDCUPRPD)
045700200529     D                                     PREFIX(@P)
045800200529
045900200529      * Previous Customer in Screen Format - Base Rate Tax Details
046000200529     D PrvCuBrt      E DS                  EXTNAME(SDCUBRPD)
046100200529     D                                     PREFIX(@P)
046200200529
046300200529      * Previous Customer in Screen Format - Private Banking Details
046400200529     D PrvCuPriv     E DS                  EXTNAME(SDCUPBPD)
046500200529     D                                     PREFIX(@P)
046600200529      * Previous TI Details in screen Format - TI Details                                    BUG3362
046700200529     D PrvTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
046800200529     D                                     PREFIX(@P)                                        BUG3362
046900200529
047000200529      * Previous Customer in Screen Format - Secondary Details
047100200529     D PrvCuSeco     E DS                  EXTNAME(SDCUSEPD)
047200200529     D                                     PREFIX(@P)
047300200529
047400200529      * Previous Customer in Screen Format - Message Details
047500200529     D PrvCuMsg      E DS                  EXTNAME(SDCUMRPD)
047600200529     D                                     PREFIX(@P)
047700200529      *                                                                                       CSW024
047800200529      ** Previous Customer in Screen Format - Message Details                                 CSW024
047900200529     D PrvCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
048000200529     D                                     PREFIX(@P)                                         CSW024
048100200529      ** New SD Customers in Screen Format (#nLX)                                             CER001
048200200529     D NwDlScnFmt    E DS                  EXTNAME(SDCURXPD)                                  CER001
048300200529      ** Current SD Customers in Screen Format (#6LX)                                         CER001
048400200529     D CrDlScnFmt    E DS                  EXTNAME(SDCURXPD)                                  CER001
048500200529     D                                     PREFIX(SS)                                         CER001
048600200529      *                                                                                       CFT050
048700200529      ** Previous Customer in Screen Format - Message Details                                 CFT050
048800200529      *                                                                                       CFT050
048900200529     D***CuSW13        E DS                  EXTNAME(SDSW13PD)                       CFT050 MD022395
049000200529     D NewCuSW13     E DS                  EXTNAME(SDSW13PD)                                MD022395
049100200529     D  S13DDBRCD    E                     EXTFLD(DDBRCD)                                     CFT050
049200200529      *                                                                                     MD022395
049300200529      ** Current SWIFT 2013 Screen Format                                                   MD022395
049400200529      *                                                                                     MD022395
049500200529     D CrCuSW13      E DS                  EXTNAME(SDSW13PD)                                MD022395
049600200529     D                                     PREFIX(C13_)                                     MD022395
049700200529
049800200529
049900200529
050000200529      * Error indicators
050100200529     D OKCuPrim      E DS                  EXTNAME(SDECUPRPD)
050200200529     D OKCuSeco      E DS                  EXTNAME(SDECUSEPD)
050300200529     D OKCuMsg       E DS                  EXTNAME(SDECUMRPD)
050400200529     D OKCuBrt       E DS                  EXTNAME(SDECUBRPD)
050500200529     D OKCuPriv      E DS                  EXTNAME(SDECUPBPD)
050600200529     D OKCuMT3x      E DS                  EXTNAME(SDECUMTPD)                                 CSW024
050700200529     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CSW207
050800200529
050900200529     D/COPY WNCPYSRC,SDH00729
051000200529
051100200529      * Further Details Parameter Data Structure
051200200529     D**FURDETS          DS           565                                                    BUG3362
051300200529     D**FURDETS          DS           701                                            BUG3362 BUG4454
051400200529     D***FURDETS           DS           708                                          BUG4454 BUG5139
051500200529     D***FURDETS          DS           701                                          BUG5139 BUG26917
051600200529     D***FURDETS          DS           709                                        BUG26917 BUG26917A
051700200529     DFURDETS          DS           701                                                    BUG26917A
051800200529     D FDCUST                  1      6
051900200529     D FDCSSN                  7     16
052000200529     D FDCRTN                157    166
052100200529     D FDCRNM                168    187
052200200529     D FDLINC                228    229
052300200529     D FDTICS                564    564
052400200529     D FDCTID                565    700                                                      BUG3362
052600200529     D***FDCRPC*               702    702                                            BUG4454 BUG5139
052700200529     D***FDBRCD*               703    705                                            BUG4454 BUG5139
052800200529     D***FDLICD*               706    708                                            BUG4454 BUG5139
052900200529     D***FDTAIN                709    709                                         BUG26917 BUG26917A
053000200529
053100200529
053200200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
053300200529      ** EXTERNAL DS FOR BANK DETAILS
053400200529
053500200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
053600200529      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
053700200529
053800200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
053900200529     D SCA_LCD       E                     EXTFLD(LCD)
054000200529      ** EXTERNAL DS FOR SAR DETAILS
054100200529
054200200529     D DSFDY         E DS                  EXTNAME(DSFDY)
054300200529      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
054400200529
054500200529     D DSSDY         E DS                  EXTNAME(DSSDY)
054600200529      ** Second DS for access progrmas, long data structure
054700200529
054800200529     D ExtData       E DS                  EXTNAME(SDCUEXPD)
054900200529      * SD Custom Extra Data - File (D/B) format
055000200529                                                                                              CSC011
055100200529      ** SD data area                                                                         CSC011
055200200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
055300200529                                                                                              CSC011
055400200529      ** 24X7 status data area                                                                CSC011
055500200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
055600200529     ** Business Entity Identifier                                                            CFT050
055700200529     D MEBEIS        E DS                  EXTNAME(MEBEISPD)                                  CFT050
055800200529      ** External DS for Customer Details                                                     CFT050
055900200529     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CFT050
056000200529     D                                     PREFIX(PR_)                                        CFT050
056100200529
056200200529      ** Changed Party Names Array
056300200529     D ChgNamArr       S              1    DIM(5)
056400200529
056500200529      **  Data Structure for AOSVALR0 string                                                  CSD012
056600200529     DSVAL1            DS           200                                                       CSD012
056700200529     DSVAL11                   1      1                                                       CSD012
056800200529                                                                                              CSD012
056900200529     D CSD012          S              1A                                                      CSD012
057000200529     D SVALKK          C                   CONST('AuthReqCustomerMaint')                      CSD012
057100200529                                                                                              CSD012
057200200529      ** Override SDAULGL2                                                                    CSD012
057300200529     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
057400200529     D CSD028          S              1A                                                      CSD028
057500200529     D PCustNum        S              6A                                                      CSD028
057600200529                                                                                              CSD012
057700200529     D/COPY QWINDSRC,SDCUSDDTA                                                                189774
057800200529                                                                                              189774
057900200529     D PDATA           DS          1024                                                       CER001
058000200529     D**#1FLD1**               1      6  0                                            CER001 CSD027A
058100200529                                                                                              CER001
058200200529     D  #1CUST                 1      6                                                       CER001
058300200529     D  #1PAIN                 7      7                                                       CER001
058400200529     D  #1PCNB                 8     13                                                       CER001
058500200529     D  #1COLC                15     16                                                       CER001
058600200529     D  #1LINC                17     18                                                       CER001
058700200529     D  #1BRCD                19     21                                                       CER001
058800200529     D  #1BNBI                22     22                                                       CER001
058900200529     D  #2CNCZ                23     24                                                       CER001
059000200529     D  #1FOTR                45     64                                                       CER001
059100200529     D  #1TMST                65     90Z                                                      CER001
059200200529     D  #1CRNM                91    110                                                       CER001
059300200529     D  #1NCOS               111    114                                                       CER001
059400200529                                                                                              CER001
059500200529     D/COPY WNCPYSRC,SDH00485
059600200529      ** +--------------------------------------+
059700200529      ** ¦ Declared variables                   ¦
059800200529      ** ¦ ==================                   ¦
059900200529      ** +--------------------------------------+
060000200529
060200200529      ** Customer Work Field
060300200529     D WKCUST          S                   LIKE(DDCUSN)
060400200529
060500200529      ** Response Mode, passed as a constant parameter to the VAL module
060600200529      ** This is always 'S' for Synchronous
060700200529     D RespMode        S              1A   INZ('S')
060800200529
060900200529      ** Timestamp for the transaction
061000200529     D TimeStamp       S               Z
061100200529                                                                                              CSC011
061200200529      **  Switchable Feature variable                                                         CSC011
061300200529     D***CER048          S              1A                                        BUG26917 BUG26917A
061400200529     D CSC011          S              1                                                       CSC011
061500200529     D CSD021          S              1A                                                      CSD021
061600200529     D CSD037          S              1A   INZ('N')                                           CSD031
061700200529     D CGP001          S              1                                                       CGP001
061800200529     D V_DDGCUS        S             10                                                       CGP001
061900200529     D CSW207          S              1A                                                      CSW207
062000200529                                                                                              CLE025
062100200529     D CLE025          S              1                                                       CLE025
062200200529     D CFX001          S              1                                                       CFX001
062300200529     D DDAPRC          S              1                                                     MD054028
062400200529     D PRTCD           S              7                                                       CLE025
062500200529     D POPTN           S              7                                                       CLE025
062600200529     D PSARD           S              6                                                       CLE025
062700200529     D PMODE           S              1                                                       CLE025
062800200529     D PAccMde         S              1A                                                      CSD031
062900200529     D PUpdYN          S              1A                                                      CSD031
063000200529     D ULX043          S              1                                                       CER001
063100200529     D ULX008          S              1                                                       CER001
063200200529     D ULX012          S              1                                                       CER001
063300200529     D ULX048          S              1                                                       CER001
063400200529     D ULX609          S              1                                                       CER001
063500200529     D ULX004          S              1                                                     BUG13228
063600200529     D LOOP            S              1                                                       CER001
063700200529     D KCUST           S              6                                                       CER001
063800200529     D BRBKCO          S              2S 0                                                    CER001
063900200529      ** Error message fields received as parameters                                          CER001
064000200529     D MSG1            S                   LIKE(#MsgID)                                       CER001
064100200529     D WFIND1          S              1                                                       CER001
064200200529     D WFIND2          S              1                                                       CER001
064300200529     D WPARKEY         S             12A                                                      CFT050
064400200529     D @EINKV          S              1                                                       CFT050
064500200529     D @INKV           S              1                                                       CFT050
064600200529     D WIMODE          S              1                                                       CFT050
064700200529     D WICRIT          S             35                                                       CFT050
064800200529     D WOADD           S            175                                                       CFT050
064900200529     D WOCHIP          S              6                                                       CFT050
065000200529     D WOUTCD          S              2                                                       CFT050
065100200529     D WRTCD           S              7                                                       CFT050
065200200529     D CSW213          S              1                                                       CSW213
065300200529     D***CSW204*         S              1                                            CFT050 MD022463
065400200529     D CSW024          S              1                                                     MD022463
065500200529     D SVCNCZ          S              2A                                                      CFT050
065600200529     D SVCOLC          S              2A                                                      CFT050
065700200529     D SVCLSY          S              2A                                                      CFT050
065800200529     D PBICD           S              4A                                                      CFT050
065900200529     D @KEY1           S             10A                                                      CFT050
066000200529     D @KYST           S              7A                                                      CFT050
066100200529     D CFT050          S              1                                                     MD022463
066200200529
066300200529      ** +--------------------------------------+
066400200529      ** ¦ End of D-specs                       ¦
066500200529      ** ¦ ==============                       ¦
066600200529      ** +--------------------------------------+
066700200529
066800200529      ** +----------------------------------------+
066900200529      ** ¦ Hook for non-core D-specs (all types)  ¦
067000200529      ** ¦ also any I-specs (if necessary)        ¦
067100200529      ** ¦ =====================================  ¦
067200200529      ** +----------------------------------------+
067300200529      /COPY WNCPYSRC,SDCUSDS001
067400200529
067500200529     D DDTMESTMP       S             26Z                                                      CER001
067600200529     D DDFOTRANID      S             20                                                       CER001
067700200529                                                                                              CER001
067800200529      **  Rename fields to differentiate SDCUSTPD from CrCuFilFmt.                            202805
067900200529     I@CUSTFT                                                                                 202805
068000200529     I              BBNET                       W@NET                                         202805
068100200529     I              BBNTGP                      W@NTGP                                        202805
068200200529     I              BBNTCP                      W@NTCP                                        202805
068300200529     I              BBNTND                      W@NTND                                        202805
068400200529     I              BBNTMM                      W@NTMM                                        202805
068500200529     I              BBTMST                      W@TMST                                        202805
068600200529      *                                                                                       202805
068700200529     ISDACSTD1                                                                                CSD031
068800200529     I              BBNET                       W@NET                                         CSD031
068900200529     I              BBNTGP                      W@NTGP                                        CSD031
069000200529     I              BBNTCP                      W@NTCP                                        CSD031
069100200529     I              BBNTND                      W@NTND                                        CSD031
069200200529     I              BBNTMM                      W@NTMM                                        CSD031
069300200529     I              BBTMST                      W@TMST                                        CSD031
069400200529      *****************************************************************
069500200529      /EJECT
069600200529      *****************************************************************
069700200529     C
069800200529      ** +--- Start of Main processing -----------------------------------+
069900200529      ** ¦                                                                ¦
070000200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
070100200529      ** ¦ executed at program activation.                                ¦
070200200529      ** ¦                                                                ¦
070300200529      ** +----------------------------------------------------------------+
070400200529      *
070500200529      /COPY WNCPYSRC,SDCUSDS002
070600200529      *
070700200529      * Issue rollback to clear any possible updates in window functions
070800200529      *
070900200529     C     @INKL         IFEQ      '1'
071000200529     C                   ROLBK
071100200529     C                   END
071200200529      *
071300200529     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
071400200529     C                   IF        @INKL = ' '                                                CSD028
071500200529     C                   MOVEL     PCustNum      DDCUSN                                       CSD028
071600200529     C                   MOVEL     'A'           DDACTN                                       CSD028
071700200529     C                   MOVEL     'A'           @OPSEL                                       CSD028
071800200529     C                   EXSR      VAL@K                                                      CSD028
071900200529     C                   ELSE                                                                 CSD028
072000200529     C                   EVAL      @SCRN = 'T'                                                CSD028
072100200529     C                   ENDIF                                                                CSD028
072200200529     C                   ENDIF                                                                CSD028
072300200529      *                                                                                       CSD028
072400200529      /COPY WNCPYSRC,SDCUSDS003
072500200529      *
072600200529      ** Build browse subfile record
072700200529      *
072800200529     C     @SCRN         IFEQ      'B'
072900200529     C                   EXSR      BLDBRW
073000200529     C                   ENDIF
073100200529      *
073200200529      ** Read next browse subfile record
073300200529      *
073400200529     C     @SCRN         IFEQ      'R'
073500200529     C                   EXSR      RDNBRW
073600200529     C                   ENDIF
073700200529      *
073800200529      /COPY WNCPYSRC,SDCUSDS004
073900200529      *
074000200529      ** DO WHILE screen: Key Details Screen
074100200529      *
074200200529     C                   Z-ADD     *ZERO         WIdx_KVAL         3 0
074300200529     C     @SCRN         DOWEQ     'K'
074400200529     C                   EXSR      Scrn@K
074500200529     C                   ENDDO
074600200529      *
074700200529      /COPY WNCPYSRC,SDCUSDS005
074800200529      *
074900200529      ** DO WHILE screen: Primary Details Screen
075000200529      *
075100200529     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
075200200529     C     @SCRN         DOWEQ     'P'
075300200529     C                   EXSR      Scrn@P
075400200529     C                   ENDDO
075500200529      *
075600200529      /COPY WNCPYSRC,SDCUSDS006
075700200529      *
075800200529      ** DO WHILE screen: Base Rate Tax Details
075900200529      *
076000200529     C                   Z-ADD     *ZERO         WIdx_BVAL         3 0
076100200529     C                   Z-ADD     *ZERO         WIdx_TVAL         3 0
076200200529     C     @SCRN         DOWEQ     'X'
076300200529     C                   EXSR      Scrn@B
076400200529     C                   ENDDO
076500200529      *
076600200529      /COPY WNCPYSRC,SDCUSDS007
076700200529      *
076800200529      ** DO WHILE screen: Secondary Details Screen
076900200529      *
077000200529     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
077100200529     C     @SCRN         DOWEQ     'S'
077200200529     C                   EXSR      Scrn@S
077300200529     C                   ENDDO
077400200529      *
077500200529      /COPY WNCPYSRC,SDCUSDS008
077600200529      *                                                                                       CSW024
077700200529      ** DO WHILE screen: MT3xx BEI Details Screen                                            CSW024
077800200529      *                                                                                       CSW024
077900200529     C                   Z-ADD     *ZERO         WIdx_FVAL         3 0                        CSW024
078000200529     C     @SCRN         DOWEQ     'F'                                                        CSW024
078100200529     C                   EXSR      SCRN@F                                                     CSW024
078200200529     C                   ENDDO                                                                CSW024
078300200529     C/COPY WNCPYSRC,SDH00601
078400200529      *
078500200529      ** DO WHILE screen: Message Details Screen
078600200529      *
078700200529     C                   Z-ADD     *ZERO         WIdx_MVAL         3 0
078800200529     C     @SCRN         DOWEQ     'M'
078900200529     C                   EXSR      SCRN@M
079000200529     C                   ENDDO
079100200529      *
079200200529      /COPY WNCPYSRC,SDCUSDS009
079300200529      ** If Private Banking Module is On                                                      203036
079400200529      *
079500200529      ** DO WHILE screen: Private Banking Details
079600200529     C     BGN4ST        IFEQ      'Y'                                                        203036
079700200529      *
079800200529     C     @SCRN         DOWEQ     'I'
079900200529     C                   EXSR      Scrn@R
080000200529     C                   ENDDO
080100200529     C                   ENDIF                                                                203036
080200200529      *                                                                                       CER001
080300200529      ** DO WHILE screen: Extension Details                                                   CER001
080400200529      *                                                                                       CER001
080500200529     C                   DOW       @SCRN = 'L'                                                CER001
080600200529     C                   EXSR      SRSCRN@L                                                   CER001
080700200529     C                   ENDDO                                                                CER001
080800200529      *
080900200529      /COPY WNCPYSRC,SDCUSDS014                                                               189774
081000200529      *                                                                                       189774
081100200529      ** Do window processing                                                                 189774
081200200529      *                                                                                       189774
081300200529      ** If Private Banking Module is on display window on top of Private                     203036
081400200529      ** Banking Screen                                                                       203036
081500200529      *                                                                                       203036
081600200529     C     BGN4ST        IFEQ      'Y'                                                        203036
081700200529     C     @SCRN         DOWEQ     'W'                                                        189774
081800200529     C                   EXSR      Scrn@W                                                     189774
081900200529     C                   ENDDO                                                                189774
082000200529      *                                                                                       203036
082100200529      ** If Private Banking Module is not on display widow on to                              203036
082200200529      ** Message details Screen.                                                              203036
082300200529     C                   ELSE                                                                 203036
082400200529     C     @SCRN         DOWEQ     'W'                                                        203036
082500200529     C                   EXSR      Scrn@W2                                                    203036
082600200529     C                   ENDDO                                                                203036
082700200529     C                   ENDIF                                                                203036
082800200529      ** Display Bank Directory Plus screen                                                   CFT050
082900200529     C**********         IF        CSW213 = 'Y'                                      CFT050 MD022463
083000200529     C                   IF        CFT050 = 'Y'                                             MD022463
083100200529     C     @SCRN         DOWEQ     'E'                                                        CFT050
083200200529     C                   EXSR      SRScrnPL                                                   CFT050
083300200529     C                   ENDDO                                                                CFT050
083400200529     C                   ENDIF                                                                CFT050
083500200529      *                                                                                       189774
083600200529      /COPY WNCPYSRC,SDCUSDS010
083700200529      *
083800200529      ** Do File updates
083900200529      *
084000200529     C     @SCRN         IFEQ      'U'
084100200529     C                   EXSR      UPDATS
084200200529     C                   ENDIF
084300200529      *
084400200529      /COPY WNCPYSRC,SDCUSDS011
084500200529      *
084600200529      ** Terminate program
084700200529      *
084800200529     C     @SCRN         IFEQ      'T'
084900200529     C                   ROLBK                                                                192916
085000200529     C                   MOVE      *ON           *INLR
085100200529     C                   ENDIF
085200200529      *
085300200529      *****************************************************************
085400200529
085500200529      * Hook to enable non-core subroutines to be included
085600200529      /COPY WNCPYSRC,SDCUSDS012
085700200529
085800200529      /EJECT
085900200529      *****************************************************************
086000200529      * SCRN@K - PROCESS SCREEN: KEY DETAILS
086100200529      *****************************************************************
086200200529     C     SCRN@K        BEGSR
086300200529      *                                                                                       248913
086400200529     C                   EXSR      SFKEYS                                                     248913
086500200529      *
086600200529      * Reset customer number if there are no errors
086700200529     C     Idx           IFEQ      0
086800200529     C                   MOVE      *BLANKS       DDCUSN
086900200529     C                   ENDIF
087000200529      *
087200200529      *
087300200529      * Set F7/F8 called from Insert mode flag
087400200529     C                   MOVE      'Y'           INSERTENQ
087500200529      *
087600200529      ** WRITE/READ DISPLAY SCREEN - Key Details
087700200529      *
087800200529     C                   CALLB     'SDCUSD1DP'
087900200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
088000200529      * INPUT PARAMETERS :
088100200529      * Return code
088200200529     C                   PARM      *BLANK        RetCodeOut
088300200529      *
088400200529      * Customer (IN SCREEN FORMAT - Primary)
088500200529     C                   PARM                    NewCuPrim
088600200529      *
088700200529      * Fields in error
088800200529     C                   PARM                    OKCuPrim
088900200529      *
089000200529      * ERRORS
089100200529     C                   PARM                    FldNameArr
089200200529     C                   PARM                    MsgIdArr
089300200529     C                   PARM                    MsgDtaArr
089400200529      *
089500200529      * WARNINGS
089600200529     C                   PARM                    WFldNamArr
089700200529     C                   PARM                    WMsgIdArr
089800200529     C                   PARM                    WMsgDtaArr
089900200529      *
090000200529      * ENABLED KEY FIELDS
090100200529      * ENABLED DETAIL FIELDS
090200200529     C                   PARM                    @EKYFD            1
090300200529     C                   PARM                    @EDTFD            1
090400200529      *
090500200529      * ENABLED FUNCTION KEYS
090600200529      * KG = COMMAND KEY 07 = READ PREVIOUS
090700200529     C**********         PARM      'Y'           @EINKG            1                          248913
090800200529     C                   PARM                    @EINKG            1                          248913
090900200529      * KH = COMMAND KEY 08 = READ NEXT
091000200529     C**********         PARM      'Y'           @EINKH            1                          248913
091100200529     C                   PARM                    @EINKH            1                          248913
091200200529      *
091300200529      * OUTPUT PARAMETERS :
091400200529      * Function Keys
091500200529     C                   PARM      '0'           @INKC             1
091600200529     C                   PARM      '0'           @INKG             1
091700200529     C                   PARM      '0'           @INKH             1
091800200529     C                   PARM      '0'           @INKL             1
091900200529      *
092000200529      * Write screen with no read indicator
092100200529     C                   PARM      'N'           WriteOnly         1
092200200529                                                                                              CSD021
092300200529     C                   PARM                    WWCNUM            6                          CSD021
092400200529      *
092500200529      * RESET ERRORS ....
092600200529      *
092700200529     C                   MOVE      *ALL'Y'       OKCuPrim
092800200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
092900200529     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
093000200529     C                   ENDIF                                                                CSW207
093100200529     C/COPY WNCPYSRC,SDH00730
093200200529     C                   MOVEL     *BLANK        FldNameArr
093300200529     C                   MOVEL     *BLANK        MsgIdArr
093400200529     C                   MOVEL     *BLANK        MsgDtaArr
093500200529     C                   MOVEL     *BLANK        WFldNamArr
093600200529     C                   MOVEL     *BLANK        WMsgIdArr
093700200529     C                   MOVEL     *BLANK        WMsgDtaArr
093800200529      *
093900200529      * F3 - End Program
094000200529     C     @INKC         CASEQ     '1'           ENDP
094100200529      *
094200200529      * F7 - Roll Backwards
094300200529     C     @INKG         CASEQ     '1'           ROLL
094400200529      *
094500200529      * F8 - Roll Forwards
094600200529     C     @INKH         CASEQ     '1'           ROLL
094700200529      *
094800200529      * F12 - Cancel on Key Screen
094900200529     C     @INKL         CASEQ     '1'           CANC@K
095000200529      *
095100200529      * Validate input to Key screen
095200200529     C                   CAS                     VAL@K
095300200529      *
095400200529     C                   ENDCS
095500200529      *
095600200529     C                   ENDSR
095700200529      *****************************************************************
095800200529      /EJECT
095900200529      *****************************************************************
096000200529      * VAL@K  - VALIDATE INPUT TO KEY SCREEN
096100200529      *****************************************************************
096200200529     C     VAL@K         BEGSR
096300200529      *                                                                                       CSD021
096400200529     C                   MOVE      *BLANK        WWCNUM                                       CSD021
096500200529      *
096600200529      * Retrieve Customer details
096700200529      *
096800200529     C                   EXSR      RTVCUS
096900200529      *
097000200529      * If primary fields are NOT OK
097100200529      * Re-output screen with error messages on it
097200200529      *
097300200529     C     DDACTNOK      IFEQ      'N'
097400200529     C     DDCUSNOK      OREQ      'N'
097500200529     C                   GOTO      EndVAL@K
097600200529     C                   END
097700200529      *                                                                         CPB002
097800200529      * Check if customer is a Portfolio Management customer.                   CPB002
097900200529     C                   EXSR      CHKPTFR                                      CPB002
098000200529      *
098100200529      *
098200200529      * If action code is not insert
098300200529      *  .. Convert the customer to screen format
098400200529      *  .. Update the customer in file format
098500200529      *  .. Go to Primary details screen
098600200529      *
098700200529     C     DDACTN        IFNE      'I'
098800200529     C                   EXSR      CVTCUS
098900200529     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
099000200529     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
099100200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
099200200529     C                   MOVEL     CrSwFilFmt    NwSwFilFmt                                   CSW207
099300200529     C                   ENDIF                                                                CSW207
099400200529     C/COPY WNCPYSRC,SDH00731
099500200529     C                   IF        CSW213 = 'Y'                                             MD022395
099600200529     C                   EVAL      DDLEIC = C_CSLEIC                                        MD022395
099700200529     C                   EVAL      DDCLSY = C_CSCLSY                                        MD022395
099800200529     C                   EVAL      DDCLID = C_CSCLID                                        MD022395
099900200529     C                   ENDIF                                                              MD022463
100000200529     C                   IF        CFT050 = 'Y'                                             MD022463
100100200529     C                   EVAL      DDBDRK = C_CSBDRK                                        MD022395
100200200529     C                   ENDIF                                                              MD022395
100300200529     C                   MOVEL     'P'           @SCRN
100400200529     C                   EXSR      SFDS@P
100500200529     C                   MOVEL     CrTIFilFMt    NwTIFilFmt                                  BUG3362
100600200529     C                   MOVEL     CrTIFilFMt    FDCTID                                       244030
100700200529     C                   GOTO      EndVAL@K
100800200529     C                   END
100900200529      *
101000200529      * Clear any warning messages
101100200529      *
101200200529     C                   CLEAR                   NwCuFilFmt
101300200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
101400200529     C                   CLEAR                   NwSwFilFmt                                   CSW207
101500200529     C                   CLEAR                   CurCuSwft                                   CSW207A
101600200529     C                   CLEAR                   NewCuSwft                                   CSW207A
101700200529     C                   ENDIF                                                                CSW207
101800200529     C                   IF        CSW213 = 'Y'                                             MD022395
101900200529     C                   CLEAR                   NewCuSW13                                  MD022395
102000200529     C                   ENDIF                                                              MD022395
102100200529     C                   CLEAR                   NwBrFilFmt
102200200529     C                   CLEAR                   CrCuFilFmt
102300200529     C                   CLEAR                   CrBrFilFmt
102400200529     C                   CLEAR                   CrPbFilFmt
102500200529     C                   CLEAR                   CrTIFilFMt                                  BUG3362
102600200529     C                   CLEAR                   FURDETS                                      244030
102700200529      *                                                                                      BUG3362
102800200529     C                   MOVEL     DDCUSN        WKCUST
102900200529     C                   CLEAR                   CurCuPrim
103000200529     C                   CLEAR                   CurCuBrt
103100200529     C                   CLEAR                   CurCuPriv
103200200529     C                   CLEAR                   CurCuSeco
103300200529     C                   CLEAR                   CurCuMsg
103400200529     C                   CLEAR                   CurCuMT3x                                    CSW024
103500200529     C                   CLEAR                   NewCuPrim
103600200529     C                   CLEAR                   NewCuBrt
103700200529     C                   CLEAR                   NewCuPriv
103800200529     C                   CLEAR                   NewCuSeco
103900200529     C                   MOVEL     *BLANK        DDLEIC                                       CSW213
104000200529     C                   CLEAR                   NewCuMsg
104100200529     C                   CLEAR                   NewCuMT3x                                    CSW024
104200200529     C                   MOVEL     WKCUST        DDCUSN
104300200529     C                   MOVEL     'I'           DDACTN
104400200529     C                   MOVE      *ALL'Y'       OKCuPrim
104500200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
104600200529     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
104700200529     C                   ENDIF                                                                CSW207
104800200529     C                   MOVE      *ALL'Y'       OKCuSeco
104900200529     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
105000200529     C                   MOVEL     *BLANK        WFldNamArr
105100200529     C                   MOVEL     *BLANK        WMsgIdArr
105200200529     C                   MOVEL     *BLANK        WMsgDtaArr
105300200529     C/COPY WNCPYSRC,SDCUSDSC07
105400200529      *
105500200529      * Go to Primary Details screen
105600200529      *
105700200529     C                   MOVEL     'P'           @SCRN
105800200529     C                   EXSR      SFDS@P
105900200529     C                   MOVEL     CrTIFilFMt    NwTIFilFmt                                  BUG3362
106000200529     C                   MOVEL     CrTIFilFMt    FDCTID                                       244030
106100200529      *
106200200529     C     EndVAL@K      ENDSR
106300200529      *****************************************************************
106400200529      /EJECT
106500200529      *****************************************************************
106600200529      * SFDS@P - SET FIELD STATUS ON PRIMARY SCREEN
106700200529      *****************************************************************
106800200529     C     SFDS@P        BEGSR
106900200529      *
107000200529      * Enable/disable fields on primary screen
107100200529      *
107200200529     C     DDACTN        IFEQ      'I'
107300200529     C     DDACTN        OREQ      'A'
107400200529     C                   MOVEL     'Y'           @EKYFD
107500200529     C                   MOVEL     'Y'           @EDTFD
107600200529     C                   ELSE
107700200529     C                   MOVEL     'N'           @EKYFD
107800200529     C                   MOVEL     'N'           @EDTFD
107900200529     C                   END
108000200529      *
108100200529     C                   ENDSR
108200200529      *****************************************************************
108300200529      /EJECT
108400200529      *****************************************************************
108500200529      * SCRN@P - PROCESS PRIMARY SCREEN
108600200529      *****************************************************************
108700200529     C     SCRN@P        BEGSR
108800200529
108900200529      * Set function key status on PRIMARY screen
109000200529      *
109100200529     C                   EXSR      SFKEYS
109200200529      *
109300200529      ** Default Private Banking Customer Indicator to an 'N' for insert
109400200529      *
109500200529     C                   IF        DDACTN = 'I' and BGN4ST = 'Y'
109700200529     C                   EVAL      DDPRBA = 'N'
109800200529     C                   END
109900200529                                                                                              CSD031
110000200529      ** Hide further details if the customer came from the acceptance subfile.               CSD031
110100200529                                                                                              CSD031
110200200529     C                   IF        CSD037 = 'Y' AND                                           CSD031
110300200529     C                             PAccMde = 'A'                                              CSD031
110400200529     C                   EVAL      @EINKX = 'N'                                               CSD031
110500200529     C                   ENDIF                                                                CSD031
110600200529      *
110700200529      ** WRITE/READ DISPLAY SCREEN - Primary Details
110800200529      *
110900200529     C                   CALLB     'SDCUSD2DP'
111000200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
111100200529      * INPUT PARAMETERS :
111200200529      * Return code
111300200529     C                   PARM      *BLANK        RetCodeOut
111400200529      * Customer (IN SCREEN FORMAT - Primary )
111500200529     C                   PARM                    NewCuPrim
111600200529      * Fields in error
111700200529     C                   PARM                    OKCuPrim
111800200529     C/COPY WNCPYSRC,SDH00732
111900200529      * Errors
112000200529     C                   PARM                    FldNameArr
112100200529     C                   PARM                    MsgIdArr
112200200529     C                   PARM                    MsgDtaArr
112300200529      * Warnings
112400200529     C                   PARM                    WFldNamArr
112500200529     C                   PARM                    WMsgIdArr
112600200529     C                   PARM                    WMsgDtaArr
112700200529      * ENABLED KEY & DETAIL FIELDS
112800200529     C                   PARM                    @EKYFD            1
112900200529     C                   PARM                    @EDTFD            1
113000200529      * ENABLED Function Keys
113100200529      * KG = COMMAND KEY 07 = READ PREVIOUS
113200200529      * KH = COMMAND KEY 08 = READ NEXT
113300200529      * KJ = COMMAND KEY 10 = CONFIRM DELETE
113400200529      * KW = COMMAND KEY 22 = CONFIRM CLOSURE OR RELEASE                                      CSD007
113500200529      * KX = COMMAND KEY 23 = FURTHER DETAILS
113600200529     C                   PARM                    @EINKG
113700200529     C                   PARM                    @EINKJ            1
113800200529     C                   PARM                    @EINKW            1                          CSD007
113900200529     C                   PARM                    @EINKX            1
114000200529     C                   PARM                    @EINKV                                       CFT050
114100200529                                                                                              CLE025
114200200529      ** Switchable features                                                                  CLE025
114300200529                                                                                              CLE025
114400200529     C                   PARM                    CLE025                                       CLE025
114500200529     C                   PARM                    CFX001                                       CFX001
114600200529     C**********         PARM                    CSD037                              CSD031 BUG11907
114700200529     C                   PARM                    TransType                                    CSD028
114800200529      *                                                                                     BUG11907
114900200529      ** Move parameter CSD037 after TransType                                              BUG11907
115000200529      *                                                                                     BUG11907
115100200529     C                   PARM                    CSD037                                     BUG11907
115200200529      * Customer (IN SCREEN FORMAT - SWIFT Extension)                                         CSW207
115300200529     C                   PARM                    NewCuSwft                                    CSW207
115400200529      * Fields in error SWIFT Details                                                         CSW207
115500200529     C                   PARM                    OKCuSwft                                     CSW207
115600200529      ** Linkage record key                                                                   CFT050
115700200529     C                   PARM                    DDBDRK                                       CFT050
115800200529      *
115900200529      * OUTPUT PARAMETERS :
116000200529      * FUNCTION KEYS
116100200529     C                   PARM      '0'           @INKC
116200200529     C                   PARM      '0'           @INKG
116300200529     C                   PARM      '0'           @INKH
116400200529     C                   PARM      '0'           @INKJ             1
116500200529     C                   PARM      '0'           @INKL
116600200529     C/COPY WNCPYSRC,SDH00104
116700200529     C                   PARM      '0'           @INKW             1                          CSD007
116800200529     C                   PARM      '0'           @INKX             1
116900200529     C                   PARM      '0'           @INKV                                        CFT050
117000200529      * Write screen with no read indicator
117100200529     C                   PARM      'N'           WriteOnly
117200200529      ** Acceptance Mode                                                                      CSD031
117300200529     C                   PARM                    PAccMde                                      CSD031
117400200529      *
117500200529      * RESET ERRORS ....
117600200529      *
117700200529     C     DDCUSNOK      IFNE      'N'
117800200529     C                   MOVE      *ALL'Y'       OKCuPrim
117900200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
118000200529     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
118100200529     C                   ENDIF                                                                CSW207
118200200529     C                   MOVEL     *BLANK        FldNameArr
118300200529     C                   MOVEL     *BLANK        MsgIdArr
118400200529     C                   MOVEL     *BLANK        MsgDtaArr
118500200529     C                   MOVEL     *BLANK        WFldNamArr
118600200529     C                   MOVEL     *BLANK        WMsgIdArr
118700200529     C                   MOVEL     *BLANK        WMsgDtaArr
118800200529     C                   ENDIF
118900200529
119000200529      *
119200200529      *
119300200529      * F3 - End Program
119400200529     C     @INKC         CASEQ     '1'           ENDP
119500200529      *
119600200529      * F7 - Roll Backwards
119700200529     C     @INKG         CASEQ     '1'           ROLL
119800200529      *
119900200529      * F8 - Roll Forwards
120000200529     C     @INKH         CASEQ     '1'           ROLL
120100200529      *
120200200529      * F12 - Cancel on Primary Screen
120300200529     C     @INKL         CASEQ     '1'           CANC@P
120400200529      *
120500200529      * Validate Input to Primary Screen
120600200529     C                   CAS                     VAL@P
120700200529      *
120800200529     C                   ENDCS
120900200529     C/COPY WNCPYSRC,SDH00105
121000200529      *
121100200529      * On F23, go to Further Details, if no errors on this screen
121200200529      *
121300200529     C     @INKX         IFEQ      '1'
121400200529     C     Idx           ANDEQ     0
121500200529     C     @INKX         OREQ      '1'                                                        237595
121600200529     C     Idx           ANDNE     0                                                          237595
121700200529     C     DDACTN        ANDEQ     'D'                                                        237595
121800200529     C                   EXSR      FURDET
121900200529     C                   ENDIF
122000200529
122100200529     C                   ENDSR
122200200529      *****************************************************************
122300200529      /EJECT
122400200529      *****************************************************************
122500200529      * VAL@P  - VALIDATE INPUT TO PRIMARY SCREEN
122600200529      *****************************************************************
122700200529     C     VAL@P         BEGSR
122800200529      ** If F21 was pressed go to Bank Directory Plus screen                                  CFT050
122900200529     C                   IF        @INKV = '1'                                                CFT050
123000200529     C                   EVAL      @SCRN = 'E'                                                CFT050
123100200529     C                   GOTO      EndVAL@P                                                   CFT050
123200200529     C                   ENDIF                                                                CFT050
123300200529      *
123400200529      * If customer number is NOT OK
123500200529      * Re-output screen with error message on it
123600200529      *
123700200529     C     DDCUSNOK      IFEQ      'N'
123800200529     C                   GOTO      EndVAL@P
123900200529     C                   END
124000200529      *
124100200529      * Prior to validation, initialize error indicators as 'OK'
124200200529      *
124300200529     C                   Z-ADD     *ZERO         Idx               3 0
124400200529     C/COPY WNCPYSRC,SDH00733
124500200529     C                   Z-ADD     *ZERO         WIdx_PVAL
124600200529     C/COPY WNCPYSRC,SDH00734
124700200529     C                   MOVE      *ALL'Y'       OKCuPrim
124800200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
124900200529     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
125000200529     C                   ENDIF                                                                CSW207
125100200529      *
125200200529      *
125300200529      * Determine whether BRT customer and initialise controls
125400200529      *
125500200529     C     S01383        IFEQ      'Y'
125600200529     C     DDTAIN        IFEQ      'I'
125700200529     C     DDTAIN        OREQ      'J'
125800200529     C     DDTAIN        OREQ      'R'                                                        CRE007
125900200529     C                   MOVE      '1'           BRTSCREEN
126000200529     C                   MOVEA     *BLANKS       ChgNamArr
126100200529     C                   ENDIF
126200200529     C                   ENDIF
126300200529      *
126400200529      *----------------------------------------------------------------
126500200529      * IF DELETE
126600200529      *
126700200529     C     DDACTN        IFEQ      'D'
126800200529      *
126900200529      * IF F10 TAKEN, GO ON TO UPDATES
127000200529      *
127100200529     C     @INKJ         IFEQ      '1'
127200200529     C                   EXSR      RTVCUS                                                     237595
127300200529     C     DDCUSNOK      IFNE      'N'                                                        237595
127400200529     C                   MOVEL     'U'           @SCRN
127500200529     C                   ENDIF                                                                237595
127600200529     C/COPY WNCPYSRC,SDCUSDSC17
127700200529     C                   END
127800200529     C                   GOTO      EndVAL@P
127900200529     C                   END
128000200529      *
128100200529      *----------------------------------------------------------------                       CSD007
128200200529      * IF CLOSURE OR RELEASE                                                                 CSD007
128300200529      *                                                                                       CSD007
128400200529     C     DDACTN        IFEQ      'C'                                                        CSD007
128500200529     C     DDACTN        OREQ      'R'                                                        CSD007
128600200529      *                                                                                       CSD007
128700200529      * IF F22 TAKEN, GO ON TO UPDATES                                                        CSD007
128800200529      *                                                                                       CSD007
128900200529     C     @INKW         IFEQ      '1'                                                        CSD007
129000200529     C                   MOVEL     'U'           @SCRN                                        CSD007
129100200529     C/COPY WNCPYSRC,SDCUSDSC18
129200200529     C                   ELSE                                                                 CSD007
129300200529      * WARNING MESSAGE                                                                       CSD007
129400200529     C                   ENDIF                                                                CSD007
129500200529     C                   GOTO      EndVAL@P                                                   CSD007
129600200529     C                   ENDIF                                                                CSD007
129700200529      *                                                                                       CSD007
129800200529      *----------------------------------------------------------------
129900200529      * IF ENQUIRE
130000200529      *
130100200529     C     DDACTN        IFEQ      'E'
130200200529                                                                                              CSD031
130300200529      ** Skip further screens if the customer came from the acceptance subfile.               CSD031
130400200529                                                                                              CSD031
130500200529     C                   IF        CSD037 = 'Y' AND                                           CSD031
130600200529     C                             PAccMde = 'A'                                              CSD031
130700200529     C**********         MOVEL     'B'           @SCRN                               CSD031 BUG11917
130800200529     C                   MOVEL     'R'           @SCRN                                      BUG11917
130900200529     C                   GOTO      EndVAL@P                                                   CSD031
131000200529     C                   ENDIF                                                                CSD031
131100200529      *
131200200529      * If Further Details (F23) has not been selected:
131300200529     C     @INKX         IFEQ      '0'
131400200529      *
131500200529      * If Base Rate Tax is ON
131600200529     C     S01383        IFEQ      'Y'
131700200529      *
131800200529      **If*account*holder*type*I*or*J,*display*participant*details**                          CRE007
131900200529      * If account holder type I, J, or R display participant details                         CRE007
132000200529     C     DDTAIN        IFEQ      'I'
132100200529     C     DDTAIN        OREQ      'J'
132200200529     C     DDTAIN        OREQ      'R'                                                        CRE007
132300200529     C                   MOVE      'X'           @SCRN
132400200529     C                   ELSE
132500200529     C                   MOVE      'S'           @SCRN
132600200529     C                   ENDIF
132700200529      *
132800200529      * If Base Rate Tax is OFF, go to message details screen
132900200529     C                   ELSE
133000200529     C                   MOVE      'S'           @SCRN
133100200529     C                   ENDIF
133200200529      *
133300200529      * If Further Details (F23) has been selected:
133400200529     C                   ELSE
133500200529      *
133600200529      * Return to Primary Detail Screen after Further Details
133700200529     C                   MOVE      'P'           @SCRN
133800200529      *
133900200529     C                   ENDIF
134000200529      *
134100200529     C                   GOTO      EndVAL@P
134200200529      *
134300200529     C                   ENDIF
134400200529      *
134500200529      *----------------------------------------------------------------
134600200529      * IF INSERT OR AMEND / CHANGE
134700200529      *
134800200529     C     DDACTN        IFEQ      'I'
134900200529     C     DDACTN        OREQ      'A'
135000200529
135100200529      * Validate Primary Customer Details
135200200529
135300200529
135400200529      * Update 'previous' screens and previous number of warnings
135500200529
135600200529     C/COPY WNCPYSRC,SDH00735
135700200529     C                   MOVEL     NewCuPrim     PrvCuPrim
135800200529     C                   Z-ADD     WIdx_PVAL     PrvN_Warn         3 0
135900200529
136000200529
136100200529     C                   CALLB     'SDCUSD2VL'
136200200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
136300200529      * INPUTS :
136400200529      * Response mode
136500200529     C                   PARM                    RespMode
136600200529      ** Customer Primary Details
136700200529     C                   PARM                    NewCuPrim
136900200529      * Customer Extra Data file data
137000200529     C                   PARM                    ExtData
137100200529                                                                                              CLE025
137200200529      ** Switchable features                                                                  CLE025
137300200529                                                                                              CLE025
137400200529     C                   PARM                    CLE025                                       CLE025
137500200529     C                   PARM                    CFX001                                       CFX001
137600200529      ** Customer Primary Details                                                             CSW207
137700200529     C                   PARM                    NewCuSwft                                    CSW207
137800200529      *
137900200529      * OUTPUTS :
138000200529      *
138100200529      ** Customer Primary Details OK inds
138200200529     C                   PARM                    OKCuPrim
138300200529     C/COPY WNCPYSRC,SDH00736
138400200529      * Error fields/message IDs/message data (arrays) from/to caller
138500200529     C                   PARM                    FldNameArr
138600200529     C                   PARM                    MsgIDArr
138700200529     C                   PARM                    MsgDtaArr
138800200529      * Array index (3P0) from/to caller
138900200529     C                   PARM                    Idx
139000200529      * Warning fields/message IDs/message data (arrays) from/to caller
139100200529     C                   PARM                    WFldNamArr
139200200529     C                   PARM                    WMsgIDArr
139300200529     C                   PARM                    WMsgDtaArr
139400200529      * Array index (3P0) from/to caller
139500200529     C/COPY WNCPYSRC,SDH00737
139600200529     C                   PARM                    WIdx_SVAL
139700200529     C/COPY WNCPYSRC,SDH00738
139800200529      * Valid Customer layout (DS) from/to caller
139900200529      ** Valid Global Customer ID                                                             CGP001
140000200529     C                   PARM                    NwCuFilFmt
140200200529     C                   PARM                    V_DDGCUS                                     CGP001
140300200529      ** Customer Primary Details OK inds                                                     CSW207
140400200529     C                   PARM                    OKCuSwft                                     CSW207
140500200529      * Valid Customer SWIFT Details (DS) from/to caller                                      CSW207
140600200529     C                   PARM                    NwSwFilFmt                                   CSW207
140700200529     C/COPY WNCPYSRC,SDH00739
140800200529      *
140900200529      * If errors returned
141000200529      *
141100200529     C     Idx           IFNE      0
141200200529     C                   GOTO      EndVAL@P
141300200529     C                   END
141400200529      *
141500200529      * If the screen has changed in the course of the validation
141600200529      * or if there are warnings which have not been displayed
141700200529      * re-display the screen
141800200529      *
141900200529     C     NewCuPrim     IFNE      PrvCuPrim
142000200529     C     WIdx_PVAL     ORNE      PrvN_Warn
142100200529     C                   GOTO      EndVAL@P
142200200529     C                   END
142300200529     C/COPY WNCPYSRC,SDH00740
142400200529      *
142500200529      * Clear any warning messages
142600200529      *
142700200529     C                   MOVE      *ALL'Y'       OKCuPrim
142800200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
142900200529     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
143000200529     C                   ENDIF                                                                CSW207
143100200529     C/COPY WNCPYSRC,SDH00741
143200200529     C                   MOVEL     *BLANK        WFldNamArr
143300200529     C                   MOVEL     *BLANK        WMsgIdArr
143400200529     C                   MOVEL     *BLANK        WMsgDtaArr
143500200529      *
143600200529     C                   ENDIF
143700200529     C
143800200529      *
143900200529      * If Further Details (F23) has not been selected:
144000200529     C     @INKX         IFEQ      '0'
144100200529      *
144200200529      * If Base Rate Tax is OFF
144300200529     C     S01383        IFEQ      'N'
144400200529     C                   MOVE      'S'           @SCRN
144500200529     C                   GOTO      EndVAL@P
144600200529     C                   ENDIF
144700200529      *
144800200529      **Display*participant*details*if*account*holder*type*I*or*J***                          CRE007
144900200529      * Display participant details if account holder type I, J, or R                         CRE007
145000200529     C     DDTAIN        IFEQ      'I'
145100200529     C     DDTAIN        OREQ      'J'
145200200529     C     DDTAIN        OREQ      'R'                                                        CRE007
145300200529     C                   MOVE      'X'           @SCRN
145400200529     C                   ELSE
145500200529     C                   EXSR      VAL@T
145600200529     C                   MOVE      'S'           @SCRN
145700200529     C                   ENDIF
145800200529      *
145900200529      * If Further Details (F23) has been selected:
146000200529     C                   ELSE
146100200529      *
146200200529      * Return to Primary Detail Screen after Further Details
146300200529     C                   MOVE      'P'           @SCRN
146400200529     C                   EXSR      SFDS@P
146500200529      *
146600200529     C                   ENDIF
146700200529      *
146800200529     C     EndVAL@P      ENDSR
146900200529      *****************************************************************
147000200529      /EJECT
147100200529      *****************************************************************
147200200529      * SCRN@B - PROCESS BASE RATE TAX DETAILS SCREEN
147300200529      *****************************************************************
147400200529     C     SCRN@B        BEGSR
147500200529
147600200529      * IF ACTION CODE IS DELETE
147700200529      * BYPASS SCREEN PROCESSING AND PROCESS BRT DATA
147800200529      *
147900200529     C     DDACTN        IFEQ      'D'
148000200529     C                   EXSR      VAL@T
148100200529     C                   MOVE      'U'           @SCRN
148200200529     C                   GOTO      EndBDSP
148300200529     C                   ENDIF
148400200529
148500200529      * If Account Holder Type is 'R' then default BRT Tax Ind to 'N'.                        CRE007
148600200529      * If Insert mode as well then default Post 5/4/01 to 'Y'.                               CRE007
148700200529      *                                                                                       CRE007
148800200529     C     DDTAIN        IFEQ      'R'                                                        CRE007
148900200529     C                   EVAL      DDTXIN = 'N'                                               CRE007
149000200529     C     DDACTN        IFEQ      'I'                                                        CRE007
149100200529     C                   EVAL      DDPSTR = 'Y'                                               CRE007
149200200529     C                   ENDIF                                                                CRE007
149300200529     C                   ENDIF                                                                CRE007
149400200529
149500200529     C                   CALLB     'SDCUSD6DP'
149600200529      * INPUT PARAMETERS :
149700200529      * Return code
149800200529     C                   PARM                    RetCodeIn
149900200529      *
150000200529      * Primary Details
150100200529      * Base Rate Tax Details
150200200529     C                   PARM                    NewCuPrim
150300200529     C                   PARM                    NewCuBrt
150400200529      *
150500200529      * Fields in error
150600200529     C                   PARM                    OKCuBrt
150700200529      *
150800200529      * ERRORS
150900200529     C                   PARM                    FldNameArr
151000200529     C                   PARM                    MsgIdArr
151100200529     C                   PARM                    MsgDtaArr
151200200529      *
151300200529      * WARNINGS
151400200529     C                   PARM                    WFldNamArr
151500200529     C                   PARM                    WMsgIdArr
151600200529     C                   PARM                    WMsgDtaArr
151700200529      *
151800200529      * ENABLED FUNCTION KEYS
151900200529      * Display first or second page of Base Rate Tax details
152000200529     C                   PARM                    BRTSCREEN         1
152100200529      *
152200200529      * Changed Party Names Array
152300200529     C                   PARM                    ChgNamArr         1
152400200529      *
152500200529      * OUTPUT PARAMETERS :
152600200529      * Function Keys
152700200529     C                   PARM                    @INKC
152800200529     C                   PARM                    @INKL
152900200529     C                   PARM                    @INKS             1
153000200529      *
153100200529      * Write screen with no read indicator
153200200529     C                   PARM                    WriteOnly
153300200529      *
153400200529      *
153500200529      * F3 - End Program
153600200529     C     @INKC         CASEQ     '1'           ENDP
153700200529      *
153800200529      * F12 - Cancel on Base Rate Tax Screen
153900200529     C     @INKL         CASEQ     '1'           CANC@B
154000200529      *
154100200529      * Validate name changes and process participant history DS
154200200529     C     CHGNAME       CASEQ     '1'           VAL@T
154300200529      *
154400200529      * Validate Input to Base Rate Tax Screen
154500200529     C                   CAS                     VAL@B
154600200529      *
154700200529     C                   ENDCS
154800200529      *
154900200529     C     EndBDSP       ENDSR
155000200529      *****************************************************************
155100200529      /EJECT
155200200529      *****************************************************************
155300200529      * VAL@B  - VALIDATE INPUT TO BASE RATE TAX DETAILS
155400200529      *****************************************************************
155500200529     C     VAL@B         BEGSR
155600200529      *
155700200529      * IF ENQUIRE
155800200529      *
155900200529     C     DDACTN        IFEQ      'E'
156000200529      *
156100200529      * From BRT screen 1, go to screen 2 if there are details to view
156200200529      * otherwise return to browse screen
156300200529      *
156400200529     C     BRTSCREEN     IFEQ      '1'
156500200529     C     DD3NAM        ANDNE     *BLANKS
156600200529     C                   MOVE      '2'           BRTSCREEN
156700200529     C                   ELSE
156800200529     C                   MOVE      'S'           @SCRN
156900200529     C                   GOTO      EndVAL@B
157000200529     C                   ENDIF
157100200529      *
157200200529     C                   ENDIF
157300200529      *
157400200529      *----------------------------------------------------------------
157500200529      * IF INSERT OR AMEND / CHANGE
157600200529      *
157700200529     C     DDACTN        IFEQ      'I'
157800200529     C     DDACTN        OREQ      'A'
157900200529      *
158000200529      ** For account holder type I
158100200529      ** or  account holder type R                                                            CRE007
158200200529     C     DDTAIN        IFEQ      'I'
158300200529     C     DDTAIN        OREQ      'R'                                                        CRE007
158400200529      *
158500200529      ** If user has just left screen 1
158600200529     C     BRTSCREEN     IFEQ      '1'
158700200529      *
158800200529      ** If names have been entered for both parties 1 and 2 or
158900200529      ** party 3 has a name
159000200529     C     DD1NAM        IFNE      *BLANKS
159100200529     C     DD2NAM        ANDNE     *BLANKS
159200200529     C     DD3NAM        ORNE      *BLANKS
159300200529      *
159400200529      ** display the second screen before validating
159500200529     C                   MOVE      '2'           BRTSCREEN
159600200529     C                   GOTO      EndVAL@B
159700200529     C                   ENDIF
159800200529     C                   ELSE
159900200529     C                   MOVE      '1'           BRTSCREEN
160000200529     C                   ENDIF
160100200529      *
160200200529      ** For account holder type J
160300200529     C                   ELSE
160400200529      *
160500200529      ** As long as there are parties on screen 2, toggle between first
160600200529      ** and second BRT screens if errors and redisplaying screens
160700200529      *
160800200529     C     DD3NAM        IFNE      *BLANKS
160900200529     C     BRTSCREEN     IFEQ      '1'
161000200529     C                   MOVE      '2'           BRTSCREEN
161100200529     C                   ELSE
161200200529     C                   MOVE      '1'           BRTSCREEN
161300200529     C                   ENDIF
161400200529     C                   ENDIF
161500200529
161600200529     C                   ENDIF
161700200529
161800200529     C                   Z-ADD     *ZERO         Idx
161900200529     C                   MOVE      *ALL'Y'       OKCuBrt
162000200529     C                   MOVEL     *BLANK        FldNameArr
162100200529     C                   MOVEL     *BLANK        MsgIdArr
162200200529     C                   MOVEL     *BLANK        MsgDtaArr
162300200529     C                   MOVEL     *BLANK        WFldNamArr
162400200529     C                   MOVEL     *BLANK        WMsgIdArr
162500200529     C                   MOVEL     *BLANK        WMsgDtaArr
162600200529      *
162700200529      *
162800200529      * Update 'previous' screens and previous number of warnings
162900200529
163000200529     C                   MOVEL     NewCuBrt      PrvCuBrt
163100200529     C                   Z-ADD     WIdx_BVAL     PrvN_Warn
163200200529      *
163300200529      * Validate Base Rate Tax Details
163400200529      *
163500200529     C                   CALLB     'SDCUSD6VL'
163600200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
163700200529      * INPUTS :
163800200529      * Response mode
163900200529     C                   PARM                    RespMode
164000200529      *
164100200529      * Action Code
164200200529     C                   PARM                    DDACTN
164300200529      *
164400200529      * Customer Number
164500200529     C                   PARM                    DDCUSN            6
164600200529      *
164700200529      * Account Holder Type
164800200529     C                   PARM                    DDTAIN            1
164900200529      *
165000200529      ** Customer Base Rate Tax Details
165100200529     C                   PARM                    NewCuBrt
165200200529      *
165300200529      ** Screen validation
165400200529     C                   PARM      '1'           SinVal            1
165500200529      *
165600200529      * OUTPUTS :
165700200529      ** Customer Base Rate Tax Details
165800200529     C                   PARM                    OKCuBrt
165900200529      *
166000200529      * Error fields/message IDs/message data (arrays) from/to caller
166100200529     C                   PARM                    FldNameArr
166200200529     C                   PARM                    MsgIDArr
166300200529     C                   PARM                    MsgDtaArr
166400200529      *
166500200529      * Array index (3P0) from/to caller
166600200529     C                   PARM                    Idx
166700200529      *
166800200529      * Warning fields/message IDs/message data (arrays) from/to caller
166900200529     C                   PARM                    WFldNamArr
167000200529     C                   PARM                    WMsgIDArr
167100200529     C                   PARM                    WMsgDtaArr
167200200529      *
167300200529      * Array index (3P0) from/to caller
167400200529     C                   PARM      0             WIdx_BVAL
167500200529      *
167600200529      * Valid Base Rate Tax layout (DS) from/to caller
167700200529     C                   PARM                    NwBrFilFmt
167800200529      *
167900200529      * Changed Party Names Array
168000200529     C                   PARM                    ChgNamArr
168100200529      *
168200200529      * If any errors redisplay screen
168300200529     C     Idx           IFNE      0
168400200529     C                   GOTO      ENDVAL@B
168500200529     C                   ENDIF
168600200529      *
168700200529      * If there are any warnings, redisplay screen
168800200529     C     WIdx_BVAL     IFNE      PrvN_Warn
168900200529      *
169000200529      * Don't prompt user for name if redisplaying for warning message
169100200529     C                   MOVEA     *BLANKS       ChgNamArr
169200200529     C                   GOTO      EndVAL@B
169300200529      *
169400200529     C                   ELSE
169500200529      *
169600200529     C                   MOVEL     *BLANK        WFldNamArr
169700200529     C                   MOVEL     *BLANK        WMsgIdArr
169800200529     C                   MOVEL     *BLANK        WMsgDtaArr
169900200529     C                   END
170000200529      *
170100200529      * Determine whether there are changed/new names among participants
170200200529     C                   EXSR      PARNAMES
170300200529      *
170400200529      * If any changed names, redisplay screen for user to confirm
170500200529      * whether this is a name change or a new participant
170600200529      *
170700200529     C     DDACTN        IFEQ      'A'
170800200529     C     CHGNAME       ANDEQ     '1'
170900200529     C                   GOTO      ENDVAL@B
171000200529     C                   ENDIF
171100200529      *
171200200529      *
171300200529     C                   EXSR      VAL@T
171400200529
171500200529      * Clear any warning messages
171600200529      *
171700200529     C                   MOVE      *ALL'Y'       OKCuBrt
171800200529     C                   MOVEL     *BLANK        WFldNamArr
171900200529     C                   MOVEL     *BLANK        WMsgIdArr
172000200529     C                   MOVEL     *BLANK        WMsgDtaArr
172100200529      *
172200200529      * Move on to Secondary Screen
172300200529     C                   MOVE      'S'           @SCRN
172400200529      *
172500200529      * End of Insert/Amend condition controlling validation call
172600200529     C                   ENDIF
172700200529      *
172800200529      *
172900200529     C     EndVAL@B      ENDSR
173000200529      *****************************************************************
173100200529      /EJECT
173200200529      *****************************************************************
173300200529      * VAL@T - Validate Name Prompt and Process Participant History DS
173400200529      *****************************************************************
173500200529     C     VAL@T         BEGSR
173600200529      *
173700200529      * Prior to validation, initialize error indicators as 'OK'
173800200529      *
173900200529     C                   Z-ADD     *ZERO         Idx
174000200529     C                   Z-ADD     *ZERO         WIdx_TVAL
174100200529     C                   MOVE      *ALL'Y'       OKCuBRT
174200200529     C                   MOVEL     *BLANK        FldNameArr
174300200529     C                   MOVEL     *BLANK        MsgIdArr
174400200529     C                   MOVEL     *BLANK        MsgDtaArr
174500200529      *
174600200529      ** Call to validate name prompt and process Participant History
174700200529      *
174800200529     C                   CALLB     'SDCUSD7VL'
174900200529      * INPUTS
175000200529
175100200529      * Response mode
175200200529     C                   PARM                    RespMode          1
175300200529      *
175400200529      * Action Code
175500200529      * Customer Number
175600200529      * Account Holder Type
175700200529     C                   PARM                    DDACTN
175800200529     C                   PARM                    DDCUSN
175900200529     C                   PARM                    DDTAIN
176000200529
176100200529      ** Customer Base Rate Tax
176200200529     C                   PARM                    NewCuBrt
176300200529
176400200529      ** OUTPUTS
176500200529
176600200529      ** Customer Base Rate Tax OK indicators
176700200529     C                   PARM                    OKCuBrt
176800200529
176900200529      * Error fields/message IDs/message data (arrays) from/to caller
177000200529     C                   PARM                    FldNameArr
177100200529     C                   PARM                    MsgIDArr
177200200529     C                   PARM                    MsgDtaArr
177300200529
177400200529      * Array index (3P0) from/to caller
177500200529     C                   PARM                    Idx
177600200529
177700200529      * Warning fields/message IDs/message data (arrays) from/to caller
177800200529     C                   PARM                    WFldNamArr
177900200529     C                   PARM                    WMsgIDArr
178000200529     C                   PARM                    WMsgDtaArr
178100200529
178200200529      * Array index (3P0) from/to caller
178300200529     C                   PARM                    WIdx_TVAL
178400200529
178500200529      * Changed Party Name Array
178600200529     C                   PARM                    ChgNamArr
178700200529      *
178800200529      * Valid BRT file layout (DS) to/from caller
178900200529     C                   PARM                    NwBrFilFmt
179000200529      *
179100200529      * If there are errors, redisplay Base Rate Tax screen
179200200529
179300200529     C     Idx           IFNE      0
179400200529     C                   GOTO      EndVAL@T
179500200529     C                   ENDIF
179600200529
179700200529      * If the screen has changed in the course of the validation
179800200529      * or if there are warnings which have not been displayed
179900200529      * re-display the screen
180000200529
180100200529     C     BRTSCREEN     IFEQ      '2'
180200200529     C                   MOVEA     *BLANKS       ChgNamArr
180300200529     C                   MOVE      '0'           CHGNAME
180400200529     C                   MOVE      'S'           @SCRN
180500200529     C                   GOTO      EndVAL@T
180600200529     C                   ENDIF
180700200529      *
180800200529     C     ChgNamArr(3)  IFEQ      'P'
180900200529     C     ChgNamArr(4)  OREQ      'P'
181000200529     C     ChgNamArr(5)  OREQ      'P'
181100200529     C                   MOVE      '2'           BRTSCREEN
181200200529     C                   ELSE
181300200529     C                   MOVEA     *BLANKS       ChgNamArr
181400200529     C                   MOVE      '0'           CHGNAME
181500200529     C                   MOVE      'S'           @SCRN
181600200529     C                   ENDIF
181700200529
181800200529
181900200529     C     EndVAL@T      ENDSR
182000200529      *****************************************************************
182100200529      /EJECT
182200200529      *****************************************************************
182300200529      * SCRN@S - PROCESS SECOND SCREEN
182400200529      *****************************************************************
182500200529     C     SCRN@S        BEGSR
182600200529
182700200529      * Set function key status on SECONDARY screen
182800200529      *
182900200529     C                   EXSR      SFKEYS
183000200529      *
183100200529      ** WRITE/READ DISPLAY SCREEN - Secondary Details
183200200529      *
183300200529     C                   CALLB     'SDCUSD3DP'
183400200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
183500200529      * INPUT PARAMETERS :
183600200529      * Return code
183700200529     C                   PARM      *BLANK        RetCodeOut
183800200529      *
183900200529      * Customer (IN SCREEN FORMAT - Primary)
184000200529     C                   PARM                    NewCuPrim
184100200529     C                   PARM                    NewCuSeco
184200200529     C                   PARM                    NewCuSwft                                    CSW207
184300200529     C**********         PARM                    CuSW13                              CFT050 MD022395
184400200529     C                   PARM                    NewCuSW13                                  MD022395
184500200529      * Customer OK indicators
184600200529     C                   PARM                    OKCuSeco
184700200529      *
184800200529      * Errors
184900200529     C                   PARM                    FldNameArr
185000200529     C                   PARM                    MsgIdArr
185100200529     C                   PARM                    MsgDtaArr
185200200529      * Warnings
185300200529     C                   PARM                    WFldNamArr
185400200529     C                   PARM                    WMsgIdArr
185500200529     C                   PARM                    WMsgDtaArr
185600200529      *
185700200529      * ENABLED Function Keys
185800200529      * KJ = COMMAND KEY 10 = CONFIRM DELETE
185900200529      * KX = COMMAND KEY 23 = FURTHERDETAILS
186000200529     C                   PARM                    @EINKJ            1
186100200529     C                   PARM                    @EINKX
186200200529     C                   PARM                    @EINKV                                       CFT050
186300200529      *
186400200529      * OUTPUT PARAMETERS :
186500200529      * FUNCTION KEYS
186600200529     C                   PARM      '0'           @INKC
186700200529     C                   PARM      '0'           @INKJ
186800200529     C                   PARM      '0'           @INKL
186900200529     C                   PARM      '0'           @INKX
187000200529     C                   PARM      '0'           @INKV                                        CFT050
187100200529      *
187200200529      * Write screen with no read indicator
187300200529     C                   PARM      'N'           WriteOnly
187400200529     C/COPY WNCPYSRC,SDCUSDSC08
187500200529      *
187600200529      * RESET ERRORS ....
187700200529      *
187800200529     C                   MOVE      *ALL'Y'       OKCuSeco
187900200529     C                   MOVEL     *BLANK        FldNameArr
188000200529     C                   MOVEL     *BLANK        MsgIdArr
188100200529     C                   MOVEL     *BLANK        MsgDtaArr
188200200529     C                   MOVEL     *BLANK        WFldNamArr
188300200529     C                   MOVEL     *BLANK        WMsgIdArr
188400200529     C                   MOVEL     *BLANK        WMsgDtaArr
188500200529     C/COPY WNCPYSRC,SDCUSDSC09
188600200529      *
188700200529      * F3 - End Program
188800200529     C     @INKC         CASEQ     '1'           ENDP
188900200529      *
189000200529      * F12 - Cancel on Secondary Screen
189100200529     C     @INKL         CASEQ     '1'           CANC@S
189200200529      *
189300200529      * Validate Input to Secondary Screen
189400200529     C                   CAS                     VAL@S
189500200529      *
189600200529     C                   ENDCS
189700200529      *
189800200529      * On F23, go to Further Details, if there are no errors on this screen
189900200529      *
190000200529     C     @INKX         IFEQ      '1'
190100200529     C     Idx           ANDEQ     0
190200200529     C     @INKX         OREQ      '1'                                                        237595
190300200529     C     Idx           ANDNE     0                                                          237595
190400200529     C     DDACTN        ANDEQ     'D'                                                        237595
190500200529     C                   EXSR      FURDET
190600200529     C                   ENDIF
190700200529      *
190800200529     C                   ENDSR
190900200529      *****************************************************************
191000200529      /EJECT
191100200529      *****************************************************************
191200200529      * VAL@S  - VALIDATE INPUT TO SECONDARY SCREEN
191300200529      *****************************************************************
191400200529     C     VAL@S         BEGSR
191500200529      ** If F21 was pressed go to Bank Directory Plus menu                                    CFT050
191600200529     C                   IF        @INKV = '1'                                                CFT050
191700200529     C                   EVAL      @SCRN = 'E'                                                CFT050
191800200529     C                   GOTO      EndVAL@S                                                   CFT050
191900200529     C                   ENDIF                                                                CFT050
192000200529      *
192100200529      * Prior to validation, initialize error indicators as 'OK'
192200200529      *
192300200529     C                   Z-ADD     *ZERO         Idx
192400200529     C                   Z-ADD     *ZERO         WIdx_SVAL
192500200529     C                   MOVE      *ALL'Y'       OKCuSeco
192600200529     C/COPY WNCPYSRC,SDCUSDSC10
192700200529      *
192800200529      *----------------------------------------------------------------
192900200529      * IF DELETE
193000200529      *
193100200529     C     DDACTN        IFEQ      'D'
193200200529      *
193300200529      * IF F10 TAKEN, GO ON TO UPDATES
193400200529      *
193500200529     C     @INKJ         IFEQ      '1'
193600200529     C                   EXSR      RTVCUS                                                     237595
193700200529     C     DDCUSNOK      IFNE      'N'                                                        237595
193800200529     C                   MOVEL     'U'           @SCRN
193900200529     C                   ENDIF                                                                237595
194000200529     C                   END
194100200529     C                   GOTO      EndVAL@S
194200200529     C                   END
194300200529      *
194400200529      *----------------------------------------------------------------
194500200529      * IF ENQUIRE
194600200529      *
194700200529     C     DDACTN        IFEQ      'E'
194800200529      *
194900200529      * If F23 has not been selected go on to Message Details screen
195000200529      *
195100200529     C     @INKX         IFEQ      '0'
195200200529      *                                                                                       CSW024
195300200529      ** If MT3xx BEI enhancement has been installed and                                      CSW024
195400200529      ** SWIFT/Direct Link module is on then display                                          CSW024
195500200529      ** screen for MT3xx BEI details                                                         CSW024
195600200529     C                   IF        CSW024 = 'Y' AND                                           CSW024
195700200529     C                             BGMSDL = 'Y'                                               CSW024
195800200529     C                   MOVEL     'F'           @SCRN                                        CSW024
195900200529     C                   ELSE                                                                 CSW024
196000200529     C                   MOVEL     'M'           @SCRN
196100200529     C                   ENDIF                                                                CSW024
196200200529                                                                                              CSW024
196300200529     C                   END
196400200529      *
196500200529     C                   GOTO      EndVAL@S
196600200529     C                   END
196700200529      *
196800200529      *----------------------------------------------------------------
196900200529      * IF INSERT OR AMEND / CHANGE
197000200529      *
197100200529     C     DDACTN        IFEQ      'I'
197200200529     C     DDACTN        OREQ      'A'
197300200529      *
197400200529      * Update 'previous' screens and previous number of warnings
197500200529
197600200529     C                   MOVEL     NewCuSeco     PrvCuSeco
197700200529     C                   Z-ADD     WIdx_SVAL     PrvN_Warn
197800200529      *
197900200529      * Validate Secondary Screen details
198000200529      *
198100200529     C                   CALLB     'SDCUSD3VL'
198200200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
198300200529      * INPUTS :
198400200529      ** Response mode
198500200529     C                   PARM                    RespMode
198600200529      ** Customer Primary Details
198700200529     C                   PARM                    NewCuPrim
198800200529      ** Customer Secondary Details
198900200529     C                   PARM                    NewCuSeco
199000200529      ** Customer Extra Data file data
199100200529     C                   PARM                    ExtData
199200200529      ** SWIFT Detail                                                                         CSW207
199300200529     C                   PARM                    NewCuSwft                                    CSW207
199400200529     C**********         PARM                    CuSW13                              CFT050 MD022395
199500200529     C                   PARM                    NewCuSW13                                  MD022395
199600200529      * OUTPUTS :
199700200529      ** Customer Seconda Details OK inds
199800200529     C                   PARM                    OKCuSeco
199900200529      * Error fields/message IDs/message data (arrays) from/to caller
200000200529     C                   PARM                    FldNameArr
200100200529     C                   PARM                    MsgIDArr
200200200529     C                   PARM                    MsgDtaArr
200300200529      * Array index (3P0) from/to caller
200400200529     C                   PARM                    Idx
200500200529      * Warning fields/message IDs/message data (arrays) from/to caller
200600200529     C                   PARM                    WFldNamArr
200700200529     C                   PARM                    WMsgIDArr
200800200529     C                   PARM                    WMsgDtaArr
200900200529      * Array index (3P0) from/to caller
201000200529     C                   PARM                    WIdx_SVAL
201100200529      * Valid Customer layout (DS) from/to caller
201200200529     C                   PARM                    NwCuFilFmt
201300200529      * Valid SWIFT Layout (DS) from/to caller                                                CSW207
201400200529     C                   PARM                    NwSwFilFmt                                   CSW207
201500200529      * Customer SWIFT Details OK Indicator                                                   CSW207
201600200529     C                   PARM                    OkCuSwft                                     CSW207
201700200529     C/COPY WNCPYSRC,SDCUSDSC11
201800200529      *
201900200529      * If errors returned
202000200529      *
202100200529     C     Idx           IFNE      0
202200200529     C                   GOTO      EndVAL@S
202300200529     C                   END
202400200529      *
202500200529      * If the screen has changed in the course of the validation
202600200529      * or if there are warnings which have not been displayed
202700200529      * re-output the screen
202800200529      *
202900200529     C     NewCuSeco     IFNE      PrvCuSeco
203000200529     C     WIdx_SVAL     ORNE      PrvN_Warn
203100200529     C                   GOTO      EndVAL@S
203200200529     C                   END
203300200529      *
203400200529      * Clear any warning messages
203500200529      *
203600200529     C                   MOVE      *ALL'Y'       OKCuSeco
203700200529     C                   MOVEL     *BLANK        WFldNamArr
203800200529     C                   MOVEL     *BLANK        WMsgIdArr
203900200529     C                   MOVEL     *BLANK        WMsgDtaArr
204000200529     C/COPY WNCPYSRC,SDCUSDSC12
204100200529      *
204200200529      * If displaying Further Details, return to secondary details screen
204300200529      * Otherwise move on to message detail screen
204400200529      *
204500200529     C     @INKX         IFNE      '1'
204600200529      *                                                                                       CSW024
204700200529      ** If MT3xx BEI enhancement has been installed, and                                     CSW024
204800200529      ** SWIFT/Direct Link module is on then display                                          CSW024
204900200529      ** screen for MT3xx BEI details                                                         CSW024
205000200529     C                   IF        CSW024 = 'Y' AND                                           CSW024
205100200529     C                             BGMSDL = 'Y'                                               CSW024
205200200529     C                   MOVEL     'F'           @SCRN                                        CSW024
205300200529     C                   ELSE                                                                 CSW024
205400200529     C                   MOVEL     'M'           @SCRN
205500200529     C                   ENDIF                                                                CSW024
205600200529                                                                                              CSW024
205700200529     C                   END
205800200529      *
205900200529     C                   END
206000200529      *
206100200529     C     EndVAL@S      ENDSR
206200200529                                                                                              CSW024
206300200529      *****************************************************************                       CSW024
206400200529      /EJECT                                                                                  CSW024
206500200529      *****************************************************************                       CSW024
206600200529      *                                                               *                       CSW024
206700200529      * SCRN@F - Process MT3xx BEI and Fund Details screen            *                       CSW024
206800200529      *                                                               *                       CSW024
206900200529      *****************************************************************                       CSW024
207000200529                                                                                              CSW024
207100200529     C     SCRN@F        BEGSR                                                                CSW024
207200200529      *                                                                                       CSW024
207300200529      ** Set function key status for MT3xx BEI screen                                         CSW024
207400200529      *                                                                                       CSW024
207500200529     C                   EXSR      SFKEYS                                                     CSW024
207600200529      *                                                                                       CSW024
207700200529      ** Write/read display - MT3xx BEI and Fund details screen                               CSW024
207800200529      *                                                                                       CSW024
207900200529     C                   CALLB     'SDCUSD8DP'                                                CSW024
208000200529      *                  =====================                                                CSW024
208100200529      ** INPUT                                                                                CSW024
208200200529      *  =====                                                                                CSW024
208300200529      *                                                                                       CSW024
208400200529      ** Return Code                                                                          CSW024
208500200529     C                   PARM      *BLANK        RetCodeOut                                   CSW024
208600200529      *                                                                                       CSW024
208700200529      ** New Customer in Screen Format - Primary Details                                      CSW024
208800200529     C                   PARM                    NewCuPrim                                    CSW024
208900200529      *                                                                                       CSW024
209000200529      ** New Customer in Screen Format - MT3xx BEI details                                    CSW024
209100200529     C                   PARM                    NewCuMT3x                                    CSW024
209200200529      *                                                                                       CSW024
209300200529      ** Fields in error                                                                      CSW024
209400200529     C                   PARM                    OKCuMT3x                                     CSW024
209500200529      *                                                                                       CSW024
209600200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW024
209700200529     C                   PARM                    FldNameArr                                   CSW024
209800200529     C                   PARM                    MsgIdArr                                     CSW024
209900200529     C                   PARM                    MsgDtaArr                                    CSW024
210000200529      *                                                                                       CSW024
210100200529      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW024
210200200529     C                   PARM                    WFldNamArr                                   CSW024
210300200529     C                   PARM                    WMsgIdArr                                    CSW024
210400200529     C                   PARM                    WMsgDtaArr                                   CSW024
210500200529      *                                                                                       CSW024
210600200529      ** Enabled Function Keys                                                                CSW024
210700200529      ** KJ = Command Key 10 = DELETE                                                         CSW024
210800200529      ** KX = Command Key 23 = FURTHER DETAILS                                                CSW024
210900200529     C                   PARM                    @EINKJ                                       CSW024
211000200529     C                   PARM                    @EINKX                                       CSW024
211100200529     C                   PARM                    @EINKV                                       CFT050
211200200529      *                                                                                       CSW024
211300200529      ** Write screen with no read indicator                                                  CSW024
211400200529     C                   PARM                    WriteOnly                                    CSW024
211500200529      ** Linkage record key                                                                   CFT050
211600200529     C                   PARM                    DDBDRK                                       CFT050
211700200529      *                                                                                       CSW024
211800200529      ** OUTPUT                                                                               CSW024
211900200529      ** ======                                                                               CSW024
212000200529      *                                                                                       CSW024
212100200529      ** Function Keys                                                                        CSW024
212200200529     C                   PARM      '0'           @INKC                                        CSW024
212300200529     C                   PARM      '0'           @INKJ                                        CSW024
212400200529     C                   PARM      '0'           @INKL                                        CSW024
212500200529     C                   PARM      '0'           @INKX                                        CSW024
212600200529     C                   PARM      '0'           @INKV                                        CFT050
212700200529      *                                                                                       CSW024
212800200529      ** Reset errors                                                                         CSW024
212900200529      *                                                                                       CSW024
213000200529     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
213100200529     C                   MOVEL     *BLANK        FldNameArr                                   CSW024
213200200529     C                   MOVEL     *BLANK        MsgIdArr                                     CSW024
213300200529     C                   MOVEL     *BLANK        MsgDtaArr                                    CSW024
213400200529     C                   MOVEL     *BLANK        WFldNamArr                                   CSW024
213500200529     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW024
213600200529     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW024
213700200529      *                                                                                       CSW024
213800200529      ** F3 - End Program                                                                     CSW024
213900200529     C     @INKC         CASEQ     '1'           ENDP                                         CSW024
214000200529      *                                                                                       CSW024
214100200529      ** F12 - Cancel on Message Details Screen                                               CSW024
214200200529     C     @INKL         CASEQ     '1'           CANC@F                                       CSW024
214300200529      *                                                                                       CSW024
214400200529      ** Validate Input to Message Details Screen                                             CSW024
214500200529     C                   CAS                     VAL@F                                        CSW024
214600200529      *                                                                                       CSW024
214700200529     C                   ENDCS                                                                CSW024
214800200529      *                                                                                       CSW024
214900200529      ** On F23, go to Further Details, if there are no errors                                CSW024
215000200529      *                                                                                       CSW024
215100200529     C     DDACTN        IFNE      'I'                                                       BUG3362
215200200529     C     @INKX         IFEQ      '1'                                                        CSW024
215300200529     C     Idx           ANDEQ     0                                                          CSW024
215400200529     C     @INKX         OREQ      '1'                                                        237595
215500200529     C     Idx           ANDNE     0                                                          237595
215600200529     C     DDACTN        ANDEQ     'D'                                                        237595
215700200529     C                   EXSR      FURDET                                                     CSW024
215800200529     C                   ENDIF                                                                CSW024
215900200529     C                   ENDIF                                                               BUG3362
216000200529      *                                                                                       CSW024
216100200529     C                   ENDSR                                                                CSW024
216200200529                                                                                              CSW024
216300200529      *****************************************************************                       CSW024
216400200529      /EJECT                                                                                  CSW024
216500200529      *****************************************************************                       CSW024
216600200529      *                                                               *                       CSW024
216700200529      * VAL@F - Validate MT3xx BEI and Fund Details screen            *                       CSW024
216800200529      *                                                               *                       CSW024
216900200529      *****************************************************************                       CSW024
217000200529                                                                                              CSW024
217100200529     C     VAL@F         BEGSR                                                                CSW024
217200200529      ** If F21 was press go to Bank Directory Plus screen                                    CFT050
217300200529     C                   IF        @INKV = '1'                                                CFT050
217400200529     C                   EVAL      @SCRN = 'E'                                                CFT050
217500200529     C                   GOTO      EndVAL@F                                                   CFT050
217600200529     C                   ENDIF                                                                CFT050
217700200529      *                                                                                       CSW024
217800200529      ** Prior to validation, initialize error indicators as 'OK'                             CSW024
217900200529      *                                                                                       CSW024
218000200529     C                   Z-ADD     *ZERO         Idx                                          CSW024
218100200529     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
218200200529      *                                                                                       CSW024
218300200529      ** If Enquire                                                                           CSW024
218400200529      *                                                                                       CSW024
218500200529     C     DDACTN        IFEQ      'E'                                                        CSW024
218600200529      *                                                                                       CSW024
218700200529      ** If displaying Further Details, return to message details screen                      CSW024
218800200529      ** Otherwise move on to customer subfile display.                                       CSW024
218900200529      *                                                                                       CSW024
219000200529     C     @INKX         IFNE      '1'                                                        CSW024
219100200529     C     @RDNB         IFEQ      'Y'                                                        CSW024
219200200529     C     BGN4ST        ANDEQ     'Y'                                                        CSW024
219300200529     C                   MOVEL     'I'           @SCRN                                        CSW024
219400200529     C                   ELSE                                                                 CSW024
219500200529      **If*Window*Processing*on:***************************************               BUG6565 235524
219600200529      **********                                                                      BUG6565 235524
219700200529     C*****BGWDPR        IFEQ      'Y'                                                BUG6565 235524
219800200529     C**********         MOVEL     'W'           @SCRN                                BUG6565 235524
219900200529     C**********         ELSE                                                         BUG6565 235524
220000200529     C**********         EXSR      INITIAL                                             CSW024 235524
220100200529     C**********         ENDIF                                                        BUG6565 235524
220200200529      *                                                                                       235524
220300200529     C                   MOVEL     'M'           @SCRN                                        235524
220400200529     C/COPY WNCPYSRC,SDH00602
220500200529     C                   ENDIF                                                                CSW024
220600200529     C                   ENDIF                                                                CSW024
220700200529      *                                                                                       CSW024
220800200529     C                   GOTO      EndVAL@F                                                   CSW024
220900200529     C                   ENDIF                                                                CSW024
221000200529      *                                                                                       CSW024
221100200529      ** If Insert or Amend                                                                   CSW024
221200200529      *                                                                                       CSW024
221300200529     C     DDACTN        IFEQ      'I'                                                        CSW024
221400200529     C     DDACTN        OREQ      'A'                                                        CSW024
221500200529      *                                                                                       CSW024
221600200529      ** Update 'previous' screens and previous number of warnings                            CSW024
221700200529                                                                                              CSW024
221800200529     C                   MOVEL     NewCuMT3x     PrvCuMT3x                                    CSW024
221900200529     C                   Z-ADD     WIdx_Fval     PrvN_Warn                                    CSW024
222000200529     C                   Z-ADD     *ZERO         WIdx_Fval                                    CSW024
222100200529      *                                                                                       CSW024
222200200529      ** Validate message details screen                                                      CSW024
222300200529      *                                                                                       CSW024
222400200529     C                   CALLB     'SDCUSD8VL'                                                CSW024
222500200529      *                  =====================                                                CSW024
222600200529      ** INPUTS                                                                               CSW024
222700200529      ** ======                                                                               CSW024
222800200529      *                                                                                       CSW024
222900200529      ** Return Code                                                                          CSW024
223000200529     C                   PARM      *BLANK        RetCodeOut                                   CSW024
223100200529      *                                                                                       CSW024
223200200529      ** New Customer in Screen Format - MT3xx BEI details                                    CSW024
223300200529     C                   PARM                    NewCuMT3x                                    CSW024
223400200529      *                                                                                       CSW024
223500200529      ** Fields in error                                                                      CSW024
223600200529     C                   PARM                    OKCuMT3x                                     CSW024
223700200529      *                                                                                       CSW024
223800200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW024
223900200529     C                   PARM                    FldNameArr                                   CSW024
224000200529     C                   PARM                    MsgIDArr                                     CSW024
224100200529     C                   PARM                    MsgDtaArr                                    CSW024
224200200529      *                                                                                       CSW024
224300200529      ** Array index (3P0) from/to caller                                                     CSW024
224400200529     C                   PARM                    Idx                                          CSW024
224500200529      *                                                                                       CSW024
224600200529      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW024
224700200529     C                   PARM                    WFldNamArr                                   CSW024
224800200529     C                   PARM                    WMsgIDArr                                    CSW024
224900200529     C                   PARM                    WMsgDtaArr                                   CSW024
225000200529      *                                                                                       CSW024
225100200529      ** Array index (3P0) from/to caller                                                     CSW024
225200200529     C                   PARM                    WIdx_Fval                                    CSW024
225300200529      *                                                                                       CSW024
225400200529      ** Valid Customer layout (DS) from/to caller                                            CSW024
225500200529     C                   PARM                    NwCuFilFmt                                   CSW024
225600200529      *                                                                                       CSW024
225700200529      ** If errors returned                                                                   CSW024
225800200529      *                                                                                       CSW024
225900200529     C     Idx           IFNE      0                                                          CSW024
226000200529     C                   GOTO      EndVAL@F                                                   CSW024
226100200529     C                   ENDIF                                                                CSW024
226200200529      *                                                                                       CSW024
226300200529      ** If the screen has changed in the course of the validation                            CSW024
226400200529      ** or if there are warnings which have not been displayed                               CSW024
226500200529      ** re-output the screen                                                                 CSW024
226600200529      *                                                                                       CSW024
226700200529     C     NewCuMT3x     IFNE      PrvCuMT3x                                                  CSW024
226800200529     C     WIdx_Fval     ORNE      PrvN_Warn                                                  CSW024
226900200529     C                   GOTO      EndVAL@F                                                   CSW024
227000200529     C                   ENDIF                                                                CSW024
227100200529      *                                                                                       CSW024
227200200529      ** Clear any warning messages                                                           CSW024
227300200529      *                                                                                       CSW024
227400200529     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
227500200529     C                   MOVEL     *BLANK        WFldNamArr                                   CSW024
227600200529     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW024
227700200529     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW024
227800200529      *                                                                                       CSW024
227900200529      ** If displaying Further Details, return to secondary details screen                    CSW024
228000200529      ** otherwise, move to message details screen.                                           CSW024
228100200529      *                                                                                       CSW024
228200200529     C     @INKX         IFNE      '1'                                                        CSW024
228300200529     C                   MOVEL     'M'           @SCRN                                        CSW024
228400200529     C/COPY WNCPYSRC,SDH00603
228500200529     C                   ENDIF                                                                CSW024
228600200529      *                                                                                       CSW024
228700200529     C                   ENDIF                                                                CSW024
228800200529      *                                                                                       CSW024
228900200529     C     EndVAL@F      ENDSR                                                                CSW024
229000200529                                                                                              CSW024
229100200529      *****************************************************************
229200200529      /EJECT
229300200529      *****************************************************************
229400200529      * SCRN@M - PROCESS MESSAGE DETAILS SCREEN
229500200529      *****************************************************************
229600200529     C     SCRN@M        BEGSR
229700200529
229800200529      * Set function key status on SECONDARY screen
229900200529      *
230000200529     C                   EXSR      SFKEYS
230100200529      *
230200200529      ** WRITE/READ DISPLAY - Message Details Screen
230300200529      *
230400200529     C                   CALLB     'SDCUSD4DP'
230500200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
230600200529      * INPUT PARAMETERS:
230700200529      * Return Code
230800200529     C                   PARM      *BLANK        RetCodeOut
230900200529      * Customer (IN SCREEN FORMAT) - Message tails
231000200529     C                   PARM                    NewCuPrim
231100200529     C                   PARM                    NewCuMsg
231200200529      *
231300200529      * Fields in error
231400200529     C                   PARM                    OKCuMsg
231500200529      * Errors
231600200529     C                   PARM                    FldNameArr
231700200529     C                   PARM                    MsgIdArr
231800200529     C                   PARM                    MsgDtaArr
231900200529      * Warnings
232000200529     C                   PARM                    WFldNamArr
232100200529     C                   PARM                    WMsgIdArr
232200200529     C                   PARM                    WMsgDtaArr
232300200529      * ENABLED FUNCTION KEYS
232400200529      * KJ = COMMAND KEY 10 = DELETE
232500200529      * KX = COMMAND KEY 23 = FURTHER DETAILS
232600200529     C                   PARM                    @EINKJ            1
232700200529     C                   PARM                    @EINKX            1
232800200529      *
232900200529      ** OUTPUT PARAMETERS :
233000200529      * Function Keys
233100200529     C                   PARM      '0'           @INKC
233200200529     C                   PARM      '0'           @INKJ
233300200529     C                   PARM      '0'           @INKL
233400200529     C                   PARM      '0'           @INKX
233500200529      * Write screen with no read indicator
233600200529     C                   PARM      'N'           WriteOnly
233700200529      *
233800200529      * RESET ERRORS ....
233900200529      *
234000200529     C                   MOVE      *ALL'Y'       OKCuMsg
234100200529     C                   MOVEL     *BLANK        FldNameArr
234200200529     C                   MOVEL     *BLANK        MsgIdArr
234300200529     C                   MOVEL     *BLANK        MsgDtaArr
234400200529     C                   MOVEL     *BLANK        WFldNamArr
234500200529     C                   MOVEL     *BLANK        WMsgIdArr
234600200529     C                   MOVEL     *BLANK        WMsgDtaArr
234700200529      *
234800200529      *
234900200529      * F3 - End Program
235000200529     C     @INKC         CASEQ     '1'           ENDP
235100200529      *
235200200529      * F12 - Cancel on Message Details Screen
235300200529     C     @INKL         CASEQ     '1'           CANC@M
235400200529      *
235500200529      * Validate Input to Message Details Screen
235600200529     C                   CAS                     VAL@M
235700200529      *
235800200529     C                   ENDCS
235900200529
236000200529      * On F23, go to Further Details, if there are no errors on this screen
236100200529      *
236200200529     C     @INKX         IFEQ      '1'
236300200529     C     Idx           ANDEQ     0
236400200529     C     @INKX         OREQ      '1'                                                        237595
236500200529     C     Idx           ANDNE     0                                                          237595
236600200529     C     DDACTN        ANDEQ     'D'                                                        237595
236700200529     C                   EXSR      FURDET
236800200529     C                   ENDIF
236900200529      *
237000200529     C                   ENDSR
237100200529      *****************************************************************
237200200529      /EJECT
237300200529      *****************************************************************
237400200529      * VAL@M  - VALIDATE INPUT TO MESSAGE DETAILS SCREEN
237500200529      *****************************************************************
237600200529     C     VAL@M         BEGSR
237700200529      *
237800200529      * Prior to validation, initialize error indicators as 'OK'
237900200529      *
238000200529     C                   Z-ADD     *ZERO         Idx
238100200529     C                   Z-ADD     *ZERO         WIdx_Mval
238200200529     C                   MOVE      *ALL'Y'       OKCuMsg
238300200529      *
238400200529      *----------------------------------------------------------------
238500200529      * IF ENQUIRE
238600200529      *
238700200529     C     DDACTN        IFEQ      'E'
238800200529      *
238900200529      * If displaying Further Details, return to message details screen
239000200529      * Otherwise move on to customer subfile display
239100200529      **  (but if window processing is on but Private Banking is off, display window)         213713
239200200529      *
239300200529     C     @INKX         IFNE      '1'
239400200529     C     @RDNB         IFEQ      'Y'
239500200529     C     BGN4ST        ANDEQ     'Y'
239600200529     C                   MOVEL     'I'           @SCRN
239700200529     C                   ELSE
239800200529     C/COPY WNCPYSRC,SDCUSDSC04
239900200529      **If*window*processing*on                                                     BUG6565 BUG10295
240000200529     C*****BGWDPR        IFEQ      'Y'                                              BUG6565 BUG10295
240100200529     C**********         MOVEL     'W'           @SCRN                              BUG6565 BUG10295
240200200529     C**********         ELSE                                                       BUG6565 BUG10295
240300200529     C                   IF        ULX043 = 'Y'                                               CER001
240400200529     C                             OR ULX609 = 'Y'                                          BUG10817
240500200529     C                   EVAL      @SCRN = 'L'                                                CER001
240600200529     C                   ELSE                                                                 CER001
240700200529                                                                                            BUG10295
240800200529      ** If window processing on                                                            BUG10295
240900200529     C     BGWDPR        IFEQ      'Y'                                                      BUG10295
241000200529     C                   MOVEL     'W'           @SCRN                                      BUG10295
241100200529     C                   ELSE                                                               BUG10295
241200200529     C                   EXSR      INITIAL
241300200529     C                   ENDIF                                                                CER001
241400200529     C/COPY WNCPYSRC,SDCUSDSC05
241500200529     C                   ENDIF                                                               BUG6565
241600200529     C                   ENDIF
241700200529     C                   ENDIF
241800200529      *
241900200529     C                   GOTO      EndVAL@M
242000200529     C                   END
242100200529      *----------------------------------------------------------------
242200200529      * IF INSERT OR AMEND / CHANGE
242300200529      *
242400200529     C     DDACTN        IFEQ      'I'
242500200529     C     DDACTN        OREQ      'A'
242600200529      *
242700200529      * Update 'previous' screens and previous number of warnings
242800200529
242900200529     C                   MOVEL     NewCuMsg      PrvCuMsg
243000200529     C                   Z-ADD     WIdx_Mval     PrvN_Warn
243100200529      *
243200200529      * Validate message details screen
243300200529      *
243400200529     C                   CALLB     'SDCUSD4VL'
243500200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
243600200529      * INPUTS :
243700200529      * Response mode
243800200529     C                   PARM                    RespMode
243900200529      ** Customer Primary Details
244000200529      ** Customer Secondary Details
244100200529     C                   PARM                    NewCuPrim
244200200529     C                   PARM                    NewCuSeco
244300200529      ** Customer Message Details
244400200529     C                   PARM                    NewCuMsg
244500200529      * Custom Extra Data file data
244600200529     C                   PARM                    ExtData
244700200529
244800200529      ** Message details OK indicators
244900200529     C                   PARM                    OKCuMsg
245000200529
245100200529      * Error fields/message IDs/message data (arrays) from/to caller
245200200529     C                   PARM                    FldNameArr
245300200529     C                   PARM                    MsgIDArr
245400200529     C                   PARM                    MsgDtaArr
245500200529      * Array index (3P0) from/to caller
245600200529     C                   PARM                    Idx
245700200529
245800200529      * Warning fields/message IDs/message data (arrays) from/to caller
245900200529     C                   PARM                    WFldNamArr
246000200529     C                   PARM                    WMsgIDArr
246100200529     C                   PARM                    WMsgDtaArr
246200200529      * Array index (3P0) from/to caller
246300200529     C                   PARM                    WIdx_Mval
246400200529
246500200529      * Valid Customer layout (DS) from/to caller
246600200529     C                   PARM                    NwCuFilFmt
246700200529      *
246800200529      * If errors returned
246900200529      *
247000200529     C     Idx           IFNE      0
247100200529     C                   GOTO      EndVAL@M
247200200529     C                   END
247300200529      *
247400200529      * If the screen has changed in the course of the validation
247500200529      * or if there are warnings which have not been displayed
247600200529      *   re-output the screen
247700200529      *
247800200529     C     NewCuMsg      IFNE      PrvCuMsg
247900200529     C     WIdx_Mval     ORNE      PrvN_Warn
248000200529     C                   GOTO      EndVAL@M
248100200529     C                   END
248200200529      *
248300200529      * Clear any warning messages
248400200529      *
248500200529     C                   MOVE      *ALL'Y'       OKCuMsg
248600200529     C                   MOVEL     *BLANK        WFldNamArr
248700200529     C                   MOVEL     *BLANK        WMsgIdArr
248800200529     C                   MOVEL     *BLANK        WMsgDtaArr
248900200529      *
249000200529      * If displaying Further Details, return to secondary details screen
249100200529      * Otherwise move on to Private Banking Screen
249200200529      **  (but if window processing is on but Private Banking is off, display window)         213713
249300200529      *
249400200529     C     @INKX         IFNE      '1'
249500200529     C     BGN4ST        IFEQ      'Y'
249600200529     C                   MOVEL     'I'           @SCRN
249700200529     C                   ELSE
249800200529     C/COPY WNCPYSRC,SDCUSDSC02
249900200529      *
250000200529      * If Action Code is I or A go to Update
250100200529      *
250200200529     C     DDACTN        IFEQ      'I'
250300200529     C     DDACTN        OREQ      'A'
250400200529      **If*window*processing*on                                                     BUG6565 BUG10295
250500200529     C*****BGWDPR        IFEQ      'Y'                                              BUG6565 BUG10295
250600200529     C**********         MOVEL     'W'           @SCRN                              BUG6565 BUG10295
250700200529     C**********         ELSE                                                       BUG6565 BUG10295
250800200529     C                   IF        ULX043 = 'Y'                                               CER001
250900200529     C                             OR ULX609 = 'Y'                                          BUG10817
251000200529     C                   EVAL      @SCRN = 'L'                                                CER001
251100200529     C                   ELSE                                                                 CER001
251200200529                                                                                            BUG10295
251300200529      ** If window processing on                                                            BUG10295
251400200529     C     BGWDPR        IFEQ      'Y'                                                      BUG10295
251500200529     C                   MOVEL     'W'           @SCRN                                      BUG10295
251600200529     C                   ELSE                                                               BUG10295
251700200529     C                   MOVEL     'U'           @SCRN
251800200529     C                   ENDIF                                                                CER001
251900200529     C                   ENDIF                                                               BUG6565
252000200529                                                                                            BUG10295
252100200529     C                   ELSE
252200200529     C                   MOVEL     'B'           @SCRN
252300200529     C                   ENDIF
252400200529     C/COPY WNCPYSRC,SDCUSDSC03
252500200529     C                   ENDIF
252600200529     C                   END
252700200529      *
252800200529     C                   ENDIF
252900200529      *
253000200529     C     EndVAL@M      ENDSR
253100200529      *****************************************************************
253200200529      /EJECT
253300200529      *****************************************************************
253400200529      * SCRN@R - PROCESS Private Banking Details Screen
253500200529      *****************************************************************
253600200529     C     SCRN@R        BEGSR
253700200529
253800200529
253900200529     C                   CALLB     'SDCUSD5DP'
254000200529      * INPUT PARAMETERS :
254100200529      * Return code
254200200529     C                   PARM                    RetCodeIn
254300200529      *
254400200529      * Primary Details
254500200529      * Private Banking Details
254600200529     C                   PARM                    NewCuPrim
254700200529     C                   PARM                    NewCuPriv
254800200529      *
254900200529      * Fields in error
255000200529     C                   PARM                    OKCuPriv
255100200529      *
255200200529      * ERRORS
255300200529     C                   PARM                    FldNameArr
255400200529     C                   PARM                    MsgIdArr
255500200529     C                   PARM                    MsgDtaArr
255600200529      *
255700200529      * KX = COMMAND KEY 23 = FURTHER DETAILS
255800200529     C                   PARM                    @EINKX            1
255900200529      *
256000200529      * OUTPUT PARAMETERS :
256100200529      *
256200200529      * Function Keys
256300200529     C                   PARM                    @INKC
256400200529     C                   PARM                    @INKL
256500200529     C                   PARM                    @INKX
256600200529      *
256700200529      * Write screen with no read indicator
256800200529     C                   PARM                    WriteOnly
256900200529      *
257000200529      *
257100200529      * F3 - End Program
257200200529     C     @INKC         CASEQ     '1'           ENDP
257300200529      *
257400200529      * F12 - Cancel on Base Rate Tax Screen
257500200529     C     @INKL         CASEQ     '1'           CANC@R
257600200529      *
257700200529      * Validate Input to Private Banking Screen
257800200529     C                   CAS                     VAL@R
257900200529      *
258000200529     C                   ENDCS
258100200529      *
258200200529      * On F23, go to Further Details, if there are no errors on this screen
258300200529      *
258400200529     C     @INKX         IFEQ      '1'
258500200529     C     Idx           ANDEQ     0
258600200529     C     @INKX         OREQ      '1'                                                        237595
258700200529     C     Idx           ANDNE     0                                                          237595
258800200529     C     DDACTN        ANDEQ     'D'                                                        237595
258900200529     C                   EXSR      FURDET
259000200529     C                   ENDIF
259100200529      *
259200200529      *
259300200529     C     EndRDSP       ENDSR
259400200529      /EJECT                                                                                  CER001
259500200529      *****************************************************************                       CER001
259600200529      *                                                               *                       CER001
259700200529      * SRSCRN@L - Process Extension Details Screen                   *                       CER001
259800200529      *                                                               *                       CER001
259900200529      *****************************************************************                       CER001
260000200529     C     SRSCRN@L      BEGSR                                                                CER001
260100200529      *                                                                                       CER001
260200200529     C                   MOVE      DDCUSN        #1CUST                                       CER001
260300200529     C                   MOVE      DDPAIN        #1PAIN                                       CER001
260400200529     C                   MOVE      DDPCNB        #1PCNB                                       CER001
260500200529     C                   MOVE      DDCOLC        #1COLC                                       CER001
260600200529     C                   MOVE      DDLINC        #1LINC                                       CER001
260700200529     C                   MOVE      DDBRCD        #1BRCD                                       CER001
260800200529     C                   MOVE      DDBNBI        #1BNBI                                       CER001
260900200529     C                   MOVE      DDCNCZ        #2CNCZ                                       CER001
261000200529     C                   MOVE      DDTMESTMP     #1TMST                                       CER001
261100200529     C                   MOVE      DDFOTRANID    #1FOTR                                       CER001
261200200529     C                   MOVE      DDCRNM        #1CRNM                                       CER001
261300200529      *                                                                                       CER001
261400200529     C                   MOVE      DDCUSN        KCUST                                        CER001
261500200529     C                   IF        ULX609 = 'Y'                                             BUG10817
261600200529     C                   EXSR      SRRTVEXT1                                                  CER001
261700200529     C                   ENDIF                                                              BUG10817
261800200529     C                   IF        ULX043 = 'Y'                                             BUG10817
261900200529     C                   EXSR      SRRTVEXT2                                                  CER001
262000200529     C                   ENDIF                                                              BUG10817
262100200529      *                                                                                       CER001
262200200529     C                   DOU       LOOP = 'N'                                                 CER001
262300200529     C                   EVAL      LOOP = 'N'                                                 CER001
262400200529      *                                                                                       CER001
262500200529     C                   IF        ULX609 = 'Y'                                             BUG10817
262600200529     C                   CALL      'SDCUSD2SN'                                                CER001
262700200529     C                   PARM      *Blanks       RetCodeIn                                    CER001
262800200529     C                   PARM      DDACTN        PWAction                                     CER001
262900200529     C                   PARM                    PDATA                                        CER001
263000200529     C                   PARM                    PWRtn                                        CER001
263100200529     C                   PARM                    NwDlScnFmt                                   CER001
263200200529     C                   PARM                    NwDlFilFmt1                                  CER001
263300200529     C                   PARM                    ULX008                                       CER001
263400200529     C                   PARM                    ULX012                                       CER001
263500200529     C                   PARM                    ULX048                                       CER001
263600200529     C                   PARM                    ULX609                                       CER001
263700200529     C                   PARM                    BGLRIN                                       CER001
263800200529     C                   PARM                    BJMRDT                                       CER001
263900200529     C                   PARM                    ULX004                                     BUG13228
264000200529      *                                                                                       CER001
264100200529      ** If F3 or F12 was pressed in called program                                           CER001
264200200529      ** or window/DB error                                                                   CER001
264300200529      *                                                                                       CER001
264400200529     C                   IF        (PWRtn = 'Y2U9999') or                                     CER001
264500200529     C                             (PWRtn = 'USR0790') or                                     CER001
264600200529     C                             (PWRtn = 'USR0563') or                                     CER001
264700200529     C                             (PWRtn = 'Y2U0004')                                        CER001
264800200529     C                   ITER                                                                 CER001
264900200529     C                   ENDIF                                                                CER001
265000200529     C                   ENDIF                                                              BUG10817
265100200529      *                                                                                       CER001
265200200529      ** If Enter is pressed and without error                                                CER001
265300200529      *                                                                                       CER001
265400200529     C                   IF        ULX043 = 'Y'                                             BUG10817
265500200529     C                   CALL      'SDCUSD3SN'                                                CER001
265600200529     C                   PARM      *Blanks       RetCodeIn                                    CER001
265700200529     C                   PARM      DDACTN        PWAction                                     CER001
265800200529     C                   PARM                    PDATA                                        CER001
265900200529     C                   PARM                    PWRtn                                        CER001
266000200529     C                   PARM                    NwDlScnFmt                                   CER001
266100200529     C                   PARM                    NwDlFilFmt2                                  CER001
266200200529     C                   PARM                    ULX043                                       CER001
266300200529     C                   PARM                    BGNWST                                       CER001
266400200529     C                   PARM                    BJMRDT                                       CER001
266500200529      *                                                                                       CER001
266600200529      ** If F12 was pressed in called program                                                 CER001
266700200529      *                                                                                       CER001
266800200529     C                   IF        (PWRtn = 'USR0790')                                        CER001
266900200529     C                   EVAL      LOOP = 'Y'                                                 CER001
267000200529     C                   ENDIF                                                                CER001
267100200529     C                   ENDIF                                                              BUG10817
267200200529      *                                                                                       CER001
267300200529     C                   ENDDO                                                                CER001
267400200529      *                                                                                       CER001
267500200529      *                                                                                       CER001
267600200529      ** If F3 pressed, end program                                                           CER001
267700200529      *                                                                                       CER001
267800200529     C                   IF        PWRtn = 'Y2U9999'                                          CER001
267900200529     C                   EXSR      ENDP                                                       CER001
268000200529     C                   ELSE                                                                 CER001
268100200529      *                                                                                       CER001
268200200529      ** Else if F12 pressed, return to Private Banking details screen                        CER001
268300200529      *                                                                                       CER001
268400200529     C                   IF        PWRtn = 'USR0790'                                          CER001
268500200529     C                   IF        BGN4ST = 'Y'                                               CER001
268600200529     C                   EVAL      @SCRN = 'I'                                                CER001
268700200529     C                   ELSE                                                                 CER001
268800200529     C                   EVAL      @SCRN = 'M'                                                CER001
268900200529     C                   ENDIF                                                                CER001
269000200529     C                   EVAL      WriteOnly = 'N'                                            CER001
269100200529     C                   ROLBK                                                                CER001
269200200529     C                   ELSE                                                                 CER001
269300200529      *                                                                                       CER001
269400200529      ** Else if ENTER key was pressed,                                                       CER001
269500200529      *                                                                                       CER001
269600200529     C                   IF        BGWDPR = 'Y'                                               CER001
269700200529     C                   EVAL      @SCRN = 'W'                                                CER001
269800200529     C                   IF        DDACTN = 'E'                                               CER001
269900200529     C                   IF        CSC011 = 'Y'                                               CER001
270000200529     C                             AND LIBR = S1SUPP                                          CER001
270100200529     C                   Z-ADD     *ZERO         Idx                                          CER001
270200200529     C                   MOVE      *ALL'Y'       OKCuPriv                                     CER001
270300200529     C                   EVAL      FldNameArr = *BLANKS                                       CER001
270400200529     C                   EVAL      MsgIdArr = *BLANKS                                         CER001
270500200529     C                   EVAL      MsgDtaArr = *BLANKS                                        CER001
270600200529     C                   ENDIF                                                                CER001
270700200529     C                   ENDIF                                                                CER001
270800200529     C                   ELSE                                                                 CER001
270900200529     C                   EVAL      @SCRN = 'U'                                                CER001
271000200529     C                   ENDIF                                                                CER001
271100200529      *                                                                                       CER001
271200200529     C                   ENDIF                                                                CER001
271300200529     C                   ENDIF                                                                CER001
271400200529      *                                                                                       CER001
271500200529     C                   ENDSR                                                                CER001
271600200529      *****************************************************************
271700200529      /EJECT                                                                                  189774
271800200529      *****************************************************************                       189774
271900200529      * SCRN@W - Window Processing                                                            189774
272000200529      *****************************************************************                       189774
272100200529     C     Scrn@W        BEGSR                                                                189774
272200200529     C/COPY WNCPYSRC,SDCUSDSC19
272300200529      *                                                                                       213713
272400200529     C     BGN4ST        IFEQ      'Y'                                                        213713
272500200529      *                                                                                       189774
272600200529     C                   CALLB     'SDCUSD5DP'                                                189774
272700200529      ** Input parameters                                                                     189774
272800200529     C                   PARM      *Blanks       RetCodeIn                                    189774
272900200529     C                   PARM                    NewCuPrim                                    189774
273000200529     C                   PARM                    NewCuPriv                                    189774
273100200529     C                   PARM                    OKCuPriv                                     189774
273200200529     C                   PARM                    FldNameArr                                   189774
273300200529     C                   PARM                    MsgIdArr                                     189774
273400200529     C                   PARM                    MsgDtaArr                                    189774
273500200529     C                   PARM                    @EINKX                                       189774
273600200529      ** Output parameters                                                                    189774
273700200529     C                   PARM                    @INKC                                        189774
273800200529     C                   PARM                    @INKL                                        189774
273900200529     C                   PARM                    @INKX                                        189774
274000200529     C                   PARM      'Y'           WriteOnly                                    189774
274100200529      *                                                                                       213713
274200200529     C                   ELSE                                                                 213713
274300200529      *                                                                                       213713
274400200529     C                   CALLB     'SDCUSD4DP'                                                213713
274500200529      *                                                                                       213713
274600200529      * INPUT PARAMETERS:                                                                     213713
274700200529     C                   PARM      *BLANK        RetCodeOut                                   213713
274800200529     C                   PARM                    NewCuPrim                                    213713
274900200529     C                   PARM                    NewCuMsg                                     213713
275000200529     C                   PARM                    OKCuMsg                                      213713
275100200529     C                   PARM                    FldNameArr                                   213713
275200200529     C                   PARM                    MsgIdArr                                     213713
275300200529     C                   PARM                    MsgDtaArr                                    213713
275400200529     C                   PARM                    WFldNamArr                                   213713
275500200529     C                   PARM                    WMsgIdArr                                    213713
275600200529     C                   PARM                    WMsgDtaArr                                   213713
275700200529     C                   PARM                    @EINKJ                                       213713
275800200529     C                   PARM                    @EINKX                                       213713
275900200529      ** OUTPUT PARAMETERS :                                                                  213713
276000200529     C                   PARM                    @INKC                                        213713
276100200529     C                   PARM                    @INKJ                                        213713
276200200529     C                   PARM                    @INKL                                        213713
276300200529     C                   PARM                    @INKX                                        213713
276400200529     C                   PARM      'Y'           WriteOnly                                    213713
276500200529      *                                                                                       213713
276600200529     C                   END                                                                  213713
276700200529      *                                                                                       189774
276800200529     C/COPY WNCPYSRC,SDCUSDSMV1                                                               189774
276900200529      *                                                                                       189774
277000200529      ** If BOE installed                                                                    LLN022A
277100200529      *                                                                                      LLN022A
277200200529     C                   IF        LLN022 = 'Y'                                              LLN022A
277300200529      *                                                                                      LLN022A
277400200529      ** Move fields from main screen to Data structure                                      LLN022A
277500200529      ** to be passed to window                                                              LLN022A
277600200529      ** Customer Number:                                                                    LLN022A
277700200529      *                                                                                      LLN022A
277800200529     C                   Eval      BYCUST = DDCUSN                                           LLN022A
277900200529      *                                                                                      LLN022A
278000200529      ** Institution and Industry Codes                                                      LLN022A
278100200529      *                                                                                      LLN022A
278200200529     C                   Eval      BYLINC = CULINC                                           LLN022A
278300200529     C                   Eval      BYLICD = CULICD                                           LLN022A
278400200529     C                   Eval      BYCOLC = CUCOLC                                           LLN022A
278500200529      *                                                                                      LLN022A
278600200529     C                   ENDIF                                                               LLN022A
278700200529      *                                                                                      LLN022A
278800200529     C                   CALL      'WN0010'                                                   189774
278900200529     C                   PARM      'SDCUSDSIN'   PWPgm            10                          189774
279000200529     C                   PARM                    PWKey             2                          189774
279100200529     C                   PARM      DDACTN        PWAction          1                          189774
279200200529     C                   PARM                    Data                                         189774
279300200529     C                   PARM      *Blanks       PWRtn             7                          189774
279400200529     C                   PARM                    PWSpare         256                          189774
279500200529      *                                                                                       189774
279600200529      ** If F3 pressed, end program                                                           189774
279700200529      *                                                                                       189774
279800200529     C     PWRtn         IFEQ      'Y2U9999'                                                  189774
279900200529     C                   EXSR      ENDP                                                       189774
280000200529     C                   ELSE                                                                 189774
280100200529      *                                                                                       189774
280200200529      ** Else if F12 pressed, return to Private Banking details screen                        189774
280300200529      *                                                                                       189774
280400200529     C     PWRtn         IFEQ      'USR0790'                                                  189774
280500200529     C     BGN4ST        IFEQ      'Y'                                                       BUG6565
280600200529     C                   EVAL      @SCRN = 'I'                                                189774
280700200529     C                   ELSE                                                                BUG6565
280800200529     C                   EVAL      @SCRN = 'M'                                               BUG6565
280900200529     C                   ENDIF                                                               BUG6565
281000200529     C                   EVAL      WriteOnly = 'N'                                            189774
281100200529     C                   ROLBK                                                                192916
281200200529     C                   ELSE                                                                 189774
281300200529      *                                                                                       189774
281400200529      ** Else if ENTER key was pressed,                                                       189774
281500200529      **      if action is Enquire, move on to initial subfile display                        189774
281600200529      **      if Insert or Delete, do update processing                                       189774
281700200529      *                                                                                       189774
281800200529     C     DDACTN        IFEQ      'E'                                                        189774
281900200529     C                   EXSR      INITIAL                                                    189774
282000200529     C                   ELSE                                                                 189774
282100200529     C     DDACTN        IFEQ      'I'                                                        189774
282200200529     C     DDACTN        OREQ      'A'                                                        189774
282300200529     C/COPY WNCPYSRC,SDCUSDSC20
282400200529     C                   EVAL      @SCRN = 'U'                                                189774
282500200529     C                   ENDIF                                                                189774
282600200529     C                   ENDIF                                                                189774
282700200529      *                                                                                       189774
282800200529     C                   ENDIF                                                                189774
282900200529     C                   ENDIF                                                                189774
283000200529      *                                                                                       189774
283100200529     C                   ENDSR                                                                189774
283200200529      *****************************************************************                       189774
283300200529      /EJECT
283400200529      *****************************************************************                       203036
283500200529      * SCRN@W2 - Window Processing(non private banking)                                      203036
283600200529      *****************************************************************                       203036
283700200529     C     Scrn@W2       BEGSR                                                                203036
283800200529      *                                                                                       203036
283900200529      *                                                                                       203036
284000200529     C*****/COPY*QWINDSRC,*SDCUSDSMV1**                                                203036 213713
284100200529     C/COPY WNCPYSRC,SDCUSDSMV1                                                               213713
284200200529      *                                                                                       203036
284300200529      ** If BOE installed                                                                    LLN022A
284400200529      *                                                                                      LLN022A
284500200529     C                   IF        LLN022 = 'Y'                                              LLN022A
284600200529      *                                                                                      LLN022A
284700200529      ** Move fields from main screen to Data structure                                      LLN022A
284800200529      ** to be passed to window                                                              LLN022A
284900200529      ** Customer Number:                                                                    LLN022A
285000200529      *                                                                                      LLN022A
285100200529     C                   Eval      BYCUST = DDCUSN                                           LLN022A
285200200529      *                                                                                      LLN022A
285300200529      ** Institution and Industry Codes                                                      LLN022A
285400200529      *                                                                                      LLN022A
285500200529     C                   Eval      BYLINC = CULINC                                           LLN022A
285600200529     C                   Eval      BYLICD = CULICD                                           LLN022A
285700200529     C                   Eval      BYCOLC = CUCOLC                                           LLN022A
285800200529      *                                                                                      LLN022A
285900200529     C                   ENDIF                                                               LLN022A
286000200529      *                                                                                      LLN022A
286100200529     C                   CALL      'WN0010'                                                   203036
286200200529     C                   PARM      'SDCUSDSIN'   PWPgm            10                          203036
286300200529     C                   PARM                    PWKey             2                          203036
286400200529     C                   PARM      DDACTN        PWAction          1                          203036
286500200529     C                   PARM                    Data                                         203036
286600200529     C                   PARM      *Blanks       PWRtn             7                          203036
286700200529     C                   PARM                    PWSpare         256                          203036
286800200529      *                                                                                       203036
286900200529      ** If F3 pressed, end program                                                           203036
287000200529      *                                                                                       203036
287100200529     C     PWRtn         IFEQ      'Y2U9999'                                                  203036
287200200529     C                   EXSR      ENDP                                                       203036
287300200529     C                   ELSE                                                                 203036
287400200529      *                                                                                       203036
287500200529      ** Else if F12 pressed, return to PROCESS MESSAGE DETAILS SCREEN                        203036
287600200529      *                                                                                       203036
287700200529     C     PWRtn         IFEQ      'USR0790'                                                  203036
287800200529     C     BGN4ST        IFEQ      'Y'                                                        203036
287900200529     C                   EVAL      @SCRN = 'I'                                                203036
288000200529     C                   ELSE                                                                 203036
288100200529     C                   EVAL      @SCRN = 'M'                                                203036
288200200529     C                   ENDIF                                                                203036
288300200529     C                   EVAL      WriteOnly = 'N'                                            203036
288400200529     C/COPY WNCPYSRC,SDH00109
288500200529     C                   ELSE                                                                 203036
288600200529      *                                                                                       203036
288700200529      ** Else if ENTER key was pressed,                                                       203036
288800200529      **      if action is Enquire, move on to initial subfile display                        203036
288900200529      **      if Insert or Delete, do update processing                                       203036
289000200529      *                                                                                       203036
289100200529     C     DDACTN        IFEQ      'E'                                                        203036
289200200529     C                   EXSR      INITIAL                                                    203036
289300200529     C                   ELSE                                                                 203036
289400200529     C     DDACTN        IFEQ      'I'                                                        203036
289500200529     C     DDACTN        OREQ      'A'                                                        203036
289600200529     C                   EVAL      @SCRN = 'U'                                                203036
289700200529     C                   ENDIF                                                                203036
289800200529     C                   ENDIF                                                                203036
289900200529      *                                                                                       203036
290000200529     C                   ENDIF                                                                203036
290100200529     C                   ENDIF                                                                203036
290200200529      *                                                                                       203036
290300200529     C                   ENDSR                                                                203036
290400200529     C/COPY WNCPYSRC,SDH00486
290500200529      *****************************************************************                       203036
290600200529      /EJECT                                                                                  203036
290700200529      *****************************************************************
290800200529      * VAL@R  - VALIDATE INPUT TO Private Banking Details
290900200529      *****************************************************************
291000200529     C     VAL@R         BEGSR
291100200529      *
291200200529      * Prior to validation, initialize error indicators as 'OK'
291300200529     C                   Z-ADD     *ZERO         Idx
291400200529     C                   MOVE      *ALL'Y'       OKCuPriv
291500200529      *
291600200529      * IF ENQUIRE
291700200529      *
291800200529     C     DDACTN        IFEQ      'E'
291900200529      *
292000200529      * Return to browse screen
292100200529      *
292200200529      * If displaying Further Details, return to message details screen
292300200529      * Otherwise move on to customer subfile display
292400200529      *    (but if window processing is on, display window)                                   189774
292500200529      *
292600200529     C     @INKX         IFNE      '1'
292700200529     C                   IF        ULX043 = 'Y'                                               CER001
292800200529     C                             OR ULX609 = 'Y'                                          BUG10817
292900200529     C                   EVAL      @SCRN = 'L'                                                CER001
293000200529     C                   ELSE                                                                 CER001
293100200529     C     BGWDPR        IFEQ      'Y'                                                        189774
293200200529     C                   MOVE      'W'           @SCRN                                        189774
293300200529     C                   IF        CSC011 = 'Y'                                               CSC011
293400200529     C                             AND LIBR = S1SUPP                                          CSC011
293500200529     C                   Z-ADD     *ZERO         Idx                                          CSC011
293600200529     C                   MOVE      *ALL'Y'       OKCuPriv                                     CSC011
293700200529     C                   EVAL      FldNameArr = *BLANKS                                       CSC011
293800200529     C                   EVAL      MsgIdArr = *BLANKS                                         CSC011
293900200529     C                   EVAL      MsgDtaArr = *BLANKS                                        CSC011
294000200529     C                   ENDIF                                                                CSC011
294100200529     C                   ELSE                                                                 189774
294200200529     C     @RDNB         IFEQ      'Y'
294300200529     C                   MOVE      'R'           @SCRN
294400200529     C                   ENDIF                                                                189774
294500200529     C                   ENDIF                                                                189774
294600200529     C                   ENDIF                                                                CER001
294700200529     C                   ELSE
294800200529     C                   IF        CSC011 = 'Y'                                               CSC011
294900200529     C                             AND LIBR = S1SUPP                                          CSC011
295000200529     C                   EVAL      @SCRN = 'I'                                                CSC011
295100200529     C                   ELSE                                                                 CSC011
295200200529     C                   EXSR      INITIAL
295300200529     C                   ENDIF                                                                CSC011
295400200529     C                   ENDIF
295500200529     C***********        ENDIF                                                                189774
295600200529     C                   GOTO      EndVAL@R
295700200529      *
295800200529     C                   ENDIF
295900200529      *
296000200529      *----------------------------------------------------------------
296100200529      * IF INSERT OR AMEND / CHANGE
296200200529      *
296300200529     C     DDACTN        IFEQ      'I'
296400200529     C     DDACTN        OREQ      'A'
296500200529
296600200529     C                   Z-ADD     *ZERO         Idx
296700200529     C                   MOVE      *ALL'Y'       OKCuPriv
296800200529     C                   MOVEL     *BLANK        FldNameArr
296900200529     C                   MOVEL     *BLANK        MsgIdArr
297000200529     C                   MOVEL     *BLANK        MsgDtaArr
297100200529      *
297200200529      *
297300200529      * Update 'previous' screens and previous number of warnings
297400200529
297500200529     C                   MOVEL     NewCuPriv     PrvCuPriv
297600200529      *
297700200529      * Validate Private Banking Details
297800200529      *
297900200529     C                   CALLB     'SDCUSD5VL'
298000200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
298100200529      * INPUTS :
298200200529      * Response mode
298300200529     C                   PARM                    RespMode
298400200529      *
298500200529      ** Private Banking Customer Indicator
298600200529     C                   PARM                    CUPRBA
298700200529      *
298800200529      ** Customer Private Banking Details
298900200529     C                   PARM                    NewCuPriv
299000200529      *                                                                         CPB002
299100200529      ** Portfolio Management Customer Indicator                                CPB002
299200200529     C                   PARM                    PtfrCust          1            CPB002
299300200529      *                                                                         CPB002
299400200529      ** Account Officer                                                        CPB002
299500200529     C                   PARM                    DDACOC                         CPB002
299600200529                                                                                              CGL031
299700200529      ** Customer Number                                                                      CGL031
299800200529     C                   PARM                    DDCUSN                                       CGL031
299900200529      *
300000200529      * OUTPUTS :
300100200529      ** Customer Base Rate Tax Details
300200200529     C                   PARM                    OKCuPriv
300300200529      *
300400200529      * Error fields/message IDs/message data (arrays) from/to caller
300500200529     C                   PARM                    FldNameArr
300600200529     C                   PARM                    MsgIDArr
300700200529     C                   PARM                    MsgDtaArr
300800200529      *
300900200529      * Array index (3P0) from/to caller
301000200529     C                   PARM                    Idx
301100200529      *
301200200529      * Valid Private Banking layout (DS) from/to caller
301300200529     C                   PARM                    NwPBFilFmt
301400200529      *
301500200529      *
301600200529      * If any errors redisplay screen
301700200529     C     Idx           IFNE      0
301800200529     C                   GOTO      ENDVAL@R
301900200529     C                   ENDIF
302000200529      *
302100200529      * If the screen has changed in the course of the validation
302200200529      * or if there are warnings which have not been displayed
302300200529      *   re-output the screen
302400200529      *
302500200529     C     NewCuPriv     IFNE      PrvCuPriv
302600200529     C                   GOTO      EndVAL@R
302700200529     C                   END
302800200529      *
302900200529      ** Clear error indicators
303000200529     C                   MOVE      *ALL'Y'       OKCuPriv
303100200529      *
303200200529      * If displaying Further Details, go ahead, otherwise update.
303300200529      *
303400200529     C     @INKX         IFNE      '1'
303500200529      *
303600200529      * If Action Code is I or A go to Update
303700200529      *
303800200529     C     DDACTN        IFEQ      'I'
303900200529     C     DDACTN        OREQ      'A'
304000200529     C                   IF        ULX043 = 'Y'                                               CER001
304100200529     C                             OR ULX609 = 'Y'                                          BUG10817
304200200529     C                   EVAL      @SCRN = 'L'                                                CER001
304300200529     C                   ELSE                                                                 CER001
304400200529      *                                                                                       189774
304500200529     C     BGWDPR        IFEQ      'Y'                                                        189774
304600200529     C                   MOVE      'W'           @SCRN                                        189774
304700200529     C                   ELSE                                                                 189774
304800200529     C                   MOVEL     'U'           @SCRN
304900200529     C                   ENDIF                                                                189774
305000200529      *                                                                                       189774
305100200529     C                   ENDIF                                                                CER001
305200200529     C                   ELSE
305300200529     C                   MOVEL     'B'           @SCRN
305400200529     C                   ENDIF
305500200529      *
305600200529     C                   ENDIF
305700200529      *
305800200529      * End of Insert/Amend condition controlling validation call
305900200529     C                   ENDIF
306000200529      *
306100200529      *
306200200529     C     EndVAL@R      ENDSR
306300200529      *****************************************************************
306400200529      /EJECT
306500200529      *****************************************************************
306600200529      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH CUSTOMER FILE
306700200529      *****************************************************************
306800200529     C     ROLL          BEGSR
306900200529      *
307000200529      * If action is insert, control return to key screen
307100200529      *
307200200529     C     DDACTN        IFEQ      'I'
307300200529     C                   MOVE      'Y'           INSERTENQ         1
307400200529     C                   END
307500200529      *
307600200529      * Default action code to enquiry if action insert or not valid
307700200529      *
307800200529     C     DDACTN        IFNE      'A'
307900200529     C     DDACTN        ANDNE     'D'
308000200529     C                   MOVE      'E'           DDACTN
308100200529     C                   END
308200200529      *
308300200529      * READ NEXT OR PREVIOUS RECORD ON CUSTOMER FILE
308400200529      * ACCORDING TO COMMAND KEY TAKEN (F7/@INKG OR F8/@INKH)
308500200529      *
308600200529     C     @INKG         IFEQ      '1'
308700200529     C                   MOVEL     *BLANK        @RDFWD
308800200529     C                   MOVEL     'Y'           @RDBCK
308900200529     C                   ELSE
309000200529     C                   MOVEL     'Y'           @RDFWD
309100200529     C                   MOVEL     *BLANK        @RDBCK
309200200529     C                   END
309300200529      *
309400200529     C                   CALLB     'SDCUSDRED'
309500200529      *
309600200529      * INPUT PARAMETERS
309700200529      *
309800200529      * Return Code
309900200529     C                   PARM      *BLANK        RetCodeOut
310000200529      *
310100200529      * Action Code
310200200529     C                   PARM                    DDACTN
310300200529      *
310400200529      * CUSTO REF. POINTER
310500200529     C                   PARM                    DDCUSN
310600200529      *
310700200529      * READ FORWARDS
310800200529     C                   PARM                    @RDFWD            1
310900200529      *
311000200529      * READ BACKWARDS
311100200529     C                   PARM                    @RDBCK            1
311200200529      ** Acceptance Mode                                                                      CSD031
311300200529     C                   PARM                    PAccMde                                      CSD031
311400200529      *
311500200529      * OUTPUT PARAMETERS
311600200529      *
311700200529      * Error message
311800200529     C                   PARM      *BLANK        @ERRMS            7
311900200529     C                   PARM      *BLANK        @data            45                          249076
312000200529      *
312100200529      * CUSTO REF. READ
312200200529     C                   PARM      *BLANK        @CURED            6
312300200529      *
312400200529      * If error message returned from read, send it to detail screen
312500200529      *
312600200529     C     @ERRMS        IFNE      *BLANK
312700200529     C                   EXSR      SNDM@P
312800200529     C                   GOTO      EROLL
312900200529     C                   END
313000200529      *
313100200529      * If customer read
313200200529      *
313300200529     C     @CURED        IFNE      *BLANK
313400200529      *
313500200529      * Retrieve customer details
313600200529      *
313700200529     C                   MOVEL     @CURED        DDCUSN
313800200529     C                   EXSR      RTVCUS
313900200529      *
314000200529      * Return to browse screen if there is an error on customer number
314100200529      *
314200200529     C     DDCUSNOK      IFEQ      'N'
314300200529     C     DDACTNOK      OREQ      'N'
314400200529     C                   MOVEL     'B'           @SCRN
314500200529     C                   GOTO      EROLL
314600200529     C                   ENDIF
314700200529      *                                                                         CPB002
314800200529      * Check if customer is a Portfolio Management customer.                   CPB002
314900200529     C                   EXSR      CHKPTFR                                      CPB002
315000200529      *
315100200529      * Convert Customer
315200200529     C                   EXSR      CVTCUS
315300200529     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
315400200529     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
315500200529     C                   CLEAR                   NwPbFilFmt
315600200529     C                   MOVEL     CrPbFilFmt    NwPbFilFmt
315700200529     C                   MOVEL     CrTIFilFmt    NwTIFilFmt                                  BUG3362
315800200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
315900200529     C                   MOVEL     CrSwFilFmt    NwSwFilFmt                                   CSW207
316000200529     C                   ENDIF                                                                CSW207
316100200529     C/COPY WNCPYSRC,SDH00742
316200200529     C                   IF        CSW213 = 'Y'                                             MD022395
316300200529     C                   EVAL      DDLEIC = C_CSLEIC                                        MD022395
316400200529     C                   EVAL      DDCLSY = C_CSCLSY                                        MD022395
316500200529     C                   EVAL      DDCLID = C_CSCLID                                        MD022395
316600200529     C                   ENDIF                                                              MD022463
316700200529     C                   IF        CFT050 = 'Y'                                             MD022463
316800200529     C                   EVAL      DDBDRK = C_CSBDRK                                        MD022395
316900200529     C                   ENDIF                                                              MD022395
317000200529      *
317100200529      * Put the customer on the primary details screen
317200200529      *
317300200529     C                   MOVEL     'P'           @SCRN
317400200529      *
317500200529     C                   ENDIF
317600200529      *
317700200529     C     EROLL         ENDSR
317800200529      *****************************************************************
317900200529      /EJECT
318000200529      *****************************************************************
318100200529      * BLDBRW - BUILD BROWSE SUBFILE
318200200529      *****************************************************************
318300200529     C     BLDBRW        BEGSR
318400200529      *
318500200529      * Set/reset return to key screen from primary details
318600200529     C                   MOVE      'N'           INSERTENQ         1
318700200529      *
318800200529      * Reset Read next browse subfile record
318900200529     C                   MOVEL     *BLANK        @RDNB             1
319000200529      *
319100200529      * Build Browse subfile
319200200529     C                   CALLB     'SDCUSDBRW'
319300200529      *
319400200529      * INPUT PARAMETERS :
319500200529      * Return Code
319600200529      * Action Code
319700200529      * Customer Ref. Pointer
319800200529      * Build subfile
319900200529      * Read subfile record
320000200529      * Mode                                                                                  CLE025
320100200529     C                   PARM      *BLANK        RetCodeOut
320200200529     C                   PARM                    DDACTN
320300200529     C                   PARM                    DDCUSN
320400200529     C                   PARM      'Y'           @BDSFL            1
320500200529     C                   PARM      *BLANK        @RDSFL            1
320600200529     C                   PARM                    PMODE                                        CLE025
320700200529     C                   PARM                    FldNameArr
320800200529     C                   PARM                    MsgIdArr
320900200529     C                   PARM                    MsgDtaArr
321000200529     C                   PARM                    CSD037                                       CSD031
321100200529      *
321200200529      * OUTPUT PARAMETERS :
321300200529      * Error message
321400200529      * Option Selected
321500200529      * Customer Reference Selected
321600200529      * Command Keys
321700200529     C                   PARM      *BLANK        @ERRMS
321800200529     C                   PARM      *BLANK        @data                                        249076
321900200529     C                   PARM      *BLANK        @OPSEL            1
322000200529     C                   PARM      *BLANK        @CUSEL            6
322100200529     C                   PARM      '0'           @INKC
322200200529     C                   PARM      '0'           @INKI             1
322300200529      ** Acceptance Mode                                                                      CSD031
322400200529     C                   PARM                    PAccMde                                      CSD031
322500200529      *
322600200529      * If F3 taken in browse, End Program
322700200529     C     @INKC         IFEQ      '1'
322800200529     C                   EXSR      ENDP
322900200529     C                   GOTO      EndBLDBRW
323000200529     C                   END
323100200529      *
323200200529      * If Insert (F9) selected from browse, go to key screen
323300200529     C     @OPSEL        IFEQ      'I'
323400200529     C                   MOVEL     'K'           @SCRN
323500200529     C                   MOVE      'I'           DDACTN
323600200529     C                   GOTO      EndBLDBRW
323700200529     C                   END
323800200529      *
323900200529      * If error message returned from browse, send it to detail screen
324000200529      *
324100200529     C     @ERRMS        IFNE      *BLANK
324200200529     C                   EXSR      SNDM@P
324300200529     C                   GOTO      EndBLDBRW
324400200529     C                   END
324500200529      *
324600200529      * Read next browse subfile record
324700200529      *
324800200529      *
324900200529     C                   MOVE      'Y'           @RDNB
325000200529     C                   MOVEL     'R'           @SCRN
325100200529      *
325200200529     C     EndBLDBRW     ENDSR
325300200529      *****************************************************************
325400200529      /EJECT
325500200529      *****************************************************************
325600200529      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
325700200529      *****************************************************************
325800200529     C     RDNBRW        BEGSR
325900200529      *
326000200529      * Read Next Subfile Record
326100200529      *
326200200529     C                   CALLB     'SDCUSDBRW'
326300200529      * INPUT PARAMETERS :
326400200529      * Return code
326500200529      * Action code
326600200529      * Customer Ref. pointer
326700200529      * Build Sub-file
326800200529      * Read Sub-file record
326900200529      * Browse Screen
327000200529     C                   PARM      *BLANK        RetCodeOut
327100200529     C                   PARM                    DDACTN
327200200529     C                   PARM                    DDCUSN
327300200529     C                   PARM      *BLANK        @BDSFL
327400200529     C                   PARM      'Y'           @RDSFL
327500200529     C                   PARM                    PMODE                                        CLE025
327600200529     C                   PARM                    FldNameArr
327700200529     C                   PARM                    MsgIdArr
327800200529     C                   PARM                    MsgDtaArr
327900200529     C                   PARM                    CSD037                                       CSD031
328000200529      * OUTPUT PARAMETERS :
328100200529      * Error Message
328200200529      * Option Selected
328300200529      * Customer Ref. selected
328400200529      * Function keys
328500200529     C                   PARM      *BLANK        @ERRMS
328600200529     C                   PARM      *BLANK        @data                                        249076
328700200529     C                   PARM      *BLANK        @OPSEL
328800200529     C                   PARM      *BLANK        @CUSEL
328900200529     C                   PARM      '0'           @INKC
329000200529     C                   PARM      '0'           @INKI
329100200529      ** Acceptance Mode                                                                      CSD031
329200200529     C                   PARM                    PAccMde                                      CSD031
329300200529      *
329400200529      * If Customer read from subfile
329500200529     C     @CUSEL        IFNE      *BLANK
329600200529      *
329700200529      * Retrieve Customer details
329800200529      *
329900200529     C                   MOVEL     @OPSEL        DDACTN
330000200529     C                   MOVEL     @CUSEL        DDCUSN
330100200529     C                   EXSR      RTVCUS
330200200529      *
330300200529      * Stay on browse screen if there is an error on customer number
330400200529      *
330500200529     C     DDCUSNOK      IFEQ      'N'
330600200529     C     DDACTN        ANDNE     'D'                                                        237595
330700200529     C     DDACTNOK      OREQ      'N'
330800200529     C                   MOVEL     'B'           @SCRN
330900200529     C                   GOTO      EndRDNBRW
331000200529     C                   ENDIF
331100200529     C                   MOVE      *ALL'Y'       OKCuPrim                                     237595
331200200529     C                   MOVEL     *BLANK        FldNameArr                                   237595
331300200529     C                   MOVEL     *BLANK        MsgIdArr                                     237595
331400200529     C                   MOVEL     *BLANK        MsgDtaArr                                    237595
331500200529     C                   MOVEL     *BLANK        WFldNamArr                                   237595
331600200529     C                   MOVEL     *BLANK        WMsgIdArr                                    237595
331700200529     C                   MOVEL     *BLANK        WMsgDtaArr                                   237595
331800200529     C                   Z-ADD     0             Idx                                          237595
331900200529      *                                                                         CPB002
332000200529      * Check if customer is a Portfolio Management customer.                   CPB002
332100200529     C                   EXSR      CHKPTFR                                      CPB002
332200200529      *
332300200529      * Convert Customer details
332400200529     C                   EXSR      CVTCUS
332500200529     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
332600200529     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
332700200529     C                   MOVEL     CrPBFilFmt    NwPBFilFmt
332800200529     C                   MOVEL     CrTIFilFmt    NwTIFilFmt                                  BUG3362
332900200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
333000200529     C                   MOVEL     CrSwFilFmt    NwSwFilFmt                                   CSW207
333100200529     C                   ENDIF                                                                CSW207
333200200529     C/COPY WNCPYSRC,SDH00743
333300200529     C                   IF        CSW213 = 'Y'                                             MD022395
333400200529     C                   EVAL      DDLEIC = C_CSLEIC                                        MD022395
333500200529     C                   EVAL      DDCLSY = C_CSCLSY                                        MD022395
333600200529     C                   EVAL      DDCLID = C_CSCLID                                        MD022395
333700200529     C                   ENDIF                                                              MD022854
333800200529     C                   IF        CFT050 = 'Y'                                             MD022854
333900200529     C                   EVAL      DDBDRK = C_CSBDRK                                        MD022395
334000200529     C                   ENDIF                                                              MD022395
334100200529     C     DDCUSN        IFNE      FDCUST                                                     244030
334200200529     C                   CLEAR                   FURDETS                                      244030
334300200529     C                   MOVE      DDCUSN        FDCUST                                       244030
334400200529     C                   MOVE      DDCSSN        FDCSSN                                       244030
334500200529     C                   MOVE      DDCRTN        FDCRTN                                       244030
334600200529     C                   MOVE      DDCRNM        FDCRNM                                       244030
334700200529     C                   MOVE      DDLINC        FDLINC                                       244030
334800200529     C                   MOVE      C_BBTICS      FDTICS                                       244030
334900200529     C                   MOVEL     CrTIFilFMt    FDCTID                                       244030
335000200529     C                   ENDIF                                                                244030
335100200529      *
335200200529      * Put customer on key screen for Insert, primary details otherwise
335300200529      *
335400200529     C     @OPSEL        IFEQ      'I'
335500200529     C                   MOVEL     'K'           @SCRN
335600200529     C                   ELSE
335700200529     C/COPY WNCPYSRC,SDH00487
335800200529     C                   MOVEL     'P'           @SCRN
335900200529     C/COPY WNCPYSRC,SDH00488
336000200529     C                   END
336100200529     C                   EXSR      SFDS@P
336200200529      *
336300200529      * Else, go to initial screen
336400200529      *
336500200529     C                   ELSE
336600200529     C                   EXSR      INITIAL
336700200529     C                   END
336800200529      *
336900200529     C     EndRDNBRW     ENDSR
337000200529      *****************************************************************
337100200529      /EJECT
337200200529      *****************************************************************
337300200529      * RTVCUS - RETRIEVE CUSTO
337400200529      *****************************************************************
337500200529     C     RTVCUS        BEGSR
337600200529      *
337700200529      * RETRIEVE CUSTOMER
337800200529      *
337900200529     C                   CALLB     'SDCUSDRTV'
338000200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
338100200529      * INPUTS :
338200200529      * Return code
338300200529     C                   PARM      *BLANK        RetCodeOut
338400200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
338500200529      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
338600200529     C                   PARM      '      '      @@MODE            6
338700200529      * Response mode
338800200529     C                   PARM      'S'           @@RSMD            1
338900200529      * Action Code
339000200529     C                   PARM                    DDACTN
339100200529      * Front Office Transaction ID
339200200529     C                   PARM                    C_BBFRNT
339300200529      * (Midas) Trade Reference
339400200529     C                   PARM                    DDCUSN
339500200529      * Base Rate Auth req                                                                    CSD012
339600200529     C                   PARM                    AUTHRQ                                       CSD012
339700200529      * Base Auth mode                                                                        CSD012
339800200529     C                   PARM                    AUTHMD                                       CSD012
339900200529      *
340000200529      *  Base Rate Tax option feature is switched on
340100200529     C                   PARM                    S01383
340200200529      *  Private Banking Customer module is switched on
340300200529     C                   PARM                    BGN4ST
340400200529      ** Global Data Layout feature is switched on                                            CGP001
340500200529     C                   PARM                    CGP001                                       CGP001
340600200529      ** KYC: Transaction Type                                                                CSD028
340700200529                                                                                              CSD028
340800200529     C                   PARM                    TransType                                    CSD028
340900200529      ** Acceptance Mode                                                                      CSD031
341000200529     C                   PARM                    PAccMde                                      CSD031
341100200529      ** Update (Y/N)                                                                         CSD031
341200200529     C                   PARM                    PUpdYN                                       CSD031
341300200529      * OUTPUTS :
341400200529      * (Current) Customer in file format
341500200529      * Current Customer Base Rate Tax in file format
341600200529      ** (Current) Global Customer X-Reference in file format                                 CGP001
341700200529     C                   PARM                    CrCuFilFmt
341800200529     C                   PARM                    CrBrFilFmt
341900200529     C                   PARM                    CrPBFilFmt
342000200529     C                   PARM                    CrTIFilFmt                                  BUG3362
342100200529     C                   PARM                    GCrCuFilFmt                                  CGP001
342300200529     C                   PARM                    CrcmFilFmt                                   CRE026
342400200529     C                   PARM                    CracFilFmt                                   CRE026
342500200529     C                   PARM                    CrcfFilFmt                                   CRE026
342600200529     C                   PARM                    CrchFilFmt                                   CRE026
342700200529     C                   PARM                    CrsaFilFmt                                   CRE026
342800200529     C                   PARM                    CrvrFilFmt                                   CRE026
342900200529     C                   PARM                    CrfoFilFmt                                   CRE026
343000200529     C                   PARM                    CroxFilFmt                                   CRE026
343100200529     C                   PARM                    CrplFilFmt                                   CRE026
343200200529     C                   PARM                    Crx2FilFmt                                   CRE026
343300200529     C                   PARM                    Crx1fFilFmt                                  CRE026
343500200529     C                   PARM                    CrSwFilFmt                                   CSW207
343600200529     C**********         PARM                    CuSW13                              CFT050 MD022395
343700200529     C                   PARM                    CrCuSW13                                   MD022395
343900200529     C                   PARM                    TranInCUAH                                   CER059
344000200529     C                   PARM                    TranInCCTX                                   CER059
344200200529     C                   PARM                    CurCuPrim                                    CFT050
344300200529     C                   PARM                    CurCuSeco                                    CFT050
344400200529     C                   PARM                    CurCuMT3x                                    CFT050
344500200529     C/COPY WNCPYSRC,SDH00744
344600200529      * OK - Action code
344700200529     C                   PARM      *BLANK        DDACTNOK
344800200529      * OK - Customer Reference
344900200529     C                   PARM      *BLANK        DDCUSNOK
345000200529      * Error fields/message IDs/message data (arrays) from/to caller
345100200529     C                   PARM                    FldNameArr
345200200529     C                   PARM                    MsgIdArr
345300200529     C                   PARM                    MsgDtaArr
345400200529      * Array index (3P0) from/to caller
345500200529     C                   PARM      *ZERO         Idx
345600200529      **Base*Rate Auth req                                                             CSD012 222373
345700200529     C**********         PARM                    AUTHRQ                                CSD012 222373
345800200529      *                                                                                     BUG23518
345900200529      * Warning fields/message IDs/message data (arrays) from/to caller                     BUG23518
346000200529     C                   PARM                    WFldNamArr                                 BUG23518
346100200529     C                   PARM                    WMsgIDArr                                  BUG23518
346200200529     C                   PARM                    WMsgDtaArr                                 BUG23518
346300200529      *                                                                                     BUG23518
346400200529      * Array index (3P0) from/to caller                                                    BUG23518
346500200529     C                   PARM      *ZEROS        WIdx_PVAL                                  BUG23518
346600200529     C/COPY WNCPYSRC,SDCUSDSC13
346700200529
346800200529     C     EndRTVCUS     ENDSR
346900200529      *****************************************************************                       CER001
347000200529      /EJECT                                                                                  CER001
347100200529      *****************************************************************                       CER001
347200200529      *                                                               *                       CER001
347300200529      * SRRTVEXT1 - Retrieve customer extension group 1               *                       CER001
347400200529      *                                                               *                       CER001
347500200529      *****************************************************************                       CER001
347600200529     C     SRRTVEXT1     BEGSR                                                                CER001
347700200529      *                                                                                       CER001
347800200529      ** Retrieve record in extension file                                                    CER001
347900200529      *                                                                                       CER001
348000200529     C     K@KEY1        CHAIN(N)  RTVIDXA                            85                      CER001
348100200529      *                                                                                       CER001
348200200529     C                   SELECT                                                               CER001
348300200529      *                                                                                       CER001
348400200529      ** If record exist                                                                      CER001
348500200529      *                                                                                       CER001
348600200529     C                   WHEN      *IN85 = *OFF                                               CER001
348700200529      *                                                                                       CER001
348800200529     C                   EVAL      WFIND1 = 'Y'                                               CER001
348900200529      *                                                                                       CER001
349000200529     C*********          IF        VFCGRP = 0                                         CER001 CSD027A
349100200529     C                   IF        VFCGRP = *BLANKS                                          CSD027A
349200200529     C                   MOVE      *BLANKS       L6LXCGRP                                     CER001
349300200529     C                   ELSE                                                                 CER001
349400200529     C                   MOVE      VFCGRP        L6LXCGRP                                     CER001
349500200529     C                   ENDIF                                                                CER001
349600200529      *                                                                                       CER001
349700200529      ** Use the SR/ZEDIT to format the Provisions Forfaitaires                               CER001
349800200529      *                                                                                       CER001
349900200529     C                   MOVE      *BLANKS       ZFIELD           16                          CER001
350000200529     C                   MOVE      VFPAPS        ZFIELD                                       CER001
350100200529     C                   Z-ADD     2             ZADEC             1 0                        CER001
350200200529     C                   CALLB     'ZEDIT'                                                    CER001
350300200529     C                   PARM                    ZFIELD                                       CER001
350400200529     C                   PARM                    ZADEC                                        CER001
350500200529     C                   MOVE      ZFIELD        L6LXPAPS                                     CER001
350600200529      *                                                                                       CER001
350700200529     C                   MOVE      VFCONS        L6LXCONS                                     CER001
350800200529     C                   MOVE      VFECOS        L6LXECOS                                     CER001
350900200529     C                   MOVE      VFNCOS        L6LXNCOS                                     CER001
351000200529     C                   MOVE      VFINRF        L6LXINRF                                     CER001
351100200529     C                   MOVE      VFPERF        L6LXPERF                                     CER001
351200200529     C                   MOVE      VFSMRS        L6LXSMRS                                     CER001
351300200529      *                                                                                       CER001
351400200529     C                   IF        ULX012 = 'Y'                                               CER001
351500200529     C                   MOVE      VFAUTG        L6LXAUTG                                     CER001
351600200529     C                   MOVE      VFPROG        L6LXPROG                                     CER001
351700200529     C                   MOVE      VFASSP        L6LXASSP                                     CER001
351800200529     C                   ENDIF                                                                CER001
351900200529      *                                                                                       CER001
352000200529     C                   IF        ULX008 = 'Y'                                               CER001
352100200529     C                   MOVE      VFICCD        L6LXICCD                                     CER001
352200200529     C                   MOVE      VFMCID        L6LXMCID                                     CER001
352300200529     C                   ENDIF                                                                CER001
352400200529      *                                                                                       CER001
352500200529     C                   EVAL      #6LXVFFOTR  =  DDFOTRANID                                  CER001
352600200529     C                   EVAL      #6LXVFCUST  =  VFCUST                                      CER001
352700200529     C                   EVAL      #6LXVFCONS  =  VFCONS                                      CER001
352800200529     C                   EVAL      #6LXVFECOS  =  VFECOS                                      CER001
352900200529     C                   EVAL      #6LXVFINRF  =  VFINRF                                      CER001
353000200529     C                   EVAL      #6LXVFCGRP  =  VFCGRP                                      CER001
353100200529     C                   EVAL      #6LXVFCRNM  =  VFCRNM                                      CER001
353200200529     C                   EVAL      #6LXVFCOLC  =  VFCOLC                                      CER001
353300200529     C                   EVAL      #6LXVFPAPS  =  VFPAPS                                      CER001
353400200529     C                   EVAL      #6LXVFPERF  =  VFPERF                                      CER001
353500200529     C                   EVAL      #6LXVFNCOS  =  VFNCOS                                      CER001
353600200529     C                   EVAL      #6LXVFAUTG  =  VFAUTG                                      CER001
353700200529     C                   EVAL      #6LXVFPROG  =  VFPROG                                      CER001
353800200529     C                   EVAL      #6LXVFASSP  =  VFASSP                                      CER001
353900200529     C                   EVAL      #6LXVFICCD  =  VFICCD                                      CER001
354000200529     C                   EVAL      #6LXVFMCID  =  VFMCID                                      CER001
354100200529     C                   EVAL      #6LXVFSMRS  =  VFSMRS                                      CER001
354200200529     C                   EVAL      #6LXVFTMES  =  DDTMESTMP                                   CER001
354300200529      *                                                                                       CER001
354400200529     C                   MOVE      NwDlScnFmt    CrDlScnFmt                                   CER001
354500200529      *                                                                                       CER001
354600200529      ** If record does not exist                                                             CER001
354700200529      *                                                                                       CER001
354800200529     C                   WHEN      *IN85 = *ON                                                CER001
354900200529      *                                                                                       CER001
355000200529     C                   EVAL      WFIND1 = *BLANKS                                           CER001
355100200529      *                                                                                       CER001
355200200529     C                   EVAL      L6LXPAPS = *BLANKS                                         CER001
355300200529     C                   EVAL      L6LXCGRP = *BLANKS                                         CER001
355400200529     C                   EVAL      L6LXCONS = '0'                                             CER001
355500200529                                                                                            BG12345A
355600200529     C                   IF        ULX043 = 'Y' AND BGNWST = 'Y'                            BG12345A
355700200529      *                                                                                       CER001
355800200529     C     #1LINC        CHAIN     SDINX1L0                           99                      CER001
355900200529     C                   IF        *IN99 = *ON                                                CER001
356000200529     C                   EVAL      L6LXECOS = '4000'                                          CER001
356100200529     C                   EVAL      L6LXNCOS = '9000'                                          CER001
356200200529     C                   ELSE                                                                 CER001
356300200529      *                                                                                       CER001
356400200529     C                   SELECT                                                               CER001
356500200529     C                   WHEN      #1COLC = 'LU'                                              CER001
356600200529     C                   MOVE      AOECOL        L6LXECOS                                     CER001
356700200529     C                   WHEN      #1COLC = 'BE'                                              CER001
356800200529     C                   MOVE      AOECOB        L6LXECOS                                     CER001
356900200529     C                   OTHER                                                                CER001
357000200529     C                   MOVE      AOECOO        L6LXECOS                                     CER001
357100200529     C                   ENDSL                                                                CER001
357200200529      *                                                                                       CER001
357300200529      ** Retrieve data SDCTX2L0                                                               CER001
357400200529      *                                                                                       CER001
357500200529     C     #1COLC        CHAIN     SDCTX2L0                           99                      CER001
357600200529     C                   IF        *IN99 = *ON                                                CER001
357700200529     C                   ENDIF                                                                CER001
357800200529      *                                                                                       CER001
357900200529     C                   SELECT                                                               CER001
358000200529     C                   WHEN      #1COLC = 'LU'                                              CER001
358100200529     C                   MOVE      AONCOL        L6LXNCOS                                     CER001
358200200529     C                   WHEN      #1COLC <> 'LU'  AND                                        CER001
358300200529     C                             WFEMUM = 'Y'                                               CER001
358400200529     C                   MOVE      AONCOE        L6LXNCOS                                     CER001
358500200529     C                   OTHER                                                                CER001
358600200529     C                   MOVE      AONCOO        L6LXNCOS                                     CER001
358700200529     C                   ENDSL                                                                CER001
358800200529      *                                                                                       CER001
358900200529     C                   ENDIF                                                              BG12345A
359000200529     C                   ENDIF                                                                CER001
359100200529      *                                                                                       CER001
359200200529     C                   EVAL      L6LXINRF = '0'                                             CER001
359300200529     C                   EVAL      L6LXPERF = *BLANKS                                         CER001
359400200529     C                   EVAL      L6LXSMRS = *BLANKS                                         CER001
359500200529      *                                                                                       CER001
359600200529     C                   IF        ULX012 = 'Y'                                               CER001
359700200529     C                   EVAL      L6LXAUTG = *BLANKS                                         CER001
359800200529     C                   EVAL      L6LXPROG = *BLANKS                                         CER001
359900200529     C                   EVAL      L6LXASSP = *BLANKS                                         CER001
360000200529     C                   ENDIF                                                                CER001
360100200529      *                                                                                       CER001
360200200529     C                   IF        ULX008 = 'Y'                                               CER001
360300200529     C                   EVAL      L6LXICCD = *BLANKS                                         CER001
360400200529     C                   IF        ULX048 = 'Y'                                               CER001
360500200529     C                   EVAL      L6LXMCID = 'Y'                                             CER001
360600200529     C                   ELSE                                                                 CER001
360700200529     C                   EVAL      L6LXMCID = 'N'                                             CER001
360800200529     C                   ENDIF                                                                CER001
360900200529     C                   ENDIF                                                                CER001
361000200529      *                                                                                       CER001
361100200529     C                   ENDSL                                                                CER001
361200200529      *                                                                                       CER001
361300200529     C                   ENDSR                                                                CER001
361400200529      *****************************************************************                       CER001
361500200529      /EJECT                                                                                  CER001
361600200529      *****************************************************************                       CER001
361700200529      *                                                               *                       CER001
361800200529      * SRRTVEXT2 - Retrieve customer extension group 2               *                       CER001
361900200529      *                                                               *                       CER001
362000200529      *****************************************************************                       CER001
362100200529     C     SRRTVEXT2     BEGSR                                                                CER001
362200200529      *                                                                                       CER001
362300200529      ** Retrieve record in extension file                                                    CER001
362400200529      *                                                                                       CER001
362500200529     C     K@KEY1        CHAIN(N)  RTVIDXB                            85                      CER001
362600200529      *                                                                                       CER001
362700200529     C                   SELECT                                                               CER001
362800200529      *                                                                                       CER001
362900200529      ** If record exist                                                                      CER001
363000200529      *                                                                                       CER001
363100200529     C                   WHEN      *IN85 = *OFF                                               CER001
363200200529      *                                                                                       CER001
363300200529     C                   EVAL      WFIND2 = 'Y'                                               CER001
363400200529      *                                                                                       CER001
363500200529     C                   MOVE      CUTYPE        LLLXTYPE                                     CER001
363600200529     C                   MOVE      CUIDCO        LLLXIDCO                                     CER001
363700200529     C                   MOVE      CUIDEN        LLLXIDEN                                     CER001
363800200529     C                   MOVE      CUIMCO        LLLXIMCO                                     CER001
363900200529     C                   MOVE      CUIMNB        LLLXIMNB                                     CER001
364000200529      *                                                                                       CER001
364100200529     C                   EVAL      #LLXCUFOTR = DDFOTRANID                                    CER001
364200200529     C                   EVAL      #LLXCUCNUM = CUCNUM                                        CER001
364300200529     C                   EVAL      #LLXCUTYPE = CUTYPE                                        CER001
364400200529     C                   EVAL      #LLXCUIDCO = CUIDCO                                        CER001
364500200529     C                   EVAL      #LLXCUIDEN = CUIDEN                                        CER001
364600200529     C                   EVAL      #LLXCUIMCO = CUIMCO                                        CER001
364700200529     C                   EVAL      #LLXCUIMNB = CUIMNB                                        CER001
364800200529     C                   EVAL      #LLXCUTMES = DDTMESTMP                                     CER001
364900200529      *                                                                                       CER001
365000200529     C                   MOVE      NwDlScnFmt    CrDlScnFmt                                   CER001
365100200529      *                                                                                       CER001
365200200529      ** If record does not exist                                                             CER001
365300200529      *                                                                                       CER001
365400200529     C                   WHEN      *IN85 = *ON                                                CER001
365500200529     C                   EVAL      WFIND2 = *BLANKS                                           CER001
365600200529      *                                                                                       CER001
365700200529     C                   EVAL      LLLXTYPE = *BLANKS                                         CER001
365800200529     C                   EVAL      LLLXIDCO = *BLANKS                                         CER001
365900200529     C                   EVAL      LLLXIDEN = *BLANKS                                         CER001
366000200529     C                   EVAL      LLLXIMCO = *BLANKS                                         CER001
366100200529     C                   EVAL      LLLXIMNB = *BLANKS                                         CER001
366200200529      *                                                                                       CER001
366300200529     C                   CALLB     'SDVCUTYPE2'                                               CER001
366400200529     C                   PARM                    ReturnCode                                   CER001
366500200529     C                   PARM                    MSG1                                         CER001
366600200529     C                   PARM                    LLLXTYPE                                     CER001
366700200529     C                   PARM                    DDCOLC                                       CER001
366800200529     C                   PARM                    DDCUSN                                       CER001
366900200529     C                   PARM                    DDBNBI                                       CER001
367000200529     C                   PARM                    DDBRCD                                       CER001
367100200529     C                   PARM                    BRBKCO                                       CER001
367200200529     C                   PARM                    #1NCOS                                       CER001
367300200529      *                                                                                       CER001
367400200529     C                   ENDSL                                                                CER001
367500200529      *                                                                                       CER001
367600200529     C                   ENDSR                                                                CER001
367700200529      *****************************************************************
367800200529      /EJECT
367900200529      *****************************************************************         CPB002
368000200529      * CHKPTFR - Check if Portfolio Management Customer.                       CPB002
368100200529      *****************************************************************         CPB002
368200200529     C     CHKPTFR       BEGSR                                                  CPB002
368300200529      *                                                                         CPB002
368400200529      ** Initialize Portfolio Management customer indicator.                    CPB002
368500200529     C                   MOVE      'N'           PtfrCust                       CPB002
368600200529      *                                                                         CPB002
368700200529      * Retrieve Portfolio Management customer details.                         CPB002
368800200529      * if PM is on.                                                                          212263
368900200529      *                                                                         CPB002
369000200529     C     BGPFMG        IFEQ      'Y'                                                        212263
369100200529     C                   CALL      'AOPLCSR0'                                   CPB002
369200200529     C                   PARM      *BLANKS       @RTCD                          CPB002
369300200529     C                   PARM      '*VERIFY'     @OPTN                          CPB002
369400200529     C                   PARM      DDCUSN        P@CUST           10            CPB002
369500200529     C                   PARM                    DSFDY                                        212263
369600200529      *                                                                         CPB002
369700200529      ** If Portfolio Management customer details exist, set up                 CPB002
369800200529      ** Portfolio Management Customer Indicator.                               CPB002
369900200529      *                                                                         CPB002
370000200529     C     @RTCD         IFEQ      *BLANKS                                      CPB002
370100200529     C                   MOVE      'Y'           PtfrCust                       CPB002
370200200529      *                                                                         CPB002
370300200529     C                   END                                                                  212263
370400200529     C                   END                                                    CPB002
370500200529                                                                                CPB002
370600200529     C                   ENDSR                                                  CPB002
370700200529      *****************************************************************         CPB002
370800200529      /EJECT                                                                    CPB002
370900200529      *****************************************************************
371000200529      * CVTCUS - PUT A CUSTOMER ON THE PRIMARY DETAILS SCREEN
371100200529      *****************************************************************
371200200529     C     CVTCUS        BEGSR
371300200529      *
371400200529      * Call program to fill screen fields with data from SDCUSTPD
371500200529      *
371600200529     C                   CALLB     'SDCUSDCVT'
371700200529      *
371800200529      * INPUTS :
371900200529      * Return Code
372000200529     C                   PARM      *BLANK        RetCodeOut
372100200529      *
372200200529      * Customer file format
372300200529     C                   PARM                    CrCuFilFmt
372400200529     C/COPY WNCPYSRC,SDH00745
372500200529      *
372600200529      * Base Rate Tax file format
372700200529     C                   PARM                    CrBrFilFmt
372800200529      *
372900200529      * Private Banking format
373000200529     C                   PARM                    CrPBFilFmt
373200200529                                                                                              CGP001
373300200529      ** Global Customer X-Reference                                                          CGP001
373400200529     C                   PARM                    GCrCuFilFmt                                  CGP001
373500200529     C                   PARM                    CrSwFilFmt                                   CSW207
373700200529                                                                                              CGP001
373800200529      ** Switchable features                                                                  CLE025
373900200529                                                                                              CLE025
374000200529     C                   PARM                    CLE025                                       CLE025
374100200529     C                   PARM                    CFX001                                       CFX001
374200200529      *                                                                                     MD054028
374300200529     C                   PARM                    DDAPRC                                     MD054028
374400200529      * OUTPUTS
374500200529      * Customer - screen formats
374600200529     C                   PARM                    NewCuPrim
374700200529     C                   PARM                    NewCuSeco
374800200529     C                   PARM                    NewCuMT3x                                    CSW024
374900200529     C                   PARM                    NewCuMsg
375000200529     C                   PARM                    NewCuBrt
375100200529     C                   PARM                    NewCuPriv
375300200529     C                   PARM                    TranInACU3                                   CER059
375400200529     C                   PARM                    TranInACU4                                   CER059
375600200529     C                   PARM                    NewCuSwft                                    CSW207
375700200529     C/COPY WNCPYSRC,SDCUSDSC14
375800200529      *
375900200529      * Update 'Current' Customer with Customer in Screen Format
376000200529      *
376100200529     C                   MOVEL     NewCuPrim     CurCuPrim
376200200529     C                   MOVEL     NewCuBrt      CurCuBrt
376300200529     C                   MOVEL     NewCuSeco     CurCuSeco
376400200529     C                   MOVEL     NewCuMsg      CurCuMsg
376500200529     C                   MOVEL     NewCuPriv     CurCuPriv
376600200529     C                   MOVEL     NewCuMT3x     CurCuMT3x                                    CSW024
376700200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
376800200529     C                   MOVEL     NewCuSwft     CurCuSwft                                    CSW027
376900200529     C                   ENDIF                                                                CSW207
377000200529     C/COPY WNCPYSRC,SDCUSDSC15
377100200529      *
377200200529     C                   ENDSR
377300200529      *
377400200529      *****************************************************************
377500200529      /EJECT
377600200529      *****************************************************************
377700200529      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
377800200529      *****************************************************************
377900200529     C     SFKEYS        BEGSR
378000200529      *
378100200529      * Enable/disable function keys
378200200529      *
378300200529      * KG = COMMAND KEY 07 = READ PREVIOUS CUSTOMER
378400200529      * KH = COMMAND KEY 08 = READ NEXT CUSTOMER
378500200529      *
378600200529     C     @SCRN         IFEQ      'P'
378700200529     C     DDACTN        ANDNE     'I'                                                        248913
378800200529     C     DDACTN        ANDNE     'A'                                                        248913
378900200529     C     @SCRN         OREQ      'K'                                                        248913
379000200529     C     DDACTN        ANDNE     'I'                                                        248913
379100200529     C     DDACTN        ANDNE     'A'                                                        248913
379200200529     C                   MOVEL     'Y'           @EINKG
379300200529     C                   MOVEL     'Y'           @EINKH
379400200529     C                   ELSE
379500200529     C                   MOVEL     'N'           @EINKG
379600200529     C                   MOVEL     'N'           @EINKH
379700200529     C                   ENDIF
379800200529      *
379900200529      * KJ = COMMAND KEY 10 = CONFIRM DELETE
380000200529      *
380100200529     C     DDACTN        IFEQ      'D'
380200200529     C                   MOVEL     'Y'           @EINKJ
380300200529     C                   ELSE
380400200529     C                   MOVEL     'N'           @EINKJ
380500200529     C                   END
380600200529                                                                                              CSD007
380700200529      ** KW = Command Key 22 = CONFIRM CLOSURE/RELEASE                                        CSD007
380800200529                                                                                              CSD007
380900200529     C     DDACTN        IFEQ      'C'                                                        CSD007
381000200529     C     DDACTN        OREQ      'R'                                                        CSD007
381100200529     C                   MOVEL     'Y'           @EINKW                                       CSD007
381200200529     C                   ELSE                                                                 CSD007
381300200529     C                   MOVEL     'N'           @EINKW                                       CSD007
381400200529     C                   ENDIF                                                                CSD007
381500200529      *
381600200529      * KX = COMMAND KEY 23 = FURTHER DETAILS
381700200529      *
381800200529     C     DDACTN        IFNE      'I'
381900200529     C                   MOVEL     'Y'           @EINKX
382000200529     C                   ELSE
382100200529     C                   MOVEL     'N'           @EINKX
382200200529     C                   END
382300200529      *
382400200529     C                   ENDSR
382500200529      *****************************************************************
382600200529      /EJECT
382700200529      *****************************************************************
382800200529      * IFDS@K - INITIALIZE FIELD STATUS ON KEY SCREEN
382900200529      *****************************************************************
383000200529     C     IFDS@K        BEGSR
383100200529      *
383200200529      * ENABLE KEY FIELDS ON KEY SCREEN
383300200529      *
383400200529     C                   MOVEL     'Y'           @EDTFD
383500200529     C                   MOVEL     'Y'           @EKYFD
383600200529      *
383700200529     C                   ENDSR
383800200529      *****************************************************************
383900200529      /EJECT
384000200529      *****************************************************************
384100200529      * PARNAMES - Flag if there are changed participant names
384200200529      *****************************************************************
384300200529     C     PARNAMES      BEGSR
384400200529      *
384500200529      * If any 'P', the user to be prompted to confirm if new party or not
384600200529     C     'P'           LOOKUP    ChgNamArr                              99
384700200529     C                   MOVE      *IN99         CHGNAME           1
384800200529      *
384900200529     C                   ENDSR
385000200529      *****************************************************************
385100200529      /EJECT
385200200529      *****************************************************************
385300200529      * SNDM@P - SEND A MESSAGE TO SCREEN
385400200529      *****************************************************************
385500200529     C     SNDM@P        BEGSR
385600200529      *
385700200529      ** Add error message to array passed to detail screen
385800200529      *
385900200529     C                   Z-ADD     1             E                 3 0
386000200529     C     *BLANK        LOOKUP    FldNameArr(E)                          99
386100200529     C                   MOVEL     '*ANY'        FldNameArr(E)
386200200529     C                   MOVEL     @ERRMS        MsgIdArr(E)
386300200529     C                   MOVEL     @data         MsgDtaArr(E)                                 249076
386400200529      *
386500200529     C     EndSNDM@P     ENDSR
386600200529      *****************************************************************
386700200529      /EJECT
386800200529      *****************************************************************
386900200529      * CANC@K - CANCEL ON KEY SCREEN
387000200529      *****************************************************************
387100200529     C     CANC@K        BEGSR
387200200529      *
387300200529      * Reset Read Next Browse Subfile Record (if active)
387400200529      *
387500200529     C                   MOVEL     *BLANK        @RDNB
387600200529     C                   MOVEL     'B'           @SCRN
387700200529      *
387800200529      * If input fields are enabled
387900200529      * Blank the screens
388000200529      *
388100200529     C     @EKYFD        IFEQ      'Y'
388200200529     C     @EDTFD        OREQ      'Y'
388300200529     C                   MOVEL     *BLANK        NewCuPrim
388400200529     C                   MOVEL     *BLANK        NewCuSeco
388500200529     C                   MOVEL     *BLANK        NewCuMsg
388600200529     C                   MOVEL     *BLANK        NewCuMT3x                                    CSW024
388700200529     C/COPY WNCPYSRC,SDH00746
388800200529     C                   END
388900200529      *
389000200529      * Initialize field status on Key Screen
389100200529      *
389200200529     C                   EXSR      IFDS@K
389300200529      *
389400200529     C                   ENDSR
389500200529      *****************************************************************
389600200529      /EJECT
389700200529      *****************************************************************
389800200529      * CANC@P - CANCEL ON PRIMARY SCREEN
389900200529      *****************************************************************
390000200529     C     CANC@P        BEGSR
390100200529      *
390200200529      * Return to previous screen
390300200529      *
390400200529     C                   IF        PAccMde <> 'A'                                             CSD031
390500200529     C     INSERTENQ     IFEQ      'Y'
390600200529     C                   MOVE      'I'           DDACTN
390700200529     C                   MOVEL     'K'           @SCRN
390800200529     C                   ELSE
390900200529     C                   MOVEL     'B'           @SCRN
391000200529     C                   ENDIF
391100200529     C                   ELSE                                                                 CSD031
391200200529     C**********         MOVEL     'B'           @SCRN                               CSD031 BUG11889
391300200529     C                   MOVEL     'R'           @SCRN                                      BUG11889
391400200529      *                                                                                     BUG11889
391500200529      ** Move 'R' to @SCRN to go to RDNBRW, from SDCUSDBRW                                  BUG11889
391600200529      **  it will execute RDSFLR to read the selected customer                              BUG11889
391700200529      *                                                                                     BUG11889
391800200529     C                   ENDIF                                                                CSD031
391900200529      *
392000200529     C                   ENDSR
392100200529      *****************************************************************
392200200529      /EJECT
392300200529      *****************************************************************
392400200529      * CANC@S - CANCEL ON SECONDARY SCREEN
392500200529      *****************************************************************
392600200529     C     CANC@S        BEGSR
392700200529      *
392800200529      * Return to BRT tax screen
392900200529     C     S01383        IFEQ      'Y'
393000200529     C     DDTAIN        ANDEQ     'I'
393100200529     C     S01383        OREQ      'Y'
393200200529     C     DDTAIN        ANDEQ     'J'
393300200529     C     S01383        OREQ      'Y'                                                        CRE007
393400200529     C     DDTAIN        ANDEQ     'R'                                                        CRE007
393500200529     C                   MOVE      'X'           @SCRN
393600200529     C                   ELSE
393700200529      * Or return to Primary Details screen
393800200529     C                   MOVE      'P'           @SCRN
393900200529     C                   ENDIF
394000200529      *
394100200529     C     EndCANC@S     ENDSR
394200200529                                                                                              CSW024
394300200529      *****************************************************************                       CSW024
394400200529      /EJECT                                                                                  CSW024
394500200529      *****************************************************************                       CSW024
394600200529      *                                                               *                       CSW024
394700200529      * CANC@F - Cancel on MT3xx BEI and Fund Details screen          *                       CSW024
394800200529      *                                                               *                       CSW024
394900200529      *****************************************************************                       CSW024
395000200529                                                                                              CSW024
395100200529     C     CANC@F        BEGSR                                                                CSW024
395200200529      *                                                                                       CSW024
395300200529      ** Go to secondary details screen                                                       CSW024
395400200529     C                   MOVEL     'S'           @SCRN                                        CSW024
395500200529      *                                                                                       CSW024
395600200529     C     EndCANC@F     ENDSR                                                                CSW024
395700200529                                                                                              CSW024
395800200529      *****************************************************************
395900200529      /EJECT
396000200529      *****************************************************************
396100200529      * CANC@M - CANCEL ON MESSAGE DETAILS SCREEN
396200200529      *****************************************************************
396300200529     C     CANC@M        BEGSR
396400200529      *
396500200529      * Return to Secondary Screen
396600200529      *
396700200529      ** If MT3xx BEI enhancement has been installed, and                                     CSW024
396800200529      ** SWIFT/Direct Link module is on then display                                          CSW024
396900200529      ** screen for MT3xx BEI details                                                         CSW024
397000200529     C                   IF        CSW024 = 'Y' AND                                           CSW024
397100200529     C                             BGMSDL = 'Y'                                               CSW024
397200200529     C                   MOVEL     'F'           @SCRN                                        CSW024
397300200529     C                   ELSE                                                                 CSW024
397400200529     C                   MOVEL     'S'           @SCRN
397500200529     C                   ENDIF                                                                CSW024
397600200529     C/COPY WNCPYSRC,SDH00604
397700200529      *
397800200529     C                   ENDSR
397900200529      *****************************************************************
398000200529      /EJECT
398100200529      *****************************************************************
398200200529      * CANC@B - CANCEL ON BASE RATE TAX SCREENS
398300200529      *****************************************************************
398400200529     C     CANC@B        BEGSR
398500200529      *
398600200529      * If on BRT screen 2, F12 returns to BRT screen 1
398700200529      * otherwise F12 returns to customer Primary Details screen
398800200529      *
398900200529     C     BRTSCREEN     IFEQ      '2'
399000200529     C                   MOVEL     '1'           BRTSCREEN
399100200529     C                   ELSE
399200200529     C                   MOVEL     'P'           @SCRN
399300200529      * Reset errors
399400200529      *
399500200529     C                   MOVE      *ALL'Y'       OKCuBrt
399600200529     C                   MOVEL     *BLANK        FldNameArr
399700200529     C                   MOVEL     *BLANK        MsgIdArr
399800200529     C                   MOVEL     *BLANK        MsgDtaArr
399900200529      *
400000200529     C                   ENDIF
400100200529      *
400200200529     C                   ENDSR
400300200529      *****************************************************************
400400200529      /EJECT
400500200529      *****************************************************************
400600200529      * CANC@R - CANCEL ON Private Banking SCREEN
400700200529      *****************************************************************
400800200529     C     CANC@R        BEGSR
400900200529      *
401000200529      * Return to Messages Screen
401100200529      *
401200200529     C                   MOVEL     'M'           @SCRN
401300200529     C                   MOVE      *ALL'Y'       OKCuPriv
401400200529     C                   MOVEL     *BLANK        FldNameArr
401500200529     C                   MOVEL     *BLANK        MsgIdArr
401600200529     C                   MOVEL     *BLANK        MsgDtaArr
401700200529      *
401800200529     C                   ENDSR
401900200529      *****************************************************************
402000200529      /EJECT
402100200529      *****************************************************************
402200200529      * FURDET - Further Details
402300200529      *****************************************************************
402400200529     C     FURDET        BEGSR
402500200529      **********                                                                  BUG26917 BUG26917A
402600200529     C*****CER048        IFEQ      'Y'                                            BUG26917 BUG26917A
402700200529     C*****DDACTN        IFEQ      'I'                                            BUG26917 BUG26917A
402800200529     C*****DDACTN        OREQ      'A'                                            BUG26917 BUG26917A
402900200529     C*****DDTAIN        IFEQ      'Y'                                            BUG26917 BUG26917A
403000200529     C**********         EVAL      FDTAIN = DDTAIN                                BUG26917 BUG26917A
403100200529     C**********         ELSE                                                     BUG26917 BUG26917A
403200200529     C**********         EVAL      FDTAIN = *BLANKS                               BUG26917 BUG26917A
403300200529     C**********         ENDIF                                                    BUG26917 BUG26917A
403400200529     C**********         ENDIF                                                    BUG26917 BUG26917A
403500200529     C**********         ENDIF                                                    BUG26917 BUG26917A
403600200529                                                                                              CSC011
403700200529      ** Further Details (F23) not available in Support System                                CSC011
403800200529                                                                                              CSC011
403900200529     C                   IF        CSC011 = 'Y'                                               CSC011
404000200529     C                             AND LIBR = S1SUPP                                          CSC011
404100200529     C                             AND DDACTN <> 'E'                                          CSC011
404200200529     C                   IF        DDACTN <> 'I'                                              CSC011
404300200529     C                   EVAL      Idx = 1                                                    CSC011
404400200529     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 CSC011
404500200529     C                   EVAL      MsgIdArr(Idx) = 'USR9370'                                  CSC011
404600200529     C                   ENDIF                                                                CSC011
404700200529     C                   ELSE                                                                 CSC011
404800200529      **
404900200529      ** Call Further Details
405000200529      **
405100200529     C                   MOVE      DDCUSN        FDCUST
405200200529     C                   MOVE      DDCSSN        FDCSSN
405300200529     C                   MOVE      DDCRTN        FDCRTN
405400200529     C                   MOVE      DDCRNM        FDCRNM
405500200529     C                   MOVE      DDLINC        FDLINC
405600200529     C                   MOVE      C_BBTICS      FDTICS
405800200529     C**********         MOVE      DDCRPC        FDCRPC                              BUG4454 BUG5139
405900200529     C**********         MOVE      DDBRCD        FDBRCD                              BUG4454 BUG5139
406000200529     C**********         MOVE      DDLICD        FDLICD                              BUG4454 BUG5139
406100200529      *
406200200529     C                   CALL      'SD0014V'                              90
406300200529     C                   PARM                    RTNCDE            7
406400200529     C                   PARM                    FURDETS
406500200529     C                   PARM                    @OPSEL
406600200529     C                   PARM                    DDPAIN
406700200529      *                                                                                       237595
406800200529      ** Reset error indicators                                                               237595
406900200529      *                                                                                       237595
407000200529     C                   MOVE      *ALL'Y'       OKCuPrim                                     237595
407100200529     C                   MOVEL     *BLANK        FldNameArr                                   237595
407200200529     C                   MOVEL     *BLANK        MsgIdArr                                     237595
407300200529     C                   MOVEL     *BLANK        MsgDtaArr                                    237595
407400200529     C                   MOVEL     *BLANK        WFldNamArr                                   237595
407500200529     C                   MOVEL     *BLANK        WMsgIdArr                                    237595
407600200529     C                   MOVEL     *BLANK        WMsgDtaArr                                   237595
407700200529     C                   Z-ADD     0             Idx                                          237595
407800200529      *                                                                                       237595
407900200529                                                                                              CSC011
408000200529     C                   ENDIF                                                                CSC011
408100200529      *
408200200529     C     EndFURDET     ENDSR
408300200529      *****************************************************************
408400200529      /EJECT
408500200529      *****************************************************************
408600200529      * UPDATS - UPDATES
408700200529      *****************************************************************
408800200529     C     UPDATS        BEGSR
408900200529     C/COPY WNCPYSRC,SDCUSDSC21
409000200529      *****                                                                     185595
409100200529      **If*action code 'I', maintain Further Details                            185595
409200200529      *****                                                                     185595
409300200529     C*****DDACTN        IFEQ      'I'                                          185595
409400200529     C*****              EXSR      FURDET                                       185595
409500200529     C*****              END                                                    185595
409600200529      ***********************************************                                BUG3362 BUG8425
409700200529      ***If*action*code*'I',*maintain*Further*Details                                BUG3362 BUG8425
409800200529      ***********************************************                                BUG3362 BUG8425
409900200529     C*****Idx**         IFEQ      *ZEROS                                            BUG3362 BUG8425
410000200529     C*****DDACTN        IFEQ      'I'                                               BUG3362 BUG8425
410100200529     C**********         EXSR      FURDET                                            BUG3362 BUG8425
410200200529     C**********         ENDIF                                                       BUG3362 BUG8425
410300200529     C**********         ENDIF                                                       BUG3362 BUG8425
410400200529      *
410500200529      * Update valid customer: customer reference
410600200529      *
410700200529     C                   MOVEL     DDCUSN        CUCUST
410800200529     C                   MOVEL     DDACTN        CUTYLC
410900200529      *
411000200529      ** Carry forward non-validated master file values to valid file
411100200529      *
411200200529     C     DDACTN        IFEQ      'A'
411300200529     C                   MOVE      C_BBTXA2      CUTXA2
411400200529     C                   MOVE      C_BBTXA3      CUTXA3
411500200529     C                   MOVE      C_BBTXA4      CUTXA4
411600200529     C                   MOVE      C_BBTXA5      CUTXA5
411700200529     C                   MOVE      C_BBLETI      CULETI
411800200529     C                   MOVE      C_BBCMTI      CUCMTI
411900200529     C                   MOVE      C_BBOGID      CUOGID
412000200529     C                   Z-ADD     C_BBORED      CUORED
412100200529     C**********         MOVE      C_BBNET       CUNET                                        202805
412200200529     C**********         MOVE      C_BBNTGP      CUNTGP                                       202805
412300200529     C**********         MOVE      C_BBNTCP      CUNTCP                                       202805
412400200529     C**********         Z-ADD     C_BBNTND      CUNTND                                       202805
412500200529     C**********         MOVE      C_BBNTMM      CUNTMM                                       202805
412600200529     C**********         MOVE      C_BBTMST      CUTMST                                       202805
412700200529                                                                                              CSD031
412800200529     C                   IF        PAccMde <> 'A'                                             CSD031
412900200529     C     DDCUSN        CHAIN     SDCUSTL5                           90                      202805
413000200529     C                   ELSE                                                                 CSD031
413100200529     C     DDCUSN        CHAIN     SDACSTL1                           90                      CSD031
413200200529     C                   ENDIF                                                                CSD031
413300200529                                                                                              CSD031
413400200529     C     *IN90         IFEQ      '0'                                                        202805
413500200529     C                   MOVE      W@NET         CUNET                                        202805
413600200529     C                   MOVE      W@NTGP        CUNTGP                                       202805
413700200529     C                   MOVE      W@NTCP        CUNTCP                                       202805
413800200529     C                   Z-ADD     W@NTND        CUNTND                                       202805
413900200529     C                   MOVE      W@NTMM        CUNTMM                                       202805
414000200529     C                   MOVE      W@TMST        CUTMST                                       202805
414100200529     C                   ENDIF                                                                202805
414200200529                                                                                             BUG2664
414300200529      ** If FDTICS is blanks, this means F23 was not pressed, therefore,                     BUG2664
414400200529      ** field must retain its current value else, get the updated value                     BUG2664
414500200529                                                                                             BUG2664
414600200529     C     FDTICS        IFEQ      *BLANKS                                                   BUG2664
414700200529     C                   MOVE      C_BBTICS      CUTICS                                      BUG2664
414800200529     C                   ELSE                                                                BUG2664
414900200529     C                   MOVE      FDTICS        CUTICS                                       196149
415000200529     C                   ENDIF                                                               BUG2664
415100200529                                                                                             BUG2664
415200200529     C                   ELSE
415300200529      *
415400200529      ** Initialise non-validated valid file fields for Insert
415500200529      *
415600200529     C     DDACTN        IFEQ      'I'
415700200529     C                   MOVE      *BLANKS       CUTXA2
415800200529     C                   MOVE      *BLANKS       CUTXA3
415900200529     C                   MOVE      *BLANKS       CUTXA4
416000200529     C                   MOVE      *BLANKS       CUTXA5
416100200529     C                   MOVE      *BLANKS       CULETI
416200200529     C                   MOVE      *BLANKS       CUCMTI
416300200529     C                   MOVE      *BLANKS       CUOGID
416400200529     C                   Z-ADD     BJRDNB        CUORED
416500200529     C                   MOVE      'N'           CUNET
416600200529     C                   MOVE      *BLANKS       CUNTGP
416700200529     C                   MOVE      'N'           CUNTCP
416800200529     C                   MOVE      'N'           CUNTMM
416900200529     C     CUTICS        IFEQ      *BLANK
417000200529     C                   MOVE      'N'           CUTICS
417100200529     C                   ENDIF
417200200529     C                   ENDIF
417300200529     C                   ENDIF
417400200529      *                                                                                      BUG3362
417500200529      ** If Further details was accessed, load changed value(FDCTID from                     BUG3362
417600200529      ** SD0014V) to NwTIFilfmt if no error                                                  BUG3362
417700200529      *                                                                                      BUG3362
417800200529     C     FDTICS        IFEQ      'Y'                                                       BUG3362
417900200529      *                                                                                      BUG3362
418000200529     C                   MOVEL     FDCTID        NwTIfilFmt                                  BUG3362
418100200529     C                   EVAL      V_TCLCD = BJRDNB                                          BUG3362
418200200529      *                                                                                      BUG3362
418300200529     C     DDACTN        IFEQ      'I'                                                       BUG3362
418400200529     C                   EVAL      V_TCCSSN=CUCSSN                                           BUG3362
418500200529     C                   ENDIF                                                               BUG3362
418600200529     C                   EVAL      CUTICS = FDTICS                                           BUG3362
418700200529     C                   ELSE                                                                BUG3362
418800200529     C     FDTICS        IFEQ      'N'                                                       BUG3362
418900200529     C     DDACTN        ANDEQ     'I'                                                       BUG3362
419000200529     C     FDTICS        OREQ      ' '                                                       BUG3362
419100200529     C     DDACTN        ANDEQ     'I'                                                       BUG3362
419200200529      ** case FDTICS = 'N'                                                                   BUG3362
419300200529     C                   MOVE      *BLANKS       NwTifilFmt                                  BUG3362
419400200529     C                   EVAL      V_TCLCD = 0                                               BUG3362
419500200529     C                   ENDIF                                                               BUG3362
419600200529     C                   ENDIF                                                               BUG3362
419700200529      *                                                                                      BUG3362
419800200529     C                   MOVEL     *BLANK        @RTCD
419900200529      *
420000200529      * CUSTOMER UPDATES
420100200529      *
420200200529     C                   CALLB     'SDCUSDUPD'
420300200529     C                   PARM                    @RTCD
420400200529     C                   PARM                    NwCuFilFmt
420500200529     C                   PARM                    NwBrFilFmt
420600200529     C                   PARM                    NwPBFilFmt
420700200529     C                   PARM                    NwTIFilFmt                                  BUG3362
420800200529     C                   PARM                    NwSwFilFmt                                   CSW207
420900200529     C**********         PARM                    CuSW13                              CFT050 MD022395
421000200529     C                   PARM                    NewCuSW13                                  MD022395
421100200529      * Base Rate Auth req                                                                    CSD012
421200200529     C                   PARM                    AUTHRQ            1                          CSD012
421300200529      * Authorisation Mode                                                                    CSD012
421400200529     C                   PARM                    AUTHMD            1                          CSD012
421500200529     C                   PARM                    V_DDGCUS                                     CGP001
421600200529     C                   PARM                    S01383
421700200529                                                                                              CLE025
421800200529      ** Switchable features                                                                  CLE025
421900200529                                                                                              CLE025
422000200529     C                   PARM                    CSW024                                       CSW024
422100200529     C                   PARM                    CGP001                                       CGP001
422200200529     C                   PARM                    CLE025                                       CLE025
422300200529     C                   PARM                    CFX001                                       CFX001
422400200529     C                   PARM                    TransType                                    CSD028
422500200529     C                   PARM                    DACTN             1                          CSD028
422600200529     C                   PARM                    CTI006            1                        MD030956
422700200529      ** Acceptance Mode                                                                      CSD031
422800200529     C                   PARM                    PAccMde                                      CSD031
422900200529      ** Update (Y/N)                                                                         CSD031
423000200529     C                   PARM                    PUpdYN                                       CSD031
423100200529     C/COPY WNCPYSRC,SDCUSDSC16
423200200529      *
423300200529      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
423400200529      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
423500200529      *
423600200529     C     @RTCD         IFNE      *BLANK
423700200529     C                   ROLBK
423800200529     C     @RTCD         IFEQ      '*LOCKED'                                                  252069
423900200529     C                   ADD       1             Idx                                          252069
424000200529     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 252069
424100200529     C                   EVAL      MsgIdArr(Idx) = 'USR0001'                                  252069
424200200529     C                   ELSE                                                                 252069
424300200529     C                   EXSR      *PSSR
424400200529     C                   ENDIF                                                                252069
424500200529     C                   ELSE
424600200529      *                                                                                       CER001
424700200529     C**********         IF        ULX043 = 'Y'                                      CER001 BUG10817
424800200529     C                   IF        ULX609 = 'Y'                                             BUG10817
424900200529      *                                                                                       CER001
425000200529      ** Update extension fields group 1                                                      CER001
425100200529      *                                                                                       CER001
425200200529     C                   EVAL      #6LXVFCOLC = #1COLC                                        CER001
425300200529     C                   EVAL      #6LXVFCRNM = #1CRNM                                        CER001
425400200529      *                                                                                       CER001
425500200529     C                   CALLB     'SDCUSD2UP'                                                CER001
425600200529     C                   PARM                    PWAction                                     CER001
425700200529     C                   PARM      *BLANK        @RTCD                                        CER001
425800200529     C                   PARM                    WFIND1                                       CER001
425900200529     C                   PARM                    NwDlFilFmt1                                  CER001
426000200529     C                   PARM                    CrDlFilFmt1                                  CER001
426100200529      *                                                                                       CER001
426200200529      ** If there were any errors in the update functions, rollback any                       CER001
426300200529      ** updates and end this pgm, otherwise delete the invalid extended                      CER001
426400200529      ** deal and commit the updates                                                          CER001
426500200529      *                                                                                       CER001
426600200529     C                   IF        @RTCD <> *BLANK    AND                                     CER001
426700200529     C                             @RTCD <> '*RECUPD' AND                                     CER001
426800200529     C                             @RTCD <> '*RECLCK'                                         CER001
426900200529     C                   ROLBK                                                                CER001
427000200529     C                   EXSR      *PSSR                                                      CER001
427100200529     C                   ENDIF                                                              BUG10817
427200200529     C                   ENDIF                                                              BUG10817
427300200529     C**********         ELSE                                                                 CER001
427400200529     C                   IF        @RTCD = *BLANK                                           BUG10817
427500200529      *                                                                                       CER001
427600200529      ** Update extension fields group 2                                                      CER001
427700200529      *                                                                                       CER001
427800200529     C                   IF        ULX043 = 'Y'                                             BUG10817
427900200529     C                   CALLB     'SDCUSD3UP'                                                CER001
428000200529     C                   PARM                    PWAction                                     CER001
428100200529     C                   PARM      *BLANK        @RTCD                                        CER001
428200200529     C                   PARM                    WFIND2                                       CER001
428300200529     C                   PARM                    NwDlFilFmt2                                  CER001
428400200529     C                   PARM                    CrDlFilFmt2                                  CER001
428500200529      *                                                                                       CER001
428600200529      ** If there were any errors in the update functions, rollback any                       CER001
428700200529      ** updates and end this pgm, otherwise delete the invalid extended                      CER001
428800200529      ** customer and commit the updates                                                      CER001
428900200529      *                                                                                       CER001
429000200529     C                   IF        @RTCD <> *BLANK    AND                                     CER001
429100200529     C                             @RTCD <> '*RECUPD' AND                                     CER001
429200200529     C                             @RTCD <> '*RECLCK'                                         CER001
429300200529     C                   ROLBK                                                                CER001
429400200529     C                   EXSR      *PSSR                                                      CER001
429500200529     C                   ENDIF                                                                CER001
429600200529     C                   ENDIF                                                                CER001
429700200529     C                   ENDIF                                                                CER001
429800200529     C/COPY WNCPYSRC,SDCUSDSC01
429900200529     C                   COMMIT
430000200529      *********************************************************************           185595 BUG3362
430100200529      **If*action*code*'I',*maintain*Further*Details***********************           185595 BUG3362
430200200529      *********************************************************************           185595 BUG3362
430300200529     C*****DDACTN********IFEQ******'I'*************************************           185595 BUG3362
430400200529     C*******************EXSR******FURDET**********************************           185595 BUG3362
430500200529     C*******************END***********************************************           185595 BUG3362
430600200529      *********************************************************************           185595 BUG3362
430700200529                                                                                             BUG5139
430800200529      ** If action code 'I', maintain Further Details                                        BUG5139
430900200529                                                                                             BUG5139
431000200529     C     Idx           IFEQ      *ZEROS                                                    BUG5139
431100200529     C     DDACTN        IFEQ      'I'                                                       BUG5139
431200200529     C                   EXSR      FURDET                                                    BUG5139
431300200529     C                   ENDIF                                                               BUG5139
431400200529     C                   ENDIF                                                               BUG5139
431500200529     C                   END
431600200529      *
431700200529      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
431800200529      *
431900200529     C     @RDNB         IFEQ      'Y'
432000200529     C                   MOVEL     'R'           @SCRN
432100200529     C                   ELSE
432200200529      *
432300200529      * ELSE, RETURN TO INSERT KEY SCREEN OR BROWSE SBFILE
432400200529      *
432500200529     C     DDACTN        IFEQ      'I'
432600200529     C                   MOVEL     'K'           @SCRN
432700200529                                                                                              CSD021
432800200529     C     CSD021        IFEQ      'Y'                                                        CSD021
432900200529     C                   MOVEL     CUCUST        WWCNUM                                       CSD021
433000200529     C                   ENDIF                                                                CSD021
433100200529                                                                                              CSD021
433200200529     C                   ELSE
433300200529     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
433400200529     C                   EVAL      @SCRN = 'T'                                                CSD028
433500200529     C                   ELSE                                                                 CSD028
433600200529     C                   MOVEL     'B'           @SCRN
433700200529     C                   ENDIF                                                                CSD028
433800200529     C                   ENDIF
433900200529     C                   ENDIF
434000200529     C/COPY WNCPYSRC,SDCUSDSC22
434100200529      *
434200200529     C                   ENDSR
434300200529      *****************************************************************
434400200529      /EJECT
434500200529      *****************************************************************
434600200529      * ENDP - End Program
434700200529      *****************************************************************
434800200529     C     ENDP          BEGSR
434900200529      *                                                                                       189774
435000200529      ** Rollback to clear any possible updates in window function                            189774
435100200529      *                                                                                       189774
435200200529     C     BGWDPR        IFEQ      'Y'                                                        189774
435300200529     C                   ROLBK                                                                189774
435400200529     C                   ENDIF                                                                189774
435500200529      *
435600200529     C                   MOVEL     'T'           @SCRN
435700200529      *
435800200529     C                   ENDSR
435900200529      *****************************************************************
436000200529      /EJECT
436100200529      *****************************************************************
436200200529      * INITIAL Go To Initial Screen
436300200529      *****************************************************************
436400200529     C     INITIAL       BEGSR
436500200529      *
436600200529      * Reset Read Next Browse Subfile Record (if active)
436700200529      *
436800200529     C                   MOVEL     *BLANK        @RDNB
436900200529      *
437000200529      * Blank the screens
437100200529      *
437200200529     C                   MOVEL     *BLANK        NewCuPrim
437300200529     C                   MOVEL     *BLANK        NewCuSeco
437400200529     C                   MOVEL     *BLANK        NewCuMsg
437500200529     C                   MOVEL     *BLANK        NewCuPriv
437600200529     C                   MOVEL     *BLANK        NewCuMT3x                                    CSW024
437700200529     C/COPY WNCPYSRC,SDH00747
437800200529      *
437900200529      * Browse Screen
438000200529      *
438100200529     C                   MOVEL     'B'           @SCRN             1
438200200529      *
438300200529      * Initialize field status on Key Screen
438400200529      *
438500200529     C                   EXSR      IFDS@K
438600200529      *
438700200529     C                   ENDSR
438800200529      *****************************************************************                       CFT050
438900200529      /EJECT                                                                                  CFT050
439000200529      *****************************************************************                       CFT050
439100200529      * SRSCRNPL- Display Bank Plus enquiry screen                                            CFT050
439200200529      *****************************************************************                       CFT050
439300200529     C     SRSCRNPL      BEGSR                                                                CFT050
439400200529      *                                                                                       CFT050
439500200529     C                   IF        DDBDRK =  *BLANKS                                          CFT050
439600200529      *                                                                                       CFT050
439700200529     C                   CALL      'FT0900'                                                   CFT050
439800200529     C                   PARM      'S'           WIMODE                                       CFT050
439900200529     C                   PARM      *BLANKS       WICRIT                                       CFT050
440000200529     C                   PARM      *BLANKS       WOADD                                        CFT050
440100200529     C                   PARM      *BLANKS       WOCHIP                                       CFT050
440200200529     C                   PARM      *BLANKS       WOUTCD                                       CFT050
440300200529     C                   PARM      *BLANKS       WRTCD                                        CFT050
440400200529      *                                                                                       CFT050
440500200529     C                   EVAL      WPARKEY = *BLANKS                                          CFT050
440600200529     C                   IF        WOADD  <> *BLANKS                                          CFT050
440700200529     C                   EVAL      CUBDRK   = WOADD                                           CFT050
440800200529     C                   EVAL      DDBDRK   = WOADD                                           CFT050
440900200529     C     CUBDRK        SETLL     MEBIB3L0                                                   CFT050
441000200529     C                   IF        %EQUAL                                                     CFT050
441100200529     C     CUBDRK        CHAIN     MEBIB3L0                                                   CFT050
441200200529     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
441300200529     C                   EVAL      WPARKEY = B3POKY                                           CFT050
441400200529     C                   ENDIF                                                                CFT050
441500200529     C                   ENDIF                                                                CFT050
441600200529     C                   ENDIF                                                                CFT050
441700200529      *                                                                                       CFT050
441800200529      ** Default if insert mode                                                               CFT050
441900200529      *                                                                                       CFT050
442000200529     C                   IF        DDACTN = 'I'                                               CFT050
442100200529     C                             AND WPARKEY <> *BLANKS                                     CFT050
442200200529     C                   EXSR      GETPARKEY                                                  CFT050
442300200529     C                   EXSR      DEF2NDSCR                                                  CFT050
442400200529     C                   EXSR      DEF3RDSCR                                                  CFT050
442500200529     C                   EXSR      DEF8THSCR                                                  CFT050
442600200529     C                   ENDIF                                                                CFT050
442700200529                                                                                              CFT050
442800200529     C                   ELSE                                                                 CFT050
442900200529                                                                                              CFT050
443000200529     C                   EVAL      DDBDRK = *BLANKS                                           CFT050
443100200529     C                   EVAL      CUBDRK = *BLANKS                                           CFT050
443200200529                                                                                              CFT050
443300200529     C                   ENDIF                                                                CFT050
443400200529     C                   EVAL      @SCRN = 'P'                                                CFT050
443500200529      *                                                                                       CFT050
443600200529     C                   ENDSR                                                                CFT050
443700200529                                                                                              CFT050
443800200529      *****************************************************************                       CFT050
443900200529      /EJECT                                                                                  CFT050
444000200529      *****************************************************************                       CFT050
444100200529      * GETPARKEY - Get parent key from customer file                                         CFT050
444200200529      *****************************************************************                       CFT050
444300200529     C     GETPARKEY     BEGSR                                                                CFT050
444400200529      *                                                                                       CFT050
444500200529     C     WPARKEY       SETLL     SDCSSWL2                                                   CFT050
444600200529     C                   IF        %EQUAL                                                     CFT050
444700200529     C     WPARKEY       CHAIN     SDCSSWL2                                                   CFT050
444800200529     C                   IF        %FOUND(SDCSSWL2)                                           CFT050
444900200529      *                                                                                       CFT050
445000200529     C                   CALL      'AOCUSTR0'                                                 CFT050
445100200529     C                   PARM      *BLANKS       @RTCD                                        CFT050
445200200529     C                   PARM      '*KEY   '     @OPTN                                        CFT050
445300200529     C                   PARM      CSCUSD        @KEY1                                        CFT050
445400200529     C                   PARM      *BLANKS       @KYST                                        CFT050
445500200529     C     SDCUST        PARM      *BLANKS       DSSDY                                        CFT050
445600200529      *                                                                                       CFT050
445700200529     C                   IF        @RTCD = *BLANKS                                            CFT050
445800200529     C                   IF        DDPCNB = *BLANKS                                           CFT050
445900200529     C                   EVAL      DDPCNB = PR_BBPCNB                                         CFT050
446000200529     C                   ENDIF                                                                CFT050
446100200529     C                   ENDIF                                                                CFT050
446200200529      *                                                                                       CFT050
446300200529     C                   ENDIF                                                                CFT050
446400200529     C                   ENDIF                                                                CFT050
446500200529      *                                                                                       CFT050
446600200529     C                   ENDSR                                                                CFT050
446700200529                                                                                              CFT050
446800200529      *****************************************************************                       CFT050
446900200529      /EJECT                                                                                  CFT050
447000200529      *****************************************************************                       CFT050
447100200529      * DEF2NDSCR - Default second screen using record key                                    CFT050
447200200529      *****************************************************************                       CFT050
447300200529     C     DEF2NDSCR     BEGSR                                                                CFT050
447400200529      *                                                                                       CFT050
447500200529     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
447600200529      **                                                                                      CFT050
447700200529     C                   EVAL      WPARKEY = B3POKY                                           CFT050
447800200529      **                                                                                      CFT050
447900200529     C                   IF        DDBNBI = *BLANKS                                           CFT050
448000200529     C                   IF        B3ISST = 'BANK'                                            CFT050
448100200529     C                             OR B3ISST = 'COOP'                                         CFT050
448200200529     C                             OR B3ISST = 'CBMA'                                         CFT050
448300200529     C                   EVAL      DDBNBI = 'Y'                                               CFT050
448400200529     C                   ENDIF                                                                CFT050
448500200529     C                   ENDIF                                                                CFT050
448600200529      **                                                                                      CFT050
448700200529     C                   IF        DDCNA1 = *BLANKS                                           CFT050
448800200529     C                   EVAL      DDCNA1 = B3INS1                                            CFT050
448900200529     C                   ENDIF                                                                CFT050
449000200529      **                                                                                      CFT050
449100200529     C                   IF        DDCRNM = *BLANKS                                           CFT050
449200200529     C                   EVAL      DDCRNM = B3INS1                                            CFT050
449300200529     C                   ENDIF                                                                CFT050
449400200529      **                                                                                      CFT050
449500200529     C                   IF        DDCNA2 = *BLANKS                                           CFT050
449600200529     C                   EVAL      DDCNA2 = B3ADD1                                            CFT050
449700200529     C                   ENDIF                                                                CFT050
449800200529      **                                                                                      CFT050
449900200529     C                   IF        DDCNA3 = *BLANKS                                           CFT050
450000200529     C                   EVAL      DDCNA3 = B3ADD2                                            CFT050
450100200529     C                   ENDIF                                                                CFT050
450200200529      **                                                                                      CFT050
450300200529     C                   IF        DDCRTN = *BLANKS                                           CFT050
450400200529     C                   EVAL      DDCRTN = B3CITY                                            CFT050
450500200529     C                   ENDIF                                                                CFT050
450600200529      **                                                                                      CFT050
450700200529     C                   SELECT                                                               CFT050
450800200529     C                   WHEN      DDCNA1 = *BLANKS                                           CFT050
450900200529     C                   EVAL      DDCNA1 = B3CPS1                                            CFT050
451000200529     C                   WHEN      DDCNA2 = *BLANKS                                           CFT050
451100200529     C                   EVAL      DDCNA2 = B3CPS1                                            CFT050
451200200529     C                   WHEN      DDCNA3 = *BLANKS                                           CFT050
451300200529     C                   EVAL      DDCNA3 = B3CPS1                                            CFT050
451400200529     C                   WHEN      DDCNA4 = *BLANKS                                           CFT050
451500200529     C                   EVAL      DDCNA4 = B3CPS1                                            CFT050
451600200529     C                   ENDSL                                                                CFT050
451700200529      **                                                                                      CFT050
451800200529     C                   SELECT                                                               CFT050
451900200529     C                   WHEN      DDCNA1 = *BLANKS                                           CFT050
452000200529     C                   EVAL      DDCNA1 = B3CNT1                                            CFT050
452100200529     C                   WHEN      DDCNA2 = *BLANKS                                           CFT050
452200200529     C                   EVAL      DDCNA2 = B3CNT1                                            CFT050
452300200529     C                   WHEN      DDCNA3 = *BLANKS                                           CFT050
452400200529     C                   EVAL      DDCNA3 = B3CNT1                                            CFT050
452500200529     C                   WHEN      DDCNA4 = *BLANKS                                           CFT050
452600200529     C                   EVAL      DDCNA4 = B3CNT1                                            CFT050
452700200529     C                   ENDSL                                                                CFT050
452800200529      **                                                                                      CFT050
452900200529     C                   IF        DDCNCZ = *BLANKS                                           CFT050
453000200529     C                   EVAL      DDCNCZ = B3ISOC                                            CFT050
453100200529     C                   ENDIF                                                                CFT050
453200200529      **                                                                                      CFT050
453300200529     C                   IF        DDCNCZ = *BLANKS                                           CFT050
453400200529     C                   EVAL      DDCOLC = B3ISOC                                            CFT050
453500200529     C                   ENDIF                                                                CFT050
453600200529      **                                                                                      CFT050
453700200529     C                   EVAL      SVCNCZ = *BLANKS                                           CFT050
453800200529     C                   EVAL      SVCOLC = *BLANKS                                           CFT050
453900200529     C     B3ISOC        SETLL     SDCTRYL3                                                   CFT050
454000200529     C                   IF        %EQUAL                                                     CFT050
454100200529     C     B3ISOC        CHAIN     SDCTRYL3                                                   CFT050
454200200529     C                   DOW       %FOUND(SDCTRYL3)                                           CFT050
454300200529     C                   EVAL      SVCNCZ = A4CNCD                                            CFT050
454400200529     C                   EVAL      SVCOLC = A4CNCD                                            CFT050
454500200529     C                   IF        B3ISOC = A4CNCD                                            CFT050
454600200529     C                   EVAL      SVCNCZ = A4CNCD                                            CFT050
454700200529     C                   EVAL      SVCOLC = A4CNCD                                            CFT050
454800200529     C                   LEAVE                                                                CFT050
454900200529     C                   ENDIF                                                                CFT050
455000200529     C     B3ISOC        READE     SDCTRYL3                                                   CFT050
455100200529      ** SDCTRYL3 dow                                                                         CFT050
455200200529     C                   ENDDO                                                                CFT050
455300200529      **                                                                                      CFT050
455400200529     C                   IF        SVCNCZ <> *BLANKS                                          CFT050
455500200529     C                             AND DDCNCZ = *BLANK                                        CFT050
455600200529     C                   EVAL      DDCNCZ = SVCNCZ                                            CFT050
455700200529     C                   ENDIF                                                                CFT050
455800200529      **                                                                                      CFT050
455900200529     C                   IF        SVCOLC <> *BLANKS                                          CFT050
456000200529     C                             AND DDCOLC = *BLANK                                        CFT050
456100200529     C                   EVAL      DDCOLC = SVCOLC                                            CFT050
456200200529     C                   ENDIF                                                                CFT050
456300200529      ** SDCTRYL3 equal                                                                       CFT050
456400200529     C                   ENDIF                                                                CFT050
456500200529      ** MEBIB3L0 chain                                                                       CFT050
456600200529     C                   ENDIF                                                                CFT050
456700200529      *                                                                                       CFT050
456800200529     C                   ENDSR                                                                CFT050
456900200529      *                                                                                       CFT050
457000200529      *****************************************************************                       CFT050
457100200529      /EJECT                                                                                  CFT050
457200200529      *****************************************************************                       CFT050
457300200529      * DEF3RDSCR - Default third screen using record key                                     CFT050
457400200529      *****************************************************************                       CFT050
457500200529     C     DEF3RDSCR     BEGSR                                                                CFT050
457600200529      *                                                                                       CFT050
457700200529     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
457800200529      **                                                                                      CFT050
457900200529      **                                                                                      CFT050
458000200529     C                   IF        DDCSID = *BLANKS                                           CFT050
458100200529     C                   EVAL      DDCSID = B3BICC                                            CFT050
458200200529     C                   ENDIF                                                                CFT050
458300200529      **                                                                                      CFT050
458400200529     C                   IF        DDCIDA = *BLANKS                                           CFT050
458500200529     C                   EVAL      DDCIDA = B3CHIP                                            CFT050
458600200529     C                   ENDIF                                                                CFT050
458700200529      **                                                                                      CFT050
458800200529     C                   IF        B3ISOC = 'US'                                              CFT050
458900200529     C                   IF        DDFWCA = *BLANKS                                           CFT050
459000200529     C                   EVAL      DDFWCA = B3NATI                                            CFT050
459100200529     C                   ENDIF                                                                CFT050
459200200529     C                   ENDIF                                                                CFT050
459300200529      **                                                                                      CFT050
459400200529     C                   IF        B3ISOC = 'DE'                                              CFT050
459500200529     C                   IF        DDBLCD = *BLANKS                                           CFT050
459600200529     C                   EVAL      DDBLCD = B3NATI                                            CFT050
459700200529     C                   ENDIF                                                                CFT050
459800200529     C                   ENDIF                                                                CFT050
459900200529      **                                                                                      CFT050
460000200529     C                   IF        B3ISOC = 'JP'                                              CFT050
460100200529     C                   IF        DDBFIC = *BLANKS                                           CFT050
460200200529     C                   EVAL      DDBFIC = B3NATI                                            CFT050
460300200529     C                   ENDIF                                                                CFT050
460400200529     C                   ENDIF                                                                CFT050
460500200529      **                                                                                      CFT050
460600200529     C                   IF        B3ISOC = 'GB'                                              CFT050
460700200529     C                   IF        DDCSCA = *BLANKS                                           CFT050
460800200529     C                   EVAL      DDCSCA = B3NATI                                            CFT050
460900200529     C                   ENDIF                                                                CFT050
461000200529     C                   ENDIF                                                                CFT050
461100200529      **                                                                                      CFT050
461200200529     C                   EVAL      SVCLSY = *BLANKS                                         MD022443
461300200529     C                   IF        CSW213 = 'Y'                                               CSW213
461400200529      *                                                                                       CSW213
461500200529     C                   IF        DDCLID = *BLANKS                                           CSW213
461600200529     C                   EVAL      DDCLID = B3NATI                                            CSW213
461700200529     C                   ENDIF                                                                CSW213
461800200529      *                                                                                       CSW213
461900200529     C                   IF        DDCLSY = *BLANKS                                           CSW213
462000200529     C**********         EVAL      DDCLSY = B3ISOC                                   CSW213 MD022443
462100200529     C                   EVAL      SVCLSY = B3ISOC                                          MD022443
462200200529     C                   ENDIF                                                                CSW213
462300200529      *                                                                                       CSW213
462400200529     C**********         EVAL      SVCLSY = *BLANKS                                  CSW213 MD022443
462500200529     C                   SELECT                                                               CSW213
462600200529      *                                                                                       CSW213
462700200529     C                   WHEN      B3ISOC = 'AT'                                              CSW213
462800200529     C                   EVAL      SVCLSY = 'AT'                                              CSW213
462900200529      *                                                                                       CSW213
463000200529     C                   WHEN      B3ISOC = 'AU'                                              CSW213
463100200529     C                   EVAL      SVCLSY = 'AU'                                              CSW213
463200200529      *                                                                                       CSW213
463300200529     C                   WHEN      B3ISOC = 'CA'                                              CSW213
463400200529     C                   EVAL      SVCLSY = 'CC'                                              CSW213
463500200529      *                                                                                       CSW213
463600200529     C                   WHEN      B3ISOC = 'ES'                                              CSW213
463700200529     C                   EVAL      SVCLSY = 'ES'                                              CSW213
463800200529      *                                                                                       CSW213
463900200529     C                   WHEN      B3ISOC = 'GR'                                              CSW213
464000200529     C                   EVAL      SVCLSY = 'GR'                                              CSW213
464100200529      *                                                                                       CSW213
464200200529     C                   WHEN      B3ISOC = 'HK'                                              CSW213
464300200529     C                   EVAL      SVCLSY = 'HK'                                              CSW213
464400200529      *                                                                                       CSW213
464500200529     C                   WHEN      B3ISOC = 'IE'                                              CSW213
464600200529     C                   EVAL      SVCLSY = 'IE'                                              CSW213
464700200529      *                                                                                       CSW213
464800200529     C                   WHEN      B3ISOC = 'IN'                                              CSW213
464900200529     C                   EVAL      SVCLSY = 'IN'                                              CSW213
465000200529      *                                                                                       CSW213
465100200529     C                   WHEN      B3ISOC = 'IT'                                              CSW213
465200200529     C                   EVAL      SVCLSY = 'IT'                                              CSW213
465300200529      *                                                                                       CSW213
465400200529     C                   WHEN      B3ISOC = 'NZ'                                              CSW213
465500200529     C                   EVAL      SVCLSY = 'NZ'                                              CSW213
465600200529      *                                                                                       CSW213
465700200529     C                   WHEN      B3ISOC = 'PL'                                              CSW213
465800200529     C                   EVAL      SVCLSY = 'PL'                                              CSW213
465900200529      *                                                                                       CSW213
466000200529     C                   WHEN      B3ISOC = 'PT'                                              CSW213
466100200529     C                   EVAL      SVCLSY = 'PT'                                              CSW213
466200200529      *                                                                                       CSW213
466300200529     C                   WHEN      B3ISOC = 'RU'                                              CSW213
466400200529     C                   EVAL      SVCLSY = 'RU'                                              CSW213
466500200529      *                                                                                       CSW213
466600200529     C                   WHEN      B3ISOC = 'CH'                                              CSW213
466700200529     C                   EVAL      SVCLSY = 'SW'                                              CSW213
466800200529      *                                                                                       CSW213
466900200529     C                   WHEN      B3ISOC = 'SW'                                              CSW213
467000200529     C                   EVAL      SVCLSY = 'SW'                                              CSW213
467100200529      *                                                                                       CSW213
467200200529     C                   WHEN      B3ISOC = 'ZA'                                              CSW213
467300200529     C                   EVAL      SVCLSY = 'ZA'                                              CSW213
467400200529      *                                                                                       CSW213
467500200529     C                   OTHER                                                                CSW213
467600200529     C                   EVAL      DDCLID = *BLANKS                                           CSW213
467700200529     C                   EVAL      DDCLSY = *BLANKS                                           CSW213
467800200529      *                                                                                       CSW213
467900200529     C                   ENDSL                                                                CSW213
468000200529      *                                                                                       CSW213
468100200529     C                   IF        SVCLSY <> *BLANKS                                          CSW213
468200200529     C                             AND DDCLSY = *BLANKS                                       CSW213
468300200529     C                   EVAL      DDCLSY = SVCLSY                                            CSW213
468400200529     C                   ENDIF                                                                CSW213
468500200529      *                                                                                       CSW213
468600200529     C                   IF        DDLEIC = *BLANKS                                           CSW213
468700200529     C                   EVAL      DDLEIC = B3LEIC                                            CSW213
468800200529     C                   ENDIF                                                                CSW213
468900200529      ** CSW213                                                                               CSW213
469000200529     C                   ENDIF                                                                CSW213
469100200529      **                                                                                      CFT050
469200200529     C                   IF        B3CBIC <> *BLANKS                                          CFT050
469300200529     C                   EVAL      DDCSID =  B3CBIC                                           CFT050
469400200529     C                   ENDIF                                                                CFT050
469500200529      **                                                                                      CFT050
469600200529     C                   CALLB     'AOBEISR0'                                                 CFT050
469700200529     C                   PARM      *BLANKS       @RTCD                                        CFT050
469800200529     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
469900200529     C                   PARM      B3STYP        PBICD                                        CFT050
470000200529     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CFT050
470100200529     C                   IF        @RTCD <> *BLANKS                                           CFT050
470200200529     C                   IF        DDSWFI = *BLANKS                                           CFT050
470300200529     C                   EVAL      DDSWFI = 'Y'                                               CFT050
470400200529     C                   ENDIF                                                                CFT050
470500200529     C                   ELSE                                                                 CFT050
470600200529     C                   IF        DDSWFI = *BLANKS                                           CFT050
470700200529     C                   EVAL      DDSWFI = 'N'                                               CFT050
470800200529     C                   ENDIF                                                                CFT050
470900200529     C                   ENDIF                                                                CFT050
471000200529      **                                                                                      CFT050
471100200529     C**********         IF        CSW204 = 'Y'                                      CFT050 MD022463
471200200529     C**********                   AND B3STYP = 'CORP'                               CFT050 MD022463
471300200529     C**********         IF        DDCRPC = *BLANKS                                  CFT050 MD022463
471400200529     C**********         EVAL      DDCRPC = 'Y'                                      CFT050 MD022463
471500200529     C**********         ENDIF                                                       CFT050 MD022463
471600200529      ***CSW204*                                                                     CFT050 MD022463
471700200529     C**********         ENDIF                                                       CFT050 MD022463
471800200529     C                                                                                        CFT050
471900200529      ** MEBIB3L0 chain                                                                       CFT050
472000200529     C                   ENDIF                                                                CFT050
472100200529      *                                                                                       CFT050
472200200529     C                   ENDSR                                                                CFT050
472300200529      *****************************************************************                       CFT050
472400200529      /EJECT                                                                                  CFT050
472500200529      *****************************************************************                       CFT050
472600200529      * DEF8THSCR - Default eight screen using record key                                     CFT050
472700200529      *****************************************************************                       CFT050
472800200529     C     DEF8THSCR     BEGSR                                                                CFT050
472900200529      *                                                                                       CFT050
473000200529     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
473100200529      **                                                                                      CFT050
473200200529     C                   EVAL      WPARKEY = B3POKY                                           CFT050
473300200529      **                                                                                      CFT050
473400200529     C                   IF        CSW024 = 'Y'                                             MD022463
473500200529     C                             AND B3STYP = 'CORP'                                      MD022463
473600200529     C                   IF        DDCORP = *BLANKS                                         MD022463
473700200529     C                   EVAL      DDCORP = 'Y'                                             MD022463
473800200529     C                   ENDIF                                                              MD022463
473900200529      **                                                                                    MD022463
474000200529     C                   IF        B3BICC <>*BLANKS                                         MD022463
474100200529                                                                                            MD022463
474200200529     C                   IF        DDCBEI = *BLANKS                                           CFT050
474300200529     C                   EVAL      DDCBEI = B3UBIC                                            CFT050
474400200529     C                   ENDIF                                                                CFT050
474500200529                                                                                            MD022463
474600200529     C                   ELSE                                                               MD022463
474700200529      **                                                                                      CFT050
474800200529     C                   IF        DDRI01 = *BLANKS                                           CFT050
474900200529     C                   IF        B3BICC <> *BLANKS                                          CFT050
475000200529     C                   EVAL      DDRI01 = '/ABIC/' + B3BICC                                 CFT050
475100200529     C                   ELSE                                                                 CFT050
475200200529     C                   EVAL      DDRI01 = '/ABIC/UKNW'                                      CFT050
475300200529     C                   ENDIF                                                                CFT050
475400200529     C                   ENDIF                                                                CFT050
475500200529      **                                                                                      CFT050
475600200529     C                   IF        DDRI02 = *BLANKS                                           CFT050
475700200529     C                   EVAL      DDRI02 = '/NAME/' + B3INS1                                 CFT050
475800200529     C                   ENDIF                                                                CFT050
475900200529      **                                                                                      CFT050
476000200529     C                   IF        CSW213 = 'Y'                                               CFT050
476100200529     C                             AND B3LEIC <> *BLANKS                                      CFT050
476200200529     C                   IF        DDRI03 = *BLANKS                                           CFT050
476300200529     C                   EVAL      DDRI03 = '/LEIC/' + B3LEIC                                 CFT050
476400200529     C                   ENDIF                                                                CFT050
476500200529     C                   ENDIF                                                                CFT050
476600200529      ** B3BICC                                                                             MD022463
476700200529     C                   ENDIF                                                              MD022463
476800200529      ** CSW024                                                                             MD022463
476900200529     C                   ENDIF                                                              MD022463
477000200529     C                                                                                        CFT050
477100200529      ** MEBIB3L0 chain                                                                       CFT050
477200200529     C                   ENDIF                                                                CFT050
477300200529      *                                                                                       CFT050
477400200529     C                   ENDSR                                                                CFT050
477500200529      *                                                                                       CFT050
477600200529      *****************************************************************
477700200529      /EJECT
477800200529      *****************************************************************
477900200529      * *INZSR - INITIAL PROCESSING
478000200529      *****************************************************************
478100200529     C     *INZSR        BEGSR
478200200529                                                                                              CSD028
478300200529      ** Entry Parameters                                                                     CSD028
478400200529                                                                                              CSD028
478500200529     C     *ENTRY        PLIST                                                                CSD028
478600200529                                                                                              CSD028
478700200529      ** INPUTS                                                                               CSD028
478800200529      ** Transaction Type                                                                     CSD028
478900200529     C                   PARM                    TransType                                    CSD028
479000200529                                                                                              CSD028
479100200529      ** Customer Number                                                                      CSD028
479200200529     C                   PARM                    PCustNum                                     CSD028
479300200529                                                                                              CSD012
479400200529      * Override SDAULGL2                                                                     CSD012
479500200529     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
479600200529     C                   CALL      'QCMDEXC'                                                  CSD012
479700200529     C                   PARM                    CMD                                          CSD012
479800200529     C                   PARM                    CMDLEN                                       CSD012
479900200529      *
480000200529      ** Initialize program name
480100200529      *
480200200529     C                   MOVEL     'SDCUSDSIN'   DBPGM
480300200529      *
480400200529      ** ACCESS BANK DETAILS
480500200529      *
480600200529     C                   CALL      'AOBANKR0'
480700200529     C                   PARM      *BLANKS       @RTCD             7
480800200529     C                   PARM      '*FIRST '     @OPTN             7
480900200529     C     SDBANK        PARM      SDBANK        DSFDY
481000200529      *
481100200529      * DATABASE ERROR
481200200529      *
481300200529     C     @RTCD         IFNE      *BLANKS
481400200529     C                   MOVEL     'SDBANKPD'    DBFILE
481500200529     C                   MOVEL     '901'         DBASE
481600200529     C                   MOVEL     @OPTN         DBKEY
481700200529     C                   EXSR      *PSSR
481800200529     C                   END
481900200529      *
482000200529      ** Access Module Details
482100200529      *
482200200529     C                   CALL      'AOMMODR0'
482300200529     C                   PARM      *BLANKS       @RTCD
482400200529     C                   PARM      '*FIRST '     @OPTN
482500200529     C     SDMMOD        PARM      SDMMOD        DSFDY
482600200529      *
482700200529      * DATABASE ERROR
482800200529      *
482900200529     C     @RTCD         IFNE      *BLANKS
483000200529     C                   MOVEL     'SDMMODPD'    DBFILE
483100200529     C                   MOVEL     '904'         DBASE
483200200529     C                   MOVEL     @OPTN         DBKEY
483300200529     C                   EXSR      *PSSR
483400200529     C                   END
483500200529      *
483600200529      ** Access SAR details file to determine if S01383
483700200529      ** (Base Rate Tax) is on.
483800200529      *
483900200529     C                   CALLB     'AOSARDR0'
484000200529     C                   PARM      *BLANKS       @RTCD
484100200529     C                   PARM      '*VERIFY'     @OPTN
484200200529     C                   PARM      'S01383'      @SARD             6
484300200529     C     SCSARD        PARM      SCSARD        DSFDY
484400200529      *
484500200529      * DATABASE ERROR
484600200529      *
484700200529     C     @RTCD         IFNE      *BLANKS
484800200529     C     @RTCD         ANDNE     '*NRF   '
484900200529     C                   MOVEL     'SCSARDPD'    DBFILE
485000200529     C                   MOVEL     '905'         DBASE
485100200529     C                   MOVEL     'S01383'      DBKEY
485200200529     C                   EXSR      *PSSR
485300200529     C                   END
485400200529      *
485500200529     C     @RTCD         IFEQ      *BLANK
485600200529     C                   MOVEL     'Y'           S01383            1
485700200529     C                   ELSE
485800200529     C                   MOVEL     'N'           S01383
485900200529     C                   END
486000200529      *                                                                                       CSW024
486100200529      ** Access SAR details file to determine if CSW024                                       CSW024
486200200529      ** S.W.I.F.T. MT3xx Field 82/83/87 is installed.                                        CSW024
486300200529      *                                                                                       CSW024
486400200529     C                   CALLB     'AOSARDR0'                                                 CSW024
486500200529     C                   PARM      *BLANKS       @RTCD                                        CSW024
486600200529     C                   PARM      '*VERIFY'     @OPTN                                        CSW024
486700200529     C                   PARM      'CSW024'      @SARD                                        CSW024
486800200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW024
486900200529      *                                                                                       CSW024
487000200529      * DATABASE ERROR                                                                        CSW024
487100200529      *                                                                                       CSW024
487200200529     C     @RTCD         IFNE      *BLANKS                                                    CSW024
487300200529     C     @RTCD         ANDNE     '*NRF   '                                                  CSW024
487400200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSW024
487500200529     C                   MOVEL     '906'         DBASE                                        CSW024
487600200529     C                   MOVEL     'CSW024'      DBKEY                                        CSW024
487700200529     C                   EXSR      *PSSR                                                      CSW024
487800200529     C                   ENDIF                                                                CSW024
487900200529      *                                                                                       CSW024
488000200529     C     @RTCD         IFEQ      *BLANK                                                     CSW024
488100200529     C                   MOVEL     'Y'           CSW024            1                          CSW024
488200200529     C                   ELSE                                                                 CSW024
488300200529     C                   MOVEL     'N'           CSW024                                       CSW024
488400200529     C                   ENDIF                                                                CSW024
488500200529                                                                                              CSC011
488600200529      ** Access SAR Details file to determine if CSC011 is switched on                        CSC011
488700200529                                                                                              CSC011
488800200529     C                   CALLB     'AOSARDR0'                                                 CSC011
488900200529     C                   PARM      *BLANKS       @RTCD                                        CSC011
489000200529     C                   PARM      '*VERIFY'     @OPTN                                        CSC011
489100200529     C                   PARM      'CSC011'      @SARD                                        CSC011
489200200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
489300200529                                                                                              CSC011
489400200529      ** Database Error                                                                       CSC011
489500200529                                                                                              CSC011
489600200529     C     @RTCD         IFNE      *BLANKS                                                    CSC011
489700200529     C     @RTCD         ANDNE     '*NRF   '                                                  CSC011
489800200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSC011
489900200529     C                   MOVEL     '907'         DBASE                                        CSC011
490000200529     C                   MOVEL     'CSC011'      DBKEY                                        CSC011
490100200529     C                   EXSR      *PSSR                                                      CSC011
490200200529     C                   ENDIF                                                                CSC011
490300200529      *                                                                                       CSC011
490400200529     C     @RTCD         IFEQ      *BLANK                                                     CSC011
490500200529     C                   MOVEL     'Y'           CSC011            1                          CSC011
490600200529     C                   IN        SDSTAT                                                     CSC011
490700200529     C                   IN        SC24X7                                                     CSC011
490800200529     C                   ELSE                                                                 CSC011
490900200529     C                   MOVEL     'N'           CSC011                                       CSC011
491000200529     C                   ENDIF                                                                CSC011
491100200529                                                                                              CSD021
491200200529      ** Check if CSD021 is installed                                                         CSD021
491300200529     C                   CALLB     'AOSARDR0'                                                 CSD021
491400200529     C                   PARM      *BLANKS       @RTCD                                        CSD021
491500200529     C                   PARM      '*VERIFY'     @OPTN                                        CSD021
491600200529     C                   PARM      'CSD021'      @SARD                                        CSD021
491700200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD021
491800200529                                                                                              CSD021
491900200529      ** Database error                                                                       CSD021
492000200529                                                                                              CSD021
492100200529     C                   IF        (@RTCD <> *BLANKS) and                                     CSD021
492200200529     C                             (@RTCD <> '*NRF   ')                                       CSD021
492300200529     C                   EVAL      DBKEY = 'CSD021'                                           CSD021
492400200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD021
492500200529     C                   EVAL      DBASE = 909                                                CSD021
492600200529     C                   EXSR      *PSSR                                                      CSD021
492700200529     C                   ENDIF                                                                CSD021
492800200529                                                                                              CSD021
492900200529     C                   IF        @RTCD = *BLANKS                                            CSD021
493000200529     C                   EVAL      CSD021 = 'Y'                                               CSD021
493100200529     C                   ELSE                                                                 CSD021
493200200529     C                   EVAL      CSD021 = 'N'                                               CSD021
493300200529     C                   ENDIF                                                                CSD021
493400200529      *                                                                                       CSD012
493500200529      ** Access SAR details file to determine if CSD012                                       CSD012
493600200529      ** (Standing Data Authorisation) is on.                                                 CSD012
493700200529     C                   CALLB     'AOSARDR0'                                                 CSD012
493800200529     C                   PARM      *BLANKS       @RTCD                                        CSD012
493900200529     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
494000200529     C                   PARM      'CSD012'      @SARD                                        CSD012
494100200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC012
494200200529      *                                                                                       CSD012
494300200529     C     @RTCD         IFEQ      *BLANK                                                     CSD012
494400200529     C                   MOVE      'Y'           CSD012                                       CSD012
494500200529     C                   ELSE                                                                 CSD012
494600200529     C                   MOVE      'N'           CSD012                                       CSD012
494700200529     C                   ENDIF                                                                CSD012
494800200529                                                                                              CSD012
494900200529      ** If CSD012 is ON, Check if Customer Details Authorisation is ON                       CSD012
495000200529 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
495100200529      *                                                                                       CSD012
495200200529     C                   CALL      'AOSVALR0'                                                 CSD012
495300200529     C                   PARM                    @RTCD                                        CSD012
495400200529     C                   PARM      SVALKK        SVALK1           20                          CSD012
495500200529     C                   PARM                    SVAL1           200                          CSD012
495600200529     C                   PARM                    SVALK2           20                          CSD012
495700200529     C                   PARM                    SVAL2           200                          CSD012
495800200529     C                   PARM                    SVALK3           20                          CSD012
495900200529     C                   PARM                    SVAL3           200                          CSD012
496000200529     C                   PARM                    SVALK4           20                          CSD012
496100200529     C                   PARM                    SVAL4           200                          CSD012
496200200529     C                   PARM                    SVALK5           20                          CSD012
496300200529     C                   PARM                    SVAL5           200                          CSD012
496400200529     C                   PARM                    SVALK6           20                          CSD012
496500200529     C                   PARM                    SVAL6           200                          CSD012
496600200529     C                   PARM                    SVALK7           20                          CSD012
496700200529     C                   PARM                    SVAL7           200                          CSD012
496800200529     C                   PARM                    SVALK8           20                          CSD012
496900200529     C                   PARM                    SVAL8           200                          CSD012
497000200529     C                   PARM                    SVALK9           20                          CSD012
497100200529     C                   PARM                    SVAL9           200                          CSD012
497200200529     C                   PARM                    SVALK0           20                          CSD012
497300200529     C                   PARM                    SVAL10          200                          CSD012
497400200529      *                                                                                       CSD012
497500200529     C     @RTCD         IFNE      *BLANKS                                                    CSD012
497600200529                                                                                              CSD012
497700200529     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
497800200529     C                   MOVE      SVALK0        DBKEY                                        CSD012
497900200529     C                   ENDIF                                                                CSD012
498000200529     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
498100200529     C                   MOVE      SVALK9        DBKEY                                        CSD012
498200200529     C                   ENDIF                                                                CSD012
498300200529     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
498400200529     C                   MOVE      SVALK8        DBKEY                                        CSD012
498500200529     C                   ENDIF                                                                CSD012
498600200529     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
498700200529     C                   MOVE      SVALK7        DBKEY                                        CSD012
498800200529     C                   ENDIF                                                                CSD012
498900200529     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
499000200529     C                   MOVE      SVALK6        DBKEY                                        CSD012
499100200529     C                   ENDIF                                                                CSD012
499200200529     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
499300200529     C                   MOVE      SVALK5        DBKEY                                        CSD012
499400200529     C                   ENDIF                                                                CSD012
499500200529     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
499600200529     C                   MOVE      SVALK4        DBKEY                                        CSD012
499700200529     C                   ENDIF                                                                CSD012
499800200529     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
499900200529     C                   MOVE      SVALK3        DBKEY                                        CSD012
500000200529     C                   ENDIF                                                                CSD012
500100200529     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
500200200529     C                   MOVE      SVALK2        DBKEY                                        CSD012
500300200529     C                   ENDIF                                                                CSD012
500400200529     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
500500200529     C                   MOVE      SVALK1        DBKEY                                        CSD012
500600200529     C                   ENDIF                                                                CSD012
500700200529                                                                                              CSD012
500800200529     C     *LOCK         IN        LDA                                                        CSD012
500900200529     C                   Z-ADD     908           DBASE                                        CSD012
501000200529     C                   MOVEL     'SDSVALPD'    DBFILE                                       CSD012
501100200529     C                   MOVEL     'SDCUSDSIN'   DBPGM                                        CSD012
501200200529     C                   OUT       LDA                                                        CSD012
501300200529     C                   EXSR      *PSSR                                                      CSD012
501400200529     C                   ENDIF                                                                CSD012
501500200529      *                                                                                       CSD012
501600200529      ** If Customer Details Authorisation is On set to Authorise                             CSD012
501700200529     C     SVAL11        IFEQ      'Y'                                                        CSD012
501800200529     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
501900200529     C                   ELSE                                                                 CSD012
502000200529     C                   MOVE      'N'           AUTHRQ                                       CSD012
502100200529     C                   ENDIF                                                                CSD012
502200200529      *                                                                                       CSD012
502300200529 E1  C                   ENDIF                                                                CSD012
502400200529                                                                                              CGP001
502500200529      ** Check if Global Data Layout Enhancement (CGP001) is on.                              CGP001
502600200529                                                                                              CGP001
502700200529     C                   EVAL      CGP001 = 'N'                                               CGP001
502800200529                                                                                              CGP001
502900200529     C                   CALLB     'AOSARDR0'                                                 CGP001
503000200529     C                   PARM      *BLANKS       @RTCD                                        CGP001
503100200529     C                   PARM      '*VERIFY'     @OPTN                                        CGP001
503200200529     C                   PARM      'CGP001'      @SARD                                        CGP001
503300200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGP001
503400200529                                                                                              CGP001
503500200529     C                   IF        @RTCD = *BLANKS                                            CGP001
503600200529     C                   EVAL      CGP001 = 'Y'                                               CGP001
503700200529     C                   ENDIF                                                                CGP001
503800200529                                                                                              CGP001
503900200529     C                   IF        @RTCD <> *BLANKS and                                       CGP001
504000200529     C                             @RTCD <> '*NRF   '                                         CGP001
504100200529     C     *LOCK         IN        LDA                                                        CGP001
504200200529     C                   EVAL      DBKEY = 'CGP001'                                           CGP001
504300200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGP001
504400200529     C                   EVAL      DBASE = 908                                                CGP001
504500200529     C                   OUT       LDA                                                        CGP001
504600200529     C                   EXSR      *PSSR                                                      CGP001
504700200529     C                   ENDIF                                                                CGP001
504800200529                                                                                              CLE025
504900200529      ** Check if enhancement CLE025 (Multi-Option Facilities) is on                          CLE025
505000200529                                                                                              CLE025
505100200529     C                   CALLB     'AOSARDR0'                                                 CLE025
505200200529     C                   PARM      *BLANKS       PRTCD                                        CLE025
505300200529     C                   PARM      '*VERIFY'     POPTN                                        CLE025
505400200529     C                   PARM      'CLE025'      PSARD                                        CLE025
505500200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
505600200529                                                                                              CLE025
505700200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE025
505800200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
505900200529     C                   EVAL      DBKEY  = 'CLE025'                                          CLE025
506000200529     C                   EVAL      DBASE  = 902                                               CLE025
506100200529     C                   EXSR      *PSSR                                                      CLE025
506200200529     C                   ENDIF                                                                CLE025
506300200529      *                                                                                       CLE025
506400200529     C                   IF        PRTCD = *BLANKS                                            CLE025
506500200529     C                   EVAL      CLE025 = 'Y'                                               CLE025
506600200529     C                   ELSE                                                                 CLE025
506700200529     C                   EVAL      CLE025 = 'N'                                               CLE025
506800200529     C                   ENDIF                                                                CLE025
506900200529                                                                                              CFX001
507000200529      ** Check if enhancement CFX001 (FX Margin Trading) is on                                CFX001
507100200529                                                                                              CFX001
507200200529     C                   CALLB     'AOSARDR0'                                                 CFX001
507300200529     C                   PARM      *BLANKS       PRTCD                                        CFX001
507400200529     C                   PARM      '*VERIFY'     POPTN                                        CFX001
507500200529     C                   PARM      'CFX001'      PSARD                                        CFX001
507600200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CFX001
507700200529                                                                                              CFX001
507800200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CFX001
507900200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFX001
508000200529     C                   EVAL      DBKEY  = 'CFX001'                                          CFX001
508100200529     C                   EVAL      DBASE  = 903                                               CFX001
508200200529     C                   EXSR      *PSSR                                                      CFX001
508300200529     C                   ENDIF                                                                CFX001
508400200529      *                                                                                       CFX001
508500200529     C                   IF        PRTCD = *BLANKS                                            CFX001
508600200529     C                   EVAL      CFX001 = 'Y'                                               CFX001
508700200529     C                   ELSE                                                                 CFX001
508800200529     C                   EVAL      CFX001 = 'N'                                               CFX001
508900200529     C                   ENDIF                                                                CFX001
509000200529                                                                                              CGP001
509100200529      ** Check if enhancement CSD028 (Know Your Customer) is on                               CSD028
509200200529                                                                                              CSD028
509300200529     C                   CALLB     'AOSARDR0'                                                 CSD028
509400200529     C                   PARM      *BLANKS       PRTCD                                        CSD028
509500200529     C                   PARM      '*VERIFY'     POPTN                                        CSD028
509600200529     C                   PARM      'CSD028'      PSARD                                        CSD028
509700200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD028
509800200529                                                                                              CSD028
509900200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD028
510000200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD028
510100200529     C                   EVAL      DBKEY = 'CSD028'                                           CSD028
510200200529     C                   EVAL      DBASE = 910                                                CSD028
510300200529     C                   EXSR      *PSSR                                                      CSD028
510400200529     C                   ENDIF                                                                CSD028
510500200529                                                                                              CSD028
510600200529     C                   IF        PRTCD = *BLANKS                                            CSD028
510700200529     C                   EVAL      CSD028 = 'Y'                                               CSD028
510800200529     C                   ELSE                                                                 CSD028
510900200529     C                   EVAL      CSD028 = 'N'                                               CSD028
511000200529     C                   ENDIF                                                                CSD028
511100200529                                                                                              CSD028
511200200529      *                                                                                       CER001
511300200529      ** Check if ULX043 in ON                                                                CER001
511400200529      *                                                                                       CER001
511500200529     C                   CALLB     'AOSARDR0'                                                 CER001
511600200529     C                   PARM      *BLANKS       PRTCD                                        CER001
511700200529     C                   PARM      '*VERIFY'     POPTN                                        CER001
511800200529     C                   PARM      'ULX043'      PSARD                                        CER001
511900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
512000200529                                                                                              CER001
512100200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
512200200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
512300200529     C                   EVAL      DBKEY  = 'ULX043'                                          CER001
512400200529     C                   EVAL      DBASE  = 910                                               CER001
512500200529     C                   EXSR      *PSSR                                                      CER001
512600200529     C                   ENDIF                                                                CER001
512700200529      *                                                                                       CER001
512800200529     C                   IF        PRTCD = *BLANKS                                            CER001
512900200529     C                   EVAL      ULX043 = 'Y'                                               CER001
513000200529      *                                                                                       CER001
513100200529      ** Do not process lux extension details when IBLC Returns                               CER001
513200200529      ** indicator is not set to 'Y'                                                          CER001
513300200529      *                                                                                       CER001
513400200529     C                   IF         BGNWST <> 'Y'                                             CER001
513500200529     C                   EVAL       ULX043 = 'N'                                              CER001
513600200529     C                   ENDIF                                                                CER001
513700200529     C                   ELSE                                                                 CER001
513800200529     C                   EVAL      ULX043 = 'N'                                               CER001
513900200529     C                   ENDIF                                                                CER001
514000200529      *                                                                                       CER001
514100200529     C                   IF        ULX043 = 'Y' AND BGNWST = 'Y'                              CER001
514200200529     C                   OPEN      SDCUX1L0                                                   CER001
514300200529     C                   OPEN      SDINX1L0                                                   CER001
514400200529     C                   OPEN      SDCTX2L0                                                   CER001
514500200529     C                   ENDIF                                                                CER001
514600200529      *                                                                                       CER001
514700200529      ** Check if ULX008 in ON                                                                CER001
514800200529      *                                                                                       CER001
514900200529     C                   CALLB     'AOSARDR0'                                                 CER001
515000200529     C                   PARM      *BLANKS       PRTCD                                        CER001
515100200529     C                   PARM      '*VERIFY'     POPTN                                        CER001
515200200529     C                   PARM      'ULX008'      PSARD                                        CER001
515300200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
515400200529                                                                                              CER001
515500200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
515600200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
515700200529     C                   EVAL      DBKEY  = 'ULX008'                                          CER001
515800200529     C                   EVAL      DBASE  = 911                                               CER001
515900200529     C                   EXSR      *PSSR                                                      CER001
516000200529     C                   ENDIF                                                                CER001
516100200529      *                                                                                       CER001
516200200529     C                   IF        PRTCD = *BLANKS                                            CER001
516300200529     C                   EVAL      ULX008 = 'Y'                                               CER001
516400200529     C                   ELSE                                                                 CER001
516500200529     C                   EVAL      ULX008 = 'N'                                               CER001
516600200529     C                   ENDIF                                                                CER001
516700200529      *                                                                                       CER001
516800200529      ** Check if ULX012 in ON                                                                CER001
516900200529      *                                                                                       CER001
517000200529     C                   CALLB     'AOSARDR0'                                                 CER001
517100200529     C                   PARM      *BLANKS       PRTCD                                        CER001
517200200529     C                   PARM      '*VERIFY'     POPTN                                        CER001
517300200529     C                   PARM      'ULX012'      PSARD                                        CER001
517400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
517500200529                                                                                              CER001
517600200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
517700200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
517800200529     C                   EVAL      DBKEY  = 'ULX012'                                          CER001
517900200529     C                   EVAL      DBASE  = 912                                               CER001
518000200529     C                   EXSR      *PSSR                                                      CER001
518100200529     C                   ENDIF                                                                CER001
518200200529      *                                                                                       CER001
518300200529     C                   IF        PRTCD = *BLANKS                                            CER001
518400200529     C                   EVAL      ULX012 = 'Y'                                               CER001
518500200529     C                   ELSE                                                                 CER001
518600200529     C                   EVAL      ULX012 = 'N'                                               CER001
518700200529     C                   ENDIF                                                                CER001
518800200529      *                                                                                       CER001
518900200529      ** Check if ULX048 in ON                                                                CER001
519000200529      *                                                                                       CER001
519100200529     C                   CALLB     'AOSARDR0'                                                 CER001
519200200529     C                   PARM      *BLANKS       PRTCD                                        CER001
519300200529     C                   PARM      '*VERIFY'     POPTN                                        CER001
519400200529     C                   PARM      'ULX048'      PSARD                                        CER001
519500200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
519600200529                                                                                              CER001
519700200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
519800200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
519900200529     C                   EVAL      DBKEY  = 'ULX048'                                          CER001
520000200529     C                   EVAL      DBASE  = 913                                               CER001
520100200529     C                   EXSR      *PSSR                                                      CER001
520200200529     C                   ENDIF                                                                CER001
520300200529      *                                                                                       CER001
520400200529     C                   IF        PRTCD = *BLANKS                                            CER001
520500200529     C                   EVAL      ULX048 = 'Y'                                               CER001
520600200529     C                   ELSE                                                                 CER001
520700200529     C                   EVAL      ULX048 = 'N'                                               CER001
520800200529     C                   ENDIF                                                                CER001
520900200529      *                                                                                       CER001
521000200529      ** Check if ULX609 in ON                                                                CER001
521100200529      *                                                                                       CER001
521200200529     C                   CALLB     'AOSARDR0'                                                 CER001
521300200529     C                   PARM      *BLANKS       PRTCD                                        CER001
521400200529     C                   PARM      '*VERIFY'     POPTN                                        CER001
521500200529     C                   PARM      'ULX609'      PSARD                                        CER001
521600200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
521700200529                                                                                              CER001
521800200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
521900200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
522000200529     C                   EVAL      DBKEY  = 'ULX609'                                          CER001
522100200529     C                   EVAL      DBASE  = 914                                               CER001
522200200529     C                   EXSR      *PSSR                                                      CER001
522300200529     C                   ENDIF                                                                CER001
522400200529      *                                                                                       CER001
522500200529     C                   IF        PRTCD = *BLANKS                                            CER001
522600200529     C                   EVAL      ULX609 = 'Y'                                               CER001
522700200529      *                                                                                       CER001
522800200529      ** Do not process lux extension details when Lux Return                                 CER001
522900200529      ** indicator is not set to 'Y'                                                          CER001
523000200529      *                                                                                       CER001
523100200529     C                   IF         BGLRIN <> 'Y'                                             CER001
523200200529     C                   EVAL       ULX609 = 'N'                                              CER001
523300200529     C                   ENDIF                                                                CER001
523400200529     C                   ELSE                                                                 CER001
523500200529     C                   EVAL      ULX609 = 'N'                                               CER001
523600200529     C                   ENDIF                                                                CER001
523700200529      *                                                                                       CER001
523800200529     C                   IF        ULX609 = 'Y' and BGLRIN = 'Y'                              CER001
523900200529     C                   OPEN      SDCUX2L0                                                   CER001
524000200529     C                   ENDIF                                                                CER001
524100200529                                                                                              CSW207
524200200529      ** Check if SWIFT 2007 is installed                                                     CSW207
524300200529                                                                                              CSW207
524400200529     C                   CALL      'SWIF2007'                                                 CSW207
524500200529     C                   PARM      *BLANKS       PRtCd                                        CSW207
524600200529                                                                                              CSW207
524700200529     C                   IF        PRtCd   = 'CSW2007'                                        CSW207
524800200529     C                   EVAL      CSW207 = 'Y'                                               CSW207
524900200529     C                   ELSE                                                                 CSW207
525000200529     C                   EVAL      CSW207 = 'N'                                               CSW207
525100200529     C                   ENDIF                                                                CSW207
525200200529                                                                                              CSW207
525300200529      *                                                                                     BUG13228
525400200529      ** Check if ULX004 in ON                                                              BUG13228
525500200529      *                                                                                     BUG13228
525600200529     C                   CALLB     'AOSARDR0'                                               BUG13228
525700200529     C                   PARM      *BLANKS       PRTCD                                      BUG13228
525800200529     C                   PARM      '*VERIFY'     POPTN                                      BUG13228
525900200529     C                   PARM      'ULX004'      PSARD                                      BUG13228
526000200529     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG13228
526100200529                                                                                            BUG13228
526200200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                BUG13228
526300200529     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG13228
526400200529     C                   EVAL      DBKEY  = 'ULX004'                                        BUG13228
526500200529     C                   EVAL      DBASE  = 915                                             BUG13228
526600200529     C                   EXSR      *PSSR                                                    BUG13228
526700200529     C                   ENDIF                                                              BUG13228
526800200529      *                                                                                     BUG13228
526900200529     C                   IF        PRTCD = *BLANKS                                          BUG13228
527000200529     C                   EVAL      ULX004 = 'Y'                                             BUG13228
527100200529     C                   ELSE                                                               BUG13228
527200200529     C                   EVAL      ULX004 = 'N'                                             BUG13228
527300200529     C                   ENDIF                                                              BUG13228
527400200529      ***********                                                                 BUG26917 BUG26917A
527500200529      ***Check*if*CER048*is*ON*                                                   BUG26917 BUG26917A
527600200529      **********                                                                  BUG26917 BUG26917A
527700200529     C**********         CALLB     'AOSARDR0'                                     BUG26917 BUG26917A
527800200529     C**********         PARM      *BLANKS       PRTCD                            BUG26917 BUG26917A
527900200529     C**********         PARM      '*VERIFY'     POPTN                            BUG26917 BUG26917A
528000200529     C**********         PARM      'CER048'      PSARD                            BUG26917 BUG26917A
528100200529     C*****SCSARD        PARM      SCSARD        DSFDY                            BUG26917 BUG26917A
528200200529      **********                                                                  BUG26917 BUG26917A
528300200529     C**********         IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '      BUG26917 BUG26917A
528400200529     C**********         EVAL      DBFILE = 'SCSARDPD'                            BUG26917 BUG26917A
528500200529     C**********         EVAL      DBKEY  = 'CER048'                              BUG26917 BUG26917A
528600200529     C**********         EVAL      DBASE  = 915                                   BUG26917 BUG26917A
528700200529     C**********         EXSR      *PSSR                                          BUG26917 BUG26917A
528800200529     C**********         ENDIF                                                    BUG26917 BUG26917A
528900200529      **********                                                                  BUG26917 BUG26917A
529000200529     C**********         IF        PRTCD = *BLANKS                                BUG26917 BUG26917A
529100200529     C**********         EVAL      CER048 = 'Y'                                   BUG26917 BUG26917A
529200200529     C**********         ELSE                                                     BUG26917 BUG26917A
529300200529     C**********         EVAL      CER048 = 'N'                                   BUG26917 BUG26917A
529400200529     C**********         ENDIF                                                    BUG26917 BUG26917A
529500200529      **********                                                                  BUG26917 BUG26917A
529600200529      *                                                                                       CER001
529700200529     C     K@KEY1        KLIST                                                                CER001
529800200529     C                   KFLD                    KCUST                                        CER001
529900200529     C/COPY WNCPYSRC,SDH00489
530000200529      ** Check if CSD037 is enabled.                                                          CSD031
530100200529                                                                                              CSD031
530200200529     C                   CALLB     'AOSARDR0'                                                 CSD031
530300200529     C                   PARM      *BLANKS       PRtCd                                        CSD031
530400200529     C                   PARM      '*VERIFY'     POptn                                        CSD031
530500200529     C                   PARM      'CSD037'      PSARD                                        CSD031
530600200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD031
530700200529                                                                                              CSD031
530800200529     C                   IF        PRtCd = *BLANKS                                            CSD031
530900200529     C                   EVAL      CSD037 = 'Y'                                               CSD031
531000200529     C                   ELSE                                                                 CSD031
531100200529                                                                                              CSD031
531200200529     C                   IF        PRtCd <> '*NRF   '                                         CSD031
531300200529     C     *LOCK         IN        LDA                                                        CSD031
531400200529     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD031
531500200529     C                   EVAL      DBKey = 'CSD037'                                           CSD031
531600200529     C                   EVAL      DBase = 101                                                CSD031
531700200529     C                   OUT       LDA                                                        CSD031
531800200529     C                   EXSR      *PSSR                                                      CSD031
531900200529     C                   ENDIF                                                                CSD031
532000200529                                                                                              CSD031
532100200529     C                   ENDIF                                                                CSD031
532200200529                                                                                              CSD031
532300200529      ** Access Switchable Features file to determine whether                                LLN022A
532400200529      ** LLN022 (Bank of England) processing is installed.                                   LLN022A
532500200529      *                                                                                      LLN022A
532600200529     C                   MOVE      'N'           LLN022            1                         LLN022A
532700200529     C                   CALLB     'AOSARDR0'                                                LLN022A
532800200529     C                   PARM      *BLANK        PRTCD                                       LLN022A
532900200529     C                   PARM      '*VERIFY'     POPTN                                       LLN022A
533000200529     C                   PARM      'LLN022'      PSARD                                       LLN022A
533100200529     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
533200200529      *                                                                                      LLN022A
533300200529     C                   IF        PRTCD = *BLANK                                            LLN022A
533400200529     C                   MOVE      'Y'           LLN022                                      LLN022A
533500200529     C                   ENDIF                                                               LLN022A
533600200529      *                                                                                     MD022463
533700200529      ** Check if SWIFT 2013 is installed                                                   MD022463
533800200529      *                                                                                     MD022463
533900200529     C                   CALL      'SWIF2013'                                               MD022463
534000200529     C                   PARM      *BLANKS       PRtCd                                      MD022463
534100200529                                                                                            MD022463
534200200529     C                   IF        PRtCd   = 'CSW2013'                                      MD022463
534300200529     C                   EVAL      CSW213 = 'Y'                                             MD022463
534400200529     C                   ELSE                                                               MD022463
534500200529     C                   EVAL      CSW213 = 'N'                                             MD022463
534600200529     C                   ENDIF                                                              MD022463
534700200529      *                                                                                     MD022463
534800200529      ** Check if CFT050 in ON                                                              MD022463
534900200529      *                                                                                     MD022463
535000200529     C                   CALLB     'AOSARDR0'                                               MD022463
535100200529     C                   PARM      *BLANKS       PRtCd                                      MD022463
535200200529     C                   PARM      '*VERIFY'     POptn                                      MD022463
535300200529     C                   PARM      'CFT050'      PSard                                      MD022463
535400200529     C     SCSARD        PARM      SCSARD        DSFDY                                      MD022463
535500200529                                                                                            MD022463
535600200529     C                   IF        PRtCd <> *BLANKS  AND  PRtCd <> '*NRF   '                MD022463
535700200529     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD022463
535800200529     C                   EVAL      DBKEY  = 'CFT050'                                        MD022463
535900200529     C                   EVAL      DBASE  = 916                                             MD022463
536000200529     C                   EXSR      *PSSR                                                    MD022463
536100200529     C                   ENDIF                                                              MD022463
536200200529      *                                                                                     MD022463
536300200529     C                   IF        PRtCd = *BLANKS                                          MD022463
536400200529     C                   EVAL      CFT050 = 'Y'                                             MD022463
536500200529     C                   ELSE                                                               MD022463
536600200529     C                   EVAL      CFT050 = 'N'                                             MD022463
536700200529     C                   ENDIF                                                              MD022463
536800200529     C/COPY WNCPYSRC,SDCUSDSC06
536900200529      *
537000200529      * GO TO INITIAL SCREEN
537100200529      *
537200200529     C                   EXSR      INITIAL
537300200529      *
537400200529
537500200529      *  Hook to enable non-core initial processing to be included
537600200529      /COPY WNCPYSRC,SDCUSDS013
537700200529
537800200529     C                   ENDSR
537900200529      *****************************************************************
538000200529      /EJECT
538100200529     C/COPY WNCPYSRC,SDCUSDSC23
538200200529      *****************************************************************
538300200529      ** Program, module and procedure names for database error processing.
538400200529      ** =================================================================
538500200529      ** The following /COPY sets these values, and also defines LDA as
538600200529      ** an external data area
538700200529      ********************************************************************
538800200529     C/COPY ZACPYSRC,PSSR_ILE
538900200529      ********************************************************************
539000200529**  CPY@
539100200529(c) Finastra International Limited 2001
