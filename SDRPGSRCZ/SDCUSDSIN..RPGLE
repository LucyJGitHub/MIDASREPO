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
001700200529      *  Last Amend No. MD032160           Date 22May20               *
001800200529      *  Prev Amend No. MD054028           Date 05Sep19               *
001900200529      *                 CER050             Date 16Jun19               *
002000200529      *                 MD046248           Date 27Oct17               *
002100200529      *                 LLN022A            Date 03Jun15               *
002200200529      *                 LLN022             Date 03Jun15               *
002300200529      *                 CER070             Date 24Nov14               *
002400200529      *                 MD030956           Date 09Oct14               *
002500200529      *                 MD022854           Date 14Oct13               *
002600200529      *                 MD022463           Date 27Sep13               *
002700200529      *                 MD022395           Date 15Sep13               *
002800200529      *                 MD022443           Date 18Sep13               *
002900200529      *                 CFT050             Date 03Jun13               *
003000200529      *                 CSW213             Date 03Jun13               *
003100200529      *                 CLE134             Date 01Aug12               *
003200200529      *                 AR787620           Date 10Jun11               *
003300200529      *                 CER059             Date 19Jul10               *
003400200529      *                 BUG26917A          Date 27Jan10               *
003500200529      *                 BUG26917           Date 20Jan10               *
003600200529      *                 BUG23518           Date 30Mar09               *
003700200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
003800200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
003900200529      *                 256564             Date 17Sep08               *
004000200529      *                 248913             Date 11Jul07               *
004100200529      *                 CSW207A            Date 08Jun07               *
004200200529      *                 CSW207             Date 08Jun07               *
004300200529      *                 249076             Date 03Aug07               *
004400200529      *                 244030             Date 28Nov06               *
004500200529      *                 CRE026             Date 24May06               *
004600200529      *                 BUG13228           Date 07Feb07               *
004700200529      * Midas Plus 1.3 ----------- Base ------------------------------*
004800200529      *                 BG12345A           Date 29Oct06               *
004900200529      *                 BUG11917           Date 18Aug06               *
005000200529      *                 BUG11907           Date 16Aug06               *
005100200529      *                 BUG11889           Date 13Aug06               *
005200200529      *                 213713             Date 06Jun06               *
005300200529      *                 BUG8425            Date 24May06               *
005400200529      *                 237595             Date 07Feb06               *
005500200529      *                 CSD031             Date 10Apr06               *
005600200529      *                 BUG8134            Date 10Oct05               *
005700200529      *                 CSD027A            Date 05May06               *
005800200529      *                 CSD027             Date 09Dec05               *
005900200529      *                 BUG10817           Date 17Mar06               *
006000200529      *                 BUG10295           Date 02Feb06               *
006100200529      *                 CER001             Date 25Apr05               *
006200200529      *                 CSD028             Date 22Aug05               *
006300200529      *                 CGL031             Date 05Jul04               *
006400200529      *                 235524             Date 26Aug05               *
006500200529      *                 CSW037A            Date 02May05               *
006600200529      *                 BUG6565            Date 05Apr05               *
006700200529      *                 BUG6198            Date 04Apr05               *
006800200529      *                 BUG5139            Date 10Mar05               *
006900200529      *                 CSD025             Date 11Jan05               *
007000200529      *                 CSW037             Date 15Dec04               *
007100200529      *                 CSW036             Date 15Dec04               *
007200200529      *                 BUG4454            Date 08Oct04               *
007300200529      *                 BUG3362            Date 28Jul04               *
007400200529      *                 CFX001             Date 20Oct03               *
007500200529      *                 CLE025             Date 20Oct03               *
007600200529      *                 BUG2664            Date 21May04               *
007700200529      *                 CSD021             Date 14Jul03               *
007800200529      *                 222373             Date 24Oct03               *
007900200529      *                 CGP001             Date 23May03               *
008000200529      *                 CSD012             Date 15Oct02               *
008100200529      * Midas Release 4.01.03 ----------------------------------------*
008200200529      *                 212263             Date 21Nov02               *
008300200529      * Midas Release 4.01.02 ----------------------------------------*
008400200529      *                 203036             Date 10May02               *
008500200529      *                 202805             Date 10May02               *
008600200529      *                 192916             Date 27Mar02               *
008700200529      * Midas Release 4.01 -------------------------------------------*
008800200529      *                 CSC011             Date 18Sep01               *
008900200529      *                 193883             Date 20Nov01               *
009000200529      *                 CSW024             Date 31Aug01               *
009100200529      *                 196149             Date 16Aug01               *
009200200529      * Midas Release 4 --------------- Base -------------------------*
009300200529      * Midas DBA 3.05 -----------------------------------------------*
009400200529      *                 CRE007             Date 01Mar01               *
009500200529      *                 185595             Date 30Oct00               *
009600200529      *                 CPB002             Date 13Dec99               *
009700200529      *                 189774             Date 13Feb01               *
009800200529      * Midas DBA 3.04 -----------------------------------------------*
009900200529      *                 CSD007             Date 28Aug00               *
010000200529      *                 CDL008             Date 02May00               *
010100200529      * Midas DBA 3.02 -----------------------------------------------*
010200200529      *                 CAP014             Date 20Dec99               *
010300200529      *                 CAP034  *CREATE    Date 25May99               *
010400200529      *                                                               *
010500200529      *---------------------------------------------------------------*
010600200529      *                                                               *
010700200529      *  MD032160 - upgrade selected fixes from UBS-TPE MP1.2.1 to    *
010800200529      *             UBS-TPE 2.1 SP22.                                 *
010900200529      *             Apply fix 252069                                  *
011000200529      *  252069 - Database error message occurs when there is a       *
011100200529      *           record locking issue.                               *
011200200529      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
011300200529      *             being updated                                     *
011400200529      *  CER050 - Annualised Percentage Rate (Recompile)              *
011500200529      *  MD046248 - Finastra Rebranding                               *
011600200529      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
011700200529      *            /COPY members and add switchability.               *
011800200529      *  LLN022 - BOE Upgrade to MidasPlus.                           *
011900200529      *           Recompiled over changes in /COPY                    *
012000200529      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
012100200529      *  MD030956 - Additional changes to BFM-TI enhancement          *
012200200529      *  MD022854 - No Legal entity identifier for input              *
012300200529      *  MD022463 - No screen is displayed to show Bank Directory     *
012400200529      *             Plus Detail Screen on Linked Customers during     *
012500200529      *             Amend and Enquire                                 *
012600200529      *  MD022395 - Value of Clearing System on previously checked    *
012700200529      *             customer is copied into another customer when     *
012800200529      *             amending it                                       *
012900200529      *  MD022443 - Clearing System incorrect defaulting for ISO      *
013000200529      *             Country code CA and CH                            *
013100200529      *  CFT050 - SWIFTRef Directories upload                         *
013200200529      *  CSW213 - SWIFT Changes 2013                                  *
013300200529      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
013400200529      *  AR787620 - Hooks Incorporation                               *
013500200529      *             WNCPYSRC,SDH00104                                 *
013600200529      *             WNCPYSRC,SDH00105                                 *
013700200529      *             WNCPYSRC,SDH00109                                 *
013800200529      *  CER059 - German Feature Upgrade to Delhi                     *
013900200529      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
014000200529      *  BUG26917A - Reverse fix for bug26917                         *
014100200529      *  BUG26917 - COB error when customer is declared as taxable    *
014200200529      *           w/ German features installed and no additional      *
014300200529      *           customers information is set up                     *
014400200529      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
014500200529      *             Customer Closure                                  *
014600200529      *  256564 - Recompile due to PF changes done by fix 256330      *
014700200529      *  248913 - Disable F7/F8 or Next/Previous screen option during *
014800200529      *           input or amend.                                     *
014900200529      *  CSW207A - SWIFT 2007 Changes                                 *
015000200529      *  CSW207 - SWIFT 2007 Changes                                  *
015100200529      *  249076 - Enhance error message S270004 to show character     *
015200200529      *           and position that is not allowed in SDSVALPD.       *
015300200529      *  244030 - Clear datastructure for further details to prevent  *
015400200529      *           database error during insertion of new customers.   *
015500200529      *  CRE026 - Consumer Banking (Recompile)                        *
015600200529      *  BUG13228 - Need to pass status of ULX004 to SDCUSD2SN        *
015700200529      *  BG12345A - I/O Operation was applied tp closed File SDINX10  *
015800200529      *  BUG11917 - Different error message appear when enquiring/    *
015900200529      *             accepting/deleting a record in zonal acceptance   *
016000200529      *  BUG11907 - System hangs when rejecting a customer record     *
016100200529      *             in acceptance list                                *
016200200529      *  BUG11889 - Alphanumeric customer not accepted in zonal F11   *
016300200529      *  213713 - Window processing not performed when PB module is   *
016400200529      *           switched off.  Ensure window is displayed when      *
016500200529      *           window processing is on and PB module is off.       *
016600200529      *  BUG8425 - Update customer file before proceeding to further  *
016700200529      *            details especially Securities and Futures and      *
016800200529      *            options.                                           *
016900200529      *  237595 - Amend program such that when action code is 'D',    *
017000200529      *           access is allowed to the next screens, enabling the *
017100200529      *           user to delete further customer details (i.e.,      *
017200200529      *           marketing information, etc.).  Applied fix 230859.  *
017300200529      *  CSD031 - Enhanced Centralised Static Data                    *
017400200529      *  BUG8134 - Recompiled source to fix this bug                  *
017500200529      *  CSD027A - Conversion Of Customer Number to Alpha             *
017600200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
017700200529      *  BUG10817 - DB Error upon accessing SDCUX2L0                  *
017800200529      *  BUG10295 - Customer details extension missing                *
017900200529      *  CER001 - LUX Upgrade to MidasPlus                            *
018000200529      *  CSD028 - KYC (Standing Data Authorisations )                 *
018100200529      *  CGL031 - Taxation on Savings Income                          *
018200200529      *  235524 - Show "Message Routing Maintenance" screen on enquiry*
018300200529      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
018400200529      *  BUG6565- Window processing not properly handled in SDCUSDSIN *
018500200529      *  BUG6198 - Cannot save new Details for CUSD (Recompile)       *
018600200529      *  BUG5139 - Unable to process additional customer during       *
018700200529      *            insert                                             *
018800200529      *  CSD025 - Customer De-Activation                              *
018900200529      *  CSW037 - Additional Field Data on MT300/MT320                *
019000200529      *  CSW036 - Dual SWIFT BIC held on Client Details               *
019100200529      *  BUG4454 - Database error when inserting a customer with      *
019200200529      *           additional customer details                         *
019300200529      *  BUG3362 - Added processing for TI details.                   *
019400200529      *  CFX001 - FX Margin Trading                                   *
019500200529      *  CLE025 - Credit Lines                                        *
019600200529      *  BUG2664 - Amend program such that BBTICS is not reset during *
019700200529      *            amendment of TI client.  Apply part of fix 219329. *
019800200529      *  CSD021 - System generated customer number.                   *
019900200529      *  222373 - Parameter Mismatch                                  *
020000200529      *  CGP001 - Global Processing                                   *
020100200529      *  CSD012 - Standing Data Authorisation                         *
020200200529      *  212263 - Complete CPB002 : the call of AOPLCSR0 requires     *
020300200529      *           4 parameters                                        *
020400200529      *           Condition the call : if PM is off, do not call      *
020500200529      *  203036 - If Private Banking Module is not Switched On, don't *
020600200529      *           display screen.                                     *
020700200529      *  202805 - Using API, amended FX Netting Details not updated.  *
020800200529      *  192916 - Rollback of window updates wrongly managed in Core  *
020900200529      *           API's modules RPR and SIN.                          *
021000200529      *  CSC011 - 24x7 Midas Availability                             *
021100200529      *  193883 - Recompile over changed SDCUSDUPD.                   *
021200200529      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
021300200529      *  196149 - Update BBTICS with the value of FDTICS from SD0014V.*
021400200529      *  CRE007 - Base Rate Tax 2001                                  *
021500200529      *  185595 - Impossible to input "Further Details" during Input  *
021600200529      *  CPB002 - New Private Banking Customer Processing.            *
021700200529      *  189774 - Window processing for Customer Details API program  *
021800200529      *  CSD007 - Customer Closing:                                   *
021900200529      *           Allow for action codes 'C' (closure) and 'R'        *
022000200529      *           (release).                                          *
022100200529      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
022200200529      *  CAP014 - Repair function enhancements                        *
022300200529      *  CAP034 - Conversion of SD inputs into modular structure to   *
022400200529      *           use as APIs.                                        *
022500200529      *                                                               *
022600200529      *****************************************************************
022700200529
022800200529     FSDCUSTL5  IF   E           K DISK    INFSR(*PSSR)                                       202805
022900200529      *                                                                                       CER001
023000200529     FSDCUX2L0  IF   E           K DISK    USROPN                                             CER001
023100200529     F                                     RENAME(SDCUSTF6:RTVIDXA)                           CER001
023200200529     F                                     INFSR(*PSSR)                                       CER001
023300200529     F                                     COMMIT                                             CER001
023400200529                                                                                              CER001
023500200529      ** Midas ER Institutions - Economic Sectors                                             CER001
023600200529     FSDINX1L0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
023700200529     F                                     USROPN                                             CER001
023800200529                                                                                              CER001
023900200529      ** Midas ER Country Codes - LU Ext. index                                               CER001
024000200529     FSDCTX2L0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
024100200529     F                                     USROPN                                             CER001
024200200529                                                                                              CER001
024300200529     FSDCUX1L0  IF   E           K DISK    USROPN                                             CER001
024400200529     F                                     RENAME(SDCUSTDL:RTVIDXB)                           CER001
024500200529     F                                     INFSR(*PSSR)                                       CER001
024600200529     F                                     COMMIT                                             CER001
024700200529     FSDACSTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD031
024800200529     F                                     RENAME(SDCUSTD0: SDACSTD1)                         CSD031
024900200529      ** SWIFTRef BANK DIRECTORY Plus                                                         CFT050
025000200529     FMEBIB3L0  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
025100200529      ** Country codes                                                                        CFT050
025200200529     FSDCTRYL3  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
025300200529      ** SWIFT Customer extension                                                             CFT050
025400200529     FSDCSSWL2  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
025500200529
025600200529     F/COPY WNCPYSRC,SDCUSDSF01
025700200529      *****************************************************************
025800200529      ** +--------------------------------------+
025900200529      ** ¦ Automatically included D-specs       ¦
026000200529      ** ¦ ==============================       ¦
026100200529      ** +--------------------------------------+
026200200529      **
026300200529      **--------------------------------------------------------------------------------------------
026400200529      ** The following /COPY line includes (among others) the LDA layout
026500200529      ** and the copyright array definition:
026600200529     D/COPY ZACPYSRC,STD_D_SPEC
026700200529      **--------------------------------------------------------------------------------------------
026800200529
026900200529      **--------------------------------------------------------------------------------------------
027000200529      ** The following /COPY includes the MM standard declares:
027100200529     D/COPY ZACPYSRC,STDDECLARE
027200200529      **--------------------------------------------------------------------------------------------
027300200529
027400200529      **--------------------------------------------------------------------------------------------
027500200529      ** The following /COPY line includes all the defined fields in the
027600200529      ** Program Status Data Structures.  They have meaningful
027700200529      ** names, prefixed by 'PS'.
027800200529     D/COPY ZACPYSRC,PSDS
027900200529      **--------------------------------------------------------------------------------------------
028000200529
028100200529      **--------------------------------------------------------------------------------------------
028200200529      ** The following /COPY line includes the definitions for error and
028300200529      ** warning message arrays.
028400200529     D/COPY ZACPYSRC,ERR_ARRAYS
028500200529      **--------------------------------------------------------------------------------------------
028600200529
028700200529      ** +--------------------------------------+
028800200529      ** ¦ End of automatically included D-specs¦
028900200529      ** ¦ =====================================¦
029000200529      ** +--------------------------------------+
029100200529
029200200529      *****************************************************************
029300200529      /EJECT
029400200529      *****************************************************************
029500200529
029600200529      ** +--------------------------------------+
029700200529      ** ¦ Manually included D-specs            ¦
029800200529      ** ¦ =========================            ¦
029900200529      ** +--------------------------------------+
030000200529
030100200529      ** +--------------------------------------+
030200200529      ** ¦ Named constants                      ¦
030300200529      ** ¦ ===============                      ¦
030400200529      ** +--------------------------------------+
030500200529
030600200529      ** +--------------------------------------+
030700200529      ** ¦ Arrays and Data Structures           ¦
030800200529      ** ¦ ==========================           ¦
030900200529      ** +--------------------------------------+
031000200529
031100200529      * Current Customer in File Format
031200200529     D CrCuFilFmt    E DS                  EXTNAME(SDCUSTPD)
031300200529     D                                     PREFIX(C_)
031400200529
031500200529      * Current Customer - SWIFT Details  in File Format                                      CSW207
031600200529     D CrSwFilFmt    E DS                  EXTNAME(SDCSSWPD)                                  CSW207
031700200529     D                                     PREFIX(C_)                                         CSW207
031800200529                                                                                              CSW207
031900200529     D TranInACU3    E DS                  EXTNAME (SDACU3DPD)                                CER059
032000200529     D TranInACU4    E DS                  EXTNAME (SDACU4DPD)                                CER059
032100200529     D TranInCUAH    E DS                  EXTNAME (SDCUAHDPD)                                CER059
032200200529     D                                     PREFIX(AH)                                         CER059
032300200529     D TranInCCTX    E DS                  EXTNAME (SDCCTXDPD)                                CER059
032400200529     D                                     PREFIX(TX)                                         CER059
032500200529                                                                                              CER059
032600200529      * Current Customer in File Format - Base Rate Tax Details
032700200529     D CrBrFilFmt    E DS                  EXTNAME(SDVCUBRPD)
032800200529     D                                     PREFIX(C_)
032900200529
033000200529      * Current Customer in File Format - Private Banking Details
033100200529     D CrPBFilFmt    E DS                  EXTNAME(SDVCUPBPD)
033200200529     D                                     PREFIX(C_)
033300200529      *                                                                                      BUG3362
033400200529     D CrTIFilFmt    E DS                  EXTNAME(SDVTICDPD)                                BUG3362
033500200529     D                                     PREFIX(C_)                                        BUG3362
033600200529                                                                                             BUG3362
033700200529      ** Current Customer in File Format (VF)                                                 CER001
033800200529     D CrDlFilFmt1   E DS                  EXTNAME(SDCUX2L0)                                  CER001
033900200529      ** Current Customer in File Format (VL)                                                 CER001
034000200529     D CrDlFilFmt2   E DS                  EXTNAME(SDCUX1L0)                                  CER001
034100200529      ** Current Global Customer X-Reference in File Format                                   CGP001
034200200529     D GCrCuFilFmt   E DS                  EXTNAME(GPCUSTXPD)                                 CGP001
034300200529     D                                     PREFIX(CG_)                                        CGP001
034400200529                                                                                              CGP001
034500200529      ** Marketing Information Details in File Format                                         CRE026
034600200529     D CrcmFilFmt    E DS                  EXTNAME(SDCMRKPD)                                  CRE026
034700200529      ** Additional Customer details in File Format                                           CRE026
034800200529     D CracFilFmt    E DS                  EXTNAME(SDACUSPD)                                  CRE026
034900200529      ** Service Fees Details in File Format                                                  CRE026
035000200529     D CrcfFilFmt    E DS                  EXTNAME(SDCFCDPD)                                  CRE026
035100200529     D Q_QQSMAC      E                     EXTFLD(QQSMAC)                                     CRE026
035200200529      ** Cheques and Cards Details in File Format                                             CRE026
035300200529     D CrchFilFmt    E DS                  EXTNAME(SDCHEQPD)                                  CRE026
035400200529      ** Safe details in File Format                                                          CRE026
035500200529     D CrsaFilFmt    E DS                  EXTNAME(SDSAFEPD)                                  CRE026
035600200529      ** Risk weighted assets in Valid File Format                                            CRE026
035700200529     D CrvrFilFmt    E DS                  EXTNAME(SDVRWANPD)                                 CRE026
035800200529      ** Future and option Detail in File Format                                              CRE026
035900200529     D CrfoFilFmt    E DS                  EXTNAME(SDFOCSPD)                                  CRE026
036000200529      ** Future & options European reporting in File Format                                   CRE026
036100200529     D CroxFilFmt    E DS                  EXTNAME(SDFOX1PD)                                  CRE026
036200200529      ** Fiduciary Details in File Format                                                     CRE026
036300200529     D CrplFilFmt    E DS                  EXTNAME(SDPLCSPD)                                  CRE026
036400200529     ** Lux(European Reporting) in file format                                                CRE026
036500200529     D Crx2FilFmt    E DS                  EXTNAME(SDCUX2PD)                                  CRE026
036600200529     D                                     PREFIX(C_)                                         CRE026
036700200529     ** Lux(IBLC - Extended Information) in file format                                       CRE026
036800200529     D Crx1fFilFmt   E DS                  EXTNAME(SDCUX1PD)                                  CRE026
036900200529     D                                     PREFIX(C_)                                         CRE026
037000200529      * Current Customer in Screen Format - Primary Details
037100200529     D CurCuPrim     E DS                  EXTNAME(SDCUPRPD)
037200200529     D                                     PREFIX(@)
037300200529
037400200529      * Current Customer in Screen Format - Swift Extension                                   CSW207
037500200529     D CurCuSwft     E DS                  EXTNAME(SDCUSWPD)                                  CSW207
037600200529     D                                     PREFIX(@)                                          CSW207
037700200529                                                                                              CSW207
037800200529      * Current Customer in Screen Format - Base Rate Tax Details
037900200529     D CurCuBrt      E DS                  EXTNAME(SDCUBRPD)
038000200529     D                                     PREFIX(@)
038100200529
038200200529      * Current Customer in Screen Format - Private Banking Details
038300200529     D CurCuPriv     E DS                  EXTNAME(SDCUPBPD)
038400200529     D                                     PREFIX(@)
038500200529                                                                                             BUG3362
038600200529      * Current TI details Screen Format - TI Details                                        BUG3362
038700200529     D CurTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
038800200529     D                                     PREFIX(@)                                         BUG3362
038900200529
039000200529      * Current Customer in Screen Format - Secondary Details
039100200529     D CurCuSeco     E DS                  EXTNAME(SDCUSEPD)
039200200529     D                                     PREFIX(@)
039300200529      * Current Customer in Screen Format - Message Details
039400200529     D CurCuMsg      E DS                  EXTNAME(SDCUMRPD)
039500200529     D                                     PREFIX(@)
039600200529      *                                                                                       CSW024
039700200529      ** Current Customer in Screen Format - MT3xx BEI Details                                CSW024
039800200529     D CurCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
039900200529     D                                     PREFIX(@)                                          CSW024
040000200529
040100200529      * New Customer in File Format
040200200529     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
040300200529                                                                                              CSW207
040400200529      * New SWIFT Detail in File Format                                                       CSW207
040500200529     D NwSwFilFmt    E DS                  EXTNAME(SDVSWSDPD)                                 CSW207
040600200529
040700200529      * New Customer in File Format - Base Rate Tax Details
040800200529     D NwBrFilFmt    E DS                  EXTNAME(SDVCUBRPD)
040900200529
041000200529      * New Customer in File Format - Private Banking Details
041100200529     D NwPBFilFmt    E DS                  EXTNAME(SDVCUPBPD)
041200200529
041300200529      * New TI Details in File Format                                                        BUG3362
041400200529     D NwTIFilFmt    E DS                  EXTNAME(SDVTICDPD)                                BUG3362
041500200529     D                                     PREFIX(V_)                                        BUG3362
041600200529                                                                                             BUG3362
041700200529      ** New Customer extension in File Format (#6LXVF)                                       CER001
041800200529     D NwDlFilFmt1   E DS                  EXTNAME(SDVCULX2PD)                                CER001
041900200529      ** New Customer extension in File Format (#LLXVL)                                       CER001
042000200529     D NwDlFilFmt2   E DS                  EXTNAME(SDVCULX1PD)                                CER001
042100200529      * New Customer in Screen Format - Primary Details
042200200529     D NewCuPrim     E DS                  EXTNAME(SDCUPRPD)
042300200529      * New Customer in Screen Format - Swift Extension                                       CSW207
042400200529     D NewCuSwft     E DS                  EXTNAME(SDCUSWPD)                                  CSW207
042500200529
042600200529      * New Customer in Screen Format - Base Rate Tax Details
042700200529     D NewCuBrt      E DS                  EXTNAME(SDCUBRPD)
042800200529
042900200529      * New Customer in Screen Format - Private Banking Details
043000200529     D NewCuPriv     E DS                  EXTNAME(SDCUPBPD)
043100200529
043200200529      * New TI Details in Screen Format - TI Details                                         BUG3362
043300200529     D NewTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
043400200529     D                                     PREFIX(N_)                                        BUG3362
043500200529                                                                                             BUG3362
043600200529      * New Customer in Screen Format - Secondary Details
043700200529     D NewCuSeco     E DS                  EXTNAME(SDCUSEPD)
043800200529
043900200529      * New Customer in Screen Format - Message Details
044000200529     D NewCuMsg      E DS                  EXTNAME(SDCUMRPD)
044100200529      *                                                                                       CSW024
044200200529      ** New Customer in Screen Format - MT3xx BEI Details                                    CSW024
044300200529     D NewCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
044400200529
044500200529
044600200529
044700200529      * Previous Customer in Screen Format - Primary Details
044800200529     D PrvCuPrim     E DS                  EXTNAME(SDCUPRPD)
044900200529     D                                     PREFIX(@P)
045000200529
045100200529      * Previous Customer in Screen Format - Base Rate Tax Details
045200200529     D PrvCuBrt      E DS                  EXTNAME(SDCUBRPD)
045300200529     D                                     PREFIX(@P)
045400200529
045500200529      * Previous Customer in Screen Format - Private Banking Details
045600200529     D PrvCuPriv     E DS                  EXTNAME(SDCUPBPD)
045700200529     D                                     PREFIX(@P)
045800200529      * Previous TI Details in screen Format - TI Details                                    BUG3362
045900200529     D PrvTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
046000200529     D                                     PREFIX(@P)                                        BUG3362
046100200529
046200200529      * Previous Customer in Screen Format - Secondary Details
046300200529     D PrvCuSeco     E DS                  EXTNAME(SDCUSEPD)
046400200529     D                                     PREFIX(@P)
046500200529
046600200529      * Previous Customer in Screen Format - Message Details
046700200529     D PrvCuMsg      E DS                  EXTNAME(SDCUMRPD)
046800200529     D                                     PREFIX(@P)
046900200529      *                                                                                       CSW024
047000200529      ** Previous Customer in Screen Format - Message Details                                 CSW024
047100200529     D PrvCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
047200200529     D                                     PREFIX(@P)                                         CSW024
047300200529      ** New SD Customers in Screen Format (#nLX)                                             CER001
047400200529     D NwDlScnFmt    E DS                  EXTNAME(SDCURXPD)                                  CER001
047500200529      ** Current SD Customers in Screen Format (#6LX)                                         CER001
047600200529     D CrDlScnFmt    E DS                  EXTNAME(SDCURXPD)                                  CER001
047700200529     D                                     PREFIX(SS)                                         CER001
047800200529      *                                                                                       CFT050
047900200529      ** Previous Customer in Screen Format - Message Details                                 CFT050
048000200529      *                                                                                       CFT050
048100200529     D***CuSW13        E DS                  EXTNAME(SDSW13PD)                       CFT050 MD022395
048200200529     D NewCuSW13     E DS                  EXTNAME(SDSW13PD)                                MD022395
048300200529     D  S13DDBRCD    E                     EXTFLD(DDBRCD)                                     CFT050
048400200529      *                                                                                     MD022395
048500200529      ** Current SWIFT 2013 Screen Format                                                   MD022395
048600200529      *                                                                                     MD022395
048700200529     D CrCuSW13      E DS                  EXTNAME(SDSW13PD)                                MD022395
048800200529     D                                     PREFIX(C13_)                                     MD022395
048900200529
049000200529
049100200529
049200200529      * Error indicators
049300200529     D OKCuPrim      E DS                  EXTNAME(SDECUPRPD)
049400200529     D OKCuSeco      E DS                  EXTNAME(SDECUSEPD)
049500200529     D OKCuMsg       E DS                  EXTNAME(SDECUMRPD)
049600200529     D OKCuBrt       E DS                  EXTNAME(SDECUBRPD)
049700200529     D OKCuPriv      E DS                  EXTNAME(SDECUPBPD)
049800200529     D OKCuMT3x      E DS                  EXTNAME(SDECUMTPD)                                 CSW024
049900200529     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CSW207
050000200529
050100200529     D/COPY WNCPYSRC,SDH00729
050200200529
050300200529      * Further Details Parameter Data Structure
050400200529     D**FURDETS          DS           565                                                    BUG3362
050500200529     D**FURDETS          DS           701                                            BUG3362 BUG4454
050600200529     D***FURDETS           DS           708                                          BUG4454 BUG5139
050700200529     D***FURDETS          DS           701                                          BUG5139 BUG26917
050800200529     D***FURDETS          DS           709                                        BUG26917 BUG26917A
050900200529     DFURDETS          DS           701                                                    BUG26917A
051000200529     D FDCUST                  1      6
051100200529     D FDCSSN                  7     16
051200200529     D FDCRTN                157    166
051300200529     D FDCRNM                168    187
051400200529     D FDLINC                228    229
051500200529     D FDTICS                564    564
051600200529     D FDCTID                565    700                                                      BUG3362
051700200529     D***FDCRPC*               702    702                                            BUG4454 BUG5139
051800200529     D***FDBRCD*               703    705                                            BUG4454 BUG5139
051900200529     D***FDLICD*               706    708                                            BUG4454 BUG5139
052000200529     D***FDTAIN                709    709                                         BUG26917 BUG26917A
052100200529
052200200529
052300200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
052400200529      ** EXTERNAL DS FOR BANK DETAILS
052500200529
052600200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
052700200529      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
052800200529
052900200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
053000200529     D SCA_LCD       E                     EXTFLD(LCD)
053100200529      ** EXTERNAL DS FOR SAR DETAILS
053200200529
053300200529     D DSFDY         E DS                  EXTNAME(DSFDY)
053400200529      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
053500200529
053600200529     D DSSDY         E DS                  EXTNAME(DSSDY)
053700200529      ** Second DS for access progrmas, long data structure
053800200529
053900200529     D ExtData       E DS                  EXTNAME(SDCUEXPD)
054000200529      * SD Custom Extra Data - File (D/B) format
054100200529                                                                                              CSC011
054200200529      ** SD data area                                                                         CSC011
054300200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
054400200529                                                                                              CSC011
054500200529      ** 24X7 status data area                                                                CSC011
054600200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
054700200529     ** Business Entity Identifier                                                            CFT050
054800200529     D MEBEIS        E DS                  EXTNAME(MEBEISPD)                                  CFT050
054900200529      ** External DS for Customer Details                                                     CFT050
055000200529     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CFT050
055100200529     D                                     PREFIX(PR_)                                        CFT050
055200200529
055300200529      ** Changed Party Names Array
055400200529     D ChgNamArr       S              1    DIM(5)
055500200529
055600200529      **  Data Structure for AOSVALR0 string                                                  CSD012
055700200529     DSVAL1            DS           200                                                       CSD012
055800200529     DSVAL11                   1      1                                                       CSD012
055900200529                                                                                              CSD012
056000200529     D CSD012          S              1A                                                      CSD012
056100200529     D SVALKK          C                   CONST('AuthReqCustomerMaint')                      CSD012
056200200529                                                                                              CSD012
056300200529      ** Override SDAULGL2                                                                    CSD012
056400200529     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
056500200529     D CSD028          S              1A                                                      CSD028
056600200529     D PCustNum        S              6A                                                      CSD028
056700200529                                                                                              CSD012
056800200529     D/COPY QWINDSRC,SDCUSDDTA                                                                189774
056900200529                                                                                              189774
057000200529     D PDATA           DS          1024                                                       CER001
057100200529     D**#1FLD1**               1      6  0                                            CER001 CSD027A
057200200529                                                                                              CER001
057300200529     D  #1CUST                 1      6                                                       CER001
057400200529     D  #1PAIN                 7      7                                                       CER001
057500200529     D  #1PCNB                 8     13                                                       CER001
057600200529     D  #1COLC                15     16                                                       CER001
057700200529     D  #1LINC                17     18                                                       CER001
057800200529     D  #1BRCD                19     21                                                       CER001
057900200529     D  #1BNBI                22     22                                                       CER001
058000200529     D  #2CNCZ                23     24                                                       CER001
058100200529     D  #1FOTR                45     64                                                       CER001
058200200529     D  #1TMST                65     90Z                                                      CER001
058300200529     D  #1CRNM                91    110                                                       CER001
058400200529     D  #1NCOS               111    114                                                       CER001
058500200529                                                                                              CER001
058600200529     D/COPY WNCPYSRC,SDH00485
058700200529      ** +--------------------------------------+
058800200529      ** ¦ Declared variables                   ¦
058900200529      ** ¦ ==================                   ¦
059000200529      ** +--------------------------------------+
059100200529
059200200529      ** Customer Work Field
059300200529     D WKCUST          S                   LIKE(DDCUSN)
059400200529
059500200529      ** Response Mode, passed as a constant parameter to the VAL module
059600200529      ** This is always 'S' for Synchronous
059700200529     D RespMode        S              1A   INZ('S')
059800200529
059900200529      ** Timestamp for the transaction
060000200529     D TimeStamp       S               Z
060100200529                                                                                              CSC011
060200200529      **  Switchable Feature variable                                                         CSC011
060300200529     D***CER048          S              1A                                        BUG26917 BUG26917A
060400200529     D CSC011          S              1                                                       CSC011
060500200529     D CSD021          S              1A                                                      CSD021
060600200529     D CSD037          S              1A   INZ('N')                                           CSD031
060700200529     D CGP001          S              1                                                       CGP001
060800200529     D V_DDGCUS        S             10                                                       CGP001
060900200529     D CSW207          S              1A                                                      CSW207
061000200529                                                                                              CLE025
061100200529     D CLE025          S              1                                                       CLE025
061200200529     D CFX001          S              1                                                       CFX001
061300200529     D DDAPRC          S              1                                                     MD054028
061400200529     D PRTCD           S              7                                                       CLE025
061500200529     D POPTN           S              7                                                       CLE025
061600200529     D PSARD           S              6                                                       CLE025
061700200529     D PMODE           S              1                                                       CLE025
061800200529     D PAccMde         S              1A                                                      CSD031
061900200529     D PUpdYN          S              1A                                                      CSD031
062000200529     D ULX043          S              1                                                       CER001
062100200529     D ULX008          S              1                                                       CER001
062200200529     D ULX012          S              1                                                       CER001
062300200529     D ULX048          S              1                                                       CER001
062400200529     D ULX609          S              1                                                       CER001
062500200529     D ULX004          S              1                                                     BUG13228
062600200529     D LOOP            S              1                                                       CER001
062700200529     D KCUST           S              6                                                       CER001
062800200529     D BRBKCO          S              2S 0                                                    CER001
062900200529      ** Error message fields received as parameters                                          CER001
063000200529     D MSG1            S                   LIKE(#MsgID)                                       CER001
063100200529     D WFIND1          S              1                                                       CER001
063200200529     D WFIND2          S              1                                                       CER001
063300200529     D WPARKEY         S             12A                                                      CFT050
063400200529     D @EINKV          S              1                                                       CFT050
063500200529     D @INKV           S              1                                                       CFT050
063600200529     D WIMODE          S              1                                                       CFT050
063700200529     D WICRIT          S             35                                                       CFT050
063800200529     D WOADD           S            175                                                       CFT050
063900200529     D WOCHIP          S              6                                                       CFT050
064000200529     D WOUTCD          S              2                                                       CFT050
064100200529     D WRTCD           S              7                                                       CFT050
064200200529     D CSW213          S              1                                                       CSW213
064300200529     D***CSW204*         S              1                                            CFT050 MD022463
064400200529     D CSW024          S              1                                                     MD022463
064500200529     D SVCNCZ          S              2A                                                      CFT050
064600200529     D SVCOLC          S              2A                                                      CFT050
064700200529     D SVCLSY          S              2A                                                      CFT050
064800200529     D PBICD           S              4A                                                      CFT050
064900200529     D @KEY1           S             10A                                                      CFT050
065000200529     D @KYST           S              7A                                                      CFT050
065100200529     D CFT050          S              1                                                     MD022463
065200200529
065300200529      ** +--------------------------------------+
065400200529      ** ¦ End of D-specs                       ¦
065500200529      ** ¦ ==============                       ¦
065600200529      ** +--------------------------------------+
065700200529
065800200529      ** +----------------------------------------+
065900200529      ** ¦ Hook for non-core D-specs (all types)  ¦
066000200529      ** ¦ also any I-specs (if necessary)        ¦
066100200529      ** ¦ =====================================  ¦
066200200529      ** +----------------------------------------+
066300200529      /COPY WNCPYSRC,SDCUSDS001
066400200529
066500200529     D DDTMESTMP       S             26Z                                                      CER001
066600200529     D DDFOTRANID      S             20                                                       CER001
066700200529                                                                                              CER001
066800200529      **  Rename fields to differentiate SDCUSTPD from CrCuFilFmt.                            202805
066900200529     I@CUSTFT                                                                                 202805
067000200529     I              BBNET                       W@NET                                         202805
067100200529     I              BBNTGP                      W@NTGP                                        202805
067200200529     I              BBNTCP                      W@NTCP                                        202805
067300200529     I              BBNTND                      W@NTND                                        202805
067400200529     I              BBNTMM                      W@NTMM                                        202805
067500200529     I              BBTMST                      W@TMST                                        202805
067600200529      *                                                                                       202805
067700200529     ISDACSTD1                                                                                CSD031
067800200529     I              BBNET                       W@NET                                         CSD031
067900200529     I              BBNTGP                      W@NTGP                                        CSD031
068000200529     I              BBNTCP                      W@NTCP                                        CSD031
068100200529     I              BBNTND                      W@NTND                                        CSD031
068200200529     I              BBNTMM                      W@NTMM                                        CSD031
068300200529     I              BBTMST                      W@TMST                                        CSD031
068400200529      *****************************************************************
068500200529      /EJECT
068600200529      *****************************************************************
068700200529     C
068800200529      ** +--- Start of Main processing -----------------------------------+
068900200529      ** ¦                                                                ¦
069000200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
069100200529      ** ¦ executed at program activation.                                ¦
069200200529      ** ¦                                                                ¦
069300200529      ** +----------------------------------------------------------------+
069400200529      *
069500200529      /COPY WNCPYSRC,SDCUSDS002
069600200529      *
069700200529      * Issue rollback to clear any possible updates in window functions
069800200529      *
069900200529     C     @INKL         IFEQ      '1'
070000200529     C                   ROLBK
070100200529     C                   END
070200200529      *
070300200529     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
070400200529     C                   IF        @INKL = ' '                                                CSD028
070500200529     C                   MOVEL     PCustNum      DDCUSN                                       CSD028
070600200529     C                   MOVEL     'A'           DDACTN                                       CSD028
070700200529     C                   MOVEL     'A'           @OPSEL                                       CSD028
070800200529     C                   EXSR      VAL@K                                                      CSD028
070900200529     C                   ELSE                                                                 CSD028
071000200529     C                   EVAL      @SCRN = 'T'                                                CSD028
071100200529     C                   ENDIF                                                                CSD028
071200200529     C                   ENDIF                                                                CSD028
071300200529      *                                                                                       CSD028
071400200529      /COPY WNCPYSRC,SDCUSDS003
071500200529      *
071600200529      ** Build browse subfile record
071700200529      *
071800200529     C     @SCRN         IFEQ      'B'
071900200529     C                   EXSR      BLDBRW
072000200529     C                   ENDIF
072100200529      *
072200200529      ** Read next browse subfile record
072300200529      *
072400200529     C     @SCRN         IFEQ      'R'
072500200529     C                   EXSR      RDNBRW
072600200529     C                   ENDIF
072700200529      *
072800200529      /COPY WNCPYSRC,SDCUSDS004
072900200529      *
073000200529      ** DO WHILE screen: Key Details Screen
073100200529      *
073200200529     C                   Z-ADD     *ZERO         WIdx_KVAL         3 0
073300200529     C     @SCRN         DOWEQ     'K'
073400200529     C                   EXSR      Scrn@K
073500200529     C                   ENDDO
073600200529      *
073700200529      /COPY WNCPYSRC,SDCUSDS005
073800200529      *
073900200529      ** DO WHILE screen: Primary Details Screen
074000200529      *
074100200529     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
074200200529     C     @SCRN         DOWEQ     'P'
074300200529     C                   EXSR      Scrn@P
074400200529     C                   ENDDO
074500200529      *
074600200529      /COPY WNCPYSRC,SDCUSDS006
074700200529      *
074800200529      ** DO WHILE screen: Base Rate Tax Details
074900200529      *
075000200529     C                   Z-ADD     *ZERO         WIdx_BVAL         3 0
075100200529     C                   Z-ADD     *ZERO         WIdx_TVAL         3 0
075200200529     C     @SCRN         DOWEQ     'X'
075300200529     C                   EXSR      Scrn@B
075400200529     C                   ENDDO
075500200529      *
075600200529      /COPY WNCPYSRC,SDCUSDS007
075700200529      *
075800200529      ** DO WHILE screen: Secondary Details Screen
075900200529      *
076000200529     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
076100200529     C     @SCRN         DOWEQ     'S'
076200200529     C                   EXSR      Scrn@S
076300200529     C                   ENDDO
076400200529      *
076500200529      /COPY WNCPYSRC,SDCUSDS008
076600200529      *                                                                                       CSW024
076700200529      ** DO WHILE screen: MT3xx BEI Details Screen                                            CSW024
076800200529      *                                                                                       CSW024
076900200529     C                   Z-ADD     *ZERO         WIdx_FVAL         3 0                        CSW024
077000200529     C     @SCRN         DOWEQ     'F'                                                        CSW024
077100200529     C                   EXSR      SCRN@F                                                     CSW024
077200200529     C                   ENDDO                                                                CSW024
077300200529     C/COPY WNCPYSRC,SDH00601
077400200529      *
077500200529      ** DO WHILE screen: Message Details Screen
077600200529      *
077700200529     C                   Z-ADD     *ZERO         WIdx_MVAL         3 0
077800200529     C     @SCRN         DOWEQ     'M'
077900200529     C                   EXSR      SCRN@M
078000200529     C                   ENDDO
078100200529      *
078200200529      /COPY WNCPYSRC,SDCUSDS009
078300200529      ** If Private Banking Module is On                                                      203036
078400200529      *
078500200529      ** DO WHILE screen: Private Banking Details
078600200529     C     BGN4ST        IFEQ      'Y'                                                        203036
078700200529      *
078800200529     C     @SCRN         DOWEQ     'I'
078900200529     C                   EXSR      Scrn@R
079000200529     C                   ENDDO
079100200529     C                   ENDIF                                                                203036
079200200529      *                                                                                       CER001
079300200529      ** DO WHILE screen: Extension Details                                                   CER001
079400200529      *                                                                                       CER001
079500200529     C                   DOW       @SCRN = 'L'                                                CER001
079600200529     C                   EXSR      SRSCRN@L                                                   CER001
079700200529     C                   ENDDO                                                                CER001
079800200529      *
079900200529      /COPY WNCPYSRC,SDCUSDS014                                                               189774
080000200529      *                                                                                       189774
080100200529      ** Do window processing                                                                 189774
080200200529      *                                                                                       189774
080300200529      ** If Private Banking Module is on display window on top of Private                     203036
080400200529      ** Banking Screen                                                                       203036
080500200529      *                                                                                       203036
080600200529     C     BGN4ST        IFEQ      'Y'                                                        203036
080700200529     C     @SCRN         DOWEQ     'W'                                                        189774
080800200529     C                   EXSR      Scrn@W                                                     189774
080900200529     C                   ENDDO                                                                189774
081000200529      *                                                                                       203036
081100200529      ** If Private Banking Module is not on display widow on to                              203036
081200200529      ** Message details Screen.                                                              203036
081300200529     C                   ELSE                                                                 203036
081400200529     C     @SCRN         DOWEQ     'W'                                                        203036
081500200529     C                   EXSR      Scrn@W2                                                    203036
081600200529     C                   ENDDO                                                                203036
081700200529     C                   ENDIF                                                                203036
081800200529      ** Display Bank Directory Plus screen                                                   CFT050
081900200529     C**********         IF        CSW213 = 'Y'                                      CFT050 MD022463
082000200529     C                   IF        CFT050 = 'Y'                                             MD022463
082100200529     C     @SCRN         DOWEQ     'E'                                                        CFT050
082200200529     C                   EXSR      SRScrnPL                                                   CFT050
082300200529     C                   ENDDO                                                                CFT050
082400200529     C                   ENDIF                                                                CFT050
082500200529      *                                                                                       189774
082600200529      /COPY WNCPYSRC,SDCUSDS010
082700200529      *
082800200529      ** Do File updates
082900200529      *
083000200529     C     @SCRN         IFEQ      'U'
083100200529     C                   EXSR      UPDATS
083200200529     C                   ENDIF
083300200529      *
083400200529      /COPY WNCPYSRC,SDCUSDS011
083500200529      *
083600200529      ** Terminate program
083700200529      *
083800200529     C     @SCRN         IFEQ      'T'
083900200529     C                   ROLBK                                                                192916
084000200529     C                   MOVE      *ON           *INLR
084100200529     C                   ENDIF
084200200529      *
084300200529      *****************************************************************
084400200529
084500200529      * Hook to enable non-core subroutines to be included
084600200529      /COPY WNCPYSRC,SDCUSDS012
084700200529
084800200529      /EJECT
084900200529      *****************************************************************
085000200529      * SCRN@K - PROCESS SCREEN: KEY DETAILS
085100200529      *****************************************************************
085200200529     C     SCRN@K        BEGSR
085300200529      *                                                                                       248913
085400200529     C                   EXSR      SFKEYS                                                     248913
085500200529      *
085600200529      * Reset customer number if there are no errors
085700200529     C     Idx           IFEQ      0
085800200529     C                   MOVE      *BLANKS       DDCUSN
085900200529     C                   ENDIF
086000200529      *
086100200529      * Set F7/F8 called from Insert mode flag
086200200529     C                   MOVE      'Y'           INSERTENQ
086300200529      *
086400200529      ** WRITE/READ DISPLAY SCREEN - Key Details
086500200529      *
086600200529     C                   CALLB     'SDCUSD1DP'
086700200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
086800200529      * INPUT PARAMETERS :
086900200529      * Return code
087000200529     C                   PARM      *BLANK        RetCodeOut
087100200529      *
087200200529      * Customer (IN SCREEN FORMAT - Primary)
087300200529     C                   PARM                    NewCuPrim
087400200529      *
087500200529      * Fields in error
087600200529     C                   PARM                    OKCuPrim
087700200529      *
087800200529      * ERRORS
087900200529     C                   PARM                    FldNameArr
088000200529     C                   PARM                    MsgIdArr
088100200529     C                   PARM                    MsgDtaArr
088200200529      *
088300200529      * WARNINGS
088400200529     C                   PARM                    WFldNamArr
088500200529     C                   PARM                    WMsgIdArr
088600200529     C                   PARM                    WMsgDtaArr
088700200529      *
088800200529      * ENABLED KEY FIELDS
088900200529      * ENABLED DETAIL FIELDS
089000200529     C                   PARM                    @EKYFD            1
089100200529     C                   PARM                    @EDTFD            1
089200200529      *
089300200529      * ENABLED FUNCTION KEYS
089400200529      * KG = COMMAND KEY 07 = READ PREVIOUS
089500200529     C**********         PARM      'Y'           @EINKG            1                          248913
089600200529     C                   PARM                    @EINKG            1                          248913
089700200529      * KH = COMMAND KEY 08 = READ NEXT
089800200529     C**********         PARM      'Y'           @EINKH            1                          248913
089900200529     C                   PARM                    @EINKH            1                          248913
090000200529      *
090100200529      * OUTPUT PARAMETERS :
090200200529      * Function Keys
090300200529     C                   PARM      '0'           @INKC             1
090400200529     C                   PARM      '0'           @INKG             1
090500200529     C                   PARM      '0'           @INKH             1
090600200529     C                   PARM      '0'           @INKL             1
090700200529      *
090800200529      * Write screen with no read indicator
090900200529     C                   PARM      'N'           WriteOnly         1
091000200529                                                                                              CSD021
091100200529     C                   PARM                    WWCNUM            6                          CSD021
091200200529      *
091300200529      * RESET ERRORS ....
091400200529      *
091500200529     C                   MOVE      *ALL'Y'       OKCuPrim
091600200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
091700200529     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
091800200529     C                   ENDIF                                                                CSW207
091900200529     C/COPY WNCPYSRC,SDH00730
092000200529     C                   MOVEL     *BLANK        FldNameArr
092100200529     C                   MOVEL     *BLANK        MsgIdArr
092200200529     C                   MOVEL     *BLANK        MsgDtaArr
092300200529     C                   MOVEL     *BLANK        WFldNamArr
092400200529     C                   MOVEL     *BLANK        WMsgIdArr
092500200529     C                   MOVEL     *BLANK        WMsgDtaArr
092600200529      *
092700200529      * F3 - End Program
092800200529     C     @INKC         CASEQ     '1'           ENDP
092900200529      *
093000200529      * F7 - Roll Backwards
093100200529     C     @INKG         CASEQ     '1'           ROLL
093200200529      *
093300200529      * F8 - Roll Forwards
093400200529     C     @INKH         CASEQ     '1'           ROLL
093500200529      *
093600200529      * F12 - Cancel on Key Screen
093700200529     C     @INKL         CASEQ     '1'           CANC@K
093800200529      *
093900200529      * Validate input to Key screen
094000200529     C                   CAS                     VAL@K
094100200529      *
094200200529     C                   ENDCS
094300200529      *
094400200529     C                   ENDSR
094500200529      *****************************************************************
094600200529      /EJECT
094700200529      *****************************************************************
094800200529      * VAL@K  - VALIDATE INPUT TO KEY SCREEN
094900200529      *****************************************************************
095000200529     C     VAL@K         BEGSR
095100200529      *                                                                                       CSD021
095200200529     C                   MOVE      *BLANK        WWCNUM                                       CSD021
095300200529      *
095400200529      * Retrieve Customer details
095500200529      *
095600200529     C                   EXSR      RTVCUS
095700200529      *
095800200529      * If primary fields are NOT OK
095900200529      * Re-output screen with error messages on it
096000200529      *
096100200529     C     DDACTNOK      IFEQ      'N'
096200200529     C     DDCUSNOK      OREQ      'N'
096300200529     C                   GOTO      EndVAL@K
096400200529     C                   END
096500200529      *                                                                         CPB002
096600200529      * Check if customer is a Portfolio Management customer.                   CPB002
096700200529     C                   EXSR      CHKPTFR                                      CPB002
096800200529      *
096900200529      *
097000200529      * If action code is not insert
097100200529      *  .. Convert the customer to screen format
097200200529      *  .. Update the customer in file format
097300200529      *  .. Go to Primary details screen
097400200529      *
097500200529     C     DDACTN        IFNE      'I'
097600200529     C                   EXSR      CVTCUS
097700200529     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
097800200529     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
097900200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
098000200529     C                   MOVEL     CrSwFilFmt    NwSwFilFmt                                   CSW207
098100200529     C                   ENDIF                                                                CSW207
098200200529     C/COPY WNCPYSRC,SDH00731
098300200529     C                   IF        CSW213 = 'Y'                                             MD022395
098400200529     C                   EVAL      DDLEIC = C_CSLEIC                                        MD022395
098500200529     C                   EVAL      DDCLSY = C_CSCLSY                                        MD022395
098600200529     C                   EVAL      DDCLID = C_CSCLID                                        MD022395
098700200529     C                   ENDIF                                                              MD022463
098800200529     C                   IF        CFT050 = 'Y'                                             MD022463
098900200529     C                   EVAL      DDBDRK = C_CSBDRK                                        MD022395
099000200529     C                   ENDIF                                                              MD022395
099100200529     C                   MOVEL     'P'           @SCRN
099200200529     C                   EXSR      SFDS@P
099300200529     C                   MOVEL     CrTIFilFMt    NwTIFilFmt                                  BUG3362
099400200529     C                   MOVEL     CrTIFilFMt    FDCTID                                       244030
099500200529     C                   GOTO      EndVAL@K
099600200529     C                   END
099700200529      *
099800200529      * Clear any warning messages
099900200529      *
100000200529     C                   CLEAR                   NwCuFilFmt
100100200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
100200200529     C                   CLEAR                   NwSwFilFmt                                   CSW207
100300200529     C                   CLEAR                   CurCuSwft                                   CSW207A
100400200529     C                   CLEAR                   NewCuSwft                                   CSW207A
100500200529     C                   ENDIF                                                                CSW207
100600200529     C                   IF        CSW213 = 'Y'                                             MD022395
100700200529     C                   CLEAR                   NewCuSW13                                  MD022395
100800200529     C                   ENDIF                                                              MD022395
100900200529     C                   CLEAR                   NwBrFilFmt
101000200529     C                   CLEAR                   CrCuFilFmt
101100200529     C                   CLEAR                   CrBrFilFmt
101200200529     C                   CLEAR                   CrPbFilFmt
101300200529     C                   CLEAR                   CrTIFilFMt                                  BUG3362
101400200529     C                   CLEAR                   FURDETS                                      244030
101500200529      *                                                                                      BUG3362
101600200529     C                   MOVEL     DDCUSN        WKCUST
101700200529     C                   CLEAR                   CurCuPrim
101800200529     C                   CLEAR                   CurCuBrt
101900200529     C                   CLEAR                   CurCuPriv
102000200529     C                   CLEAR                   CurCuSeco
102100200529     C                   CLEAR                   CurCuMsg
102200200529     C                   CLEAR                   CurCuMT3x                                    CSW024
102300200529     C                   CLEAR                   NewCuPrim
102400200529     C                   CLEAR                   NewCuBrt
102500200529     C                   CLEAR                   NewCuPriv
102600200529     C                   CLEAR                   NewCuSeco
102700200529     C                   MOVEL     *BLANK        DDLEIC                                       CSW213
102800200529     C                   CLEAR                   NewCuMsg
102900200529     C                   CLEAR                   NewCuMT3x                                    CSW024
103000200529     C                   MOVEL     WKCUST        DDCUSN
103100200529     C                   MOVEL     'I'           DDACTN
103200200529     C                   MOVE      *ALL'Y'       OKCuPrim
103300200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
103400200529     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
103500200529     C                   ENDIF                                                                CSW207
103600200529     C                   MOVE      *ALL'Y'       OKCuSeco
103700200529     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
103800200529     C                   MOVEL     *BLANK        WFldNamArr
103900200529     C                   MOVEL     *BLANK        WMsgIdArr
104000200529     C                   MOVEL     *BLANK        WMsgDtaArr
104100200529     C/COPY WNCPYSRC,SDCUSDSC07
104200200529      *
104300200529      * Go to Primary Details screen
104400200529      *
104500200529     C                   MOVEL     'P'           @SCRN
104600200529     C                   EXSR      SFDS@P
104700200529     C                   MOVEL     CrTIFilFMt    NwTIFilFmt                                  BUG3362
104800200529     C                   MOVEL     CrTIFilFMt    FDCTID                                       244030
104900200529      *
105000200529     C     EndVAL@K      ENDSR
105100200529      *****************************************************************
105200200529      /EJECT
105300200529      *****************************************************************
105400200529      * SFDS@P - SET FIELD STATUS ON PRIMARY SCREEN
105500200529      *****************************************************************
105600200529     C     SFDS@P        BEGSR
105700200529      *
105800200529      * Enable/disable fields on primary screen
105900200529      *
106000200529     C     DDACTN        IFEQ      'I'
106100200529     C     DDACTN        OREQ      'A'
106200200529     C                   MOVEL     'Y'           @EKYFD
106300200529     C                   MOVEL     'Y'           @EDTFD
106400200529     C                   ELSE
106500200529     C                   MOVEL     'N'           @EKYFD
106600200529     C                   MOVEL     'N'           @EDTFD
106700200529     C                   END
106800200529      *
106900200529     C                   ENDSR
107000200529      *****************************************************************
107100200529      /EJECT
107200200529      *****************************************************************
107300200529      * SCRN@P - PROCESS PRIMARY SCREEN
107400200529      *****************************************************************
107500200529     C     SCRN@P        BEGSR
107600200529
107700200529      * Set function key status on PRIMARY screen
107800200529      *
107900200529     C                   EXSR      SFKEYS
108000200529      *
108100200529      ** Default Private Banking Customer Indicator to an 'N' for insert
108200200529      *
108300200529     C                   IF        DDACTN = 'I' and BGN4ST = 'Y'
108400200529     C                   EVAL      DDPRBA = 'N'
108500200529     C                   END
108600200529                                                                                              CSD031
108700200529      ** Hide further details if the customer came from the acceptance subfile.               CSD031
108800200529                                                                                              CSD031
108900200529     C                   IF        CSD037 = 'Y' AND                                           CSD031
109000200529     C                             PAccMde = 'A'                                              CSD031
109100200529     C                   EVAL      @EINKX = 'N'                                               CSD031
109200200529     C                   ENDIF                                                                CSD031
109300200529      *
109400200529      ** WRITE/READ DISPLAY SCREEN - Primary Details
109500200529      *
109600200529     C                   CALLB     'SDCUSD2DP'
109700200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
109800200529      * INPUT PARAMETERS :
109900200529      * Return code
110000200529     C                   PARM      *BLANK        RetCodeOut
110100200529      * Customer (IN SCREEN FORMAT - Primary )
110200200529     C                   PARM                    NewCuPrim
110300200529      * Fields in error
110400200529     C                   PARM                    OKCuPrim
110500200529     C/COPY WNCPYSRC,SDH00732
110600200529      * Errors
110700200529     C                   PARM                    FldNameArr
110800200529     C                   PARM                    MsgIdArr
110900200529     C                   PARM                    MsgDtaArr
111000200529      * Warnings
111100200529     C                   PARM                    WFldNamArr
111200200529     C                   PARM                    WMsgIdArr
111300200529     C                   PARM                    WMsgDtaArr
111400200529      * ENABLED KEY & DETAIL FIELDS
111500200529     C                   PARM                    @EKYFD            1
111600200529     C                   PARM                    @EDTFD            1
111700200529      * ENABLED Function Keys
111800200529      * KG = COMMAND KEY 07 = READ PREVIOUS
111900200529      * KH = COMMAND KEY 08 = READ NEXT
112000200529      * KJ = COMMAND KEY 10 = CONFIRM DELETE
112100200529      * KW = COMMAND KEY 22 = CONFIRM CLOSURE OR RELEASE                                      CSD007
112200200529      * KX = COMMAND KEY 23 = FURTHER DETAILS
112300200529     C                   PARM                    @EINKG
112400200529     C                   PARM                    @EINKJ            1
112500200529     C                   PARM                    @EINKW            1                          CSD007
112600200529     C                   PARM                    @EINKX            1
112700200529     C                   PARM                    @EINKV                                       CFT050
112800200529                                                                                              CLE025
112900200529      ** Switchable features                                                                  CLE025
113000200529                                                                                              CLE025
113100200529     C                   PARM                    CLE025                                       CLE025
113200200529     C                   PARM                    CFX001                                       CFX001
113300200529     C**********         PARM                    CSD037                              CSD031 BUG11907
113400200529     C                   PARM                    TransType                                    CSD028
113500200529      *                                                                                     BUG11907
113600200529      ** Move parameter CSD037 after TransType                                              BUG11907
113700200529      *                                                                                     BUG11907
113800200529     C                   PARM                    CSD037                                     BUG11907
113900200529      * Customer (IN SCREEN FORMAT - SWIFT Extension)                                         CSW207
114000200529     C                   PARM                    NewCuSwft                                    CSW207
114100200529      * Fields in error SWIFT Details                                                         CSW207
114200200529     C                   PARM                    OKCuSwft                                     CSW207
114300200529      ** Linkage record key                                                                   CFT050
114400200529     C                   PARM                    DDBDRK                                       CFT050
114500200529      *
114600200529      * OUTPUT PARAMETERS :
114700200529      * FUNCTION KEYS
114800200529     C                   PARM      '0'           @INKC
114900200529     C                   PARM      '0'           @INKG
115000200529     C                   PARM      '0'           @INKH
115100200529     C                   PARM      '0'           @INKJ             1
115200200529     C                   PARM      '0'           @INKL
115300200529     C/COPY WNCPYSRC,SDH00104
115400200529     C                   PARM      '0'           @INKW             1                          CSD007
115500200529     C                   PARM      '0'           @INKX             1
115600200529     C                   PARM      '0'           @INKV                                        CFT050
115700200529      * Write screen with no read indicator
115800200529     C                   PARM      'N'           WriteOnly
115900200529      ** Acceptance Mode                                                                      CSD031
116000200529     C                   PARM                    PAccMde                                      CSD031
116100200529      *
116200200529      * RESET ERRORS ....
116300200529      *
116400200529     C     DDCUSNOK      IFNE      'N'
116500200529     C                   MOVE      *ALL'Y'       OKCuPrim
116600200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
116700200529     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
116800200529     C                   ENDIF                                                                CSW207
116900200529     C                   MOVEL     *BLANK        FldNameArr
117000200529     C                   MOVEL     *BLANK        MsgIdArr
117100200529     C                   MOVEL     *BLANK        MsgDtaArr
117200200529     C                   MOVEL     *BLANK        WFldNamArr
117300200529     C                   MOVEL     *BLANK        WMsgIdArr
117400200529     C                   MOVEL     *BLANK        WMsgDtaArr
117500200529     C                   ENDIF
117600200529
117700200529      *
117800200529      * F3 - End Program
117900200529     C     @INKC         CASEQ     '1'           ENDP
118000200529      *
118100200529      * F7 - Roll Backwards
118200200529     C     @INKG         CASEQ     '1'           ROLL
118300200529      *
118400200529      * F8 - Roll Forwards
118500200529     C     @INKH         CASEQ     '1'           ROLL
118600200529      *
118700200529      * F12 - Cancel on Primary Screen
118800200529     C     @INKL         CASEQ     '1'           CANC@P
118900200529      *
119000200529      * Validate Input to Primary Screen
119100200529     C                   CAS                     VAL@P
119200200529      *
119300200529     C                   ENDCS
119400200529     C/COPY WNCPYSRC,SDH00105
119500200529      *
119600200529      * On F23, go to Further Details, if no errors on this screen
119700200529      *
119800200529     C     @INKX         IFEQ      '1'
119900200529     C     Idx           ANDEQ     0
120000200529     C     @INKX         OREQ      '1'                                                        237595
120100200529     C     Idx           ANDNE     0                                                          237595
120200200529     C     DDACTN        ANDEQ     'D'                                                        237595
120300200529     C                   EXSR      FURDET
120400200529     C                   ENDIF
120500200529
120600200529     C                   ENDSR
120700200529      *****************************************************************
120800200529      /EJECT
120900200529      *****************************************************************
121000200529      * VAL@P  - VALIDATE INPUT TO PRIMARY SCREEN
121100200529      *****************************************************************
121200200529     C     VAL@P         BEGSR
121300200529      ** If F21 was pressed go to Bank Directory Plus screen                                  CFT050
121400200529     C                   IF        @INKV = '1'                                                CFT050
121500200529     C                   EVAL      @SCRN = 'E'                                                CFT050
121600200529     C                   GOTO      EndVAL@P                                                   CFT050
121700200529     C                   ENDIF                                                                CFT050
121800200529      *
121900200529      * If customer number is NOT OK
122000200529      * Re-output screen with error message on it
122100200529      *
122200200529     C     DDCUSNOK      IFEQ      'N'
122300200529     C                   GOTO      EndVAL@P
122400200529     C                   END
122500200529      *
122600200529      * Prior to validation, initialize error indicators as 'OK'
122700200529      *
122800200529     C                   Z-ADD     *ZERO         Idx               3 0
122900200529     C/COPY WNCPYSRC,SDH00733
123000200529     C                   Z-ADD     *ZERO         WIdx_PVAL
123100200529     C/COPY WNCPYSRC,SDH00734
123200200529     C                   MOVE      *ALL'Y'       OKCuPrim
123300200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
123400200529     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
123500200529     C                   ENDIF                                                                CSW207
123600200529      *
123700200529      *
123800200529      * Determine whether BRT customer and initialise controls
123900200529      *
124000200529     C     S01383        IFEQ      'Y'
124100200529     C     DDTAIN        IFEQ      'I'
124200200529     C     DDTAIN        OREQ      'J'
124300200529     C     DDTAIN        OREQ      'R'                                                        CRE007
124400200529     C                   MOVE      '1'           BRTSCREEN
124500200529     C                   MOVEA     *BLANKS       ChgNamArr
124600200529     C                   ENDIF
124700200529     C                   ENDIF
124800200529      *
124900200529      *----------------------------------------------------------------
125000200529      * IF DELETE
125100200529      *
125200200529     C     DDACTN        IFEQ      'D'
125300200529      *
125400200529      * IF F10 TAKEN, GO ON TO UPDATES
125500200529      *
125600200529     C     @INKJ         IFEQ      '1'
125700200529     C                   EXSR      RTVCUS                                                     237595
125800200529     C     DDCUSNOK      IFNE      'N'                                                        237595
125900200529     C                   MOVEL     'U'           @SCRN
126000200529     C                   ENDIF                                                                237595
126100200529     C/COPY WNCPYSRC,SDCUSDSC17
126200200529     C                   END
126300200529     C                   GOTO      EndVAL@P
126400200529     C                   END
126500200529      *
126600200529      *----------------------------------------------------------------                       CSD007
126700200529      * IF CLOSURE OR RELEASE                                                                 CSD007
126800200529      *                                                                                       CSD007
126900200529     C     DDACTN        IFEQ      'C'                                                        CSD007
127000200529     C     DDACTN        OREQ      'R'                                                        CSD007
127100200529      *                                                                                       CSD007
127200200529      * IF F22 TAKEN, GO ON TO UPDATES                                                        CSD007
127300200529      *                                                                                       CSD007
127400200529     C     @INKW         IFEQ      '1'                                                        CSD007
127500200529     C                   MOVEL     'U'           @SCRN                                        CSD007
127600200529     C/COPY WNCPYSRC,SDCUSDSC18
127700200529     C                   ELSE                                                                 CSD007
127800200529      * WARNING MESSAGE                                                                       CSD007
127900200529     C                   ENDIF                                                                CSD007
128000200529     C                   GOTO      EndVAL@P                                                   CSD007
128100200529     C                   ENDIF                                                                CSD007
128200200529      *                                                                                       CSD007
128300200529      *----------------------------------------------------------------
128400200529      * IF ENQUIRE
128500200529      *
128600200529     C     DDACTN        IFEQ      'E'
128700200529                                                                                              CSD031
128800200529      ** Skip further screens if the customer came from the acceptance subfile.               CSD031
128900200529                                                                                              CSD031
129000200529     C                   IF        CSD037 = 'Y' AND                                           CSD031
129100200529     C                             PAccMde = 'A'                                              CSD031
129200200529     C**********         MOVEL     'B'           @SCRN                               CSD031 BUG11917
129300200529     C                   MOVEL     'R'           @SCRN                                      BUG11917
129400200529     C                   GOTO      EndVAL@P                                                   CSD031
129500200529     C                   ENDIF                                                                CSD031
129600200529      *
129700200529      * If Further Details (F23) has not been selected:
129800200529     C     @INKX         IFEQ      '0'
129900200529      *
130000200529      * If Base Rate Tax is ON
130100200529     C     S01383        IFEQ      'Y'
130200200529      *
130300200529      **If*account*holder*type*I*or*J,*display*participant*details**                          CRE007
130400200529      * If account holder type I, J, or R display participant details                         CRE007
130500200529     C     DDTAIN        IFEQ      'I'
130600200529     C     DDTAIN        OREQ      'J'
130700200529     C     DDTAIN        OREQ      'R'                                                        CRE007
130800200529     C                   MOVE      'X'           @SCRN
130900200529     C                   ELSE
131000200529     C                   MOVE      'S'           @SCRN
131100200529     C                   ENDIF
131200200529      *
131300200529      * If Base Rate Tax is OFF, go to message details screen
131400200529     C                   ELSE
131500200529     C                   MOVE      'S'           @SCRN
131600200529     C                   ENDIF
131700200529      *
131800200529      * If Further Details (F23) has been selected:
131900200529     C                   ELSE
132000200529      *
132100200529      * Return to Primary Detail Screen after Further Details
132200200529     C                   MOVE      'P'           @SCRN
132300200529      *
132400200529     C                   ENDIF
132500200529      *
132600200529     C                   GOTO      EndVAL@P
132700200529      *
132800200529     C                   ENDIF
132900200529      *
133000200529      *----------------------------------------------------------------
133100200529      * IF INSERT OR AMEND / CHANGE
133200200529      *
133300200529     C     DDACTN        IFEQ      'I'
133400200529     C     DDACTN        OREQ      'A'
133500200529
133600200529      * Validate Primary Customer Details
133700200529
133800200529
133900200529      * Update 'previous' screens and previous number of warnings
134000200529
134100200529     C/COPY WNCPYSRC,SDH00735
134200200529     C                   MOVEL     NewCuPrim     PrvCuPrim
134300200529     C                   Z-ADD     WIdx_PVAL     PrvN_Warn         3 0
134400200529
134500200529
134600200529     C                   CALLB     'SDCUSD2VL'
134700200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
134800200529      * INPUTS :
134900200529      * Response mode
135000200529     C                   PARM                    RespMode
135100200529      ** Customer Primary Details
135200200529     C                   PARM                    NewCuPrim
135300200529      * Customer Extra Data file data
135400200529     C                   PARM                    ExtData
135500200529                                                                                              CLE025
135600200529      ** Switchable features                                                                  CLE025
135700200529                                                                                              CLE025
135800200529     C                   PARM                    CLE025                                       CLE025
135900200529     C                   PARM                    CFX001                                       CFX001
136000200529      ** Customer Primary Details                                                             CSW207
136100200529     C                   PARM                    NewCuSwft                                    CSW207
136200200529      *
136300200529      * OUTPUTS :
136400200529      *
136500200529      ** Customer Primary Details OK inds
136600200529     C                   PARM                    OKCuPrim
136700200529     C/COPY WNCPYSRC,SDH00736
136800200529      * Error fields/message IDs/message data (arrays) from/to caller
136900200529     C                   PARM                    FldNameArr
137000200529     C                   PARM                    MsgIDArr
137100200529     C                   PARM                    MsgDtaArr
137200200529      * Array index (3P0) from/to caller
137300200529     C                   PARM                    Idx
137400200529      * Warning fields/message IDs/message data (arrays) from/to caller
137500200529     C                   PARM                    WFldNamArr
137600200529     C                   PARM                    WMsgIDArr
137700200529     C                   PARM                    WMsgDtaArr
137800200529      * Array index (3P0) from/to caller
137900200529     C/COPY WNCPYSRC,SDH00737
138000200529     C                   PARM                    WIdx_SVAL
138100200529     C/COPY WNCPYSRC,SDH00738
138200200529      * Valid Customer layout (DS) from/to caller
138300200529      ** Valid Global Customer ID                                                             CGP001
138400200529     C                   PARM                    NwCuFilFmt
138500200529     C                   PARM                    V_DDGCUS                                     CGP001
138600200529      ** Customer Primary Details OK inds                                                     CSW207
138700200529     C                   PARM                    OKCuSwft                                     CSW207
138800200529      * Valid Customer SWIFT Details (DS) from/to caller                                      CSW207
138900200529     C                   PARM                    NwSwFilFmt                                   CSW207
139000200529     C/COPY WNCPYSRC,SDH00739
139100200529      *
139200200529      * If errors returned
139300200529      *
139400200529     C     Idx           IFNE      0
139500200529     C                   GOTO      EndVAL@P
139600200529     C                   END
139700200529      *
139800200529      * If the screen has changed in the course of the validation
139900200529      * or if there are warnings which have not been displayed
140000200529      * re-display the screen
140100200529      *
140200200529     C     NewCuPrim     IFNE      PrvCuPrim
140300200529     C     WIdx_PVAL     ORNE      PrvN_Warn
140400200529     C                   GOTO      EndVAL@P
140500200529     C                   END
140600200529     C/COPY WNCPYSRC,SDH00740
140700200529      *
140800200529      * Clear any warning messages
140900200529      *
141000200529     C                   MOVE      *ALL'Y'       OKCuPrim
141100200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
141200200529     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
141300200529     C                   ENDIF                                                                CSW207
141400200529     C/COPY WNCPYSRC,SDH00741
141500200529     C                   MOVEL     *BLANK        WFldNamArr
141600200529     C                   MOVEL     *BLANK        WMsgIdArr
141700200529     C                   MOVEL     *BLANK        WMsgDtaArr
141800200529      *
141900200529     C                   ENDIF
142000200529     C
142100200529      *
142200200529      * If Further Details (F23) has not been selected:
142300200529     C     @INKX         IFEQ      '0'
142400200529      *
142500200529      * If Base Rate Tax is OFF
142600200529     C     S01383        IFEQ      'N'
142700200529     C                   MOVE      'S'           @SCRN
142800200529     C                   GOTO      EndVAL@P
142900200529     C                   ENDIF
143000200529      *
143100200529      **Display*participant*details*if*account*holder*type*I*or*J***                          CRE007
143200200529      * Display participant details if account holder type I, J, or R                         CRE007
143300200529     C     DDTAIN        IFEQ      'I'
143400200529     C     DDTAIN        OREQ      'J'
143500200529     C     DDTAIN        OREQ      'R'                                                        CRE007
143600200529     C                   MOVE      'X'           @SCRN
143700200529     C                   ELSE
143800200529     C                   EXSR      VAL@T
143900200529     C                   MOVE      'S'           @SCRN
144000200529     C                   ENDIF
144100200529      *
144200200529      * If Further Details (F23) has been selected:
144300200529     C                   ELSE
144400200529      *
144500200529      * Return to Primary Detail Screen after Further Details
144600200529     C                   MOVE      'P'           @SCRN
144700200529     C                   EXSR      SFDS@P
144800200529      *
144900200529     C                   ENDIF
145000200529      *
145100200529     C     EndVAL@P      ENDSR
145200200529      *****************************************************************
145300200529      /EJECT
145400200529      *****************************************************************
145500200529      * SCRN@B - PROCESS BASE RATE TAX DETAILS SCREEN
145600200529      *****************************************************************
145700200529     C     SCRN@B        BEGSR
145800200529
145900200529      * IF ACTION CODE IS DELETE
146000200529      * BYPASS SCREEN PROCESSING AND PROCESS BRT DATA
146100200529      *
146200200529     C     DDACTN        IFEQ      'D'
146300200529     C                   EXSR      VAL@T
146400200529     C                   MOVE      'U'           @SCRN
146500200529     C                   GOTO      EndBDSP
146600200529     C                   ENDIF
146700200529
146800200529      * If Account Holder Type is 'R' then default BRT Tax Ind to 'N'.                        CRE007
146900200529      * If Insert mode as well then default Post 5/4/01 to 'Y'.                               CRE007
147000200529      *                                                                                       CRE007
147100200529     C     DDTAIN        IFEQ      'R'                                                        CRE007
147200200529     C                   EVAL      DDTXIN = 'N'                                               CRE007
147300200529     C     DDACTN        IFEQ      'I'                                                        CRE007
147400200529     C                   EVAL      DDPSTR = 'Y'                                               CRE007
147500200529     C                   ENDIF                                                                CRE007
147600200529     C                   ENDIF                                                                CRE007
147700200529
147800200529     C                   CALLB     'SDCUSD6DP'
147900200529      * INPUT PARAMETERS :
148000200529      * Return code
148100200529     C                   PARM                    RetCodeIn
148200200529      *
148300200529      * Primary Details
148400200529      * Base Rate Tax Details
148500200529     C                   PARM                    NewCuPrim
148600200529     C                   PARM                    NewCuBrt
148700200529      *
148800200529      * Fields in error
148900200529     C                   PARM                    OKCuBrt
149000200529      *
149100200529      * ERRORS
149200200529     C                   PARM                    FldNameArr
149300200529     C                   PARM                    MsgIdArr
149400200529     C                   PARM                    MsgDtaArr
149500200529      *
149600200529      * WARNINGS
149700200529     C                   PARM                    WFldNamArr
149800200529     C                   PARM                    WMsgIdArr
149900200529     C                   PARM                    WMsgDtaArr
150000200529      *
150100200529      * ENABLED FUNCTION KEYS
150200200529      * Display first or second page of Base Rate Tax details
150300200529     C                   PARM                    BRTSCREEN         1
150400200529      *
150500200529      * Changed Party Names Array
150600200529     C                   PARM                    ChgNamArr         1
150700200529      *
150800200529      * OUTPUT PARAMETERS :
150900200529      * Function Keys
151000200529     C                   PARM                    @INKC
151100200529     C                   PARM                    @INKL
151200200529     C                   PARM                    @INKS             1
151300200529      *
151400200529      * Write screen with no read indicator
151500200529     C                   PARM                    WriteOnly
151600200529      *
151700200529      *
151800200529      * F3 - End Program
151900200529     C     @INKC         CASEQ     '1'           ENDP
152000200529      *
152100200529      * F12 - Cancel on Base Rate Tax Screen
152200200529     C     @INKL         CASEQ     '1'           CANC@B
152300200529      *
152400200529      * Validate name changes and process participant history DS
152500200529     C     CHGNAME       CASEQ     '1'           VAL@T
152600200529      *
152700200529      * Validate Input to Base Rate Tax Screen
152800200529     C                   CAS                     VAL@B
152900200529      *
153000200529     C                   ENDCS
153100200529      *
153200200529     C     EndBDSP       ENDSR
153300200529      *****************************************************************
153400200529      /EJECT
153500200529      *****************************************************************
153600200529      * VAL@B  - VALIDATE INPUT TO BASE RATE TAX DETAILS
153700200529      *****************************************************************
153800200529     C     VAL@B         BEGSR
153900200529      *
154000200529      * IF ENQUIRE
154100200529      *
154200200529     C     DDACTN        IFEQ      'E'
154300200529      *
154400200529      * From BRT screen 1, go to screen 2 if there are details to view
154500200529      * otherwise return to browse screen
154600200529      *
154700200529     C     BRTSCREEN     IFEQ      '1'
154800200529     C     DD3NAM        ANDNE     *BLANKS
154900200529     C                   MOVE      '2'           BRTSCREEN
155000200529     C                   ELSE
155100200529     C                   MOVE      'S'           @SCRN
155200200529     C                   GOTO      EndVAL@B
155300200529     C                   ENDIF
155400200529      *
155500200529     C                   ENDIF
155600200529      *
155700200529      *----------------------------------------------------------------
155800200529      * IF INSERT OR AMEND / CHANGE
155900200529      *
156000200529     C     DDACTN        IFEQ      'I'
156100200529     C     DDACTN        OREQ      'A'
156200200529      *
156300200529      ** For account holder type I
156400200529      ** or  account holder type R                                                            CRE007
156500200529     C     DDTAIN        IFEQ      'I'
156600200529     C     DDTAIN        OREQ      'R'                                                        CRE007
156700200529      *
156800200529      ** If user has just left screen 1
156900200529     C     BRTSCREEN     IFEQ      '1'
157000200529      *
157100200529      ** If names have been entered for both parties 1 and 2 or
157200200529      ** party 3 has a name
157300200529     C     DD1NAM        IFNE      *BLANKS
157400200529     C     DD2NAM        ANDNE     *BLANKS
157500200529     C     DD3NAM        ORNE      *BLANKS
157600200529      *
157700200529      ** display the second screen before validating
157800200529     C                   MOVE      '2'           BRTSCREEN
157900200529     C                   GOTO      EndVAL@B
158000200529     C                   ENDIF
158100200529     C                   ELSE
158200200529     C                   MOVE      '1'           BRTSCREEN
158300200529     C                   ENDIF
158400200529      *
158500200529      ** For account holder type J
158600200529     C                   ELSE
158700200529      *
158800200529      ** As long as there are parties on screen 2, toggle between first
158900200529      ** and second BRT screens if errors and redisplaying screens
159000200529      *
159100200529     C     DD3NAM        IFNE      *BLANKS
159200200529     C     BRTSCREEN     IFEQ      '1'
159300200529     C                   MOVE      '2'           BRTSCREEN
159400200529     C                   ELSE
159500200529     C                   MOVE      '1'           BRTSCREEN
159600200529     C                   ENDIF
159700200529     C                   ENDIF
159800200529
159900200529     C                   ENDIF
160000200529
160100200529     C                   Z-ADD     *ZERO         Idx
160200200529     C                   MOVE      *ALL'Y'       OKCuBrt
160300200529     C                   MOVEL     *BLANK        FldNameArr
160400200529     C                   MOVEL     *BLANK        MsgIdArr
160500200529     C                   MOVEL     *BLANK        MsgDtaArr
160600200529     C                   MOVEL     *BLANK        WFldNamArr
160700200529     C                   MOVEL     *BLANK        WMsgIdArr
160800200529     C                   MOVEL     *BLANK        WMsgDtaArr
160900200529      *
161000200529      *
161100200529      * Update 'previous' screens and previous number of warnings
161200200529
161300200529     C                   MOVEL     NewCuBrt      PrvCuBrt
161400200529     C                   Z-ADD     WIdx_BVAL     PrvN_Warn
161500200529      *
161600200529      * Validate Base Rate Tax Details
161700200529      *
161800200529     C                   CALLB     'SDCUSD6VL'
161900200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
162000200529      * INPUTS :
162100200529      * Response mode
162200200529     C                   PARM                    RespMode
162300200529      *
162400200529      * Action Code
162500200529     C                   PARM                    DDACTN
162600200529      *
162700200529      * Customer Number
162800200529     C                   PARM                    DDCUSN            6
162900200529      *
163000200529      * Account Holder Type
163100200529     C                   PARM                    DDTAIN            1
163200200529      *
163300200529      ** Customer Base Rate Tax Details
163400200529     C                   PARM                    NewCuBrt
163500200529      *
163600200529      ** Screen validation
163700200529     C                   PARM      '1'           SinVal            1
163800200529      *
163900200529      * OUTPUTS :
164000200529      ** Customer Base Rate Tax Details
164100200529     C                   PARM                    OKCuBrt
164200200529      *
164300200529      * Error fields/message IDs/message data (arrays) from/to caller
164400200529     C                   PARM                    FldNameArr
164500200529     C                   PARM                    MsgIDArr
164600200529     C                   PARM                    MsgDtaArr
164700200529      *
164800200529      * Array index (3P0) from/to caller
164900200529     C                   PARM                    Idx
165000200529      *
165100200529      * Warning fields/message IDs/message data (arrays) from/to caller
165200200529     C                   PARM                    WFldNamArr
165300200529     C                   PARM                    WMsgIDArr
165400200529     C                   PARM                    WMsgDtaArr
165500200529      *
165600200529      * Array index (3P0) from/to caller
165700200529     C                   PARM      0             WIdx_BVAL
165800200529      *
165900200529      * Valid Base Rate Tax layout (DS) from/to caller
166000200529     C                   PARM                    NwBrFilFmt
166100200529      *
166200200529      * Changed Party Names Array
166300200529     C                   PARM                    ChgNamArr
166400200529      *
166500200529      * If any errors redisplay screen
166600200529     C     Idx           IFNE      0
166700200529     C                   GOTO      ENDVAL@B
166800200529     C                   ENDIF
166900200529      *
167000200529      * If there are any warnings, redisplay screen
167100200529     C     WIdx_BVAL     IFNE      PrvN_Warn
167200200529      *
167300200529      * Don't prompt user for name if redisplaying for warning message
167400200529     C                   MOVEA     *BLANKS       ChgNamArr
167500200529     C                   GOTO      EndVAL@B
167600200529      *
167700200529     C                   ELSE
167800200529      *
167900200529     C                   MOVEL     *BLANK        WFldNamArr
168000200529     C                   MOVEL     *BLANK        WMsgIdArr
168100200529     C                   MOVEL     *BLANK        WMsgDtaArr
168200200529     C                   END
168300200529      *
168400200529      * Determine whether there are changed/new names among participants
168500200529     C                   EXSR      PARNAMES
168600200529      *
168700200529      * If any changed names, redisplay screen for user to confirm
168800200529      * whether this is a name change or a new participant
168900200529      *
169000200529     C     DDACTN        IFEQ      'A'
169100200529     C     CHGNAME       ANDEQ     '1'
169200200529     C                   GOTO      ENDVAL@B
169300200529     C                   ENDIF
169400200529      *
169500200529      *
169600200529     C                   EXSR      VAL@T
169700200529
169800200529      * Clear any warning messages
169900200529      *
170000200529     C                   MOVE      *ALL'Y'       OKCuBrt
170100200529     C                   MOVEL     *BLANK        WFldNamArr
170200200529     C                   MOVEL     *BLANK        WMsgIdArr
170300200529     C                   MOVEL     *BLANK        WMsgDtaArr
170400200529      *
170500200529      * Move on to Secondary Screen
170600200529     C                   MOVE      'S'           @SCRN
170700200529      *
170800200529      * End of Insert/Amend condition controlling validation call
170900200529     C                   ENDIF
171000200529      *
171100200529      *
171200200529     C     EndVAL@B      ENDSR
171300200529      *****************************************************************
171400200529      /EJECT
171500200529      *****************************************************************
171600200529      * VAL@T - Validate Name Prompt and Process Participant History DS
171700200529      *****************************************************************
171800200529     C     VAL@T         BEGSR
171900200529      *
172000200529      * Prior to validation, initialize error indicators as 'OK'
172100200529      *
172200200529     C                   Z-ADD     *ZERO         Idx
172300200529     C                   Z-ADD     *ZERO         WIdx_TVAL
172400200529     C                   MOVE      *ALL'Y'       OKCuBRT
172500200529     C                   MOVEL     *BLANK        FldNameArr
172600200529     C                   MOVEL     *BLANK        MsgIdArr
172700200529     C                   MOVEL     *BLANK        MsgDtaArr
172800200529      *
172900200529      ** Call to validate name prompt and process Participant History
173000200529      *
173100200529     C                   CALLB     'SDCUSD7VL'
173200200529      * INPUTS
173300200529
173400200529      * Response mode
173500200529     C                   PARM                    RespMode          1
173600200529      *
173700200529      * Action Code
173800200529      * Customer Number
173900200529      * Account Holder Type
174000200529     C                   PARM                    DDACTN
174100200529     C                   PARM                    DDCUSN
174200200529     C                   PARM                    DDTAIN
174300200529
174400200529      ** Customer Base Rate Tax
174500200529     C                   PARM                    NewCuBrt
174600200529
174700200529      ** OUTPUTS
174800200529
174900200529      ** Customer Base Rate Tax OK indicators
175000200529     C                   PARM                    OKCuBrt
175100200529
175200200529      * Error fields/message IDs/message data (arrays) from/to caller
175300200529     C                   PARM                    FldNameArr
175400200529     C                   PARM                    MsgIDArr
175500200529     C                   PARM                    MsgDtaArr
175600200529
175700200529      * Array index (3P0) from/to caller
175800200529     C                   PARM                    Idx
175900200529
176000200529      * Warning fields/message IDs/message data (arrays) from/to caller
176100200529     C                   PARM                    WFldNamArr
176200200529     C                   PARM                    WMsgIDArr
176300200529     C                   PARM                    WMsgDtaArr
176400200529
176500200529      * Array index (3P0) from/to caller
176600200529     C                   PARM                    WIdx_TVAL
176700200529
176800200529      * Changed Party Name Array
176900200529     C                   PARM                    ChgNamArr
177000200529      *
177100200529      * Valid BRT file layout (DS) to/from caller
177200200529     C                   PARM                    NwBrFilFmt
177300200529      *
177400200529      * If there are errors, redisplay Base Rate Tax screen
177500200529
177600200529     C     Idx           IFNE      0
177700200529     C                   GOTO      EndVAL@T
177800200529     C                   ENDIF
177900200529
178000200529      * If the screen has changed in the course of the validation
178100200529      * or if there are warnings which have not been displayed
178200200529      * re-display the screen
178300200529
178400200529     C     BRTSCREEN     IFEQ      '2'
178500200529     C                   MOVEA     *BLANKS       ChgNamArr
178600200529     C                   MOVE      '0'           CHGNAME
178700200529     C                   MOVE      'S'           @SCRN
178800200529     C                   GOTO      EndVAL@T
178900200529     C                   ENDIF
179000200529      *
179100200529     C     ChgNamArr(3)  IFEQ      'P'
179200200529     C     ChgNamArr(4)  OREQ      'P'
179300200529     C     ChgNamArr(5)  OREQ      'P'
179400200529     C                   MOVE      '2'           BRTSCREEN
179500200529     C                   ELSE
179600200529     C                   MOVEA     *BLANKS       ChgNamArr
179700200529     C                   MOVE      '0'           CHGNAME
179800200529     C                   MOVE      'S'           @SCRN
179900200529     C                   ENDIF
180000200529
180100200529
180200200529     C     EndVAL@T      ENDSR
180300200529      *****************************************************************
180400200529      /EJECT
180500200529      *****************************************************************
180600200529      * SCRN@S - PROCESS SECOND SCREEN
180700200529      *****************************************************************
180800200529     C     SCRN@S        BEGSR
180900200529
181000200529      * Set function key status on SECONDARY screen
181100200529      *
181200200529     C                   EXSR      SFKEYS
181300200529      *
181400200529      ** WRITE/READ DISPLAY SCREEN - Secondary Details
181500200529      *
181600200529     C                   CALLB     'SDCUSD3DP'
181700200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
181800200529      * INPUT PARAMETERS :
181900200529      * Return code
182000200529     C                   PARM      *BLANK        RetCodeOut
182100200529      *
182200200529      * Customer (IN SCREEN FORMAT - Primary)
182300200529     C                   PARM                    NewCuPrim
182400200529     C                   PARM                    NewCuSeco
182500200529     C                   PARM                    NewCuSwft                                    CSW207
182600200529     C**********         PARM                    CuSW13                              CFT050 MD022395
182700200529     C                   PARM                    NewCuSW13                                  MD022395
182800200529      * Customer OK indicators
182900200529     C                   PARM                    OKCuSeco
183000200529      *
183100200529      * Errors
183200200529     C                   PARM                    FldNameArr
183300200529     C                   PARM                    MsgIdArr
183400200529     C                   PARM                    MsgDtaArr
183500200529      * Warnings
183600200529     C                   PARM                    WFldNamArr
183700200529     C                   PARM                    WMsgIdArr
183800200529     C                   PARM                    WMsgDtaArr
183900200529      *
184000200529      * ENABLED Function Keys
184100200529      * KJ = COMMAND KEY 10 = CONFIRM DELETE
184200200529      * KX = COMMAND KEY 23 = FURTHERDETAILS
184300200529     C                   PARM                    @EINKJ            1
184400200529     C                   PARM                    @EINKX
184500200529     C                   PARM                    @EINKV                                       CFT050
184600200529      *
184700200529      * OUTPUT PARAMETERS :
184800200529      * FUNCTION KEYS
184900200529     C                   PARM      '0'           @INKC
185000200529     C                   PARM      '0'           @INKJ
185100200529     C                   PARM      '0'           @INKL
185200200529     C                   PARM      '0'           @INKX
185300200529     C                   PARM      '0'           @INKV                                        CFT050
185400200529      *
185500200529      * Write screen with no read indicator
185600200529     C                   PARM      'N'           WriteOnly
185700200529     C/COPY WNCPYSRC,SDCUSDSC08
185800200529      *
185900200529      * RESET ERRORS ....
186000200529      *
186100200529     C                   MOVE      *ALL'Y'       OKCuSeco
186200200529     C                   MOVEL     *BLANK        FldNameArr
186300200529     C                   MOVEL     *BLANK        MsgIdArr
186400200529     C                   MOVEL     *BLANK        MsgDtaArr
186500200529     C                   MOVEL     *BLANK        WFldNamArr
186600200529     C                   MOVEL     *BLANK        WMsgIdArr
186700200529     C                   MOVEL     *BLANK        WMsgDtaArr
186800200529     C/COPY WNCPYSRC,SDCUSDSC09
186900200529      *
187000200529      * F3 - End Program
187100200529     C     @INKC         CASEQ     '1'           ENDP
187200200529      *
187300200529      * F12 - Cancel on Secondary Screen
187400200529     C     @INKL         CASEQ     '1'           CANC@S
187500200529      *
187600200529      * Validate Input to Secondary Screen
187700200529     C                   CAS                     VAL@S
187800200529      *
187900200529     C                   ENDCS
188000200529      *
188100200529      * On F23, go to Further Details, if there are no errors on this screen
188200200529      *
188300200529     C     @INKX         IFEQ      '1'
188400200529     C     Idx           ANDEQ     0
188500200529     C     @INKX         OREQ      '1'                                                        237595
188600200529     C     Idx           ANDNE     0                                                          237595
188700200529     C     DDACTN        ANDEQ     'D'                                                        237595
188800200529     C                   EXSR      FURDET
188900200529     C                   ENDIF
189000200529      *
189100200529     C                   ENDSR
189200200529      *****************************************************************
189300200529      /EJECT
189400200529      *****************************************************************
189500200529      * VAL@S  - VALIDATE INPUT TO SECONDARY SCREEN
189600200529      *****************************************************************
189700200529     C     VAL@S         BEGSR
189800200529      ** If F21 was pressed go to Bank Directory Plus menu                                    CFT050
189900200529     C                   IF        @INKV = '1'                                                CFT050
190000200529     C                   EVAL      @SCRN = 'E'                                                CFT050
190100200529     C                   GOTO      EndVAL@S                                                   CFT050
190200200529     C                   ENDIF                                                                CFT050
190300200529      *
190400200529      * Prior to validation, initialize error indicators as 'OK'
190500200529      *
190600200529     C                   Z-ADD     *ZERO         Idx
190700200529     C                   Z-ADD     *ZERO         WIdx_SVAL
190800200529     C                   MOVE      *ALL'Y'       OKCuSeco
190900200529     C/COPY WNCPYSRC,SDCUSDSC10
191000200529      *
191100200529      *----------------------------------------------------------------
191200200529      * IF DELETE
191300200529      *
191400200529     C     DDACTN        IFEQ      'D'
191500200529      *
191600200529      * IF F10 TAKEN, GO ON TO UPDATES
191700200529      *
191800200529     C     @INKJ         IFEQ      '1'
191900200529     C                   EXSR      RTVCUS                                                     237595
192000200529     C     DDCUSNOK      IFNE      'N'                                                        237595
192100200529     C                   MOVEL     'U'           @SCRN
192200200529     C                   ENDIF                                                                237595
192300200529     C                   END
192400200529     C                   GOTO      EndVAL@S
192500200529     C                   END
192600200529      *
192700200529      *----------------------------------------------------------------
192800200529      * IF ENQUIRE
192900200529      *
193000200529     C     DDACTN        IFEQ      'E'
193100200529      *
193200200529      * If F23 has not been selected go on to Message Details screen
193300200529      *
193400200529     C     @INKX         IFEQ      '0'
193500200529      *                                                                                       CSW024
193600200529      ** If MT3xx BEI enhancement has been installed and                                      CSW024
193700200529      ** SWIFT/Direct Link module is on then display                                          CSW024
193800200529      ** screen for MT3xx BEI details                                                         CSW024
193900200529     C                   IF        CSW024 = 'Y' AND                                           CSW024
194000200529     C                             BGMSDL = 'Y'                                               CSW024
194100200529     C                   MOVEL     'F'           @SCRN                                        CSW024
194200200529     C                   ELSE                                                                 CSW024
194300200529     C                   MOVEL     'M'           @SCRN
194400200529     C                   ENDIF                                                                CSW024
194500200529                                                                                              CSW024
194600200529     C                   END
194700200529      *
194800200529     C                   GOTO      EndVAL@S
194900200529     C                   END
195000200529      *
195100200529      *----------------------------------------------------------------
195200200529      * IF INSERT OR AMEND / CHANGE
195300200529      *
195400200529     C     DDACTN        IFEQ      'I'
195500200529     C     DDACTN        OREQ      'A'
195600200529      *
195700200529      * Update 'previous' screens and previous number of warnings
195800200529
195900200529     C                   MOVEL     NewCuSeco     PrvCuSeco
196000200529     C                   Z-ADD     WIdx_SVAL     PrvN_Warn
196100200529      *
196200200529      * Validate Secondary Screen details
196300200529      *
196400200529     C                   CALLB     'SDCUSD3VL'
196500200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
196600200529      * INPUTS :
196700200529      ** Response mode
196800200529     C                   PARM                    RespMode
196900200529      ** Customer Primary Details
197000200529     C                   PARM                    NewCuPrim
197100200529      ** Customer Secondary Details
197200200529     C                   PARM                    NewCuSeco
197300200529      ** Customer Extra Data file data
197400200529     C                   PARM                    ExtData
197500200529      ** SWIFT Detail                                                                         CSW207
197600200529     C                   PARM                    NewCuSwft                                    CSW207
197700200529     C**********         PARM                    CuSW13                              CFT050 MD022395
197800200529     C                   PARM                    NewCuSW13                                  MD022395
197900200529      * OUTPUTS :
198000200529      ** Customer Seconda Details OK inds
198100200529     C                   PARM                    OKCuSeco
198200200529      * Error fields/message IDs/message data (arrays) from/to caller
198300200529     C                   PARM                    FldNameArr
198400200529     C                   PARM                    MsgIDArr
198500200529     C                   PARM                    MsgDtaArr
198600200529      * Array index (3P0) from/to caller
198700200529     C                   PARM                    Idx
198800200529      * Warning fields/message IDs/message data (arrays) from/to caller
198900200529     C                   PARM                    WFldNamArr
199000200529     C                   PARM                    WMsgIDArr
199100200529     C                   PARM                    WMsgDtaArr
199200200529      * Array index (3P0) from/to caller
199300200529     C                   PARM                    WIdx_SVAL
199400200529      * Valid Customer layout (DS) from/to caller
199500200529     C                   PARM                    NwCuFilFmt
199600200529      * Valid SWIFT Layout (DS) from/to caller                                                CSW207
199700200529     C                   PARM                    NwSwFilFmt                                   CSW207
199800200529      * Customer SWIFT Details OK Indicator                                                   CSW207
199900200529     C                   PARM                    OkCuSwft                                     CSW207
200000200529     C/COPY WNCPYSRC,SDCUSDSC11
200100200529      *
200200200529      * If errors returned
200300200529      *
200400200529     C     Idx           IFNE      0
200500200529     C                   GOTO      EndVAL@S
200600200529     C                   END
200700200529      *
200800200529      * If the screen has changed in the course of the validation
200900200529      * or if there are warnings which have not been displayed
201000200529      * re-output the screen
201100200529      *
201200200529     C     NewCuSeco     IFNE      PrvCuSeco
201300200529     C     WIdx_SVAL     ORNE      PrvN_Warn
201400200529     C                   GOTO      EndVAL@S
201500200529     C                   END
201600200529      *
201700200529      * Clear any warning messages
201800200529      *
201900200529     C                   MOVE      *ALL'Y'       OKCuSeco
202000200529     C                   MOVEL     *BLANK        WFldNamArr
202100200529     C                   MOVEL     *BLANK        WMsgIdArr
202200200529     C                   MOVEL     *BLANK        WMsgDtaArr
202300200529     C/COPY WNCPYSRC,SDCUSDSC12
202400200529      *
202500200529      * If displaying Further Details, return to secondary details screen
202600200529      * Otherwise move on to message detail screen
202700200529      *
202800200529     C     @INKX         IFNE      '1'
202900200529      *                                                                                       CSW024
203000200529      ** If MT3xx BEI enhancement has been installed, and                                     CSW024
203100200529      ** SWIFT/Direct Link module is on then display                                          CSW024
203200200529      ** screen for MT3xx BEI details                                                         CSW024
203300200529     C                   IF        CSW024 = 'Y' AND                                           CSW024
203400200529     C                             BGMSDL = 'Y'                                               CSW024
203500200529     C                   MOVEL     'F'           @SCRN                                        CSW024
203600200529     C                   ELSE                                                                 CSW024
203700200529     C                   MOVEL     'M'           @SCRN
203800200529     C                   ENDIF                                                                CSW024
203900200529                                                                                              CSW024
204000200529     C                   END
204100200529      *
204200200529     C                   END
204300200529      *
204400200529     C     EndVAL@S      ENDSR
204500200529                                                                                              CSW024
204600200529      *****************************************************************                       CSW024
204700200529      /EJECT                                                                                  CSW024
204800200529      *****************************************************************                       CSW024
204900200529      *                                                               *                       CSW024
205000200529      * SCRN@F - Process MT3xx BEI and Fund Details screen            *                       CSW024
205100200529      *                                                               *                       CSW024
205200200529      *****************************************************************                       CSW024
205300200529                                                                                              CSW024
205400200529     C     SCRN@F        BEGSR                                                                CSW024
205500200529      *                                                                                       CSW024
205600200529      ** Set function key status for MT3xx BEI screen                                         CSW024
205700200529      *                                                                                       CSW024
205800200529     C                   EXSR      SFKEYS                                                     CSW024
205900200529      *                                                                                       CSW024
206000200529      ** Write/read display - MT3xx BEI and Fund details screen                               CSW024
206100200529      *                                                                                       CSW024
206200200529     C                   CALLB     'SDCUSD8DP'                                                CSW024
206300200529      *                  =====================                                                CSW024
206400200529      ** INPUT                                                                                CSW024
206500200529      *  =====                                                                                CSW024
206600200529      *                                                                                       CSW024
206700200529      ** Return Code                                                                          CSW024
206800200529     C                   PARM      *BLANK        RetCodeOut                                   CSW024
206900200529      *                                                                                       CSW024
207000200529      ** New Customer in Screen Format - Primary Details                                      CSW024
207100200529     C                   PARM                    NewCuPrim                                    CSW024
207200200529      *                                                                                       CSW024
207300200529      ** New Customer in Screen Format - MT3xx BEI details                                    CSW024
207400200529     C                   PARM                    NewCuMT3x                                    CSW024
207500200529      *                                                                                       CSW024
207600200529      ** Fields in error                                                                      CSW024
207700200529     C                   PARM                    OKCuMT3x                                     CSW024
207800200529      *                                                                                       CSW024
207900200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW024
208000200529     C                   PARM                    FldNameArr                                   CSW024
208100200529     C                   PARM                    MsgIdArr                                     CSW024
208200200529     C                   PARM                    MsgDtaArr                                    CSW024
208300200529      *                                                                                       CSW024
208400200529      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW024
208500200529     C                   PARM                    WFldNamArr                                   CSW024
208600200529     C                   PARM                    WMsgIdArr                                    CSW024
208700200529     C                   PARM                    WMsgDtaArr                                   CSW024
208800200529      *                                                                                       CSW024
208900200529      ** Enabled Function Keys                                                                CSW024
209000200529      ** KJ = Command Key 10 = DELETE                                                         CSW024
209100200529      ** KX = Command Key 23 = FURTHER DETAILS                                                CSW024
209200200529     C                   PARM                    @EINKJ                                       CSW024
209300200529     C                   PARM                    @EINKX                                       CSW024
209400200529     C                   PARM                    @EINKV                                       CFT050
209500200529      *                                                                                       CSW024
209600200529      ** Write screen with no read indicator                                                  CSW024
209700200529     C                   PARM                    WriteOnly                                    CSW024
209800200529      ** Linkage record key                                                                   CFT050
209900200529     C                   PARM                    DDBDRK                                       CFT050
210000200529      *                                                                                       CSW024
210100200529      ** OUTPUT                                                                               CSW024
210200200529      ** ======                                                                               CSW024
210300200529      *                                                                                       CSW024
210400200529      ** Function Keys                                                                        CSW024
210500200529     C                   PARM      '0'           @INKC                                        CSW024
210600200529     C                   PARM      '0'           @INKJ                                        CSW024
210700200529     C                   PARM      '0'           @INKL                                        CSW024
210800200529     C                   PARM      '0'           @INKX                                        CSW024
210900200529     C                   PARM      '0'           @INKV                                        CFT050
211000200529      *                                                                                       CSW024
211100200529      ** Reset errors                                                                         CSW024
211200200529      *                                                                                       CSW024
211300200529     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
211400200529     C                   MOVEL     *BLANK        FldNameArr                                   CSW024
211500200529     C                   MOVEL     *BLANK        MsgIdArr                                     CSW024
211600200529     C                   MOVEL     *BLANK        MsgDtaArr                                    CSW024
211700200529     C                   MOVEL     *BLANK        WFldNamArr                                   CSW024
211800200529     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW024
211900200529     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW024
212000200529      *                                                                                       CSW024
212100200529      ** F3 - End Program                                                                     CSW024
212200200529     C     @INKC         CASEQ     '1'           ENDP                                         CSW024
212300200529      *                                                                                       CSW024
212400200529      ** F12 - Cancel on Message Details Screen                                               CSW024
212500200529     C     @INKL         CASEQ     '1'           CANC@F                                       CSW024
212600200529      *                                                                                       CSW024
212700200529      ** Validate Input to Message Details Screen                                             CSW024
212800200529     C                   CAS                     VAL@F                                        CSW024
212900200529      *                                                                                       CSW024
213000200529     C                   ENDCS                                                                CSW024
213100200529      *                                                                                       CSW024
213200200529      ** On F23, go to Further Details, if there are no errors                                CSW024
213300200529      *                                                                                       CSW024
213400200529     C     DDACTN        IFNE      'I'                                                       BUG3362
213500200529     C     @INKX         IFEQ      '1'                                                        CSW024
213600200529     C     Idx           ANDEQ     0                                                          CSW024
213700200529     C     @INKX         OREQ      '1'                                                        237595
213800200529     C     Idx           ANDNE     0                                                          237595
213900200529     C     DDACTN        ANDEQ     'D'                                                        237595
214000200529     C                   EXSR      FURDET                                                     CSW024
214100200529     C                   ENDIF                                                                CSW024
214200200529     C                   ENDIF                                                               BUG3362
214300200529      *                                                                                       CSW024
214400200529     C                   ENDSR                                                                CSW024
214500200529                                                                                              CSW024
214600200529      *****************************************************************                       CSW024
214700200529      /EJECT                                                                                  CSW024
214800200529      *****************************************************************                       CSW024
214900200529      *                                                               *                       CSW024
215000200529      * VAL@F - Validate MT3xx BEI and Fund Details screen            *                       CSW024
215100200529      *                                                               *                       CSW024
215200200529      *****************************************************************                       CSW024
215300200529                                                                                              CSW024
215400200529     C     VAL@F         BEGSR                                                                CSW024
215500200529      ** If F21 was press go to Bank Directory Plus screen                                    CFT050
215600200529     C                   IF        @INKV = '1'                                                CFT050
215700200529     C                   EVAL      @SCRN = 'E'                                                CFT050
215800200529     C                   GOTO      EndVAL@F                                                   CFT050
215900200529     C                   ENDIF                                                                CFT050
216000200529      *                                                                                       CSW024
216100200529      ** Prior to validation, initialize error indicators as 'OK'                             CSW024
216200200529      *                                                                                       CSW024
216300200529     C                   Z-ADD     *ZERO         Idx                                          CSW024
216400200529     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
216500200529      *                                                                                       CSW024
216600200529      ** If Enquire                                                                           CSW024
216700200529      *                                                                                       CSW024
216800200529     C     DDACTN        IFEQ      'E'                                                        CSW024
216900200529      *                                                                                       CSW024
217000200529      ** If displaying Further Details, return to message details screen                      CSW024
217100200529      ** Otherwise move on to customer subfile display.                                       CSW024
217200200529      *                                                                                       CSW024
217300200529     C     @INKX         IFNE      '1'                                                        CSW024
217400200529     C     @RDNB         IFEQ      'Y'                                                        CSW024
217500200529     C     BGN4ST        ANDEQ     'Y'                                                        CSW024
217600200529     C                   MOVEL     'I'           @SCRN                                        CSW024
217700200529     C                   ELSE                                                                 CSW024
217800200529      **If*Window*Processing*on:***************************************               BUG6565 235524
217900200529      **********                                                                      BUG6565 235524
218000200529     C*****BGWDPR        IFEQ      'Y'                                                BUG6565 235524
218100200529     C**********         MOVEL     'W'           @SCRN                                BUG6565 235524
218200200529     C**********         ELSE                                                         BUG6565 235524
218300200529     C**********         EXSR      INITIAL                                             CSW024 235524
218400200529     C**********         ENDIF                                                        BUG6565 235524
218500200529      *                                                                                       235524
218600200529     C                   MOVEL     'M'           @SCRN                                        235524
218700200529     C/COPY WNCPYSRC,SDH00602
218800200529     C                   ENDIF                                                                CSW024
218900200529     C                   ENDIF                                                                CSW024
219000200529      *                                                                                       CSW024
219100200529     C                   GOTO      EndVAL@F                                                   CSW024
219200200529     C                   ENDIF                                                                CSW024
219300200529      *                                                                                       CSW024
219400200529      ** If Insert or Amend                                                                   CSW024
219500200529      *                                                                                       CSW024
219600200529     C     DDACTN        IFEQ      'I'                                                        CSW024
219700200529     C     DDACTN        OREQ      'A'                                                        CSW024
219800200529      *                                                                                       CSW024
219900200529      ** Update 'previous' screens and previous number of warnings                            CSW024
220000200529                                                                                              CSW024
220100200529     C                   MOVEL     NewCuMT3x     PrvCuMT3x                                    CSW024
220200200529     C                   Z-ADD     WIdx_Fval     PrvN_Warn                                    CSW024
220300200529     C                   Z-ADD     *ZERO         WIdx_Fval                                    CSW024
220400200529      *                                                                                       CSW024
220500200529      ** Validate message details screen                                                      CSW024
220600200529      *                                                                                       CSW024
220700200529     C                   CALLB     'SDCUSD8VL'                                                CSW024
220800200529      *                  =====================                                                CSW024
220900200529      ** INPUTS                                                                               CSW024
221000200529      ** ======                                                                               CSW024
221100200529      *                                                                                       CSW024
221200200529      ** Return Code                                                                          CSW024
221300200529     C                   PARM      *BLANK        RetCodeOut                                   CSW024
221400200529      *                                                                                       CSW024
221500200529      ** New Customer in Screen Format - MT3xx BEI details                                    CSW024
221600200529     C                   PARM                    NewCuMT3x                                    CSW024
221700200529      *                                                                                       CSW024
221800200529      ** Fields in error                                                                      CSW024
221900200529     C                   PARM                    OKCuMT3x                                     CSW024
222000200529      *                                                                                       CSW024
222100200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW024
222200200529     C                   PARM                    FldNameArr                                   CSW024
222300200529     C                   PARM                    MsgIDArr                                     CSW024
222400200529     C                   PARM                    MsgDtaArr                                    CSW024
222500200529      *                                                                                       CSW024
222600200529      ** Array index (3P0) from/to caller                                                     CSW024
222700200529     C                   PARM                    Idx                                          CSW024
222800200529      *                                                                                       CSW024
222900200529      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW024
223000200529     C                   PARM                    WFldNamArr                                   CSW024
223100200529     C                   PARM                    WMsgIDArr                                    CSW024
223200200529     C                   PARM                    WMsgDtaArr                                   CSW024
223300200529      *                                                                                       CSW024
223400200529      ** Array index (3P0) from/to caller                                                     CSW024
223500200529     C                   PARM                    WIdx_Fval                                    CSW024
223600200529      *                                                                                       CSW024
223700200529      ** Valid Customer layout (DS) from/to caller                                            CSW024
223800200529     C                   PARM                    NwCuFilFmt                                   CSW024
223900200529      *                                                                                       CSW024
224000200529      ** If errors returned                                                                   CSW024
224100200529      *                                                                                       CSW024
224200200529     C     Idx           IFNE      0                                                          CSW024
224300200529     C                   GOTO      EndVAL@F                                                   CSW024
224400200529     C                   ENDIF                                                                CSW024
224500200529      *                                                                                       CSW024
224600200529      ** If the screen has changed in the course of the validation                            CSW024
224700200529      ** or if there are warnings which have not been displayed                               CSW024
224800200529      ** re-output the screen                                                                 CSW024
224900200529      *                                                                                       CSW024
225000200529     C     NewCuMT3x     IFNE      PrvCuMT3x                                                  CSW024
225100200529     C     WIdx_Fval     ORNE      PrvN_Warn                                                  CSW024
225200200529     C                   GOTO      EndVAL@F                                                   CSW024
225300200529     C                   ENDIF                                                                CSW024
225400200529      *                                                                                       CSW024
225500200529      ** Clear any warning messages                                                           CSW024
225600200529      *                                                                                       CSW024
225700200529     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
225800200529     C                   MOVEL     *BLANK        WFldNamArr                                   CSW024
225900200529     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW024
226000200529     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW024
226100200529      *                                                                                       CSW024
226200200529      ** If displaying Further Details, return to secondary details screen                    CSW024
226300200529      ** otherwise, move to message details screen.                                           CSW024
226400200529      *                                                                                       CSW024
226500200529     C     @INKX         IFNE      '1'                                                        CSW024
226600200529     C                   MOVEL     'M'           @SCRN                                        CSW024
226700200529     C/COPY WNCPYSRC,SDH00603
226800200529     C                   ENDIF                                                                CSW024
226900200529      *                                                                                       CSW024
227000200529     C                   ENDIF                                                                CSW024
227100200529      *                                                                                       CSW024
227200200529     C     EndVAL@F      ENDSR                                                                CSW024
227300200529                                                                                              CSW024
227400200529      *****************************************************************
227500200529      /EJECT
227600200529      *****************************************************************
227700200529      * SCRN@M - PROCESS MESSAGE DETAILS SCREEN
227800200529      *****************************************************************
227900200529     C     SCRN@M        BEGSR
228000200529
228100200529      * Set function key status on SECONDARY screen
228200200529      *
228300200529     C                   EXSR      SFKEYS
228400200529      *
228500200529      ** WRITE/READ DISPLAY - Message Details Screen
228600200529      *
228700200529     C                   CALLB     'SDCUSD4DP'
228800200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
228900200529      * INPUT PARAMETERS:
229000200529      * Return Code
229100200529     C                   PARM      *BLANK        RetCodeOut
229200200529      * Customer (IN SCREEN FORMAT) - Message tails
229300200529     C                   PARM                    NewCuPrim
229400200529     C                   PARM                    NewCuMsg
229500200529      *
229600200529      * Fields in error
229700200529     C                   PARM                    OKCuMsg
229800200529      * Errors
229900200529     C                   PARM                    FldNameArr
230000200529     C                   PARM                    MsgIdArr
230100200529     C                   PARM                    MsgDtaArr
230200200529      * Warnings
230300200529     C                   PARM                    WFldNamArr
230400200529     C                   PARM                    WMsgIdArr
230500200529     C                   PARM                    WMsgDtaArr
230600200529      * ENABLED FUNCTION KEYS
230700200529      * KJ = COMMAND KEY 10 = DELETE
230800200529      * KX = COMMAND KEY 23 = FURTHER DETAILS
230900200529     C                   PARM                    @EINKJ            1
231000200529     C                   PARM                    @EINKX            1
231100200529      *
231200200529      ** OUTPUT PARAMETERS :
231300200529      * Function Keys
231400200529     C                   PARM      '0'           @INKC
231500200529     C                   PARM      '0'           @INKJ
231600200529     C                   PARM      '0'           @INKL
231700200529     C                   PARM      '0'           @INKX
231800200529      * Write screen with no read indicator
231900200529     C                   PARM      'N'           WriteOnly
232000200529      *
232100200529      * RESET ERRORS ....
232200200529      *
232300200529     C                   MOVE      *ALL'Y'       OKCuMsg
232400200529     C                   MOVEL     *BLANK        FldNameArr
232500200529     C                   MOVEL     *BLANK        MsgIdArr
232600200529     C                   MOVEL     *BLANK        MsgDtaArr
232700200529     C                   MOVEL     *BLANK        WFldNamArr
232800200529     C                   MOVEL     *BLANK        WMsgIdArr
232900200529     C                   MOVEL     *BLANK        WMsgDtaArr
233000200529      *
233100200529      *
233200200529      * F3 - End Program
233300200529     C     @INKC         CASEQ     '1'           ENDP
233400200529      *
233500200529      * F12 - Cancel on Message Details Screen
233600200529     C     @INKL         CASEQ     '1'           CANC@M
233700200529      *
233800200529      * Validate Input to Message Details Screen
233900200529     C                   CAS                     VAL@M
234000200529      *
234100200529     C                   ENDCS
234200200529
234300200529      * On F23, go to Further Details, if there are no errors on this screen
234400200529      *
234500200529     C     @INKX         IFEQ      '1'
234600200529     C     Idx           ANDEQ     0
234700200529     C     @INKX         OREQ      '1'                                                        237595
234800200529     C     Idx           ANDNE     0                                                          237595
234900200529     C     DDACTN        ANDEQ     'D'                                                        237595
235000200529     C                   EXSR      FURDET
235100200529     C                   ENDIF
235200200529      *
235300200529     C                   ENDSR
235400200529      *****************************************************************
235500200529      /EJECT
235600200529      *****************************************************************
235700200529      * VAL@M  - VALIDATE INPUT TO MESSAGE DETAILS SCREEN
235800200529      *****************************************************************
235900200529     C     VAL@M         BEGSR
236000200529      *
236100200529      * Prior to validation, initialize error indicators as 'OK'
236200200529      *
236300200529     C                   Z-ADD     *ZERO         Idx
236400200529     C                   Z-ADD     *ZERO         WIdx_Mval
236500200529     C                   MOVE      *ALL'Y'       OKCuMsg
236600200529      *
236700200529      *----------------------------------------------------------------
236800200529      * IF ENQUIRE
236900200529      *
237000200529     C     DDACTN        IFEQ      'E'
237100200529      *
237200200529      * If displaying Further Details, return to message details screen
237300200529      * Otherwise move on to customer subfile display
237400200529      **  (but if window processing is on but Private Banking is off, display window)         213713
237500200529      *
237600200529     C     @INKX         IFNE      '1'
237700200529     C     @RDNB         IFEQ      'Y'
237800200529     C     BGN4ST        ANDEQ     'Y'
237900200529     C                   MOVEL     'I'           @SCRN
238000200529     C                   ELSE
238100200529     C/COPY WNCPYSRC,SDCUSDSC04
238200200529      **If*window*processing*on                                                     BUG6565 BUG10295
238300200529     C*****BGWDPR        IFEQ      'Y'                                              BUG6565 BUG10295
238400200529     C**********         MOVEL     'W'           @SCRN                              BUG6565 BUG10295
238500200529     C**********         ELSE                                                       BUG6565 BUG10295
238600200529     C                   IF        ULX043 = 'Y'                                               CER001
238700200529     C                             OR ULX609 = 'Y'                                          BUG10817
238800200529     C                   EVAL      @SCRN = 'L'                                                CER001
238900200529     C                   ELSE                                                                 CER001
239000200529                                                                                            BUG10295
239100200529      ** If window processing on                                                            BUG10295
239200200529     C     BGWDPR        IFEQ      'Y'                                                      BUG10295
239300200529     C                   MOVEL     'W'           @SCRN                                      BUG10295
239400200529     C                   ELSE                                                               BUG10295
239500200529     C                   EXSR      INITIAL
239600200529     C                   ENDIF                                                                CER001
239700200529     C/COPY WNCPYSRC,SDCUSDSC05
239800200529     C                   ENDIF                                                               BUG6565
239900200529     C                   ENDIF
240000200529     C                   ENDIF
240100200529      *
240200200529     C                   GOTO      EndVAL@M
240300200529     C                   END
240400200529      *----------------------------------------------------------------
240500200529      * IF INSERT OR AMEND / CHANGE
240600200529      *
240700200529     C     DDACTN        IFEQ      'I'
240800200529     C     DDACTN        OREQ      'A'
240900200529      *
241000200529      * Update 'previous' screens and previous number of warnings
241100200529
241200200529     C                   MOVEL     NewCuMsg      PrvCuMsg
241300200529     C                   Z-ADD     WIdx_Mval     PrvN_Warn
241400200529      *
241500200529      * Validate message details screen
241600200529      *
241700200529     C                   CALLB     'SDCUSD4VL'
241800200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
241900200529      * INPUTS :
242000200529      * Response mode
242100200529     C                   PARM                    RespMode
242200200529      ** Customer Primary Details
242300200529      ** Customer Secondary Details
242400200529     C                   PARM                    NewCuPrim
242500200529     C                   PARM                    NewCuSeco
242600200529      ** Customer Message Details
242700200529     C                   PARM                    NewCuMsg
242800200529      * Custom Extra Data file data
242900200529     C                   PARM                    ExtData
243000200529
243100200529      ** Message details OK indicators
243200200529     C                   PARM                    OKCuMsg
243300200529
243400200529      * Error fields/message IDs/message data (arrays) from/to caller
243500200529     C                   PARM                    FldNameArr
243600200529     C                   PARM                    MsgIDArr
243700200529     C                   PARM                    MsgDtaArr
243800200529      * Array index (3P0) from/to caller
243900200529     C                   PARM                    Idx
244000200529
244100200529      * Warning fields/message IDs/message data (arrays) from/to caller
244200200529     C                   PARM                    WFldNamArr
244300200529     C                   PARM                    WMsgIDArr
244400200529     C                   PARM                    WMsgDtaArr
244500200529      * Array index (3P0) from/to caller
244600200529     C                   PARM                    WIdx_Mval
244700200529
244800200529      * Valid Customer layout (DS) from/to caller
244900200529     C                   PARM                    NwCuFilFmt
245000200529      *
245100200529      * If errors returned
245200200529      *
245300200529     C     Idx           IFNE      0
245400200529     C                   GOTO      EndVAL@M
245500200529     C                   END
245600200529      *
245700200529      * If the screen has changed in the course of the validation
245800200529      * or if there are warnings which have not been displayed
245900200529      *   re-output the screen
246000200529      *
246100200529     C     NewCuMsg      IFNE      PrvCuMsg
246200200529     C     WIdx_Mval     ORNE      PrvN_Warn
246300200529     C                   GOTO      EndVAL@M
246400200529     C                   END
246500200529      *
246600200529      * Clear any warning messages
246700200529      *
246800200529     C                   MOVE      *ALL'Y'       OKCuMsg
246900200529     C                   MOVEL     *BLANK        WFldNamArr
247000200529     C                   MOVEL     *BLANK        WMsgIdArr
247100200529     C                   MOVEL     *BLANK        WMsgDtaArr
247200200529      *
247300200529      * If displaying Further Details, return to secondary details screen
247400200529      * Otherwise move on to Private Banking Screen
247500200529      **  (but if window processing is on but Private Banking is off, display window)         213713
247600200529      *
247700200529     C     @INKX         IFNE      '1'
247800200529     C     BGN4ST        IFEQ      'Y'
247900200529     C                   MOVEL     'I'           @SCRN
248000200529     C                   ELSE
248100200529     C/COPY WNCPYSRC,SDCUSDSC02
248200200529      *
248300200529      * If Action Code is I or A go to Update
248400200529      *
248500200529     C     DDACTN        IFEQ      'I'
248600200529     C     DDACTN        OREQ      'A'
248700200529      **If*window*processing*on                                                     BUG6565 BUG10295
248800200529     C*****BGWDPR        IFEQ      'Y'                                              BUG6565 BUG10295
248900200529     C**********         MOVEL     'W'           @SCRN                              BUG6565 BUG10295
249000200529     C**********         ELSE                                                       BUG6565 BUG10295
249100200529     C                   IF        ULX043 = 'Y'                                               CER001
249200200529     C                             OR ULX609 = 'Y'                                          BUG10817
249300200529     C                   EVAL      @SCRN = 'L'                                                CER001
249400200529     C                   ELSE                                                                 CER001
249500200529                                                                                            BUG10295
249600200529      ** If window processing on                                                            BUG10295
249700200529     C     BGWDPR        IFEQ      'Y'                                                      BUG10295
249800200529     C                   MOVEL     'W'           @SCRN                                      BUG10295
249900200529     C                   ELSE                                                               BUG10295
250000200529     C                   MOVEL     'U'           @SCRN
250100200529     C                   ENDIF                                                                CER001
250200200529     C                   ENDIF                                                               BUG6565
250300200529                                                                                            BUG10295
250400200529     C                   ELSE
250500200529     C                   MOVEL     'B'           @SCRN
250600200529     C                   ENDIF
250700200529     C/COPY WNCPYSRC,SDCUSDSC03
250800200529     C                   ENDIF
250900200529     C                   END
251000200529      *
251100200529     C                   ENDIF
251200200529      *
251300200529     C     EndVAL@M      ENDSR
251400200529      *****************************************************************
251500200529      /EJECT
251600200529      *****************************************************************
251700200529      * SCRN@R - PROCESS Private Banking Details Screen
251800200529      *****************************************************************
251900200529     C     SCRN@R        BEGSR
252000200529
252100200529
252200200529     C                   CALLB     'SDCUSD5DP'
252300200529      * INPUT PARAMETERS :
252400200529      * Return code
252500200529     C                   PARM                    RetCodeIn
252600200529      *
252700200529      * Primary Details
252800200529      * Private Banking Details
252900200529     C                   PARM                    NewCuPrim
253000200529     C                   PARM                    NewCuPriv
253100200529      *
253200200529      * Fields in error
253300200529     C                   PARM                    OKCuPriv
253400200529      *
253500200529      * ERRORS
253600200529     C                   PARM                    FldNameArr
253700200529     C                   PARM                    MsgIdArr
253800200529     C                   PARM                    MsgDtaArr
253900200529      *
254000200529      * KX = COMMAND KEY 23 = FURTHER DETAILS
254100200529     C                   PARM                    @EINKX            1
254200200529      *
254300200529      * OUTPUT PARAMETERS :
254400200529      *
254500200529      * Function Keys
254600200529     C                   PARM                    @INKC
254700200529     C                   PARM                    @INKL
254800200529     C                   PARM                    @INKX
254900200529      *
255000200529      * Write screen with no read indicator
255100200529     C                   PARM                    WriteOnly
255200200529      *
255300200529      *
255400200529      * F3 - End Program
255500200529     C     @INKC         CASEQ     '1'           ENDP
255600200529      *
255700200529      * F12 - Cancel on Base Rate Tax Screen
255800200529     C     @INKL         CASEQ     '1'           CANC@R
255900200529      *
256000200529      * Validate Input to Private Banking Screen
256100200529     C                   CAS                     VAL@R
256200200529      *
256300200529     C                   ENDCS
256400200529      *
256500200529      * On F23, go to Further Details, if there are no errors on this screen
256600200529      *
256700200529     C     @INKX         IFEQ      '1'
256800200529     C     Idx           ANDEQ     0
256900200529     C     @INKX         OREQ      '1'                                                        237595
257000200529     C     Idx           ANDNE     0                                                          237595
257100200529     C     DDACTN        ANDEQ     'D'                                                        237595
257200200529     C                   EXSR      FURDET
257300200529     C                   ENDIF
257400200529      *
257500200529      *
257600200529     C     EndRDSP       ENDSR
257700200529      /EJECT                                                                                  CER001
257800200529      *****************************************************************                       CER001
257900200529      *                                                               *                       CER001
258000200529      * SRSCRN@L - Process Extension Details Screen                   *                       CER001
258100200529      *                                                               *                       CER001
258200200529      *****************************************************************                       CER001
258300200529     C     SRSCRN@L      BEGSR                                                                CER001
258400200529      *                                                                                       CER001
258500200529     C                   MOVE      DDCUSN        #1CUST                                       CER001
258600200529     C                   MOVE      DDPAIN        #1PAIN                                       CER001
258700200529     C                   MOVE      DDPCNB        #1PCNB                                       CER001
258800200529     C                   MOVE      DDCOLC        #1COLC                                       CER001
258900200529     C                   MOVE      DDLINC        #1LINC                                       CER001
259000200529     C                   MOVE      DDBRCD        #1BRCD                                       CER001
259100200529     C                   MOVE      DDBNBI        #1BNBI                                       CER001
259200200529     C                   MOVE      DDCNCZ        #2CNCZ                                       CER001
259300200529     C                   MOVE      DDTMESTMP     #1TMST                                       CER001
259400200529     C                   MOVE      DDFOTRANID    #1FOTR                                       CER001
259500200529     C                   MOVE      DDCRNM        #1CRNM                                       CER001
259600200529      *                                                                                       CER001
259700200529     C                   MOVE      DDCUSN        KCUST                                        CER001
259800200529     C                   IF        ULX609 = 'Y'                                             BUG10817
259900200529     C                   EXSR      SRRTVEXT1                                                  CER001
260000200529     C                   ENDIF                                                              BUG10817
260100200529     C                   IF        ULX043 = 'Y'                                             BUG10817
260200200529     C                   EXSR      SRRTVEXT2                                                  CER001
260300200529     C                   ENDIF                                                              BUG10817
260400200529      *                                                                                       CER001
260500200529     C                   DOU       LOOP = 'N'                                                 CER001
260600200529     C                   EVAL      LOOP = 'N'                                                 CER001
260700200529      *                                                                                       CER001
260800200529     C                   IF        ULX609 = 'Y'                                             BUG10817
260900200529     C                   CALL      'SDCUSD2SN'                                                CER001
261000200529     C                   PARM      *Blanks       RetCodeIn                                    CER001
261100200529     C                   PARM      DDACTN        PWAction                                     CER001
261200200529     C                   PARM                    PDATA                                        CER001
261300200529     C                   PARM                    PWRtn                                        CER001
261400200529     C                   PARM                    NwDlScnFmt                                   CER001
261500200529     C                   PARM                    NwDlFilFmt1                                  CER001
261600200529     C                   PARM                    ULX008                                       CER001
261700200529     C                   PARM                    ULX012                                       CER001
261800200529     C                   PARM                    ULX048                                       CER001
261900200529     C                   PARM                    ULX609                                       CER001
262000200529     C                   PARM                    BGLRIN                                       CER001
262100200529     C                   PARM                    BJMRDT                                       CER001
262200200529     C                   PARM                    ULX004                                     BUG13228
262300200529      *                                                                                       CER001
262400200529      ** If F3 or F12 was pressed in called program                                           CER001
262500200529      ** or window/DB error                                                                   CER001
262600200529      *                                                                                       CER001
262700200529     C                   IF        (PWRtn = 'Y2U9999') or                                     CER001
262800200529     C                             (PWRtn = 'USR0790') or                                     CER001
262900200529     C                             (PWRtn = 'USR0563') or                                     CER001
263000200529     C                             (PWRtn = 'Y2U0004')                                        CER001
263100200529     C                   ITER                                                                 CER001
263200200529     C                   ENDIF                                                                CER001
263300200529     C                   ENDIF                                                              BUG10817
263400200529      *                                                                                       CER001
263500200529      ** If Enter is pressed and without error                                                CER001
263600200529      *                                                                                       CER001
263700200529     C                   IF        ULX043 = 'Y'                                             BUG10817
263800200529     C                   CALL      'SDCUSD3SN'                                                CER001
263900200529     C                   PARM      *Blanks       RetCodeIn                                    CER001
264000200529     C                   PARM      DDACTN        PWAction                                     CER001
264100200529     C                   PARM                    PDATA                                        CER001
264200200529     C                   PARM                    PWRtn                                        CER001
264300200529     C                   PARM                    NwDlScnFmt                                   CER001
264400200529     C                   PARM                    NwDlFilFmt2                                  CER001
264500200529     C                   PARM                    ULX043                                       CER001
264600200529     C                   PARM                    BGNWST                                       CER001
264700200529     C                   PARM                    BJMRDT                                       CER001
264800200529      *                                                                                       CER001
264900200529      ** If F12 was pressed in called program                                                 CER001
265000200529      *                                                                                       CER001
265100200529     C                   IF        (PWRtn = 'USR0790')                                        CER001
265200200529     C                   EVAL      LOOP = 'Y'                                                 CER001
265300200529     C                   ENDIF                                                                CER001
265400200529     C                   ENDIF                                                              BUG10817
265500200529      *                                                                                       CER001
265600200529     C                   ENDDO                                                                CER001
265700200529      *                                                                                       CER001
265800200529      *                                                                                       CER001
265900200529      ** If F3 pressed, end program                                                           CER001
266000200529      *                                                                                       CER001
266100200529     C                   IF        PWRtn = 'Y2U9999'                                          CER001
266200200529     C                   EXSR      ENDP                                                       CER001
266300200529     C                   ELSE                                                                 CER001
266400200529      *                                                                                       CER001
266500200529      ** Else if F12 pressed, return to Private Banking details screen                        CER001
266600200529      *                                                                                       CER001
266700200529     C                   IF        PWRtn = 'USR0790'                                          CER001
266800200529     C                   IF        BGN4ST = 'Y'                                               CER001
266900200529     C                   EVAL      @SCRN = 'I'                                                CER001
267000200529     C                   ELSE                                                                 CER001
267100200529     C                   EVAL      @SCRN = 'M'                                                CER001
267200200529     C                   ENDIF                                                                CER001
267300200529     C                   EVAL      WriteOnly = 'N'                                            CER001
267400200529     C                   ROLBK                                                                CER001
267500200529     C                   ELSE                                                                 CER001
267600200529      *                                                                                       CER001
267700200529      ** Else if ENTER key was pressed,                                                       CER001
267800200529      *                                                                                       CER001
267900200529     C                   IF        BGWDPR = 'Y'                                               CER001
268000200529     C                   EVAL      @SCRN = 'W'                                                CER001
268100200529     C                   IF        DDACTN = 'E'                                               CER001
268200200529     C                   IF        CSC011 = 'Y'                                               CER001
268300200529     C                             AND LIBR = S1SUPP                                          CER001
268400200529     C                   Z-ADD     *ZERO         Idx                                          CER001
268500200529     C                   MOVE      *ALL'Y'       OKCuPriv                                     CER001
268600200529     C                   EVAL      FldNameArr = *BLANKS                                       CER001
268700200529     C                   EVAL      MsgIdArr = *BLANKS                                         CER001
268800200529     C                   EVAL      MsgDtaArr = *BLANKS                                        CER001
268900200529     C                   ENDIF                                                                CER001
269000200529     C                   ENDIF                                                                CER001
269100200529     C                   ELSE                                                                 CER001
269200200529     C                   EVAL      @SCRN = 'U'                                                CER001
269300200529     C                   ENDIF                                                                CER001
269400200529      *                                                                                       CER001
269500200529     C                   ENDIF                                                                CER001
269600200529     C                   ENDIF                                                                CER001
269700200529      *                                                                                       CER001
269800200529     C                   ENDSR                                                                CER001
269900200529      *****************************************************************
270000200529      /EJECT                                                                                  189774
270100200529      *****************************************************************                       189774
270200200529      * SCRN@W - Window Processing                                                            189774
270300200529      *****************************************************************                       189774
270400200529     C     Scrn@W        BEGSR                                                                189774
270500200529     C/COPY WNCPYSRC,SDCUSDSC19
270600200529      *                                                                                       213713
270700200529     C     BGN4ST        IFEQ      'Y'                                                        213713
270800200529      *                                                                                       189774
270900200529     C                   CALLB     'SDCUSD5DP'                                                189774
271000200529      ** Input parameters                                                                     189774
271100200529     C                   PARM      *Blanks       RetCodeIn                                    189774
271200200529     C                   PARM                    NewCuPrim                                    189774
271300200529     C                   PARM                    NewCuPriv                                    189774
271400200529     C                   PARM                    OKCuPriv                                     189774
271500200529     C                   PARM                    FldNameArr                                   189774
271600200529     C                   PARM                    MsgIdArr                                     189774
271700200529     C                   PARM                    MsgDtaArr                                    189774
271800200529     C                   PARM                    @EINKX                                       189774
271900200529      ** Output parameters                                                                    189774
272000200529     C                   PARM                    @INKC                                        189774
272100200529     C                   PARM                    @INKL                                        189774
272200200529     C                   PARM                    @INKX                                        189774
272300200529     C                   PARM      'Y'           WriteOnly                                    189774
272400200529      *                                                                                       213713
272500200529     C                   ELSE                                                                 213713
272600200529      *                                                                                       213713
272700200529     C                   CALLB     'SDCUSD4DP'                                                213713
272800200529      *                                                                                       213713
272900200529      * INPUT PARAMETERS:                                                                     213713
273000200529     C                   PARM      *BLANK        RetCodeOut                                   213713
273100200529     C                   PARM                    NewCuPrim                                    213713
273200200529     C                   PARM                    NewCuMsg                                     213713
273300200529     C                   PARM                    OKCuMsg                                      213713
273400200529     C                   PARM                    FldNameArr                                   213713
273500200529     C                   PARM                    MsgIdArr                                     213713
273600200529     C                   PARM                    MsgDtaArr                                    213713
273700200529     C                   PARM                    WFldNamArr                                   213713
273800200529     C                   PARM                    WMsgIdArr                                    213713
273900200529     C                   PARM                    WMsgDtaArr                                   213713
274000200529     C                   PARM                    @EINKJ                                       213713
274100200529     C                   PARM                    @EINKX                                       213713
274200200529      ** OUTPUT PARAMETERS :                                                                  213713
274300200529     C                   PARM                    @INKC                                        213713
274400200529     C                   PARM                    @INKJ                                        213713
274500200529     C                   PARM                    @INKL                                        213713
274600200529     C                   PARM                    @INKX                                        213713
274700200529     C                   PARM      'Y'           WriteOnly                                    213713
274800200529      *                                                                                       213713
274900200529     C                   END                                                                  213713
275000200529      *                                                                                       189774
275100200529     C/COPY WNCPYSRC,SDCUSDSMV1                                                               189774
275200200529      *                                                                                       189774
275300200529      ** If BOE installed                                                                    LLN022A
275400200529      *                                                                                      LLN022A
275500200529     C                   IF        LLN022 = 'Y'                                              LLN022A
275600200529      *                                                                                      LLN022A
275700200529      ** Move fields from main screen to Data structure                                      LLN022A
275800200529      ** to be passed to window                                                              LLN022A
275900200529      ** Customer Number:                                                                    LLN022A
276000200529      *                                                                                      LLN022A
276100200529     C                   Eval      BYCUST = DDCUSN                                           LLN022A
276200200529      *                                                                                      LLN022A
276300200529      ** Institution and Industry Codes                                                      LLN022A
276400200529      *                                                                                      LLN022A
276500200529     C                   Eval      BYLINC = CULINC                                           LLN022A
276600200529     C                   Eval      BYLICD = CULICD                                           LLN022A
276700200529     C                   Eval      BYCOLC = CUCOLC                                           LLN022A
276800200529      *                                                                                      LLN022A
276900200529     C                   ENDIF                                                               LLN022A
277000200529      *                                                                                      LLN022A
277100200529     C                   CALL      'WN0010'                                                   189774
277200200529     C                   PARM      'SDCUSDSIN'   PWPgm            10                          189774
277300200529     C                   PARM                    PWKey             2                          189774
277400200529     C                   PARM      DDACTN        PWAction          1                          189774
277500200529     C                   PARM                    Data                                         189774
277600200529     C                   PARM      *Blanks       PWRtn             7                          189774
277700200529     C                   PARM                    PWSpare         256                          189774
277800200529      *                                                                                       189774
277900200529      ** If F3 pressed, end program                                                           189774
278000200529      *                                                                                       189774
278100200529     C     PWRtn         IFEQ      'Y2U9999'                                                  189774
278200200529     C                   EXSR      ENDP                                                       189774
278300200529     C                   ELSE                                                                 189774
278400200529      *                                                                                       189774
278500200529      ** Else if F12 pressed, return to Private Banking details screen                        189774
278600200529      *                                                                                       189774
278700200529     C     PWRtn         IFEQ      'USR0790'                                                  189774
278800200529     C     BGN4ST        IFEQ      'Y'                                                       BUG6565
278900200529     C                   EVAL      @SCRN = 'I'                                                189774
279000200529     C                   ELSE                                                                BUG6565
279100200529     C                   EVAL      @SCRN = 'M'                                               BUG6565
279200200529     C                   ENDIF                                                               BUG6565
279300200529     C                   EVAL      WriteOnly = 'N'                                            189774
279400200529     C                   ROLBK                                                                192916
279500200529     C                   ELSE                                                                 189774
279600200529      *                                                                                       189774
279700200529      ** Else if ENTER key was pressed,                                                       189774
279800200529      **      if action is Enquire, move on to initial subfile display                        189774
279900200529      **      if Insert or Delete, do update processing                                       189774
280000200529      *                                                                                       189774
280100200529     C     DDACTN        IFEQ      'E'                                                        189774
280200200529     C                   EXSR      INITIAL                                                    189774
280300200529     C                   ELSE                                                                 189774
280400200529     C     DDACTN        IFEQ      'I'                                                        189774
280500200529     C     DDACTN        OREQ      'A'                                                        189774
280600200529     C/COPY WNCPYSRC,SDCUSDSC20
280700200529     C                   EVAL      @SCRN = 'U'                                                189774
280800200529     C                   ENDIF                                                                189774
280900200529     C                   ENDIF                                                                189774
281000200529      *                                                                                       189774
281100200529     C                   ENDIF                                                                189774
281200200529     C                   ENDIF                                                                189774
281300200529      *                                                                                       189774
281400200529     C                   ENDSR                                                                189774
281500200529      *****************************************************************                       189774
281600200529      /EJECT
281700200529      *****************************************************************                       203036
281800200529      * SCRN@W2 - Window Processing(non private banking)                                      203036
281900200529      *****************************************************************                       203036
282000200529     C     Scrn@W2       BEGSR                                                                203036
282100200529      *                                                                                       203036
282200200529      *                                                                                       203036
282300200529     C*****/COPY*QWINDSRC,*SDCUSDSMV1**                                                203036 213713
282400200529     C/COPY WNCPYSRC,SDCUSDSMV1                                                               213713
282500200529      *                                                                                       203036
282600200529      ** If BOE installed                                                                    LLN022A
282700200529      *                                                                                      LLN022A
282800200529     C                   IF        LLN022 = 'Y'                                              LLN022A
282900200529      *                                                                                      LLN022A
283000200529      ** Move fields from main screen to Data structure                                      LLN022A
283100200529      ** to be passed to window                                                              LLN022A
283200200529      ** Customer Number:                                                                    LLN022A
283300200529      *                                                                                      LLN022A
283400200529     C                   Eval      BYCUST = DDCUSN                                           LLN022A
283500200529      *                                                                                      LLN022A
283600200529      ** Institution and Industry Codes                                                      LLN022A
283700200529      *                                                                                      LLN022A
283800200529     C                   Eval      BYLINC = CULINC                                           LLN022A
283900200529     C                   Eval      BYLICD = CULICD                                           LLN022A
284000200529     C                   Eval      BYCOLC = CUCOLC                                           LLN022A
284100200529      *                                                                                      LLN022A
284200200529     C                   ENDIF                                                               LLN022A
284300200529      *                                                                                      LLN022A
284400200529     C                   CALL      'WN0010'                                                   203036
284500200529     C                   PARM      'SDCUSDSIN'   PWPgm            10                          203036
284600200529     C                   PARM                    PWKey             2                          203036
284700200529     C                   PARM      DDACTN        PWAction          1                          203036
284800200529     C                   PARM                    Data                                         203036
284900200529     C                   PARM      *Blanks       PWRtn             7                          203036
285000200529     C                   PARM                    PWSpare         256                          203036
285100200529      *                                                                                       203036
285200200529      ** If F3 pressed, end program                                                           203036
285300200529      *                                                                                       203036
285400200529     C     PWRtn         IFEQ      'Y2U9999'                                                  203036
285500200529     C                   EXSR      ENDP                                                       203036
285600200529     C                   ELSE                                                                 203036
285700200529      *                                                                                       203036
285800200529      ** Else if F12 pressed, return to PROCESS MESSAGE DETAILS SCREEN                        203036
285900200529      *                                                                                       203036
286000200529     C     PWRtn         IFEQ      'USR0790'                                                  203036
286100200529     C     BGN4ST        IFEQ      'Y'                                                        203036
286200200529     C                   EVAL      @SCRN = 'I'                                                203036
286300200529     C                   ELSE                                                                 203036
286400200529     C                   EVAL      @SCRN = 'M'                                                203036
286500200529     C                   ENDIF                                                                203036
286600200529     C                   EVAL      WriteOnly = 'N'                                            203036
286700200529     C/COPY WNCPYSRC,SDH00109
286800200529     C                   ELSE                                                                 203036
286900200529      *                                                                                       203036
287000200529      ** Else if ENTER key was pressed,                                                       203036
287100200529      **      if action is Enquire, move on to initial subfile display                        203036
287200200529      **      if Insert or Delete, do update processing                                       203036
287300200529      *                                                                                       203036
287400200529     C     DDACTN        IFEQ      'E'                                                        203036
287500200529     C                   EXSR      INITIAL                                                    203036
287600200529     C                   ELSE                                                                 203036
287700200529     C     DDACTN        IFEQ      'I'                                                        203036
287800200529     C     DDACTN        OREQ      'A'                                                        203036
287900200529     C                   EVAL      @SCRN = 'U'                                                203036
288000200529     C                   ENDIF                                                                203036
288100200529     C                   ENDIF                                                                203036
288200200529      *                                                                                       203036
288300200529     C                   ENDIF                                                                203036
288400200529     C                   ENDIF                                                                203036
288500200529      *                                                                                       203036
288600200529     C                   ENDSR                                                                203036
288700200529     C/COPY WNCPYSRC,SDH00486
288800200529      *****************************************************************                       203036
288900200529      /EJECT                                                                                  203036
289000200529      *****************************************************************
289100200529      * VAL@R  - VALIDATE INPUT TO Private Banking Details
289200200529      *****************************************************************
289300200529     C     VAL@R         BEGSR
289400200529      *
289500200529      * Prior to validation, initialize error indicators as 'OK'
289600200529     C                   Z-ADD     *ZERO         Idx
289700200529     C                   MOVE      *ALL'Y'       OKCuPriv
289800200529      *
289900200529      * IF ENQUIRE
290000200529      *
290100200529     C     DDACTN        IFEQ      'E'
290200200529      *
290300200529      * Return to browse screen
290400200529      *
290500200529      * If displaying Further Details, return to message details screen
290600200529      * Otherwise move on to customer subfile display
290700200529      *    (but if window processing is on, display window)                                   189774
290800200529      *
290900200529     C     @INKX         IFNE      '1'
291000200529     C                   IF        ULX043 = 'Y'                                               CER001
291100200529     C                             OR ULX609 = 'Y'                                          BUG10817
291200200529     C                   EVAL      @SCRN = 'L'                                                CER001
291300200529     C                   ELSE                                                                 CER001
291400200529     C     BGWDPR        IFEQ      'Y'                                                        189774
291500200529     C                   MOVE      'W'           @SCRN                                        189774
291600200529     C                   IF        CSC011 = 'Y'                                               CSC011
291700200529     C                             AND LIBR = S1SUPP                                          CSC011
291800200529     C                   Z-ADD     *ZERO         Idx                                          CSC011
291900200529     C                   MOVE      *ALL'Y'       OKCuPriv                                     CSC011
292000200529     C                   EVAL      FldNameArr = *BLANKS                                       CSC011
292100200529     C                   EVAL      MsgIdArr = *BLANKS                                         CSC011
292200200529     C                   EVAL      MsgDtaArr = *BLANKS                                        CSC011
292300200529     C                   ENDIF                                                                CSC011
292400200529     C                   ELSE                                                                 189774
292500200529     C     @RDNB         IFEQ      'Y'
292600200529     C                   MOVE      'R'           @SCRN
292700200529     C                   ENDIF                                                                189774
292800200529     C                   ENDIF                                                                189774
292900200529     C                   ENDIF                                                                CER001
293000200529     C                   ELSE
293100200529     C                   IF        CSC011 = 'Y'                                               CSC011
293200200529     C                             AND LIBR = S1SUPP                                          CSC011
293300200529     C                   EVAL      @SCRN = 'I'                                                CSC011
293400200529     C                   ELSE                                                                 CSC011
293500200529     C                   EXSR      INITIAL
293600200529     C                   ENDIF                                                                CSC011
293700200529     C                   ENDIF
293800200529     C***********        ENDIF                                                                189774
293900200529     C                   GOTO      EndVAL@R
294000200529      *
294100200529     C                   ENDIF
294200200529      *
294300200529      *----------------------------------------------------------------
294400200529      * IF INSERT OR AMEND / CHANGE
294500200529      *
294600200529     C     DDACTN        IFEQ      'I'
294700200529     C     DDACTN        OREQ      'A'
294800200529
294900200529     C                   Z-ADD     *ZERO         Idx
295000200529     C                   MOVE      *ALL'Y'       OKCuPriv
295100200529     C                   MOVEL     *BLANK        FldNameArr
295200200529     C                   MOVEL     *BLANK        MsgIdArr
295300200529     C                   MOVEL     *BLANK        MsgDtaArr
295400200529      *
295500200529      *
295600200529      * Update 'previous' screens and previous number of warnings
295700200529
295800200529     C                   MOVEL     NewCuPriv     PrvCuPriv
295900200529      *
296000200529      * Validate Private Banking Details
296100200529      *
296200200529     C                   CALLB     'SDCUSD5VL'
296300200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
296400200529      * INPUTS :
296500200529      * Response mode
296600200529     C                   PARM                    RespMode
296700200529      *
296800200529      ** Private Banking Customer Indicator
296900200529     C                   PARM                    CUPRBA
297000200529      *
297100200529      ** Customer Private Banking Details
297200200529     C                   PARM                    NewCuPriv
297300200529      *                                                                         CPB002
297400200529      ** Portfolio Management Customer Indicator                                CPB002
297500200529     C                   PARM                    PtfrCust          1            CPB002
297600200529      *                                                                         CPB002
297700200529      ** Account Officer                                                        CPB002
297800200529     C                   PARM                    DDACOC                         CPB002
297900200529                                                                                              CGL031
298000200529      ** Customer Number                                                                      CGL031
298100200529     C                   PARM                    DDCUSN                                       CGL031
298200200529      *
298300200529      * OUTPUTS :
298400200529      ** Customer Base Rate Tax Details
298500200529     C                   PARM                    OKCuPriv
298600200529      *
298700200529      * Error fields/message IDs/message data (arrays) from/to caller
298800200529     C                   PARM                    FldNameArr
298900200529     C                   PARM                    MsgIDArr
299000200529     C                   PARM                    MsgDtaArr
299100200529      *
299200200529      * Array index (3P0) from/to caller
299300200529     C                   PARM                    Idx
299400200529      *
299500200529      * Valid Private Banking layout (DS) from/to caller
299600200529     C                   PARM                    NwPBFilFmt
299700200529      *
299800200529      *
299900200529      * If any errors redisplay screen
300000200529     C     Idx           IFNE      0
300100200529     C                   GOTO      ENDVAL@R
300200200529     C                   ENDIF
300300200529      *
300400200529      * If the screen has changed in the course of the validation
300500200529      * or if there are warnings which have not been displayed
300600200529      *   re-output the screen
300700200529      *
300800200529     C     NewCuPriv     IFNE      PrvCuPriv
300900200529     C                   GOTO      EndVAL@R
301000200529     C                   END
301100200529      *
301200200529      ** Clear error indicators
301300200529     C                   MOVE      *ALL'Y'       OKCuPriv
301400200529      *
301500200529      * If displaying Further Details, go ahead, otherwise update.
301600200529      *
301700200529     C     @INKX         IFNE      '1'
301800200529      *
301900200529      * If Action Code is I or A go to Update
302000200529      *
302100200529     C     DDACTN        IFEQ      'I'
302200200529     C     DDACTN        OREQ      'A'
302300200529     C                   IF        ULX043 = 'Y'                                               CER001
302400200529     C                             OR ULX609 = 'Y'                                          BUG10817
302500200529     C                   EVAL      @SCRN = 'L'                                                CER001
302600200529     C                   ELSE                                                                 CER001
302700200529      *                                                                                       189774
302800200529     C     BGWDPR        IFEQ      'Y'                                                        189774
302900200529     C                   MOVE      'W'           @SCRN                                        189774
303000200529     C                   ELSE                                                                 189774
303100200529     C                   MOVEL     'U'           @SCRN
303200200529     C                   ENDIF                                                                189774
303300200529      *                                                                                       189774
303400200529     C                   ENDIF                                                                CER001
303500200529     C                   ELSE
303600200529     C                   MOVEL     'B'           @SCRN
303700200529     C                   ENDIF
303800200529      *
303900200529     C                   ENDIF
304000200529      *
304100200529      * End of Insert/Amend condition controlling validation call
304200200529     C                   ENDIF
304300200529      *
304400200529      *
304500200529     C     EndVAL@R      ENDSR
304600200529      *****************************************************************
304700200529      /EJECT
304800200529      *****************************************************************
304900200529      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH CUSTOMER FILE
305000200529      *****************************************************************
305100200529     C     ROLL          BEGSR
305200200529      *
305300200529      * If action is insert, control return to key screen
305400200529      *
305500200529     C     DDACTN        IFEQ      'I'
305600200529     C                   MOVE      'Y'           INSERTENQ         1
305700200529     C                   END
305800200529      *
305900200529      * Default action code to enquiry if action insert or not valid
306000200529      *
306100200529     C     DDACTN        IFNE      'A'
306200200529     C     DDACTN        ANDNE     'D'
306300200529     C                   MOVE      'E'           DDACTN
306400200529     C                   END
306500200529      *
306600200529      * READ NEXT OR PREVIOUS RECORD ON CUSTOMER FILE
306700200529      * ACCORDING TO COMMAND KEY TAKEN (F7/@INKG OR F8/@INKH)
306800200529      *
306900200529     C     @INKG         IFEQ      '1'
307000200529     C                   MOVEL     *BLANK        @RDFWD
307100200529     C                   MOVEL     'Y'           @RDBCK
307200200529     C                   ELSE
307300200529     C                   MOVEL     'Y'           @RDFWD
307400200529     C                   MOVEL     *BLANK        @RDBCK
307500200529     C                   END
307600200529      *
307700200529     C                   CALLB     'SDCUSDRED'
307800200529      *
307900200529      * INPUT PARAMETERS
308000200529      *
308100200529      * Return Code
308200200529     C                   PARM      *BLANK        RetCodeOut
308300200529      *
308400200529      * Action Code
308500200529     C                   PARM                    DDACTN
308600200529      *
308700200529      * CUSTO REF. POINTER
308800200529     C                   PARM                    DDCUSN
308900200529      *
309000200529      * READ FORWARDS
309100200529     C                   PARM                    @RDFWD            1
309200200529      *
309300200529      * READ BACKWARDS
309400200529     C                   PARM                    @RDBCK            1
309500200529      ** Acceptance Mode                                                                      CSD031
309600200529     C                   PARM                    PAccMde                                      CSD031
309700200529      *
309800200529      * OUTPUT PARAMETERS
309900200529      *
310000200529      * Error message
310100200529     C                   PARM      *BLANK        @ERRMS            7
310200200529     C                   PARM      *BLANK        @data            45                          249076
310300200529      *
310400200529      * CUSTO REF. READ
310500200529     C                   PARM      *BLANK        @CURED            6
310600200529      *
310700200529      * If error message returned from read, send it to detail screen
310800200529      *
310900200529     C     @ERRMS        IFNE      *BLANK
311000200529     C                   EXSR      SNDM@P
311100200529     C                   GOTO      EROLL
311200200529     C                   END
311300200529      *
311400200529      * If customer read
311500200529      *
311600200529     C     @CURED        IFNE      *BLANK
311700200529      *
311800200529      * Retrieve customer details
311900200529      *
312000200529     C                   MOVEL     @CURED        DDCUSN
312100200529     C                   EXSR      RTVCUS
312200200529      *
312300200529      * Return to browse screen if there is an error on customer number
312400200529      *
312500200529     C     DDCUSNOK      IFEQ      'N'
312600200529     C     DDACTNOK      OREQ      'N'
312700200529     C                   MOVEL     'B'           @SCRN
312800200529     C                   GOTO      EROLL
312900200529     C                   ENDIF
313000200529      *                                                                         CPB002
313100200529      * Check if customer is a Portfolio Management customer.                   CPB002
313200200529     C                   EXSR      CHKPTFR                                      CPB002
313300200529      *
313400200529      * Convert Customer
313500200529     C                   EXSR      CVTCUS
313600200529     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
313700200529     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
313800200529     C                   CLEAR                   NwPbFilFmt
313900200529     C                   MOVEL     CrPbFilFmt    NwPbFilFmt
314000200529     C                   MOVEL     CrTIFilFmt    NwTIFilFmt                                  BUG3362
314100200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
314200200529     C                   MOVEL     CrSwFilFmt    NwSwFilFmt                                   CSW207
314300200529     C                   ENDIF                                                                CSW207
314400200529     C/COPY WNCPYSRC,SDH00742
314500200529     C                   IF        CSW213 = 'Y'                                             MD022395
314600200529     C                   EVAL      DDLEIC = C_CSLEIC                                        MD022395
314700200529     C                   EVAL      DDCLSY = C_CSCLSY                                        MD022395
314800200529     C                   EVAL      DDCLID = C_CSCLID                                        MD022395
314900200529     C                   ENDIF                                                              MD022463
315000200529     C                   IF        CFT050 = 'Y'                                             MD022463
315100200529     C                   EVAL      DDBDRK = C_CSBDRK                                        MD022395
315200200529     C                   ENDIF                                                              MD022395
315300200529      *
315400200529      * Put the customer on the primary details screen
315500200529      *
315600200529     C                   MOVEL     'P'           @SCRN
315700200529      *
315800200529     C                   ENDIF
315900200529      *
316000200529     C     EROLL         ENDSR
316100200529      *****************************************************************
316200200529      /EJECT
316300200529      *****************************************************************
316400200529      * BLDBRW - BUILD BROWSE SUBFILE
316500200529      *****************************************************************
316600200529     C     BLDBRW        BEGSR
316700200529      *
316800200529      * Set/reset return to key screen from primary details
316900200529     C                   MOVE      'N'           INSERTENQ         1
317000200529      *
317100200529      * Reset Read next browse subfile record
317200200529     C                   MOVEL     *BLANK        @RDNB             1
317300200529      *
317400200529      * Build Browse subfile
317500200529     C                   CALLB     'SDCUSDBRW'
317600200529      *
317700200529      * INPUT PARAMETERS :
317800200529      * Return Code
317900200529      * Action Code
318000200529      * Customer Ref. Pointer
318100200529      * Build subfile
318200200529      * Read subfile record
318300200529      * Mode                                                                                  CLE025
318400200529     C                   PARM      *BLANK        RetCodeOut
318500200529     C                   PARM                    DDACTN
318600200529     C                   PARM                    DDCUSN
318700200529     C                   PARM      'Y'           @BDSFL            1
318800200529     C                   PARM      *BLANK        @RDSFL            1
318900200529     C                   PARM                    PMODE                                        CLE025
319000200529     C                   PARM                    FldNameArr
319100200529     C                   PARM                    MsgIdArr
319200200529     C                   PARM                    MsgDtaArr
319300200529     C                   PARM                    CSD037                                       CSD031
319400200529      *
319500200529      * OUTPUT PARAMETERS :
319600200529      * Error message
319700200529      * Option Selected
319800200529      * Customer Reference Selected
319900200529      * Command Keys
320000200529     C                   PARM      *BLANK        @ERRMS
320100200529     C                   PARM      *BLANK        @data                                        249076
320200200529     C                   PARM      *BLANK        @OPSEL            1
320300200529     C                   PARM      *BLANK        @CUSEL            6
320400200529     C                   PARM      '0'           @INKC
320500200529     C                   PARM      '0'           @INKI             1
320600200529      ** Acceptance Mode                                                                      CSD031
320700200529     C                   PARM                    PAccMde                                      CSD031
320800200529      *
320900200529      * If F3 taken in browse, End Program
321000200529     C     @INKC         IFEQ      '1'
321100200529     C                   EXSR      ENDP
321200200529     C                   GOTO      EndBLDBRW
321300200529     C                   END
321400200529      *
321500200529      * If Insert (F9) selected from browse, go to key screen
321600200529     C     @OPSEL        IFEQ      'I'
321700200529     C                   MOVEL     'K'           @SCRN
321800200529     C                   MOVE      'I'           DDACTN
321900200529     C                   GOTO      EndBLDBRW
322000200529     C                   END
322100200529      *
322200200529      * If error message returned from browse, send it to detail screen
322300200529      *
322400200529     C     @ERRMS        IFNE      *BLANK
322500200529     C                   EXSR      SNDM@P
322600200529     C                   GOTO      EndBLDBRW
322700200529     C                   END
322800200529      *
322900200529      * Read next browse subfile record
323000200529      *
323100200529      *
323200200529     C                   MOVE      'Y'           @RDNB
323300200529     C                   MOVEL     'R'           @SCRN
323400200529      *
323500200529     C     EndBLDBRW     ENDSR
323600200529      *****************************************************************
323700200529      /EJECT
323800200529      *****************************************************************
323900200529      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
324000200529      *****************************************************************
324100200529     C     RDNBRW        BEGSR
324200200529      *
324300200529      * Read Next Subfile Record
324400200529      *
324500200529     C                   CALLB     'SDCUSDBRW'
324600200529      * INPUT PARAMETERS :
324700200529      * Return code
324800200529      * Action code
324900200529      * Customer Ref. pointer
325000200529      * Build Sub-file
325100200529      * Read Sub-file record
325200200529      * Browse Screen
325300200529     C                   PARM      *BLANK        RetCodeOut
325400200529     C                   PARM                    DDACTN
325500200529     C                   PARM                    DDCUSN
325600200529     C                   PARM      *BLANK        @BDSFL
325700200529     C                   PARM      'Y'           @RDSFL
325800200529     C                   PARM                    PMODE                                        CLE025
325900200529     C                   PARM                    FldNameArr
326000200529     C                   PARM                    MsgIdArr
326100200529     C                   PARM                    MsgDtaArr
326200200529     C                   PARM                    CSD037                                       CSD031
326300200529      * OUTPUT PARAMETERS :
326400200529      * Error Message
326500200529      * Option Selected
326600200529      * Customer Ref. selected
326700200529      * Function keys
326800200529     C                   PARM      *BLANK        @ERRMS
326900200529     C                   PARM      *BLANK        @data                                        249076
327000200529     C                   PARM      *BLANK        @OPSEL
327100200529     C                   PARM      *BLANK        @CUSEL
327200200529     C                   PARM      '0'           @INKC
327300200529     C                   PARM      '0'           @INKI
327400200529      ** Acceptance Mode                                                                      CSD031
327500200529     C                   PARM                    PAccMde                                      CSD031
327600200529      *
327700200529      * If Customer read from subfile
327800200529     C     @CUSEL        IFNE      *BLANK
327900200529      *
328000200529      * Retrieve Customer details
328100200529      *
328200200529     C                   MOVEL     @OPSEL        DDACTN
328300200529     C                   MOVEL     @CUSEL        DDCUSN
328400200529     C                   EXSR      RTVCUS
328500200529      *
328600200529      * Stay on browse screen if there is an error on customer number
328700200529      *
328800200529     C     DDCUSNOK      IFEQ      'N'
328900200529     C     DDACTN        ANDNE     'D'                                                        237595
329000200529     C     DDACTNOK      OREQ      'N'
329100200529     C                   MOVEL     'B'           @SCRN
329200200529     C                   GOTO      EndRDNBRW
329300200529     C                   ENDIF
329400200529     C                   MOVE      *ALL'Y'       OKCuPrim                                     237595
329500200529     C                   MOVEL     *BLANK        FldNameArr                                   237595
329600200529     C                   MOVEL     *BLANK        MsgIdArr                                     237595
329700200529     C                   MOVEL     *BLANK        MsgDtaArr                                    237595
329800200529     C                   MOVEL     *BLANK        WFldNamArr                                   237595
329900200529     C                   MOVEL     *BLANK        WMsgIdArr                                    237595
330000200529     C                   MOVEL     *BLANK        WMsgDtaArr                                   237595
330100200529     C                   Z-ADD     0             Idx                                          237595
330200200529      *                                                                         CPB002
330300200529      * Check if customer is a Portfolio Management customer.                   CPB002
330400200529     C                   EXSR      CHKPTFR                                      CPB002
330500200529      *
330600200529      * Convert Customer details
330700200529     C                   EXSR      CVTCUS
330800200529     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
330900200529     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
331000200529     C                   MOVEL     CrPBFilFmt    NwPBFilFmt
331100200529     C                   MOVEL     CrTIFilFmt    NwTIFilFmt                                  BUG3362
331200200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
331300200529     C                   MOVEL     CrSwFilFmt    NwSwFilFmt                                   CSW207
331400200529     C                   ENDIF                                                                CSW207
331500200529     C/COPY WNCPYSRC,SDH00743
331600200529     C                   IF        CSW213 = 'Y'                                             MD022395
331700200529     C                   EVAL      DDLEIC = C_CSLEIC                                        MD022395
331800200529     C                   EVAL      DDCLSY = C_CSCLSY                                        MD022395
331900200529     C                   EVAL      DDCLID = C_CSCLID                                        MD022395
332000200529     C                   ENDIF                                                              MD022854
332100200529     C                   IF        CFT050 = 'Y'                                             MD022854
332200200529     C                   EVAL      DDBDRK = C_CSBDRK                                        MD022395
332300200529     C                   ENDIF                                                              MD022395
332400200529     C     DDCUSN        IFNE      FDCUST                                                     244030
332500200529     C                   CLEAR                   FURDETS                                      244030
332600200529     C                   MOVE      DDCUSN        FDCUST                                       244030
332700200529     C                   MOVE      DDCSSN        FDCSSN                                       244030
332800200529     C                   MOVE      DDCRTN        FDCRTN                                       244030
332900200529     C                   MOVE      DDCRNM        FDCRNM                                       244030
333000200529     C                   MOVE      DDLINC        FDLINC                                       244030
333100200529     C                   MOVE      C_BBTICS      FDTICS                                       244030
333200200529     C                   MOVEL     CrTIFilFMt    FDCTID                                       244030
333300200529     C                   ENDIF                                                                244030
333400200529      *
333500200529      * Put customer on key screen for Insert, primary details otherwise
333600200529      *
333700200529     C     @OPSEL        IFEQ      'I'
333800200529     C                   MOVEL     'K'           @SCRN
333900200529     C                   ELSE
334000200529     C/COPY WNCPYSRC,SDH00487
334100200529     C                   MOVEL     'P'           @SCRN
334200200529     C/COPY WNCPYSRC,SDH00488
334300200529     C                   END
334400200529     C                   EXSR      SFDS@P
334500200529      *
334600200529      * Else, go to initial screen
334700200529      *
334800200529     C                   ELSE
334900200529     C                   EXSR      INITIAL
335000200529     C                   END
335100200529      *
335200200529     C     EndRDNBRW     ENDSR
335300200529      *****************************************************************
335400200529      /EJECT
335500200529      *****************************************************************
335600200529      * RTVCUS - RETRIEVE CUSTO
335700200529      *****************************************************************
335800200529     C     RTVCUS        BEGSR
335900200529      *
336000200529      * RETRIEVE CUSTOMER
336100200529      *
336200200529     C                   CALLB     'SDCUSDRTV'
336300200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
336400200529      * INPUTS :
336500200529      * Return code
336600200529     C                   PARM      *BLANK        RetCodeOut
336700200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
336800200529      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
336900200529     C                   PARM      '      '      @@MODE            6
337000200529      * Response mode
337100200529     C                   PARM      'S'           @@RSMD            1
337200200529      * Action Code
337300200529     C                   PARM                    DDACTN
337400200529      * Front Office Transaction ID
337500200529     C                   PARM                    C_BBFRNT
337600200529      * (Midas) Trade Reference
337700200529     C                   PARM                    DDCUSN
337800200529      * Base Rate Auth req                                                                    CSD012
337900200529     C                   PARM                    AUTHRQ                                       CSD012
338000200529      * Base Auth mode                                                                        CSD012
338100200529     C                   PARM                    AUTHMD                                       CSD012
338200200529      *
338300200529      *  Base Rate Tax option feature is switched on
338400200529     C                   PARM                    S01383
338500200529      *  Private Banking Customer module is switched on
338600200529     C                   PARM                    BGN4ST
338700200529      ** Global Data Layout feature is switched on                                            CGP001
338800200529     C                   PARM                    CGP001                                       CGP001
338900200529      ** KYC: Transaction Type                                                                CSD028
339000200529                                                                                              CSD028
339100200529     C                   PARM                    TransType                                    CSD028
339200200529      ** Acceptance Mode                                                                      CSD031
339300200529     C                   PARM                    PAccMde                                      CSD031
339400200529      ** Update (Y/N)                                                                         CSD031
339500200529     C                   PARM                    PUpdYN                                       CSD031
339600200529      * OUTPUTS :
339700200529      * (Current) Customer in file format
339800200529      * Current Customer Base Rate Tax in file format
339900200529      ** (Current) Global Customer X-Reference in file format                                 CGP001
340000200529     C                   PARM                    CrCuFilFmt
340100200529     C                   PARM                    CrBrFilFmt
340200200529     C                   PARM                    CrPBFilFmt
340300200529     C                   PARM                    CrTIFilFmt                                  BUG3362
340400200529     C                   PARM                    GCrCuFilFmt                                  CGP001
340500200529     C                   PARM                    CrcmFilFmt                                   CRE026
340600200529     C                   PARM                    CracFilFmt                                   CRE026
340700200529     C                   PARM                    CrcfFilFmt                                   CRE026
340800200529     C                   PARM                    CrchFilFmt                                   CRE026
340900200529     C                   PARM                    CrsaFilFmt                                   CRE026
341000200529     C                   PARM                    CrvrFilFmt                                   CRE026
341100200529     C                   PARM                    CrfoFilFmt                                   CRE026
341200200529     C                   PARM                    CroxFilFmt                                   CRE026
341300200529     C                   PARM                    CrplFilFmt                                   CRE026
341400200529     C                   PARM                    Crx2FilFmt                                   CRE026
341500200529     C                   PARM                    Crx1fFilFmt                                  CRE026
341600200529     C                   PARM                    CrSwFilFmt                                   CSW207
341700200529     C**********         PARM                    CuSW13                              CFT050 MD022395
341800200529     C                   PARM                    CrCuSW13                                   MD022395
341900200529     C                   PARM                    TranInCUAH                                   CER059
342000200529     C                   PARM                    TranInCCTX                                   CER059
342100200529     C                   PARM                    CurCuPrim                                    CFT050
342200200529     C                   PARM                    CurCuSeco                                    CFT050
342300200529     C                   PARM                    CurCuMT3x                                    CFT050
342400200529     C/COPY WNCPYSRC,SDH00744
342500200529      * OK - Action code
342600200529     C                   PARM      *BLANK        DDACTNOK
342700200529      * OK - Customer Reference
342800200529     C                   PARM      *BLANK        DDCUSNOK
342900200529      * Error fields/message IDs/message data (arrays) from/to caller
343000200529     C                   PARM                    FldNameArr
343100200529     C                   PARM                    MsgIdArr
343200200529     C                   PARM                    MsgDtaArr
343300200529      * Array index (3P0) from/to caller
343400200529     C                   PARM      *ZERO         Idx
343500200529      **Base*Rate Auth req                                                             CSD012 222373
343600200529     C**********         PARM                    AUTHRQ                                CSD012 222373
343700200529      *                                                                                     BUG23518
343800200529      * Warning fields/message IDs/message data (arrays) from/to caller                     BUG23518
343900200529     C                   PARM                    WFldNamArr                                 BUG23518
344000200529     C                   PARM                    WMsgIDArr                                  BUG23518
344100200529     C                   PARM                    WMsgDtaArr                                 BUG23518
344200200529      *                                                                                     BUG23518
344300200529      * Array index (3P0) from/to caller                                                    BUG23518
344400200529     C                   PARM      *ZEROS        WIdx_PVAL                                  BUG23518
344500200529     C/COPY WNCPYSRC,SDCUSDSC13
344600200529
344700200529     C     EndRTVCUS     ENDSR
344800200529      *****************************************************************                       CER001
344900200529      /EJECT                                                                                  CER001
345000200529      *****************************************************************                       CER001
345100200529      *                                                               *                       CER001
345200200529      * SRRTVEXT1 - Retrieve customer extension group 1               *                       CER001
345300200529      *                                                               *                       CER001
345400200529      *****************************************************************                       CER001
345500200529     C     SRRTVEXT1     BEGSR                                                                CER001
345600200529      *                                                                                       CER001
345700200529      ** Retrieve record in extension file                                                    CER001
345800200529      *                                                                                       CER001
345900200529     C     K@KEY1        CHAIN(N)  RTVIDXA                            85                      CER001
346000200529      *                                                                                       CER001
346100200529     C                   SELECT                                                               CER001
346200200529      *                                                                                       CER001
346300200529      ** If record exist                                                                      CER001
346400200529      *                                                                                       CER001
346500200529     C                   WHEN      *IN85 = *OFF                                               CER001
346600200529      *                                                                                       CER001
346700200529     C                   EVAL      WFIND1 = 'Y'                                               CER001
346800200529      *                                                                                       CER001
346900200529     C*********          IF        VFCGRP = 0                                         CER001 CSD027A
347000200529     C                   IF        VFCGRP = *BLANKS                                          CSD027A
347100200529     C                   MOVE      *BLANKS       L6LXCGRP                                     CER001
347200200529     C                   ELSE                                                                 CER001
347300200529     C                   MOVE      VFCGRP        L6LXCGRP                                     CER001
347400200529     C                   ENDIF                                                                CER001
347500200529      *                                                                                       CER001
347600200529      ** Use the SR/ZEDIT to format the Provisions Forfaitaires                               CER001
347700200529      *                                                                                       CER001
347800200529     C                   MOVE      *BLANKS       ZFIELD           16                          CER001
347900200529     C                   MOVE      VFPAPS        ZFIELD                                       CER001
348000200529     C                   Z-ADD     2             ZADEC             1 0                        CER001
348100200529     C                   CALLB     'ZEDIT'                                                    CER001
348200200529     C                   PARM                    ZFIELD                                       CER001
348300200529     C                   PARM                    ZADEC                                        CER001
348400200529     C                   MOVE      ZFIELD        L6LXPAPS                                     CER001
348500200529      *                                                                                       CER001
348600200529     C                   MOVE      VFCONS        L6LXCONS                                     CER001
348700200529     C                   MOVE      VFECOS        L6LXECOS                                     CER001
348800200529     C                   MOVE      VFNCOS        L6LXNCOS                                     CER001
348900200529     C                   MOVE      VFINRF        L6LXINRF                                     CER001
349000200529     C                   MOVE      VFPERF        L6LXPERF                                     CER001
349100200529     C                   MOVE      VFSMRS        L6LXSMRS                                     CER001
349200200529      *                                                                                       CER001
349300200529     C                   IF        ULX012 = 'Y'                                               CER001
349400200529     C                   MOVE      VFAUTG        L6LXAUTG                                     CER001
349500200529     C                   MOVE      VFPROG        L6LXPROG                                     CER001
349600200529     C                   MOVE      VFASSP        L6LXASSP                                     CER001
349700200529     C                   ENDIF                                                                CER001
349800200529      *                                                                                       CER001
349900200529     C                   IF        ULX008 = 'Y'                                               CER001
350000200529     C                   MOVE      VFICCD        L6LXICCD                                     CER001
350100200529     C                   MOVE      VFMCID        L6LXMCID                                     CER001
350200200529     C                   ENDIF                                                                CER001
350300200529      *                                                                                       CER001
350400200529     C                   EVAL      #6LXVFFOTR  =  DDFOTRANID                                  CER001
350500200529     C                   EVAL      #6LXVFCUST  =  VFCUST                                      CER001
350600200529     C                   EVAL      #6LXVFCONS  =  VFCONS                                      CER001
350700200529     C                   EVAL      #6LXVFECOS  =  VFECOS                                      CER001
350800200529     C                   EVAL      #6LXVFINRF  =  VFINRF                                      CER001
350900200529     C                   EVAL      #6LXVFCGRP  =  VFCGRP                                      CER001
351000200529     C                   EVAL      #6LXVFCRNM  =  VFCRNM                                      CER001
351100200529     C                   EVAL      #6LXVFCOLC  =  VFCOLC                                      CER001
351200200529     C                   EVAL      #6LXVFPAPS  =  VFPAPS                                      CER001
351300200529     C                   EVAL      #6LXVFPERF  =  VFPERF                                      CER001
351400200529     C                   EVAL      #6LXVFNCOS  =  VFNCOS                                      CER001
351500200529     C                   EVAL      #6LXVFAUTG  =  VFAUTG                                      CER001
351600200529     C                   EVAL      #6LXVFPROG  =  VFPROG                                      CER001
351700200529     C                   EVAL      #6LXVFASSP  =  VFASSP                                      CER001
351800200529     C                   EVAL      #6LXVFICCD  =  VFICCD                                      CER001
351900200529     C                   EVAL      #6LXVFMCID  =  VFMCID                                      CER001
352000200529     C                   EVAL      #6LXVFSMRS  =  VFSMRS                                      CER001
352100200529     C                   EVAL      #6LXVFTMES  =  DDTMESTMP                                   CER001
352200200529      *                                                                                       CER001
352300200529     C                   MOVE      NwDlScnFmt    CrDlScnFmt                                   CER001
352400200529      *                                                                                       CER001
352500200529      ** If record does not exist                                                             CER001
352600200529      *                                                                                       CER001
352700200529     C                   WHEN      *IN85 = *ON                                                CER001
352800200529      *                                                                                       CER001
352900200529     C                   EVAL      WFIND1 = *BLANKS                                           CER001
353000200529      *                                                                                       CER001
353100200529     C                   EVAL      L6LXPAPS = *BLANKS                                         CER001
353200200529     C                   EVAL      L6LXCGRP = *BLANKS                                         CER001
353300200529     C                   EVAL      L6LXCONS = '0'                                             CER001
353400200529                                                                                            BG12345A
353500200529     C                   IF        ULX043 = 'Y' AND BGNWST = 'Y'                            BG12345A
353600200529      *                                                                                       CER001
353700200529     C     #1LINC        CHAIN     SDINX1L0                           99                      CER001
353800200529     C                   IF        *IN99 = *ON                                                CER001
353900200529     C                   EVAL      L6LXECOS = '4000'                                          CER001
354000200529     C                   EVAL      L6LXNCOS = '9000'                                          CER001
354100200529     C                   ELSE                                                                 CER001
354200200529      *                                                                                       CER001
354300200529     C                   SELECT                                                               CER001
354400200529     C                   WHEN      #1COLC = 'LU'                                              CER001
354500200529     C                   MOVE      AOECOL        L6LXECOS                                     CER001
354600200529     C                   WHEN      #1COLC = 'BE'                                              CER001
354700200529     C                   MOVE      AOECOB        L6LXECOS                                     CER001
354800200529     C                   OTHER                                                                CER001
354900200529     C                   MOVE      AOECOO        L6LXECOS                                     CER001
355000200529     C                   ENDSL                                                                CER001
355100200529      *                                                                                       CER001
355200200529      ** Retrieve data SDCTX2L0                                                               CER001
355300200529      *                                                                                       CER001
355400200529     C     #1COLC        CHAIN     SDCTX2L0                           99                      CER001
355500200529     C                   IF        *IN99 = *ON                                                CER001
355600200529     C                   ENDIF                                                                CER001
355700200529      *                                                                                       CER001
355800200529     C                   SELECT                                                               CER001
355900200529     C                   WHEN      #1COLC = 'LU'                                              CER001
356000200529     C                   MOVE      AONCOL        L6LXNCOS                                     CER001
356100200529     C                   WHEN      #1COLC <> 'LU'  AND                                        CER001
356200200529     C                             WFEMUM = 'Y'                                               CER001
356300200529     C                   MOVE      AONCOE        L6LXNCOS                                     CER001
356400200529     C                   OTHER                                                                CER001
356500200529     C                   MOVE      AONCOO        L6LXNCOS                                     CER001
356600200529     C                   ENDSL                                                                CER001
356700200529      *                                                                                       CER001
356800200529     C                   ENDIF                                                              BG12345A
356900200529     C                   ENDIF                                                                CER001
357000200529      *                                                                                       CER001
357100200529     C                   EVAL      L6LXINRF = '0'                                             CER001
357200200529     C                   EVAL      L6LXPERF = *BLANKS                                         CER001
357300200529     C                   EVAL      L6LXSMRS = *BLANKS                                         CER001
357400200529      *                                                                                       CER001
357500200529     C                   IF        ULX012 = 'Y'                                               CER001
357600200529     C                   EVAL      L6LXAUTG = *BLANKS                                         CER001
357700200529     C                   EVAL      L6LXPROG = *BLANKS                                         CER001
357800200529     C                   EVAL      L6LXASSP = *BLANKS                                         CER001
357900200529     C                   ENDIF                                                                CER001
358000200529      *                                                                                       CER001
358100200529     C                   IF        ULX008 = 'Y'                                               CER001
358200200529     C                   EVAL      L6LXICCD = *BLANKS                                         CER001
358300200529     C                   IF        ULX048 = 'Y'                                               CER001
358400200529     C                   EVAL      L6LXMCID = 'Y'                                             CER001
358500200529     C                   ELSE                                                                 CER001
358600200529     C                   EVAL      L6LXMCID = 'N'                                             CER001
358700200529     C                   ENDIF                                                                CER001
358800200529     C                   ENDIF                                                                CER001
358900200529      *                                                                                       CER001
359000200529     C                   ENDSL                                                                CER001
359100200529      *                                                                                       CER001
359200200529     C                   ENDSR                                                                CER001
359300200529      *****************************************************************                       CER001
359400200529      /EJECT                                                                                  CER001
359500200529      *****************************************************************                       CER001
359600200529      *                                                               *                       CER001
359700200529      * SRRTVEXT2 - Retrieve customer extension group 2               *                       CER001
359800200529      *                                                               *                       CER001
359900200529      *****************************************************************                       CER001
360000200529     C     SRRTVEXT2     BEGSR                                                                CER001
360100200529      *                                                                                       CER001
360200200529      ** Retrieve record in extension file                                                    CER001
360300200529      *                                                                                       CER001
360400200529     C     K@KEY1        CHAIN(N)  RTVIDXB                            85                      CER001
360500200529      *                                                                                       CER001
360600200529     C                   SELECT                                                               CER001
360700200529      *                                                                                       CER001
360800200529      ** If record exist                                                                      CER001
360900200529      *                                                                                       CER001
361000200529     C                   WHEN      *IN85 = *OFF                                               CER001
361100200529      *                                                                                       CER001
361200200529     C                   EVAL      WFIND2 = 'Y'                                               CER001
361300200529      *                                                                                       CER001
361400200529     C                   MOVE      CUTYPE        LLLXTYPE                                     CER001
361500200529     C                   MOVE      CUIDCO        LLLXIDCO                                     CER001
361600200529     C                   MOVE      CUIDEN        LLLXIDEN                                     CER001
361700200529     C                   MOVE      CUIMCO        LLLXIMCO                                     CER001
361800200529     C                   MOVE      CUIMNB        LLLXIMNB                                     CER001
361900200529      *                                                                                       CER001
362000200529     C                   EVAL      #LLXCUFOTR = DDFOTRANID                                    CER001
362100200529     C                   EVAL      #LLXCUCNUM = CUCNUM                                        CER001
362200200529     C                   EVAL      #LLXCUTYPE = CUTYPE                                        CER001
362300200529     C                   EVAL      #LLXCUIDCO = CUIDCO                                        CER001
362400200529     C                   EVAL      #LLXCUIDEN = CUIDEN                                        CER001
362500200529     C                   EVAL      #LLXCUIMCO = CUIMCO                                        CER001
362600200529     C                   EVAL      #LLXCUIMNB = CUIMNB                                        CER001
362700200529     C                   EVAL      #LLXCUTMES = DDTMESTMP                                     CER001
362800200529      *                                                                                       CER001
362900200529     C                   MOVE      NwDlScnFmt    CrDlScnFmt                                   CER001
363000200529      *                                                                                       CER001
363100200529      ** If record does not exist                                                             CER001
363200200529      *                                                                                       CER001
363300200529     C                   WHEN      *IN85 = *ON                                                CER001
363400200529     C                   EVAL      WFIND2 = *BLANKS                                           CER001
363500200529      *                                                                                       CER001
363600200529     C                   EVAL      LLLXTYPE = *BLANKS                                         CER001
363700200529     C                   EVAL      LLLXIDCO = *BLANKS                                         CER001
363800200529     C                   EVAL      LLLXIDEN = *BLANKS                                         CER001
363900200529     C                   EVAL      LLLXIMCO = *BLANKS                                         CER001
364000200529     C                   EVAL      LLLXIMNB = *BLANKS                                         CER001
364100200529      *                                                                                       CER001
364200200529     C                   CALLB     'SDVCUTYPE2'                                               CER001
364300200529     C                   PARM                    ReturnCode                                   CER001
364400200529     C                   PARM                    MSG1                                         CER001
364500200529     C                   PARM                    LLLXTYPE                                     CER001
364600200529     C                   PARM                    DDCOLC                                       CER001
364700200529     C                   PARM                    DDCUSN                                       CER001
364800200529     C                   PARM                    DDBNBI                                       CER001
364900200529     C                   PARM                    DDBRCD                                       CER001
365000200529     C                   PARM                    BRBKCO                                       CER001
365100200529     C                   PARM                    #1NCOS                                       CER001
365200200529      *                                                                                       CER001
365300200529     C                   ENDSL                                                                CER001
365400200529      *                                                                                       CER001
365500200529     C                   ENDSR                                                                CER001
365600200529      *****************************************************************
365700200529      /EJECT
365800200529      *****************************************************************         CPB002
365900200529      * CHKPTFR - Check if Portfolio Management Customer.                       CPB002
366000200529      *****************************************************************         CPB002
366100200529     C     CHKPTFR       BEGSR                                                  CPB002
366200200529      *                                                                         CPB002
366300200529      ** Initialize Portfolio Management customer indicator.                    CPB002
366400200529     C                   MOVE      'N'           PtfrCust                       CPB002
366500200529      *                                                                         CPB002
366600200529      * Retrieve Portfolio Management customer details.                         CPB002
366700200529      * if PM is on.                                                                          212263
366800200529      *                                                                         CPB002
366900200529     C     BGPFMG        IFEQ      'Y'                                                        212263
367000200529     C                   CALL      'AOPLCSR0'                                   CPB002
367100200529     C                   PARM      *BLANKS       @RTCD                          CPB002
367200200529     C                   PARM      '*VERIFY'     @OPTN                          CPB002
367300200529     C                   PARM      DDCUSN        P@CUST           10            CPB002
367400200529     C                   PARM                    DSFDY                                        212263
367500200529      *                                                                         CPB002
367600200529      ** If Portfolio Management customer details exist, set up                 CPB002
367700200529      ** Portfolio Management Customer Indicator.                               CPB002
367800200529      *                                                                         CPB002
367900200529     C     @RTCD         IFEQ      *BLANKS                                      CPB002
368000200529     C                   MOVE      'Y'           PtfrCust                       CPB002
368100200529      *                                                                         CPB002
368200200529     C                   END                                                                  212263
368300200529     C                   END                                                    CPB002
368400200529                                                                                CPB002
368500200529     C                   ENDSR                                                  CPB002
368600200529      *****************************************************************         CPB002
368700200529      /EJECT                                                                    CPB002
368800200529      *****************************************************************
368900200529      * CVTCUS - PUT A CUSTOMER ON THE PRIMARY DETAILS SCREEN
369000200529      *****************************************************************
369100200529     C     CVTCUS        BEGSR
369200200529      *
369300200529      * Call program to fill screen fields with data from SDCUSTPD
369400200529      *
369500200529     C                   CALLB     'SDCUSDCVT'
369600200529      *
369700200529      * INPUTS :
369800200529      * Return Code
369900200529     C                   PARM      *BLANK        RetCodeOut
370000200529      *
370100200529      * Customer file format
370200200529     C                   PARM                    CrCuFilFmt
370300200529     C/COPY WNCPYSRC,SDH00745
370400200529      *
370500200529      * Base Rate Tax file format
370600200529     C                   PARM                    CrBrFilFmt
370700200529      *
370800200529      * Private Banking format
370900200529     C                   PARM                    CrPBFilFmt
371000200529                                                                                              CGP001
371100200529      ** Global Customer X-Reference                                                          CGP001
371200200529     C                   PARM                    GCrCuFilFmt                                  CGP001
371300200529     C                   PARM                    CrSwFilFmt                                   CSW207
371400200529                                                                                              CGP001
371500200529      ** Switchable features                                                                  CLE025
371600200529                                                                                              CLE025
371700200529     C                   PARM                    CLE025                                       CLE025
371800200529     C                   PARM                    CFX001                                       CFX001
371900200529      *                                                                                     MD054028
372000200529     C                   PARM                    DDAPRC                                     MD054028
372100200529      * OUTPUTS
372200200529      * Customer - screen formats
372300200529     C                   PARM                    NewCuPrim
372400200529     C                   PARM                    NewCuSeco
372500200529     C                   PARM                    NewCuMT3x                                    CSW024
372600200529     C                   PARM                    NewCuMsg
372700200529     C                   PARM                    NewCuBrt
372800200529     C                   PARM                    NewCuPriv
372900200529     C                   PARM                    TranInACU3                                   CER059
373000200529     C                   PARM                    TranInACU4                                   CER059
373100200529     C                   PARM                    NewCuSwft                                    CSW207
373200200529     C/COPY WNCPYSRC,SDCUSDSC14
373300200529      *
373400200529      * Update 'Current' Customer with Customer in Screen Format
373500200529      *
373600200529     C                   MOVEL     NewCuPrim     CurCuPrim
373700200529     C                   MOVEL     NewCuBrt      CurCuBrt
373800200529     C                   MOVEL     NewCuSeco     CurCuSeco
373900200529     C                   MOVEL     NewCuMsg      CurCuMsg
374000200529     C                   MOVEL     NewCuPriv     CurCuPriv
374100200529     C                   MOVEL     NewCuMT3x     CurCuMT3x                                    CSW024
374200200529     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
374300200529     C                   MOVEL     NewCuSwft     CurCuSwft                                    CSW027
374400200529     C                   ENDIF                                                                CSW207
374500200529     C/COPY WNCPYSRC,SDCUSDSC15
374600200529      *
374700200529     C                   ENDSR
374800200529      *
374900200529      *****************************************************************
375000200529      /EJECT
375100200529      *****************************************************************
375200200529      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
375300200529      *****************************************************************
375400200529     C     SFKEYS        BEGSR
375500200529      *
375600200529      * Enable/disable function keys
375700200529      *
375800200529      * KG = COMMAND KEY 07 = READ PREVIOUS CUSTOMER
375900200529      * KH = COMMAND KEY 08 = READ NEXT CUSTOMER
376000200529      *
376100200529     C     @SCRN         IFEQ      'P'
376200200529     C     DDACTN        ANDNE     'I'                                                        248913
376300200529     C     DDACTN        ANDNE     'A'                                                        248913
376400200529     C     @SCRN         OREQ      'K'                                                        248913
376500200529     C     DDACTN        ANDNE     'I'                                                        248913
376600200529     C     DDACTN        ANDNE     'A'                                                        248913
376700200529     C                   MOVEL     'Y'           @EINKG
376800200529     C                   MOVEL     'Y'           @EINKH
376900200529     C                   ELSE
377000200529     C                   MOVEL     'N'           @EINKG
377100200529     C                   MOVEL     'N'           @EINKH
377200200529     C                   ENDIF
377300200529      *
377400200529      * KJ = COMMAND KEY 10 = CONFIRM DELETE
377500200529      *
377600200529     C     DDACTN        IFEQ      'D'
377700200529     C                   MOVEL     'Y'           @EINKJ
377800200529     C                   ELSE
377900200529     C                   MOVEL     'N'           @EINKJ
378000200529     C                   END
378100200529                                                                                              CSD007
378200200529      ** KW = Command Key 22 = CONFIRM CLOSURE/RELEASE                                        CSD007
378300200529                                                                                              CSD007
378400200529     C     DDACTN        IFEQ      'C'                                                        CSD007
378500200529     C     DDACTN        OREQ      'R'                                                        CSD007
378600200529     C                   MOVEL     'Y'           @EINKW                                       CSD007
378700200529     C                   ELSE                                                                 CSD007
378800200529     C                   MOVEL     'N'           @EINKW                                       CSD007
378900200529     C                   ENDIF                                                                CSD007
379000200529      *
379100200529      * KX = COMMAND KEY 23 = FURTHER DETAILS
379200200529      *
379300200529     C     DDACTN        IFNE      'I'
379400200529     C                   MOVEL     'Y'           @EINKX
379500200529     C                   ELSE
379600200529     C                   MOVEL     'N'           @EINKX
379700200529     C                   END
379800200529      *
379900200529     C                   ENDSR
380000200529      *****************************************************************
380100200529      /EJECT
380200200529      *****************************************************************
380300200529      * IFDS@K - INITIALIZE FIELD STATUS ON KEY SCREEN
380400200529      *****************************************************************
380500200529     C     IFDS@K        BEGSR
380600200529      *
380700200529      * ENABLE KEY FIELDS ON KEY SCREEN
380800200529      *
380900200529     C                   MOVEL     'Y'           @EDTFD
381000200529     C                   MOVEL     'Y'           @EKYFD
381100200529      *
381200200529     C                   ENDSR
381300200529      *****************************************************************
381400200529      /EJECT
381500200529      *****************************************************************
381600200529      * PARNAMES - Flag if there are changed participant names
381700200529      *****************************************************************
381800200529     C     PARNAMES      BEGSR
381900200529      *
382000200529      * If any 'P', the user to be prompted to confirm if new party or not
382100200529     C     'P'           LOOKUP    ChgNamArr                              99
382200200529     C                   MOVE      *IN99         CHGNAME           1
382300200529      *
382400200529     C                   ENDSR
382500200529      *****************************************************************
382600200529      /EJECT
382700200529      *****************************************************************
382800200529      * SNDM@P - SEND A MESSAGE TO SCREEN
382900200529      *****************************************************************
383000200529     C     SNDM@P        BEGSR
383100200529      *
383200200529      ** Add error message to array passed to detail screen
383300200529      *
383400200529     C                   Z-ADD     1             E                 3 0
383500200529     C     *BLANK        LOOKUP    FldNameArr(E)                          99
383600200529     C                   MOVEL     '*ANY'        FldNameArr(E)
383700200529     C                   MOVEL     @ERRMS        MsgIdArr(E)
383800200529     C                   MOVEL     @data         MsgDtaArr(E)                                 249076
383900200529      *
384000200529     C     EndSNDM@P     ENDSR
384100200529      *****************************************************************
384200200529      /EJECT
384300200529      *****************************************************************
384400200529      * CANC@K - CANCEL ON KEY SCREEN
384500200529      *****************************************************************
384600200529     C     CANC@K        BEGSR
384700200529      *
384800200529      * Reset Read Next Browse Subfile Record (if active)
384900200529      *
385000200529     C                   MOVEL     *BLANK        @RDNB
385100200529     C                   MOVEL     'B'           @SCRN
385200200529      *
385300200529      * If input fields are enabled
385400200529      * Blank the screens
385500200529      *
385600200529     C     @EKYFD        IFEQ      'Y'
385700200529     C     @EDTFD        OREQ      'Y'
385800200529     C                   MOVEL     *BLANK        NewCuPrim
385900200529     C                   MOVEL     *BLANK        NewCuSeco
386000200529     C                   MOVEL     *BLANK        NewCuMsg
386100200529     C                   MOVEL     *BLANK        NewCuMT3x                                    CSW024
386200200529     C/COPY WNCPYSRC,SDH00746
386300200529     C                   END
386400200529      *
386500200529      * Initialize field status on Key Screen
386600200529      *
386700200529     C                   EXSR      IFDS@K
386800200529      *
386900200529     C                   ENDSR
387000200529      *****************************************************************
387100200529      /EJECT
387200200529      *****************************************************************
387300200529      * CANC@P - CANCEL ON PRIMARY SCREEN
387400200529      *****************************************************************
387500200529     C     CANC@P        BEGSR
387600200529      *
387700200529      * Return to previous screen
387800200529      *
387900200529     C                   IF        PAccMde <> 'A'                                             CSD031
388000200529     C     INSERTENQ     IFEQ      'Y'
388100200529     C                   MOVE      'I'           DDACTN
388200200529     C                   MOVEL     'K'           @SCRN
388300200529     C                   ELSE
388400200529     C                   MOVEL     'B'           @SCRN
388500200529     C                   ENDIF
388600200529     C                   ELSE                                                                 CSD031
388700200529     C**********         MOVEL     'B'           @SCRN                               CSD031 BUG11889
388800200529     C                   MOVEL     'R'           @SCRN                                      BUG11889
388900200529      *                                                                                     BUG11889
389000200529      ** Move 'R' to @SCRN to go to RDNBRW, from SDCUSDBRW                                  BUG11889
389100200529      **  it will execute RDSFLR to read the selected customer                              BUG11889
389200200529      *                                                                                     BUG11889
389300200529     C                   ENDIF                                                                CSD031
389400200529      *
389500200529     C                   ENDSR
389600200529      *****************************************************************
389700200529      /EJECT
389800200529      *****************************************************************
389900200529      * CANC@S - CANCEL ON SECONDARY SCREEN
390000200529      *****************************************************************
390100200529     C     CANC@S        BEGSR
390200200529      *
390300200529      * Return to BRT tax screen
390400200529     C     S01383        IFEQ      'Y'
390500200529     C     DDTAIN        ANDEQ     'I'
390600200529     C     S01383        OREQ      'Y'
390700200529     C     DDTAIN        ANDEQ     'J'
390800200529     C     S01383        OREQ      'Y'                                                        CRE007
390900200529     C     DDTAIN        ANDEQ     'R'                                                        CRE007
391000200529     C                   MOVE      'X'           @SCRN
391100200529     C                   ELSE
391200200529      * Or return to Primary Details screen
391300200529     C                   MOVE      'P'           @SCRN
391400200529     C                   ENDIF
391500200529      *
391600200529     C     EndCANC@S     ENDSR
391700200529                                                                                              CSW024
391800200529      *****************************************************************                       CSW024
391900200529      /EJECT                                                                                  CSW024
392000200529      *****************************************************************                       CSW024
392100200529      *                                                               *                       CSW024
392200200529      * CANC@F - Cancel on MT3xx BEI and Fund Details screen          *                       CSW024
392300200529      *                                                               *                       CSW024
392400200529      *****************************************************************                       CSW024
392500200529                                                                                              CSW024
392600200529     C     CANC@F        BEGSR                                                                CSW024
392700200529      *                                                                                       CSW024
392800200529      ** Go to secondary details screen                                                       CSW024
392900200529     C                   MOVEL     'S'           @SCRN                                        CSW024
393000200529      *                                                                                       CSW024
393100200529     C     EndCANC@F     ENDSR                                                                CSW024
393200200529                                                                                              CSW024
393300200529      *****************************************************************
393400200529      /EJECT
393500200529      *****************************************************************
393600200529      * CANC@M - CANCEL ON MESSAGE DETAILS SCREEN
393700200529      *****************************************************************
393800200529     C     CANC@M        BEGSR
393900200529      *
394000200529      * Return to Secondary Screen
394100200529      *
394200200529      ** If MT3xx BEI enhancement has been installed, and                                     CSW024
394300200529      ** SWIFT/Direct Link module is on then display                                          CSW024
394400200529      ** screen for MT3xx BEI details                                                         CSW024
394500200529     C                   IF        CSW024 = 'Y' AND                                           CSW024
394600200529     C                             BGMSDL = 'Y'                                               CSW024
394700200529     C                   MOVEL     'F'           @SCRN                                        CSW024
394800200529     C                   ELSE                                                                 CSW024
394900200529     C                   MOVEL     'S'           @SCRN
395000200529     C                   ENDIF                                                                CSW024
395100200529     C/COPY WNCPYSRC,SDH00604
395200200529      *
395300200529     C                   ENDSR
395400200529      *****************************************************************
395500200529      /EJECT
395600200529      *****************************************************************
395700200529      * CANC@B - CANCEL ON BASE RATE TAX SCREENS
395800200529      *****************************************************************
395900200529     C     CANC@B        BEGSR
396000200529      *
396100200529      * If on BRT screen 2, F12 returns to BRT screen 1
396200200529      * otherwise F12 returns to customer Primary Details screen
396300200529      *
396400200529     C     BRTSCREEN     IFEQ      '2'
396500200529     C                   MOVEL     '1'           BRTSCREEN
396600200529     C                   ELSE
396700200529     C                   MOVEL     'P'           @SCRN
396800200529      * Reset errors
396900200529      *
397000200529     C                   MOVE      *ALL'Y'       OKCuBrt
397100200529     C                   MOVEL     *BLANK        FldNameArr
397200200529     C                   MOVEL     *BLANK        MsgIdArr
397300200529     C                   MOVEL     *BLANK        MsgDtaArr
397400200529      *
397500200529     C                   ENDIF
397600200529      *
397700200529     C                   ENDSR
397800200529      *****************************************************************
397900200529      /EJECT
398000200529      *****************************************************************
398100200529      * CANC@R - CANCEL ON Private Banking SCREEN
398200200529      *****************************************************************
398300200529     C     CANC@R        BEGSR
398400200529      *
398500200529      * Return to Messages Screen
398600200529      *
398700200529     C                   MOVEL     'M'           @SCRN
398800200529     C                   MOVE      *ALL'Y'       OKCuPriv
398900200529     C                   MOVEL     *BLANK        FldNameArr
399000200529     C                   MOVEL     *BLANK        MsgIdArr
399100200529     C                   MOVEL     *BLANK        MsgDtaArr
399200200529      *
399300200529     C                   ENDSR
399400200529      *****************************************************************
399500200529      /EJECT
399600200529      *****************************************************************
399700200529      * FURDET - Further Details
399800200529      *****************************************************************
399900200529     C     FURDET        BEGSR
400000200529      **********                                                                  BUG26917 BUG26917A
400100200529     C*****CER048        IFEQ      'Y'                                            BUG26917 BUG26917A
400200200529     C*****DDACTN        IFEQ      'I'                                            BUG26917 BUG26917A
400300200529     C*****DDACTN        OREQ      'A'                                            BUG26917 BUG26917A
400400200529     C*****DDTAIN        IFEQ      'Y'                                            BUG26917 BUG26917A
400500200529     C**********         EVAL      FDTAIN = DDTAIN                                BUG26917 BUG26917A
400600200529     C**********         ELSE                                                     BUG26917 BUG26917A
400700200529     C**********         EVAL      FDTAIN = *BLANKS                               BUG26917 BUG26917A
400800200529     C**********         ENDIF                                                    BUG26917 BUG26917A
400900200529     C**********         ENDIF                                                    BUG26917 BUG26917A
401000200529     C**********         ENDIF                                                    BUG26917 BUG26917A
401100200529                                                                                              CSC011
401200200529      ** Further Details (F23) not available in Support System                                CSC011
401300200529                                                                                              CSC011
401400200529     C                   IF        CSC011 = 'Y'                                               CSC011
401500200529     C                             AND LIBR = S1SUPP                                          CSC011
401600200529     C                             AND DDACTN <> 'E'                                          CSC011
401700200529     C                   IF        DDACTN <> 'I'                                              CSC011
401800200529     C                   EVAL      Idx = 1                                                    CSC011
401900200529     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 CSC011
402000200529     C                   EVAL      MsgIdArr(Idx) = 'USR9370'                                  CSC011
402100200529     C                   ENDIF                                                                CSC011
402200200529     C                   ELSE                                                                 CSC011
402300200529      **
402400200529      ** Call Further Details
402500200529      **
402600200529     C                   MOVE      DDCUSN        FDCUST
402700200529     C                   MOVE      DDCSSN        FDCSSN
402800200529     C                   MOVE      DDCRTN        FDCRTN
402900200529     C                   MOVE      DDCRNM        FDCRNM
403000200529     C                   MOVE      DDLINC        FDLINC
403100200529     C                   MOVE      C_BBTICS      FDTICS
403200200529     C**********         MOVE      DDCRPC        FDCRPC                              BUG4454 BUG5139
403300200529     C**********         MOVE      DDBRCD        FDBRCD                              BUG4454 BUG5139
403400200529     C**********         MOVE      DDLICD        FDLICD                              BUG4454 BUG5139
403500200529      *
403600200529     C                   CALL      'SD0014V'                              90
403700200529     C                   PARM                    RTNCDE            7
403800200529     C                   PARM                    FURDETS
403900200529     C                   PARM                    @OPSEL
404000200529     C                   PARM                    DDPAIN
404100200529      *                                                                                       237595
404200200529      ** Reset error indicators                                                               237595
404300200529      *                                                                                       237595
404400200529     C                   MOVE      *ALL'Y'       OKCuPrim                                     237595
404500200529     C                   MOVEL     *BLANK        FldNameArr                                   237595
404600200529     C                   MOVEL     *BLANK        MsgIdArr                                     237595
404700200529     C                   MOVEL     *BLANK        MsgDtaArr                                    237595
404800200529     C                   MOVEL     *BLANK        WFldNamArr                                   237595
404900200529     C                   MOVEL     *BLANK        WMsgIdArr                                    237595
405000200529     C                   MOVEL     *BLANK        WMsgDtaArr                                   237595
405100200529     C                   Z-ADD     0             Idx                                          237595
405200200529      *                                                                                       237595
405300200529                                                                                              CSC011
405400200529     C                   ENDIF                                                                CSC011
405500200529      *
405600200529     C     EndFURDET     ENDSR
405700200529      *****************************************************************
405800200529      /EJECT
405900200529      *****************************************************************
406000200529      * UPDATS - UPDATES
406100200529      *****************************************************************
406200200529     C     UPDATS        BEGSR
406300200529     C/COPY WNCPYSRC,SDCUSDSC21
406400200529      *****                                                                     185595
406500200529      **If*action code 'I', maintain Further Details                            185595
406600200529      *****                                                                     185595
406700200529     C*****DDACTN        IFEQ      'I'                                          185595
406800200529     C*****              EXSR      FURDET                                       185595
406900200529     C*****              END                                                    185595
407000200529      ***********************************************                                BUG3362 BUG8425
407100200529      ***If*action*code*'I',*maintain*Further*Details                                BUG3362 BUG8425
407200200529      ***********************************************                                BUG3362 BUG8425
407300200529     C*****Idx**         IFEQ      *ZEROS                                            BUG3362 BUG8425
407400200529     C*****DDACTN        IFEQ      'I'                                               BUG3362 BUG8425
407500200529     C**********         EXSR      FURDET                                            BUG3362 BUG8425
407600200529     C**********         ENDIF                                                       BUG3362 BUG8425
407700200529     C**********         ENDIF                                                       BUG3362 BUG8425
407800200529      *
407900200529      * Update valid customer: customer reference
408000200529      *
408100200529     C                   MOVEL     DDCUSN        CUCUST
408200200529     C                   MOVEL     DDACTN        CUTYLC
408300200529      *
408400200529      ** Carry forward non-validated master file values to valid file
408500200529      *
408600200529     C     DDACTN        IFEQ      'A'
408700200529     C                   MOVE      C_BBTXA2      CUTXA2
408800200529     C                   MOVE      C_BBTXA3      CUTXA3
408900200529     C                   MOVE      C_BBTXA4      CUTXA4
409000200529     C                   MOVE      C_BBTXA5      CUTXA5
409100200529     C                   MOVE      C_BBLETI      CULETI
409200200529     C                   MOVE      C_BBCMTI      CUCMTI
409300200529     C                   MOVE      C_BBOGID      CUOGID
409400200529     C                   Z-ADD     C_BBORED      CUORED
409500200529     C**********         MOVE      C_BBNET       CUNET                                        202805
409600200529     C**********         MOVE      C_BBNTGP      CUNTGP                                       202805
409700200529     C**********         MOVE      C_BBNTCP      CUNTCP                                       202805
409800200529     C**********         Z-ADD     C_BBNTND      CUNTND                                       202805
409900200529     C**********         MOVE      C_BBNTMM      CUNTMM                                       202805
410000200529     C**********         MOVE      C_BBTMST      CUTMST                                       202805
410100200529                                                                                              CSD031
410200200529     C                   IF        PAccMde <> 'A'                                             CSD031
410300200529     C     DDCUSN        CHAIN     SDCUSTL5                           90                      202805
410400200529     C                   ELSE                                                                 CSD031
410500200529     C     DDCUSN        CHAIN     SDACSTL1                           90                      CSD031
410600200529     C                   ENDIF                                                                CSD031
410700200529                                                                                              CSD031
410800200529     C     *IN90         IFEQ      '0'                                                        202805
410900200529     C                   MOVE      W@NET         CUNET                                        202805
411000200529     C                   MOVE      W@NTGP        CUNTGP                                       202805
411100200529     C                   MOVE      W@NTCP        CUNTCP                                       202805
411200200529     C                   Z-ADD     W@NTND        CUNTND                                       202805
411300200529     C                   MOVE      W@NTMM        CUNTMM                                       202805
411400200529     C                   MOVE      W@TMST        CUTMST                                       202805
411500200529     C                   ENDIF                                                                202805
411600200529                                                                                             BUG2664
411700200529      ** If FDTICS is blanks, this means F23 was not pressed, therefore,                     BUG2664
411800200529      ** field must retain its current value else, get the updated value                     BUG2664
411900200529                                                                                             BUG2664
412000200529     C     FDTICS        IFEQ      *BLANKS                                                   BUG2664
412100200529     C                   MOVE      C_BBTICS      CUTICS                                      BUG2664
412200200529     C                   ELSE                                                                BUG2664
412300200529     C                   MOVE      FDTICS        CUTICS                                       196149
412400200529     C                   ENDIF                                                               BUG2664
412500200529                                                                                             BUG2664
412600200529     C                   ELSE
412700200529      *
412800200529      ** Initialise non-validated valid file fields for Insert
412900200529      *
413000200529     C     DDACTN        IFEQ      'I'
413100200529     C                   MOVE      *BLANKS       CUTXA2
413200200529     C                   MOVE      *BLANKS       CUTXA3
413300200529     C                   MOVE      *BLANKS       CUTXA4
413400200529     C                   MOVE      *BLANKS       CUTXA5
413500200529     C                   MOVE      *BLANKS       CULETI
413600200529     C                   MOVE      *BLANKS       CUCMTI
413700200529     C                   MOVE      *BLANKS       CUOGID
413800200529     C                   Z-ADD     BJRDNB        CUORED
413900200529     C                   MOVE      'N'           CUNET
414000200529     C                   MOVE      *BLANKS       CUNTGP
414100200529     C                   MOVE      'N'           CUNTCP
414200200529     C                   MOVE      'N'           CUNTMM
414300200529     C     CUTICS        IFEQ      *BLANK
414400200529     C                   MOVE      'N'           CUTICS
414500200529     C                   ENDIF
414600200529     C                   ENDIF
414700200529     C                   ENDIF
414800200529      *                                                                                      BUG3362
414900200529      ** If Further details was accessed, load changed value(FDCTID from                     BUG3362
415000200529      ** SD0014V) to NwTIFilfmt if no error                                                  BUG3362
415100200529      *                                                                                      BUG3362
415200200529     C     FDTICS        IFEQ      'Y'                                                       BUG3362
415300200529      *                                                                                      BUG3362
415400200529     C                   MOVEL     FDCTID        NwTIfilFmt                                  BUG3362
415500200529     C                   EVAL      V_TCLCD = BJRDNB                                          BUG3362
415600200529      *                                                                                      BUG3362
415700200529     C     DDACTN        IFEQ      'I'                                                       BUG3362
415800200529     C                   EVAL      V_TCCSSN=CUCSSN                                           BUG3362
415900200529     C                   ENDIF                                                               BUG3362
416000200529     C                   EVAL      CUTICS = FDTICS                                           BUG3362
416100200529     C                   ELSE                                                                BUG3362
416200200529     C     FDTICS        IFEQ      'N'                                                       BUG3362
416300200529     C     DDACTN        ANDEQ     'I'                                                       BUG3362
416400200529     C     FDTICS        OREQ      ' '                                                       BUG3362
416500200529     C     DDACTN        ANDEQ     'I'                                                       BUG3362
416600200529      ** case FDTICS = 'N'                                                                   BUG3362
416700200529     C                   MOVE      *BLANKS       NwTifilFmt                                  BUG3362
416800200529     C                   EVAL      V_TCLCD = 0                                               BUG3362
416900200529     C                   ENDIF                                                               BUG3362
417000200529     C                   ENDIF                                                               BUG3362
417100200529      *                                                                                      BUG3362
417200200529     C                   MOVEL     *BLANK        @RTCD
417300200529      *
417400200529      * CUSTOMER UPDATES
417500200529      *
417600200529     C                   CALLB     'SDCUSDUPD'
417700200529     C                   PARM                    @RTCD
417800200529     C                   PARM                    NwCuFilFmt
417900200529     C                   PARM                    NwBrFilFmt
418000200529     C                   PARM                    NwPBFilFmt
418100200529     C                   PARM                    NwTIFilFmt                                  BUG3362
418200200529     C                   PARM                    NwSwFilFmt                                   CSW207
418300200529     C**********         PARM                    CuSW13                              CFT050 MD022395
418400200529     C                   PARM                    NewCuSW13                                  MD022395
418500200529      * Base Rate Auth req                                                                    CSD012
418600200529     C                   PARM                    AUTHRQ            1                          CSD012
418700200529      * Authorisation Mode                                                                    CSD012
418800200529     C                   PARM                    AUTHMD            1                          CSD012
418900200529     C                   PARM                    V_DDGCUS                                     CGP001
419000200529     C                   PARM                    S01383
419100200529                                                                                              CLE025
419200200529      ** Switchable features                                                                  CLE025
419300200529                                                                                              CLE025
419400200529     C                   PARM                    CSW024                                       CSW024
419500200529     C                   PARM                    CGP001                                       CGP001
419600200529     C                   PARM                    CLE025                                       CLE025
419700200529     C                   PARM                    CFX001                                       CFX001
419800200529     C                   PARM                    TransType                                    CSD028
419900200529     C                   PARM                    DACTN             1                          CSD028
420000200529     C                   PARM                    CTI006            1                        MD030956
420100200529      ** Acceptance Mode                                                                      CSD031
420200200529     C                   PARM                    PAccMde                                      CSD031
420300200529      ** Update (Y/N)                                                                         CSD031
420400200529     C                   PARM                    PUpdYN                                       CSD031
420500200529     C/COPY WNCPYSRC,SDCUSDSC16
420600200529      *
420700200529      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
420800200529      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
420900200529      *
421000200529     C     @RTCD         IFNE      *BLANK
421100200529     C                   ROLBK
421200200529     C     @RTCD         IFEQ      '*LOCKED'                                                  252069
421300200529     C                   ADD       1             Idx                                          252069
421400200529     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 252069
421500200529     C                   EVAL      MsgIdArr(Idx) = 'USR0001'                                  252069
421600200529     C                   ELSE                                                                 252069
421700200529     C                   EXSR      *PSSR
421800200529     C                   ENDIF                                                                252069
421900200529     C                   ELSE
422000200529      *                                                                                       CER001
422100200529     C**********         IF        ULX043 = 'Y'                                      CER001 BUG10817
422200200529     C                   IF        ULX609 = 'Y'                                             BUG10817
422300200529      *                                                                                       CER001
422400200529      ** Update extension fields group 1                                                      CER001
422500200529      *                                                                                       CER001
422600200529     C                   EVAL      #6LXVFCOLC = #1COLC                                        CER001
422700200529     C                   EVAL      #6LXVFCRNM = #1CRNM                                        CER001
422800200529      *                                                                                       CER001
422900200529     C                   CALLB     'SDCUSD2UP'                                                CER001
423000200529     C                   PARM                    PWAction                                     CER001
423100200529     C                   PARM      *BLANK        @RTCD                                        CER001
423200200529     C                   PARM                    WFIND1                                       CER001
423300200529     C                   PARM                    NwDlFilFmt1                                  CER001
423400200529     C                   PARM                    CrDlFilFmt1                                  CER001
423500200529      *                                                                                       CER001
423600200529      ** If there were any errors in the update functions, rollback any                       CER001
423700200529      ** updates and end this pgm, otherwise delete the invalid extended                      CER001
423800200529      ** deal and commit the updates                                                          CER001
423900200529      *                                                                                       CER001
424000200529     C                   IF        @RTCD <> *BLANK    AND                                     CER001
424100200529     C                             @RTCD <> '*RECUPD' AND                                     CER001
424200200529     C                             @RTCD <> '*RECLCK'                                         CER001
424300200529     C                   ROLBK                                                                CER001
424400200529     C                   EXSR      *PSSR                                                      CER001
424500200529     C                   ENDIF                                                              BUG10817
424600200529     C                   ENDIF                                                              BUG10817
424700200529     C**********         ELSE                                                                 CER001
424800200529     C                   IF        @RTCD = *BLANK                                           BUG10817
424900200529      *                                                                                       CER001
425000200529      ** Update extension fields group 2                                                      CER001
425100200529      *                                                                                       CER001
425200200529     C                   IF        ULX043 = 'Y'                                             BUG10817
425300200529     C                   CALLB     'SDCUSD3UP'                                                CER001
425400200529     C                   PARM                    PWAction                                     CER001
425500200529     C                   PARM      *BLANK        @RTCD                                        CER001
425600200529     C                   PARM                    WFIND2                                       CER001
425700200529     C                   PARM                    NwDlFilFmt2                                  CER001
425800200529     C                   PARM                    CrDlFilFmt2                                  CER001
425900200529      *                                                                                       CER001
426000200529      ** If there were any errors in the update functions, rollback any                       CER001
426100200529      ** updates and end this pgm, otherwise delete the invalid extended                      CER001
426200200529      ** customer and commit the updates                                                      CER001
426300200529      *                                                                                       CER001
426400200529     C                   IF        @RTCD <> *BLANK    AND                                     CER001
426500200529     C                             @RTCD <> '*RECUPD' AND                                     CER001
426600200529     C                             @RTCD <> '*RECLCK'                                         CER001
426700200529     C                   ROLBK                                                                CER001
426800200529     C                   EXSR      *PSSR                                                      CER001
426900200529     C                   ENDIF                                                                CER001
427000200529     C                   ENDIF                                                                CER001
427100200529     C                   ENDIF                                                                CER001
427200200529     C/COPY WNCPYSRC,SDCUSDSC01
427300200529     C                   COMMIT
427400200529      *********************************************************************           185595 BUG3362
427500200529      **If*action*code*'I',*maintain*Further*Details***********************           185595 BUG3362
427600200529      *********************************************************************           185595 BUG3362
427700200529     C*****DDACTN********IFEQ******'I'*************************************           185595 BUG3362
427800200529     C*******************EXSR******FURDET**********************************           185595 BUG3362
427900200529     C*******************END***********************************************           185595 BUG3362
428000200529      *********************************************************************           185595 BUG3362
428100200529                                                                                             BUG5139
428200200529      ** If action code 'I', maintain Further Details                                        BUG5139
428300200529                                                                                             BUG5139
428400200529     C     Idx           IFEQ      *ZEROS                                                    BUG5139
428500200529     C     DDACTN        IFEQ      'I'                                                       BUG5139
428600200529     C                   EXSR      FURDET                                                    BUG5139
428700200529     C                   ENDIF                                                               BUG5139
428800200529     C                   ENDIF                                                               BUG5139
428900200529     C                   END
429000200529      *
429100200529      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
429200200529      *
429300200529     C     @RDNB         IFEQ      'Y'
429400200529     C                   MOVEL     'R'           @SCRN
429500200529     C                   ELSE
429600200529      *
429700200529      * ELSE, RETURN TO INSERT KEY SCREEN OR BROWSE SBFILE
429800200529      *
429900200529     C     DDACTN        IFEQ      'I'
430000200529     C                   MOVEL     'K'           @SCRN
430100200529                                                                                              CSD021
430200200529     C     CSD021        IFEQ      'Y'                                                        CSD021
430300200529     C                   MOVEL     CUCUST        WWCNUM                                       CSD021
430400200529     C                   ENDIF                                                                CSD021
430500200529                                                                                              CSD021
430600200529     C                   ELSE
430700200529     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
430800200529     C                   EVAL      @SCRN = 'T'                                                CSD028
430900200529     C                   ELSE                                                                 CSD028
431000200529     C                   MOVEL     'B'           @SCRN
431100200529     C                   ENDIF                                                                CSD028
431200200529     C                   ENDIF
431300200529     C                   ENDIF
431400200529     C/COPY WNCPYSRC,SDCUSDSC22
431500200529      *
431600200529     C                   ENDSR
431700200529      *****************************************************************
431800200529      /EJECT
431900200529      *****************************************************************
432000200529      * ENDP - End Program
432100200529      *****************************************************************
432200200529     C     ENDP          BEGSR
432300200529      *                                                                                       189774
432400200529      ** Rollback to clear any possible updates in window function                            189774
432500200529      *                                                                                       189774
432600200529     C     BGWDPR        IFEQ      'Y'                                                        189774
432700200529     C                   ROLBK                                                                189774
432800200529     C                   ENDIF                                                                189774
432900200529      *
433000200529     C                   MOVEL     'T'           @SCRN
433100200529      *
433200200529     C                   ENDSR
433300200529      *****************************************************************
433400200529      /EJECT
433500200529      *****************************************************************
433600200529      * INITIAL Go To Initial Screen
433700200529      *****************************************************************
433800200529     C     INITIAL       BEGSR
433900200529      *
434000200529      * Reset Read Next Browse Subfile Record (if active)
434100200529      *
434200200529     C                   MOVEL     *BLANK        @RDNB
434300200529      *
434400200529      * Blank the screens
434500200529      *
434600200529     C                   MOVEL     *BLANK        NewCuPrim
434700200529     C                   MOVEL     *BLANK        NewCuSeco
434800200529     C                   MOVEL     *BLANK        NewCuMsg
434900200529     C                   MOVEL     *BLANK        NewCuPriv
435000200529     C                   MOVEL     *BLANK        NewCuMT3x                                    CSW024
435100200529     C/COPY WNCPYSRC,SDH00747
435200200529      *
435300200529      * Browse Screen
435400200529      *
435500200529     C                   MOVEL     'B'           @SCRN             1
435600200529      *
435700200529      * Initialize field status on Key Screen
435800200529      *
435900200529     C                   EXSR      IFDS@K
436000200529      *
436100200529     C                   ENDSR
436200200529      *****************************************************************                       CFT050
436300200529      /EJECT                                                                                  CFT050
436400200529      *****************************************************************                       CFT050
436500200529      * SRSCRNPL- Display Bank Plus enquiry screen                                            CFT050
436600200529      *****************************************************************                       CFT050
436700200529     C     SRSCRNPL      BEGSR                                                                CFT050
436800200529      *                                                                                       CFT050
436900200529     C                   IF        DDBDRK =  *BLANKS                                          CFT050
437000200529      *                                                                                       CFT050
437100200529     C                   CALL      'FT0900'                                                   CFT050
437200200529     C                   PARM      'S'           WIMODE                                       CFT050
437300200529     C                   PARM      *BLANKS       WICRIT                                       CFT050
437400200529     C                   PARM      *BLANKS       WOADD                                        CFT050
437500200529     C                   PARM      *BLANKS       WOCHIP                                       CFT050
437600200529     C                   PARM      *BLANKS       WOUTCD                                       CFT050
437700200529     C                   PARM      *BLANKS       WRTCD                                        CFT050
437800200529      *                                                                                       CFT050
437900200529     C                   EVAL      WPARKEY = *BLANKS                                          CFT050
438000200529     C                   IF        WOADD  <> *BLANKS                                          CFT050
438100200529     C                   EVAL      CUBDRK   = WOADD                                           CFT050
438200200529     C                   EVAL      DDBDRK   = WOADD                                           CFT050
438300200529     C     CUBDRK        SETLL     MEBIB3L0                                                   CFT050
438400200529     C                   IF        %EQUAL                                                     CFT050
438500200529     C     CUBDRK        CHAIN     MEBIB3L0                                                   CFT050
438600200529     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
438700200529     C                   EVAL      WPARKEY = B3POKY                                           CFT050
438800200529     C                   ENDIF                                                                CFT050
438900200529     C                   ENDIF                                                                CFT050
439000200529     C                   ENDIF                                                                CFT050
439100200529      *                                                                                       CFT050
439200200529      ** Default if insert mode                                                               CFT050
439300200529      *                                                                                       CFT050
439400200529     C                   IF        DDACTN = 'I'                                               CFT050
439500200529     C                             AND WPARKEY <> *BLANKS                                     CFT050
439600200529     C                   EXSR      GETPARKEY                                                  CFT050
439700200529     C                   EXSR      DEF2NDSCR                                                  CFT050
439800200529     C                   EXSR      DEF3RDSCR                                                  CFT050
439900200529     C                   EXSR      DEF8THSCR                                                  CFT050
440000200529     C                   ENDIF                                                                CFT050
440100200529                                                                                              CFT050
440200200529     C                   ELSE                                                                 CFT050
440300200529                                                                                              CFT050
440400200529     C                   EVAL      DDBDRK = *BLANKS                                           CFT050
440500200529     C                   EVAL      CUBDRK = *BLANKS                                           CFT050
440600200529                                                                                              CFT050
440700200529     C                   ENDIF                                                                CFT050
440800200529     C                   EVAL      @SCRN = 'P'                                                CFT050
440900200529      *                                                                                       CFT050
441000200529     C                   ENDSR                                                                CFT050
441100200529                                                                                              CFT050
441200200529      *****************************************************************                       CFT050
441300200529      /EJECT                                                                                  CFT050
441400200529      *****************************************************************                       CFT050
441500200529      * GETPARKEY - Get parent key from customer file                                         CFT050
441600200529      *****************************************************************                       CFT050
441700200529     C     GETPARKEY     BEGSR                                                                CFT050
441800200529      *                                                                                       CFT050
441900200529     C     WPARKEY       SETLL     SDCSSWL2                                                   CFT050
442000200529     C                   IF        %EQUAL                                                     CFT050
442100200529     C     WPARKEY       CHAIN     SDCSSWL2                                                   CFT050
442200200529     C                   IF        %FOUND(SDCSSWL2)                                           CFT050
442300200529      *                                                                                       CFT050
442400200529     C                   CALL      'AOCUSTR0'                                                 CFT050
442500200529     C                   PARM      *BLANKS       @RTCD                                        CFT050
442600200529     C                   PARM      '*KEY   '     @OPTN                                        CFT050
442700200529     C                   PARM      CSCUSD        @KEY1                                        CFT050
442800200529     C                   PARM      *BLANKS       @KYST                                        CFT050
442900200529     C     SDCUST        PARM      *BLANKS       DSSDY                                        CFT050
443000200529      *                                                                                       CFT050
443100200529     C                   IF        @RTCD = *BLANKS                                            CFT050
443200200529     C                   IF        DDPCNB = *BLANKS                                           CFT050
443300200529     C                   EVAL      DDPCNB = PR_BBPCNB                                         CFT050
443400200529     C                   ENDIF                                                                CFT050
443500200529     C                   ENDIF                                                                CFT050
443600200529      *                                                                                       CFT050
443700200529     C                   ENDIF                                                                CFT050
443800200529     C                   ENDIF                                                                CFT050
443900200529      *                                                                                       CFT050
444000200529     C                   ENDSR                                                                CFT050
444100200529                                                                                              CFT050
444200200529      *****************************************************************                       CFT050
444300200529      /EJECT                                                                                  CFT050
444400200529      *****************************************************************                       CFT050
444500200529      * DEF2NDSCR - Default second screen using record key                                    CFT050
444600200529      *****************************************************************                       CFT050
444700200529     C     DEF2NDSCR     BEGSR                                                                CFT050
444800200529      *                                                                                       CFT050
444900200529     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
445000200529      **                                                                                      CFT050
445100200529     C                   EVAL      WPARKEY = B3POKY                                           CFT050
445200200529      **                                                                                      CFT050
445300200529     C                   IF        DDBNBI = *BLANKS                                           CFT050
445400200529     C                   IF        B3ISST = 'BANK'                                            CFT050
445500200529     C                             OR B3ISST = 'COOP'                                         CFT050
445600200529     C                             OR B3ISST = 'CBMA'                                         CFT050
445700200529     C                   EVAL      DDBNBI = 'Y'                                               CFT050
445800200529     C                   ENDIF                                                                CFT050
445900200529     C                   ENDIF                                                                CFT050
446000200529      **                                                                                      CFT050
446100200529     C                   IF        DDCNA1 = *BLANKS                                           CFT050
446200200529     C                   EVAL      DDCNA1 = B3INS1                                            CFT050
446300200529     C                   ENDIF                                                                CFT050
446400200529      **                                                                                      CFT050
446500200529     C                   IF        DDCRNM = *BLANKS                                           CFT050
446600200529     C                   EVAL      DDCRNM = B3INS1                                            CFT050
446700200529     C                   ENDIF                                                                CFT050
446800200529      **                                                                                      CFT050
446900200529     C                   IF        DDCNA2 = *BLANKS                                           CFT050
447000200529     C                   EVAL      DDCNA2 = B3ADD1                                            CFT050
447100200529     C                   ENDIF                                                                CFT050
447200200529      **                                                                                      CFT050
447300200529     C                   IF        DDCNA3 = *BLANKS                                           CFT050
447400200529     C                   EVAL      DDCNA3 = B3ADD2                                            CFT050
447500200529     C                   ENDIF                                                                CFT050
447600200529      **                                                                                      CFT050
447700200529     C                   IF        DDCRTN = *BLANKS                                           CFT050
447800200529     C                   EVAL      DDCRTN = B3CITY                                            CFT050
447900200529     C                   ENDIF                                                                CFT050
448000200529      **                                                                                      CFT050
448100200529     C                   SELECT                                                               CFT050
448200200529     C                   WHEN      DDCNA1 = *BLANKS                                           CFT050
448300200529     C                   EVAL      DDCNA1 = B3CPS1                                            CFT050
448400200529     C                   WHEN      DDCNA2 = *BLANKS                                           CFT050
448500200529     C                   EVAL      DDCNA2 = B3CPS1                                            CFT050
448600200529     C                   WHEN      DDCNA3 = *BLANKS                                           CFT050
448700200529     C                   EVAL      DDCNA3 = B3CPS1                                            CFT050
448800200529     C                   WHEN      DDCNA4 = *BLANKS                                           CFT050
448900200529     C                   EVAL      DDCNA4 = B3CPS1                                            CFT050
449000200529     C                   ENDSL                                                                CFT050
449100200529      **                                                                                      CFT050
449200200529     C                   SELECT                                                               CFT050
449300200529     C                   WHEN      DDCNA1 = *BLANKS                                           CFT050
449400200529     C                   EVAL      DDCNA1 = B3CNT1                                            CFT050
449500200529     C                   WHEN      DDCNA2 = *BLANKS                                           CFT050
449600200529     C                   EVAL      DDCNA2 = B3CNT1                                            CFT050
449700200529     C                   WHEN      DDCNA3 = *BLANKS                                           CFT050
449800200529     C                   EVAL      DDCNA3 = B3CNT1                                            CFT050
449900200529     C                   WHEN      DDCNA4 = *BLANKS                                           CFT050
450000200529     C                   EVAL      DDCNA4 = B3CNT1                                            CFT050
450100200529     C                   ENDSL                                                                CFT050
450200200529      **                                                                                      CFT050
450300200529     C                   IF        DDCNCZ = *BLANKS                                           CFT050
450400200529     C                   EVAL      DDCNCZ = B3ISOC                                            CFT050
450500200529     C                   ENDIF                                                                CFT050
450600200529      **                                                                                      CFT050
450700200529     C                   IF        DDCNCZ = *BLANKS                                           CFT050
450800200529     C                   EVAL      DDCOLC = B3ISOC                                            CFT050
450900200529     C                   ENDIF                                                                CFT050
451000200529      **                                                                                      CFT050
451100200529     C                   EVAL      SVCNCZ = *BLANKS                                           CFT050
451200200529     C                   EVAL      SVCOLC = *BLANKS                                           CFT050
451300200529     C     B3ISOC        SETLL     SDCTRYL3                                                   CFT050
451400200529     C                   IF        %EQUAL                                                     CFT050
451500200529     C     B3ISOC        CHAIN     SDCTRYL3                                                   CFT050
451600200529     C                   DOW       %FOUND(SDCTRYL3)                                           CFT050
451700200529     C                   EVAL      SVCNCZ = A4CNCD                                            CFT050
451800200529     C                   EVAL      SVCOLC = A4CNCD                                            CFT050
451900200529     C                   IF        B3ISOC = A4CNCD                                            CFT050
452000200529     C                   EVAL      SVCNCZ = A4CNCD                                            CFT050
452100200529     C                   EVAL      SVCOLC = A4CNCD                                            CFT050
452200200529     C                   LEAVE                                                                CFT050
452300200529     C                   ENDIF                                                                CFT050
452400200529     C     B3ISOC        READE     SDCTRYL3                                                   CFT050
452500200529      ** SDCTRYL3 dow                                                                         CFT050
452600200529     C                   ENDDO                                                                CFT050
452700200529      **                                                                                      CFT050
452800200529     C                   IF        SVCNCZ <> *BLANKS                                          CFT050
452900200529     C                             AND DDCNCZ = *BLANK                                        CFT050
453000200529     C                   EVAL      DDCNCZ = SVCNCZ                                            CFT050
453100200529     C                   ENDIF                                                                CFT050
453200200529      **                                                                                      CFT050
453300200529     C                   IF        SVCOLC <> *BLANKS                                          CFT050
453400200529     C                             AND DDCOLC = *BLANK                                        CFT050
453500200529     C                   EVAL      DDCOLC = SVCOLC                                            CFT050
453600200529     C                   ENDIF                                                                CFT050
453700200529      ** SDCTRYL3 equal                                                                       CFT050
453800200529     C                   ENDIF                                                                CFT050
453900200529      ** MEBIB3L0 chain                                                                       CFT050
454000200529     C                   ENDIF                                                                CFT050
454100200529      *                                                                                       CFT050
454200200529     C                   ENDSR                                                                CFT050
454300200529      *                                                                                       CFT050
454400200529      *****************************************************************                       CFT050
454500200529      /EJECT                                                                                  CFT050
454600200529      *****************************************************************                       CFT050
454700200529      * DEF3RDSCR - Default third screen using record key                                     CFT050
454800200529      *****************************************************************                       CFT050
454900200529     C     DEF3RDSCR     BEGSR                                                                CFT050
455000200529      *                                                                                       CFT050
455100200529     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
455200200529      **                                                                                      CFT050
455300200529      **                                                                                      CFT050
455400200529     C                   IF        DDCSID = *BLANKS                                           CFT050
455500200529     C                   EVAL      DDCSID = B3BICC                                            CFT050
455600200529     C                   ENDIF                                                                CFT050
455700200529      **                                                                                      CFT050
455800200529     C                   IF        DDCIDA = *BLANKS                                           CFT050
455900200529     C                   EVAL      DDCIDA = B3CHIP                                            CFT050
456000200529     C                   ENDIF                                                                CFT050
456100200529      **                                                                                      CFT050
456200200529     C                   IF        B3ISOC = 'US'                                              CFT050
456300200529     C                   IF        DDFWCA = *BLANKS                                           CFT050
456400200529     C                   EVAL      DDFWCA = B3NATI                                            CFT050
456500200529     C                   ENDIF                                                                CFT050
456600200529     C                   ENDIF                                                                CFT050
456700200529      **                                                                                      CFT050
456800200529     C                   IF        B3ISOC = 'DE'                                              CFT050
456900200529     C                   IF        DDBLCD = *BLANKS                                           CFT050
457000200529     C                   EVAL      DDBLCD = B3NATI                                            CFT050
457100200529     C                   ENDIF                                                                CFT050
457200200529     C                   ENDIF                                                                CFT050
457300200529      **                                                                                      CFT050
457400200529     C                   IF        B3ISOC = 'JP'                                              CFT050
457500200529     C                   IF        DDBFIC = *BLANKS                                           CFT050
457600200529     C                   EVAL      DDBFIC = B3NATI                                            CFT050
457700200529     C                   ENDIF                                                                CFT050
457800200529     C                   ENDIF                                                                CFT050
457900200529      **                                                                                      CFT050
458000200529     C                   IF        B3ISOC = 'GB'                                              CFT050
458100200529     C                   IF        DDCSCA = *BLANKS                                           CFT050
458200200529     C                   EVAL      DDCSCA = B3NATI                                            CFT050
458300200529     C                   ENDIF                                                                CFT050
458400200529     C                   ENDIF                                                                CFT050
458500200529      **                                                                                      CFT050
458600200529     C                   EVAL      SVCLSY = *BLANKS                                         MD022443
458700200529     C                   IF        CSW213 = 'Y'                                               CSW213
458800200529      *                                                                                       CSW213
458900200529     C                   IF        DDCLID = *BLANKS                                           CSW213
459000200529     C                   EVAL      DDCLID = B3NATI                                            CSW213
459100200529     C                   ENDIF                                                                CSW213
459200200529      *                                                                                       CSW213
459300200529     C                   IF        DDCLSY = *BLANKS                                           CSW213
459400200529     C**********         EVAL      DDCLSY = B3ISOC                                   CSW213 MD022443
459500200529     C                   EVAL      SVCLSY = B3ISOC                                          MD022443
459600200529     C                   ENDIF                                                                CSW213
459700200529      *                                                                                       CSW213
459800200529     C**********         EVAL      SVCLSY = *BLANKS                                  CSW213 MD022443
459900200529     C                   SELECT                                                               CSW213
460000200529      *                                                                                       CSW213
460100200529     C                   WHEN      B3ISOC = 'AT'                                              CSW213
460200200529     C                   EVAL      SVCLSY = 'AT'                                              CSW213
460300200529      *                                                                                       CSW213
460400200529     C                   WHEN      B3ISOC = 'AU'                                              CSW213
460500200529     C                   EVAL      SVCLSY = 'AU'                                              CSW213
460600200529      *                                                                                       CSW213
460700200529     C                   WHEN      B3ISOC = 'CA'                                              CSW213
460800200529     C                   EVAL      SVCLSY = 'CC'                                              CSW213
460900200529      *                                                                                       CSW213
461000200529     C                   WHEN      B3ISOC = 'ES'                                              CSW213
461100200529     C                   EVAL      SVCLSY = 'ES'                                              CSW213
461200200529      *                                                                                       CSW213
461300200529     C                   WHEN      B3ISOC = 'GR'                                              CSW213
461400200529     C                   EVAL      SVCLSY = 'GR'                                              CSW213
461500200529      *                                                                                       CSW213
461600200529     C                   WHEN      B3ISOC = 'HK'                                              CSW213
461700200529     C                   EVAL      SVCLSY = 'HK'                                              CSW213
461800200529      *                                                                                       CSW213
461900200529     C                   WHEN      B3ISOC = 'IE'                                              CSW213
462000200529     C                   EVAL      SVCLSY = 'IE'                                              CSW213
462100200529      *                                                                                       CSW213
462200200529     C                   WHEN      B3ISOC = 'IN'                                              CSW213
462300200529     C                   EVAL      SVCLSY = 'IN'                                              CSW213
462400200529      *                                                                                       CSW213
462500200529     C                   WHEN      B3ISOC = 'IT'                                              CSW213
462600200529     C                   EVAL      SVCLSY = 'IT'                                              CSW213
462700200529      *                                                                                       CSW213
462800200529     C                   WHEN      B3ISOC = 'NZ'                                              CSW213
462900200529     C                   EVAL      SVCLSY = 'NZ'                                              CSW213
463000200529      *                                                                                       CSW213
463100200529     C                   WHEN      B3ISOC = 'PL'                                              CSW213
463200200529     C                   EVAL      SVCLSY = 'PL'                                              CSW213
463300200529      *                                                                                       CSW213
463400200529     C                   WHEN      B3ISOC = 'PT'                                              CSW213
463500200529     C                   EVAL      SVCLSY = 'PT'                                              CSW213
463600200529      *                                                                                       CSW213
463700200529     C                   WHEN      B3ISOC = 'RU'                                              CSW213
463800200529     C                   EVAL      SVCLSY = 'RU'                                              CSW213
463900200529      *                                                                                       CSW213
464000200529     C                   WHEN      B3ISOC = 'CH'                                              CSW213
464100200529     C                   EVAL      SVCLSY = 'SW'                                              CSW213
464200200529      *                                                                                       CSW213
464300200529     C                   WHEN      B3ISOC = 'SW'                                              CSW213
464400200529     C                   EVAL      SVCLSY = 'SW'                                              CSW213
464500200529      *                                                                                       CSW213
464600200529     C                   WHEN      B3ISOC = 'ZA'                                              CSW213
464700200529     C                   EVAL      SVCLSY = 'ZA'                                              CSW213
464800200529      *                                                                                       CSW213
464900200529     C                   OTHER                                                                CSW213
465000200529     C                   EVAL      DDCLID = *BLANKS                                           CSW213
465100200529     C                   EVAL      DDCLSY = *BLANKS                                           CSW213
465200200529      *                                                                                       CSW213
465300200529     C                   ENDSL                                                                CSW213
465400200529      *                                                                                       CSW213
465500200529     C                   IF        SVCLSY <> *BLANKS                                          CSW213
465600200529     C                             AND DDCLSY = *BLANKS                                       CSW213
465700200529     C                   EVAL      DDCLSY = SVCLSY                                            CSW213
465800200529     C                   ENDIF                                                                CSW213
465900200529      *                                                                                       CSW213
466000200529     C                   IF        DDLEIC = *BLANKS                                           CSW213
466100200529     C                   EVAL      DDLEIC = B3LEIC                                            CSW213
466200200529     C                   ENDIF                                                                CSW213
466300200529      ** CSW213                                                                               CSW213
466400200529     C                   ENDIF                                                                CSW213
466500200529      **                                                                                      CFT050
466600200529     C                   IF        B3CBIC <> *BLANKS                                          CFT050
466700200529     C                   EVAL      DDCSID =  B3CBIC                                           CFT050
466800200529     C                   ENDIF                                                                CFT050
466900200529      **                                                                                      CFT050
467000200529     C                   CALLB     'AOBEISR0'                                                 CFT050
467100200529     C                   PARM      *BLANKS       @RTCD                                        CFT050
467200200529     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
467300200529     C                   PARM      B3STYP        PBICD                                        CFT050
467400200529     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CFT050
467500200529     C                   IF        @RTCD <> *BLANKS                                           CFT050
467600200529     C                   IF        DDSWFI = *BLANKS                                           CFT050
467700200529     C                   EVAL      DDSWFI = 'Y'                                               CFT050
467800200529     C                   ENDIF                                                                CFT050
467900200529     C                   ELSE                                                                 CFT050
468000200529     C                   IF        DDSWFI = *BLANKS                                           CFT050
468100200529     C                   EVAL      DDSWFI = 'N'                                               CFT050
468200200529     C                   ENDIF                                                                CFT050
468300200529     C                   ENDIF                                                                CFT050
468400200529      **                                                                                      CFT050
468500200529     C**********         IF        CSW204 = 'Y'                                      CFT050 MD022463
468600200529     C**********                   AND B3STYP = 'CORP'                               CFT050 MD022463
468700200529     C**********         IF        DDCRPC = *BLANKS                                  CFT050 MD022463
468800200529     C**********         EVAL      DDCRPC = 'Y'                                      CFT050 MD022463
468900200529     C**********         ENDIF                                                       CFT050 MD022463
469000200529      ***CSW204*                                                                     CFT050 MD022463
469100200529     C**********         ENDIF                                                       CFT050 MD022463
469200200529     C                                                                                        CFT050
469300200529      ** MEBIB3L0 chain                                                                       CFT050
469400200529     C                   ENDIF                                                                CFT050
469500200529      *                                                                                       CFT050
469600200529     C                   ENDSR                                                                CFT050
469700200529      *****************************************************************                       CFT050
469800200529      /EJECT                                                                                  CFT050
469900200529      *****************************************************************                       CFT050
470000200529      * DEF8THSCR - Default eight screen using record key                                     CFT050
470100200529      *****************************************************************                       CFT050
470200200529     C     DEF8THSCR     BEGSR                                                                CFT050
470300200529      *                                                                                       CFT050
470400200529     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
470500200529      **                                                                                      CFT050
470600200529     C                   EVAL      WPARKEY = B3POKY                                           CFT050
470700200529      **                                                                                      CFT050
470800200529     C                   IF        CSW024 = 'Y'                                             MD022463
470900200529     C                             AND B3STYP = 'CORP'                                      MD022463
471000200529     C                   IF        DDCORP = *BLANKS                                         MD022463
471100200529     C                   EVAL      DDCORP = 'Y'                                             MD022463
471200200529     C                   ENDIF                                                              MD022463
471300200529      **                                                                                    MD022463
471400200529     C                   IF        B3BICC <>*BLANKS                                         MD022463
471500200529                                                                                            MD022463
471600200529     C                   IF        DDCBEI = *BLANKS                                           CFT050
471700200529     C                   EVAL      DDCBEI = B3UBIC                                            CFT050
471800200529     C                   ENDIF                                                                CFT050
471900200529                                                                                            MD022463
472000200529     C                   ELSE                                                               MD022463
472100200529      **                                                                                      CFT050
472200200529     C                   IF        DDRI01 = *BLANKS                                           CFT050
472300200529     C                   IF        B3BICC <> *BLANKS                                          CFT050
472400200529     C                   EVAL      DDRI01 = '/ABIC/' + B3BICC                                 CFT050
472500200529     C                   ELSE                                                                 CFT050
472600200529     C                   EVAL      DDRI01 = '/ABIC/UKNW'                                      CFT050
472700200529     C                   ENDIF                                                                CFT050
472800200529     C                   ENDIF                                                                CFT050
472900200529      **                                                                                      CFT050
473000200529     C                   IF        DDRI02 = *BLANKS                                           CFT050
473100200529     C                   EVAL      DDRI02 = '/NAME/' + B3INS1                                 CFT050
473200200529     C                   ENDIF                                                                CFT050
473300200529      **                                                                                      CFT050
473400200529     C                   IF        CSW213 = 'Y'                                               CFT050
473500200529     C                             AND B3LEIC <> *BLANKS                                      CFT050
473600200529     C                   IF        DDRI03 = *BLANKS                                           CFT050
473700200529     C                   EVAL      DDRI03 = '/LEIC/' + B3LEIC                                 CFT050
473800200529     C                   ENDIF                                                                CFT050
473900200529     C                   ENDIF                                                                CFT050
474000200529      ** B3BICC                                                                             MD022463
474100200529     C                   ENDIF                                                              MD022463
474200200529      ** CSW024                                                                             MD022463
474300200529     C                   ENDIF                                                              MD022463
474400200529     C                                                                                        CFT050
474500200529      ** MEBIB3L0 chain                                                                       CFT050
474600200529     C                   ENDIF                                                                CFT050
474700200529      *                                                                                       CFT050
474800200529     C                   ENDSR                                                                CFT050
474900200529      *                                                                                       CFT050
475000200529      *****************************************************************
475100200529      /EJECT
475200200529      *****************************************************************
475300200529      * *INZSR - INITIAL PROCESSING
475400200529      *****************************************************************
475500200529     C     *INZSR        BEGSR
475600200529                                                                                              CSD028
475700200529      ** Entry Parameters                                                                     CSD028
475800200529                                                                                              CSD028
475900200529     C     *ENTRY        PLIST                                                                CSD028
476000200529                                                                                              CSD028
476100200529      ** INPUTS                                                                               CSD028
476200200529      ** Transaction Type                                                                     CSD028
476300200529     C                   PARM                    TransType                                    CSD028
476400200529                                                                                              CSD028
476500200529      ** Customer Number                                                                      CSD028
476600200529     C                   PARM                    PCustNum                                     CSD028
476700200529                                                                                              CSD012
476800200529      * Override SDAULGL2                                                                     CSD012
476900200529     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
477000200529     C                   CALL      'QCMDEXC'                                                  CSD012
477100200529     C                   PARM                    CMD                                          CSD012
477200200529     C                   PARM                    CMDLEN                                       CSD012
477300200529      *
477400200529      ** Initialize program name
477500200529      *
477600200529     C                   MOVEL     'SDCUSDSIN'   DBPGM
477700200529      *
477800200529      ** ACCESS BANK DETAILS
477900200529      *
478000200529     C                   CALL      'AOBANKR0'
478100200529     C                   PARM      *BLANKS       @RTCD             7
478200200529     C                   PARM      '*FIRST '     @OPTN             7
478300200529     C     SDBANK        PARM      SDBANK        DSFDY
478400200529      *
478500200529      * DATABASE ERROR
478600200529      *
478700200529     C     @RTCD         IFNE      *BLANKS
478800200529     C                   MOVEL     'SDBANKPD'    DBFILE
478900200529     C                   MOVEL     '901'         DBASE
479000200529     C                   MOVEL     @OPTN         DBKEY
479100200529     C                   EXSR      *PSSR
479200200529     C                   END
479300200529      *
479400200529      ** Access Module Details
479500200529      *
479600200529     C                   CALL      'AOMMODR0'
479700200529     C                   PARM      *BLANKS       @RTCD
479800200529     C                   PARM      '*FIRST '     @OPTN
479900200529     C     SDMMOD        PARM      SDMMOD        DSFDY
480000200529      *
480100200529      * DATABASE ERROR
480200200529      *
480300200529     C     @RTCD         IFNE      *BLANKS
480400200529     C                   MOVEL     'SDMMODPD'    DBFILE
480500200529     C                   MOVEL     '904'         DBASE
480600200529     C                   MOVEL     @OPTN         DBKEY
480700200529     C                   EXSR      *PSSR
480800200529     C                   END
480900200529      *
481000200529      ** Access SAR details file to determine if S01383
481100200529      ** (Base Rate Tax) is on.
481200200529      *
481300200529     C                   CALLB     'AOSARDR0'
481400200529     C                   PARM      *BLANKS       @RTCD
481500200529     C                   PARM      '*VERIFY'     @OPTN
481600200529     C                   PARM      'S01383'      @SARD             6
481700200529     C     SCSARD        PARM      SCSARD        DSFDY
481800200529      *
481900200529      * DATABASE ERROR
482000200529      *
482100200529     C     @RTCD         IFNE      *BLANKS
482200200529     C     @RTCD         ANDNE     '*NRF   '
482300200529     C                   MOVEL     'SCSARDPD'    DBFILE
482400200529     C                   MOVEL     '905'         DBASE
482500200529     C                   MOVEL     'S01383'      DBKEY
482600200529     C                   EXSR      *PSSR
482700200529     C                   END
482800200529      *
482900200529     C     @RTCD         IFEQ      *BLANK
483000200529     C                   MOVEL     'Y'           S01383            1
483100200529     C                   ELSE
483200200529     C                   MOVEL     'N'           S01383
483300200529     C                   END
483400200529      *                                                                                       CSW024
483500200529      ** Access SAR details file to determine if CSW024                                       CSW024
483600200529      ** S.W.I.F.T. MT3xx Field 82/83/87 is installed.                                        CSW024
483700200529      *                                                                                       CSW024
483800200529     C                   CALLB     'AOSARDR0'                                                 CSW024
483900200529     C                   PARM      *BLANKS       @RTCD                                        CSW024
484000200529     C                   PARM      '*VERIFY'     @OPTN                                        CSW024
484100200529     C                   PARM      'CSW024'      @SARD                                        CSW024
484200200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW024
484300200529      *                                                                                       CSW024
484400200529      * DATABASE ERROR                                                                        CSW024
484500200529      *                                                                                       CSW024
484600200529     C     @RTCD         IFNE      *BLANKS                                                    CSW024
484700200529     C     @RTCD         ANDNE     '*NRF   '                                                  CSW024
484800200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSW024
484900200529     C                   MOVEL     '906'         DBASE                                        CSW024
485000200529     C                   MOVEL     'CSW024'      DBKEY                                        CSW024
485100200529     C                   EXSR      *PSSR                                                      CSW024
485200200529     C                   ENDIF                                                                CSW024
485300200529      *                                                                                       CSW024
485400200529     C     @RTCD         IFEQ      *BLANK                                                     CSW024
485500200529     C                   MOVEL     'Y'           CSW024            1                          CSW024
485600200529     C                   ELSE                                                                 CSW024
485700200529     C                   MOVEL     'N'           CSW024                                       CSW024
485800200529     C                   ENDIF                                                                CSW024
485900200529                                                                                              CSC011
486000200529      ** Access SAR Details file to determine if CSC011 is switched on                        CSC011
486100200529                                                                                              CSC011
486200200529     C                   CALLB     'AOSARDR0'                                                 CSC011
486300200529     C                   PARM      *BLANKS       @RTCD                                        CSC011
486400200529     C                   PARM      '*VERIFY'     @OPTN                                        CSC011
486500200529     C                   PARM      'CSC011'      @SARD                                        CSC011
486600200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
486700200529                                                                                              CSC011
486800200529      ** Database Error                                                                       CSC011
486900200529                                                                                              CSC011
487000200529     C     @RTCD         IFNE      *BLANKS                                                    CSC011
487100200529     C     @RTCD         ANDNE     '*NRF   '                                                  CSC011
487200200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSC011
487300200529     C                   MOVEL     '907'         DBASE                                        CSC011
487400200529     C                   MOVEL     'CSC011'      DBKEY                                        CSC011
487500200529     C                   EXSR      *PSSR                                                      CSC011
487600200529     C                   ENDIF                                                                CSC011
487700200529      *                                                                                       CSC011
487800200529     C     @RTCD         IFEQ      *BLANK                                                     CSC011
487900200529     C                   MOVEL     'Y'           CSC011            1                          CSC011
488000200529     C                   IN        SDSTAT                                                     CSC011
488100200529     C                   IN        SC24X7                                                     CSC011
488200200529     C                   ELSE                                                                 CSC011
488300200529     C                   MOVEL     'N'           CSC011                                       CSC011
488400200529     C                   ENDIF                                                                CSC011
488500200529                                                                                              CSD021
488600200529      ** Check if CSD021 is installed                                                         CSD021
488700200529     C                   CALLB     'AOSARDR0'                                                 CSD021
488800200529     C                   PARM      *BLANKS       @RTCD                                        CSD021
488900200529     C                   PARM      '*VERIFY'     @OPTN                                        CSD021
489000200529     C                   PARM      'CSD021'      @SARD                                        CSD021
489100200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD021
489200200529                                                                                              CSD021
489300200529      ** Database error                                                                       CSD021
489400200529                                                                                              CSD021
489500200529     C                   IF        (@RTCD <> *BLANKS) and                                     CSD021
489600200529     C                             (@RTCD <> '*NRF   ')                                       CSD021
489700200529     C                   EVAL      DBKEY = 'CSD021'                                           CSD021
489800200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD021
489900200529     C                   EVAL      DBASE = 909                                                CSD021
490000200529     C                   EXSR      *PSSR                                                      CSD021
490100200529     C                   ENDIF                                                                CSD021
490200200529                                                                                              CSD021
490300200529     C                   IF        @RTCD = *BLANKS                                            CSD021
490400200529     C                   EVAL      CSD021 = 'Y'                                               CSD021
490500200529     C                   ELSE                                                                 CSD021
490600200529     C                   EVAL      CSD021 = 'N'                                               CSD021
490700200529     C                   ENDIF                                                                CSD021
490800200529      *                                                                                       CSD012
490900200529      ** Access SAR details file to determine if CSD012                                       CSD012
491000200529      ** (Standing Data Authorisation) is on.                                                 CSD012
491100200529     C                   CALLB     'AOSARDR0'                                                 CSD012
491200200529     C                   PARM      *BLANKS       @RTCD                                        CSD012
491300200529     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
491400200529     C                   PARM      'CSD012'      @SARD                                        CSD012
491500200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC012
491600200529      *                                                                                       CSD012
491700200529     C     @RTCD         IFEQ      *BLANK                                                     CSD012
491800200529     C                   MOVE      'Y'           CSD012                                       CSD012
491900200529     C                   ELSE                                                                 CSD012
492000200529     C                   MOVE      'N'           CSD012                                       CSD012
492100200529     C                   ENDIF                                                                CSD012
492200200529                                                                                              CSD012
492300200529      ** If CSD012 is ON, Check if Customer Details Authorisation is ON                       CSD012
492400200529 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
492500200529      *                                                                                       CSD012
492600200529     C                   CALL      'AOSVALR0'                                                 CSD012
492700200529     C                   PARM                    @RTCD                                        CSD012
492800200529     C                   PARM      SVALKK        SVALK1           20                          CSD012
492900200529     C                   PARM                    SVAL1           200                          CSD012
493000200529     C                   PARM                    SVALK2           20                          CSD012
493100200529     C                   PARM                    SVAL2           200                          CSD012
493200200529     C                   PARM                    SVALK3           20                          CSD012
493300200529     C                   PARM                    SVAL3           200                          CSD012
493400200529     C                   PARM                    SVALK4           20                          CSD012
493500200529     C                   PARM                    SVAL4           200                          CSD012
493600200529     C                   PARM                    SVALK5           20                          CSD012
493700200529     C                   PARM                    SVAL5           200                          CSD012
493800200529     C                   PARM                    SVALK6           20                          CSD012
493900200529     C                   PARM                    SVAL6           200                          CSD012
494000200529     C                   PARM                    SVALK7           20                          CSD012
494100200529     C                   PARM                    SVAL7           200                          CSD012
494200200529     C                   PARM                    SVALK8           20                          CSD012
494300200529     C                   PARM                    SVAL8           200                          CSD012
494400200529     C                   PARM                    SVALK9           20                          CSD012
494500200529     C                   PARM                    SVAL9           200                          CSD012
494600200529     C                   PARM                    SVALK0           20                          CSD012
494700200529     C                   PARM                    SVAL10          200                          CSD012
494800200529      *                                                                                       CSD012
494900200529     C     @RTCD         IFNE      *BLANKS                                                    CSD012
495000200529                                                                                              CSD012
495100200529     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
495200200529     C                   MOVE      SVALK0        DBKEY                                        CSD012
495300200529     C                   ENDIF                                                                CSD012
495400200529     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
495500200529     C                   MOVE      SVALK9        DBKEY                                        CSD012
495600200529     C                   ENDIF                                                                CSD012
495700200529     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
495800200529     C                   MOVE      SVALK8        DBKEY                                        CSD012
495900200529     C                   ENDIF                                                                CSD012
496000200529     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
496100200529     C                   MOVE      SVALK7        DBKEY                                        CSD012
496200200529     C                   ENDIF                                                                CSD012
496300200529     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
496400200529     C                   MOVE      SVALK6        DBKEY                                        CSD012
496500200529     C                   ENDIF                                                                CSD012
496600200529     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
496700200529     C                   MOVE      SVALK5        DBKEY                                        CSD012
496800200529     C                   ENDIF                                                                CSD012
496900200529     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
497000200529     C                   MOVE      SVALK4        DBKEY                                        CSD012
497100200529     C                   ENDIF                                                                CSD012
497200200529     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
497300200529     C                   MOVE      SVALK3        DBKEY                                        CSD012
497400200529     C                   ENDIF                                                                CSD012
497500200529     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
497600200529     C                   MOVE      SVALK2        DBKEY                                        CSD012
497700200529     C                   ENDIF                                                                CSD012
497800200529     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
497900200529     C                   MOVE      SVALK1        DBKEY                                        CSD012
498000200529     C                   ENDIF                                                                CSD012
498100200529                                                                                              CSD012
498200200529     C     *LOCK         IN        LDA                                                        CSD012
498300200529     C                   Z-ADD     908           DBASE                                        CSD012
498400200529     C                   MOVEL     'SDSVALPD'    DBFILE                                       CSD012
498500200529     C                   MOVEL     'SDCUSDSIN'   DBPGM                                        CSD012
498600200529     C                   OUT       LDA                                                        CSD012
498700200529     C                   EXSR      *PSSR                                                      CSD012
498800200529     C                   ENDIF                                                                CSD012
498900200529      *                                                                                       CSD012
499000200529      ** If Customer Details Authorisation is On set to Authorise                             CSD012
499100200529     C     SVAL11        IFEQ      'Y'                                                        CSD012
499200200529     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
499300200529     C                   ELSE                                                                 CSD012
499400200529     C                   MOVE      'N'           AUTHRQ                                       CSD012
499500200529     C                   ENDIF                                                                CSD012
499600200529      *                                                                                       CSD012
499700200529 E1  C                   ENDIF                                                                CSD012
499800200529                                                                                              CGP001
499900200529      ** Check if Global Data Layout Enhancement (CGP001) is on.                              CGP001
500000200529                                                                                              CGP001
500100200529     C                   EVAL      CGP001 = 'N'                                               CGP001
500200200529                                                                                              CGP001
500300200529     C                   CALLB     'AOSARDR0'                                                 CGP001
500400200529     C                   PARM      *BLANKS       @RTCD                                        CGP001
500500200529     C                   PARM      '*VERIFY'     @OPTN                                        CGP001
500600200529     C                   PARM      'CGP001'      @SARD                                        CGP001
500700200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGP001
500800200529                                                                                              CGP001
500900200529     C                   IF        @RTCD = *BLANKS                                            CGP001
501000200529     C                   EVAL      CGP001 = 'Y'                                               CGP001
501100200529     C                   ENDIF                                                                CGP001
501200200529                                                                                              CGP001
501300200529     C                   IF        @RTCD <> *BLANKS and                                       CGP001
501400200529     C                             @RTCD <> '*NRF   '                                         CGP001
501500200529     C     *LOCK         IN        LDA                                                        CGP001
501600200529     C                   EVAL      DBKEY = 'CGP001'                                           CGP001
501700200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGP001
501800200529     C                   EVAL      DBASE = 908                                                CGP001
501900200529     C                   OUT       LDA                                                        CGP001
502000200529     C                   EXSR      *PSSR                                                      CGP001
502100200529     C                   ENDIF                                                                CGP001
502200200529                                                                                              CLE025
502300200529      ** Check if enhancement CLE025 (Multi-Option Facilities) is on                          CLE025
502400200529                                                                                              CLE025
502500200529     C                   CALLB     'AOSARDR0'                                                 CLE025
502600200529     C                   PARM      *BLANKS       PRTCD                                        CLE025
502700200529     C                   PARM      '*VERIFY'     POPTN                                        CLE025
502800200529     C                   PARM      'CLE025'      PSARD                                        CLE025
502900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
503000200529                                                                                              CLE025
503100200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE025
503200200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
503300200529     C                   EVAL      DBKEY  = 'CLE025'                                          CLE025
503400200529     C                   EVAL      DBASE  = 902                                               CLE025
503500200529     C                   EXSR      *PSSR                                                      CLE025
503600200529     C                   ENDIF                                                                CLE025
503700200529      *                                                                                       CLE025
503800200529     C                   IF        PRTCD = *BLANKS                                            CLE025
503900200529     C                   EVAL      CLE025 = 'Y'                                               CLE025
504000200529     C                   ELSE                                                                 CLE025
504100200529     C                   EVAL      CLE025 = 'N'                                               CLE025
504200200529     C                   ENDIF                                                                CLE025
504300200529                                                                                              CFX001
504400200529      ** Check if enhancement CFX001 (FX Margin Trading) is on                                CFX001
504500200529                                                                                              CFX001
504600200529     C                   CALLB     'AOSARDR0'                                                 CFX001
504700200529     C                   PARM      *BLANKS       PRTCD                                        CFX001
504800200529     C                   PARM      '*VERIFY'     POPTN                                        CFX001
504900200529     C                   PARM      'CFX001'      PSARD                                        CFX001
505000200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CFX001
505100200529                                                                                              CFX001
505200200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CFX001
505300200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFX001
505400200529     C                   EVAL      DBKEY  = 'CFX001'                                          CFX001
505500200529     C                   EVAL      DBASE  = 903                                               CFX001
505600200529     C                   EXSR      *PSSR                                                      CFX001
505700200529     C                   ENDIF                                                                CFX001
505800200529      *                                                                                       CFX001
505900200529     C                   IF        PRTCD = *BLANKS                                            CFX001
506000200529     C                   EVAL      CFX001 = 'Y'                                               CFX001
506100200529     C                   ELSE                                                                 CFX001
506200200529     C                   EVAL      CFX001 = 'N'                                               CFX001
506300200529     C                   ENDIF                                                                CFX001
506400200529                                                                                              CGP001
506500200529      ** Check if enhancement CSD028 (Know Your Customer) is on                               CSD028
506600200529                                                                                              CSD028
506700200529     C                   CALLB     'AOSARDR0'                                                 CSD028
506800200529     C                   PARM      *BLANKS       PRTCD                                        CSD028
506900200529     C                   PARM      '*VERIFY'     POPTN                                        CSD028
507000200529     C                   PARM      'CSD028'      PSARD                                        CSD028
507100200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD028
507200200529                                                                                              CSD028
507300200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD028
507400200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD028
507500200529     C                   EVAL      DBKEY = 'CSD028'                                           CSD028
507600200529     C                   EVAL      DBASE = 910                                                CSD028
507700200529     C                   EXSR      *PSSR                                                      CSD028
507800200529     C                   ENDIF                                                                CSD028
507900200529                                                                                              CSD028
508000200529     C                   IF        PRTCD = *BLANKS                                            CSD028
508100200529     C                   EVAL      CSD028 = 'Y'                                               CSD028
508200200529     C                   ELSE                                                                 CSD028
508300200529     C                   EVAL      CSD028 = 'N'                                               CSD028
508400200529     C                   ENDIF                                                                CSD028
508500200529                                                                                              CSD028
508600200529      *                                                                                       CER001
508700200529      ** Check if ULX043 in ON                                                                CER001
508800200529      *                                                                                       CER001
508900200529     C                   CALLB     'AOSARDR0'                                                 CER001
509000200529     C                   PARM      *BLANKS       PRTCD                                        CER001
509100200529     C                   PARM      '*VERIFY'     POPTN                                        CER001
509200200529     C                   PARM      'ULX043'      PSARD                                        CER001
509300200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
509400200529                                                                                              CER001
509500200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
509600200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
509700200529     C                   EVAL      DBKEY  = 'ULX043'                                          CER001
509800200529     C                   EVAL      DBASE  = 910                                               CER001
509900200529     C                   EXSR      *PSSR                                                      CER001
510000200529     C                   ENDIF                                                                CER001
510100200529      *                                                                                       CER001
510200200529     C                   IF        PRTCD = *BLANKS                                            CER001
510300200529     C                   EVAL      ULX043 = 'Y'                                               CER001
510400200529      *                                                                                       CER001
510500200529      ** Do not process lux extension details when IBLC Returns                               CER001
510600200529      ** indicator is not set to 'Y'                                                          CER001
510700200529      *                                                                                       CER001
510800200529     C                   IF         BGNWST <> 'Y'                                             CER001
510900200529     C                   EVAL       ULX043 = 'N'                                              CER001
511000200529     C                   ENDIF                                                                CER001
511100200529     C                   ELSE                                                                 CER001
511200200529     C                   EVAL      ULX043 = 'N'                                               CER001
511300200529     C                   ENDIF                                                                CER001
511400200529      *                                                                                       CER001
511500200529     C                   IF        ULX043 = 'Y' AND BGNWST = 'Y'                              CER001
511600200529     C                   OPEN      SDCUX1L0                                                   CER001
511700200529     C                   OPEN      SDINX1L0                                                   CER001
511800200529     C                   OPEN      SDCTX2L0                                                   CER001
511900200529     C                   ENDIF                                                                CER001
512000200529      *                                                                                       CER001
512100200529      ** Check if ULX008 in ON                                                                CER001
512200200529      *                                                                                       CER001
512300200529     C                   CALLB     'AOSARDR0'                                                 CER001
512400200529     C                   PARM      *BLANKS       PRTCD                                        CER001
512500200529     C                   PARM      '*VERIFY'     POPTN                                        CER001
512600200529     C                   PARM      'ULX008'      PSARD                                        CER001
512700200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
512800200529                                                                                              CER001
512900200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
513000200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
513100200529     C                   EVAL      DBKEY  = 'ULX008'                                          CER001
513200200529     C                   EVAL      DBASE  = 911                                               CER001
513300200529     C                   EXSR      *PSSR                                                      CER001
513400200529     C                   ENDIF                                                                CER001
513500200529      *                                                                                       CER001
513600200529     C                   IF        PRTCD = *BLANKS                                            CER001
513700200529     C                   EVAL      ULX008 = 'Y'                                               CER001
513800200529     C                   ELSE                                                                 CER001
513900200529     C                   EVAL      ULX008 = 'N'                                               CER001
514000200529     C                   ENDIF                                                                CER001
514100200529      *                                                                                       CER001
514200200529      ** Check if ULX012 in ON                                                                CER001
514300200529      *                                                                                       CER001
514400200529     C                   CALLB     'AOSARDR0'                                                 CER001
514500200529     C                   PARM      *BLANKS       PRTCD                                        CER001
514600200529     C                   PARM      '*VERIFY'     POPTN                                        CER001
514700200529     C                   PARM      'ULX012'      PSARD                                        CER001
514800200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
514900200529                                                                                              CER001
515000200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
515100200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
515200200529     C                   EVAL      DBKEY  = 'ULX012'                                          CER001
515300200529     C                   EVAL      DBASE  = 912                                               CER001
515400200529     C                   EXSR      *PSSR                                                      CER001
515500200529     C                   ENDIF                                                                CER001
515600200529      *                                                                                       CER001
515700200529     C                   IF        PRTCD = *BLANKS                                            CER001
515800200529     C                   EVAL      ULX012 = 'Y'                                               CER001
515900200529     C                   ELSE                                                                 CER001
516000200529     C                   EVAL      ULX012 = 'N'                                               CER001
516100200529     C                   ENDIF                                                                CER001
516200200529      *                                                                                       CER001
516300200529      ** Check if ULX048 in ON                                                                CER001
516400200529      *                                                                                       CER001
516500200529     C                   CALLB     'AOSARDR0'                                                 CER001
516600200529     C                   PARM      *BLANKS       PRTCD                                        CER001
516700200529     C                   PARM      '*VERIFY'     POPTN                                        CER001
516800200529     C                   PARM      'ULX048'      PSARD                                        CER001
516900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
517000200529                                                                                              CER001
517100200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
517200200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
517300200529     C                   EVAL      DBKEY  = 'ULX048'                                          CER001
517400200529     C                   EVAL      DBASE  = 913                                               CER001
517500200529     C                   EXSR      *PSSR                                                      CER001
517600200529     C                   ENDIF                                                                CER001
517700200529      *                                                                                       CER001
517800200529     C                   IF        PRTCD = *BLANKS                                            CER001
517900200529     C                   EVAL      ULX048 = 'Y'                                               CER001
518000200529     C                   ELSE                                                                 CER001
518100200529     C                   EVAL      ULX048 = 'N'                                               CER001
518200200529     C                   ENDIF                                                                CER001
518300200529      *                                                                                       CER001
518400200529      ** Check if ULX609 in ON                                                                CER001
518500200529      *                                                                                       CER001
518600200529     C                   CALLB     'AOSARDR0'                                                 CER001
518700200529     C                   PARM      *BLANKS       PRTCD                                        CER001
518800200529     C                   PARM      '*VERIFY'     POPTN                                        CER001
518900200529     C                   PARM      'ULX609'      PSARD                                        CER001
519000200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
519100200529                                                                                              CER001
519200200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
519300200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
519400200529     C                   EVAL      DBKEY  = 'ULX609'                                          CER001
519500200529     C                   EVAL      DBASE  = 914                                               CER001
519600200529     C                   EXSR      *PSSR                                                      CER001
519700200529     C                   ENDIF                                                                CER001
519800200529      *                                                                                       CER001
519900200529     C                   IF        PRTCD = *BLANKS                                            CER001
520000200529     C                   EVAL      ULX609 = 'Y'                                               CER001
520100200529      *                                                                                       CER001
520200200529      ** Do not process lux extension details when Lux Return                                 CER001
520300200529      ** indicator is not set to 'Y'                                                          CER001
520400200529      *                                                                                       CER001
520500200529     C                   IF         BGLRIN <> 'Y'                                             CER001
520600200529     C                   EVAL       ULX609 = 'N'                                              CER001
520700200529     C                   ENDIF                                                                CER001
520800200529     C                   ELSE                                                                 CER001
520900200529     C                   EVAL      ULX609 = 'N'                                               CER001
521000200529     C                   ENDIF                                                                CER001
521100200529      *                                                                                       CER001
521200200529     C                   IF        ULX609 = 'Y' and BGLRIN = 'Y'                              CER001
521300200529     C                   OPEN      SDCUX2L0                                                   CER001
521400200529     C                   ENDIF                                                                CER001
521500200529                                                                                              CSW207
521600200529      ** Check if SWIFT 2007 is installed                                                     CSW207
521700200529                                                                                              CSW207
521800200529     C                   CALL      'SWIF2007'                                                 CSW207
521900200529     C                   PARM      *BLANKS       PRtCd                                        CSW207
522000200529                                                                                              CSW207
522100200529     C                   IF        PRtCd   = 'CSW2007'                                        CSW207
522200200529     C                   EVAL      CSW207 = 'Y'                                               CSW207
522300200529     C                   ELSE                                                                 CSW207
522400200529     C                   EVAL      CSW207 = 'N'                                               CSW207
522500200529     C                   ENDIF                                                                CSW207
522600200529                                                                                              CSW207
522700200529      *                                                                                     BUG13228
522800200529      ** Check if ULX004 in ON                                                              BUG13228
522900200529      *                                                                                     BUG13228
523000200529     C                   CALLB     'AOSARDR0'                                               BUG13228
523100200529     C                   PARM      *BLANKS       PRTCD                                      BUG13228
523200200529     C                   PARM      '*VERIFY'     POPTN                                      BUG13228
523300200529     C                   PARM      'ULX004'      PSARD                                      BUG13228
523400200529     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG13228
523500200529                                                                                            BUG13228
523600200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                BUG13228
523700200529     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG13228
523800200529     C                   EVAL      DBKEY  = 'ULX004'                                        BUG13228
523900200529     C                   EVAL      DBASE  = 915                                             BUG13228
524000200529     C                   EXSR      *PSSR                                                    BUG13228
524100200529     C                   ENDIF                                                              BUG13228
524200200529      *                                                                                     BUG13228
524300200529     C                   IF        PRTCD = *BLANKS                                          BUG13228
524400200529     C                   EVAL      ULX004 = 'Y'                                             BUG13228
524500200529     C                   ELSE                                                               BUG13228
524600200529     C                   EVAL      ULX004 = 'N'                                             BUG13228
524700200529     C                   ENDIF                                                              BUG13228
524800200529      ***********                                                                 BUG26917 BUG26917A
524900200529      ***Check*if*CER048*is*ON*                                                   BUG26917 BUG26917A
525000200529      **********                                                                  BUG26917 BUG26917A
525100200529     C**********         CALLB     'AOSARDR0'                                     BUG26917 BUG26917A
525200200529     C**********         PARM      *BLANKS       PRTCD                            BUG26917 BUG26917A
525300200529     C**********         PARM      '*VERIFY'     POPTN                            BUG26917 BUG26917A
525400200529     C**********         PARM      'CER048'      PSARD                            BUG26917 BUG26917A
525500200529     C*****SCSARD        PARM      SCSARD        DSFDY                            BUG26917 BUG26917A
525600200529      **********                                                                  BUG26917 BUG26917A
525700200529     C**********         IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '      BUG26917 BUG26917A
525800200529     C**********         EVAL      DBFILE = 'SCSARDPD'                            BUG26917 BUG26917A
525900200529     C**********         EVAL      DBKEY  = 'CER048'                              BUG26917 BUG26917A
526000200529     C**********         EVAL      DBASE  = 915                                   BUG26917 BUG26917A
526100200529     C**********         EXSR      *PSSR                                          BUG26917 BUG26917A
526200200529     C**********         ENDIF                                                    BUG26917 BUG26917A
526300200529      **********                                                                  BUG26917 BUG26917A
526400200529     C**********         IF        PRTCD = *BLANKS                                BUG26917 BUG26917A
526500200529     C**********         EVAL      CER048 = 'Y'                                   BUG26917 BUG26917A
526600200529     C**********         ELSE                                                     BUG26917 BUG26917A
526700200529     C**********         EVAL      CER048 = 'N'                                   BUG26917 BUG26917A
526800200529     C**********         ENDIF                                                    BUG26917 BUG26917A
526900200529      **********                                                                  BUG26917 BUG26917A
527000200529      *                                                                                       CER001
527100200529     C     K@KEY1        KLIST                                                                CER001
527200200529     C                   KFLD                    KCUST                                        CER001
527300200529     C/COPY WNCPYSRC,SDH00489
527400200529      ** Check if CSD037 is enabled.                                                          CSD031
527500200529                                                                                              CSD031
527600200529     C                   CALLB     'AOSARDR0'                                                 CSD031
527700200529     C                   PARM      *BLANKS       PRtCd                                        CSD031
527800200529     C                   PARM      '*VERIFY'     POptn                                        CSD031
527900200529     C                   PARM      'CSD037'      PSARD                                        CSD031
528000200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD031
528100200529                                                                                              CSD031
528200200529     C                   IF        PRtCd = *BLANKS                                            CSD031
528300200529     C                   EVAL      CSD037 = 'Y'                                               CSD031
528400200529     C                   ELSE                                                                 CSD031
528500200529                                                                                              CSD031
528600200529     C                   IF        PRtCd <> '*NRF   '                                         CSD031
528700200529     C     *LOCK         IN        LDA                                                        CSD031
528800200529     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD031
528900200529     C                   EVAL      DBKey = 'CSD037'                                           CSD031
529000200529     C                   EVAL      DBase = 101                                                CSD031
529100200529     C                   OUT       LDA                                                        CSD031
529200200529     C                   EXSR      *PSSR                                                      CSD031
529300200529     C                   ENDIF                                                                CSD031
529400200529                                                                                              CSD031
529500200529     C                   ENDIF                                                                CSD031
529600200529                                                                                              CSD031
529700200529      ** Access Switchable Features file to determine whether                                LLN022A
529800200529      ** LLN022 (Bank of England) processing is installed.                                   LLN022A
529900200529      *                                                                                      LLN022A
530000200529     C                   MOVE      'N'           LLN022            1                         LLN022A
530100200529     C                   CALLB     'AOSARDR0'                                                LLN022A
530200200529     C                   PARM      *BLANK        PRTCD                                       LLN022A
530300200529     C                   PARM      '*VERIFY'     POPTN                                       LLN022A
530400200529     C                   PARM      'LLN022'      PSARD                                       LLN022A
530500200529     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
530600200529      *                                                                                      LLN022A
530700200529     C                   IF        PRTCD = *BLANK                                            LLN022A
530800200529     C                   MOVE      'Y'           LLN022                                      LLN022A
530900200529     C                   ENDIF                                                               LLN022A
531000200529      *                                                                                     MD022463
531100200529      ** Check if SWIFT 2013 is installed                                                   MD022463
531200200529      *                                                                                     MD022463
531300200529     C                   CALL      'SWIF2013'                                               MD022463
531400200529     C                   PARM      *BLANKS       PRtCd                                      MD022463
531500200529                                                                                            MD022463
531600200529     C                   IF        PRtCd   = 'CSW2013'                                      MD022463
531700200529     C                   EVAL      CSW213 = 'Y'                                             MD022463
531800200529     C                   ELSE                                                               MD022463
531900200529     C                   EVAL      CSW213 = 'N'                                             MD022463
532000200529     C                   ENDIF                                                              MD022463
532100200529      *                                                                                     MD022463
532200200529      ** Check if CFT050 in ON                                                              MD022463
532300200529      *                                                                                     MD022463
532400200529     C                   CALLB     'AOSARDR0'                                               MD022463
532500200529     C                   PARM      *BLANKS       PRtCd                                      MD022463
532600200529     C                   PARM      '*VERIFY'     POptn                                      MD022463
532700200529     C                   PARM      'CFT050'      PSard                                      MD022463
532800200529     C     SCSARD        PARM      SCSARD        DSFDY                                      MD022463
532900200529                                                                                            MD022463
533000200529     C                   IF        PRtCd <> *BLANKS  AND  PRtCd <> '*NRF   '                MD022463
533100200529     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD022463
533200200529     C                   EVAL      DBKEY  = 'CFT050'                                        MD022463
533300200529     C                   EVAL      DBASE  = 916                                             MD022463
533400200529     C                   EXSR      *PSSR                                                    MD022463
533500200529     C                   ENDIF                                                              MD022463
533600200529      *                                                                                     MD022463
533700200529     C                   IF        PRtCd = *BLANKS                                          MD022463
533800200529     C                   EVAL      CFT050 = 'Y'                                             MD022463
533900200529     C                   ELSE                                                               MD022463
534000200529     C                   EVAL      CFT050 = 'N'                                             MD022463
534100200529     C                   ENDIF                                                              MD022463
534200200529     C/COPY WNCPYSRC,SDCUSDSC06
534300200529      *
534400200529      * GO TO INITIAL SCREEN
534500200529      *
534600200529     C                   EXSR      INITIAL
534700200529      *
534800200529
534900200529      *  Hook to enable non-core initial processing to be included
535000200529      /COPY WNCPYSRC,SDCUSDS013
535100200529
535200200529     C                   ENDSR
535300200529      *****************************************************************
535400200529      /EJECT
535500200529     C/COPY WNCPYSRC,SDCUSDSC23
535600200529      *****************************************************************
535700200529      ** Program, module and procedure names for database error processing.
535800200529      ** =================================================================
535900200529      ** The following /COPY sets these values, and also defines LDA as
536000200529      ** an external data area
536100200529      ********************************************************************
536200200529     C/COPY ZACPYSRC,PSSR_ILE
536300200529      ********************************************************************
536400200529**  CPY@
536500200529(c) Finastra International Limited 2001
