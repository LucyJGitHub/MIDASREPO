     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details screen input')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCUSDSIN - CUSTOMER DETAILS SCREEN INPUT                    *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Customer Details.                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054028           Date 05Sep19               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 CER070             Date 24Nov14               *
      *                 MD030956           Date 09Oct14               *
      *                 MD022854           Date 14Oct13               *
      *                 MD022463           Date 27Sep13               *
      *                 MD022395           Date 15Sep13               *
      *                 MD022443           Date 18Sep13               *
      *                 CFT050             Date 03Jun13               *
      *                 CSW213             Date 03Jun13               *
      *                 CLE134             Date 01Aug12               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26917A          Date 27Jan10               *
      *                 BUG26917           Date 20Jan10               *
      *                 BUG23518           Date 30Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248913             Date 11Jul07               *
      *                 CSW207A            Date 08Jun07               *
      *                 CSW207             Date 08Jun07               *
      *                 249076             Date 03Aug07               *
      *                 244030             Date 28Nov06               *
      *                 CRE026             Date 24May06               *
      *                 BUG13228           Date 07Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BG12345A           Date 29Oct06               *
      *                 BUG11917           Date 18Aug06               *
      *                 BUG11907           Date 16Aug06               *
      *                 BUG11889           Date 13Aug06               *
      *                 213713             Date 06Jun06               *
      *                 BUG8425            Date 24May06               *
      *                 237595             Date 07Feb06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8134            Date 10Oct05               *
      *                 CSD027A            Date 05May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10817           Date 17Mar06               *
      *                 BUG10295           Date 02Feb06               *
      *                 CER001             Date 25Apr05               *
      *                 CSD028             Date 22Aug05               *
      *                 CGL031             Date 05Jul04               *
      *                 235524             Date 26Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6565            Date 05Apr05               *
      *                 BUG6198            Date 04Apr05               *
      *                 BUG5139            Date 10Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4454            Date 08Oct04               *
      *                 BUG3362            Date 28Jul04               *
      *                 CFX001             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2664            Date 21May04               *
      *                 CSD021             Date 14Jul03               *
      *                 222373             Date 24Oct03               *
      *                 CGP001             Date 23May03               *
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 212263             Date 21Nov02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 203036             Date 10May02               *
      *                 202805             Date 10May02               *
      *                 192916             Date 27Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 193883             Date 20Nov01               *
      *                 CSW024             Date 31Aug01               *
      *                 196149             Date 16Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      *                 185595             Date 30Oct00               *
      *                 CPB002             Date 13Dec99               *
      *                 189774             Date 13Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP014             Date 20Dec99               *
      *                 CAP034  *CREATE    Date 25May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Recompiled over changes in /COPY                    *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  MD022854 - No Legal entity identifier for input              *
      *  MD022463 - No screen is displayed to show Bank Directory     *
      *             Plus Detail Screen on Linked Customers during     *
      *             Amend and Enquire                                 *
      *  MD022395 - Value of Clearing System on previously checked    *
      *             customer is copied into another customer when     *
      *             amending it                                       *
      *  MD022443 - Clearing System incorrect defaulting for ISO      *
      *             Country code CA and CH                            *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,SDH00104                                 *
      *             WNCPYSRC,SDH00105                                 *
      *             WNCPYSRC,SDH00109                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG26917A - Reverse fix for bug26917                         *
      *  BUG26917 - COB error when customer is declared as taxable    *
      *           w/ German features installed and no additional      *
      *           customers information is set up                     *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248913 - Disable F7/F8 or Next/Previous screen option during *
      *           input or amend.                                     *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  249076 - Enhance error message S270004 to show character     *
      *           and position that is not allowed in SDSVALPD.       *
      *  244030 - Clear datastructure for further details to prevent  *
      *           database error during insertion of new customers.   *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BUG13228 - Need to pass status of ULX004 to SDCUSD2SN        *
      *  BG12345A - I/O Operation was applied tp closed File SDINX10  *
      *  BUG11917 - Different error message appear when enquiring/    *
      *             accepting/deleting a record in zonal acceptance   *
      *  BUG11907 - System hangs when rejecting a customer record     *
      *             in acceptance list                                *
      *  BUG11889 - Alphanumeric customer not accepted in zonal F11   *
      *  213713 - Window processing not performed when PB module is   *
      *           switched off.  Ensure window is displayed when      *
      *           window processing is on and PB module is off.       *
      *  BUG8425 - Update customer file before proceeding to further  *
      *            details especially Securities and Futures and      *
      *            options.                                           *
      *  237595 - Amend program such that when action code is 'D',    *
      *           access is allowed to the next screens, enabling the *
      *           user to delete further customer details (i.e.,      *
      *           marketing information, etc.).  Applied fix 230859.  *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  BUG8134 - Recompiled source to fix this bug                  *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10817 - DB Error upon accessing SDCUX2L0                  *
      *  BUG10295 - Customer details extension missing                *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *  CGL031 - Taxation on Savings Income                          *
      *  235524 - Show "Message Routing Maintenance" screen on enquiry*
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6565- Window processing not properly handled in SDCUSDSIN *
      *  BUG6198 - Cannot save new Details for CUSD (Recompile)       *
      *  BUG5139 - Unable to process additional customer during       *
      *            insert                                             *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4454 - Database error when inserting a customer with      *
      *           additional customer details                         *
      *  BUG3362 - Added processing for TI details.                   *
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Credit Lines                                        *
      *  BUG2664 - Amend program such that BBTICS is not reset during *
      *            amendment of TI client.  Apply part of fix 219329. *
      *  CSD021 - System generated customer number.                   *
      *  222373 - Parameter Mismatch                                  *
      *  CGP001 - Global Processing                                   *
      *  CSD012 - Standing Data Authorisation                         *
      *  212263 - Complete CPB002 : the call of AOPLCSR0 requires     *
      *           4 parameters                                        *
      *           Condition the call : if PM is off, do not call      *
      *  203036 - If Private Banking Module is not Switched On, don't *
      *           display screen.                                     *
      *  202805 - Using API, amended FX Netting Details not updated.  *
      *  192916 - Rollback of window updates wrongly managed in Core  *
      *           API's modules RPR and SIN.                          *
      *  CSC011 - 24x7 Midas Availability                             *
      *  193883 - Recompile over changed SDCUSDUPD.                   *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *  196149 - Update BBTICS with the value of FDTICS from SD0014V.*
      *  CRE007 - Base Rate Tax 2001                                  *
      *  185595 - Impossible to input "Further Details" during Input  *
      *  CPB002 - New Private Banking Customer Processing.            *
      *  189774 - Window processing for Customer Details API program  *
      *  CSD007 - Customer Closing:                                   *
      *           Allow for action codes 'C' (closure) and 'R'        *
      *           (release).                                          *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  CAP014 - Repair function enhancements                        *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSDCUSTL5  IF   E           K DISK    INFSR(*PSSR)                                       202805
      *                                                                                       CER001
     FSDCUX2L0  IF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(SDCUSTF6:RTVIDXA)                           CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
      ** Midas ER Institutions - Economic Sectors                                             CER001
     FSDINX1L0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
     F                                     USROPN                                             CER001
                                                                                              CER001
      ** Midas ER Country Codes - LU Ext. index                                               CER001
     FSDCTX2L0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
     F                                     USROPN                                             CER001
                                                                                              CER001
     FSDCUX1L0  IF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(SDCUSTDL:RTVIDXB)                           CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
     FSDACSTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD031
     F                                     RENAME(SDCUSTD0: SDACSTD1)                         CSD031
      ** SWIFTRef BANK DIRECTORY Plus                                                         CFT050
     FMEBIB3L0  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
      ** Country codes                                                                        CFT050
     FSDCTRYL3  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
      ** SWIFT Customer extension                                                             CFT050
     FSDCSSWL2  IF   E           K DISK    INFSR(*PSSR)                                       CFT050
 
     F/COPY WNCPYSRC,SDCUSDSF01
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Current Customer in File Format
     D CrCuFilFmt    E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(C_)
 
      * Current Customer - SWIFT Details  in File Format                                      CSW207
     D CrSwFilFmt    E DS                  EXTNAME(SDCSSWPD)                                  CSW207
     D                                     PREFIX(C_)                                         CSW207
                                                                                              CSW207
     D TranInACU3    E DS                  EXTNAME (SDACU3DPD)                                CER059
     D TranInACU4    E DS                  EXTNAME (SDACU4DPD)                                CER059
     D TranInCUAH    E DS                  EXTNAME (SDCUAHDPD)                                CER059
     D                                     PREFIX(AH)                                         CER059
     D TranInCCTX    E DS                  EXTNAME (SDCCTXDPD)                                CER059
     D                                     PREFIX(TX)                                         CER059
                                                                                              CER059
      * Current Customer in File Format - Base Rate Tax Details
     D CrBrFilFmt    E DS                  EXTNAME(SDVCUBRPD)
     D                                     PREFIX(C_)
 
      * Current Customer in File Format - Private Banking Details
     D CrPBFilFmt    E DS                  EXTNAME(SDVCUPBPD)
     D                                     PREFIX(C_)
      *                                                                                      BUG3362
     D CrTIFilFmt    E DS                  EXTNAME(SDVTICDPD)                                BUG3362
     D                                     PREFIX(C_)                                        BUG3362
                                                                                             BUG3362
      ** Current Customer in File Format (VF)                                                 CER001
     D CrDlFilFmt1   E DS                  EXTNAME(SDCUX2L0)                                  CER001
      ** Current Customer in File Format (VL)                                                 CER001
     D CrDlFilFmt2   E DS                  EXTNAME(SDCUX1L0)                                  CER001
      ** Current Global Customer X-Reference in File Format                                   CGP001
     D GCrCuFilFmt   E DS                  EXTNAME(GPCUSTXPD)                                 CGP001
     D                                     PREFIX(CG_)                                        CGP001
                                                                                              CGP001
      ** Marketing Information Details in File Format                                         CRE026
     D CrcmFilFmt    E DS                  EXTNAME(SDCMRKPD)                                  CRE026
      ** Additional Customer details in File Format                                           CRE026
     D CracFilFmt    E DS                  EXTNAME(SDACUSPD)                                  CRE026
      ** Service Fees Details in File Format                                                  CRE026
     D CrcfFilFmt    E DS                  EXTNAME(SDCFCDPD)                                  CRE026
     D Q_QQSMAC      E                     EXTFLD(QQSMAC)                                     CRE026
      ** Cheques and Cards Details in File Format                                             CRE026
     D CrchFilFmt    E DS                  EXTNAME(SDCHEQPD)                                  CRE026
      ** Safe details in File Format                                                          CRE026
     D CrsaFilFmt    E DS                  EXTNAME(SDSAFEPD)                                  CRE026
      ** Risk weighted assets in Valid File Format                                            CRE026
     D CrvrFilFmt    E DS                  EXTNAME(SDVRWANPD)                                 CRE026
      ** Future and option Detail in File Format                                              CRE026
     D CrfoFilFmt    E DS                  EXTNAME(SDFOCSPD)                                  CRE026
      ** Future & options European reporting in File Format                                   CRE026
     D CroxFilFmt    E DS                  EXTNAME(SDFOX1PD)                                  CRE026
      ** Fiduciary Details in File Format                                                     CRE026
     D CrplFilFmt    E DS                  EXTNAME(SDPLCSPD)                                  CRE026
     ** Lux(European Reporting) in file format                                                CRE026
     D Crx2FilFmt    E DS                  EXTNAME(SDCUX2PD)                                  CRE026
     D                                     PREFIX(C_)                                         CRE026
     ** Lux(IBLC - Extended Information) in file format                                       CRE026
     D Crx1fFilFmt   E DS                  EXTNAME(SDCUX1PD)                                  CRE026
     D                                     PREFIX(C_)                                         CRE026
      * Current Customer in Screen Format - Primary Details
     D CurCuPrim     E DS                  EXTNAME(SDCUPRPD)
     D                                     PREFIX(@)
 
      * Current Customer in Screen Format - Swift Extension                                   CSW207
     D CurCuSwft     E DS                  EXTNAME(SDCUSWPD)                                  CSW207
     D                                     PREFIX(@)                                          CSW207
                                                                                              CSW207
      * Current Customer in Screen Format - Base Rate Tax Details
     D CurCuBrt      E DS                  EXTNAME(SDCUBRPD)
     D                                     PREFIX(@)
 
      * Current Customer in Screen Format - Private Banking Details
     D CurCuPriv     E DS                  EXTNAME(SDCUPBPD)
     D                                     PREFIX(@)
                                                                                             BUG3362
      * Current TI details Screen Format - TI Details                                        BUG3362
     D CurTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
     D                                     PREFIX(@)                                         BUG3362
 
      * Current Customer in Screen Format - Secondary Details
     D CurCuSeco     E DS                  EXTNAME(SDCUSEPD)
     D                                     PREFIX(@)
      * Current Customer in Screen Format - Message Details
     D CurCuMsg      E DS                  EXTNAME(SDCUMRPD)
     D                                     PREFIX(@)
      *                                                                                       CSW024
      ** Current Customer in Screen Format - MT3xx BEI Details                                CSW024
     D CurCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
     D                                     PREFIX(@)                                          CSW024
 
      * New Customer in File Format
     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
                                                                                              CSW207
      * New SWIFT Detail in File Format                                                       CSW207
     D NwSwFilFmt    E DS                  EXTNAME(SDVSWSDPD)                                 CSW207
 
      * New Customer in File Format - Base Rate Tax Details
     D NwBrFilFmt    E DS                  EXTNAME(SDVCUBRPD)
 
      * New Customer in File Format - Private Banking Details
     D NwPBFilFmt    E DS                  EXTNAME(SDVCUPBPD)
 
      * New TI Details in File Format                                                        BUG3362
     D NwTIFilFmt    E DS                  EXTNAME(SDVTICDPD)                                BUG3362
     D                                     PREFIX(V_)                                        BUG3362
                                                                                             BUG3362
      ** New Customer extension in File Format (#6LXVF)                                       CER001
     D NwDlFilFmt1   E DS                  EXTNAME(SDVCULX2PD)                                CER001
      ** New Customer extension in File Format (#LLXVL)                                       CER001
     D NwDlFilFmt2   E DS                  EXTNAME(SDVCULX1PD)                                CER001
      * New Customer in Screen Format - Primary Details
     D NewCuPrim     E DS                  EXTNAME(SDCUPRPD)
      * New Customer in Screen Format - Swift Extension                                       CSW207
     D NewCuSwft     E DS                  EXTNAME(SDCUSWPD)                                  CSW207
 
      * New Customer in Screen Format - Base Rate Tax Details
     D NewCuBrt      E DS                  EXTNAME(SDCUBRPD)
 
      * New Customer in Screen Format - Private Banking Details
     D NewCuPriv     E DS                  EXTNAME(SDCUPBPD)
 
      * New TI Details in Screen Format - TI Details                                         BUG3362
     D NewTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
     D                                     PREFIX(N_)                                        BUG3362
                                                                                             BUG3362
      * New Customer in Screen Format - Secondary Details
     D NewCuSeco     E DS                  EXTNAME(SDCUSEPD)
 
      * New Customer in Screen Format - Message Details
     D NewCuMsg      E DS                  EXTNAME(SDCUMRPD)
      *                                                                                       CSW024
      ** New Customer in Screen Format - MT3xx BEI Details                                    CSW024
     D NewCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
 
 
 
      * Previous Customer in Screen Format - Primary Details
     D PrvCuPrim     E DS                  EXTNAME(SDCUPRPD)
     D                                     PREFIX(@P)
 
      * Previous Customer in Screen Format - Base Rate Tax Details
     D PrvCuBrt      E DS                  EXTNAME(SDCUBRPD)
     D                                     PREFIX(@P)
 
      * Previous Customer in Screen Format - Private Banking Details
     D PrvCuPriv     E DS                  EXTNAME(SDCUPBPD)
     D                                     PREFIX(@P)
      * Previous TI Details in screen Format - TI Details                                    BUG3362
     D PrvTIDet      E DS                  EXTNAME(SDTICSPD)                                 BUG3362
     D                                     PREFIX(@P)                                        BUG3362
 
      * Previous Customer in Screen Format - Secondary Details
     D PrvCuSeco     E DS                  EXTNAME(SDCUSEPD)
     D                                     PREFIX(@P)
 
      * Previous Customer in Screen Format - Message Details
     D PrvCuMsg      E DS                  EXTNAME(SDCUMRPD)
     D                                     PREFIX(@P)
      *                                                                                       CSW024
      ** Previous Customer in Screen Format - Message Details                                 CSW024
     D PrvCuMT3x     E DS                  EXTNAME(SDCUMTPD)                                  CSW024
     D                                     PREFIX(@P)                                         CSW024
      ** New SD Customers in Screen Format (#nLX)                                             CER001
     D NwDlScnFmt    E DS                  EXTNAME(SDCURXPD)                                  CER001
      ** Current SD Customers in Screen Format (#6LX)                                         CER001
     D CrDlScnFmt    E DS                  EXTNAME(SDCURXPD)                                  CER001
     D                                     PREFIX(SS)                                         CER001
      *                                                                                       CFT050
      ** Previous Customer in Screen Format - Message Details                                 CFT050
      *                                                                                       CFT050
     D***CuSW13        E DS                  EXTNAME(SDSW13PD)                       CFT050 MD022395
     D NewCuSW13     E DS                  EXTNAME(SDSW13PD)                                MD022395
     D  S13DDBRCD    E                     EXTFLD(DDBRCD)                                     CFT050
      *                                                                                     MD022395
      ** Current SWIFT 2013 Screen Format                                                   MD022395
      *                                                                                     MD022395
     D CrCuSW13      E DS                  EXTNAME(SDSW13PD)                                MD022395
     D                                     PREFIX(C13_)                                     MD022395
 
 
 
      * Error indicators
     D OKCuPrim      E DS                  EXTNAME(SDECUPRPD)
     D OKCuSeco      E DS                  EXTNAME(SDECUSEPD)
     D OKCuMsg       E DS                  EXTNAME(SDECUMRPD)
     D OKCuBrt       E DS                  EXTNAME(SDECUBRPD)
     D OKCuPriv      E DS                  EXTNAME(SDECUPBPD)
     D OKCuMT3x      E DS                  EXTNAME(SDECUMTPD)                                 CSW024
     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CSW207
 
     D/COPY WNCPYSRC,SDH00729
 
      * Further Details Parameter Data Structure
     D**FURDETS          DS           565                                                    BUG3362
     D**FURDETS          DS           701                                            BUG3362 BUG4454
     D***FURDETS           DS           708                                          BUG4454 BUG5139
     D***FURDETS          DS           701                                          BUG5139 BUG26917
     D***FURDETS          DS           709                                        BUG26917 BUG26917A
     DFURDETS          DS           701                                                    BUG26917A
     D FDCUST                  1      6
     D FDCSSN                  7     16
     D FDCRTN                157    166
     D FDCRNM                168    187
     D FDLINC                228    229
     D FDTICS                564    564
     D FDCTID                565    700                                                      BUG3362
     D***FDCRPC*               702    702                                            BUG4454 BUG5139
     D***FDBRCD*               703    705                                            BUG4454 BUG5139
     D***FDLICD*               706    708                                            BUG4454 BUG5139
     D***FDTAIN                709    709                                         BUG26917 BUG26917A
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access progrmas, long data structure
 
     D ExtData       E DS                  EXTNAME(SDCUEXPD)
      * SD Custom Extra Data - File (D/B) format
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
     ** Business Entity Identifier                                                            CFT050
     D MEBEIS        E DS                  EXTNAME(MEBEISPD)                                  CFT050
      ** External DS for Customer Details                                                     CFT050
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CFT050
     D                                     PREFIX(PR_)                                        CFT050
 
      ** Changed Party Names Array
     D ChgNamArr       S              1    DIM(5)
 
      **  Data Structure for AOSVALR0 string                                                  CSD012
     DSVAL1            DS           200                                                       CSD012
     DSVAL11                   1      1                                                       CSD012
                                                                                              CSD012
     D CSD012          S              1A                                                      CSD012
     D SVALKK          C                   CONST('AuthReqCustomerMaint')                      CSD012
                                                                                              CSD012
      ** Override SDAULGL2                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
     D CSD028          S              1A                                                      CSD028
     D PCustNum        S              6A                                                      CSD028
                                                                                              CSD012
     D/COPY QWINDSRC,SDCUSDDTA                                                                189774
                                                                                              189774
     D PDATA           DS          1024                                                       CER001
     D**#1FLD1**               1      6  0                                            CER001 CSD027A
                                                                                              CER001
     D  #1CUST                 1      6                                                       CER001
     D  #1PAIN                 7      7                                                       CER001
     D  #1PCNB                 8     13                                                       CER001
     D  #1COLC                15     16                                                       CER001
     D  #1LINC                17     18                                                       CER001
     D  #1BRCD                19     21                                                       CER001
     D  #1BNBI                22     22                                                       CER001
     D  #2CNCZ                23     24                                                       CER001
     D  #1FOTR                45     64                                                       CER001
     D  #1TMST                65     90Z                                                      CER001
     D  #1CRNM                91    110                                                       CER001
     D  #1NCOS               111    114                                                       CER001
                                                                                              CER001
     D/COPY WNCPYSRC,SDH00485
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Customer Work Field
     D WKCUST          S                   LIKE(DDCUSN)
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
                                                                                              CSC011
      **  Switchable Feature variable                                                         CSC011
     D***CER048          S              1A                                        BUG26917 BUG26917A
     D CSC011          S              1                                                       CSC011
     D CSD021          S              1A                                                      CSD021
     D CSD037          S              1A   INZ('N')                                           CSD031
     D CGP001          S              1                                                       CGP001
     D V_DDGCUS        S             10                                                       CGP001
     D CSW207          S              1A                                                      CSW207
                                                                                              CLE025
     D CLE025          S              1                                                       CLE025
     D CFX001          S              1                                                       CFX001
     D DDAPRC          S              1                                                     MD054028
     D PRTCD           S              7                                                       CLE025
     D POPTN           S              7                                                       CLE025
     D PSARD           S              6                                                       CLE025
     D PMODE           S              1                                                       CLE025
     D PAccMde         S              1A                                                      CSD031
     D PUpdYN          S              1A                                                      CSD031
     D ULX043          S              1                                                       CER001
     D ULX008          S              1                                                       CER001
     D ULX012          S              1                                                       CER001
     D ULX048          S              1                                                       CER001
     D ULX609          S              1                                                       CER001
     D ULX004          S              1                                                     BUG13228
     D LOOP            S              1                                                       CER001
     D KCUST           S              6                                                       CER001
     D BRBKCO          S              2S 0                                                    CER001
      ** Error message fields received as parameters                                          CER001
     D MSG1            S                   LIKE(#MsgID)                                       CER001
     D WFIND1          S              1                                                       CER001
     D WFIND2          S              1                                                       CER001
     D WPARKEY         S             12A                                                      CFT050
     D @EINKV          S              1                                                       CFT050
     D @INKV           S              1                                                       CFT050
     D WIMODE          S              1                                                       CFT050
     D WICRIT          S             35                                                       CFT050
     D WOADD           S            175                                                       CFT050
     D WOCHIP          S              6                                                       CFT050
     D WOUTCD          S              2                                                       CFT050
     D WRTCD           S              7                                                       CFT050
     D CSW213          S              1                                                       CSW213
     D***CSW204*         S              1                                            CFT050 MD022463
     D CSW024          S              1                                                     MD022463
     D SVCNCZ          S              2A                                                      CFT050
     D SVCOLC          S              2A                                                      CFT050
     D SVCLSY          S              2A                                                      CFT050
     D PBICD           S              4A                                                      CFT050
     D @KEY1           S             10A                                                      CFT050
     D @KYST           S              7A                                                      CFT050
     D CFT050          S              1                                                     MD022463
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUSDS001
 
     D DDTMESTMP       S             26Z                                                      CER001
     D DDFOTRANID      S             20                                                       CER001
                                                                                              CER001
      **  Rename fields to differentiate SDCUSTPD from CrCuFilFmt.                            202805
     I@CUSTFT                                                                                 202805
     I              BBNET                       W@NET                                         202805
     I              BBNTGP                      W@NTGP                                        202805
     I              BBNTCP                      W@NTCP                                        202805
     I              BBNTND                      W@NTND                                        202805
     I              BBNTMM                      W@NTMM                                        202805
     I              BBTMST                      W@TMST                                        202805
      *                                                                                       202805
     ISDACSTD1                                                                                CSD031
     I              BBNET                       W@NET                                         CSD031
     I              BBNTGP                      W@NTGP                                        CSD031
     I              BBNTCP                      W@NTCP                                        CSD031
     I              BBNTND                      W@NTND                                        CSD031
     I              BBNTMM                      W@NTMM                                        CSD031
     I              BBTMST                      W@TMST                                        CSD031
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
      *
      /COPY WNCPYSRC,SDCUSDS002
      *
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKL         IFEQ      '1'
     C                   ROLBK
     C                   END
      *
     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
     C                   IF        @INKL = ' '                                                CSD028
     C                   MOVEL     PCustNum      DDCUSN                                       CSD028
     C                   MOVEL     'A'           DDACTN                                       CSD028
     C                   MOVEL     'A'           @OPSEL                                       CSD028
     C                   EXSR      VAL@K                                                      CSD028
     C                   ELSE                                                                 CSD028
     C                   EVAL      @SCRN = 'T'                                                CSD028
     C                   ENDIF                                                                CSD028
     C                   ENDIF                                                                CSD028
      *                                                                                       CSD028
      /COPY WNCPYSRC,SDCUSDS003
      *
      ** Build browse subfile record
      *
     C     @SCRN         IFEQ      'B'
     C                   EXSR      BLDBRW
     C                   ENDIF
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDCUSDS004
      *
      ** DO WHILE screen: Key Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_KVAL         3 0
     C     @SCRN         DOWEQ     'K'
     C                   EXSR      Scrn@K
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDCUSDS005
      *
      ** DO WHILE screen: Primary Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      Scrn@P
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDCUSDS006
      *
      ** DO WHILE screen: Base Rate Tax Details
      *
     C                   Z-ADD     *ZERO         WIdx_BVAL         3 0
     C                   Z-ADD     *ZERO         WIdx_TVAL         3 0
     C     @SCRN         DOWEQ     'X'
     C                   EXSR      Scrn@B
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDCUSDS007
      *
      ** DO WHILE screen: Secondary Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      Scrn@S
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDCUSDS008
      *                                                                                       CSW024
      ** DO WHILE screen: MT3xx BEI Details Screen                                            CSW024
      *                                                                                       CSW024
     C                   Z-ADD     *ZERO         WIdx_FVAL         3 0                        CSW024
     C     @SCRN         DOWEQ     'F'                                                        CSW024
     C                   EXSR      SCRN@F                                                     CSW024
     C                   ENDDO                                                                CSW024
     C/COPY WNCPYSRC,SDH00601
      *
      ** DO WHILE screen: Message Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_MVAL         3 0
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDCUSDS009
      ** If Private Banking Module is On                                                      203036
      *
      ** DO WHILE screen: Private Banking Details
     C     BGN4ST        IFEQ      'Y'                                                        203036
      *
     C     @SCRN         DOWEQ     'I'
     C                   EXSR      Scrn@R
     C                   ENDDO
     C                   ENDIF                                                                203036
      *                                                                                       CER001
      ** DO WHILE screen: Extension Details                                                   CER001
      *                                                                                       CER001
     C                   DOW       @SCRN = 'L'                                                CER001
     C                   EXSR      SRSCRN@L                                                   CER001
     C                   ENDDO                                                                CER001
      *
      /COPY WNCPYSRC,SDCUSDS014                                                               189774
      *                                                                                       189774
      ** Do window processing                                                                 189774
      *                                                                                       189774
      ** If Private Banking Module is on display window on top of Private                     203036
      ** Banking Screen                                                                       203036
      *                                                                                       203036
     C     BGN4ST        IFEQ      'Y'                                                        203036
     C     @SCRN         DOWEQ     'W'                                                        189774
     C                   EXSR      Scrn@W                                                     189774
     C                   ENDDO                                                                189774
      *                                                                                       203036
      ** If Private Banking Module is not on display widow on to                              203036
      ** Message details Screen.                                                              203036
     C                   ELSE                                                                 203036
     C     @SCRN         DOWEQ     'W'                                                        203036
     C                   EXSR      Scrn@W2                                                    203036
     C                   ENDDO                                                                203036
     C                   ENDIF                                                                203036
      ** Display Bank Directory Plus screen                                                   CFT050
     C**********         IF        CSW213 = 'Y'                                      CFT050 MD022463
     C                   IF        CFT050 = 'Y'                                             MD022463
     C     @SCRN         DOWEQ     'E'                                                        CFT050
     C                   EXSR      SRScrnPL                                                   CFT050
     C                   ENDDO                                                                CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       189774
      /COPY WNCPYSRC,SDCUSDS010
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDCUSDS011
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   ROLBK                                                                192916
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUSDS012
 
      /EJECT
      *****************************************************************
      * SCRN@K - PROCESS SCREEN: KEY DETAILS
      *****************************************************************
     C     SCRN@K        BEGSR
      *                                                                                       248913
     C                   EXSR      SFKEYS                                                     248913
      *
      * Reset customer number if there are no errors
     C     Idx           IFEQ      0
     C                   MOVE      *BLANKS       DDCUSN
     C                   ENDIF
      *
      * Set F7/F8 called from Insert mode flag
     C                   MOVE      'Y'           INSERTENQ
      *
      ** WRITE/READ DISPLAY SCREEN - Key Details
      *
     C                   CALLB     'SDCUSD1DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Customer (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewCuPrim
      *
      * Fields in error
     C                   PARM                    OKCuPrim
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY FIELDS
      * ENABLED DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
     C**********         PARM      'Y'           @EINKG            1                          248913
     C                   PARM                    @EINKG            1                          248913
      * KH = COMMAND KEY 08 = READ NEXT
     C**********         PARM      'Y'           @EINKH            1                          248913
     C                   PARM                    @EINKH            1                          248913
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKL             1
      *
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
                                                                                              CSD021
     C                   PARM                    WWCNUM            6                          CSD021
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
     C                   ENDIF                                                                CSW207
     C/COPY WNCPYSRC,SDH00730
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F7 - Roll Backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll Forwards
     C     @INKH         CASEQ     '1'           ROLL
      *
      * F12 - Cancel on Key Screen
     C     @INKL         CASEQ     '1'           CANC@K
      *
      * Validate input to Key screen
     C                   CAS                     VAL@K
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@K  - VALIDATE INPUT TO KEY SCREEN
      *****************************************************************
     C     VAL@K         BEGSR
      *                                                                                       CSD021
     C                   MOVE      *BLANK        WWCNUM                                       CSD021
      *
      * Retrieve Customer details
      *
     C                   EXSR      RTVCUS
      *
      * If primary fields are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C                   GOTO      EndVAL@K
     C                   END
      *                                                                         CPB002
      * Check if customer is a Portfolio Management customer.                   CPB002
     C                   EXSR      CHKPTFR                                      CPB002
      *
      *
      * If action code is not insert
      *  .. Convert the customer to screen format
      *  .. Update the customer in file format
      *  .. Go to Primary details screen
      *
     C     DDACTN        IFNE      'I'
     C                   EXSR      CVTCUS
     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   MOVEL     CrSwFilFmt    NwSwFilFmt                                   CSW207
     C                   ENDIF                                                                CSW207
     C/COPY WNCPYSRC,SDH00731
     C                   IF        CSW213 = 'Y'                                             MD022395
     C                   EVAL      DDLEIC = C_CSLEIC                                        MD022395
     C                   EVAL      DDCLSY = C_CSCLSY                                        MD022395
     C                   EVAL      DDCLID = C_CSCLID                                        MD022395
     C                   ENDIF                                                              MD022463
     C                   IF        CFT050 = 'Y'                                             MD022463
     C                   EVAL      DDBDRK = C_CSBDRK                                        MD022395
     C                   ENDIF                                                              MD022395
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SFDS@P
     C                   MOVEL     CrTIFilFMt    NwTIFilFmt                                  BUG3362
     C                   MOVEL     CrTIFilFMt    FDCTID                                       244030
     C                   GOTO      EndVAL@K
     C                   END
      *
      * Clear any warning messages
      *
     C                   CLEAR                   NwCuFilFmt
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   CLEAR                   NwSwFilFmt                                   CSW207
     C                   CLEAR                   CurCuSwft                                   CSW207A
     C                   CLEAR                   NewCuSwft                                   CSW207A
     C                   ENDIF                                                                CSW207
     C                   IF        CSW213 = 'Y'                                             MD022395
     C                   CLEAR                   NewCuSW13                                  MD022395
     C                   ENDIF                                                              MD022395
     C                   CLEAR                   NwBrFilFmt
     C                   CLEAR                   CrCuFilFmt
     C                   CLEAR                   CrBrFilFmt
     C                   CLEAR                   CrPbFilFmt
     C                   CLEAR                   CrTIFilFMt                                  BUG3362
     C                   CLEAR                   FURDETS                                      244030
      *                                                                                      BUG3362
     C                   MOVEL     DDCUSN        WKCUST
     C                   CLEAR                   CurCuPrim
     C                   CLEAR                   CurCuBrt
     C                   CLEAR                   CurCuPriv
     C                   CLEAR                   CurCuSeco
     C                   CLEAR                   CurCuMsg
     C                   CLEAR                   CurCuMT3x                                    CSW024
     C                   CLEAR                   NewCuPrim
     C                   CLEAR                   NewCuBrt
     C                   CLEAR                   NewCuPriv
     C                   CLEAR                   NewCuSeco
     C                   MOVEL     *BLANK        DDLEIC                                       CSW213
     C                   CLEAR                   NewCuMsg
     C                   CLEAR                   NewCuMT3x                                    CSW024
     C                   MOVEL     WKCUST        DDCUSN
     C                   MOVEL     'I'           DDACTN
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
     C                   ENDIF                                                                CSW207
     C                   MOVE      *ALL'Y'       OKCuSeco
     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C/COPY WNCPYSRC,SDCUSDSC07
      *
      * Go to Primary Details screen
      *
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SFDS@P
     C                   MOVEL     CrTIFilFMt    NwTIFilFmt                                  BUG3362
     C                   MOVEL     CrTIFilFMt    FDCTID                                       244030
      *
     C     EndVAL@K      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@P - SET FIELD STATUS ON PRIMARY SCREEN
      *****************************************************************
     C     SFDS@P        BEGSR
      *
      * Enable/disable fields on primary screen
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@P - PROCESS PRIMARY SCREEN
      *****************************************************************
     C     SCRN@P        BEGSR
 
      * Set function key status on PRIMARY screen
      *
     C                   EXSR      SFKEYS
      *
      ** Default Private Banking Customer Indicator to an 'N' for insert
      *
     C                   IF        DDACTN = 'I' and BGN4ST = 'Y'
     C                   EVAL      DDPRBA = 'N'
     C                   END
                                                                                              CSD031
      ** Hide further details if the customer came from the acceptance subfile.               CSD031
                                                                                              CSD031
     C                   IF        CSD037 = 'Y' AND                                           CSD031
     C                             PAccMde = 'A'                                              CSD031
     C                   EVAL      @EINKX = 'N'                                               CSD031
     C                   ENDIF                                                                CSD031
      *
      ** WRITE/READ DISPLAY SCREEN - Primary Details
      *
     C                   CALLB     'SDCUSD2DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Customer (IN SCREEN FORMAT - Primary )
     C                   PARM                    NewCuPrim
      * Fields in error
     C                   PARM                    OKCuPrim
     C/COPY WNCPYSRC,SDH00732
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED KEY & DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      * ENABLED Function Keys
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KW = COMMAND KEY 22 = CONFIRM CLOSURE OR RELEASE                                      CSD007
      * KX = COMMAND KEY 23 = FURTHER DETAILS
     C                   PARM                    @EINKG
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKW            1                          CSD007
     C                   PARM                    @EINKX            1
     C                   PARM                    @EINKV                                       CFT050
                                                                                              CLE025
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
     C**********         PARM                    CSD037                              CSD031 BUG11907
     C                   PARM                    TransType                                    CSD028
      *                                                                                     BUG11907
      ** Move parameter CSD037 after TransType                                              BUG11907
      *                                                                                     BUG11907
     C                   PARM                    CSD037                                     BUG11907
      * Customer (IN SCREEN FORMAT - SWIFT Extension)                                         CSW207
     C                   PARM                    NewCuSwft                                    CSW207
      * Fields in error SWIFT Details                                                         CSW207
     C                   PARM                    OKCuSwft                                     CSW207
      ** Linkage record key                                                                   CFT050
     C                   PARM                    DDBDRK                                       CFT050
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL
     C/COPY WNCPYSRC,SDH00104
     C                   PARM      '0'           @INKW             1                          CSD007
     C                   PARM      '0'           @INKX             1
     C                   PARM      '0'           @INKV                                        CFT050
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      ** Acceptance Mode                                                                      CSD031
     C                   PARM                    PAccMde                                      CSD031
      *
      * RESET ERRORS ....
      *
     C     DDCUSNOK      IFNE      'N'
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
     C                   ENDIF                                                                CSW207
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   ENDIF
 
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F7 - Roll Backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll Forwards
     C     @INKH         CASEQ     '1'           ROLL
      *
      * F12 - Cancel on Primary Screen
     C     @INKL         CASEQ     '1'           CANC@P
      *
      * Validate Input to Primary Screen
     C                   CAS                     VAL@P
      *
     C                   ENDCS
     C/COPY WNCPYSRC,SDH00105
      *
      * On F23, go to Further Details, if no errors on this screen
      *
     C     @INKX         IFEQ      '1'
     C     Idx           ANDEQ     0
     C     @INKX         OREQ      '1'                                                        237595
     C     Idx           ANDNE     0                                                          237595
     C     DDACTN        ANDEQ     'D'                                                        237595
     C                   EXSR      FURDET
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@P  - VALIDATE INPUT TO PRIMARY SCREEN
      *****************************************************************
     C     VAL@P         BEGSR
      ** If F21 was pressed go to Bank Directory Plus screen                                  CFT050
     C                   IF        @INKV = '1'                                                CFT050
     C                   EVAL      @SCRN = 'E'                                                CFT050
     C                   GOTO      EndVAL@P                                                   CFT050
     C                   ENDIF                                                                CFT050
      *
      * If customer number is NOT OK
      * Re-output screen with error message on it
      *
     C     DDCUSNOK      IFEQ      'N'
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C/COPY WNCPYSRC,SDH00733
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C/COPY WNCPYSRC,SDH00734
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
     C                   ENDIF                                                                CSW207
      *
      *
      * Determine whether BRT customer and initialise controls
      *
     C     S01383        IFEQ      'Y'
     C     DDTAIN        IFEQ      'I'
     C     DDTAIN        OREQ      'J'
     C     DDTAIN        OREQ      'R'                                                        CRE007
     C                   MOVE      '1'           BRTSCREEN
     C                   MOVEA     *BLANKS       ChgNamArr
     C                   ENDIF
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * IF F10 TAKEN, GO ON TO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   EXSR      RTVCUS                                                     237595
     C     DDCUSNOK      IFNE      'N'                                                        237595
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                237595
     C/COPY WNCPYSRC,SDCUSDSC17
     C                   END
     C                   GOTO      EndVAL@P
     C                   END
      *
      *----------------------------------------------------------------                       CSD007
      * IF CLOSURE OR RELEASE                                                                 CSD007
      *                                                                                       CSD007
     C     DDACTN        IFEQ      'C'                                                        CSD007
     C     DDACTN        OREQ      'R'                                                        CSD007
      *                                                                                       CSD007
      * IF F22 TAKEN, GO ON TO UPDATES                                                        CSD007
      *                                                                                       CSD007
     C     @INKW         IFEQ      '1'                                                        CSD007
     C                   MOVEL     'U'           @SCRN                                        CSD007
     C/COPY WNCPYSRC,SDCUSDSC18
     C                   ELSE                                                                 CSD007
      * WARNING MESSAGE                                                                       CSD007
     C                   ENDIF                                                                CSD007
     C                   GOTO      EndVAL@P                                                   CSD007
     C                   ENDIF                                                                CSD007
      *                                                                                       CSD007
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
                                                                                              CSD031
      ** Skip further screens if the customer came from the acceptance subfile.               CSD031
                                                                                              CSD031
     C                   IF        CSD037 = 'Y' AND                                           CSD031
     C                             PAccMde = 'A'                                              CSD031
     C**********         MOVEL     'B'           @SCRN                               CSD031 BUG11917
     C                   MOVEL     'R'           @SCRN                                      BUG11917
     C                   GOTO      EndVAL@P                                                   CSD031
     C                   ENDIF                                                                CSD031
      *
      * If Further Details (F23) has not been selected:
     C     @INKX         IFEQ      '0'
      *
      * If Base Rate Tax is ON
     C     S01383        IFEQ      'Y'
      *
      **If*account*holder*type*I*or*J,*display*participant*details**                          CRE007
      * If account holder type I, J, or R display participant details                         CRE007
     C     DDTAIN        IFEQ      'I'
     C     DDTAIN        OREQ      'J'
     C     DDTAIN        OREQ      'R'                                                        CRE007
     C                   MOVE      'X'           @SCRN
     C                   ELSE
     C                   MOVE      'S'           @SCRN
     C                   ENDIF
      *
      * If Base Rate Tax is OFF, go to message details screen
     C                   ELSE
     C                   MOVE      'S'           @SCRN
     C                   ENDIF
      *
      * If Further Details (F23) has been selected:
     C                   ELSE
      *
      * Return to Primary Detail Screen after Further Details
     C                   MOVE      'P'           @SCRN
      *
     C                   ENDIF
      *
     C                   GOTO      EndVAL@P
      *
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
 
      * Validate Primary Customer Details
 
 
      * Update 'previous' screens and previous number of warnings
 
     C/COPY WNCPYSRC,SDH00735
     C                   MOVEL     NewCuPrim     PrvCuPrim
     C                   Z-ADD     WIdx_PVAL     PrvN_Warn         3 0
 
 
     C                   CALLB     'SDCUSD2VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Customer Primary Details
     C                   PARM                    NewCuPrim
      * Customer Extra Data file data
     C                   PARM                    ExtData
                                                                                              CLE025
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
      ** Customer Primary Details                                                             CSW207
     C                   PARM                    NewCuSwft                                    CSW207
      *
      * OUTPUTS :
      *
      ** Customer Primary Details OK inds
     C                   PARM                    OKCuPrim
     C/COPY WNCPYSRC,SDH00736
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C/COPY WNCPYSRC,SDH00737
     C                   PARM                    WIdx_SVAL
     C/COPY WNCPYSRC,SDH00738
      * Valid Customer layout (DS) from/to caller
      ** Valid Global Customer ID                                                             CGP001
     C                   PARM                    NwCuFilFmt
     C                   PARM                    V_DDGCUS                                     CGP001
      ** Customer Primary Details OK inds                                                     CSW207
     C                   PARM                    OKCuSwft                                     CSW207
      * Valid Customer SWIFT Details (DS) from/to caller                                      CSW207
     C                   PARM                    NwSwFilFmt                                   CSW207
     C/COPY WNCPYSRC,SDH00739
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@P
     C                   END
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      * re-display the screen
      *
     C     NewCuPrim     IFNE      PrvCuPrim
     C     WIdx_PVAL     ORNE      PrvN_Warn
     C                   GOTO      EndVAL@P
     C                   END
     C/COPY WNCPYSRC,SDH00740
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   MOVE      *ALL'Y'       OKCuSwft                                     CSW207
     C                   ENDIF                                                                CSW207
     C/COPY WNCPYSRC,SDH00741
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
     C                   ENDIF
     C
      *
      * If Further Details (F23) has not been selected:
     C     @INKX         IFEQ      '0'
      *
      * If Base Rate Tax is OFF
     C     S01383        IFEQ      'N'
     C                   MOVE      'S'           @SCRN
     C                   GOTO      EndVAL@P
     C                   ENDIF
      *
      **Display*participant*details*if*account*holder*type*I*or*J***                          CRE007
      * Display participant details if account holder type I, J, or R                         CRE007
     C     DDTAIN        IFEQ      'I'
     C     DDTAIN        OREQ      'J'
     C     DDTAIN        OREQ      'R'                                                        CRE007
     C                   MOVE      'X'           @SCRN
     C                   ELSE
     C                   EXSR      VAL@T
     C                   MOVE      'S'           @SCRN
     C                   ENDIF
      *
      * If Further Details (F23) has been selected:
     C                   ELSE
      *
      * Return to Primary Detail Screen after Further Details
     C                   MOVE      'P'           @SCRN
     C                   EXSR      SFDS@P
      *
     C                   ENDIF
      *
     C     EndVAL@P      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@B - PROCESS BASE RATE TAX DETAILS SCREEN
      *****************************************************************
     C     SCRN@B        BEGSR
 
      * IF ACTION CODE IS DELETE
      * BYPASS SCREEN PROCESSING AND PROCESS BRT DATA
      *
     C     DDACTN        IFEQ      'D'
     C                   EXSR      VAL@T
     C                   MOVE      'U'           @SCRN
     C                   GOTO      EndBDSP
     C                   ENDIF
 
      * If Account Holder Type is 'R' then default BRT Tax Ind to 'N'.                        CRE007
      * If Insert mode as well then default Post 5/4/01 to 'Y'.                               CRE007
      *                                                                                       CRE007
     C     DDTAIN        IFEQ      'R'                                                        CRE007
     C                   EVAL      DDTXIN = 'N'                                               CRE007
     C     DDACTN        IFEQ      'I'                                                        CRE007
     C                   EVAL      DDPSTR = 'Y'                                               CRE007
     C                   ENDIF                                                                CRE007
     C                   ENDIF                                                                CRE007
 
     C                   CALLB     'SDCUSD6DP'
      * INPUT PARAMETERS :
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Primary Details
      * Base Rate Tax Details
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuBrt
      *
      * Fields in error
     C                   PARM                    OKCuBrt
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED FUNCTION KEYS
      * Display first or second page of Base Rate Tax details
     C                   PARM                    BRTSCREEN         1
      *
      * Changed Party Names Array
     C                   PARM                    ChgNamArr         1
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKS             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly
      *
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F12 - Cancel on Base Rate Tax Screen
     C     @INKL         CASEQ     '1'           CANC@B
      *
      * Validate name changes and process participant history DS
     C     CHGNAME       CASEQ     '1'           VAL@T
      *
      * Validate Input to Base Rate Tax Screen
     C                   CAS                     VAL@B
      *
     C                   ENDCS
      *
     C     EndBDSP       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@B  - VALIDATE INPUT TO BASE RATE TAX DETAILS
      *****************************************************************
     C     VAL@B         BEGSR
      *
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * From BRT screen 1, go to screen 2 if there are details to view
      * otherwise return to browse screen
      *
     C     BRTSCREEN     IFEQ      '1'
     C     DD3NAM        ANDNE     *BLANKS
     C                   MOVE      '2'           BRTSCREEN
     C                   ELSE
     C                   MOVE      'S'           @SCRN
     C                   GOTO      EndVAL@B
     C                   ENDIF
      *
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ** For account holder type I
      ** or  account holder type R                                                            CRE007
     C     DDTAIN        IFEQ      'I'
     C     DDTAIN        OREQ      'R'                                                        CRE007
      *
      ** If user has just left screen 1
     C     BRTSCREEN     IFEQ      '1'
      *
      ** If names have been entered for both parties 1 and 2 or
      ** party 3 has a name
     C     DD1NAM        IFNE      *BLANKS
     C     DD2NAM        ANDNE     *BLANKS
     C     DD3NAM        ORNE      *BLANKS
      *
      ** display the second screen before validating
     C                   MOVE      '2'           BRTSCREEN
     C                   GOTO      EndVAL@B
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '1'           BRTSCREEN
     C                   ENDIF
      *
      ** For account holder type J
     C                   ELSE
      *
      ** As long as there are parties on screen 2, toggle between first
      ** and second BRT screens if errors and redisplaying screens
      *
     C     DD3NAM        IFNE      *BLANKS
     C     BRTSCREEN     IFEQ      '1'
     C                   MOVE      '2'           BRTSCREEN
     C                   ELSE
     C                   MOVE      '1'           BRTSCREEN
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OKCuBrt
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      *
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewCuBrt      PrvCuBrt
     C                   Z-ADD     WIdx_BVAL     PrvN_Warn
      *
      * Validate Base Rate Tax Details
      *
     C                   CALLB     'SDCUSD6VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Customer Number
     C                   PARM                    DDCUSN            6
      *
      * Account Holder Type
     C                   PARM                    DDTAIN            1
      *
      ** Customer Base Rate Tax Details
     C                   PARM                    NewCuBrt
      *
      ** Screen validation
     C                   PARM      '1'           SinVal            1
      *
      * OUTPUTS :
      ** Customer Base Rate Tax Details
     C                   PARM                    OKCuBrt
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      0             WIdx_BVAL
      *
      * Valid Base Rate Tax layout (DS) from/to caller
     C                   PARM                    NwBrFilFmt
      *
      * Changed Party Names Array
     C                   PARM                    ChgNamArr
      *
      * If any errors redisplay screen
     C     Idx           IFNE      0
     C                   GOTO      ENDVAL@B
     C                   ENDIF
      *
      * If there are any warnings, redisplay screen
     C     WIdx_BVAL     IFNE      PrvN_Warn
      *
      * Don't prompt user for name if redisplaying for warning message
     C                   MOVEA     *BLANKS       ChgNamArr
     C                   GOTO      EndVAL@B
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   END
      *
      * Determine whether there are changed/new names among participants
     C                   EXSR      PARNAMES
      *
      * If any changed names, redisplay screen for user to confirm
      * whether this is a name change or a new participant
      *
     C     DDACTN        IFEQ      'A'
     C     CHGNAME       ANDEQ     '1'
     C                   GOTO      ENDVAL@B
     C                   ENDIF
      *
      *
     C                   EXSR      VAL@T
 
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKCuBrt
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Move on to Secondary Screen
     C                   MOVE      'S'           @SCRN
      *
      * End of Insert/Amend condition controlling validation call
     C                   ENDIF
      *
      *
     C     EndVAL@B      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@T - Validate Name Prompt and Process Participant History DS
      *****************************************************************
     C     VAL@T         BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_TVAL
     C                   MOVE      *ALL'Y'       OKCuBRT
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      ** Call to validate name prompt and process Participant History
      *
     C                   CALLB     'SDCUSD7VL'
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
      * Customer Number
      * Account Holder Type
     C                   PARM                    DDACTN
     C                   PARM                    DDCUSN
     C                   PARM                    DDTAIN
 
      ** Customer Base Rate Tax
     C                   PARM                    NewCuBrt
 
      ** OUTPUTS
 
      ** Customer Base Rate Tax OK indicators
     C                   PARM                    OKCuBrt
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx_TVAL
 
      * Changed Party Name Array
     C                   PARM                    ChgNamArr
      *
      * Valid BRT file layout (DS) to/from caller
     C                   PARM                    NwBrFilFmt
      *
      * If there are errors, redisplay Base Rate Tax screen
 
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@T
     C                   ENDIF
 
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      * re-display the screen
 
     C     BRTSCREEN     IFEQ      '2'
     C                   MOVEA     *BLANKS       ChgNamArr
     C                   MOVE      '0'           CHGNAME
     C                   MOVE      'S'           @SCRN
     C                   GOTO      EndVAL@T
     C                   ENDIF
      *
     C     ChgNamArr(3)  IFEQ      'P'
     C     ChgNamArr(4)  OREQ      'P'
     C     ChgNamArr(5)  OREQ      'P'
     C                   MOVE      '2'           BRTSCREEN
     C                   ELSE
     C                   MOVEA     *BLANKS       ChgNamArr
     C                   MOVE      '0'           CHGNAME
     C                   MOVE      'S'           @SCRN
     C                   ENDIF
 
 
     C     EndVAL@T      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SECOND SCREEN
      *****************************************************************
     C     SCRN@S        BEGSR
 
      * Set function key status on SECONDARY screen
      *
     C                   EXSR      SFKEYS
      *
      ** WRITE/READ DISPLAY SCREEN - Secondary Details
      *
     C                   CALLB     'SDCUSD3DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Customer (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuSeco
     C                   PARM                    NewCuSwft                                    CSW207
     C**********         PARM                    CuSW13                              CFT050 MD022395
     C                   PARM                    NewCuSW13                                  MD022395
      * Customer OK indicators
     C                   PARM                    OKCuSeco
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED Function Keys
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KX = COMMAND KEY 23 = FURTHERDETAILS
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKX
     C                   PARM                    @EINKV                                       CFT050
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKX
     C                   PARM      '0'           @INKV                                        CFT050
      *
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
     C/COPY WNCPYSRC,SDCUSDSC08
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKCuSeco
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C/COPY WNCPYSRC,SDCUSDSC09
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F12 - Cancel on Secondary Screen
     C     @INKL         CASEQ     '1'           CANC@S
      *
      * Validate Input to Secondary Screen
     C                   CAS                     VAL@S
      *
     C                   ENDCS
      *
      * On F23, go to Further Details, if there are no errors on this screen
      *
     C     @INKX         IFEQ      '1'
     C     Idx           ANDEQ     0
     C     @INKX         OREQ      '1'                                                        237595
     C     Idx           ANDNE     0                                                          237595
     C     DDACTN        ANDEQ     'D'                                                        237595
     C                   EXSR      FURDET
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@S  - VALIDATE INPUT TO SECONDARY SCREEN
      *****************************************************************
     C     VAL@S         BEGSR
      ** If F21 was pressed go to Bank Directory Plus menu                                    CFT050
     C                   IF        @INKV = '1'                                                CFT050
     C                   EVAL      @SCRN = 'E'                                                CFT050
     C                   GOTO      EndVAL@S                                                   CFT050
     C                   ENDIF                                                                CFT050
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_SVAL
     C                   MOVE      *ALL'Y'       OKCuSeco
     C/COPY WNCPYSRC,SDCUSDSC10
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * IF F10 TAKEN, GO ON TO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   EXSR      RTVCUS                                                     237595
     C     DDCUSNOK      IFNE      'N'                                                        237595
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                237595
     C                   END
     C                   GOTO      EndVAL@S
     C                   END
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * If F23 has not been selected go on to Message Details screen
      *
     C     @INKX         IFEQ      '0'
      *                                                                                       CSW024
      ** If MT3xx BEI enhancement has been installed and                                      CSW024
      ** SWIFT/Direct Link module is on then display                                          CSW024
      ** screen for MT3xx BEI details                                                         CSW024
     C                   IF        CSW024 = 'Y' AND                                           CSW024
     C                             BGMSDL = 'Y'                                               CSW024
     C                   MOVEL     'F'           @SCRN                                        CSW024
     C                   ELSE                                                                 CSW024
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF                                                                CSW024
                                                                                              CSW024
     C                   END
      *
     C                   GOTO      EndVAL@S
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewCuSeco     PrvCuSeco
     C                   Z-ADD     WIdx_SVAL     PrvN_Warn
      *
      * Validate Secondary Screen details
      *
     C                   CALLB     'SDCUSD3VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      ** Response mode
     C                   PARM                    RespMode
      ** Customer Primary Details
     C                   PARM                    NewCuPrim
      ** Customer Secondary Details
     C                   PARM                    NewCuSeco
      ** Customer Extra Data file data
     C                   PARM                    ExtData
      ** SWIFT Detail                                                                         CSW207
     C                   PARM                    NewCuSwft                                    CSW207
     C**********         PARM                    CuSW13                              CFT050 MD022395
     C                   PARM                    NewCuSW13                                  MD022395
      * OUTPUTS :
      ** Customer Seconda Details OK inds
     C                   PARM                    OKCuSeco
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx_SVAL
      * Valid Customer layout (DS) from/to caller
     C                   PARM                    NwCuFilFmt
      * Valid SWIFT Layout (DS) from/to caller                                                CSW207
     C                   PARM                    NwSwFilFmt                                   CSW207
      * Customer SWIFT Details OK Indicator                                                   CSW207
     C                   PARM                    OkCuSwft                                     CSW207
     C/COPY WNCPYSRC,SDCUSDSC11
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@S
     C                   END
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      * re-output the screen
      *
     C     NewCuSeco     IFNE      PrvCuSeco
     C     WIdx_SVAL     ORNE      PrvN_Warn
     C                   GOTO      EndVAL@S
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKCuSeco
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C/COPY WNCPYSRC,SDCUSDSC12
      *
      * If displaying Further Details, return to secondary details screen
      * Otherwise move on to message detail screen
      *
     C     @INKX         IFNE      '1'
      *                                                                                       CSW024
      ** If MT3xx BEI enhancement has been installed, and                                     CSW024
      ** SWIFT/Direct Link module is on then display                                          CSW024
      ** screen for MT3xx BEI details                                                         CSW024
     C                   IF        CSW024 = 'Y' AND                                           CSW024
     C                             BGMSDL = 'Y'                                               CSW024
     C                   MOVEL     'F'           @SCRN                                        CSW024
     C                   ELSE                                                                 CSW024
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF                                                                CSW024
                                                                                              CSW024
     C                   END
      *
     C                   END
      *
     C     EndVAL@S      ENDSR
                                                                                              CSW024
      *****************************************************************                       CSW024
      /EJECT                                                                                  CSW024
      *****************************************************************                       CSW024
      *                                                               *                       CSW024
      * SCRN@F - Process MT3xx BEI and Fund Details screen            *                       CSW024
      *                                                               *                       CSW024
      *****************************************************************                       CSW024
                                                                                              CSW024
     C     SCRN@F        BEGSR                                                                CSW024
      *                                                                                       CSW024
      ** Set function key status for MT3xx BEI screen                                         CSW024
      *                                                                                       CSW024
     C                   EXSR      SFKEYS                                                     CSW024
      *                                                                                       CSW024
      ** Write/read display - MT3xx BEI and Fund details screen                               CSW024
      *                                                                                       CSW024
     C                   CALLB     'SDCUSD8DP'                                                CSW024
      *                  =====================                                                CSW024
      ** INPUT                                                                                CSW024
      *  =====                                                                                CSW024
      *                                                                                       CSW024
      ** Return Code                                                                          CSW024
     C                   PARM      *BLANK        RetCodeOut                                   CSW024
      *                                                                                       CSW024
      ** New Customer in Screen Format - Primary Details                                      CSW024
     C                   PARM                    NewCuPrim                                    CSW024
      *                                                                                       CSW024
      ** New Customer in Screen Format - MT3xx BEI details                                    CSW024
     C                   PARM                    NewCuMT3x                                    CSW024
      *                                                                                       CSW024
      ** Fields in error                                                                      CSW024
     C                   PARM                    OKCuMT3x                                     CSW024
      *                                                                                       CSW024
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW024
     C                   PARM                    FldNameArr                                   CSW024
     C                   PARM                    MsgIdArr                                     CSW024
     C                   PARM                    MsgDtaArr                                    CSW024
      *                                                                                       CSW024
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW024
     C                   PARM                    WFldNamArr                                   CSW024
     C                   PARM                    WMsgIdArr                                    CSW024
     C                   PARM                    WMsgDtaArr                                   CSW024
      *                                                                                       CSW024
      ** Enabled Function Keys                                                                CSW024
      ** KJ = Command Key 10 = DELETE                                                         CSW024
      ** KX = Command Key 23 = FURTHER DETAILS                                                CSW024
     C                   PARM                    @EINKJ                                       CSW024
     C                   PARM                    @EINKX                                       CSW024
     C                   PARM                    @EINKV                                       CFT050
      *                                                                                       CSW024
      ** Write screen with no read indicator                                                  CSW024
     C                   PARM                    WriteOnly                                    CSW024
      ** Linkage record key                                                                   CFT050
     C                   PARM                    DDBDRK                                       CFT050
      *                                                                                       CSW024
      ** OUTPUT                                                                               CSW024
      ** ======                                                                               CSW024
      *                                                                                       CSW024
      ** Function Keys                                                                        CSW024
     C                   PARM      '0'           @INKC                                        CSW024
     C                   PARM      '0'           @INKJ                                        CSW024
     C                   PARM      '0'           @INKL                                        CSW024
     C                   PARM      '0'           @INKX                                        CSW024
     C                   PARM      '0'           @INKV                                        CFT050
      *                                                                                       CSW024
      ** Reset errors                                                                         CSW024
      *                                                                                       CSW024
     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
     C                   MOVEL     *BLANK        FldNameArr                                   CSW024
     C                   MOVEL     *BLANK        MsgIdArr                                     CSW024
     C                   MOVEL     *BLANK        MsgDtaArr                                    CSW024
     C                   MOVEL     *BLANK        WFldNamArr                                   CSW024
     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW024
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW024
      *                                                                                       CSW024
      ** F3 - End Program                                                                     CSW024
     C     @INKC         CASEQ     '1'           ENDP                                         CSW024
      *                                                                                       CSW024
      ** F12 - Cancel on Message Details Screen                                               CSW024
     C     @INKL         CASEQ     '1'           CANC@F                                       CSW024
      *                                                                                       CSW024
      ** Validate Input to Message Details Screen                                             CSW024
     C                   CAS                     VAL@F                                        CSW024
      *                                                                                       CSW024
     C                   ENDCS                                                                CSW024
      *                                                                                       CSW024
      ** On F23, go to Further Details, if there are no errors                                CSW024
      *                                                                                       CSW024
     C     DDACTN        IFNE      'I'                                                       BUG3362
     C     @INKX         IFEQ      '1'                                                        CSW024
     C     Idx           ANDEQ     0                                                          CSW024
     C     @INKX         OREQ      '1'                                                        237595
     C     Idx           ANDNE     0                                                          237595
     C     DDACTN        ANDEQ     'D'                                                        237595
     C                   EXSR      FURDET                                                     CSW024
     C                   ENDIF                                                                CSW024
     C                   ENDIF                                                               BUG3362
      *                                                                                       CSW024
     C                   ENDSR                                                                CSW024
                                                                                              CSW024
      *****************************************************************                       CSW024
      /EJECT                                                                                  CSW024
      *****************************************************************                       CSW024
      *                                                               *                       CSW024
      * VAL@F - Validate MT3xx BEI and Fund Details screen            *                       CSW024
      *                                                               *                       CSW024
      *****************************************************************                       CSW024
                                                                                              CSW024
     C     VAL@F         BEGSR                                                                CSW024
      ** If F21 was press go to Bank Directory Plus screen                                    CFT050
     C                   IF        @INKV = '1'                                                CFT050
     C                   EVAL      @SCRN = 'E'                                                CFT050
     C                   GOTO      EndVAL@F                                                   CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CSW024
      ** Prior to validation, initialize error indicators as 'OK'                             CSW024
      *                                                                                       CSW024
     C                   Z-ADD     *ZERO         Idx                                          CSW024
     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
      *                                                                                       CSW024
      ** If Enquire                                                                           CSW024
      *                                                                                       CSW024
     C     DDACTN        IFEQ      'E'                                                        CSW024
      *                                                                                       CSW024
      ** If displaying Further Details, return to message details screen                      CSW024
      ** Otherwise move on to customer subfile display.                                       CSW024
      *                                                                                       CSW024
     C     @INKX         IFNE      '1'                                                        CSW024
     C     @RDNB         IFEQ      'Y'                                                        CSW024
     C     BGN4ST        ANDEQ     'Y'                                                        CSW024
     C                   MOVEL     'I'           @SCRN                                        CSW024
     C                   ELSE                                                                 CSW024
      **If*Window*Processing*on:***************************************               BUG6565 235524
      **********                                                                      BUG6565 235524
     C*****BGWDPR        IFEQ      'Y'                                                BUG6565 235524
     C**********         MOVEL     'W'           @SCRN                                BUG6565 235524
     C**********         ELSE                                                         BUG6565 235524
     C**********         EXSR      INITIAL                                             CSW024 235524
     C**********         ENDIF                                                        BUG6565 235524
      *                                                                                       235524
     C                   MOVEL     'M'           @SCRN                                        235524
     C/COPY WNCPYSRC,SDH00602
     C                   ENDIF                                                                CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
     C                   GOTO      EndVAL@F                                                   CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
      ** If Insert or Amend                                                                   CSW024
      *                                                                                       CSW024
     C     DDACTN        IFEQ      'I'                                                        CSW024
     C     DDACTN        OREQ      'A'                                                        CSW024
      *                                                                                       CSW024
      ** Update 'previous' screens and previous number of warnings                            CSW024
                                                                                              CSW024
     C                   MOVEL     NewCuMT3x     PrvCuMT3x                                    CSW024
     C                   Z-ADD     WIdx_Fval     PrvN_Warn                                    CSW024
     C                   Z-ADD     *ZERO         WIdx_Fval                                    CSW024
      *                                                                                       CSW024
      ** Validate message details screen                                                      CSW024
      *                                                                                       CSW024
     C                   CALLB     'SDCUSD8VL'                                                CSW024
      *                  =====================                                                CSW024
      ** INPUTS                                                                               CSW024
      ** ======                                                                               CSW024
      *                                                                                       CSW024
      ** Return Code                                                                          CSW024
     C                   PARM      *BLANK        RetCodeOut                                   CSW024
      *                                                                                       CSW024
      ** New Customer in Screen Format - MT3xx BEI details                                    CSW024
     C                   PARM                    NewCuMT3x                                    CSW024
      *                                                                                       CSW024
      ** Fields in error                                                                      CSW024
     C                   PARM                    OKCuMT3x                                     CSW024
      *                                                                                       CSW024
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW024
     C                   PARM                    FldNameArr                                   CSW024
     C                   PARM                    MsgIDArr                                     CSW024
     C                   PARM                    MsgDtaArr                                    CSW024
      *                                                                                       CSW024
      ** Array index (3P0) from/to caller                                                     CSW024
     C                   PARM                    Idx                                          CSW024
      *                                                                                       CSW024
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW024
     C                   PARM                    WFldNamArr                                   CSW024
     C                   PARM                    WMsgIDArr                                    CSW024
     C                   PARM                    WMsgDtaArr                                   CSW024
      *                                                                                       CSW024
      ** Array index (3P0) from/to caller                                                     CSW024
     C                   PARM                    WIdx_Fval                                    CSW024
      *                                                                                       CSW024
      ** Valid Customer layout (DS) from/to caller                                            CSW024
     C                   PARM                    NwCuFilFmt                                   CSW024
      *                                                                                       CSW024
      ** If errors returned                                                                   CSW024
      *                                                                                       CSW024
     C     Idx           IFNE      0                                                          CSW024
     C                   GOTO      EndVAL@F                                                   CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
      ** If the screen has changed in the course of the validation                            CSW024
      ** or if there are warnings which have not been displayed                               CSW024
      ** re-output the screen                                                                 CSW024
      *                                                                                       CSW024
     C     NewCuMT3x     IFNE      PrvCuMT3x                                                  CSW024
     C     WIdx_Fval     ORNE      PrvN_Warn                                                  CSW024
     C                   GOTO      EndVAL@F                                                   CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
      ** Clear any warning messages                                                           CSW024
      *                                                                                       CSW024
     C                   MOVE      *ALL'Y'       OKCuMT3x                                     CSW024
     C                   MOVEL     *BLANK        WFldNamArr                                   CSW024
     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW024
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW024
      *                                                                                       CSW024
      ** If displaying Further Details, return to secondary details screen                    CSW024
      ** otherwise, move to message details screen.                                           CSW024
      *                                                                                       CSW024
     C     @INKX         IFNE      '1'                                                        CSW024
     C                   MOVEL     'M'           @SCRN                                        CSW024
     C/COPY WNCPYSRC,SDH00603
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
     C     EndVAL@F      ENDSR                                                                CSW024
                                                                                              CSW024
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS MESSAGE DETAILS SCREEN
      *****************************************************************
     C     SCRN@M        BEGSR
 
      * Set function key status on SECONDARY screen
      *
     C                   EXSR      SFKEYS
      *
      ** WRITE/READ DISPLAY - Message Details Screen
      *
     C                   CALLB     'SDCUSD4DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS:
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Customer (IN SCREEN FORMAT) - Message tails
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuMsg
      *
      * Fields in error
     C                   PARM                    OKCuMsg
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED FUNCTION KEYS
      * KJ = COMMAND KEY 10 = DELETE
      * KX = COMMAND KEY 23 = FURTHER DETAILS
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKX            1
      *
      ** OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKX
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKCuMsg
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F12 - Cancel on Message Details Screen
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * Validate Input to Message Details Screen
     C                   CAS                     VAL@M
      *
     C                   ENDCS
 
      * On F23, go to Further Details, if there are no errors on this screen
      *
     C     @INKX         IFEQ      '1'
     C     Idx           ANDEQ     0
     C     @INKX         OREQ      '1'                                                        237595
     C     Idx           ANDNE     0                                                          237595
     C     DDACTN        ANDEQ     'D'                                                        237595
     C                   EXSR      FURDET
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MESSAGE DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_Mval
     C                   MOVE      *ALL'Y'       OKCuMsg
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * If displaying Further Details, return to message details screen
      * Otherwise move on to customer subfile display
      **  (but if window processing is on but Private Banking is off, display window)         213713
      *
     C     @INKX         IFNE      '1'
     C     @RDNB         IFEQ      'Y'
     C     BGN4ST        ANDEQ     'Y'
     C                   MOVEL     'I'           @SCRN
     C                   ELSE
     C/COPY WNCPYSRC,SDCUSDSC04
      **If*window*processing*on                                                     BUG6565 BUG10295
     C*****BGWDPR        IFEQ      'Y'                                              BUG6565 BUG10295
     C**********         MOVEL     'W'           @SCRN                              BUG6565 BUG10295
     C**********         ELSE                                                       BUG6565 BUG10295
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             OR ULX609 = 'Y'                                          BUG10817
     C                   EVAL      @SCRN = 'L'                                                CER001
     C                   ELSE                                                                 CER001
                                                                                            BUG10295
      ** If window processing on                                                            BUG10295
     C     BGWDPR        IFEQ      'Y'                                                      BUG10295
     C                   MOVEL     'W'           @SCRN                                      BUG10295
     C                   ELSE                                                               BUG10295
     C                   EXSR      INITIAL
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,SDCUSDSC05
     C                   ENDIF                                                               BUG6565
     C                   ENDIF
     C                   ENDIF
      *
     C                   GOTO      EndVAL@M
     C                   END
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewCuMsg      PrvCuMsg
     C                   Z-ADD     WIdx_Mval     PrvN_Warn
      *
      * Validate message details screen
      *
     C                   CALLB     'SDCUSD4VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Customer Primary Details
      ** Customer Secondary Details
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuSeco
      ** Customer Message Details
     C                   PARM                    NewCuMsg
      * Custom Extra Data file data
     C                   PARM                    ExtData
 
      ** Message details OK indicators
     C                   PARM                    OKCuMsg
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx_Mval
 
      * Valid Customer layout (DS) from/to caller
     C                   PARM                    NwCuFilFmt
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@M
     C                   END
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      *   re-output the screen
      *
     C     NewCuMsg      IFNE      PrvCuMsg
     C     WIdx_Mval     ORNE      PrvN_Warn
     C                   GOTO      EndVAL@M
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKCuMsg
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * If displaying Further Details, return to secondary details screen
      * Otherwise move on to Private Banking Screen
      **  (but if window processing is on but Private Banking is off, display window)         213713
      *
     C     @INKX         IFNE      '1'
     C     BGN4ST        IFEQ      'Y'
     C                   MOVEL     'I'           @SCRN
     C                   ELSE
     C/COPY WNCPYSRC,SDCUSDSC02
      *
      * If Action Code is I or A go to Update
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      **If*window*processing*on                                                     BUG6565 BUG10295
     C*****BGWDPR        IFEQ      'Y'                                              BUG6565 BUG10295
     C**********         MOVEL     'W'           @SCRN                              BUG6565 BUG10295
     C**********         ELSE                                                       BUG6565 BUG10295
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             OR ULX609 = 'Y'                                          BUG10817
     C                   EVAL      @SCRN = 'L'                                                CER001
     C                   ELSE                                                                 CER001
                                                                                            BUG10295
      ** If window processing on                                                            BUG10295
     C     BGWDPR        IFEQ      'Y'                                                      BUG10295
     C                   MOVEL     'W'           @SCRN                                      BUG10295
     C                   ELSE                                                               BUG10295
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                               BUG6565
                                                                                            BUG10295
     C                   ELSE
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
     C/COPY WNCPYSRC,SDCUSDSC03
     C                   ENDIF
     C                   END
      *
     C                   ENDIF
      *
     C     EndVAL@M      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@R - PROCESS Private Banking Details Screen
      *****************************************************************
     C     SCRN@R        BEGSR
 
 
     C                   CALLB     'SDCUSD5DP'
      * INPUT PARAMETERS :
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Primary Details
      * Private Banking Details
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuPriv
      *
      * Fields in error
     C                   PARM                    OKCuPriv
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * KX = COMMAND KEY 23 = FURTHER DETAILS
     C                   PARM                    @EINKX            1
      *
      * OUTPUT PARAMETERS :
      *
      * Function Keys
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKX
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly
      *
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F12 - Cancel on Base Rate Tax Screen
     C     @INKL         CASEQ     '1'           CANC@R
      *
      * Validate Input to Private Banking Screen
     C                   CAS                     VAL@R
      *
     C                   ENDCS
      *
      * On F23, go to Further Details, if there are no errors on this screen
      *
     C     @INKX         IFEQ      '1'
     C     Idx           ANDEQ     0
     C     @INKX         OREQ      '1'                                                        237595
     C     Idx           ANDNE     0                                                          237595
     C     DDACTN        ANDEQ     'D'                                                        237595
     C                   EXSR      FURDET
     C                   ENDIF
      *
      *
     C     EndRDSP       ENDSR
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SRSCRN@L - Process Extension Details Screen                   *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRSCRN@L      BEGSR                                                                CER001
      *                                                                                       CER001
     C                   MOVE      DDCUSN        #1CUST                                       CER001
     C                   MOVE      DDPAIN        #1PAIN                                       CER001
     C                   MOVE      DDPCNB        #1PCNB                                       CER001
     C                   MOVE      DDCOLC        #1COLC                                       CER001
     C                   MOVE      DDLINC        #1LINC                                       CER001
     C                   MOVE      DDBRCD        #1BRCD                                       CER001
     C                   MOVE      DDBNBI        #1BNBI                                       CER001
     C                   MOVE      DDCNCZ        #2CNCZ                                       CER001
     C                   MOVE      DDTMESTMP     #1TMST                                       CER001
     C                   MOVE      DDFOTRANID    #1FOTR                                       CER001
     C                   MOVE      DDCRNM        #1CRNM                                       CER001
      *                                                                                       CER001
     C                   MOVE      DDCUSN        KCUST                                        CER001
     C                   IF        ULX609 = 'Y'                                             BUG10817
     C                   EXSR      SRRTVEXT1                                                  CER001
     C                   ENDIF                                                              BUG10817
     C                   IF        ULX043 = 'Y'                                             BUG10817
     C                   EXSR      SRRTVEXT2                                                  CER001
     C                   ENDIF                                                              BUG10817
      *                                                                                       CER001
     C                   DOU       LOOP = 'N'                                                 CER001
     C                   EVAL      LOOP = 'N'                                                 CER001
      *                                                                                       CER001
     C                   IF        ULX609 = 'Y'                                             BUG10817
     C                   CALL      'SDCUSD2SN'                                                CER001
     C                   PARM      *Blanks       RetCodeIn                                    CER001
     C                   PARM      DDACTN        PWAction                                     CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    PWRtn                                        CER001
     C                   PARM                    NwDlScnFmt                                   CER001
     C                   PARM                    NwDlFilFmt1                                  CER001
     C                   PARM                    ULX008                                       CER001
     C                   PARM                    ULX012                                       CER001
     C                   PARM                    ULX048                                       CER001
     C                   PARM                    ULX609                                       CER001
     C                   PARM                    BGLRIN                                       CER001
     C                   PARM                    BJMRDT                                       CER001
     C                   PARM                    ULX004                                     BUG13228
      *                                                                                       CER001
      ** If F3 or F12 was pressed in called program                                           CER001
      ** or window/DB error                                                                   CER001
      *                                                                                       CER001
     C                   IF        (PWRtn = 'Y2U9999') or                                     CER001
     C                             (PWRtn = 'USR0790') or                                     CER001
     C                             (PWRtn = 'USR0563') or                                     CER001
     C                             (PWRtn = 'Y2U0004')                                        CER001
     C                   ITER                                                                 CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                              BUG10817
      *                                                                                       CER001
      ** If Enter is pressed and without error                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                             BUG10817
     C                   CALL      'SDCUSD3SN'                                                CER001
     C                   PARM      *Blanks       RetCodeIn                                    CER001
     C                   PARM      DDACTN        PWAction                                     CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    PWRtn                                        CER001
     C                   PARM                    NwDlScnFmt                                   CER001
     C                   PARM                    NwDlFilFmt2                                  CER001
     C                   PARM                    ULX043                                       CER001
     C                   PARM                    BGNWST                                       CER001
     C                   PARM                    BJMRDT                                       CER001
      *                                                                                       CER001
      ** If F12 was pressed in called program                                                 CER001
      *                                                                                       CER001
     C                   IF        (PWRtn = 'USR0790')                                        CER001
     C                   EVAL      LOOP = 'Y'                                                 CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                              BUG10817
      *                                                                                       CER001
     C                   ENDDO                                                                CER001
      *                                                                                       CER001
      *                                                                                       CER001
      ** If F3 pressed, end program                                                           CER001
      *                                                                                       CER001
     C                   IF        PWRtn = 'Y2U9999'                                          CER001
     C                   EXSR      ENDP                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** Else if F12 pressed, return to Private Banking details screen                        CER001
      *                                                                                       CER001
     C                   IF        PWRtn = 'USR0790'                                          CER001
     C                   IF        BGN4ST = 'Y'                                               CER001
     C                   EVAL      @SCRN = 'I'                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      @SCRN = 'M'                                                CER001
     C                   ENDIF                                                                CER001
     C                   EVAL      WriteOnly = 'N'                                            CER001
     C                   ROLBK                                                                CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** Else if ENTER key was pressed,                                                       CER001
      *                                                                                       CER001
     C                   IF        BGWDPR = 'Y'                                               CER001
     C                   EVAL      @SCRN = 'W'                                                CER001
     C                   IF        DDACTN = 'E'                                               CER001
     C                   IF        CSC011 = 'Y'                                               CER001
     C                             AND LIBR = S1SUPP                                          CER001
     C                   Z-ADD     *ZERO         Idx                                          CER001
     C                   MOVE      *ALL'Y'       OKCuPriv                                     CER001
     C                   EVAL      FldNameArr = *BLANKS                                       CER001
     C                   EVAL      MsgIdArr = *BLANKS                                         CER001
     C                   EVAL      MsgDtaArr = *BLANKS                                        CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      @SCRN = 'U'                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************
      /EJECT                                                                                  189774
      *****************************************************************                       189774
      * SCRN@W - Window Processing                                                            189774
      *****************************************************************                       189774
     C     Scrn@W        BEGSR                                                                189774
     C/COPY WNCPYSRC,SDCUSDSC19
      *                                                                                       213713
     C     BGN4ST        IFEQ      'Y'                                                        213713
      *                                                                                       189774
     C                   CALLB     'SDCUSD5DP'                                                189774
      ** Input parameters                                                                     189774
     C                   PARM      *Blanks       RetCodeIn                                    189774
     C                   PARM                    NewCuPrim                                    189774
     C                   PARM                    NewCuPriv                                    189774
     C                   PARM                    OKCuPriv                                     189774
     C                   PARM                    FldNameArr                                   189774
     C                   PARM                    MsgIdArr                                     189774
     C                   PARM                    MsgDtaArr                                    189774
     C                   PARM                    @EINKX                                       189774
      ** Output parameters                                                                    189774
     C                   PARM                    @INKC                                        189774
     C                   PARM                    @INKL                                        189774
     C                   PARM                    @INKX                                        189774
     C                   PARM      'Y'           WriteOnly                                    189774
      *                                                                                       213713
     C                   ELSE                                                                 213713
      *                                                                                       213713
     C                   CALLB     'SDCUSD4DP'                                                213713
      *                                                                                       213713
      * INPUT PARAMETERS:                                                                     213713
     C                   PARM      *BLANK        RetCodeOut                                   213713
     C                   PARM                    NewCuPrim                                    213713
     C                   PARM                    NewCuMsg                                     213713
     C                   PARM                    OKCuMsg                                      213713
     C                   PARM                    FldNameArr                                   213713
     C                   PARM                    MsgIdArr                                     213713
     C                   PARM                    MsgDtaArr                                    213713
     C                   PARM                    WFldNamArr                                   213713
     C                   PARM                    WMsgIdArr                                    213713
     C                   PARM                    WMsgDtaArr                                   213713
     C                   PARM                    @EINKJ                                       213713
     C                   PARM                    @EINKX                                       213713
      ** OUTPUT PARAMETERS :                                                                  213713
     C                   PARM                    @INKC                                        213713
     C                   PARM                    @INKJ                                        213713
     C                   PARM                    @INKL                                        213713
     C                   PARM                    @INKX                                        213713
     C                   PARM      'Y'           WriteOnly                                    213713
      *                                                                                       213713
     C                   END                                                                  213713
      *                                                                                       189774
     C/COPY WNCPYSRC,SDCUSDSMV1                                                               189774
      *                                                                                       189774
      ** If BOE installed                                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
      ** Move fields from main screen to Data structure                                      LLN022A
      ** to be passed to window                                                              LLN022A
      ** Customer Number:                                                                    LLN022A
      *                                                                                      LLN022A
     C                   Eval      BYCUST = DDCUSN                                           LLN022A
      *                                                                                      LLN022A
      ** Institution and Industry Codes                                                      LLN022A
      *                                                                                      LLN022A
     C                   Eval      BYLINC = CULINC                                           LLN022A
     C                   Eval      BYLICD = CULICD                                           LLN022A
     C                   Eval      BYCOLC = CUCOLC                                           LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   CALL      'WN0010'                                                   189774
     C                   PARM      'SDCUSDSIN'   PWPgm            10                          189774
     C                   PARM                    PWKey             2                          189774
     C                   PARM      DDACTN        PWAction          1                          189774
     C                   PARM                    Data                                         189774
     C                   PARM      *Blanks       PWRtn             7                          189774
     C                   PARM                    PWSpare         256                          189774
      *                                                                                       189774
      ** If F3 pressed, end program                                                           189774
      *                                                                                       189774
     C     PWRtn         IFEQ      'Y2U9999'                                                  189774
     C                   EXSR      ENDP                                                       189774
     C                   ELSE                                                                 189774
      *                                                                                       189774
      ** Else if F12 pressed, return to Private Banking details screen                        189774
      *                                                                                       189774
     C     PWRtn         IFEQ      'USR0790'                                                  189774
     C     BGN4ST        IFEQ      'Y'                                                       BUG6565
     C                   EVAL      @SCRN = 'I'                                                189774
     C                   ELSE                                                                BUG6565
     C                   EVAL      @SCRN = 'M'                                               BUG6565
     C                   ENDIF                                                               BUG6565
     C                   EVAL      WriteOnly = 'N'                                            189774
     C                   ROLBK                                                                192916
     C                   ELSE                                                                 189774
      *                                                                                       189774
      ** Else if ENTER key was pressed,                                                       189774
      **      if action is Enquire, move on to initial subfile display                        189774
      **      if Insert or Delete, do update processing                                       189774
      *                                                                                       189774
     C     DDACTN        IFEQ      'E'                                                        189774
     C                   EXSR      INITIAL                                                    189774
     C                   ELSE                                                                 189774
     C     DDACTN        IFEQ      'I'                                                        189774
     C     DDACTN        OREQ      'A'                                                        189774
     C/COPY WNCPYSRC,SDCUSDSC20
     C                   EVAL      @SCRN = 'U'                                                189774
     C                   ENDIF                                                                189774
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDIF                                                                189774
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDSR                                                                189774
      *****************************************************************                       189774
      /EJECT
      *****************************************************************                       203036
      * SCRN@W2 - Window Processing(non private banking)                                      203036
      *****************************************************************                       203036
     C     Scrn@W2       BEGSR                                                                203036
      *                                                                                       203036
      *                                                                                       203036
     C*****/COPY*QWINDSRC,*SDCUSDSMV1**                                                203036 213713
     C/COPY WNCPYSRC,SDCUSDSMV1                                                               213713
      *                                                                                       203036
      ** If BOE installed                                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
      ** Move fields from main screen to Data structure                                      LLN022A
      ** to be passed to window                                                              LLN022A
      ** Customer Number:                                                                    LLN022A
      *                                                                                      LLN022A
     C                   Eval      BYCUST = DDCUSN                                           LLN022A
      *                                                                                      LLN022A
      ** Institution and Industry Codes                                                      LLN022A
      *                                                                                      LLN022A
     C                   Eval      BYLINC = CULINC                                           LLN022A
     C                   Eval      BYLICD = CULICD                                           LLN022A
     C                   Eval      BYCOLC = CUCOLC                                           LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   CALL      'WN0010'                                                   203036
     C                   PARM      'SDCUSDSIN'   PWPgm            10                          203036
     C                   PARM                    PWKey             2                          203036
     C                   PARM      DDACTN        PWAction          1                          203036
     C                   PARM                    Data                                         203036
     C                   PARM      *Blanks       PWRtn             7                          203036
     C                   PARM                    PWSpare         256                          203036
      *                                                                                       203036
      ** If F3 pressed, end program                                                           203036
      *                                                                                       203036
     C     PWRtn         IFEQ      'Y2U9999'                                                  203036
     C                   EXSR      ENDP                                                       203036
     C                   ELSE                                                                 203036
      *                                                                                       203036
      ** Else if F12 pressed, return to PROCESS MESSAGE DETAILS SCREEN                        203036
      *                                                                                       203036
     C     PWRtn         IFEQ      'USR0790'                                                  203036
     C     BGN4ST        IFEQ      'Y'                                                        203036
     C                   EVAL      @SCRN = 'I'                                                203036
     C                   ELSE                                                                 203036
     C                   EVAL      @SCRN = 'M'                                                203036
     C                   ENDIF                                                                203036
     C                   EVAL      WriteOnly = 'N'                                            203036
     C/COPY WNCPYSRC,SDH00109
     C                   ELSE                                                                 203036
      *                                                                                       203036
      ** Else if ENTER key was pressed,                                                       203036
      **      if action is Enquire, move on to initial subfile display                        203036
      **      if Insert or Delete, do update processing                                       203036
      *                                                                                       203036
     C     DDACTN        IFEQ      'E'                                                        203036
     C                   EXSR      INITIAL                                                    203036
     C                   ELSE                                                                 203036
     C     DDACTN        IFEQ      'I'                                                        203036
     C     DDACTN        OREQ      'A'                                                        203036
     C                   EVAL      @SCRN = 'U'                                                203036
     C                   ENDIF                                                                203036
     C                   ENDIF                                                                203036
      *                                                                                       203036
     C                   ENDIF                                                                203036
     C                   ENDIF                                                                203036
      *                                                                                       203036
     C                   ENDSR                                                                203036
     C/COPY WNCPYSRC,SDH00486
      *****************************************************************                       203036
      /EJECT                                                                                  203036
      *****************************************************************
      * VAL@R  - VALIDATE INPUT TO Private Banking Details
      *****************************************************************
     C     VAL@R         BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OKCuPriv
      *
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * Return to browse screen
      *
      * If displaying Further Details, return to message details screen
      * Otherwise move on to customer subfile display
      *    (but if window processing is on, display window)                                   189774
      *
     C     @INKX         IFNE      '1'
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             OR ULX609 = 'Y'                                          BUG10817
     C                   EVAL      @SCRN = 'L'                                                CER001
     C                   ELSE                                                                 CER001
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                             AND LIBR = S1SUPP                                          CSC011
     C                   Z-ADD     *ZERO         Idx                                          CSC011
     C                   MOVE      *ALL'Y'       OKCuPriv                                     CSC011
     C                   EVAL      FldNameArr = *BLANKS                                       CSC011
     C                   EVAL      MsgIdArr = *BLANKS                                         CSC011
     C                   EVAL      MsgDtaArr = *BLANKS                                        CSC011
     C                   ENDIF                                                                CSC011
     C                   ELSE                                                                 189774
     C     @RDNB         IFEQ      'Y'
     C                   MOVE      'R'           @SCRN
     C                   ENDIF                                                                189774
     C                   ENDIF                                                                189774
     C                   ENDIF                                                                CER001
     C                   ELSE
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                             AND LIBR = S1SUPP                                          CSC011
     C                   EVAL      @SCRN = 'I'                                                CSC011
     C                   ELSE                                                                 CSC011
     C                   EXSR      INITIAL
     C                   ENDIF                                                                CSC011
     C                   ENDIF
     C***********        ENDIF                                                                189774
     C                   GOTO      EndVAL@R
      *
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
 
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OKCuPriv
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      *
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewCuPriv     PrvCuPriv
      *
      * Validate Private Banking Details
      *
     C                   CALLB     'SDCUSD5VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      *
      ** Private Banking Customer Indicator
     C                   PARM                    CUPRBA
      *
      ** Customer Private Banking Details
     C                   PARM                    NewCuPriv
      *                                                                         CPB002
      ** Portfolio Management Customer Indicator                                CPB002
     C                   PARM                    PtfrCust          1            CPB002
      *                                                                         CPB002
      ** Account Officer                                                        CPB002
     C                   PARM                    DDACOC                         CPB002
                                                                                              CGL031
      ** Customer Number                                                                      CGL031
     C                   PARM                    DDCUSN                                       CGL031
      *
      * OUTPUTS :
      ** Customer Base Rate Tax Details
     C                   PARM                    OKCuPriv
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Valid Private Banking layout (DS) from/to caller
     C                   PARM                    NwPBFilFmt
      *
      *
      * If any errors redisplay screen
     C     Idx           IFNE      0
     C                   GOTO      ENDVAL@R
     C                   ENDIF
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      *   re-output the screen
      *
     C     NewCuPriv     IFNE      PrvCuPriv
     C                   GOTO      EndVAL@R
     C                   END
      *
      ** Clear error indicators
     C                   MOVE      *ALL'Y'       OKCuPriv
      *
      * If displaying Further Details, go ahead, otherwise update.
      *
     C     @INKX         IFNE      '1'
      *
      * If Action Code is I or A go to Update
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             OR ULX609 = 'Y'                                          BUG10817
     C                   EVAL      @SCRN = 'L'                                                CER001
     C                   ELSE                                                                 CER001
      *                                                                                       189774
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   ELSE                                                                 189774
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDIF                                                                CER001
     C                   ELSE
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
      *
     C                   ENDIF
      *
      * End of Insert/Amend condition controlling validation call
     C                   ENDIF
      *
      *
     C     EndVAL@R      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH CUSTOMER FILE
      *****************************************************************
     C     ROLL          BEGSR
      *
      * If action is insert, control return to key screen
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'Y'           INSERTENQ         1
     C                   END
      *
      * Default action code to enquiry if action insert or not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      * READ NEXT OR PREVIOUS RECORD ON CUSTOMER FILE
      * ACCORDING TO COMMAND KEY TAKEN (F7/@INKG OR F8/@INKH)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'SDCUSDRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * CUSTO REF. POINTER
     C                   PARM                    DDCUSN
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      ** Acceptance Mode                                                                      CSD031
     C                   PARM                    PAccMde                                      CSD031
      *
      * OUTPUT PARAMETERS
      *
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @data            45                          249076
      *
      * CUSTO REF. READ
     C                   PARM      *BLANK        @CURED            6
      *
      * If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EROLL
     C                   END
      *
      * If customer read
      *
     C     @CURED        IFNE      *BLANK
      *
      * Retrieve customer details
      *
     C                   MOVEL     @CURED        DDCUSN
     C                   EXSR      RTVCUS
      *
      * Return to browse screen if there is an error on customer number
      *
     C     DDCUSNOK      IFEQ      'N'
     C     DDACTNOK      OREQ      'N'
     C                   MOVEL     'B'           @SCRN
     C                   GOTO      EROLL
     C                   ENDIF
      *                                                                         CPB002
      * Check if customer is a Portfolio Management customer.                   CPB002
     C                   EXSR      CHKPTFR                                      CPB002
      *
      * Convert Customer
     C                   EXSR      CVTCUS
     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
     C                   CLEAR                   NwPbFilFmt
     C                   MOVEL     CrPbFilFmt    NwPbFilFmt
     C                   MOVEL     CrTIFilFmt    NwTIFilFmt                                  BUG3362
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   MOVEL     CrSwFilFmt    NwSwFilFmt                                   CSW207
     C                   ENDIF                                                                CSW207
     C/COPY WNCPYSRC,SDH00742
     C                   IF        CSW213 = 'Y'                                             MD022395
     C                   EVAL      DDLEIC = C_CSLEIC                                        MD022395
     C                   EVAL      DDCLSY = C_CSCLSY                                        MD022395
     C                   EVAL      DDCLID = C_CSCLID                                        MD022395
     C                   ENDIF                                                              MD022463
     C                   IF        CFT050 = 'Y'                                             MD022463
     C                   EVAL      DDBDRK = C_CSBDRK                                        MD022395
     C                   ENDIF                                                              MD022395
      *
      * Put the customer on the primary details screen
      *
     C                   MOVEL     'P'           @SCRN
      *
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * Set/reset return to key screen from primary details
     C                   MOVE      'N'           INSERTENQ         1
      *
      * Reset Read next browse subfile record
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * Build Browse subfile
     C                   CALLB     'SDCUSDBRW'
      *
      * INPUT PARAMETERS :
      * Return Code
      * Action Code
      * Customer Ref. Pointer
      * Build subfile
      * Read subfile record
      * Mode                                                                                  CLE025
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDCUSN
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      *BLANK        @RDSFL            1
     C                   PARM                    PMODE                                        CLE025
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    CSD037                                       CSD031
      *
      * OUTPUT PARAMETERS :
      * Error message
      * Option Selected
      * Customer Reference Selected
      * Command Keys
     C                   PARM      *BLANK        @ERRMS
     C                   PARM      *BLANK        @data                                        249076
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @CUSEL            6
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI             1
      ** Acceptance Mode                                                                      CSD031
     C                   PARM                    PAccMde                                      CSD031
      *
      * If F3 taken in browse, End Program
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If Insert (F9) selected from browse, go to key screen
     C     @OPSEL        IFEQ      'I'
     C                   MOVEL     'K'           @SCRN
     C                   MOVE      'I'           DDACTN
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * Read next browse subfile record
      *
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
      *
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * Read Next Subfile Record
      *
     C                   CALLB     'SDCUSDBRW'
      * INPUT PARAMETERS :
      * Return code
      * Action code
      * Customer Ref. pointer
      * Build Sub-file
      * Read Sub-file record
      * Browse Screen
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDCUSN
     C                   PARM      *BLANK        @BDSFL
     C                   PARM      'Y'           @RDSFL
     C                   PARM                    PMODE                                        CLE025
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    CSD037                                       CSD031
      * OUTPUT PARAMETERS :
      * Error Message
      * Option Selected
      * Customer Ref. selected
      * Function keys
     C                   PARM      *BLANK        @ERRMS
     C                   PARM      *BLANK        @data                                        249076
     C                   PARM      *BLANK        @OPSEL
     C                   PARM      *BLANK        @CUSEL
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
      ** Acceptance Mode                                                                      CSD031
     C                   PARM                    PAccMde                                      CSD031
      *
      * If Customer read from subfile
     C     @CUSEL        IFNE      *BLANK
      *
      * Retrieve Customer details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @CUSEL        DDCUSN
     C                   EXSR      RTVCUS
      *
      * Stay on browse screen if there is an error on customer number
      *
     C     DDCUSNOK      IFEQ      'N'
     C     DDACTN        ANDNE     'D'                                                        237595
     C     DDACTNOK      OREQ      'N'
     C                   MOVEL     'B'           @SCRN
     C                   GOTO      EndRDNBRW
     C                   ENDIF
     C                   MOVE      *ALL'Y'       OKCuPrim                                     237595
     C                   MOVEL     *BLANK        FldNameArr                                   237595
     C                   MOVEL     *BLANK        MsgIdArr                                     237595
     C                   MOVEL     *BLANK        MsgDtaArr                                    237595
     C                   MOVEL     *BLANK        WFldNamArr                                   237595
     C                   MOVEL     *BLANK        WMsgIdArr                                    237595
     C                   MOVEL     *BLANK        WMsgDtaArr                                   237595
     C                   Z-ADD     0             Idx                                          237595
      *                                                                         CPB002
      * Check if customer is a Portfolio Management customer.                   CPB002
     C                   EXSR      CHKPTFR                                      CPB002
      *
      * Convert Customer details
     C                   EXSR      CVTCUS
     C                   MOVEL     CrCuFilFmt    NwCuFilFmt
     C                   MOVEL     CrBrFilFmt    NwBrFilFmt
     C                   MOVEL     CrPBFilFmt    NwPBFilFmt
     C                   MOVEL     CrTIFilFmt    NwTIFilFmt                                  BUG3362
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   MOVEL     CrSwFilFmt    NwSwFilFmt                                   CSW207
     C                   ENDIF                                                                CSW207
     C/COPY WNCPYSRC,SDH00743
     C                   IF        CSW213 = 'Y'                                             MD022395
     C                   EVAL      DDLEIC = C_CSLEIC                                        MD022395
     C                   EVAL      DDCLSY = C_CSCLSY                                        MD022395
     C                   EVAL      DDCLID = C_CSCLID                                        MD022395
     C                   ENDIF                                                              MD022854
     C                   IF        CFT050 = 'Y'                                             MD022854
     C                   EVAL      DDBDRK = C_CSBDRK                                        MD022395
     C                   ENDIF                                                              MD022395
     C     DDCUSN        IFNE      FDCUST                                                     244030
     C                   CLEAR                   FURDETS                                      244030
     C                   MOVE      DDCUSN        FDCUST                                       244030
     C                   MOVE      DDCSSN        FDCSSN                                       244030
     C                   MOVE      DDCRTN        FDCRTN                                       244030
     C                   MOVE      DDCRNM        FDCRNM                                       244030
     C                   MOVE      DDLINC        FDLINC                                       244030
     C                   MOVE      C_BBTICS      FDTICS                                       244030
     C                   MOVEL     CrTIFilFMt    FDCTID                                       244030
     C                   ENDIF                                                                244030
      *
      * Put customer on key screen for Insert, primary details otherwise
      *
     C     @OPSEL        IFEQ      'I'
     C                   MOVEL     'K'           @SCRN
     C                   ELSE
     C/COPY WNCPYSRC,SDH00487
     C                   MOVEL     'P'           @SCRN
     C/COPY WNCPYSRC,SDH00488
     C                   END
     C                   EXSR      SFDS@P
      *
      * Else, go to initial screen
      *
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVCUS - RETRIEVE CUSTO
      *****************************************************************
     C     RTVCUS        BEGSR
      *
      * RETRIEVE CUSTOMER
      *
     C                   CALLB     'SDCUSDRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      @@MODE            6
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM                    C_BBFRNT
      * (Midas) Trade Reference
     C                   PARM                    DDCUSN
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ                                       CSD012
      * Base Auth mode                                                                        CSD012
     C                   PARM                    AUTHMD                                       CSD012
      *
      *  Base Rate Tax option feature is switched on
     C                   PARM                    S01383
      *  Private Banking Customer module is switched on
     C                   PARM                    BGN4ST
      ** Global Data Layout feature is switched on                                            CGP001
     C                   PARM                    CGP001                                       CGP001
      ** KYC: Transaction Type                                                                CSD028
                                                                                              CSD028
     C                   PARM                    TransType                                    CSD028
      ** Acceptance Mode                                                                      CSD031
     C                   PARM                    PAccMde                                      CSD031
      ** Update (Y/N)                                                                         CSD031
     C                   PARM                    PUpdYN                                       CSD031
      * OUTPUTS :
      * (Current) Customer in file format
      * Current Customer Base Rate Tax in file format
      ** (Current) Global Customer X-Reference in file format                                 CGP001
     C                   PARM                    CrCuFilFmt
     C                   PARM                    CrBrFilFmt
     C                   PARM                    CrPBFilFmt
     C                   PARM                    CrTIFilFmt                                  BUG3362
     C                   PARM                    GCrCuFilFmt                                  CGP001
     C                   PARM                    CrcmFilFmt                                   CRE026
     C                   PARM                    CracFilFmt                                   CRE026
     C                   PARM                    CrcfFilFmt                                   CRE026
     C                   PARM                    CrchFilFmt                                   CRE026
     C                   PARM                    CrsaFilFmt                                   CRE026
     C                   PARM                    CrvrFilFmt                                   CRE026
     C                   PARM                    CrfoFilFmt                                   CRE026
     C                   PARM                    CroxFilFmt                                   CRE026
     C                   PARM                    CrplFilFmt                                   CRE026
     C                   PARM                    Crx2FilFmt                                   CRE026
     C                   PARM                    Crx1fFilFmt                                  CRE026
     C                   PARM                    CrSwFilFmt                                   CSW207
     C**********         PARM                    CuSW13                              CFT050 MD022395
     C                   PARM                    CrCuSW13                                   MD022395
     C                   PARM                    TranInCUAH                                   CER059
     C                   PARM                    TranInCCTX                                   CER059
     C                   PARM                    CurCuPrim                                    CFT050
     C                   PARM                    CurCuSeco                                    CFT050
     C                   PARM                    CurCuMT3x                                    CFT050
     C/COPY WNCPYSRC,SDH00744
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      * OK - Customer Reference
     C                   PARM      *BLANK        DDCUSNOK
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      **Base*Rate Auth req                                                             CSD012 222373
     C**********         PARM                    AUTHRQ                                CSD012 222373
      *                                                                                     BUG23518
      * Warning fields/message IDs/message data (arrays) from/to caller                     BUG23518
     C                   PARM                    WFldNamArr                                 BUG23518
     C                   PARM                    WMsgIDArr                                  BUG23518
     C                   PARM                    WMsgDtaArr                                 BUG23518
      *                                                                                     BUG23518
      * Array index (3P0) from/to caller                                                    BUG23518
     C                   PARM      *ZEROS        WIdx_PVAL                                  BUG23518
     C/COPY WNCPYSRC,SDCUSDSC13
 
     C     EndRTVCUS     ENDSR
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SRRTVEXT1 - Retrieve customer extension group 1               *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRRTVEXT1     BEGSR                                                                CER001
      *                                                                                       CER001
      ** Retrieve record in extension file                                                    CER001
      *                                                                                       CER001
     C     K@KEY1        CHAIN(N)  RTVIDXA                            85                      CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
      *                                                                                       CER001
      ** If record exist                                                                      CER001
      *                                                                                       CER001
     C                   WHEN      *IN85 = *OFF                                               CER001
      *                                                                                       CER001
     C                   EVAL      WFIND1 = 'Y'                                               CER001
      *                                                                                       CER001
     C*********          IF        VFCGRP = 0                                         CER001 CSD027A
     C                   IF        VFCGRP = *BLANKS                                          CSD027A
     C                   MOVE      *BLANKS       L6LXCGRP                                     CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      VFCGRP        L6LXCGRP                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Use the SR/ZEDIT to format the Provisions Forfaitaires                               CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       ZFIELD           16                          CER001
     C                   MOVE      VFPAPS        ZFIELD                                       CER001
     C                   Z-ADD     2             ZADEC             1 0                        CER001
     C                   CALLB     'ZEDIT'                                                    CER001
     C                   PARM                    ZFIELD                                       CER001
     C                   PARM                    ZADEC                                        CER001
     C                   MOVE      ZFIELD        L6LXPAPS                                     CER001
      *                                                                                       CER001
     C                   MOVE      VFCONS        L6LXCONS                                     CER001
     C                   MOVE      VFECOS        L6LXECOS                                     CER001
     C                   MOVE      VFNCOS        L6LXNCOS                                     CER001
     C                   MOVE      VFINRF        L6LXINRF                                     CER001
     C                   MOVE      VFPERF        L6LXPERF                                     CER001
     C                   MOVE      VFSMRS        L6LXSMRS                                     CER001
      *                                                                                       CER001
     C                   IF        ULX012 = 'Y'                                               CER001
     C                   MOVE      VFAUTG        L6LXAUTG                                     CER001
     C                   MOVE      VFPROG        L6LXPROG                                     CER001
     C                   MOVE      VFASSP        L6LXASSP                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX008 = 'Y'                                               CER001
     C                   MOVE      VFICCD        L6LXICCD                                     CER001
     C                   MOVE      VFMCID        L6LXMCID                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EVAL      #6LXVFFOTR  =  DDFOTRANID                                  CER001
     C                   EVAL      #6LXVFCUST  =  VFCUST                                      CER001
     C                   EVAL      #6LXVFCONS  =  VFCONS                                      CER001
     C                   EVAL      #6LXVFECOS  =  VFECOS                                      CER001
     C                   EVAL      #6LXVFINRF  =  VFINRF                                      CER001
     C                   EVAL      #6LXVFCGRP  =  VFCGRP                                      CER001
     C                   EVAL      #6LXVFCRNM  =  VFCRNM                                      CER001
     C                   EVAL      #6LXVFCOLC  =  VFCOLC                                      CER001
     C                   EVAL      #6LXVFPAPS  =  VFPAPS                                      CER001
     C                   EVAL      #6LXVFPERF  =  VFPERF                                      CER001
     C                   EVAL      #6LXVFNCOS  =  VFNCOS                                      CER001
     C                   EVAL      #6LXVFAUTG  =  VFAUTG                                      CER001
     C                   EVAL      #6LXVFPROG  =  VFPROG                                      CER001
     C                   EVAL      #6LXVFASSP  =  VFASSP                                      CER001
     C                   EVAL      #6LXVFICCD  =  VFICCD                                      CER001
     C                   EVAL      #6LXVFMCID  =  VFMCID                                      CER001
     C                   EVAL      #6LXVFSMRS  =  VFSMRS                                      CER001
     C                   EVAL      #6LXVFTMES  =  DDTMESTMP                                   CER001
      *                                                                                       CER001
     C                   MOVE      NwDlScnFmt    CrDlScnFmt                                   CER001
      *                                                                                       CER001
      ** If record does not exist                                                             CER001
      *                                                                                       CER001
     C                   WHEN      *IN85 = *ON                                                CER001
      *                                                                                       CER001
     C                   EVAL      WFIND1 = *BLANKS                                           CER001
      *                                                                                       CER001
     C                   EVAL      L6LXPAPS = *BLANKS                                         CER001
     C                   EVAL      L6LXCGRP = *BLANKS                                         CER001
     C                   EVAL      L6LXCONS = '0'                                             CER001
                                                                                            BG12345A
     C                   IF        ULX043 = 'Y' AND BGNWST = 'Y'                            BG12345A
      *                                                                                       CER001
     C     #1LINC        CHAIN     SDINX1L0                           99                      CER001
     C                   IF        *IN99 = *ON                                                CER001
     C                   EVAL      L6LXECOS = '4000'                                          CER001
     C                   EVAL      L6LXNCOS = '9000'                                          CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
     C                   WHEN      #1COLC = 'LU'                                              CER001
     C                   MOVE      AOECOL        L6LXECOS                                     CER001
     C                   WHEN      #1COLC = 'BE'                                              CER001
     C                   MOVE      AOECOB        L6LXECOS                                     CER001
     C                   OTHER                                                                CER001
     C                   MOVE      AOECOO        L6LXECOS                                     CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
      ** Retrieve data SDCTX2L0                                                               CER001
      *                                                                                       CER001
     C     #1COLC        CHAIN     SDCTX2L0                           99                      CER001
     C                   IF        *IN99 = *ON                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
     C                   WHEN      #1COLC = 'LU'                                              CER001
     C                   MOVE      AONCOL        L6LXNCOS                                     CER001
     C                   WHEN      #1COLC <> 'LU'  AND                                        CER001
     C                             WFEMUM = 'Y'                                               CER001
     C                   MOVE      AONCOE        L6LXNCOS                                     CER001
     C                   OTHER                                                                CER001
     C                   MOVE      AONCOO        L6LXNCOS                                     CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                              BG12345A
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EVAL      L6LXINRF = '0'                                             CER001
     C                   EVAL      L6LXPERF = *BLANKS                                         CER001
     C                   EVAL      L6LXSMRS = *BLANKS                                         CER001
      *                                                                                       CER001
     C                   IF        ULX012 = 'Y'                                               CER001
     C                   EVAL      L6LXAUTG = *BLANKS                                         CER001
     C                   EVAL      L6LXPROG = *BLANKS                                         CER001
     C                   EVAL      L6LXASSP = *BLANKS                                         CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX008 = 'Y'                                               CER001
     C                   EVAL      L6LXICCD = *BLANKS                                         CER001
     C                   IF        ULX048 = 'Y'                                               CER001
     C                   EVAL      L6LXMCID = 'Y'                                             CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      L6LXMCID = 'N'                                             CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SRRTVEXT2 - Retrieve customer extension group 2               *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRRTVEXT2     BEGSR                                                                CER001
      *                                                                                       CER001
      ** Retrieve record in extension file                                                    CER001
      *                                                                                       CER001
     C     K@KEY1        CHAIN(N)  RTVIDXB                            85                      CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
      *                                                                                       CER001
      ** If record exist                                                                      CER001
      *                                                                                       CER001
     C                   WHEN      *IN85 = *OFF                                               CER001
      *                                                                                       CER001
     C                   EVAL      WFIND2 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   MOVE      CUTYPE        LLLXTYPE                                     CER001
     C                   MOVE      CUIDCO        LLLXIDCO                                     CER001
     C                   MOVE      CUIDEN        LLLXIDEN                                     CER001
     C                   MOVE      CUIMCO        LLLXIMCO                                     CER001
     C                   MOVE      CUIMNB        LLLXIMNB                                     CER001
      *                                                                                       CER001
     C                   EVAL      #LLXCUFOTR = DDFOTRANID                                    CER001
     C                   EVAL      #LLXCUCNUM = CUCNUM                                        CER001
     C                   EVAL      #LLXCUTYPE = CUTYPE                                        CER001
     C                   EVAL      #LLXCUIDCO = CUIDCO                                        CER001
     C                   EVAL      #LLXCUIDEN = CUIDEN                                        CER001
     C                   EVAL      #LLXCUIMCO = CUIMCO                                        CER001
     C                   EVAL      #LLXCUIMNB = CUIMNB                                        CER001
     C                   EVAL      #LLXCUTMES = DDTMESTMP                                     CER001
      *                                                                                       CER001
     C                   MOVE      NwDlScnFmt    CrDlScnFmt                                   CER001
      *                                                                                       CER001
      ** If record does not exist                                                             CER001
      *                                                                                       CER001
     C                   WHEN      *IN85 = *ON                                                CER001
     C                   EVAL      WFIND2 = *BLANKS                                           CER001
      *                                                                                       CER001
     C                   EVAL      LLLXTYPE = *BLANKS                                         CER001
     C                   EVAL      LLLXIDCO = *BLANKS                                         CER001
     C                   EVAL      LLLXIDEN = *BLANKS                                         CER001
     C                   EVAL      LLLXIMCO = *BLANKS                                         CER001
     C                   EVAL      LLLXIMNB = *BLANKS                                         CER001
      *                                                                                       CER001
     C                   CALLB     'SDVCUTYPE2'                                               CER001
     C                   PARM                    ReturnCode                                   CER001
     C                   PARM                    MSG1                                         CER001
     C                   PARM                    LLLXTYPE                                     CER001
     C                   PARM                    DDCOLC                                       CER001
     C                   PARM                    DDCUSN                                       CER001
     C                   PARM                    DDBNBI                                       CER001
     C                   PARM                    DDBRCD                                       CER001
     C                   PARM                    BRBKCO                                       CER001
     C                   PARM                    #1NCOS                                       CER001
      *                                                                                       CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************
      /EJECT
      *****************************************************************         CPB002
      * CHKPTFR - Check if Portfolio Management Customer.                       CPB002
      *****************************************************************         CPB002
     C     CHKPTFR       BEGSR                                                  CPB002
      *                                                                         CPB002
      ** Initialize Portfolio Management customer indicator.                    CPB002
     C                   MOVE      'N'           PtfrCust                       CPB002
      *                                                                         CPB002
      * Retrieve Portfolio Management customer details.                         CPB002
      * if PM is on.                                                                          212263
      *                                                                         CPB002
     C     BGPFMG        IFEQ      'Y'                                                        212263
     C                   CALL      'AOPLCSR0'                                   CPB002
     C                   PARM      *BLANKS       @RTCD                          CPB002
     C                   PARM      '*VERIFY'     @OPTN                          CPB002
     C                   PARM      DDCUSN        P@CUST           10            CPB002
     C                   PARM                    DSFDY                                        212263
      *                                                                         CPB002
      ** If Portfolio Management customer details exist, set up                 CPB002
      ** Portfolio Management Customer Indicator.                               CPB002
      *                                                                         CPB002
     C     @RTCD         IFEQ      *BLANKS                                      CPB002
     C                   MOVE      'Y'           PtfrCust                       CPB002
      *                                                                         CPB002
     C                   END                                                                  212263
     C                   END                                                    CPB002
                                                                                CPB002
     C                   ENDSR                                                  CPB002
      *****************************************************************         CPB002
      /EJECT                                                                    CPB002
      *****************************************************************
      * CVTCUS - PUT A CUSTOMER ON THE PRIMARY DETAILS SCREEN
      *****************************************************************
     C     CVTCUS        BEGSR
      *
      * Call program to fill screen fields with data from SDCUSTPD
      *
     C                   CALLB     'SDCUSDCVT'
      *
      * INPUTS :
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Customer file format
     C                   PARM                    CrCuFilFmt
     C/COPY WNCPYSRC,SDH00745
      *
      * Base Rate Tax file format
     C                   PARM                    CrBrFilFmt
      *
      * Private Banking format
     C                   PARM                    CrPBFilFmt
                                                                                              CGP001
      ** Global Customer X-Reference                                                          CGP001
     C                   PARM                    GCrCuFilFmt                                  CGP001
     C                   PARM                    CrSwFilFmt                                   CSW207
                                                                                              CGP001
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
      *                                                                                     MD054028
     C                   PARM                    DDAPRC                                     MD054028
      * OUTPUTS
      * Customer - screen formats
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuSeco
     C                   PARM                    NewCuMT3x                                    CSW024
     C                   PARM                    NewCuMsg
     C                   PARM                    NewCuBrt
     C                   PARM                    NewCuPriv
     C                   PARM                    TranInACU3                                   CER059
     C                   PARM                    TranInACU4                                   CER059
     C                   PARM                    NewCuSwft                                    CSW207
     C/COPY WNCPYSRC,SDCUSDSC14
      *
      * Update 'Current' Customer with Customer in Screen Format
      *
     C                   MOVEL     NewCuPrim     CurCuPrim
     C                   MOVEL     NewCuBrt      CurCuBrt
     C                   MOVEL     NewCuSeco     CurCuSeco
     C                   MOVEL     NewCuMsg      CurCuMsg
     C                   MOVEL     NewCuPriv     CurCuPriv
     C                   MOVEL     NewCuMT3x     CurCuMT3x                                    CSW024
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   MOVEL     NewCuSwft     CurCuSwft                                    CSW027
     C                   ENDIF                                                                CSW207
     C/COPY WNCPYSRC,SDCUSDSC15
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
      *****************************************************************
     C     SFKEYS        BEGSR
      *
      * Enable/disable function keys
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS CUSTOMER
      * KH = COMMAND KEY 08 = READ NEXT CUSTOMER
      *
     C     @SCRN         IFEQ      'P'
     C     DDACTN        ANDNE     'I'                                                        248913
     C     DDACTN        ANDNE     'A'                                                        248913
     C     @SCRN         OREQ      'K'                                                        248913
     C     DDACTN        ANDNE     'I'                                                        248913
     C     DDACTN        ANDNE     'A'                                                        248913
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   ELSE
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH
     C                   ENDIF
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
                                                                                              CSD007
      ** KW = Command Key 22 = CONFIRM CLOSURE/RELEASE                                        CSD007
                                                                                              CSD007
     C     DDACTN        IFEQ      'C'                                                        CSD007
     C     DDACTN        OREQ      'R'                                                        CSD007
     C                   MOVEL     'Y'           @EINKW                                       CSD007
     C                   ELSE                                                                 CSD007
     C                   MOVEL     'N'           @EINKW                                       CSD007
     C                   ENDIF                                                                CSD007
      *
      * KX = COMMAND KEY 23 = FURTHER DETAILS
      *
     C     DDACTN        IFNE      'I'
     C                   MOVEL     'Y'           @EINKX
     C                   ELSE
     C                   MOVEL     'N'           @EINKX
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@K - INITIALIZE FIELD STATUS ON KEY SCREEN
      *****************************************************************
     C     IFDS@K        BEGSR
      *
      * ENABLE KEY FIELDS ON KEY SCREEN
      *
     C                   MOVEL     'Y'           @EDTFD
     C                   MOVEL     'Y'           @EKYFD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PARNAMES - Flag if there are changed participant names
      *****************************************************************
     C     PARNAMES      BEGSR
      *
      * If any 'P', the user to be prompted to confirm if new party or not
     C     'P'           LOOKUP    ChgNamArr                              99
     C                   MOVE      *IN99         CHGNAME           1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@P - SEND A MESSAGE TO SCREEN
      *****************************************************************
     C     SNDM@P        BEGSR
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
     C                   MOVEL     @data         MsgDtaArr(E)                                 249076
      *
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@K - CANCEL ON KEY SCREEN
      *****************************************************************
     C     CANC@K        BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
     C                   MOVEL     'B'           @SCRN
      *
      * If input fields are enabled
      * Blank the screens
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NewCuPrim
     C                   MOVEL     *BLANK        NewCuSeco
     C                   MOVEL     *BLANK        NewCuMsg
     C                   MOVEL     *BLANK        NewCuMT3x                                    CSW024
     C/COPY WNCPYSRC,SDH00746
     C                   END
      *
      * Initialize field status on Key Screen
      *
     C                   EXSR      IFDS@K
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@P - CANCEL ON PRIMARY SCREEN
      *****************************************************************
     C     CANC@P        BEGSR
      *
      * Return to previous screen
      *
     C                   IF        PAccMde <> 'A'                                             CSD031
     C     INSERTENQ     IFEQ      'Y'
     C                   MOVE      'I'           DDACTN
     C                   MOVEL     'K'           @SCRN
     C                   ELSE
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
     C                   ELSE                                                                 CSD031
     C**********         MOVEL     'B'           @SCRN                               CSD031 BUG11889
     C                   MOVEL     'R'           @SCRN                                      BUG11889
      *                                                                                     BUG11889
      ** Move 'R' to @SCRN to go to RDNBRW, from SDCUSDBRW                                  BUG11889
      **  it will execute RDSFLR to read the selected customer                              BUG11889
      *                                                                                     BUG11889
     C                   ENDIF                                                                CSD031
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SECONDARY SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to BRT tax screen
     C     S01383        IFEQ      'Y'
     C     DDTAIN        ANDEQ     'I'
     C     S01383        OREQ      'Y'
     C     DDTAIN        ANDEQ     'J'
     C     S01383        OREQ      'Y'                                                        CRE007
     C     DDTAIN        ANDEQ     'R'                                                        CRE007
     C                   MOVE      'X'           @SCRN
     C                   ELSE
      * Or return to Primary Details screen
     C                   MOVE      'P'           @SCRN
     C                   ENDIF
      *
     C     EndCANC@S     ENDSR
                                                                                              CSW024
      *****************************************************************                       CSW024
      /EJECT                                                                                  CSW024
      *****************************************************************                       CSW024
      *                                                               *                       CSW024
      * CANC@F - Cancel on MT3xx BEI and Fund Details screen          *                       CSW024
      *                                                               *                       CSW024
      *****************************************************************                       CSW024
                                                                                              CSW024
     C     CANC@F        BEGSR                                                                CSW024
      *                                                                                       CSW024
      ** Go to secondary details screen                                                       CSW024
     C                   MOVEL     'S'           @SCRN                                        CSW024
      *                                                                                       CSW024
     C     EndCANC@F     ENDSR                                                                CSW024
                                                                                              CSW024
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MESSAGE DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
      *
      * Return to Secondary Screen
      *
      ** If MT3xx BEI enhancement has been installed, and                                     CSW024
      ** SWIFT/Direct Link module is on then display                                          CSW024
      ** screen for MT3xx BEI details                                                         CSW024
     C                   IF        CSW024 = 'Y' AND                                           CSW024
     C                             BGMSDL = 'Y'                                               CSW024
     C                   MOVEL     'F'           @SCRN                                        CSW024
     C                   ELSE                                                                 CSW024
     C                   MOVEL     'S'           @SCRN
     C                   ENDIF                                                                CSW024
     C/COPY WNCPYSRC,SDH00604
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@B - CANCEL ON BASE RATE TAX SCREENS
      *****************************************************************
     C     CANC@B        BEGSR
      *
      * If on BRT screen 2, F12 returns to BRT screen 1
      * otherwise F12 returns to customer Primary Details screen
      *
     C     BRTSCREEN     IFEQ      '2'
     C                   MOVEL     '1'           BRTSCREEN
     C                   ELSE
     C                   MOVEL     'P'           @SCRN
      * Reset errors
      *
     C                   MOVE      *ALL'Y'       OKCuBrt
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@R - CANCEL ON Private Banking SCREEN
      *****************************************************************
     C     CANC@R        BEGSR
      *
      * Return to Messages Screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   MOVE      *ALL'Y'       OKCuPriv
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FURDET - Further Details
      *****************************************************************
     C     FURDET        BEGSR
      **********                                                                  BUG26917 BUG26917A
     C*****CER048        IFEQ      'Y'                                            BUG26917 BUG26917A
     C*****DDACTN        IFEQ      'I'                                            BUG26917 BUG26917A
     C*****DDACTN        OREQ      'A'                                            BUG26917 BUG26917A
     C*****DDTAIN        IFEQ      'Y'                                            BUG26917 BUG26917A
     C**********         EVAL      FDTAIN = DDTAIN                                BUG26917 BUG26917A
     C**********         ELSE                                                     BUG26917 BUG26917A
     C**********         EVAL      FDTAIN = *BLANKS                               BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
                                                                                              CSC011
      ** Further Details (F23) not available in Support System                                CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                             AND LIBR = S1SUPP                                          CSC011
     C                             AND DDACTN <> 'E'                                          CSC011
     C                   IF        DDACTN <> 'I'                                              CSC011
     C                   EVAL      Idx = 1                                                    CSC011
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                                 CSC011
     C                   EVAL      MsgIdArr(Idx) = 'USR9370'                                  CSC011
     C                   ENDIF                                                                CSC011
     C                   ELSE                                                                 CSC011
      **
      ** Call Further Details
      **
     C                   MOVE      DDCUSN        FDCUST
     C                   MOVE      DDCSSN        FDCSSN
     C                   MOVE      DDCRTN        FDCRTN
     C                   MOVE      DDCRNM        FDCRNM
     C                   MOVE      DDLINC        FDLINC
     C                   MOVE      C_BBTICS      FDTICS
     C**********         MOVE      DDCRPC        FDCRPC                              BUG4454 BUG5139
     C**********         MOVE      DDBRCD        FDBRCD                              BUG4454 BUG5139
     C**********         MOVE      DDLICD        FDLICD                              BUG4454 BUG5139
      *
     C                   CALL      'SD0014V'                              90
     C                   PARM                    RTNCDE            7
     C                   PARM                    FURDETS
     C                   PARM                    @OPSEL
     C                   PARM                    DDPAIN
      *                                                                                       237595
      ** Reset error indicators                                                               237595
      *                                                                                       237595
     C                   MOVE      *ALL'Y'       OKCuPrim                                     237595
     C                   MOVEL     *BLANK        FldNameArr                                   237595
     C                   MOVEL     *BLANK        MsgIdArr                                     237595
     C                   MOVEL     *BLANK        MsgDtaArr                                    237595
     C                   MOVEL     *BLANK        WFldNamArr                                   237595
     C                   MOVEL     *BLANK        WMsgIdArr                                    237595
     C                   MOVEL     *BLANK        WMsgDtaArr                                   237595
     C                   Z-ADD     0             Idx                                          237595
      *                                                                                       237595
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
     C     EndFURDET     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
     C/COPY WNCPYSRC,SDCUSDSC21
      *****                                                                     185595
      **If*action code 'I', maintain Further Details                            185595
      *****                                                                     185595
     C*****DDACTN        IFEQ      'I'                                          185595
     C*****              EXSR      FURDET                                       185595
     C*****              END                                                    185595
      ***********************************************                                BUG3362 BUG8425
      ***If*action*code*'I',*maintain*Further*Details                                BUG3362 BUG8425
      ***********************************************                                BUG3362 BUG8425
     C*****Idx**         IFEQ      *ZEROS                                            BUG3362 BUG8425
     C*****DDACTN        IFEQ      'I'                                               BUG3362 BUG8425
     C**********         EXSR      FURDET                                            BUG3362 BUG8425
     C**********         ENDIF                                                       BUG3362 BUG8425
     C**********         ENDIF                                                       BUG3362 BUG8425
      *
      * Update valid customer: customer reference
      *
     C                   MOVEL     DDCUSN        CUCUST
     C                   MOVEL     DDACTN        CUTYLC
      *
      ** Carry forward non-validated master file values to valid file
      *
     C     DDACTN        IFEQ      'A'
     C                   MOVE      C_BBTXA2      CUTXA2
     C                   MOVE      C_BBTXA3      CUTXA3
     C                   MOVE      C_BBTXA4      CUTXA4
     C                   MOVE      C_BBTXA5      CUTXA5
     C                   MOVE      C_BBLETI      CULETI
     C                   MOVE      C_BBCMTI      CUCMTI
     C                   MOVE      C_BBOGID      CUOGID
     C                   Z-ADD     C_BBORED      CUORED
     C**********         MOVE      C_BBNET       CUNET                                        202805
     C**********         MOVE      C_BBNTGP      CUNTGP                                       202805
     C**********         MOVE      C_BBNTCP      CUNTCP                                       202805
     C**********         Z-ADD     C_BBNTND      CUNTND                                       202805
     C**********         MOVE      C_BBNTMM      CUNTMM                                       202805
     C**********         MOVE      C_BBTMST      CUTMST                                       202805
                                                                                              CSD031
     C                   IF        PAccMde <> 'A'                                             CSD031
     C     DDCUSN        CHAIN     SDCUSTL5                           90                      202805
     C                   ELSE                                                                 CSD031
     C     DDCUSN        CHAIN     SDACSTL1                           90                      CSD031
     C                   ENDIF                                                                CSD031
                                                                                              CSD031
     C     *IN90         IFEQ      '0'                                                        202805
     C                   MOVE      W@NET         CUNET                                        202805
     C                   MOVE      W@NTGP        CUNTGP                                       202805
     C                   MOVE      W@NTCP        CUNTCP                                       202805
     C                   Z-ADD     W@NTND        CUNTND                                       202805
     C                   MOVE      W@NTMM        CUNTMM                                       202805
     C                   MOVE      W@TMST        CUTMST                                       202805
     C                   ENDIF                                                                202805
                                                                                             BUG2664
      ** If FDTICS is blanks, this means F23 was not pressed, therefore,                     BUG2664
      ** field must retain its current value else, get the updated value                     BUG2664
                                                                                             BUG2664
     C     FDTICS        IFEQ      *BLANKS                                                   BUG2664
     C                   MOVE      C_BBTICS      CUTICS                                      BUG2664
     C                   ELSE                                                                BUG2664
     C                   MOVE      FDTICS        CUTICS                                       196149
     C                   ENDIF                                                               BUG2664
                                                                                             BUG2664
     C                   ELSE
      *
      ** Initialise non-validated valid file fields for Insert
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      *BLANKS       CUTXA2
     C                   MOVE      *BLANKS       CUTXA3
     C                   MOVE      *BLANKS       CUTXA4
     C                   MOVE      *BLANKS       CUTXA5
     C                   MOVE      *BLANKS       CULETI
     C                   MOVE      *BLANKS       CUCMTI
     C                   MOVE      *BLANKS       CUOGID
     C                   Z-ADD     BJRDNB        CUORED
     C                   MOVE      'N'           CUNET
     C                   MOVE      *BLANKS       CUNTGP
     C                   MOVE      'N'           CUNTCP
     C                   MOVE      'N'           CUNTMM
     C     CUTICS        IFEQ      *BLANK
     C                   MOVE      'N'           CUTICS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG3362
      ** If Further details was accessed, load changed value(FDCTID from                     BUG3362
      ** SD0014V) to NwTIFilfmt if no error                                                  BUG3362
      *                                                                                      BUG3362
     C     FDTICS        IFEQ      'Y'                                                       BUG3362
      *                                                                                      BUG3362
     C                   MOVEL     FDCTID        NwTIfilFmt                                  BUG3362
     C                   EVAL      V_TCLCD = BJRDNB                                          BUG3362
      *                                                                                      BUG3362
     C     DDACTN        IFEQ      'I'                                                       BUG3362
     C                   EVAL      V_TCCSSN=CUCSSN                                           BUG3362
     C                   ENDIF                                                               BUG3362
     C                   EVAL      CUTICS = FDTICS                                           BUG3362
     C                   ELSE                                                                BUG3362
     C     FDTICS        IFEQ      'N'                                                       BUG3362
     C     DDACTN        ANDEQ     'I'                                                       BUG3362
     C     FDTICS        OREQ      ' '                                                       BUG3362
     C     DDACTN        ANDEQ     'I'                                                       BUG3362
      ** case FDTICS = 'N'                                                                   BUG3362
     C                   MOVE      *BLANKS       NwTifilFmt                                  BUG3362
     C                   EVAL      V_TCLCD = 0                                               BUG3362
     C                   ENDIF                                                               BUG3362
     C                   ENDIF                                                               BUG3362
      *                                                                                      BUG3362
     C                   MOVEL     *BLANK        @RTCD
      *
      * CUSTOMER UPDATES
      *
     C                   CALLB     'SDCUSDUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwCuFilFmt
     C                   PARM                    NwBrFilFmt
     C                   PARM                    NwPBFilFmt
     C                   PARM                    NwTIFilFmt                                  BUG3362
     C                   PARM                    NwSwFilFmt                                   CSW207
     C**********         PARM                    CuSW13                              CFT050 MD022395
     C                   PARM                    NewCuSW13                                  MD022395
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
     C                   PARM                    V_DDGCUS                                     CGP001
     C                   PARM                    S01383
                                                                                              CLE025
      ** Switchable features                                                                  CLE025
                                                                                              CLE025
     C                   PARM                    CSW024                                       CSW024
     C                   PARM                    CGP001                                       CGP001
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
     C                   PARM                    TransType                                    CSD028
     C                   PARM                    DACTN             1                          CSD028
     C                   PARM                    CTI006            1                        MD030956
      ** Acceptance Mode                                                                      CSD031
     C                   PARM                    PAccMde                                      CSD031
      ** Update (Y/N)                                                                         CSD031
     C                   PARM                    PUpdYN                                       CSD031
     C/COPY WNCPYSRC,SDCUSDSC16
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CER001
     C**********         IF        ULX043 = 'Y'                                      CER001 BUG10817
     C                   IF        ULX609 = 'Y'                                             BUG10817
      *                                                                                       CER001
      ** Update extension fields group 1                                                      CER001
      *                                                                                       CER001
     C                   EVAL      #6LXVFCOLC = #1COLC                                        CER001
     C                   EVAL      #6LXVFCRNM = #1CRNM                                        CER001
      *                                                                                       CER001
     C                   CALLB     'SDCUSD2UP'                                                CER001
     C                   PARM                    PWAction                                     CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM                    WFIND1                                       CER001
     C                   PARM                    NwDlFilFmt1                                  CER001
     C                   PARM                    CrDlFilFmt1                                  CER001
      *                                                                                       CER001
      ** If there were any errors in the update functions, rollback any                       CER001
      ** updates and end this pgm, otherwise delete the invalid extended                      CER001
      ** deal and commit the updates                                                          CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANK    AND                                     CER001
     C                             @RTCD <> '*RECUPD' AND                                     CER001
     C                             @RTCD <> '*RECLCK'                                         CER001
     C                   ROLBK                                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                              BUG10817
     C                   ENDIF                                                              BUG10817
     C**********         ELSE                                                                 CER001
     C                   IF        @RTCD = *BLANK                                           BUG10817
      *                                                                                       CER001
      ** Update extension fields group 2                                                      CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                             BUG10817
     C                   CALLB     'SDCUSD3UP'                                                CER001
     C                   PARM                    PWAction                                     CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM                    WFIND2                                       CER001
     C                   PARM                    NwDlFilFmt2                                  CER001
     C                   PARM                    CrDlFilFmt2                                  CER001
      *                                                                                       CER001
      ** If there were any errors in the update functions, rollback any                       CER001
      ** updates and end this pgm, otherwise delete the invalid extended                      CER001
      ** customer and commit the updates                                                      CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANK    AND                                     CER001
     C                             @RTCD <> '*RECUPD' AND                                     CER001
     C                             @RTCD <> '*RECLCK'                                         CER001
     C                   ROLBK                                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,SDCUSDSC01
     C                   COMMIT
      *********************************************************************           185595 BUG3362
      **If*action*code*'I',*maintain*Further*Details***********************           185595 BUG3362
      *********************************************************************           185595 BUG3362
     C*****DDACTN********IFEQ******'I'*************************************           185595 BUG3362
     C*******************EXSR******FURDET**********************************           185595 BUG3362
     C*******************END***********************************************           185595 BUG3362
      *********************************************************************           185595 BUG3362
                                                                                             BUG5139
      ** If action code 'I', maintain Further Details                                        BUG5139
                                                                                             BUG5139
     C     Idx           IFEQ      *ZEROS                                                    BUG5139
     C     DDACTN        IFEQ      'I'                                                       BUG5139
     C                   EXSR      FURDET                                                    BUG5139
     C                   ENDIF                                                               BUG5139
     C                   ENDIF                                                               BUG5139
     C                   END
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO INSERT KEY SCREEN OR BROWSE SBFILE
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'K'           @SCRN
                                                                                              CSD021
     C     CSD021        IFEQ      'Y'                                                        CSD021
     C                   MOVEL     CUCUST        WWCNUM                                       CSD021
     C                   ENDIF                                                                CSD021
                                                                                              CSD021
     C                   ELSE
     C                   IF        CSD028 = 'Y' AND TransType = 'AUTH'                        CSD028
     C                   EVAL      @SCRN = 'T'                                                CSD028
     C                   ELSE                                                                 CSD028
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF                                                                CSD028
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,SDCUSDSC22
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      *                                                                                       189774
      ** Rollback to clear any possible updates in window function                            189774
      *                                                                                       189774
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   ROLBK                                                                189774
     C                   ENDIF                                                                189774
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      * Blank the screens
      *
     C                   MOVEL     *BLANK        NewCuPrim
     C                   MOVEL     *BLANK        NewCuSeco
     C                   MOVEL     *BLANK        NewCuMsg
     C                   MOVEL     *BLANK        NewCuPriv
     C                   MOVEL     *BLANK        NewCuMT3x                                    CSW024
     C/COPY WNCPYSRC,SDH00747
      *
      * Browse Screen
      *
     C                   MOVEL     'B'           @SCRN             1
      *
      * Initialize field status on Key Screen
      *
     C                   EXSR      IFDS@K
      *
     C                   ENDSR
      *****************************************************************                       CFT050
      /EJECT                                                                                  CFT050
      *****************************************************************                       CFT050
      * SRSCRNPL- Display Bank Plus enquiry screen                                            CFT050
      *****************************************************************                       CFT050
     C     SRSCRNPL      BEGSR                                                                CFT050
      *                                                                                       CFT050
     C                   IF        DDBDRK =  *BLANKS                                          CFT050
      *                                                                                       CFT050
     C                   CALL      'FT0900'                                                   CFT050
     C                   PARM      'S'           WIMODE                                       CFT050
     C                   PARM      *BLANKS       WICRIT                                       CFT050
     C                   PARM      *BLANKS       WOADD                                        CFT050
     C                   PARM      *BLANKS       WOCHIP                                       CFT050
     C                   PARM      *BLANKS       WOUTCD                                       CFT050
     C                   PARM      *BLANKS       WRTCD                                        CFT050
      *                                                                                       CFT050
     C                   EVAL      WPARKEY = *BLANKS                                          CFT050
     C                   IF        WOADD  <> *BLANKS                                          CFT050
     C                   EVAL      CUBDRK   = WOADD                                           CFT050
     C                   EVAL      DDBDRK   = WOADD                                           CFT050
     C     CUBDRK        SETLL     MEBIB3L0                                                   CFT050
     C                   IF        %EQUAL                                                     CFT050
     C     CUBDRK        CHAIN     MEBIB3L0                                                   CFT050
     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
     C                   EVAL      WPARKEY = B3POKY                                           CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
      ** Default if insert mode                                                               CFT050
      *                                                                                       CFT050
     C                   IF        DDACTN = 'I'                                               CFT050
     C                             AND WPARKEY <> *BLANKS                                     CFT050
     C                   EXSR      GETPARKEY                                                  CFT050
     C                   EXSR      DEF2NDSCR                                                  CFT050
     C                   EXSR      DEF3RDSCR                                                  CFT050
     C                   EXSR      DEF8THSCR                                                  CFT050
     C                   ENDIF                                                                CFT050
                                                                                              CFT050
     C                   ELSE                                                                 CFT050
                                                                                              CFT050
     C                   EVAL      DDBDRK = *BLANKS                                           CFT050
     C                   EVAL      CUBDRK = *BLANKS                                           CFT050
                                                                                              CFT050
     C                   ENDIF                                                                CFT050
     C                   EVAL      @SCRN = 'P'                                                CFT050
      *                                                                                       CFT050
     C                   ENDSR                                                                CFT050
                                                                                              CFT050
      *****************************************************************                       CFT050
      /EJECT                                                                                  CFT050
      *****************************************************************                       CFT050
      * GETPARKEY - Get parent key from customer file                                         CFT050
      *****************************************************************                       CFT050
     C     GETPARKEY     BEGSR                                                                CFT050
      *                                                                                       CFT050
     C     WPARKEY       SETLL     SDCSSWL2                                                   CFT050
     C                   IF        %EQUAL                                                     CFT050
     C     WPARKEY       CHAIN     SDCSSWL2                                                   CFT050
     C                   IF        %FOUND(SDCSSWL2)                                           CFT050
      *                                                                                       CFT050
     C                   CALL      'AOCUSTR0'                                                 CFT050
     C                   PARM      *BLANKS       @RTCD                                        CFT050
     C                   PARM      '*KEY   '     @OPTN                                        CFT050
     C                   PARM      CSCUSD        @KEY1                                        CFT050
     C                   PARM      *BLANKS       @KYST                                        CFT050
     C     SDCUST        PARM      *BLANKS       DSSDY                                        CFT050
      *                                                                                       CFT050
     C                   IF        @RTCD = *BLANKS                                            CFT050
     C                   IF        DDPCNB = *BLANKS                                           CFT050
     C                   EVAL      DDPCNB = PR_BBPCNB                                         CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C                   ENDSR                                                                CFT050
                                                                                              CFT050
      *****************************************************************                       CFT050
      /EJECT                                                                                  CFT050
      *****************************************************************                       CFT050
      * DEF2NDSCR - Default second screen using record key                                    CFT050
      *****************************************************************                       CFT050
     C     DEF2NDSCR     BEGSR                                                                CFT050
      *                                                                                       CFT050
     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
      **                                                                                      CFT050
     C                   EVAL      WPARKEY = B3POKY                                           CFT050
      **                                                                                      CFT050
     C                   IF        DDBNBI = *BLANKS                                           CFT050
     C                   IF        B3ISST = 'BANK'                                            CFT050
     C                             OR B3ISST = 'COOP'                                         CFT050
     C                             OR B3ISST = 'CBMA'                                         CFT050
     C                   EVAL      DDBNBI = 'Y'                                               CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDCNA1 = *BLANKS                                           CFT050
     C                   EVAL      DDCNA1 = B3INS1                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDCRNM = *BLANKS                                           CFT050
     C                   EVAL      DDCRNM = B3INS1                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDCNA2 = *BLANKS                                           CFT050
     C                   EVAL      DDCNA2 = B3ADD1                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDCNA3 = *BLANKS                                           CFT050
     C                   EVAL      DDCNA3 = B3ADD2                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDCRTN = *BLANKS                                           CFT050
     C                   EVAL      DDCRTN = B3CITY                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   SELECT                                                               CFT050
     C                   WHEN      DDCNA1 = *BLANKS                                           CFT050
     C                   EVAL      DDCNA1 = B3CPS1                                            CFT050
     C                   WHEN      DDCNA2 = *BLANKS                                           CFT050
     C                   EVAL      DDCNA2 = B3CPS1                                            CFT050
     C                   WHEN      DDCNA3 = *BLANKS                                           CFT050
     C                   EVAL      DDCNA3 = B3CPS1                                            CFT050
     C                   WHEN      DDCNA4 = *BLANKS                                           CFT050
     C                   EVAL      DDCNA4 = B3CPS1                                            CFT050
     C                   ENDSL                                                                CFT050
      **                                                                                      CFT050
     C                   SELECT                                                               CFT050
     C                   WHEN      DDCNA1 = *BLANKS                                           CFT050
     C                   EVAL      DDCNA1 = B3CNT1                                            CFT050
     C                   WHEN      DDCNA2 = *BLANKS                                           CFT050
     C                   EVAL      DDCNA2 = B3CNT1                                            CFT050
     C                   WHEN      DDCNA3 = *BLANKS                                           CFT050
     C                   EVAL      DDCNA3 = B3CNT1                                            CFT050
     C                   WHEN      DDCNA4 = *BLANKS                                           CFT050
     C                   EVAL      DDCNA4 = B3CNT1                                            CFT050
     C                   ENDSL                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDCNCZ = *BLANKS                                           CFT050
     C                   EVAL      DDCNCZ = B3ISOC                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDCNCZ = *BLANKS                                           CFT050
     C                   EVAL      DDCOLC = B3ISOC                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   EVAL      SVCNCZ = *BLANKS                                           CFT050
     C                   EVAL      SVCOLC = *BLANKS                                           CFT050
     C     B3ISOC        SETLL     SDCTRYL3                                                   CFT050
     C                   IF        %EQUAL                                                     CFT050
     C     B3ISOC        CHAIN     SDCTRYL3                                                   CFT050
     C                   DOW       %FOUND(SDCTRYL3)                                           CFT050
     C                   EVAL      SVCNCZ = A4CNCD                                            CFT050
     C                   EVAL      SVCOLC = A4CNCD                                            CFT050
     C                   IF        B3ISOC = A4CNCD                                            CFT050
     C                   EVAL      SVCNCZ = A4CNCD                                            CFT050
     C                   EVAL      SVCOLC = A4CNCD                                            CFT050
     C                   LEAVE                                                                CFT050
     C                   ENDIF                                                                CFT050
     C     B3ISOC        READE     SDCTRYL3                                                   CFT050
      ** SDCTRYL3 dow                                                                         CFT050
     C                   ENDDO                                                                CFT050
      **                                                                                      CFT050
     C                   IF        SVCNCZ <> *BLANKS                                          CFT050
     C                             AND DDCNCZ = *BLANK                                        CFT050
     C                   EVAL      DDCNCZ = SVCNCZ                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        SVCOLC <> *BLANKS                                          CFT050
     C                             AND DDCOLC = *BLANK                                        CFT050
     C                   EVAL      DDCOLC = SVCOLC                                            CFT050
     C                   ENDIF                                                                CFT050
      ** SDCTRYL3 equal                                                                       CFT050
     C                   ENDIF                                                                CFT050
      ** MEBIB3L0 chain                                                                       CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C                   ENDSR                                                                CFT050
      *                                                                                       CFT050
      *****************************************************************                       CFT050
      /EJECT                                                                                  CFT050
      *****************************************************************                       CFT050
      * DEF3RDSCR - Default third screen using record key                                     CFT050
      *****************************************************************                       CFT050
     C     DEF3RDSCR     BEGSR                                                                CFT050
      *                                                                                       CFT050
     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
      **                                                                                      CFT050
      **                                                                                      CFT050
     C                   IF        DDCSID = *BLANKS                                           CFT050
     C                   EVAL      DDCSID = B3BICC                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDCIDA = *BLANKS                                           CFT050
     C                   EVAL      DDCIDA = B3CHIP                                            CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        B3ISOC = 'US'                                              CFT050
     C                   IF        DDFWCA = *BLANKS                                           CFT050
     C                   EVAL      DDFWCA = B3NATI                                            CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        B3ISOC = 'DE'                                              CFT050
     C                   IF        DDBLCD = *BLANKS                                           CFT050
     C                   EVAL      DDBLCD = B3NATI                                            CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        B3ISOC = 'JP'                                              CFT050
     C                   IF        DDBFIC = *BLANKS                                           CFT050
     C                   EVAL      DDBFIC = B3NATI                                            CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        B3ISOC = 'GB'                                              CFT050
     C                   IF        DDCSCA = *BLANKS                                           CFT050
     C                   EVAL      DDCSCA = B3NATI                                            CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   EVAL      SVCLSY = *BLANKS                                         MD022443
     C                   IF        CSW213 = 'Y'                                               CSW213
      *                                                                                       CSW213
     C                   IF        DDCLID = *BLANKS                                           CSW213
     C                   EVAL      DDCLID = B3NATI                                            CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
     C                   IF        DDCLSY = *BLANKS                                           CSW213
     C**********         EVAL      DDCLSY = B3ISOC                                   CSW213 MD022443
     C                   EVAL      SVCLSY = B3ISOC                                          MD022443
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
     C**********         EVAL      SVCLSY = *BLANKS                                  CSW213 MD022443
     C                   SELECT                                                               CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'AT'                                              CSW213
     C                   EVAL      SVCLSY = 'AT'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'AU'                                              CSW213
     C                   EVAL      SVCLSY = 'AU'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'CA'                                              CSW213
     C                   EVAL      SVCLSY = 'CC'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'ES'                                              CSW213
     C                   EVAL      SVCLSY = 'ES'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'GR'                                              CSW213
     C                   EVAL      SVCLSY = 'GR'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'HK'                                              CSW213
     C                   EVAL      SVCLSY = 'HK'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'IE'                                              CSW213
     C                   EVAL      SVCLSY = 'IE'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'IN'                                              CSW213
     C                   EVAL      SVCLSY = 'IN'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'IT'                                              CSW213
     C                   EVAL      SVCLSY = 'IT'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'NZ'                                              CSW213
     C                   EVAL      SVCLSY = 'NZ'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'PL'                                              CSW213
     C                   EVAL      SVCLSY = 'PL'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'PT'                                              CSW213
     C                   EVAL      SVCLSY = 'PT'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'RU'                                              CSW213
     C                   EVAL      SVCLSY = 'RU'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'CH'                                              CSW213
     C                   EVAL      SVCLSY = 'SW'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'SW'                                              CSW213
     C                   EVAL      SVCLSY = 'SW'                                              CSW213
      *                                                                                       CSW213
     C                   WHEN      B3ISOC = 'ZA'                                              CSW213
     C                   EVAL      SVCLSY = 'ZA'                                              CSW213
      *                                                                                       CSW213
     C                   OTHER                                                                CSW213
     C                   EVAL      DDCLID = *BLANKS                                           CSW213
     C                   EVAL      DDCLSY = *BLANKS                                           CSW213
      *                                                                                       CSW213
     C                   ENDSL                                                                CSW213
      *                                                                                       CSW213
     C                   IF        SVCLSY <> *BLANKS                                          CSW213
     C                             AND DDCLSY = *BLANKS                                       CSW213
     C                   EVAL      DDCLSY = SVCLSY                                            CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
     C                   IF        DDLEIC = *BLANKS                                           CSW213
     C                   EVAL      DDLEIC = B3LEIC                                            CSW213
     C                   ENDIF                                                                CSW213
      ** CSW213                                                                               CSW213
     C                   ENDIF                                                                CSW213
      **                                                                                      CFT050
     C                   IF        B3CBIC <> *BLANKS                                          CFT050
     C                   EVAL      DDCSID =  B3CBIC                                           CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   CALLB     'AOBEISR0'                                                 CFT050
     C                   PARM      *BLANKS       @RTCD                                        CFT050
     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
     C                   PARM      B3STYP        PBICD                                        CFT050
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CFT050
     C                   IF        @RTCD <> *BLANKS                                           CFT050
     C                   IF        DDSWFI = *BLANKS                                           CFT050
     C                   EVAL      DDSWFI = 'Y'                                               CFT050
     C                   ENDIF                                                                CFT050
     C                   ELSE                                                                 CFT050
     C                   IF        DDSWFI = *BLANKS                                           CFT050
     C                   EVAL      DDSWFI = 'N'                                               CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C**********         IF        CSW204 = 'Y'                                      CFT050 MD022463
     C**********                   AND B3STYP = 'CORP'                               CFT050 MD022463
     C**********         IF        DDCRPC = *BLANKS                                  CFT050 MD022463
     C**********         EVAL      DDCRPC = 'Y'                                      CFT050 MD022463
     C**********         ENDIF                                                       CFT050 MD022463
      ***CSW204*                                                                     CFT050 MD022463
     C**********         ENDIF                                                       CFT050 MD022463
     C                                                                                        CFT050
      ** MEBIB3L0 chain                                                                       CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C                   ENDSR                                                                CFT050
      *****************************************************************                       CFT050
      /EJECT                                                                                  CFT050
      *****************************************************************                       CFT050
      * DEF8THSCR - Default eight screen using record key                                     CFT050
      *****************************************************************                       CFT050
     C     DEF8THSCR     BEGSR                                                                CFT050
      *                                                                                       CFT050
     C                   IF        %FOUND(MEBIB3L0)                                           CFT050
      **                                                                                      CFT050
     C                   EVAL      WPARKEY = B3POKY                                           CFT050
      **                                                                                      CFT050
     C                   IF        CSW024 = 'Y'                                             MD022463
     C                             AND B3STYP = 'CORP'                                      MD022463
     C                   IF        DDCORP = *BLANKS                                         MD022463
     C                   EVAL      DDCORP = 'Y'                                             MD022463
     C                   ENDIF                                                              MD022463
      **                                                                                    MD022463
     C                   IF        B3BICC <>*BLANKS                                         MD022463
                                                                                            MD022463
     C                   IF        DDCBEI = *BLANKS                                           CFT050
     C                   EVAL      DDCBEI = B3UBIC                                            CFT050
     C                   ENDIF                                                                CFT050
                                                                                            MD022463
     C                   ELSE                                                               MD022463
      **                                                                                      CFT050
     C                   IF        DDRI01 = *BLANKS                                           CFT050
     C                   IF        B3BICC <> *BLANKS                                          CFT050
     C                   EVAL      DDRI01 = '/ABIC/' + B3BICC                                 CFT050
     C                   ELSE                                                                 CFT050
     C                   EVAL      DDRI01 = '/ABIC/UKNW'                                      CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        DDRI02 = *BLANKS                                           CFT050
     C                   EVAL      DDRI02 = '/NAME/' + B3INS1                                 CFT050
     C                   ENDIF                                                                CFT050
      **                                                                                      CFT050
     C                   IF        CSW213 = 'Y'                                               CFT050
     C                             AND B3LEIC <> *BLANKS                                      CFT050
     C                   IF        DDRI03 = *BLANKS                                           CFT050
     C                   EVAL      DDRI03 = '/LEIC/' + B3LEIC                                 CFT050
     C                   ENDIF                                                                CFT050
     C                   ENDIF                                                                CFT050
      ** B3BICC                                                                             MD022463
     C                   ENDIF                                                              MD022463
      ** CSW024                                                                             MD022463
     C                   ENDIF                                                              MD022463
     C                                                                                        CFT050
      ** MEBIB3L0 chain                                                                       CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C                   ENDSR                                                                CFT050
      *                                                                                       CFT050
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
                                                                                              CSD028
      ** Entry Parameters                                                                     CSD028
                                                                                              CSD028
     C     *ENTRY        PLIST                                                                CSD028
                                                                                              CSD028
      ** INPUTS                                                                               CSD028
      ** Transaction Type                                                                     CSD028
     C                   PARM                    TransType                                    CSD028
                                                                                              CSD028
      ** Customer Number                                                                      CSD028
     C                   PARM                    PCustNum                                     CSD028
                                                                                              CSD012
      * Override SDAULGL2                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSDSIN'   DBPGM
      *
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
      ** Access SAR details file to determine if S01383
      ** (Base Rate Tax) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   MOVEL     'S01383'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   ELSE
     C                   MOVEL     'N'           S01383
     C                   END
      *                                                                                       CSW024
      ** Access SAR details file to determine if CSW024                                       CSW024
      ** S.W.I.F.T. MT3xx Field 82/83/87 is installed.                                        CSW024
      *                                                                                       CSW024
     C                   CALLB     'AOSARDR0'                                                 CSW024
     C                   PARM      *BLANKS       @RTCD                                        CSW024
     C                   PARM      '*VERIFY'     @OPTN                                        CSW024
     C                   PARM      'CSW024'      @SARD                                        CSW024
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW024
      *                                                                                       CSW024
      * DATABASE ERROR                                                                        CSW024
      *                                                                                       CSW024
     C     @RTCD         IFNE      *BLANKS                                                    CSW024
     C     @RTCD         ANDNE     '*NRF   '                                                  CSW024
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSW024
     C                   MOVEL     '906'         DBASE                                        CSW024
     C                   MOVEL     'CSW024'      DBKEY                                        CSW024
     C                   EXSR      *PSSR                                                      CSW024
     C                   ENDIF                                                                CSW024
      *                                                                                       CSW024
     C     @RTCD         IFEQ      *BLANK                                                     CSW024
     C                   MOVEL     'Y'           CSW024            1                          CSW024
     C                   ELSE                                                                 CSW024
     C                   MOVEL     'N'           CSW024                                       CSW024
     C                   ENDIF                                                                CSW024
                                                                                              CSC011
      ** Access SAR Details file to determine if CSC011 is switched on                        CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       @RTCD                                        CSC011
     C                   PARM      '*VERIFY'     @OPTN                                        CSC011
     C                   PARM      'CSC011'      @SARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** Database Error                                                                       CSC011
                                                                                              CSC011
     C     @RTCD         IFNE      *BLANKS                                                    CSC011
     C     @RTCD         ANDNE     '*NRF   '                                                  CSC011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSC011
     C                   MOVEL     '907'         DBASE                                        CSC011
     C                   MOVEL     'CSC011'      DBKEY                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSC011
     C     @RTCD         IFEQ      *BLANK                                                     CSC011
     C                   MOVEL     'Y'           CSC011            1                          CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   MOVEL     'N'           CSC011                                       CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD021
      ** Check if CSD021 is installed                                                         CSD021
     C                   CALLB     'AOSARDR0'                                                 CSD021
     C                   PARM      *BLANKS       @RTCD                                        CSD021
     C                   PARM      '*VERIFY'     @OPTN                                        CSD021
     C                   PARM      'CSD021'      @SARD                                        CSD021
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD021
                                                                                              CSD021
      ** Database error                                                                       CSD021
                                                                                              CSD021
     C                   IF        (@RTCD <> *BLANKS) and                                     CSD021
     C                             (@RTCD <> '*NRF   ')                                       CSD021
     C                   EVAL      DBKEY = 'CSD021'                                           CSD021
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD021
     C                   EVAL      DBASE = 909                                                CSD021
     C                   EXSR      *PSSR                                                      CSD021
     C                   ENDIF                                                                CSD021
                                                                                              CSD021
     C                   IF        @RTCD = *BLANKS                                            CSD021
     C                   EVAL      CSD021 = 'Y'                                               CSD021
     C                   ELSE                                                                 CSD021
     C                   EVAL      CSD021 = 'N'                                               CSD021
     C                   ENDIF                                                                CSD021
      *                                                                                       CSD012
      ** Access SAR details file to determine if CSD012                                       CSD012
      ** (Standing Data Authorisation) is on.                                                 CSD012
     C                   CALLB     'AOSARDR0'                                                 CSD012
     C                   PARM      *BLANKS       @RTCD                                        CSD012
     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
     C                   PARM      'CSD012'      @SARD                                        CSD012
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC012
      *                                                                                       CSD012
     C     @RTCD         IFEQ      *BLANK                                                     CSD012
     C                   MOVE      'Y'           CSD012                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           CSD012                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
      ** If CSD012 is ON, Check if Customer Details Authorisation is ON                       CSD012
 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'                                                 CSD012
     C                   PARM                    @RTCD                                        CSD012
     C                   PARM      SVALKK        SVALK1           20                          CSD012
     C                   PARM                    SVAL1           200                          CSD012
     C                   PARM                    SVALK2           20                          CSD012
     C                   PARM                    SVAL2           200                          CSD012
     C                   PARM                    SVALK3           20                          CSD012
     C                   PARM                    SVAL3           200                          CSD012
     C                   PARM                    SVALK4           20                          CSD012
     C                   PARM                    SVAL4           200                          CSD012
     C                   PARM                    SVALK5           20                          CSD012
     C                   PARM                    SVAL5           200                          CSD012
     C                   PARM                    SVALK6           20                          CSD012
     C                   PARM                    SVAL6           200                          CSD012
     C                   PARM                    SVALK7           20                          CSD012
     C                   PARM                    SVAL7           200                          CSD012
     C                   PARM                    SVALK8           20                          CSD012
     C                   PARM                    SVAL8           200                          CSD012
     C                   PARM                    SVALK9           20                          CSD012
     C                   PARM                    SVAL9           200                          CSD012
     C                   PARM                    SVALK0           20                          CSD012
     C                   PARM                    SVAL10          200                          CSD012
      *                                                                                       CSD012
     C     @RTCD         IFNE      *BLANKS                                                    CSD012
                                                                                              CSD012
     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK0        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK9        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK8        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK7        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK6        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK5        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK4        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK3        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK2        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK1        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     *LOCK         IN        LDA                                                        CSD012
     C                   Z-ADD     908           DBASE                                        CSD012
     C                   MOVEL     'SDSVALPD'    DBFILE                                       CSD012
     C                   MOVEL     'SDCUSDSIN'   DBPGM                                        CSD012
     C                   OUT       LDA                                                        CSD012
     C                   EXSR      *PSSR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If Customer Details Authorisation is On set to Authorise                             CSD012
     C     SVAL11        IFEQ      'Y'                                                        CSD012
     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           AUTHRQ                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
 E1  C                   ENDIF                                                                CSD012
                                                                                              CGP001
      ** Check if Global Data Layout Enhancement (CGP001) is on.                              CGP001
                                                                                              CGP001
     C                   EVAL      CGP001 = 'N'                                               CGP001
                                                                                              CGP001
     C                   CALLB     'AOSARDR0'                                                 CGP001
     C                   PARM      *BLANKS       @RTCD                                        CGP001
     C                   PARM      '*VERIFY'     @OPTN                                        CGP001
     C                   PARM      'CGP001'      @SARD                                        CGP001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGP001
                                                                                              CGP001
     C                   IF        @RTCD = *BLANKS                                            CGP001
     C                   EVAL      CGP001 = 'Y'                                               CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
     C                   IF        @RTCD <> *BLANKS and                                       CGP001
     C                             @RTCD <> '*NRF   '                                         CGP001
     C     *LOCK         IN        LDA                                                        CGP001
     C                   EVAL      DBKEY = 'CGP001'                                           CGP001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGP001
     C                   EVAL      DBASE = 908                                                CGP001
     C                   OUT       LDA                                                        CGP001
     C                   EXSR      *PSSR                                                      CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CLE025
      ** Check if enhancement CLE025 (Multi-Option Facilities) is on                          CLE025
                                                                                              CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE025
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBKEY  = 'CLE025'                                          CLE025
     C                   EVAL      DBASE  = 902                                               CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CFX001
      ** Check if enhancement CFX001 (FX Margin Trading) is on                                CFX001
                                                                                              CFX001
     C                   CALLB     'AOSARDR0'                                                 CFX001
     C                   PARM      *BLANKS       PRTCD                                        CFX001
     C                   PARM      '*VERIFY'     POPTN                                        CFX001
     C                   PARM      'CFX001'      PSARD                                        CFX001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFX001
                                                                                              CFX001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CFX001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFX001
     C                   EVAL      DBKEY  = 'CFX001'                                          CFX001
     C                   EVAL      DBASE  = 903                                               CFX001
     C                   EXSR      *PSSR                                                      CFX001
     C                   ENDIF                                                                CFX001
      *                                                                                       CFX001
     C                   IF        PRTCD = *BLANKS                                            CFX001
     C                   EVAL      CFX001 = 'Y'                                               CFX001
     C                   ELSE                                                                 CFX001
     C                   EVAL      CFX001 = 'N'                                               CFX001
     C                   ENDIF                                                                CFX001
                                                                                              CGP001
      ** Check if enhancement CSD028 (Know Your Customer) is on                               CSD028
                                                                                              CSD028
     C                   CALLB     'AOSARDR0'                                                 CSD028
     C                   PARM      *BLANKS       PRTCD                                        CSD028
     C                   PARM      '*VERIFY'     POPTN                                        CSD028
     C                   PARM      'CSD028'      PSARD                                        CSD028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD028
                                                                                              CSD028
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD028
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD028
     C                   EVAL      DBKEY = 'CSD028'                                           CSD028
     C                   EVAL      DBASE = 910                                                CSD028
     C                   EXSR      *PSSR                                                      CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
     C                   IF        PRTCD = *BLANKS                                            CSD028
     C                   EVAL      CSD028 = 'Y'                                               CSD028
     C                   ELSE                                                                 CSD028
     C                   EVAL      CSD028 = 'N'                                               CSD028
     C                   ENDIF                                                                CSD028
                                                                                              CSD028
      *                                                                                       CER001
      ** Check if ULX043 in ON                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX043'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX043'                                          CER001
     C                   EVAL      DBASE  = 910                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX043 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Do not process lux extension details when IBLC Returns                               CER001
      ** indicator is not set to 'Y'                                                          CER001
      *                                                                                       CER001
     C                   IF         BGNWST <> 'Y'                                             CER001
     C                   EVAL       ULX043 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX043 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y' AND BGNWST = 'Y'                              CER001
     C                   OPEN      SDCUX1L0                                                   CER001
     C                   OPEN      SDINX1L0                                                   CER001
     C                   OPEN      SDCTX2L0                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Check if ULX008 in ON                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX008'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX008'                                          CER001
     C                   EVAL      DBASE  = 911                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX008 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX008 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Check if ULX012 in ON                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX012'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX012'                                          CER001
     C                   EVAL      DBASE  = 912                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX012 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX012 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Check if ULX048 in ON                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX048'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX048'                                          CER001
     C                   EVAL      DBASE  = 913                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX048 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX048 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Check if ULX609 in ON                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX609'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX609'                                          CER001
     C                   EVAL      DBASE  = 914                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX609 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return                                 CER001
      ** indicator is not set to 'Y'                                                          CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX609 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX609 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX609 = 'Y' and BGLRIN = 'Y'                              CER001
     C                   OPEN      SDCUX2L0                                                   CER001
     C                   ENDIF                                                                CER001
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd   = 'CSW2007'                                        CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      *                                                                                     BUG13228
      ** Check if ULX004 in ON                                                              BUG13228
      *                                                                                     BUG13228
     C                   CALLB     'AOSARDR0'                                               BUG13228
     C                   PARM      *BLANKS       PRTCD                                      BUG13228
     C                   PARM      '*VERIFY'     POPTN                                      BUG13228
     C                   PARM      'ULX004'      PSARD                                      BUG13228
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG13228
                                                                                            BUG13228
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                BUG13228
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG13228
     C                   EVAL      DBKEY  = 'ULX004'                                        BUG13228
     C                   EVAL      DBASE  = 915                                             BUG13228
     C                   EXSR      *PSSR                                                    BUG13228
     C                   ENDIF                                                              BUG13228
      *                                                                                     BUG13228
     C                   IF        PRTCD = *BLANKS                                          BUG13228
     C                   EVAL      ULX004 = 'Y'                                             BUG13228
     C                   ELSE                                                               BUG13228
     C                   EVAL      ULX004 = 'N'                                             BUG13228
     C                   ENDIF                                                              BUG13228
      ***********                                                                 BUG26917 BUG26917A
      ***Check*if*CER048*is*ON*                                                   BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         CALLB     'AOSARDR0'                                     BUG26917 BUG26917A
     C**********         PARM      *BLANKS       PRTCD                            BUG26917 BUG26917A
     C**********         PARM      '*VERIFY'     POPTN                            BUG26917 BUG26917A
     C**********         PARM      'CER048'      PSARD                            BUG26917 BUG26917A
     C*****SCSARD        PARM      SCSARD        DSFDY                            BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '      BUG26917 BUG26917A
     C**********         EVAL      DBFILE = 'SCSARDPD'                            BUG26917 BUG26917A
     C**********         EVAL      DBKEY  = 'CER048'                              BUG26917 BUG26917A
     C**********         EVAL      DBASE  = 915                                   BUG26917 BUG26917A
     C**********         EXSR      *PSSR                                          BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         IF        PRTCD = *BLANKS                                BUG26917 BUG26917A
     C**********         EVAL      CER048 = 'Y'                                   BUG26917 BUG26917A
     C**********         ELSE                                                     BUG26917 BUG26917A
     C**********         EVAL      CER048 = 'N'                                   BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
      *                                                                                       CER001
     C     K@KEY1        KLIST                                                                CER001
     C                   KFLD                    KCUST                                        CER001
     C/COPY WNCPYSRC,SDH00489
      ** Check if CSD037 is enabled.                                                          CSD031
                                                                                              CSD031
     C                   CALLB     'AOSARDR0'                                                 CSD031
     C                   PARM      *BLANKS       PRtCd                                        CSD031
     C                   PARM      '*VERIFY'     POptn                                        CSD031
     C                   PARM      'CSD037'      PSARD                                        CSD031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD031
                                                                                              CSD031
     C                   IF        PRtCd = *BLANKS                                            CSD031
     C                   EVAL      CSD037 = 'Y'                                               CSD031
     C                   ELSE                                                                 CSD031
                                                                                              CSD031
     C                   IF        PRtCd <> '*NRF   '                                         CSD031
     C     *LOCK         IN        LDA                                                        CSD031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD031
     C                   EVAL      DBKey = 'CSD037'                                           CSD031
     C                   EVAL      DBase = 101                                                CSD031
     C                   OUT       LDA                                                        CSD031
     C                   EXSR      *PSSR                                                      CSD031
     C                   ENDIF                                                                CSD031
                                                                                              CSD031
     C                   ENDIF                                                                CSD031
                                                                                              CSD031
      ** Access Switchable Features file to determine whether                                LLN022A
      ** LLN022 (Bank of England) processing is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN022            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANK        PRTCD                                       LLN022A
     C                   PARM      '*VERIFY'     POPTN                                       LLN022A
     C                   PARM      'LLN022'      PSARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        PRTCD = *BLANK                                            LLN022A
     C                   MOVE      'Y'           LLN022                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                     MD022463
      ** Check if SWIFT 2013 is installed                                                   MD022463
      *                                                                                     MD022463
     C                   CALL      'SWIF2013'                                               MD022463
     C                   PARM      *BLANKS       PRtCd                                      MD022463
                                                                                            MD022463
     C                   IF        PRtCd   = 'CSW2013'                                      MD022463
     C                   EVAL      CSW213 = 'Y'                                             MD022463
     C                   ELSE                                                               MD022463
     C                   EVAL      CSW213 = 'N'                                             MD022463
     C                   ENDIF                                                              MD022463
      *                                                                                     MD022463
      ** Check if CFT050 in ON                                                              MD022463
      *                                                                                     MD022463
     C                   CALLB     'AOSARDR0'                                               MD022463
     C                   PARM      *BLANKS       PRtCd                                      MD022463
     C                   PARM      '*VERIFY'     POptn                                      MD022463
     C                   PARM      'CFT050'      PSard                                      MD022463
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD022463
                                                                                            MD022463
     C                   IF        PRtCd <> *BLANKS  AND  PRtCd <> '*NRF   '                MD022463
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD022463
     C                   EVAL      DBKEY  = 'CFT050'                                        MD022463
     C                   EVAL      DBASE  = 916                                             MD022463
     C                   EXSR      *PSSR                                                    MD022463
     C                   ENDIF                                                              MD022463
      *                                                                                     MD022463
     C                   IF        PRtCd = *BLANKS                                          MD022463
     C                   EVAL      CFT050 = 'Y'                                             MD022463
     C                   ELSE                                                               MD022463
     C                   EVAL      CFT050 = 'N'                                             MD022463
     C                   ENDIF                                                              MD022463
     C/COPY WNCPYSRC,SDCUSDSC06
      *
      * GO TO INITIAL SCREEN
      *
     C                   EXSR      INITIAL
      *
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUSDS013
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,SDCUSDSC23
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
