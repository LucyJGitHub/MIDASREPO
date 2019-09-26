     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans Interface Controller')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIPCTL - LE Customer Loans Maintenance.                   *
      *                                                               *
      *  Function: This Program Validates LE Customer Loans for       *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Customer loans details fields     *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For D (=Delete) call a separate function to      *
      *              process this Customer loans and bypass the rest  *
      *              of the validation                                *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 LLN022A            Date 13Aug12               *
      *                 LLN022             Date 13Aug12               *
      *                 MD032052           Date 23Jan15               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025521           Date 19Aug14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD020578           Date 24May13               *
      *                 AR910559           Date 10Dec12               *
      *                 AR804863           Date 10Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247441             Date 20Jul07               *
      *                 CPK028             Date 12Jun07               *
      *                 247549             Date 03May07               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      *                 BUG13843           Date 02May07               *
      *                 245227             Date 27Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 BUG10574           Date 02Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 BUG9173            Date 07Nov05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG6227            Date 12Mar05               *
      *                 BUG8526            Date 27Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 10Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE120             Date 09Aug04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 225959             Date 23Mar04               *
      *                 TDA023             Date 22Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP074  *CREATE    Date 26Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Update for MidasPlus                            *
      *           Core hooks added:LECLIPCC01,LECLIPCC02,LECLIPCC03   *
      *                            LECLIPCC04,LECLIPCC05              *
      *  MD032052 - Unable to authorize loan repaired from repair     *
      *             queue. Enhance MD031225 to bypass validation of   *
      *             loan number if record come from COB.              *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025521 - Recompile due to changes on LECLI2PD.             *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD020578 -  Cannot authorise WIP record. Status is neither   *
      *              complete nor requesting re-authorisation         *
      *  AR910559 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Add @ACTRV*
      *             parameter in LECLIP5VL. (Child: AR910560)         *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247441 - Additional parameter for LECLIP1VL                  *
      *  CPK028 - Customer Number fields should be alpha.             *
      *  247549 - Review delay processing.                            *
      *  245273 - Added DDFPTF field to LECLIPRTV.                    *
      *           Recompiled due to changes in LECLI1PD.              *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  245227 - Added fields WAUTOA & WAUTOY to LECLIP1VL.          *
      *  CSD027 - Conversion Of Customer Number to Alpha (recompile)  *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  BUG10574 - Recompiled due to changes in LECLI4PD.            *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  BUG9173- Could not authorise loan coming from valid file     *
      *           updater.                                            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG6227- Valid files updated incorrectly                     *
      *  BUG8526- Facility Currency Exchange Rate should be used, if  *
      *           entered, in the calculation of the Facility         *
      *           Repayment amount.                                   *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CLE120 - Core changes for GBO020                             *
      *         - Debt Classification by Assets                       *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:LECLIPC019                         *
      *           Core hooks amended:LECLIPC002                       *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  225959 - Missing CAS00x changes                              *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Customer Loans CK file
     FLEVCLIKPD UF A E             DISK    INFSR(*pssr)
     F**********                           PREFIX(VL_)                                       BUG6227
     F                                     PREFIX(VK_)                                       BUG6227
     F                                     COMMIT
      * Valid Customer Loans CL file
     FLEVCLILPD UF A E             DISK    INFSR(*pssr)
     F**********                           PREFIX(VK_)                                       BUG6227
     F                                     PREFIX(VL_)                                       BUG6227
     F                                     COMMIT
      * Invalid Customer loans
     FLEICLIPPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FLEVCLLX1PDUF A E             DISK    INFSR(*pssr)                                       CER001
     F                                     RENAME(LEVCLIPF6:VCLIPD6)                          CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
      ** Valid Customer Loans file                                                            CER001
      *                                                                                       CER001
     FLEICLLX1PDUF A E             DISK    INFSR(*pssr)                                       CER001
     F                                     RENAME(LEICLIPF6:ICLIPD6)                          CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
      ** Invalid Customer Loans file                                                          CER001
      *                                                                                       CER001
     FLEVCLIPL0 IF   E           K DISK
     F                                     RENAME(LEVCLILD0:LEVCLILCK0)
     F                                     RENAME(LEVCLIKD0:LEVCLIKCK0)
     FLEVCLIPL1 IF   E           K DISK
     F                                     RENAME(LEVCLILD0:LEVCLILCK1)
     F                                     RENAME(LEVCLIKD0:LEVCLIKCK1)
 
     FAPIDSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LECLIPC001
 
      ** Valid File                                                                          LLN022A
      *                                                                                      LLN022A
     FLEVCLIPX0 UF A E           K DISK    INFSR(*PSSR)                                      LLN022A
     F                                     RENAME(LEVCLIX0 : VCLIPD0)                        LLN022A
     F                                     COMMIT                                            LLN022A
      *                                                                                      LLN022A
      ** Invalid File                                                                        LLN022A
      *                                                                                      LLN022A
     FLEICLIPX0 UF A E           K DISK    INFSR(*PSSR)                                      LLN022A
     F                                     RENAME(LEICLIX0 : ICLIPD0)                        LLN022A
     F                                     COMMIT                                            LLN022A
      *                                                                                      LLN022A
      *****************************************************************
      *  +--------------------------------------+
      *    Automatically included D-specs        
      *    ==============================        
      *  +--------------------------------------+
 
      *  Standard D-specs
      *  ================
 
      *  The following /COPY line includes the LDA layout,
      *  the copyright array definition,
      *  and the following named constants:
      *     True       logical = *on (for indcator processing)
      *     False      logical = *off (for indcator processing)
      *     DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      *                                     handler)
      *  and the following variables:
      *     RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *  Program Status Data Structure
      *  =============================
      *  The following /COPY line includes all the defined fields in the
      *  PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *  The following /COPY line includes definitions for the above fields
      *  as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      *  corresponding fields in the PSDS /COPY member, so that member
      *  must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes the definitions for error and
      *  warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      * --------------------------------------------------------------------------------------------
 
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes the definitions for arrays
      *  specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      * --------------------------------------------------------------------------------------------
 
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes the definitions for fields
      *  used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      * --------------------------------------------------------------------------------------------
 
      *  +--------------------------------------+
      *    End of automatically included D-specs 
      *    ===================================== 
      *  +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *  +--------------------------------------+
      *    Manually included D-specs             
      *    =========================             
      *  +--------------------------------------+
 
      *  +--------------------------------------+
      *    Named constants                       
      *    ===============                       
      *  +--------------------------------------+
 
      * String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
 
      *  +--------------------------------------+
      *    Arrays and Data Structures            
      *    ==========================            
      *  +--------------------------------------+
 
      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(LECLI1PD)
     D TranInSeco    E DS                  EXTNAME(LECLI2PD)
     D TranInThir    E DS                  EXTNAME(LECLI3PD)
     D TranInFour    E DS                  EXTNAME(LECLI4PD)
 
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
 
      * Error indicators
     D OKClPrim      E DS                  EXTNAME(LEECLI1PD)
     D OKClSeco      E DS                  EXTNAME(LEECLI2PD)
     D OKClThir      E DS                  EXTNAME(LEECLI3PD)
     D OKClFour      E DS                  EXTNAME(LEECLI4PD)
 
 
 
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
     D***OOSDA**               37     48                                                      CGL029
     D  QQOSD1                37     48                                                       CGL029
     D  OTSTN                 49     58
     D  OFACO                 59     68
     D  OSPI1                 69     98
     D  OSPI2                 99    128
     D  OSPI3                129    158
     D  OSPI                  69    158
     D  OMDST                159    160  0
     D  MTNOSX               161    162
     D***OOMDA**              161    172                                                      CGL029
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
     D***WOSDA**               37     48                                                      CGL029
     D  QQOSD2                37     48                                                       CGL029
     D  WTSTN                 49     58
     D  WFACO                 59     68
     D  DDSPI1A               69     98
     D  DDSPI2A               99    128
     D  DDSPI3A              129    158
     D  DDSPI                 69    158
     D  WMDST                159    160  0
     D  MTNOS                161    162
     D***WOMDA**              161    172                                                      CGL029
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
     D**FCUSM***              64     69  0                                                    CPK028
     D  FCUSM                 64     69                                                       CPK028
     D  FTYPM                 70     72  0
     D  FSEQM                 73     74  0
     D  FCXRM                 75     87  8
     D  FMDIM                 88     88
     D  ORBRM                 89     91
     D  CRSKM                 92     93
     D  LINDM                 94     96
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
     D**WPTFC***             224    229  0                                                    CPK028
     D  WPTFC                224    229A                                                      CPK028
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
     D**ANUM****             445    450  0                                                    CPK028
     D**CNUMF***             451    456  0                                                    CPK028
     D**PMFC****             457    462  0                                                    CPK028
     D  ANUM                 445    450                                                       CPK028
     D  CNUMF                451    456                                                       CPK028
     D  PMFC                 457    462                                                       CPK028
     D  W#SYCU               463    468
     D  WPTYP                469    470  0
     D  WLIND                471    473
     D  CRSKF                474    475
     D  WCHGA                476    488  0                                                   BUG3721
     D  WLCCD                489    491                                                      BUG3721
     D  WPRCS2               492    492                                                      BUG3721
      *                                                                                       CER001
     D  PDATA          DS          1024                                                       CER001
     D   #1LNRF                1      6                                                       CER001
     D   #1CUST                7     12                                                       CER001
     D   #1PTYP               13     14                                                       CER001
     D   #1CCY                15     17                                                       CER001
     D   #1AMNT               18     32  0                                                    CER001
     D   #1FOID               33     52                                                       CER001
     D   #1RPLC               53     53                                                       CER001
     D   #1TMSP               54     79Z                                                      CER001
      *                                                                                       CER001
     D   #PSUBR              139    139                                                       CER001
     D   #PMOBL              140    149                                                       CER001
     D   #PRISC              150    151                                                       CER001
     D   #PIMEX              152    152                                                       CER001
     D   #PPPSC              153    158                                                       CER001
     D   #PCOAM              159    173                                                       CER001
     D   #PDGRI              174    174                                                       CER001
     D   #PIM93              175    175                                                       CER001
     D   #PCLAT              176    176                                                       CER001
     D   #PGUAC              177    177                                                       CER001
     D   #PLUSU              178    179                                                       CER001
      *                                                                                       CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
      *                                                                                       CSC022
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * External DS for Bank Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      * External DS for API ICD
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * EXTERNAL DS FOR SAR DETAILS
 
     D SCA_LCD       E                     EXTFLD(LCD)
 
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
      * LE Extra Data - Classe 1 Data - File (D/B) format                                     CAP086
     D                                     PREFIX(IF_)                                        CAP086
                                                                                              CAP086
     D ExtData       E DS                  EXTNAME(LECLEXPD)
      * SD Customer Loans Extra Data - File (D/B) format
     D RegData       E DS                  EXTNAME(LECLRXPD)                                  CER001
      *                                                                                       CER001
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      * 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      * SD data area
     D ValidCLIPEx   E DS                  EXTNAME(LEVCLLX1PD)                                CER001
      * Valid file                                                                            CER001
     D OKCLEXFlags   E DS                  EXTNAME(LEECLLX1PD)                                CER001
      * OK Flag                                                                               CER001
     D CLIPExFilFmt  E DS                  EXTNAME(LECLX1PD)                                  CER001
 
      ** +--------------------------------------+                                             CSC022
      **   Use of Indicator                                                                   CSC022
      **   ================                                                                   CSC022
      ** ¶                                      ¶                                             CSC022
      ** ¶ 17      Used by LOOKUP               ¶                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022
      *  +--------------------------------------+
      *    Declared variables                    
      *    ==================                    
      *  +--------------------------------------+
 
      * Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      * Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      * Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
     D Trans5004       S            500A
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data                                      CAP086
     D InfData500      S            500A                                                      CAP086
 
      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
     D RegData500      S            500A                                                      CER001
 
      * Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      * Indicies for arrays used to set up corresponding sequence numbers
      *  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      * Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      * Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      * Timestamp for the transaction
     D TimeStamp       S             26Z
 
     D Object          S             10A   INZ('LECLIPUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      * Dummy message ID and message file fields for use on the calls to
      * ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
     D CSC011          S              1A   INZ('N')
     D CAP086          S              1A   INZ('N')                                           CAP086
     D TRANSDTL        S           5800A
     D***PDealNo**       S             18A                                                    CGL029
     D***PADealNo*       S             18A                                                    CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D ULX004          S              1A                                                      CER001
     D PAction         S              1A                                                      CER001
 
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
                                                                                              CSC022
      * Whether or not to clear the program message queue (this is not
      * actually used, but is required by the message handler's parameter
      * list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      * Flags to indicate whether substitution is required in
      * each of the various parts the transaction
     D RepPrim         S              1A   inz('N')
     D RepSeco         S              1A   inz('N')
     D RepThir         S              1A   inz('N')
     D RepFour         S              1A   inz('N')
 
      * Work field for CLE030 processing                                                      CLE030
     D W_LSTS          S                   LIKE(VL_CLLSTS)                                    CLE030
                                                                                              CLE030
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      *  +--------------------------------------+
      *    End of D-specs                        
      *    ==============                        
      *  +--------------------------------------+
 
      *  +----------------------------------------+
      *    Hook for non-core D-specs (all types)   
      *    also any I-specs (if necessary)         
      *    =====================================   
      *  +----------------------------------------+
      /COPY WNCPYSRC,LECLIPC002
 
      **  NEW Loan Details in File Format                                                    LLN022A
      *                                                                                      LLN022A
     D NwCLIPFilFmt  E DS                  EXTNAME(LEVECLIPX0)                               LLN022A
     D                                     Prefix(PF)                                        LLN022A
      *                                                                                      LLN022A
      ** valid BOE details layout                                                            LLN022A
      *                                                                                      LLN022A
     D ValidBoE      E DS                  EXTNAME(LEVCLIPX0)                                LLN022A
      *                                                                                      LLN022A
      ** OK Indicators for fields                                                            LLN022A
      *                                                                                      LLN022A
     D OKBOEFlags    E DS                  EXTNAME(LEECLIPX0)                                LLN022A
      *                                                                                      LLN022A
      ** Data structure for passing data required further down                               LLN022A
      ** the Call Stack                                                                      LLN022A
      *                                                                                      LLN022A
     D DATA            DS          1024                                                      LLN022A
     D BYLNRF                301    306  0                                                   LLN022A
     D BYMDTE                307    309P 0                                                   LLN022A
     D BYMDAT                310    315                                                      LLN022A
      *                                                                                      LLN022A
      *****************************************************************
      /EJECT
      *****************************************************************
      *  +--- Start of Main processing -----------------------------------+
      *                                                                    
      *    Initial processing is performed automatically: the *INZSR is    
      *    executed at program activation.                                 
      *                                                                    
      *  +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,LECLIPC003
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInPrim
     C                   MOVEL     Trans5002     TranInSeco
     C                   MOVEL     Trans5003     TranInThir
     C                   MOVEL     Trans5004     TranInFour
     C                   MOVEL     InfData500    InfData                                      CAP086
     C                   MOVEL     Extdata500    Extdata
     C                   MOVEL     RegData500    RegData                                      CER001
 
      * Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      ResetCycle
 
      /COPY WNCPYSRC,LECLIPC004
 
      *  Set user field depending on action
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
     C                   EVAL         F1IUSR = APMIDUSR
     C                   WHEN         DDACTN = 'X'
     C                   EVAL         F1XUSR = APMIDUSR
     C                   WHEN         DDACTN = 'Q'                                            CLE030
     C                   EVAL         F1XUSR = APMIDUSR                                       CLE030
     C                   WHEN         DDACTN = 'A'
     C                   EVAL         F1AUSR = APMIDUSR
 
     C                   ENDSL
 
      * Check if valid Customer Loans details exists
 
     C                   EXSR      ChkValLoan
 
      * If valid Loan det. does exist (even after delay), fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
 
      * Check if valid Loans exists for Midas Loans Number
 
     C                   EXSR      ChkValMiCl
 
      * If valid Loans does exist (even after delay), fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid loans details file.
 
     C                   EXSR      ResetCycle
 
      /COPY WNCPYSRC,LECLIPC005
 
      * Validate Action Code
 
     C                   EXSR      ValidateAc
 
      /COPY WNCPYSRC,LECLIPC006
 
      *  If error in validation of action code, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
 
      * Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
      * Processing for Inserts
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateTr
      *                                                                                      LLN022A
      ** If Bank of England Processing installed validate data.                              LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
      ** If Idx is equal to 0                                                                LLN022A
      *                                                                                      LLN022A
     C     Idx           IFEQ      0                                                         LLN022A
      *                                                                                      LLN022A
      ** Set Up DATA to be passed.                                                           LLN022A
      *                                                                                      LLN022A
     C                   MOVE      VL_CLLNRF     BYLNRF                                      LLN022A
     C                   MOVE      VL_CLMDAT     BYMDTE                                      LLN022A
     C                   MOVE      DDMDAT        BYMDAT                                      LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LECLIPVAL1'                                              LLN022A
      *                                                                                      LLN022A
      ** INPUTS                                                                              LLN022A
      ** Response mode                                                                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    ACTN              1                         LLN022A
      *                                                                                      LLN022A
      ** Data required further down call stack.                                              LLN022A
      *                                                                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
      *                                                                                      LLN022A
      ** Bank of England Details                                                             LLN022A
      *                                                                                      LLN022A
     C                   PARM                    ExtData                                     LLN022A
      *                                                                                      LLN022A
      ** Date Format Indicator                                                               LLN022A
      *                                                                                      LLN022A
     C                   PARM                    BJDFIN                                      LLN022A
      *                                                                                      LLN022A
      ** OUTPUTS                                                                             LLN022A
      ** Bank of England Details OK inds                                                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    OKBOEFlags                                  LLN022A
      *                                                                                      LLN022A
      ** Error fields/message IDs/message data (arrays) from/to caller                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    Idx                                         LLN022A
      *                                                                                      LLN022A
      ** Warning fields/message IDs/message data (arrays) from/to caller                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WIdx                                        LLN022A
     C                   PARM                    ValidBoE                                    LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   If        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
     C                   EXSR      ValidateSt
 
     C                   WHEN         DDACTN = 'A'
      * Processing for Amends or Changes
 
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C     GHSUBS        ifne      *blank                                       CAP011
 
     C     GHSUBS        scan      TranInPrim                             99
     C                   if        *in99
     C                   eval      RepPrim = 'Y'
     C                   endif
 
     C     GHSUBS        scan      TranInSeco                             99
     C                   if        *in99
     C                   eval      RepSeco = 'Y'
     C                   endif
 
     C     GHSUBS        scan      TranInThir                             99
     C                   if        *in99
     C                   eval      RepThir = 'Y'
     C                   endif
 
     C     GHSUBS        scan      TranInFour                             99
     C                   if        *in99
     C                   eval      RepFour = 'Y'
     C                   endif
 
      * If any of the flags set above is true, do the data
      * substution subroutine.
     C                   if        (RepPrim = 'Y' OR RepSeco = 'Y' OR
     C                              RepThir = 'Y' OR RepFour = 'Y')
     C                   EXSR      DtaSubs
     C                   endif
 
     C                   endif
 
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateTr
      *                                                                                      LLN022A
      ** If Bank of England Processing installed validate data.                              LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
      ** If Idx is equal to 0                                                                LLN022A
      *                                                                                      LLN022A
     C     Idx           IFEQ      0                                                         LLN022A
      *                                                                                      LLN022A
      ** Set Up DATA to be passed.                                                           LLN022A
      *                                                                                      LLN022A
     C                   MOVEL     DDLNRF        BYLNRF                                      LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LECLIPVAL1'                                              LLN022A
      *                                                                                      LLN022A
      ** INPUTS                                                                              LLN022A
      ** Response mode                                                                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    ACTN                                        LLN022A
      *                                                                                      LLN022A
      ** Data required further down call stack.                                              LLN022A
      *                                                                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
      *                                                                                      LLN022A
      ** Bank of England Details                                                             LLN022A
      *                                                                                      LLN022A
     C                   PARM                    ExtData                                     LLN022A
      *                                                                                      LLN022A
      ** Date Format Indicator                                                               LLN022A
      *                                                                                      LLN022A
     C                   PARM                    BJDFIN                                      LLN022A
      *                                                                                      LLN022A
      ** OUTPUTS                                                                             LLN022A
      ** Bank of England Details OK inds                                                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    OKBOEFlags                                  LLN022A
      *                                                                                      LLN022A
      ** Error fields/message IDs/message data (arrays) from/to caller                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    Idx                                         LLN022A
      *                                                                                      LLN022A
      ** Warning fields/message IDs/message data (arrays) from/to caller                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WIdx                                        LLN022A
     C                   PARM                    ValidBoE                                    LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   If        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
     C                   EXSR      ValidateSt
 
     C                   ENDSL
 
     C     Invalid       TAG
 
      * Check for exception error from any program lower in the stack
      * If error detected, send message to system operator and
      * return to calling program without updating database or
      * prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,LECLIPC012
 
     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
 
      * Processing for Error checking/write to database
      /COPY WNCPYSRC,LECLIPC013
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,LECLIPC014
 
      * If valid, send data queue entry to prompt DB update program
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      * Check if update program active using Allocate Object API
      * No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
 
     C     Return        IFEQ      *BLANK
 
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes a check for whether there
      *  are messages on the server/updater data queue, and sends a 'GO'.
      *  message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      * --------------------------------------------------------------------------------------------
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LECLIPC015
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValLoan - Routine to check if valid Loans details exist    *
      *                                                               *
      *****************************************************************
     C     ChkValLoan    BEGSR
 
      * Check for Loans on Valid file
     C     APFOTranID    CHAIN     LEVCLIPL0                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * Delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     APFOTranID    CHAIN     LEVCLIPL0                          99
     C                   END                                                                  247549
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'APFOTranID'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValMiCl - Routine to check if valid Loans exists for       *
      *    Midas Loans reference                                      *
      *                                                               *
      *****************************************************************
     C     ChkValMiCl    BEGSR
 
      * Key list for file LEVCLIPL1
     C     KCLIP1        KLIST
     C**********         KFLD                    KLNRF             6 0                        CLE148
     C                   KFLD                    KLNRF             6                          CLE148
 
     C     DDLNRF        IFNE      *BLANKS
 
      * Check for Customer loans on Valid file
     C                   MOVE      DDLNRF        KLNRF
     C     KCLIP1        CHAIN     LEVCLIPL1                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     KCLIP1        CHAIN     LEVCLIPL1                          99
     C                   END                                                                  247549
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'
     C                   EVAL      MsgIDArr(Idx) = 'LEL0664'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              loans supplied                                   *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
 
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  if insert
      *  if not insert and Midas transaction ID is not present
      * Otherwise
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
 
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C     DDLNRF        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVEL     *BLANKS       ModeofOp
     C                   ENDIF
     C                   ENDIF
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
     C                   PARM                    APRESPMODE        1
      * Action Code
     C                   PARM                    DDACTN            1
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      * (Midas) Customer Loans Number
     C                   PARM                    DDLNRF
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
      * OK - Customer Number
     C                   PARM                    DDLnrfOK          1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr                                   225959
     C                   PARM                    WMsgIdArr                                    225959
     C                   PARM                    WMsgDtaArr                                   225959
     C                   PARM                    WIdx                                         225959
     C                   PARM                    DDFPTF                                       245273
      *                                                                                     AR804863
      ** Reject Button                                                                      AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C/COPY WNCPYSRC,LECLIPC019
 
     C                   Z-ADD     CL_TNLU       H#TNLU            5 0
     C                   Z-ADD     CL_CHGA       WCHGA                                       BUG3721
 
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
      *                                                                         CSW097
      ** Version century of ISDA Agreement                                      CSW097
     C                   PARM                    Blank2X           2            CSW097
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
      *                                                                                       CER001
      ** Call LECLIP5VL to validate the customer loans extension details                      CER001
      ** only when the loan is not parts sold.                                                CER001
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   IF        LoanPtyp <> 66 and LoanPtyp <> 67 and                      CER001
     C                             LoanPtyp <> 69 and LoanPtyp <> 72                          CER001
      *                                                                                       CER001
     C                   MOVE      DDLNRF        #1LNRF                                       CER001
     C                   MOVEL     DDCUST        #1CUST                                       CER001
     C                   MOVE      VL_CLPTYP     #1PTYP                                       CER001
      *                                                                                       CER001
     C                   MOVE      DDCURR        #1CCY                                        CER001
     C                   MOVE      VL_CLCPAM     #1AMNT                                       CER001
     C                   MOVE      APFOTranID    #1FOID                                       CER001
     C                   MOVE      APRprLocn     #1RPLC                                       CER001
     C                   MOVE      TimeStamp     #1TMSP                                       CER001
      *                                                                                       CER001
     C                   MOVE      LSUBR         #PSUBR                                       CER001
     C                   MOVE      LMOBL         #PMOBL                                       CER001
     C                   MOVE      LGUAC         #PGUAC                                       CER001
     C                   MOVE      LPPSC         #PPPSC                                       CER001
     C                   MOVE      LCOAM         #PCOAM                                       CER001
     C                   MOVE      LIMEX         #PIMEX                                       CER001
     C                   MOVE      LRISC         #PRISC                                       CER001
     C                   MOVE      LIM93         #PIM93                                       CER001
     C                   MOVE      LCLAT         #PCLAT                                       CER001
     C                   MOVE      LLUSU         #PLUSU                                       CER001
     C                   MOVE      LDGRI         #PDGRI                                       CER001
      *                                                                                       CER001
     C                   CALLB     'LECLIP5VL'                                                CER001
     C                   PARM      DDACTN        PAction                                      CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OKCLEXFlags                                  CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidClipEx                                  CER001
     C                   PARM                    @ACTRV                                     AR910559
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrPrim - Validate Customer Loans Primary details          *
      *                                                               *
      *****************************************************************
     C     ValdTrPrim    BEGSR
 
     C                   CALLB     'LECLIP1VL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    APRESPMODE        1
 
      * Primary Details
     C                   PARM                    TranInPrim
     C                   PARM                    InfData                                      CAP086
      * Extra Data file data
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Reject Button                                                                      AR804863
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
 
      * OUTPUTS
 
      * Customer Loans Primary Details OK inds
     C                   PARM                    OKClPrim
 
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
     C                   PARM                    PRANG             2
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
                                                                                              247441
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                  247441
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                              247441
                                                                                              247441
     C                   PARM                    ModeofOp          6                          247441
      ** Front Office ID                                                                    MD032052
     C                   PARM                    APFOTranID       20                        MD032052
 
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
     C                   PARM                    APRESPMODE        1
 
      * Primary Details
     C                   PARM                    TranInSeco
      ** Loan details screen 3                                                               BUG8526
     C                   PARM                    TranInThir                                  BUG8526
     C                   PARM                    InfData                                      CAP086
      * Extra Data file data
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Reject Button                                                                      AR804863
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
      ** Screen Detail 1                                                                     BUG3721
      ** Customer Loans Primary Details OK inds                                              BUG3721
     C                   PARM                    ClilFilFmt                                  BUG3721
     C                   PARM                    TranInPrim                                  BUG3721
     C                   PARM                    OKClPrim                                    BUG3721
 
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
     C                   PARM                    PRANG
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
 
     C                   CALLB     'LECLIP3VL'
      * INPUTS
 
      * Response mode
     C                   PARM                    APRESPMODE        1
 
      * Primary Details
     C                   PARM                    TranInThir
     C                   PARM                    InfData                                      CAP086
      * Extra Data file data
     C                   PARM                    ExtData
      *                                                                                     AR804863
      ** Reject Button                                                                      AR804863
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
     C                   PARM                    PRANG
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
     C                   PARM                    APRESPMODE        1
 
      * Primary Details
     C                   PARM                    TranInFour
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
     C                   PARM                    PRANG
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
      /SPACE 5
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************
     C     ValidateSt    BEGSR
 
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
     C                   MOVEL     DDCUST        WWCUST
     C                   END
      *
     C                   RESET                   ReturnCode
 
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
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
 
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
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
      * File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##FRIF
      * Extra Input
      * Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      * Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
 
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
      *
      ***  Extra validation after the Extended Settlements
      *
     C                   CALLB     'LECLIPEVL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    APRESPMODE
      * Loan details screen 1 and 2
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
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
      ** Reject Button                                                                      AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
 
      *
      * UPDATE VALID Loan: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLPAY         ValidPAY
     C                   MOVEL     FLPONS        ValidPAYEx                                   CGL029
     C                   MOVEL     FLPSTM        VL_CLPSTM                                    CGL029
     C                   MOVE      FLCVMR        VL_CLCVMR
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
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        VL_CLREXR                                    CLE031
     C                   Z-ADD     FLPEXR        VL_CLPEXR                                    CLE031
     C                   MOVE      FLREXI        VL_CLREXI                                    CLE031
     C                   MOVE      FLPEXI        VL_CLPEXI                                    CLE031
     C                   MOVE      FLRSCY        VL_CLSCCY                                    CLE031
     C                   MOVE      FLPSCY        VL_CLPSCY                                    CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLI002
      * UPDATE VALID Loan: OUR START DATE & OUR MATURITY DATE INSTRUCTIONS
      *                                                                                       CLI002
     C                   MOVE      WSDST         VL_CLSDST
     C                   MOVEL     WOSDA         VL_CLOSDA
     C                   MOVE      WOMDB         VL_CLOMDB
     C                   MOVEL     WTSTN         VL_CLTSTN
 
     C                   MOVE      WMDST         VL_CLMDST
     C                   MOVEL     WOMDA         VL_CLOMDA
     C                   MOVE      WOSDB         VL_CLOSDB
     C                   MOVEL     WTMAN         VL_CLTMAN
     C                   MOVEL     WFACO         VL_CLFACO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
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
      * For Amends, put the complete (pre-existing) Transaction into the Valid
      * file record - fields in this will be updated during processing
 
     C                   MOVE      ClilFilFmt    ValidClil
     C                   MOVE      ClikFilFmt    ValidClik
 
      * For Amends, convert the customer loan to screen format 1
 
     C                   CALLB     'LECLIP1CT'
      * Inputs
 
      * Return Code
     C                   PARM                    RetCodeIn
      * Customer loans - file formats
     C                   PARM                    ValidClil
     C                   PARM                    ValidClik
 
      * Output parameters
      * Customer loans Details - screen formats 1
     C                   PARM                    CurClPrim
 
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
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     CL_REXR       FLREXR                                       CLE031
     C                   Z-ADD     CL_PEXR       FLPEXR                                       CLE031
     C                   MOVE      CL_REXI       FLREXI                                       CLE031
     C                   MOVE      CL_PEXI       FLPEXI                                       CLE031
     C                   MOVE      CL_SCCY       FLRSCY                                       CLE031
     C                   MOVE      CL_PSCY       FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
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
      * (Current) Customer Loans in Screen Format :
     C                   PARM                    CurClFour
      * (Current) Loan in file format:
     C                   PARM                    ClilFilFmt
     C                   PARM                    ClikFilFmt
      * Calling type
     C                   PARM                    LoanType          4
 
      * OUTPUTS
 
      * Error Indicators
     C                   PARM                    OKClFour
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
      *                                                               *
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *                                                               *
      *****************************************************************
     C     CheckWrite    BEGSR
 
      *  If no errors were found:
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report Customer loans status
      *  If any errors were found:
      *     - write a record to the Invalid file
      *     - call the message handler to pass the errors back
      *     - use std message handler to report trade status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
 
     C                   IF        Idx = 0
 
     C                   EXSR      SetupValid
     C                   WRITE     LEVCLIKD0
     C                   WRITE     LEVCLILD0
      *                                                                                       CER001
      ** Setup LEVCLLX1PD fields only if loan is not parts sold                               CER001
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   IF        LoanPtyp <> 66 and LoanPtyp <> 67 and                      CER001
     C                             LoanPtyp <> 69 and LoanPtyp <> 72                          CER001
     C                   EVAL      LKLNRF = VL_CLLNRF                                         CER001
     C                   EVAL      LKFOID = APFOTranID                                        CER001
     C                   EVAL      LKRPLC = APRprLocn                                         CER001
     C                   EVAL      LKTMSP = TimeStamp                                         CER001
      *                                                                                       CER001
     C                   WRITE     VCLIPD6                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
 
      ** Set up BOE fields if installed.                                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      LVLNRF = VL_CLLNRF                                        LLN022A
     C                   EVAL      LVTMST = VL_CLTMES                                        LLN022A
     C                   EVAL      LVAFRT = VL_CLFRNT                                        LLN022A
     C                   EVAL      LVREPA = VL_CLREPA                                        LLN022A
      *                                                                                      LLN022A
     C                   WRITE     VCLIPD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
     C     Idx           IFGT      0
     C                   EXSR      SetupInVal
 
      * Only write to Invalid files if repair in back office
     C                   IF        APRprLocn = 'B'
     C                   WRITE     LEICLIPD0
     C                   WRITE     APIDSETD0
 
      * Write all invalid records to the support log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      TRANSDTL = TranInPrim +
     C                                        TranInSeco  +
     C                                        TranInThir  +
     C                                        TranInFour  +
     C                                        ##RECS      +
     C**********                              ##PAYS                                          CER001
     C                                        ##PAYS      +                                   CER001
     C                                        RegData     +                                   CER001
     C                                        Extdata                                         CER001
 
     C                   EVAL      APTGTTYPE  = 'LECLIP'
     C                   EVAL      PDealNo = DDLNRF
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    Timestamp
     C                   PARM                    PDealNo
     C                   PARM      *BLANKS       PADealNo
 
      * Database error
 
     C                   IF        RetCodeOut <> *BLanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PDealNo
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Setup LEICLLX1PD fields only if not parts sold                                       CER001
      *                                                                                       CER001
     C                   IF        LoanPtyp <> 66 and LoanPtyp <> 67 and                      CER001
     C                             LoanPtyp <> 69 and LoanPtyp <> 72                          CER001
     C                   MOVE      LSUBR         LCSUBR                                       CER001
     C                   MOVE      LMOBL         LCMOBL                                       CER001
     C                   MOVE      LGUAC         LCGUAC                                       CER001
     C                   MOVE      LPPSC         LCPPSC                                       CER001
     C                   MOVE      LCOAM         LCCOAM                                       CER001
     C                   MOVE      LIMEX         LCIMEX                                       CER001
     C                   MOVE      LRISC         LCRISC                                       CER001
     C                   MOVE      LIM93         LCIM93                                       CER001
     C                   MOVE      LCLAT         LCCLAT                                       CER001
     C                   MOVE      LLUSU         LCLUSU                                       CER001
     C                   MOVE      LDGRI         LCDGRI                                       CER001
     C                   EVAL      LCFOID = APFOTranID                                        CER001
     C                   EVAL      LCRPLC = APRprLocn                                         CER001
     C                   MOVE      Timestamp     LCTMSP                                       CER001
      *                                                                                       CER001
     C                   WRITE     ICLIPD6                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
 
     C                   ENDIF
      *                                                                                      LLN022A
      ** Set up BOE fields if installed.                                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   MOVE      VL_CLLNRF     LILNRF                                      LLN022A
     C                   MOVE      DDTMESTMP     LITMST                                      LLN022A
     C                   MOVE      DDFOtranid    LIAFRT                                      LLN022A
     C                   MOVE      DDRprLocn     LIREPA                                      LLN022A
     C                   MOVE      LLNTPX        LILNTP                                      LLN022A
     C                   MOVE      LFMATX        LIFMAT                                      LLN022A
      *                                                                                      LLN022A
     C                   WRITE     ICLIPD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupValid - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
     C     SetupValid    BEGSR
                                                                                              CLE030
      * If CLE030 and action code is Authorise then set work loan                             CLE030
      * status to be same as valid file.                                                      CLE030
     C                   IF        DDACTN = 'X' AND CLE030 = 'Y'                              CLE030
     C                   EVAL      W_LSTS = VL_CLLSTS                                         CLE030
     C                   ENDIF                                                                CLE030
 
      * For Reversed put the complete (pre-existing) Customer loans
      * into the Valid file record
     C*******************IF           DDACTN = 'R' OR DDACTN = 'X'                            CLE030
     C                   IF        DDACTN = 'R' OR DDACTN = 'X'                               CLE030
     C                             OR DDACTN = 'Q'                                            CLE030
     C                   MOVE      ClilFilFmt    ValidClil
     C                   MOVE      ClikFilFmt    ValidClik
     C                   MOVE      DDACTN        VL_CLCHTP
     C                   MOVE      DDACTN        VK_CLCHTP
      *                                                                                       CER001
     C                   IF         ULX004 = 'Y'                                              CER001
     C                   CALLB     'LECLIP2RV'                                                CER001
     C                   PARM      *Blanks       RetCodeIn                                    CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    APFOTranID                                   CER001
     C                   PARM                    DDLNRF                                       CER001
     C                   PARM                    CLIPExFilFmt                                 CER001
      *                                                                                       CER001
     C                   MOVEL     CLIPExFilFmt  ValidCLIPEx                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF
 
      * If CLE030 and action code is Authorise then set Loan status                           CLE030
      * field from valid file back to work field value.                                       CLE030
     C                   IF        DDACTN = 'X' AND CLE030 = 'Y'                              CLE030
     C                   EVAL      VL_CLLSTS = W_LSTS                                         CLE030
     C                   ENDIF                                                                CLE030
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      VL_CLFRNT = APFOTranID
     C                   EVAL      VL_CLPCRF = APFOTranID
     C                   EVAL      VL_CLREPA = APRprLocn
     C                   EVAL      VL_CLTMES = TimeStamp
     C                   EVAL      VK_CLFRNT = APFOTranID                                    BUG6227
     C                   EVAL      VK_CLREPA = APRprLocn                                     BUG6227
     C                   EVAL      VK_CLTMES = TimeStamp                                     BUG6227
                                                                                              CAP086
      * Automatic Authorisation flag                                                          CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      VL_CLAUTH = IF_AUTH                                        CAP086
     C                   ELSE                                                               MD020578
     C                   EVAL      VL_CLAUTH = *BLANKS                                      MD020578
     C                   ENDIF                                                                CAP086
 
     C                   EVAL      TranStatus = 'S'
      *                                                                                      BUG9173
      ** Populate the user profile fields                                                    BUG9173
      *                                                                                      BUG9173
     C     DDACTN        IFEQ      'I'                                                       BUG9173
      *                                                                                      BUG9173
     C     ModeOfop      IFEQ      '*FRONT'                                                  BUG9173
     C                   MOVE      F1IUSR        VL_CLIUSR                                   BUG9173
     C                   MOVE      F1AUSR        VL_CLAUSR                                   BUG9173
     C                   MOVE      F1XUSR        VL_CLXUSR                                   BUG9173
     C                   ELSE                                                                BUG9173
     C                   MOVE      PSUSER        VL_CLIUSR                                   BUG9173
     C                   ENDIF                                                               BUG9173
      *                                                                                      BUG9173
     C                   ENDIF                                                               BUG9173
      *                                                                                      BUG9173
     C     DDACTN        IFEQ      'X'                                                       BUG9173
      *                                                                                      BUG9173
     C     ModeOfop      IFEQ      '*FRONT'                                                  BUG9173
     C                   MOVE      F1IUSR        VL_CLIUSR                                   BUG9173
     C                   MOVE      F1XUSR        VL_CLXUSR                                   BUG9173
     C                   ENDIF                                                               BUG9173
      *                                                                                      BUG9173
     C                   ENDIF                                                               BUG9173
      *                                                                                      BUG9173
     C     DDACTN        IFEQ      'A'                                                       BUG9173
      *                                                                                      BUG9173
     C     ModeOfop      IFEQ      '*FRONT'                                                  BUG9173
     C                   MOVE      F1AUSR        VL_CLAUSR                                   BUG9173
     C                   MOVE      F1XUSR        VL_CLXUSR                                   BUG9173
     C                   ELSE                                                                BUG9173
     C                   MOVE      PSUSER        VL_CLAUSR                                   BUG9173
     C                   MOVE      *BLANKS       VL_CLXUSR                                   BUG9173
     C                   ENDIF                                                               BUG9173
      *                                                                                      BUG9173
     C                   ENDIF                                                               BUG9173
 
      /COPY WNCPYSRC,LECLIPC017
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupInVal - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      *****************************************************************
     C     SetupInVal    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDMsgType  = 'LECLIP'
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDFOAsocID = APFOAsocID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
 
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,LECLIPC016
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************
     C     CallMsgHdl    BEGSR
 
      * Set up an array of sequence numbers that correspond to the fields
      * with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C                   IF        FldNameArr(Ix) <> *blanks
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
 
     C                   ENDDO
 
     C                   RESET                   ReturnCode
 
     C                   MOVEL     DDLNRF        PTranID          20
 
     C                   CALLB     'ZAMSGHNDLE'
      * Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      * Deal repair location (1A, from caller)
     C                   PARM                    APRprLocn
      * Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      * List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      * List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      * List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      * List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      * Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      * Midas module ID (2A)
     C                   Parm                    ModuleID
      * Midas transaction ID (20A, from caller)
     C                   PARM                    PTranID
      * Message file (10A, from caller)
     C                   PARM                    #MsgFile
      * Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      * Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      * Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      * The following three parameters are needed when messages are to
      * be displayed on a screen
      * Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      * Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      * Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      * The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      * The transaction's timestamp
     C                   PARM                    TimeStamp
      * Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      * Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
 
     C                   ENDSR
      *****************************************************************
      /eject
      *****************************************************************
      *                                                               *
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************
     C     DtaSubs       begsr
 
      * Convert file fields to screen format
     C                   reset                   ReturnCode
 
     C                   EXSR      SetupAmd
 
      * Substitute the data for the various parts of the transaction,
      * dependent on the flags that were set earlier.
 
     C                   if        RepPrim = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInPrim    IncData        2000
      * Current Data
     C                   PARM      CurClPrim     CurData        2000
 
     C                   MOVEL     IncDATA       TranInPrim
 
     C                   endif
 
     C                   if        RepSeco = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInSeco    IncData
      * Current Data
     C                   PARM      CurClSeco     CurData
 
     C                   MOVEL     IncDATA       TranInSeco
 
     C                   endif
 
     C                   if        RepThir = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInThir    IncData
      * Current Data
     C                   PARM      CurClThir     CurData
 
     C                   MOVEL     IncDATA       TranInThir
 
     C                   endif
 
     C                   if        RepFour = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInFour    IncData
      * Current Data
     C                   PARM      CurClFour     CurData
 
     C                   MOVEL     IncDATA       TranInFour
 
     C                   endif
 
     C                   endsr
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ResetCycle- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
     C     ResetCycle    BEGSR
 
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
 
     C                   MOVE      *ALL'Y'       OKClPrim
     C                   MOVE      *ALL'Y'       OKClSeco
     C                   MOVE      *ALL'Y'       OKClThir
     C                   MOVE      *ALL'Y'       OKClFour
 
     C                   CLEAR                   ValidClil
     C                   CLEAR                   ValidClik
 
     C                   ENDSR
      *****************************************************************
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
     C                   PARM                    InfData500                                   CAP086
      * Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ##FRIS
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData500
      * Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
      * Ultimate calling Program/Module/Procedure
     C                   PARM                    LoanType          4
      *                                                                                     AR804863
      ** Reject Button                                                                      AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'LERMSGF '
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'Y2USRMSG'
 
      **  Add GBBYUSRMSG to MsgFArray if BOE installed                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
     C                             'GBBYUSRMSG'                                              LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      * Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'LE'
 
      * Access Bank details via access program
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
 
      * Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APCLIPDTQ'
 
      *                                                                                       CLE030
      ***  Determine if Release authorisation enhancement feature                             CLE030
      ***  is installed                                                                       CLE030
      *                                                                                       CLE030
     C                   MOVE      'N'           CLE030            1                          CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD             6                          CLE030
      *                                                                                       CLE030
     C     @RTCD         IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'Y'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
     C     @RTCD         IFEQ      '*NRF'                                                     CLE030
     C                   MOVE      'N'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      * DATABASE ERROR                                                                        CLE030
      *                                                                                       CLE030
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE030
     C                   MOVEL     '902'         DBASE                          * DBERR 902 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
                                                                                             BUG3721
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
     C                   MOVEL     '905'         DBASE                          * DBERR 905 *BUG3721
     C                   MOVEL     @OPTN         DBKEY                          *************BUG3721
     C                   EXSR      *PSSR                                                     BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
 
     C                   EVAL      @RTCD = *BLANKS
      *                                                                                       CLE030
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LECLIPC018
      *                                                                                      LLN022A
      ** Determine if LLN007 (BOE Yellow Book) is switched on                                LLN022A
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
                                                                                              CSC022
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
     C                   EVAL      DBPGM = 'LECLIPCTL'                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 903                                               CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CER001
      ** Check if switchable feature ULX004 is ON.                                            CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX004                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD             6                          CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVE      'Y'           ULX004                                       CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX004 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C     @RTCD         IFEQ      '*NRF'                                                     CER001
     C                   MOVE      'N'           ULX004                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** Database error                                                                       CER001
      *                                                                                       CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBPGM = 'LECLIPCTL'                                        CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   EVAL      DBASE = 904                                                CER001
     C                   MOVEL     @OPTN         DBKEY                                        CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CAP086
      ** Check if CAP086 is enabled                                                           CAP086
                                                                                              CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRtCd                                        CAP086
     C                   PARM      '*VERIFY'     POptn                                        CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRtCd = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C                   IF        PRtCd <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBase = 906                                                CAP086
     C                   EVAL      DBKey = 'CAP086'                                           CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CSC022
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
