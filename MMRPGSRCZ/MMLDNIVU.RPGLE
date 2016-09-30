     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits validate and update')          *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIVU - Deal Loans and deposits validate and update       *
      *                                                               *
      *  Function: This Program Validates MM Loans and deposits for   *
      *            into the Midas database and updates if required    *
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
      *              process this deal and bypass remaining validation*
      *              bypass the field validation                      *
      *            - For D (=Delete) call a separate function to      *
      *              process this deal and bypass the rest of the     *
      *              validation                                       *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD037869A          Date 28Mar16               *
      *  Prev Amend No. MD038485           Date 10Aug16               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 MD030436           Date 01Oct14               *
      *                 MD027337A          Date 01Oct14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD027415           Date 19Aug14               *
      *                 MD027337           Date 05Jun14               *
      *                 MD024884           Date 07Feb14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD022849           Date 13Oct13               *
      *                 MD022656           Date 01Oct13               *
      *                 AR751620           Date 12Jun13               *
      *                 MD000091           Date 14May13               *
      *                 AR1060863          Date 06Apr13               *
      *                 AR665113           Date 28Nov12               *
      *                 AR971184A          Date 22Jun12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR863263           Date 11Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 AR819540A          Date 30Aug11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 259924A            Date 28May09               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23519           Date 24Mar09               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260428A            Date 10Jun09               *
      *                 260428             Date 28May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256638             Date 21Oct08               *
      *                 256564             Date 17Sep08               *
      *                 248297             Date 05Jun07               *
      *                 244784             Date 11JAN07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244537             Date 17Aug05               *
      *                 BUG5169            Date 04Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12967           Date 21Dec06               *
      *                 241685             Date 18Sep06               *
      *                 BUG12589           Date 15Nov06               *
      *                 BUG12551           Date 09Nov06               *
      *                 CDL049             Date 11Jul06               *
      *                 239400             Date 26Jun06               *
      *                 CSD027A            Date 09May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10943           Date 27Mar06               *
      *                 BUG10718           Date 03Mar06               *
      *                 BUG10725           Date 02Mar06               *
      *                 BUG10695           Date 25Feb06               *
      *                 BUG10677           Date 23Feb06               *
      *                 BUG10341           Date 07Feb06               *
      *                 BUG10563           Date 14Feb06               *
      *                 BUG9827            Date 10Jan06               *
      *                 BUG10296           Date 07Feb06               *
      *                 CAP087             Date 02Sep05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG8119            Date 20Oct05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG6512            Date 21Apr05               *
      *                 BUG6164            Date 01Apr05               *
      *                 BUG4808            Date 16Nov04               *
      *                 BUG4728            Date 05Nov04               *
      *                 BUG3992            Date 01Oct04               *
      *                 BUG4482            Date 29Sep04               *
      *                 BUG3792            Date 28Sep04               *
      *                 BUG4380            Date 29Sep04               *
      *                 BUG4068            Date 03Sep04               *
      *                 BUG4097            Date 01Sep04               *
      *                 BUG3684            Date 18Aug04               *
      *                 BUG3986            Date 13Aug04               *
      *                 CMM105             Date 22Jun04               *
      *                 BUG3869            Date 26Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 TCA002             Date 26Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *CREATE    Date 17Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD037869A - Unable to authorise deal in LDNI after updating  *
      *              base rate.                                       *
      *  MD038485 - Correct mapping of Stamp Tax fields (CER049).     *
      *  CGL165 - Dual Withholding Tax                                *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  MD030436 - Enhance fix MD027337A to the cater defaulting of  *
      *             settlement from '00' to SSI details.              *
      *  MD027337A - Settlement details are not being re-defaulted    *
      *              during amend.                                    *
      *            - Applied for MD030436.                            *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *  MD027415 - Unexpected validation of settlement instruction   *
      *             during 'EDIT' of a deal after it's value date.    *
      *           - Correct the validation of the field. Check        *
      *             counterparty nostro as well.                      *
      *  MD027337 - Settlement details are not being defaulted during *
      *             amend.                                            *
      *  MD024884 - Incorrect Payment and Receipt accounts            *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD022849 - Settlement Payment Fields cannot be amended error *
      *  MD022656 - Amendment is allowed for protected settlement     *
      *             fields                                            *
      *  AR751620 - Serious midas error encountered when processing   *
      *             a deal that has a different timestamp from file.  *
      *             Amend program to show an error message instead.   *
      *             (Child: AR751621)                                 *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1060863 - Deal irregular interest schedules lost           *
      *            - Applied for AR1097090                            *
      *  AR665113 - Check deal number for the existing associated     *
      *             rollover deals.(Child: AR665114)                  *
      *  AR971184A- During Amend Front Ofc Id must be updated with the*
      *             new one                                           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  AR863263 - Further Pay/Receipt Settlement Accounts are       *
      *             reset to blanks                                   *
      *  CSF011 - Customer Name on Inputs                             *
      *  AR819540A - Mapping error encountered in LDNI                *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding                              *
      *  259924A- Amended so that system can get the front office ID  *
      *           from Java.                                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23519 - Warning messages with the same text are displayed *
      *             at the same time (Recompile)                      *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  260428A - Always protect fields for validation if Authorise  *
      *  260428 - Skip validation on receipt side / pay side if       *
      *           accounting has taken place already in the past.     *
      *  256638 - Add the parameters needed to prevent Serious Midas  *
      *           Error message in Java screen.                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248297 - EXTDTA is no more part of Output buffers            *
      *           - Add DS in Buffer2                                 *
      *           - Ensure MMLDNIR also use it                        *
      *           - ROLLBACK updates in case of Problem               *
      *  244784 - Lux fields are lost. Remove BUG10943 because        *
      *           inconsistent with processing in APTRANVU            *
      *  244537 - To avoid overriding front office identifier.        *
      *  BUG5169 - Validate CDL020 fields on MMLDNIVLP.               *
      *  BUG12967 - MM LDNI crashes with serious Midas Error          *
      *  241685 - Extended Settlements are not defaulted. Default     *
      *           when Pay/Receipt Settlement is blank and Currency   *
      *           Code and Customer are NOT blank.                    *
      *  BUG12589 - When short term rate is specified, it is not      *
      *             reflected as actual interest rate in the files    *
      *             due to recalculation in calling MMLDNIVLP.        *
      *  BUG12551 - LDNI was unable to amend transaction.             *
      *             Serious Midas Plus error occurred.                *
      *             Reference Rate field was not updated properly.    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  239400 - Add Front Office ID to be used by SOAP Interface    *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10943 - Interest Rate Change Schedule not displayed       *
      *  BUG10718 - Deletion of Fiduciary Placing Associated Takings  *
      *             not deleted, no warning message.                  *
      *  BUG10725 - Fiduciary code/charges are not updated during     *
      *             insertion thereby causing Midasplus error in      *
      *             deal amendments                                   *
      *  BUG10695 - Wrong Total Interest being computed for           *
      *             fiduciary deals.  (Recompile)                     *
      *  BUG10677- Do not delete associated takings when the placing  *
      *            being deleted is authorised.  Also send appropriate*
      *            warning messages when deleting fiduciary deals.    *
      *  BUG10341-Indicate which row on edit table is in error        *
      *  BUG10563-Resolve conflict between BUG10296 and 9827          *
      *  BUG9827 - Fiduciary deal changes for Midas Plus              *
      *  BUG10296 - LUX extension fields are missing                  *
      *  CAP087  - REPO JAVA changes                                  *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG8119 - Fields returned incorrectly from API if update     *
      *            flag set to 'Y' but data is invalid.               *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL033  - Floating Rate CDs Issued.                          *
      *  BUG6512 - Retrieve TRAM details                              *
      *  BUG6164 - For WIP authorise cannot call ValidateAc before    *
      *            ValidateTr as HK* fields are not always retrieved. *
      *  BUG4808 - Unable to authorise transaction because WIP do     *
      *            not have correct Timestamp.                        *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  BUG3992- Call new program MMLDNIVLP to perform post          *
      *           settlement detail validation. Revalidate dates.     *
      *  BUG4482- Authorise should call Validate to show all the      *
      *           warning errors.                                     *
      *  BUG3792- Only allow Block/Unblock on Deposits.               *
      *  BUG4380- Clear Multiple Sett Account fields if not selected  *
      *  BUG4068- Deal number range for Fixed Loan/Deposit            *
      *  BUG4097 - Ensure Block/Unblock action leaves deal authorised *
      *  BUG3684 - Set up action field for Block/Unblock              *
      *  BUG3986- Pass the status and TimeStamp out to the MidasPlus *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *                  - Upgrade to Midasplus                       *
      *           Core hooks added: MMLDNIXD01,MMLDNIXC01,            *
      *                             MMLDNIXC03,MMLDNIXC04,MMLDNIXC05, *
      *                             MMLDNIXC06                        *
      *           Core hooks amended:MMLDNIM01                        *
      *  BUG3869 - Records lost from DLFSACPD on authorization        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TCA002 - 10-Digit Account Code Errors - Retrieve a/c details.*
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic Rollover of Fixed Term Loan/Deposit       *
      *  222727 - Release 5.0 errors (recompile).                     *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FSDFDDRL0  UF   E           K DISK    INFSR(*PSSR)                                      BUG4068
     F                                     COMMIT                                            BUG4068
      ** Fixed Loan/Deposit Deal Number Range file                                           BUG4068
      *                                                                                      BUG4068
     F***MMDEALLL  IF   E           K DISK    INFSR(*PSSR)                          BUG4068 AR665113
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)                                     AR665113
     FDEALSCL1  IF   E           K DISK    INFSR(*PSSR)                                     AR665113
     F                                     RENAME(DEALSDCF:DEALSRCF)                        AR665113
      *                                                                                      BUG4068
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
     FDLFRSCL0  UF A E           K DISK    INFSR(*PSSR)                                       CDL033
     F                                     COMMIT                                             CDL033
     FSDCCGRL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG9827
     FDLCCGDL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG9827
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG9827

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

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **-----------------------------------------------------------------------

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

      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.                                                           BUG4808
     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG4808
                                                                                             BUG4808
      ** Array of error message IDs                                                          BUG4808
     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG4808
     D                                     LIKE(#MsgID)                                      BUG4808
                                                                                             BUG4808
      ** Array of error message data.                                                        BUG4808
     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG4808
     D                                     LIKE(#MsgData)                                    BUG4808
                                                                                             BUG4808
      ** Array of message files to check                                                     BUG4808
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG4808
                                                                                             BUG4808
     D OLDMSG          S             10A   DIM(16) PERRCD(1) CTDATA                         BUG10341
     D NEWMSG          S             10A   DIM(16) ALT(OLDMSG)                              BUG10341
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Incoming transaction in screen format
     D TranIn        E DS                  EXTNAME(MMLDNIPD)

     D TranQExt      E DS                  EXTNAME(DLSTMPPD)                                  CER049
     ** Incoming stamp tax details screen format                                              CER049
                                                                                              CER049
      * Valid file layout
     D ValidDeal     E DS                  EXTNAME(MMVLDNIPD)
     D***LDNIRecIns           456    524                                                      CGL029
     D***LDNIPayIns           525   1083                                                      CGL029
     D LDNIRecIns            470    524                                                       CGL029
     D LDNIPayIns            539   1083                                                       CGL029

      * Current transaction record in file format
     D DealFilFmt    E DS                  EXTNAME(MMDELDPP)
     D  QQDORI1      E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMORI1      E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDOPI1      E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMOPI1      E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRONS1      E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPONS1      E                     EXTFLD(QQPONS)                                     CGL029
     D  QQINSA1      E                     EXTFLD(QQINSA)                                     CGL029
     D***DELDRecIns           456    524                                                      CGL029
     D***DELDPayIns           525   1083                                                      CGL029
     D DELDRecIns            470    524                                                       CGL029
     D DELDPayIns            539   1083                                                       CGL029

      * Current transaction in screen format
     D DealScnFmt    E DS                  EXTNAME(MMLDNIPD)
     D                                     PREFIX(@)

      * Pay settlement instructions in screen format
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)

      * Receive settlement instructions in screen format
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)

      * FRA/IRS settlement instructions in screen format
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)

      * Pay settlement instructions - current
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)

      * Receive settlement instructions - current
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)

      * FRA/IRS settlement instructions - current
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)

      * Pay settlement instructions in file format
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D FLPAY2                 21    565                                                       CGL029

      * Receive settlement instructions in file format
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D FLREC2                 21     75                                                       CGL029

      * FRA/IRS settlement instructions in file format
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)

     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  CDL018
      * Receive Further Settlement Instructions in file format                                CDL018
                                                                                              CDL018
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  CDL018
      * Payment Further Settlement Instructions in file format                                CDL018
                                                                                              CDL018
     D #FRECS        E DS                  EXTNAME(SDFSSRPD)                                  CDL018
      * Receive Further Settlement instructions in screen format                              CDL018
                                                                                              CDL018
     D #FPAYS        E DS                  EXTNAME(SDFSSPPD)                                  CDL018
      * Payment Further Settlement instructions in screen format                              CDL018
                                                                                              CDL018
     D #FRECE        E DS                  EXTNAME(SDFSERPD)                                  CDL018
      * Errors - Receive Further Settlement Instructions                                      CDL018
                                                                                              CDL018
     D #FPAYE        E DS                  EXTNAME(SDFSEPPD)                                  CDL018
      * Errors - Payment Further Settlement Instructions                                      CDL018
                                                                                              CDL018
      * Extra data in file format - Class 1 data
     D InfData       E DS                  EXTNAME(MMLDIFPD)
     D                                     PREFIX(IF_)

      * Extra data in file format
     D ExtData       E DS                  EXTNAME(MMLDEXPD)
      *                                                                                       CER001
      ** Regional data in file format                                                         CER001
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(MMLDRXPD)                                  CER001

      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
                                                                                             BUG9827
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                 BUG9827
      ** External DS for Midas Modules                                                       BUG9827
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                                 BUG9827
      ** External DS for Portfolio Management ICD                                            BUG9827
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG9827
      ** External DS for Customer Details                                                    BUG9827
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                 BUG9827
      ** External DS for Portfolio Management ICD                                            BUG9827
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                 BUG9827
      ** External DS for dealing ICD                                                         BUG9827

      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                             BUG9827
     D DSLDY         E DS                  EXTNAME(DSLDY)                                    BUG9827

     D ValidLUX      E DS                  EXTNAME(MMVLDLX1PD)                                CER001
                                                                                              CER001
     D SVRCD         E DS                  EXTNAME(MMDLX1PD)                                  CER001
     D                                     PREFIX(SV)                                         CER001
                                                                                              CER001
     D OkFlags       E DS                  EXTNAME(MMELDLX1PD)                                CER001
                                                                                              CER001
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area

     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
     D ZMUSER          DS            17                                                      BUG9827
     D  ZMBRCA                11     13                                                      BUG9827
     D  ZMDEPT                14     16                                                      BUG9827
                                                                                             BUG9827
     D MMLDNIUPC       DS             1    DTAARA(MMLDNIUPC)

     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0

     D                 DS                                                                    CSF011A
     D  A#OURA                 1     21                                                      CSF011A
     D  A#NOST                 1      2                                                      CSF011A
     D  A#CNUM                 1      6                                                      CSF011A
     D  A#RENO                 1     10                                                      CSF011A
     D  A#ACOD                 7     16                                                      CSF011A
     D  A#ACAS                 7     18                                                      CSF011A
     D  A#ACSQ                17     18                                                      CSF011A
     D  A#REST                 3     18                                                      CSF011A
     D  A#RES2                11     18                                                      CSF011A
     D  A#BRCA                19     21                                                      CSF011A
                                                                                             CSF011A
      ***Customers*Extension*Screen*Format*based*on*SDCUCUPD                           CER043 CSF011
     D***TranInCust    E DS                  EXTNAME(SDCUCUPD)                         CER043 CSF011
                                                                                              CSF011
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSF011
     D                                     PREFIX(NO_)                                        CSF011
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CSF011
     D                                     PREFIX(AC_)                                        CSF011
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                                  CSF011
     D @TYPE           S              7                                                      CSF011A
     D @ACID           S             10                                                      CSF011A
     D @CYCD           S              3                                                      CSF011A
     D @ACCD           S             10                                                      CSF011A
     D @ACSN           S              2                                                      CSF011A
     D @BRCA           S              3                                                      CSF011A
     D @NOSN           S              2                                                      CSF011A
     D @CUST           S              6                                                      CSF011A
     D @PNOI           S              1                                                      CSF011A
     D @CSSN           S             10                                                      CSF011A
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
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

      ** Field (500A) to receive the incoming transaction
     D***Trans500        S            500A                                                   CSF011A
     D Trans500        S           1000A                                                     CSF011A

      ***Field*(500A)*to*receive*the*incoming*Settelement*details                      CER043 CSF011
     D***Trans500C       S            500A                                             CER043 CSF011
      *                                                                                       CER043
      ** Field (500A) to receive the incoming Extra Data
     D InfData500      S            500A

      ** Field (500A) to receive the incoming Stamp Tax data                                  CER049
     D TransQ500       S            500A                                                      CER049
                                                                                              CER049
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
      *                                                                                       CER001
      ** Field (500A) to receive the incoming Extra Data                                      CER001
      *                                                                                       CER001
     D RegData500      S            500A                                                      CER001

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indices for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

     D MMELDN        E DS                  EXTNAME(MMELDNIPD)
      * Error indicators

     D MMELDN2       E DS                  EXTNAME(MMELDN2PD)                                 CDL016
      * Error indicators screen 2                                                             CDL016
                                                                                              CDL016
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
     D  DDPmacOK                      1A   INZ('Y')                                           CDL018

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
     D  DDRmacOK                      1A   INZ('Y')                                           CDL018

     D  DDRexrOK                      1A   INZ('Y')                                           CDL094
     D  DDRexiOK                      1A   INZ('Y')                                           CDL094
     D  DDRbb1OK                      1A   INZ('Y')                                           CDL094
     D  DDRbb2OK                      1A   INZ('Y')                                           CDL094
     D  DDRbb3OK                      1A   INZ('Y')                                           CDL094
     D  DDRbb4OK                      1A   INZ('Y')                                           CDL094
     D  DDRbb5OK                      1A   INZ('Y')                                           CDL094
     D  DDRbb6OK                      1A   INZ('Y')                                           CDL094

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

     D DATALUX         DS          1024                                                       CER001
     D  #1FLD1                 1      6  0                                                    CER001
     D  #1DN38                 1      6                                                       CER001
     D  #1DLTP                 7      8                                                       CER001
     D  #1CNUM                 9     14                                                       CER001
     D  #1CCY                 15     17                                                       CER001
     D  #1AMNT                18     32  0                                                    CER001
     D  #1VDAT                33     38                                                       CER001
     D  #1MDAT                39     44                                                       CER001
     D  #1FOTR                45     64                                                       CER001
     D  #1TMST                65     90Z                                                      CER001
                                                                                              CER001
     D WFIDTDTL        DS            48                                                      BUG9827
     D  SFDLNO                 1      6                                                      BUG9827
     D  SFCNUM                 7     16                                                      BUG9827
     D  SFPTFR                17     20                                                      BUG9827
     D  SFAMNT                21     35                                                      BUG9827
     D  SFACOD                36     45                                                      BUG9827
     D  SFACSQ                46     47                                                      BUG9827
     D  SFTRAS                48     48                                                      BUG9827
                                                                                             BUG9827
     D VFIDTDTL        DS            48                                                      BUG9827
     D  VSFDLNO                1      6                                                      BUG9827
     D  VSFCNUM                7     16                                                      BUG9827
     D  VSFPTFR               17     20                                                      BUG9827
     D  VSFAMNT               21     35                                                      BUG9827
     D  VSFACOD               36     45                                                      BUG9827
     D  VSFACSQ               46     47                                                      BUG9827
     D  VSFTRAS               48     48                                                      BUG9827
                                                                                             BUG9827
     D WDUMMY          S             90A                                                    BUG10563
     D FIDTScnRpt      S           4752A                                                     BUG9827
     D FIDTScnRstN     S            240A                                                     BUG9827
     D FIDTVScnFmt     S           4752A                                                     BUG9827
                                                                                             BUG9827
      ** Flag to indicate outcome of call to lower level module
     D AmendOK         S              1A   INZ('Y')

      ** A code to indicate the calling function to the lower level modules
     D LDNI            S              4A   INZ('LDNI')

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
     D Blank3          S              3A   INZ(*BLANKS)
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)

      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')

      ** Timestamp for the transaction
     D TimeStamp       S               Z
                                                                                              CDL033
      ** Interest Rate Change or Interest Payment                                             CDL033
     D IntRate         S              1A                                                      CDL033

      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D RecNostro       S             18A                                                      CDL038
     D*RecNostro*******S             12A                                                      CDL038
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             18A                                                      CDL038
     D*PayNostro*******S             12A                                                      CDL038

     D OLD_MATD        S              5P 0
     D WProcDate       S                   LIKE(BJRDNB)
     D CSC011          S              1A   INZ('N')

      ** Midas Day number
     D @@DAYN          S              5P 0

      ** Formatted date field for use in the parameter list
     D DateOut         S              8S 0

      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CDL033
     DBuffer2          DS          3999                                                       CDL033
     DBufferEx2        DS          9999                                                       CDL033
     D***SfBuff20               1   4800                                            CDL033 AR1060863
     D***SfBuff21            4801   9600                                            CDL033 AR1060863
     D  SfBuff20            2282   7081                                                    AR1060863
     DBufferEx3        DS          9999                                                       CSF011
     D  SfBuff21            2283   7082                                                    AR1060863
     DPInDates         DS          3600                                                       CDL033
     DRinDates         DS          3600                                                       CDL033
     DRatDATEADS       DS                                                                     CDL033
     D RatDATEA                       8A   DIM(600)                                           CDL033
     D  RatDate                       6A   OVERLAY(RatDATEA:1)                                CDL033
     D  RatIndtr                      1A   OVERLAY(RatDATEA:7)                                CDL033
     D  RatProc                       1A   OVERLAY(RatDATEA:8)                                CDL033
     DPayDATEADS       DS                                                                     CDL033
     DPayDATEA                        8A   DIM(600)                                           CDL033
     D  PayDate                       6A   OVERLAY(PayDATEA:1)                                CDL033
     D  PayIndtr                      1A   OVERLAY(PayDATEA:7)                                CDL033
     D  PayProc                       1A   OVERLAY(PayDATEA:8)                                CDL033
     DRatDAYA                         5S 0 DIM(600)                                           CDL033
     DPayDAYA                         5S 0 DIM(600)                                           CDL033
     D                 DS                                                                     CDL033
     D  XCharA                        3A                                                      CDL033
     D  XNumP                         5P 0 OVERLAY(XCharA)                                    CDL033
     DRatDateDS        DS          4800                                                       CDL033
     DPayDateDS        DS          4800                                                       CDL033
     DRPConfHol        DS           600                                                       CDL033
     DRProcInd         DS           600                                                       CDL033
     DPPConfHol        DS           600                                                       CDL033
     DPProcInd         DS           600                                                       CDL033
     DRFormula         S              8A                                                      CDL033
     DPFormula         S              8A                                                      CDL033
     DPvalueDate       S              5P 0                                                    CDL033
     DPmaturityDate    S              5P 0                                                    CDL033
     DPControlDate     S              5P 0                                                    CDL033
     DPaction          S              1A                                                      CDL033
     DPDealNo          S              6A                                                      CDL033
     DPPrevDate        S              5P 0                                                    CDL033
     DOPrevDate        S              5P 0                                                    CDL033
     DPcurrency        S              3A                                                      CDL033
     DRDatesIn         DS          3600                                                       CDL033
     DOKInRatCal       S            600A                                                      CDL033
     DRValDateOut      S           1800                                                       CDL033
     DPValDateOut      S           1800                                                       CDL033
     DPFrequency       S              1A                                                      CDL033
     DPfreqForm        S              7A                                                      CDL033
     DValDateIn        S           1800                                                       CDL033
     DARdx             S              3S 0                                                    CDL033
     DARelmt           S              5S 0                                                    CDL033
     DXResult          S              9S 4                                                    CDL033
     DXRemand          S              3S 0                                                    CDL033
     DPDatesIn         DS          3600                                                       CDL033
     D PDateIn         S              6A                                                      CDL033
     D PDayNoOut       S              5P 0                                                    CDL033
     D PErrorFlg       S              1A                                                      CDL033
     D I               S              5S 0                                                    CDL033
     D J               S              5S 0                                                    CDL033
     D N               S              5S 0                                                    CDL033
     D S               S              5S 0                                                    CDL033
     D T               S              5S 0                                                    CDL033
     DVDLNO            S              6S 0                                                    CDL033
     DSRate            S             11P 7                                                    CDL033
     D #N              S              5S 0                                                    CDL033
     D #X              S              5S 0                                                    CDL033
     D #Y              S              5S 0                                                    CDL033
     DZDAYNO           S              5P 0                                                    CDL033
     DZDATE            S              6P 0                                                    CDL033
     DZADATE           S              7A                                                      CDL033
     D@ACDLNO          S              7A                                                      CDL033
     D ACTN            S              1                                                       CER001
     D WFIND           S              1                                                       CER001
     D @@ER91          S              1                                                       CER001
     D ULX600          S              1A                                                      CER001
     D CER043          S              1A                                                      CER043
      ***This*field*should*be*reduced*everytime*a*core*field*is*added              BUG10296 BUG10563
     D*LDNIFil*        S           3953A                                           BUG10296 BUG10563
                                                                                              CSC022
     D WTAmount        S             15S 0                                                   BUG9827
     D WAmount         S             15S 0                                                   BUG9827
     D OKFIDTDTL       S              1A                                                     BUG9827
     D Tkg             S              3  0                                                   BUG9827
     D TkgA            S              3A                                                    BUG10341
     D Str             S              4  0                                                   BUG9827
     D FIDTLen         S              2  0 INZ(48)                                           BUG9827
     D*Filler**        S           2523A                                              BUG9827 CER043
     D*Filler***       S           2072A                                               CER043 CDL096
     D*Filler**        S           2038A                                               CDL096 CGL165
     D Filler          S           2034A                                                      CGL165
     D NoOfTakingsIns  S              2  0 INZ(0)                                            BUG9827
     D S01468          S              1A                                                     BUG9827
     D NNDCSP          S              1A                                                     BUG9827
     D PCYDP           S              1S 0                                                   BUG9827
     D PDLNO           S                   LIKE(DDDLNO)                                      BUG9827
     D PNTCE           S              3S 0                                                   BUG9827
     D PDDMDAT         S              6A                                                     BUG9827
     D PDDNTCE         S              3A                                                     BUG9827
     D PKEY1           S             10A                                                     BUG9827
     D PKYST           S              7A                                                     BUG9827
     D PTOTI           S             14A                                                     BUG9827
     D PTRTP           S              5A                                                     BUG9827
     D ZADEC           S              1P 0                                                   BUG9827
     D ZADIG           S              2P 0                                                   BUG9827
     D ZALIGNOK        S              1A                                                     BUG9827
     D ZFIELD          S             16A                                                     BUG9827
     D ZFLD15          S             15P 0                                                   BUG9827
     D ZOUT21          S             21A                                                     BUG9827
     D ZECODE          S              1A                                                     BUG9827
     D ZDECS           S              1P 0                                                   BUG9827
     D PRDLNO          S                   LIKE(DDDLNO)                                      BUG9827
     D ErrTot          S              3  0                                                  BUG10341
     D NewErrTot       S              3  0                                                  BUG10341
     D ErrID           S              2  0                                                  BUG10341
     D St              S              3  0                                                  BUG10341
     D Le              S              3  0                                                  BUG10341
     D m               S              3  0                                                  BUG10341
     D pos             S              3  0                                                  BUG10341
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091

     D @@STRT          S                   LIKE(IKINTR)                                     BUG12589
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

     D SREMK           S             35                                                       CMM105
      *                                                                                       CER043
      ** Parameters for Calling AOCUSTR0                                                      CER043
     D PCNum           S             10A                                                      CER043
     D PKey7           S              7A                                                      CER043
      *                                                                                       CER043
     D W#RONX          S             21                                                     MD022656
     D W#PONX          S             21                                                     MD022656
     D W#PSTM          S              2                                                     MD022656
     D W#RSTM          S              2                                                     MD022656
     D W#CCY           S              3                                                     MD022656
     D W#CNT           S              3P 0                                                  MD022656
     D W#ROBN          S             10    INZ(*BLANKS)                                     MD022656
     D W#ROCN          S             10    INZ(*BLANKS)                                     MD022656
     D W#POBN          S             10    INZ(*BLANKS)                                     MD022656
     D W#POCN          S             10    INZ(*BLANKS)                                     MD022656
     D W#ITER          S              1  0                                                  MD022656
     D W#RCRN          S             10    INZ(*BLANKS)                                     MD022849
     D W#RVNO          S             10    INZ(*BLANKS)                                     MD022849
     D W#AWBN          S             10    INZ(*BLANKS)                                     MD022849
     D W#PIBN          S             10    INZ(*BLANKS)                                     MD022849
     D W#BENN          S             10    INZ(*BLANKS)                                     MD022849
     D W#RIBN          S             10    INZ(*BLANKS)                                     MD022849
     D**ValueDate        S              5P 0                                      MD027337 MD027337A
     D/COPY WNCPYSRC,MMLDNIXD01
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans500      TranIn
     C**********         MOVEL     Trans500C     TranInCust                            CER043 CSF011
     C                   MOVEL     TransQ500     TranQExt                                     CER049
                                                                                             BUG9827
      *-----------------------------------------------------------------------------         BUG9827
      * Buffer layout .......  please update when making future changes to buffer            BUG9827
      *                        or whenever a file layout changes                             BUG9827
      * ----------------------------------------------------------------------------         BUG9827
      * Field / DS  ¦ Start   ¦ End     ¦ Length   ¦                                         BUG9827
      * -------------------------------------------                                          BUG9827
      **MMLDNIPD****¦****1****¦**407****¦**407*****¦                                  BUG9827 CSF011
      **MMLDIFPD****¦**408****¦**457****¦***50*****¦                                  BUG9827 CSF011
      **RFormula****¦**458****¦**465****¦****8*****¦                                  BUG9827 CSF011
      **PFormula****¦**466****¦**483****¦****8*****¦                                BUG9827 BUG10563
      **SREMK*******¦**484****¦**518****¦***35*****¦                                BUG9827 BUG10563
      **DDSTS*******¦**519****¦**542****¦***24*****¦                                BUG9827 BUG10563
      **DDCSTS******¦**543****¦**552****¦***10*****¦                                BUG9827 BUG10563
      **CPST********¦**553****¦**554****¦****2*****¦                                BUG9827 BUG10563
      **DSPCP*******¦**555****¦**555****¦****1*****¦                                BUG9827 BUG10563
      **BKST********¦**556****¦**557****¦****2*****¦                                BUG9827 BUG10563
      **DSPBK*******¦**558****¦**558****¦****1*****¦                                BUG9827 BUG10563
      **@TimeStamp**¦**559****¦**584****¦***26*****¦                                BUG9827 BUG10563
      **DDACTC******¦**585****¦**585****¦****1*****¦                                BUG9827 BUG10563
      **PLATAK******¦**586****¦**586****¦****1*****¦                                BUG9827 BUG10563
      **SDFSSPPD****¦**587****¦*1137****¦**551*****¦                                BUG9827 BUG10563
      **SDFSSRPD****¦*1138****¦*1688****¦**551*****¦                                BUG9827 BUG10563
      **SDESSPPD****¦*1689****¦*2282****¦**594*****¦                                BUG9827 BUG10563
      **SDESSRPD****¦*2283****¦*2374****¦***92*****¦                                BUG9827 BUG10563
      **MMLDRXPD****¦*2375****¦*2434****¦***60*****¦                                BUG9827 BUG10563
      **MMLDEXPD****¦*2435****¦*2484****¦***50*****¦                                BUG9827 BUG10563
      **PFormula****¦**466****¦**473****¦****8*****¦                                 BUG10563 CSF011
      **SREMK*******¦**484****¦**508****¦***35*****¦                                 BUG10563 CSF011
      **DDSTS*******¦**519****¦**532****¦***24*****¦                                 BUG10563 CSF011
      **DDCST*******¦**543****¦**542****¦***10*****¦                                 BUG10563 CSF011
      **CPST********¦**553****¦**544****¦****2*****¦                                 BUG10563 CSF011
      **DSPCP*******¦**555****¦**545****¦****1*****¦                                 BUG10563 CSF011
      **BKST********¦**556****¦**547****¦****2*****¦                                 BUG10563 CSF011
      **DSPBK*******¦**558****¦**548****¦****1*****¦                                 BUG10563 CSF011
      **@TimeStamp**¦**559****¦**574****¦***26*****¦                                 BUG10563 CSF011
      **DDACTC******¦**585****¦**575****¦****1*****¦                                 BUG10563 CSF011
      **PLATAK******¦**586****¦**576****¦****1*****¦                                 BUG10563 CSF011
      **SDFSSPPD****¦**587****¦*1127****¦**551*****¦                                 BUG10563 CSF011
      **SDFSSRPD****¦*1138****¦*1678****¦**551*****¦                                 BUG10563 CSF011
      **SDESSPPD****¦*1689****¦*2287****¦**609*****¦                                 BUG10563 CSF011
      **SDESSRPD****¦*2283****¦*2394****¦**107*****¦                                 BUG10563 CSF011
      **WDUMMY******¦*2395****¦*2484****¦***90*****¦                                 BUG10563 CSF011
      **FIDTScnRstN*¦*2485****¦*2724****¦**240*****¦                                  BUG9827 CSF011
      **Filler******¦*2725****¦*5247****¦*2523*****¦                                  BUG9827 CSF011
      **FIDTScnRpt**¦*5248****¦*6000****¦**********¦                                  BUG9827 CSF011
      ***End*of*buffer*(6000)*start*of*Buffer2*(3999)                                 BUG9827 CSF011
      *...FIDTScnRpt¦****1****¦*3999****¦*4752*****¦                                  BUG9827 CSF011
      ***End*of*buffer2*(3999)*start*of*BufferEx2                                     BUG9827 CSF011
      **SfBuff20****¦****1****¦*4800****¦*4800*****¦                                  BUG9827 CSF011
      **SfBuff21****¦*4801****¦*9600****¦*4800*****¦                                  BUG9827 CSF011
      **MMLDRXPD****¦*9601****¦*9640****¦***40*****¦                                 BUG10563 CSF011
      **MMLDEXPD****¦*9641    ¦ 9690    ¦   50     ¦                                          248297
      **MMLDEXPD****¦*9641****¦*9730****¦***90*****¦                                   248297 CSF011
                                                                                              CDL096
      **MMLDNIPD****¦****1****¦**666****¦**666*****¦                                  CSF011A CDL096
      **MMLDIFPD****¦**667****¦**716****¦***50*****¦                                  CSF011A CDL096
      **RFormula****¦**717****¦**724****¦****8*****¦                                  CSF011A CDL096
      **PFormula****¦**725****¦**732****¦****8*****¦                                  CSF011A CDL096
      **SREMK*******¦**733****¦**767****¦***35*****¦                                  CSF011A CDL096
      **DDSTS*******¦**768****¦**791****¦***24*****¦                                  CSF011A CDL096
      **DDCSTS******¦**792****¦**801****¦***10*****¦                                  CSF011A CDL096
      **CPST********¦**802****¦**803****¦****2*****¦                                  CSF011A CDL096
      **DSPCP*******¦**804****¦**804****¦****1*****¦                                  CSF011A CDL096
      **BKST********¦**805****¦**806****¦****2*****¦                                  CSF011A CDL096
      **DSPBK*******¦**807****¦**807****¦****1*****¦                                  CSF011A CDL096
      **@TimeStamp**¦**808****¦**833****¦***26*****¦                                  CSF011A CDL096
      **DDACTC******¦**834****¦**834****¦****1*****¦                                  CSF011A CDL096
      **PLATAK******¦**835****¦**835****¦****1*****¦                                  CSF011A CDL096
      **DDFOIDPD****¦**836****¦*1855****¦***20*****¦                                  CSF011A CDL096
      **SDFSSRPD****¦*1856****¦*2270****¦*1415*****¦                                  CSF011A CDL096
      **SDFSSPPD****¦*2271****¦*3685****¦*1415*****¦                                  CSF011A CDL096
      **SDESSRPD****¦*3686****¦*4020****¦**335*****¦                                  CSF011A CDL096
      **SDESSPPD****¦*4021****¦*5065****¦*1045*****¦                                  CSF011A CDL096
      **WDUMMYPD****¦*5066****¦*5155****¦***90*****¦                                  CSF011A CDL096
      **FIDTScnRstN*¦*5156****¦*5395****¦**240*****¦                                  CSF011A CDL096
      **Filler******¦*5396****¦*6000****¦**********¦                                  CSF011A CDL096
                                                                                      CDL096  CGL165
      **MMLDNIPD****¦*   1    ¦  700    ¦  700     ¦                                  CDL096  CGL165
      **MMLDIFPD****¦* 701    ¦  750    ¦   50     ¦                                  CDL096  CGL165
      **RFormula****¦* 751    ¦  758    ¦    8     ¦                                  CDL096  CGL165
      **PFormula****¦* 759    ¦  766    ¦    8     ¦                                  CDL096  CGL165
      **SREMK*******¦* 767    ¦  801    ¦   35     ¦                                  CDL096  CGL165
      **DDSTS*******¦* 802    ¦  825    ¦   24     ¦                                  CDL096  CGL165
      **DDCSTS******¦* 826    ¦  835    ¦   10     ¦                                  CDL096  CGL165
      **CPST********¦* 836    ¦  837    ¦    2     ¦                                  CDL096  CGL165
      **DSPCP*******¦* 838    ¦  838    ¦    1     ¦                                  CDL096  CGL165
      **BKST********¦* 839    ¦  840    ¦    2     ¦                                  CDL096  CGL165
      **DSPBK*******¦* 841    ¦  841    ¦    1     ¦                                  CDL096  CGL165
      **@TimeStamp**¦* 842    ¦  867    ¦   26     ¦                                  CDL096  CGL165
      **DDACTC******¦* 868    ¦  868    ¦    1     ¦                                  CDL096  CGL165
      **PLATAK******¦* 869    ¦  869    ¦    1     ¦                                  CDL096  CGL165
      **DDFOIDPD****¦* 870    ¦  889    ¦   20     ¦                                  CDL096  CGL165
      **SDFSSRPD****¦* 890    ¦ 2304    ¦ 1415     ¦                                  CDL096  CGL165
      **SDFSSPPD****¦*2305    ¦ 3719    ¦ 1415     ¦                                  CDL096  CGL165
      **SDESSRPD****¦*3720    ¦ 4054    ¦  335     ¦                                  CDL096  CGL165
      **SDESSPPD****¦*4055    ¦ 5099    ¦ 1045     ¦                                  CDL096  CGL165
      **WDUMMY******¦*5100    ¦ 5189    ¦   90     ¦                                  CDL096  CGL165
      **FIDTScnRstN*¦*5190    ¦ 5429    ¦  240     ¦                                  CDL096  CGL165
      **Filler******¦ 5430    ¦ 6000    ¦          ¦                                  CDL096  CGL165
                                                                                              CGL165
      * MMLDNIPD    ¦    1    ¦  704    ¦  700     ¦                                          CGL165
      * MMLDIFPD    ¦  705    ¦  754    ¦   50     ¦                                          CGL165
      * RFormula    ¦  755    ¦  762    ¦    8     ¦                                          CGL165
      * PFormula    ¦  763    ¦  770    ¦    8     ¦                                          CGL165
      * SREMK       ¦  771    ¦  805    ¦   35     ¦                                          CGL165
      * DDSTS       ¦  806    ¦  829    ¦   24     ¦                                          CGL165
      * DDCST       ¦  830    ¦  839    ¦   10     ¦                                          CGL165
      * CPST        ¦  840    ¦  841    ¦    2     ¦                                          CGL165
      * DSPCP       ¦  842    ¦  842    ¦    1     ¦                                          CGL165
      * BKST        ¦  843    ¦  844    ¦    2     ¦                                          CGL165
      * DSPBK       ¦  845    ¦  845    ¦    1     ¦                                          CGL165
      * @TimeStamp  ¦  846    ¦  871    ¦   26     ¦                                          CGL165
      * DDACTC      ¦  872    ¦  872    ¦    1     ¦                                          CGL165
      * PLATAK      ¦  873    ¦  873    ¦    1     ¦                                          CGL165
      * DDFOID      ¦  874    ¦  893    ¦   20     ¦                                          CGL165
      * SDFSSRPD    ¦  894    ¦ 2308    ¦ 1415     ¦                                          CGL165
      * SDFSSPPD    ¦ 2309    ¦ 3723    ¦ 1415     ¦                                          CGL165
      * SDESSRPD    ¦ 3724    ¦ 4058    ¦  335     ¦                                          CGL165
      * SDESSPPD    ¦ 4059    ¦ 5103    ¦ 1045     ¦                                          CGL165
      * WDUMMY      ¦ 5104    ¦ 5193    ¦   90     ¦                                          CGL165
      * FIDTScnRstN ¦ 5194    ¦ 5433    ¦  240     ¦                                          CGL165
      * Filler      ¦ 5434    ¦ 6000    ¦          ¦                                          CGL165
      ** End of buffer (6000) start of Buffer2 (3999)                                         CSF011
      ****Filler****¦****1****¦*1467****¦*2072*****¦                                   CSF011 CDL096
      ****Filler****¦    1    ¦ 1467    ¦ 2038     ¦                                   CDL096 CGL165
      *...Filler    ¦    1    ¦ 1467    ¦ 2034     ¦                                          CGL165
      * TranQExt    ¦ 1468    ¦ 1562    ¦   95     ¦                                          CSF011
      * FIDTScnRpt  ¦ 1563    ¦ 3999    ¦          ¦                                          CSF011
      ** End of buffer2 (3999) start of BufferEx2                                             CSF011
      *...FIDTScnRpt¦    1    ¦ 2315    ¦ 4752     ¦                                          CSF011
      * SfBuff20    ¦ 2316    ¦ 7115    ¦ 4800     ¦                                          CSF011
      * SfBuff21    ¦ 7116    ¦ 9999    ¦          ¦                                          CSF011
      ** End of BufferEx2(9999) start of BufferEx3                                            CSF011
      *...SfBuff21  ¦    1    ¦ 1916    ¦ 4800     ¦                                          CSF011
      * MMLDRXPD    ¦ 1917    ¦ 1956    ¦   40     ¦                                          CSF011
      * MMLDEXPD    ¦ 1957    ¦ 2006    ¦   50     ¦                                          CSF011
                                                                                             BUG9827
      * Extract the CDL006 fields from buffer and buffer2                                    BUG9827
     C                   If        CDL006 = 'Y'                                              BUG9827
     C**********         Eval      FIDTScnRstN = %SUBST(Buffer:2484:240)              BUG9827 CSF011
     C**********         Eval      FIDTScnRpt = %SUBST(Buffer:5248) + Buffer2         BUG9827 CSF011
     C**********         EVAL      FIDTScnRstN = %SUBST(Buffer:5156:240)               CSF011 CDL096
     C**********         EVAL      FIDTScnRstN = %SUBST(Buffer:5190:240)               CDL096 CGL165
     C                   EVAL      FIDTScnRstN = %SUBST(Buffer:5194:240)                      CGL165
     C                   EVAL      FIDTScnRpt = %SUBST(Buffer2:1563) +                        CSF011
     C                                          %SUBST(BufferEx2:1:2315)                      CSF011
     C                   EndIf                                                               BUG9827

     C                   IF        CDL033 = 'Y'                                               CDL033
     C**********         EVAL      RFormula = %SUBST(Buffer:454:8)                    CDL033 BUG9827
     C**********         EVAL      PFormula = %SUBST(Buffer:462:8)                    CDL033 BUG9827
     C**********         EVAL      RFormula = %SUBST(Buffer:458:8)                    BUG9827 CSF011
     C**********         EVAL      PFormula = %SUBST(Buffer:466:8)                    BUG9827 CSF011
     C**********         EVAL      RFormula = %SUBST(Buffer:717:8)                    CSF011A CDL096
     C**********         EVAL      PFormula = %SUBST(Buffer:725:8)                    CSF011A CDL096
     C**********         EVAL      RFormula = %SUBST(Buffer:751:8)                    CDL096  CGL165
     C**********         EVAL      PFormula = %SUBST(Buffer:759:8)                    CDL096  CGL165
     C                   EVAL      RFormula = %SUBST(Buffer:755:8)                            CGL165
     C                   EVAL      PFormula = %SUBST(Buffer:763:8)                            CGL165
     C                   MOVEA     SfBuff20      RatDATEA                                     CDL033
     C                   MOVEA     SfBuff21      PayDATEA                                     CDL033
     C                   DO        600           N                                            CDL033
     C                   EVAL      S = (N - 1) * 6 + 1                                        CDL033
     C                   IF        RatDATEA(N) = *BLANK                                       CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   EVAL      %Subst(Rindates:S:6) =                                     CDL033
     C                             RatDate(N)                                                 CDL033
     C                   EVAL      %Subst(RPConfHol:N:1) =                                    CDL033
     C                             RatIndtr(N)                                                CDL033
     C                   EVAL      %Subst(RProcInd:N:1) =                                     CDL033
     C                             RatProc(N)                                                 CDL033
     C                   ENDDO                                                                CDL033
      *                                                                                       CDL033
     C                   DO        600           N                                            CDL033
     C                   EVAL      S = (N - 1) * 6 + 1                                        CDL033
     C                   IF        PayDATEA(N) = *BLANK                                       CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   EVAL      %Subst(Pindates:S:6) =                                     CDL033
     C                             PayDate(N)                                                 CDL033
     C                   EVAL      %Subst(PPConfHol:N:1) =                                    CDL033
     C                             PayIndtr(N)                                                CDL033
     C                   EVAL      %Subst(PProcInd:N:1) =                                     CDL033
     C                             PayProc(N)                                                 CDL033
     C                   ENDDO                                                                CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
     C                   MOVEL     Infdata500    Infdata
     C/COPY WNCPYSRC,MMLDNIXC01
     C                   MOVEL     Extdata500    Extdata
     C                   MOVEL     RegData500    RegData                                      CER001
     C**********         EVAL      APFOTranID = DDFOID                             259924A AR971184A
     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
     C                   EVAL      DDFOID = APFOTranID                                     AR971184A
     C                   ENDIF                                                             AR971184A
                                                                                              CAP087
     C                   Eval      RepoFlag = 'N'                                             CAP087
     C                   If        DDDRID <> *Blanks                                          CAP087
     C                             AND CSE006 = 'Y'                                           CAP087
     C                   Eval      RepoFlag = 'Y'                                             CAP087
     C                   Endif                                                                CAP087
                                                                                             BUG3684
      * Reset the Action code to B or U if this is caled from the Block or Unblock           BUG3684
      * buttons on the input form or pre-confirmation screen.                                BUG3684
     C     DDACTC        IFEQ      'B'                                                       BUG3684
     C                   MOVE      'B'           DDACTN                                      BUG3684
     C                   ENDIF                                                               BUG3684
                                                                                             BUG3684
     C     DDACTC        IFEQ      'U'                                                       BUG3684
     C                   MOVE      'U'           DDACTN                                      BUG3684
     C                   ENDIF                                                               BUG3684

      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

      *  Validate Action Code

     C**********         IF        DDACTN <> 'X'                                   BUG6164 MD037869A
     C                   EXSR      ValidateAc
     C**********         END                                                       BUG6164 MD037869A

      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
                                                                                             BUG6512
      *                                                                                      BUG6512
      * Retrieve TRAM details                                                                BUG6512
      *                                                                                      BUG6512
     C                   EXSR      ZACFFEERTV                                                BUG6512

      *  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN      DDACTN = 'I'
      *  Processing for Inserts
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt
     C                   IF        CDL033 = 'Y'                                               CDL033
     C                   IF        Idx = 0                                                    CDL033
     C                   EXSR      ValidateRC                                                 CDL033
     C                   IF        Idx = 0                                                    CDL033
     C                   EXSR      ValidatePC                                                 CDL033
     C                   ENDIF                                                                CDL033
     C                   IF        DDSTRT <> *BLANKS                                        BUG12589
     C                   EVAL      @@STRT = IKINTR                                          BUG12589
     C                   ENDIF                                                              BUG12589
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                     BUG12967
      *  Do not validate if error occurs in previous validation                             BUG12967
     C                   IF        Idx = 0                                                  BUG12967
     C                   EXSR      ValidateLP                                                BUG3992
     C                   Endif                                                              BUG12967
                                                                                            BUG12589
      ** For Insert:                                                                        BUG12589
      ** If CDL033 is on and short term rate was specified, ensure                          BUG12589
      ** this becomes the prevailing rate as IKINTR value is reset in                       BUG12589
      ** SR/ValidateLP when calling ZAVSPRRATE program                                      BUG12589
     C                   IF        CDL033 = 'Y' and DDSTRT <> *BLANKS                       BUG12589
     C                   EVAL      IKINTR = @@STRT                                          BUG12589
     C                   ENDIF                                                              BUG12589
                                                                                             BUG9827
      * If dealtype is a fiduciary placing then do SR/ValidateFD                             BUG9827
     C                   IF        CDL006 = 'Y' and Idx = 0                                  BUG9827
     C                   IF        DDTYPE = 'FL' or DDTYPE = 'DP' or                         BUG9827
     C                             DDTYPE = 'LP'                                             BUG9827
     C                   EXSR      ValidateFD                                                BUG9827
     C                   EndIf                                                               BUG9827
     C                   EndIf                                                               BUG9827

     C                   WHEN      DDACTN = 'A'
      *  Processing for Amends
     C                   IF        CDL033 = 'Y'                                               CDL033
     C                   IF        Idx = 0                                                    CDL033
     C                   EXSR      ValidateRC                                                 CDL033
     C                   IF        Idx = 0                                                    CDL033
     C                   EXSR      ValidatePC                                                 CDL033
     C                   ENDIF                                                                CDL033
     C                   IF        DDSTRT <> *BLANKS                                        BUG12589
     C                   EVAL      @@STRT = IKINTR                                          BUG12589
     C                   ENDIF                                                              BUG12589
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      TranIn                                 99
     C     *in99         ifeq      *on
     C                   EXSR      TDtDtaSubs
     C                   endif
     C                   endif
     C                   EXSR      SetupAmend
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt
     C                   EXSR      ValidateLP                                                BUG3992
                                                                                            BUG12589
      ** For Amend:                                                                         BUG12589
      ** If CDL033 is on and short term rate was specified, ensure                          BUG12589
      ** this becomes the prevailing rate as IKINTR value is reset in                       BUG12589
      ** SR/ValidateLP when calling ZAVSPRRATE program                                      BUG12589
     C                   IF        CDL033 = 'Y' and DDSTRT <> *BLANKS                       BUG12589
     C                   EVAL      IKINTR = @@STRT                                          BUG12589
     C                   ENDIF                                                              BUG12589
     C                   EXSR      ValdateAmd
                                                                                             BUG4482
     C                   WHEN      DDACTN = 'X'                                              BUG4482
      *  Processing for Authorises                                                           BUG4482
     C                   EVAL      IKINTR = HKINTR                                         MD037869A
     C                   EVAL      IKSPRD = HKSPRD                                         MD037869A
     C                   EXSR      ValidateTr                                                BUG4482
     C**********         EXSR      ValidateAc                                      BUG6164 MD037869A
     C                   EXSR      ValidateSt                                                BUG4482
     C                   EXSR      ValidateLP                                                BUG3992
     C                   IF        CDL033 = 'Y'                                               CDL033
     C                   IF        Idx = 0                                                    CDL033
     C                   EXSR      ValidateRC                                                 CDL033
     C                   IF        Idx = 0                                                    CDL033
     C                   EXSR      ValidatePC                                                 CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                             BUG9827
      * If dealtype is a fiduciary placing then do SR/ValidateFD                             BUG9827
     C                   IF        CDL006 = 'Y' and Idx = 0                                  BUG9827
     C                   IF        DDTYPE = 'FL' or DDTYPE = 'DP' or                         BUG9827
     C                             DDTYPE = 'LP'                                             BUG9827
     C                   EXSR      ValidateFD                                                BUG9827
     C                   EndIf                                                               BUG9827
     C                   EndIf                                                               BUG9827
                                                                                             BUG9827
     C                   WHEN      DDACTN = 'D'                                              BUG9827
      * If dealtype is a fiduciary placing then do SR/ValidateFD                             BUG9827
     C                   IF        CDL006 = 'Y' and Idx = 0                                  BUG9827
     C                   IF        DDTYPE = 'FL' or DDTYPE = 'DP' or                         BUG9827
     C                             DDTYPE = 'LP'                                             BUG9827
     C                   EXSR      ValidateFD                                                BUG9827
     C                   EndIf                                                               BUG9827
     C                   EndIf                                                               BUG9827

     C                   ENDSL
      *                                                                                       CER043
      ***Population*of*Customer*Details                                                CER043 CSF011
     C**********         IF        CER043 = 'Y'                                        CER043 CSF011
     C**********         EXSR      SrPopCust                                           CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
      *
     C     INVALID       TAG

      ** Populate Customer Name Inputs                                                        CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
                                                                                              CSF011
      *  Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   IF        CDL033 = 'Y'                                              CDL033
     C                   EXSR      SupVALIRC                                                 CDL033
     C                   ENDIF                                                               CDL033
     C                   ENDIF

     C                   SETON                                        LR
     C                   IF        CDL033 = 'Y'                                              CDL033
     C                   MOVEA     RatDATEA      RatDateDS                                   CDL033
     C                   MOVEA     PayDATEA      PayDateDS                                   CDL033
     C                   ENDIF                                                               CDL033

      ** If action is for Update, get the correct record information                         BUG4808
      ** from file                                                                           BUG4808
     C                   IF        UpdateYN = 'Y'                                            BUG4808
     C                             AND Idx = 0                                               BUG8119
     C                   MOVE      IKDN38        DDDLNO_In                                   BUG4808
     C                   CALL      'MMLDNIR'                                                 BUG4808
     C                   PARM                    @AuthComp         1                         BUG4808
     C                   PARM                    @FwdBck           1                         BUG4808
     C                   PARM                    DDDLNO_In         6                         BUG4808
     C                   PARM                    Buffer                                      BUG4808
     C                   PARM                    Buffer2                                      CDL033
     C                   PARM                    BufferEx2                                    CDL033
     C                   PARM                    BufferEx3                                    CSF011
     C                   PARM                    @FldNameArr                                 BUG4808
     C                   PARM                    @MsgIDArr                                   BUG4808
     C                   PARM                    @MsgDtaArr                                  BUG4808
     C                   PARM                    @MsgFArray                                  BUG4808
     C                   PARM                    @APIRetC          1                         BUG4808
     C                   MOVEL     DDACTN        Buffer                                      BUG4808
     C                   MOVE      IKDN38        @ACDLNO                                      CDL033
     C                   MOVEL     DDACTN        @ACDLNO                                      CDL033
     C                   MOVEL     @ACDLNO       Buffer                                       CDL033
     C                   ELSE                                                                BUG4808
     C*******************EVAL                    Buffer = TranIN                              TCA002
     C                   EVAL                    Buffer = TranIN + InfData                    TCA002
     C                                           + RFormula                                   CDL033
     C                                           + PFormula                                   CDL033
     C                                           + SREMK                                      CMM105
     C                                           + DDSTS + DDCSTS                            BUG3986
     C                                           + CPST     + DSPCP                          BUG6512
     C                                           + BKST     + DSPBK                          BUG6512
     C**********                                 + @TimeStamp                        BUG3986 BUG3684
     C**********                                 + @TimeStamp + DDACTC               BUG3684 BUG3792
     C                                           + @TimeStamp + DDACTC + PLATAK              BUG3792
     C                                           + DDFOID                                     239400
     C                                           + #FRECS + #FPAYS                            CDL018
     C                                           + InRecSttmt + InPaySttmt
     C**********                                 + ExtData                                    CER001
     C**********                                 + RegData + ExtData                 CER001 BUG10296
     C                                           + WDUMMY                                   BUG10563
     C                                           + FIDTScnRstN + Filler                      BUG9827
     C**********                                 + TranQExt                         CER049 AR819540A
     C**********                                 + TranInCust                          CER043 CSF011
     C**********                                 + TranQExt                         AR819540A CSF011
     C**********                                 + FIDTScnRpt                         BUG9827 CSF011
                                                                                              CDL033
     C**********         EVAL      Buffer2 = *BLANK                                   CDL033 BUG9827
     C**********         EVAL      Buffer2 = LDNIFil + RegData                      BUG10296 BUG9827
     C****               EVAL      Buffer2 = %SUBST(FIDTScnMft:3516)                         BUG9827
     C**********         EVAL      Buffer2 = %SUBST(FIDTScnRpt:754)                   BUG9827 CSF011
     C**********         EVAL      Buffer2 = %SUBST(Filler:606)                        CSF011 CDL096
     C**********         EVAL      Buffer2 = %SUBST(Filler:572)                        CDL096 CGL165
     C**********         EVAL      Buffer2 = %SUBST(Filler:568)                      CGL165 MD038485
     C                   EVAL      Buffer2 = %SUBST(Filler:354)                             MD038485
     C                                       + TranQExt                                       CSF011
     C                                       + FIDTScnRpt                                     CSF011
     C**********         EVAL      BufferEx2 = RatDateDS + PayDateDS                 CDL033 BUG10943
     C**********                              + RegData                            BUG10563 BUG10943
     C******             EVAL      BufferEx2 = RegData + RatDateDS                 BUG10943 244784
     C******                                  + PayDateDS                          BUG10943 244784
     C**********         EVAL      BufferEx2 = RatDateDS + PayDateDS                   244784 CSF011
     C**********                              + RegData                                244784 CSF011
     C**********                              + ExtData                                248297 CSF011
     C                   EVAL      BufferEx2 = %SUBST(FIDTScnRpt:2438)                        CSF011
     C                                        + RatDateDS + PayDateDS                         CSF011
     C                   EVAL      BufferEx3 = %SUBST(PayDateDS:2885)                         CSF011
     C                                        + RegData + ExtData                             CSF011
     C                   ENDIF                                                               BUG4808

     C                   RETURN

      *****************************************************************
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer Number                                                                     CSF011A
                                                                                             CSF011A
     C                   IF        DDCUST <> *BLANKS                                         CSF011A
     C                   EVAL      PCNum = DDCUST                                            CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Interest Settlement Account                                                         CSF011A
                                                                                             CSF011A
     C                   IF        DDINSA <> *BLANKS                                         CSF011A
                                                                                             CSF011A
     C                   MOVEL     *BLANKS       A#OURA                                      CSF011A
     C                   MOVEL     DDINSA        A#OURA                                      CSF011A
     C                   IF        DDISCY <> *BLANKS                                         CSF011A
     C                   MOVE      DDISCY        @CYCD                                       CSF011A
     C                   ELSE                                                                CSF011A
     C                   MOVE      DDCCY         @CYCD                                       CSF011A
     C                   ENDIF                                                               CSF011A
     C                   EXSR      CNIRTV                                                    CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDIASN = BBCSSN                                           CSF011A
     C                   EVAL      DDIANM = BBCRNM                                           CSF011A
     C                   EVAL      DDIATN = BBCRTN                                           CSF011A
     C                   EVAL      DDIAAN = AC_ANAM                                          CSF011A
     C                   EVAL      DDIASW = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Interest Counterparty Nostro                                                        CSF011A
                                                                                             CSF011A
     C                   IF        DDINOS <> *BLANKS                                         CSF011A
     C                   EVAL      PCNUm = DDINOS                                            CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDINSN = BBCSSN                                           CSF011A
     C                   EVAL      DDINNM = BBCRNM                                           CSF011A
     C                   EVAL      DDINTN = BBCRTN                                           CSF011A
     C                   EVAL      DDINSW = BBCSID                                           CSF011A
     C                   ELSE                                                                CSF011A
     C                   EXSR      ACCNST                                                    CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDINSN = AWCSN1 + AWCSN2                                  CSF011A
     C                   EVAL      DDINNM = AWCPNM                                           CSF011A
     C                   EVAL      DDINTN = AWCNTN                                           CSF011A
     C                   EVAL      DDINSW = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Current Holder of CD                                                                CSF011A
                                                                                             CSF011A
     C                   IF        DDCDCH <> *BLANKS                                         CSF011A
     C                   EVAL      PCNum = DDCDCH                                            CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDCDSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCDNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCDTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACNOST - Access Nostro Details                                *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACNOST        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AONOSTR0'                                                CSF011A
     C                   PARM      *BLANKS       PRtcd                                       CSF011A
     C                   PARM      '*KEY   '     POptn                                       CSF011A
     C                   PARM      *BLANKS       @CUST                                       CSF011A
     C                   PARM                    @CYCD                                       CSF011A
     C                   PARM      *BLANKS       @ACCD                                       CSF011A
     C                   PARM      *BLANKS       @ACSN                                       CSF011A
     C                   PARM                    @NOSN                                       CSF011A
     C                   PARM      *BLANKS       @BRCA                                       CSF011A
     C                   PARM      *BLANKS       @CSSN                                       CSF011A
     C                   PARM      *BLANKS       @PNOI                                       CSF011A
     C     SDNOST        PARM      SDNOST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACACCT - Access Account Details                               *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACACCT        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AOACCTV0'                                                CSF011A
     C                   PARM      *BLANKS       PRtcd                                       CSF011A
     C                   PARM                    @ACID                                       CSF011A
     C                   PARM                    @CYCD                                       CSF011A
     C                   PARM                    @ACCD                                       CSF011A
     C                   PARM                    @ACSN                                       CSF011A
     C                   PARM                    @BRCA                                       CSF011A
     C                   PARM                    @TYPE                                       CSF011A
     C                   PARM                    @NOSN                                       CSF011A
     C     ACCNT         PARM      ACCNT         DSSDY                                       CSF011A
     C                                                                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * ACCNST - Access Counterparty Nostro Details                   *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     ACCNST        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AOCNSTR0'                                                CSF011A
     C                   PARM      *BLANKS       PRtcd                                       CSF011A
     C                   PARM      '*KEY   '     POptn                                       CSF011A
     C                   PARM                    PCNum                                       CSF011A
     C     SDCNST        PARM      SDCNST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * CNIRTV - Retrive Customer and Account Details                 *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     CNIRTV        BEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   SETOFF                                       515253                 CSF011A
     C                   SETOFF                                       54                     CSF011A
                                                                                             CSF011A
     C                   CLEAR                   ACCNT                                       CSF011A
     C                   CLEAR                   SDCUST                                      CSF011A
                                                                                             CSF011A
     C                   TESTN                   A#NOST               51        Nostro       CSF011A
     C                   TESTN                   A#ACOD               52        Ledger       CSF011A
     C   52              TESTN                   A#ACSQ               52        Ledger       CSF011A
     C                   TESTN                   A#RENO               53        Retail       CSF011A
                                                                                             CSF011A
     C                   SELECT                                                              CSF011A
     C                   WHEN      A#CNUM <> *BLANKS AND A#ACAS = *BLANKS                    CSF011A
     C                             AND %LEN(A#CNUM) = 6 AND *IN51 = *OFF                     CSF011A
     C                   EVAL      *IN54 = *ON                                               CSF011A
     C                   EVAL      PCNum = A#CNUM                                            CSF011A
                                                                                             CSF011A
     C                   WHEN      *IN51 = *ON AND A#REST = *BLANKS                          CSF011A
     C                   MOVE      A#NOST        @NOSN                                       CSF011A
     C                   EXSR      ACNOST                                                    CSF011A
     C                   MOVEL     *BLANKS       @ACID                                       CSF011A
     C                   MOVEL     NO_A7CUST     @ACID                                       CSF011A
     C                   MOVE      NO_A7ACCD     @ACCD                                       CSF011A
     C                   MOVE      NO_A7ACSN     @ACSN                                       CSF011A
     C                   MOVE      NO_A7BRCD     @BRCA                                       CSF011A
     C                   IF        @RTCD <> *BLANKS                                          CSF011A
     C                   EVAL      *IN54 = *ON                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   WHEN      *IN52 = *ON                                               CSF011A
     C                   MOVEL     *BLANKS       @ACID                                       CSF011A
     C                   MOVEL     A#CNUM        @ACID                                       CSF011A
     C                   MOVE      A#ACSQ        @ACSN                                       CSF011A
     C                   MOVE      A#ACOD        @ACCD                                       CSF011A
     C                   MOVE      A#BRCA        @BRCA                                       CSF011A
                                                                                             CSF011A
     C                   WHEN      *IN53 = *ON                                               CSF011A
     C                   MOVEL     A#RENO        @ACID                                       CSF011A
     C                   MOVE      *BLANKS       @CYCD                                       CSF011A
     C                   MOVE      *BLANKS       @ACSN                                       CSF011A
     C                   MOVE      *BLANKS       @ACCD                                       CSF011A
     C                   MOVE      *BLANKS       @BRCA                                       CSF011A
                                                                                             CSF011A
     C                   ENDSL                                                               CSF011A
                                                                                             CSF011A
     C  N54              EXSR      ACACCT                                                    CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      PCNum = AC_CNUM                                           CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      ******************************************************************                     CSF011A
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
     C                   PARM                    InfData500
     C                   PARM                    TransQ500                                    CER049
     C**********         PARM                    Trans500C                             CER043 CSF011
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    #FPAYS                                       CDL018
     C                   PARM                    #FRECS                                       CDL018
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
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
     C                   PARM                    Buffer2                                      CDL033
     C                   PARM                    BufferEx2                                    CDL033
     C                   PARM                    BufferEx3                                    CSF011
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp       26                         BUG3986
     C                   PARM                    DDACTC            1                         BUG3684
     C                   PARM                    PLATAK            1                         BUG3792
     C                   PARM                    DDFOID           20                          239400

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'SDUSRMSG'                                  CRE073

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,MMLDNIM01

      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access API ICD via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY

      ** Access SAR details file to determine if
      ** Deposit Breakdown Penalty is installed
      *
     C                   MOVEL     'N'           CDL007            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL007
     C                   ENDIF
      *
      ** Access SAR details file to determine if
      ** Automatic Authorisation (MM Part) is installed
      *
     C                   MOVEL     'N'           CAP051            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP051'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP051
     C                   ENDIF
                                                                                              CDL016
      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
      ** (Automatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
                                                                                              CDL016
     C                   CallB     'AOSARDR0'                                                 CDL016
     C                   Parm      *Blanks       @RTCD                                        CDL016
     C                   Parm      '*VERIFY'     @OPTN                                        CDL016
     C                   Parm      'CDL016'      @SARD                                        CDL016
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL016
      *                                                                                       CDL016
     C                   Move      'N'           CDL016            1                          CDL016
     C                   If        @RTCD = *Blanks                                            CDL016
     C                   Eval      CDL016 = 'Y'                                               CDL016
     C                   Endif                                                                CDL016
                                                                                              CDL018
      ** Access SAR details file to determine if CDL018 is switched on                        CDL018
      ** (Multiple Settlement Accounts on Loans/Deposit)                                      CDL018
                                                                                              CDL018
     C                   CallB     'AOSARDR0'                                                 CDL018
     C                   Parm      *Blanks       PRTCD             7                          CDL018
     C                   Parm      '*VERIFY'     POPTN             7                          CDL018
     C                   Parm      'CDL018'      PSARD             6                          CDL018
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL018
      *                                                                                       CDL018
     C                   Move      'N'           CDL018            1                          CDL018
     C                   If        PRTCD = *Blanks                                            CDL018
     C                   Eval      CDL018 = 'Y'                                               CDL018
     C                   Endif                                                                CDL018
                                                                                              CDL019
      ** Access SAR details file to determine if CDL019 is switched on                        CDL019
      ** (Allow Base Rate Changes on Fixed Deposits/Loans)                                    CDL019
                                                                                              CDL019
     C                   CallB     'AOSARDR0'                                                 CDL019
     C                   Parm      *Blanks       @RTCD                                        CDL019
     C                   Parm      '*VERIFY'     @OPTN                                        CDL019
     C                   Parm      'CDL019'      @SARD                                        CDL019
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL019
      *                                                                                       CDL019
     C                   Move      'N'           CDL019            1                          CDL019
     C                   If        @RTCD = *Blanks                                            CDL019
     C                   Eval      CDL019 = 'Y'                                               CDL019
     C                   Endif                                                                CDL019
                                                                                              CDL020
      ** Access SAR details file to determine if CDL020 is switched on                        CDL020
      ** (Apply Base Rate at Value Date)                                                      CDL020
                                                                                              CDL020
     C                   CallB     'AOSARDR0'                                                 CDL020
     C                   Parm      *Blanks       PRTCD                                        CDL020
     C                   Parm      '*VERIFY'     POPTN                                        CDL020
     C                   Parm      'CDL020'      PSARD                                        CDL020
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL020
      *                                                                                       CDL020
     C                   Move      'N'           CDL020            1                          CDL020
     C                   If        PRTCD = *Blanks                                            CDL020
     C                   Eval      CDL020 = 'Y'                                               CDL020
     C                   Endif                                                                CDL020
      *
      * Access SAR details file to determine if CSC011 switchable feature
      * is switched on

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD = *Blanks

     C                   EVAL      CSC011 = 'Y'

     C                   IN        SC24X7
     C                   IN        SDSTAT

      ** If 24X7 Midas availability is installed and support system is
      ** active, used processing date from dataarea SC24X7 as the
      ** rundate.

     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
     C                   EVAL      WProcDate = S1DATE
     C                   ELSE
     C                   EVAL      WProcDate = BJRDNB
     C                   ENDIF

     C                   ELSE
      ** Database error

     C                   IF        @RTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 900
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 901                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CDL033
      ** Access SAR details file to determine if CDL033 is switch on                          CDL033
      *                                                                                       CDL033
     C                   MOVEL     'N'           CDL033            1                          CDL033
     C                   CALL      'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       @RTCD                                        CDL033
     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
     C                   PARM      'CDL033'      @SARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
      *                                                                                       CDL033
     C     @RTCD         IFEQ      *BLANK                                                     CDL033
     C                   MOVEL     'Y'           CDL033                                       CDL033
     C                   ELSE                                                                 CDL033
      ** Database Error, if Return Code is not blanks or *NRF                                 CDL033
     C     @RTCD         IFNE      '*NRF'                                                     CDL033
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
     C                   MOVEL     '009'         DBASE                                        CDL033
     C                   MOVEL     'CDL033'      DBKEY                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
      ** Verify if Hedge Accounting Enhancement is on.                                        CDL033
                                                                                              CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       @RTCD                                        CDL033
     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
     C                   PARM      'CAS005'      @SARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
     C                   SELECT                                                               CDL033
     C                   WHEN      @RTCD = *BLANKS                                            CDL033
     C                   MOVE      'Y'           CAS005            1                          CDL033
     C                   WHEN      @RTCD <> '*NRF   '                                         CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL033
     C                   EVAL      DBASE = 902                                                CDL033
     C                   EVAL      DBKEY = @SARD                                              CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   OTHER                                                                CDL033
     C                   MOVE      'N'           CAS005                                       CDL033
     C                   ENDSL                                                                CDL033
                                                                                              CDL033
      *                                                                                       CER001
      * Check if Switch ULX600 is on                                                          CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX600'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX600 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX600 = 'N'                                               CER001
                                                                                              CER001
     C                   IF        PRTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX600'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 909                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *                                                                                      BUG9827
      ** Access SAR details file to determine if CDL006 is switch on                         BUG9827
      *                                                                                      BUG9827
     C                   MOVEL     'N'           CDL006            1                         BUG9827
     C                   CALL      'AOSARDR0'                                                BUG9827
     C                   PARM      *BLANKS       @RTCD                                       BUG9827
     C                   PARM      '*VERIFY'     @OPTN                                       BUG9827
     C                   PARM      'CDL006'      @SARD                                       BUG9827
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9827
      *                                                                                      BUG9827
     C     @RTCD         IFEQ      *BLANK                                                    BUG9827
     C                   MOVEL     'Y'           CDL006                                      BUG9827
     C                   ELSE                                                                BUG9827
      ** Database Error, if Return Code is not blanks or *NRF                                BUG9827
     C     @RTCD         IFNE      '*NRF'                                                    BUG9827
     C                   MOVEL     'SCSARDPD'    DBFILE                                      BUG9827
     C                   MOVEL     '010'         DBASE                                       BUG9827
     C                   MOVEL     'CDL006'      DBKEY                                       BUG9827
     C                   EXSR      *PSSR                                                     BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
      ** Modules Details                                                                     BUG9827
                                                                                             BUG9827
     C                   CALLB     'AOMMODR0'                                                BUG9827
     C                   PARM      '*DBERR '     @RTCD                                       BUG9827
     C                   PARM      '*FIRST '     @OPTN                                       BUG9827
     C     SDMMOD        PARM      SDMMOD        DSFDY                                       BUG9827
                                                                                             BUG9827
     C                   IF        @RTCD <> *BLANKS                                          BUG9827
     C     *LOCK         IN        LDA                                                       BUG9827
     C                   EVAL      DBKEY = '*FIRST'                                          BUG9827
     C                   EVAL      DBFILE = 'SDMMODPD'                                       BUG9827
     C                   EVAL      DBASE = 011                                               BUG9827
     C                   OUT       LDA                                                       BUG9827
     C                   EXSR      *PSSR                                                     BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
      ** ICD Portfolio Management                                                            BUG9827
                                                                                             BUG9827
     C     BGPFMG        IFEQ      'Y'                                                       BUG9827
     C                   CALLB     'AOPORTR0'                                                BUG9827
     C                   PARM      *BLANKS       @RTCD                                       BUG9827
     C                   PARM      '*FIRST '     @OPTN                                       BUG9827
     C     SDPORT        PARM      SDPORT        DSFDY                                       BUG9827
     C                   IF        @RTCD <> *BLANKS                                          BUG9827
     C     *LOCK         IN        LDA                                                       BUG9827
     C                   EVAL      DBKEY = '*FIRST'                                          BUG9827
     C                   EVAL      DBFILE = 'SDPORTPD'                                       BUG9827
     C                   EVAL      DBASE = 012                                               BUG9827
     C                   OUT       LDA                                                       BUG9827
     C                   EXSR      *PSSR                                                     BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
      ** Access to Deal ICD file to retrieve Placing and Taking range                        BUG9827
     C                   CALLB     'AODEALR1'                                                BUG9827
     C                   PARM      '*DBERR '     @RTCD                                       BUG9827
     C                   PARM      '*FIRST '     @OPTN                                       BUG9827
     C     SDDEAL        PARM      SDDEAL        DSFDY                                      BUG10725
                                                                                             BUG9827
     C     @RTCD         IFNE      *BLANKS                                                   BUG9827
     C     *LOCK         IN        LDA                                                       BUG9827
     C                   MOVE      *ON           *INU7                                       BUG9827
     C                   MOVE      *ON           *INU8                                       BUG9827
     C                   Z-ADD     014           DBASE                                       BUG9827
     C                   MOVEL     'SDDEALPD'    DBFILE                                      BUG9827
     C                   MOVEL     '*FIRST'      DBKEY                                       BUG9827
     C                   OUT       LDA                                                       BUG9827
     C                   EXSR      *PSSR                                                     BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
      ** Check if S01468 is installed                                                        BUG9827
                                                                                             BUG9827
     C                   CALL      'AOSARDR0'                                                BUG9827
     C                   PARM      *BLANKS       PRTCD                                       BUG9827
     C                   PARM      '*VERIFY'     POPTN                                       BUG9827
     C                   PARM      'S01468'      PSARD                                       BUG9827
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9827
                                                                                             BUG9827
     C                   IF        PRTCD = *BLANKS                                           BUG9827
     C                   EVAL      S01468 = 'Y'                                              BUG9827
     C                   ELSE                                                                BUG9827
     C                   EVAL      S01468 = 'N'                                              BUG9827
                                                                                             BUG9827
     C                   IF        PRTCD <> '*NRF'                                           BUG9827
     C     *LOCK         IN        LDA                                                       BUG9827
     C                   EVAL      DBKEY = 'S01468'                                          BUG9827
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9827
     C                   EVAL      DBASE = 013                                               BUG9827
     C                   OUT       LDA                                                       BUG9827
     C                   EXSR      *PSSR                                                     BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
      ** Define KLIST to access DLCCGDL0                                                     BUG9827
                                                                                             BUG9827
     C     WWDLCC        KLIST                                                               BUG9827
     C                   KFLD                    WWCCY             3                         BUG9827
     C                   KFLD                    FDCCOM                                      BUG9827
                                                                                              CAP087
      ** Access SAR details file to determine if CSE006 is switched on                        CAP087
                                                                                              CAP087
     C                   CallB     'AOSARDR0'                                                 CAP087
     C                   Parm      *Blanks       PRTCD                                        CAP087
     C                   Parm      '*VERIFY'     POPTN                                        CAP087
     C                   Parm      'CSE006'      PSARD                                        CAP087
     C     SCSARD        Parm      SCSARD        DSFDY                                        CAP087
      *                                                                                       CAP087
     C                   Move      'N'           CSE006            1                          CAP087
     C                   If        PRTCD = *Blanks                                            CAP087
     C                   Eval      CSE006 = 'Y'                                               CAP087
     C                   Endif                                                                CAP087
      *                                                                                       CER043
      ** Check if CER043 is switched on                                                       CER043
                                                                                              CER043
     C                   CALL      'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM      '*VERIFY'     POPTN                                        CER043
     C                   PARM      'CER043'      PSARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ELSE                                                                 CER043
     C                   EVAL      CER043 = 'N'                                               CER043
                                                                                              CER043
     C                   IF        PRTCD <> '*NRF'                                            CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 907                                                CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   ENDIF                                                                CER043
     C/COPY WNCPYSRC,MMLDNIXC03

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************

     C     ValidateAc    BEGSR

      * Validate action code versus transaction IDs supplied
      * This function will set the Midas deal number and the Midas
      * associated deal number.
      * The deal in file format from the MM database is retrieved as well.

     C                   RESET                   ReturnCode
     C                   CALLB     'MMLDNIRTV'

      * INPUTS
      * Return code
     C                   PARM                    ReturnCode

      * Mode = '*FRONT' (Front Office transaction interface)
      * Mode = '      ' (Not Front Office transaction interface)
     C                   PARM      '      '      ModeofOp          6
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

      * (Midas) Depot Movement Reference

     C                   PARM                    DDDDMR            6

      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN

      * Booking branch
     C                   PARM                    DDBRCA

      * REPO Flag
     C                   PARM                    RepoFlag          1

      * OUTPUTS
      * (Current) deal in file format
     C                   PARM                    DealFilFmt

      * OK - Action code
     C                   PARM                    OKACTN

      * OK - Deal Number
     C                   PARM                    OKDLNO

      * OK - Booking branch
     C                   PARM                    OKBRCA
                                                                                              CDL016
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT             1                          CDL016

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning flds/message IDs/message data (arrays) from/to caller

     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    WIdx
     C/COPY WNCPYSRC,MMLDNIXC06
      *
      ** Default current system date to Deal Date when inserting
      ** a new transaction.
      *
     C     DDACTN        IFEQ      *BLANK
     C                   EXSR      SetupDDAT
     C                   ENDIF
      *                                                                                     BUG10677
      ** Call MMLDNIWRN where necessary when deleting fiduciary deals                       BUG10677
      *                                                                                     BUG10677
     C                   IF        CDL006 = 'Y' and DDACTN = 'D'                            BUG10677
      *                                                                                     BUG10677
     C                   IF        DDTYPE = 'FL' or DDTYPE = 'DP' or                        BUG10677
     C                             DDTYPE = 'LP'                                            BUG10677
     C**********         IF        HKDSTS = 'C'                                    BUG10677 BUG10718
     C                   IF        HKDSTS = 'C' or                                          BUG10718
     C                             HKDSTS = 'A'                                             BUG10718
     C                   CALLB     'MMLDNIWRN'                                              BUG10677
     C                   PARM                    DDDLNO                                     BUG10677
     C                   PARM                    DDTYPE                                     BUG10677
     C                   PARM                    WFldNamArr                                 BUG10677
     C                   PARM                    WMsgIdArr                                  BUG10677
     C                   PARM                    WMsgDtaArr                                 BUG10677
     C                   PARM                    WIdx                                       BUG10677
     C                   ENDIF                                                              BUG10677
     C                   ENDIF                                                              BUG10677
      *                                                                                     BUG10677
     C                   IF        DDTYPE = 'FT' or DDTYPE = 'DT' or                        BUG10677
     C                             DDTYPE = 'LT'                                            BUG10677
     C                   CALLB     'MMLDNIWRN'                                              BUG10677
     C                   PARM                    DDDLNO                                     BUG10677
     C                   PARM                    DDTYPE                                     BUG10677
     C                   PARM                    WFldNamArr                                 BUG10677
     C                   PARM                    WMsgIdArr                                  BUG10677
     C                   PARM                    WMsgDtaArr                                 BUG10677
     C                   PARM                    WIdx                                       BUG10677
     C                   ENDIF                                                              BUG10677
      *                                                                                     BUG10677
     C                   ENDIF                                                              BUG10677

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
     C                             AND DDCcy  <> *BLANK                                       241685
     C                             AND DDCust <> *BLANK                                       241685
     C                             AND DDACTN = 'I'                                        MD027337A
     C                             OR  DDACTN = 'A'                                        MD027337A
     C                             AND DDCcy  <> *BLANK                                    MD027337A
     C                             AND DDCust <> *BLANK                                    MD027337A
     C                             AND (DDRSTM = *blank                                    MD027337A
     C                             OR  DDPSTM = *blank)                                    MD027337A

     C/COPY WNCPYSRC,MMH00034
     C                   CALLB     'ZASETINDFT'

      ** Output
      ** Calling function type
     C                   PARM                    LDNI
      ** Payment currency (or deal cuurency if only one currency on deal)
     C                   PARM                    DDCcy
      ** Receive currency (only if deal has two currencies)
     C                   PARM                    DDCcy
      ** Customer (shortname or number)
     C                   PARM                    DDCust
      ** Deal type
     C                   PARM                    DDType
      ** Federal Funds Ind.
     C                   PARM                    DDFedF
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    Blank4
      ** Type of ISDA agreement
     C                   PARM                    Blank6
      ** Date of ISDA Agreement
     C                   PARM                    Blank6
      ** Version of ISDA Agreement
     C                   PARM                    Blank2
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2
      ** Deal Subtype                                                                         CSD095
     C                   PARM                    DDSTYP                                       CSD095
      ** Branch                                                                               CSD095
     C                   PARM                    DDBRCA                                       CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt
     C/COPY WNCPYSRC,MMH00035

      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.

     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt

      ** Current Settlement Instruction in input format
     C                   PARM                    CrPaySttmt
     C                   PARM                    CrRecSttmt
     C                   PARM                    CrFRASttmt
     C                   PARM      DDCCY         #TRCCY                                      CSF011A
     C                   PARM      DDCCY         #TPCCY                                      CSF011A

      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the deal.

     C**********         IF            (InPaySttmt = *blank)                                MD027337
     C                   IF            (DDPSTM = *blank)                                    MD027337
     C                   EVAL      InPaySttmt = CrPaySttmt
     C                   ENDIF

     C**********         IF            (InRecSttmt = *blank)                                MD027337
     C                   IF            (DDRSTM = *blank)                                    MD027337
     C                   EVAL      InRecSttmt = CrRecSttmt
     C                   ENDIF

      * Do data substitution for Settlement Instructions

     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      InPaySttmt                             99
     C  N99GHSUBS        scan      InRecSttmt                             99
     C     *in99         ifeq      *on
     C                   EXSR      SDtDtaSubs
     C                   endif
     C                   endif

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

      * For Amends, put the complete (pre-existing) deal into the Valid
      *  file record - fields in this will be updated during  processing
     C                   MOVEL     DealFilFmt    ValidDeal
     C                   Z-ADD     HKRRAT        IKRRAT                                     BUG12551
     C                   Z-ADD     HKMATD        OLD_MATD
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

     C**********         EVAL      DBRecSttmt = DELDRecIns + HKROBR                           CGL029
     C                   EVAL      FLRSTM     = HKRSTM                                        CGL029
     C                   EVAL      FLRONS     = HKRONS                                        CGL029
     C                   EVAL      FLREC2     = DELDRecIns                                    CGL029
     C                   EVAL      FLROBR     = HKROBR                                        CGL029
     C                   EVAL      FLRSCY     = HKSTCY
     C                   EVAL      FLRMAC     = HKRMAC                                        CDL018
     C**********         EVAL      DBPaySttmt = DELDPayIns + HKPOBR + HKCVMR                  CGL029
     C                   EVAL      FLPSTM     = HKPSTM                                        CGL029
     C                   EVAL      FLPONS     = HKPONS                                        CGL029
     C                   EVAL      FLPAY2     = DELDPayIns                                    CGL029
     C                   EVAL      FLPOBR     = HKPOBR                                        CGL029
     C                   EVAL      FLCVMR     = HKCVMR                                        CGL029
     C                   EVAL      FLPSCY     = HKSTCY
     C                   EVAL      FLIC72     = HKIC72
     C                   EVAL      FLPMAC     = HKPMAC                                        CDL018
     C                   EVAL      FLRBB1     = HKRBB1                                        CDL094
     C                   EVAL      FLRBB2     = HKRBB2                                        CDL094
     C                   EVAL      FLRBB3     = HKRBB3                                        CDL094
     C                   EVAL      FLRBB4     = HKRBB4                                        CDL094
     C                   EVAL      FLRBB5     = HKRBB5                                        CDL094
     C                   EVAL      FLRBB6     = HKRBB6                                        CDL094

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
     C                   PARM      HKCCY         #TRCCY                                      CSF011A
     C                   PARM      HKCCY         #TPCCY                                      CSF011A

     C                   ELSE                                                               MD027337
     C                   IF        DDRSTM = *BLANK                                         MD027337A
     C                             OR DDPSTM = *BLANK                                      MD027337A
     C                   EXSR      DftSettmts                                               MD027337
     C                   ENDIF                                                             MD027337A
     C                   ENDIF

      * Do data substitution for Settlement Instructions

     C     GHSUBS        IFNE      *BLANK
     C     GHSUBS        SCAN      InPaySttmt                             99
     C  N99GHSUBS        SCAN      InRecSttmt                             99
     C     *IN99         IFEQ      *ON
     C                   EXSR      SDtDtaSubs
     C                   ENDIF
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

     C                   CALLB     'MMLDNIVAL'
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
     C                   PARM      HKFRNT        @@FRNT           20
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    MMELDN
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
     C*******************PARM      'N'           RepoFlag          1                          CAP087
     C                   PARM                    RepoFlag          1                          CAP087
     C/COPY WNCPYSRC,MMLDNIXC04
      *                                                                                       CDL016
      * If errors bypass Screen 2 validation                                                  CDL016
      *                                                                                       CDL016
     C                   IF        Idx <> *ZERO                                               CDL016
     C                   GOTO      EValTr                                                     CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
      * Validate screen 2 if feature is on and Fixed Deposit Deal                             CDL016
      *                                                                                       CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
     C     CDL019        OREQ      'Y'                                                        CDL019
     C     CDL020        OREQ      'Y'                                                        CDL020
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDType        ANDEQ     'CF'                                                       CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDType        ANDEQ     'CI'                                                       CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDType        ANDEQ     'IP'                                                       CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDType        ANDEQ     'IT'                                                       CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDType        ANDEQ     'TI'                                                       CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDType        ANDEQ     'TD'                                                       CDL033
      *                                                                                       CDL016
     C                   CALLB     'MMLDNIVL2'                                                CDL016
      * Response mode (1A), from source system common header                                  CDL016
     C                   PARM                    APRespMode                                   CDL016
      * Transaction information (DS) from source system                                       CDL016
     C                   PARM                    TranIn                                       CDL016
     C                   PARM                    InfData                                      CDL016
      * Receive Settlement Currency, Method & Nostro and                                      CDL016
      * Payment Settlement Currency, Method & Nostro                                          CDL016
      * Extra Data                                                                            CDL016
     C                   PARM      *BLANK        RecSetCcy                                    CDL016
     C                   PARM      *ZERO         RecSetMeth                                   CDL016
     C                   PARM                    RecNostro                                    CDL016
     C                   PARM      *BLANK        PaySetCcy                                    CDL016
     C                   PARM      *ZERO         PaySetMeth                                   CDL016
     C                   PARM                    PayNostro                                    CDL016
     C                   PARM      HKFRNT        @@FRNT                                       CDL016
     C                   PARM                    ExtData                                      CDL016
      * Field OK flags (DS) from/to caller                                                    CDL016
     C                   PARM                    MMELDN2                                      CDL016
      * Error fields/message IDs/message data (arrays) from/to caller                         CDL016
     C                   PARM                    FldNameArr                                   CDL016
     C                   PARM                    MsgIDArr                                     CDL016
     C                   PARM                    MsgDtaArr                                    CDL016
      * Array index (3P0) from/to caller                                                      CDL016
     C                   PARM                    Idx                                          CDL016
      * Warning fields/message IDs/message data (arrays) from/to caller                       CDL016
     C                   PARM                    WFldNamArr                                   CDL016
     C                   PARM                    WMsgIDArr                                    CDL016
     C                   PARM                    WMsgDtaArr                                   CDL016
      * Array index (3P0) from/to caller                                                      CDL016
     C                   PARM                    WIdx                                         CDL016
      * Valid Deals layout (DS) from/to caller                                                CDL016
     C                   PARM                    ValidDeal                                    CDL016
     C                   PARM      'N'           RepoFlag          1                          CDL016
     C                   PARM                    CDL016                                       CDL016
     C                   PARM                    CDL019                                       CDL019
     C                   PARM                    CDL020                                       CDL020
     C                   PARM                    CAS005                                       CDL033
     C                   PARM                    CDL033                                       CDL033
     C                   PARM      IKINTR        SRate                                        CDL033
                                                                                              CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL016
     C                   IF        ULX600 = 'Y'                                               CER001
     C                   EXSR      ValidateLUX                                                CER001
                                                                                              CER001
     C     Ix            IFNE      0                                                          CER001
     C                   GOTO      EValTr                                                     CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C     EValTr        TAG                                                                  CDL016

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
     C                   CALLB     'MMLDNIVLP'                                               BUG3992
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
     C                   PARM      HKFRNT        @@FRNT           20                         BUG3992
     C                   PARM                    ExtData                                     BUG3992
      * Field OK flags (DS) from/to caller                                                   BUG3992
     C                   PARM                    MMELDN                                      BUG3992
     C                   PARM                    MMELDN2                                     BUG5169
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
     C                   PARM      'N'           RepoFlag          1                         BUG3992
     C/COPY WNCPYSRC,MMLDNIXC07                                                              BUG3992
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
     C                   IF        NOT (OKCUST = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF

      * The called module uses the value date in Midas Day Number format,
      *  which will not have been returned from the overall validation
      *  routine, so it needs to be converetd here.

     C                   IF        OKVDAT <> 'N'

     C                   CALLB     'ZDATE1'
     C                   PARM                    DDVDAT
     C                   PARM                    ValDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag

      * If the Deal Type is for a Loan,    set the Pay Date = Value Date
      * If the Deal Type is for a Deposit, set the Receive Date = Value Date
     C                   IF           DDType = 'IP' OR DDType = 'TI'
     C                             OR DDType = 'CL' OR DDType = 'LN'
     C                             OR DDType = 'DL'
     C                   EVAL      PayDat = ValDateMDN
     C                   ELSE
     C                   EVAL      RecDat = ValDateMDN
     C                   ENDIF
      *                                                                                       260428
     C     DDACTN        IFNE      'I'                                                        260428
      *                                                                                       260428
      * Convert Transaction Date to a Midas Day Number                                        260428
      *                                                                                       260428
     C                   Z-ADD     IKDTYY        @@YEAR                                       260428
     C                   Z-ADD     IKDTMM        @@MNTH                                       260428
     C                   Z-ADD     IKDTDD        @@DAY                                        260428
     C     @@DTIN        IFEQ      0                                                          260428
     C                   Z-ADD     BJRDNB        TransDate                                    260428
     C                   ELSE                                                                 260428
     C                   CALLB     'ZDATE10'                                                  260428
     C                   PARM                    @@DTIN                                       260428
     C                   PARM                    ZZMDNO            5 0                        260428
     C                   MOVE      ZZMDNO        TransDate         5 0                        260428
     C                   ENDIF                                                                260428
      *                                                                                       260428
      * Protect Payment/Receive instructions if dates                                         260428
      * are in the past and the deal was not done today                                       260428
      *                                                                                       260428
     C                   EVAL      W#CCY = *BLANKS                                          MD022656
     C     PayDat        IFLT      BJRDNB                                                     260428
     C     TransDate     ANDNE     BJRDNB                                                     260428
     C     DDACTN        OREQ      'X'                                                       260428A
     C                   MOVEL     'Y'           ##PPAY                                       260428
     C                   IF        DDACTN = 'A'                                             MD022656
     C                   EXSR      SrPayAmnd                                                MD022656
     C                   ENDIF                                                              MD022656
     C                   ELSE                                                                 260428
     C                   MOVEL     'N'           ##PPAY                                       260428
     C                   ENDIF                                                                260428
     C     RecDat        IFLT      BJRDNB                                                     260428
     C     TransDate     ANDNE     BJRDNB                                                     260428
     C     DDACTN        OREQ      'X'                                                       260428A
     C                   MOVEL     'Y'           ##PREC                                       260428
     C                   IF        DDACTN = 'A'                                             MD022656
     C                   EXSR      SrRecAmnd                                                MD022656
     C                   ENDIF                                                              MD022656
     C                   ELSE                                                                 260428
     C                   MOVEL     'N'           ##PREC                                       260428
     C                   ENDIF                                                                260428
     C                   ENDIF                                                                260428

     C                   ENDIF

     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'

      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    LDNI
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Customer (shortname or number)
     C                   PARM                    DDCUST
      ** Deal type
     C                   PARM                    DDTYPE
      ** Federal Funds Ind.
     C                   PARM                    DDFEDF
      ** Booking Branch
     C                   PARM                    DDBrCA
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
      ** Extra Input
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
                                                                                              CDL018
      ** Validate Further Settlement Instructions                                             CDL018
                                                                                              CDL018
     C     CDL018        IFEQ      'Y'                                                        CDL018
     C     Idx           ANDEQ     0                                                          CDL018
      *                                                                                       CDL018
     C     DDTYPE        IFEQ      'IT'                                                       CDL018
     C     DDTYPE        OREQ      'IP'                                                       CDL018
     C     DDTYPE        OREQ      'TD'                                                       CDL018
     C     DDTYPE        OREQ      'TI'                                                       CDL018
      *                                                                                       CDL018
     C     DDRMAC        IFEQ      'Y'                                                        CDL018
     C     DDPMAC        OREQ      'Y'                                                        CDL018
      *                                                                                       CDL018
     C                   CALLB     'ZAFSETIVAL'                                               CDL018
      *                                                                                       CDL018
      ** INPUTS                                                                               CDL018
      ** Return Code                                                                          CDL018
     C                   PARM      *BLANKS       ReturnCode                                   CDL018
      *                                                                                       CDL018
      ** Calling program                                                                      CDL018
     C                   PARM                    LDNI                                         CDL018
      *                                                                                       CDL018
      ** Payment currency                                                                     CDL018
     C                   PARM                    DDCCY                                        CDL018
      *                                                                                       CDL018
      ** Receive currency                                                                     CDL018
     C                   PARM                    DDCCY                                        CDL018
      *                                                                                       CDL018
      ** Transaction Type                                                                     CDL018
     C                   PARM                    DDTYPE                                       CDL018
      *                                                                                       CDL018
      ** Booking branch                                                                       CDL018
     C                   PARM                    DDBrCA                                       CDL018
      *                                                                                       CDL018
      ** Receipt Date                                                                         CDL018
      ** (must = 99999 if no back valuation validation to be done)                            CDL018
     C                   PARM                    RecDat                                       CDL018
      *                                                                                       CDL018
      ** Payment Date                                                                         CDL018
      ** (must = 99999 if no back valuation validation to be done)                            CDL018
     C                   PARM                    Paydat                                       CDL018
      *                                                                                       CDL018
      ** Payment - Settle instructions - Screen format                                        CDL018
     C                   PARM                    InPaySttmt                                   CDL018
      *                                                                                       CDL018
      ** Receive - Settle instructions - Screen format                                        CDL018
     C                   PARM                    InRecSttmt                                   CDL018
      *                                                                                       CDL018
      ** Payment - Further Settle instructions - Screen format                                CDL018
     C                   PARM                    #FPAYS                                       CDL018
      *                                                                                       CDL018
      ** Receive - Further Settle instructions - Screen format                                CDL018
     C                   PARM                    #FRECS                                       CDL018
      *                                                                                       CDL018
      ** Action Code                                                                          CDL018
     C                   PARM                    ##ACTN                                       CDL018
      *                                                                                       CDL018
      ** Protect Payment Field                                                                CDL018
     C                   PARM                    ##PPAY                                       CDL018
      *                                                                                       CDL018
      ** Protect Receipt Field                                                                CDL018
     C                   PARM                    ##PREC                                       CDL018
      *                                                                                       CDL018
      ** LDNI Deal details                                                                    CDL018
     C                   PARM                    ValidDeal                                    CDL018
      *                                                                                       CDL018
      ** OUTPUTS                                                                              CDL018
      ** Errors in Payment further settle instructions                                        CDL018
     C                   PARM                    #FPAYE                                       CDL018
      *                                                                                       CDL018
      ** Errors in Receive further settle instructions                                        CDL018
     C                   PARM                    #FRECE                                       CDL018
      *                                                                                       CDL018
      ** Error fields/message IDs/message data (arrays) from/to caller                        CDL018
     C                   PARM                    FldNameArr                                   CDL018
     C                   PARM                    MsgIDArr                                     CDL018
      *                                                                                       CDL018
      ** Array index (3P0) from/to caller                                                     CDL018
     C                   PARM                    Idx                                          CDL018
      *                                                                                       CDL018
      ** Warning Messages                                                                     CDL018
     C                   PARM                    WFldNamArr                                   CDL018
     C                   PARM                    WMsgIDArr                                    CDL018
     C                   PARM                    WMsgDtaArr                                   CDL018
     C                   PARM                    WIdx                                         CDL018
      *                                                                                       CDL018
      ** Payment - Further Settle instructions - File format                                  CDL018
     C                   PARM                    #FPAYF                                       CDL018
      *                                                                                       CDL018
      ** Receive - Further Settle instructions - File format                                  CDL018
     C                   PARM                    #FRECF                                       CDL018
      *                                                                                       CDL018
     C                   ELSE                                                                BUG4380
     C                   CLEAR                   #FPAYS                                      BUG4380
     C                   CLEAR                   #FRECS                                      BUG4380
     C                   ENDIF                                                                CDL018
     C                   ENDIF                                                                CDL018
     C                   ENDIF                                                                CDL018

     C     ValSetExit    TAG

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************

     C     TDtDtaSubs    BEGSR

      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT

     C                   RESET                   ReturnCode
     C                   CALLB     'MMLDNICVT'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt

      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS
      *
      ** Collateral Status
     C                   PARM                    DDCSTS           10

      ** DATA SUBSTITUTION

     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranIn        IncDATA        2000
      * Current Data
     C                   PARM      DealScnfmt    CurDATA        2000

     C                   MOVEL     IncDATA       TranIn

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *                                                               *
      *****************************************************************

     C     SDtDtaSubs    BEGSR

      ** PAYMENT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InPaySttmt    IncDATA
      * Current Data
     C                   PARM      CrPaySttmt    CurDATA

     C                   MOVEL     IncDATA       InPaySttmt

      ** RECEIPT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InRecSttmt    IncDATA
      * Current Data
     C                   PARM      CrRecSttmt    CurDATA

     C                   MOVEL     IncDATA       InRecSttmt

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

      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.  Some are never amendable and some depend upon ICD
      ** settings as to whether they are amendable.

      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.

      ** These fields are then compared with the fields on the input
      ** transaction.

      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.

      * Convert file format to screen format

     C                   RESET                   ReturnCode
     C                   CALLB     'MMLDNICVT'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt

      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      ** Collateral Status
     C                   PARM                    DDCSTS           10

      ** AMEND CHECKING
     C                   RESET                   ReturnCode
     C                   CALLB     'MMLDNIAMD'

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
     C                   PARM                    MMELDN
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1                          CDL038
     C*******************PARM      'N'           ResetErrs         1                          CDL038

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
     C     WriteToDB     BEGSR

     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDEALN
     C                   ENDIF

     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR
      *                                                                                       CDL016
      * Update Valid Deal: Blocked Indicator                                                  CDL016
      *                                                                                       CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
      *                                                                                       CDL016
     C     BUACT         IFEQ      'B'                                                        CDL016
     C                   MOVE      'Y'           IKBLKA                                       CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C     BUACT         IFEQ      'U'                                                        CDL016
     C     DDACTN        OREQ      'I'                                                        CDL016
     C                   MOVE      'N'           IKBLKA                                       CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
     C                   ENDIF                                                                CDL016
      *
      * Money Market updates
      *
      * Setup parameters for Block, Unblock action.                                          BUG4097
      * Borrow the return code parameter to send the Block, Unblock condition.               BUG4097
     C                   MOVE      *BLANKS       @RTCD                                       BUG4097
     C     DDACTC        IFEQ      'B'                                                       BUG4097
     C                   MOVE      'BLOCK  '     @RTCD                                       BUG4097
     C                   END                                                                 BUG4097
     C     DDACTC        IFEQ      'U'                                                       BUG4097
     C                   MOVE      'UNBLOCK'     @RTCD                                       BUG4097
     C                   END                                                                 BUG4097
      *                                                                                      BUG4097
     C                   CALLB     'MMLDNIUPM'
     C**********         PARM      *BLANK        @RTCD             7                         BUG4097
     C                   PARM                    @RTCD             7                         BUG4097
     C                   PARM                    ValidDeal
     C                   PARM                    #FPAYF                                       CDL018
     C                   PARM                    #FRECF                                       CDL018
      ** FRCD Issued Extension details before update                                          256638
     C                   PARM                    PBFRCD          100                          256638
      ** FRCD Issued Extension details after update                                           256638
     C                   PARM                    PAFRCD          100                          256638
     C                   PARM                    TranQExt                                     CER049
      *                                                                                       256638
     C/COPY WNCPYSRC,MMLDNIXC05
      *
      * Deals updates
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RTCD
     C                   PARM                    ValidDeal
     C                   PARM                    #FPAYF                                     AR863263
     C                   PARM                    #FRECF                                     AR863263
     C                   PARM                    PBFRCD                                     AR863263
     C                   PARM                    PAFRCD                                     AR863263
     C                   END
      *                                                                                       CDL018
      * Further Settlement Instructions updates                                               CDL018
      *                                                                                       CDL018
     C     CDL018        IFEQ      'Y'                                                        CDL018
     C     @RTCD         ANDEQ     *BLANK                                                     CDL018
     C     DDACTN        IFEQ      'I'                                                       BUG3869
     C     DDACTN        OREQ      'A'                                                       BUG3869
     C                   CALLB     'ZAFSETIUPD'                                               CDL018
     C                   PARM                    @RTCD                                        CDL018
     C                   PARM                    DDDLNO                                       CDL018
     C**********         PARM                    FLRMAC                               CDL018 BUG3869
     C**********         PARM                    FLPMAC                               CDL018 BUG3869
     C                   PARM                    IKRMAC                                      BUG3869
     C                   PARM                    IKPMAC                                      BUG3869
     C                   PARM                    #FPAYF                                       CDL018
     C                   PARM                    #FRECF                                       CDL018
     C                   ENDIF                                                               BUG3869
     C                   ENDIF                                                                CDL018
      *                                                                                       CER001
      ** Update LUX extension detail file                                                     CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *Blanks and                                        CER001
     C                             ULX600 = 'Y'                                               CER001
     C                   EVAL      #6LXVLDN38 = IKDN38                                        CER001
     C                   CALLB     'MMLDNI2UP'                                                CER001
     C                   PARM      DDACTN        ACTN                                         CER001
     C                   PARM                    @RTCD                                        CER001
     C                   PARM      'Y'           WFIND                                        CER001
     C                   PARM                    ValidLUX                                     CER001
     C                   PARM                    SVRCD                                        CER001
     C                   ENDIF                                                                CER001
                                                                                             BUG9827
     C                   IF        CDL006 = 'Y' and DDACTN <> 'A'                            BUG9827
     C                   IF        DDTYPE = 'FL' or DDTYPE = 'DP' or                         BUG9827
     C                             DDTYPE = 'LP'                                             BUG9827
     C**********         IF        HKDSTS <> 'R'                                    BUG9827 BUG10677
      * Only delete/authorise associated takings if status is not 'R' or 'A'                BUG10677
      * else could be left could be with outstanding records on WIP file.                   BUG10677
     C                   IF        HKDSTS <> 'R' and HKDSTS <> 'A'                          BUG10677
     C                   EXSR      SupFIDT                                                   BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     @RTCD         IFNE      *BLANK
     C**** @RTCD         ANDNE     '*RECUPD'                                                  248297
     C**********         MOVEL     '0'           APIRetc                                    AR751620
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ENDIF                                                                CSC022
     C     @RTCD         IFNE      '*RECUPD'                                                AR751620
     C                   MOVEL     '0'           APIRetc                                    AR751620
     C                   EXSR      *PSSR
     C                   ENDIF                                                              AR751620
     C                   ELSE
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   ADD       1             Idx                                        AR751620
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C**********         MOVEL     'MMM1067'     MsgIdArr(1)                                AR751620
     C                   MOVEL     'MMM1099'     MsgIdArr(1)                                AR751620
     C
     C                   END

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

     C                   MOVE      *ALL'Y'       MMELDN
     C                   MOVE      *ALL'Y'       MMELDN2                                     BUG5169

     C                   RESET                   AmendOK

     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKFRAInsDS

     C                   RESET                   PayDat
     C                   RESET                   RecDat

     C                   CLEAR                   ValidDeal
      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      ** there are long alpha fileds overlapping these which cause the
      ** CLEAR to put blanks in the numeric fields
     C                   Z-ADD     *ZERO         IKRSTM
     C**********         Z-ADD     *ZERO         IKROBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKROCN                                       CSD027
     C                   EVAL      IKROBN = *BLANKS                                           CSD027
     C                   EVAL      IKROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IKPSTM
     C**********         Z-ADD     *ZERO         IKPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKPOCN                                       CSD027
     C                   EVAL      IKPOBN = *BLANKS                                           CSD027
     C                   EVAL      IKPOCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IKOMDT

      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt

      ** Initalise Customer name on Input fields                                             CSF011A
                                                                                             CSF011A
     C                   EVAL      DDCRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCRTN = *BLANKS                                          CSF011A
     C                   EVAL      DDIASN = *BLANKS                                          CSF011A
     C                   EVAL      DDIANM = *BLANKS                                          CSF011A
     C                   EVAL      DDIATN = *BLANKS                                          CSF011A
     C                   EVAL      DDIAAN = *BLANKS                                          CSF011A
     C                   EVAL      DDIASW = *BLANKS                                          CSF011A
     C                   EVAL      DDINSN = *BLANKS                                          CSF011A
     C                   EVAL      DDINNM = *BLANKS                                          CSF011A
     C                   EVAL      DDINTN = *BLANKS                                          CSF011A
     C                   EVAL      DDINSW = *BLANKS                                          CSF011A
     C                   EVAL      DDCDSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCDNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCDTN = *BLANKS                                          CSF011A
                                                                                             CSF011A
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPDEALN - Set up Deal Number for Inserts                   *
      *                                                               *
      *****************************************************************

     C     SETUPDEALN    BEGSR

      ** For Fixed Loan/Deposit get next deal number from the                                BUG4068
      ** fixed loan/deposit deal number range if set up.                                     BUG4068
                                                                                             BUG4068
     C     CDL016        IFEQ      'Y'                                                       BUG4068
                                                                                             BUG4068
     C     DDDLNO        IFEQ      *blanks                                                   BUG4068
     C     DDDLNO        OREQ      *zeros                                                    BUG4068
                                                                                             BUG4068
     C     DDTYPE        IFEQ      'TD'                                                      BUG4068
     C     DDTYPE        OREQ      'TI'                                                      BUG4068
     C     DDTYPE        OREQ      'IT'                                                      BUG4068
     C     DDTYPE        OREQ      'IP'                                                      BUG4068
                                                                                             BUG4068
      ** Lock the deal no. record in SDFDDRL0 so that other users do                         BUG4068
      ** not update it.                                                                      BUG4068
     C     KFDDR         KLIST                                                               BUG4068
     C                   KFLD                    DDBRCA                                      BUG4068
     C                   KFLD                    DDTYPE                                      BUG4068
                                                                                             BUG4068
     C     KFDDR         CHAIN     SDFDDRL0                           22                     BUG4068
                                                                                             BUG4068
     C     *IN22         IFEQ      '0'                                                       BUG4068
     C                   MOVE      MMCU          @NEWDL            6 0                       BUG4068
     C                   SETOFF                                       65                     BUG4068
                                                                                             BUG4068
     C     *IN65         DOUEQ     '1'                                                       BUG4068
     C*****@NEWDL        CHAIN     MMDEALLL                           65            BUG4068 AR665113
     C     @NEWDL        CHAIN     DEALSALL                           65                    AR665113
                                                                                            AR665113
     C                   IF        *IN65 = '1'                                              AR665113
     C     @NEWDL        CHAIN     DEALSCL1                           65                    AR665113
     C                   ENDIF                                                              AR665113
                                                                                             BUG4068
     C     *IN65         IFEQ      '0'                                                       BUG4068
     C                   ADD       1             @NEWDL                                      BUG4068
     C                   ELSE                                                                BUG4068
     C     @NEWDL        IFGT      MMLS                                                      BUG4068
     C                   Z-ADD     MMIN          @NEWDL                                      BUG4068
     C                   SETOFF                                       65                     BUG4068
     C                   ELSE                                                                BUG4068
     C                   Z-ADD     @NEWDL        MMCU                                        BUG4068
     C                   ENDIF                                                               BUG4068
     C                   ENDIF                                                               BUG4068
                                                                                             BUG4068
     C                   ENDDO                                                               BUG4068
     C                   MOVE      MMCU          DDDLNO                                      BUG4068
     C                   UPDATE    SDFDDRD0                                                  BUG4068
     C                   ENDIF                                                               BUG4068
                                                                                             BUG4068
     C                   ENDIF                                                               BUG4068
     C                   ENDIF                                                               BUG4068
     C                   ENDIF                                                               BUG4068
      *                                                                                      BUG4068
     C                   IF           DDDLNO = *blanks
     C                             OR DDDLNO = *zeros

     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDDLNO
     C                   PARM      *ZEROS        IKDN38

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKDLNO
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

      ** If deal number was entered, put it in the file field
     C                   ELSE
     C                   MOVE      DDDLNO        IKDN38

     C                   ENDIF
      *                                                                                       CER001
     C                   IF        DDDRID <> ' ' AND DDDDMR = *BLANKS                         CAP087
     C                   MOVE      IKDN38        IKDDMR                                       CAP087
     C                   ENDIF                                                                CAP087
                                                                                              CAP087
      ** Pass Deal Number to Update Program of extension file (MMLDNI2UP)                     CER001
      *                                                                                       CER001
     C                   IF        ULX600 = 'Y'                                               CER001
     C                   MOVE      DDDLNO        #6LXVLDN38                                   CER001
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupDDAT - Default Midas rundate as Deal Date.               *
      *                                                               *
      *****************************************************************

     C     SetupDDAT     BEGSR

      *
      ** Convert day number to YYYYMMDD format
      *
     C                   EVAL      @@DAYN = BJRDNB
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    DateOut
     C                   PARM                    @@RETC           10

      *
      ** ZDATE9 assigns a value of '0' for non-zero/non-negative date
      ** so test it here. Otherwise, value of '1' returns (if so just
      ** default a blank deal date on the screen).
      *
     C                   IF        @@RETC = '0'
     C                   EVAL      @@DTIN = DateOut
     C                   CALLB     'ZA0770'
     C                   PARM                    @@RETC
     C                   PARM                    @@DTIN
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         @@DTOU            6 0
     C                   MOVEL     @@DTOU        DDDLDT
     C                   ELSE
     C                   MOVEL     *BLANK        DDDLDT
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

      * For Inserts and Amends, put the Settlement Instructions (input or
      * defaulted) into the Valid file record.
      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
      * in contiguous areas, which must be placed into the correct parts
      * of the Valid file record
     C                   IF        DDACTN = 'I'
     C                             OR (DDACTN = 'A')
     C**********         MOVEL     DBPaySttmt    LDNIPayIns                                   CGL029
     C**********         MOVEL     DBRecSttmt    LDNIRecIns                                   CGL029
     C                   MOVEL     FLRSTM        IKRSTM                                       CGL029
     C                   MOVEL     FLRONS        IKRONS                                       CGL029
     C                   MOVEL     FLRMAC        IKRMAC                                       CDL018
     C                   MOVEL     FLREC2        LDNIRecIns                                   CGL029
     C                   MOVEL     FLPSTM        IKPSTM                                       CGL029
     C                   MOVEL     FLPONS        IKPONS                                       CGL029
     C                   MOVEL     FLPAY2        LDNIPayIns                                   CGL029
     C                   MOVE      FLPOBR        IKPOBR
     C                   MOVE      FLROBR        IKROBR
     C                   MOVE      FLCVMR        IKCVMR
     C                   MOVE      FLPSCY        IKSTCY
     C                   MOVE      FLIC72        IKIC72
     C                   MOVEL     FLPMAC        IKPMAC                                       CDL018
     C                   MOVEL     FLRBB1        IKRBB1                                       CDL094
     C                   MOVEL     FLRBB2        IKRBB2                                       CDL094
     C                   MOVEL     FLRBB3        IKRBB3                                       CDL094
     C                   MOVEL     FLRBB4        IKRBB4                                       CDL094
     C                   MOVEL     FLRBB5        IKRBB5                                       CDL094
     C                   MOVEL     FLRBB6        IKRBB6                                       CDL094
     C
     C                   ENDIF

      * For Deletes & Authorises, put the complete (pre-existing) deal
      * into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVEL     DealFilFmt    ValidDeal
     C                   ENDIF

      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      IKLACT = DDACTN

      * Include Header fields that need to be o/p to the Valid file
                                                                                              244537
      * Do not override header fields from existing transaction.                              244537
     C**********         IF        DDACTN = 'I'                                     244537 AR971184A
     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
                                                                                              244537
     C                   EVAL      IKFRNT = APFOTranID
     C                   EVAL      IKAFRT = APFOAsocID
     C                   EVAL      IKREPA = APRprLocn
     C**********         IF        DDFOID <> *BLANKS                                239400 AR971184A
     C**********         EVAL      IKFRNT = DDFOID                                  239400 AR971184A
     C**********         END                                                        239400 AR971184A
     C                   EVAL      DDFOID = APFOTranID                                     AR971184A
                                                                                              244537
     C                   ENDIF                                                                244537

      * Information needed to broken down
     C                   IF        CDL007 = 'Y'
     C                                AND DDACTN = 'A'

      * Update Breakdown User Id with Last Breakdown User Id
     C                   EVAL      IKBUSR = IF_BUSR

      * Update The Original Maturity Date
     C                   IF        IKMATD < OLD_MATD
     C                             AND DDTYPE = 'TD'
     C                             OR IKMATD < OLD_MATD
     C                             AND DDTYPE = 'TI'
     C                   EVAL      IKOMDT = OLD_MATD
     C                   EVAL      IKPRIN = *BLANKS
     C                   ENDIF
     C                   ENDIF

      * Automatic Authorisation flag
     C                   IF        CAP051 = 'Y'
     C                   EVAL      IKAUTH = IF_AUTH
     C                   ENDIF
                                                                                             BUG3986
      * Restore Timestamp from the original record                                           BUG3986
     C                   IF        DDACTN <> 'I'                                             BUG3986
     C*****************            AND DDACTN <> 'X'                                 BUG4808 BUG4808
     C                             AND DDACTN <> 'X'                                          256638
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C                   MOVEL     @TimeStamp    IKTMESTMP                                   BUG3986
     C                   ENDIF                                                               BUG3986

     C                   ENDSR
      **********************************************************************                 BUG6512
     C     ZACFFEERTV    BEGSR                                                               BUG6512
                                                                                             BUG6512
     C                   CALLB     'ZACFFEERTV'                                              BUG6512
      *                                                                                      BUG6512
      * INPUTS                                                                               BUG6512
      *                                                                                      BUG6512
      * Return code                                                                          BUG6512
     C                   PARM      *BLANK        RetCodeIn        10                         BUG6512
      *                                                                                      BUG6512
      * Action Code                                                                          BUG6512
     C                   PARM                    DDACTN            1                         BUG6512
      *                                                                                      BUG6512
      * (Midas) Deal Number                                                                  BUG6512
     C                   PARM                    DDDLNO            6                         BUG6512
      *                                                                                      BUG6512
      * Broker                                                                               BUG6512
     C                   PARM                    DDBKCD            4                         BUG6512
      *                                                                                      BUG6512
      * OUTPUTS                                                                              BUG6512
      *                                                                                      BUG6512
      * OK - Action code                                                                     BUG6512
     C                   PARM      'Y'           DDActnOK          1                         BUG6512
      *                                                                                      BUG6512
      * Counterparty Status                                                                  BUG6512
     C                   PARM                    CPST              2                         BUG6512
     C                   PARM                    DSPCP             1                         BUG6512
      *                                                                                      BUG6512
      * Broker Status                                                                        BUG6512
     C                   PARM                    BKST              2                         BUG6512
     C                   PARM                    DSPBK             1                         BUG6512
      *                                                                                      BUG6512
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG6512
     C                   PARM                    FldNameArr                                  BUG6512
     C                   PARM                    MsgIdArr                                    BUG6512
     C                   PARM                    MsgDtaArr                                   BUG6512
      *                                                                                      BUG6512
      * Array index (3P0) from/to caller                                                     BUG6512
     C                   PARM                    Idx                                         BUG6512
                                                                                             BUG6512
      ** Warning error fields/message IDs/message data (arrays) from/to caller               BUG6512
                                                                                             BUG6512
     C**********         PARM      *BLANKS       WFldNamArr                         BUG6512 BUG10677
     C**********         PARM      *BLANKS       WMsgIdArr                          BUG6512 BUG10677
     C**********         PARM      *BLANKS       WMsgDtaArr                         BUG6512 BUG10677
     C                   PARM                    WFldNamArr                                 BUG10677
     C                   PARM                    WMsgIdArr                                  BUG10677
     C                   PARM                    WMsgDtaArr                                 BUG10677
                                                                                             BUG6512
      ** Warning array index (3P0) from/to caller                                            BUG6512
                                                                                             BUG6512
     C**********         PARM      *ZEROS        WIdx                               BUG6512 BUG10677
     C                   PARM                    WIdx                                       BUG10677
                                                                                             BUG6512
     C                   ENDSR                                                               BUG6512
      **********************************************************************                 BUG6512
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * ValidateLUX - Validate LUX extension file                     *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
                                                                                              CER001
     C     ValidateLUX   BEGSR                                                                CER001
                                                                                              CER001
     C                   EVAL      #1DN38 = DDDLNO                                            CER001
     C                   EVAL      #1CCY  = DDCCY                                             CER001
     C                   Z-ADD     IKAMNP        #1AMNT                                       CER001
                                                                                              CER001
     C                   CALLB     'MMLDNI2VL'                                                CER001
     C                   PARM      DDACTN        ACTN                                         CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OKFlags                                      CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidLUX                                     CER001
     C                   PARM                    @@ER91                                       CER001
                                                                                              CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * ValidateRC - Routine to validate the Rate Change Frequency    *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
      *                                                                                       CDL033
     C     ValidateRC    BEGSR                                                                CDL033
      *                                                                                       CDL033
      ** Check if at least one date exist in array RatDATEA() and                             CDL033
      ** Rate Change                                                                          CDL033
      *                                                                                       CDL033
     C                   IF        SfBuff20 <> *BLANK AND                                     CDL033
     C                             DDRCFR   <> 'Z'                                            CDL033
     C                   ADD       1             Idx                                          CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCFR'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CDL033
     C                   LEAVESR                                                              CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If Frequency is 'Z' and no date specified on the schedule,                           CDL033
      ** always put the rate change date on top of the array                                  CDL033
      *                                                                                       CDL033
     C                   IF        SfBuff20 = *BLANK AND                                      CDL033
     C                             DDRCFR = 'Z'                                               CDL033
     C                   EVAL      RatDATEA(1) = DDRCDT                                       CDL033
     C                   EVAL      %Subst(Rindates:1:6) = DDRCDT                              CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   IF        DDRCFR = 'Z'                                               CDL033
      *                                                                                       CDL033
      ** convert maturity date screen format to MIDAS day no.                                 CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZDATE1'                                                   CDL033
     C                   PARM      DDVDAT        PDateIn                                      CDL033
     C     PvalueDate    PARM                    PDayNoOut                                    CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM                    PErrorFlg                                    CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZDATE1'                                                   CDL033
     C                   PARM      DDMDAT        PDateIn                                      CDL033
     C     PmaturityDate PARM                    PDayNoOut                                    CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM                    PErrorFlg                                    CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZDATE1'                                                   CDL033
     C                   PARM      DDRCDT        PDateIn                                      CDL033
     C     PControlDate  PARM                    PDayNoOut                                    CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM                    PErrorFlg                                    CDL033
      *                                                                                       CDL033
     C                   EVAL      PPrevDate = PvalueDate                                     CDL033
      *                                                                                       CDL033
     C                   CALLB     'MMVMRCHG'                                                 CDL033
     C                   PARM      *BLANKS       ReturnCode                                   CDL033
     C                   PARM                    PvalueDate                                   CDL033
     C                   PARM                    PmaturityDate                                CDL033
     C                   PARM                    PControlDate                                 CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM      DDACTN        Paction                                      CDL033
     C                   PARM      DDDLNO        PDealNo                                      CDL033
     C                   PARM                    PPrevDate                                    CDL033
     C                   PARM      DDCCY         Pcurrency                                    CDL033
     C                   PARM      RinDates      RDatesIn                                     CDL033
     C                   PARM                    RPConfHol                                    CDL033
     C                   PARM                    OKInRatCal                                   CDL033
     C                   PARM      *BLANKS       FldNameArr                                   CDL033
     C                   PARM      *BLANKS       MsgIDArr                                     CDL033
     C                   PARM                    Idx                                          CDL033
     C                   PARM      'Y'           IntRate                                      CDL033
     C                   PARM                    RValDateOut                                  CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If no error encountered, validate the formula and generate                           CDL033
      ** the dates based from the formula.                                                    CDL033
      *                                                                                       CDL033
     C                   IF        Idx = 0                                                    CDL033
     C                             AND DDRCFR = 'Z'                                           CDL033
     C                   EVAL      PFrequency = %SUBST(Rformula:1:1)                          CDL033
     C                   EVAL      PfreqForm  = %SUBST(Rformula:2:7)                          CDL033
      *                                                                                       CDL033
     C                   CALLB     'MMVFORMLA'                                                CDL033
     C                   PARM                    ReturnCode                                   CDL033
     C                   PARM                    PFrequency                                   CDL033
     C                   PARM                    PfreqForm                                    CDL033
     C                   PARM                    PControlDate                                 CDL033
     C                   PARM                    PmaturityDate                                CDL033
     C                   PARM      DDCCY         PCurrency                                    CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM      RvalDateOut   ValDateIn                                    CDL033
     C                   PARM      *BLANKS       FldNameArr                                   CDL033
     C                   PARM      *BLANKS       MsgIDArr                                     CDL033
     C                   PARM                    Idx                                          CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If no error encountered, check each dates in ValDateIn if it                         CDL033
      ** falls on Saturday or Sunday.                                                         CDL033
      *                                                                                       CDL033
     C                   IF        Idx = 0                                                    CDL033
     C                             AND DDRCFR = 'Z'                                           CDL033
     C                   EVAL      #X = 1                                                     CDL033
     C                   EVAL      #N = 1                                                     CDL033
      *                                                                                       CDL033
     C                   DO        600                                                        CDL033
     C                   EVAL      XCharA = %SUBST(ValDateIn:#N:3)                            CDL033
     C                   IF        XCharA = *BLANK                                            CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   EVAL      RatDAYA(#X) = XNumP                                        CDL033
     C                   EVAL      #N = #N + 3                                                CDL033
     C                   EVAL      #X = #X + 1                                                CDL033
     C                   ENDDO                                                                CDL033
      *                                                                                       CDL033
     C                   EVAL      ARdx = 1                                                   CDL033
     C                   DO        600           Ardx                                         CDL033
     C                   MoveA     RatDAYA(ARdx) XNumP                                        CDL033
     C                   IF        XNumP =  *ZEROS                                            CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   EVAL      ZDAYNO = XNumP                                             CDL033
     C                   CALLB     'ZDATE2'                                                   CDL033
     C                   PARM                    ZDAYNO                                       CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM      *ZEROS        ZDATE                                        CDL033
     C                   PARM      *BLANKS       ZADATE                                       CDL033
     C                   MOVE      ZDATE         RatDate(ARdx)                                CDL033
     C                   ENDDO                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * ValidatePC - Routine to validate the Interest Payment         *                       CDL033
      *              Frequency                                        *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
      *                                                                                       CDL033
     C     ValidatePC    BEGSR                                                                CDL033
      *                                                                                       CDL033
      ** Check if at least one date exist in array PayDATEA() and                             CDL033
      ** Interest Payment Frequency                                                           CDL033
      *                                                                                       CDL033
     C                   IF        SfBuff21 <> *BLANK AND                                     CDL033
     C                             DDIPFQ <> 'Z'                                              CDL033
     C                   ADD       1             Idx                                          CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDIPFQ'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'MMA0678'                                  CDL033
     C                   LEAVESR                                                              CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If Frequency is 'Z' and no date specified on the schedule,                           CDL033
      ** always put the rate change date on top of the array                                  CDL033
      *                                                                                       CDL033
     C                   IF        SfBuff21 = *BLANK AND                                      CDL033
     C                             DDIPFQ = 'Z'                                               CDL033
     C                   EVAL      PayDATEA(1) = DDNDAT                                       CDL033
     C                   EVAL      %Subst(Pindates:1:6) = DDNDAT                              CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   IF        DDIPFQ = 'Z'                                               CDL033
      *                                                                                       CDL033
      ** convert maturity date screen format to MIDAS day no.                                 CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZDATE1'                                                   CDL033
     C                   PARM      DDVDAT        PDateIn                                      CDL033
     C     PvalueDate    PARM                    PDayNoOut                                    CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM                    PErrorFlg                                    CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZDATE1'                                                   CDL033
     C                   PARM      DDMDAT        PDateIn                                      CDL033
     C     PmaturityDate PARM                    PDayNoOut                                    CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM                    PErrorFlg                                    CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZDATE1'                                                   CDL033
     C                   PARM      DDNDAT        PDateIn                                      CDL033
     C     PControlDate  PARM                    PDayNoOut                                    CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM                    PErrorFlg                                    CDL033
      *                                                                                       CDL033
     C                   EVAL      PPrevDate = PvalueDate                                     CDL033
      *                                                                                       CDL033
     C                   CALLB     'MMVMRCHG'                                                 CDL033
     C                   PARM      *BLANKS       ReturnCode                                   CDL033
     C                   PARM                    PvalueDate                                   CDL033
     C                   PARM                    PmaturityDate                                CDL033
     C                   PARM                    PControlDate                                 CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM      DDACTN        Paction                                      CDL033
     C                   PARM      DDDLNO        PDealNo                                      CDL033
     C                   PARM                    PPrevDate                                    CDL033
     C                   PARM      DDCCY         Pcurrency                                    CDL033
     C                   PARM      PinDates      PDatesIn                                     CDL033
     C                   PARM                    PPConfHol                                    CDL033
     C                   PARM                    OKInRatCal                                   CDL033
     C                   PARM      *BLANKS       FldNameArr                                   CDL033
     C                   PARM      *BLANKS       MsgIDArr                                     CDL033
     C                   PARM                    Idx                                          CDL033
     C                   PARM      ' '           IntRate                                      CDL033
     C                   PARM                    PValDateOut                                  CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If no error encountered, validate the formula and generate                           CDL033
      ** the dates based from the formula.                                                    CDL033
      *                                                                                       CDL033
     C                   IF        Idx = 0                                                    CDL033
     C                             AND DDIPFQ = 'Z'                                           CDL033
     C                   EVAL      PFrequency = %SUBST(PFormula:1:1)                          CDL033
     C                   EVAL      PfreqForm  = %SUBST(PFormula:2:7)                          CDL033
      *                                                                                       CDL033
     C                   CALLB     'MMVFORMLA'                                                CDL033
     C                   PARM                    ReturnCode                                   CDL033
     C                   PARM                    PFrequency                                   CDL033
     C                   PARM                    PfreqForm                                    CDL033
     C                   PARM                    PControlDate                                 CDL033
     C                   PARM                    PmaturityDate                                CDL033
     C                   PARM      DDCCY         PCurrency                                    CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM      PValDateOut   ValDateIn                                    CDL033
     C                   PARM      *Blanks       FldNameArr                                   CDL033
     C                   PARM      *Blanks       MsgIDArr                                     CDL033
     C                   PARM                    Idx                                          CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If no error encountered, check each dates in ValDateIn if it                         CDL033
      ** falls on Saturday or Sunday.                                                         CDL033
      *                                                                                       CDL033
     C                   IF        Idx = 0                                                    CDL033
     C                             AND DDIPFQ = 'Z'                                           CDL033
     C                   EVAL      #X = 1                                                     CDL033
     C                   EVAL      #N = 1                                                     CDL033
      *                                                                                       CDL033
     C                   DO        600                                                        CDL033
     C                   EVAL      XCharA = %SUBST(ValDateIn:#N:3)                            CDL033
     C                   IF        XCharA = *BLANK                                            CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   EVAL      PayDAYA(#X) = XNumP                                        CDL033
     C                   EVAL      #N = #N + 3                                                CDL033
     C                   EVAL      #X = #X + 1                                                CDL033
     C                   ENDDO                                                                CDL033
      *                                                                                       CDL033
     C                   EVAL      ARdx = 1                                                   CDL033
     C                   DO        600           Ardx                                         CDL033
     C                   MoveA     PayDAYA(ARdx) XNumP                                        CDL033
     C                   IF        XNumP =  *ZEROS                                            CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   EVAL      ZDAYNO = XNumP                                             CDL033
     C                   CALLB     'ZDATE2'                                                   CDL033
     C                   PARM                    ZDAYNO                                       CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM      *ZEROS        ZDATE                                        CDL033
     C                   PARM      *BLANKS       ZADATE                                       CDL033
     C                   MOVE      ZDATE         PayDate(ARdx)                                CDL033
     C                   ENDDO                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * SUpVALIRC - Routine to validate  the Rate Change              *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
      *                                                                                       CDL033
     C     SUpVALIRC     BEGSR                                                                CDL033
     C                   IF        DDACTN = 'A'                                               CDL033
     C                             OR DDACTN = 'R'                                            CDL033
     C                   MOVE      DDDLNO        VDLNO                                        CDL033
     C     VDLNO         SETLL     DLFRSCL0
     C                   READ      DLFRSCL0                               60                  CDL033
     C     *IN60         DOWEQ     *OFF                                                       CDL033
     C     HHDLNO        ANDEQ     VDLNO                                                      CDL033
      *                                                                                       CDL033
     C                   IF        HHDTPR <> 'Y'                                              CDL033
     C                             OR HHDTPR <> 'y'                                           CDL033
     C                   DELETE    DLFRSCD0                                                   CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   READ      DLFRSCL0                               60                  CDL033
     C                   ENDDO                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   IF        DDACTN = 'I'                                               CDL033
     C                             OR DDACTN = 'A'                                            CDL033
      *                                                                                       CDL033
     C                   IF        DDIPFQ = 'Z'                                               CDL033
     C                   EVAL      HHRCIP = 'P'                                               CDL033
     C                   DO        600           T                                            CDL033
     C                   EVAL      HHPRDT = PayDAYA(T)                                        CDL033
     C                   IF        HHPRDT = 0                                                 CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   IF        PayProc(T) <> 'Y'                                          CDL033
     C                             OR PayProc(T) <> 'y'                                       CDL033
     C                   MOVE      DDDLNO        HHDLNO                                       CDL033
     C                   EVAL      HHRCIP = 'P'                                               CDL033
     C                   EVAL      HHCOHO = PayIndtr(T)                                       CDL033
     C                   EVAL      HHDTPR = PayProc(T)                                        CDL033
     C                   WRITE     DLFRSCD0                                                   CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDDO                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   IF        DDRCFR = 'Z'                                               CDL033
     C                   Z-ADD     1             T                                            CDL033
     C                   EVAL      HHRCIP = 'R'                                               CDL033
     C                   DO        600           T                                            CDL033
      *                                                                                       CDL033
     C                   EVAL      HHPRDT = RatDAYA(T)                                        CDL033
     C                   IF        HHPRDT = 0                                                 CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   IF        RatProc(T) <> 'Y'                                          CDL033
     C                             OR RatProc(T) <> 'y'                                       CDL033
     C                   MOVE      DDDLNO        HHDLNO                                       CDL033
     C                   EVAL      HHRCIP = 'R'                                               CDL033
     C                   EVAL      HHCOHO = RatIndtr(T)                                       CDL033
     C                   EVAL      HHDTPR = RatProc(T)                                        CDL033
     C                   WRITE     DLFRSCD0                                                   CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDDO                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT
      *****************************************************************
      *                                                               *                      BUG9827
      * VALIDATEFD - Routine to Validate Fiduciary Takings            *                      BUG9827
      *                                                               *                      BUG9827
      *****************************************************************                      BUG9827
     C     ValidateFD    BEGSR                                                               BUG9827
                                                                                             BUG9827
     C                   Eval      Tkg = 1                                                   BUG9827
     C                   Eval      Str = 1                                                   BUG9827
     C                   Eval      NoOfTakingsIns = 0                                        BUG9827
     C                   Eval      WTAmount = 0                                              BUG9827
     C                   DOW       Tkg <= 99                                                 BUG9827
                                                                                             BUG9827
     C                   Eval      WFIDTDTL = %SUBST(FIDTScnRpt:Str:FIDTLen)                 BUG9827
                                                                                             BUG9827
     C                   If        WFIDTDTL = *blanks                                        BUG9827
     C                   Leave                                                               BUG9827
     C                   EndIf                                                               BUG9827
                                                                                             BUG9827
     C                   If        DDTYPE = 'DP' and Tkg > 1 or                              BUG9827
     C                             DDTYPE = 'LP' and Tkg > 1                                 BUG9827
     C                   ADD       1             Idx                                         BUG9827
     C                   Eval      FldNameArr(Idx) = 'DDDLNO'                                BUG9827
     C                   Eval      MsgIDArr(Idx) = 'MMM9039'                                 BUG9827
     C                   Leave                                                               BUG9827
     C                   EndIf                                                               BUG9827
                                                                                             BUG9827
      * No need to call validate module in delete mode                                       BUG9827
     C                   If        DDACTN <> 'D'                                             BUG9827
                                                                                            BUG10341
     C                   Eval      ErrTot = Idx                                             BUG10341
     C                   CALLB     'MMFIDTVAL'                                               BUG9827
     C                   PARM      *blanks       ReturnCode                                  BUG9827
     C                   PARM                    DDACTN                                      BUG9827
     C                   PARM                    DDDLNO                                      BUG9827
     C                   PARM                    DDBRCA                                      BUG9827
     C                   PARM                    DDCCY                                       BUG9827
     C                   PARM                    DDTYPE                                      BUG9827
     C                   PARM                    DDCUST                                      BUG9827
     C                   PARM                    WFIDTDTL                                    BUG9827
     C                   PARM                    BGPFMG                                      BUG9827
     C                   PARM                    SDPORT                                      BUG9827
     C                   PARM                    WTAmount                                    BUG9827
     C                   PARM      'Y'           OKFIDTDTL                                   BUG9827
     C                   PARM                    FldNameArr                                  BUG9827
     C                   PARM                    MsgIDArr                                    BUG9827
     C                   PARM                    MsgDtaArr                                   BUG9827
     C**********         PARM      0             Idx                                BUG9827 BUG10341
     C                   PARM                    Idx                                        BUG10341
     C                   PARM      *BLANKS       VFIDTDTL                                    BUG9827
                                                                                            BUG10341
     C                   Eval      NewErrTot = Idx                                          BUG10341
     C                   If        NewErrTot <> ErrTot                                      BUG10341
     C                   EXSR      FIDTERRMSG                                               BUG10341
     C                   EndIf                                                              BUG10341
                                                                                            BUG10341
     C                   EndIf                                                               BUG9827
                                                                                             BUG9827
      * If delete, then valid details not setup                                              BUG9827
     C                   If        DDACTN <> 'D'                                             BUG9827
     C                   Eval      %SUBST(FIDTVScnFmt:Str) = VFIDTDTL                        BUG9827
     C                   Else                                                                BUG9827
     C                   Eval      %subst(FIDTVScnFmt:Str) = WFIDTDTL                        BUG9827
     C                   EndIf                                                               BUG9827
                                                                                             BUG9827
     C                   Eval      NoOfTakingsIns = Tkg                                      BUG9827
     C                   Eval      Tkg = Tkg + 1                                             BUG9827
     C                   Eval      Str = Str + FIDTLen                                       BUG9827
     C                   ENDDO                                                               BUG9827
                                                                                             BUG9827
      ** Total amounts of takings deals must match the placing deal amount                   BUG9827
                                                                                             BUG9827
     C                   If        DDACTN <> 'D'                                             BUG9827
     C                   CALLB     'AOCURRR0'                                                BUG9827
     C                   PARM      *BLANKS       PRTCD                                       BUG9827
     C                   PARM      '*KEY   '     POPTN                                       BUG9827
     C                   PARM      DDCCY         PCCY              3                         BUG9827
     C     SDCURR        PARM      SDCURR        DSSDY                                       BUG9827
     C                   If        PRTCD <> *Blanks                                          BUG9827
     C     *LOCK         IN        LDA                                                       BUG9827
     C                   EVAL      DBKEY = DDCCY                                             BUG9827
     C                   EVAL      DBFILE = 'SDCUSTPD'                                       BUG9827
     C                   EVAL      DBASE = 015                                               BUG9827
     C                   OUT       LDA                                                       BUG9827
     C                   EXSR      *PSSR                                                     BUG9827
     C                   EndIf                                                               BUG9827
                                                                                             BUG9827
     C                   Eval      PCYDP = A6NBDP                                            BUG9827
     C                   MOVE      *BLANKS       ZFIELD                                      BUG9827
                                                                                             BUG9827
     C                   CALLB     'ZALIGN'                                                  BUG9827
     C                   PARM                    ZALIGNOK                                    BUG9827
     C                   PARM      DDAMNP        ZFIELD                                      BUG9827
     C                   PARM      PCYDP         ZADEC                                       BUG9827
     C                   PARM      12            ZADIG                                       BUG9827
                                                                                             BUG9827
     C                   MOVE      ZFIELD        WAmount                                     BUG9827
     C                   If        WTAmount <> WAmount                                       BUG9827
     C                   MOVE      *BLANKS       ZFLD15                                      BUG9827
                                                                                             BUG9827
     C                   CALLB     'ZSEDIT'                                                  BUG9827
     C                   PARM      WTAmount      ZFLD15                                      BUG9827
     C                   PARM      PCYDP         ZDECS                                       BUG9827
     C                   PARM      *BLANKS       ZECODE                                      BUG9827
     C                   PARM                    ZOUT21                                      BUG9827
     C                   ADD       1             Idx                                         BUG9827
     C                   Eval      FldNameArr(Idx) = 'DDAMNP'                                BUG9827
     C                   Eval      MsgIDArr(Idx) = 'MMA0579'                                 BUG9827
     C**********         Eval      MsgDtaArr(Idx) = ZOUT21                          BUG9827 MD000091
     C                   EVAL      BLen = %Len(%Trim(ZOUT21))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(ZOUT21)                   MD000091
     C                   EndIf                                                               BUG9827
                                                                                             BUG9827
     C                   EndIf                                                               BUG9827
                                                                                             BUG9827
     C                   ENDSR                                                               BUG9827
      *****************************************************************                      BUG9827
      *                                                               *                      BUG9827
      * SupFIDT - Call update modules for Fiduciary takings           *                      BUG9827
      *                                                               *                      BUG9827
      *****************************************************************                      BUG9827
     C     SupFIDT       BEGSR                                                               BUG9827
      *                                                                                      BUG9827
      ** Loop through and write deals                                                        BUG9827
     C                   MOVE      IKDN38        PRDLNO                                      BUG9827
     C                   Eval      Tkg = 1                                                   BUG9827
     C                   Eval      Str = 1                                                   BUG9827
     C                   DOW       Tkg <= NoOfTakingsIns                                     BUG9827
     C                   Eval      VFIDTDTL = %subst(FIDTVScnFmt:Str:FIDTLen)                BUG9827
      ** Setup valid deal file details                                                       BUG9827
     C                   Eval      DDDLNO = *blanks                                          BUG9827
     C                   If        DDACTN = 'I'                                              BUG9827
     C                   EXSR      SETUPVFIDTI                                               BUG9827
     C                   Else                                                                BUG9827
     C                   Eval      DDDLNO = VSFDLNO                                          BUG9827
     C                   EXSR      ValidateAc                                                BUG9827
     C                   MOVEL     DealFilFmt    ValidDeal                                   BUG9827
      * Set Valid file field(s) that are needed for all Action Codes                         BUG9827
      * Include Header fields that need to be o/p to the Valid file                          BUG9827
     C                   EVAL      IKLACT = DDACTN                                           BUG9827
     C                   EVAL      IKFRNT = APFOTranID                                       BUG9827
     C                   EVAL      IKAFRT = APFOAsocID                                       BUG9827
     C                   EVAL      IKREPA = APRprLocn                                        BUG9827
     C                   EndIf                                                               BUG9827
                                                                                             BUG9827
     C                   EXSR      UPDATEFIDT                                                BUG9827
     C                   MOVE      IKDN38        IKDN38A           6                         BUG9827
     C                   Eval      %SUBST(FIDTScnRpt:Str:6) = IKDN38A                        BUG9827
     C                   Eval      Tkg = Tkg + 1                                             BUG9827
     C                   Eval      Str = Str + FIDTLen                                       BUG9827
     C                   EndDo                                                               BUG9827
                                                                                             BUG9827
      * Put original deal number back in screen field                                        BUG9827
     C                   Eval      DDDLNO = PRDLNO                                           BUG9827
     C                   MOVE      PRDLNO        IKDN38                                      BUG9827
                                                                                             BUG9827
     C                   ENDSR                                                               BUG9827
      *****************************************************************                      BUG9827
      /EJECT                                                                                 BUG9827
      *****************************************************************                      BUG9827
      *                                                               *                      BUG9827
      * SETUPVFIDTI - Setup Valid file for Fiduciary takings (Insert) *                      BUG9827
      *                                                               *                      BUG9827
      *****************************************************************                      BUG9827
     C     SETUPVFIDTI   BEGSR                                                               BUG9827
      *                                                                                      BUG9827
      ** Use current deals valid format, replacing necessary details for the taking          BUG9827
                                                                                             BUG9827
     C                   CALLB     'AOCUSTR1'                                                BUG9827
     C                   PARM      *BLANKS       PRTCD                                       BUG9827
     C                   PARM      '*KEY   '     POPTN                                       BUG9827
     C                   PARM      VSFCNUM       PKEY1                                       BUG9827
     C                   PARM      *BLANKS       PKYST                                       BUG9827
     C     SDCUST        PARM      SDCUST        DSLDY                                       BUG9827
                                                                                             BUG9827
     C                   IF        PRTCD <> *BLANKS                                          BUG9827
     C     *LOCK         IN        LDA                                                       BUG9827
     C                   EVAL      DBKEY = VSFCNUM                                           BUG9827
     C                   EVAL      DBFILE = 'SDCUSTPD'                                       BUG9827
     C                   EVAL      DBASE = 016                                               BUG9827
     C                   OUT       LDA                                                       BUG9827
     C                   EXSR      *PSSR                                                     BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
      ** Setup Timestamp                                                                     BUG9827
     C                   Eval      IKTMESTMP = TimeStamp                                     BUG9827
      ** Linked Deal Number                                                                  BUG9827
     C                   MOVE      PRDLNO        IKLNKN                                      BUG9827
     C                   IF        DDTYPE = 'FL'                                             BUG9827
     C                   MOVEL     'FT'          IKTYPE                                      BUG9827
     C                   ELSE                                                                BUG9827
     C                   IF        DDTYPE = 'DP'                                             BUG9827
     C                   MOVEL     'DT'          IKTYPE                                      BUG9827
     C                   ELSE                                                                BUG9827
     C                   IF        DDTYPE = 'LP'                                             BUG9827
     C                   MOVEL     'LT'          IKTYPE                                      BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
     C                   MOVEL     BBCSSN        IKCSNM                                      BUG9827
     C                   MOVE      BBCUST        IKCNUM                                      BUG9827
     C                   MOVEL     *BLANKS       ZFIELD                                      BUG9827
                                                                                             BUG9827
     C                   CALLB     'ZALIGN'                                                  BUG9827
     C                   PARM                    ZALIGNOK                                    BUG9827
     C                   PARM      VSFAMNT       ZFIELD                                      BUG9827
     C                   PARM      A6NBDP        ZADEC                                       BUG9827
     C                   PARM      12            ZADIG                                       BUG9827
                                                                                             BUG9827
     C                   MOVE      ZFIELD        IKAMNP                                      BUG9827
     C                   MOVEL     DDACTN        IKLACT                                      BUG9827
     C                   MOVEL     *BLANKS       IKCPTI                                      BUG9827
     C                   MOVE      VSFACSQ       IKACSQ                                      BUG9827
     C                   MOVEL     'MAIL'        IKBKCD                                      BUG9827
     C                   MOVEL     'N'           IKMTAX                                      BUG9827
                                                                                             BUG9827
     C                   MOVEL     'MACC '       IKDORM                                      BUG9827
     C                   MOVE      05            IKORCM                                      BUG9827
     C                   EVAL      IKDORI = BBCUST + VSFACOD + VSFACSQ                       BUG9827
     C                   EVAL      IKMORI = BBCUST + VSFACOD + VSFACSQ                       BUG9827
     C                   MOVEL     'MACC '       IKDOPM                                      BUG9827
     C                   MOVE      05            IKMOPM                                      BUG9827
     C                   EVAL      IKDOPI = BBCUST + VSFACOD + VSFACSQ                       BUG9827
     C                   EVAL      IKMOPI = BBCUST + VSFACOD + VSFACSQ                       BUG9827
     C                   MOVE      05            IKRSTM                                      BUG9827
     C                   EVAL      IKRONS = BBCUST + VSFACOD + VSFACSQ                       BUG9827
     C                   MOVE      05            IKPSTM                                      BUG9827
     C                   EVAL      IKPONS = BBCUST + VSFACOD + VSFACSQ                       BUG9827
                                                                                             BUG9827
     C                   CALLB     'AOPRFMR0'                                                BUG9827
     C                   PARM      *BLANKS       PRTCD                                       BUG9827
     C                   PARM      IKBOKC        PBOOK             2                         BUG9827
     C                   PARM      IKTYPE        PTRTP                                       BUG9827
     C                   PARM      IKSTYP        PSUTP             2                         BUG9827
     C                   PARM      IKBRCA        PBRAN             3                         BUG9827
     C                   PARM      ZMDEPT        PDEPT1            2                         BUG9827
     C                   PARM      PSUSER        PUSER            10                         BUG9827
     C                   PARM      BBACOC        PACOF             2                         BUG9827
     C                   PARM      BBCUST        PCUST             6                         BUG9827
     C                   PARM                    PPRFC             4                         BUG9827
                                                                                             BUG9827
     C                   IF        PRTCD = *BLANKS                                           BUG9827
     C                   MOVEL     PPRFC         IKPRFC                                      BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
     C                   MOVEL     DDBRCA        IKPOBR                                      BUG9827
     C                   MOVEL     DDBRCA        IKROBR                                      BUG9827
     C                   MOVE      VSFTRAS       IKFTST                                      BUG9827
                                                                                             BUG9827
     C                   IF        DDTYPE = 'LP'                                             BUG9827
     C                   ELSE                                                                BUG9827
     C                   MOVE      *BLANKS       IKFRN1                                      BUG9827
     C                   MOVE      *BLANKS       IKFRN2                                      BUG9827
     C                   MOVE      *BLANKS       IKFRN3                                      BUG9827
     C                   MOVE      *BLANKS       IKFRN4                                      BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
     C                   IF        BGPFMG  = 'Y'                                             BUG9827
     C                   IF        VSFPTFR = FCR997                                          BUG9827
     C                   MOVE      '9997'        IKPTFR                                      BUG9827
     C                   ELSE                                                                BUG9827
     C                   MOVEL     VSFPTFR       IKPTFR                                      BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ELSE                                                                BUG9827
     C                   MOVE      *BLANKS       IKPTFR                                      BUG9827
     C                   ENDIF                                                               BUG9827
      ** Calculate total interest of the taking deal                                         BUG9827
                                                                                             BUG9827
     C                   Z-ADD     IKCYDP        PCYDP                                       BUG9827
     C                   Z-ADD     IKNTCE        PNTCE                                       BUG9827
                                                                                             BUG9827
     C                   CALLB     'ZAVTOTINT'                                               BUG9827
     C                   PARM      *Blanks       ReturnCode                                  BUG9827
     C                   PARM      *Blanks       MsgIDArr                                    BUG9827
      ** Action Code (1A, from caller)                                                       BUG9827
     C                   PARM                    DDACTN                                      BUG9827
      ** Message data (45A)                                                                  BUG9827
     C                   PARM      *BLANKS       #MsgData                                    BUG9827
      ** Total interest amount returned from this module (15,0P)                             BUG9827
     C                   PARM      *ZERO         IKMTTI                                      BUG9827
      ** Total interest amount (14A, from transaction)                                       BUG9827
     C                   PARM      '*'           PTOTI                                       BUG9827
      ** Default interest for CL and CD deals with zero notice days                          BUG9827
      ** feature flag (1A, from SCSARDPD)                                                    BUG9827
     C                   PARM                    S01468                                      BUG9827
      ** Deal notice days (3A, from transaction)                                             BUG9827
     C                   PARM                    PDDNTCE                                     BUG9827
      ** Deal type (2A, from transaction)                                                    BUG9827
     C                   PARM                    IKTYPE                                      BUG9827
      ** Interest rate (11,7P)                                                               BUG9827
     C                   PARM                    IKINTR                                      BUG9827
      ** Deal amount (15,0P, from caller)                                                    BUG9827
     C                   PARM                    IKAMNP                                      BUG9827
      ** Interest calculation method (1A, from transaction)                                  BUG9827
     C                   PARM                    IKICMT                                      BUG9827
      ** Deal value date in Midas day number format (5,0P)                                   BUG9827
     C                   PARM                    IKDVSD                                      BUG9827
      ** Currency FldNameArr OK flag (1A)                                                    BUG9827
     C                   PARM      'Y'           DDCCYOK           1                         BUG9827
      ** Number of decimal places in deal currency (1,0S, from SDCURRPD)                     BUG9827
     C                   PARM                    PCYDP                                       BUG9827
      ** Value date field OK (1A)                                                            BUG9827
     C                   PARM      'Y'           DDVDATOK          1                         BUG9827
      ** Notice days field OK (1A)                                                           BUG9827
     C                   PARM      'Y'           DDNTCEOK          1                         BUG9827
      ** Amount field OK (1A)                                                                BUG9827
     C                   PARM      'Y'           DDAMNPOK          1                         BUG9827
      ** Base Rate field OK (1A)                                                             BUG9827
     C                   PARM      'Y'           DDBSRCOK          1                         BUG9827
      ** Spread/Rate field OK (1A)                                                           BUG9827
     C                   PARM      'Y'           DDSPRTOK          1                         BUG9827
      ** Calculation method field OK (1A)                                                    BUG9827
     C                   PARM      'Y'           DDICMTOK          1                         BUG9827
      ** Maturity date (6A, from transaction)                                                BUG9827
     C                   PARM                    PDDMDAT                                     BUG9827
      ** Maturity date in Midas day number format (5,0P)                                     BUG9827
     C                   PARM                    IKMATD                                      BUG9827
      ** Maturity date field OK (1A)                                                         BUG9827
     C                   PARM      'Y'           DDMDATOK          1                         BUG9827
      ** Notice days (3,0S)                                                                  BUG9827
     C                   PARM                    PNTCE                                       BUG9827
      ** First and last day interest flag (1A, from transaction)                             BUG9827
     C                   PARM                    IKFLID                                      BUG9827
      ** Round-down interest flag (1A, from transaction)                                     BUG9827
     C                   PARM                    IKRDFC                                      BUG9827
      ** Decimal separator (1A, from SDDEALPD)                                               BUG9827
     C                   PARM      *blanks       NNDCSP                                      BUG9827
                                                                                             BUG9827
     C                   IF        ReturnCode <> *BLANKS                                     BUG9827
     C     *LOCK         IN        LDA                                                       BUG9827
     C                   EVAL      DBASE = 905                                               BUG9827
     C                   EVAL      DBFILE = 'ZAVTOTINT'                                      BUG9827
     C                   OUT       LDA                                                       BUG9827
     C                   EXSR      *PSSR                                                     BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
     C                   ENDSR                                                               BUG9827
      *****************************************************************                      BUG9827
      /EJECT                                                                                 BUG9827
      *****************************************************************                      BUG9827
      *                                                               *                      BUG9827
      * UPDATEFIDT  - Call update module to update database for       *                      BUG9827
      *               fiduciary takings                               *                      BUG9827
      *                                                               *                      BUG9827
      *****************************************************************                      BUG9827
     C     UPDATEFIDT    BEGSR                                                               BUG9827
                                                                                             BUG9827
      ** Deal Number                                                                         BUG9827
     C                   IF        VSFDLNO <> *blanks                                        BUG9827
     C                   MOVE      VSFDLNO       IKDN38                                      BUG9827
     C                   ELSE                                                                BUG9827
     C                   EXSR      SETUPDEALN                                                BUG9827
     C                   ENDIF                                                               BUG9827
      *                                                                                      BUG9827
      * Charges and Commissions                                                              BUG9827
      *                                                                                      BUG9827
     C                   If        DDACTN = 'I'                                              BUG9827
     C                   EXSR      SETCHGCOM                                                 BUG9827
     C                   EndIf                                                               BUG9827
      *                                                                                      BUG9827
      * Deals updates                                                                        BUG9827
      *                                                                                      BUG9827
     C                   CALLB     'MMLDNIUPM'                                               BUG9827
     C                   PARM                    @RTCD                                       BUG9827
     C                   PARM                    ValidDeal                                   BUG9827
     C                   PARM                    #FPAYF                                      BUG9827
     C                   PARM                    #FRECF                                      BUG9827
      ** FRCD Issued Extension details before update                                          256638
     C                   PARM                    PBFRCD          100                          256638
      ** FRCD Issued Extension details after update                                           256638
     C                   PARM                    PAFRCD          100                          256638
      *                                                                                       256638
      *                                                                                      BUG9827
     C     @RTCD         IFEQ      *BLANK                                                    BUG9827
     C                   CALLB     'MMLDNIUPD'                                               BUG9827
     C                   PARM                    @RTCD                                       BUG9827
     C                   PARM                    ValidDeal                                   BUG9827
     C                   END                                                                 BUG9827
      *                                                                                      BUG9827
                                                                                             BUG9827
     C                   ENDSR                                                               BUG9827
      *****************************************************************                      BUG9827
      /EJECT                                                                                 BUG9827
      *****************************************************************                      BUG9827
      *                                                               *                      BUG9827
      * SETCHGCOM   - Setup Charges and Commissinons for deal         *                      BUG9827
      *                                                               *                      BUG9827
      *****************************************************************                      BUG9827
     C     SETCHGCOM     BEGSR                                                               BUG9827
      *                                                                                      BUG9827
     C                   MOVE      IKDN38        PDLNO                                       BUG9827
     C                   MOVE      IKCNUM        WWCNUM            6                         BUG9827
     C     WWCNUM        CHAIN     SDCUSTL1                           91                     BUG9827
      *                                                                                      BUG9827
      ** ------------------- **                                                              BUG9827
      ** Charges calculation **                                                              BUG9827
      ** ------------------- **                                                              BUG9827
      *                                                                                      BUG9827
     C                   MOVE      *BLANKS       CHGCDE                                      BUG9827
     C                   MOVE      *BLANKS       IKFCGC                                      BUG9827
     C                   MOVE      *BLANKS       IKFCGD                                      BUG9827
     C                   Z-ADD     0             IKFCGA                                      BUG9827
     C                   Z-ADD     0             IKFCGT                                      BUG9827
                                                                                             BUG9827
     C     BNCHTK        IFEQ      'Y'                                                       BUG9827
     C     BBCHRG        ANDNE     *BLANKS                                                   BUG9827
     C     *IN91         ANDEQ     *OFF                                                      BUG9827
                                                                                             BUG9827
     C     BBCHRG        CHAIN     SDCCGRL0                           90                     BUG9827
     C     *IN90         IFEQ      *OFF                                                      BUG9827
     C     CCRECI        ANDEQ     'D'                                                       BUG9827
     C                   MOVEL     CCCHOD        CHGCDE                                      BUG9827
     C                   MOVEL     IKCCY         WWCCY                                       BUG9827
     C     BNCTBC        IFEQ      'Y'                                                       BUG9827
     C                   MOVE      BJCYCD        WWCCY                                       BUG9827
     C                   ENDIF                                                               BUG9827
     C                   MOVEL     CHGCDE        FDCCOM                                      BUG9827
                                                                                             BUG9827
     C     WWDLCC        CHAIN     DLCCGDL0                           90                     BUG9827
     C     *IN90         IFEQ      *OFF                                                      BUG9827
     C                   CALLB     'MMFIDTCHG'                                               BUG9827
     C                   PARM                    PSProcName                                  BUG9827
     C                   PARM                    DDACTN                                      BUG9827
     C                   PARM                    PDLNO                                       BUG9827
     C*******************PARM      IKCNUM        PCustNo           6 0               BUG9827 CSD027A
     C                   PARM      IKCNUM        PCustNo           6                         CSD027A
     C                   PARM                    IKCCY                                       BUG9827
     C                   PARM      IKAMNP        PAMNP            13 0                       BUG9827
     C                   PARM                    CHGCDE           20                         BUG9827
     C                   PARM      *BLANKS       PFCGD            20                         BUG9827
     C                   PARM      *ZERO         PFCGA            13 0                       BUG9827
     C                   PARM      *BLANKS       PRTCD             7                         BUG9827
                                                                                             BUG9827
     C     PRTCD         IFEQ      *BLANKS                                                   BUG9827
     C**********         MOVE      CHGCDE        IKFCGC                             BUG9827 BUG10725
     C                   MOVEL     CHGCDE        IKFCGC                                     BUG10725
     C                   MOVE      PFCGD         IKFCGD                                      BUG9827
     C                   Z-ADD     PFCGA         IKFCGA                                      BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
      *                                                                                      BUG9827
      ** ---------------------- **                                                           BUG9827
      ** Commission calculation **                                                           BUG9827
      ** ---------------------- **                                                           BUG9827
      *                                                                                      BUG9827
                                                                                             BUG9827
     C                   MOVEL     *BLANKS       CMCCDE                                      BUG9827
     C                   MOVEL     *BLANKS       IKFCMC                                      BUG9827
     C                   MOVE      *BLANKS       IKFCMD                                      BUG9827
     C                   Z-ADD     0             IKFCMA                                      BUG9827
     C                   Z-ADD     0             IKFCMT                                      BUG9827
     C     BNCOTK        IFEQ      'Y'                                                       BUG9827
     C     *IN91         ANDEQ     *OFF                                                      BUG9827
     C     BBCOMG        ANDNE     *BLANKS                                                   BUG9827
     C     IKMATD        ANDNE     *ZEROS                                                    BUG9827
                                                                                             BUG9827
     C     BBCOMG        CHAIN     SDCCGRL0                           90                     BUG9827
     C     *IN90         IFEQ      *OFF                                                      BUG9827
     C     CCRECI        ANDEQ     'D'                                                       BUG9827
     C                   MOVEL     CCCCOD        CMCCDE                                      BUG9827
     C                   MOVEL     IKCCY         WWCCY                                       BUG9827
     C     BNCTBC        IFEQ      'Y'                                                       BUG9827
     C                   MOVE      BJCYCD        WWCCY                                       BUG9827
     C                   ENDIF                                                               BUG9827
     C                   MOVEL     CMCCDE        FDCCOM                                      BUG9827
     C     WWDLCC        CHAIN     DLCCGDL0                           90                     BUG9827
                                                                                             BUG9827
     C     *IN90         IFEQ      *OFF                                                      BUG9827
     C                   CALLB     'MMFIDTCOM'                                               BUG9827
     C                   PARM                    PSProcName                                  BUG9827
     C                   PARM                    DDACTN                                      BUG9827
     C                   PARM                    PDLNO                                       BUG9827
     C                   PARM      IKCNUM        PCustNo                                     BUG9827
     C                   PARM                    IKCCY                                       BUG9827
     C                   PARM                    IKTYPE                                      BUG9827
     C                   PARM      HKMATD        PMATD             5 0                       BUG9827
     C                   PARM      HKVDDD        PVDDD             2 0                       BUG9827
     C                   PARM      HKVDMM        PVDMM             2 0                       BUG9827
     C                   PARM      HKVDYY        PVDYY             2 0                       BUG9827
     C                   PARM                    HKRDFC                                      BUG9827
     C                   PARM                    HKICMT                                      BUG9827
     C                   PARM      IKAMNP        PAMNP15          15 0                       BUG9827
     C                   PARM                    CMCCDE           20                         BUG9827
     C                   PARM      *BLANKS       PFCMD            20                         BUG9827
     C                   PARM      *ZEROS        PFCMA            13 0                       BUG9827
     C                   PARM      *BLANKS       PRTCD                                       BUG9827
     C     PRTCD         IFEQ      *BLANKS                                                   BUG9827
     C                   MOVE      HKFCMC        IKFCMC                                      BUG9827
     C                   MOVE      PFCMD         IKFCMD                                      BUG9827
     C                   Z-ADD     PFCMA         IKFCMA                                      BUG9827
     C                   EndIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
     C                   ENDSR                                                               BUG9827
      *****************************************************************                      BUG9827
      /EJECT                                                                                 BUG9827
      *****************************************************************                      BUG9827
      *                                                               *                     BUG10341
      * FIDTERRMSG  - Setup Error messages for Fid. Taking Edittable  *                     BUG10341
      *                                                               *                     BUG10341
      *****************************************************************                     BUG10341
     C     FIDTERRMSG    BEGSR                                                              BUG10341
      *                                                                                     BUG10341
      * Need to go through error array, changing the old error msg code to the new          BUG10341
      * error msg code, setting the equivalent MsgDtaArr to be the row number               BUG10341
      *                                                                                     BUG10341
     C                   Eval      St = ErrTot + 1                                          BUG10341
     C                   Eval      Le = NewErrTot - ErrTot                                  BUG10341
     C                   Eval      pos = 0                                                  BUG10341
     C                   Eval      m = 0                                                    BUG10341
     C                   Eval      errID = 1                                                BUG10341
                                                                                            BUG10341
     C                   DOW       errID <= 16                                              BUG10341
                                                                                            BUG10341
     C                   Eval      pos = %lookup(OLDMSG(errID):MsgIDArr:St:Le)              BUG10341
     C                   If        pos <> 0                                                 BUG10341
     C                   MOVE      Tkg           TkgA                                       BUG10341
     C**********         Eval      MsgDtaArr(pos) = TkgA                           BUG10341 MD000091
     C                   EVAL      BLen = %Len(%Trim(TkgA))                                 MD000091
     C                   EVAL      MsgDtaArr(pos) = LenStr +%TRIM(TkgA)                     MD000091
     C                   Eval      MsgIDArr(pos) = NEWMSG(errID)                            BUG10341
     C                   Eval      m = m + 1                                                BUG10341
     C                   EndIf                                                              BUG10341
                                                                                            BUG10341
     C                   If        m = Le                                                   BUG10341
     C                   Leave                                                              BUG10341
     C                   EndIf                                                              BUG10341
     C                   Eval      ErrID = ErrID + 1                                        BUG10341
                                                                                            BUG10341
     C                   ENDDO                                                              BUG10341
                                                                                            BUG10341
     C                   ENDSR                                                              BUG10341
      *****************************************************************                     BUG10341
      /EJECT                                                                                BUG10341
      *****************************************************************                     BUG10341
      *                                                               *                       CER043
      *  SrPopCust - Subroutine to Populate Customer Details          *                       CER043
      *                                                               *                       CER043
      *  Called by: MAIN Processing                                   *                       CER043
      *                                                               *                       CER043
      *  Calls: SrRtvCust                                             *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
      **********                                                                       CER043 CSF011
     C*****SrPopCust     BEGSR                                                         CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         CLEAR                   TranInCust                            CER043 CSF011
      **********                                                                       CER043 CSF011
      ***Retrieve Customer Details                                                     CER043 CSF011
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
      *                                                                                       CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
      *                                                               *                     MD022656
      *  SrPayAmnd - Check if Payment Settlements are amended         *                     MD022656
      *                                                               *                     MD022656
      *****************************************************************                     MD022656
     C     SrPayAmnd     BEGSR                                                              MD022656
                                                                                            MD022656
      ** Convert some file format fields in screen format to match                          MD022656
                                                                                            MD022656
     C                   EVAL      W#PONX = IKPONS                                          MD022656
     C                   MOVEL     IKPSTM        W#PSTM                                     MD022656
                                                                                            MD022656
     C                   IF        %LEN(%TRIM(DDPONX)) = 21                                 MD024884
     C                             OR %LEN(%TRIM(DDPONX)) = 18                              MD024884
     C                   MOVE      IKPONS        W#PONX                                     MD024884
     C                   MOVEL     IKPOBR        W#PONX                                     MD024884
     C                   ENDIF                                                              MD024884
                                                                                            MD024884
     C                   IF        DDPSCY <> *BLANKS                                        MD022656
     C                   EVAL      W#CCY = IKCCY                                            MD022656
     C                   ENDIF                                                              MD022656
                                                                                            MD022656
     C                   IF        DDPOBN <> *BLANKS                                        MD022656
     C                   EVAL      PCNum = DDPOBN                                           MD022656
     C                   EXSR      SrRtvCust                                                MD022656
     C                   EVAL      W#POBN = BBCUST                                          MD022656
     C                   ENDIF                                                              MD022656
                                                                                            MD022656
     C                   IF        DDPOCN <> *BLANKS                                        MD022656
     C                   EVAL      PCNum = DDPOCN                                           MD022656
     C                   EXSR      SrRtvCust                                                MD022656
     C                   EVAL      W#POCN = BBCUST                                          MD022656
     C                   ENDIF                                                              MD022656
     C                                                                                      MD022656
     C                   IF        DDRCRN <> *BLANKS                                        MD022849
     C                   EVAL      PCNum = DDRCRN                                           MD022849
     C                   EXSR      SrRtvCust                                                MD022849
      ** If valid customer number, move BBCUST (customer number)                            MD027415
      ** Else, need to check if it's a valid Counterparty Nostro.                           MD027415
     C                   IF        PRtcd = *BLANKS                                          MD027415
     C                   EVAL      W#RCRN = BBCUST                                          MD022849
     C                   ELSE                                                               MD027415
     C                   EXSR      ACCNST                                                   MD027415
     C                   IF        PRtcd = *BLANKS                                          MD027415
     C                   EVAL      W#RCRN = AWCPNC                                          MD027415
     C                   ELSE                                                               MD027415
     C                   EVAL      W#RCRN = *BLANKS                                         MD027415
     C                   ENDIF                                                              MD027415
     C                   ENDIF                                                              MD027415
     C                   ENDIF                                                              MD022849
     C                                                                                      MD022849
     C                   IF        DDRVNO <> *BLANKS                                        MD022849
     C                   EVAL      PCNum = DDRVNO                                           MD022849
     C                   EXSR      SrRtvCust                                                MD022849
     C                   EVAL      W#RVNO = BBCUST                                          MD022849
     C                   ENDIF                                                              MD022849
     C                                                                                      MD022849
     C                   IF        DDAWBN <> *BLANKS                                        MD022849
     C                   EVAL      PCNum = DDAWBN                                           MD022849
     C                   EXSR      SrRtvCust                                                MD022849
      ** If valid customer number, move BBCUST (customer number)                            MD027415
      ** Else, need to check if it's a valid Counterparty Nostro.                           MD027415
     C                   IF        PRtcd = *BLANKS                                          MD027415
     C                   EVAL      W#AWBN = BBCUST                                          MD022849
     C                   ELSE                                                               MD027415
     C                   EXSR      ACCNST                                                   MD027415
     C                   IF        PRtcd = *BLANKS                                          MD027415
     C                   EVAL      W#AWBN = AWCPNC                                          MD027415
     C                   ELSE                                                               MD027415
     C                   EVAL      W#AWBN = *BLANKS                                         MD027415
     C                   ENDIF                                                              MD027415
     C                   ENDIF                                                              MD027415
     C                   ENDIF                                                              MD022849
     C                                                                                      MD022849
     C                   IF        DDPIBN <> *BLANKS                                        MD022849
     C                   EVAL      PCNum = DDPIBN                                           MD022849
     C                   EXSR      SrRtvCust                                                MD022849
      ** If valid customer number, move BBCUST (customer number)                            MD027415
      ** Else, need to check if it's a valid Counterparty Nostro.                           MD027415
     C                   IF        PRtcd = *BLANKS                                          MD027415
     C                   EVAL      W#PIBN = BBCUST                                          MD022849
     C                   ELSE                                                               MD027415
     C                   EXSR      ACCNST                                                   MD027415
     C                   IF        PRtcd = *BLANKS                                          MD027415
     C                   EVAL      W#PIBN = AWCPNC                                          MD027415
     C                   ELSE                                                               MD027415
     C                   EVAL      W#PIBN = *BLANKS                                         MD027415
     C                   ENDIF                                                              MD027415
     C                   ENDIF                                                              MD027415
     C                   ENDIF                                                              MD022849
     C                                                                                      MD022849
     C                   IF        DDBENN <> *BLANKS                                        MD022849
     C                   EVAL      PCNum = DDBENN                                           MD022849
     C                   EXSR      SrRtvCust                                                MD022849
      ** If valid customer number, move BBCUST (customer number)                            MD027415
      ** Else, need to check if it's a valid Counterparty Nostro.                           MD027415
     C                   IF        PRtcd = *BLANKS                                          MD027415
     C                   EVAL      W#BENN = BBCUST                                          MD022849
     C                   ELSE                                                               MD027415
     C                   EXSR      ACCNST                                                   MD027415
     C                   IF        PRtcd = *BLANKS                                          MD027415
     C                   EVAL      W#BENN = AWCPNC                                          MD027415
     C                   ELSE                                                               MD027415
     C                   EVAL      W#BENN = *BLANKS                                         MD027415
     C                   ENDIF                                                              MD027415
     C                   ENDIF                                                              MD027415
     C                   ENDIF                                                              MD022849
     C                                                                                      MD022849
                                                                                            MD022656
      ** Compare Payment settlement fields                                                  MD022656
                                                                                            MD022656
     C                   Z-ADD     Idx           W#CNT                                      MD022656
                                                                                            MD022656
     C                   SELECT                                                             MD022656
     C                   WHEN      DDPSCY <> W#CCY                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDPSCY'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDPSTM <> W#PSTM                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDPONX <> W#PONX                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                               MD022656
                                                                                            MD022656
     C**********         WHEN      DDRVNO <> IKRVNO                                MD022656 MD022849
     C                   WHEN      W#RVNO <> IKRVNO                                         MD022849
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDCVMR <> IKCVMR                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDCVMR'                               MD022656
                                                                                            MD022656
     C                   WHEN      W#POCN <> IKPOCN                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDPOCN'                               MD022656
                                                                                            MD022656
     C                   WHEN      W#POBN <> IKPOBN                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'                               MD022656
                                                                                            MD022656
     C**********         WHEN      DDRCRN <> IKRCRN                                MD022656 MD022849
     C                   WHEN      W#RCRN <> IKRCRN                                         MD022849
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDRCRA <> IKRCRA                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDRCRA'                               MD022656
                                                                                            MD022656
     C**********         WHEN      DDPIBN <> IKPIBN                                MD022656 MD022849
     C                   WHEN      W#PIBN <> IKPIBN                                         MD022849
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDPIBA <> IKPIBA                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDPIBA'                               MD022656
                                                                                            MD022656
     C**********         WHEN      DDAWBN <> IKAWBN                                MD022656 MD022849
     C                   WHEN      W#AWBN <> IKAWBN                                         MD022849
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDAWBA <> IKAWBA                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDAWBA'                               MD022656
                                                                                            MD022656
     C**********         WHEN      DDBENN <> IKBENN                                MD022656 MD022849
     C                   WHEN      W#BENN <> IKBENN                                         MD022849
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDBENN'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDBENA <> IKBENA                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDBENA'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDBENA <> IKBENA                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDBENA'                               MD022656
                                                                                            MD022656
     C                   WHEN      %SUBST(InPaySttmt:674:140) <>                            MD022656
     C                             %SUBST(ValidDeal:731:140)                                MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDDTP1'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDDCHG <> IKDCHG                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDDCHG'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDIC72 <> IKIC72                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDIC72'                               MD022656
                                                                                            MD022656
     C                   WHEN      %SUBST(InPaySttmt:820:210) <>                            MD022656
     C                             %SUBST(ValidDeal:874:210)                                MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDBTB1'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDPMAC <> IKPMAC                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDPMAC'                               MD022656
     C                   ENDSL                                                              MD022656
                                                                                            MD022656
      ** If there are difference in any of the fields,                                      MD022656
      ** issue the error message                                                            MD022656
                                                                                            MD022656
     C                   IF        W#CNT <> Idx                                             MD022656
     C                   EVAL      MsgIDArr(Idx) = '5046114'                                MD022656
     C                   ENDIF                                                              MD022656
                                                                                            MD022656
     C                   ENDSR                                                              MD022656
      *****************************************************************                     MD022656
      /EJECT                                                                                MD022656
      *****************************************************************                     MD022656
      *                                                               *                     MD022656
      *  SrRecAmnd - Check if Receipt Settlements are amended         *                     MD022656
      *                                                               *                     MD022656
      *****************************************************************                     MD022656
     C     SrRecAmnd     BEGSR                                                              MD022656
     C                                                                                      MD022656
                                                                                            MD022656
      ** Convert some file format fields in screen format to match                          MD022656
                                                                                            MD022656
     C                   EVAL      W#RONX = IKRONS                                          MD022656
                                                                                            MD024884
     C                   IF        %LEN(%TRIM(DDRONX)) = 21                                 MD024884
     C                             OR %LEN(%TRIM(DDRONX)) = 18                              MD024884
     C                   MOVE      IKRONS        W#RONX                                     MD024884
     C                   MOVEL     IKROBR        W#RONX                                     MD024884
     C                   ENDIF                                                              MD024884
                                                                                            MD024884
     C                   MOVEL     IKRSTM        W#RSTM                                     MD022656
     C                   IF        DDRSCY <> *BLANKS                                        MD022656
     C                   EVAL      W#CCY = IKCCY                                            MD022656
     C                   ENDIF                                                              MD022656
                                                                                            MD022656
     C                   IF        DDROBN <> *BLANKS                                        MD022656
     C                   EVAL      PCNum = DDROBN                                           MD022656
     C                   EXSR      SrRtvCust                                                MD022656
     C                   EVAL      W#ROBN  = BBCUST                                         MD022656
     c                   ENDIF                                                              MD022656
                                                                                            MD022656
     C                   IF        DDROCN <> *BLANKS                                        MD022656
     C                   EVAL      PCNum = DDROCN                                           MD022656
     C                   EXSR      SrRtvCust                                                MD022656
     C                   EVAL      W#ROCN = BBCUST                                          MD022656
     C                   ENDIF                                                              MD022656
     C                                                                                      MD022849
     C                   IF        DDRIBN <> *BLANKS                                        MD022849
     C                   EVAL      PCNum = DDRIBN                                           MD022849
     C                   EXSR      SrRtvCust                                                MD022849
      ** If valid customer number, move BBCUST (customer number)                            MD027415
      ** Else, need to check if it's a valid Counterparty Nostro.                           MD027415
     C                   IF        PRtcd = *BLANKS                                          MD027415
     C                   EVAL      W#RIBN = BBCUST                                          MD022849
     C                   ELSE                                                               MD027415
     C                   EXSR      ACCNST                                                   MD027415
     C                   IF        PRtcd = *BLANKS                                          MD027415
     C                   EVAL      W#RIBN = AWCPNC                                          MD027415
     C                   ELSE                                                               MD027415
     C                   EVAL      W#RIBN = *BLANKS                                         MD027415
     C                   ENDIF                                                              MD027415
     C                   ENDIF                                                              MD027415
     C                   ENDIF                                                              MD022849
                                                                                            MD022656
      ** Compare Payment settlement fields                                                  MD022656
                                                                                            MD022656
     C                   Z-ADD     Idx           W#CNT                                      MD022656
     C                   SELECT                                                             MD022656
                                                                                            MD022656
     C                   WHEN      DDRSCY <> W#CCY                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDRSTM <> W#RSTM                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDRONX <> W#RONX                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                               MD022656
                                                                                            MD022656
     C**********         WHEN      DDRIBN <> IKRIBN                                MD022656 MD022849
     C                   WHEN      W#RIBN <> IKRIBN                                         MD022849
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDRIBN'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDRIBA <> IKRIBA                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDRIBA'                               MD022656
                                                                                            MD022656
     C                   WHEN      W#ROBN <> IKROBN                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDROBN'                               MD022656
                                                                                            MD022656
     C                   WHEN      W#ROCN <> IKROCN                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDROCN'                               MD022656
                                                                                            MD022656
     C                   WHEN      DDRMAC <> IKRMAC                                         MD022656
     C                             AND W#CNT = Idx                                          MD022656
     C                   ADD       1             Idx                                        MD022656
     C                   EVAL      FldNameArr(Idx) = 'DDRMAC'                               MD022656
     C                   ENDSL                                                              MD022656
                                                                                            MD022656
      ** If there are difference in any of the fields,                                      MD022656
      ** issue the error message                                                            MD022656
                                                                                            MD022656
     C                   IF        W#CNT <> Idx                                             MD022656
     C                   EVAL      MsgIDArr(Idx) = '5046115'                                MD022656
     C                   ENDIF                                                              MD022656
     C                   ENDSR                                                              MD022656
      *****************************************************************                     MD022656
      /EJECT                                                                                MD022656
      *****************************************************************                     MD022656
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
**  CTDATA OLDMSG                                                                           BUG10341
MMA0568   MMA1320                                                                           BUG10341
MMA0569   MMA1321                                                                           BUG10341
MMA0582   MMA1322                                                                           BUG10341
MMA0571   MMA1323                                                                           BUG10341
MMM9010   MMA1324                                                                           BUG10341
MMM9011   MMA1325                                                                           BUG10341
MMM9012   MMA1326                                                                           BUG10341
MMA0572   MMA1327                                                                           BUG10341
MMA0573   MMA1328                                                                           BUG10341
MMA0574   MMA1329                                                                           BUG10341
MMA0575   MMA1330                                                                           BUG10341
USR8627   MMA1331                                                                           BUG10341
USR8628   MMA1332                                                                           BUG10341
MMA0576   MMA1333                                                                           BUG10341
MMA0577   MMA1334                                                                           BUG10341
MMA0578   MMA1335                                                                           BUG10341
