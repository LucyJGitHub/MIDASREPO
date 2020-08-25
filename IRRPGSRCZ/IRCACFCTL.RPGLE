     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/collars/floors interface controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCACFCTL - Caps/Collars/Floors Interface Controller         *
      *                                                               *
      *  Function: This function validates Caps/Collars/Floors deals  *
      *            for input into the Midas database.                 *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) if ALL of the settlement fields  *
      *              are blank, set them up from standard settlement  *
      *              instructions                                     *
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
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR314712           Date 13Apr10               *
      *                 AR218555           Date 26Mar10               *
      *                 245692             Date 10Dec13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247888             Date 18May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241470             Date 07Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 233467             Date 06Jun05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7166            Date 12May05               *
      *                 BUG6472            Date 23Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG5707            Date 28Jan05               *
      *                 BUG2603            Date 12May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 31Oct03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 185064             Date 05Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  AR314712 - Missing Account Key for Caps/Floors Deals.        *
      *             Default Up-front fee pay/rcv based on buy/sell    *
      *             indicator.                                        *
      *  AR218555 - Cannot authorise/edit Caps, Collars, Floors in    *
      *           WIP. It issues error message RS00018.               *
      *           - Do not validate the Fees and Buy out fields       *
      *           if CIR006 is switched off.                          *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247888 - Missing record in CLE025 files.                     *
      *  241470 - New field by CDL038 not passed to work file.        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233467 - Added parameter passed to IRSFBOVAL                 *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  BUG6472- Added a sign field for short term rate              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG5707 - Parameter mismatch in IRCACFVAL and IRCACFCVT      *
      *  BUG2603- Commitment Control Changes for Midas Plus           *
      *  CDL018 - Mutliple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Correct parameters on program calls                 *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  185064 - Old up-front fee details should be saved in         *
      *           DLDGUPFE.                                           *
      *  CAP056 - Automatic Authorisation of Interface Deals          *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80         String found for SCAN operation                 *
      *    81         String being tested for TESTN is numeric        *
      *    82         Equal entry found for LOOKUP operation          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrChkDlDLNO  - Check if Valid Deal Exists for Deal Number    *
      *  SrChkDlFOID  - Check if Valid Deal Exists for Front Ofc ID   *
      *  SrChkWrite   - Control Checking of Error Status and Sending  *
      *                 of Messages/Writing to the Database           *
      *  SrDefaultSSI - Apply Default Settlement Instructions,        *
      *                 If None Have Been Supplied                    *
      *  SrDtaSubsS   - Settlement Details Data Substitution          *
      *  SrDtaSubsT   - Transaction Details Data Substitution         *
      *  SrMsgHndl    - Call the Message Handling Module              *
      *  SrResetCycl  - Reset Error Information that is Gradually     *
      *                 Updated During Each Run of this Program       *
      *  SrSetupAmd   - Setup Flds Needed in Validation of Amendments *
      *  SrSetupDLNO  - Set up Deal Number for Inserts                *
      *  SrSetupInv   - Setup Addtl. Fields Needed on Invalids File   *
      *  SrSetupVld   - Setup Addtl. Fields Needed on Valids File     *
      *  SrValActCde  - Validate Action Code VS Deal Number Supplied  *
      *  SrValAmend   - Validate Whether Amended Fields are Amendable *
      *  SrValSSI     - Validate Settlement Instructions              *
      *  SrValTrans   - Validate Main Transaction Details             *
      *  SrValidFE - Routine to validate Fees\Buy-Outs fields         *
      *  SRFileFlds - Set up file fields                              *
      *  SRUpdUpF -  Write into PF/DLDGUPFE old values of up-front    *
      *              value date, fee and P/R indicator                *
      * *PSSR         - Error processing                              *
      * *INZSR        - Program Initialisation Routine                *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FIRVCACFPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT

     FIRICACFPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT

     FIRVPCSCPD UF A E             DISK    INFSR(*PSSR) PREFIX(PV)                            CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRIPCSCPD UF A E             DISK    INFSR(*PSSR) PREFIX(PI)                            CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRWPCSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(P)                             CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRTPCSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(P)                             CAP043
     F                                     RENAME(IRVPCSCD0:IRTPCSCD0)                        CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRWCACFL0 UF A E           K DISK    INFSR(*PSSR)                                       CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FAPIDSETPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT

     FIRVCACFL0 IF   E           K DISK    RENAME(IRVCACFD0:IRVCACFCHK)
     F                                     INFSR(*PSSR)

     FIRVCACFL1 IF   E           K DISK    RENAME(IRVCACFD0:IRVCACFCK1)
     F                                     INFSR(*PSSR)

     FDLDGUPFE  O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLDGREF:DLDGREFF)
     F                                     COMMIT

     FDLDGUPL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** FX/MM/FRA/IRS Extension files                                                        247888
     FDLDEALL5  UF A E           K DISK    PREFIX(DX_)                                        247888
     F                                     INFSR(*pssr)                                       247888
     F                                     COMMIT                                             247888
                                                                                              247888
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRCACFC001
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Data structure for data area commitment control                                     BUG2603
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG2603
     D  ComitJobs              4    103A                                                     BUG2603
                                                                                             BUG2603
     D JobCmtCtlDS     S             10A   DIM(10)                                           BUG2603
      * MIDAS SC Jobs Handling Commitment Control Data Structure                             BUG2603
                                                                                             BUG2603
     D OurPCSC         S           1886A   DIM(ArrayMax)                                      CAP043

      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
     D WMSGTYPE                1      6                                                       CAP043

      ** Incoming transaction
     D TranIn        E DS                  EXTNAME(IRCACFPD)
     D WBDCLeg1              205    234                                                       CAP043

      ** Valid deals layout
     D NwIRFilFmt    E DS                  EXTNAME(IRVCACFPD)
     D***CACFRecIns          716    784                                                       CGL029
     D***CACFPayIns          785   1343                                                       CGL029
     D   CACFRecIns          730    784                                                       CGL029
     D   CACFPayIns          799   1343                                                       CGL029
     D   CACFFraIns         1345   1992

      ** Current deal in File format
     D CrIRFilFmt    E DS                  EXTNAME(DEALSDG)

      ** Current deal in Screen format
     D CrIRScnFmt    E DS                  EXTNAME(IRCACFPD)
     D                                     PREFIX(@)

     D PrcChgDS      E DS                  EXTNAME(IRPCSCPD) PREFIX(PR)                       CAP043
      ** Principal Change Schedule (used to save principal change records                     CAP043
      ** in IRWPCSCPD file)                                                                   CAP043
     D WPrcChg1                1    492                                                       CAP043
     D WPrcChg2              493    988                                                       CAP043
     D WPrcChg3              989   1484                                                       CAP043
     D WPrcChg4             1485   1886                                                       CAP043
                                                                                              CAP043
     D WPrcChgDS     E DS                  EXTNAME(IRWPCSCPD) PREFIX(P)                       CAP043
      ** Principal Change Schedule work definition file (DS of IRWPCSCL0 defined              CAP043
      ** in F Specs)                                                                          CAP043
     D WPrinChg               43   1928                                                       CAP043
                                                                                              CAP043
     D OurPrcCDS     E DS                  EXTNAME(IRWPCSCPD) PREFIX(OP)                      CAP043
      ** Our Principal Change Schedule (used to validate our prin change)                     CAP043
     D WOurPrcCD              43    534                                                       CAP043
     D WOurPrcCA             535   1846                                                       CAP043
     D WOurPrcCI            1847   1928                                                       CAP043
     D WOurPrin               43   1928                                                       CAP043
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
     D WrkCACFDS     E DS                  EXTNAME(IRWCACFPD)                                 CAP043
      ** CACF work file DS (used to save x-ccy records in IRWCACFPD)                          CAP043
     D*WIRCACF****************42****364                                                CAP043 241470
     D WIRCACF                42    414                                                       241470
                                                                                              CAP043
     D VldPrinChg    E DS                  EXTNAME(IRVPCSCPD) PREFIX(PV)                      CAP043
      ** Valid Prin Change def file (use to write valid records in IRVPCSCPD)                 CAP043
                                                                                              CAP043
     D TrailerDS     E DS                  EXTNAME(IRTRSCPD)                                  CAP043
      ** Trailer file DS                                                                      CAP043
                                                                                              CAP043
     D InvPrinChg    E DS                  EXTNAME(IRIPCSCPD) PREFIX(PI)                      CAP043
      ** Invld Prin Change def file (use to write invld records in IRIPCSCPD)                 CAP043
     D WInvPrcChg             23   1908                                                       CAP043
                                                                                              CAP043
      ** Pay/Rcv/FRA-IRS Settlement Instructions - Input
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
                                                                                              CAP056
      ** FRA/IRS Interface Non-Screen Data                                                    CAP056
     D InfData       E DS                  EXTNAME(IRRPIFPD)                                  CAP056

      ** Pay/Rcv/FRA-IRS Settlement Instructions - Current
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)

      ** Pay/Rcv/FRA-IRS Settlement Instructions - File (D/B) format
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D  DBPaySttmt1           21    565                                                       CGL029
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D  DBRecSttmt1           21     75                                                       CGL029
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)

      ** Caps/Collars/Floors Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(IRCPEXPD)

      ** Error indicators/OK flags
     D IRECACF       E DS                  EXTNAME(IRECACFPD)

      ** OK flags for Pay Settlement Instruction fields
     D OKPaySSI        DS
     D  #0PSCYOK                      1A   INZ('Y')
     D  #0PSTMOK                      1A   INZ('Y')
     D  #0PONXOK                      1A   INZ('Y')
     D  #0RVNOOK                      1A   INZ('Y')
     D  #0CVMROK                      1A   INZ('Y')
     D  #0POCNOK                      1A   INZ('Y')
     D  #0POBNOK                      1A   INZ('Y')
     D  #0RCRNOK                      1A   INZ('Y')
     D  #0RCRAOK                      1A   INZ('Y')
     D  #0PIBNOK                      1A   INZ('Y')
     D  #0PIBAOK                      1A   INZ('Y')
     D  #0AWBNOK                      1A   INZ('Y')
     D  #0AWBAOK                      1A   INZ('Y')
     D  #0BENNOK                      1A   INZ('Y')
     D  #0BENAOK                      1A   INZ('Y')
     D  #0DTP1OK                      1A   INZ('Y')
     D  #0DTP2OK                      1A   INZ('Y')
     D  #0DTP3OK                      1A   INZ('Y')
     D  #0DTP4OK                      1A   INZ('Y')
     D  #0DCHGOK                      1A   INZ('Y')
     D  #0IC72OK                      1A   INZ('Y')
     D  #0BTB1OK                      1A   INZ('Y')
     D  #0BTB2OK                      1A   INZ('Y')
     D  #0BTB3OK                      1A   INZ('Y')
     D  #0BTB4OK                      1A   INZ('Y')
     D  #0BTB5OK                      1A   INZ('Y')
     D  #0BTB6OK                      1A   INZ('Y')

      ** OK flags for Receive Settlement Instruction fields
     D OKRcvSSI        DS
     D  #0RSCYOK                      1A
     D  #0RSTMOK                      1A   INZ('Y')
     D  #0RONXOK                      1A   INZ('Y')
     D  #0ROCNOK                      1A   INZ('Y')
     D  #0ROBNOK                      1A   INZ('Y')
     D  #0RIBNOK                      1A   INZ('Y')
     D  #0RIBAOK                      1A   INZ('Y')

      ** OK flags for FRA/IRS Instruction fields
     D OKFraSSI        DS
     D  #0DSR1OK                      1A   INZ('Y')
     D  #0DSR2OK                      1A   INZ('Y')
     D  #0DSR3OK                      1A   INZ('Y')
     D  #0DSR4OK                      1A   INZ('Y')
     D  #0DSR5OK                      1A   INZ('Y')
     D  #0DSR6OK                      1A   INZ('Y')
     D  #0SSR1OK                      1A   INZ('Y')
     D  #0SSR2OK                      1A   INZ('Y')
     D  #0SSR3OK                      1A   INZ('Y')
     D  #0SSR4OK                      1A   INZ('Y')
     D  #0SSR5OK                      1A   INZ('Y')
     D  #0SSR6OK                      1A   INZ('Y')
     D  #0CND1OK                      1A   INZ('Y')
     D  #0CND2OK                      1A   INZ('Y')
     D  #0CND3OK                      1A   INZ('Y')
     D  #0CND4OK                      1A   INZ('Y')
     D  #0CND5OK                      1A   INZ('Y')
     D  #0CND6OK                      1A   INZ('Y')
     D  #0ISDAOK                      1A   INZ('Y')
     D  #0AGTYOK                      1A   INZ('Y')
     D  #0AGDTOK                      1A   INZ('Y')
     D  #0AGVVOK                      1A   INZ('Y')

      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Module details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External DS for Deal details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)

      ** External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  ACCDB1       E                     EXTFLD(QQACCD)                                     CGL029

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** External DS for FRA/IRS ICD
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)

      ** External DS for Trading details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  ACCDB2       E                     EXTFLD(QQACCD)                                     CGL029

      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D   SCLCD       E                     EXTFLD(LCD)

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** ZMUSER data area
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)

      ** Short DS for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
     D                                     PREFIX(A)

      ** Transaction Details retrieved from file - in screen
      ** format
     D CrFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
     D                                     PREFIX(B)

      ** Transaction Details OK indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
     D                                     PREFIX(W)

      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  ACCDB3       E                     EXTFLD(QQACCD)                                     CGL029

      ** First DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D/COPY QWINDSRC,IRCACFDTA
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Switchable features
     D CIR001          S              1A
     D CIR005          S              1A
     D CIR006          S              1A
     D CIR007          S              1A
     D CIR008          S              1A
     D CAP056          S              1A
     D CSC011          S              1A
     D CAP041          S              1A
     D CEU003          S              1A

      ** Indexes
     D AmIdx           S              3P 0
     D Idx             S              3P 0
     D Ix              S              3P 0
     D Iy              S              3P 0
     D WIdx            S              3P 0

      ** Entry Parameters
     D ExtData500      S            500A
     D InfData500      S            500A                                                      CAP056
     D Trans500        S            500A

      ** Fields to recieve Principal Change                                                   CAP043
     D TransB500       S            500A                                                      CAP043
     D TransC500       S            500A                                                      CAP043
     D TransD500       S            500A                                                      CAP043
                                                                                              CAP043
      ** Parameters for APCALCOBJ
     D WDlcobj         S              1A
     D WLckState       S              7A
     D WLib            S             10A
     D WMember         S             10A
     D WObject         S             10A
     D WObjTyp         S              7A
     D WRtCd7A         S              7A
     D WWait           S              6A

      ** Parameters for APDTASUBS
     D CurDATA         S           2000A
     D IncDATA         S           2000A
     D PSubsChar       S              1A

      ** Parameters for IRCACFAMD
     D PAmendOK        S              1A   INZ('Y')
     D PResetErrs      S              1A

      ** Parameter for IRCACFCVT
     D PDealSts        S             24A

      ** Parameters for IRCACFVAL
     D ModeOfOp        S              6A
     D***PayNostro       S             12A                                                    CGL029
     D PayNostro       S             18A                                                      CGL029
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D***RecNostro       S             12A                                                    CGL029
     D RecNostro       S             18A                                                      CGL029
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D WValBDC         S              1A

      ** Date array parameter passed to IRVIRCVAL                                             CAP043
     D DatesToVal      S            492A                                                      CAP043
                                                                                              CAP043
      ** IRC valid dates returned from IRVIRCVAL                                              CAP043
     D ValidDates      S            246A   INZ(*BLANKS)                                       CAP043
                                                                                              CAP043
     D PWUCDP          S              1P 0
     D PWTCDP          S              1P 0
     D PWPSCY          S              3A
     D PWRSCY          S              3A
     D PWPNLOC         S              3A
     D PWRNLOC         S              3A

      ** Parameters for ZAMSGHNDLE
     D PModuleID       S              2A
     D PTranID         S             20A
     D PTranSts        S              1A
     D PTimeStamp      S             26Z

      ** Parameters for ZAMSGTOOPR
     D PSysOprMsg      S            132A
     D PMsgID          S                   LIKE(#MsgID)
     D PMsgF           S             10A

      ** Parameters for ZASETINDFT
     D CACF            S              4A   INZ('CACF')
     D PBlank3         S              3A   INZ(*BLANKS)
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095

      ** Parameters for ZASETINVAL
     D PAction         S              1A
     D PValIter        S              3A
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)

      ** Parameters for Access Object
     D PRetCode        S              7A
     D POption         S              7A
     D PSarD           S              6A
     D PACCD           S             10A                                                      CGL029

      ** Parameters for APLOGTRAN
     D TRANSDTL        S           5800A
     D PDealNo         S             18A
     D PADealNo        S             18A

     D PGnDlNo         S              6A

      ** Fields defined for CAP043                                                            CAP043
     D CAP043          S              1A                                                      CAP043
     D OKPrcChg        S              1A   INZ('Y')                                           CAP043
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
     D WOurTheir       S              1A                                                      CAP043
     D X               S              3  0                                                    CAP043
     D PCtlDate        S              5P 0                                                    CAP043
                                                                                              222373
      ** Whether or not to clear the program message queue                                    222373
     D ClearPgmQ       S              1A                                                      222373
                                                                                              CAP043
      ** Define workfields for Commitment Control Changes for Midas Plus                     BUG2603
     D CSC022          S              1A                                                     BUG2603
     D WSkpCom         S              1A                                                     BUG2603
     D WPos            S              2S 0                                                   BUG2603
                                                                                              233467
      ** Additional Parameters for IRSFBOVAL                                                  233467
     D vDLNO           S              6A   INZ(*BLANKS)                                       233467
                                                                                             CSF011A
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRCACFC002
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      /COPY WNCPYSRC,IRCACFC003
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
                                                                                              CAP043
      ** Save message to its corresponding work file when message is not                      CAP043
      ** a trailer, otherwise retrieve saved messages and continue normal                     CAP043
      ** processing                                                                           CAP043
                                                                                              CAP043
     C                   SELECT                                                               CAP043
                                                                                              CAP043
     C                   WHEN      (WMSGTYPE = 'IRCACF')                                      CAP043
                                                                                              CAP043
     C                   EVAL      WSFOTRANID = APFOTRANID                                    CAP043
     C                   EVAL      WSFOASOCID = APFOASOCID                                    CAP043
     C                   EVAL      WSRPRLOCN = APRPRLOCN                                      CAP043
     C                   MOVEL     Trans500      WIRCACF                                      CAP043
     C                   WRITE     IRWCACFD0                                                  CAP043
                                                                                              CAP043
     C                   WHEN      (WMSGTYPE = 'IRCAPC') AND (CAP041 = 'Y')                   CAP043
                                                                                              CAP043
     C                   EVAL      PWSFOTRANID = APFOTRANID                                   CAP043
     C                   EVAL      PWSFOASOCID = APFOASOCID                                   CAP043
     C                   EVAL      PWSRPRLOCN = APRPRLOCN                                     CAP043
                                                                                              CAP043
     C                   EVAL      PWSOURTH = ' '                                             CAP043
     C                   MOVEL     TRANS500      WPrcChg1                                     CAP043
     C                   MOVEL     TRANSB500     WPrcChg2                                     CAP043
     C                   MOVEL     TRANSC500     WPrcChg3                                     CAP043
     C                   MOVEL     TRANSD500     WPrcChg4                                     CAP043
     C                   MOVEL     PrcChgDS      WPrinChg                                     CAP043
     C                   WRITE     IRWPCSCD0                                                  CAP043
                                                                                              CAP043
     C                   WHEN      (WMSGTYPE = 'IRCATR')                                      CAP043
     C                   MOVEL     TRANS500      TrailerDS                                    CAP043
                                                                                              CAP043
     C                   ENDSL                                                                CAP043
                                                                                              CAP043
      ** Only process transaction record once the trailer arrives                             CAP043
                                                                                              CAP043
     C                   IF        WMSGTYPE <> 'IRCATR'                                       CAP043
                                                                                              CAP043
     C                   IF        CSC022 = 'N'                                              BUG2603
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                       BUG2603
     C                   COMMIT                                                               CAP043
     C                   ENDIF                                                               BUG2603
                                                                                              CAP043
     C                   RETURN                                                               CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Retrieve transaction message then load it onto receiving parameter                   CAP043
      ** data structure                                                                       CAP043
                                                                                              CAP043
     C                   EXSR      SRRtvCACF                                                  CAP043
                                                                                              CAP043
      ** Load work file records to respective arrays (ours/theirs)                            CAP043
                                                                                              CAP043
     C                   EXSR      SRLoadArr                                                  CAP043
     C                   ENDIF                                                                CAP043

      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used b/w this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.

     C                   MOVEL     Trans500      TranIn
     C                   MOVEL     Extdata500    Extdata
     C                   MOVEL     InfData500    InfData                                      CAP056

      * If CAP041 is installed, move Fees/Buy-Outs fields to one DS for
      * processing later.
     C                   IF        CAP041 = 'Y'
     C                   EVAL      ASOIPM  = #0OIPM
     C                   EVAL      ASONPCD = #0ONPCD
     C                   EVAL      ASTIPM  = #0TIPM
     C                   EVAL      ASTNPCD = #0TNPCD
     C                   EVAL      ASUFVD  = #0UFVD
     C                   EVAL      ASUFEE  = #0UFEE
     C                   EVAL      ASUFPR  = #0UFPR
     C                   EVAL      ASBOVD  = #0BOVD
     C                   EVAL      ASBUYA  = #0BUYA
     C                   EVAL      ASBOPR  = #0BOPR
     C                   ENDIF

      ** Generate a timestamp for this transaction

     C                   RESET                   RetCodeOut

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp

      ** Reset variables gradually updated, once only at start

     C                   EXSR      SrResetCycl

      /COPY WNCPYSRC,IRCACFC004

      ** Check if valid deal exists for Front office ID
      ** If valid deal does exist (even after delay), fail this input

     C                   EXSR      SrChkDlFOID
     C                   IF        Idx <> *ZERO
     C                   GOTO      INVALID
     C                   ENDIF

      ** Check if valid deal exists for Midas deal number
      ** If valid deal does exist (even after delay), fail this input

     C                   EXSR      SrChkDlDLNO
     C                   IF        Idx <> *ZERO
     C                   GOTO      INVALID
     C                   ENDIF

      ** Reset variables again in case they were corrupted by
      ** previous chain to Valid deals file

     C                   EXSR      SrResetCycl

      /COPY WNCPYSRC,IRCACFC005
      ** Validate Action code

     C                   EXSR      SrValActCde

      /COPY WNCPYSRC,IRCACFC006
      ** If error in validation of action code, fail this input

     C                   IF        Idx <> *ZERO
     C                   GOTO      INVALID
     C                   ENDIF

      ** Processing depends upon Action code:

     C                   SELECT

      ** For Inserts

     C                   WHEN      #0ACCD = 'I'
      /COPY WNCPYSRC,IRCACFC007
     C                   EXSR      SrDefaultSSI
      /COPY WNCPYSRC,IRCACFC008
     C                   EXSR      SrValTrans
      /COPY WNCPYSRC,IRCACFC009
     C                   EXSR      SrValSSI
      /COPY WNCPYSRC,IRCACFC010

      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change
      ** Date) is installed and no previous errors, then perform validation of fields.

     C                   IF        CAP041 = 'Y' AND Idx = 0
     C                             AND CIR006 = 'Y'                                         AR218555
     C                   EXSR      SrValidFE
     C                   IF        (CAP043 = 'Y') AND Idx = 0                                 CAP043
     C                   EXSR      ValidateIC3                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF

      ** For Amends

     C                   WHEN      #0ACCD = 'A'
      /COPY WNCPYSRC,IRCACFC011
     C                   IF        GHSUBS <> *BLANKS
     C     GHSUBS        SCAN      TranIn                                 80
     C                   IF        *IN80 = *ON
     C                   EXSR      SrDtaSubsT
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SrSetupAmd
      /COPY WNCPYSRC,IRCACFC012
     C                   EXSR      SrValTrans
      /COPY WNCPYSRC,IRCACFC013
     C                   EXSR      SrValSSI

      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change
      ** Date) is installed and no previous errors, then perform validation of fields.

     C                   IF        CAP041 = 'Y' and Idx = 0
     C                             AND CIR006 = 'Y'                                         AR218555
     C                   EXSR      SrValidFE
     C                   IF        (CAP043 = 'Y') AND Idx = 0                                 CAP043
     C                   EXSR      ValidateIC3                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF

      /COPY WNCPYSRC,IRCACFC014
     C                   EXSR      SrValAmend
      /COPY WNCPYSRC,IRCACFC015

     C                   ENDSL

      ** Check for exception error from any program lower in the stack
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program

     C     INVALID       TAG
     C                   IN        APDUMP
      /COPY WNCPYSRC,IRCACFC016
     C                   IF        ARERRMOD <> *BLANKS
     C                   EVAL      PSysOprMsg = 'Error in module' +
     C                             ARERRMOD

     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    RetCodeOut
     C                   PARM                    PSysOprMsg
     C                   PARM                    PMsgID
     C                   PARM                    PMsgF

     C                   EVAL      APRETCODE = ARERRMOD
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANKS
     C                   OUT       APDUMP
     C                   RETURN

     C                   ELSE

      /COPY WNCPYSRC,IRCACFC017
      ** Processing for Error checking/write to database

     C                   EXSR      SrChkWrite

      /COPY WNCPYSRC,IRCACFC018
      ** If valid, send data queue entry to prompt DB update program

     C                   IF        Idx = *ZERO
     C                   EVAL      WObject = 'IRCACFUPC'
     C                   EVAL      WLib = '*LIBL'
     C                   EVAL      WObjTyp = '*DTAARA'
     C                   EVAL      WLckState = '*SHRRD'
     C                   EVAL      WWait = '0     '
     C                   EVAL      WDlcobj = 'Y'

      ** Check if update program active using Allocate Object API
      ** No prompting necessary if program is running

     C                   CALLB     'APCALCOBJ'
     C                   PARM                    WObject
     C                   PARM                    WLib
     C                   PARM                    WObjTyp
     C                   PARM                    WLckState
     C                   PARM                    WMember
     C                   PARM                    WWait
     C                   PARM                    WDlcobj
     C                   PARM      *BLANKS       WRtCd7A

     C                   IF        WRtCd7A = *BLANKS
      **---------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     C/COPY ZACPYSRC,DTAQCHK
      **---------------------------------------------------------------
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   RETURN

      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRCACFC019
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRRtvCACF - Retrieve Caps, Collars and Floors Transaction Details*                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRRtvCACF     BEGSR                                                                CAP043
                                                                                              CAP043
     C     APFOAsocID    CHAIN     IRWCACFL0                                                  CAP043
                                                                                              CAP043
     C                   IF        %FOUND(IRWCACFL0)                                          CAP043
     C                   CLEAR                   Trans500                                     CAP043
     C                   MOVEL     WIRCACF       Trans500                                     CAP043
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
      ** Our Principal Change                                                                 CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C                   EVAL      OurPCSC = *BLANK                                           CAP043
     C                   EVAL      WOurTheir = ' '                                            CAP043
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
     C                   ENDIF                                                                CAP043
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
     C                   IF        (#0ONPCD = *BLANK)                                         CAP043
     C                   MOVE      'N'           OKPrcChg                                     CAP043
     C                   ADD       1             Idx                                          CAP043
     C                   EVAL      FldNameArr(Idx) = 'SDAT01'                                 CAP043
     C                   EVAL      MsgIDArr(Idx) = 'MMA1248'                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ELSE                                                                 CAP043
     C                   IF        (#0ONPCD <> *BLANK)                                        CAP043
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
     C                   PARM                    RPVDAT                                       CAP043
     C                   PARM                    RPMDAT                                       CAP043
     C                   PARM      #1UNPC        PCtlDate                                     CAP043
     C                   PARM                    BJDFIN                                       CAP043
     C                   PARM      #0ACCD        PAction                                      CAP043
     C                   PARM      #0DLNO        PDealNo                                      CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM      'P'           PValType                                     CAP043
     C                   PARM      ' '           POurTheir                                    CAP043
     C                   PARM      #0CUCY        PCurrency                                    CAP043
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
     C                   EVAL      PYOURTHR = ' '                                             CAP043
     C                   EVAL      PYTMESTMP = PTimeStamp                                     CAP043
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
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValidFE  - Routine to validate Fees\Buy-Outs fields         *
      *                                                               *
      *****************************************************************

     C     SrValidFE     BEGSR

     C                   IF        #0ACCD = 'I'
     C                   EXSR      SrSetupDLNO
     C                   ENDIF

      ** Set up details of DS DATA before calling validation.
     C/COPY QWINDSRC,IRCACFMOV1

      ** Set up Our/Their number of decimal places.
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM      #1UCUC        PCcy              3
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   EVAL      PWUCDP = A6NBDP

     C                   IF        #1TCUC <> *BLANKS

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      #1TCUC        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   EVAL      PWTCDP = A6NBDP
     C                   ELSE
     C                   EVAL      PWTCDP = A6NBDP
     C                   ENDIF

      ** Set up Settlement & Receivers currency.

     C                   IF        CEU003 = 'Y' AND #1PSCY <> *BLANKS
     C                   MOVEL     #1PSCY        PWPSCY
     C                   ELSE
     C                   MOVEL     #1UCUC        PWPSCY
     C                   ENDIF

     C                   IF        CEU003 = 'Y' AND #1RSCY <> *BLANKS
     C                   MOVEL     #1RSCY        PWRSCY
     C                   ELSE
     C                   MOVEL     #1TCUC        PWRSCY
     C                   ENDIF

      ** Access nostro location for our-effective-settlement-currency

     C                   IF        PWPSCY <> *BLANKS

     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANK        PCust
     C                   PARM      PWPSCY        PCcy
     C                   PARM      *BLANKS       PAccd
     C                   PARM      *BLANKS       PAcsn
     C                   PARM      #1UNON        PNost
     C                   PARM      *BLANKS       PBrcd
     C                   PARM      *BLANKS       PCssn
     C                   PARM      *BLANKS       Pinoy
     C     SDNOST        PARM      SDNOST        DSFDY

     C                   IF        PRtcd = *BLANKS
     C                   MOVE      A7NOSN        PWPNLOC
     C                   ELSE
     C                   MOVE      *BLANKS       PWPNLOC
     C                   ENDIF

     C                   ENDIF

      ** Access nostro location for their-effective-settlement-currency

     C                   IF        PWRSCY <> *BLANKS

     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANK        PCust             6
     C                   PARM      PWRSCY        PCcy
     C**********         PARM      *BLANKS       PAccd             4                          CGL029
     C                   PARM      *BLANKS       PAccd                                        CGL029
     C                   PARM      *BLANKS       PAcsn             2
     C                   PARM      #1TNON        PNost             2 0
     C                   PARM      *BLANKS       PBrcd             3
     C                   PARM      *BLANKS       PCssn            10
     C                   PARM      *BLANKS       Pinoy             1
     C     SDNOST        PARM      SDNOST        DSFDY

     C                   IF        PRtcd = *BLANKS
     C                   MOVE      A7NOSN        PWRNLOC
     C                   ELSE
     C                   MOVE      A7NOSN        PWRNLOC
     C                   ENDIF

     C                   ENDIF

     C                   CALLB     'IRSFBOVAL'
      *
      ** INPUTS
      ** ======
      *
      * Response mode
     C                   PARM                    APRespMode
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *                                                                                       233467
      ** Deal no.                                                                             233467
     C                   PARM                    vDLNO                                        233467
      *
      ** OTHERS
      ** ======
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    PWUCDP
     C                   PARM                    PWTCDP
      *
      ** Settlement currency
      ** Receivers currency
     C                   PARM                    PWPSCY
     C                   PARM                    PWRSCY
      *
      ** Nostro Locations
     C                   PARM                    PWPNLOC
     C                   PARM                    PWRNLOC
      *
      ** OUTPUTS
      ** =======
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO

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
      *
      ** Deal info passed from calling programs
     C                   PARM                    Data
     C                   PARM                    BNDCSP                                       245692

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkDlFOID - Check if Valid Deal Exists for Front Office ID *
      *                                                               *
      *****************************************************************
     C     SrChkDlFOID   BEGSR

     C     APFOTranID    CHAIN     IRVCACFL0

      ** If found, delay and repeat check. Error if still present.

     C                   IF        %FOUND(IRVCACFL0)
     C                   CALLB     'ZACDELAY'
     C     APFOTranID    CHAIN     IRVCACFL0
     C                   IF        %FOUND(IRVCACFL0)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkDlDLNO - Check if Valid Deal Exists for Deal Number     *
      *                                                               *
      *****************************************************************
     C     SrChkDlDLNO   BEGSR

      ** Check if deal number supplied is numeric

     C                   TESTN                   #0DLNO               8181

     C                   IF        #0DLNO <> *BLANKS AND *IN81 = *ON

      ** Check for deal on Valids file

     C                   MOVEL     #0DLNO        RPDLNO
     C     RPDLNO        CHAIN     IRVCACFL1

      ** If found, delay and repeat check. Error if still present.

     C                   IF        %FOUND(IRVCACFL1)
     C                   CALLB     'ZACDELAY'
     C     RPDLNO        CHAIN     IRVCACFL1
     C                   IF        %FOUND(IRVCACFL1)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValActCde - Validate Action Code VS Deal Number Supplied   *
      *                                                               *
      *****************************************************************
     C     SrValActCde   BEGSR

      ** If insert OR if not insert and Midas deal no. is not present
      **   set retrieve mode to '*FRONT' (Access using FOID)
      ** Otherwise, set retrieve mode to blank (Access using DLNO)

     C                   IF        #0ACCD = 'I'
     C                   EVAL      ModeOfOp = '*FRONT'
     C                   ELSE
     C                   IF        #0DLNO = *BLANKS
     C                   EVAL      ModeOfOp = '*FRONT'
     C                   ELSE
     C                   EVAL      ModeOfOp = *BLANKS
     C                   ENDIF
     C                   ENDIF

      ** Validate Action code versus Deal number supplied

     C                   CALLB     'IRCACFRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    ModeOfOp
     C                   PARM                    APRESPMODE
     C                   PARM                    #0ACCD
     C                   PARM                    APFOTranID
     C                   PARM                    APFOAsocID
     C                   PARM                    #0DLNO
     C                   PARM                    #0LNKD
     C                   PARM                    #0BRCA
     C                   PARM                    #0DTYP
     C                   PARM                    BJSBRC
     C                   PARM                    DBRN
     C                   PARM                    BKOBUV
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CrIRFilFmt
     C                   PARM                    OKACCD
     C                   PARM                    OKDLNO
     C                   PARM                    OKBRCA
     C                   PARM                    OKDTYP
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDefaultSSI - Apply Default Settlement Instructions,        *
      *                 If None Have Been Supplied                    *
      *                                                               *
      *****************************************************************
     C     SrDefaultSSI  BEGSR

      ** If ANY of Settlement fields were entered, bypass this routine.
      ** Otherwise, use modules that will use SSIs to apply defaults

     C                   IF        InRecSttmt = *BLANKS AND
     C                             InPaySttmt = *BLANKS

     C                   CALLB     'ZASETINDFT'
     C                   PARM                    CACF
     C                   PARM                    #0CUCY
     C                   PARM                    PBlank3
     C                   PARM                    #0CNUM
     C                   PARM                    #0DTYP
     C                   PARM                    #0FEFI
     C                   PARM                    BQISDA
     C                   PARM                    BQAGTY
     C                   PARM                    BQAGDT
     C                   PARM                    BQAGVV
     C                   PARM                    BQAGVC
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
                                                                                              CSD095
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt

      ** Defaulted instructions are in file format, but the Settlements
      ** validation requires that they are in the input format.
      ** Therefore run them through a conversion module.

     C                   CALLB     'ZASETINCVT'
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      #0CUCY        InRCCY                                      CSF011A
     C                   PARM      #0CUCY        InPCCY                                      CSF011A

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetupAmd - Setup Fields Needed in Validation of Amendments *
      *                                                               *
      *****************************************************************
     C     SrSetupAmd    BEGSR

      ** For Amends, put the complete (pre-existing) FRA into the Valid
      ** file record - fields in this will be updated during processing

     C                   MOVEL     CrIRFilFmt    NwIRFilFmt

     C**********         EVAL      DBRecSttmt = CACFRecIns + RPROBR                           CGL029
     C                   MOVE      RPRSTM        FLRSTM                                       CGL029
     C                   MOVE      RPRONS        FLRONS                                       CGL029
     C                   EVAL      DBRecSttmt1 = CACFRecIns                                   CGL029
     C                   MOVE      RPROBR        FLROBR                                       CGL029
     C                   EVAL      FLRSCY     = RPRSCY
     C**********         EVAL      DBPaySttmt = CACFPayIns + RPPOBR +                         CGL029
     C**********                   RPCVMR                                                     CGL029
     C                   MOVE      RPPSTM        FLPSTM                                       CGL029
     C                   MOVE      RPPONS        FLPONS                                       CGL029
     C                   EVAL      DBPaySttmt1 = CACFPayIns                                   CGL029
     C                   MOVE      RPPOBR        FLPOBR                                       CGL029
     C                   MOVE      RPCVMR        FLCVMR                                       CGL029
     C                   EVAL      FLPSCY     = RPPSCY
     C                   EVAL      FLIC72     = RPIC72
     C                   EVAL      DBFraSttmt = CACFFraIns
     C                   MOVE      RPAGVC        FLAGVC

      ** .... and then convert these to the screen format

     C                   CALLB     'ZASETINCVT'
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
     C                   PARM                    CrPaySttmt
     C                   PARM                    CrRecSttmt
     C                   PARM                    CrFRASttmt
     C                   PARM      #0CUCY        InRCCY                                      CSF011A
     C                   PARM      #0CUCY        InPCCY                                      CSF011A

      ** If no Payment or Receive instructions have been supplied
      ** default them to those currently on the deal

     C                   IF        InPaySttmt = *BLANKS
     C                   EVAL      InPaySttmt = CrPaySttmt
     C                   ENDIF

     C                   IF        InRecSttmt = *BLANKS
     C                   EVAL      InRecSttmt = CrRecSttmt
     C                   ENDIF

     C                   IF        InFRASttmt = *BLANKS
     C                   EVAL      InFRASttmt = CrFRASttmt
     C                   ENDIF

      ** Do data substitution for Settlement Instructions

     C                   IF        GHSUBS <> *BLANKS
     C     GHSUBS        SCAN      InPaySttmt                             80
     C                   IF        *IN80 = *OFF
     C     GHSUBS        SCAN      InRecSttmt                             80
     C                   ENDIF
     C                   IF        *IN80 = *OFF
     C     GHSUBS        SCAN      InFRASttmt                             80
     C                   ENDIF
     C                   IF        *IN80 = *ON
     C                   EXSR      SrDtaSubsS
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValTrans - Validate Main Transaction Details               *
      *                                                               *
      *****************************************************************
     C     SrValTrans    BEGSR

      ** Set up settlemnt information needed for holidays validation:
      ** - default fields for Inserts
      ** - existing d/b fields for Amends

     C                   IF        #0ACCD = 'I'
     C                   EVAL      RecSetMeth = RPRSTM
     C                   EVAL      RecNostro  = RPRONS
     C                   EVAL      PaySetMeth = RPPSTM
     C                   EVAL      PayNostro  = RPPONS
     C                   ENDIF

     C                   IF        #0ACCD = 'A'
     C                   EVAL      RecSetMeth = RPRSTM
     C                   EVAL      RecNostro  = RPRONS
     C                   EVAL      PaySetMeth = RPPSTM
     C                   EVAL      PayNostro  = RPPONS
     C                   ENDIF

      ** If Business Day Convention enhancement is installed, allow
      ** validation of dates through currency conventions, otherwise
      ** validation against BDC not needed.

     C                   IF        CIR005 = 'Y'
     C                   EVAL      WValBDC = 'Y'
     C                   ELSE
     C                   EVAL      WValBDC = 'N'
     C                   ENDIF

     C                   CALLB     'IRCACFVAL'
     C                   PARM      '*FRONT'      ModeOfOp
     C                   PARM                    APRespMode
     C                   PARM                    CrIRScnFmt
     C                   PARM                    TranIn
     C                   PARM      *BLANKS       RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM      *BLANKS       PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    ExtData
     C                   PARM                    WValBDC
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDDEAL
     C                   PARM                    SDGELR
     C                   PARM                    SDTRAD
     C                   PARM                    SDFAIS
     C                   PARM                    ZMUSER
     C                   PARM                    CIR001
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CIR007
     C                   PARM                    IRECACF
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwIRFilFmt
      ***Sign*of Short Term Rate                                                     BUG5707 BUG6472
     C**********         PARM                    #0SIGN            1                 BUG5707 BUG6472

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValSSI - Validate Settlement Instructions                  *
      *                                                               *
      *****************************************************************
     C     SrValSSI      BEGSR

      ** The called module requires that customer number/name is valid.
      ** If it is not, exit from this subroutine.

     C                   IF        OKCNUM <> 'Y'
     C                   GOTO      ESrValSSI
     C                   ENDIF

      ** Set pay and receive dates to run date

     C                   EVAL      PayDat = BJRDNB
     C                   EVAL      RecDat = BJRDNB

     C                   CALLB     'ZASETINVAL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    CACF
     C                   PARM                    #0CUCY
     C                   PARM                    #0CUCY
     C                   PARM                    #0CNUM
     C                   PARM                    #0DTYP
     C                   PARM                    #0FEFI
     C                   PARM                    #0BRCA
     C                   PARM                    RecDat
     C                   PARM                    Paydat
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    #0ACCD
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
     C                   PARM                    OKPaySSI
     C                   PARM                    OKRcvSSI
     C                   PARM                    OKFraSSI
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller                      222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIDArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
      ** Array index (3P0) from/to caller                                                     222373
     C                   PARM                    WIdx                                         222373
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
     C                   PARM      #0ACCD        PAction
     C                   PARM      '1ST'         PValIter

     C     ESrValSSI     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDtaSubsT - Transaction Details Data Substitution           *
      *                                                               *
      *****************************************************************
     C     SrDtaSubsT    BEGSR

      ** Convert of File fields to Screen format

     C                   CALLB     'IRCACFCVT'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    #0ACCD
     C                   PARM                    CrIRFilFmt
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    BJDFIN
     C                   PARM                    BGPFMG
     C                   PARM                    BNDCSP
     C                   PARM                    CrIRScnFmt
     C                   PARM                    PDealSts
      ***Sign*of Short Term Rate                                                     BUG5707 BUG6472
     C**********         PARM                    #0SIGN                              BUG5707 BUG6472

      ** Data substitution

     C                   CALLB     'APDTASUBS'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      GHSUBS        PSubsChar
     C                   PARM      TranIn        IncDATA
     C                   PARM      CrIRScnFmt    CurDATA

     C                   MOVEL     IncDATA       TranIn

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDtaSubsS - Settlement Details Data Substitution            *
      *                                                               *
      *****************************************************************
     C     SrDtaSubsS    BEGSR

      ** Payment instructions

     C                   CALLB     'APDTASUBS'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      GHSUBS        PSubsChar
     C                   PARM      InPaySttmt    IncDATA
     C                   PARM      CrPaySttmt    CurDATA

     C                   MOVEL     IncDATA       InPaySttmt

      ** Receipt instructions

     C                   CALLB     'APDTASUBS'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      GHSUBS        PSubsChar
     C                   PARM      InRecSttmt    IncDATA
     C                   PARM      CrRecSttmt    CurDATA

     C                   MOVEL     IncDATA       InRecSttmt

      ** FRA/IRS instructions

     C                   CALLB     'APDTASUBS'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      GHSUBS        PSubsChar
     C                   PARM      InFRASttmt    IncDATA
     C                   PARM      CrFRASttmt    CurDATA

     C                   MOVEL     IncDATA       InFRASttmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValAmend - Validate Whether Amended Fields are Amendable   *
      *                                                               *
      *****************************************************************
     C     SrValAmend    BEGSR

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

      ** Conversion of File fields to Screen format

     C                   CALLB     'IRCACFCVT'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    #0ACCD
     C                   PARM                    CrIRFilFmt
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    BJDFIN
     C                   PARM                    BGPFMG
     C                   PARM                    BNDCSP
     C                   PARM                    CrIRScnFmt
     C                   PARM                    PDealSts

     C                   CALLB     'IRCACFAMD'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    TranIn
     C                   PARM                    CrIRScnFmt
     C                   PARM                    CrIRFilFmt
     C                   PARM      'N'           PResetErrs
     C                   PARM                    BJRDNB
     C                   PARM                    BGPFMG
     C                   PARM                    BGMBIN
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKOBRU
     C                   PARM                    CIR001
     C                   PARM                    CIR006
     C                   PARM                    IRECACF
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
     C                   PARM                    AmIdx
     C                   PARM                    PAmendOk
      *
     C                   IF        CAP041 = 'Y' AND AmIdx = 0
      *
     C                   EVAL      BSOIPM  = @#0OIPM
     C                   EVAL      BSONPCD = @#0ONPCD
     C                   EVAL      BSTIPM  = @#0TIPM
     C                   EVAL      BSTNPCD = @#0TNPCD
     C                   EVAL      BSUFVD  = @#0UFVD
     C                   EVAL      BSUFEE  = @#0UFEE
     C                   EVAL      BSUFPR  = @#0UFPR
     C                   EVAL      BSBOVD  = @#0BOVD
     C                   EVAL      BSBUYA  = @#0BUYA
     C                   EVAL      BSBOPR  = @#0BOPR
      *
     C                   CALLB     'IRSFBOAMD'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    ReturnCode
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** Transaction Details retrieved from file - in screen
     C                   PARM                    CrFBScnFmt
      *
      ** Deal information details
     C                   PARM                    Data
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           PResetFld         1
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
     C                   PARM                    PWUCDP
      *
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    PWTCDP
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Rundate
     C                   PARM                    BJRDNB
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Overnight index swaps
     C                   PARM                    CIR007
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    AmIDx
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
     C                   PARM                    BNDCSP                                       245692
      *
     C                   ENDIF

      ** If any errors overwrite previous error information

     C                   IF        AmIdx <> *ZERO
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   EVAL      Idx = AmIdx
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkWrite - Control Checking of Error Status and Sending of *
      *               Messages/Writing to the Database                *
      *                                                               *
      *****************************************************************
     C     SrChkWrite    BEGSR

      ** If no errors were found:
      ** - If Action Code = I and Deal Number is not supplied
      **   set up the deal number
      ** - If there are still no errors
      **    - set up additional data
      **    - write a record to the Valid file
      **    - use std message handler to report deal status
      ** If any errors were found:
      ** - write a record to the Invalid file
      ** - call the message handler to pass the errors back
      ** - use std message handler to report deal status
      ** The index to the error arrays is checked for presence/absence
      ** of errors

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

     C                   IF        Idx = *ZERO

     C                   IF        #0ACCD = 'I'
     C                   EXSR      SrSetupDLNO
     C                   ENDIF

     C                   IF        Idx = *ZERO
     C                   EXSR      SrSetupVld
     C                   WRITE     IRVCACFD0
                                                                                              CAP043
      ** Principal Change Schedule                                                            CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
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
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Insert DLDLDGQD record for CLE025 processing                                         247888
     C                   IF        #1ACTN = 'I' AND CLE025 = 'Y'                              247888
     C     #0DLNO        CHAIN     DLDLDGD0                           12                      247888
     C     *IN12         IFEQ      *ON                                                        247888
     C                   EVAL      DX_F1DLNO = #0DLNO                                         247888
     C                   EVAL      DX_F1BRCA = #0BRCA                                         247888
     C                   WRITE     DLDLDGD0                                                   247888
     C                   ENDIF                                                                247888
     C                   ENDIF                                                                247888
                                                                                              247888
     C                   EXSR      SrMsgHndl
     C                   ENDIF

     C                   ENDIF

     C                   IF        Idx > *ZERO
     C                   EXSR      SrSetupInv

      ** Only write to Invalids file if repair in Back office

     C                   IF        APRprLocn = 'B'
     C                   WRITE     IRICACFD0
     C                   WRITE     APIDSETD0

      ** Also write all invalid records to the support log file

     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR

     C                   EVAL      TRANSDTL = TranIn +
     C                                        InRecSttmt +
     C                                        InPaySttmt +
     C                                        InFRASttmt +
     C                                        InfData +
     C                                        ExtData

     C                   EVAL      APTGTTYPE  = 'IRCACF'
     C                   EVAL      PDealNo = #0DLNO

     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    PTimestamp
     C                   PARM                    PDealNo
     C                   PARM      *BLANKS       PADealNo

     C                   IF        RetCodeOut <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 015
     C                   EVAL      DBKEY = #0DLNO
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C                   EVAL      PITFOtranID = APFOTranID                                   CAP043
     C                   EVAL      PITRprLocn  = APRprLocn                                    CAP043
     C                   EVAL      PITTmeStmp  = PTimeStamp                                   CAP043
                                                                                              CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C                   DOW       (OurPCSC(X) <> *BLANK)                                     CAP043
                                                                                              CAP043
      ** Our Principal Change                                                                 CAP043
                                                                                              CAP043
     C                   IF        OurPCSC(X) <> *BLANK                                       CAP043
     C                   EVAL      PITOURTHR = ' '                                            CAP043
     C                   EVAL      WInvPrcChg = OurPCSC(X)                                    CAP043
     C                   WRITE     IRIPCSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If support system is active, write invalid transaction to                            CAP043
      ** log file via APLOGTRAN standard module.                                              CAP043
                                                                                              CAP043
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CAP043
                                                                                              CAP043
     C                   EVAL      WMSGTYPE2 = 'IRCAPC'                                       CAP043
     C                   EVAL      TRANSDTL =  OurPCSC(X) + ExtData                           CAP043
     C                   EXSR      SRLogInvTr                                                 CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Also log trailer file                                                                CAP043
                                                                                              CAP043
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CAP043
                                                                                              CAP043
     C                   EVAL      WMSGTYPE2 = 'IRCATR'                                       CAP043
     C                   EVAL      TRANSDTL =  TrailerDS                                      CAP043
     C                                         + InPaySttmt                                   CAP043
     C                                         + InRecSttmt                                   CAP043
     C                                         + InFRASttmt                                   CAP043
     C                                         + InfData                                      CAP043
     C                                         + ExtData                                      CAP043
     C                   EXSR      SRLogInvTr                                                 CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF

     C                   EXSR      SrMsgHndl
     C                   ENDIF
                                                                                              CAP043
      ** Remove records from work and temporary file                                          CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C                   EXSR      SRClrWrkTmp                                                CAP043
     C                   ENDIF                                                                CAP043

     C                   IF        CSC022 = 'N' OR                                           BUG2603
     C                             CSC022 = 'Y' AND WSkpCom = 'N'                            BUG2603
     C                   COMMIT
     C                   ENDIF                                                               BUG2603

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrResetCycl - Reset Error Information that is Gradually      *
      *                Updated During Each Run of this Program        *
      *                                                               *
      *****************************************************************
     C     SrResetCycl   BEGSR

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

     C                   RESET                   IRECACF

     C                   RESET                   PAmendOK

     C                   RESET                   OKPaySSI
     C                   RESET                   OKRcvSSI
     C                   RESET                   OKFraSSI
     C                   MOVE      *ALL'Y'       OKFEBO
     C                   RESET                   OKPrcChg                                     CAP043

     C                   RESET                   PayDat
     C                   RESET                   RecDat

      ** Numeric fields within 'NwIRFilFmt' have to be reset explicitly
      ** as there are long alpha fileds overlapping these which cause
      ** the CLEAR to put blanks in the numeric fields

     C                   CLEAR                   NwIRFilFmt

     C                   EVAL      RPRSTM = *ZERO
     C**********         EVAL      RPROBN = *ZERO                                             CSD027
     C**********         EVAL      RPROCN = *ZERO                                             CSD027
     C                   EVAL      RPROBN = *BLANKS                                           CSD027
     C                   EVAL      RPROCN = *BLANKS                                           CSD027
     C                   EVAL      RPPSTM = *ZERO
     C**********         EVAL      RPPOBN = *ZERO                                             CSD027
     C**********         EVAL      RPPOCN = *ZERO                                             CSD027
     C                   EVAL      RPPOBN = *BLANKS                                           CSD027
     C                   EVAL      RPPOCN = *BLANKS                                           CSD027

      ** Have to clear the settlement data structure, or the packed
      ** numeric fields are not initialised correctly

     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt
     C                   CLEAR                   VldPrinChg                                   CAP043
     C                   CLEAR                   InvPrinChg                                   CAP043

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetupInv - Setup Additional Fields Needed on Invalids File *
      *                                                               *
      *****************************************************************
     C     SrSetupInv    BEGSR

     C                   EVAL      #0FOID = APFOTranID
     C                   EVAL      #0LOCN  = APRprLocn
     C                   EVAL      #0TMES  = PTimeStamp
     C                   EVAL      DDMSGTYPE  = 'IRCACF'
     C                   EVAL      DDFOTRANID = APFOTranID
     C                   EVAL      DDRPRLOCN  = APRprLocn
     C                   EVAL      DDTMESTMP = PTimeStamp
     C                   EVAL      PTranSts = 'F'
                                                                                              CAP056
      ** Setup the InValid file with 'Authomatic Authorisation' from                          CAP056
      ** Interface file IRRPIFPD                                                              CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                   EVAL      #0AUTH = AUTH                                              CAP056
     C                   ENDIF                                                                CAP056

      /COPY WNCPYSRC,IRCACFC020
     C                   ENDSR
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
     C                   EVAL      PDealNo = #0DLNO                                           CAP043
                                                                                              CAP043
     C                   CALLB     'APLOGTRAN'                                                CAP043
     C                   PARM      *BLANKS       RetCodeOut                                   CAP043
     C                   PARM                    HeadIn                                       CAP043
     C                   PARM                    TRANSDTL                                     CAP043
     C                   PARM                    PTimestamp                                   CAP043
     C                   PARM                    PDealNo                                      CAP043
     C                   PARM      *BLANKS       PADealNo                                     CAP043
                                                                                              CAP043
     C                   IF        RetCodeOut <> *Blanks                                      CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKey = PDealNo                                            CAP043
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
      ** CACF work file                                                                       CAP043
                                                                                              CAP043
     C     APFOTRANID    SETLL     IRWCACFL0                                                  CAP043
     C     APFOTRANID    READE     IRWCACFL0                                                  CAP043
     C                   DOW       NOT %EOF                                                   CAP043
     C                   DELETE    IRWCACFD0                                                  CAP043
     C     APFOTRANID    READE     IRWCACFL0                                                  CAP043
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
      ** PCSC temp file                                                                       CAP043
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
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetupDLNO - Set up Deal Number for Inserts                 *
      *                                                               *
      *****************************************************************
     C     SrSetupDLNO   BEGSR

     C                   IF        #0DLNO = *BLANKS OR #0DLNO = *ZEROS

     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PMsgID
     C                   PARM                    #0DLNO
     C                   PARM                    RPDLNO

     C                   IF        PMsgID <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'
     C                   EVAL      MsgIDArr(Idx) = PMsgID
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag

     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKDLNO
     C                   PARM                    RetCodeOut
     C                   PARM                    WarnGlobal

     C                   ELSE
     C                   MOVE      #0DLNO        RPDLNO
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetupVld - Setup Additional Fields Needed on Valids File   *
      *                                                               *
      *****************************************************************
     C     SrSetupVld    BEGSR

      ** For Inserts and Amends, put the Settlement Instructions (input
      ** or defaulted) into the Valid file record.
      ** Two DSs (one Pay, one Rcv) contain the Settlement Instructions
      ** in contiguous areas, which must be placed into the correct
      ** parts of the Valid file record

     C                   IF        #0ACCD = 'I' OR #0ACCD = 'A'

     C                   EVAL      RPPSTM = FLPSTM                                            CGL029
     C                   EVAL      RPPONS = FLPONS                                            CGL029
     C                   MOVEL     DBPaySttmt    CACFPayIns
     C                   EVAL      RPRSTM = FLRSTM                                            CGL029
     C                   EVAL      RPRONS = FLRONS                                            CGL029
     C                   MOVEL     DBRecSttmt    CACFRecIns
     C                   EVAL      RPPOBR = FLPOBR
     C                   EVAL      RPROBR = FLROBR
     C                   EVAL      RPCVMR = FLCVMR
     C                   EVAL      RPPSCY = FLPSCY
     C                   EVAL      RPRSCY = FLRSCY
     C                   EVAL      RPIC72 = FLIC72
     C                   MOVEL     DBFraSttmt    CACFFraIns
     C                   MOVE      FLAGVC        RPAGVC

      ** Ensure numeric fields are zero if not entered

     C                   IF        FLISDA = *BLANKS
     C                   EVAL      RPISDA = *ZERO
     C                   ENDIF

     C                   IF        FLAGDT = *BLANKS
     C                   EVAL      RPAGDT = *ZERO
     C                   ENDIF

     C                   IF        FLAGVV = *BLANKS
     C                   EVAL      RPAGVV = *ZERO
     C                   ENDIF

     C                   IF        FLAGVC = *BLANKS
     C                   EVAL      RPAGVC = *ZERO
     C                   ENDIF
                                                                                              CAP056
      ** Setup the Valid file with 'Authomatic Authorisation' from                            CAP056
      ** Interface file IRRPIFPD                                                              CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                   EVAL      RPAUTH = AUTH                                              CAP056
     C                   ENDIF                                                                CAP056

      ** Default Up-front Fee pay/receive indicator                                         AR314712
                                                                                            AR314712
     C                   IF        CIR001 = 'Y'                                             AR314712
     C                             AND RPUPPR = *BLANKS                                     AR314712
     C                             AND RPUPFE <> *ZERO                                      AR314712
     C                             AND RPUPVD <> *ZERO                                      AR314712
     C                   IF        #0BYSL = 'B'                                             AR314712
     C                   EVAL      RPUPPR = 'P'                                             AR314712
     C                   ELSE                                                               AR314712
     C                   EVAL      RPUPPR = 'R'                                             AR314712
     C                   ENDIF                                                              AR314712
     C                   ENDIF                                                              AR314712
                                                                                            AR314712
     C                   ENDIF

      ** For Deletes put the complete (pre-existing) deal into the
      ** Valids file record
      ** For Authorise, put the complete (pre-existing) deal into the                         CIR008
      ** Valids file record                                                                   CIR008

     C                   IF        #0ACCD = 'R'
     C                             OR CIR008 = 'Y' AND #0ACCD = 'X'                           CIR008
     C                   MOVEL     CrIRFilFmt    NwIRFilFmt
     C                   ENDIF

      * Set Fees/Buy-Outs fields for update to the valids file if CAP041 is installed.

     C                   IF        CAP041 = 'Y'
     C                             AND CIR006 = 'Y'                                         AR314712
     C                   EXSR      SRFileFlds
     C                   ENDIF

      ** Set Valid file field(s) that are needed for all Action Codes

     C                   EVAL      RPCHTP = #0ACCD

      ** Include Header fields that need to be o/p to the Valid file

     C                   EVAL      RPFRNT = APFOTranID
     C                   EVAL      RPREPA = APRprLocn
     C                   EVAL      RPTMESTMP = PTimeStamp

     C                   EVAL      PTranSts = 'S'
      /COPY WNCPYSRC,IRCACFC021
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFileFlds - Set up file fields                              *
      *                                                               *
      *****************************************************************
      *
     C     SRFileFlds    BEGSR
      *
      ** If any of the Up-front fee details have been
      ** amended, set Confirmation Required indicator to Y
      ** otherwise, set to N.
      *
     C                   IF        #1UPVD <> RPUPVD OR
     C                             #1UPFE <> RPUPFE OR
     C                             #1UPPR <> RPUPPR
     C                   EVAL      #1CNRQ = 'Y'
     C                   EXSR      SRUpdUpF
     C                   ELSE
     C                   EVAL      #1CNRQ = 'N'
     C                   ENDIF

     C/COPY QWINDSRC,IRCACFMOV2

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdUpF -  Write into PF/DLDGUPFE old values of up-front    *
      *              value date, fee and P/R indicator                *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdUpF      BEGSR
      *
     C     #1ACTN        IFEQ      'A'
     C                   MOVE      #1DLNO        DDLNO             6 0
     C     DDLNO         CHAIN     DLDGUPL1                           01
      *
     C                   IF        *IN01
     C                   MOVE      DDLNO         DLNO
     C**********         MOVE      #1UPVD        UPVD                                         185064
     C**********         MOVE      #1UPFE        UPFE                                         185064
     C**********         MOVE      #1UPPR        UPPR                                         185064
     C                   MOVE      RPUPVD        UPVD                                         185064
     C                   MOVE      RPUPFE        UPFE                                         185064
     C                   MOVE      RPUPPR        UPPR                                         185064
     C                   WRITE     DLDGREFF
     C                   ELSE
     C**********         MOVE      #1UPFE        UPFE                                         185064
     C**********         MOVE      #1UPVD        UPVD                                         185064
     C**********         MOVE      #1UPPR        UPPR                                         185064
     C                   MOVE      RPUPVD        UPVD                                         185064
     C                   MOVE      RPUPFE        UPFE                                         185064
     C                   MOVE      RPUPPR        UPPR                                         185064
     C                   UPDATE    DLDGREF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMsgHndl - Call the Message Handling Module                 *
      *                                                               *
      *****************************************************************
     C     SrMsgHndl     BEGSR

      ** Set up an array of sequence numbers that correspond to the
      ** fields with errors

     C                   EVAL      IX = 1
     C                   DO        ArrayMax

     C                   IF        FldNameArr(Ix) <> *BLANKS

     C                   EVAL      Iy = 1
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           82
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)

     C                   ELSE
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      Ix = Ix + 1
     C                   ENDDO

     C                   EVAL      PTranID = #0DLNO

     C                   CALLB     'ZAMSGHNDLE'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APRprLocn
     C                   PARM                    APCnfValFO
     C                   PARM                    MsgIDArr
     C                   PARM                    FldNoArr
     C                   PARM                    FldNameArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    APFOTranID
     C                   PARM                    PModuleID
     C                   PARM                    PTranID
     C                   PARM                    #MsgFile
     C                   PARM                    #0ACCD
     C                   PARM                    PTranSts
     C                   PARM                    APRespMode
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
     C                   PARM                    APRpyQueue
     C                   PARM                    PTimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)                       222373
     C                   PARM                    MsgFArray                                    222373
      ** Whether or not to clear the program message queue (1A)                               222373
     C                   PARM                    ClearPgmQ                                    222373

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Common header information (DS) from source system
      ** Transaction information from source system
      ** Payment Settlement Instruction from source system
      ** Receipt Settlement Instruction from source system
      ** FRA/IRS Settlement Instruction from source system
      ** Incoming Extra Data
      ** Ultimate calling Program
      ** Ultimate calling Module
      ** Ultimate calling Procedure

     C                   PARM                    HeadIn
     C                   PARM                    Trans500
     C                   PARM                    TRANSB500                                    CAP043
     C                   PARM                    TRANSC500                                    CAP043
     C                   PARM                    TRANSD500                                    CAP043
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
                                                                                              CAP056
      ** FRA/IRS Interface Non-Screen Data                                                    CAP056
                                                                                              CAP056
     C                   PARM                    InfData500                                   CAP056
     C                   PARM                    ExtData500
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName

      ** Initialise variables

     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER

     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EVAL      PModuleID = 'IR'
     C                   EVAL      DtaQName = 'APCACFDTQ'
     C                   EVAL      DBPGM = 'IRCACFCTL'
     C                   EVAL      IRECACF = *ALL'Y'

     C     KCFPCList     KLIST                                                                CAP043
     C                   KFLD                    APFOAsocID                                   CAP043
     C                   KFLD                    WOurTheir                                    CAP043
                                                                                              CAP043
      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Module details

     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDMMOD        PARM      SDMMOD        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Dealing details

     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRetCode
     C                   PARM      '*FIRST '     POption
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access General Ledger details

     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRetCode
     C                   PARM      '*FIRST '     POption
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access API ICD

     C                   CALL      'AOAPIR0'
     C                   PARM      '*DBERR '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDAPI         PARM      SDAPI         DSFDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDAPIPD'
     C                   EVAL      DBASE = 005
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access FRA/IRS ICD

     C                   CALL      'AOFAISR0'
     C                   PARM      '*DBERR '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDFAIS        PARM      SDFAIS        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFAISPD'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Tranding details

     C                   CALLB     'AOTRADR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDTRAD        PARM      SDTRAD        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDTRADPD'
     C                   EVAL      DBASE = 007
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if Interest Rate Calendars is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CIR001'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 008
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CIR001 = 'Y'
     C                   ELSE
     C                   EVAL      CIR001 = 'N'
     C                   ENDIF

      ** Check if FRA/IRS Business Day Day Convention is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CIR005'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 009
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CIR005 = 'Y'
     C                   ELSE
     C                   EVAL      CIR005 = 'N'
     C                   ENDIF

      ** Check if Amortisation of Caps, Collars, Floors and
      ** Individual Compounding Swaps is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CIR006'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 010
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CIR006 = 'Y'
     C                   ELSE
     C                   EVAL      CIR006 = 'N'
     C                   ENDIF

      ** Check if Overnight Index Swaps is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CIR007'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 011
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CIR007 = 'Y'
     C                   ELSE
     C                   EVAL      CIR007 = 'N'
     C                   ENDIF

      **  Check if 24x7 Midas Availability is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSC011'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 014
     C                   EVAL      DBKEY = 'CSC011'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
                                                                                              CAP056
      ** Check if Automatic Authorisation feature is installed                                CAP056
                                                                                              CAP056
     C                   CALL      'AOSARDR0'                                                 CAP056
     C                   PARM      *BLANKS       PRetCode                                     CAP056
     C                   PARM      '*VERIFY'     POption                                      CAP056
     C                   PARM      'CAP056'      PSarD                                        CAP056
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP056
                                                                                              CAP056
     C                   IF        PRetCode <> *BLANKS AND                                    CAP056
     C                             PRetCode <> '*NRF   '                                      CAP056
     C     *LOCK         IN        LDA                                                        CAP056
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP056
     C                   EVAL      DBASE = 012                                                CAP056
     C                   EVAL      DBKEY = PSarD                                              CAP056
     C                   OUT       LDA                                                        CAP056
     C                   EXSR      *PSSR                                                      CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP056
     C                   IF        PRetCode = *BLANKS                                         CAP056
     C                   EVAL      CAP056 = 'Y'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   EVAL      CAP056 = 'N'                                               CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CIR008
      **  Check if FRA/IRS Deals Authorisation is installed                                   CIR008
                                                                                              CIR008
     C                   CALL      'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       PRetCode                                     CIR008
     C                   PARM      '*VERIFY'     POption                                      CIR008
     C                   PARM      'CIR008'      PSarD                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRetCode <> *BLANKS AND                                    CIR008
     C                             PRetCode <> '*NRF   '                                      CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE = 013                                                CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
     C                   OUT       LDA                                                        CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        PRetCode = *BLANKS                                         CIR008
     C                   EVAL      CIR008 = 'Y'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      CIR008 = 'N'                                               CIR008
     C                   ENDIF                                                                CIR008

      ** Check if APIs for IRS Fees/Buy-Outs/Processing Method/Next
      ** Principal Change Date feature is switched on

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CAP041'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 016
     C                   EVAL      DBKEY = 'CAP041'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CAP041 = 'Y'
     C                   ELSE
     C                   EVAL      CAP041 = 'N'
     C                   ENDIF

      ** Access SAR details file to determine EMU Dealing Settlement Ccy
      ** Conversion feature is switched on.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CEU003'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 017
     C                   EVAL      DBKEY = 'CEU003'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CEU003 = 'Y'
     C                   ELSE
     C                   EVAL      CEU003 = 'N'
     C                   ENDIF

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
     C                   EVAL      DBASE = 918                                                CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      *                                                                                      BUG2603
      ** Determine if enhancement CSC022 is switched on                                      BUG2603
      *                                                                                      BUG2603
     C                   CALLB     'AOSARDR0'                                                BUG2603
     C                   PARM      *BLANKS       PRTCD                                       BUG2603
     C                   PARM      '*VERIFY'     POPTN                                       BUG2603
     C                   PARM      'CSC022'      PSARD                                       BUG2603
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG2603
      *                                                                                      BUG2603
      ** Initialize work fields                                                              BUG2603
      *                                                                                      BUG2603
     C                   EVAL      CSC022 = 'N'                                              BUG2603
     C                   EVAL      WSkpCom = 'N'                                             BUG2603
      *                                                                                      BUG2603
     C                   IF        PRTCD = *Blanks                                           BUG2603
     C                   EVAL      CSC022 = 'Y'                                              BUG2603
      *                                                                                      BUG2603
     C                   IN        SCCMTJOB                                                  BUG2603
      *                                                                                      BUG2603
     C                   IF        COMITNUM <> 0                                             BUG2603
     C                   MOVEA     Comitjobs     JobCmtctlDS                                 BUG2603
     C                   EVAL      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                     BUG2603
     C                   IF        WPos > 0                                                  BUG2603
     C                   EVAL      WSkpCom = 'Y'                                             BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ELSE                                                                BUG2603
      *                                                                                      BUG2603
      ** An NRF (No Record Found) return code is valid.                                      BUG2603
      ** Issue database error only for error return codes.                                   BUG2603
      *                                                                                      BUG2603
     C                   IF        PRTCD <> '*NRF'                                           BUG2603
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG2603
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2603
     C                   EVAL      DBASE = 019                                               BUG2603
     C                   EXSR      *PSSR                                                     BUG2603
     C                   ENDIF                                                               BUG2603
     C                   ENDIF                                                               BUG2603
                                                                                              247888
      ** Check if CLE025 is installed                                                         247888
                                                                                              247888
     C                   CALL      'AOSARDR0'                                                 247888
     C                   PARM      *BLANKS       @RTCD                                        247888
     C                   PARM      '*VERIFY'     @OPTN                                        247888
     C                   PARM      'CLE025'      @SARD                                        247888
     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
                                                                                              247888
     C     @RTCD         IFEQ      *BLANK                                                     247888
     C                   MOVEL     'Y'           CLE025            1                          247888
     C                   ELSE                                                                 247888
     C                   MOVEL     'N'           CLE025                                       247888
     C                   ENDIF                                                                247888
                                                                                              247888
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRCACFC022
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
