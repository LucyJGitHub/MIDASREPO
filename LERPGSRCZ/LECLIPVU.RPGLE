     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan details validate and update')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LECLIPVU - Customer loans validate and update                *
      *                                                               *
      *                                                               *
      *  Function: This Program Validates customer loans for          *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD056313           Date 21Sep20               *      
      *  Prev Amend No. MD053956           Date 29Oct19               *
      *                 MD036838A          Date 29Oct19               *
      *                 MD036838           Date 29Oct19               *
      *                 MD030274           Date 29Oct19               *
      *                 MD054028           Date 05Sep19               *
      *                 CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD053143           Date 04Apr19               *
      *                 MD052478           Date 15Jan19               *
      *                 MD052134           Date 18Oct18               *
      *                 MD034521A          Date 14Sep15               *
      *                 MD039547           Date 20Sep16               *
      *                 MD041649           Date 06Oct16               *
      *                 CLE168             Date 26Feb18               *
      *                 MD034643           Date 11Sep17               *
      *                 MD032110           Date 11Sep17               *
      *                 MD044880           Date 15Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD048478           Date 21Nov17               *
      *                 MD046969           Date 02Sep17               *
      *                 CLE141             Date 08Feb16               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 MD030621           Date 26Feb15               *
      *                 MD032052           Date 23Jan15               *
      *                 CLE164             Date 18Aug14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025521           Date 19Aug14               *
      *                 MD025619           Date 07Mar14               *
      *                 MD025009B          Date 12May14               *
      *                 MD023116           Date 24Apr14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD022807C          Date 15Oct13               *
      *                 MD022807           Date 11Oct13               *
      *                 AR868380           Date 19Jun13               *
      *                 MD020605           Date 05Jun13               *
      *                 MD020578           Date 24May13               *
      *                 AR1095041          Date 12Mar13               *
      *                 AR1076968A         Date 07Feb13               *
      *                 AR804863           Date 08Feb13               *
      *                 AR1078092          Date 20Jan13               *
      *                 AR1021983          Date 01Aug12               *
      *                 AR693137           Date 01Aug12               *
      *                 AR314017           Date 01Aug12               *
      *                 262461A            Date 01Aug12               *
      *                 262461             Date 01Aug12               *
      *                 AR634877           Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 AR746353A          Date 06Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG22318           Date 28Jan09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG21167           Date 25Sep08               *
      *                 256564             Date 17Sep08               *
      *                 255159A            Date 27Jun08               *
      *                 BUG16617           Date 01Mar08               *
      *                 247441             Date 20Jul07               *
      *                 247545             Date 09May07               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      *                 246342             Date 12Mar07
      *                 BUG13843           Date 02May07               *
      *                 244510             Date 28Feb07               *
      *                 245227             Date 27Feb07               *
      *                 245210             Date 12Jan07               *
      *                 241519             Date 05Sep06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11679           Date 05Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 BUG10574           Date 02Mar06               *
      *                 BUG10604           Date 02Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG8526            Date 27Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 10Feb03               *
      *                 CLE034             Date 05May03               *
      *                 CAS011             Date 16May05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG6108            Date 16Apr05               *
      *                 BUG6010            Date 30Mar05               *
      *                 BUG4685            Date 17Nov04               *
      *                 BUG4473            Date 06Oct04               *
      *                 CLE120             Date 09Aug04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 BUG2480            Date 26May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 TDA023             Date 24Feb04               *
      *                 BUG826             Date 23Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 196461             Date 22Aug03               *
      *                 CDE005             Date 23Sep02               *
      *                 CAP084  *CREATE    Date 22Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056313 - Settlement validated twice. Used placeholder for  *
      *             messages in first ZASETINVAL call                 *      
      *  MD053956 - Modified fix MD036838 by removing  checking of    *
      *             ##PPAY or ##PREC for warning message LEL0700/0701.*
      *  MD036838A - Move ZASETINVAL call to ensure that settlement   *
      *              will have correct values.                        *
      *            - Applied for MD053956.                            *
      *  MD036838 - Call ZASETINVAL for C_PAY to have similar details *
      *             with ##PAYS.                                      *
      *           - Applied for MD053956. Modified fix by removing    *
      *             checking of ##PPAY or ##PREC for error message    *
      *             LEL0700/LEL0701.                                  *
      *  MD030274 - If System Value LoanStartStlInsAmd = 'Y', do not  *
      *             pay settlement for LOAN or receipt settlement for *
      *             PTSO.  Patterned after 230526.                    *
      *           - Applied for MD053956.                             *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate                          *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD053143 - CLE141 Business Day Convention processing to be   *
      *             applied for loan start date rate fixing.          *
      *  MD052478 - Dump occur in LECLIPR due to parameter mismatch.  *
      *  MD052134 - Serious Midas Error Occurred when attempting to   *
      *             input a LE Particiapation Sold                    *
      *           - Applied for MD052132.                             *
      *  MD034521A - Error handling of Blocked account is not the     *
      *              same across the modules                          *
      *            - Block Accounts should not be dependent to CLE134 *
      *  MD039547 - Referred account is not properly validated.       *
      *  MD041649 - Validation during authorisation should be executed*
      *  CLE168 - Allow Debit of Blocked Account                      *
      *  MD034643 - Settlement branch not restored after reject. On   *
      *             reject, retrieve settlement details and convert   *
      *             screenfield shortname to file customer no.        *
      *           - Applied for MD-47150                              *
      *  MD032110 - Settlement receipt and payments were changed      *
      *             after reject of loan amendment. Retrieved 18      *
      *             characters starting at 4 from screen settlement   *
      *             fields if settlement method 05.                   *
      *           - Applied for MD-47150                              *
      *  MD044880 - BOE Switched On Testing and Fixing                *
      *  MD046248 - Finastra Rebranding                               *
      *  MD048478 - Cannot input auto settle = pre check order        *
      *  MD046969 - Inserted PDCL X and Y combined via SOAP or Manual *
      *             Input will leave the PDCL Y loan in WIP. Buffer is*
      *             returned without the @DEPI value misaligning the  *
      *             position for the Auto-Auth field.                 *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions                                *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *           /COPY members and add switchability.                *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Core hooks amended:LECLIPDTA,LECLIPVC01,            *
      *                              LECLIPVC02,LECLIPVC03,           *
      *                              LECLIPVC04,LECLIPVC05            *
      *  MD030621 - Pass @DEPI (Decrease Principal indicator) for PDCL*
      *  MD032052 - Unable to authorize loan repaired from repair     *
      *             queue. Enhance MD031225 to bypass validation of   *
      *             loan number if record come from COB.              *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           Reverse fix AR314017 due to LEACCNPD being redundant*
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025521 - Recompile due to changes on LECLI2PD.             *
      *  MD025619 - No validation for Pay Our Account for blocked     *
      *             debits and credits                                *
      *  MD025009B - API returned a Serious midas error has occurred  *
      *  MD023116 - Incorrect error message in RONS field             *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD022807C - Additional validation delivered by MD022807      *
      *              no longer required                               *
      *  MD022807 - Additional validation for PDCL Maturity Date      *
      *             amendment                                         *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  MD020605 - CLE134 Impossible to create PDCL in IC            *
      *  MD020578 -  Cannot authorise WIP record. Status is neither   *
      *              complete nor requesting re-authorisation         *
      *  AR1095041 - Midas error in CLIP due to CPF4293 error in      *
      *              LEPDUELB file                                    *
      *  AR1076968A - System did not generate PDCL fees for unpaid    *
      *               portion of Fee due                              *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  AR1078092 - Event Code of 45021706 (settlement account is    *
      *              (blocked) is not user configurable               *
      *  AR1021983 - [PDP] Option C - Technical Enhancements Stated   *
      *              in POC                                           *
      *  AR693137 - If pre-deal check is defined, Receipt/Pay settle- *
      *             ment should be equal to 01, 05, 08 and 14.        *
      *             Enhancement of AR634878/A. (Child: AR693138)      *
      *  AR314017 - LEC0459 failed in COB # 10 in BB                  *
      *             CLOAN (Child: AR314018)                           *
      *  262461A- PDCL (Recompile)                                    *
      *  262461 - PDCL (Recompile)                                    *
      *  AR634877 - Component LEC0459 failed in COB                   *
      *           - AUTO cannot be 'C' if both settlement methods are *
      *             '00'.                                             *
      *             (Child: AR634878)                                 *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - CCR016: Settlement Allocation                      *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding                              *
      *  AR746353A - System Error Occured in CLIP                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting ß24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  BUG22318 - Risk Participation loans with recourse are not    *
      *             allowed (Recompile)                               *
      *  BUG21167 - No generation of MT103, 202 and 210               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255159A - Re-instate part of fix commented out by 247545 for *
      *           pay settlement.  Correct fix is to protect the field*
      *           on JAVA when loan has started (same with R4).       *
      *  BUG16617 - Attempt to divide by zero while calculating       *
      *             repayment amount for repayment type 3. Do not     *
      *             calculate if effective interest rate is zero      *
      *             (Recompile)                                       *
      *  247441 - Additional parameter for LECLIP1VL                  *
      *  247545 - Move new values to VALIDCLIL when amending an       *
      *           existing loan.                                      *
      *  245273 - Added parameter to LECLIPRTV and LECLIPUPD call.    *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  246342 - *RECUP must not commit changes But Rollback updates *
      *           ==> avoid *PSSR after Rollback                      *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  244510 - Validate first loan details before defaulting       *
      *           settlement instructions.                            *
      *  245227 - Added fields WAUTOA & WAUTOY to LECLIP1VL, LECLIPUPD*
      *  245210 - User should not be able to reopen matured           *
      *           participant loan                                    *
      *  241519 - Check System Value LoanCustOriginPurch to decide if *
      *           original borrower or Purchased From customer should *
      *           should be use to validate Settlement Type 04 on     *
      *           Parts Purchased.                                    *
      *  BUG11679 - Additional Conversion of Customer Number to Alpha *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  BUG10574 - Recompiled due to changes in LECLI4PD.            *
      *  BUG10604- UNLOCK record locking for PTPF.                    *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG8526- Facility Currency Exchange Rate should be used, if  *
      *           entered, in the calculation of the Facility         *
      *           Repayment amount.                                   *
      *  CLE106 - Syndications Manager. Amended to show UTN fields.   *
      *  CLE031 - Lending Enhancements.                               *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG6108-  Allow manual entry of loan numbers                 *
      *  BUG6010 - Allow Amendment of the value date settlement if    *
      *            the loan has passed value date.  Display Warning   *
      *            message instead of an error message.               *
      *  BUG4685 - Unable to authorise transaction because WIP do     *
      *            not have correct data.                             *
      *  BUG4473 - Error in validating a closed payment account when  *
      *            authorising loan                                   *
      *  CLE120 - Core changes for GBO020                             *
      *         - Debt Classification by Assets                       *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:LECLIPXD01,LECLIPXC01,LECLIPXC02,  *
      *                            LECLIPXC03,LECLIPXC04              *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  BUG2480 - Send the reservation id to the back end            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *  BUG826 - Missing CAS00x changes                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  196461 - Validation of settlement shall not be done when     *
      *           Receipt and/or Payment are protected.               *
      *  CDE005   Reservation ID                                      *
      *  CAP084 - Midas Plus API development                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
     FFCLTY     IF   E           K DISK                                                       CLE031
     F                                     PREFIX(FC)                                         CLE031
     F                                     IGNORE(FCLTYHHF)                                   CLE031
     F                                     IGNORE(FCLTYFNF)                                   CLE031
     F                                     IGNORE(FCLTYZZF)                                   CLE031

     F***LEACCNL5  IF   E           K DISK                                           AR314017 CLE164
     F**********                           PREFIX(@@)                                AR314017 CLE164
     FLEFCLTLH  IF   E           K DISK    INFSR(*PSSR)                                       CLE168
     F                                     PREFIX(C_)                                         CLE168

      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
                                                                                           AR1095041
      ** Array for LEPDUELB override                                                       AR1095041
     D PCMD            S             50A   DIM(2) CTDATA PERRCD(1)                         AR1095041
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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+

      ** Array of Fields in error.                                                           BUG4685
     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG4685
                                                                                             BUG4685
      ** Array of error message IDs                                                          BUG4685
     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG4685
     D                                     LIKE(#MsgID)                                      BUG4685
                                                                                             BUG4685
      ** Array of error message data.                                                        BUG4685
     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG4685
     D                                     LIKE(#MsgData)                                    BUG4685
                                                                                             BUG4685
      ** Array of message files to check                                                     BUG4685
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG4685
                                                                                             BUG4685
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+

      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+

      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+

      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(LECLI1PD)
     D TranInSeco    E DS                  EXTNAME(LECLI2PD)
     D TranInThir    E DS                  EXTNAME(LECLI3PD)
     D TranInFour    E DS                  EXTNAME(LECLI4PD)
     D TranInFive    E DS                  EXTNAME(LECLI5PD)                                  CLE106
     D TranInSix     E DS                  EXTNAME(LECLI6PD)                               AR1021983
     D TranInSeven   E DS                  EXTNAME(LECLI7PD)                                  CLE141
     D TranInExt     E DS                  EXTNAME(LESTMP2PD)                                 CER049
     D                                     PREFIX(Q)                                          CER049

      * Valid Customer Loans CL layout
     D ValidClil     E DS                  EXTNAME(LEVCLILPD)
     D                                     PREFIX(VL_)
     D***ValidREC             459    527                                                      CGL029
     D***ValidPAY             528   1086                                                      CGL029
     D  ValidREC             473    527                                                       CGL029
     D  ValidPAY             542   1086                                                       CGL029
     D***ValidRECEx          1579   1596                                               CGL029 TDA023
     D***ValidPAYEx          1597   1614                                               CGL029 TDA023
     D  ValidRECEx          1597   1614                                                       TDA023
     D  ValidPAYEx          1615   1632                                                       TDA023

      * Valid Customer Loans CK layout
     D ValidClik     E DS                  EXTNAME(LEVCLIKPD)
     D                                     PREFIX(VK_)
      ** Customer Loans Valid Extension Files                                                 CER001
     D ValidCLIPEx   E DS                  EXTNAME(LEVCLLX1PD)                                CER001
                                                                                              CER001
      ** Customer Loans Extension Files                                                       CER001
     D CLIPExFilFmt  E DS                  EXTNAME(LECLX1PD)                                  CER001

      * (Current) Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
     D***ClipFilREC           459    527                                                      CGL029
     D***ClipFilPAY           528   1086                                                      CGL029
     D  ClipFilREC           473    527                                                       CGL029
     D  ClipFilPAY           542   1086                                                       CGL029
     D  ClipFilRECEx        1597   1614                                                       CGL029
     D  ClipFilPAYEx        1615   1632                                                       CGL029

      * (Current) Customer Loans record CK in file Format
     D ClikFilFmt    E DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(CK_)

      * (Current) Customer Loans in Screen Format - Primary Details
     D CurClPrim     E DS                  EXTNAME(LECLI1PD)
     D                                     PREFIX(@)
      * (Current) Customer Loans in Screen Format - Secondary Details
     D CurClSeco     E DS                  EXTNAME(LECLI2PD)
     D                                     PREFIX(@)
      * (Current) Customer Loans in Screen Format - Third Details
     D CurClThir     E DS                  EXTNAME(LECLI3PD)
     D                                     PREFIX(@)
      * (Current) Customer Loans in Screen Format - Fourth Details
     D CurClFour     E DS                  EXTNAME(LECLI4PD)
     D                                     PREFIX(@)

      * (Current) Customer Loans in Screen Format - Sixth Details                             CLE134
     D CurClSix      E DS                  EXTNAME(LECLI6PD)                                  CLE134
     D                                     PREFIX(@)                                          CLE134

     D CurClSeven    E DS                  EXTNAME(LECLI7PD)                                  CLE141
     D                                     PREFIX(@)                                          CLE141

     D ClExtFilFmt   E DS                  EXTNAME(BYLOANX0)                                MD044880
     D                                     PREFIX(@)                                        MD044880

      * Error indicators
     D OKClPrim      E DS                  EXTNAME(LEECLI1PD)
     D OKClSeco      E DS                  EXTNAME(LEECLI2PD)
     D OKClThir      E DS                  EXTNAME(LEECLI3PD)
     D OKClFour      E DS                  EXTNAME(LEECLI4PD)
     D OKClSix       E DS                  EXTNAME(LEECLI6PD)                                 CLE134
     D OKClSeven     E DS                  EXTNAME(LEECLI7PD)                                 CLE141
      ** LE Customer Loans LUX Error Definition                                               CER001
     D OKCLEXFlgs    E DS                  EXTNAME(LEECLLX1PD)                                CER001


      * File Receive instructions
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029

      * File Payment instructions
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029

      * File Fra/irs instructions
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)

      * Screen Receive instructions
     D ##RECS        E DS                  EXTNAME(SDESSRPD)

      * Screen Payment instructions
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)

      * Screen Fra/irs instructions
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)

      * Curent Screen Receive instructions
     D C_REC         E DS                  EXTNAME(SDESSRPD) PREFIX(C_)

      * Current Screen Payment instructions
     D C_PAY         E DS                  EXTNAME(SDESSPPD) PREFIX(C_)

      * FRA/IRS Settlement Instructions - Current
     D C_FRA         E DS                  EXTNAME(SDESSFPD) PREFIX(C_)

     D C_EXTDATA     E DS                  EXTNAME(LECLEXPD) PREFIX(C_)                     MD044880
                                                                                            MD044880
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  247545
     D PCust           S             10                                                       247545
     D PStKey          S              7                                                       247545
                                                                                              247545
      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
     D OKPayInsDS      DS
     D  DDPscyOK                      1A   INZ('Y')
     D  DDPstmOK                      1A   INZ('Y')
     D  DDPonxOK                      1A   INZ('Y')
     D  DDRvnoOK                      1A   INZ('Y')
     D  DDCvmrOK                      1A   INZ('Y')
     D  DDPocnOK                      1A   INZ('Y')
     D  DDPobnOK                      1A   INZ('Y')
     D  DDRcrnOK                      1A   INZ('Y')
     D  DDRcraOK                      1A   INZ('Y')
     D  DDPibnOK                      1A   INZ('Y')
     D  DDPibaOK                      1A   INZ('Y')
     D  DDAwbnOK                      1A   INZ('Y')
     D  DDAwbaOK                      1A   INZ('Y')
     D  DDBennOK                      1A   INZ('Y')
     D  DDBenaOK                      1A   INZ('Y')
     D  DDDtp1OK                      1A   INZ('Y')
     D  DDDtp2OK                      1A   INZ('Y')
     D  DDDtp3OK                      1A   INZ('Y')
     D  DDDtp4OK                      1A   INZ('Y')
     D  DDDchgOK                      1A   INZ('Y')
     D  DDIc72OK                      1A   INZ('Y')
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')
     D  DDPmacOK                      1A   INZ('Y')                                           CLE031
     D  DDPexrOK                      1A   INZ('Y')                                           CLE031
     D  DDPexiOK                      1A   INZ('Y')                                           CLE031

      ** Flags to indicate whether Receive Settlement instruction fields
      **  are valid
     D OKRecInsDS      DS
     D  DDRscyOK                      1A   INZ('Y')
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')
     D  DDRmacOK                      1A   INZ('Y')                                           CLE031
     D  DDRexrOK                      1A   INZ('Y')                                           CLE031
     D  DDRexiOK                      1A   INZ('Y')                                           CLE031

      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKFRAInsDS      DS
     D  DDDsr1OK                      1A   INZ('Y')
     D  DDDsr2OK                      1A   INZ('Y')
     D  DDDsr3OK                      1A   INZ('Y')
     D  DDDsr4OK                      1A   INZ('Y')
     D  DDDsr5OK                      1A   INZ('Y')
     D  DDDsr6OK                      1A   INZ('Y')
     D  DDSsr1OK                      1A   INZ('Y')
     D  DDSsr2OK                      1A   INZ('Y')
     D  DDSsr3OK                      1A   INZ('Y')
     D  DDSsr4OK                      1A   INZ('Y')
     D  DDSsr5OK                      1A   INZ('Y')
     D  DDSsr6OK                      1A   INZ('Y')
     D  DDCnd1OK                      1A   INZ('Y')
     D  DDCnd2OK                      1A   INZ('Y')
     D  DDCnd3OK                      1A   INZ('Y')
     D  DDCnd4OK                      1A   INZ('Y')
     D  DDCnd5OK                      1A   INZ('Y')
     D  DDCnd6OK                      1A   INZ('Y')
     D  DDIsdaOK                      1A   INZ('Y')
     D  DDAgtyOK                      1A   INZ('Y')
     D  DDAgdtOK                      1A   INZ('Y')
     D  DDAgvvOK                      1A   INZ('Y')

     D  DataOldRcd     DS           500
      * Fields used in setting confirmation indicators (old record)

     D  OMDAT                  1      5  0
     D  ONIDT                  6     10  0
     D  ONRPD                 11     15  0
     D  OIFDY                 16     17  0
     D  OIPFR                 18     18
     D  ORDYN                 19     20  0
     D  ORFRQ                 21     21
     D  ORAMT                 22     34  0
     D  OSDST                 35     36  0
     D  STNOSX                37     38
     D**OOSDA***              37     48                                                       CGL029
     D  QQOSD1                37     48                                                       CGL029
     D  OTSTN                 49     58
     D  OFACO                 59     68
     D  OSPI1                 69     98
     D  OSPI2                 99    128
     D  OSPI3                129    158
     D  OSPI                  69    158
     D  OMDST                159    160  0
     D  MTNOSX               161    162
     D**OOMDA***             161    172                                                       CGL029
     D  QQOMD1               161    172                                                       CGL029
     D  OTMAN                173    182
     D  MATYX                159    182
     D  OINTR                183    193  7
     D  ORLDT                194    198  0
     D  ORLFQ                199    199
     D  ORLDY                200    201  0
     D  OOSDA                202    219                                                       CGL029
     D  OOMDA                220    237                                                       CGL029
     D  CONF1                  1     34
     D  LINK1                  6     34
     D  CONF2                 35    158
     D  LINK2                183    201

     D  DataNewRcd     DS           500
      * Fields used in setting confirmation indicators (new record)

     D  WSVMD                  1      5  0
     D  WSVID                  6     10  0
     D  WSVRP                 11     15  0
     D  WIFDY                 16     17  0
     D  SIPFR                 18     18
     D  WRDYN                 19     20  0
     D  SRFRQ                 21     21
     D  WSVRA                 22     34  0
     D  WSDST                 35     36  0
     D  STNOS                 37     38
     D**WOSDA***              37     48                                                       CGL029
     D  QQOSD2                37     48                                                       CGL029
     D  WTSTN                 49     58
     D  WFACO                 59     68
     D  DDSPI1A               69     98
     D  DDSPI2A               99    128
     D  DDSPI3A              129    158
     D  DDSPI                 69    158
     D  WMDST                159    160  0
     D  MTNOS                161    162
     D**WOMDA***             161    172                                                       CGL029
     D  QQOMD2               161    172                                                       CGL029
     D  WTMAN                173    182
     D  WREC                 159    182
     D  WINTT                183    193  7
     D  WSVRD                194    198  0
     D  SRLFQ                199    199
     D  WRLDY                200    201  0
     D  WOSDA                202    219                                                       CGL029
     D  WOMDA                220    237                                                       CGL029
     D  CONFS1                 1     34
     D  LINKS1                 6     34
     D  CONFS2                35    158
     D  LINKS2               183    201

     D  TransData      DS           500
      * Shared data

     D  WLNPT                  1      2  0
     D  W72TP                  3      4
     D  BASER                  5     15  7
     D  WSVBX                 16     28  8
     D  WBMIN                 29     29
     D  WSVDD                 30     34  0
     D  WSVVD                 35     39  0
     D  WSVAM                 40     52  0
     D  WSVRS                 53     63  7
     D**FCUSM***              64     69  0                                                  BUG11679
     D  FCUSM                 64     69                                                     BUG11679
     D  FTYPM                 70     72  0
     D  FSEQM                 73     74  0
     D  FCXRM                 75     87  8
     D  FMDIM                 88     88
     D  ORBRM                 89     91
     D  CRSKM                 92     93
     D**LINDM***              94     96                                                       CER020
     D  LOICM                 94     96                                                       CER020
     D  PRFCM                 97    100
     D  ACOFM                101    102
     D  FCCYM                103    105
     D  FCLBM                106    108
     D  MCRAM                109    109
     D  PTYPM                110    111  0
     D  RLDTM                112    116  0
     D  NBRAM                117    118  0
     D  NCASM                119    119  0
     D  NCHIM                120    120
     D  NCCYM                121    123
     D  NFCEM                124    136  8
     D  NFMDM                137    137
     D  NBCEM                138    150  8
     D  NBMDM                151    151
     D  CNUMM                152    157
     D  BRCAM                158    160
     D  CCYM                 161    163
     D  CPAMM                164    176  0
     D  DDATM                177    181  0
     D  VDATM                182    186  0
     D  MDATM                187    191  0
     D  PSAMM                192    204  0
     D  WSVFX                205    217  8
     D  WFMIN                218    218
     D  FCCYF                219    221
     D  WLPFI                222    222
     D  WPASI                223    223
     D**WPTFC***             224    229  0                                                  BUG11679
     D  WPTFC                224    229A                                                    BUG11679
     D  WPTFT                230    232  0
     D  WPTFN                233    234  0
     D  WACEI                235    235
     D  WCBLI                236    236
     D  WORMD                237    241  0
     D  WORTI                242    254  0
     D  WSVMG                255    261  5
     D  WSVWT                262    272  7
     D  WOSDB                273    275
     D  WOMDB                276    278
     D  W#OIDT               279    283  0
     D  WTOTI                284    296  0
     D  WPTFR                297    300
     D  WFSRP                301    311  7
     D  WSVFA                312    324  0
     D  NBDPM                325    325  0
     D  WSVCN                326    331
     D  WRISP                332    332
     D  NYET                 333    333
     D  WFLAG                334    334
     D  WCDPL                335    335  0
     D  WCDPF                336    336  0
     D  WSVTX                337    338  0
     D  WTXND                339    340  0
     D  S#ICBS               341    341  0
     D  WSVRAM               342    354  0
     D  WSVRAP               355    367  0
     D  W@FCRA               368    382
     D  W@RAMT               383    397
     D  W#CCY                398    400
     D  W#FCY                401    403
     D  WSVAM2               404    416  0
     D  WSVIN                417    417
     D  WSVRT                418    430  8
     D  W@NRPD               431    435  0
     D  ACOFF                436    437
     D  SYINF                438    438
     D  WAGENT               439    444
     D**ANUM****             445    450  0                                                  BUG11679
     D**CNUMF***             451    456  0                                                  BUG11679
     D**PMFC****             457    462  0                                                  BUG11679
     D  ANUM                 445    450                                                     BUG11679
     D  CNUMF                451    456                                                     BUG11679
     D  PMFC                 457    462                                                     BUG11679
     D  W#SYCU               463    468
     D  WPTYP                469    470  0
     D**WLIND***             471    473                                                       CER020
     D  WLOIC                471    473                                                       CER020
     D  CRSKF                474    475
     D  WCHGA                476    488  0                                                   BUG3721
     D  WLCCD                489    491                                                      BUG3721
     D  WPRCS2               492    492                                                      BUG3721

     D PDATA           DS          1024                                                       CER001
     D  #1LNRF                 1      6                                                       CER001
     D  #1CUST                 7     12                                                       CER001
     D  #1PTYP                13     14                                                       CER001
     D  #1CCY                 15     17                                                       CER001
     D  #1AMNT                18     32S 0                                                    CER001
      *                                                                                       CLE168
     D LEFCLY        E DS                  EXTNAME(LEFCLYPP) DTAARA                           CLE168
     D                                     PREFIX(A_)                                         CLE168
      *                                                                                       CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
      *                                                                                       CSC022
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * EXTERNAL DS FOR MIDAS MODULES DETAILS
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SDLENO        E DS                  EXTNAME(SDLENOPD)
      ***  Loan number ranges file
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      ***  Loan type/subtype details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
      *                                                                                     MD034643
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                MD034643
      ** External DS for Nostro Account                                                     MD034643
      *                                                                                     MD034643
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                 MD034643
     D                                     PREFIX(AC_)                                      MD034643
      ** External DS for Retail Account                                                     MD034643
      *                                                                                     MD034643
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** Interface Data Format Definition File format                                         CAP086

     D ExtData       E DS                  EXTNAME(LECLEXPD)
      * LE Loans details Extra Data - File (D/B) format
     D RegData       E DS                  EXTNAME(LECLRXPD)                                  CER001
     D                                     PREFIX(LR)                                         CER001
      *                                                                                       CER001
      ** Regional data in file format                                                         CER001
      *                                                                                       CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      * 24X7 status dataarea

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      * SD data area
      ** +--------------------------------------+                                             CSC022
      **   Use of Indicator                                                                   CSC022
      **   ================                                                                   CSC022
      ** ¶                                      ¶                                             CSC022
      ** ¶ 17      Used by LOOKUP               ¶                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022

      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      ** Work variables                          r                                            241519
     D WPARM           S             20A   INZ('LoanCustOriginPurch')                         241519
     D WPARM2          S             20A   INZ('PDCLBlockDebit')                           AR1078092
     D WPARM3          S             20A   INZ('LoanStartStlInsAmd')                        MD030274
     D WBLKACCT        S              1A                                                   AR1078092
     D WMSGID          S              7A                                                   AR1078092
     D WX0             S              3P 0                                                 AR1078092
     D WX1             S              3P 0                                                 AR1078092
     D WX2             S              3P 0                                                 AR1078092
     D WX3             S              3P 0                                                 AR1078092
     D WX4             S              3P 0                                                  MD025619

      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      * Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
     D Trans5004       S            500A
     D Trans5005       S            500A
     D Trans5006       S            500A
     D Trans5007       S            500A                                                      CLE141
     D TransQ          S            500A                                                      CER049
                                                                                              CAP086
     D InfData500      S            500A                                                      CAP086
      ** Field (500A) to receive the incoming Interface Data                                  CAP086

      ** Field (500A) to receive the incoming Regional Data                                   CER001
     D RegData500      S            500A                                                      CER001
      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      * Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indices for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A

      ** Timestamp for the transaction
     D TimeStamp       S               Z


     D CSC011          S              1A   INZ('N')
     D CAP086          S              1A   INZ('N')                                           CAP086
     D CLE106          S              1A   INZ('N')                                           CLE106
     D CLE031          S              1A   INZ('N')                                           CLE031
     D TRANSDTL        S           5800A
     D***PDealNo         S             18A                                                    CGL029
     D***PADealNo        S             18A                                                    CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D*PLoanNum*       S              6S 0                                             CER001 CLE148
     D PLoanNum        S              6A                                                      CLE148
     D PFind           S              1A                                                      CER001
     D ULX004          S              1A                                                      CER001

     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')

      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   inz('N')
     D RepSeco         S              1A   inz('N')
     D RepThir         S              1A   inz('N')
     D RepFour         S              1A   inz('N')
      * Asset code and health code                                                            CLE120
     D SASCD           S              4                                                       CLE120
     D SHLCD           S              4                                                       CLE120
      * Work Fields                                                                           CLE031
     D KFCUS           S                   LIKE(FCCNUM)                                       CLE031
     D KFACT           S                   LIKE(FCFACT)                                       CLE031
     D KFCNO           S                   LIKE(FCFCNO)                                       CLE031
     D KRCTP           S                   LIKE(FCRCTP)                                       CLE031
     D WFPCRF          S                   LIKE(FCPCRF)                                       CLE031
     D WLPCRF          S                   LIKE(FCPCRF)                                       CLE031
     D WKMCCY          S                   LIKE(FCMCCY)                                       CLE031
     D ZFIELD          S             16                                                       CLE106
     D ZADEC           S              1  0                                                    CLE106
     D WCustomer       S             10                                                      CSF011A
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
     D WSETP           S              2  0                                                  MD034643
     D WOSAC           S             21A                                                    MD034643
     D WOSBR           S              3                                                     MD034643
     D WSCCY           S              3                                                     MD034643
     D W#FRNT          S              8A                                                   AR1021983
     D PCMDLEN         S             15  5                                                 AR1095041
                                                                                             CSF011A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+

      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
     D/COPY WNCPYSRC,LECLIPXD01
      *                                                                                      LLN022A
     D ValidBoe      E DS                  EXTNAME(LEVCLIPX0)                                LLN022A
     D OKBOEFlags    E DS                  EXTNAME(LEECLIPX0)                                LLN022A
     D                                     PREFIX(OF_)                                       LLN022A
      *                                                                                       LLN022
     D/COPY QWINDSRC,LECLIPDTA                                                                LLN022

      ** Placeholder for ZASETINVAL
     D   IdxHld        S                   LIKE(Idx)                                        MD056313
     D   FldNamHld     S                   LIKE(FldNameArr)                                 MD056313
     D   MsgIdArrHld   S                   LIKE(MsgIdArr)                                   MD056313
     D   WIdxHld       S                   LIKE(WIdx)                                       MD056313
     D   WFldNamHld    S                   LIKE(WFldNamArr)                                 MD056313
     D   WMsgIdArrHld  S                   LIKE(WMsgIdArr)                                  MD056313
     D   WMsgDtaArrHl  S                   LIKE(WMsgDtaArr)                                 MD056313
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+


      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInPrim
     C                   MOVEL     Trans5002     TranInSeco
     C                   MOVEL     InfData500    InfData                                      CAP086
     C                   MOVEL     Trans5003     TranInThir
     C                   MOVEL     Trans5004     TranInFour
     C                   MOVEL     Trans5005     TranInFive                                   CLE106
     C                   MOVEL     Trans5006     TranInSix                                 AR1021983
     C                   MOVEL     Trans5007     TranInSeven                                  CLE141
      ** DDOFCU should be override by DDCUST and saved in CLOANCL.OFCU                    AR1076968A
     C                   MOVEL     APFOTRANID    W#FRNT                                   AR1076968A
     C                   IF        CLE134 = 'Y'                                           AR1076968A
     C                             AND W#FRNT = 'LE000473'                                AR1076968A
     C                   EVAL      DDOFCU = DDCUST                                        AR1076968A
     C                   ENDIF                                                            AR1076968A
     C                   MOVEL     TransQ        TranInExt                                    CER049
     C/COPY WNCPYSRC,LECLIPXC04
     C                   MOVEL     Extdata500    Extdata
      ** ExtData Buffer Pointer                                                             MD054028
     C                   Z-ADD     1             eBfp              4 0                      MD054028
     C                   MOVEL     'LECLEXPD'    Filename                                   MD054028
     C                   EXSR      GETRCDLN                                                 MD054028
     C                   ADD       RecordLen     eBfp                                       MD054028
      ** CER050 Fields                                                                      MD054028
     C                   IF        CER050 = 'Y'                                             MD054028
     C                   EVAL      DDAPRC = %SUBST(Extdata500:eBfp:1)                       MD054028
     C                   ADD       1             eBfp                                       MD054028
     C                   EVAL      DDPREM = %SUBST(Extdata500:eBfp:15)                      MD054028
     C                   ADD       15            eBfp                                       MD054028
     C                   EVAL      DDAPRR = %SUBST(Extdata500:eBfp:8)                       MD054028
     C                   ADD       8             eBfp                                       MD054028
     C                   ENDIF                                                              MD054028
     C                   MOVEL     RegData500    RegData                                      CER001

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      ** if DDLSTS = 'M'or 'R' (Mature or Reverse) and action code 'A'                        245210
      ** then no further Processing.                                                          245210
                                                                                              245210
     C                   IF        DDLSTS = 'MATURED        ' OR                              245210
     C                             DDLSTS = 'REVERSED       ' AND                             245210
     C                             DDACTN = 'A'                                               245210
     C                   IF        DDLSTS = 'MATURED        '                                 245210
     C                   ADD       1             Idx                                          245210
     C                   EVAL      FldNameArr(Idx) = 'DDLRNF'                                 245210
     C                   MOVEL     'LEL0041'     MsgIdArr(Idx)                                245210
     C                   ENDIF                                                                245210
                                                                                              245210
     C                   IF        DDLSTS = 'REVERSED       '                                 245210
     C                   ADD       1             Idx                                          245210
     C                   EVAL      FldNameArr(Idx) = 'DDLRNF'                                 245210
     C                   MOVEL     'LEL0040'     MsgIdArr(Idx)                                245210
     C                   ENDIF                                                                245210
                                                                                              245210
     C                   ENDIF                                                                245210
                                                                                              245210
     C                   IF        Idx <> 0                                                   245210
     C                   GOTO      INVALID                                                    245210
     C                   ENDIF                                                                245210
                                                                                              245210
      *  Validate Action Code

     C                   EXSR      ValidateAc
      *

      *  If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      *  Processing depends upon Action Code

     C                   SELECT
     C
     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
     C**********         EXSR      DftSettmts                                                 244510
     C                   EXSR      ValidateTr
     C                   If        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *                                                                                       LLN022
      ** If BOE installed, validate fields.                                                  LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   MOVE      VL_CLLNRF     BYLNRF                                      LLN022A
     C                   MOVE      VL_CLMDAT     BYMDTE                                      LLN022A
     C                   MOVE      DDMDAT        BYMDAT                                      LLN022A
      *                                                                                      LLN022A
      ** Call Validation Module                                                              LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LECLIPVAL1'                                              LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
     C                   PARM                    ExtData                                     LLN022A
     C                   PARM                    BJDFIN                                      LLN022A
     C                   PARM                    OKBOEFlags                                  LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
     C                   PARM                    Idx                                         LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
     C                   PARM                    WIdx                                        LLN022A
     C                   PARM                    ValidBoe                                    LLN022A
      *                                                                                      LLN022A
      ** If error occured, go to INVALID                                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        Idx <> 0                                                  LLN022A
     C                   GOTO      INVALID                                                   LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   EXSR      DftSettmts                                                 244510
     C                   EXSR      ValidateSt

     C                   WHEN         DDACTN = 'A'
      *  Processing for Amends or Changes
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateTr
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     CLE106        OREQ      'Y'                                                        CLE106
     C                   MOVEL     DDFCUS        KFCUS                                        CLE031
     C                   MOVEL     DDFTYP        KFACT                                        CLE031
     C                   MOVEL     DDFSEQ        KFCNO                                        CLE031
     C                   EXSR      LEFCLTY                                                    CLE031
     C                   EVAL      WKMCCY = FCMCCY                                            CLE031
     C                   EVAL      DDFCCY = FCFCCY                                            CLE031
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   EVAL      DDLUTN = CL_PCRF                                           CLE106
     C                   IF        LoanType = 'PTSO'                                          CLE106
     C                   EVAL      DDFUTN = *Blanks                                           CLE106
     C                   ELSE                                                                 CLE106
     C                   EVAL      DDFUTN = FCPCRF                                            CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE031
     C                   If        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *                                                                                       LLN022
      ** If BOE installed, validate fields.                                                  LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   MOVE      VL_CLLNRF     BYLNRF                                      LLN022A
     C                   MOVE      VL_CLMDAT     BYMDTE
     C                   MOVE      DDMDAT        BYMDAT                                      LLN022A
      *                                                                                      LLN022A
      ** Call Validation Module                                                              LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LECLIPVAL1'                                              LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
     C                   PARM                    ExtData                                     LLN022A
     C                   PARM                    BJDFIN                                      LLN022A
     C                   PARM                    OKBOEFlags                                  LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
     C                   PARM                    Idx                                         LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
     C                   PARM                    WIdx                                        LLN022A
     C                   PARM                    ValidBoe                                    LLN022A
      *                                                                                      LLN022A
      ** If error occured, go to INVALID                                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        Idx <> 0                                                  LLN022A
     C                   GOTO      INVALID                                                   LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   EXSR      ValidateSt

     C                   WHEN         DDACTN = 'X' OR DDACTN = 'Q'
      *  Processing for Authorize or Release
     C                   EXSR      SetupAmd                                                 MD052134
     C                   EVAL      ExtData = C_EXTDATA                                      MD052134
     C                   EXSR      ValidateTr
     C                   If        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
     C**********         EXSR      SetupAmd                                        MD044880 MD052134
     C**********         EVAL      ExtData = C_EXTDATA                             MD044880 MD052134
      *                                                                                       LLN022
      ** If BOE installed, validate fields.                                                  LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   MOVE      VL_CLLNRF     BYLNRF                                      LLN022A
     C                   MOVE      VL_CLMDAT     BYMDTE
     C                   MOVE      DDMDAT        BYMDAT                                      LLN022A
      *                                                                                      LLN022A
      ** Call Validation Module                                                              LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LECLIPVAL1'                                              LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
     C                   PARM                    ExtData                                     LLN022A
     C                   PARM                    BJDFIN                                      LLN022A
     C                   PARM                    OKBOEFlags                                  LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
     C                   PARM                    Idx                                         LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
     C                   PARM                    WIdx                                        LLN022A
     C                   PARM                    ValidBoe                                    LLN022A
      *                                                                                      LLN022A
      ** If error occured, go to INVALID                                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        Idx <> 0                                                  LLN022A
     C                   GOTO      INVALID                                                   LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   EXSR      ValidateSt
     C                   WHEN      DDACTN = 'R' AND CL_VDAT < BJRDNB                         BUG6010
     C                             AND CL_ORED < BJRDNB                                      BUG6010
     C                   EXSR      SetupAmd                                                  BUG6010
     C                   EVAL      ExtData = C_EXTDATA                                      MD044880
     C                   EXSR      ValidateTr                                                BUG6010
     C                   EVAL      ##PREC = 'Y'                                              BUG6010
     C                   EVAL      ##PPAY = 'Y'                                              BUG6010
     C                   IF        LoanType = 'PTSO'                                         BUG6010
      *                                                                                      BUG6010
      ** Validate Receipt Settlement                                                         BUG6010
      *                                                                                      BUG6010
     C                   EVAL      ##PREC = 'N'                                              BUG6010
     C                   IF        ##RECS <> C_Rec                                           BUG6010
     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
     C                   EVAL      WFldNamArr(WIdx) = 'DDRSTM'                               BUG6010
     C                   EVAL      WMsgIDArr(WIdx) = 'LEL0701'                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ELSE                                                                BUG6010
      *                                                                                      BUG6010
      ** Validate Payment Settlement                                                         BUG6010
      *                                                                                      BUG6010
     C                   EVAL      ##PPAY = 'N'                                              BUG6010
     C                   IF        ##PAYS <> C_Pay                                           BUG6010
     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
     C                   EVAL      WFldNamArr(WIdx) = 'DDPSTM'                               BUG6010
     C                   EVAL      WMsgIDArr(WIdx) = 'LEL0700'                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   IF        ##PPAY = 'N' AND DDPSTM <> '00'                           BUG6010
     C                             AND DDPSTM <> *BLANK                                      BUG6010
     C                             OR ##PREC = 'N' AND DDRSTM <> '00'                        BUG6010
     C                             AND DDRSTM <> *BLANK                                      BUG6010
     C     LoanType      IFNE      'PTSO'                                                    BUG6010
     C                   Z-ADD     *ZERO         ##DATR                                      BUG6010
     C     WSVRP         IFGT      WSVID                                                     BUG6010
     C     WSVID         IFGT      *ZERO                                                     BUG6010
     C                   Z-ADD     WSVID         ##DATR                                      BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ELSE                                                                BUG6010
     C     WSVRP         IFGT      *ZERO                                                     BUG6010
     C                   Z-ADD     WSVRP         ##DATR                                      BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ENDIF                                                               BUG6010
     C     ##DATR        IFEQ      *ZERO                                                     BUG6010
     C     WSVMD         IFGT      *ZERO                                                     BUG6010
     C                   Z-ADD     WSVMD         ##DATR                                      BUG6010
     C                   ELSE                                                                BUG6010
     C                   Z-ADD     BJRDNB        ##DATR                                      BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   Z-ADD     WSVVD         ##DATP                                      BUG6010
     C                   ELSE                                                                BUG6010
     C                   Z-ADD     *ZERO         ##DATP                                      BUG6010
     C     WSVRP         IFGT      WSVID                                                     BUG6010
     C     WSVID         IFGT      *ZERO                                                     BUG6010
     C                   Z-ADD     WSVID         ##DATP                                      BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ELSE                                                                BUG6010
     C     WSVRP         IFGT      *ZERO                                                     BUG6010
     C                   Z-ADD     WSVRP         ##DATP                                      BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ENDIF                                                               BUG6010
     C     ##DATP        IFEQ      *ZERO                                                     BUG6010
     C     WSVMD         IFGT      *ZERO                                                     BUG6010
     C                   Z-ADD     WSVMD         ##DATP                                      BUG6010
     C                   ELSE                                                                BUG6010
     C                   Z-ADD     BJRDNB        ##DATP                                      BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   Z-ADD     WSVVD         ##DATR                                      BUG6010
     C                   ENDIF                                                               BUG6010
     C     LoanType      IFNE      'PTPU'                                                    BUG6010
     C                   MOVEL     WSVCN         WWCUST                                      BUG6010
     C                   ELSE                                                                BUG6010
     C                   MOVEL     DDCUST        WWCUST                                      BUG6010
     C                   END                                                                 BUG6010
     C                   RESET                   ReturnCode                                  BUG6010
      *                                                                                       CLE168
      ** Set Facility Customer, Facility Type, Facility Sequence                              CLE168
      *                                                                                       CLE168
     C                   IF        CLE168 = 'Y'                                               CLE168
     C     *LOCK         IN        LEFCLY                                                     CLE168
     C                   EVAL      KFCUN = DDFCUS                                             CLE168
     C                   EVAL      KFTYP = DDFTYP                                             CLE168
     C                   EVAL      KFSEQ = DDFSEQ                                             CLE168
     C     LEFCLT1       CHAIN     LEFCLTD0                           89                      CLE168
     C                   IF        *IN89 = '0'                                                CLE168
     C                   EVAL      A_XBKPT = C_FCBKPT                                         CLE168
     C                   ENDIF                                                                CLE168
     C                   EVAL      A_XCNUM = DDFCUS                                           CLE168
     C                   EVAL      A_XFACT = DDFTYP                                           CLE168
     C                   EVAL      A_XFCNO = DDFSEQ                                           CLE168
     C                   OUT       LEFCLY                                                     CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
     C                   CALLB     'ZASETINVAL'                                              BUG6010
      *                                                                                      BUG6010
      ** Return Code                                                                         BUG6010
      *                                                                                      BUG6010
     C                   PARM                    ReturnCode                                  BUG6010
      *                                                                                      BUG6010
      ** Following parameters are output to called module                                    BUG6010
      ** Calling function type                                                               BUG6010
      *                                                                                      BUG6010
     C                   PARM      'LEND'        ##CALP                                      BUG6010
      *                                                                                      BUG6010
      ** Transaction Fields                                                                  BUG6010
      ** Payment currency (or Loan currency if only one currency on Loan)                    BUG6010
      *                                                                                      BUG6010
     C                   PARM      DDCURR        ##PCCY                                      BUG6010
      *                                                                                      BUG6010
      ** Receive currency (or Loan currency if only one currency on Loan)                    BUG6010
      *                                                                                      BUG6010
     C                   PARM      DDCURR        ##RCCY                                      BUG6010
      *                                                                                      BUG6010
      ** Customer (shortname or number)                                                      BUG6010
      *                                                                                      BUG6010
     C                   PARM      WWCUST        ##CSNM                                      BUG6010
      *                                                                                      BUG6010
      ** Loan type                                                                           BUG6010
      *                                                                                      BUG6010
     C                   PARM      DDLTYP        ##TTYP                                      BUG6010
      *                                                                                      BUG6010
      ** Federal Funds Ind.                                                                  BUG6010
      *                                                                                      BUG6010
     C                   PARM      *BLANKS       ##FFND                                      BUG6010
      *                                                                                      BUG6010
      ** Booking Branch                                                                      BUG6010
      *                                                                                      BUG6010
     C                   PARM      DDBRCA        ##BRCA                                      BUG6010
      *                                                                                      BUG6010
      ** Receipt Date                                                                        BUG6010
      *                                                                                      BUG6010
     C                   PARM                    ##DATR                                      BUG6010
      *                                                                                      BUG6010
      ** Payment Date                                                                        BUG6010
      *                                                                                      BUG6010
     C                   PARM                    ##DATP                                      BUG6010
      *                                                                                      BUG6010
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction                 BUG6010
      *                                                                                      BUG6010
     C                   PARM                    ##PAYS                                      BUG6010
     C                   PARM                    ##RECS                                      BUG6010
     C                   PARM                    ##FRIS                                      BUG6010
      *                                                                                      BUG6010
      ** Action Code                                                                         BUG6010
      *                                                                                      BUG6010
     C                   PARM      DDACTN        ##ACTN                                      BUG6010
      *                                                                                      BUG6010
      ** Protect Payment Field                                                               BUG6010
      *                                                                                      BUG6010
     C                   PARM                    ##PPAY                                      BUG6010
      *                                                                                      BUG6010
      ** Protect Receipt Field                                                               BUG6010
      *                                                                                      BUG6010
     C                   PARM                    ##PREC                                      BUG6010
      *                                                                                      BUG6010
      ** Following parameters are returned by called module                                  BUG6010
      ** Payment Instruction OK flag                                                         BUG6010
      *                                                                                      BUG6010
     C                   PARM                    OKPayInsDS                                  BUG6010
      *                                                                                      BUG6010
      ** Receive Instruction OK flag                                                         BUG6010
      *                                                                                      BUG6010
     C                   PARM                    OKRecInsDS                                  BUG6010
      *                                                                                      BUG6010
      ** FRA/IRS Instruction OK flag                                                         BUG6010
      *                                                                                      BUG6010
     C                   PARM                    OKFRAInsDS                                  BUG6010
      *                                                                                      BUG6010
      ** Error fields/message IDs (arrays) from/to caller                                    BUG6010
      *                                                                                      BUG6010
     C                   PARM                    FldNameArr                                  BUG6010
     C                   PARM                    MsgIDArr                                    BUG6010
      *                                                                                      BUG6010
      ** Array index (3P0) from/to caller                                                    BUG6010
      *                                                                                      BUG6010
     C                   PARM                    Idx                                         BUG6010
      *                                                                                      BUG6010
      ** Warning Messages                                                                    BUG6010
      *                                                                                      BUG6010
     C                   PARM                    WFldNamArr                                  BUG6010
     C                   PARM                    WMsgIdArr                                   BUG6010
     C                   PARM                    WMsgDtaArr                                  BUG6010
     C                   PARM                    WIdx                                        BUG6010
      *                                                                                      BUG6010
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction                           BUG6010
      *                                                                                      BUG6010
     C                   PARM                    ##PAYF                                      BUG6010
     C                   PARM                    ##RECF                                      BUG6010
     C                   PARM                    ##FRIF                                      BUG6010
      *                                                                                      BUG6010
      ** Extra Input                                                                         BUG6010
      ** Action Code used                                                                    BUG6010
      *                                                                                      BUG6010
     C                   PARM      DDACTN        ##ACTN                                      BUG6010
      *                                                                                      BUG6010
      ** Validation Iteration                                                                BUG6010
      *                                                                                      BUG6010
     C                   PARM      *BLANK        ##ValIter                                   BUG6010
      ** Check and override blocked account                                                AR1078092
     C**********         IF        CLE134 = 'Y'                                  AR1078092 MD034521A
     C**********                   AND WBLKACCT = 'Y'                            AR1078092 MD034521A
     C                   EXSR      CHKNOVRBLKACCT                                          AR1078092
     C**********         ENDIF                                                   AR1078092 MD034521A
     C                   ENDIF                                                               BUG6010
      *                                                                                     MD039547
      ** Call account referred validation.                                                  MD039547
      *                                                                                     MD039547
     C                   IF        Idx = 0                                                  MD039547
     C                   CALL      'ZASETINVL2'                                             MD039547
     C                   PARM                    ReturnCode                                 MD039547
     C                   PARM      'LEND'        ##CALP                                     MD039547
     C                   PARM      DDCURR        ##PCCY                                     MD039547
     C                   PARM      DDCURR        ##RCCY                                     MD039547
     C                   PARM      WWCUST        ##CSNM                                     MD039547
     C                   PARM      DDBRCA        ##BRCA                                     MD039547
     C                   PARM                    ##PAYS                                     MD039547
     C                   PARM                    ##RECS                                     MD039547
     C                   PARM      DDACTN        ##ACTN                                     MD039547
     C                   PARM                    ##PPAY                                     MD039547
     C                   PARM                    ##PREC                                     MD039547
     C                   PARM                    OKPayInsDS                                 MD039547
     C                   PARM                    OKRecInsDS                                 MD039547
     C                   PARM                    FldNameArr                                 MD039547
     C                   PARM                    MsgIDArr                                   MD039547
     C                   PARM                    Idx                                        MD039547
     C                   PARM                    WFldNamArr                                 MD039547
     C                   PARM                    WMsgIdArr                                  MD039547
     C                   PARM                    WMsgDtaArr                                 MD039547
     C                   PARM                    WIdx                                       MD039547
     C                   ENDIF                                                              MD039547


     C                   ENDSL
      *
     C     INVALID       TAG
                                                                                              CSF011
      ** Populate Customer Name on Inputs Fields                                              CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011

      *  Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF

     C                   SETON                                        LR
     C     DDAPRC        Ifeq      'N'                                                        CER050
     C     DDAPRR        Ifne      *Blanks                                                    CER050
     C                   Move      *Blanks       DDAPRR                                       CER050
     C                   Endif                                                                CER050
     C     DDPREM        Ifne      *Blanks                                                    CER050
     C                   Move      *Blanks       DDPREM                                       CER050
     C                   Endif                                                                CER050
     C                   Endif                                                                CER050
     C     DDAPRC        Ifeq      'Y'                                                        CER050
     C     DDAPRR        Ifeq      *Blanks                                                    CER050
     C     @DDAPRR       andne     *Blanks                                                    CER050
     C                   Move      @DDAPRR       DDAPRR                                       CER050
     C                   Endif                                                                CER050
     C     DDPREM        Ifeq      *Blanks                                                    CER050
     C     @DDPREM       andne     *Blanks                                                    CER050
     C                   Move      @DDPREM       DDPREM                                       CER050
     C                   Endif                                                                CER050
     C                   Endif                                                                CER050

      ** If action is for Update, get the correct record information                         BUG4685
      ** from file                                                                           BUG4685
      ** so long as no errors on update                                                      BUG6108
     C                   IF        UpdateYN = 'Y'                                            BUG4685
     C                             and Idx = 0                                               BUG6108
     C                             And DDACTN <> 'I'                                          CLE106
     C                   MOVE      DDLNRF        DDLNRF_In                                   BUG4685
     C                   IF        DDACTN = 'X'                                            AR746353A
     C                   MOVE      'E'           DDACTN_In                                   BUG4685
     C                   ELSE                                                              AR746353A
     C                   MOVE      DDACTN        DDACTN_In                                 AR746353A
     C                   ENDIF                                                             AR746353A
     C                   CALL      'LECLIPR'                                                 BUG4685
     C                   PARM                    @AuthComp         1                         BUG4685
     C                   PARM                    @FwdBck           1                         BUG4685
     C                   PARM                    DDLNRF_In         6                         BUG4685
     C                   PARM                    DDACTN_In         1                         BUG4685
     C                   PARM                    Buffer                                      BUG4685
     C                   PARM                    @FldNameArr                                 BUG4685
     C                   PARM                    @MsgIDArr                                   BUG4685
     C                   PARM                    @MsgDtaArr                                  BUG4685
     C                   PARM                    @MsgFArray                                  BUG4685
     C                   PARM                    @APIRetC          1                         BUG4685
     C                   PARM                    @ACTRV                                     AR804863
     C                   PARM                    @DEPI             1                        MD052478
      *                                                                                     MD052478
     C                   MOVEL     DDACTN        @SACTN            1                         BUG4685
     C                   MOVEL     Buffer        TranInPrim                                  BUG4685
     C                   MOVE      @SACTN        DDACTN                                      BUG4685
     C                   MOVEL     TranInPrim    Buffer                                      BUG4685
                                                                                            MD020605
     C                   IF        CLE134 = 'Y'                                             MD020605
     C                   EVAL                 Buffer = TranInPrim + TranInSeco              MD020605
     C                                               + TranInThir + TranInFour              MD020605
     C                                               + TranInFive                           MD020605
     C                                               + SASCD + SHLCD                        MD020605
     C                                               + @ACTRV                               MD020605
     C                                               + TranInExt                            MD020605
     C                                               + TranInSix                            MD020605
     C                                               + TranInSeven                            CLE141
     C                                               + ##RECS + ##PAYS                      MD020605
     C                                               + @DEPI                                MD046969
     C**********                                     + InfData + RegData           MD020605 MD044880
     C                                               + InfData                              MD044880
     C                                               + ExtData                              MD020605
     C                                               + DDAPRC                               MD054028
     C                                               + DDPREM                               MD054028
     C                                               + DDAPRR                               MD054028
     C                                               + RegData                              MD044880
     C                   ENDIF                                                              MD020605
                                                                                            MD020605
     C                   ELSE                                                                BUG4685
      * Remerge buffer with all relevant data structures
     C*******************EVAL                 Buffer = TranInPrim + TranInSeco  BUG2480
     C*******************                            + TranInThir + TranInFour  BUG2480
     C*******************                            + ##RECS + ##PAYS          BUG2480
     C*******************                            + ReservID                 BUG2480
     C*******************                            + ExtData                  BUG2480
     C                   EVAL                 Buffer = TranInPrim + TranInSeco  BUG2480
     C                                               + TranInThir + TranInFour  BUG2480
     C                                               + TranInFive                             CLE106
     C                                               + SASCD + SHLCD                          CLE120
     C                                               + @ACTRV                               AR804863
     C                                               + TranInExt                              CER049
     C                                               + TranInSix                           AR1021983
     C                                               + TranInSeven                            CLE141
     C                                               + ##RECS + ##PAYS          BUG2480
     C**********                                     + ExtData                        BUG2480 CAP086
     C**********                                     + InfData + ExtData              CAP086  CER001
     C                                               + @DEPI                                MD046969
     C**********                                     + InfData + RegData             CER001 MD044880
     C                                               + InfData                              MD044880
     C                                               + ExtData                                CER001
     C                                               + DDAPRC                               MD054028
     C                                               + DDPREM                               MD054028
     C                                               + DDAPRR                               MD054028
     C                                               + RegData                              MD044880
     C                   ENDIF                                                               BUG4685

     C                   RETURN

      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Transaction number supplied                                *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the database is retrieved
      * as well.

     C                   RESET                   ReturnCode
     C                   CALLB     'LECLIPRTV'

      * INPUTS

      * Return code
     C                   PARM      *BLANK        ReturnCode

      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)

     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM      'S'           RespMode          1
      * Action Code
     C                   PARM                    DDACTN            1
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      * (Midas) Customer Loan Reference
     C                   PARM                    DDLNRF            6
      *
      ** Loan type/sub type
     C                   PARM                    DDLTYP
     C                   PARM                    DDSUTP
     C                   PARM                    DDCLAS                                       CLE042
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721

      * OUTPUTS

      * Loan Processing Type
     C                   PARM                    LoanPtyp          2 0
      * Loan Type
     C                   PARM                    LoanType          4

      * (Current) Customer loan CL in file format
     C                   PARM                    ClilFilFmt
      * (Current) Customer loan CK in file format
     C                   PARM                    ClikFilFmt
      * OK - Action code
     C                   PARM                    DDActnOK          1
      * OK - Loan Reference
     C                   PARM                    DDLnrfOK          1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr                                   BUG826
     C                   PARM                    WMsgIdArr                                    BUG826
     C                   PARM                    WMsgDtaArr                                   BUG826
     C                   PARM                    WIdx                                         BUG826
     C                   PARM                    DDFPTF                                       245273
      *                                                                                     AR804863
      ** Reject Button                                                                      AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C/COPY WNCPYSRC,LECLIPXC03

     C                   Z-ADD     CL_TNLU       H#TNLU            5 0
     C                   Z-ADD     CL_CHGA       WCHGA                                       BUG3721

      * Put the complete (pre-existing) Transaction into the
      * Valid file record - fields in this will be updated during processing

     C**********         MOVE      ClilFilFmt    ValidClil                                    CAS011
     C                   MOVEL     ClilFilFmt    ValidClil                                    CAS011
     C**********         MOVE      ClikFilFmt    ValidClik                                    CLE106
     C                   MOVEL     ClikFilFmt    ValidClik                                    CLE106

      *                                                                                       CER001
      ** Retrieve LECLIP customer extension file if switchable                                CER001
      ** ULX004 is on and non-parts sold loan.                                                CER001
      *                                                                                       CER001
     C                   If        ULX004  = 'Y' And                                          CER001
     C                             LoanType <> 'PTSO'                                         CER001
     C                   MOVE      DDLNRF        PLoanNum                                     CER001
     C                   CALLB     'LECLIP2RV'                                                CER001
     C                   PARM      *BLANK        ReturnCode                                   CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    APFOTranID                                   CER001
     C                   PARM                    PLoanNum                                     CER001
     C                   PARM                    CLIPExFilFmt                                 CER001
     C                   ENDIF                                                                CER001

     C                   IF        LLN007 = 'Y'                                             MD044880
     C                   CALLB     'LECLIPRTV1'                                             MD044880
     C                   PARM                    ReturnCode                                 MD044880
     C                   PARM                    DDACTN                                     MD044880
     C                   PARM                    APFOTranID                                 MD044880
     C                   PARM                    DDLNRF                                     MD044880
     C                   PARM                    ClExtFilFmt                                MD044880
     C                   ENDIF                                                              MD044880
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************
     C     DftSettmts    BEGSR

      * If ANY of the Settlements fields have been entered, bypass this
      *  routine.
      * Otherwise, use modules which will use Standard Settlement
      *  Instructions to apply defaults.

     C                   IF            (##PAYS = *blank)
     C                             AND (##RECS = *blank)

     C                   CALLB     'ZASETINDFT'

      ** Output
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4
      ** Payment currency
     C                   PARM      DDCURR        ##PCCY            3
      ** Receive currency
     C                   PARM      DDCURR        ##RCCY            3
      ** Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM           10
      ** Deal type
     C                   PARM      *BLANKS       ##TTYP            2
      ** Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND            1
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    Blank4            4
      ** Type of ISDA agreement
     C                   PARM                    Blank6            6
      ** Date of ISDA Agreement
     C                   PARM                    Blank6X           6
      ** Version of ISDA Agreement
     C                   PARM                    Blank2            2
      *
      ** Version century of ISDA Agreement
     C                   PARM                    Blank2X           2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    ##PAYF
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    ##RECF
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    ##FRIF

      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.

     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM      *BLANK        ##FRIF

      ** Defaulted Settlement Instruction in input format
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ##FRIS
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR

     C                   MOVE      DDACTN        VL_CLCHTP
     C                   MOVE      DDACTN        VK_CLCHTP
     C                   EVAL      PGNTF = DDPNTF                                             CLE106

      * Validate Customer Loans details 1

     C                   EXSR      ValdTrPrim

      * If error in validation, fail this input

     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Customer Loans details 2

     C                   EXSR      ValdTrSeco

      *  If error in validation, fail this input

     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Customer Loans details 3

     C                   EXSR      ValdTrThir

      *  If error in validation, fail this input

     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Customer Loans details 4

     C                   EXSR      ValdTrFour

      *  If error in validation, fail this input

     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
                                                                                              CDE005
      * Validate Reservation ID if in update mode                                             CDE005
                                                                                              CDE005
     C     CDE005        IFEQ      'Y'                                                        CDE005
                                                                                              CDE005
     C     UpdateYN      IFEQ      'Y'                                                        CDE005
     C                   EXSR      ValdTrResv                                                 CDE005
     C                   ENDIF                                                                CDE005
                                                                                              CDE005
      *  If error in validation, fail this input                                              CDE005
                                                                                              CDE005
     C     Idx           IFNE      0                                                          CDE005
     C                   GOTO      EValidTr                                                   CDE005
     C                   END                                                                  CDE005
                                                                                              CDE005
     C                   ENDIF                                                                CDE005
                                                                                              CDE005
      *                                                                                       CER001
      ** Validate customer loans extension details if switchable is on                        CER001
      ** and non-part sold loan.                                                              CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y' And                                          CER001
     C                             LoanType <> 'PTSO'                                         CER001
     C                   EXSR      ValdExtDtl                                                 CER001
     C                   ENDIF                                                                CER001
     C*                                                                                       CER001
      ** If error in validation, fail this input                                              CER001
      *                                                                                       CER001
     C                   IF        Idx <> 0                                                   CER001
     C                   GOTO      EValidTr                                                   CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrPrim - Validate Customer Loans Primary details          *
      *                                                               *
      *****************************************************************
     C     ValdTrPrim    BEGSR
      *                                                                                       CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      PTREF = DDLUTN                                             CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE134
     C                   IF        CLE134 = 'Y' AND TranInSix <> *BLANKS                      CLE134
     C                             OR CLE134 = 'Y' AND APSRCSYS = 'MIDASCOB'                  CLE134
     C                   EVAL      W#PDCL = 'Y'                                               CLE134
     C                   ENDIF                                                                CLE134

     C                   CALLB     'LECLIP1VL'

      * INPUTS

      * Response mode
     C                   PARM      'S'           RespMode          1

      * Primary Details
     C                   PARM                    TranInPrim
      ** Interface Data file                                                                  CAP086
     C                   PARM                    InfData                                      CAP086
      * Extra Data file data
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
      * Calling type
     C                   PARM                    LoanType          4
     C                   PARM                    @USER            16
     C                   PARM                    W#SEQ             4 0
     C                   PARM                    W#PCOB            3
     C                   PARM                    PGNTF             1
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
                                                                                             BUG3721
      ** Screen Detail 2                                                                     BUG3721
     C                   PARM                    TranInSeco                                  BUG3721
                                                                                              CLE106
      ** Screen Detail 3                                                                      CLE106
     C                   PARM                    TranInThir                                   CLE106
                                                                                              CLE134
      ** Screen Detail 6                                                                      CLE134
     C                   PARM                    TranInSix                                    CLE134
                                                                                              CLE141
      ** Business Day Convention Screen Detail                                                CLE141
     C                   PARM                    TranInSeven                                  CLE141
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDPREM           15                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028

      * OUTPUTS

      * Customer Loans Primary Details OK inds
     C                   PARM                    OKClPrim
     C                   PARM                    OKClSeven                                    CLE141

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
     C                   PARM                    WIdx

      * Valid Customer Loans CL layout (DS) from/to caller
     C                   PARM                    ValidClil
      * Valid Customer Loans CK layout (DS) from/to caller
     C                   PARM                    ValidClik
      * Next available loan number
     C                   PARM                    @PRANG            2
      * Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      * Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      * Shared data
     C                   PARM                    TransData
      * PC Processing
     C                   PARM                    PPTIN             1
     C                   PARM                    PTDT1            35
     C                   PARM                    PTDT2            35
     C                   PARM                    PTDT3            35
     C                   PARM                    PTREF            15
      ***  (Current) loan in file format CL
     C                   PARM                    ClilFilFmt
     C                   PARM                    WAUTOA            1                          245227
     C                   PARM                    WAUTOY            1                          245227

     C                   PARM                    ModeofOp          6                          247441
     C                   PARM                    W#PDCL                                       CLE134
      ** Front Office ID                                                                    MD032052
     C                   PARM                    APFOTranID       20                        MD032052
     C**********         PARM                    WBLKACCT                         MD022807 MD022807C
                                                                                              247441
     C                   MOVE      DDAPRC        @DDAPRC           1                        MD054028
     C                   MOVE      DDPREM        @DDPREM          15                        MD054028
     C                   MOVE      DDAPRR        @DDAPRR           8                        MD054028
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrSeco - Validate Customer Loans Secondary details        *
      *                                                               *
      *****************************************************************
     C     ValdTrSeco    BEGSR

     C                   CALLB     'LECLIP2VL'
      * INPUTS

      * Response mode
     C                   PARM      'S'           RespMode          1

      * Primary Details
     C                   PARM                    TranInSeco
      ** Loan details screen 3                                                               BUG8526
     C                   PARM                    TranInThir                                  BUG8526
      ** Interface Data file                                                                  CAP086
     C                   PARM                    InfData                                      CAP086
      * Extra Data file data
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
      * Calling type
     C                   PARM                    LoanType
     C                   PARM                    @USER
     C                   PARM                    W#SEQ
     C                   PARM                    W#PCOB
     C                   PARM                    PGNTF
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
                                                                                             BUG3721
      ** (Current) loan in file format CL                                                    BUG3721
      ** Screen detail 1                                                                     BUG3721
      ** Customer Loans Primary Details OK inds                                              BUG3721
     C                   PARM                    ClilFilFmt                                  BUG3721
     C                   PARM                    TranInPrim                                  BUG3721
     C                   PARM                    OKClPrim
      ** Business Day Convention Screen Detail                                              MD053143
     C                   PARM                    TranInSeven                                MD053143

      * OUTPUTS

      * Customer Loans Primary Details OK inds
     C                   PARM                    OKClSeco

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
     C                   PARM                    WIdx

      * Valid Customer Loans CL layout (DS) from/to caller
     C                   PARM                    ValidClil
      * Valid Customer Loans CK layout (DS) from/to caller
     C                   PARM                    ValidClik
      * Next available loan number
     C                   PARM                    @PRANG
      * Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      * Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      * Shared data
     C                   PARM                    TransData
      * PC Processing
     C                   PARM                    PPTIN
     C                   PARM                    PTDT1
     C                   PARM                    PTDT2
     C                   PARM                    PTDT3
     C                   PARM                    PTREF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrThir - Validate Customer Loans Third details            *
      *                                                               *
      *****************************************************************
     C     ValdTrThir    BEGSR

     C                   MOVE      DDACTN        DDACT3

     C                   CALLB     'LECLIP3VL'
      * INPUTS

      * Response mode
     C                   PARM      'S'           RespMode          1

      * Primary Details
     C                   PARM                    TranInThir
      ** Interface Data file                                                                  CAP086
     C                   PARM                    InfData                                      CAP086
      * Extra Data file data
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
      * Calling type
     C                   PARM                    LoanType
     C                   PARM                    @USER
     C                   PARM                    W#SEQ
     C                   PARM                    W#PCOB
     C                   PARM                    PGNTF

      * OUTPUTS

      * Customer Loans Primary Details OK inds
     C                   PARM                    OKClThir

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
     C                   PARM                    WIdx

      * Valid Customer Loans CL layout (DS) from/to caller
     C                   PARM                    ValidClil
      * Valid Customer Loans CK layout (DS) from/to caller
     C                   PARM                    ValidClik
      * Next available loan number
     C                   PARM                    @PRANG
      * Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      * Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      * Shared data
     C                   PARM                    TransData
      * PC Processing
     C                   PARM                    PPTIN
     C                   PARM                    PTDT1
     C                   PARM                    PTDT2
     C                   PARM                    PTDT3
     C                   PARM                    PTREF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrFour - Validate Customer Loans Fourth details           *
      *                                                               *
      *****************************************************************
     C     ValdTrFour    BEGSR

     C                   CALLB     'LECLIP4VL'
      * INPUTS

      * Response mode
     C                   PARM      'S'           RespMode          1

      * Primary Details
     C                   PARM                    TranInFour
     C                   PARM                    TranInSix                                    CLE134
      *                                                                                       CLE134
      ** (Current) Customer loan CL in file format                                            CLE134
      *                                                                                       CLE134
     C                   PARM                    ClilFilFmt                                   CLE134
      ** Interface Data file                                                                  CAP086
     C                   PARM                    InfData                                      CAP086
      * Extra Data file data
     C                   PARM                    ExtData
      * Calling type
     C                   PARM                    LoanType
     C                   PARM                    @USER
     C                   PARM                    W#SEQ
     C                   PARM                    W#PCOB
     C                   PARM                    PGNTF

      * OUTPUTS

      * Customer Loans Primary Details OK inds
     C                   PARM                    OKClFour
     C                   PARM                    OKClSix                                      CLE134

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
     C                   PARM                    WIdx

      * Valid Customer Loans CL layout (DS) from/to caller
     C                   PARM                    ValidClil
      * Valid Customer Loans CK layout (DS) from/to caller
     C                   PARM                    ValidClik
      * Next available loan number
     C                   PARM                    @PRANG
      * Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      * Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      * Shared data
     C                   PARM                    TransData
      * PC Processing
     C                   PARM                    PPTIN
     C                   PARM                    PTDT1
     C                   PARM                    PTDT2
     C                   PARM                    PTDT3
     C                   PARM                    PTREF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************
     C     ValidateSt    BEGSR

     C                   MOVEL     'N'           ##PPAY
     C                   MOVEL     'N'           ##PREC

     C*****DDACTN        IFEQ      'X'                                              BUG4473 MD041649
     C**********         MOVEL     'Y'           ##PPAY                             BUG4473 MD041649
     C**********         MOVEL     'Y'           ##PREC                             BUG4473 MD041649
     C**********         ENDIF                                                      BUG4473 MD041649
                                                                                             BUG4473
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'X'                                                      MD041649
     C     CL_VDAT       IFLT      BJRDNB
     C     CL_ORED       ANDLT     BJRDNB
     C     LoanType      IFEQ      'PTSO'
     C     STARAM        Ifeq      'N'                                                      MD030274
     C                   MOVEL     'Y'           ##PREC
     C                   Endif                                                              MD030274
     C                   ELSE
     C     STARAM        Ifeq      'N'                                                      MD030274
     C                   MOVEL     'Y'           ##PPAY
     C                   Endif                                                              MD030274
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C**********         IF        ##PPAY = 'Y' AND ##PAYS <> C_Pay                         MD036838
     C**********                   AND DDACTN <> 'X'                                BUG4473 MD036838
      *****************************************************************             BUG6010 MD036838
      ***Allow*amendment*of*the*settlement*details.********************             BUG6010 MD036838
      *****************************************************************             BUG6010 MD036838
     C**********         EVAL      WIdx = WIdx + 1                                  BUG6010 MD036838
     C**********         EVAL      WFldNamArr(WIdx) = 'DDPSTM'                      BUG6010 MD036838
     C**********         EVAL      WMsgIDArr(WIdx) = 'LEL0700'                      BUG6010 MD036838
     C**********         ADD       1             Idx                                         BUG6010
     C**********         EVAL      FldNameArr(Idx) = 'DDPSTM'                                BUG6010
     C**********         MOVEL     'LEL0677'     MsgIDArr(Idx)                               BUG6010
     C**********         GOTO      INVALID                                                   BUG6010
     C**********         ENDIF                                                              MD036838

     C**********         IF        ##PREC = 'Y' AND ##RECS <> C_Rec                         MD036838
     C**********                   AND DDACTN <> 'X'                                BUG4473 MD036838
     C**********         EVAL      WIdx = WIdx + 1                                  BUG6010 MD036838
     C**********         EVAL      WFldNamArr(WIdx) = 'DDRSTM'                      BUG6010 MD036838
     C**********         EVAL      WMsgIDArr(WIdx) = 'LEL0701'                      BUG6010 MD036838
     C**********         ADD       1             Idx                                         BUG6010
     C**********         EVAL      FldNameArr(Idx) = 'DDRSTM'                                BUG6010
     C**********         MOVEL     'LEL0678'     MsgIDArr(Idx)                               BUG6010
     C**********         GOTO      INVALID                                                   BUG6010
     C**********         ENDIF                                                              MD036838
      **********                                                                     AR314017 CLE164
     C**********         IF        CLE134 = 'Y'                                      AR314017 CLE164
      **********                                                                     AR314017 CLE164
      ***Warnings*about*existing*records*in*Priority*Repayment file****              AR314017 CLE164
      **********                                                                     AR314017 CLE164
     C**********         IF        DDACTN = 'A'                                      AR314017 CLE164
     C**********         MOVE      VL_CLLNRF     WLNRF                               AR314017 CLE164
      *                                                                                     AR314017
     C**********         IF        DDRONX <> C_DDRONX                                AR314017 CLE164
     C*****KLNRF         CHAIN     LEACCNL5                           99             AR314017 CLE164
     C**********         IF        *IN99 = *OFF                                      AR314017 CLE164
     C**********         EVAL      WIdx = WIdx + 1                                   AR314017 CLE164
     C**********         EVAL      WFldNamArr(WIdx) = 'DDRONX'                       AR314017 CLE164
     C**********         EVAL      WMsgIDArr(WIdx) = '5045675'                       AR314017 CLE164
     C**********         ENDIF                                                       AR314017 CLE164
     C**********         ENDIF                                                       AR314017 CLE164
      *                                                                                     AR314017
     C**********         IF        DDPONX <> C_DDPONX                                AR314017 CLE164
     C*****KLNRF         CHAIN     LEACCNL5                           99             AR314017 CLE164
     C**********         IF        *IN99 = *OFF                                      AR314017 CLE164
     C**********         EVAL      WIdx = WIdx + 1                                   AR314017 CLE164
     C**********         EVAL      WFldNamArr(WIdx) = 'DDPONX'                       AR314017 CLE164
     C**********         EVAL      WMsgIDArr(WIdx) = '5045676'                       AR314017 CLE164
     C**********         ENDIF                                                       AR314017 CLE164
     C**********         ENDIF                                                       AR314017 CLE164
      *                                                                                     AR314017
     C**********         ENDIF                                                       AR314017 CLE164
      *****************************************************************              AR314017 CLE164
      ***Settlement*account*must*be*present*with*AUTO*=*C**************              AR314017 CLE164
      *****************************************************************              AR314017 CLE164
     C**********         IF        VL_CLAUTO = 'C'                                   AR314017 CLE164
      *                                                                                     AR314017
     C**********         IF        (VL_CLPTYP=66 OR VL_CLPTYP=69                     AR314017 CLE164
     C**********                   OR VL_CLPTYP=72)                                  AR314017 CLE164
     C**********                   AND DDPONX = *BLANKS                              AR314017 CLE164
     C**********                   AND DDPSTM <> '00'                                AR314017 CLE164
     C**********                   AND DDPSTM <> '  '                                AR314017 CLE164
     C**********         ADD       1             Idx                                 AR314017 CLE164
     C**********         EVAL      FldNameArr(Idx) = 'DDPONX'                        AR314017 CLE164
     C**********         MOVEL     '5045677'     MsgIDArr(Idx)                       AR314017 CLE164
     C**********         GOTO      INVALID                                           AR314017 CLE164
     C**********         ENDIF                                                       AR314017 CLE164
      **********                                                                     AR314017 CLE164
     C**********         IF        (VL_CLPTYP=61 OR VL_CLPTYP=62                     AR314017 CLE164
     C**********                   OR VL_CLPTYP=64 OR VL_CLPTYP=68                   AR314017 CLE164
     C**********                   OR VL_CLPTYP=80)                                  AR314017 CLE164
     C**********                   AND DDRONX = *BLANKS                              AR314017 CLE164
     C**********                   AND DDRSTM <> '00'                                AR314017 CLE164
     C**********                   AND DDRSTM <> '  '                                AR314017 CLE164
     C**********         ADD       1             Idx                                 AR314017 CLE164
     C**********         EVAL      FldNameArr(Idx) = 'DDRONX'                        AR314017 CLE164
     C**********         MOVEL     'LER5586'     MsgIDArr(Idx)                     AR314017 MD023116
     C**********         MOVEL     '5045678'     MsgIDArr(Idx)                       MD023116 CLE164
     C**********         GOTO      INVALID                                           AR314017 CLE164
     C**********         ENDIF                                                       AR314017 CLE164
                                                                                            AR634877
      ***Autosettle*cannot*be*'C'*if*both*settlement*methods*are*'00'.*            AR634877 AR693137
      *****************************************************************            AR634877 AR693137
     C**********         IF        VL_CLAUTO = 'C'                                 AR634877 AR693137
     C**********                   AND (DDPSTM = '00'                              AR634877 AR693137
     C**********                   OR DDPSTM = *BLANK)                             AR634877 AR693137
     C**********                                                                   AR634877 AR693137
     C**********                   AND (DDRSTM = '00'                              AR634877 AR693137
     C**********                   OR DDRSTM = *BLANK)                             AR634877 AR693137
     C**********                                                                   AR634877 AR693137
     C**********                                                                   AR634877 AR693137
     C**********         ADD       1             Idx                               AR634877 AR693137
     C**********         EVAL      FldNameArr(Idx) = 'DDAUTO'                      AR634877 AR693137
     C**********         MOVEL     'LER5592'     MsgIDArr(Idx)                     AR634877 AR693137
     C**********         GOTO      INVALID                                         AR634877 AR693137
     C**********         ENDIF                                                     AR634877 AR693137
      *****************************************************************            AR634877 AR693137
      *                                                                                     AR693137
      ** If pre-deal check is defined, Receipt/Pay settlement should be                     AR693137
      ** equal to 01, 05, 08 or 14.                                                         AR693137
      *                                                                                     AR693137
     C**********         IF        VL_CLAUTO = 'C'                                 AR693137 MD048478
     C**********                   AND DDACTN = 'I'                                AR693137 MD048478
     C**********                   OR VL_CLAUTO = 'C'                              AR693137 MD048478
     C**********                   AND DDACTN = 'A'                                AR693137 MD048478
     C**********         IF        DDRSTM <> '01'                                  AR693137 MD048478
     C**********                   AND DDRSTM <> '05'                              AR693137 MD048478
     C**********                   AND DDRSTM <> '08'                              AR693137 MD048478
     C**********                   AND DDRSTM <> '14'                              AR693137 MD048478
     C**********         ADD       1             Idx                               AR693137 MD048478
     C**********         EVAL      FldNameArr(Idx) = 'DDRSTM'                      AR693137 MD048478
     C**********         MOVEL     '5045685'     MsgIDArr(Idx)                     AR693137 MD048478
     C**********         GOTO      INVALID                                         AR693137 MD048478
     C**********         ENDIF                                                     AR693137 MD048478
      *                                                                            AR693137 MD048478
     C**********         ENDIF                                                     AR693137 MD048478
      *****************************************************************              AR314017 CLE164
     C**********         ENDIF                                                       AR314017 CLE164
      *****************************************************************              AR314017 CLE164
     C**********         ENDIF                                                       AR314017 CLE164

      ** If loan is not a participation sold

     C     LoanType      IFNE      'PTSO'
      *
      ** ... set up date of receipt.
      ** It is next interest date or next repayment date.
      ** If date receipt still zero, use maturity date if present,
      ** otherwise, use midas rundate
      *
     C                   Z-ADD     *ZERO         ##DATR
     C     WSVRP         IFGT      WSVID
     C     WSVID         IFGT      *ZERO
     C                   Z-ADD     WSVID         ##DATR
     C                   ENDIF
     C                   ELSE
     C     WSVRP         IFGT      *ZERO
     C                   Z-ADD     WSVRP         ##DATR
     C                   ENDIF
     C                   ENDIF
     C     ##DATR        IFEQ      *ZERO
     C     WSVMD         IFGT      *ZERO
     C                   Z-ADD     WSVMD         ##DATR
     C                   ELSE
     C                   Z-ADD     BJRDNB        ##DATR
     C                   ENDIF
     C                   ENDIF
      *
      ** .. set up date of payment
      *
     C                   Z-ADD     WSVVD         ##DATP

     C                   ELSE
      *
      ** ... set up date of payment.
      ** It is next interest date or next repayment date.
      ** If date receipt still zero, use maturity date if present,
      ** otherwise, use midas rundate
      *
     C                   Z-ADD     *ZERO         ##DATP
     C     WSVRP         IFGT      WSVID
     C     WSVID         IFGT      *ZERO
     C                   Z-ADD     WSVID         ##DATP
     C                   ENDIF
     C                   ELSE
     C     WSVRP         IFGT      *ZERO
     C                   Z-ADD     WSVRP         ##DATP
     C                   ENDIF
     C                   ENDIF
     C     ##DATP        IFEQ      *ZERO
     C     WSVMD         IFGT      *ZERO
     C                   Z-ADD     WSVMD         ##DATP
     C                   ELSE
     C                   Z-ADD     BJRDNB        ##DATP
     C                   ENDIF
     C                   ENDIF
      *
      ** .. set up date of receipt
      *
     C                   Z-ADD     WSVVD         ##DATR

     C                   ENDIF
      *
      ** .. set up customer
      *
     C     LoanType      IFNE      'PTPU'
     C                   MOVEL     WSVCN         WWCUST           10
     C                   ELSE
      *                                                                                       241519
      *If the loan is a Participation Purchased, & System Value                               241519
      * LoanCustOriginPurch = 'O', use Original Borrower:                                     241519
     C     PPCUST        IFEQ      'O'                                                        241519
     C                   MOVEL     DDCUST        WWCUST
      * Else, use 'Purchased from' customer number.                                           241519
     C                   ELSE                                                                 241519
     C                   EVAL      DDPFRM = %TRIML(DDPFRM)                                    241519
     C                   MOVEL     DDPFRM        WWCUST                                       241519
     C                   ENDIF                                                                241519
     C                   END
      *
     C                   RESET                   ReturnCode

      ** Remove settlements if Settlement Allocation is available                             CLE034
                                                                                              CLE034
     C                   IF        DDSTAL = 'Y'                                               CLE034
     C                   EVAL      ##PAYS = *Blanks                                           CLE034
     C                   EVAL      ##RECS = *Blanks                                           CLE034
     C                   EVAL      DDPSTM = '00'                                              CLE034
     C                   EVAL      DDRSTM = '00'                                              CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
      *                                                                                       CLE168
      **	Set Facility Customer, Facility Type, Facility Sequence                           CLE168
      *                                                                                       CLE168
     C                   IF        CLE168 = 'Y'                                               CLE168
     C     *LOCK         IN        LEFCLY                                                     CLE168
     C                   EVAL      KFCUN = DDFCUS                                             CLE168
     C                   EVAL      KFTYP = DDFTYP                                             CLE168
     C                   EVAL      KFSEQ = DDFSEQ                                             CLE168
     C     LEFCLT1       CHAIN     LEFCLTD0                           89                      CLE168
     C                   IF        *IN89 = '0'                                                CLE168
     C                   EVAL      A_XBKPT = C_FCBKPT                                         CLE168
     C                   ENDIF                                                                CLE168
     C                   EVAL      A_XCNUM = DDFCUS                                           CLE168
     C                   EVAL      A_XFACT = DDFTYP                                           CLE168
     C                   EVAL      A_XFCNO = DDFSEQ                                           CLE168
     C                   OUT       LEFCLY                                                     CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
      *                                                                                    MD036838A
      ** Call ZASETINVAL for C_PAY                                                         MD036838A
      *                                                                                    MD036838A
     C                   CALLB     'ZASETINVAL'                                            MD036838A
     C                   PARM                    ReturnCode                                MD036838A
     C                   PARM      'LEND'        ##CALP                                    MD036838A
     C                   PARM      DDCURR        ##PCCY                                    MD036838A
     C                   PARM      DDCURR        ##RCCY                                    MD036838A
     C                   PARM      WWCUST        ##CSNM                                    MD036838A
     C                   PARM      DDLTYP        ##TTYP                                    MD036838A
     C                   PARM      *BLANKS       ##FFND                                    MD036838A
     C                   PARM      DDBRCA        ##BRCA                                    MD036838A
     C                   PARM                    ##DATR                                    MD036838A
     C                   PARM                    ##DATP                                    MD036838A
     C                   PARM                    C_PAY                                     MD036838A
     C                   PARM                    C_REC                                     MD036838A
     C                   PARM                    C_FRA                                     MD036838A
     C                   PARM      DDACTN        ##ACTN                                    MD036838A
     C                   PARM                    ##PPAY                                    MD036838A
     C                   PARM                    ##PREC                                    MD036838A
     C                   PARM                    OKPayInsDS                                MD036838A
     C                   PARM                    OKRecInsDS                                MD036838A
     C                   PARM                    OKFRAInsDS                                MD036838A
     C**********         PARM                    FldNameArr                      MD036838A  MD056313
     C**********         PARM                    MsgIDArr                        MD036838A  MD056313
     C**********         PARM                    Idx                             MD036838A  MD056313
     C**********         PARM                    WFldNamArr                      MD036838A  MD056313
     C**********         PARM                    WMsgIdArr                       MD036838A  MD056313
     C**********         PARM                    WMsgDtaArr                      MD036838A  MD056313
     C**********         PARM                    WIdx                            MD036838A  MD056313
     C                   PARM                    FldNamHld                                  MD056313
     C                   PARM                    MsgIdArrHld                                MD056313
     C                   PARM                    IdxHld                                     MD056313
     C                   PARM                    WFldNamHld                                 MD056313
     C                   PARM                    WMsgIdArrHld                               MD056313
     C                   PARM                    WMsgDtaArrHl                               MD056313
     C                   PARM                    WIdxHld                                    MD056313
     C                   PARM                    ##PAYF                                    MD036838A
     C                   PARM                    ##RECF                                    MD036838A
     C                   PARM                    ##FRIF                                    MD036838A
     C                   PARM      DDACTN        ##ACTN                                    MD036838A
     C                   PARM      '1ST'         ##ValIter                                 MD036838A
      *                                                                                    MD036838A
     C                   CALLB     'ZASETINVAL'

      * Return Code
     C                   PARM                    ReturnCode
      * Following parameters are output to called module
      * Calling function type
     C                   PARM      'LEND'        ##CALP            4
      * Transaction Fields
      * Payment currency (or Loan currency if only one currency on Loan)
     C                   PARM      DDCURR        ##PCCY            3
      * Receive currency (or Loan currency if only one currency on Loan)
     C                   PARM      DDCURR        ##RCCY            3
      * Customer (shortname or number)
     C                   PARM      WWCUST        ##CSNM           10
      * Loan type
     C                   PARM      DDLTYP        ##TTYP            2
      * Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      * Booking Branch
     C                   PARM      DDBRCA        ##BRCA            3
      * Receipt Date
     C                   PARM                    ##DATR            5 0
      * Payment Date
     C                   PARM                    ##DATP            5 0
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ##FRIS
      * Action Code
     C                   PARM      DDACTN        ##ACTN            1
      * Protect Payment Field                                                                 196461
     C                   PARM                    ##PPAY            1                          196461
      * Protect Receipt Field                                                                 196461
     C                   PARM                    ##PREC            1                          196461

      * Following parameters are returned by called module
      * Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      * Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      * FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning Messages
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx

      * File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##FRIF
      * Extra Input
      * Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      * Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
      *                                                                                     MD036838
      ** Move validation here.                                                              MD036838
      *                                                                                     MD036838
     C                   IF        ##PAYS <> C_Pay AND DDACTN <> 'X'                        MD053956
     C                             AND DDACTN <> 'I'                                        MD056313
     C                                                                                      MD036838
     C                   EVAL      WIdx = WIdx + 1                                          MD036838
     C                   EVAL      WFldNamArr(WIdx) = 'DDPSTM'                              MD036838
     C                   EVAL      WMsgIDArr(WIdx) = 'LEL0700'                              MD036838
     C                   ENDIF                                                              MD036838
                                                                                            MD036838
     C                   IF        ##RECS <> C_Rec  AND DDACTN <> 'X'                       MD053956
     C                             AND DDACTN <> 'I'                                        MD056313
     C                                                                                      MD036838
     C                   EVAL      WIdx = WIdx + 1                                          MD036838
     C                   EVAL      WFldNamArr(WIdx) = 'DDRSTM'                              MD036838
     C                   EVAL      WMsgIDArr(WIdx) = 'LEL0701'                              MD036838
     C                   ENDIF                                                              MD036838
      ** Check and override blocked account                                                AR1078092
     C**********         IF        CLE134 = 'Y'                                  AR1078092 MD034521A
     C**********                   AND WBLKACCT = 'Y'                            AR1078092 MD034521A
     C                   EXSR      CHKNOVRBLKACCT                                          AR1078092
     C**********         ENDIF                                                   AR1078092 MD034521A
      *                                                                                     MD039547
      ** Call account referred validation.                                                  MD039547
      *                                                                                     MD039547
     C                   IF        Idx = 0                                                  MD039547
     C                   CALL      'ZASETINVL2'                                             MD039547
     C                   PARM                    ReturnCode                                 MD039547
     C                   PARM      'LEND'        ##CALP                                     MD039547
     C                   PARM      DDCURR        ##PCCY                                     MD039547
     C                   PARM      DDCURR        ##RCCY                                     MD039547
     C                   PARM      WWCUST        ##CSNM                                     MD039547
     C                   PARM      DDBRCA        ##BRCA                                     MD039547
     C                   PARM                    ##PAYS                                     MD039547
     C                   PARM                    ##RECS                                     MD039547
     C                   PARM      DDACTN        ##ACTN                                     MD039547
     C                   PARM                    ##PPAY                                     MD039547
     C                   PARM                    ##PREC                                     MD039547
     C                   PARM                    OKPayInsDS                                 MD039547
     C                   PARM                    OKRecInsDS                                 MD039547
     C                   PARM                    FldNameArr                                 MD039547
     C                   PARM                    MsgIDArr                                   MD039547
     C                   PARM                    Idx                                        MD039547
     C                   PARM                    WFldNamArr                                 MD039547
     C                   PARM                    WMsgIdArr                                  MD039547
     C                   PARM                    WMsgDtaArr                                 MD039547
     C                   PARM                    WIdx                                       MD039547
     C                   ENDIF                                                              MD039547
      *                                                                                       241519
      *If the loan is a Participation Purchased, & System Value                               241519
      * LoanCustOriginPurch = 'O', use Original Borrower:                                     241519
     C     FLPSTM        IFEQ      04                                                         241519
     C     PPCUST        IFEQ      'O'                                                        241519
     C                   MOVEL     DDCUST        FLPONS                                       241519
      * Else, use 'Purchased from' customer number.                                           241519
     C                   ELSE                                                                 241519
     C                   MOVEL     DDPFRM        FLPONS                                       241519
     C                   ENDIF                                                                241519
     C                   ENDIF                                                                241519
      *                                                                                       241519
     C                   IF        DDSTAL = 'Y'                                               CLE034
     C                   EVAL      ##PAYS = *Blanks                                           CLE034
     C                   EVAL      ##RECS = *Blanks                                           CLE034
     C                   ELSE                                                                 CLE034
      *
      * If Part Sold, move Rec settl insts into Our start date settl insts
      *               and  Pay settl insts into Our maturity date settl insts
      *         else, the contrary
      *
     C     LoanType      IFNE      'PTSO'
     C                   MOVE      FLPSTM        WSDST
     C                   MOVE      FLRSTM        WMDST
     C                   MOVE      FLPONS        WOSDA
     C                   MOVE      FLRONS        WOMDA
     C                   MOVEL     FLAWBN        WTSTN
     C                   MOVEL     FLRIBN        WTMAN
     C                   MOVE      FLPOBR        WOSDB
     C                   MOVE      FLROBR        WOMDB
      *  Part Sold
     C                   ELSE
     C                   MOVE      FLRSTM        WSDST
     C                   MOVE      FLPSTM        WMDST
     C                   MOVE      FLRONS        WOSDA
     C                   MOVE      FLPONS        WOMDA
     C                   MOVEL     FLRIBN        WTSTN
     C                   MOVEL     FLAWBN        WTMAN
     C                   MOVE      FLROBR        WOSDB
     C                   MOVE      FLPOBR        WOMDB
     C                   ENDIF
     C                   MOVEL     FLBENN        WFACO
     C                   ENDIF                                                                CLE034
      *
      ***  Extra validation after the Extended Settlements
      *
     C                   CALLB     'LECLIPEVL'

      * INPUTS

      * Response mode
     C                   PARM      'S'           RespMode
      * Loan details screen 1 and 2
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
                                                                                              CLE141
      ** Business Day Convention Screen Detail                                                CLE141
     C                   PARM                    TranInSeven                                  CLE141
                                                                                              CLE141
      ***  Generated by Principal Transfer from PT Midas input
     C                   PARM                    PGNTF             1
      ***  Pay Settlement Currency
     C                   PARM                    DDPSCY
      ***  Receive Settlement Currency                                                        CLE031
     C                   PARM                    DDRSCY                                       CLE031
      ***  Loan Type                                                                          CLE031
     C                   PARM                    LoanType                                     CLE031

      * OUTPUTS

      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKClPrim
     C                   PARM                    OKClSeco
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ***  Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      ***  Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      ***  Shared data
     C                   PARM                    TransData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863

     C                   IF        DDSTAL <> 'Y'                                              CLE034
      *
      * UPDATE VALID Loan: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   IF        DDACTN  = 'I'                                            BUG21167
     C**********         MOVEL     FLPAY         ValidPAY                                     247545
     C**********         MOVEL     FLPONS        ValidPAYEx                            CGL029 247545
     C**********         MOVEL     FLPSTM        VL_CLPSTM                             CGL029 247545
     C**********         MOVE      FLCVMR        VL_CLCVMR                                    247545
     C                   MOVEL     FLPAY         ValidPAY                                   BUG21167
     C                   MOVEL     FLPONS        ValidPAYEx                                 BUG21167
     C                   MOVEL     FLPSTM        VL_CLPSTM                                  BUG21167
     C                   MOVE      FLCVMR        VL_CLCVMR                                  BUG21167
     C                   ENDIF                                                              BUG21167
      *                                                                                      255159A
      ** Pay settlement lost during insert, protect fields (pay/receipt)                     255159A
      ** on JAVA when loan has started,  same with R4 processing.                            255159A
      *                                                                                      255159A
     C                   MOVEL     FLPAY         ValidPAY                                    255159A
     C                   MOVEL     FLPONS        ValidPAYEx                                  255159A
     C                   MOVEL     FLPSTM        VL_CLPSTM                                   255159A
     C                   MOVE      FLCVMR        VL_CLCVMR                                   255159A
     C                   MOVE      FLPSCY        VL_CLSCCY
     C                   MOVE      FLIC72        VL_CLICCY
      *
      * UPDATE VALID Loan: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLREC         ValidREC
     C                   MOVEL     FLRONS        ValidRECEx                                   CGL029
     C                   MOVEL     FLRSTM        VL_CLRSTM                                    CGL029
     C                   MOVE      FLRSCY        VL_CLSCCY
      *                                                                                       CLE031
     C                   Z-ADD     FLREXR        VL_CLREXR                                    CLE031
     C                   Z-ADD     FLPEXR        VL_CLPEXR                                    CLE031
     C                   MOVE      FLREXI        VL_CLREXI                                    CLE031
     C                   MOVE      FLPEXI        VL_CLPEXI                                    CLE031
     C                   MOVE      FLRSCY        VL_CLSCCY                                    CLE031
     C                   MOVE      FLPSCY        VL_CLPSCY                                    CLE031
      *                                                                                       CLI002
      * UPDATE VALID Loan: OUR STATT DATE & OUR MATURITY DATE INSTRUCTIONS
      *                                                                                       CLI002
     C                   MOVE      WSDST         VL_CLSDST
     C                   MOVEL     WOSDA         VL_CLOSDA
     C                   MOVE      WOSDB         VL_CLOSDB
     C                   MOVEL     WTSTN         VL_CLTSTN

     C                   MOVE      WMDST         VL_CLMDST
     C                   MOVEL     WOMDA         VL_CLOMDA
     C                   MOVE      WOMDB         VL_CLOMDB
     C                   MOVEL     WTMAN         VL_CLTMAN
     C                   MOVEL     WFACO         VL_CLFACO
     C                   ENDIF                                                                CLE034

     C                   ENDSR
      *****************************************************************                       CDE005
      /EJECT                                                                                  CDE005
      *****************************************************************                       CDE005
      *                                                               *                       CDE005
      * ValdTrResv - Validate Reservation ID                          *                       CDE005
      *                                                               *                       CDE005
      *****************************************************************                       CDE005
     C     ValdTrResv    BEGSR                                                                CDE005
                                                                                              CDE005
     C                   CALLB     'LERSVIDVL'                                                CDE005
     C                   PARM      'LE'          Module            2                          CDE005
     C                   PARM                    LoanType                                     CDE005
     C                   PARM                    DDACTN                                       CDE005
     C                   PARM                    ReservID                                     CDE005
     C                   PARM                    FldNameArr                                   CDE005
     C                   PARM                    MsgIdArr                                     CDE005
     C                   PARM                    MsgDtaArr                                    CDE005
     C                   PARM                    Idx                                          CDE005
                                                                                              CDE005
     C                   ENDSR                                                                CDE005
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * ValdExtDtl - Validate customer loans inputs extension details *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     ValdExtDtl    BEGSR                                                                CER001
     C                   MOVE      VL_CLLNRF     #1LNRF                                       CER001
     C                   MOVE      VL_CLCNUM     #1CUST                                       CER001
     C                   MOVE      VL_CLPTYP     #1PTYP                                       CER001
     C                   MOVE      VL_CLCCY      #1CCY                                        CER001
     C                   MOVE      VL_CLCPAM     #1AMNT                                       CER001
     C                   CALLB     'LECLIP5VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OKCLEXFlgs                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidCLIPEx                                  CER001
     C                   PARM                    @ACTRV                                     AR804863
     C                   ENDSR                                                                CER001
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments.                                             *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      * Set up modified Settlement payments fields from screen                                247545
      * to ValidClil for validation and update                                                247545
                                                                                              247545
     C                   MOVEL     DDPSTM        VL_CLPSTM                                    247545
      *                                                                                     MD032110
     C                   If        DDPSTM <> '05'                                           MD032110
     C                   MOVEL     DDPONX        VL_CLPONS                                    247545
     C                   Else                                                               MD032110
     C                   Eval      VL_CLPONS = *Blanks                                      MD032110
     C                   Eval      VL_CLPONS = %Subst(DDPONX:4:18)                          MD032110
     C                   EndIf                                                              MD032110
      *                                                                                     MD032110
     C                   EVAL      VL_CLRVNO = DDRVNO                                         247545
     C                   EVAL      VL_CLCVMR = DDCVMR                                         247545
     C                   MOVEL     DDPOBN        VL_CLPOBN                                    247545
                                                                                              247545
     C                   IF        DDPOCN <> *BLANKS                                          247545
     C                   MOVEL     DDPOCN        PCUST                                        247545
     C                   CALLB     'AOCUSTR0'                                                 247545
     C                   PARM      *BLANKS       PRTCD                                        247545
     C                   PARM      '*KEY'        POPTN                                        247545
     C                   Parm                    PCUST                                        247545
     C                   PARM      *BLANKS       PSTKEY                                       247545
     C     SDCUST        PARM      SDCUST        DSSDY                                        247545
                                                                                              247545
     C                   IF        PRTCD <> *BLANKS                                           247545
     C                             AND PRTCD <> '*NRF   '                                     247545
     C                   EVAL      DBKEY = POPTN                                              247545
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        247545
     C                   EVAL      DBASE = 908                                                247545
     C                   EXSR      *PSSR                                                      247545
     C                   ENDIF                                                                247545
     C                   MOVEL     BBCUST        VL_CLPOCN                                    247545
     C                   ELSE                                                                 247545
     C                   MOVEL     *BLANKS       VL_CLPOCN                                    247545
     C                   ENDIF                                                                247545
                                                                                              247545
     C                   EVAL      VL_CLRCRN = DDRCRN                                         247545
     C                   EVAL      VL_CLRCRA = DDRCRA                                         247545
     C                   EVAL      VL_CLPIBN = DDPIBN                                         247545
     C                   EVAL      VL_CLPIBA = DDPIBA                                         247545
     C                   EVAL      VL_CLAWBN = DDAWBN                                         247545
     C                   EVAL      VL_CLAWBA = DDAWBA                                         247545
                                                                                              247545
     C                   IF        DDBENN <> *BLANKS                                          247545
     C                   MOVEL     DDBENN        PCUST                                        247545
     C                   CALLB     'AOCUSTR0'                                                 247545
     C                   PARM      *BLANKS       PRTCD                                        247545
     C                   PARM      '*KEY'        POPTN                                        247545
     C                   Parm                    PCUST                                        247545
     C                   PARM      *BLANKS       PSTKEY                                       247545
     C     SDCUST        PARM      SDCUST        DSSDY                                        247545
                                                                                              247545
     C                   IF        PRTCD <> *BLANKS                                           247545
     C                             AND PRTCD <> '*NRF   '                                     247545
     C                   EVAL      DBKEY = POPTN                                              247545
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        247545
     C                   EVAL      DBASE = 909                                                247545
     C                   EXSR      *PSSR                                                      247545
     C                   ENDIF                                                                247545
     C                   MOVEL     BBCUST        VL_CLBENN                                    247545
     C                   ELSE                                                                 247545
     C                   MOVEL     *BLANKS       VL_CLBENN                                    247545
     C                   ENDIF                                                                247545
                                                                                              247545
     C                   EVAL      VL_CLBENA = DDBENA                                         247545
     C                   EVAL      VL_CLDTP1 = DDDTP1                                         247545
     C                   EVAL      VL_CLDTP2 = DDDTP2                                         247545
     C                   EVAL      VL_CLDTP3 = DDDTP3                                         247545
     C                   EVAL      VL_CLDTP4 = DDDTP4                                         247545
     C                   EVAL      VL_CLDCHG = DDDCHG                                         247545
     C                   EVAL      VL_CLBTB1 = DDBTB1                                         247545
     C                   EVAL      VL_CLBTB2 = DDBTB2                                         247545
     C                   EVAL      VL_CLBTB3 = DDBTB3                                         247545
     C                   EVAL      VL_CLBTB4 = DDBTB4                                         247545
     C                   EVAL      VL_CLBTB5 = DDBTB5                                         247545
     C                   EVAL      VL_CLBTB6 = DDBTB6                                         247545
                                                                                              247545
     C                   IF        CER050 = 'Y'                                             MD054028
     C                   EVAL      VL_CLAPRC = DDAPRC                                       MD054028
     C     DDAPRC        IFEQ      'Y'                                                      MD054028
     C     DDPREM        ANDNE     *BLANKS                                                  MD054028
     C                   EVAL      VL_CLPREM = %DECH(%TRIM(DDPREM):13:2)*100                MD054028
     C                   ELSE                                                               MD054028
     C                   EVAL      VL_CLPREM = 0                                            MD054028
     C                   ENDIF                                                              MD054028
     C                   ENDIF                                                              MD054028
      * 	                                                                                MD054028
      ** Setup work field                                                                    BUG3721
                                                                                             BUG3721
     C                   MOVE      'N'           WPRCS2            1                         BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     CL_RECI       ANDEQ     'D'                                                       BUG3721
     C     DDACTN        ANDEQ     'A'                                                       BUG3721
     C     CL_PTYP       ANDEQ     80                                                        BUG3721
     C     CL_VDAT       ANDLT     BJRDNB                                                    BUG3721
     C     CL_ORED       ANDNE     BJRDNB                                                    BUG3721
     C                   MOVE      'Y'           WPRCS2                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      * For Amends, convert the customer loan to screen format 1

     C                   CALLB     'LECLIP1CT'
      * Inputs

      * Return Code
     C                   PARM                    RetCodeIn
      * Customer loans - file formats
     C                   PARM                    ValidClil
     C                   PARM                    ValidClik
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDPREM           15                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028

      * Output parameters
      * Customer loans Details - screen formats 1
     C                   PARM                    CurClPrim

     C                   MOVE      DDAPRC        @DDAPRC                                    MD054028
     C                   MOVE      DDPREM        @DDPREM                                    MD054028
     C                   MOVE      DDAPRR        @DDAPRR                                    MD054028
      * For Amends, convert the customer loan to screen format 2

     C                   CALLB     'LECLIP2CT'

      * INPUTS

      * Return Code
     C                   PARM                    RetCodeIn
      * Customer loans - file formats
     C                   PARM                    ValidClil
     C                   PARM                    ValidClik
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721

      * Output parameters

      * Customer loans Details - screen formats 2
     C                   PARM                    CurClSeco

      * For Amends, convert the customer loan to screen format 3

     C                   CALLB     'LECLIP3CT'

      * INPUTS

      * Return Code
     C                   PARM                    RetCodeIn
      * Customer loans - file formats
     C                   PARM                    ValidClil
     C                   PARM                    ValidClik

      * Output parameters

      * Customer loans Details - screen formats 3
     C                   PARM                    CurClThir

      * For Amends, convert the customer loan to screen format 4

     C                   CALLB     'LECLIP4CT'

      * INPUTS

      * Return Code
     C                   PARM                    RetCodeIn
      * Customer loans - file formats
     C                   PARM                    ValidClil
     C                   PARM                    ValidClik

      * Output parameters

      * Customer loans Details - screen formats 4
     C                   PARM                    CurClFour
     C                   PARM                    CurClSix                                     CLE134
     C                   PARM                    CurClSeven                                   CLE141
      *                                                                                     AR804863
      ** If Reject is actioned, reverse settlements.                                        AR804863
      *                                                                                     AR804863
     C     @ACTRV        IFEQ      'Y'                                                      AR804863
     C                   EXSR      SRRSFD                                                   AR804863
     C                   ENDIF                                                              AR804863
                                                                                            AR804863

      ***  Set up payment instructions from loan

     C                   MOVEL     ClipFilPAY    FLPAY
     C                   MOVEL     ClipFilPAYEx  FLPONS                                       CGL029
     C                   MOVEL     CL_PSTM       FLPSTM                                       CGL029
     C                   MOVE      CL_CVMR       FLCVMR
     C                   MOVE      CL_SCCY       FLPSCY
     C                   MOVE      CL_ICCY       FLIC72
      *
      * If not a Part Sold, pay branch is our start date branch
      * If Part Sold, pay branch is our maturity date branch
     C     LoanType      IFNE      'PTSO'
     C                   MOVE      CL_OSDB       FLPOBR
     C                   ELSE
     C                   MOVE      CL_OMDB       FLPOBR
     C                   ENDIF

      ***  Set up receive instructions from loan

     C                   MOVEL     ClipFilREC    FLREC
     C                   MOVEL     ClipFilRECEx  FLRONS                                       CGL029
     C                   MOVEL     CL_RSTM       FLRSTM                                       CGL029
     C                   MOVE      CL_SCCY       FLRSCY
      *
      * If not a Part Sold, receive branch is our maturity date branch
      * If Part Sold, receive branch is our start date branch
     C     LoanType      IFNE      'PTSO'
     C                   MOVE      CL_OMDB       FLROBR
     C                   ELSE
     C                   MOVE      CL_OSDB       FLROBR
     C                   ENDIF
      *                                                                                       CLE031
     C                   Z-ADD     CL_REXR       FLREXR                                       CLE031
     C                   Z-ADD     CL_PEXR       FLPEXR                                       CLE031
     C                   MOVE      CL_REXI       FLREXI                                       CLE031
     C                   MOVE      CL_PEXI       FLPEXI                                       CLE031
     C                   MOVE      CL_SCCY       FLRSCY                                       CLE031
     C                   MOVE      CL_PSCY       FLPSCY                                       CLE031

      *  The sett instructions are in file format (retrieved on ValidateAc, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.

     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM      *BLANK        ##FRIF

      ** Current Settlement Instruction in input format
     C                   PARM                    C_Pay
     C                   PARM                    C_Rec
     C                   PARM                    C_FRA
     C                   PARM      @DDCURR       #TRCCY                                      CSF011A
     C                   PARM      @DDCURR       #TPCCY                                      CSF011A

      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the deal.

     C                   IF            (##PAYS = *blank)
     C                   EVAL      ##PAYS = C_Pay
     C                   ENDIF

     C                   IF            (##RECS = *blank)
     C                   EVAL      ##RECS = C_Rec
     C                   ENDIF

      ** Format fields from WIP (Work in Progress)                                            CLE106
      ** to match formatting being done in CVT modules on records                             CLE106
      ** retrieved from file.                                                                 CLE106
                                                                                              CLE106
     C                   CALLB     'LECLIPWIP'                                                CLE106
     C                   PARM                    TranInPrim                                   CLE106
     C                   PARM                    TranInSeco                                   CLE106
     C                   PARM                    TranInThir                                   CLE106

     C                   IF        LLN007 = 'Y'                                             MD044880
     C                   CALLB     'LECLIPCVT1'                                             MD044880
     C                   PARM                    ReturnCode                                 MD044880
     C                   PARM                    DDLNRF                                     MD044880
     C                   PARM                    ClExtFilFmt                                MD044880
     C                   PARM                    C_EXTDATA                                  MD044880
     C                   PARM                    BJDFIN                                     MD044880
     C                   ENDIF                                                              MD044880

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
     C     ValdateAmd    BEGSR

      * This subroutine calls procedures which check whether it
      * was valid to Amend or Change any of the fields which have been
      * altered.

      * First Screen
     C                   CALLB     'LECLIP1AD'

      * INPUTS

      * Return Code
     C                   PARM                    RetCodeIn
      * Incoming Customer Loans in Screen Format :
     C                   PARM                    TraninPrim
      * (Current) Customer Loans in Screen Format :
     C                   PARM                    CurClPrim
      * (Current) Loan in file format:
     C                   PARM                    ClilFilFmt
     C                   PARM                    ClikFilFmt
      * Calling type
     C                   PARM                    LoanType          4

      * OUTPUTS

      * Error Indicators
     C                   PARM                    OKClPrim
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1

      * If any errors overwrite previous error information

     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   GOTO      EndAmend
     C                   ENDIF

      * Second Screen
     C                   CALLB     'LECLIP2AD'

      * INPUTS

      * Return Code
     C                   PARM                    RetCodeIn
      * Incoming Customer Loans in Screen Format :
     C                   PARM                    TraninSeco
      * (Current) Customer Loans in Screen Format :
     C                   PARM                    CurClSeco
      * (Current) Loan in file format:
     C                   PARM                    ClilFilFmt
     C                   PARM                    ClikFilFmt
      * Calling type
     C                   PARM                    LoanType          4
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
                                                                                             BUG3721
      ** Work fields                                                                         BUG3721
     C                   PARM                    WPRCS2                                      BUG3721
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863

      * OUTPUTS

      * Error Indicators
     C                   PARM                    OKClSeco
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1

      * If any errors overwrite previous error information

     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   GOTO      EndAmend
     C                   ENDIF

      * Third Screen
     C                   CALLB     'LECLIP3AD'

      * INPUTS

      * Return Code
     C                   PARM                    RetCodeIn
      * Incoming Customer Loans in Screen Format :
     C                   PARM                    TraninThir
      * (Current) Customer Loans in Screen Format :
     C                   PARM                    CurClThir
      * (Current) Loan in file format:
     C                   PARM                    ClilFilFmt
     C                   PARM                    ClikFilFmt
      * Calling type
     C                   PARM                    LoanType          4

      * OUTPUTS

      * Error Indicators
     C                   PARM                    OKClThir
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1

      * If any errors overwrite previous error information

     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   GOTO      EndAmend
     C                   ENDIF

      * Fourth Screen
     C                   CALLB     'LECLIP4AD'

      * INPUTS

      * Return Code
     C                   PARM                    RetCodeIn
      * Incoming Customer Loans in Screen Format :
     C                   PARM                    TraninFour
     C                   PARM                    TraninSix                                    CLE134
     C                   PARM                    TraninSeven                                  CLE141
      * (Current) Customer Loans in Screen Format :
     C                   PARM                    CurClFour
     C                   PARM                    CurClSix                                     CLE134
     C                   PARM                    CurClSeven                                   CLE141
      * (Current) Loan in file format:
     C                   PARM                    ClilFilFmt
     C                   PARM                    ClikFilFmt
      * Calling type
     C                   PARM                    LoanType          4

      * OUTPUTS

      * Error Indicators
     C                   PARM                    OKClFour
     C                   PARM                    OKClSix                                      CLE134
     C                   PARM                    OKClSeven                                    CLE141
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1

      * If any errors overwrite previous error information

     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF

     C     EndAmend      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR

     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
      *                                                                                       LLN022
      ** If BOE installed, validate fields.                                                  LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   MOVEL     VL_CLLNRF     LVLNRF                                      LLN022A
      *                                                                                      LLN022A
      ** Call Validation Module                                                              LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LECLIPUPD1'                                              LLN022A
     C
     C                   PARM                    PRTCD                                       LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    ValidBoe                                    LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF

     C                   ENDSR
      *****************************************************************                     AR804863
      /EJECT                                                                                AR804863
      *****************************************************************                     AR804863
      *                                                               *                     AR804863
      * SRRSFD  -  Restore original details (for Reject Action)       *                     AR804863
      *                                                               *                     AR804863
      *****************************************************************                     AR804863
     C     SRRSFD        BEGSR                                                              AR804863
      *                                                                                     AR804863
     C                   IF        DDPIBN <> *BLANKS                                        MD034643
     C                             and %SUBST(DDPIBN:9:1) <> *Blanks                        MD034643
     C                   MOVEL     DDPIBN        PCUST                                      MD034643
     C                   EXSR      SRCSTDET                                                 MD034643
     C                   MOVE      *BLANKS       CL_PIBN                                    MD034643
     C                   MOVEL     BBCUST        CL_PIBN                                    MD034643
     C                   ELSE                                                               MD034643
     C                   MOVEL     DDPIBN        CL_PIBN                                    AR804863
     C                   ENDIF                                                              MD034643
      *                                                                                     MD034643
     C                   MOVEL     DDPIBA        CL_PIBA                                    AR804863
     C**********         MOVEL     DDPOBN        CL_POBN                           AR804863 MD034643
      *                                                                                     MD034643
     C                   IF        DDPOBN <> *BLANKS                                        MD034643
     C                   MOVEL     DDPOBN        PCUST                                      MD034643
     C                   EXSR      SRCSTDET                                                 MD034643
     C                   MOVEL     BBCUST        CL_POBN                                    MD034643
     C                   ELSE                                                               MD034643
     C                   MOVEL     *BLANKS       CL_POBN                                    MD034643
     C                   ENDIF                                                              MD034643
      *                                                                                     AR804863
     C                   IF        DDPOCN <> *BLANKS                                        AR804863
     C                   MOVEL     DDPOCN        PCUST                                      AR804863
     C                   CALLB     'AOCUSTR0'                                               AR804863
     C                   PARM      *BLANKS       PRTCD                                      AR804863
     C                   PARM      '*KEY'        POPTN                                      AR804863
     C                   Parm                    PCUST                                      AR804863
     C                   PARM      *BLANKS       PSTKEY                                     AR804863
     C     SDCUST        PARM      SDCUST        DSSDY                                      AR804863
     C                   MOVEL     BBCUST        CL_POCN                                    AR804863
     C                   ELSE                                                               AR804863
     C                   MOVEL     *BLANKS       CL_POCN                                    AR804863
     C                   ENDIF                                                              AR804863
      *                                                                                     AR804863
     C                   IF        DDRCRN <> *BLANKS                                        MD034643
     C                             and %SUBST(DDRCRN:9:1) <> *Blanks                        MD034643
     C                   MOVEL     DDRCRN        PCUST                                      MD034643
     C                   EXSR      SRCSTDET                                                 MD034643
     C                   MOVE      *BLANKS       CL_RCRN                                    MD034643
     C                   MOVEL     BBCUST        CL_RCRN                                    MD034643
     C                   ELSE                                                               MD034643
     C                   MOVEL     DDRCRN        CL_RCRN                                    AR804863
     C                   ENDIF                                                              MD034643
      *                                                                                     MD034643
     C                   MOVEL     DDRCRA        CL_RCRA                                    AR804863
      *                                                                                     MD034643
     C                   IF        DDRVNO <> *BLANKS                                        MD034643
     C                             and %SUBST(DDRVNO:9:1) <> *Blanks                        MD034643
     C                   MOVEL     DDRVNO        PCUST                                      MD034643
     C                   EXSR      SRCSTDET                                                 MD034643
     C                   MOVE      *BLANKS       CL_RVNO                                    MD034643
     C                   MOVEL     BBCUST        CL_RVNO                                    MD034643
     C                   ELSE                                                               MD034643
     C                   MOVEL     DDRVNO        CL_RVNO                                    AR804863
     C                   ENDIF                                                              MD034643
      *                                                                                     MD034643
     C                   IF        DDAWBN <> *BLANKS                                        MD034643
     C                             and %SUBST(DDAWBN:9:1) <> *Blanks                        MD034643
     C                   MOVEL     DDAWBN        PCUST                                      MD034643
     C                   EXSR      SRCSTDET                                                 MD034643
     C                   MOVE      *BLANKS       CL_AWBN                                    MD034643
     C                   MOVEL     BBCUST        CL_AWBN                                    MD034643
     C                   ELSE                                                               MD034643
     C                   MOVEL     DDAWBN        CL_AWBN                                    AR804863
     C                   ENDIF                                                              MD034643
      *                                                                                     MD034643
     C                   MOVEL     DDAWBA        CL_AWBA                                    AR804863
      *                                                                                     AR804863
     C                   IF        DDBENN <> *BLANKS                                        AR804863
     C                             and %SUBST(DDBENN:9:1) <> *Blanks                        MD034643
     C                   MOVEL     DDBENN        PCUST                                      AR804863
     C                   CALLB     'AOCUSTR0'                                               AR804863
     C                   PARM      *BLANKS       PRTCD                                      AR804863
     C                   PARM      '*KEY'        POPTN                                      AR804863
     C                   Parm                    PCUST                                      AR804863
     C                   PARM      *BLANKS       PSTKEY                                     AR804863
     C     SDCUST        PARM      SDCUST        DSSDY                                      AR804863
     C                   MOVEL     *BLANKS       CL_BENN                                    MD034643
     C                   MOVEL     BBCUST        CL_BENN                                    AR804863
     C                   ELSE                                                               AR804863
     C**********         MOVEL     *BLANKS       CL_BENN                           AR804863 MD034643
     C                   MOVEL     DDBENN        CL_BENN                                    MD034643
     C                   ENDIF                                                              AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDBENA        CL_BENA                                    AR804863
     C                   MOVEL     DDDTP1        CL_DTP1                                    AR804863
     C                   MOVEL     DDDTP2        CL_DTP2                                    AR804863
     C                   MOVEL     DDDTP3        CL_DTP3                                    AR804863
     C                   MOVEL     DDDTP4        CL_DTP4                                    AR804863
     C                   MOVEL     DDDCHG        CL_DCHG                                    AR804863
     C                   MOVEL     DDBTB1        CL_BTB1                                    AR804863
     C                   MOVEL     DDBTB2        CL_BTB2                                    AR804863
     C                   MOVEL     DDBTB3        CL_BTB3                                    AR804863
     C                   MOVEL     DDBTB4        CL_BTB4                                    AR804863
     C                   MOVEL     DDBTB5        CL_BTB5                                    AR804863
     C                   MOVEL     DDBTB6        CL_BTB6                                    AR804863
      *                                                                                     AR804863
     C                   IF        DDRIBN <> *BLANKS                                        MD034643
     C                             and %SUBST(DDRIBN:9:1) <> *Blanks                        MD034643
     C                   MOVEL     DDRIBN        PCUST                                      MD034643
     C                   EXSR      SRCSTDET                                                 MD034643
     C                   MOVEL     BBCUST        CL_RIBN                                    MD034643
     C                   ELSE                                                               MD034643
     C                   MOVEL     DDRIBN        CL_RIBN                                    AR804863
     C                   ENDIF                                                              MD034643
      *                                                                                     MD034643
     C                   MOVEL     DDRIBA        CL_RIBA                                    AR804863
     C**********         MOVEL     DDROBN        CL_ROBN                           AR804863 MD034643
     C**********         MOVEL     DDROCN        CL_ROCN                           AR804863 MD034643
      *                                                                                     MD034643
     C                   IF        DDROBN <> *BLANKS                                        MD034643
     C                   MOVEL     DDROBN        PCUST                                      MD034643
     C                   EXSR      SRCSTDET                                                 MD034643
     C                   MOVEL     BBCUST        CL_ROBN                                    MD034643
     C                   ELSE                                                               MD034643
     C                   MOVEL     *BLANKS       CL_ROBN                                    MD034643
     C                   ENDIF                                                              MD034643
      *                                                                                     MD034643
     C                   IF        DDROCN <> *BLANKS                                        MD034643
     C                   MOVEL     DDROCN        PCUST                                      MD034643
     C                   EXSR      SRCSTDET                                                 MD034643
     C                   MOVEL     BBCUST        CL_ROCN                                    MD034643
     C                   ELSE                                                               MD034643
     C                   MOVEL     *BLANKS       CL_ROCN                                    MD034643
     C                   ENDIF                                                              MD034643
      *                                                                                     AR804863
     C                   Eval      CL_PONS = *Blanks                                        MD032110
     C                   Eval      CL_RONS = *Blanks                                        MD032110
      *                                                                                     MD032110
     C                   If        DDPSTM <> '05'                                           MD032110
     C                   MOVEL     DDPONX        CL_PONS                                    AR804863
     C                   Else                                                               MD032110
     C                   Eval      CL_PONS = %Subst(DDPONX:4:18)                            MD032110
     C                   EndIf                                                              MD032110
      *                                                                                     MD032110
     C                   If        DDRSTM <> '05'                                           MD032110
     C                   MOVEL     DDRONX        CL_RONS                                    AR804863
     C                   Else                                                               MD032110
     C                   Eval      CL_RONS = %Subst(DDRONX:4:18)                            MD032110
     C                   EndIf                                                              MD032110
      *                                                                                     AR804863
     C                   MOVEL     DDPSTM        CL_PSTM                                    AR804863
     C                   MOVE      DDCVMR        CL_CVMR                                    AR804863
     C                   MOVE      DDPSCY        CL_SCCY                                    AR804863
     C                   MOVE      DDIC72        CL_ICCY                                    AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDPSTM        CL_RSTM                                    AR804863
     C                   MOVE      DDRSCY        CL_SCCY                                    AR804863
      *                                                                                     MD034643
     C                   MOVE      DDPEXI        CL_PEXI                                    MD034643
     C                   MOVE      DDPEXR        CL_PEXR                                    MD034643
     C                   MOVE      DDREXI        CL_REXI                                    MD034643
     C                   MOVE      DDREXR        CL_REXR                                    MD034643
      *                                                                                     MD034643
      ** Retrieve settlement branch                                                         MD034643
      *                                                                                     MD034643
     C                   Eval      ##PPAY = 'N'                                             MD034643
     C                   Eval      ##PREC = 'N'                                             MD034643
      *                                                                                     MD034643
     C                   If        CL_VDAT < BJRDNB and CL_ORED < BJRDNB                    MD034643
      *                                                                                     MD034643
     C                   If        LoanType = 'PTSO'                                        MD034643
     C                   Eval       ##PREC = 'Y'                                            MD034643
     C                   Else                                                               MD034643
     C                   Eval       ##PPAY = 'Y'                                            MD034643
     C                   EndIf                                                              MD034643
      *                                                                                     MD034643
     C                   EndIf                                                              MD034643
      *                                                                                     MD034643
     C                   EVAL      WSCCY = DDCURR                                           MD034643
      *                                                                                     MD034643
     C                   If        ##PPAY = 'N'                                             MD034643
      *                                                                                     MD034643
      ** Start Settlement Branch                                                            MD034643
      *                                                                                     MD034643
     C                   If        LoanType = 'PTSO'                                        MD034643
     C                   Eval      WSETP = %INT(DDRSTM)                                     MD034643
     C                   Eval      WOSAC = DDRONX                                           MD034643
      *                                                                                     MD034643
     C                   If        DDRSCY <> *Blanks                                        MD034643
     C                   Eval      WSCCY = DDRSCY                                           MD034643
     C                   EndIf                                                              MD034643
      *                                                                                     MD034643
     C                   Else                                                               MD034643
     C                   Eval      WSETP = %INT(DDPSTM)                                     MD034643
     C                   Eval      WOSAC = DDPONX                                           MD034643
      *                                                                                     MD034643
     C                   If        DDPSCY <> *Blanks                                        MD034643
     C                   Eval      WSCCY = DDPSCY                                           MD034643
     C                   EndIf                                                              MD034643
     C                   EndIf                                                              MD034643
      *                                                                                     MD034643
     C                   ExSR      SRRTVBRC                                                 MD034643
      *                                                                                     MD034643
     C                   Eval      CL_OSDB = WOSBR                                          MD034643
     C                   EndIf                                                              MD034643
      *                                                                                     MD034643
     C                   If        ##PREC = 'N'                                             MD034643
      *                                                                                     MD034643
      ** Maturity Settlement Branch                                                         MD034643
      *                                                                                     MD034643
     C                   If        LoanType = 'PTSO'                                        MD034643
     C                   Eval      WSETP = %INT(DDPSTM)                                     MD034643
     C                   Eval      WOSAC = DDPONX                                           MD034643
      *                                                                                     MD034643
     C                   If        DDPSCY <> *Blanks                                        MD034643
     C                   Eval      WSCCY = DDPSCY                                           MD034643
     C                   EndIf                                                              MD034643
      *                                                                                     MD034643
     C                   Else                                                               MD034643
     C                   Eval      WSETP = %INT(DDRSTM)                                     MD034643
     C                   Eval      WOSAC = DDRONX                                           MD034643
      *                                                                                     MD034643
     C                   If        DDRSCY <> *Blanks                                        MD034643
     C                   Eval      WSCCY = DDRSCY                                           MD034643
     C                   EndIf                                                              MD034643
     C                   EndIf                                                              MD034643
      *                                                                                     MD034643
     C                   ExSR      SRRTVBRC                                                 MD034643
      *                                                                                     MD034643
     C                   Eval      CL_OMDB = WOSBR                                          MD034643
     C                   EndIf                                                              MD034643
      *                                                                                     AR804863
     C                   ENDSR                                                              AR804863
      *****************************************************************
      /EJECT
      *****************************************************************                     MD034643
      *                                                               *                     MD034643
      * SRRTVBRC = Retrieve Settlement Account Branch                 *                     MD034643
      *                                                               *                     MD034643
      *****************************************************************                     MD034643
     C     SRRTVBRC      BEGSR                                                              MD034643
      *                                                                                     MD034643
     C                   Eval      P@ACCT = *Blanks                                         MD034643
     C                   Eval      WOSBR  = *Blanks                                         MD034643
      *                                                                                     MD034643
     C                   Select                                                             MD034643
      *                                                                                     MD034643
      ** Nostro Account                                                                     MD034643
      *                                                                                     MD034643
     C                   When      WSETP = 01 or WSETP = 02                                 MD034643
     C                             or WSETP = 07 or WSETP = 08                              MD034643
     C                             or WSETP = 12                                            MD034643
     C                   Eval      P@ACCT = WSCCY + WOSAC                                   MD034643
      *                                                                                     MD034643
     C                   CallB     'AOACCTV1'                                               MD034643
     C                   Parm      *Blanks       P@RTCD           10                        MD034643
     C                   Parm      *Blanks       P@TYPE           10                        MD034643
     C                   Parm                    P@ACCT           35                        MD034643
     C     SDNOST        Parm      *Blanks       DSSDY                                      MD034643
      *                                                                                     MD034643
     C                   Eval      WOSBR  = A7BRCD                                          MD034643
      *                                                                                     MD034643
      ** Customer Prime Account                                                             MD034643
      *                                                                                     MD034643
     C                   When      WSETP = 04                                               MD034643
     C                   Eval      WOSBR = DDBRCA                                           MD034643
      *                                                                                     MD034643
      ** Midas Account                                                                      MD034643
      *                                                                                     MD034643
     C                   When      WSETP = 05                                               MD034643
     C                   Eval      WOSBR = %SUBST(WOSAC:1:3)                                MD034643
      *                                                                                     MD034643
      ** Retail Account                                                                     MD034643
      *                                                                                     MD034643
     C                   When      WSETP = 14                                               MD034643
     C                   Eval      P@ACCT = WOSAC                                           MD034643
      *                                                                                     MD034643
     C                   CallB     'AOACCTV1'                                               MD034643
     C                   Parm      *Blanks       P@RTCD                                     MD034643
     C                   Parm      *Blanks       P@TYPE                                     MD034643
     C                   Parm                    P@ACCT                                     MD034643
     C     ACCNT         Parm      *Blanks       DSSDY                                      MD034643
      *                                                                                     MD034643
     C                   Eval      WOSBR  = AC_BRCA                                         MD034643
     C                   EndSl                                                              MD034643
      *                                                                                     MD034643
     C                   ENDSR                                                              MD034643
      *****************************************************************                     MD034643
      /EJECT                                                                                MD034643
      *****************************************************************                     MD034643
      *                                                               *                     MD034643
      * SRCSTDET = Retrieve Customer/Country Nostro Details           *                     MD034643
      *                                                               *                     MD034643
      *****************************************************************                     MD034643
     C     SRCSTDET      BEGSR                                                              MD034643
      *                                                                                     MD034643
     C                   CALLB     'AOCUSTR0'                                               MD034643
     C                   PARM      *BLANKS       PRTCD                                      MD034643
     C                   PARM      '*KEY'        POPTN                                      MD034643
     C                   Parm                    PCUST                                      MD034643
     C                   PARM      *BLANKS       PSTKEY                                     MD034643
     C     SDCUST        PARM      SDCUST        DSSDY                                      MD034643
      *                                                                                     MD034643
     C                   ENDSR                                                              MD034643
      *****************************************************************                     MD034643
      /EJECT                                                                                MD034643
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
     C     SETUPVALID    BEGSR

      * For Reversed put the complete (pre-existing) Customer loans
      * into the Valid file record
     C                   IF           DDACTN = 'R'
     C**********         MOVE      ClilFilFmt    ValidClil                                    CAS011
     C                   MOVEL     ClilFilFmt    ValidClil                                    CAS011
     C                   MOVE      ClikFilFmt    ValidClik
     C                   MOVE      DDACTN        VL_CLCHTP
     C                   MOVE      DDACTN        VK_CLCHTP
     C                   IF        ULX004 = 'Y'  AND LoanType <> 'PTSO'                     BUG10604
     C                   MOVEL     CLIPExFilFmt  ValidCLIPEx                                BUG10604
     C                   ENDIF                                                              BUG10604
     C                   ENDIF
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      VL_CLAUTH = IF_AUTH                                        CAP086
     C                   ELSE                                                               MD020578
     C                   EVAL      VL_CLAUTH = *BLANKS                                      MD020578
     C                   ENDIF                                                                CAP086
      *                                                                                       CLE134
      ** Set CLE134 unused fields                                                             CLE134
      *                                                                                       CLE134
     C                   IF        CLE134 = 'Y'                                               CLE134
     C                   EVAL      VL_CLRICC = 0                                              CLE134
     C                   EVAL      VL_CLBICC = 0                                              CLE134
     C                   EVAL      VL_CLFPNR = *BLANKS                                        CLE134
     C                   ENDIF                                                                CLE134

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************
     C     UPDATEDB      BEGSR
      *
      * CLIPS UPDATES
      *
      ***  Get the next available loan number
      ***  If action is I and DDLNRF still blank
      *
      *
     C                   MOVEL     DDLNRF        VL_CLLNRF
     C                   MOVEL     DDLNRF        VK_CLLNRF
     C                   EVAL      PTREF = DDLUTN                                             CLE106
      *                                                                                    AR1021983
      ** Update PDCL fields                                                                AR1021983
      *                                                                                    AR1021983
     C                   MOVEL     APFOTRANID    W#FRNT                                    AR1021983
     C                   IF        CLE134 = 'Y'                                            AR1021983
     C                   EVAL      VL_CLORLN = DDORLN                                      AR1021983
     C                   EVAL      VL_CLOFCU = DDOFCU                                      AR1021983
     C                   EVAL      VL_CLOFAC = DDOFAC                                      AR1021983
     C                   EVAL      VL_CLOFES = DDOFES                                      AR1021983
     C                   EVAL      VL_CLOFSQ = DDOFSQ                                      AR1021983
     C                   EVAL      VL_CLOFLN = DDOFLN                                      AR1021983
      *                                                                                    AR1021983
     C                   IF        APSRCSYS = 'MIDASCOB' AND                               AR1021983
     C                             W#FRNT = 'LE000473'                                     AR1021983
     C                   EVAL      VK_CLFRNT = APFOTRANID                                  AR1021983
     C                   EVAL      VL_CLFRNT = APFOTRANID                                  AR1021983
     C                   ENDIF                                                             AR1021983
     C                   ENDIF                                                             AR1021983
      *                                                                                    AR1095041
      ** Override LEPDUELB                                                                 AR1095041
      *                                                                                    AR1095041
     C                   Z-ADD     32            PCMDLEN                                   AR1095041
     C                   CALL      'QCMDEXC'                                               AR1095041
     C                   PARM                    PCMD(1)                                   AR1095041
     C                   PARM                    PCMDLEN                                   AR1095041
      *
      ***  Loans updates
      *
     C                   CALLB     'LECLIPUPD'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    ValidClil
     C                   PARM                    ValidClik
     C                   PARM                    TranInExt                                    CER049
     C                   PARM                    @PRang
     C                   PARM                    PPTIN             1
     C                   PARM                    PGNTF             1
     C                   PARM                    PTDT1            35
     C                   PARM                    PTDT2            35
     C                   PARM                    PTDT3            35
     C                   PARM                    PTREF            15
     C                   PARM                    W#SEQ             4 0
                                                                                              CDE005
      ** Reservation ID (input from VU only)                                                  CDE005
     C                   PARM                    ReservID         10                          CDE005
                                                                                              CDE005
      ** Calling module                                                                       CDE005
     C                   PARM      'JVA'         CallModCode       3                          CDE005
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
     C                   PARM                    WAUTOA            1                          245227
     C                   PARM                    WAUTOY            1                          245227
     C                   PARM                    DDFPTF                                       245273
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C                   PARM                    @DEPI                                      MD030621
     C/COPY WNCPYSRC,LECLIPXC02
      *
     C                   MOVEL     VL_CLLNRF     DDLNRF
      *                                                                                       CER001
      ** Update LECLIP extension file if switchable ULX004 is on                              CER001
      ** and non-part sold loan.                                                              CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y' And  @RTCD = *Blank And                      CER001
     C                             LoanType <> 'PTSO'                                         CER001
     C                   MOVEL     VL_CLLNRF     LKLNRF                                       CER001
     C                   CALLB     'LECLIP2UP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM      *BLANK        PFind                                        CER001
     C                   PARM                    ValidCLIPEx                                  CER001
     C                   PARM                    CLIPExFilFmt                                 CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   EVAL      DDCHIN = VL_CLCHIN                                         CLE106
                                                                                              CLE106
     C                   IF        LoanType = 'PTSO'                                          CLE106
     C                   EVAL      DDORBR = VL_CLORBR                                         CLE106
     C                   EVAL      DDPRFC = VL_CLPRFC                                         CLE106
     C                   EVAL      DDCRSK = VL_CLCRSK                                         CLE106
     C**********         IF        VL_CLLIND <> *Zeros                                 CLE106 CER020
     C                   IF        VL_CLLOIC <> *BLANKS                                       CER020
     C**********         MOVE      VL_CLLIND     DDLIND                                CLE106 CER020
     C                   MOVE      VL_CLLOIC     DDLIND                                       CER020
     C                   ELSE                                                                 CLE106
     C                   MOVE      *Blanks       DDLIND                                       CLE106
     C                   ENDIF                                                                CLE106
     C                   EVAL      DDFMIN = VL_CLFMDI                                         CLE106
     C                   MOVE      *Blanks       ZFIELD                                       CLE106
     C                   MOVE      VL_CLFCXR     ZFIELD                                       CLE106
     C                   CALL      'ZEDIT'                                                    CLE106
     C                   PARM                    ZFIELD                                       CLE106
     C                   PARM      8             ZADEC                                        CLE106
     C                   MOVE      ZFIELD        DDFCXR                                       CLE106
     C                   ENDIF                                                                CLE106
      *
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C*****@RTCD         ANDNE     '*RECUPD'                                                  246342
     C                   IF        @RTCD <> '*RECUPD'                                      MD025009B
     C                   MOVEL     '0'           APIRetc
     C                   ENDIF                                                             MD025009B
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   IF        @RTCD <> '*RECUPD'                                         246342
     C                             AND @RTCD <> '*RECLCK'                                   AR868380
     C                   EXSR      *PSSR
     C                   ENDIF                                                                246342
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
      *
      ** If update not done due to record being updated by another
      ** workstation send message to screen.

     C     @RTCD         IFEQ      '*RECUPD'

     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LEL0666'     MsgIdArr(1)

     C                   END
      *                                                                                     AR868380
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   EVAL      FldNameArr(1) = '*ANY'                                   AR868380
     C                   EVAL      MsgIdArr(1) =  'LEL0817'                                 AR868380
     C                   ENDIF                                                              AR868380

     C                   EVAl      DDLUTN = PTREF                                            CSF011A
      *                                                                                    AR1095041
      ** Delete override of LEPDUELB                                                       AR1095041
      *                                                                                    AR1095041
     C                   Z-ADD     21            PCMDLEN                                   AR1095041
     C                   CALL      'QCMDEXC'                                               AR1095041
     C                   PARM                    PCMD(2)                                   AR1095041
     C                   PARM                    PCMDLEN                                   AR1095041

     C                   ENDSR
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Initialise Customer name fields                                                     CSF011A
                                                                                             CSF011A
     C                   EVAL      DDCRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCRTN = *BLANKS                                          CSF011A
     C                   EVAL      DDPRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDPRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDPRTN = *BLANKS                                          CSF011A
     C                   EVAL      DDRESN = *BLANKS                                          CSF011A
     C                   EVAL      DDRENM = *BLANKS                                          CSF011A
     C                   EVAL      DDRETN = *BLANKS                                          CSF011A
     C                   EVAL      DDFRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDFRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDFCRT = *BLANKS                                          CSF011A
     C                   EVAL      DDCOSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCONM = *BLANKS                                          CSF011A
     C                   EVAL      DDCOTN = *BLANKS                                          CSF011A
                                                                                             CSF011A
      ** Customer Number                                                                     CSF011A
                                                                                             CSF011A
     C                   IF        DDCUST <> *BLANKS                                         CSF011A
     C                   EVAL      WCustomer = DDCUST                                        CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Purchase From                                                                       CSF011A
                                                                                             CSF011A
     C                   IF        DDPFRM <> *BLANKS                                         CSF011A
     C                   EVAL      WCustomer = DDPFRM                                        CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDPRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDPRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDPRTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Receiver of Guarantee                                                               CSF011A
                                                                                             CSF011A
     C                   IF        DDRECE <> *BLANKS                                         CSF011A
     C                   EVAL      WCustomer = DDRECE                                        CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDRESN = BBCSSN                                           CSF011A
     C                   EVAL      DDRENM = BBCRNM                                           CSF011A
     C                   EVAL      DDRETN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Facility Customer                                                                   CSF011A
                                                                                             CSF011A
     C                   IF        DDFCUS <> *BLANKS                                         CSF011A
     C                   EVAL      WCustomer = DDFCUS                                        CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDFRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDFRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDFCRT = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Customer Confirmation                                                               CSF011A
                                                                                             CSF011A
     C                   IF        DDCOCU <> *BLANKS                                         CSF011A
     C                   EVAL      WCustomer = DDCOCU                                        CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDCOSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCONM = BBCRNM                                           CSF011A
     C                   EVAL      DDCOTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACCUST - ACCESS CUSTOMER DETAILS                              *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
                                                                                             CSF011A
     C     ACCUST        BEGSR                                                               CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM      '*KEY'        @OPTN                                       CSF011A
     C                   PARM      WCustomer     PCust                                       CSF011A
     C                   PARM      *BLANKS       PStKey                                      CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                    AR1078092
      /EJECT                                                                               AR1078092
      *****************************************************************                    AR1078092
      *                                                               *                    AR1078092
      * CHKNOVRBLKACT - Check and Override Blocke Accounts            *                    AR1078092
      *                                                               *                    AR1078092
      *****************************************************************                    AR1078092
                                                                                           AR1078092
     C     CHKNOVRBLKACCTBEGSR                                                             AR1078092
      ** Check for overrideable message id                                                 AR1078092
     C                   DOW       WX0 <= 2                                                AR1078092
      *                                                                                    AR1078092
     C                   EVAL      WX0 = WX0 + 1                                           AR1078092
     C                   IF        IDx > 0                                                 AR1078092
      *                                                                                    AR1078092
     C                   SELECT                                                            AR1078092
     C                   WHEN      WX0 = 1                                                 AR1078092
     C                   EVAL      WMSGID = 'ESM0991'                                      AR1078092
     C                   WHEN      WX0 = 2                                                 AR1078092
     C                   EVAL      WMSGID = 'ESM0992'                                      AR1078092
     C                   ENDSL                                                             AR1078092
      *                                                                                    AR1078092
     C                   EVAL      WX1 = 1                                                 AR1078092
     C     WMSGID        LOOKUP    MsgIDArr(WX1)                          99               AR1078092
     C                   IF        *IN99 = '1'                                             AR1078092
     C**********         EVAL      WX2 = 1                                        AR1078092 MD025619
     C*****WMSGID        LOOKUP    WMsgIDArr(WX2)                         99      AR1078092 MD025619
     C**********         IF        *IN99 = '0'                                    AR1078092 MD025619
     C                   EVAL      WIdx = WIdx + 1                                         AR1078092
     C                   EVAL      WFldNamArr(WIdx) = FldNameArr(WX1)                      AR1078092
     C                   EVAL      WMsgIDArr(WIdx) = MsgIDArr(WX1)                         AR1078092
     C                   IF        WX0 = 1                                                  MD025619
     C                   EVAL      DDRonxOK = 'W'                                           MD025619
     C                   ELSE                                                               MD025619
     C                   EVAL      DDPonxOK = 'W'                                          AR1078092
     C                   ENDIF                                                             AR1078092
      ** Remove overrided error message                                                    AR1078092
     C**********         EVAL      WX3 = WX1                                      AR1078092 MD025619
     C**********         DOW       WX1 < 999                                      AR1078092 MD025619
     C**********         EVAL      WX3 = WX3 + 1                                  AR1078092 MD025619
      **********                                                                  AR1078092 MD025619
     C**********         EVAL      FldNameArr(WX1) = FldNameArr(WX3)              AR1078092 MD025619
     C**********         EVAL      MsgIDArr(WX1) = WMsgIDArr(WX3)                 AR1078092 MD025619
     C**********         EVAL      Idx = Idx - 1                                  AR1078092 MD025619
      **********                                                                  AR1078092 MD025619
     C**********         IF        MsgIDArr(WX3) = *BLANK                         AR1078092 MD025619
     C**********         LEAVE                                                    AR1078092 MD025619
     C**********         ENDIF                                                    AR1078092 MD025619
      **********                                                                  AR1078092 MD025619
     C**********         ENDDO                                                    AR1078092 MD025619
      **********                                                                  AR1078092 MD025619
     C                   EVAL      WX2 = 1                                                  MD025619
     C     *BLANKS       LOOKUP    MsgIDArr(WX2)                          99                MD025619
     C                   EVAL      FldNameArr(WX1) = *BLANKS                                MD025619
     C                   EVAL      MsgIDArr(WX1) = *BLANKS                                  MD025619
     C                   EVAL      Idx = Idx - 1                                            MD025619
     C                   DOW       WX2 > WX1                                                MD025619
     C                   EVAL      WX3 = WX1 + 1                                            MD025619
     C                   EVAL      FldNameArr(WX1) = FldNameArr(WX3)                        MD025619
     C                   EVAL      MsgIDArr(WX1) = MsgIDArr(WX3)                            MD025619
     C                   EVAL      FldNameArr(WX3) = *BLANKS                                MD025619
     C                   EVAL      MsgIDArr(WX3) = *BLANKS                                  MD025619
     C                   EVAL      WX1 = WX3                                                MD025619
     C                   EVAL      WX2 = WX2 - 1                                            MD025619
     C                   ENDDO                                                              MD025619
     C                   ENDIF                                                             AR1078092
      *                                                                                    AR1078092
     C                   ENDIF                                                             AR1078092
      *                                                                                    AR1078092
     C                   ENDDO                                                             AR1078092
                                                                                           AR1078092
     C                   ENDSR                                                             AR1078092
      *****************************************************************                      CSF011A
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx

     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx

     C                   RESET                   FldNoArr

     C                   CLEAR                   CurClPrim
     C                   CLEAR                   CurClSeco
     C                   CLEAR                   CurClThir
     C                   CLEAR                   CurClFour
     C                   CLEAR                   CurClSix                                     CLE134
     C                   CLEAR                   CurClSeven                                   CLE141

     C                   MOVE      *ALL'Y'       OKClPrim
     C                   MOVE      *ALL'Y'       OKClSeco
     C                   MOVE      *ALL'Y'       OKClThir
     C                   MOVE      *ALL'Y'       OKClFour
     C                   MOVE      *ALL'Y'       OKClSix                                      CLE134
     C                   MOVE      *ALL'Y'       OKClSeven                                    CLE141

     C                   CLEAR                   ValidClil
     C                   CLEAR                   ValidClik
     C                   EVAL      VL_CLRIDT = 0                                              CLE134
     C                   EVAL      VL_CLBIDT = 0                                              CLE134

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    Trans5003
     C                   PARM                    Trans5004
     C                   PARM                    Trans5005                                    CLE106
     C                   PARM                    TransQ                                       CER049
     C                   PARM                    Trans5006                                 AR1021983
     C                   PARM                    Trans5007                                    CLE141
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ReservID         10
     C                   PARM                    InfData500                                   CAP086
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData500
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
     C                   PARM                    @DEPI             1                        MD030621

      ** Access SAR details file to determine if LLN007                                      LLN022A
      ** Bank of England Yellow Book Changes is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN007            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN007 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN007 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
     C                   EVAL      MsgFArray(4) = 'SDUSRMSG'                                  CRE073

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,LECLIPM01
      *                                                                                      LLN022A
      **  Add GBBYUSRMSG to MsgFArray if BOE installed                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
     C                             'GBBYUSRMSG'                                              LLN022A
     C                   ENDIF                                                               LLN022A

      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'LE'

      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      * Access MIDAS Modules details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY

      * Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
                                                                                              CDE005
      * Determine if CDE005 is switched on                                                    CDE005
                                                                                              CDE005
     C                   CALLB     'AOSARDR0'                                                 CDE005
     C                   PARM      *BLANKS       @RTCD                                        CDE005
     C                   PARM      '*VERIFY'     @OPTN                                        CDE005
     C                   PARM      'CDE005'      @SARD                                        CDE005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE005
     C                   IF        @RTCD = *BLANK                                             CDE005
     C                   MOVEL     'Y'           CDE005            1                          CDE005
     C                   ELSE                                                                 CDE005
     C                   MOVEL     'N'           CDE005                                       CDE005
     C                   ENDIF                                                                CDE005
                                                                                              CDE005
     C                   EVAL      @RTCD = *BLANKS

      *  Hook to enable non-core initial processing to be included

      * Determine if CSC022 is switched on                                                    CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
     C                   IF        @RTCD = *BLANK                                             CSC022
     C                   EVAL      CSC022 ='Y'                                                CSC022
     C                   EVAL      WCMT01 ='N'                                                CSC022
      * SCCMTJOB data area                                                                    CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      * Move data area to commitment array                                                    CSC022
     C                   IF        COMITNOM > 0                                               CSC022
     C                   MOVEA     COMITJOB      ARRJBNAM                                     CSC022
      *                                                                                       CSC022
      * Check if PSJOBNAME exist.                                                             CSC022
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                  CSC022
     C                   IF        *IN17 = *ON                                                CSC022
     C                   EVAL      WCMT01= 'Y'                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C                   ELSE                                                                 CSC022
      * @rtcd not found                                                                       CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBPGM = 'LECLIPVU'                                         CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 905                                               CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C/COPY WNCPYSRC,LECLIPXC01
                                                                                              CSC022
      ** Determine if Flat Rate Personal Loans (Rule of 78s) is installed                    BUG3721
                                                                                             BUG3721
     C                   MOVE      'N'           CLE028            1                         BUG3721
     C                   CALLB     'AOSARDR0'                                                BUG3721
     C                   PARM      *BLANKS       @RTCD                                       BUG3721
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3721
     C                   PARM      'CLE028'      @SARD             6                         BUG3721
                                                                                             BUG3721
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3721
     C                   MOVE      'Y'           CLE028                                      BUG3721
     C                   ELSE                                                                BUG3721
     C     @RTCD         IFEQ      '*NRF'                                                    BUG3721
     C                   MOVE      'N'           CLE028                                      BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
      ** Database error                                                                      BUG3721
                                                                                             BUG3721
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************BUG3721
     C                   MOVEL     '907'         DBASE                          * DBERR 907 *BUG3721
     C                   MOVEL     @OPTN         DBKEY                          *************BUG3721
     C                   EXSR      *PSSR                                                     BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
      *                                                                                       CLE134
      ** Check CLE134                                                                         CLE134
      *                                                                                       CLE134
     C                   MOVE      'N'           W#PDCL            1                          CLE134
     C                   MOVE      'N'           CLE134            1                          CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD             6                          CLE134
      *                                                                                       CLE134
     C     @RTCD         IFEQ      *BLANKS                                                    CLE134
     C                   MOVE      'Y'           CLE134                                       CLE134
     C                   ELSE                                                                 CLE134
     C     @RTCD         IFEQ      '*NRF'                                                     CLE134
     C                   MOVE      'N'           CLE134                                       CLE134
     C                   ELSE                                                                 CLE134
      *                                                                                       CLE134
      ** Database error                                                                       CLE134
      *                                                                                       CLE134
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE134
     C                   MOVEL     '910'         DBASE                                        CLE134
     C                   MOVEL     @OPTN         DBKEY                                        CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       241519
      ** Check System Value: Use Original Borrower or Purchased From?                         241519
      ** Set up parameter so access object checks LoanCustOriginPurch                         241519
     C                   MOVEL     WPARM         SVALK1                                       241519
     C                   MOVEL     WPARM2        SVALK2                                    AR1078092
      *                                                                                     MD030274
      ** Check System Value: Loan St Dt Settl Instr Amendable After                         MD030274
      **                     After Value Date                                               MD030274
      ** Set up parameter so access object checks LoanStartStlInsAmd                        MD030274
      *                                                                                     MD030274
     C                   MOVEL     WPARM3        SVALK3                                     MD030274
      * Call Access object:                                                                   241519
     C                   CALL      'AOSVALR0'                                                 241519
     C                   PARM                    RTNCDE            7                          241519
     C                   PARM                    SVALK1           20                          241519
     C                   PARM                    SVAL1           200                          241519
     C                   PARM                    SVALK2           20                          241519
     C                   PARM                    SVAL2           200                          241519
     C                   PARM                    SVALK3           20                          241519
     C                   PARM                    SVAL3           200                          241519
     C                   PARM                    SVALK4           20                          241519
     C                   PARM                    SVAL4           200                          241519
     C                   PARM                    SVALK5           20                          241519
     C                   PARM                    SVAL5           200                          241519
     C                   PARM                    SVALK6           20                          241519
     C                   PARM                    SVAL6           200                          241519
     C                   PARM                    SVALK7           20                          241519
     C                   PARM                    SVAL7           200                          241519
     C                   PARM                    SVALK8           20                          241519
     C                   PARM                    SVAL8           200                          241519
     C                   PARM                    SVALK9           20                          241519
     C                   PARM                    SVAL9           200                          241519
     C                   PARM                    SVALK0           20                          241519
     C                   PARM                    SVAL10          200                          241519
      * If the system value is not found then default value to 'P'                            241519
     C     RTNCDE        IFNE      '        '                                                 241519
     C                   MOVE      'P'           PPCUST                                       241519
     C                   Movel     'N'           STARAM                                     MD030274
     C                   ELSE                                                                 241519
      * Isolate the first character of SVAL1 which = 'P' or 'O'.                              241519
     C                   MOVEL     SVAL1         WRK01             1                          241519
     C     WRK01         IFEQ      'O'                                                        241519
     C                   MOVE      'O'           PPCUST            1                          241519
     C                   ELSE                                                                 241519
     C                   MOVE      'P'           PPCUST                                       241519
     C                   ENDIF                                                                241519
     C                   MOVEL     SVAL2         WBLKACCT                                  AR1078092
      *                                                                                     MD030274
      ** Isolate the first character of SVAL3 which should contain the                      MD030274
      ** value Y or N.                                                                      MD030274
      *                                                                                     MD030274
     C                   Movel     SVAL3         WRK03             1                        MD030274
     C     WRK03         Ifeq      'Y'                                                      MD030274
     C                   Movel     'Y'           STARAM            1                        MD030274
     C                   Else                                                               MD030274
      *                                                                                     MD030274
      ** If STARAM = 'N', Start Settlement Instructions can't be amended                    MD030274
      *                                                                                     MD030274
     C                   Movel     'N'           STARAM                                     MD030274
     C                   Endif                                                              MD030274
     C                   ENDIF                                                                241519
      *                                                                                       CER001
      ** Determine if ULX004 is switched on                                                   CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        @RTCD   = *BLANK                                           CER001
     C                   EVAL      ULX004  = 'Y'                                              CER001
     C                   ELSE                                                                 CER001
     C                   IF        @RTCD   = '*NRF'                                           CER001
     C                   EVAL      ULX004  = 'N'                                              CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '907'         DBASE                                        CER001
     C                   MOVEL     @OPTN         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CAP086
      ** Check if enhancement Automatic Authorisation(CAP086) is on                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 908                                               CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      VL_CLAUTH = IF_AUTH                                        CAP086
     C                   ELSE                                                               MD020578
     C                   EVAL      VL_CLAUTH = *BLANKS                                      MD020578
     C                   ENDIF                                                                CAP086
                                                                                             BUG3721
      ** Determine if CLE031 (Lending Enhancements)                                           CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
     C     @RTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '008'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE106
      ** Determine if CLE106 (Syndications Manager)                                           CLE106
      *                                                                                       CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
      *                                                                                       CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
     C     @RTCD         IFEQ      '*NRF'                                                     CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
      ** Database error                                                                       CLE106
      *                                                                                       CLE106
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE106
     C                   MOVEL     '009'         DBASE                          * DBERR 008 * CLE106
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE106
     C                   EXSR      *PSSR                                                      CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                     MD054028
      ** Check if CER050 is ON                                                              MD054028
     C                   CallB     'AOSARDR0'                                               MD054028
     C                   Parm      *Blanks       PRTCD                                      MD054028
     C                   Parm      '*VERIFY'     POPTN                                      MD054028
     C                   Parm      'CER050'      PSARD                                      MD054028
     C     SCSARD        Parm      SCSARD        DSFDY                                      MD054028
      *                                                                                     MD054028
     C                   Move      'N'           CER050            1                        MD054028
     C                   If        PRTCD = *Blanks                                          MD054028
     C                   Eval      CER050 = 'Y'                                             MD054028
     C                   Endif                                                              MD054028
      *                                                                                       CLE168
      ** Access SAR details file                                                              CLE168
      *                                                                                       CLE168
     C                   CALLB     'AOSARDR0'                                                 CLE168
     C                   PARM      *BLANKS       @RTCD                                        CLE168
     C                   PARM      '*VERIFY'     @OPTN                                        CLE168
     C                   PARM      'CLE168'      @SARD                                        CLE168
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE168
                                                                                              CLE168
     C                   IF        @RTCD = *BLANK                                             CLE168
     C                   MOVEL     'Y'           CLE168            1                          CLE168
     C                   ELSE                                                                 CLE168
     C                   MOVEL     'N'           CLE168                                       CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
     C     LEFCLT1       KLIST                                                                CLE168
     C                   KFLD                    KFCUN             6                          CLE168
     C                   KFLD                    KFTYP             3                          CLE168
     C                   KFLD                    KFSEQ             2                          CLE168
      *                                                                                       CLE168
      ** Key Fields for Facility File                                                         CLE031
     C     CHKFAC        KLIST                                                                CLE031
     C                   KFLD                    KFCUS                                        CLE031
     C                   KFLD                    KFACT                                        CLE031
     C                   KFLD                    KFCNO                                        CLE031
     C                   KFLD                    KRCTP                                        CLE031
      *****************************************************************              AR314017 CLE164
      ***Key*Fields*for*Repayment*Priority*file************************              AR314017 CLE164
      *****************************************************************              AR314017 CLE164
     C*****KLNRF         KLIST                                                       AR314017 CLE164
     C**********         KFLD                    WLNRF             6 0               AR314017 CLE134
     C**********         KFLD                    WLNRF             6                   CLE134 CLE164
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************                       CLE031
      * LEFCLTY - Retrieve Facility details                            *                      CLE031
      *****************************************************************                       CLE031
     C     LEFCLTY       BEGSR                                                                CLE031
     C                   EVAL      KRCTP = 'A'                                                CLE031
     C     CHKFAC        CHAIN     FCLTY                                                      CLE031
     C                   ENDSR                                                                CLE031
      ****************************************************************                      MD054028
      *  Get Record Lengths of Transaction Data Blocks               *                      MD054028
      ****************************************************************                      MD054028
     C     GETRCDLN      BEGSR                                                              MD054028
                                                                                            MD054028
     C                   CALLB     'UTGETRCDLN'                                             MD054028
     C                   PARM                    ReturnCode       10                        MD054028
     C                   PARM      *ZERO         RecordLen         5 0                      MD054028
     C                   PARM                    FileName         10                        MD054028
     C                   PARM      '*LIBL     '  FileLib          10                        MD054028
                                                                                            MD054028
      ** If file not found (or any other error) shut down the program                       MD054028
     C     ReturnCode    Ifne      *Blanks                                                  MD054028
     C                   EXSR      *pssr                                                    MD054028
     C                   EndIf                                                              MD054028
                                                                                            MD054028
     C                   ENDSR                                                              MD054028
      *****************************************************************                    AR1095041
      /EJECT                                                                               AR1095041
      *****************************************************************                    AR1095041
** PCMD                                                                                    AR1095041
OVRDBF FILE(LEPDUELB) SHARE(*NO)                                                           AR1095041
DLTOVR FILE(LEPDUELB)                                                                      AR1095041
