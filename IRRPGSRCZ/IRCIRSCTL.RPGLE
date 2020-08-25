     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross ccy IRS validation controller')         *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCIRSCTL - Validate IRS Deals - Controlling program         *
      *                                                               *
      *  Function: This Program Validates Cross Currency IRS deals    *
      *            for Input into the Midas database.                 *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert)                                  *
      *              - If ALL of the settlement fields are blank, set *
      *                them up from standard settlement instructions  *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the deal fields                       *
      *              - Validate the settlement fields                 *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For X (=Authorise) call a separate function to   *
      *              process this deal and bypass the rest of the     *
      *              validation                                       *
      *            - For D (=Delete) call a separate function to      *
      *              process this deal and bypass the rest of the     *
      *              validation                                       *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 245692             Date 11Dec13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248452             Date 13Jun07               *
      *                 247888             Date 18May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241470             Date 07Sep06               *
      *                 CIR014             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 233467             Date 06Jun05               *
      *                 BUG9887            Date 12Jan06               *
      *                 CDL038             Date 10May05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG6472            Date 20Apr05               *
      *                 CAS008             Date 16Jun04               *
      *                 CDL028             Date 07Feb05               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 31Oct03               *
      *                 221576             Date 16Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CRE008             Date 19Feb02               *
      *                 218641             Date 10Jun03               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196461             Date 22Apr02               *
      *                 185064             Date 05Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 199787             Date 06Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 CAS001             Date 23Nov01               *
      *                 CAP041             Date 07Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185057             Date 23Jan01               *
      *                 184560             Date 23Jan01               *
      *                 188418             Date 09Jan01               *
      *                 CIR003             Date 13Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187606             Date 12Dec00               *
      *                 179510             Date 06Nov00               *
      *                 166888             Date 08Sep99               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033             Date 26Apr99               *
      *                 CSW097             Date 02Dec99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 170909             Date 07Sep99               *
      *                 167475             Date 14Sep99               *
      *                 162497             Date 21Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 168981             Date 20May99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP004             Date 28Jul98               *
      *                 CAP003  *CREATE    Date 06OCT97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248452 - Remove 247888 from IRCIRSCTL and IRSIRSCTL only.    *
      *           Update done by UPD module.                          *
      *  247888 - Missing record in CLE025 files.                     *
      *  241470 - New field by CDL038 not passed to work file.        *
      *           Add core fix BUG9887.                               *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233467 - Additional parameter vDLNO for IRCFBOVAL (Recompile)*
      *  BUG9887 - Increase size of TRANS500 to 1000 (CDL028)         *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG6472- Added sign field for short term rate (Recompile)    *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CLE025 - Credit Lines                                        *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors (Authorization fails: dumps)     *
      *  222373 - Correct parameters on program calls                 *
      *  221576 - Adjust field positions caused by 218641 and CAS005  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CRE008 - Cash Management  Added parameters to ZASETINVAL     *
      *  218641 - Adjust Yield Curve field position in the definition *
      *           file                                                *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  196461 - Additional parameter ##PREC and ##PPAY in ZASETINVAL*
      *  185064 - Old up-front fee details should be saved in         *
      *           DLDGUPFE.                                           *
      *  CAP056 - Automatic Authorisation of Interface Deals.         *
      *  CIR008 - FRA/IRS Deals Authorisation.                        *
      *  199787 - Add Action Code parameter when calling ZASETINVAL   *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *  200400 - Reverse fix 179510.                                 *
      *  185057 - Validate 'Rate fix days' and 'Rate change Date,     *
      *           only if one of them has changed.                    *
      *           Pass the parameters down.                           *
      *  184560 - Validate Maturity date correctly against            *
      *           Our and Their Start/Last Int Pay Date.              *
      *  188418 - Interest rate calendar validation fails             *
      *  CIR003 - Principal Exchange on Cross Currencies IRS.         *
      *  187606 - Do not validate the Amount/Base Currency Rate       *
      *           in Amend mode.                                      *
      *  179510 - Added  @MORPI  parameter at call to  ZASETINVAL     *
      *           and  Re-compiled  .                                 *
      *  166888 - Settlement Instructions - Pay Ordering Bank returns *
      *           to defaulted value all the time. Apply GEMS 163745  *
      *           However, 163745 only fixes the problem for 'A' and  *
      *           'X' processing. Problem still exists for insert.    *
      *           Need to default only the 1st time validation is     *
      *           done. Do not re-default for subsequent validations. *
      *           Due to this 163745 in its original form is no       *
      *           longer required, now default required only for      *
      *           'first time insert'.                                *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Increased length of Transaction        *
      *           Reference ID from 6A to 20A.                        *
      *  CSW097 - Swift 97 changes for FRAIRS MT34* and MT36*         *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  170909 - Settlement instructions not updated on amendment    *
      *  167475 - If FRA/IRS CTL functions fail, they loop.           *
      *  162497 - Errors in processing of settlement instructions     *
      *           (within ZASETINVAL and ZASETINSIN).                 *
      *  168981 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*       *
      *           (recompiled)                                        *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP004 - Add APIs Interest Rate Calendar processing          *
      *           Add extra parm for Extar Data                       *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FIRVCIRSPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT

     FIRICIRSPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT

     FIRVDTSCPD UF A E             DISK    INFSR(*PSSR)                         CAP004
     F                                     COMMIT                               CAP004
                                                                                CAP004
     FIRIDTSCPD UF A E             DISK    INFSR(*PSSR)                         CAP004
     F                                     COMMIT                               CAP004
                                                                                CAP004
     FIRVCFSCPD UF A E             DISK    INFSR(*PSSR) PREFIX(CV)                            CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRICFSCPD UF A E             DISK    INFSR(*PSSR) PREFIX(CI)                            CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRVPCSCPD UF A E             DISK    INFSR(*PSSR) PREFIX(PV)                            CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRIPCSCPD UF A E             DISK    INFSR(*PSSR) PREFIX(PI)                            CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRWDTSCL0 UF A E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRWCFSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(C)                             CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRWPCSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(P)                             CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRWCIRSL0 UF A E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRTDTSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(D)                             CAP043
     F                                     RENAME(IRVDTSCD0:IRTDTSCD0)                        CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRTCFSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(C)                             CAP043
     F                                     RENAME(IRVCFSCD0:IRTCFSCD0)                        CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRTPCSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(P)                             CAP043
     F                                     RENAME(IRVPCSCD0:IRTPCSCD0)                        CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FAPIDSETPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT

     FIRVXSETPD UF A E             DISK    INFSR(*PSSR)  PREFIX(EX)                           CIR003
     F                                     COMMIT                                             CIR003
                                                                                              CIR003
     FIRIXSETPD UF A E             DISK    INFSR(*PSSR)  PREFIX(EX)                           CIR003
     F                                     COMMIT                                             CIR003
                                                                                              CIR003
      ***FX/MM/FRA/IRS Extension files                                                  247888248452
     F*DLDEALL5  UF A E           K DISK    PREFIX(DX_)                                 247888248452
     F**********                           INFSR(*pssr)                                 247888248452
     F**********                           COMMIT                                       247888248452
      **********                                                                        247888248452
     FIRVCIRSL0 IF   E           K DISK    RENAME(IRVCIRSD0:IRVCIRSCHK)
     F                                     INFSR(*pssr)                         CAP013
     FIRVCIRSL1 IF   E           K DISK    RENAME(IRVCIRSD0:IRVCIRSCK1)         CAP013
     F                                     INFSR(*pssr)                         CAP013
                                                                                              CAP041
     FDLDGUPFE  O    E           K DISK    INFSR(*PSSR)                                       CAP041
     F                                     RENAME(DLDGREF:DLDGREFF)                           CAP041
     F                                     COMMIT                                             CAP041
                                                                                              CAP041
     FDLDGUPL1  UF   E           K DISK    INFSR(*PSSR)                                       CAP041
     F                                     COMMIT                                             CAP041

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRCIRSC019

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

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

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
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
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

      ** String for error messages to the operator                              167475
     D ProcErr         C                   CONST('Error in module')             167475
                                                                                167475
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D OurRDTSC        S            492A   DIM(ArrayMax)                                      CAP043
     D OurIDTSC        S            492A   DIM(ArrayMax)                                      CAP043
     D ThrRDTSC        S            492A   DIM(ArrayMax)                                      CAP043
     D ThrIDTSC        S            492A   DIM(ArrayMax)                                      CAP043
     D OurCFSC         S           1640A   DIM(ArrayMax)                                      CAP043
     D ThrCFSC         S           1640A   DIM(ArrayMax)                                      CAP043
     D OurPCSC         S           1886A   DIM(ArrayMax)                                      CAP043
     D ThrPCSC         S           1886A   DIM(ArrayMax)                                      CAP043

     D HeadIn        E DS                  EXTNAME(APHEADPD)
      * Incoming Header
     D WMSGTYPE                1      6                                                       CAP043

     D TranIn        E DS                  EXTNAME(IRCIRSPD)
      * Incoming Transaction
     D*WBDCLeg1**************243****272***                                             CAP043 221576
     D*WBDCLeg2**************307****336***                                             CAP043 221576
     D*WBDCLeg1**************263    292                                                221576 CLE025
     D*WBDCLeg2**************327    356                                                221576 CLE025
     D WBDCLeg1              278    307                                                       CLE025
     D WBDCLeg2              342    371                                                       CLE025

     D ValidDeal     E DS                  EXTNAME(IRVCIRSPD)
      * Valid Deals layout
     D CIRSRecIns            716    784
     D CIRSPayIns            785   1343
     D CIRSFraIns           1345   1992
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
                                                                                              CLE025
     D ValidXDeal    E DS                  EXTNAME(IRVXSIRPD)                                 CLE025
      * Valid Deals layout                                                                    CLE025

     D DealFilFmt    E DS                  EXTNAME(DEALSDG)
      * (Current) Deal in File Format
     D DGRecIns              716    784
     D DGPayIns              785   1343
     D DGFraIns             1345   1992
      * Large fields to include
      * - Receive instructions (RSTM to ROCN)
      * - Pay     instructions (PSTM to BTB6)
                                                                                              CLE025
     D DealXFilFmt   E DS                  EXTNAME(DLDLDGQD)                                  CLE025
      ** Deal Extension File Format                                                           CLE025

     D DealScnFmt    E DS                  EXTNAME(IRCIRSPD)
     D                                     PREFIX(@)
      * (Current) Deal in Screen Format

     D OurRatChgD    E DS                  EXTNAME(IRDTSCPD)                    CAP004
      * Our Rate Change Dates (IRCs)                                            CAP004
     D                                     PREFIX(OR)                           CAP004
     D ORDatesAlp              1    492                                         CAP004
                                                                                CAP004
     D OurIntPayD    E DS                  EXTNAME(IRDTSCPD)                    CAP004
      * Our Interest Payment Dates (IRCs)                                       CAP004
     D                                     PREFIX(OP)                           CAP004
     D OPDatesAlp              1    492                                         CAP004
                                                                                CAP004
     D ThrRatChgD    E DS                  EXTNAME(IRDTSCPD)                    CAP004
      * Their Rate Change Dates (IRCs)                                          CAP004
     D                                     PREFIX(TR)                           CAP004
     D TRDatesAlp              1    492                                         CAP004
                                                                                CAP004
     D ThrIntPayD    E DS                  EXTNAME(IRDTSCPD)                    CAP004
      * Their Interest Payment Dates (IRCs)                                     CAP004
     D                                     PREFIX(TP)                           CAP004
     D TPDatesAlp              1    492                                         CAP004
                                                                                CAP004
     D OurRatChgD2   E DS                  EXTNAME(IRDTSCPD) PREFIX(OR2)                      CAP043
      ** Our Rate Change Dates (IRCs)                                                         CAP043
     D ORDatesAlp2             1    492                                                       CAP043
                                                                                              CAP043
     D OurIntPayD2   E DS                  EXTNAME(IRDTSCPD) PREFIX(OP2)                      CAP043
      ** Our Interest Payment Dates (IRCs)                                                    CAP043
     D OPDatesAlp2             1    492                                                       CAP043
                                                                                              CAP043
     D ThrRatChgD2   E DS                  EXTNAME(IRDTSCPD) PREFIX(TR2)                      CAP043
      ** Their Rate Change Dates (IRCs)                                                       CAP043
     D TRDatesAlp2             1    492                                                       CAP043
                                                                                              CAP043
     D ThrIntPayD2   E DS                  EXTNAME(IRDTSCPD) PREFIX(TP2)                      CAP043
      ** Their Interest Payment Dates (IRCs)                                                  CAP043
     D TPDatesAlp2             1    492                                                       CAP043
                                                                                              CAP043
     D CshFlwDS      E DS                  EXTNAME(IRCFSCPD) PREFIX(CS)                       CAP043
      ** Cash Flow Schedule (used to save cash flow records in IRWCFSCPD file)                CAP043
     D WCshFlw1                1    492                                                       CAP043
     D WCshFlw2              493    982                                                       CAP043
     D WCshFlw3              983   1472                                                       CAP043
     D WCshFlw4             1473   1640                                                       CAP043
                                                                                              CAP043
     D PrcChgDS      E DS                  EXTNAME(IRPCSCPD) PREFIX(PR)                       CAP043
      ** Principal Change Schedule (used to save principal change records                     CAP043
      ** in IRWPCSCPD file)                                                                   CAP043
     D WPrcChg1                1    492                                                       CAP043
     D WPrcChg2              493    988                                                       CAP043
     D WPrcChg3              989   1484                                                       CAP043
     D WPrcChg4             1485   1886                                                       CAP043
                                                                                              CAP043
     D WCshFlwDS     E DS                  EXTNAME(IRWCFSCPD) PREFIX(C)                       CAP043
      ** Cash Flow Schedule work definition file (DS of IRWCFSCL0 defined in F Specs)         CAP043
     D WCashFlw               43   1682                                                       CAP043
                                                                                              CAP043
     D WPrcChgDS     E DS                  EXTNAME(IRWPCSCPD) PREFIX(P)                       CAP043
      ** Principal Change Schedule work definition file (DS of IRWPCSCL0 defined              CAP043
      ** in F Specs)                                                                          CAP043
     D WPrinChg               43   1928                                                       CAP043
                                                                                              CAP043
     D OurCshFDS     E DS                  EXTNAME(IRWCFSCPD) PREFIX(OC)                      CAP043
      ** Our Cash Flow Schedule (used to validate our cash flow)                              CAP043
     D WOurCshFD              43    534                                                       CAP043
     D WOurCshFA             535   1682                                                       CAP043
     D WOurCash               43   1682                                                       CAP043
                                                                                              CAP043
     D ThrCshFDS     E DS                  EXTNAME(IRWCFSCPD) PREFIX(TC)                      CAP043
      ** Their Cash Flow Schedule (used to validate their cash flow)                          CAP043
     D WThrCshFD              43    534                                                       CAP043
     D WThrCshFA             535   1682                                                       CAP043
     D WThrCash               43   1682                                                       CAP043
                                                                                              CAP043
     D OurPrcCDS     E DS                  EXTNAME(IRWPCSCPD) PREFIX(OP)                      CAP043
      ** Our Principal Change Schedule (used to validate our prin change)                     CAP043
     D WOurPrcCD              43    534                                                       CAP043
     D WOurPrcCA             535   1846                                                       CAP043
     D WOurPrcCI            1847   1928                                                       CAP043
     D WOurPrin               43   1928                                                       CAP043
                                                                                              CAP043
     D ThrPrcCDS     E DS                  EXTNAME(IRWPCSCPD) PREFIX(TP)                      CAP043
      ** Their Principal Change Schedule (used to validate their prin change)                 CAP043
     D WThrPrcCD              43    534                                                       CAP043
     D WThrPrcCA             535   1846                                                       CAP043
     D WThrPrcCI            1847   1928                                                       CAP043
     D WThrPrin               43   1928                                                       CAP043
                                                                                              CAP043
     D WrkCIRSDS     E DS                  EXTNAME(IRWCIRSPD)                                 CAP043
      ** CIRS work file DS (used to save x-ccy records in IRWCIRSPD)                          CAP043
     D*WIRCIRS****************42****477***                                             CAP043 221576
     D*WIRCIRS****************42****487***                                             221576 241470
     D WIRCIRS                42    606                                                       241470
                                                                                              CAP043
     D WrkDTSCDS     E DS                  EXTNAME(IRWDTSCPD)                                 CAP043
      ** DTSC work file DS (used to save irc records in IRWDTSCPD)                            CAP043
     D WDFOTRANID    E                     EXTFLD(WSFOTRANID)                                 CAP043
     D WDFOASOCID    E                     EXTFLD(WSFOASOCID)                                 CAP043
     D WDRPRLOCN     E                     EXTFLD(WSRPRLOCN)                                  CAP043
     D WIRDTSC                44    535                                                       CAP043
                                                                                              CAP043
     D TIntRtCDS     E DS                  EXTNAME(IRTDTSCPD) PREFIX(D)                       CAP043
      ** Cash Flow Schedule temporary definition file (used to save valid records             CAP043
      ** in IRTDTSCPD)                                                                        CAP043
     D WIntRtC                23    268                                                       CAP043
     D WDTSCConfH            269    350                                                       CAP043
                                                                                              CAP043
     D TCshFlwDS     E DS                  EXTNAME(IRTCFSCPD) PREFIX(C)                       CAP043
      ** Cash Flow Schedule temporary definition file (used to save valid records             CAP043
      ** in IRTCFSCPD)                                                                        CAP043
     D WCashFlwD              22    267                                                       CAP043
     D WCashFlwA             268    841                                                       CAP043
     D WCFSCConfH            842    923                                                       CAP043
                                                                                              CAP043
     D TPrcChgDS     E DS                  EXTNAME(IRTPCSCPD) PREFIX(P)                       CAP043
      ** Principal Change Schedule temporary definition file (used to save valid              CAP043
      ** records in IRTPCSCPD)                                                                CAP043
     D WPrinChgD              22    267                                                       CAP043
     D WPrinChgA             268    923                                                       CAP043
     D WPrinChgCA            924   1579                                                       CAP043
     D WPCSCConfH           1580   1661                                                       CAP043
     D WPCSCIDInd           1662   1743                                                       CAP043
                                                                                              CAP043
     D VldCashFlw    E DS                  EXTNAME(IRVCFSCPD) PREFIX(CV)                      CAP043
      ** Valid Cash Flow definition file (use to write valid records in IRVCFSCPD)            CAP043
                                                                                              CAP043
     D VldPrinChg    E DS                  EXTNAME(IRVPCSCPD) PREFIX(PV)                      CAP043
      ** Valid Prin Change def file (use to write valid records in IRVPCSCPD)                 CAP043
                                                                                              CAP043
     D InvCashFlw    E DS                  EXTNAME(IRICFSCPD) PREFIX(CI)                      CAP043
      ** Invld Cash Flow definition file (use to write invld records in IRICFSCPD)            CAP043
     D WInvCshFlw             23   1662                                                       CAP043
                                                                                              CAP043
     D InvPrinChg    E DS                  EXTNAME(IRIPCSCPD) PREFIX(PI)                      CAP043
      ** Invld Prin Change def file (use to write invld records in IRIPCSCPD)                 CAP043
     D WInvPrcChg             23   1908                                                       CAP043
                                                                                              CAP043
     D TrailerDS     E DS                  EXTNAME(IRTRSCPD)                                  CAP043
      ** Trailer file DS                                                                      CAP043
                                                                                              CAP043
     D ValidExt      E DS                  EXTNAME(IRVXSETPD)  PREFIX(EX)                     CIR003
     D***ExRSet*               10     84                                               CIR003 CGL029
     D***ExPSet*               85    653                                               CIR003 CGL029
     D  ExRSet                10     90                                                       CGL029
     D  ExPSet                91    665                                                       CGL029
                                                                                              CIR003
     D InValExt      E DS                  EXTNAME(IRIXSETPD)  PREFIX(EX)                     CIR003
     D***ExRSetI               31    105                                               CIR003 CGL029
     D***ExPSetI              106    706                                               CIR003 CGL029
     D  ExRSetI               31    111                                                       CGL029
     D  ExPSetI              112    712                                                       CGL029
                                                                                              CIR003
     D ExtSetV       E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(VD)                                         CIR003
     D***ExRValDat             10     84                                               CIR003 CGL029
     D***ExPValDat             85    653                                               CIR003 CGL029
     D  ExRValDat             10     90                                                       CGL029
     D  ExPValDat             91    665                                                       CGL029
                                                                                              CIR003
     D ExtSetM       E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(MD)                                         CIR003
     D***ExRMatDat             10     84                                               CIR003 CGL029
     D***ExPMatDat             85    653                                               CIR003 CGL029
     D  ExRMatDat             10     90                                                       CGL029
     D  ExPMatDat             91    665                                                       CGL029
                                                                                              CIR003
     D ExtSetI       E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(ID)                                         CIR003
                                                                                              CIR003
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions - Input

     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions - Input

     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions - Input

     D InPayStmtE    E DS                  EXTNAME(SDESSPPD)                                  CIR003
     D                                     PREFIX(E)                                          CIR003
      * Pay Settlement Instructions - Extra Settlements                                       CIR003
                                                                                              CIR003
     D InRecStmtE    E DS                  EXTNAME(SDESSRPD)                                  CIR003
     D                                     PREFIX(E)                                          CIR003
      * Receive Settlement Instructions - Extra Settlements                                   CIR003
                                                                                              CIR003
     D InFRAStmtE    E DS                  EXTNAME(SDESSFPD)                                  CIR003
     D                                     PREFIX(E)                                          CIR003
      * FRA/IRS Settlement Instructions - Extra Settlements                                   CIR003
                                                                                              CIR003
     D InPayStmtV    E DS                  EXTNAME(SDESSPPD)                                  CIR003
     D                                     PREFIX(V)                                          CIR003
      * Pay Settlement Instructions - Value date                                              CIR003
                                                                                              CIR003
     D InRecStmtV    E DS                  EXTNAME(SDESSRPD)                                  CIR003
     D                                     PREFIX(V)                                          CIR003
      * Receive Settlement Instructions - Vaue Date                                           CIR003
                                                                                              CIR003
     D InPayStmtM    E DS                  EXTNAME(SDESSPPD)                                  CIR003
     D                                     PREFIX(M)                                          CIR003
      * Pay Settlement Instructions - Maturity Date                                           CIR003
                                                                                              CIR003
     D InRecStmtM    E DS                  EXTNAME(SDESSRPD)                                  CIR003
     D                                     PREFIX(M)                                          CIR003
      * Receive Settlement Instructions - Maturity Date                                       CIR003
                                                                                              CIR003
     D CrPayStmtE    E DS                  EXTNAME(SDESSPPD) PREFIX(C)                        CIR003
      * Pay Settlement Instructions - Current  (Extra)                                        CIR003
                                                                                              CIR003
     D CrRecStmtE    E DS                  EXTNAME(SDESSRPD) PREFIX(C)                        CIR003
      * Receive Settlement Instructions - Current  (Extra)                                    CIR003
                                                                                              CIR003
     D CrFRAStmtE    E DS                  EXTNAME(SDESSFPD) PREFIX(C)                        CIR003
      * FRA/IRS Settlement Instructions - Current (Extra)                                     CIR003
                                                                                              CIR003
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)          CAP011
      * Pay Settlement Instructions - Current                                   CAP011
                                                                                CAP011
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)          CAP011
      * Receive Settlement Instructions - Current                               CAP011
                                                                                CAP011
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)          CAP011
      * FRA/IRS Settlement Instructions - Current                               CAP011
                                                                                CAP011
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
      * Pay Settlement Instructions - File (D/B) format

     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
      * Receive Settlement Instructions - File (D/B) format

     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS Settlement Instructions - File (D/B) format
                                                                                CAP004
     D DBPayStmtE    E DS                  EXTNAME(SDESFPPD)                                  CIR003
     D                                     PREFIX(E)                                          CIR003
      * Pay Settlement Instructions - File (D/B) format (Extra)                               CIR003
                                                                                              CIR003
     D DBRecStmtE    E DS                  EXTNAME(SDESFRPD)                                  CIR003
     D                                     PREFIX(E)                                          CIR003
      * Receive Settlement Instructions - File (D/B) format (Extra)                           CIR003
                                                                                              CIR003
     D DBFRAStmtE    E DS                  EXTNAME(SDESFFPD)                                  CIR003
     D                                     PREFIX(E)                                          CIR003
      * FRA/IRS Settlement Instructions - File (D/B) format (Extra)                           CIR003
                                                                                              CIR003
     D DBPayStmtV    E DS                  EXTNAME(SDESFPPD)                                  CIR003
     D                                     PREFIX(V)                                          CIR003
      * Pay Settlement Instructions - File (D/B) format (Value date)                          CIR003
                                                                                              CIR003
     D DBRecStmtV    E DS                  EXTNAME(SDESFRPD)                                  CIR003
     D                                     PREFIX(V)                                          CIR003
      * Receive Settlement Instructions - File (D/B) format (Value date)                      CIR003
                                                                                              CIR003
     D DBPayStmtM    E DS                  EXTNAME(SDESFPPD)                                  CIR003
     D                                     PREFIX(M)                                          CIR003
      * Pay Settlement Instructions - File (D/B) format (Maturity date)                       CIR003
                                                                                              CIR003
     D DBRecStmtM    E DS                  EXTNAME(SDESFRPD)                                  CIR003
     D                                     PREFIX(M)                                          CIR003
      * Receive Settlement Instructions - File (D/B) format (Maturity date)                   CIR003
                                                                                              CIR003
      ** FRA/IRS Interface Non-Screen Data                                                    CAP056
     D InfData       E DS                  EXTNAME(IRRXIFPD)                                  CAP056
                                                                                              CAP056
     D ExtData       E DS                  EXTNAME(IRCSEXPD)                    CAP004
      * IR Cross Ccy IRS Extra Data - File (D/B) format                         CAP004

     D InvIRCData    E DS                  EXTNAME(IRIDTSCPD)                   CAP004
      * Invalid Interest Rate Calendar Dates                                    CAP004
     D IRCDates               24    515                                         CAP004
                                                                                CAP004
     D ValIRCData    E DS                  EXTNAME(IRVDTSCPD)                   CAP004
      * Valid Interest Rate Calendar Dates                                      CAP004
                                                                                CAP004
     D DBORatChgD    E DS                  EXTNAME(IRVDTSCPD)                   CAP004
      * Our Rate Change Dates (IRCs) - Midas Day Number format                  CAP004
     D                                     PREFIX(OR)                           CAP004
     D ORFoTran      E                     EXTFLD(XFOTRANID)                    CAP004
     D ORDates                23    268A                                        CAP004
     D ORConfH               269    350A                                                      CAP043
                                                                                CAP004
     D DBOIntPayD    E DS                  EXTNAME(IRVDTSCPD)                   CAP004
      * Our Interest Payment Dates (IRCs) - Midas Day Number format             CAP004
     D                                     PREFIX(OP)                           CAP004
     D OPFoTran      E                     EXTFLD(XFOTRANID)                    CAP004
     D OPDates                23    268A                                        CAP004
     D OPConfH               269    350A                                                      CAP043
                                                                                CAP004
     D DBTRatChgD    E DS                  EXTNAME(IRVDTSCPD)                   CAP004
      * Their Rate Change Dates (IRCs) - Midas Day Number format                CAP004
     D                                     PREFIX(TR)                           CAP004
     D TRFoTran      E                     EXTFLD(XFOTRANID)                    CAP004
     D TRDates                23    268A                                        CAP004
     D TRConfH               269    350A                                                      CAP043
                                                                                CAP004
     D DBTIntPayD    E DS                  EXTNAME(IRVDTSCPD)                   CAP004
      * Their Interest Payment Dates (IRCs) - Midas Day Number format           CAP004
     D                                     PREFIX(TP)                           CAP004
     D TPFoTran      E                     EXTFLD(XFOTRANID)                    CAP004
     D TPDates                23    268A                                        CAP004
     D TPConfH               269    350A                                                      CAP043
                                                                                CAP004
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
                                                                                              245692
      ** External DS for Deal details                                                         245692
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692
     D W#ACCD        E                     EXTFLD(QQACCD)                                     245692
                                                                                              245692
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** External DS for API ICD                                                CAP011

     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
      ** External data structure for FRA/IRS I.C.D. details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP004
      ** EXTERNAL DS FOR SAR DETAILS                                            CAP004
     D XLCD          E                     EXTFLD(LCD)                          CAP004
      *                                                                                       CAP041
      ** Transaction Details in screen format                                                 CAP041
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)                                  CAP041
     D                                     PREFIX(A)                                          CAP041
      *                                                                                       CAP041
      ** Transaction Details retrieved from file - in screen                                  CAP041
      ** format                                                                               CAP041
     D CrFBScnFmt    E DS                  EXTNAME(IRFEBOPD)                                  CAP041
     D                                     PREFIX(B)                                          CAP041
      *                                                                                       CAP041
      ** Transaction Details OK indicators                                                    CAP041
     D OKFBScnFmt    E DS                  EXTNAME(IREFEBOPD)                                 CAP041
      *                                                                                       CAP041
      ** External DS for Currency Details                                                     CAP041
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CAP041
      *                                                                                       CAP041
      ** External DS for Nostro Details                                                       CAP041
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CAP041
      *                                                                                       CAP041
      ** First DS for Access programs - long data structure                                   CAP041
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CAP041
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011

     D/COPY QWINDSRC,IRCIRSGDTA                                                               CAP041

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Field (500A) to receive the incoming transaction
     D****** Trans500        S            500A                                               BUG9887
      *                                                                                      BUG9887
      * Simple fix is to redefine the field; should really rename it as well                 BUG9887
     D Trans500        S           1000A                                                     BUG9887
                                                                                CAP004
      ** Field (500A) to receive the incoming Extra Data                        CAP004
     D ExtData500      S            500A                                        CAP004
                                                                                              CAP056
      ** Field (500A) to receive the incoming Interface Non-Screen Data                       CAP056
     D InfData500      S            500A                                                      CAP056

      ** Fields (500A) to receive the incoming Interest Rate Calendar info      CAP004
     D TransB500       S            500A                                        CAP004
     D TransC500       S            500A                                        CAP004
     D TransD500       S            500A                                        CAP004
     D TransE500       S            500A                                        CAP004
     D TransF500       S            500A                                                      CAP043
     D TransG500       S            500A                                                      CAP043
     D TransH500       S            500A                                                      CAP043

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

      ** for Transaction Currencies (Receipt and Payment Currency)                           CSF011A
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A

      ** Flags to indicate whether transaction fields are valid
      ** These have been declared for all DL1602 fields, some may not
      **  actually be needed if the field is not used/not validated
     D OKFlagsDS       DS
     D  SAccdOK                       1A   INZ('Y')
     D  SDlnoOK                       1A   INZ('Y')
     D  SDTypOK                       1A   INZ('Y')
     D  SDlstOK                       1A   INZ('Y')
     D  SDDatOK                       1A   INZ('Y')
     D  SBrcaOK                       1A   INZ('Y')
     D  SBrkcOK                       1A   INZ('Y')
     D  SBageOK                       1A   INZ('Y')
     D  SLnkDnOK                      1A   INZ('Y')
     D  SCnumOK                       1A   INZ('Y')
     D  SVDatOK                       1A   INZ('Y')
     D  SMDatOK                       1A   INZ('Y')
     D  SCdasOK                       1A   INZ('Y')
     D  STaxiOK                       1A   INZ('Y')
     D  SPrfCOK                       1A   INZ('Y')
     D  SOrBrOK                       1A   INZ('Y')
     D  SBokCOK                       1A   INZ('Y')
     D  SVDEIOK                       1A   INZ('Y')
     D  SMDEIOK                       1A   INZ('Y')
     D  SPDEIOK                       1A   INZ('Y')
     D  SUCucyOK                      1A   INZ('Y')
     D  SUPamtOK                      1A   INZ('Y')
     D  SUFfiOK                       1A   INZ('Y')
     D  SUBcxrOK                      1A   INZ('Y')
     D  SuBrttOK                      1A   INZ('Y')
     D  SuRtSpOK                      1A   INZ('Y')
     D  SuSpInOK                      1A   INZ('Y')
     D  SuFrfdOK                      1A   INZ('Y')
     D  SuNICDOK                      1A   INZ('Y')
     D  SuICFrOK                      1A   INZ('Y')
     D  SuICFDOK                      1A   INZ('Y')
     D  SuEINROK                      1A   INZ('Y')
     D  SuNIPDOK                      1A   INZ('Y')
     D  SuIPFrOK                      1A   INZ('Y')
     D  SuIPFDOK                      1A   INZ('Y')
     D  SuIcbsOK                      1A   INZ('Y')
     D  StCucyOK                      1A   INZ('Y')
     D  StPamtOK                      1A   INZ('Y')
     D  StFfiOKK                      1A   INZ('Y')
     D  StBcxrOK                      1A   INZ('Y')
     D  StBrttOK                      1A   INZ('Y')
     D  StRtSpOK                      1A   INZ('Y')
     D  StSpInOK                      1A   INZ('Y')
     D  StFrfdOK                      1A   INZ('Y')
     D  StNICDOK                      1A   INZ('Y')
     D  StICFrOK                      1A   INZ('Y')
     D  StICFDOK                      1A   INZ('Y')
     D  StEINROK                      1A   INZ('Y')
     D  StNIPDOK                      1A   INZ('Y')
     D  StIPFrOK                      1A   INZ('Y')
     D  StIPFDOK                      1A   INZ('Y')
     D  StIcbsOK                      1A   INZ('Y')
     D  SCAInOK                       1A   INZ('Y')                             CIR005
     D  OKOYLC                        1A   INZ('Y')                                           218641
     D  OKTYLC                        1A   INZ('Y')                                           218641
     D  OKOFYC                        1A   INZ('Y')                                           CAS005
     D  OKTFYC                        1A   INZ('Y')                                           CAS005
     D  SFCCUOK                       1A   INZ('Y')                                           CDL038
     D  SFACTOK                       1A   INZ('Y')                                           CDL038
     D  SFCNOOK                       1A   INZ('Y')                                           CDL038
     D  OKOFCC                        1A   INZ('Y')                                           CAS008
     D  OKTFCC                        1A   INZ('Y')                                           CAS008
     D  OKC1P1                        1A   INZ('Y')                             CIR005
     D  OKC2P1                        1A   INZ('Y')                             CIR005
     D  OKC3P1                        1A   INZ('Y')                             CIR005
     D  OKC4P1                        1A   INZ('Y')                             CIR005
     D  OKC5P1                        1A   INZ('Y')                             CIR005
     D  OKC6P1                        1A   INZ('Y')                             CIR005
     D  OKC7P1                        1A   INZ('Y')                             CIR005
     D  OKC8P1                        1A   INZ('Y')                             CIR005
     D  OKC9P1                        1A   INZ('Y')                             CIR005
     D  OKC0P1                        1A   INZ('Y')                             CIR005
     D  OKPDC1                        1A   INZ('Y')                             CIR005
     D  OKAMC1                        1A   INZ('Y')                             CIR005
     D  OKC1R1                        1A   INZ('Y')                             CIR005
     D  OKC2R1                        1A   INZ('Y')                             CIR005
     D  OKC3R1                        1A   INZ('Y')                             CIR005
     D  OKC4R1                        1A   INZ('Y')                             CIR005
     D  OKC5R1                        1A   INZ('Y')                             CIR005
     D  OKC6R1                        1A   INZ('Y')                             CIR005
     D  OKC7R1                        1A   INZ('Y')                             CIR005
     D  OKC8R1                        1A   INZ('Y')                             CIR005
     D  OKC9R1                        1A   INZ('Y')                             CIR005
     D  OKC0R1                        1A   INZ('Y')                             CIR005
     D  OKC1P2                        1A   INZ('Y')                             CIR005
     D  OKC2P2                        1A   INZ('Y')                             CIR005
     D  OKC3P2                        1A   INZ('Y')                             CIR005
     D  OKC4P2                        1A   INZ('Y')                             CIR005
     D  OKC5P2                        1A   INZ('Y')                             CIR005
     D  OKC6P2                        1A   INZ('Y')                             CIR005
     D  OKC7P2                        1A   INZ('Y')                             CIR005
     D  OKC8P2                        1A   INZ('Y')                             CIR005
     D  OKC9P2                        1A   INZ('Y')                             CIR005
     D  OKC0P2                        1A   INZ('Y')                             CIR005
     D  OKPDC2                        1A   INZ('Y')                             CIR005
     D  OKAMC2                        1A   INZ('Y')                             CIR005
     D  OKC1R2                        1A   INZ('Y')                             CIR005
     D  OKC2R2                        1A   INZ('Y')                             CIR005
     D  OKC3R2                        1A   INZ('Y')                             CIR005
     D  OKC4R2                        1A   INZ('Y')                             CIR005
     D  OKC5R2                        1A   INZ('Y')                             CIR005
     D  OKC6R2                        1A   INZ('Y')                             CIR005
     D  OKC7R2                        1A   INZ('Y')                             CIR005
     D  OKC8R2                        1A   INZ('Y')                             CIR005
     D  OKC9R2                        1A   INZ('Y')                             CIR005
     D  OKC0R2                        1A   INZ('Y')                             CIR005
     D  SUFVDOK                       1A   INZ('Y')                                           CDL038
     D  SUFEEOK                       1A   INZ('Y')                                           CDL038
     D  SUFPROK                       1A   INZ('Y')                                           CDL038
     D  SBOVDOK                       1A   INZ('Y')                                           CDL038
     D  SBUYAOK                       1A   INZ('Y')                                           CDL038
     D  SBOPROK                       1A   INZ('Y')                                           CDL038
     D  SONPCDOK                      1A   INZ('Y')                                           CDL038
     D  SOIPMOK                       1A   INZ('Y')                                           CDL038
     D  STNPCDOK                      1A   INZ('Y')                                           CDL038
     D  STIPMOK                       1A   INZ('Y')                                           CDL038
     D  SCLASOK                       1A   INZ('Y')                                           CDL038
     D**OKOYLC                        1A   INZ('Y')                                    CAS001 218641
     D**OKTYLC                        1A   INZ('Y')                                    CAS001 218641
     D**SRSetMOK                      1A   INZ('Y')                                           CDL038
     D**SPSetMOK                      1A   INZ('Y')                                           CDL038
     D**SURAccOK                      1A   INZ('Y')                                           CDL038
     D**SROBrOK*                      1A   INZ('Y')                                           CDL038
     D**S@RAccOK                      1A   INZ('Y')                                           CDL038
     D**SUPAccOK                      1A   INZ('Y')                                           CDL038
     D**SPOBrOK*                      1A   INZ('Y')                                           CDL038
     D**S@PAccOK                      1A   INZ('Y')                                           CDL038
     D**SCpPBkOK                      1A   INZ('Y')                                           CDL038
     D**SCpRBkOK                      1A   INZ('Y')                                           CDL038
     D**SFAcOOK*                      1A   INZ('Y')                                           CDL038
     D**SSPiOK**                      1A   INZ('Y')                                           CDL038

      ** Flag to indicate if Exchange Indicators are valid
     D  SExInOK                       1A   INZ('Y')

      ** Flag to indicate Base Currency Equivalent fields are within
      ** 10% of each other
     D  SBCcyEqOK                     1A   INZ('Y')

      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A   INZ('Y')

      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
     D OKPayInsDS      DS
     D  DDPscyOK                      1A   INZ('Y')                                           CIR003
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
     D  DDIc72OK                      1A   INZ('Y')                                           CIR003
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')

      ** Flags to indicate whether Receive Settlement instruction fields
      **  are valid
     D OKRecInsDS      DS
     D  DDRscyOK                      1A   INZ('Y')                                           CIR003
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')

      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKCIRSInDS      DS
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

      ** Flags to indicate whether Extra Pay Settlement instruction fields                    CIR003
      **  are valid                                                                           CIR003
     D OKPayInsDSE     DS                                                                     CIR003
     D  DDPscyOKE                     1A   INZ('Y')                                           CIR003
     D  DDPstmOKE                     1A   INZ('Y')                                           CIR003
     D  DDPonxOKE                     1A   INZ('Y')                                           CIR003
     D  DDRvnoOKE                     1A   INZ('Y')                                           CIR003
     D  DDCvmrOKE                     1A   INZ('Y')                                           CIR003
     D  DDPocnOKE                     1A   INZ('Y')                                           CIR003
     D  DDPobnOKE                     1A   INZ('Y')                                           CIR003
     D  DDRcrnOKE                     1A   INZ('Y')                                           CIR003
     D  DDRcraOKE                     1A   INZ('Y')                                           CIR003
     D  DDPibnOKE                     1A   INZ('Y')                                           CIR003
     D  DDPibaOKE                     1A   INZ('Y')                                           CIR003
     D  DDAwbnOKE                     1A   INZ('Y')                                           CIR003
     D  DDAwbaOKE                     1A   INZ('Y')                                           CIR003
     D  DDBennOKE                     1A   INZ('Y')                                           CIR003
     D  DDBenaOKE                     1A   INZ('Y')                                           CIR003
     D  DDDtp1OKE                     1A   INZ('Y')                                           CIR003
     D  DDDtp2OKE                     1A   INZ('Y')                                           CIR003
     D  DDDtp3OKE                     1A   INZ('Y')                                           CIR003
     D  DDDtp4OKE                     1A   INZ('Y')                                           CIR003
     D  DDDchgOKE                     1A   INZ('Y')                                           CIR003
     D  DDIc72OKE                     1A   INZ('Y')                                           CIR003
     D  DDBtb1OKE                     1A   INZ('Y')                                           CIR003
     D  DDBtb2OKE                     1A   INZ('Y')                                           CIR003
     D  DDBtb3OKE                     1A   INZ('Y')                                           CIR003
     D  DDBtb4OKE                     1A   INZ('Y')                                           CIR003
     D  DDBtb5OKE                     1A   INZ('Y')                                           CIR003
     D  DDBtb6OKE                     1A   INZ('Y')                                           CIR003
                                                                                              CIR003
      ** Flags to indicate whether Extra Receive Settlement instruction fields                CIR003
      **  are valid                                                                           CIR003
     D OKRecInsDSE     DS                                                                     CIR003
     D  DDRscyOKE                     1A   INZ('Y')                                           CIR003
     D  DDRstmOKE                     1A   INZ('Y')                                           CIR003
     D  DDRonxOKE                     1A   INZ('Y')                                           CIR003
     D  DDRocnOKE                     1A   INZ('Y')                                           CIR003
     D  DDRobnOKE                     1A   INZ('Y')                                           CIR003
     D  DDRibnOKE                     1A   INZ('Y')                                           CIR003
     D  DDRibaOKE                     1A   INZ('Y')                                           CIR003
                                                                                              CIR003
      ** Flags to indicate whether Extra FRA/IRS instruction fields are valid                 CIR003
     D OKCIRSInDSE     DS                                                                     CIR003
     D  DDDsr1OKE                     1A   INZ('Y')                                           CIR003
     D  DDDsr2OKE                     1A   INZ('Y')                                           CIR003
     D  DDDsr3OKE                     1A   INZ('Y')                                           CIR003
     D  DDDsr4OKE                     1A   INZ('Y')                                           CIR003
     D  DDDsr5OKE                     1A   INZ('Y')                                           CIR003
     D  DDDsr6OKE                     1A   INZ('Y')                                           CIR003
     D  DDSsr1OKE                     1A   INZ('Y')                                           CIR003
     D  DDSsr2OKE                     1A   INZ('Y')                                           CIR003
     D  DDSsr3OKE                     1A   INZ('Y')                                           CIR003
     D  DDSsr4OKE                     1A   INZ('Y')                                           CIR003
     D  DDSsr5OKE                     1A   INZ('Y')                                           CIR003
     D  DDSsr6OKE                     1A   INZ('Y')                                           CIR003
     D  DDCnd1OKE                     1A   INZ('Y')                                           CIR003
     D  DDCnd2OKE                     1A   INZ('Y')                                           CIR003
     D  DDCnd3OKE                     1A   INZ('Y')                                           CIR003
     D  DDCnd4OKE                     1A   INZ('Y')                                           CIR003
     D  DDCnd5OKE                     1A   INZ('Y')                                           CIR003
     D  DDCnd6OKE                     1A   INZ('Y')                                           CIR003
     D  DDIsdaOKE                     1A   INZ('Y')                                           CIR003
     D  DDAgtyOKE                     1A   INZ('Y')                                           CIR003
     D  DDAgdtOKE                     1A   INZ('Y')                                           CIR003
     D  DDAgvvOKE                     1A   INZ('Y')                                           CIR003
                                                                                              CIR003
      ** Error flags from Dates validation routine
     D ErrDealDat      S              1A   INZ('N')
     D ErrValDate      S              1A   INZ('N')
     D ErrMatDate      S              1A   INZ('N')
     D ErrNxInDat      S              1A   INZ('N')

      ** Flags to indicate outcome of calls to lower level modules
     D AmendOK         S              1A   INZ('Y')

      ** Flag to indicate whether Interest Rate Calendars data valid            CAP004
     D OKInRatCal      S              1A   INZ('Y')                             CAP004
                                                                                CAP004
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A

      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A

      ** Numeric version of spread/rate
     D @SPRD           S             11P 7

      ** A code to indicate the calling function to the lower level modules
     D CIRS            S              4A   INZ('CIRS')

      ** Payment & Receipt dates, passed to Settlements Validation routine.
      ** spaces in parameter list not used by this function
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)

      ***Value*Date*as*a Midas Day Number to be placed in either Payment        162497
      ****or*Receipt*Date                                                       162497
     D*ValDateMDN******S              5P 0                                      162497

      ** Blank fields, passed to Settlements Defaulting routine, to fill
      ** spaces in parameter list not used by this function
     D Blank2          S              2A   INZ(*BLANKS)
     D Blank3          S              3A   INZ(*BLANKS)
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095

      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Receive / Pay Settlement Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D***RecNostro       S             12A                                                    CGL029
     D RecNostro       S             18A                                                      CGL029
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D***PayNostro       S             12A                                                    CGL029
     D PayNostro       S             18A                                                      CGL029

     D Object          S             10A   INZ('IRCIRSUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
                                                                                167475
      ** Dummy message ID and message file fields for use on the calls to       167475
      ** ZAMSGTOOPR                                                             167475
     D DummyMsgID      S                   LIKE(#MsgID)                         167475
     D DummyMsgF       S             10A                                        167475

      ** Date array parameter passed to IRVIRCVAL                               CAP004
     D DatesToVal      S            492A                                        CAP004
      ** IRC valid dates returned from IRVIRCVAL                                CAP004
     D ValidDates      S            246A   INZ(*BLANKS)                         CAP004
      *                                                                         CIR005
      ** Validate Business Day Convention flag                                  CIR005
     D WValBDC         S              1A   INZ('N')                             CIR005
                                                                                              CIR008
      ** Switchable Feature Parameter                                                         CIR008
     D CIR008          S              1A                                                      CIR008
     D CAP056          S              1A                                                      CAP056

     D PWUCDP          S              1P 0                                                    CAP041
     D PWTCDP          S              1P 0                                                    CAP041
     D PWPSCY          S              3A                                                      CAP041
     D PWRSCY          S              3A                                                      CAP041
     D PWPNLOC         S              3A                                                      CAP041
     D PWRNLOC         S              3A                                                      CAP041
     D I#SDLNO         S                   LIKE(SDLNO) INZ(*BLANKS)                           CAP041
                                                                                              CAP041
      ** Fields defined for CSC011                                                            CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D***PDealNum        S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNum        S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
                                                                                              CSC011
      ** Fields defined for CAP043                                                            CAP043
     D CAP043          S              1A                                                      CAP043
     D OKCshFlw        S              1A   INZ('Y')                                           CAP043
     D OKPrcChg        S              1A   INZ('Y')                                           CAP043
     D PAction         S              1A                                                      CAP043
     D PDealNo         S              6A                                                      CAP043
     D PPrevDate       S              5P 0                                                    CAP043
     D PValType        S              1A                                                      CAP043
     D POurTheir       S              1A                                                      CAP043
     D PCurrency       S              3A                                                      CAP043
     D PAmtToVal1      S           1148A                                                      CAP043
     D PAmtToVal2      S           1312A                                                      CAP043
     D PIncDecInd      S             82A                                                      CAP043
     D PConfHol        S             82A                                                      CAP043
     D PBDConvtn       S             30A                                                      CAP043
     D PValidCAmt      S            656A                                                      CAP043
     D PValidAmnt      S            574A                                                      CAP043
     D WMSGTYPE2       S              6A                                                      CAP043
     D WORPrvDate      S              5P 0                                                    CAP043
     D WOPPrvDate      S              5P 0                                                    CAP043
     D WTRPrvDate      S              5P 0                                                    CAP043
     D WTPPrvDate      S              5P 0                                                    CAP043
     D WRatePay        S              1A                                                      CAP043
     D WOurTheir       S              1A                                                      CAP043
     D X               S              3  0                                                    CAP043
     D PCtlDate        S              5P 0                                                    CAP043
      ** Whether or not to clear the program message queue                                    222373
     D ClearPgmQ       S              1A                                                      222373
      ** Additional parameter for IRCFBOVAL                                                   233467
     D vDLNO           S              6A   INZ(*BLANKS)                                       233467
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRCIRSC020

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,IRCIRSC001                                                 CAP004
                                                                                CAP004
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
                                                                                              CAP043
      ** Save message to its corresponding work file when message is not                      CAP043
      ** a trailer, otherwise retrieve saved messages and continue normal                     CAP043
      ** processing                                                                           CAP043
                                                                                              CAP043
     C                   SELECT                                                               CAP043
                                                                                              CAP043
     C                   WHEN      (WMSGTYPE = 'IRCIRS')                                      CAP043
                                                                                              CAP043
     C                   EVAL      WSFOTRANID = APFOTRANID                                    CAP043
     C                   EVAL      WSFOASOCID = APFOASOCID                                    CAP043
     C                   EVAL      WSRPRLOCN = APRPRLOCN                                      CAP043
     C                   MOVEL     Trans500      WIRCIRS                                      CAP043
     C                   MOVEL     TransB500     WSCORAT                                      CAP043
     C                   MOVEL     TransC500     WSCOINT                                      CAP043
     C                   MOVEL     TransD500     WSCTRAT                                      CAP043
     C                   MOVEL     TransE500     WSCTINT                                      CAP043
     C                   WRITE     IRWCIRSD0                                                  CAP043
                                                                                              CAP043
     C                   WHEN      (WMSGTYPE = 'IRCIRI')                                      CAP043
     C                   EVAL      WSFOTRANID = APFOTRANID                                    CAP043
     C                   EVAL      WSFOASOCID = APFOASOCID                                    CAP043
     C                   EVAL      WSRPRLOCN = APRPRLOCN                                      CAP043
                                                                                              CAP043
     C                   EVAL      WSOURTH = 'U'                                              CAP043
     C                   EVAL      WSRATPA = 'R'                                              CAP043
     C                   CLEAR                   WIRDTSC                                      CAP043
     C                   MOVEL     Trans500      WIRDTSC                                      CAP043
     C                   WRITE     IRWDTSCD0                                                  CAP043
                                                                                              CAP043
     C                   EVAL      WSOURTH = 'U'                                              CAP043
     C                   EVAL      WSRATPA = 'P'                                              CAP043
     C                   CLEAR                   WIRDTSC                                      CAP043
     C                   MOVEL     TransB500     WIRDTSC                                      CAP043
     C                   WRITE     IRWDTSCD0                                                  CAP043
                                                                                              CAP043
     C                   EVAL      WSOURTH = 'T'                                              CAP043
     C                   EVAL      WSRATPA = 'R'                                              CAP043
     C                   CLEAR                   WIRDTSC                                      CAP043
     C                   MOVEL     TransC500     WIRDTSC                                      CAP043
     C                   WRITE     IRWDTSCD0                                                  CAP043
                                                                                              CAP043
     C                   EVAL      WSOURTH = 'T'                                              CAP043
     C                   EVAL      WSRATPA = 'P'                                              CAP043
     C                   CLEAR                   WIRDTSC                                      CAP043
     C                   MOVEL     TransD500     WIRDTSC                                      CAP043
     C                   WRITE     IRWDTSCD0                                                  CAP043
                                                                                              CAP043
     C                   WHEN      (WMSGTYPE = 'IRCICF')                                      CAP043
                                                                                              CAP043
     C                   EVAL      CWSFOTRANID = APFOTRANID                                   CAP043
     C                   EVAL      CWSFOASOCID = APFOASOCID                                   CAP043
     C                   EVAL      CWSRPRLOCN = APRPRLOCN                                     CAP043
                                                                                              CAP043
     C                   EVAL      CWSOURTH = 'U'                                             CAP043
     C                   CLEAR                   CshFlwDS                                     CAP043
     C                   MOVEL     TRANS500      WCshFlw1                                     CAP043
     C                   MOVEL     TRANSB500     WCshFlw2                                     CAP043
     C                   MOVEL     TRANSC500     WCshFlw3                                     CAP043
     C                   MOVEL     TRANSD500     WCshFlw4                                     CAP043
     C                   MOVEL     CshFlwDS      WCashFlw                                     CAP043
     C                   WRITE     IRWCFSCD0                                                  CAP043
     C                   EVAL      CWSOURTH = 'T'                                             CAP043
     C                   CLEAR                   CshFlwDS                                     CAP043
     C                   MOVEL     TRANSE500     WCshFlw1                                     CAP043
     C                   MOVEL     TRANSF500     WCshFlw2                                     CAP043
     C                   MOVEL     TRANSG500     WCshFlw3                                     CAP043
     C                   MOVEL     TRANSH500     WCshFlw4                                     CAP043
     C                   MOVEL     CshFlwDS      WCashFlw                                     CAP043
     C                   WRITE     IRWCFSCD0                                                  CAP043
                                                                                              CAP043
     C                   WHEN      (WMSGTYPE = 'IRCIPC') AND (CAP041 = 'Y')                   CAP043
                                                                                              CAP043
     C                   EVAL      PWSFOTRANID = APFOTRANID                                   CAP043
     C                   EVAL      PWSFOASOCID = APFOASOCID                                   CAP043
     C                   EVAL      PWSRPRLOCN = APRPRLOCN                                     CAP043
                                                                                              CAP043
     C                   EVAL      PWSOURTH = 'U'                                             CAP043
     C                   CLEAR                   PrcChgDS                                     CAP043
     C                   MOVEL     TRANS500      WPrcChg1                                     CAP043
     C                   MOVEL     TRANSB500     WPrcChg2                                     CAP043
     C                   MOVEL     TRANSC500     WPrcChg3                                     CAP043
     C                   MOVEL     TRANSD500     WPrcChg4                                     CAP043
     C                   MOVEL     PrcChgDS      WPrinChg                                     CAP043
     C                   WRITE     IRWPCSCD0                                                  CAP043
     C                   EVAL      PWSOURTH = 'T'                                             CAP043
     C                   CLEAR                   PrcChgDS                                     CAP043
     C                   MOVEL     TRANSE500     WPrcChg1                                     CAP043
     C                   MOVEL     TRANSF500     WPrcChg2                                     CAP043
     C                   MOVEL     TRANSG500     WPrcChg3                                     CAP043
     C                   MOVEL     TRANSH500     WPrcChg4                                     CAP043
     C                   MOVEL     PrcChgDS      WPrinChg                                     CAP043
     C                   WRITE     IRWPCSCD0                                                  CAP043
                                                                                              CAP043
     C                   WHEN      (WMSGTYPE = 'IRCITR')                                      CAP043
     C                   MOVEL     TRANS500      TrailerDS                                    CAP043
                                                                                              CAP043
     C                   ENDSL                                                                CAP043
                                                                                              CAP043
      ** Only process transaction record once the trailer arrives                             CAP043
                                                                                              CAP043
     C                   IF        WMSGTYPE <> 'IRCITR'                                       CAP043
                                                                                              CAP043
     C                   COMMIT                                                               CAP043
                                                                                              CAP043
     C                   RETURN                                                               CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Retrieve transaction message then load it onto receiving parameter                   CAP043
      ** data structure                                                                       CAP043
                                                                                              CAP043
     C                   EXSR      SRRtvCIRS                                                  CAP043
                                                                                              CAP043
      ** Load work file records to respective arrays (ours/theirs)                            CAP043
                                                                                              CAP043
     C                   EXSR      SRLoadArr                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      * Incoming transaction is in a 500A field, so that a common CLP
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break that 500A by loading it into the
      * appropriate (externally described) data structure.
     C                   MOVEL     Trans500      TranIn
     C                   MOVEL     Extdata500    Extdata                        CAP004
     C                   MOVEL     InfData500    InfData                                      CAP056
                                                                                              CAP041
      * If CAP041 is installed, move Fees/Buy-Outs fields to one DS for                       CAP041
      * processing later.                                                                     CAP041
     C                   IF        CAP041 = 'Y'                                               CAP041
     C                   EVAL      ASOIPM  = SOIPM                                            CAP041
     C                   EVAL      ASONPCD = SONPCD                                           CAP041
     C                   EVAL      ASTIPM  = STIPM                                            CAP041
     C                   EVAL      ASTNPCD = STNPCD                                           CAP041
     C                   EVAL      ASUFVD  = SUFVD                                            CAP041
     C                   EVAL      ASUFEE  = SUFEE                                            CAP041
     C                   EVAL      ASUFPR  = SUFPR                                            CAP041
     C                   EVAL      ASBOVD  = SBOVD                                            CAP041
     C                   EVAL      ASBUYA  = SBUYA                                            CAP041
     C                   EVAL      ASBOPR  = SBOPR                                            CAP041
     C                   ENDIF                                                                CAP041

      * If Interest Rate Calendars are in use there will be four blocks         CAP004
      * of data, each containing up to 82 dates, which represent Our/Their      CAP004
      * Rate change and Interest Payment Dates. These must be loaded into       CAP004
      * appropriate (externally described) data structures.                     CAP004
     C     CIR001        IFEQ      'Y'                                          CAP004
     C                   MOVEL     TransB500     OurRatChgD                     CAP004
     C                   MOVEL     TransC500     OurIntPayD                     CAP004
     C                   MOVEL     TransD500     ThrRatChgD                     CAP004
     C                   MOVEL     TransE500     ThrIntPayD                     CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      ** Generate a timestamp for this transaction
     C                   RESET                   ReturnCode
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      * Some fields from the common header DS are renamed to prevent compile
      *  problems, as they are used on other Data Structures.
      * Data from these must be copied over to the fields used for output
      *  or parameters.

      * Reset variables gradually updated, once only at start
     C                   EXSR      RESETCYCLE

      /COPY WNCPYSRC,IRCIRSC002                                                 CAP004

      *  Check if valid deal exists for Front Office ID

     C                   EXSR      ChkValDeal
      *
      *  If valid deal does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
                                                                                CAP013
      *  Check if valid deal exists for Midas Deal Number                       CAP013
                                                                                CAP013
     C                   EXSR      ChkValMiDl                                   CAP013
      *                                                                         CAP013
      *  If valid deal does exist (even after delay), fail this input           CAP013
      *                                                                         CAP013
     C     Idx           IFNE      0                                            CAP013
     C                   GOTO      INVALID                                      CAP013
     C                   END                                                    CAP013
                                                                                CAP013
      * Reset variables again in case the details have been corrupted           CAP013
      * by previous chain to valid deals file.                                  CAP013
                                                                                CAP013
     C                   EXSR      RESETCYCLE                                   CAP013

      /COPY WNCPYSRC,IRCIRSC003                                                 CAP004
                                                                                CAP004
      *  Validate Action Code

     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,IRCIRSC004                                                 CAP004
                                                                                CAP004
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
     C                   EVAL      ValIter = '1ST'                                            CIR003

      *  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN      SACCD = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,IRCIRSC005                                                 CAP004
     C                   EXSR      DftSettmts
      /COPY WNCPYSRC,IRCIRSC006                                                 CAP004
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,IRCIRSC007                                                 CAP004
     C                   EXSR      ValidateSt
                                                                                              CIR003
     C     CIR003        IFEQ      'Y'                                                        CIR003
     C     SVDEI         IFEQ      'Y'                                                        CIR003
     C     SPDEI         OREQ      'Y'                                                        CIR003
     C     SMDEI         OREQ      'Y'                                                        CIR003
     C                   EXSR      ValidateEx                                                 CIR003
     C                   ENDIF                                                                CIR003
     C                   ENDIF                                                                CIR003
      /COPY WNCPYSRC,IRCIRSC008                                                 CAP004
      ** If IRCs on in system and no previous errors validate IRC dates         CAP004
     C     CIR001        IFEQ      'Y'                                          CAP004
     C     Idx           ANDEQ     0                                            CAP004
     C                   EXSR      ValidateIC                                   CAP004
     C                   IF        (CAP043 = 'Y') AND Idx = 0                                 CAP043
     C                   EXSR      ValidateIC2                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   END                                                    CAP004
      *                                                                                       CAP041
      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change            CAP041
      ** Date) is installed and no previous errors, then perform validation of fields.        CAP041
      *                                                                                       CAP041
     C                   IF        CAP041 = 'Y' and Idx = 0                                   CAP041
     C                   EXSR      ValidateFE                                                 CAP041
     C                   IF        (CAP043 = 'Y') AND Idx = 0                                 CAP043
     C                   EXSR      ValidateIC3                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP041

     C                   WHEN      SACCD = 'A'
      *  Processing for Amends
      /COPY WNCPYSRC,IRCIRSC009                                                 CAP004
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      TranIn                                 99    CAP011
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011
     C                   EXSR      SetupAmend
      /COPY WNCPYSRC,IRCIRSC010                                                 CAP004
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,IRCIRSC011                                                 CAP004
     C                   EXSR      ValidateSt
                                                                                              CIR003
     C     CIR003        IFEQ      'Y'                                                        CIR003
     C     SVDEI         IFEQ      'Y'                                                        CIR003
     C     SPDEI         OREQ      'Y'                                                        CIR003
     C     SMDEI         OREQ      'Y'                                                        CIR003
     C                   EXSR      ValidateEx                                                 CIR003
     C                   ENDIF                                                                CIR003
     C                   ENDIF                                                                CIR003
      /COPY WNCPYSRC,IRCIRSC012                                                 CAP004
      ** If IRCs on in system and no previous errors validate IRC dates         CAP004
     C     CIR001        IFEQ      'Y'                                          CAP004
     C     Idx           ANDEQ     0                                            CAP004
     C                   EXSR      ValidateIC                                   CAP004
     C                   IF        (CAP043 = 'Y') AND Idx = 0                                 CAP043
     C                   EXSR      ValidateIC2                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   END                                                    CAP004
      *                                                                                       CAP041
      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change            CAP041
      ** Date) is installed and no previous errors, then perform validation of fields.        CAP041
      *                                                                                       CAP041
     C                   IF        CAP041 = 'Y' and Idx = 0                                   CAP041
     C                   EXSR      ValidateFE                                                 CAP041
     C                   IF        (CAP043 = 'Y') AND Idx = 0                                 CAP043
     C                   EXSR      ValidateIC3                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   EXSR      ValdateAmd
      /COPY WNCPYSRC,IRCIRSC013                                                 CAP004

     C                   ENDSL

     C     INVALID       TAG
                                                                                167475
      *  Check for exception error from any program lower in the stack          167475
      *  If error detected, send message to system operator and                 167475
      *  return to calling program without updating database or                 167475
      *  prompting the database update program                                  167475
     C                   IN        APDUMP                                       167475
                                                                                167475
      /COPY WNCPYSRC,IRCIRSC014                                                 167475
                                                                                167475
     C     ARERRMOD      IFNE      *BLANK                                       167475
     C                   EVAL      MQErrlong  = *blank                          167475
     C                   MOVEL     ProcErr       MQError                        167475
     C                   MOVE      ARERRMOD      MQError          28            167475
     C                   MOVEL     MQError       MQErrlong                      167475
                                                                                167475
     C                   CALLB     'ZAMSGTOOPR'                                 167475
     C                   PARM                    MQReturn         10            167475
     C                   PARM                    MQErrlong       132            167475
     C                   PARM                    DummyMsgID                     167475
     C                   PARM                    DummyMsgF                      167475
                                                                                167475
     C                   MOVEL     ARERRMOD      APRETCODE                      167475
     C     *LOCK         IN        APDUMP                                       167475
     C                   EVAL      ARERRMOD = *BLANK                            167475
     C                   OUT       APDUMP                                       167475
     C                   RETURN                                                 167475
                                                                                167475
     C                   ELSE                                                   167475

      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,IRCIRSC015                                                 CAP004
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,IRCIRSC016                                                 CAP004

      *  If valid, send data queue entry to prompt DB update program
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      *  Check if update program active using Allocate Object API
      *  No prompting necessary if program is running
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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  167475

     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRCIRSC021

      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRRtvCIRS - Retrieve Cross Currency Transaction Details          *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRRtvCIRS     BEGSR                                                                CAP043
                                                                                              CAP043
     C     APFOAsocID    CHAIN     IRWCIRSL0                                                  CAP043
                                                                                              CAP043
     C                   IF        %FOUND(IRWCIRSL0)                                          CAP043
     C                   CLEAR                   Trans500                                     CAP043
     C                   CLEAR                   TransB500                                    CAP043
     C                   CLEAR                   TransC500                                    CAP043
     C                   CLEAR                   TransD500                                    CAP043
     C                   CLEAR                   TransE500                                    CAP043
     C                   MOVEL     WIRCIRS       Trans500                                     CAP043
     C                   MOVEL     WSCORAT       TransB500                                    CAP043
     C                   MOVEL     WSCOINT       TransC500                                    CAP043
     C                   MOVEL     WSCTRAT       TransD500                                    CAP043
     C                   MOVEL     WSCTINT       TransE500                                    CAP043
                                                                                              CAP043
      ** Override Front Office and Associated Front Office Id                                 CAP043
                                                                                              CAP043
     C                   EVAL      APFOTRANID =  WSFOTRANID                                   CAP043
     C                   EVAL      APFOASOCID =  WSFOASOCID                                   CAP043
     C                                                                                        CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRLoadArr - Load Work File Records to Array                      *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRLoadArr     BEGSR                                                                CAP043
                                                                                              CAP043
     C                   EVAL      OurRDTSC = *BLANK                                          CAP043
     C                   EVAL      OurIDTSC = *BLANK                                          CAP043
     C                   EVAL      ThrRDTSC = *BLANK                                          CAP043
     C                   EVAL      ThrIDTSC = *BLANK                                          CAP043
     C                   EVAL      OurCFSC = *BLANK                                           CAP043
     C                   EVAL      ThrCFSC = *BLANK                                           CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C                   EVAL      OurPCSC = *BLANK                                           CAP043
     C                   EVAL      ThrPCSC = *BLANK                                           CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Our Rate                                                                             CAP043
                                                                                              CAP043
     C                   EVAL      WOurTheir = 'U'                                            CAP043
     C                   EVAL      WRatePay = 'R'                                             CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C     KDTSCList     SETLL     IRWDTSCL0                                                  CAP043
     C     KDTSCList     READE     IRWDTSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRWDTSCL0)                                        CAP043
     C                   EVAL      OurRDTSC(X) = WIRDTSC                                      CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C     KDTSCList     READE     IRWDTSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Our Interest Payment                                                                 CAP043
                                                                                              CAP043
     C                   EVAL      WOurTheir = 'U'                                            CAP043
     C                   EVAL      WRatePay = 'P'                                             CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C     KDTSCList     SETLL     IRWDTSCL0                                                  CAP043
     C     KDTSCList     READE     IRWDTSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRWDTSCL0)                                        CAP043
     C                   EVAL      OurIDTSC(X) = WIRDTSC                                      CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C     KDTSCList     READE     IRWDTSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Their Rate                                                                           CAP043
                                                                                              CAP043
     C                   EVAL      WOurTheir = 'T'                                            CAP043
     C                   EVAL      WRatePay = 'R'                                             CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C     KDTSCList     SETLL     IRWDTSCL0                                                  CAP043
     C     KDTSCList     READE     IRWDTSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRWDTSCL0)                                        CAP043
     C                   EVAL      ThrRDTSC(X) = WIRDTSC                                      CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C     KDTSCList     READE     IRWDTSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Their Interest Payment                                                               CAP043
                                                                                              CAP043
     C                   EVAL      WOurTheir = 'T'                                            CAP043
     C                   EVAL      WRatePay = 'P'                                             CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C     KDTSCList     SETLL     IRWDTSCL0                                                  CAP043
     C     KDTSCList     READE     IRWDTSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRWDTSCL0)                                        CAP043
     C                   EVAL      ThrIDTSC(X) = WIRDTSC                                      CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C     KDTSCList     READE     IRWDTSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Our Cash Flow                                                                        CAP043
                                                                                              CAP043
     C                   EVAL      WOurTheir = 'U'                                            CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C     KCFPCList     SETLL     IRWCFSCL0                                                  CAP043
     C     KCFPCList     READE     IRWCFSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRWCFSCL0)                                        CAP043
     C                   EVAL      OurCFSC(X) = WCashFlw                                      CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C     KCFPCList     READE     IRWCFSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Their Cash Flow                                                                      CAP043
                                                                                              CAP043
     C                   EVAL      WOurTheir = 'T'                                            CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C     KCFPCList     SETLL     IRWCFSCL0                                                  CAP043
     C     KCFPCList     READE     IRWCFSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRWCFSCL0)                                        CAP043
     C                   EVAL      ThrCFSC(X) = WCashFlw                                      CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C     KCFPCList     READE     IRWCFSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Our Principal Change                                                                 CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C                   EVAL      WOurTheir = 'U'                                            CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C     KCFPCList     SETLL     IRWPCSCL0                                                  CAP043
     C     KCFPCList     READE     IRWPCSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRWPCSCL0)                                        CAP043
     C                   EVAL      OurPCSC(X) = WPrinChg                                      CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C     KCFPCList     READE     IRWPCSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Their Principal Change                                                               CAP043
                                                                                              CAP043
     C                   EVAL      WOurTheir = 'T'                                            CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C     KCFPCList     SETLL     IRWPCSCL0                                                  CAP043
     C     KCFPCList     READE     IRWPCSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRWPCSCL0)                                        CAP043
     C                   EVAL      ThrPCSC(X) = WPrinChg                                      CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C     KCFPCList     READE     IRWPCSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValDeal - Routine to check if valid IRS  exists for        *
      *    Front Office ID                                            *
      *                                                               *
      *****************************************************************

     C     ChkValDeal    BEGSR

      * Check for FRA on Valid file
     C     APFOTranID    CHAIN     IRVCIRSL0                          99

      * If record found...
     C     *IN99         IFEQ      '0'

      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'

     C     APFOTranID    CHAIN     IRVCIRSL0                          99

      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF

     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP013
      *****************************************************************         CAP013
      *                                                               *         CAP013
      * ChkValMiDl - Routine to check if valid deal exists for        *         CAP013
      *    Midas Deal Number                                          *         CAP013
      *                                                               *         CAP013
      *****************************************************************         CAP013
                                                                                CAP013
     C     ChkValMiDl    BEGSR                                                  CAP013
                                                                                CAP013
      * If (numeric) Midas deal number supplied                                 CAP013
                                                                                CAP013
     C                   TESTN                   SDLNO                9898      CAP013
                                                                                CAP013
     C     SDLNO         IFNE      *BLANKS                                      CAP013
     C     *IN98         ANDEQ     '1'                                          CAP013
                                                                                CAP013
      * Check for deal on Valid file                                            CAP013
     C                   MOVEL     SDLNO         RXDLNO                         CAP013
     C     RXDLNO        CHAIN     IRVCIRSL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     RXDLNO        CHAIN     IRVCIRSL1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'SDLNO'                    CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   ENDSR                                                  CAP013
      *****************************************************************         CAP013
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************

     C     ValidateAc    BEGSR
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     SACCD         IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     SDLNO         IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013

      * Validate action code versus transaction IDs supplied
      * This function will set the Midas deal number
      * The deal in file format from the database is retrieved as well.

     C                   RESET                   ReturnCode
     C                   CALLB     'IRCIRSRTV'

      * INPUTS

      * Return code
     C                   PARM                    ReturnCode

      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP013
     C*******************PARM      '*FRONT'      ModeofOp          6            CAP013
     C                   PARM                    ModeofOp          6            CAP013
      *
      * Response mode
     C                   PARM                    APRESPMODE

      * Action Code
     C                   PARM                    SACCD

      * Front Office Transaction ID
     C                   PARM                    APFOTranID

      * Front Office Associated Transaction Id
     C                   PARM                    APFOAsocID

      * (Midas) Deal Number
     C                   PARM                    SDLNO

      * (Midas) Associated Deal Number
     C                   PARM                    SLNKDN

      * Booking branch
     C                   PARM                    SBRCA
                                                                                              CIR008
      ** Switchable feature CIR008                                                            CIR008
                                                                                              CIR008
     C                   PARM                    CIR008                                       CIR008

      * OUTPUTS

      * (Current) deal in file format
     C                   PARM                    DealFilFmt
                                                                                              CLE025
      ** (Current) deal extension in file format                                              CLE025
     C                   PARM                    DealXFilFmt                                  CLE025

      * OK - Action code
     C                   PARM                    SAccdOK

      * OK - Deal Number
     C                   PARM                    SDlNoOK

      * OK - Booking branch
     C                   PARM                    SBrcaOK

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    CIR003                                       CIR003
     C                   PARM                    ExtSetV                                      CIR003
     C                   PARM                    ExtSetI                                      CIR003
     C                   PARM                    ExtSetM                                      CIR003
                                                                                              CAS005
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS005
                                                                                              CAS005
     C                   PARM                    WFldNamArr                                   CAS005
     C                   PARM                    WMsgIdArr                                    CAS005
     C                   PARM                    WMsgDtaArr                                   CAS005
                                                                                              CAS005
      ** Array index (3P0) from/to caller                                                     CAS005
                                                                                              CAS005
     C                   PARM                    WIdx                                         CAS005

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

     C                   IF            (InRecSttmt = *blank)
     C                             AND (InPaySttmt = *blank)

     C                   CALLB     'ZASETINDFT'
      *
      ** Output
      ** Calling function type
     C                   PARM                    CIRS
      ** Payment currency (or deal cuurency if only one currency on deal)
     C                   PARM                    SuCucy
      ** Receive currency (only if deal has two currencies)
     C                   PARM                    StCucy
      ** Customer (shortname or number)
     C                   PARM                    SCNum
      ** Deal type
     C                   PARM                    SDTyp
      ** Federal Funds Ind.
     C                   PARM                    SuFFI
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
                                                                                CSW097
      ** Version of ISDA Agreement century                                      CSW097
     C                   PARM                    BQAGVC            2            CSW097
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt

      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.

     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt

      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      STCUCY        InRCCY                                      CSF011A
     C                   PARM      SUCUCY        InPCCY                                      CSF011A

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMEND - Set up fields that are needed in the validation  *
      *    of Amendments.                                             *
      *                                                               *
      *****************************************************************

     C     SetupAmend    BEGSR

      * For Amends, put the complete (pre-existing) IRS into the Valid
      *  file record - fields in this will be updated during  processing
     C                   MOVEL     DealFilFmt    ValidDeal
     C                   MOVEL     URACC         RXURACC                                      CGL029
     C                   MOVEL     UPACC         RXUPACC                                      CGL029
     C                   MOVEL     RONS          RXRONS                                       CGL029
     C                   MOVEL     PONS          RXPONS                                       CGL029

      **The*Settlement*Instructions*fields*are*unlikely*to*be*supplied*****     CAP011
      ***for*an*amendment.*For*each*of*Pay/Receive,*if*it*hasn't*been******     CAP011
      ***supplied*(i.e.*it*is*blank)*default*in*the*existing*database******     CAP011
      ***values*into*the*special*DB*Settlement*Instructions*DSs*....*******     CAP011
      *****************************                                             CAP011
     C*******************IF********InRecSttmt = *Blank                          CAP011
     C*******************EVAL******DBRecSttmt = CIRSRecIns + RXROBR             CAP011
     C*******************EVAL******FLRSCY     = RXRSCY                          CAP011
     C*******************ENDIF*****                                             CAP011
      *****************************                                             CAP011
     C*******************IF********InPaySttmt = *Blank                          CAP011
     C*******************EVAL******DBPaySttmt = CIRSPayIns + RXPOBR + RXCVMR    CAP011
     C*******************EVAL******FLPSCY     = RXPSCY                          CAP011
     C*******************EVAL******FLIC72     = RXIC72                          CAP011
     C*******************ENDIF*****                                             CAP011
      *****************************                                             CAP011
     C*******************IF********InFRASttmt = *Blank                          CAP011
     C*******************EVAL******DBFraSttmt = CIRSFraIns                      CAP011
     C*******************EVAL******FLRSCY     = RXRSCY                          CAP011
     C*******************ENDIF*****                                             CAP011
                                                                                CAP011
     C**********         EVAL      DBRecSttmt = CIRSRecIns + RXROBR                    CAP011 CGL029
     C                   EVAL      %SUBST(DBRecSttmt:1:2)=%SUBST(CIRSRecIns:1:2)              CGL029
     C                   EVAL      %SUBST(DBRecSttmt:3:18)=RXRONS                             CGL029
     C                   EVAL      %SUBST(DBRecSttmt:21:55)=                                  CGL029
     C                             %SUBST(CIRSRecIns:15:55)                                   CGL029
     C                   EVAL      FLROBR     = RXROBR                                        CGL029
     C                   EVAL      FLRSCY     = RXRSCY                          CAP011
     C**********         EVAL      DBPaySttmt = CIRSPayIns + RXPOBR + RXCVMR           CAP011 CGL029
     C                   EVAL      %SUBST(DBPaySttmt:1:2)=%SUBST(CIRSPayIns:1:2)              CGL029
     C                   EVAL      %SUBST(DBPaySttmt:3:18)=RXPONS                             CGL029
     C                   EVAL      %SUBST(DBPaySttmt:21:545)=                                 CGL029
     C                             %SUBST(CIRSPayIns:15:545)                                  CGL029
     C                   EVAL      FLPOBR     = RXPOBR                                        CGL029
     C                   EVAL      FLCVMR     = RXCVMR                                        CGL029
     C                   EVAL      FLPSCY     = RXPSCY                          CAP011
     C                   EVAL      FLIC72     = RXIC72                          CAP011
     C                   EVAL      DBFraSttmt = CIRSFraIns                      CAP011
     C                   MOVE      RXAGVC        FLAGVC                         CSW097

      *  .... and then convert these to the screen format
     C                   CALLB     'ZASETINCVT'

      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
                                                                                CAP011
      ** Current Settlement Instruction in input format                         CAP011
     C                   PARM                    CrPaySttmt                     CAP011
     C                   PARM                    CrRecSttmt                     CAP011
     C                   PARM                    CrFRASttmt                     CAP011
     C                   PARM      @STCUCY       InRCCY                                      CSF011A
     C                   PARM      @SUCUCY       InPCCY                                      CSF011A

      *  If no Payment or Receive instructions have been supplied               CAP011
      *  Default them to those currently on the deal.                           CAP011
                                                                                CAP011
     C                   IF            (InPaySttmt = *blank)                    CAP011
     C                   EVAL      InPaySttmt = CrPaySttmt                      CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   IF            (InRecSttmt = *blank)                    CAP011
     C                   EVAL      InRecSttmt = CrRecSttmt                      CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   IF            (InFRASttmt = *blank)                    CAP011
     C                   EVAL      InFRASttmt = CrFRASttmt                      CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
      * Do data substitution for Settlement Instructions                        CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      InPaySttmt                             99    CAP011
     C  N99GHSUBS        scan      InRecSttmt                             99    CAP011
     C  N99GHSUBS        scan      InFRASttmt                             99    CAP011
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      SDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011

      ***Defaulted*Settlement*Instruction*in*input*format**                     CAP011
     C*******************PARM********************InPaySttmt                     CAP011
     C*******************PARM********************InRecSttmt                     CAP011
     C*******************PARM********************InFRASttmt                     CAP011
     C                   IF        CIR003 = 'Y'                                               CIR003
     C                   CLEAR                   DBFRAStmtE                                   CIR003
     C                   IF        SVDEI = 'Y'                                                CIR003
     C                             OR   SPDEI = 'Y'                                           CIR003
     C                   EVAL      DBRecStmtE = ExRValDat                                     CIR003
     C                   EVAL      DBPayStmtE = ExPValDat                                     CIR003
     C                   EXSR      SrAmdCvt                                                   CIR003
                                                                                              CIR003
     C                   IF        InPayStmtV = *blanks                                       CIR003
     C                   EVAL      InPayStmtV = CrPayStmtE                                    CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
     C                   IF        InRecStmtV = *blanks                                       CIR003
     C                   EVAL      InRecStmtV = CrRecStmtE                                    CIR003
     C                   ENDIF                                                                CIR003
     C                   EVAL      InPayStmtE = InPayStmtV                                    CIR003
     C                   EVAL      InRecStmtE = InRecStmtV                                    CIR003
                                                                                              CIR003
      * Do data substitution for Settlement Instructions                                      CIR003
                                                                                              CIR003
     C                   IF        GHSUBS <> *blanks                                          CIR003
     C     GHSUBS        SCAN      InPayStmtV                             99                  CIR003
     C                   IF        *IN99 = '0'                                                CIR003
     C     GHSUBS        SCAN      InRecStmtV                             99                  CIR003
     C                   ENDIF                                                                CIR003
     C                   IF        *IN99 = '1'                                                CIR003
     C                   EXSR      SExDtaSubs                                                 CIR003
     C                   ENDIF                                                                CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
     C                   IF        SMDEI = 'Y'                                                CIR003
     C                             OR   SPDEI = 'Y'                                           CIR003
     C                   EVAL      DBRecStmtE = ExRMatDat                                     CIR003
     C                   EVAL      DBPayStmtE = ExPMatDat                                     CIR003
     C                   EXSR      SrAmdCvt                                                   CIR003
                                                                                              CIR003
     C                   IF        InPayStmtM = *blanks                                       CIR003
     C                   EVAL      InPayStmtM = CrPayStmtE                                    CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
     C                   IF        InRecStmtM = *blanks                                       CIR003
     C                   EVAL      InRecStmtM = CrRecStmtE                                    CIR003
     C                   ENDIF                                                                CIR003
     C                   EVAL      InPayStmtE = InPayStmtM                                    CIR003
     C                   EVAL      InRecStmtE = InRecStmtM                                    CIR003
                                                                                              CIR003
      * Do data substitution for Settlement Instructions                                      CIR003
                                                                                              CIR003
     C                   IF        GHSUBS <> *blanks                                          CIR003
     C     GHSUBS        SCAN      InPayStmtM                             99                  CIR003
     C                   IF        *IN99 = '0'                                                CIR003
     C     GHSUBS        SCAN      InRecStmtM                             99                  CIR003
     C                   ENDIF                                                                CIR003
     C                   IF        *IN99 = '1'                                                CIR003
     C                   EXSR      SExDtaSubs                                                 CIR003
     C                   ENDIF                                                                CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
     C                   ENDIF                                                                CIR003
     C                   ENDIF                                                                CIR003

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main transaction details *
      *                                                               *
      *****************************************************************

     C     ValidateTr    BEGSR

      * Set up the settlemnt information needed for holidays validation:
      * - default fields for Inserts
      * - existing d/b fields for Amends

     C                   IF        SACCD = 'I'
      * This block assumes that Settlement Instructions are never received
     C                   EVAL      RecSetMeth = RXRSTM
     C                   EVAL      RecNostro  = RXRONS
     C                   EVAL      PaySetMeth = RXPSTM
     C                   EVAL      PayNostro  = RXPONS
     C                   ENDIF

     C                   IF        SACCD = 'A'
     C                   EVAL      RecSetMeth = RXRSTM
     C                   EVAL      RecNostro  = RXRONS
     C                   EVAL      PaySetMeth = RXPSTM
     C                   EVAL      PayNostro  = RXPONS
     C                   ENDIF
      *                                                                         CIR005
      ** Business Day Convention enhancement is installed, allow valida         CIR005
      ** tion of dates through currency conventions, otherwise valida -         CIR005
      ** tion against BDC not needed.                                           CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   EVAL      WValBDC = 'Y'                                CIR005
     C                   ENDIF                                                  CIR005

     C                   CALLB     'IRCIRSVAL'
     C                   PARM      '*FRONT'      ModeOfOp                       CIR005
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
      * Receive Settlement Method & Nostro and  Pay Settlement Method &
      *  Nostro, from default (Action = I) or valid deal (Action = A)
      * Extra Data                                                              CAP004
     C                   PARM      *BLANKS       RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM      *BLANKS       PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    ExtData                        CAP004
      * Business Day Validation                                                 CIR005
     C                   PARM                    WValBDC                        CIR005
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
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
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
      ** Valid Deal Extension file                                                            CLE025
     C                   PARM                    ValidXDeal                                   CLE025
      *                                                                                       187606
     C                   PARM                    SACCD                                        187606
     C                   PARM                    USLIP                                        184560
     C                   PARM                    TSLIP                                        184560
      *                                                                                       185057
      * Current Deal in Screen Format                                                         185057
     C                   PARM                    DealScnfmt                                   185057

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************

     C     ValidateSt    BEGSR

      * The called module requires that the customer number/name is valid,
      *  if it is not, exit from this subroutine.
     C                   IF        NOT (SCNumOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF

      **The*called*module*uses*the*value date in Midas Day Number format,       162497
      ***which*will*not*have*been*returned from the overall validation          162497
      ***routine,*so it*needs*to*be*converetd here.                             162497
      *******************                                                       162497
     C*******************IF        SVDatOK = 'Y'                                162497
      *******************                                                       162497
     C*******************CALLB     'ZDATE1'                                     162497
     C*******************PARM                    SVDAT                          162497
     C*******************PARM                    ValDateMDN                     162497
     C*******************PARM                    BJDFIN                         162497
     C*******************PARM                    ErrorFlag                      162497
      *******************                                                       162497
      **For*IRSs*set*both*Pay*and*Receive*Dates*to*Value*Date*                  162497
     C*******************EVAL      PayDat = ValDateMDN                          162497
     C*******************EVAL      RecDat = ValDateMDN                          162497
      *******************                                                       162497
     C*******************ENDIF                                                  162497
      *                                                                         162497
      * Set pay and receive dates to run date                                   162497
     C                   EVAL      PayDat = BJRDNB                              162497
     C                   EVAL      RecDat = BJRDNB                              162497

     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'

      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    CIRS
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM                    SUCUCY
      ** Receive currency (only if deal has two currencies)
     C                   PARM                    STCUCY
      ** Customer (shortname or number)
     C                   PARM                    SCNUM
      ** Deal type
     C                   PARM                    SDTYP
      ** Federal Funds Ind.
     C                   PARM                    SUFFI
      ** Booking Branch
     C                   PARM                    SBRCA
      ** Receipt Date (Value Date for IRS)
     C                   PARM                    RecDat
      ** Payment Date (Value Date for IRS)
     C                   PARM                    Paydat
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
      * Action Code                                                                           199787
     C                   PARM                    SACCD                                        199787
      * Protect Payment Field                                                                 196461
     C                   PARM                    ##PPAY            1                          196461
      * Protect Receipt Field                                                                 196461
     C                   PARM                    ##PREC            1                          196461

      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKCIRSInDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE008
     C                   PARM                    WFldNamArr                                   CRE008
     C                   PARM                    WMsgIDArr                                    CRE008
     C                   PARM                    WMsgDtaArr                                   CRE008
      ** Array index (3P0) from/to caller                                                     CRE008
     C                   PARM                    WIdx                                         CRE008
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Extra Input                                                                          166888
      ** Action Code used                                                                     166888
     C                   PARM      SACCD         ##ACTN            1                          166888
      ** Validation Iteration                                                                 166888
     C                   PARM      '1ST'         ##ValIter         3                          166888
      ************                                                                     179510 200400
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI           24                   179510 200400
      ************                                                                     179510 200400

     C     ValSetExit    TAG

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'IRCIRSCVT'                                  CAP011
                                                                                CAP011
      * INPUTS                                                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * (Current) Deal in file format                                           CAP011
     C                   PARM                    DealFilfmt                     CAP011
                                                                                              CLE025
      ** Deal Extension in file format                                                        CLE025
     C                   PARM                    DealXFilfmt                                  CLE025
                                                                                              CLE025
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008
                                                                                CAP011
      * OUTPUTS                                                                 CAP011
      * (Current) Deal in screen format                                         CAP011
     C                   PARM                    DealScnfmt                     CAP011
      * Deal Status                                                             CAP011
     C                   PARM                    DDSTS                          CAP011
                                                                                CAP011
      ** DATA SUBSTITUTION                                                      CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TranIn        IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      DealScnfmt    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranIn                         CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * SDtDtaSubs - Settlement Details Data Substitution             *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     SDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** PAYMENT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      InPaySttmt    IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrPaySttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       InPaySttmt                     CAP011
                                                                                CAP011
      ** RECEIPT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      InRecSttmt    IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrRecSttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       InRecSttmt                     CAP011
                                                                                CAP011
      ** FRA/IRS INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      InFRASttmt    IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrFRASttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       InFRASttmt                     CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT
      *****************************************************************         CAP004
      *                                                               *         CAP004
      * ValidateIC - Routine to validate Interest Rate Calendars      *         CAP004
      *                                                               *         CAP004
      *****************************************************************         CAP004
                                                                                CAP004
     C     ValidateIC    BEGSR                                                  CAP004
      *                                                                         CAP004
      ** Validate Our Rate Change Dates                                         CAP004
      *                                                                         CAP004
      ** Invalid if Our Rate Change Frequency indicator not 'Z'                 CAP004
      *                                                                         CAP004
     C     ORDatesAlp    IFNE      *BLANKS                                      CAP004
     C     ORDatesAlp    ANDNE     *ZEROS                                                     188418
     C     RXUICFR       ANDNE     'Z'                                          CAP004
     C                   MOVE      'N'           OKInRatCal                     CAP004
     C                   ADD       1             Idx                            CAP004
     C                   EVAL      FldNameArr(Idx) = 'SUICFR'                   CAP004
     C**********         EVAL      MsgIDArr(Idx) = 'MMA0678'                           CAP004 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CAP043
     C                   ELSE                                                   CAP004
      *                                                                         CAP004
     C     RXUICFR       IFEQ      'Z'                                                        188418
     C                   CALLB     'IRVIRCVAL'                                  CAP004
      ** Following parameters are output to called module                       CAP004
      ** Return Code                                                            CAP004
     C                   PARM                    ReturnCode                     CAP004
      ** Valid Value date in 5,0 format                                         CAP004
     C                   PARM                    RXVDAT                         CAP004
      ** Valid Maturity date in 5,0 format                                      CAP004
     C                   PARM                    RXMDAT                         CAP004
     C                   PARM      *ZERO         PCtlDate                                     CAP043
      ** Date format indicator                                                  CAP004
     C                   PARM                    BJDFIN                         CAP004
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM      *ZEROS        PPrevDate                                    CAP043
     C                   PARM      'R'           PValType                                     CAP043
     C                   PARM      'U'           POurTheir                                    CAP043
     C                   PARM      SUCUCY        PCurrency                                    CAP043
      ** Our Rate Change dates (82 x 6A)                                        CAP004
     C                   PARM      ORDatesAlp    DatesToVal                     CAP004
     C                   PARM      *BLANK        PAmtToVal1                                   CAP043
     C                   PARM      *BLANK        PAmtToVal2                                   CAP043
     C                   PARM      *BLANK        PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg1      PBDConvtn                                    CAP043
      *                                                                         CAP004
      ** Following parameters are returned by called module                     CAP004
      ** IRC Dates OK flag                                                      CAP004
     C                   PARM                    OKInRatCal                     CAP004
      * Error fields/message IDs (arrays) from/to caller                        CAP004
     C                   PARM                    FldNameArr                     CAP004
     C                   PARM                    MsgIDArr                       CAP004
      * Array index (3P0) from/to caller                                        CAP004
     C                   PARM                    Idx                            CAP004
      ** Our Rate Change dates in day number format (82 x 3A)                   CAP004
     C                   PARM                    ValidDates                     CAP004
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKInRatCal    IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit                                                 CAP043
     C                   ELSE                                                                 CAP043
     C                   MOVE      ValidDates    ORDates                                      CAP043
     C                   MOVE      PConfHol      ORConfH                                      CAP043
     C                   EVAL      WORPrvDate = PPrevDate                                     CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                188418
      *                                                                         CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
     C*****OKInRatCal    IFNE      'Y'                                                 CAP004 CAP043
     C**********         GOTO      ValIRCExit                                          CAP004 CAP043
     C**********         ELSE                                                          CAP004 CAP043
     C**********         MOVE      ValidDates    ORDates                               CAP004 CAP043
     C**********         END                                                           CAP004 CAP043
      *                                                                         CAP004
      *                                                                         CAP004
      ** Validate Our Interest Payment Dates                                    CAP004
      *                                                                         CAP004
      ** Invalid if Our Interest Payment Frequency indicator not 'Z'            CAP004
      *                                                                         CAP004
     C     OPDatesAlp    IFNE      *BLANKS                                      CAP004
     C     OPDatesAlp    ANDNE     *ZEROS                                                     188418
     C     RXUIPFR       ANDNE     'Z'                                          CAP004
     C                   MOVE      'N'           OKInRatCal                     CAP004
     C                   ADD       1             Idx                            CAP004
     C                   EVAL      FldNameArr(Idx) = 'SUIPFR'                   CAP004
     C**********         EVAL      MsgIDArr(Idx) = 'MMA0678'                           CAP004 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CAP043
     C                   ELSE                                                   CAP004
      *                                                                         CAP004
     C     RXUIPFR       IFEQ      'Z'                                                        188418
     C                   CALLB     'IRVIRCVAL'                                  CAP004
      ** Following parameters are output to called module                       CAP004
      ** Return Code                                                            CAP004
     C                   PARM                    ReturnCode                     CAP004
      ** Valid Value date in 5,0 format                                         CAP004
     C                   PARM                    RXVDAT                         CAP004
      ** Valid Maturity date in 5,0 format                                      CAP004
     C                   PARM                    RXMDAT                         CAP004
     C                   PARM      *ZERO         PCtlDate                                     CAP043
      ** Date format indicator                                                  CAP004
     C                   PARM                    BJDFIN                         CAP004
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM      *ZEROS        PPrevDate                                    CAP043
     C                   PARM      'I'           PValType                                     CAP043
     C                   PARM      'U'           POurTheir                                    CAP043
     C                   PARM      SUCUCY        PCurrency                                    CAP043
      ** Our Interest Payment dates                                             CAP004
     C                   PARM      OPDatesAlp    DatesToVal                     CAP004
     C                   PARM      *BLANK        PAmtToVal1                                   CAP043
     C                   PARM      *BLANK        PAmtToVal2                                   CAP043
     C                   PARM      *BLANK        PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg1      PBDConvtn                                    CAP043
      *                                                                         CAP004
      ** Following parameters are returned by called module                     CAP004
      ** IRC Dates OK flag                                                      CAP004
     C                   PARM                    OKInRatCal                     CAP004
      * Error fields/message IDs (arrays) from/to caller                        CAP004
     C                   PARM                    FldNameArr                     CAP004
     C                   PARM                    MsgIDArr                       CAP004
      * Array index (3P0) from/to caller                                        CAP004
     C                   PARM                    Idx                            CAP004
      ** Our Interest Payment dates in day number format (82 x 3A)              CAP004
     C                   PARM                    ValidDates                     CAP004
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKInRatCal    IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit                                                 CAP043
     C                   ELSE                                                                 CAP043
     C                   MOVE      ValidDates    OPDates                                      CAP043
     C                   MOVE      PConfHol      OPConfH                                      CAP043
     C                   EVAL      WOPPrvDate = PPrevDate                                     CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                188418
      *                                                                         CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
     C*****OKInRatCal    IFNE      'Y'                                                 CAP004 CAP043
     C**********         GOTO      ValIRCExit                                          CAP004 CAP043
     C**********         ELSE                                                          CAP004 CAP043
     C**********         MOVE      ValidDates    OPDates                               CAP004 CAP043
     C**********         END                                                           CAP004 CAP043
      *                                                                         CAP004
      *                                                                         CAP004
      ** Validate Their Rate Change Dates                                       CAP004
      *                                                                         CAP004
      ** Invalid if Their Rate Change Frequency indicator not 'Z'               CAP004
      *                                                                         CAP004
     C     TRDatesAlp    IFNE      *BLANKS                                      CAP004
     C     TRDatesAlp    ANDNE     *ZEROS                                                     188418
     C     RXTICFR       ANDNE     'Z'                                          CAP004
     C                   MOVE      'N'           OKInRatCal                     CAP004
     C                   ADD       1             Idx                            CAP004
     C                   EVAL      FldNameArr(Idx) = 'STICFR'                   CAP004
     C**********         EVAL      MsgIDArr(Idx) = 'MMA0678'                           CAP004 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CAP043
     C                   ELSE                                                   CAP004
      *                                                                         CAP004
     C     RXTICFR       IFEQ      'Z'                                                        188418
     C                   CALLB     'IRVIRCVAL'                                  CAP004
      ** Following parameters are output to called module                       CAP004
      ** Return Code                                                            CAP004
     C                   PARM                    ReturnCode                     CAP004
      ** Valid Value date in 5,0 format                                         CAP004
     C                   PARM                    RXVDAT                         CAP004
      ** Valid Maturity date in 5,0 format                                      CAP004
     C                   PARM                    RXMDAT                         CAP004
     C                   PARM      *ZERO         PCtlDate                                     CAP043
      ** Date format indicator                                                  CAP004
     C                   PARM                    BJDFIN                         CAP004
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM      *ZEROS        PPrevDate                                    CAP043
     C                   PARM      'R'           PValType                                     CAP043
     C                   PARM      'T'           POurTheir                                    CAP043
     C                   PARM      STCUCY        PCurrency                                    CAP043
      ** Their Rate Change dates                                                CAP004
     C                   PARM      TRDatesAlp    DatesToVal                     CAP004
     C                   PARM      *BLANK        PAmtToVal1                                   CAP043
     C                   PARM      *BLANK        PAmtToVal2                                   CAP043
     C                   PARM      *BLANK        PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg2      PBDConvtn                                    CAP043
      *                                                                         CAP004
      ** Following parameters are returned by called module                     CAP004
      ** IRC Dates OK flag                                                      CAP004
     C                   PARM                    OKInRatCal                     CAP004
      * Error fields/message IDs (arrays) from/to caller                        CAP004
     C                   PARM                    FldNameArr                     CAP004
     C                   PARM                    MsgIDArr                       CAP004
      * Array index (3P0) from/to caller                                        CAP004
     C                   PARM                    Idx                            CAP004
      ** Their Rate Change dates in day number format (82 x 3A)                 CAP004
     C                   PARM                    ValidDates                     CAP004
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKInRatCal    IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit                                                 CAP043
     C                   ELSE                                                                 CAP043
     C                   MOVE      ValidDates    TRDates                                      CAP043
     C                   MOVE      PConfHol      TRConfH                                      CAP043
     C                   EVAL      WTRPrvDate = PPrevDate                                     CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                188418
      *                                                                         CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
     C*****OKInRatCal    IFNE      'Y'                                                 CAP004 CAP043
     C**********         GOTO      ValIRCExit                                          CAP004 CAP043
     C**********         ELSE                                                          CAP004 CAP043
     C**********         MOVE      ValidDates    TRDates                               CAP004 CAP043
     C**********         END                                                           CAP004 CAP043
      *                                                                         CAP004
      *                                                                         CAP004
      ** Validate Their Interest Payment Dates                                  CAP004
      *                                                                         CAP004
     C     TPDatesAlp    IFNE      *BLANKS                                      CAP004
     C     TPDatesAlp    ANDNE     *ZEROS                                                     188418
     C     RXTIPFR       ANDNE     'Z'                                          CAP004
     C                   MOVE      'N'           OKInRatCal                     CAP004
     C                   ADD       1             Idx                            CAP004
     C                   EVAL      FldNameArr(Idx) = 'STIPFR'                   CAP004
     C**********         EVAL      MsgIDArr(Idx) = 'MMA0678'                           CAP004 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CAP043
     C                   ELSE                                                   CAP004
      *                                                                         CAP004
     C     RXTIPFR       IFEQ      'Z'                                                        188418
     C                   CALLB     'IRVIRCVAL'                                  CAP004
      ** Following parameters are output to called module                       CAP004
      ** Return Code                                                            CAP004
     C                   PARM                    ReturnCode                     CAP004
      ** Valid Value date in 5,0 format                                         CAP004
     C                   PARM                    RXVDAT                         CAP004
      ** Valid Maturity date in 5,0 format                                      CAP004
     C                   PARM                    RXMDAT                         CAP004
     C                   PARM      *ZERO         PCtlDate                                     CAP043
      ** Date format indicator                                                  CAP004
     C                   PARM                    BJDFIN                         CAP004
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM      *ZEROS        PPrevDate                                    CAP043
     C                   PARM      'I'           PValType                                     CAP043
     C                   PARM      'T'           POurTheir                                    CAP043
     C                   PARM      STCUCY        PCurrency                                    CAP043
      ** Their Interest Payment dates                                           CAP004
     C                   PARM      TPDatesAlp    DatesToVal                     CAP004
     C                   PARM      *BLANK        PAmtToVal1                                   CAP043
     C                   PARM      *BLANK        PAmtToVal2                                   CAP043
     C                   PARM      *BLANK        PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg2      PBDConvtn                                    CAP043
      *                                                                         CAP004
      ** Following parameters are returned by called module                     CAP004
      ** IRC Dates OK flag                                                      CAP004
     C                   PARM                    OKInRatCal                     CAP004
      * Error fields/message IDs (arrays) from/to caller                        CAP004
     C                   PARM                    FldNameArr                     CAP004
     C                   PARM                    MsgIDArr                       CAP004
      * Array index (3P0) from/to caller                                        CAP004
     C                   PARM                    Idx                            CAP004
      ** Their Interest Payment dates in day number format (82 x 3A)            CAP004
     C                   PARM                    ValidDates                     CAP004
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKInRatCal    IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit                                                 CAP043
     C                   ELSE                                                                 CAP043
     C                   MOVE      ValidDates    TPDates                                      CAP043
     C                   MOVE      PConfHol      TPConfH                                      CAP043
     C                   EVAL      WTPPrvDate = PPrevDate                                     CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                188418
      *                                                                         CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
     C*****OKInRatCal    IFNE      'Y'                                                 CAP004 CAP043
     C**********         GOTO      ValIRCExit                                          CAP004 CAP043
     C**********         ELSE                                                          CAP004 CAP043
     C**********         MOVE      ValidDates    TPDates                               CAP004 CAP043
     C**********         END                                                           CAP004 CAP043
      *                                                                         CAP004
                                                                                CAP004
     C     ValIRCExit    TAG                                                    CAP004
                                                                                CAP004
     C                   ENDSR                                                  CAP004
                                                                                              CAP043
      *****************************************************************                       CAP043
      /EJECT                                                                                  CAP043
      *****************************************************************                       CAP043
      *                                                               *                       CAP043
      * ValidateIC2 - Routine to validate Interest Rate Calendars     *                       CAP043
      *               and Cash Flows                                  *                       CAP043
      *                                                               *                       CAP043
      *****************************************************************                       CAP043
                                                                                              CAP043
     C     ValidateIC2   BEGSR                                                                CAP043
                                                                                              CAP043
      ** Retrieve our/rates IRC records                                                       CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
     C                   EVAL      PPrevDate = WORPrvDate                                     CAP043
                                                                                              CAP043
      ** Validate Our Rate Change Dates                                                       CAP043
                                                                                              CAP043
     C                   DOW       OurRDTSC(X) <> *BLANK                                      CAP043
     C                   CLEAR                   OurRatChgD2                                  CAP043
     C                   MOVEA     OurRDTSC(X)   OurRatChgD2                                  CAP043
                                                                                              CAP043
      ** Invalid if Our Rate Change Frequency indicator not 'Z'                               CAP043
                                                                                              CAP043
     C     ORDatesAlp2   IFNE      *BLANKS                                                    CAP043
     C     ORDatesAlp2   ANDNE     *ZEROS                                                     CAP043
     C     RXUICFR       ANDNE     'Z'                                                        CAP043
     C                   MOVE      'N'           OKInRatCal                                   CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SUICFR'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CAP043
     C                   ELSE                                                                 CAP043
                                                                                              CAP043
     C     RXUICFR       IFEQ      'Z'                                                        CAP043
     C                   CALLB     'IRVIRCVAL'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    RXVDAT                                       CAP043
     C                   PARM                    RXMDAT                                       CAP043
     C                   PARM      *ZERO         PCtlDate                                     CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM      'R'           PValType                                     CAP043
     C                   PARM      'U'           POurTheir                                    CAP043
     C                   PARM      SUCUCY        PCurrency                                    CAP043
     C                   PARM      ORDatesAlp2   DatesToVal                                   CAP043
     C                   PARM      *BLANK        PAmtToVal1                                   CAP043
     C                   PARM      *BLANK        PAmtToVal2                                   CAP043
     C                   PARM      *BLANK        PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg1      PBDConvtn                                    CAP043
     C                   PARM                    OKInRatCal                                   CAP043
     C                   PARM                    FldNameArr                                   CAP043
     C                   PARM                    MsgIDArr                                     CAP043
     C                   PARM                    Idx                                          CAP043
     C                   PARM      *BLANK        ValidDates                                   CAP043
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKInRatCal    IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit2                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      DXFOTRANID = APFOTRANID                                    CAP043
     C                   EVAL      DXRATPAY = 'R'                                             CAP043
     C                   EVAL      DXOURTHR = 'U'                                             CAP043
     C                   EVAL      DXTMESTMP = TimeStamp                                      CAP043
     C                   MOVEL     ValidDates    WIntRtC                                      CAP043
     C                   MOVEL     PConfHol      WDTSCConfH                                   CAP043
     C                   WRITE     IRTDTSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Read next DTSC record                                                                CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Retrieve our/payment IRC records                                                     CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
     C                   EVAL      PPrevDate = WOPPrvDate                                     CAP043
                                                                                              CAP043
      ** Validate Our Interest Payment Dates                                                  CAP043
                                                                                              CAP043
     C                   DOW       OurIDTSC(X) <> *BLANK                                      CAP043
     C                   CLEAR                   OurIntPayD2                                  CAP043
     C                   MOVEA     OurIDTSC(X)   OurIntPayD2                                  CAP043
                                                                                              CAP043
      ** Invalid if Our Interest Payment Frequency indicator not 'Z'                          CAP043
                                                                                              CAP043
     C     OPDatesAlp2   IFNE      *BLANKS                                                    CAP043
     C     OPDatesAlp2   ANDNE     *ZEROS                                                     CAP043
     C     RXUIPFR       ANDNE     'Z'                                                        CAP043
     C                   MOVE      'N'           OKInRatCal                                   CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SUIPFR'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CAP043
     C                   ELSE                                                                 CAP043
                                                                                              CAP043
     C     RXUIPFR       IFEQ      'Z'                                                        CAP043
     C                   CALLB     'IRVIRCVAL'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    RXVDAT                                       CAP043
     C                   PARM                    RXMDAT                                       CAP043
     C                   PARM      *ZERO         PCtlDate                                     CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM      'I'           PValType                                     CAP043
     C                   PARM      'U'           POurTheir                                    CAP043
     C                   PARM      SUCUCY        PCurrency                                    CAP043
     C                   PARM      OPDatesAlp2   DatesToVal                                   CAP043
     C                   PARM      *BLANK        PAmtToVal1                                   CAP043
     C                   PARM      *BLANK        PAmtToVal2                                   CAP043
     C                   PARM      *BLANK        PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg1      PBDConvtn                                    CAP043
     C                   PARM                    OKInRatCal                                   CAP043
     C                   PARM                    FldNameArr                                   CAP043
     C                   PARM                    MsgIDArr                                     CAP043
     C                   PARM                    Idx                                          CAP043
     C                   PARM      *BLANK        ValidDates                                   CAP043
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKInRatCal    IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit2                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      DXFOTRANID = APFOTRANID                                    CAP043
     C                   EVAL      DXRATPAY = 'P'                                             CAP043
     C                   EVAL      DXOURTHR = 'U'                                             CAP043
     C                   EVAL      DXTMESTMP = TimeStamp                                      CAP043
     C                   MOVEL     ValidDates    WIntRtC                                      CAP043
     C                   MOVEL     PConfHol      WDTSCConfH                                   CAP043
     C                   WRITE     IRTDTSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Read next DTSC record                                                                CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Retrieve their/rates IRC records                                                     CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
     C                   EVAL      PPrevDate = WTRPrvDate                                     CAP043
                                                                                              CAP043
      ** Validate Their Rate Change Dates                                                     CAP043
                                                                                              CAP043
     C                   DOW       ThrRDTSC(X) <> *BLANK                                      CAP043
     C                   CLEAR                   ThrRatChgD2                                  CAP043
     C                   MOVEA     ThrRDTSC(X)   ThrRatChgD2                                  CAP043
                                                                                              CAP043
      ** Invalid if Their Rate Change Frequency indicator not 'Z'                             CAP043
                                                                                              CAP043
     C     TRDatesAlp2   IFNE      *BLANKS                                                    CAP043
     C     TRDatesAlp2   ANDNE     *ZEROS                                                     CAP043
     C     RXTICFR       ANDNE     'Z'                                                        CAP043
     C                   MOVE      'N'           OKInRatCal                                   CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'STICFR'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CAP043
     C                   ELSE                                                                 CAP043
                                                                                              CAP043
     C     RXTICFR       IFEQ      'Z'                                                        CAP043
     C                   CALLB     'IRVIRCVAL'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    RXVDAT                                       CAP043
     C                   PARM                    RXMDAT                                       CAP043
     C                   PARM      *ZERO         PCtlDate                                     CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM      'R'           PValType                                     CAP043
     C                   PARM      'T'           POurTheir                                    CAP043
     C                   PARM      STCUCY        PCurrency                                    CAP043
     C                   PARM      TRDatesAlp2   DatesToVal                                   CAP043
     C                   PARM      *BLANK        PAmtToVal1                                   CAP043
     C                   PARM      *BLANK        PAmtToVal2                                   CAP043
     C                   PARM      *BLANK        PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg2      PBDConvtn                                    CAP043
     C                   PARM                    OKInRatCal                                   CAP043
     C                   PARM                    FldNameArr                                   CAP043
     C                   PARM                    MsgIDArr                                     CAP043
     C                   PARM                    Idx                                          CAP043
     C                   PARM      *BLANK        ValidDates                                   CAP043
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKInRatCal    IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit2                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      DXFOTRANID = APFOTRANID                                    CAP043
     C                   EVAL      DXRATPAY = 'R'                                             CAP043
     C                   EVAL      DXOURTHR = 'T'                                             CAP043
     C                   EVAL      DXTMESTMP = TimeStamp                                      CAP043
     C                   MOVEL     ValidDates    WIntRtC                                      CAP043
     C                   MOVEL     PConfHol      WDTSCConfH                                   CAP043
     C                   WRITE     IRTDTSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Read next DTSC record                                                                CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Retrieve their/payment IRC records                                                   CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
     C                   EVAL      PPrevDate = WTPPrvDate                                     CAP043
                                                                                              CAP043
      ** Validate Their Interest Payment Dates                                                CAP043
                                                                                              CAP043
     C                   DOW       ThrIDTSC(X) <> *BLANK                                      CAP043
     C                   CLEAR                   ThrIntPayD2                                  CAP043
     C                   MOVEA     ThrIDTSC(X)   ThrIntPayD2                                  CAP043
                                                                                              CAP043
      ** Invalid if Their Payment Change Freq. indicator not 'Z'                              CAP043
                                                                                              CAP043
     C     TPDatesAlp2   IFNE      *BLANKS                                                    CAP043
     C     TPDatesAlp2   ANDNE     *ZEROS                                                     CAP043
     C     RXTIPFR       ANDNE     'Z'                                                        CAP043
     C                   MOVE      'N'           OKInRatCal                                   CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'STIPFR'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CAP043
     C                   ELSE                                                                 CAP043
                                                                                              CAP043
     C     RXTIPFR       IFEQ      'Z'                                                        CAP043
     C                   CALLB     'IRVIRCVAL'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    RXVDAT                                       CAP043
     C                   PARM                    RXMDAT                                       CAP043
     C                   PARM      *ZERO         PCtlDate                                     CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM      'I'           PValType                                     CAP043
     C                   PARM      'T'           POurTheir                                    CAP043
     C                   PARM      STCUCY        PCurrency                                    CAP043
     C                   PARM      TPDatesAlp2   DatesToVal                                   CAP043
     C                   PARM      *BLANK        PAmtToVal1                                   CAP043
     C                   PARM      *BLANK        PAmtToVal2                                   CAP043
     C                   PARM      *BLANK        PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg2      PBDConvtn                                    CAP043
     C                   PARM                    OKInRatCal                                   CAP043
     C                   PARM                    FldNameArr                                   CAP043
     C                   PARM                    MsgIDArr                                     CAP043
     C                   PARM                    Idx                                          CAP043
     C                   PARM      *BLANK        ValidDates                                   CAP043
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKInRatCal    IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit2                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      DXFOTRANID = APFOTRANID                                    CAP043
     C                   EVAL      DXRATPAY = 'P'                                             CAP043
     C                   EVAL      DXOURTHR = 'T'                                             CAP043
     C                   EVAL      DXTMESTMP = TimeStamp                                      CAP043
     C                   MOVEL     ValidDates    WIntRtC                                      CAP043
     C                   MOVEL     PConfHol      WDTSCConfH                                   CAP043
     C                   WRITE     IRTDTSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Read next DTSC record                                                                CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Retrieve Our Cash Flow records                                                       CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
                                                                                              CAP043
      ** Check if Cash Flow Schedule not entered when Interest Payment Date                   CAP043
      ** not blank or vice versa                                                              CAP043
                                                                                              CAP043
     C                   IF        RXUIPFR = 'C'                                              CAP043
     C                   IF        (OurCFSC(X) <> *BLANK)                                     CAP043
     C                   IF        (SUNIPD = *BLANK)                                          CAP043
     C                   MOVE      'N'           OKCshFlw                                     CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SDAT01'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1263'                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   IF        (SUNIPD <> *BLANK)                                         CAP043
     C                   MOVE      'N'           OKCshFlw                                     CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SDAT01'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1264'                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Validate Our Cash Flow Schedules                                                     CAP043
                                                                                              CAP043
     C                   IF        Idx = 0                                                    CAP043
     C                   DOW       OurCFSC(X) <> *BLANK                                       CAP043
     C                   CLEAR                   WOurCash                                     CAP043
     C                   MOVEA     OurCFSC(X)    WOurCash                                     CAP043
                                                                                              CAP043
      ** Our Interest Payment Frequency must be 'C'                                           CAP043
                                                                                              CAP043
     C     WOurCshFD     IFNE      *BLANKS                                                    CAP043
     C     WOurCshFD     ANDNE     *ZEROS                                                     CAP043
     C     RXUIPFR       ANDNE     'C'                                                        CAP043
     C                   MOVE      'N'           OKCshFlw                                     CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SUIPFR'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1247'                                  CAP043
     C                   ELSE                                                                 CAP043
                                                                                              CAP043
     C     RXUIPFR       IFEQ      'C'                                                        CAP043
     C                   CALLB     'IRVIRCVAL'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    RXVDAT                                       CAP043
     C                   PARM                    RXMDAT                                       CAP043
     C                   PARM      *ZERO         PCtlDate                                     CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM      'C'           PValType                                     CAP043
     C                   PARM      'U'           POurTheir                                    CAP043
     C                   PARM      SUCUCY        PCurrency                                    CAP043
     C                   PARM      WOurCshFD     DatesToVal                                   CAP043
     C                   PARM      WOurCshFA     PAmtToVal1                                   CAP043
     C                   PARM      *BLANK        PAmtToVal2                                   CAP043
     C                   PARM      *BLANK        PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg1      PBDConvtn                                    CAP043
     C                   PARM                    OKCshFlw                                     CAP043
     C                   PARM                    FldNameArr                                   CAP043
     C                   PARM                    MsgIDArr                                     CAP043
     C                   PARM                    Idx                                          CAP043
     C                   PARM      *BLANK        ValidDates                                   CAP043
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKCshFlw      IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit2                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CXFOTRANID = APFOTRANID                                    CAP043
     C                   EVAL      CXOURTHR = 'U'                                             CAP043
     C                   EVAL      CXTMESTMP = TimeStamp                                      CAP043
     C                   MOVEL     ValidDates    WCashFlwD                                    CAP043
     C                   MOVEL     PValidAmnt    WCashFlwA                                    CAP043
     C                   MOVEL     PConfHol      WCFSCConfH                                   CAP043
     C                   WRITE     IRTCFSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Read next cash flow schedule record                                                  CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Retrieve Their Cash Flow records                                                     CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
                                                                                              CAP043
      ** Check if Cash Flow Schedule not entered when Interest Payment Date                   CAP043
      ** not blank or vice versa                                                              CAP043
                                                                                              CAP043
     C                   IF        RXTIPFR = 'C'                                              CAP043
     C                   IF        (ThrCFSC(X) <> *BLANK)                                     CAP043
     C                   IF        (STNIPD = *BLANK)                                          CAP043
     C                   MOVE      'N'           OKCshFlw                                     CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SDAT01'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1263'                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   IF        (STNIPD <> *BLANK)                                         CAP043
     C                   MOVE      'N'           OKCshFlw                                     CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SDAT01'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1264'                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Validate Their Cash Flow Schedules                                                   CAP043
                                                                                              CAP043
     C                   IF        Idx = 0                                                    CAP043
     C                   DOW       ThrCFSC(X) <> *BLANK                                       CAP043
     C                   CLEAR                   WThrCash                                     CAP043
     C                   MOVEA     ThrCFSC(X)    WThrCash                                     CAP043
                                                                                              CAP043
      ** Their Interest Payment Frequency must be 'C'                                         CAP043
                                                                                              CAP043
     C     WThrCshFD     IFNE      *BLANKS                                                    CAP043
     C     WThrCshFD     ANDNE     *ZEROS                                                     CAP043
     C     RXTIPFR       ANDNE     'C'                                                        CAP043
     C                   MOVE      'N'           OKCshFlw                                     CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'STIPFR'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1247'                                  CAP043
     C                   ELSE                                                                 CAP043
                                                                                              CAP043
     C     RXTIPFR       IFEQ      'C'                                                        CAP043
     C                   CALLB     'IRVIRCVAL'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    RXVDAT                                       CAP043
     C                   PARM                    RXMDAT                                       CAP043
     C                   PARM      *ZERO         PCtlDate                                     CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM      'C'           PValType                                     CAP043
     C                   PARM      'T'           POurTheir                                    CAP043
     C                   PARM      STCUCY        PCurrency                                    CAP043
     C                   PARM      WThrCshFD     DatesToVal                                   CAP043
     C                   PARM      WThrCshFA     PAmtToVal1                                   CAP043
     C                   PARM                    PAmtToVal2                                   CAP043
     C                   PARM      *BLANK        PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg2      PBDConvtn                                    CAP043
     C                   PARM                    OKCshFlw                                     CAP043
     C                   PARM                    FldNameArr                                   CAP043
     C                   PARM                    MsgIDArr                                     CAP043
     C                   PARM                    Idx                                          CAP043
     C                   PARM      *BLANK        ValidDates                                   CAP043
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKCshFlw      IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit2                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CXFOTRANID = APFOTRANID                                    CAP043
     C                   EVAL      CXOURTHR = 'T'                                             CAP043
     C                   EVAL      CXTMESTMP = TimeStamp                                      CAP043
     C                   MOVEL     ValidDates    WCashFlwD                                    CAP043
     C                   MOVEL     PValidAmnt    WCashFlwA                                    CAP043
     C                   MOVEL     PConfHol      WCFSCConfH                                   CAP043
     C                   WRITE     IRTCFSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Read next cash flow schedule record                                                  CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C     ValIRCExit2   TAG                                                                  CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      *****************************************************************                       CAP043
      /EJECT                                                                                  CAP043
      *****************************************************************                       CAP043
      *                                                               *                       CAP043
      * ValidateIC3 - Routine to validate Principal Change Dates      *                       CAP043
      *                                                               *                       CAP043
      *****************************************************************                       CAP043
                                                                                              CAP043
     C     ValidateIC3   BEGSR                                                                CAP043
                                                                                              CAP043
      ** Retrieve Our Principal Change records                                                CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
                                                                                              CAP043
      ** Check if Principal Change Schedule not entered when Next Principal Change            CAP043
      ** Date not blank or vice versa                                                         CAP043
                                                                                              CAP043
     C                   IF        (OurPCSC(X) <> *BLANK)                                     CAP043
     C                   IF        (SONPCD = *BLANK)                                          CAP043
     C                   MOVE      'N'           OKPrcChg                                     CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SDAT01'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1248'                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   IF        (SONPCD <> *BLANK)                                         CAP043
     C                   MOVE      'N'           OKPrcChg                                     CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SDAT01'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1249'                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Validate Our Principal Change Schedule if no error                                   CAP043
                                                                                              CAP043
     C                   IF        Idx = 0                                                    CAP043
                                                                                              CAP043
     C                   DOW       OurPCSC(X) <> *BLANK                                       CAP043
     C                   CLEAR                   WOurPrin                                     CAP043
     C                   MOVEA     OurPCSC(X)    WOurPrin                                     CAP043
                                                                                              CAP043
     C                   CALLB     'IRVIRCVAL'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    RXVDAT                                       CAP043
     C                   PARM                    RXMDAT                                       CAP043
     C                   PARM      #1UNPC        PCtlDate                                     CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM      'P'           PValType                                     CAP043
     C                   PARM      'U'           POurTheir                                    CAP043
     C                   PARM      SUCUCY        PCurrency                                    CAP043
     C                   PARM      WOurPrcCD     DatesToVal                                   CAP043
     C                   PARM      *BLANK        PAmtToVal1                                   CAP043
     C                   PARM      WOurPrcCA     PAmtToVal2                                   CAP043
     C                   PARM      WOurPrcCI     PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg1      PBDConvtn                                    CAP043
     C                   PARM                    OKPrcChg                                     CAP043
     C                   PARM                    FldNameArr                                   CAP043
     C                   PARM                    MsgIDArr                                     CAP043
     C                   PARM                    Idx                                          CAP043
     C                   PARM      *BLANK        ValidDates                                   CAP043
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKPrcChg      IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit3                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      PYFOTRANID = APFOTRANID                                    CAP043
     C                   EVAL      PYOURTHR = 'U'                                             CAP043
     C                   EVAL      PYTMESTMP = TimeStamp                                      CAP043
     C                   MOVEL     ValidDates    WPrinChgD                                    CAP043
     C                   MOVEL     PValidCAmt    WPrinChgA                                    CAP043
     C                   MOVEL     PValidCAmt    WPrinChgCA                                   CAP043
     C                   MOVEL     PConfHol      WPCSCConfH                                   CAP043
     C                   MOVEL     PIncDecInd    WPCSCIDInd                                   CAP043
     C                   WRITE     IRTPCSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Read next principal change schedule record                                           CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Retrieve Their Principal Change records                                              CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
     C                   EVAL      PPrevDate = *ZERO                                          CAP043
                                                                                              CAP043
      ** Check if Principal Change Schedule not entered when Next Principal Change            CAP043
      ** Date not blank or vice versa                                                         CAP043
                                                                                              CAP043
     C                   IF        (ThrPCSC(X) <> *BLANK)                                     CAP043
     C                   IF        (STNPCD = *BLANK)                                          CAP043
     C                   MOVE      'N'           OKPrcChg                                     CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SDAT01'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1248'                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   IF        (STNPCD <> *BLANK)                                         CAP043
     C                   MOVE      'N'           OKPrcChg                                     CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SDAT01'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1249'                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Validate Their Principal Change Schedule if no error                                 CAP043
                                                                                              CAP043
     C                   IF        Idx = 0                                                    CAP043
                                                                                              CAP043
     C                   DOW       ThrPCSC(X) <> *BLANK                                       CAP043
     C                   CLEAR                   WThrPrin                                     CAP043
     C                   MOVEA     ThrPCSC(X)    WThrPrin                                     CAP043
                                                                                              CAP043
     C                   CALLB     'IRVIRCVAL'                                                CAP043
     C                   PARM                    ReturnCode                                   CAP043
     C                   PARM                    RXVDAT                                       CAP043
     C                   PARM                    RXMDAT                                       CAP043
     C                   PARM      #1TNPC        PCtlDate                                     CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      SACCD         PAction                                      CAP043
     C                   PARM      SDLNO         PDealNo                                      CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM      'P'           PValType                                     CAP043
     C                   PARM      'T'           POurTheir                                    CAP043
     C                   PARM      STCUCY        PCurrency                                    CAP043
     C                   PARM      WThrPrcCD     DatesToVal                                   CAP043
     C                   PARM      *BLANK        PAmtToVal1                                   CAP043
     C                   PARM      WThrPrcCA     PAmtToVal2                                   CAP043
     C                   PARM      WThrPrcCI     PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM      WBDCLeg2      PBDConvtn                                    CAP043
     C                   PARM                    OKPrcChg                                     CAP043
     C                   PARM                    FldNameArr                                   CAP043
     C                   PARM                    MsgIDArr                                     CAP043
     C                   PARM                    Idx                                          CAP043
     C                   PARM      *BLANK        ValidDates                                   CAP043
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C     OKPrcChg      IFNE      'Y'                                                        CAP043
     C                   GOTO      ValIRCExit3                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      PYFOTRANID = APFOTRANID                                    CAP043
     C                   EVAL      PYOURTHR = 'T'                                             CAP043
     C                   EVAL      PYTMESTMP = TimeStamp                                      CAP043
     C                   MOVEL     ValidDates    WPrinChgD                                    CAP043
     C                   MOVEL     PValidCAmt    WPrinChgA                                    CAP043
     C                   MOVEL     PValidCAmt    WPrinChgCA                                   CAP043
     C                   MOVEL     PConfHol      WPCSCConfH                                   CAP043
     C                   MOVEL     PIncDecInd    WPCSCIDInd                                   CAP043
     C                   WRITE     IRTPCSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Read next principal change schedule record                                           CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C     ValIRCExit3   TAG                                                                  CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      *****************************************************************         CAP004
      /EJECT                                                                    CAP004
      *****************************************************************                       CAP041
      *                                                               *                       CAP041
      * ValidateFE - Routine to validate Fees\Buy-Outs fields         *                       CAP041
      *                                                               *                       CAP041
      *****************************************************************                       CAP041
                                                                                              CAP041
     C     ValidateFE    BEGSR                                                                CAP041
                                                                                              CAP041
     C                   IF        SACCD = 'I'                                                CAP041
     C                   EXSR      SETUPDEALN                                                 CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
      ** Set up details of DS DATA before calling validation.                                 CAP041
     C/COPY QWINDSRC,IRCIRSMOV1                                                               CAP041
                                                                                              CAP041
      ** Set up Our/Their number of decimal places.                                           CAP041
     C                   CALL      'AOCURRR0'                                                 CAP041
     C                   PARM      *BLANKS       PRtcd             7                          CAP041
     C                   PARM      '*KEY   '     POptn             7                          CAP041
     C                   PARM      #1UCUC        PCcy              3                          CAP041
     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP041
                                                                                              CAP041
     C                   EVAL      PWUCDP = A6NBDP                                            CAP041
                                                                                              CAP041
     C                   IF        #1TCUC <> *BLANKS                                          CAP041
                                                                                              CAP041
     C                   CALL      'AOCURRR0'                                                 CAP041
     C                   PARM      *BLANKS       PRtcd                                        CAP041
     C                   PARM      '*KEY   '     POptn                                        CAP041
     C                   PARM      #1TCUC        PCcy                                         CAP041
     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP041
                                                                                              CAP041
     C                   EVAL      PWTCDP = A6NBDP                                            CAP041
                                                                                              CAP041
     C                   ELSE                                                                 CAP041
                                                                                              CAP041
     C                   EVAL      PWTCDP = A6NBDP                                            CAP041
                                                                                              CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
      ** Set up Settlement & Receivers currency.                                              CAP041
                                                                                              CAP041
     C                   IF        CEU003 = 'Y' and #1PSCY <> *BLANKS                         CAP041
     C                   MOVEL     #1PSCY        PWPSCY                                       CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     #1UCUC        PWPSCY                                       CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
     C                   IF        CEU003 = 'Y' and #1RSCY <> *BLANKS                         CAP041
     C                   MOVEL     #1RSCY        PWRSCY                                       CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     #1TCUC        PWRSCY                                       CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
      ** Access nostro location for our-effective-settlement-currency                         CAP041
                                                                                              CAP041
     C                   IF        PWPSCY <> *BLANKS                                          CAP041
                                                                                              CAP041
     C                   CALL      'AONOSTR0'                                                 CAP041
     C                   PARM      *BLANKS       PRtcd                                        CAP041
     C                   PARM      '*KEY   '     POptn                                        CAP041
     C                   PARM      *BLANK        PCust                                        CAP041
     C                   PARM      PWPSCY        PCcy                                         CAP041
     C**********         PARM      *BLANKS       PAccd             4                   CAP041 CGL029
     C                   PARM      *BLANKS       PAccd            10                          CGL029
     C                   PARM      *BLANKS       PAcsn                                        CAP041
     C                   PARM      #1UNON        PNost                                        CAP041
     C                   PARM      *BLANKS       PBrcd                                        CAP041
     C                   PARM      *BLANKS       PCssn                                        CAP041
     C                   PARM      *BLANKS       Pinoy                                        CAP041
     C     SDNOST        PARM      SDNOST        DSFDY                                        CAP041
                                                                                              CAP041
     C                   IF        PRtcd = *BLANKS                                            CAP041
     C                   MOVE      A7NOSN        PWPNLOC                                      CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVE      *BLANKS       PWPNLOC                                      CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
      ** Access nostro location for their-effective-settlement-currency                       CAP041
                                                                                              CAP041
     C                   IF        PWRSCY <> *BLANKS                                          CAP041
                                                                                              CAP041
     C                   CALL      'AONOSTR0'                                                 CAP041
     C                   PARM      *BLANKS       PRtcd                                        CAP041
     C                   PARM      '*KEY   '     POptn                                        CAP041
     C                   PARM      *BLANK        PCust             6                          CAP041
     C                   PARM      PWRSCY        PCcy                                         CAP041
     C**********         PARM      *BLANKS       PAccd             4                          CAP041
     C                   PARM      *BLANKS       PAccd                                 CAP041 CGL029
     C                   PARM      *BLANKS       PAcsn             2                          CAP041
     C                   PARM      #1TNON        PNost             2 0                        CAP041
     C                   PARM      *BLANKS       PBrcd             3                          CAP041
     C                   PARM      *BLANKS       PCssn            10                          CAP041
     C                   PARM      *BLANKS       Pinoy             1                          CAP041
     C     SDNOST        PARM      SDNOST        DSFDY                                        CAP041
                                                                                              CAP041
     C                   IF        PRtcd = *BLANKS                                            CAP041
     C                   MOVE      A7NOSN        PWRNLOC                                      CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVE      A7NOSN        PWRNLOC                                      CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
     C                   CALLB     'IRCFBOVAL'                                                CAP041
      *                                                                                       CAP041
      ** INPUTS                                                                               CAP041
      ** ======                                                                               CAP041
      *                                                                                       CAP041
      * Response mode                                                                         CAP041
     C                   PARM                    APRespMode                                   CAP041
      *                                                                                       CAP041
      ** Transaction Details                                                                  CAP041
     C                   PARM                    NwFBScnFmt                                   CAP041
      *                                                                                       233467
      ** Deal Number                                                                          233467
     C                   PARM                    vDLNO                                        233467
      *                                                                                       CAP041
      ** OTHERS                                                                               CAP041
      ** ======                                                                               CAP041
      *                                                                                       CAP041
      ** Decimal Places based on Up-Front Pay/Receive (Our)                                   CAP041
      ** Decimal Places based on Up-Front Pay/Receive (Their)                                 CAP041
     C                   PARM                    PWUCDP                                       CAP041
     C                   PARM                    PWTCDP                                       CAP041
      *                                                                                       CAP041
      ** Settlement currency                                                                  CAP041
      ** Receivers currency                                                                   CAP041
     C                   PARM                    PWPSCY                                       CAP041
     C                   PARM                    PWRSCY                                       CAP041
      *                                                                                       CAP041
      ** Nostro Locations                                                                     CAP041
     C                   PARM                    PWPNLOC                                      CAP041
     C                   PARM                    PWRNLOC                                      CAP041
      *                                                                                       CAP041
      ** OUTPUTS                                                                              CAP041
      ** =======                                                                              CAP041
      *                                                                                       CAP041
      ** Transaction Details OK inds                                                          CAP041
     C                   PARM                    OKFBScnFmt                                   CAP041
                                                                                              CAP041
      * Error fields/message IDs/message data (arrays) from/to caller                         CAP041
     C                   PARM                    FldNameArr                                   CAP041
     C                   PARM                    MsgIDArr                                     CAP041
     C                   PARM                    MsgDtaArr                                    CAP041
                                                                                              CAP041
      * Array index (3P0) from/to caller                                                      CAP041
     C                   PARM                    Idx                                          CAP041
                                                                                              CAP041
      * Warning fields/message IDs/message data (arrays) from/to caller                       CAP041
     C                   PARM                    WFldNamArr                                   CAP041
     C                   PARM                    WMsgIDArr                                    CAP041
     C                   PARM                    WMsgDtaArr                                   CAP041
                                                                                              CAP041
      * Array index (3P0) from/to caller                                                      CAP041
     C                   PARM                    WIdx                                         CAP041
      *                                                                                       CAP041
      ** Deal info passed from calling programs                                               CAP041
     C                   PARM                    Data                                         CAP041
     C                   PARM                    BNDCSP                                       245692
                                                                                              CAP041
     C                   ENDSR                                                                CAP041
      *****************************************************************                       CAP041
      /EJECT                                                                                  CAP041
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************

     C     ValdateAmd    BEGSR

      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.  Some are never amendable and some depend upon ICD
      ** settings as to whether they are amendable.

      ** To determine which fields have changed, the current fields
      ** on file must be converted to a 'screen' format.

      ** These fields are then compared with the fields on the input
      ** transaction.

      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.

      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT

     C                   RESET                   ReturnCode
     C                   CALLB     'IRCIRSCVT'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
                                                                                              CLE025
      ** (Current) Deal Extension in file format                                              CLE025
     C                   PARM                    DealXFilfmt                                  CLE025
                                                                                              CLE025
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008

      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24

      ** AMEND CHECKING
     C                   RESET                   ReturnCode

     C                   CALLB     'IRCIRSAMD'
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranIn
      * (Current) Deal in Screen Format
     C                   PARM                    DealScnfmt
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt

      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1

     C                   IF        CAP041 = 'Y' and AmIdx = 0                                 CAP041
      *                                                                                       CAP041
     C                   EVAL      BSOIPM  = @SOIPM                                           CAP041
     C                   EVAL      BSONPCD = @SONPCD                                          CAP041
     C                   EVAL      BSTIPM  = @STIPM                                           CAP041
     C                   EVAL      BSTNPCD = @STNPCD                                          CAP041
     C                   EVAL      BSUFVD  = @SUFVD                                           CAP041
     C                   EVAL      BSUFEE  = @SUFEE                                           CAP041
     C                   EVAL      BSUFPR  = @SUFPR                                           CAP041
     C                   EVAL      BSBOVD  = @SBOVD                                           CAP041
     C                   EVAL      BSBUYA  = @SBUYA                                           CAP041
     C                   EVAL      BSBOPR  = @SBOPR                                           CAP041
      *                                                                                       CAP041
     C                   CALLB     'IRCFBOAMD'                                                CAP041
      *                                                                                       CAP041
      ** INPUT                                                                                CAP041
      ** =====                                                                                CAP041
      *                                                                                       CAP041
      ** Return Code                                                                          CAP041
     C                   PARM                    ReturnCode                                   CAP041
      *                                                                                       CAP041
      ** Transaction Details                                                                  CAP041
     C                   PARM                    NwFBScnFmt                                   CAP041
      *                                                                                       CAP041
      ** Transaction Details retrieved from file - in screen                                  CAP041
     C                   PARM                    CrFBScnFmt                                   CAP041
      *                                                                                       CAP041
      ** Deal information details                                                             CAP041
     C                   PARM                    Data                                         CAP041
      *                                                                                       CAP041
      ** Reset of Fields in Error Required (Y/N)                                              CAP041
     C                   PARM      'N'           PResetFld         1                          CAP041
      *                                                                                       CAP041
      ** Decimal Places based on Up-Front Pay/Receive (Our)                                   CAP041
     C                   PARM                    PWUCDP                                       CAP041
      *                                                                                       CAP041
      ** Decimal Places based on Up-Front Pay/Receive (Their)                                 CAP041
     C                   PARM                    PWTCDP                                       CAP041
      *                                                                                       CAP041
      ** STANDING DATA                                                                        CAP041
      ** =============                                                                        CAP041
      *                                                                                       CAP041
      ** SDBANK - Rundate                                                                     CAP041
     C                   PARM                    BJRDNB                                       CAP041
      *                                                                                       CAP041
      ** SWITCHABLE FEATURES                                                                  CAP041
      ** ===================                                                                  CAP041
      *                                                                                       CAP041
      ** Overnight index swaps                                                                CAP041
     C                   PARM                    CIR007                                       CAP041
      *                                                                                       CAP041
      ** OUTPUT                                                                               CAP041
      ** ======                                                                               CAP041
      *                                                                                       CAP041
      ** Error fields/message Ids/message data (arrays) from/to caller                        CAP041
     C                   PARM                    AmFldNamAr                                   CAP041
     C                   PARM                    AmMsgIdArr                                   CAP041
     C                   PARM                    AmMsgDtaAr                                   CAP041
      *                                                                                       CAP041
      ** Array index (3P0) from/to caller                                                     CAP041
     C                   PARM                    AmIDx                                        CAP041
      *                                                                                       CAP041
      ** Transaction Details OK inds                                                          CAP041
     C                   PARM                    OKFBScnFmt                                   CAP041
      *                                                                                       CAP041
      ** OK Amendments field                                                                  CAP041
     C                   PARM                    AmendOK                                      CAP041
     C                   PARM                    BNDCSP                                       245692
      *                                                                                       CAP041
     C                   ENDIF                                                                CAP041
      ** If any errors overwrite previous error information
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF

     C                   ENDSR
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
      *  - If Action Code is Insert
      *     - set up the deal number
      *  - If there are still no errors
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report deal status
      *  If any errors were found:
      *  - write a record to the Invalid file
      *  - call the message handler to pass the errors back
      *  - use std message handler to report deal status
      *  The index to the error arrays is checked for presence/absence of
      *   errors

      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date this routine will have to cater for        |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   Endif                                                  |
      ** |                                                            |
      ** | Endif                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+

     C     Idx           IFEQ      0

     C                   IF        SACCD = 'I'
     C                   EXSR      SETUPDEALN
     C                   ENDIF

     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   WRITE     IRVCIRSD0
                                                                                              CIR003
      ** Extra Settlement                                                                     CIR003
     C                   IF        CIR003 = 'Y'                                               CIR003
     C                             AND  SACCD <> 'R'                                          CIR003
     C                   EXSR      SrValidEx                                                  CIR003
     C                   ENDIF                                                                CIR003
      *                                                                         CAP004
      * If Interest Rate Calendars are in use write to valid IRC file           CAP004
      **(dont*bother*setting*up*for*delete)**************************                  CAP004 222727
      * (dont bother setting up for delete or authorize)                                      222727
     C     CIR001        IFEQ      'Y'                                          CAP004
     C     SACCD         ANDNE     'R'                                          CAP004
     C     SACCD         ANDNE     'X'                                                        222727
     C                   EXSR      SUPVALIRC                                    CAP004
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   EXSR      SUPVALICP                                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   END                                                    CAP004
      *                                                                         CAP004
      ***Insert*DLDLDGQD*record*for*CLE025 processing                                   247888248452
     C**********         IF        #1ACTN = 'I' AND CLE025 = 'Y'                        247888248452
     C*****SDLNO         CHAIN     DLDLDGD0                           12                247888248452
     C******IN12         IFEQ      *ON                                                  247888248452
     C**********         EVAL      DX_F1DLNO = SDLNO                                    247888248452
     C**********         EVAL      DX_F1BRCA = SBRCA                                    247888248452
     C**********         WRITE     DLDLDGD0                                             247888248452
     C**********         ENDIF                                                          247888248452
     C**********         ENDIF                                                          247888248452
      **********                                                                        247888248452
     C                   EXSR      CallMsgHdl
     C                   ENDIF

     C                   ENDIF

     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *                                                                         CAP004
      * Only write to invalid files if repair in back office                    CAP004
      *                                                                         CAP004
     C     APRprLocn     IFEQ      'B'                                          CAP004
     C                   WRITE     IRICIRSD0
     C                   WRITE     APIDSETD0
                                                                                              CSC011
      ** If support system is active, write invalid transaction to                            CSC011
      ** log file via APLOGTRAN standard module.                                              CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranIn + OurRatChgD                             CSC011
     C                                        + OurIntPayD                                    CSC011
     C                                        + ThrRatChgD                                    CSC011
     C                                        + ThrIntPayD                                    CSC011
     C                                        + InRecSttmt                                    CSC011
     C                                        + InPaySttmt                                    CSC011
     C                                        + InFRASttmt                                    CSC011
     C                                        + InRecStmtV                                    CSC011
     C                                        + InPayStmtV                                    CSC011
     C                                        + InRecStmtM                                    CSC011
     C                                        + InPayStmtM                                    CSC011
     C                                        + InfData                                       CAP043
     C                                        + ExtData                                       CSC011
     C                   EVAL      APTGTTYPE = 'IRCIRS'                                       CSC011
     C                   EVAL      PDealNum = SDLNO                                           CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = PDealNum                                           CSC011
     C                   EVAL      DBFile = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBase = 909                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CIR003
      ** Extra Settlement                                                                     CIR003
     C                   IF        CIR003 = 'Y'                                               CIR003
     C                   EXSR      SrInValEx                                                  CIR003
     C                   ENDIF                                                                CIR003
      *                                                                         CAP004
      * If Interest Rate Calendars are in use write to invalid IRC file         CAP004
     C     CIR001        IFEQ      'Y'                                          CAP004
     C                   EXSR      SUPIVALIRC                                   CAP004
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   EXSR      SUPIVALICP                                                 CAP043
     C                   ENDIF                                                                CAP043
     C                   END                                                    CAP004
     C                   ENDIF                                                  CAP004
      *                                                                         CAP004
     C                   EXSR      CallMsgHdl
     C                   ENDIF
                                                                                              CAP043
      ** Remove records from work and temporary file                                          CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   EXSR      SRClrWrkTmp                                                CAP043
     C                   ENDIF                                                                CAP043

     C                   COMMIT

     C                   ENDSR
      *****************************************************************
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

     C                   RESET                   OKFlagsDS

     C                   RESET                   ErrDealDat
     C                   RESET                   ErrValDate
     C                   RESET                   ErrMatDate
     C                   RESET                   ErrNxInDat

     C                   RESET                   AmendOK

     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKCIRSInDS
     C                   RESET                   OKPayInsDSE                                  CIR003
     C                   RESET                   OKRecInsDSE                                  CIR003
     C                   RESET                   OKCIRSInDSE                                  CIR003
     C                   RESET                   OKInRatCal                     CAP004
     C                   RESET                   OKCshFlw                                     CAP043
     C                   RESET                   OKPrcChg                                     CAP043
     C                   MOVE      *ALL'Y'       OKFBScnFmt                                   CAP041

     C                   RESET                   PayDat
     C                   RESET                   RecDat

     C                   CLEAR                   ValidDeal

      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields
     C                   Z-ADD     *ZERO         RXRSTM
     C**********         Z-ADD     *ZERO         RXROBN                                       CSD027
     C**********         Z-ADD     *ZERO         RXROCN                                       CSD027
     C                   EVAL      RXROBN = *BLANKS                                           CSD027
     C                   EVAL      RXROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         RXPSTM
     C**********         Z-ADD     *ZERO         RXPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         RXPOCN                                       CSD027
     C                   EVAL      RXPOBN = *BLANKS                                           CSD027
     C                   EVAL      RXPOCN = *BLANKS                                           CSD027

      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt
     C                   CLEAR                   DBPayStmtE                                   CIR003
     C                   CLEAR                   DBRecStmtE                                   CIR003
     C                   CLEAR                   DBFRAStmtE                                   CIR003
     C                   CLEAR                   DBPayStmtV                                   CIR003
     C                   CLEAR                   DBRecStmtV                                   CIR003
     C                   CLEAR                   DBPayStmtM                                   CIR003
     C                   CLEAR                   DBRecStmtM                                   CIR003

     C                   CLEAR                   ValIRCData                     CAP004
     C                   CLEAR                   InvIRCData                     CAP004
     C                   CLEAR                   VldCashFlw                                   CAP043
     C                   CLEAR                   InvCashFlw                                   CAP043
     C                   CLEAR                   VldPrinChg                                   CAP043
     C                   CLEAR                   InvPrinChg                                   CAP043
                                                                                CAP004
     C                   CLEAR                   DBORatChgD                     CAP004
     C                   CLEAR                   DBOIntPayD                     CAP004
     C                   CLEAR                   DBTRatChgD                     CAP004
     C                   CLEAR                   DBTIntPayD                     CAP004
                                                                                              222727
     C                   CLEAR                   DATA                                         222727
                                                                                CAP004
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      *****************************************************************

     C     SETUPINVAL    BEGSR

     C                   EVAL      SFOtranID = APFOTranID
     C                   EVAL      SRprLocn  = APRprLocn
     C                   EVAL      STmeStmp  = TimeStamp

      * Include Header fields that need to be o/p to the Invalid settlement file
     C                   EVAL      DDMsgType  = 'IRCIRS'
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp

     C                   EVAL      TranStatus = 'F'
                                                                                              CAP056
      ** Setup the InValid file with 'Authomatic Authorisation' from                          CAP056
      ** Interface file IRRXIFPD                                                              CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                   EVAL      SAUTH = AUTH                                               CAP056
     C                   ENDIF                                                                CAP056

      /COPY WNCPYSRC,IRCIRSC017                                                 CAP004
     C                   ENDSR
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SUPVALICP - Set up valid IRC, Cash Flow and Principal Change     *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SUPVALICP     BEGSR                                                                CAP043
                                                                                              CAP043
      ** Interest Rate Calendar                                                               CAP043
                                                                                              CAP043
     C     APFOTRANID    SETLL     IRTDTSCL0                                                  CAP043
     C     APFOTRANID    READE     IRTDTSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRTDTSCL0)                                        CAP043
     C                   EVAL      VALIRCData = TIntRtCDS                                     CAP043
     C                   WRITE     IRVDTSCD0                                                  CAP043
     C     APFOTRANID    READE     IRTDTSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Cash Flow Schedule                                                                   CAP043
                                                                                              CAP043
     C     APFOTRANID    SETLL     IRTCFSCL0                                                  CAP043
     C     APFOTRANID    READE     IRTCFSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRTCFSCL0)                                        CAP043
     C                   EVAL      VldCashFlw = TCshFlwDS                                     CAP043
     C                   WRITE     IRVCFSCD0                                                  CAP043
     C     APFOTRANID    READE     IRTCFSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Principal Change Schedule                                                            CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C     APFOTRANID    SETLL     IRTPCSCL0                                                  CAP043
     C     APFOTRANID    READE     IRTPCSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(IRTPCSCL0)                                        CAP043
     C                   EVAL      VldPrinChg =TPrcChgDS                                      CAP043
     C                   WRITE     IRVPCSCD0                                                  CAP043
     C     APFOTRANID    READE     IRTPCSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      *****************************************************************
      /EJECT
      *****************************************************************         CAP004
      *                                                               *         CAP004
      * SUPVALIRC  - Set up valid Interest Rate Calendar details      *         CAP004
      *                                                               *         CAP004
      *****************************************************************         CAP004
                                                                                CAP004
     C     SUPVALIRC     BEGSR                                                  CAP004
                                                                                CAP004
                                                                                CAP004
      ** Our Rate Change Dates.                                                 CAP004
     C     RXUICFR       IFEQ      'Z'                                                        188418
     C                   EVAL      ORFOtran   = APFOTranID                      CAP004
     C                   EVAL      ORXTmeStmp = TimeStamp                       CAP004
     C                   MOVE      'U'           ORXOURTHR                      CAP004
     C                   MOVE      'R'           ORXRATPAY                      CAP004
     C                   MOVE      DBORatChgD    ValIRCData                     CAP004
     C                   WRITE     IRVDTSCD0                                    CAP004
     C                   ENDIF                                                                188418
                                                                                CAP004
      ** Our Interest Payment Dates.                                            CAP004
     C     RXUIPFR       IFEQ      'Z'                                                        188418
     C                   EVAL      OPFOtran   = APFOTranID                      CAP004
     C                   EVAL      OPXTmeStmp = TimeStamp                       CAP004
     C                   MOVE      'U'           OPXOURTHR                      CAP004
     C                   MOVE      'P'           OPXRATPAY                      CAP004
     C                   MOVE      DBOIntPayD    ValIRCData                     CAP004
     C                   WRITE     IRVDTSCD0                                    CAP004
     C                   ENDIF                                                                188418
                                                                                CAP004
      ** Their Rate Change Dates.                                               CAP004
     C     RXTICFR       IFEQ      'Z'                                                        188418
     C                   EVAL      TRFOtran   = APFOTranID                      CAP004
     C                   EVAL      TRXTmeStmp = TimeStamp                       CAP004
     C                   MOVE      'T'           TRXOURTHR                      CAP004
     C                   MOVE      'R'           TRXRATPAY                      CAP004
     C                   MOVE      DBTRatChgD    ValIRCData                     CAP004
     C                   WRITE     IRVDTSCD0                                    CAP004
     C                   ENDIF                                                                188418
                                                                                CAP004
      ** Their Interest Payment Dates.                                          CAP004
     C     RXTIPFR       IFEQ      'Z'                                                        188418
     C                   EVAL      TPFOtran   = APFOTranID                      CAP004
     C                   EVAL      TPXTmeStmp = TimeStamp                       CAP004
     C                   MOVE      'T'           TPXOURTHR                      CAP004
     C                   MOVE      'P'           TPXRATPAY                      CAP004
     C                   MOVE      DBTIntPayD    ValIRCData                     CAP004
     C                   WRITE     IRVDTSCD0                                    CAP004
     C                   ENDIF                                                                188418
                                                                                CAP004
                                                                                CAP004
     C                   ENDSR                                                  CAP004
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SUPIVALICP - Set up invalid IRC, Cash Flow and Principal Change  *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SUPIVALICP    BEGSR                                                                CAP043
                                                                                              CAP043
     C                   EVAL      SFOtranID = APFOTranID                                     CAP043
     C                   EVAL      SRprLocn  = APRprLocn                                      CAP043
     C                   EVAL      STmeStmp  = TimeStamp                                      CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C                   DOW       (OurRDTSC(X) <> *BLANK) OR                                 CAP043
     C                             (OurIDTSC(X) <> *BLANK) OR                                 CAP043
     C                             (ThrRDTSC(X) <> *BLANK) OR                                 CAP043
     C                             (ThrIDTSC(X) <> *BLANK)                                    CAP043
                                                                                              CAP043
      ** Our Rate                                                                             CAP043
                                                                                              CAP043
     C                   IF        OurRDTSC(X) <> *BLANK                                      CAP043
     C                   EVAL      SOURTHR   = 'U'                                            CAP043
     C                   EVAL      SRATPAY   = 'R'                                            CAP043
     C                   EVAL      IRCDates  = OurRDTSC(X)                                    CAP043
     C                   WRITE     IRIDTSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Our Interest Payment                                                                 CAP043
                                                                                              CAP043
     C                   IF        OurIDTSC(X) <> *BLANK                                      CAP043
     C                   EVAL      SOURTHR   = 'U'                                            CAP043
     C                   EVAL      SRATPAY   = 'P'                                            CAP043
     C                   EVAL      IRCDates  = OurIDTSC(X)                                    CAP043
     C                   WRITE     IRIDTSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Their Rate                                                                           CAP043
                                                                                              CAP043
     C                   IF        ThrRDTSC(X) <> *BLANK                                      CAP043
     C                   EVAL      SOURTHR   = 'T'                                            CAP043
     C                   EVAL      SRATPAY   = 'R'                                            CAP043
     C                   EVAL      IRCDates  = ThrRDTSC(X)                                    CAP043
     C                   WRITE     IRIDTSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Their Interest Payment                                                               CAP043
                                                                                              CAP043
     C                   IF        ThrIDTSC(X) <> *BLANK                                      CAP043
     C                   EVAL      SOURTHR   = 'T'                                            CAP043
     C                   EVAL      SRATPAY   = 'P'                                            CAP043
     C                   EVAL      IRCDates  = ThrIDTSC(X)                                    CAP043
     C                   WRITE     IRIDTSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If support system is active, write invalid transaction to                            CAP043
      ** log file via APLOGTRAN standard module.                                              CAP043
                                                                                              CAP043
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CAP043
                                                                                              CAP043
     C                   EVAL      WMSGTYPE2 = 'IRCIRI'                                       CAP043
     C                   EVAL      TRANSDTL =  OurRDTSC(X)                                    CAP043
     C                                        + OurIDTSC(X)                                   CAP043
     C                                        + ThrRDTSC(X)                                   CAP043
     C                                        + ThrIDTSC(X)                                   CAP043
     C                                        + ExtData                                       CAP043
     C                   EXSR      SRLogInvTr                                                 CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
                                                                                              CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   EVAL      CISFOtranID = APFOTranID                                   CAP043
     C                   EVAL      CISRprLocn  = APRprLocn                                    CAP043
     C                   EVAL      CISTmeStmp = TimeStamp                                     CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C                   DOW       (OurCFSC(X) <> *BLANK) OR                                  CAP043
     C                             (ThrCFSC(X) <> *BLANK)                                     CAP043
                                                                                              CAP043
      ** Our Cash Flow                                                                        CAP043
                                                                                              CAP043
     C                   IF        OurCFSC(X) <> *BLANK                                       CAP043
     C                   EVAL      CISOURTHR = 'U'                                            CAP043
     C                   EVAL      WInvCshFlw = OurCFSC(X)                                    CAP043
     C                   WRITE     IRICFSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Their Cash Flow                                                                      CAP043
                                                                                              CAP043
     C                   IF        ThrCFSC(X) <> *BLANK                                       CAP043
     C                   EVAL      CISOURTHR = 'T'                                            CAP043
     C                   EVAL      WInvCshFlw = ThrCFSC(X)                                    CAP043
     C                   WRITE     IRICFSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If support system is active, write invalid transaction to                            CAP043
      ** log file via APLOGTRAN standard module.                                              CAP043
                                                                                              CAP043
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CAP043
                                                                                              CAP043
     C                   EVAL      WMSGTYPE2 = 'IRCICF'                                       CAP043
     C                   EVAL      TRANSDTL =  OurCFSC(X) + ThrCFSC(X) +                      CAP043
     C                                         ExtData                                        CAP043
     C                   EXSR      SRLogInvTr                                                 CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
                                                                                              CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C                   EVAL      PITFOtranID = APFOTranID                                   CAP043
     C                   EVAL      PITRprLocn  = APRprLocn                                    CAP043
     C                   EVAL      PITTmeStmp = TimeStamp                                     CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C                   DOW       (OurPCSC(X) <> *BLANK) OR                                  CAP043
     C                             (ThrPCSC(X) <> *BLANK)                                     CAP043
                                                                                              CAP043
      ** Our Principal Change                                                                 CAP043
                                                                                              CAP043
     C                   IF        OurPCSC(X) <> *BLANK                                       CAP043
     C                   EVAL      PITOURTHR = 'U'                                            CAP043
     C                   EVAL      WInvPrcChg = OurPCSC(X)                                    CAP043
     C                   WRITE     IRIPCSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Their Principal Change                                                               CAP043
                                                                                              CAP043
     C                   IF        ThrPCSC(X) <> *BLANK                                       CAP043
     C                   EVAL      PITOURTHR = 'T'                                            CAP043
     C                   EVAL      WInvPrcChg = ThrPCSC(X)                                    CAP043
     C                   WRITE     IRIPCSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If support system is active, write invalid transaction to                            CAP043
      ** log file via APLOGTRAN standard module.                                              CAP043
                                                                                              CAP043
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CAP043
                                                                                              CAP043
     C                   EVAL      WMSGTYPE2 = 'IRCIPC'                                       CAP043
     C                   EVAL      TRANSDTL =  OurPCSC(X) + ThrPCSC(X) +                      CAP043
     C                                         ExtData                                        CAP043
     C                   EXSR      SRLogInvTr                                                 CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Also log trailer file                                                                CAP043
                                                                                              CAP043
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CAP043
                                                                                              CAP043
     C                   EVAL      WMSGTYPE2 = 'IRCITR'                                       CAP043
     C                   EVAL      TRANSDTL =  TrailerDS                                      CAP043
     C                                         + InRecSttmt                                   CAP043
     C                                         + InPaySttmt                                   CAP043
     C                                         + InFRASttmt                                   CAP043
     C                                         + InRecStmtV                                   CAP043
     C                                         + InPayStmtV                                   CAP043
     C                                         + InRecStmtM                                   CAP043
     C                                         + InPayStmtM                                   CAP043
     C                                         + InfData                                      CAP043
     C                                         + ExtData                                      CAP043
     C                   EXSR      SRLogInvTr                                                 CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRLogInvTr - Logs the invalid transaction to log file via        *                    CAP043
      *              APLOGTRAN module                                    *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRLogInvTr    BEGSR                                                                CAP043
                                                                                              CAP043
      ** If support system is active, write invalid transaction to                            CAP043
      ** log file via APLOGTRAN standard module.                                              CAP043
                                                                                              CAP043
     C                   EVAL      APTGTTYPE = WMSGTYPE2                                      CAP043
     C                   EVAL      PDealNum = SDLNO                                           CAP043
                                                                                              CAP043
     C                   CALLB     'APLOGTRAN'                                                CAP043
     C                   PARM      *BLANKS       RetCodeOut                                   CAP043
     C                   PARM                    HeadIn                                       CAP043
     C                   PARM                    TRANSDTL                                     CAP043
     C                   PARM                    Timestamp                                    CAP043
     C                   PARM                    PDealNum                                     CAP043
     C                   PARM      *BLANKS       PADealNo                                     CAP043
                                                                                              CAP043
     C                   IF        RetCodeOut <> *Blanks                                      CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKey = PDealNum                                           CAP043
     C                   EVAL      DBFile = 'APLOGTRAN'                                       CAP043
     C                   EVAL      DBase = 914                                                CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRClrWrkTmp - Clears records from work and temporary file        *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRClrWrkTmp   BEGSR                                                                CAP043
                                                                                              CAP043
      ** CIRS work file                                                                       CAP043
                                                                                              CAP043
     C     APFOTRANID    SETLL     IRWCIRSL0                                                  CAP043
     C     APFOTRANID    READE     IRWCIRSL0                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRWCIRSD0                                                  CAP043
     C     APFOTRANID    READE     IRWCIRSL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** DTSC work file                                                                       CAP043
                                                                                              CAP043
     C     APFOTRANID    SETLL     IRWDTSCL0                                                  CAP043
     C     APFOTRANID    READE     IRWDTSCL0                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRWDTSCD0                                                  CAP043
     C     APFOTRANID    READE     IRWDTSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** DTSC temp file                                                                       CAP043
                                                                                              CAP043
     C     APFOTRANID    SETLL     IRTDTSCL0                                                  CAP043
     C     APFOTRANID    READE     IRTDTSCL0                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRTDTSCD0                                                  CAP043
     C     APFOTRANID    READE     IRTDTSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** CFSC work file                                                                       CAP043
                                                                                              CAP043
     C     APFOTRANID    SETLL     IRWCFSCL0                                                  CAP043
     C     APFOTRANID    READE     IRWCFSCL0                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRWCFSCD0                                                  CAP043
     C     APFOTRANID    READE     IRWCFSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** CFSC temp file                                                                       CAP043
                                                                                              CAP043
     C     APFOTRANID    SETLL     IRTCFSCL0                                                  CAP043
     C     APFOTRANID    READE     IRTCFSCL0                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRTCFSCD0                                                  CAP043
     C     APFOTRANID    READE     IRTCFSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** PCSC work file                                                                       CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C     APFOTRANID    SETLL     IRWPCSCL0                                                  CAP043
     C     APFOTRANID    READE     IRWPCSCL0                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRWPCSCD0                                                  CAP043
     C     APFOTRANID    READE     IRWPCSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** CFSC temp file                                                                       CAP043
                                                                                              CAP043
     C     APFOTRANID    SETLL     IRTPCSCL0                                                  CAP043
     C     APFOTRANID    READE     IRTPCSCL0                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRTPCSCD0                                                  CAP043
     C     APFOTRANID    READE     IRTPCSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      *****************************************************************         CAP004
      /EJECT                                                                    CAP004
      *****************************************************************         CAP004
      *                                                               *         CAP004
      * SUPIVALIRC  - Set up invalid Interest Rate Calendar file      *         CAP004
      *                                                               *         CAP004
      *****************************************************************         CAP004
                                                                                CAP004
     C     SUPIVALIRC    BEGSR                                                  CAP004
                                                                                CAP004
     C                   EVAL      SFOtranID = APFOTranID                       CAP004
     C                   EVAL      SRprLocn  = APRprLocn                        CAP004
     C                   EVAL      STmeStmp  = TimeStamp                        CAP004
                                                                                CAP004
      ** Our Rate Change Dates.                                                 CAP004
     C                   IF        SUICFR = 'Z'                                               CAP043
     C                   MOVE      'U'           SOURTHR                        CAP004
     C                   MOVE      'R'           SRATPAY                        CAP004
     C                   MOVE      OurRatChgD    IRCDates                       CAP004
     C                   WRITE     IRIDTSCD0                                    CAP004
     C                   ENDIF                                                                CAP043
                                                                                CAP004
      ** Our Interest Payment Dates.                                            CAP004
     C                   IF        SUIPFR = 'Z'                                               CAP043
     C                   MOVE      'U'           SOURTHR                        CAP004
     C                   MOVE      'P'           SRATPAY                        CAP004
     C                   MOVE      OurIntPayD    IRCDates                       CAP004
     C                   WRITE     IRIDTSCD0                                    CAP004
     C                   ENDIF                                                                CAP043
                                                                                CAP004
      ** Their Rate Change Dates.                                               CAP004
     C                   IF        STICFR = 'Z'                                               CAP043
     C                   MOVE      'T'           SOURTHR                        CAP004
     C                   MOVE      'R'           SRATPAY                        CAP004
     C                   MOVE      ThrRatChgD    IRCDates                       CAP004
     C                   WRITE     IRIDTSCD0                                    CAP004
     C                   ENDIF                                                                CAP043
                                                                                CAP004
      ** Their Interest Payment Dates.                                          CAP004
     C                   IF        STIPFR = 'Z'                                               CAP043
     C                   MOVE      'T'           SOURTHR                        CAP004
     C                   MOVE      'P'           SRATPAY                        CAP004
     C                   MOVE      ThrIntPayD    IRCDates                       CAP004
     C                   WRITE     IRIDTSCD0                                    CAP004
     C                   ENDIF                                                                CAP043
                                                                                CAP004
                                                                                CAP004
     C                   ENDSR                                                  CAP004
      *****************************************************************         CAP004
      /EJECT                                                                    CAP004
      *****************************************************************
      *                                                               *
      * SETUPDEALN - Set up Deal Number for Inserts                   *
      *                                                               *
      *****************************************************************

     C     SETUPDEALN    BEGSR

     C     SDLNO         IFEQ      *BLANKS
     C     SDLNO         OREQ      *ZEROS

     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SDLNO
     C                   PARM                    RXDLNO

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SDlnoOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

     C                   ELSE
     C                   MOVE      SDLNO         RXDLNO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

      **For*Inserts,*put*the*Settlement*Instructions*(input*or*defaulted)***    170909
      ***into*the*Valid*file*record*****************************************    170909
                                                                                170909
      * For Inserts and Amends, put the Settlement Instructions (input or       170909
      *  defaulted) into the Valid file record.                                 170909
      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
      *  in contiguous areas, which must be placed into the correct parts
      *  of the Valid file record

     C                   IF        SACCD = 'I'
     C                             OR (SACCD = 'A')                             170909
     C**********         MOVEL     DBPaySttmt    CIRSPayIns                                   CGL029
     C**********         MOVEL     DBRecSttmt    CIRSRecIns                                   CGL029
     C                   EVAL      %SUBST(CIRSPayIns:1:2) =                                   CGL029
     C                             %SUBST(DBPaySttmt:1:2)                                     CGL029
     C                   EVAL      RXPONS = %SUBST(DBPaySttmt:3:18)                           CGL029
     C                   EVAL      %SUBST(CIRSPayIns:15:545) =                                CGL029
     C                             %SUBST(DBPaySttmt:21:545)                                  CGL029
     C                   EVAL      %SUBST(CIRSRecIns:1:2) =                                   CGL029
     C                             %SUBST(DBRecSttmt:1:2)                                     CGL029
     C                   EVAL      RXRONS = %SUBST(DBRecSttmt:3:18)                           CGL029
     C                   EVAL      %SUBST(CIRSRecIns:15:55) =                                 CGL029
     C                             %SUBST(DBRecSttmt:21:55)                                   CGL029
     C                   MOVE      FLPOBR        RXPOBR
     C                   MOVE      FLROBR        RXROBR
     C                   MOVE      FLCVMR        RXCVMR
     C                   MOVE      FLPSCY        RXPSCY
     C                   MOVE      FLRSCY        RXRSCY
     C                   MOVE      FLIC72        RXIC72
     C                   MOVEL     DBFraSttmt    CIRSFraIns
     C                   MOVE      FLAGVC        RXAGVC                         CSW097

     C** Ensure numeric fields are zero if not entered.
     C     FLISDA        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        RXISDA
     C                   END

     C     FLAGDT        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        RXAGDT
     C                   END

     C     FLAGVV        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        RXAGVV
     C                   END
                                                                                CSW097
     C     FLAGVC        IFEQ      *BLANKS                                      CSW097
     C                   Z-ADD     *ZEROS        RXAGVC                         CSW097
     C                   END                                                    CSW097

     C                   ENDIF

      **For*Amends,*put*the*pre-existing*Settlement*Instructions*into*******    170909
      ***the*Valid*file*record**********************************************    170909
      **Two*large*fields*(one*Pay,*one*Receive)*do*most*of*this*but*a*few***    170909
      ***(physically*separate)*fields*also*need*to*be*done******************    170909
     C*******************IF********SACCD*=*'A'**************                    170909
     C*******************MOVE******DGRecIns******CIRSRecIns*                    170909
     C*******************MOVE******DGPayIns******CIRSPayIns*                    170909
     C*******************MOVE******POBR**********RXPOBR*****                    170909
     C*******************MOVE******ROBR**********RXROBR*****                    170909
     C*******************MOVE******CVMR**********RXCVMR*****                    170909
     C*******************MOVE******PSCY**********RXPSCY*****                    170909
     C*******************MOVE******RSCY**********RXRSCY*****                    170909
     C*******************MOVE******IC72**********RXIC72*****                    170909
     C*******************MOVEL*****DGFraIns******CIRSFraIns*                    170909
     C*******************ENDIF******************************                    170909

      **For*Deletes*&*Authorises,*put the complete (pre-existing) deal          CAP004
      **For*Deletes*put*the*complete*(pre-existing)*deal***************                CAP004 CIR008
      ** For Deletes & Authorises, put the complete (pre-existing) deal                       CIR008
      *  into the Valid file record
     C                   IF           SACCD = 'R'
     C*******                      OR SACCD = 'X'                               CAP004
     C                             OR CIR008 = 'Y' AND SACCD = 'X'                            CIR008
     C                   MOVEL     DealFilFmt    ValidDeal
     C                   MOVEL     URACC         RXURACC                                      CGL029
     C                   MOVEL     UPACC         RXUPACC                                      CGL029
     C                   MOVEL     RONS          RXRONS                                       CGL029
     C                   MOVEL     PONS          RXPONS                                       CGL029
     C                   ENDIF
                                                                                              CAP041
      * Set Fees/Buy-Outs fields for update to the valids file if CAP041 is installed.        CAP041
     C                   IF        CAP041 = 'Y'                                               CAP041
     C                   EXSR      SRFileFlds                                                 CAP041
     C                   ENDIF                                                                CAP041

      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      RXCHTP = SACCD

      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      RXFRNT = APFOTranID
     C                   EVAL      RXREPA = APRprLocn
     C                   EVAL      RXTMESTMP = TimeStamp

     C                   EVAL      TranStatus = 'S'
                                                                                              CAP056
      ** Setup the Valid file with 'Authomatic Authorisation' from                            CAP056
      ** Interface file IRRXIFPD                                                              CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                   EVAL      RXAUTH = AUTH                                              CAP056
     C                   ENDIF                                                                CAP056

      /COPY WNCPYSRC,IRCIRSC018                                                 CAP004
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAP041
      *                                                               *                       CAP041
      *  SRFileFlds - Set up file fields                              *                       CAP041
      *                                                               *                       CAP041
      *****************************************************************                       CAP041
      *                                                                                       CAP041
     C     SRFileFlds    BEGSR                                                                CAP041
      *                                                                                       CAP041
      ** If any of the Up-front fee details have been                                         CAP041
      ** amended, set Confirmation Required indicator to Y                                    CAP041
      ** otherwise, set to N.                                                                 CAP041
      *                                                                                       CAP041
     C                   IF        #1UPVD <> RXUPVD OR                                        CAP041
     C                             #1UPFE <> RXUPFE OR                                        CAP041
     C                             #1UPPR <> RXUPPR                                           CAP041
     C                   EVAL      #1CNRQ = 'Y'                                               CAP041
     C                   EXSR      SRUpdUpF                                                   CAP041
     C                   ELSE                                                                 CAP041
     C                   EVAL      #1CNRQ = 'N'                                               CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
     C/COPY QWINDSRC,IRCIRSMOV2                                                               CAP041
                                                                                              CAP041
     C                   ENDSR                                                                CAP041
                                                                                              CAP041
      *****************************************************************                       CAP041
      /EJECT                                                                                  CAP041
      *****************************************************************                       CAP041
      *                                                               *                       CAP041
      *  SRUpdUpF -  Write into PF/DLDGUPFE old values of up-front    *                       CAP041
      *              value date, fee and P/R indicator                *                       CAP041
      *                                                               *                       CAP041
      *****************************************************************                       CAP041
      *                                                                                       CAP041
     C     SRUpdUpF      BEGSR                                                                CAP041
      *                                                                                       CAP041
     C     #1ACTN        IFEQ      'A'                                                        CAP041
     C                   MOVE      #1DLNO        DDLNO             6 0                        CAP041
     C     DDLNO         CHAIN     DLDGUPL1                           01                      CAP041
      *                                                                                       CAP041
     C                   IF        *IN01                                                      CAP041
     C                   MOVE      DDLNO         DLNO                                         CAP041
     C**********         MOVE      #1UPVD        UPVD                                  CAP041 185064
     C**********         MOVE      #1UPFE        UPFE                                  CAP041 185064
     C**********         MOVE      #1UPPR        UPPR                                  CAP041 185064
     C                   MOVE      RXUPVD        UPVD                                         185064
     C                   MOVE      RXUPFE        UPFE                                         185064
     C                   MOVE      RXUPPR        UPPR                                         185064
     C                   WRITE     DLDGREFF                                                   CAP041
     C                   ELSE                                                                 CAP041
     C**********         MOVE      #1UPFE        UPFE                                  CAP041 185064
     C**********         MOVE      #1UPVD        UPVD                                  CAP041 185064
     C**********         MOVE      #1UPPR        UPPR                                  CAP041 185064
     C                   MOVE      RXUPVD        UPVD                                         185064
     C                   MOVE      RXUPFE        UPFE                                         185064
     C                   MOVE      RXUPPR        UPPR                                         185064
     C                   UPDATE    DLDGREF                                                    CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   ENDSR                                                                CAP041
      *****************************************************************                       CAP041
      /EJECT                                                                                  CAP041
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************

     C     CallMsgHdl    BEGSR

      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors

     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax

     C     FldNameArr(Ix)IFNE      *BLANKS

     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)

     C                   ELSE

     C                   LEAVE

     C                   ENDIF

     C                   ADD       1             Ix
     C                   ENDDO

     C                   RESET                   ReturnCode
     C                   MOVEL     SDLNO         PTranID          20                          CAP033
                                                                                              CAP033

     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    APRprLocn
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ***Midas*transaction*ID*(6A,*from*caller)********************************************** CAP033
     C***********        PARM                    SDLNO                                        CAP033
      ** Midas transaction ID (20A, from caller)                                              CAP033
     C                   PARM                    PTranID                                      CAP033
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    SACCD
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)                       222373
     C                   PARM                    MsgFArray                                    222373
      ** Whether or not to clear the program message queue (1A)                               222373
     C                   PARM                    ClearPgmQ                                    222373

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CIR003
      *****************************************************************                       CIR003
      *                                                               *                       CIR003
      * ValidateEx - Process Extra Settlements                        *                       CIR003
      *                                                               *                       CIR003
      *****************************************************************                       CIR003
     C     ValidateEx    BEGSR                                                                CIR003
                                                                                              CIR003
      ** For value date settlements                                                           CIR003
     C                   IF        SVDEI = 'Y'                                                CIR003
     C                             OR  SPDEI = 'Y'                                            CIR003
     C                   EVAL      InRecStmtE = InRecStmtV                                    CIR003
     C                   EVAL      InPayStmtE = InPayStmtV                                    CIR003
     C                   EVAL      PRCcy = SUCUCY                                             CIR003
     C                   EVAL      PPCcy = STCUCY                                             CIR003
     C                   EVAL      PCalp = 'CXSV'                                             CIR003
     C                   EXSR      SrDftExS                                                   CIR003
     C                   EXSR      SrValExS                                                   CIR003
     C                   EVAL      InRecStmtV = InRecStmtE                                    CIR003
     C                   EVAL      InPayStmtV = InPayStmtE                                    CIR003
     C                   EVAL      DBRecStmtV = DBRecStmtE                                    CIR003
     C                   EVAL      DBPayStmtV = DBPayStmtE                                    CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
      ** For maturity date settlements                                                        CIR003
     C                   IF        SMDEI = 'Y'                                                CIR003
     C                             OR  SPDEI = 'Y'                                            CIR003
     C                   EVAL      InRecStmtE = InRecStmtM                                    CIR003
     C                   EVAL      InPayStmtE = InPayStmtM                                    CIR003
     C                   EVAL      PRCcy = STCUCY                                             CIR003
     C                   EVAL      PPCcy = SUCUCY                                             CIR003
     C                   EVAL      PCalp = 'CXSM'                                             CIR003
     C                   EXSR      SrDftExS                                                   CIR003
     C                   EXSR      SrValExS                                                   CIR003
     C                   EVAL      InRecStmtM = InRecStmtE                                    CIR003
     C                   EVAL      InPayStmtM = InPayStmtE                                    CIR003
     C                   EVAL      DBRecStmtM = DBRecStmtE                                    CIR003
     C                   EVAL      DBPayStmtM = DBPayStmtE                                    CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
     C                   ENDSR                                                                CIR003
      *****************************************************************                       CIR003
      /EJECT                                                                                  CIR003
      *****************************************************************                       CIR003
      *                                                               *                       CIR003
      * SrDftExs - Default Extra Settlements                          *                       CIR003
      *                                                               *                       CIR003
      *****************************************************************                       CIR003
     C     SrDftExS      BEGSR                                                                CIR003
                                                                                              CIR003
      * If ANY of the Settlements fields have been entered, bypass this                       CIR003
      *  routine.                                                                             CIR003
      * Otherwise, use modules which will use Standard Settlement                             CIR003
      *  Instructions to apply defaults.                                                      CIR003
                                                                                              CIR003
     C                   IF        InRecStmtE = *blanks                                       CIR003
     C                             AND  InPayStmtE = *blanks                                  CIR003
                                                                                              CIR003
     C                   CALLB     'ZASETINDFT'                                               CIR003
      *                                                                                       CIR003
      ** Output                                                                               CIR003
      ** Calling function type                                                                CIR003
     C                   PARM                    CIRS                                         CIR003
      ** Payment currency (or deal cuurency if only one currency on deal)                     CIR003
     C                   PARM                    PPCcy             3                          CIR003
      ** Receive currency (only if deal has two currencies)                                   CIR003
     C                   PARM                    PRCcy             3                          CIR003
      ** Customer (shortname or number)                                                       CIR003
     C                   PARM                    SCNum                                        CIR003
      ** Deal type                                                                            CIR003
     C                   PARM                    SDTyp                                        CIR003
      ** Federal Funds Ind.                                                                   CIR003
     C                   PARM                    SuFFI                                        CIR003
      ** ISDA Rules for FRA/IRS deals only                                                    CIR003
      ** Version of ISDA Rules govern                                                         CIR003
     C                   PARM                    PISDA             4                          CIR003
      ** Type of ISDA agreement                                                               CIR003
     C                   PARM                    PAGTY             6                          CIR003
      ** Date of ISDA Agreement                                                               CIR003
     C                   PARM                    PAGDT             6                          CIR003
      ** Version of ISDA Agreement                                                            CIR003
     C                   PARM                    PAGVV             2                          CIR003
      ** Version of ISDA Agreement century                                                    CIR003
     C                   PARM                    PAGVC             2                          CIR003
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
                                                                                              CIR003
      ** Return                                                                               CIR003
      ** Defaulted Payment Settlement Instruction in file format                              CIR003
     C                   PARM                    DBPayStmtE                                   CIR003
      ** Defaulted Receipt Settlement Instruction in file format                              CIR003
     C                   PARM                    DBRecStmtE                                   CIR003
      ** Defaulted FRA/IRS Settlement Instruction in file format                              CIR003
     C                   PARM                    DBFRAStmtE                                   CIR003
                                                                                              CIR003
      *  The defaulted instructions are in file format, but the                               CIR003
      *   Settlements validation requires that they are in the input format.                  CIR003
      *  Therefore run them through a conversion module.                                      CIR003
                                                                                              CIR003
     C                   CALLB     'ZASETINCVT'                                               CIR003
      ** Defaulted Settlement Instructions in file format                                     CIR003
     C                   PARM                    DBPayStmtE                                   CIR003
     C                   PARM                    DBRecStmtE                                   CIR003
     C                   PARM                    DBFRAStmtE                                   CIR003
                                                                                              CIR003
      ** Defaulted Settlement Instruction in input format                                     CIR003
     C                   PARM                    InPayStmtE                                   CIR003
     C                   PARM                    InRecStmtE                                   CIR003
     C                   PARM                    InFRAStmtE                                   CIR003
     C                   PARM      PRCcy         InRCCY                                      CSF011A
     C                   PARM      PPCcy         InPCCY                                      CSF011A
                                                                                              CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
     C                   ENDSR                                                                CIR003
      *****************************************************************                       CIR003
      /EJECT                                                                                  CIR003
      *****************************************************************                       CIR003
      *                                                               *                       CIR003
      * SrValExs - Validate Extra Settelements                        *                       CIR003
      *                                                               *                       CIR003
      *****************************************************************                       CIR003
     C     SrValExS      BEGSR                                                                CIR003
                                                                                              CIR003
     C                   RESET                   ReturnCode                                   CIR003
     C                   EVAL       OKPayInsDSE = *ALL'Y'                                     CIR003
     C                   EVAL       OKRecInsDSE = *ALL'Y'                                     CIR003
     C                   EVAL       OKCirsInDSE = *ALL'Y'                                     CIR003
                                                                                              CIR003
     C                   CALLB     'ZASETINVAL'                                               CIR003
                                                                                              CIR003
      ** Return Code                                                                          CIR003
     C                   PARM                    ReturnCode                                   CIR003
      ** Following parameters are output to called module                                     CIR003
      ** Calling function type                                                                CIR003
     C                   PARM                    PCalp             4                          CIR003
      ** Transaction Fields                                                                   CIR003
      ** Payment currency (or deal currency if only one currency on deal)                     CIR003
     C                   PARM                    PPCcy                                        CIR003
      ** Receive currency (only if deal has two currencies)                                   CIR003
     C                   PARM                    PRCcy                                        CIR003
      ** Customer (shortname or number)                                                       CIR003
     C                   PARM                    SCNUM                                        CIR003
      ** Deal type                                                                            CIR003
     C                   PARM                    SDTYP                                        CIR003
      ** Federal Funds Ind.                                                                   CIR003
     C                   PARM                    SUFFI                                        CIR003
      ** Booking Branch                                                                       CIR003
     C                   PARM                    SBRCA                                        CIR003
      ** Receipt Date (Value Date for IRS)                                                    CIR003
     C                   PARM                    RecDat                                       CIR003
      ** Payment Date (Value Date for IRS)                                                    CIR003
     C                   PARM                    Paydat                                       CIR003
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction                  CIR003
     C                   PARM                    InPayStmtE                                   CIR003
     C                   PARM                    InRecStmtE                                   CIR003
     C                   PARM                    InFRAStmtE                                   CIR003
                                                                                              CAS001
      ** Action Code                                                                          199787
     C                   PARM                    SACCD                                        199787
      * Protect Payment Field                                                                 196461
     C                   PARM                    ##PPAY            1                          196461
      * Protect Receipt Field                                                                 196461
     C                   PARM                    ##PREC            1                          196461
                                                                                              199787
      ** Following parameters are returned by called module                                   CIR003
      ** Payment Instruction OK flag                                                          CIR003
     C                   PARM                    OKPayInsDSE                                  CIR003
      ** Receive Instruction OK flag                                                          CIR003
     C                   PARM                    OKRecInsDSE                                  CIR003
      ** FRA/IRS Instruction OK flag                                                          CIR003
     C                   PARM                    OKCIRSInDSE                                  CIR003
      * Error fields/message IDs (arrays) from/to caller                                      CIR003
     C                   PARM                    FldNameArr                                   CIR003
     C                   PARM                    MsgIDArr                                     CIR003
      * Array index (3P0) from/to caller                                                      CIR003
     C                   PARM                    Idx                                          CIR003
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE008
     C                   PARM                    WFldNamArr                                   CRE008
     C                   PARM                    WMsgIDArr                                    CRE008
     C                   PARM                    WMsgDtaArr                                   CRE008
      ** Array index (3P0) from/to caller                                                     CRE008
     C                   PARM                    WIdx                                         CRE008
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction                            CIR003
     C                   PARM                    DBPayStmtE                                   CIR003
     C                   PARM                    DBRecStmtE                                   CIR003
     C                   PARM                    DBFRAStmtE                                   CIR003
     C                   PARM                    SACCD                                        CIR003
     C                   PARM                    ValIter           3                          CIR003
     C*****              PARM                    @MORPI                                CIR003 200400
                                                                                              CIR003
     C                   ENDSR                                                                CIR003
      *****************************************************************                       CIR003
      /EJECT                                                                                  CIR003
      *****************************************************************                       CIR003
      *                                                               *                       CIR003
      * SrAmdCvt - Convert Extra Settlement from File to Screen Format*                       CIR003
      *                                                               *                       CIR003
      *****************************************************************                       CIR003
     C     SrAmdCvt      BEGSR                                                                CIR003
                                                                                              CIR003
     C                   CALLB     'ZASETINCVT'                                               CIR003
      ** Defaulted Settlement Instructions in file format                                     CIR003
     C                   PARM                    DBPayStmtE                                   CIR003
     C                   PARM                    DBRecStmtE                                   CIR003
     C                   PARM                    DBFRAStmtE                                   CIR003
                                                                                              CIR003
      ** Current Settlement Instruction in input format                                       CIR003
     C                   PARM                    CrPayStmtE                                   CIR003
     C                   PARM                    CrRecStmtE                                   CIR003
     C                   PARM                    CrFRAStmtE                                   CIR003
     C                   PARM      @STCUCY       InRCCY                                      CSF011A
     C                   PARM      @SUCUCY       InPCCY                                      CSF011A
                                                                                              CIR003
     C                   ENDSR                                                                CIR003
      *****************************************************************                       CIR003
      /EJECT                                                                                  CIR003
      *****************************************************************                       CIR003
      *                                                               *                       CIR003
      * SExDtaSubs - Extra Settlement Details Data Substitution       *                       CIR003
      *                                                               *                       CIR003
      *****************************************************************                       CIR003
     C     SExDtaSubs    BEGSR                                                                CIR003
                                                                                              CIR003
      ** PAYMENT INSTRUCTIONS                                                                 CIR003
     C                   RESET                   ReturnCode                                   CIR003
     C                   CALLB     'APDTASUBS'                                                CIR003
                                                                                              CIR003
      * Return Code                                                                           CIR003
     C                   PARM                    ReturnCode                                   CIR003
      * Substitution character                                                                CIR003
     C                   PARM      GHSUBS        SubsChar                                     CIR003
      * Incoming Data                                                                         CIR003
     C                   PARM      InPayStmtE    IncDATA                                      CIR003
      * Current Data                                                                          CIR003
     C                   PARM      CrPayStmtE    CurDATA                                      CIR003
                                                                                              CIR003
     C                   MOVEL     IncDATA       InPayStmtE                                   CIR003
                                                                                              CIR003
      ** RECEIPT INSTRUCTIONS                                                                 CIR003
     C                   RESET                   ReturnCode                                   CIR003
     C                   CALLB     'APDTASUBS'                                                CIR003
                                                                                              CIR003
      * Return Code                                                                           CIR003
     C                   PARM                    ReturnCode                                   CIR003
      * Substitution character                                                                CIR003
     C                   PARM      GHSUBS        SubsChar                                     CIR003
      * Incoming Data                                                                         CIR003
     C                   PARM      InRecStmtE    IncDATA                                      CIR003
      * Current Data                                                                          CIR003
     C                   PARM      CrRecStmtE    CurDATA                                      CIR003
                                                                                              CIR003
     C                   MOVEL     IncDATA       InRecStmtE                                   CIR003
                                                                                              CIR003
     C                   ENDSR                                                                CIR003
      *****************************************************************                       CIR003
      /EJECT                                                                                  CIR003
      *****************************************************************                       CIR003
      *                                                               *                       CIR003
      * SrValidEx - Set up fields for Extra Settlement Valid File     *                       CIR003
      *             and add record to file                            *                       CIR003
      *                                                               *                       CIR003
      *****************************************************************                       CIR003
     C     SrValidEx     BEGSR                                                                CIR003
                                                                                              CIR003
      ** For value date settlement                                                            CIR003
     C                   IF        SVDEI = 'Y'                                                CIR003
     C                             OR  SPDEI = 'Y'                                            CIR003
     C                   MOVEL     DBPayStmtV    ExPSet                                       CIR003
     C                   MOVEL     DBRecStmtV    EXRSet                                       CIR003
     C                   MOVEL     RXDLNO        EXRXDLNO                                     CIR003
     C                   MOVEL     'VAL'         EXRXEDCD                                     CIR003
     C                   EVAL      EXRXFRNT = APFOTranID                                      CIR003
     C                   EVAL      EXRXTMESTMP = TimeStamp                                    CIR003
     C                   WRITE     IRVXSETD0                                                  CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
      ** For maturity date settlement                                                         CIR003
     C                   IF        SMDEI = 'Y'                                                CIR003
     C                             OR  SPDEI = 'Y'                                            CIR003
     C                   MOVEL     DBPayStmtM    ExPSet                                       CIR003
     C                   MOVEL     DBRecStmtM    EXRSet                                       CIR003
     C                   MOVEL     RXDLNO        EXRXDLNO                                     CIR003
     C                   MOVEL     'MAT'         EXRXEDCD                                     CIR003
     C                   EVAL      EXRXFRNT = APFOTranID                                      CIR003
     C                   EVAL      EXRXTMESTMP = TimeStamp                                    CIR003
     C                   WRITE     IRVXSETD0                                                  CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
     C                   ENDSR                                                                CIR003
      *****************************************************************                       CIR003
      /EJECT                                                                                  CIR003
      *****************************************************************                       CIR003
      *                                                               *                       CIR003
      * SrInValEx - Set up fields for Extra Settlement Invalid File   *                       CIR003
      *             and add record to file                            *                       CIR003
      *                                                               *                       CIR003
      *****************************************************************                       CIR003
     C     SrInValEx     BEGSR                                                                CIR003
                                                                                              CIR003
      ** For value date settlement                                                            CIR003
     C                   IF        SVDEI = 'Y'                                                CIR003
     C                             OR  SPDEI = 'Y'                                            CIR003
     C                   MOVEL     DBPayStmtV    ExPSetI                                      CIR003
     C                   MOVEL     DBRecStmtV    EXRSetI                                      CIR003
     C                   MOVEL     RXDLNO        EXSDLNO                                      CIR003
     C                   MOVEL     'VAL'         EXSEDCD                                      CIR003
     C                   EVAL      EXSFOTRANID = APFOTranID                                   CIR003
     C                   EVAL      EXSTMESTMP = TimeStamp                                     CIR003
     C                   WRITE     IRIXSETD0                                                  CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
      ** For maturity date settlement                                                         CIR003
     C                   IF        SMDEI = 'Y'                                                CIR003
     C                             OR  SPDEI = 'Y'                                            CIR003
     C                   MOVEL     DBPayStmtM    ExPSetI                                      CIR003
     C                   MOVEL     DBRecStmtM    EXRSetI                                      CIR003
     C                   MOVEL     RXDLNO        EXSDLNO                                      CIR003
     C                   MOVEL     'MAT'         EXSEDCD                                      CIR003
     C                   EVAL      EXSFOTRANID = APFOTranID                                   CIR003
     C                   EVAL      EXSTMESTMP = TimeStamp                                     CIR003
     C                   WRITE     IRIXSETD0                                                  CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
     C                   ENDSR                                                                CIR003
      *****************************************************************                       CIR003
      /EJECT
      /COPY ZACPYSRC,PSSR_ILE
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
      * Transaction information in a single large field from source system
     C                   PARM                    Trans500

      * Interest Rate Calendar info: (Only set up if CIR001 on)                 CAP004
      * Our Rate Change dates                                                   CAP004
     C                   PARM                    TRANSB500                      CAP004
      * Our Interest Payment dates                                              CAP004
     C                   PARM                    TRANSC500                      CAP004
      * Their Rate Change dates                                                 CAP004
     C                   PARM                    TRANSD500                      CAP004
      * Their Interest Payment dates                                            CAP004
     C                   PARM                    TRANSE500                      CAP004
     C                   PARM                    TRANSF500                                    CAP043
     C                   PARM                    TRANSG500                                    CAP043
     C                   PARM                    TRANSH500                                    CAP043

      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    InPayStmtV                                   CIR003
     C                   PARM                    InRecStmtV                                   CIR003
     C                   PARM                    InPayStmtM                                   CIR003
     C                   PARM                    InRecStmtM                                   CIR003
                                                                                              CAP056
      ** FRA/IRS Interface Non-Screen Data                                                    CAP056
     C                   PARM                    InfData500                                   CAP056
                                                                                              CAP056
     C                   PARM                    ExtData500                     CAP004
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'

      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'IR'
                                                                                              CAP043
      ** Define key lists for retrieving records from work file                               CAP043
                                                                                              CAP043
     C     KDTSCList     KLIST                                                                CAP043
     C                   KFLD                    APFOAsocID                                   CAP043
     C                   KFLD                    WOurTheir                                    CAP043
     C                   KFLD                    WRatePay                                     CAP043
                                                                                              CAP043
     C     KCFPCList     KLIST                                                                CAP043
     C                   KFLD                    APFOAsocID                                   CAP043
     C                   KFLD                    WOurTheir                                    CAP043

      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                CAP011
      ** Access API ICD via access program                                      CAP011
      *  (database error handling done in access program)                       CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      '*DBERR '     @RTCD             7            CAP011
     C                   PARM      '*FIRST '     @OPTN             7            CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011

      ** Access Dealing details                                                               245692
                                                                                              245692
     C                   CALL      'AODEALR1'                                                 245692
     C                   PARM      '*DBERR '     @RTCD                                        245692
     C                   PARM      '*FIRST '     @OPTN                                        245692
     C     SDDEAL        PARM      SDDEAL        DSFDY                                        245692
                                                                                              245692
     C     @RTCD         IFNE      *BLANKS                                                    245692
     C     *LOCK         IN        LDA                                                        245692
     C                   EVAL      DBFILE = 'SDDEALPD'                                        245692
     C                   EVAL      DBASE = 916                                                245692
     C                   EVAL      DBKEY = @OPTN                                              245692
     C                   OUT       LDA                                                        245692
     C                   EXSR      *PSSR                                                      245692
     C                   ENDIF                                                                245692
                                                                                              245692
      ** Call Access Program for FRA/IRS I.C.D. details
      *
     C                   CALLB     'AOFAISR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFAIS        PARM      SDFAIS        DSFDY
     C*
                                                                                CAP004
      ** ACCESS SAR DETAILS FOR Interest Rate Calendars                         CAP004
      *                                                                         CAP004
     C                   CALL      'AOSARDR0'                                   CAP004
     C                   PARM      *BLANKS       @RTCD                          CAP004
     C                   PARM      '*VERIFY'     @OPTN                          CAP004
     C                   PARM      'CIR001'      @SARD             6            CAP004
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP004
      *                                                                         CAP004
      * DATABASE ERROR                                                          CAP004
      *                                                                         CAP004
     C     @RTCD         IFNE      *BLANKS                                      CAP004
     C     @RTCD         ANDNE     '*NRF   '                                    CAP004
     C                   MOVEL     'CIR001'      DBKEY                          CAP004
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************CAP004
     C                   MOVEL     '905'         DBASE                          * DBERR 905 *CAP004
     C                   EXSR      *PSSR                                        *************CAP004
     C                   END                                                    CAP004
     C*                                                                         CAP004
     C     @RTCD         IFEQ      *BLANK                                       CAP004
     C                   MOVEL     'Y'           CIR001            1            CAP004
     C                   ELSE                                                   CAP004
     C                   MOVEL     'N'           CIR001                         CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  Access SAR details file to determine if Bus. Day Convention is on.    CIR005
      *                                                                         CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
      *                                                                         CIR005
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '      CIR005
     C     *LOCK         IN        LDA                                          CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   Z-ADD     906           DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   OUT       LDA                                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   IF        @RTCD = *BLANKS                              CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      **  Access SAR details file to determine if CIR003 is installed.                        CIR003
      *                                                                                       CIR003
     C                   CALL      'AOSARDR0'                                                 CIR003
     C                   PARM      *BLANKS       @RTCD                                        CIR003
     C                   PARM      '*VERIFY'     @OPTN                                        CIR003
     C                   PARM      'CIR003'      @SARD                                        CIR003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR003
      *                                                                                       CIR003
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '                    CIR003
     C     *LOCK         IN        LDA                                                        CIR003
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR003
     C                   Z-ADD     907           DBASE                                        CIR003
     C                   MOVEL     'CIR003'      DBKEY                                        CIR003
     C                   OUT       LDA                                                        CIR003
     C                   EXSR      *PSSR                                                      CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   IF        @RTCD = *BLANKS                                            CIR003
     C                   MOVEL     'Y'           CIR003            1                          CIR003
     C                   ELSE                                                                 CIR003
     C                   MOVEL     'N'           CIR003                                       CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR008
      **  Access SAR details file to determine if CIR008 is installed.                        CIR008
                                                                                              CIR008
     C                   CALL      'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       @RTCD                                        CIR008
     C                   PARM      '*VERIFY'     @OPTN                                        CIR008
     C                   PARM      'CIR008'      @SARD                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '                    CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE = 908                                                CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
     C                   OUT       LDA                                                        CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        @RTCD = *BLANKS                                            CIR008
     C                   EVAL      CIR008 = 'Y'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      CIR008 = 'N'                                               CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      **  Access SAR details file to determine if CAP056 is installed.                        CAP056
                                                                                              CAP056
     C                   CALL      'AOSARDR0'                                                 CAP056
     C                   PARM      *BLANKS       @RTCD                                        CAP056
     C                   PARM      '*VERIFY'     @OPTN                                        CAP056
     C                   PARM      'CAP056'      @SARD                                        CAP056
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP056
                                                                                              CAP056
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '                    CAP056
     C     *LOCK         IN        LDA                                                        CAP056
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP056
     C                   EVAL      DBASE = 909                                                CAP056
     C                   EVAL      DBKEY = 'CAP056'                                           CAP056
     C                   OUT       LDA                                                        CAP056
     C                   EXSR      *PSSR                                                      CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP056
     C                   IF        @RTCD = *BLANKS                                            CAP056
     C                   EVAL      CAP056 = 'Y'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   EVAL      CAP056 = 'N'                                               CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP056
      *                                                                                       CAP041
      **  Access SAR details file to determine if CAP041 is installed.                        CAP041
      *                                                                                       CAP041
     C                   CALL      'AOSARDR0'                                                 CAP041
     C                   PARM      *BLANKS       @RTCD                                        CAP041
     C                   PARM      '*VERIFY'     @OPTN                                        CAP041
     C                   PARM      'CAP041'      @SARD                                        CAP041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '                    CAP041
     C     *LOCK         IN        LDA                                                        CAP041
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP041
     C                   Z-ADD     908           DBASE                                        CAP041
     C                   MOVEL     'CAP041'      DBKEY                                        CAP041
     C                   OUT       LDA                                                        CAP041
     C                   EXSR      *PSSR                                                      CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD = *BLANKS                                            CAP041
     C                   MOVEL     'Y'           CAP041            1                          CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     'N'           CAP041                                       CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      **  Access SAR details file to determine if CEU003 is installed.                        CAP041
      *                                                                                       CAP041
     C                   CALL      'AOSARDR0'                                                 CAP041
     C                   PARM      *BLANKS       @RTCD                                        CAP041
     C                   PARM      '*VERIFY'     @OPTN                                        CAP041
     C                   PARM      'CEU003'      @SARD                                        CAP041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '                    CAP041
     C     *LOCK         IN        LDA                                                        CAP041
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP041
     C                   Z-ADD     909           DBASE                                        CAP041
     C                   MOVEL     'CEU003'      DBKEY                                        CAP041
     C                   OUT       LDA                                                        CAP041
     C                   EXSR      *PSSR                                                      CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD = *BLANKS                                            CAP041
     C                   MOVEL     'Y'           CEU003            1                          CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     'N'           CEU003                                       CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      **  Access SAR details file to determine if CIR002 is installed.                        CAP041
      *                                                                                       CAP041
     C                   CALL      'AOSARDR0'                                                 CAP041
     C                   PARM      *BLANKS       @RTCD                                        CAP041
     C                   PARM      '*VERIFY'     @OPTN                                        CAP041
     C                   PARM      'CIR002'      @SARD                                        CAP041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '                    CAP041
     C     *LOCK         IN        LDA                                                        CAP041
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP041
     C                   Z-ADD     910           DBASE                                        CAP041
     C                   MOVEL     'CIR002'      DBKEY                                        CAP041
     C                   OUT       LDA                                                        CAP041
     C                   EXSR      *PSSR                                                      CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD = *BLANKS                                            CAP041
     C                   MOVEL     'Y'           CIR002            1                          CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     'N'           CIR002                                       CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      **  Access SAR details file to determine if CIR006 is installed.                        CAP041
      *                                                                                       CAP041
     C                   CALL      'AOSARDR0'                                                 CAP041
     C                   PARM      *BLANKS       @RTCD                                        CAP041
     C                   PARM      '*VERIFY'     @OPTN                                        CAP041
     C                   PARM      'CIR006'      @SARD                                        CAP041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '                    CAP041
     C     *LOCK         IN        LDA                                                        CAP041
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP041
     C                   Z-ADD     911           DBASE                                        CAP041
     C                   MOVEL     'CIR006'      DBKEY                                        CAP041
     C                   OUT       LDA                                                        CAP041
     C                   EXSR      *PSSR                                                      CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD = *BLANKS                                            CAP041
     C                   MOVEL     'Y'           CIR006            1                          CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     'N'           CIR006                                       CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      **  Access SAR details file to determine if CIR007 is installed.                        CAP041
      *                                                                                       CAP041
     C                   CALL      'AOSARDR0'                                                 CAP041
     C                   PARM      *BLANKS       @RTCD                                        CAP041
     C                   PARM      '*VERIFY'     @OPTN                                        CAP041
     C                   PARM      'CIR007'      @SARD                                        CAP041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '                    CAP041
     C     *LOCK         IN        LDA                                                        CAP041
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP041
     C                   Z-ADD     912           DBASE                                        CAP041
     C                   MOVEL     'CIR007'      DBKEY                                        CAP041
     C                   OUT       LDA                                                        CAP041
     C                   EXSR      *PSSR                                                      CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD = *BLANKS                                            CAP041
     C                   MOVEL     'Y'           CIR007            1                          CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     'N'           CIR007                                       CAP041
     C                   ENDIF                                                                CAP041
      *  Initialise Data queue name
     C                   EVAL      DtaQName = 'APCIRSDTQ'
     C*

      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 908                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Check if CAP043 is installed                                                         CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRtCd                                        CAP043
     C                   PARM      '*VERIFY'     POptn                                        CAP043
     C                   PARM      'CAP043'      PSard                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
                                                                                              CAP043
     C                   IF        PRtCd = *Blanks                                            CAP043
     C                   EVAL      CAP043 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CAP043 = 'N'                                               CAP043
                                                                                              CAP043
     C                   IF        PRtCd <> '*NRF'                                            CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKEY = 'CAP043'                                           CAP043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP043
     C                   EVAL      DBASE = 915                                                CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      **********                                                                        247888248452
      ***Check*if*CLE025*is*installed                                                   247888248452
      **********                                                                        247888248452
     C**********         CALL      'AOSARDR0'                                           247888248452
     C**********         PARM      *BLANKS       @RTCD                                  247888248452
     C**********         PARM      '*VERIFY'     @OPTN                                  247888248452
     C**********         PARM      'CLE025'      @SARD                                  247888248452
     C*****SCSARD        PARM      SCSARD        DSFDY                                  247888248452
      **********                                                                        247888248452
     C*****@RTCD         IFEQ      *BLANK                                               247888248452
     C**********         MOVEL     'Y'           CLE025            1                    247888248452
     C**********         ELSE                                                           247888248452
     C**********         MOVEL     'N'           CLE025                                 247888248452
     C**********         ENDIF                                                          247888248452
      **********                                                                        247888248452
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRCIRSC023

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
