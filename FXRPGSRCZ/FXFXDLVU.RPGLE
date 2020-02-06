     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX validate and update')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange ILE Module                          *
      *                                                               *
      *  FXFXDLVU - FX Foreign Exchange  validate and update          *
      *                                                               *
      *  Function: This Program Validates FX FXDL for                 *
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
      *  Last Amend No. MD039547           Date 20Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD047971           Date 16Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 MD044506           Date 28Mar17               *
      *                 CSW216             Date 14Mar16               *
      *                 CSW214             Date 25Nov14               *
      *                 MD030956           Date 24Nov14               *
      *                 MD030841           Date 03Oct14               *
      *                 MD030436           Date 01Oct14               *
      *                 MD027337A          Date 01Oct14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD027337           Date 19Aug14               *
      *                 MD023535           Date 18Nov13               *
      *                 MD023259           Date 05Nov13               *
      *                 CSD095             Date 08Apr14               *
      *                 MD020624           Date 19Dec13               *
      *                 MD024185           Date 19Dec13               *
      *                 MD023734           Date 30Nov13               *
      *                 MD022708           Date 08Oct13               *
      *                 MD022496           Date 23Sep13               *
      *                 MD021933           Date 04Sep13               *
      *                 MD021962           Date 27Aug13               *
      *                 CSW213             Date 03Jun13               *
      *                 AR1064516          Date 08Feb13               *
      *                 CDL091             Date 12Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CSW212             Date 03May12               *
      *                 AR971184A          Date 22Jun12               *
      *                 AR971184           Date 28May12               *
      *                 AR678928           Date 05Jan11               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 261692             Date 19Nov09               *
      *                 259924A            Date 29May09               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23473           Date 20Mar09               *
      *                 CER043             Date 19May08               *
      *                 BUG27841           Date 09Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 254420             Date 20May08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22271           Date 23Jan09               *
      *                 256564             Date 17Sep08               *
      *                 247266             Date 21Jun07               *
      *                 249963             Date 29Aug0t               *
      *                 244537             Date 17Aug05               *
      *                 BUG13284           Date 09Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242477             Date 27Sep06               *
      *                 CDL049             Date 07Jul06               *
      *                 CGL058             Date 30Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG8119            Date 20Oct05               *
      *                 BUG7032R           Date 03Jun05               *
      *                 BUG7032            Date 09May05               *
      *                 BUG6555            Date 15Apr05               *
      *                 BUG4562            Date 15Mar05               *
      *                 BUG5517            Date 19Jan05               *
      *                 BUG5227            Date 24Nov04               *
      *                 BUG4815            Date 24Nov04               *
      *                 BUG4742            Date 19Nov04               *
      *                 BUG4834            Date 26Oct04               *
      *                 BUG4305            Date 09Nov04               *
      *                 BUG4728            Date 05Nov04               *
      *                 BUG3992            Date 01Oct04               *
      *                 BUG4482            Date 29Sep04               *
      *                 BUG4087            Date 26Aug04               *
      *                 CFX114             Date 15Jun04               *
      *                 BUG2899            Date 02Jun04               *
      *                 BUG2930            Date 01Jun04               *
      *                 BUG2789            Date 21May04               *
      *                 CTI004             Date 12Apr04               *
      *                 BUG617             Date 28Apr04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 22Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039547 - Referred account is not properly validated.       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD047971 - Do not allow amendment to settlement account if   *
      *             that side is already netted.                      *     
      *  CDL099 - Split Value Date                                    *
      *  MD044506 - MT300 98D trade execution date can not be before  *
      *             value date.                                       *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  MD030841 - Receive Bank to Bank info reset to blank upon     *
      *             Confirm Complete. Add missed out codes of CDL094  *
      *             during BFM2.1 SP6 incorporation.                  *
      *  MD030436 - Enhance fix MD027337A to the cater defaulting of  *
      *             settlement from '00' to SSI details.              *
      *  MD027337A - Settlement details are not being re-defaulted    *
      *              during amend.                                    *
      *            - Applied for MD030436.                            *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *  MD027337 - Settlement details are not being defaulted during *
      *             amend.                                            *
      *  MD023535 - Unexpected error during deletion of FX and MM     *
      *             deals                                             *
      *  MD023259 - FX: Front Office ID erased by the system          *
      *             during edit                                       *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD020624 - Amended validation sequence during amendment.     *
      *           - Applied for MD23981.                              *
      *  MD024185 - Serious midas error encountered when link swap id *
      *             of first leg swap is blank and non-blank for the  *
      *             second leg swap.                                  *
      *  MD023734 - Clearing Threshold Indicator not defaulted.       *
      *  MD022708 - Reports generated for unauthorised transactions   *
      *  MD022496 - Settlement Confirmation Tab not defaulted.        *
      *  MD021933 - Link Swap ID, UTI Namespace, and Transaction ID   *
      *             of the 2nd leg swap deal not defaulted from       *
      *             first leg swap deal.                              *
      *  MD021962 - Inputs in settlement confirmation screen are      *
      *             cleared when RPIF tabs are clicked.               *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  AR1064516 - FO transactions ID (Error on Delete of FX deal)  *
      *  CDL091 - FX Auto Calculation (GIB016)                        *
      *           Added hook CDL091_015                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  AR971184A- During Amend Front Ofc Id must be updated with the*
      *             new one                                           *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *  AR678928 - Pass *FRONT during MQ API to find the deal number *
      *             using FOID. (Child: AR678929)                     *
      *           - Adjusted start position to get DDFOID DDAFID due  *
      *             to changes of CSF011 in FXFXDLPD                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  261692 - Amended so that system can get the associated       *
      *           front office ID from JAVA.                          *
      *  259924A- Amended so that system can get the front office ID  *
      *           from Java.                                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT025 Corrected the parsing of DDFOID to match      *
      *           buffer                                              *
      *         - LT033B Customer info must be defaulted properly     *
      *  BUG23473 - Duplicate error shown in FXDL when Option to Date *
      *             for Option Deal is missing.  (Recompile)          *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  BUG27841 - Status changes to Requires Reauthorisation        *
      *             during Delete Action.                             *
      *  254420 - Validate value date against the back value period   *
      *           defined in PF/SDBANKPD.                             *
      *  BUG22271 - Unable to perform Auto-authorize Delete           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247266 - When deal is reversed, save it as unauthorised.     *
      *  249963 - Parse DDFOID correctly from Buffer.                 *
      *  244537 - To avoid overriding front office identifier.        *
      *  BUG13284 - Error Msg appears when authorising trades         *
      *  242477 - Applied fix 200709.  Incorrect deals update due to  *
      *           authorisation of 2nd leg of swap before authorising *
      *           the 1st leg.  Prevent authorisation of the 2nd leg  *
      *           if 1st leg is not yet authorised.                   *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL058 - Default Branch Code                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG8119 - Fields returned incorrectly from API if update     *
      *            flag set to 'Y' but data is invalid.               *
      *  BUG7032R- Validate transaction before defaulting the         *
      *            settlement details.                                *
      *  BUG7032- Pass the Buy Net and Sell Net indicators to         *
      *           ZASETINDFT.                                         *
      *  BUG6555- Check for CLS when applying SSIs or validating SIns *
      *  BUG4562- Retrieve TRAM details                               *
      *  BUG5517- Authorisation Error on FXDL.  Retrieve contents of  *
      *           DTAARA/ZMUSER moved out of INZSR                    *
      *  BUG5227- Automatic authorisation required.                   *
      *  BUG4815- Rationalise parameters for FXFXDLVU call.           *
      *  BUG4742- Re-do fix for BUG4834, as the fix is not correct.   *
      *  BUG4834- Record updated by another WS message if             *
      *           authorizing from WIP                                *
      *  BUG4305- Only call AOTIINR0 if TI is switched on             *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  BUG3992- Call new program FXFXDLVLP to perform post          *
      *           settlement detail validation. Revalidate dates.     *
      *  BUG4482 - Authorise should call Validate to show all the     *
      *            warning errors.                                    *
      *  BUG4087- Stopping users updating the same record at the same *
      *           time.                                               *
      *  CFX114 - Core changes for GBO014                             *
      *         - Perform Override when Exchange Rate Tolerance is    *
      *           exceeded.                                           *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added: FXFXDLXD01,FXFXDLXC02,            *
      *                             FXFXDLXC03,FXFXDLXC04,FXFXDLXC05  *
      *           Core hooks amended:FXFXDLM01                        *
      *  BUG2899 - Clear warning message arrays for TI deals          *
      *  BUG2930 - Setup Automatic Authorisation flag for TI deals    *
      *  BUG2789 - System testing for CTI004 development              *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           FX Deals Integration                                *
      *  BUG617 - Retrieve deal status for Authorisation and Delete   *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
     FDLRPIFL0  UF   E           K DISK    RENAME(DLRPIFD0:DLRPIF00)                        MD024185
     F                                     PREFIX(SW_)                                      MD024185

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

      *                                                                                       CER043
      ** External DS for Customer Details                                                     CER043
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER043
      *                                                                                       CER043
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

      ** Array of Fields in error.                                                           BUG4742
     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG4742
                                                                                             BUG4742
      ** Array of error message IDs                                                          BUG4742
     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG4742
     D                                     LIKE(#MsgID)                                      BUG4742
                                                                                             BUG4742
      ** Array of error message data.                                                        BUG4742
     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG4742
     D                                     LIKE(#MsgData)                                    BUG4742
                                                                                             BUG4742
      ** Array of message files to check                                                     BUG4742
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG4742
                                                                                             BUG4742
      ** Array message for RPIF                                                               CSW213
     D DFldNameArr     S             10A   DIM(ArrayMax)                                      CSW213
     D DMsgIDArr       S              7A   DIM(ArrayMax)                                      CSW213
     D DMsgDtaArr      S             45A   DIM(ArrayMax)                                      CSW213
     D DWFldNamArr     S             10A   DIM(ArrayMax)                                      CSW213
     D DWMsgIDArr      S              7A   DIM(ArrayMax)                                      CSW213
     D DWMsgDtaArr     S             45A   DIM(ArrayMax)                                      CSW213
                                                                                              CSW213
      * Array to hold Commitment Job Names                                                    CSC022
     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** Commitment Control Data Area                                                         CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitJob              4    103                                                       CSC022
                                                                                              CSC022
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

     D TranIn        E DS                  EXTNAME(FXFXDLPD)
      * Incoming Transaction

     D InfData       E DS                  EXTNAME(FXFXIFPD)
     D                                     PREFIX(IF_)
      * FX (FXDL) Extra Data - File (D/B) format

     D ValidDeal     E DS                  EXTNAME(FXVFXDLPD)
      * Valid Deals layout
     D*FXDLRecIns************400    468                                                       CGL029
     D*FXDLPayIns************469   1027                                                       CGL029
     D FXDLRecIns            414    468                                                       CGL029
     D FXDLPayIns            483   1027                                                       CGL029
     D FXDLPayIsda          1394   2043                                                       CSW212
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)

     D DealFilFmt    E DS                  EXTNAME(FXDEALPP)
      * (Current) Deal in File Format
     D  FileMORI     E                     EXTFLD(QQMORI)                                     CGL029
     D  FileDORI     E                     EXTFLD(QQDORI)                                     CGL029
     D  FileMOPI     E                     EXTFLD(QQMOPI)                                     CGL029
     D  FileDOPI     E                     EXTFLD(QQDOPI)                                     CGL029
     D  FileRONS     E                     EXTFLD(QQRONS)                                     CGL029
     D  FilePONS     E                     EXTFLD(QQPONS)                                     CGL029
     D***DEALRecIns           400    468                                                      CGL029
     D***DEALPayIns           469   1027                                                      CGL029
     D DEALRecIns            414    468                                                       CGL029
     D DEALPayIns            483   1027                                                       CGL029
     D DEALPayIsda          1394   2043                                                       CSW212
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
                                                                                              CSW213
      ** Define data structure for InSwift2013                                                CSW213
     D InSwift2013     DS                                                                     CSW213
     D  DLRPIFS1In                         LIKE(DLRPIFScn1Fmt)                                CSW213
     D  DLRPIFS2In                         LIKE(DLRPIFScn2Fmt)                                CSW213
     D  DLRPIFS3In                         LIKE(DLRPIFScn3Fmt)                                CSW213
     D  DLRPIFS4In                         LIKE(DLRPIFScn4Fmt)                                CSW214
                                                                                              CSW213
      ** Define data structure for OutSwift2013                                               CSW213
     D OutSwift2013    DS                                                                     CSW213
     D  DLRPIFS1Out                        LIKE(DLRPIFScn1Fmt)                                CSW213
     D  DLRPIFS2Out                        LIKE(DLRPIFScn2Fmt)                                CSW213
     D  DLRPIFS3Out                        LIKE(DLRPIFScn3Fmt)                                CSW213
     D  DLRPIFS4Out                        LIKE(DLRPIFScn4Fmt)                                CSW214
                                                                                              CSW213
      ** Midas DL Dealing Reporting Information file                                          CSW213
     D DLRPIFScn1Fmt E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D DLRPIFScn2Fmt E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D DLRPIFScn3Fmt E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D DLRPIFScn4Fmt E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D DLRPIFFileFmt E DS                  EXTNAME(DLRPIFPD)                                  CSW213
     D DLRILKPDIn    E DS                  EXTNAME(DLRILKPD)                                  CSW213
     D DLVRPIFileFmt E DS                  EXTNAME(DLVRPIPD)                                  CSW213
     D DLRIS1PDOut   E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D                                     PREFIX(OUT)                                        CSW213
     D DLRIS2PDOut   E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D                                     PREFIX(OUT)                                        CSW213
     D DLRIS3PDOut   E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D                                     PREFIX(OUT)                                        CSW213
     D DLRIS4PDOut   E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D                                     PREFIX(OUT)                                        CSW214
                                                                                              CSW213
      ** RPIF Error File - Screen 1                                                           CSW213
     D DLError1      E DS                  EXTNAME(DLERI1PD)                                  CSW213
                                                                                              CSW213
      ** RPIF Error File - Screen 2                                                           CSW213
     D DLError2      E DS                  EXTNAME(DLERI2PD)                                  CSW213
                                                                                              CSW213
      ** RPIF Error File - Screen 3                                                           CSW213
     D DLError3      E DS                  EXTNAME(DLERI3PD)                                  CSW213

      ** RPIF Error File - Screen 4                                                           CSW214
     D DLError4      E DS                  EXTNAME(DLERI4PD)                                  CSW214
                                                                                              CSW214
     D DealScnFmt    E DS                  EXTNAME(FXFXDLPD)
     D                                     PREFIX(@)
      * (Current) Deal in Screen Format

      * Pay settlement instructions - current                                              MD027337A
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)                     MD027337A
                                                                                           MD027337A
      * Receive settlement instructions - current                                          MD027337A
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)                     MD027337A
                                                                                           MD027337A
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions - Input

     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions - Input

     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions - Input

     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
      * Pay Settlement Instructions - File (D/B) format
     D FLPAY2                 21    565                                                       CGL029

     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
      * Receive Settlement Instructions - File (D/B) format
     D FLREC2                 21     75                                                       CGL029

     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
      **FRA/IRS*Settlement*Instructions*-*File*(D/B)*format************                       CSW212
      ** Extended Settlement Instructions - File (D/B) format                                 CSW212
     D FLISDA2                 1    650                                                       CSW212

     D ExtData       E DS                  EXTNAME(FXFXEXPD)
      * FX Extra Data - File (D/B) format

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      * Second DS for Access programs - long data structure                                   CGL029
                                                                                              CGL029
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
                                                                                             BUG2789
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                 BUG2789
      **  Midas Modules Details                                                              BUG2789
                                                                                              CTI004
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)                                  CTI004
      **  TI ICD FIle                                                                         CTI004

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD status data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)


     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
                                                                                              CDL099
     D InCDL099      E DS                  EXTNAME(FXDLEXPD)                                  CDL099
      * FX Deal Extra Data Layout Definition (input)                                          CDL099
                                                                                              CDL099
     D OutCDL099     E DS                  EXTNAME(FXDLEXPD)                                  CDL099
     D                                     PREFIX(@)                                          CDL099
      * FX Deal Extra Data Layout Definition (output)                                         CDL099

      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
      *                                                                                       CER043
      ***Customers*Extension*Screen*Format*based*on*SDCUCUPD                           CER043 CSF011
     D*TranInCust****E*DS                  EXTNAME(SDCUCUPD)                           CER043 CSF011
      *                                                                                       CER043
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

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Field (500A) to receive the incoming transaction
     D Trans500        S            500A

      ** Field (500A) to receive the incoming Extra Data                                     BUG4815
     D InfData500      S            500A                                                     BUG4815
                                                                                             BUG4815
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
      *                                                                                       CER043
      ***Field*(500A)*to*receive*the*incoming*Customer*details                         CER043 CSF011
     D*Trans500C       S            500A                                               CER043 CSF011

      ** Field (500A) to receive CDL099 Split Date w/ extra data layout                       CDL099
     D ExtDta500       S            500A                                                      CDL099
                                                                                              CDL099
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDActnOK                      1A   INZ('Y')
     D  DDDlnoOK                      1A   INZ('Y')
     D  DDDltpOK                      1A   INZ('Y')
     D  DDDlstOK                      1A   INZ('Y')
     D  DDFedfOK                      1A   INZ('Y')
     D  DDDldtOK                      1A   INZ('Y')
     D  DDBrsnOK                      1A   INZ('Y')
     D  DDBrkrOK                      1A   INZ('Y')
     D  DDBkrgOK                      1A   INZ('Y')
     D  DDSdnoOK                      1A   INZ('Y')
     D  DDCustOK                      1A   INZ('Y')
     D  DDVdatOK                      1A   INZ('Y')
     D  DDOdatOK                      1A   INZ('Y')
     D  DDBokcOK                      1A   INZ('Y')
     D  DDLnknOK                      1A   INZ('Y')
     D  DDPtfrOK                      1A   INZ('Y')
     D  DDBccyOK                      1A   INZ('Y')
     D  DDBamtOK                      1A   INZ('Y')
     D  DDNbuyOK                      1A   INZ('Y')
     D  DDRateOK                      1A   INZ('Y')
     D  DDFpntOK                      1A   INZ('Y')
     D  DDSignOK                      1A   INZ('Y')
     D  DDMginOK                      1A   INZ('Y')
     D  DDMbsiOK                      1A   INZ('Y')
     D  DDSccyOK                      1A   INZ('Y')
     D  DDSamtOK                      1A   INZ('Y')
     D  DDPrfcOK                      1A   INZ('Y')
     D  DDNselOK                      1A   INZ('Y')
     D  DDBceOK                       1A   INZ('Y')
     D  DDOrbrOK                      1A   INZ('Y')
     D  DDDbsrOK                      1A   INZ('Y')
     D  DDBbfpOK                      1A   INZ('Y')
     D  DDBbfsOK                      1A   INZ('Y')
     D  DDSbfpOK                      1A   INZ('Y')
     D  DDSbfsOK                      1A   INZ('Y')
     D  DDMtchOK                      1A   INZ('Y')
     D  DDCLSSOK                      1A   INZ('Y')                                           CDL038
     D  DDOylcOK                      1A   INZ('Y')                                           CDL038
     D  DDTylcOK                      1A   INZ('Y')                                           CDL038
     D  DDClasOK                      1A   INZ('Y')                                           CDL038

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

     D  DDRmacOK                      1A   INZ('Y')                                         MD030841
     D  DDRexrOK                      1A   INZ('Y')                                         MD030841
     D  DDRexiOK                      1A   INZ('Y')                                         MD030841
     D  DDRbb1OK                      1A   INZ('Y')                                         MD030841
     D  DDRbb2OK                      1A   INZ('Y')                                         MD030841
     D  DDRbb3OK                      1A   INZ('Y')                                         MD030841
     D  DDRbb4OK                      1A   INZ('Y')                                         MD030841
     D  DDRbb5OK                      1A   INZ('Y')                                         MD030841
     D  DDRbb6OK                      1A   INZ('Y')                                         MD030841

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

      ** A code to indicate the calling function to the lower level modules
     D FXDL            S              4A   INZ('FXDL')

      ** Payment & Receipt dates, passed to Settlements Validation routine.
      ** spaces in parameter list not used by this function
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)

      ** Value Date as a Midas Day Number to be placed in either Payment
      **  or Receipt Date
     D ValDateMDN      S              5P 0

      ** Blank fields, passed to Settlements Defaulting routine, to fill
      ** spaces in parameter list not used by this function
     D Blank2          S              2A   INZ(*BLANKS)
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)

      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')

      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D RecNostro       S             18A                                                      CDL038
     D*RecNostro*******S             12A                                                      CDL038
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             18A                                                      CDL038
     D*PayNostro*******S             12A                                                      CDL038

     D PSard           S              6A   INZ(*BLANK)

      ** SARs
     D CSC011          S              1A

      ** Work variables for CSC022                                                            CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wCommitSkip     S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
      ** Deal Front Office ID                                                                 CTI004
     D DDFOID          S             20                                                       CTI004
      ** Deal Associated Front Office ID                                                      261692
     D DDAFID          S             20                                                       261692
                                                                                              CTI004
     D OVERRIDE        S              1                                                       CFX114
     D SOVRO           S             10                                                       CFX114
     D SPWRD           S             10                                                       CFX114
      ** Timestamp                                                                           BUG4087
     D @Timestamp      S             26                                                      BUG4087
                                                                                             BUG4087
     D CGL058          S              1A   INZ('N')                                          CGL058
      ** Work Variables for DLRPIFR                                                           CSW213
     D ValScrnNo       S              1  0                                                    CSW213
     D PRetCode        S             10                                                       CSW213
     D PModeOp         S              6                                                       CSW213
     D PTranRefOK      S              1                                                       CSW213
     D DFOfcrIDOK      S              1                                                       CSW213
     D WNoRepFlag      S              1                                                       CSW213
     D CSW213          S              1                                                       CSW213
     D CtrX            S              3S 0                                                    CSW213
     D RIdx            S              3P 0                                                    CSW213
     D WRIdx           S              3P 0                                                    CSW213
     D DUpdateYN       S              1A                                                      CSW213
                                                                                              CSW213
     D***ValueDate        S              5P 0                                     MD027337 MD027337A
     D/COPY WNCPYSRC,FXFXDLXD01
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

     D*CER043***       S              1A                                               CER043 CSF011
      *                                                                                       CER043
      ** Parameters for Calling AOCUSTR0                                                      CER043
     D PRtcd           S              7A                                                      CER043
     D POptn           S              7A                                                      CER043
     D PCNum           S             10A                                                      CER043
     D PKey7           S              7A                                                      CER043
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                                                      BUG5517
      **  Get default branch and user from ZMUSER                                            BUG5517
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5517
     C                   IN        ZMUSER                                                    BUG5517
     C                   UNLOCK    ZMUSER                                                    BUG5517
      *                                                                                      BUG5517
      ** Set Front Office ID = User ID                                                       BUG5517
     C**********         EVAL      APFOTranID = %SUBST(PUSRID:1:3)                  BUG5517 AR971184

     C                   MOVEL     Trans500      TranIn
     C**********         EVAL      DDFOID = %SUBST(Trans500:293:20)                   BUG2789 244537
     C**********         EVAL      DDFOID = %SUBST(Trans500:297:20)                    244537 249963
     C**********         EVAL      DDFOID = %SUBST(Trans500:311:20)                    249963 CER043
     C**********         EVAL      DDFOID = %SUBST(Trans500:298:20)                    CER043 CER059
     C**********         EVAL      DDFOID = %SUBST(Trans500:312:20)                  CER059 AR678928
     C**********         EVAL      DDAFID = %SUBST(Trans500:332:20)                  261692 AR678928
     C**********         EVAL      DDFOID = %SUBST(Trans500:352:20)               AR678928 AR971184A
     C**********         EVAL      DDAFID = %SUBST(Trans500:372:20)               AR678928 AR971184A
     C**********         EVAL      APFOTranID = DDFOID                              259924A AR971184
     C**********         EVAL      APFOASOCID = DDAFID                               261692 AR971184
     C                   EVAL      DDFOID = %SUBST(Trans500:352:20)                         MD023259
     C                   EVAL      DDAFID = %SUBST(Trans500:372:20)                         MD023259
     C                   EVAL      APFOTranID = DDFOID                                      MD023535
     C                   EVAL      APFOASOCID = DDAFID                                      MD023535
     C**********         IF        APFOTranID <> *BLANKS                          AR971184A MD023535
     C**********         EVAL      DDFOID = APFOTranID                             AR971184 MD023535
     C**********         EVAL      DDAFID = APFOASOCID                             AR971184 MD023535
     C**********         ENDIF                                                    AR971184A MD023535
     C/COPY WNCPYSRC,FXFXDLXC02
     C**********         MOVEL     Trans500C     TranInCust                            CER043 CSF011
     C                   MOVEL     InfData500    InfData                                     BUG4815
     C**********         MOVEL     Extdata500    Extdata                                     BUG4815
     C                   MOVEL     ExtData500    ExtData                                     BUG4815
     C                   EVAL      DLRPIFScn1Fmt = DLRPIFS1In                                 CSW213
     C                   EVAL      DLRPIFScn2Fmt = DLRPIFS2In                                 CSW213
     C                   EVAL      DLRPIFScn3Fmt = DLRPIFS3In                                 CSW213
     C                   EVAL      DLRPIFScn4Fmt = DLRPIFS4In                                 CSW214
      *                                                                                       CDL099
     C                   EVAL      InCDL099 = ExtDta500                                       CDL099

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      ** Set Auto Authorise flag for transactions from TI                                    BUG2789
     C                   If        BGN3ST = 'Y'                                              BUG2789
     C                             AND DDDLST = TIDLST                                       BUG2789
     C                   Eval      IF_AUTH = 'Y'                                             BUG2789
     C                   Eval      F3AUTH = IF_AUTH                                          BUG2930
     C                   EndIf                                                               BUG2789
      *                                                                                      BUG2789
      *  Validate Action Code

     C                   EXSR      ValidateAc

      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END

                                                                                             BUG4562
      *                                                                                      BUG4562
      * Retrieve TRAM details                                                                BUG4562
      *                                                                                      BUG4562
     C                   EXSR      FXFXDLRTT                                                 BUG4562
                                                                                             BUG4562
      *  Processing depends upon Action Code

     C**********         MOVE      '0'           *IN50                               247266 BUG27841
     C                   SELECT

     C                   WHEN      DDACTN = 'I'
      *  Processing for Inserts
      *  Set up transaction details before defaulting the settlements.                      BUG7032R
     C**********         EXSR      DftSettmts                                               BUG7032R
      *                                                                                       CGL058
      ** Correct Defaulting of Branch Code                                                    CGL058
      *                                                                                       CGL058
     C                   IF        CGL058 = 'Y' and DDACTN = 'I'                              CGL058
     C                   EXSR      VBBBRCD                                                    CGL058
     C                   ENDIF                                                                CGL058
      *                                                                                       CGL058
     C                   EXSR      ValidateTr
     C                   EXSR      DftSettmts                                               BUG7032R
     C                   EXSR      ValidateSt
     C                   EXSR      ValidateLP                                                BUG3992

     C                   WHEN      DDACTN = 'A'
      *  Processing for Amends
     C                   EXSR      SetupAmend
     C**********         EXSR      ValdateAmd                                               MD020624
     C                   EXSR      ValidateTr
     C                   EXSR      ValdateAmd                                               MD020624
     C                   EXSR      ValidateSt
     C                   EXSR      ValidateLP                                                BUG3992

     C                   WHEN      DDACTN = 'X'                                               BUG617
      *  Processing for Authorisations                                                        BUG617
     C                   EXSR      FXFXDLCVT                                                  BUG617
     C                   EXSR      ValidateTr                                                BUG4482
     C                   EXSR      ValidateSt                                                BUG4482
     C                   EXSR      ValidateLP                                                BUG3992
      *                                                                                       BUG617
     C                   WHEN      DDACTN = 'D'                                               BUG617
      *  Processing for Deletes                                                               BUG617
     C                   EXSR      FXFXDLCVT                                                  BUG617
     C**********         IF        FHDSTS = 'A'  and UpdateYN = 'Y'                  247266 BUG27841
     C**********         IF        IF_AUTH = 'Y'                                   BUG22271 BUG27841
     C**********         EVAL      F3DSTS = 'R'                                    BUG22271 BUG27841
     C**********         ELSE                                                      BUG22271 BUG27841
     C**********         EVAL      F3LACT = 'A'                                      247266 BUG27841
     C**********         MOVE      '1'           *IN50                               247266 BUG27841
     C**********         ENDIF                                                     BUG22271 BUG27841
     C**********         ENDIF                                                       247266 BUG27841
      *                                                                                       BUG617
     C                   ENDSL
                                                                                              CER059
     C     INVALID       TAG                                                                  CER059
      **********                                                                       CER043 CSF011
      ***Population*of*Customer*Details********************************                CER043 CSF011
     C**********         IF        CER043 = 'Y'                                        CER043 CSF011
     C**********         EXSR      SrPopCust                                           CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
                                                                                              CSF011
     C                   EXSR      SrCustName                                                 CSF011
                                                                                              CSW213
      ** Call DLRPIFVU - Midas DL Reporting Information Validate and Update                   CSW213
                                                                                              CSW213
     C                   IF        CSW213 = 'Y' AND                                           CSW213
     C                             UpDateYN <> 'Y'                                            CSW213
     C                   EXSR      SrFXDLvu                                                   CSW213
     C                   ENDIF                                                                CSW213
      *
     C*****INVALID       TAG                                                                  CER059
                                                                                             BUG2899
      ** Reset warning error arrays for deals from TI                                        BUG2899
     C                   If        BGN3ST = 'Y'                                              BUG2899
     C                             AND DDDLST = TIDLST                                       BUG2899
     C                   RESET                   WFldNamArr                                  BUG2899
     C                   RESET                   WMsgIDArr                                   BUG2899
     C                   RESET                   WMsgDtaArr                                  BUG2899
     C                   RESET                   WIdx                                        BUG2899
     C                   EndIf                                                               BUG2899

      *  Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF

     C                   SETON                                        LR

      ** If action is for Update, get the correct record information                         BUG4742
      ** from file                                                                           BUG4742
     C                   IF        UpdateYN = 'Y'                                            BUG4742
     C                             AND Idx = 0                                               BUG8119
     C                   MOVE      F3DN38        DDDLNO_In                                   BUG4742
     C                   CALL      'FXFXDLR'                                                 BUG4742
     C                   PARM                    @AuthComp         1                         BUG4742
     C                   PARM                    @FwdBck           1                         BUG4742
     C                   PARM                    DDDLNO_In         6                         BUG4742
     C                   PARM                    Buffer                                      BUG4742
     C                   PARM                    @FldNameArr                                 BUG4742
     C                   PARM                    @MsgIDArr                                   BUG4742
     C                   PARM                    @MsgDtaArr                                  BUG4742
     C                   PARM                    @MsgFArray                                  BUG4742
     C                   PARM                    @APIRetC          1                         BUG4742
     C                   MOVEL     DDACTN        Buffer                                      BUG4742
     C                   ELSE                                                                BUG4742
     C                   EVAL                    Buffer = TranIN
     C                                           + DDNBRF     + DDNSRF
     C                                           + DDSTS      + BNNMAM
     C**********                                 + BJLCCY                                     CTI004
     C                                           + BJLCCY     + DDFOID                        CTI004
     C                                           + DDAFID                                     261692
     C                                           + OVERRIDE + SOVRO                           CFX114
     C                                           + SPWRD                                      CFX114
     C                                           + CPST     + DSPCP                          BUG4562
     C                                           + BKST     + DSPBK                          BUG4562
     C                                           + @Timestamp                                BUG4087
     C**********                                 + TranInCust                          CER043 CSF011
     C                                           + InRecSttmt + InPaySttmt
     C                                           + InFRASttmt                                 CSW212
     C**********                                 + ExtData                                    CTI004
     C                                           + InfData    + ExtData                       CTI004
     C                                           + OutSwift2013                               CSW213
     C                                           + InCDL099                                   CDL099
     C                   ENDIF                                                               BUG4742

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************

     C     ValidateAc    BEGSR

      ***Set*retrieve*mode*to*'*FRONT'*(Access*using*Front*Office*ID)             AR678928 AR1064516
      ***Otherwise                                                                AR678928 AR1064516
      ***Set*retrieve*mode*to*blank*(Access*using*Midas*transaction*ID)           AR678928 AR1064516
     C*****APFOTranID    IFNE      *BLANKS                                        AR678928 AR1064516
     C**********         MOVEL     '*FRONT'      ModeofOp                         AR678928 AR1064516
     C**********         ELSE                                                     AR678928 AR1064516
     C**********         MOVEL     '      '      ModeofOp                         AR678928 AR1064516
     C**********         ENDIF                                                    AR678928 AR1064516
      **********                                                                  AR678928 AR1064516
                                                                                            MD023535
     C     APFOTranID    IFNE      *BLANKS                                                  MD023535
     C     DDDLNO        ANDEQ     *BLANKS                                                  MD023535
     C                   MOVEL     '*FRONT'      ModeofOp                                   MD023535
     C                   ELSE                                                               MD023535
     C                   MOVEL     '      '      ModeofOp                                   MD023535
     C                   ENDIF                                                              MD023535
                                                                                            MD023535
      * Validate action code versus transaction IDs supplied
      * This function will set the Midas deal number and the Midas
      * associated deal number.
      * The deal in file format from the FX database is retrieved as well.

     C                   RESET                   ReturnCode
     C                   CALLB     'FXFXDLRTV'

      * INPUTS

      * Return code
     C                   PARM                    ReturnCode

      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
     C**********         PARM      '      '      ModeofOp          6                        AR678928
     C**********         PARM                    ModeofOp          6              AR678928 AR1064516
     C**********         PARM      '      '      ModeofOp          6              AR1064516 MD023535
     C                   PARM                    ModeofOp          6                        MD023535
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE

      * Action Code
     C                   PARM                    DDACTN

      * Front Office Transaction ID
     C                   PARM                    APFOTranID

      * Front Office Associated Transaction Id
     C                   PARM                    APFOAsocID

      * (Midas) Deal Number
     C                   PARM                    DDDLNO

      * (Midas) Swap/Option Deal Number
     C                   PARM                    DDSDNO

      * Booking branch
     C                   PARM                    DDBRSN

      * Originating branch
     C                   PARM                    DDORBR

      * OUTPUTS

      * (Current) deal in file format
     C                   PARM                    DealFilFmt

      * OK - Action code
     C                   PARM                    DDActnOK

      * OK - Deal Number
     C                   PARM                    DDDlnoOK

      * OK - Booking branch
     C                   PARM                    DDBrsnOK
      *
      * OK - Originating branch
     C                   PARM                    DDOrbrOK

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning error fields/message IDs/message data (arrays) from/to caller

     C                   PARM      *BLANKS       WFldNamArr
     C                   PARM      *BLANKS       WMsgIdArr
     C                   PARM      *BLANKS       WMsgDtaArr

      ** Warning array index (3P0) from/to caller

     C                   PARM      *ZEROS        WIdx
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

     C**********         IF            (InRecSttmt = *blank)                                MD027337
     C**********                   AND (InPaySttmt = *blank)                                MD027337
     C                   IF            (DDRSTM = *blank)                                    MD027337
     C                             AND (DDPSTM = *blank)                                    MD027337
     C                             AND (InFRASttmt = *blank)                                MD021962
     C                             AND DDACTN = 'I'                                        MD027337A
     C                             OR  DDACTN = 'A'                                        MD027337A
     C                             AND InFRASttmt = *BLANK                                 MD027337A
     C                             AND (DDRSTM = *BLANK                                    MD027337A
     C                             OR  DDPSTM = *BLANK)                                    MD027337A

      ** CL Transaction type for CLS                                                         BUG6555
                                                                                             BUG6555
     C                   IF        CDL008 = 'Y' AND DDCLSS = 'Y'                             BUG6555
     C                   EVAL      DealType = 'CL'                                           BUG6555
     C                   ELSE                                                                BUG6555
     C                   EVAL      DealType = DDDLTP                                         BUG6555
     C                   ENDIF                                                               BUG6555
                                                                                             BUG6555
      ** Pass Buy Net and Sell Net Indicators.                                               BUG7032
     C                   MOVEL     DDNBUY        BuySelInd                                   BUG7032
     C                   MOVE      DDNSEL        BuySelInd                                   BUG7032
      *                                                                                      BUG7032
     C/COPY WNCPYSRC,FXH00029
     C                   CALLB     'ZASETINDFT'

      ** Output
      ** Calling function type
     C                   PARM                    FXDL
      ** Payment currency
     C                   PARM                    DDSCCY
      ** Receive currency
     C                   PARM                    DDBCCY
      ** Customer (shortname or number)
     C                   PARM                    DDCUST
      ** Deal type
     C**********         PARM                    DDDLTP                                      BUG6555
     C                   PARM                    DealType          2                         BUG6555
      ** Federal Funds Ind.
     C                   PARM                    DDFEDF
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    Blank4
      ** Type of ISDA agreement
     C                   PARM                    Blank6
      ** Date of ISDA Agreement
     C                   PARM                    Blank6X           6
      ** Version of ISDA Agreement
     C                   PARM                    Blank2
      *
      ** Version century of ISDA Agreement
     C**********         PARM                    Blank2X           2                         BUG7032
      ** Buy Net and Sell Net Indicators.                                                    BUG7032
     C                   PARM                    BuySelInd         2                         BUG7032
      ** Deal Subtype                                                                         CSD095
     C                   PARM                    DDDLST                                       CSD095
      ** Branch                                                                               CSD095
     C                   PARM                    DDBRSN                                       CSD095
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

     C/COPY WNCPYSRC,FXH00030
     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt

      ** Defaulted Settlement Instruction in input format
     C**********         PARM                    InPaySttmt                                MD027337A
     C**********         PARM                    InRecSttmt                                MD027337A
     C                   PARM                    CrPaySttmt                                MD027337A
     C                   PARM                    CrRecSttmt                                MD027337A
     C                   PARM                    InFRASttmt
     C                   PARM      DDBCCY        #TRCCY            3                         CSF011A
     C                   PARM      DDBCCY        #TPCCY            3                         CSF011A

     C                   ENDIF
                                                                                           MD027337A
     C                   IF            (DDPSTM = *blank)                                   MD027337A
     C                   EVAL      InPaySttmt = CrPaySttmt                                 MD027337A
     C                   ENDIF                                                             MD027337A
                                                                                           MD027337A
     C                   IF            (DDRSTM = *blank)                                   MD027337A
     C                   EVAL      InRecSttmt = CrRecSttmt                                 MD027337A
     C                   ENDIF                                                             MD027337A
      *                                                                                      BUG7032
     C                   MOVEL     *BLANKS       BuySelInd                                   BUG7032

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

      * For Amends, put the complete (pre-existing) deal into the Valid
      *  file record - fields in this will be updated during  processing
     C                   MOVE      DealFilFmt    ValidDeal
      *****************************************************************           MD027337 MD027337A
      ***Convert*DDVDAT*to*Midas*Day*number****************************           MD027337 MD027337A
      *****************************************************************           MD027337 MD027337A
     C**********         CALLB     'ZDATE1'                                       MD027337 MD027337A
     C**********         PARM                    DDVDAT                           MD027337 MD027337A
     C**********         PARM                    ValueDate                        MD027337 MD027337A
     C**********         PARM                    BJDFIN                           MD027337 MD027337A
     C**********         PARM                    ErrorFlag                        MD027337 MD027337A

      *  The Settlement Instructions fields may not be supplied for an
      *  amendment. If none of the pay/receive instructions were
      *  supplied (i.e. all are blank), default the existing database
      *  values into the special DB Settlement Instructions DSs ....

     C**********         IF            (InRecSttmt = *blank)                                MD027337
     C**********                   AND (InPaySttmt = *blank)                                MD027337
     C**********         IF            (DDRSTM = *blank)                          MD027337 MD027337A
     C**********                   AND ValueDate < BJRDNB                         MD027337 MD027337A
     C**********                   OR  (DDPSTM = *blank)                          MD027337 MD027337A
     C**********                   AND ValueDate < BJRDNB                         MD027337 MD027337A
     C                   IF            (InRecSttmt = *blank)                               MD027337A
     C                             AND (InPaySttmt = *blank)                               MD027337A
     C                             AND (FLPSTM <> 00 and FLRSTM <> 00)                      MD030436

     C**********         EVAL      DBRecSttmt = DEALRecIns + FHROBR                           CGL029
     C                   EVAL      FLRSTM     = FHRSTM                                        CGL029
     C                   EVAL      FLRONS     = FHRONS                                        CGL029
     C                   EVAL      FLREC2     = DEALRecIns                                    CGL029
     C                   EVAL      FLROBR     = FHROBR                                        CGL029
     C                   EVAL      FLRSCY     = FHRSCY
     C**********         EVAL      DBPaySttmt = DEALPayIns + FHPOBR + FHCVMR                  CGL029
     C                   EVAL      FLPSTM     = FHPSTM                                        CGL029
     C                   EVAL      FLPONS     = FHPONS                                        CGL029
     C                   EVAL      FLPAY2     = DEALPayIns                                    CGL029
     C                   EVAL      FLPOBR     = FHPOBR                                        CGL029
     C                   EVAL      FLCVMR     = FHCVMR                                        CGL029
     C                   EVAL      FLPSCY     = FHPSCY
     C                   EVAL      FLIC72     = FHIC72
     C                   EVAL      FLRBB1     = FHRBB1                                      MD030841
     C                   EVAL      FLRBB2     = FHRBB2                                      MD030841
     C                   EVAL      FLRBB3     = FHRBB3                                      MD030841
     C                   EVAL      FLRBB4     = FHRBB4                                      MD030841
     C                   EVAL      FLRBB5     = FHRBB5                                      MD030841
     C                   EVAL      FLRBB6     = FHRBB6                                      MD030841
      *
     C                   IF        CSW212 = 'Y'                                               CSW212
     C                   MOVEL     FLISDA2       DEALPayIsda                                  CSW212
     C                   ENDIF                                                                CSW212

      *  .... and then convert these to the screen format
     C                   CALLB     'ZASETINCVT'

      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt

      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      FHCCY1        #TRCCY                                      CSF011A
     C                   PARM      FHCCY2        #TPCCY                                      CSF011A

     C                   ELSE                                                               MD027337
                                                                                           MD027337A
     C                   IF        DDRSTM = *BLANK                                         MD027337A
     C                             OR DDPSTM = *BLANK                                      MD027337A
     C                   EXSR      DftSettmts                                               MD027337
     C                   ENDIF                                                             MD027337A
                                                                                           MD027337A
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main tranaction details  *
      *                                                               *
      *****************************************************************

     C     ValidateTr    BEGSR

     C                   CALLB     'FXFXDLVAL'
      * Response mode (1A), from source system common header
     C                   PARM      'S'           APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    InfData
      * Receive Settlement Currency, Method & Nostro and
      * Payment Settlement Currency, Method & Nostro
      * Extra Data
     C                   PARM      *BLANK        RecSetCcy
     C                   PARM      *ZERO         RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM      *BLANK        PaySetCcy
     C                   PARM      *ZERO         PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    FrontOffice      20
     C                   PARM                    ExtData
      *
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF
     C                   PARM                    DDNSRF
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
     C                   PARM                    F3DTYP                                       242477
     C                   PARM                    InCDL099                                     CDL099
     C/COPY WNCPYSRC,FXFXDLXC03
      *                                                                                       CTI004
     C                   If        DDFOID <> *blanks                                          CTI004
     C                   Eval      F3FRNT = DDFOID                                            CTI004
     C                   EndIf                                                                CTI004
      *                                                                                       254420
     C     Idx           IFNE      0                                                          254420
     C                   GOTO      INVALID                                                    254420
     C                   END                                                                  254420

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG3992
      *                                                               *                      BUG3992
      * ValidateLP - Re-Validate dates after the settlement details   *                      BUG3992
      *              have been determined.                            *                      BUG3992
      *                                                               *                      BUG3992
      *****************************************************************                      BUG3992
                                                                                             BUG3992
     C     ValidateLP    BEGSR                                                               BUG3992
                                                                                             BUG3992
      * Initialise parameter fields                                                          BUG3992
     C                   MOVEL     DDRSTM        RecSetMeth                                  BUG3992
     C                   MOVEL     DDPSTM        PaySetMeth                                  BUG3992
     C                   MOVEL     DDRONX        RecNostro                                   BUG3992
     C                   MOVEL     DDPONX        PayNostro                                   BUG3992
                                                                                             BUG3992
     C                   CALLB     'FXFXDLVLP'                                               BUG3992
      * Response mode (1A), from source system common header                                 BUG3992
     C                   PARM      'S'           APRespMode                                  BUG3992
      * Transaction information (DS) from source system                                      BUG3992
     C                   PARM                    TranIn                                      BUG3992
     C                   PARM                    InfData                                     BUG3992
      * Receive Settlement Currency, Method & Nostro and                                     BUG3992
      * Payment Settlement Currency, Method & Nostro                                         BUG3992
      * Extra Data                                                                           BUG3992
     C                   PARM      DDRSCY        RecSetCcy                                   BUG3992
     C                   PARM                    RecSetMeth                                  BUG3992
     C                   PARM                    RecNostro                                   BUG3992
     C                   PARM      DDPSCY        PaySetCcy                                   BUG3992
     C                   PARM                    PaySetMeth                                  BUG3992
     C                   PARM                    PayNostro                                   BUG3992
     C                   PARM                    FrontOffice      20                         BUG3992
     C                   PARM                    ExtData                                     BUG3992
      *                                                                                      BUG3992
      * NET BUY/SELL REFERENCE                                                               BUG3992
     C                   PARM                    DDNBRF                                      BUG3992
     C                   PARM                    DDNSRF                                      BUG3992
      * Field OK flags (DS) from/to caller                                                   BUG3992
     C                   PARM                    OKFlagsDS                                   BUG3992
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG3992
     C                   PARM                    FldNameArr                                  BUG3992
     C                   PARM                    MsgIDArr                                    BUG3992
     C                   PARM                    MsgDtaArr                                   BUG3992
      * Array index (3P0) from/to caller                                                     BUG3992
     C                   PARM                    Idx                                         BUG3992
      * Warning fields/message IDs/message data (arrays) from/to caller                      BUG3992
     C                   PARM                    WFldNamArr                                  BUG3992
     C                   PARM                    WMsgIDArr                                   BUG3992
     C                   PARM                    WMsgDtaArr                                  BUG3992
      * Array index (3P0) from/to caller                                                     BUG3992
     C                   PARM                    WIdx                                        BUG3992
      * Valid Deals layout (DS) from/to caller                                               BUG3992
     C                   PARM                    ValidDeal                                   BUG3992
                                                                                             BUG3992
     C                   ENDSR                                                               BUG3992
                                                                                             BUG3992
      *****************************************************************                      BUG3992
      /EJECT                                                                                 BUG3992
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************

     C     ValidateSt    BEGSR

      * The called module requires that the customer number/name is valid,
      *  if it is not, exit from this subroutine.
     C                   IF        NOT (DDCustOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF

      * The called module uses the value date in Midas Day Number format,
      *  which will not have been returned from the overall validation
      *  routine, so it needs to be converetd here.

     C                   IF        DDVDatOK <> 'N'

     C                   CALLB     'ZDATE1'
     C                   PARM                    DDVDAT
     C                   PARM                    ValDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag

      * Set the Pay Date and Receive Date = Value Date

     C                   EVAL      PayDat = ValDateMDN
     C                   EVAL      RecDat = ValDateMDN

     C                   ENDIF
                                                                                             BUG6555
      ** CL Transaction type for CLS                                                         BUG6555
                                                                                             BUG6555
     C                   IF        CDL008 = 'Y' AND DDCLSS = 'Y'                             BUG6555
     C                   EVAL      DealType = 'CL'                                           BUG6555
     C                   ELSE                                                                BUG6555
     C                   EVAL      DealType = DDDLTP                                         BUG6555
     C                   ENDIF                                                               BUG6555
                                                                                             BUG6555

     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'

      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    FXDL
      ** Transaction Fields
      ** Payment currency
     C                   PARM                    DDSCCY
      ** Receive currency
     C                   PARM                    DDBCCY
      ** Customer (shortname or number)
     C                   PARM                    DDCUST
      ** Deal type
     C**********         PARM                    DDDLTP                                      BUG6555
     C                   PARM                    DealType                                    BUG6555
      ** Federal Funds Ind.
     C                   PARM                    DDFEDF
      ** Booking Branch
     C                   PARM                    DDBRSN
      ** Receipt Date
     C                   PARM                    RecDat
      ** Payment Date
     C                   PARM                    Paydat
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt

      * Action Code
     C                   PARM                    DDACTN
      * Protect Payment Field
     C                   PARM                    ##PPAY            1
      * Protect Receipt Field
     C                   PARM                    ##PREC            1

      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
      *                                                                                     MD039547
      ** Call account referred validation.                                                  MD039547
      *                                                                                     MD039547
     C                   CALL      'ZASETINVL2'                                             MD039547
     C                   PARM                    ReturnCode                                 MD039547
     C                   PARM                    FXDL                                       MD039547
     C                   PARM                    DDSCCY                                     MD039547
     C                   PARM                    DDBCCY                                     MD039547
     C                   PARM                    DDCUST                                     MD039547
     C                   PARM                    DDBRSN                                     MD039547
     C                   PARM                    InPaySttmt                                 MD039547
     C                   PARM                    InRecSttmt                                 MD039547
     C                   PARM                    DDACTN                                     MD039547
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

     C     ValSetExit    TAG

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

      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT

     C                   RESET                   ReturnCode
     C                   CALLB     'FXFXDLCVT'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt

      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF           19
     C                   PARM                    DDNSRF           19
      * Deal Status
     C                   PARM                    DDSTS            24
     C                   PARM                    OutCDL099                                    CDL099

      ** AMEND CHECKING
     C                   RESET                   ReturnCode
     C                   CALLB     'FXFXDLAMD'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranIn
      * (Current) Deal in Screen Format
     C                   PARM                    DealScnfmt
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
      *                                                                                     MD047971
      ** Pay/rcv settlement account                                                         MD047971
      *                                                                                     MD047971
     C                   PARM                    DDRONX                                     MD047971
     C                   PARM                    DDPONX                                     MD047971
     C                   PARM                    DDRONXOK                                   MD047971
     C                   PARM                    DDPONXOK                                   MD047971

      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
     C                   PARM                    InCDL099                                     CDL099
     C                   PARM                    OutCDL099                                    CDL099

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR

     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDEALN
     C                   ENDIF

     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF

     C                   ENDSR
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustname - Get the Customer details                         *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustName    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer Number                                                                     CSF011A
                                                                                             CSF011A
     C                   IF        DDCUST <> *BLANKS                                         CSF011A
     C                   EVAL      PCnum = DDCUST                                            CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
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

     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKFRAInsDS

     C                   RESET                   PayDat
     C                   RESET                   RecDat

     C                   CLEAR                   ValidDeal
      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields
     C                   Z-ADD     *ZERO         F3RSTM
     C**********         Z-ADD     *ZERO         F3ROBN                                       CSD027
     C**********         Z-ADD     *ZERO         F3ROCN                                       CSD027
     C                   EVAL      F3ROBN = *BLANKS                                           CSD027
     C                   EVAL      F3ROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         F3PSTM
     C**********         Z-ADD     *ZERO         F3POBN                                       CSD027
     C**********         Z-ADD     *ZERO         F3POCN                                       CSD027
     C                   EVAL      F3POBN = *BLANKS                                           CSD027
     C                   EVAL      F3POCN = *BLANKS                                           CSD027

      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt

      * Reset Net Buy/sell Reference

     C                   CLEAR                   DDNBRF
     C                   CLEAR                   DDNSRF
                                                                                             CSF011A
     C                   EVAL      DDCRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCRTN = *BLANKS                                          CSF011A

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPDEALN - Set up Deal Number for Inserts                   *
      *                                                               *
      *****************************************************************

     C     SETUPDEALN    BEGSR

     C                   IF           DDDLNO = *blanks
     C                             OR DDDLNO = *zeros

     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDDLNO
     C                   PARM      *ZEROS        F3DN38

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDlnoOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      ** If deal number was entered, put it in the file field
     C                   ELSE
     C                   MOVE      DDDLNO        F3DN38

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

      * For Inserts & Amends, put the Settlement Instructions (input or defaulted)
      *  into the Valid file record
      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
      *  in contiguous areas, which must be placed into the correct parts
      *  of the Valid file record
     C                   IF        DDACTN = 'I'
     C                             OR DDACTN = 'A'
     C*******************MOVEL     DBPaySttmt    FXDLPayIns                                   CGL029
     C*******************MOVEL     DBRecSttmt    FXDLRecIns                                   CGL029
     C                   MOVEL     FLRSTM        F3RSTM                                       CGL029
     C                   MOVEL     FLRONS        F3RONS                                       CGL029
     C                   MOVEL     FLREC2        FXDLRecIns                                   CGL029
     C                   MOVEL     FLPSTM        F3PSTM                                       CGL029
     C                   MOVEL     FLPONS        F3PONS                                       CGL029
     C                   MOVEL     FLPAY2        FXDLPayIns                                   CGL029
     C                   MOVE      FLPOBR        F3POBR
     C                   MOVE      FLROBR        F3ROBR
     C                   MOVE      FLCVMR        F3CVMR
     C                   MOVE      FLPSCY        F3PSCY
     C                   MOVE      FLRSCY        F3RSCY
     C                   MOVE      FLIC72        F3IC72
     C                   MOVEL     FLRBB1        F3RBB1                                     MD030841
     C                   MOVEL     FLRBB2        F3RBB2                                     MD030841
     C                   MOVEL     FLRBB3        F3RBB3                                     MD030841
     C                   MOVEL     FLRBB4        F3RBB4                                     MD030841
     C                   MOVEL     FLRBB5        F3RBB5                                     MD030841
     C                   MOVEL     FLRBB6        F3RBB6                                     MD030841
      *
     C                   IF        CSW212 = 'Y'                                               CSW212
     C                   MOVEL     FLISDA2       FXDLPayIsda                                  CSW212
      *                                                                                       CSW212
     C                   IF        FLISDA = *BLANKS                                           CSW212
     C                   Z-ADD     *ZERO         F3ISDA                                       CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
     C                   IF        FLAGDT = *BLANKS                                           CSW212
     C                   Z-ADD     *ZERO         F3AGDT                                       CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
     C                   IF        FLAGVV = *BLANKS                                           CSW212
     C                   Z-ADD     *ZERO         F3AGVV                                       CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
     C                   IF        FLAGVC = *BLANKS                                           CSW212
     C                   Z-ADD     *ZERO         F3AGVC                                       CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
     C                   ENDIF                                                                CSW212
     C                   ENDIF

      * For Amends, put the pre-existing Settlement Instructions into
      *  the Valid file record
      * Two large fields (one Pay, one Receive) do most of this but a few
      *  (physically separate) fields also need to be done

      * For Deletes & Authorises, put the complete (pre-existing) deal
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVE      DealFilFmt    ValidDeal
     C                   ENDIF

      * Set Valid file field(s) that are needed for all Action Codes
     C**********         If        *IN50 = '0'                                       247266 BUG27841
     C                   EVAL      F3LACT = DDACTN
     C**********         Else                                                        247266 BUG27841
     C**********         EVAL      F3LACT = 'A'                                      247266 BUG27841
     C**********         EVAL      F3TMESTMP = FHTMST                                247266 BUG27841
     C**********         Endif                                                       247266 BUG27841
                                                                                             BUG5227
      * Include Header fields that need to be o/p to the Valid file                           261692
     C**********         If        APFOTranID <> ' ' and                            261692 AR971184A
     C**********                   DDACTN = 'I'                                     261692 AR971184A
     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
     C                   EVAL      F3FRNT = APFOTranID                                        261692
     C                   EVAL      F3AFRT = APFOAsocID                                        261692
     C                   EVAL      F3REPA = APRprLocn                                         261692
     C                   EVAL      DDFOID = APFOTranID                                     AR971184A
     C                   EndIf                                                                261692
      ** Set Auto Authorise flag for transactions from Interface                             BUG5227
     C                   IF        CAP051 = 'Y'                                              BUG5227
     C                   EVAL      F3AUTH = IF_AUTH                                          BUG5227
     C                   ENDIF                                                               BUG5227
      *                                                                                      BUG4087
      * Restore Timestamp from the original record                                           BUG4087
     C                   IF        DDACTN <> 'I'                                             BUG4087
     C****************             AND DDACTN <> 'X'                                 BUG4834 BUG4742
     C                             AND DDACTN <> 'X'                                        BUG13284
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C**********                   AND *IN50 = '0'                                   247266 BUG27841
     C                   MOVEL     @TimeStamp    F3TMESTMP                                   BUG4087
     C                   ENDIF                                                               BUG4087

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
      * FOREIGN EXCHANGE DATABASE UPDATES
      *
     C                   CALLB     'FXFXDLUPF'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    ValidDeal
     C/COPY WNCPYSRC,FXFXDLXC04
      *                                                                                     MD022496
     C**********         EVAL      F3CHTP = DDACTN                                 MD022496 MD022708
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'FXFXDLUPD'
     C                   PARM                    @RTCD
     C                   PARM                    ValidDeal
     C                   END
      *                                                                                       CSW213
      ** Call DLRPIFVU - Midas DL Reporting Information Validate and Update                   CSW213
      *                                                                                       CSW213
     C                   IF        CSW213 = 'Y'                                               CSW213
     C                   EXSR      SrFXDLvu                                                   CSW213
     C                   ENDIF                                                                CSW213
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   IF        RLDTYP = 'SW' AND                                        MD024185
     C                             RLLTRF <> *BLANKS AND                                    MD024185
     C                             RLACTN = 'I'                                             MD024185
     C     RPIFKey       CHAIN     DLRPIFL0                                                 MD024185
     C                   IF        %FOUND                                                   MD024185
     C                   EVAL      SW_RIDTYP = 'SW'                                         MD024185
     C                   EVAL      SW_RILNRF = RVTRRF                                       MD024185
     C                   IF        RVLSID <> *BLANKS                                        MD024185
     C                             AND SW_RILSID <> RVLSID                                  MD024185
     C                   EVAL      SW_RILSID = RVLSID                                       MD024185
     C                   ENDIF                                                              MD024185
     C                   UPDATE    DLRPIF00                                                 MD024185
     C                   ENDIF                                                              MD024185
     C                   ENDIF                                                              MD024185
     C                   END
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************                 BUG617
      *                                                                    *                 BUG617
      * Retrieve Status                                                    *                 BUG617
      *                                                                    *                 BUG617
      **********************************************************************                 BUG617
     C     FXFXDLCVT     BEGSR                                                               BUG617
                                                                                             BUG617
     C                   CALLB     'FXFXDLCVT'                                               BUG617
                                                                                             BUG617
      * INPUTS                                                                               BUG617
      * Return Code                                                                          BUG617
     C                   PARM      *BLANK        ReturnCode       10                         BUG617
      * (Current) Deal in file format                                                        BUG617
     C                   PARM                    DealFilfmt                                  BUG617
                                                                                             BUG617
      * OUTPUTS                                                                              BUG617
      * (Current) Deal in screen format                                                      BUG617
     C                   PARM                    DealScnfmt                                  BUG617
      * NET BUY/SELL REFERENCE                                                               BUG617
     C                   PARM                    DDNBRF           19                         BUG617
     C                   PARM                    DDNSRF           19                         BUG617
      * Deal Status                                                                          BUG617
     C                   PARM                    DDSTS            24                         BUG617
     C                   PARM                    OutCDL099                                    CDL099
                                                                                             BUG617
     C                   ENDSR                                                               BUG617
      **********************************************************************                 BUG617
      **********************************************************************                 BUG4562
     C     FXFXDLRTT     BEGSR                                                               BUG4562
                                                                                             BUG4562
     C                   CALLB     'FXFXDLRTT'                                               BUG4562
      *                                                                                      BUG4562
      * INPUTS                                                                               BUG4562
      *                                                                                      BUG4562
      * Return code                                                                          BUG4562
     C                   PARM      *BLANK        RetCodeIn        10                         BUG4562
      *                                                                                      BUG4562
      * Action Code                                                                          BUG4562
     C                   PARM                    DDACTN            1                         BUG4562
      *                                                                                      BUG4562
      * (Midas) Deal Number                                                                  BUG4562
     C                   PARM                    DDDLNO            6                         BUG4562
      *                                                                                      BUG4562
      * Broker                                                                               BUG4562
     C                   PARM                    DDBRKR            4                         BUG4562
      *                                                                                      BUG4562
      * OUTPUTS                                                                              BUG4562
      *                                                                                      BUG4562
      * OK - Action code                                                                     BUG4562
     C                   PARM      'Y'           DDActnOK          1                         BUG4562
      *                                                                                      BUG4562
      * Counterparty Status                                                                  BUG4562
     C                   PARM                    CPST              2                         BUG4562
     C                   PARM                    DSPCP             1                         BUG4562
      *                                                                                      BUG4562
      * Broker Status                                                                        BUG4562
     C                   PARM                    BKST              2                         BUG4562
     C                   PARM                    DSPBK             1                         BUG4562
      *                                                                                      BUG4562
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG4562
     C                   PARM                    FldNameArr                                  BUG4562
     C                   PARM                    MsgIdArr                                    BUG4562
     C                   PARM                    MsgDtaArr                                   BUG4562
      *                                                                                      BUG4562
      * Array index (3P0) from/to caller                                                     BUG4562
     C                   PARM                    Idx                                         BUG4562
                                                                                             BUG4562
      ** Warning error fields/message IDs/message data (arrays) from/to caller               BUG4562
                                                                                             BUG4562
     C                   PARM      *BLANKS       WFldNamArr                                  BUG4562
     C                   PARM      *BLANKS       WMsgIdArr                                   BUG4562
     C                   PARM      *BLANKS       WMsgDtaArr                                  BUG4562
                                                                                             BUG4562
      ** Warning array index (3P0) from/to caller                                            BUG4562
                                                                                             BUG4562
     C                   PARM      *ZEROS        WIdx                                        BUG4562
                                                                                             BUG4562
     C                   ENDSR                                                               BUG4562
      **********************************************************************                 BUG4562
      /EJECT                                                                                 BUG617
      *****************************************************************                       CGL058
      *  VBBBRCD  - Validate branch                                                           CGL058
      *****************************************************************                       CGL058
     C     VBBBRCD       BEGSR                                                                CGL058
      *                                                                                       CGL058
      ** Validate Booking and Originating Branch                                              CGL058
      *                                                                                       CGL058
     C                   CALLB     'FXVBBBRCD'                                                CGL058
      *                                                                                       CGL058
      ** Inputs                                                                               CGL058
      *                                                                                       CGL058
      ** Return Code                                                                          CGL058
      *                                                                                       CGL058
     C                   PARM                    DDACTN            1                          CGL058
     C                   PARM                    BJSBRC            3                          CGL058
     C                   PARM                    DDCUST           10                          CGL058
     C                   PARM                    DDBRSN            3                          CGL058
     C                   PARM                    DDORBR            3                          CGL058
                                                                                              CGL058
     C                   ENDSR                                                                CGL058
      ********************************************************************                    CGL058
      /EJECT                                                                                  CGL058
      ********************************************************************                    CGL058
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************                       CSW213
      * SrFXDLvu - Call DLRPIFVU - Reporting Information Validate     *                       CSW213
      *            and Update                                         *                       CSW213
      *****************************************************************                       CSW213
     C     SrFXDLvu      BEGSR                                                                CSW213
                                                                                              CSW213
      ** Set-up input fields                                                                  CSW213
                                                                                              CSW213
     C                   EVAL      RLAPID = 'FXDL'                                            CSW213
     C                   EVAL      RLACTN = DDACTN                                            CSW213
     C                   EVAL      RLBRCA = DDBRSN                                            CSW213
     C                   EVAL      RLTRRF = DDDLNO                                            CSW213
     C**********         EVAL      RLLTRF = DDLNKN                                   CSW213 MD021933
     C                   EVAL      RLLTRF = DDSDNO                                          MD021933
     C                   EVAL      RLDTYP = DDDLTP                                            CSW213
     C                   EVAL      RLDLST = DDDLST                                            CSW213
      *                                                                                     MD044506
      ** Change RLVALD from Value Date to Deal Date                                         MD044506
      *                                                                                     MD044506
     C**********         EVAL      RLVALD = DDVDAT                                   CSW213 MD044506
     C                   EVAL      RLVALD = DDDLDT                                          MD044506
      *                                                                                     MD044506
     C                   EVAL      RLCNUM = DDCUST                                            CSW213
     C                   EVAL      RLBCCY = DDBCCY                                            CSW213
     C                   EVAL      RLSCCY = DDSCCY                                            CSW213
     C                   EVAL      RLFOID = DDFOID                                            CSW213
                                                                                              CSW213
     C                   EVAL      ValScrnNo = 0                                              CSW213
                                                                                              CSW213
     C                   CALL      'DLRPIFVU'                                                 CSW213
     C                   PARM                    DLRILKPDIn                                   CSW213
     C                   PARM                    DLRPIFScn1Fmt                                CSW213
     C                   PARM                    DLRPIFScn2Fmt                                CSW213
     C                   PARM                    DLRPIFScn3Fmt                                CSW213
     C                   PARM                    DLRPIFScn4Fmt                                CSW214
     C                   PARM      *BLANKS       DFldNameArr                                  CSW213
     C                   PARM      *BLANKS       DMsgIDArr                                    CSW213
     C                   PARM      *BLANKS       DMsgDtaArr                                   CSW213
     C                   PARM      *ZERO         RIdx                                         CSW213
     C                   PARM      *BLANKS       DWFldNamArr                                  CSW213
     C                   PARM      *BLANKS       DWMsgIDArr                                   CSW213
     C                   PARM      *BLANKS       DWMsgDtaArr                                  CSW213
     C                   PARM      *ZERO         WRIdx                                        CSW213
     C                   PARM                    MsgFArray                                    CSW213
     C                   PARM                    DLRIS1PDOut                                  CSW213
     C                   PARM                    DLRIS2PDOut                                  CSW213
     C                   PARM                    DLRIS3PDOut                                  CSW213
     C                   PARM                    DLRIS4PDOut                                  CSW214
     C                   PARM      UpdateYN      DUpdateYN                                    CSW213
     C                   PARM                    APIRetc                                      CSW213
     C                   PARM                    ValScrnNo                                    CSW213
     C                   PARM                    DLVRPIFileFmt                                CSW213
     C                   PARM                    DLError1                                     CSW213
     C                   PARM                    DLError2                                     CSW213
     C                   PARM                    DLError3                                     CSW213
     C                   PARM                    DLError4                                     CSW214
     C                   PARM                    DDSAMT                                     MD023734
                                                                                              CSW213
      ** Set-up Error Messages from DLRPIFVU                                                  CSW213
                                                                                              CSW213
     C                   EVAL      CtrX = 1                                                   CSW213
     C                   IF        RIdx <> 0                                                  CSW213
     C                                                                                        CSW213
     C                   DOW       RIdx >= CtrX                                               CSW213
     C                   EVAL      Idx = Idx + 1                                              CSW213
     C                   EVAL      MsgIDArr(Idx) = DMsgIDArr(CtrX)                            CSW213
     C                   EVAL      FldNameArr(Idx) = DFldNameArr(CtrX)                        CSW213
     C                   EVAL      MsgDtaArr(Idx) = DMsgDtaArr(CtrX)                          CSW213
     C                   EVAL      CtrX = CtrX + 1                                            CSW213
     C                   ENDDO                                                                CSW213
     C                                                                                        CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
      ** Set-up Warning Message from DLRPIFVU                                                 CSW213
                                                                                              CSW213
     C                   EVAL      CtrX = 1                                                   CSW213
     C                   IF        WRIdx <> 0                                                 CSW213
     C                                                                                        CSW213
     C                   DOW       WRIdx >= CtrX                                              CSW213
     C                   EVAL      WIdx = WIdx + 1                                            CSW213
     C                   EVAL      WMsgIDArr(WIdx) = DWMsgIDArr(CtrX)                         CSW213
     C                   EVAL      WFldNamArr(WIdx) = DWFldNamArr(CtrX)                       CSW213
     C                   EVAL      WMsgDtaArr(WIdx) = DWMsgDtaArr(CtrX)                       CSW213
     C                   EVAL      CtrX = CtrX + 1                                            CSW213
     C                   ENDDO                                                                CSW213
     C                                                                                        CSW213
     C                   ENDIF                                                                CSW213
     C                                                                                        CSW213
     C                   EVAL      DLRPIFS1Out = DLRIS1PDOut                                  CSW213
     C                   EVAL      DLRPIFS2Out = DLRIS2PDOut                                  CSW213
     C                   EVAL      DLRPIFS3Out = DLRIS3PDOut                                  CSW213
     C                   EVAL      DLRPIFS4Out = DLRIS4PDOut                                  CSW214
                                                                                              CSW213
     C                   ENDSR                                                                CSW213
      *****************************************************************                       CSW213
      /EJECT                                                                                  CSW213
      *****************************************************************
      **********                                                      *                CER043 CSF011
      ***SrPopCust*-*Subroutine*to*Populate*Customer*Details***********                CER043 CSF011
      **********                                                      *                CER043 CSF011
      ***Called*by:*MAIN*Processing************************************                CER043 CSF011
      **********                                                      *                CER043 CSF011
      ***Calls:*SrRtvCust**********************************************                CER043 CSF011
      **********                                                      *                CER043 CSF011
      *****************************************************************                CER043 CSF011
      **********                                                                       CER043 CSF011
     C*****SrPopCust     BEGSR                                                         CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         CLEAR                   TranInCust                            CER043 CSF011
      **********                                                                       CER043 CSF011
      ***Retrieve*Customer*Details                                                     CER043 CSF011
     C**********         IF        DDCUST <> *BLANKS                                   CER043 CSF011
     C**********         EVAL      PCNum = DDCUST                                      CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         EXSR      SrRtvCust                                           CER043 CSF011
     C**********         IF        PRtcd = *BLANKS                                     CER043 CSF011
     C**********         EVAL      DDCSSN = BBCSSN                                     CER043 CSF011
     C**********         EVAL      DDCRNM = BBCRNM                                     CER043 CSF011
     C**********         EVAL      DDCRTN = BBCRTN                                     CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         ENDSR                                                         CER043 CSF011
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
      *                                                               *                       CER043
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CER043
      *                                                               *                       CER043
      *  Called by: SrPopCust                                         *                       CER043
      *                                                               *                       CER043
      *  Calls: None                                                  *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
     C     SrRtvCust     BEGSR                                                                CER043
      *                                                                                       CER043
      ** Call AOCUSTR0 to get Customer Details                                                CER043
     C                   CALLB     'AOCUSTR0'                                                 CER043
     C                   PARM      *BLANKS       PRtcd                                        CER043
     C                   PARM      '*KEY   '     POptn                                        CER043
     C                   PARM                    PCNum                                        CER043
     C                   PARM      *BLANKS       PKey7                                        CER043
     C     SDCUST        PARM      SDCUST        DSSDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS AND                                       CER043
     C                             PRTCD <> '*NRF   '                                         CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CER043
     C                   EVAL      DBASE = 905                                                CER043
     C                   EVAL      DBKEY = PCnum                                              CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
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
     C**********         PARM                    Trans500C                             CER043 CSF011
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    InfData500                                  BUG4815
     C                   PARM                    ExtData500
     C                   PARM                    InSwift2013                                  CSW213
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
     C                   PARM                    @Timestamp                                  BUG4087
     C                   PARM                    ExtDta500                                    CDL099

      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C/COPY OFCPYSRCZ,CDL091_015                                                              CDL091
     C/COPY WNCPYSRC,FXH00020

      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,FXFXDLM01

      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access Midas Module Details                                                         BUG2789
     C                   CALLB     'AOMMODR0'                                                BUG2789
     C                   PARM      '*MSG    '    @RTCD                                       BUG2789
     C                   PARM      '*FIRST  '    @OPTN                                       BUG2789
     C     SDMMOD        PARM      SDMMOD        DSFDY                                       BUG2789
      ** Database Error                                                                      BUG2789
      *                                                                                      BUG2789
     C     @RTCD         IFNE      *BLANK                                                    BUG2789
     C                   MOVEL     @OPTN         DBKEY                                       BUG2789
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************BUG2789
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *BUG2789
     C                   EXSR      *PSSR                                        *************BUG2789
     C                   END                                                                 BUG2789
      *                                                                                      BUG2789
      ** Access TI ICD Details via access program                                             CTI004
      *                                                                                       CTI004
     C     BGN3ST        IFEQ      'Y'                                                       BUG4305
     C     CTI006        OREQ      'Y'                                                      MD030956
     C                   CALL      'AOTIINR0'                                                 CTI004
     C                   PARM      '*DBERR'      @RTCD                                        CTI004
     C                   PARM      '*FIRST'      @OPTN                                        CTI004
     C     SDTIIN        PARM      SDTIIN        DSFDY                                        CTI004
     C                   ENDIF                                                               BUG4305
                                                                                              CTI004
      ***Set*Auto*Authorise*flag*for*transactions*from*TI                             CTI004 BUG2789
      **********                                                                      CTI004 BUG2789
     C**********         If        DDDLST = TIDLST                                    CTI004 BUG2789
     C**********         Eval      IF_AUTH = 'Y'                                      CTI004 BUG2789
     C**********         EndIf                                                        CTI004 BUG2789

      ** Check if CSC011 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD = *BLANKS
     C                   MOVE      'Y'           CSC011
     C                   IN        SC24X7
     C                   IN        SDSTAT

     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   IF        @RTCD <> '*NRF'
     C                   EVAL      DBKEY  = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 3
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CDL099
      ** Check if CDL099 is installed                                                         CDL099
      *                                                                                       CDL099
     C                   CALL      'AOSARDR0'                                                 CDL099
     C                   PARM      *BLANKS       @RTCD                                        CDL099
     C                   PARM      '*VERIFY'     @OPTN                                        CDL099
     C                   PARM      'CDL099'      PSARD                                        CDL099
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL099
      *                                                                                       CDL099
     C     @RTCD         IFEQ      *BLANK                                                     CDL099
     C                   MOVEL     'Y'           CDL099            1                          CDL099
     C                   ELSE                                                                 CDL099
     C                   MOVEL     'N'           CDL099                                       CDL099
     C                   IF        @RTCD <> '*NRF'                                            CDL099
     C                   EVAL      DBKEY  = 'CDL099'                                          CDL099
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL099
     C                   EVAL      DBASE  = 4                                                 CDL099
     C                   EXSR      *PSSR                                                      CDL099
     C                   ENDIF                                                                CDL099
     C                   ENDIF                                                                CDL099
      *                                                                                       CDL099
     C/COPY WNCPYSRC,FXFXDLXC05

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      ************                                                                           BUG5517
      ***Retrieve*ZMUSER details.                                                            BUG5517
      ************                                                                           BUG5517
     C******DTAARA       DEFINE                  ZMUSER                                      BUG5517
     C************       IN        ZMUSER                                                    BUG5517
      ************                                                                           BUG5517
      ***Set*Front Office ID = User ID                                                       BUG5517
     C************       EVAL      APFOTranID = %SUBST(PUSRID:1:3)                           BUG5517

      ** Access SAR details file to determine if Commitment Control                           CSC022
      ** Changes is switched on.                                                              CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   If        @RTCD = *BLANKS                                            CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Check if Current Job exists in the Commitment Job Names                              CSC022
      ** Data Area.                                                                           CSC022
     C                   MoveA     wComitJob     CmtJobNArr                                   CSC022
     C     PSJOBNAME     LookUp    CmtJobNArr                             20                  CSC022
     C                   If        *IN20                                                      CSC022
     C                   Eval      wCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      ** Database error                                                                       CSC022
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         In        LDA                                                        CSC022
     C                   Eval      DBKey = 'CSC022'                                           CSC022
     C                   Eval      DBPgm = 'FXFXDLVU'                                         CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBase = 904                                                CSC022
     C                   Out       LDA                                                        CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      *                                                                                      BUG5227
      ** Access SAR details file to determine if                                             BUG5227
      ** Automatic Authorisation is installed                                                BUG5227
      *                                                                                      BUG5227
     C                   MOVEL     'N'           CAP051            1                         BUG5227
     C                   CALL      'AOSARDR0'                                                BUG5227
     C                   PARM      *BLANKS       @RTCD                                       BUG5227
     C                   PARM      '*VERIFY'     @OPTN                                       BUG5227
     C                   PARM      'CAP051'      @SARD                                       BUG5227
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG5227
      *                                                                                      BUG5227
     C     @RTCD         IFEQ      *BLANK                                                    BUG5227
     C                   MOVEL     'Y'           CAP051                                      BUG5227
     C                   ENDIF                                                               BUG5227
                                                                                             BUG5227
      ** Set Auto Authorise flag for transactions from Interface                             BUG5227
     C                   If        CAP051 = 'Y'                                              BUG5227
     C                   Eval      F3AUTH = IF_AUTH                                          BUG5227
     C                   EndIf                                                               BUG5227
      *                                                                                       CSC022
      *                                                                                      BUG6555
      ** Access SAR details file to determine if                                             BUG6555
      ** Continuous Linked Settlement is installed                                           BUG6555
      *                                                                                      BUG6555
     C                   CALL      'AOSARDR0'                                                BUG6555
     C                   PARM      *BLANKS       @RTCD                                       BUG6555
     C                   PARM      '*VERIFY'     @OPTN                                       BUG6555
     C                   PARM      'CDL008'      @SARD                                       BUG6555
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG6555
      *                                                                                      BUG6555
     C     @RTCD         IFEQ      *BLANK                                                    BUG6555
     C                   MOVEL     'Y'           CDL008            1                         BUG6555
     C                   ELSE                                                                BUG6555
     C                   MOVEL     'N'           CDL008                                      BUG6555
     C                   ENDIF                                                               BUG6555
      *                                                                                      BUG6555
      ** Access SAR details file to determine if                                              CGL058
      ** Default Branch code is installed                                                     CGL058
      *                                                                                       CGL058
     C                   CALL      'AOSARDR0'                                                 CGL058
     C                   PARM      *BLANKS       @RTCD                                        CGL058
     C                   PARM      '*VERIFY'     @OPTN                                        CGL058
     C                   PARM      'CGL058'      @SARD                                        CGL058
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL058
      *                                                                                       CGL058
     C     @RTCD         IFEQ      *BLANK                                                     CGL058
     C                   MOVEL     'Y'           CGL058                                       CGL058
     C                   ELSE                                                                 CGL058
     C                   MOVEL     'N'           CGL058                                       CGL058
     C                   ENDIF                                                                CGL058
      *                                                                                     MD030956
      ** Access SAR details file to determine if                                            MD030956
      ** CTI006 is enabled                                                                  MD030956
      *                                                                                     MD030956
     C                   CALL      'AOSARDR0'                                               MD030956
     C                   PARM      *BLANKS       @RTCD                                      MD030956
     C                   PARM      '*VERIFY'     @OPTN                                      MD030956
     C                   PARM      'CTI006'      @SARD                                      MD030956
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030956
      *                                                                                     MD030956
     C     @RTCD         IFEQ      *BLANK                                                   MD030956
     C                   MOVEL     'Y'           CTI006            1                        MD030956
     C                   ELSE                                                               MD030956
     C                   MOVEL     'N'           CTI006                                     MD030956
     C                   ENDIF                                                              MD030956
                                                                                              CGL058
      ***Check*if*CER043*is*switched*on********************************                CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         CALLB     'AOSARDR0'                                          CER043 CSF011
     C**********         PARM      *BLANKS       @RTCD                                 CER043 CSF011
     C**********         PARM      '*VERIFY'     @OPTN                                 CER043 CSF011
     C**********         PARM      'CER043'      @SARD                                 CER043 CSF011
     C*****SCSARD        PARM      SCSARD        DSFDY                                 CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         IF        @RTCD = *BLANKS                                     CER043 CSF011
     C**********         EVAL      CER043 = 'Y'                                        CER043 CSF011
     C**********         ELSE                                                          CER043 CSF011
     C**********         EVAL      CER043 = 'N'                                        CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         IF        @RTCD <> '*NRF'                                     CER043 CSF011
     C******LOCK         IN        LDA                                                 CER043 CSF011
     C**********         EVAL      DBKEY = 'CER043'                                    CER043 CSF011
     C**********         EVAL      DBFILE = 'SCSARDPD'                                 CER043 CSF011
     C**********         EVAL      DBASE = 906                                         CER043 CSF011
     C**********         OUT       LDA                                                 CER043 CSF011
     C**********         EXSR      *PSSR                                               CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
     C/COPY WNCPYSRC,FXH00031
      *                                                                                       CSW212
      ** Check if SWIFT 2012  is on                                                           CSW212
      *                                                                                       CSW212
     C                   CALL      'SWIF2012'                                                 CSW212
     C                   PARM      *BLANKS       @RTCD                                        CSW212
      *                                                                                       CSW212
     C     @RTCD         IFEQ      'CSW2012'                                                  CSW212
     C                   MOVEL     'Y'           CSW212            1                          CSW212
     C                   ELSE                                                                 CSW212
     C                   MOVEL     'N'           CSW212                                       CSW212
      *                                                                                       CSW212
     C                   ENDIF                                                                CSW212
                                                                                              CSW213
      ** Check if SWIFT 2013 is on                                                            CSW213
                                                                                              CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       PRtCd                                        CSW213
                                                                                              CSW213
     C     PRtCd         IFEQ      'CSW2013'                                                  CSW213
     C                   MOVEL     'Y'           CSW213                                       CSW213
     C                   ELSE                                                                 CSW213
     C                   MOVEL     'N'           CSW213                                       CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C     RPIFKey       KLIST                                                              MD024185
     C                   KFLD                    RLAPID                                     MD024185
     C                   KFLD                    RLLTRF                                     MD024185
                                                                                            MD024185
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
