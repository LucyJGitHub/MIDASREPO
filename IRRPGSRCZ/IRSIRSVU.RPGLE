     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Single currency IRS validate and update')     *
      *****************************************************************
      *                                                               *
      *  Midas - API Wrapper Project                                  *
      *                                                               *
      *  IRSIRSVU - Single Currency IRS Validate and Update           *
      *                                                               *
      *  Function: This program validates Single Currency Interest    *
      *            Rate Swaps for input into the Midas database.      *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
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
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSW216             Date 14Mar16               *
      *  Prev Amend No. MD031775           Date 09Jan15               *
      *                 MD031224           Date 25Nov14               *
      *                 MD029165           Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL094             Date 25Nov14               *
      *                 MD029596           Date 03Sep14               *
      *                 CIR017             Date 10Apr14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD025726           Date 19Mar14               *
      *                 264029             Date 22Feb10               *
      *                 245692             Date 11Dec13               *
      *                 MD023734           Date 30Nov13               *
      *                 MD022508           Date 23Sep13               *
      *                 CSW213             Date 03Jun13               *
      *                 MD000091           Date 08May13               *
      *                 AR981707           Date 19Nov12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR664921           Date 04Nov10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23454           Date 19Mar09               *
      *                 BUG27882           Date 09Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248489             Date 14Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244254             Date 12Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240134             Date 09Sep06               *
      *                 BUG12565           Date 09Nov06               *
      *                 240240             Date 26Jun06               *
      *                 CIR014             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11543           Date 23Jun06               *
      *                 239204             Date 31May06               *
      *                 BUG11254           Date 18Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7587            Date 04Oct05               *
      *                 BUG8997            Date 26Oct05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7621            Date 17Jun05               *
      *                 BUG5871            Date 22May05               *
      *                 BUG6512            Date 18May05               *
      *                 BUG7166            Date 12May05               *
      *                 BUG7046            Date 06May05               *
      *                 BUG6671            Date 26Apr05               *
      *                 BUG6940            Date 29Apr05               *
      *                 BUG6876            Date 27Apr05               *
      *                 BUG6472            Date 22Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6577            Date 12Apr05               *
      *                 BUG6377            Date 11Apr05               *
      *                 BUG6470            Date 05Apr05               *
      *                 BUG6386            Date 23Mar05               *
      *                 BUG6075            Date 23Feb05               *
      *                 BUG5964            Date 17Feb05               *
      *                 BUG5610            Date 27Jan05               *
      *                 BUG5438            Date 12Jan05               *
      *                 BUG5357            Date 05Jan05               *
      *                 BUG4646            Date 25Oct04               *
      *                 BUG4482            Date 29Sep04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW216 - SWIFT Changes 2016                                  *
      *  MD031775 - Cannot insert transaction due to errors. Correct  *
      *             mapping to include CDL094 fields.                 *
      *  MD031224 - Schedule dates does not throw warning when falls  *
      *             on holiday. Amend date validation to prompt       *
      *             warning message when it falls on holiday.         *
      *  MD029165 - Manually defined values in field 72 of Settlement *
      *             Confirmation tab are being overwritten            *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD029596 - FRNT of DEALSDG not being populated. Remove part  *
      *             of GEMS248489.                                    *
      *  CIR017 - SIRS Business Day Conventions for both Legs         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD025726 - Retrieve ISDA details from FRA/IRS ICD for        *
      *             customers with no extended settlement details     *
      *             (SSI).                                            *
      *  264029 - Fix 233467 from IRVNPCD01 was moved here. Error msg *
      *           RS00076 will appear when xNPCD = blanks while       *
      *           principal change schedules <> blanks.               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  MD023734 - Clearing Threshold Indicator not defaulted.       *
      *  MD022508 - Error encountered when RPIF Execution             *
      *             Timestamp date is entered.                        *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  MD000091 - Event Codes Substitution                          *
      *  AR981707 - Cannot authorise an amendment to IRS deal when    *
      *             auto-authorised flag is 'Y'. Blank-out RSAUTH     *
      *             in SETUPAMEND subroutine. (Child: AR981710)       *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  AR664921 - Can't authorise repaired transaction              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23454 - Set up data area DLUFBO (introduced by CGL014)    *
      *             needed in ZASETINVAL (Applied by BUG27882)        *
      *  BUG27882 - Settlement Confirmation data cleared after Amend  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248489 - Front Office ID blanked out when deal is edited.    *
      *  244254 - Retrieve ISDA details from customer's default       *
      *           settlement details even if the pay/recv details     *
      *           are manually input on the screen.                   *
      *  240134 - Ensure to pass the principal amount.                *
      *  BUG12565 - Encountered Error in rejecting record in SIRS.    *
      *  240240 - CALLB FFDATE. Call results in 'cannot resolve' bug. *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11543 - Serious midas error upon authorise (Recompile)    *
      *  239204 - During manual assignment of deal number, no deal    *
      *           reference is written on DLDLDGQD.                   *
      *  BUG11254-Positions of the schedules on the buffer were not   *
      *           changed to cope with impact of CLE031 changes.      *
      *           Also CDL038 changes when rebuilding buffer is wrong *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7587 - MT360 Cancel Msg  - Amortisation schedule from     *
      *            original not shown.                                *
      *  BUG8997 - Do not default settlements if any of the FRA/IRS   *
      *            extended settlements have been entered             *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG7621 - Retrieve schedules even if related frequency is    *
      *            not 'Z' or 'C' in the case of cashflow schedules   *
      *  BUG5871 - Send deal status to MidasPlus                      *
      *  BUG6512 - Retrieve TRAM details                              *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  BUG7046 - Validate Principal Change schedule if present      *
      *  BUG6671- Implement Auto Authorisation                        *
      *  BUG6940-Correct defaulting of ISDA fields                    *
      *  BUG6876 - Need the current deal in screen format before      *
      *            the call to the VAL module                         *
      *  BUG6472- Added a sign field to short term rate               *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG6577-Validate schedules even if there are earlier errors  *
      *  BUG6377 - Need Fixing Dates (Ours and Theirs) ADDED to       *
      *            the confirmation screens                           *
      *  BUG6470 - Screen short term rate needs left adjusting for AMD*
      *  BUG6386 - Principal Change schedules not showing for migrated*
      *            deals                                              *
      *  BUG6075-Duplicated deal numbers assigned by the system       *
      *  BUG5964-Schedule 1st non processed date should be the same as*
      *          the date in the main details                         *
      *  BUG5610-Amount formatting                                    *
      *  BUG5438-Error messages relating to edit table need more      *
      *          detailed information                                 *
      *  BUG5357- Cash flow/principle change schedule formulae need   *
      *           additional fields                                   *
      *  BUG4646- Completion of SIRS api                              *
      *  BUG4482 - Authorise should call Validate to show all the     *
      *            warning errors.                                    *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDLDGUPFE  O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLDGREF:DLDGREFF)
     F                                     COMMIT
 
     FDLDGUPL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
     FDLDETUL0  UF A E           K DISK    INFSR(*PSSR)                         BUG4646
     F                                     COMMIT                               BUG4646
     FDLPCSCL0  UF   E           K DISK    RENAME(DLPCSCD0:DLPCSCX0)            BUG4646
     F                                     PREFIX(XX)                           BUG4646
     F                                     COMMIT                               BUG4646
                                                                                              244254
     FSDEXSTL1  IF   E           K DISK                                                       244254
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
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
 
      *  Array for job name                                                     BUG4646
     D ARRJBNAM        S             10A   DIM(10)                              BUG4646
      *  Array for Our rate change date Schedule                                BUG4646
     D ORDATEA         S              8A   DIM(600)                             BUG4646
     D ORMDATE         S              5  0 DIM(600)                             BUG4646
     D ORDATEAST       S           4800A                                        BUG4646
      *  Array for Our interest payment date Schedule                           BUG4646
     D OPDATEA         S              8A   DIM(600)                             BUG4646
     D OPMDATE         S              5  0 DIM(600)                             BUG4646
     D OPDATEAST       S           4800A                                        BUG4646
      *  Array for Their rate change date Schedule                              BUG4646
     D TRDATEA         S              8A   DIM(600)                             BUG4646
     D TRMDATE         S              5  0 DIM(600)                             BUG4646
     D TRDATEAST       S           4800A                                        BUG4646
      *  Array for Their interest payment date Schedule                         BUG4646
     D TPDATEA         S              8A   DIM(600)                             BUG4646
     D TPMDATE         S              5  0 DIM(600)                             BUG4646
     D TPDATEAST       S           4800A                                        BUG4646
      *  Date schedule                                                          BUG4646
     D DATESCH         DS                                                       BUG4646
     D  DSDATE                        6A                                        BUG4646
     D  DSCHOL                        1A                                        BUG4646
     D  DSPDAT                        1A                                        BUG4646
      *  Array for Our cash flow Schedule                                       BUG4646
     D OCFSA           S             22A   DIM(600)                             BUG4646
     D OCFMDAT         S              5  0 DIM(600)                             BUG4646
     D OCFAMT          S             13  0 DIM(600)                             BUG4646
     D OCFSAST         S          13200A                                        BUG4646
      *  Array for Their cash flow Schedule                                     BUG4646
     D TCFSA           S             22A   DIM(600)                             BUG4646
     D TCFMDAT         S              5  0 DIM(600)                             BUG4646
     D TCFAMT          S             13  0 DIM(600)                             BUG4646
     D TCFSAST         S          13200A                                        BUG4646
      *  Cash Flow schedule                                                     BUG4646
     D CASHFSCH        DS                                                       BUG4646
     D  CFDATE                        6A                                        BUG4646
     D  CFCHOL                        1A                                        BUG4646
     D  CFAMT                        14A                                        BUG4646
     D  CFPDAT                        1A                                        BUG4646
      *  Array for Principle change Schedule                                    BUG4646
     D PCSA            S             25A   DIM(600)                             BUG4646
     D TPCMDAT         S              5  0 DIM(600)                             BUG4646
     D TPCAMT          S             15  0 DIM(600)                             BUG4646
     D PCSAST          S          15000A                                        BUG4646
      *  Principle Change Schedule                                              BUG4646
     D PCHGSCH         DS                                                       BUG4646
     D  PCDATE                        6A                                        BUG4646
     D  PCCHOL                        1A                                        BUG4646
     D  PCAMT                        16A                                        BUG4646
     D  PCIDFLG                       1A                                        BUG4646
     D  PCPDAT                        1A                                        BUG4646
      *  Array for Business Day Convention currencies                           BUG4646
     D  PBDCCcyArr                    3A   DIM(10)                              BUG4646
     D WMDATE          S              5  0 DIM(600)                             BUG4646
     D WCFAMT          S             13  0 DIM(600)                             BUG5357
     D WPCAMT          S             15  0 DIM(600)                             BUG5357
      *  Date schedule formula for generating dates                             BUG4646
     D FORMULAOR       DS                                                       BUG4646
     D  SFREQFOR                      1A                                        BUG4646
     D  SFORMOR                       7A                                        BUG4646
     D FORMULAOP       DS                                                       BUG4646
     D  SFREQFOP                      1A                                        BUG4646
     D  SFORMOP                       7A                                        BUG4646
     D FORMULATR       DS                                                       BUG4646
     D  SFREQFTR                      1A                                        BUG4646
     D  SFORMTR                       7A                                        BUG4646
     D FORMULATP       DS                                                       BUG4646
     D  SFREQFTP                      1A                                        BUG4646
     D  SFORMTP                       7A                                        BUG4646
     D FORMULAOC       DS                                                       BUG4646
     D  SFREQFOC                      1A                                        BUG4646
     D  SFORMOC                       7A                                        BUG4646
     D  SFORMAMTOC                   14A                                        BUG5357
     D FORMULATC       DS                                                       BUG4646
     D  SFREQFTC                      1A                                        BUG4646
     D  SFORMTC                       7A                                        BUG4646
     D  SFORMAMTTC                   14A                                        BUG5357
     D FORMULAOPC      DS                                                       BUG4646
     D  SFREQFOPC                     1A                                        BUG4646
     D  SFORMOPC                      7A                                        BUG4646
     D  SFORMAMOPC                   16A                                        BUG5357
     D  SFORMIDOPC                    1A                                        BUG5357
     D FORMULATPC      DS                                                       BUG4646
     D  SFREQFTPC                     1A                                        BUG4646
     D  SFORMTPC                      7A                                        BUG4646
     D  SFORMAMTPC                   16A                                        BUG5357
     D  SFORMIDTPC                    1A                                        BUG5357
     D FORMULA         DS                                                       BUG4646
     D  SFORM                  1      7                                         BUG4646
     D  SWRK1                  1      1                                         BUG4646
     D  SWRK2                  2      2                                         BUG4646
     D  SDN1                   1      2                                         BUG4646
     D  SWRK3                  3      3                                         BUG4646
     D  SWRK4                  4      4                                         BUG4646
     D  SWRK5                  5      5                                         BUG4646
     D  SDN2                   4      5                                         BUG4646
     D  SWRK6                  6      6                                         BUG4646
     D  S456                   4      6                                         BUG4646
     D  SWRK7                  7      7                                         BUG4646
     D LETT            S              1    DIM(7) CTDATA PERRCD(7)              BUG4646
      ** Internally described data structure for ZDATE                          BUG4646
     D DateDS          DS             6                                         BUG4646
     D  DteMth                 1      2A                                        BUG4646
     D  DteDay                 3      4A                                        BUG4646
     D  DteYr                  5      6A                                        BUG4646
      ** Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming Transaction
     D TranIn        E DS                  EXTNAME(IRSIRSPD)
     D PBDCCcy               243    306                                         BUG4646
 
      ** Valid Deals layout
      ** Large fields to include
      ** - Receive instructions (xxRSTM to xxROCN)
      ** - Pay     instructions (xxPSTM to xxBTB6)
     D ValidDeal     E DS                  EXTNAME(IRVSIRSPD)
     D SIRSRecIns            716    784
     D SIRSPayIns            785   1343
     D SIRSFraIns           1345   1992
                                                                                BUG4646
     D ValidXDeal    E DS                  EXTNAME(IRVXSIRPD)                   BUG4646
      * Valid Deals layout                                                      BUG4646
 
      ** (Current) Deal in File Format
      ** Large fields to include
      ** - Receive instructions (RSTM to ROCN)
      ** - Pay     instructions (PSTM to BTB6)
     D DealFilFmt    E DS                  EXTNAME(DEALSDG)
     D DGRecIns              716    784
     D DGPayIns              785   1343
     D DGFraIns             1345   1992
                                                                                BUG4646
     D DealXFilFmt   E DS                  EXTNAME(DLDLDGQD)                    BUG4646
      ** Deal Extension File Format                                             BUG4646
 
      ** (Current) Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(IRSIRSPD)
     D                                     PREFIX(@)
      ************************                                                  BUG4646
      ***Our*Rate*Change*Dates (IRCs)                                           BUG4646
     D*OurRatChgD****E*DS*****             EXTNAME(IRDTSCPD)                    BUG4646
     D************************             PREFIX(OR)                           BUG4646
     D*ORDatesAlp************* 1    492                                         BUG4646
      ************************                                                  BUG4646
      ***Our*Interest*Payment*Dates (IRCs)                                      BUG4646
     D*OurIntPayD****E*DS*****             EXTNAME(IRDTSCPD)                    BUG4646
     D************************             PREFIX(OP)                           BUG4646
     D*OPDatesAlp************* 1    492                                         BUG4646
      ************************                                                  BUG4646
      ***Their*Rate*Change*Dates (IRCs)                                         BUG4646
     D*ThrRatChgD****E*DS*****             EXTNAME(IRDTSCPD)                    BUG4646
     D************************             PREFIX(TR)                           BUG4646
     D*TRDatesAlp************* 1    492                                         BUG4646
      ************************                                                  BUG4646
      ***Their*Interest*Payment Dates (IRCs)                                    BUG4646
     D*ThrIntPayD****E*DS*****             EXTNAME(IRDTSCPD)                    BUG4646
     D************************             PREFIX(TP)                           BUG4646
     D*TPDatesAlp************* 1    492                                         BUG4646
      ************************                                                  BUG4646
      ** Pay Settlement Instructions - Input
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
 
      ** Receive Settlement Instructions - Input
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
 
      ** FRA/IRS Settlement Instructions - Input
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
 
      ** Pay Settlement Instructions - Current
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
 
      ** Receive Settlement Instructions - Current
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
 
      ** FRA/IRS Settlement Instructions - Current
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
 
      ** Pay Settlement Instructions - File (D/B) format
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
 
      ** Receive Settlement Instructions - File (D/B) format
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
 
      ** FRA/IRS Settlement Instructions - File (D/B) format
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
 
      ** FRA/IRS Interface Non-Screen Data                                                   BUG6671
     D InfData       E DS                  EXTNAME(IRRSIFPD)                                 BUG6671
                                                                                             BUG6671
      ** IR SIRS Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(IRSSEXPD)
      ************************                                                  BUG4646
      ***Our*Rate*Change*Dates (IRCs) - Midas Day Number format                 BUG4646
     D*DBORatChgD****E*DS*****             EXTNAME(IRVDTSCPD)                   BUG4646
     D************************             PREFIX(OR)                           BUG4646
     D*ORFoTran******E********             EXTFLD(XFOTRANID)                    BUG4646
     D*ORDates****************23    268A                                        BUG4646
      ************************                                                  BUG4646
      ***Our*Interest*Payment*Dates (IRCs) - Midas Day Number format            BUG4646
     D*DBOIntPayD****E*DS*****             EXTNAME(IRVDTSCPD)                   BUG4646
     D************************             PREFIX(OP)                           BUG4646
     D*OPFoTran******E********             EXTFLD(XFOTRANID)                    BUG4646
     D*OPDates****************23    268A                                        BUG4646
      ************************                                                  BUG4646
      ***Their*Rate*Change*Dates (IRCs) - Midas Day Number format               BUG4646
     D*DBTRatChgD****E*DS*****             EXTNAME(IRVDTSCPD)                   BUG4646
     D************************             PREFIX(TR)                           BUG4646
     D*TRFoTran******E********             EXTFLD(XFOTRANID)                    BUG4646
     D*TRDates****************23    268A                                        BUG4646
      ************************                                                  BUG4646
      ***Their*Interest*Payment Dates (IRCs) - Midas Day Number format          BUG4646
     D*DBTIntPayD****E*DS*****             EXTNAME(IRVDTSCPD)                   BUG4646
     D************************             PREFIX(TP)                           BUG4646
     D*TPFoTran******E********             EXTFLD(XFOTRANID)                    BUG4646
     D*TPDates****************23    268A                                        BUG4646
      ** Midas Modules Details Accessed via access program                      BUG4646
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    BUG4646
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Deal details                                                         245692
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692
     D W#ACCD        E                     EXTFLD(QQACCD)                                     245692
                                                                                              245692
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External data structure for FRA/IRS I.C.D. details
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
 
      ** EXTERNAL DS FOR SAR DETAILS
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D XLCD          E                     EXTFLD(LCD)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Up-front and Buy-out Details                                                       BUG27882
     D DLUFBO        E DS                  EXTNAME(DLUFBOPD) DTAARA                         BUG27882
                                                                                            BUG27882
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
     D                                     PREFIX(A)
 
      ** Transaction Details retrieved from file - in screen format
     D CrFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
     D                                     PREFIX(B)
 
      ** Transaction Details OK indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** First DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                         BUG4646
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                     BUG4646
      ** Midas SC Jobs handling commitment control data area                    BUG4646
     D  COMITNOM               1      3S 0                                      BUG4646
     D  COMITJOB               4    103                                         BUG4646
      *                                                                         BUG4646
 
      **ISDA settlement fields                                                               BUG6940
     D WWAGVV          DS             4                                                      BUG6940
     D WDAGVC                  1      2                                                      BUG6940
     D WDAGVV                  3      4                                                      BUG6940
                                                                                             BUG6940
      ** Array message for RPIF                                                               CSW213
     D DFldNameArr     S             10A   DIM(ArrayMax)                                      CSW213
     D DMsgIDArr       S              7A   DIM(ArrayMax)                                      CSW213
     D DMsgDtaArr      S             45A   DIM(ArrayMax)                                      CSW213
     D DWFldNamArr     S             10A   DIM(ArrayMax)                                      CSW213
     D DWMsgIDArr      S              7A   DIM(ArrayMax)                                      CSW213
     D DWMsgDtaArr     S             45A   DIM(ArrayMax)                                      CSW213
                                                                                              CSW213
      ** Define data structure for InSwift2013                                                CSW213
     D InSwift2013     DS                                                                     CSW213
RGC  D  DLRPIFS1In                         LIKE(DLRPIFScn1Fmt)                                CSW213
RGC  D  DLRPIFS2In                         LIKE(DLRPIFScn2Fmt)                                CSW213
RGC  D  DLRPIFS3In                         LIKE(DLRPIFScn3Fmt)                                CSW213
     D  DLRPIFS4In                         LIKE(DLRPIFScn4Fmt)                                CSW214
RGC                                                                                           CSW213
      ** Define data structure for OutSwift2013                                               CSW213
     D OutSwift2013    DS                                                                     CSW213
     D  DLRPIFS1Out                        LIKE(DLRPIFScn1Fmt)                                CSW213
     D  DLRPIFS2Out                        LIKE(DLRPIFScn2Fmt)                                CSW213
     D  DLRPIFS3Out                        LIKE(DLRPIFScn3Fmt)                                CSW213
     D  DLRPIFS4Out                        LIKE(DLRPIFScn4Fmt)                                CSW214
RGC                                                                                           CSW213
      ** Midas DL Dealing Reporting Information file                                          CSW213
     D DLRPIFScn1Fmt E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D DLRPIFScn2Fmt E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D DLRPIFScn3Fmt E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D DLRPIFScn4Fmt E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D DLRPIFFileFmt E DS                  EXTNAME(DLRPIFPD)                                  CSW213
     D DLRILKPDIn    E DS                  EXTNAME(DLRILKPD)                                  CSW213
     D DLVRPIFileFmt E DS                  EXTNAME(DLVRPIPD)                                  CSW213
                                                                                              CSW213
      ** Transaction Reporting Screens - Output                                               CSW213
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
                                                                                              CSW214
      ** RPIF Error File - Screen 4                                                           CSW214
     D DLError4      E DS                  EXTNAME(DLERI4PD)                                  CSW214
     D/COPY QWINDSRC,IRSIRSGDTA                                                 BUG4646
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D UpdateYN        S              1A
     D Buffer          S           6000A
     D Buffer2         S           3999                                         BUG4646
     D BufferEx2       S           9999                                         BUG4646
     D BufferEx3       S           9999                                         BUG4646
     D BufferEx4       S           9999                                         BUG4646
     D BufferEx5       S           9999                                         BUG4646
     D BufferEx6       S           9999                                         BUG4646
     D BufferEx7       S           9999                                         BUG4646
     D BufferEx8       S           9999                                         BUG4646
     D BufferEx9       S           9999                                         BUG4646
     D APIRetc         S              1A
 
      ** Error message field(s)
     D Msg1            S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Field (500A) to receive the incoming transaction
     D Trans500        S            500A
     D Trans1000       S           1000A
 
      ** Field (500A) to receive the incoming Extra Data                                     BUG6671
     D ExtData500      S            500A                                                     BUG6671
                                                                                             BUG6671
      ** Field (500A) to receive the incoming Interface Non-Screen Data                      BUG6671
     D InfData500      S            500A                                                     BUG6671
                                                                                             BUG6671
      ** Fields (500A) to receive the incoming Interest Rate Calendar info
     D*TransB500*******S*           500A                                        BUG4646
     D*TransC500*******S*           500A                                        BUG4646
     D*TransD500*******S*           500A                                        BUG4646
     D*TransE500*******S*           500A                                        BUG4646
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
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
     D  SUCucyOK                      1A   INZ('Y')
     D  SUPamtOK                      1A   INZ('Y')
     D  SUFfiOK                       1A   INZ('Y')
     D  SUBcxrOK                      1A   INZ('Y')
     D  SBokCOK                       1A   INZ('Y')
     D  STaxiOK                       1A   INZ('Y')
     D  SPrfCOK                       1A   INZ('Y')
     D  SOrBrOK                       1A   INZ('Y')
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
     D  SCAInOK                       1A   INZ('Y')
     D  OKOYLC                        1A   INZ('Y')
     D  STYLCOK                       1A   INZ('Y')                                           CDL038
     D  SOFYCOK                       1A   INZ('Y')                                           CDL038
     D  STFYCOK                       1A   INZ('Y')                                           CDL038
     D  SFCCUOK                       1A   INZ('Y')                                           CDL038
     D  SFACTOK                       1A   INZ('Y')                                           CDL038
     D  SFCNOOK                       1A   INZ('Y')                                           CDL038
     D  OKC1P1                        1A   INZ('Y')
     D  OKC2P1                        1A   INZ('Y')
     D  OKC3P1                        1A   INZ('Y')
     D  OKC4P1                        1A   INZ('Y')
     D  OKC5P1                        1A   INZ('Y')
     D  OKC6P1                        1A   INZ('Y')
     D  OKC7P1                        1A   INZ('Y')
     D  OKC8P1                        1A   INZ('Y')
     D  OKC9P1                        1A   INZ('Y')
     D  OKC0P1                        1A   INZ('Y')
     D  OKPDC1                        1A   INZ('Y')
     D  OKAMC1                        1A   INZ('Y')
     D  OKC1R1                        1A   INZ('Y')
     D  OKC2R1                        1A   INZ('Y')
     D  OKC3R1                        1A   INZ('Y')
     D  OKC4R1                        1A   INZ('Y')
     D  OKC5R1                        1A   INZ('Y')
     D  OKC6R1                        1A   INZ('Y')
     D  OKC7R1                        1A   INZ('Y')
     D  OKC8R1                        1A   INZ('Y')
     D  OKC9R1                        1A   INZ('Y')
     D  OKC0R1                        1A   INZ('Y')
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
     D**SRSetMOK**********************1A   INZ('Y')                                           CDL038
     D**SPSetMOK**********************1A   INZ('Y')                                           CDL038
     D**SURAccOK**********************1A   INZ('Y')                                           CDL038
     D**SROBrOK***********************1A   INZ('Y')                                           CDL038
     D**S@RAccOK**********************1A   INZ('Y')                                           CDL038
     D**SUPAccOK**********************1A   INZ('Y')                                           CDL038
     D**SPOBrOK***********************1A   INZ('Y')                                           CDL038
     D**S@PAccOK**********************1A   INZ('Y')                                           CDL038
     D**SCpPBkOK**********************1A   INZ('Y')                                           CDL038
     D**SCpRBkOK**********************1A   INZ('Y')                                           CDL038
     D**SFAcOOK***********************1A   INZ('Y')                                           CDL038
     D**SSPiOK************************1A   INZ('Y')                                           CDL038
      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A   INZ('Y')
 
      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
     D OKPayInsDS      DS
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
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')
 
      ** Flags to indicate whether Receive Settlement instruction fields
      **  are valid
     D OKRecInsDS      DS
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')
 
      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKSIRSInDS      DS
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
 
      ** Error flags from Dates validation routine
     D ErrDealDat      S              1A   INZ('N')
     D ErrValDate      S              1A   INZ('N')
     D ErrMatDate      S              1A   INZ('N')
     D ErrNxInDat      S              1A   INZ('N')
 
      ** Flags to indicate outcome of calls to lower level modules
     D AmendOK         S              1A   INZ('Y')
      *************                                                             BUG4646
      ***Flag*to*indicate whether Interest Rate Calendars data valid            BUG4646
     D*OKInRatCal**    S              1A   INZ('Y')                             BUG4646
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Numeric version of spread/rate
     D @SPRD           S             11P 7
 
      ** A code to indicate the calling function to the lower level modules
     D SIRS            S              4A   INZ('SIRS')
 
      ** Payment & Receipt dates, passed to Settlements Validation routine.
      ** spaces in parameter list not used by this function
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)
 
      ** Blank fields, passed to Settlements Defaulting routine, to fill
      ** spaces in parameter list not used by this function
     D Blank3          S              3A   INZ(*BLANKS)
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** for Transaction Currencies (Receipt and Payment Currency)                           CSF011A
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      ** Receive / Pay Settlement Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D**************RecNostro       S             12A                           BUG4646
     D RecNostro       S             18A                                        BUG4646
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D************** PayNostro       S             12A                          BUG4646
     D PayNostro       S             18A                                        BUG4646
 
     D Object          S             10A   INZ('IRSIRSUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
      **************                                                            BUG4646
      ***Date*array*parameter passed to IRVIRCVAL                               BUG4646
     D*DatesToVal***   S            492A                                        BUG4646
      ***IRC*valid*dates returned from IRVIRCVAL                                BUG4646
     D*ValidDates***   S            246A   INZ(*BLANKS)                         BUG4646
 
      ** Validate Business Day Convention flag
     D  WValBDC        S              1A
 
     D PWUCDP          S              1P 0
     D PWTCDP          S              1P 0
     D PWPSCY          S              3A
     D PWRSCY          S              3A
     D PWPNLOC         S              3A
     D PWRNLOC         S              3A
     D I#SDLNO         S                   LIKE(SDLNO) INZ(*BLANKS)
 
      ** Fields defined for CSC011
 
     D CSC011          S              1A
     D TRANSDTL        S           5800A
     D******* PDealNum        S             18A                                 BUG4646
     D******* PADealNo        S             18A                                 BUG4646
     D PDealNum        S             24A                                        BUG4646
     D PADealNo        S             24A                                        BUG4646
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
 
      ** Switchable Feature Parameters
     D CIR008          S              1A
     D CAP056          S              1A
     D CAP051          S              1A                                                     BUG6671
     D CGL014          S              1A                                                    BUG27882
                                                                                BUG4646
     D CSC022          S              1A   INZ('N')                             BUG4646
      ** Counter variable                                                       BUG4646
     D WCMT01          S              1A                                        BUG4646
      ** Commitment Flag                                                        BUG4646
                                                                                BUG4646
      ** Date converted to Midas Dayno format                                   BUG4646
     D   InDateMDN     S              5P 0                                      BUG4646
                                                                                BUG4646
      ** Date to be validated                                                   BUG4646
     D   InDate        S              6                                         BUG4646
                                                                                BUG4646
      ** Confirm holiday to be validated                                        BUG4646
     D   CHol          S              1                                         BUG4646
                                                                                BUG4646
      ** Processed date flag                                                    BUG4646
     D   ProcDate      S              1                                         BUG4646
                                                                                BUG4646
      ** Array index                                                            BUG4646
     D X               S              3  0                                      BUG4646
     D I               S              3  0                                      BUG4646
     D K               S              3  0                                      BUG4646
     D L               S              3  0                                      BUG4646
     D A               S              3  0                                      BUG5964
     D B               S              3  0                                      BUG5964
      ** Date schedule type                                                     BUG4646
     D PValType        S              1A                                        BUG4646
     D WDealNo         S              6  0                                      BUG4646
     D POurTheir       S              1A                                        BUG4646
     D WCTLDYN         S              5P 0                                      BUG4646
     D WDTSCFound      S              1A                                        BUG4646
     D WCFSCFound      S              1A                                        BUG4646
     D WPCSCFound      S              1A                                        BUG4646
     D WRatePay        S              1A                                        BUG4646
     D WAmount         S             16A                                        BUG4646
     D WONBDP          S                   LIKE(A6NBDP)                         BUG4646
     D WPNBDP          S                   LIKE(A6NBDP)                         BUG4646
     D WRNBDP          S                   LIKE(A6NBDP)                         BUG4646
     D WRSCY           S              3A                                        BUG4646
     D WPSCY           S              3A                                        BUG4646
     D WHoliday        S              1A                                        BUG4646
     D WRK153          S             15  3                                      BUG4646
     D WRK30           S              3  0                                      BUG4646
     D WPAMT           S             15  0                                      BUG4646
     D SFREQF          S              1A                                        BUG4646
     D ZDATE           S              6P 0                                      BUG4646
     D ZDAYNO          S              5P 0                                      BUG4646
     D PDAT            S              1A                                        BUG4646
     D SUINFD          S              6A                                                     BUG6377
     D STINFD          S              6A                                                     BUG6377
     D OurRate         C                   CONST('Our Interest Rate Change +    BUG5438
     D                                                 Schedule')               BUG5438
     D OurPay          C                   CONST('Our Interest Payment +        BUG5438
     D                                                 Schedule')               BUG5438
     D TheirRate       C                   CONST('Their Interest Rate Change +  BUG5438
     D                                                 Schedule')               BUG5438
     D TheirPay        C                   CONST('Their Interest Payment +      BUG5438
     D                                                 Schedule')               BUG5438
     D OurCash         C                   CONST('Our Cash Flow Schedule')      BUG5438
     D TheirCash       C                   CONST('Their Cash Flow Schedule')    BUG5438
     D PrinChg         C                   CONST('Principle Change Schedule')   BUG5438
                                                                                             BUG6470
     D #SUEINR         S             12A                                                     BUG6470
     D #STEINR         S             12A                                                     BUG6470
 
      ** Fields needed to note whether unprocessed schedules exist                           BUG7621
     D UPPSCH          DS                                                                    BUG7621
     D UPOPSCH                        1A                                                     BUG7621
     D UPTPSCH                        1A                                                     BUG7621
     D UPOCSCH                        1A                                                     BUG7621
     D UPTCSCH                        1A                                                     BUG7621
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
                                                                                              245692
      ** Parameter list for ZA0840                                                            245692
      ** =========================                                                            245692
      ** Return code for numeric validation module call                                       245692
     D @Rtcde          S             10A                                                      245692
      ** Alpha field for numeric validation                                                   245692
     D @@ALPH          S             16A                                                      245692
      ** Number of decimal places field for numeric validation                                245692
     D @@IDP           S              2  0                                                    245692
      ** Number of integers field for numeric validation                                      245692
     D @@IINT          S              2  0                                                    245692
      ** Millions/Thousands id (Y=function on)                                                245692
     D @@MTID          S              1A                                                      245692
      ** Amount calculation field                                                             245692
     D @@AMT           S             15  0                                                    245692
      ** Error return code for ZA0840 module                                                  245692
     D @@ERCD          S              1  0                                                    245692
      ** Work Variables for RPIF                                                              CSW213
     D ValScrnNo       S              1  0                                                    CSW213
     D CSW213          S              1                                                       CSW213
     D CtrX            S              3S 0                                                    CSW213
     D RIdx            S              3P 0                                                    CSW213
     D WRIdx           S              3P 0                                                    CSW213
     D DUpdateYN       S              1A                                                      CSW213
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.
 
     C**********         MOVEL     Trans500      TranIn                                       CIR017
     C                   MOVEL     Trans1000     TranIn                                       CIR017
     C                   MOVEL     InfData500    InfData                                     BUG6671
     C                   MOVEL     Extdata500    Extdata                                     BUG6671
     C                   EVAL      DLRPIFScn1Fmt = DLRPIFS1In                                 CSW213
     C                   EVAL      DLRPIFScn2Fmt = DLRPIFS2In                                 CSW213
     C                   EVAL      DLRPIFScn3Fmt = DLRPIFS3In                                 CSW213
     C                   EVAL      DLRPIFScn4Fmt = DLRPIFS4In                                 CSW214
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:1699)                     BUG4646 BUG6377
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:1707)                     BUG4646 BUG6377
     C**********         EVAL      FORMULATR=%SUBST(Buffer:1715)                     BUG4646 BUG6377
     C**********         EVAL      FORMULATP=%SUBST(Buffer:1723)                     BUG4646 BUG6377
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:1731)                     BUG4646 BUG6377
     C*******************EVAL      FORMULATC=%SUBST(Buffer:1739)                BUG4646BUG5357
     C*******************EVAL      FORMULAOPC=%SUBST(Buffer:1747)               BUG4646BUG5357
     C*******************EVAL      FORMULATPC=%SUBST(Buffer:1755)               BUG4646BUG5357
     C*******************EVAL      ORDATEAST=%SUBST(Buffer:1763)+Buffer2        BUG4646BUG5357
     C*******************EVAL      OPDATEAST=%SUBST(Buffer2:563)+BufferEx2      BUG4646BUG5357
     C*******************EVAL      TRDATEAST=%SUBST(BufferEx2:1364)             BUG4646BUG5357
     C*******************EVAL      TPDATEAST=%SUBST(BufferEx2:6164)+BufferEx3   BUG4646BUG5357
     C*******************EVAL      OCFSAST=%SUBST(BufferEx3:965)+BufferEx4      BUG4646BUG5357
     C*******************EVAL      TCFSAST=%SUBST(BufferEx4:4166)+BufferEx5     BUG4646BUG5357
     C*******************EVAL      PCSAST=%SUBST(BufferEx5:7367)+BufferEx6+     BUG4646BUG5357
     C*******************                              BufferEx7                BUG4646BUG5357
     C**********         EVAL      FORMULATC=%SUBST(Buffer:1753)                BUG5357      BUG6377
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1775)               BUG5357      BUG6377
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:1800)               BUG5357      BUG6377
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:1825)+Buffer2        BUG5357      BUG6377
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:625)+BufferEx2      BUG5357      BUG6377
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:1426)             BUG5357      BUG6377
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:6226)+BufferEx3   BUG5357      BUG6377
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:1027)+BufferEx4     BUG5357      BUG6377
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:4228)+BufferEx5     BUG5357      BUG6377
     C**********         EVAL      PCSAST=%SUBST(BufferEx5:7429)+BufferEx6+     BUG5357      BUG6377
     C**********                                       BufferEx7                BUG5357      BUG6377
     C**********         EVAL      SUINFD=%SUBST(Buffer:1699)                         BUG6377 CDL028
     C**********         EVAL      STINFD=%SUBST(Buffer:1705)                         BUG6377 CDL028
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:1711)                      BUG6377 CDL028
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:1719)                      BUG6377 CDL028
     C**********         EVAL      FORMULATR=%SUBST(Buffer:1727)                      BUG6377 CDL028
     C**********         EVAL      FORMULATP=%SUBST(Buffer:1735)                      BUG6377 CDL028
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:1743)                      BUG6377 CDL028
     C**********         EVAL      FORMULATC=%SUBST(Buffer:1765)                      BUG6377 CDL028
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1787)                     BUG6377 CDL028
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:1812)                     BUG6377 CDL028
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:1837)+Buffer2              BUG6377 CDL028
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:637)+BufferEx2            BUG6377 CDL028
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:1438)                   BUG6377 CDL028
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:6238)+BufferEx3         BUG6377 CDL028
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:1039)+BufferEx4           BUG6377 CDL028
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:4240)+BufferEx5           BUG6377 CDL028
     C**********         EVAL      PCSAST=%SUBST(BufferEx5:7441)+BufferEx6+           BUG6377 CDL028
     C**********                                       BufferEx7                      BUG6377 CDL028
     C**********         EVAL      SUINFD=%SUBST(Buffer:1787)                         CDL028 BUG6472
     C**********         EVAL      STINFD=%SUBST(Buffer:1793)                         CDL028 BUG6472
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:1799)                      CDL028 BUG6472
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:1807)                      CDL028 BUG6472
     C**********         EVAL      FORMULATR=%SUBST(Buffer:1815)                      CDL028 BUG6472
     C**********         EVAL      FORMULATP=%SUBST(Buffer:1823)                      CDL028 BUG6472
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:1831)                      CDL028 BUG6472
     C**********         EVAL      FORMULATC=%SUBST(Buffer:1853)                      CDL028 BUG6472
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1875)                     CDL028 BUG6472
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:1900)                     CDL028 BUG6472
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:1925)+Buffer2              CDL028 BUG6472
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:725)+BufferEx2            CDL028 BUG6472
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:1526)                   CDL028 BUG6472
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:6326)+BufferEx3         CDL028 BUG6472
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:1127)+BufferEx4           CDL028 BUG6472
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:4328)+BufferEx5           CDL028 BUG6472
     C**********         EVAL      PCSAST=%SUBST(BufferEx5:7529)+BufferEx6+           CDL028 BUG6472
     C**********                                       BufferEx7                      CDL028 BUG6472
     C**********         EVAL      SUINFD=%SUBST(Buffer:1789)                        BUG6472 BUG6671
     C**********         EVAL      STINFD=%SUBST(Buffer:1795)                        BUG6472 BUG6671
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:1801)                     BUG6472 BUG6671
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:1809)                     BUG6472 BUG6671
     C**********         EVAL      FORMULATR=%SUBST(Buffer:1817)                     BUG6472 BUG6671
     C**********         EVAL      FORMULATP=%SUBST(Buffer:1825)                     BUG6472 BUG6671
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:1833)                     BUG6472 BUG6671
     C**********         EVAL      FORMULATC=%SUBST(Buffer:1855)                     BUG6472 BUG6671
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1877)                    BUG6472 BUG6671
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:1902)                    BUG6472 BUG6671
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:1927)+Buffer2             BUG6472 BUG6671
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:727)+BufferEx2           BUG6472 BUG6671
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:1528)                  BUG6472 BUG6671
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:6328)+BufferEx3        BUG6472 BUG6671
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:1129)+BufferEx4          BUG6472 BUG6671
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:4330)+BufferEx5          BUG6472 BUG6671
     C**********         EVAL      PCSAST=%SUBST(BufferEx5:7531)+BufferEx6+          BUG6472 BUG6671
     C**********                                       BufferEx7                     BUG6472 BUG6671
     C*******************EVAL      SUINFD=%SUBST(Buffer:1840)                         BUG6671 CDL038
     C*******************EVAL      STINFD=%SUBST(Buffer:1846)                         BUG6671 CDL038
     C*******************EVAL      CPST=%SUBST(Buffer:1852)                           BUG6512 CDL038
     C**********         EVAL      DSPCP=%SUBST(Buffer:1855)                        BUG6512  BUG5871
     C**********         EVAL      BKST=%SUBST(Buffer:1856)                         BUG6512  BUG5871
     C**********         EVAL      DSPBK=%SUBST(Buffer:1859)                        BUG6512  BUG5871
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:1852)                    BUG6671  BUG6512
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:1860)                    BUG6671  BUG6512
     C**********         EVAL      FORMULATR=%SUBST(Buffer:1868)                    BUG6671  BUG6512
     C**********         EVAL      FORMULATP=%SUBST(Buffer:1876)                    BUG6671  BUG6512
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:1884)                    BUG6671  BUG6512
     C**********         EVAL      FORMULATC=%SUBST(Buffer:1906)                    BUG6671  BUG6512
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1928)                   BUG6671  BUG6512
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:1953)                   BUG6671  BUG6512
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:1978)+Buffer2            BUG6671  BUG6512
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:778)+BufferEx2          BUG6671  BUG6512
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:1579)                 BUG6671  BUG6512
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:6379)+BufferEx3       BUG6671  BUG6512
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:1180)+BufferEx4         BUG6671  BUG6512
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:4381)+BufferEx5         BUG6671  BUG6512
     C**********         EVAL      PCSAST=%SUBST(BufferEx5:7582)+BufferEx6+         BUG6671  BUG6512
     C**********                                       BufferEx7                    BUG6671  BUG6512
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:1858)                     BUG6512 BUG5871
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:1866)                     BUG6512 BUG5871
     C**********         EVAL      FORMULATR=%SUBST(Buffer:1874)                     BUG6512 BUG5871
     C**********         EVAL      FORMULATP=%SUBST(Buffer:1882)                     BUG6512 BUG5871
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:1890)                     BUG6512 BUG5871
     C**********         EVAL      FORMULATC=%SUBST(Buffer:1912)                     BUG6512 BUG5871
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1934)                    BUG6512 BUG5871
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:1959)                    BUG6512 BUG5871
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:1984)+Buffer2             BUG6512 BUG5871
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:784)+BufferEx2           BUG6512 BUG5871
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:1585)                  BUG6512 BUG5871
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:6385)+BufferEx3        BUG6512 BUG5871
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:1186)+BufferEx4          BUG6512 BUG5871
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:4387)+BufferEx5          BUG6512 BUG5871
     C**********         EVAL      PCSAST=%SUBST(BufferEx5:7588)+BufferEx6+          BUG6512 BUG5871
     C**********                                       BufferEx7                     BUG6512 BUG5871
     C*******************EVAL      DSPCP=%SUBST(Buffer:1854)                          BUG5871 CDL038
     C*******************EVAL      BKST=%SUBST(Buffer:1855)                           BUG5871 CDL038
     C*******************EVAL      DSPBK=%SUBST(Buffer:1857)                          BUG5871 CDL038
     C*******************EVAL      DDSTS=%SUBST(Buffer:1858)                          BUG5871 CDL038
     C*******************EVAL      FORMULAOR=%SUBST(Buffer:1882)                      BUG5871 CDL038
     C*******************EVAL      FORMULAOP=%SUBST(Buffer:1890)                      BUG5871 CDL038
     C*******************EVAL      FORMULATR=%SUBST(Buffer:1898)                      BUG5871 CDL038
     C*******************EVAL      FORMULATP=%SUBST(Buffer:1906)                      BUG5871 CDL038
     C*******************EVAL      FORMULAOC=%SUBST(Buffer:1914)                      BUG5871 CDL038
     C*******************EVAL      FORMULATC=%SUBST(Buffer:1936)                      BUG5871 CDL038
     C*******************EVAL      FORMULAOPC=%SUBST(Buffer:1958)                     BUG5871 CDL038
     C*******************EVAL      FORMULATPC=%SUBST(Buffer:1983)                     BUG5871 CDL038
     C*******************EVAL      ORDATEAST=%SUBST(Buffer:2008)+Buffer2              BUG5871 CDL038
     C*******************EVAL      OPDATEAST=%SUBST(Buffer2:808)+BufferEx2            BUG5871 CDL038
     C*******************EVAL      TRDATEAST=%SUBST(BufferEx2:1609)                   BUG5871 CDL038
     C*******************EVAL      TPDATEAST=%SUBST(BufferEx2:6409)+BufferEx3         BUG5871 CDL038
     C*******************EVAL      OCFSAST=%SUBST(BufferEx3:1210)+BufferEx4           BUG5871 CDL038
     C*******************EVAL      TCFSAST=%SUBST(BufferEx4:4411)+BufferEx5           BUG5871 CDL038
     C*******************EVAL      PCSAST=%SUBST(BufferEx5:7612)+BufferEx6+           BUG5871 CDL038
     C*******************                              BufferEx7                      BUG5871 CDL038
      **********                                                                     CDL038 BUG11254
     C**********         EVAL      SUINFD=%SUBST(Buffer:1844)                        CDL038 BUG11254
     C**********         EVAL      STINFD=%SUBST(Buffer:1850)                        CDL038 BUG11254
     C**********         EVAL      CPST=%SUBST(Buffer:1856)                          CDL038 BUG11254
     C**********         EVAL      DSPCP=%SUBST(Buffer:1858)                         CDL038 BUG11254
     C**********         EVAL      BKST=%SUBST(Buffer:1859)                          CDL038 BUG11254
     C**********         EVAL      DSPBK=%SUBST(Buffer:1861)                         CDL038 BUG11254
     C**********         EVAL      DDSTS=%SUBST(Buffer:1862)                         CDL038 BUG11254
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:1886)                     CDL038 BUG11254
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:1894)                     CDL038 BUG11254
     C**********         EVAL      FORMULATR=%SUBST(Buffer:1902)                     CDL038 BUG11254
     C**********         EVAL      FORMULATP=%SUBST(Buffer:1910)                     CDL038 BUG11254
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:1918)                     CDL038 BUG11254
     C**********         EVAL      FORMULATC=%SUBST(Buffer:1940)                     CDL038 BUG11254
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1962)                    CDL038 BUG11254
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:1987)                    CDL038 BUG11254
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:2012)+Buffer2             CDL038 BUG11254
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:812)+BufferEx2           CDL038 BUG11254
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:1613)                  CDL038 BUG11254
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:6413)+BufferEx3        CDL038 BUG11254
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:1214)+BufferEx4          CDL038 BUG11254
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:4415)+BufferEx5          CDL038 BUG11254
     C**********         EVAL      PCSAST=%SUBST(BufferEx5:7616)+BufferEx6+          CDL038 BUG11254
     C**********                                       BufferEx7                     CDL038 BUG11254
                                                                                            BUG11254
     C**********         EVAL      SUINFD=%SUBST(Buffer:1874)                       BUG11254 CSF011A
     C**********         EVAL      STINFD=%SUBST(Buffer:1880)                       BUG11254 CSF011A
     C**********         EVAL      CPST=%SUBST(Buffer:1886)                         BUG11254 CSF011A
     C**********         EVAL      DSPCP=%SUBST(Buffer:1888)                        BUG11254 CSF011A
     C**********         EVAL      BKST=%SUBST(Buffer:1889)                         BUG11254 CSF011A
     C**********         EVAL      DSPBK=%SUBST(Buffer:1891)                        BUG11254 CSF011A
     C**********         EVAL      DDSTS=%SUBST(Buffer:1892)                        BUG11254 CSF011A
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:1916)                    BUG11254 CSF011A
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:1924)                    BUG11254 CSF011A
     C**********         EVAL      FORMULATR=%SUBST(Buffer:1932)                    BUG11254 CSF011A
     C**********         EVAL      FORMULATP=%SUBST(Buffer:1940)                    BUG11254 CSF011A
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:1948)                    BUG11254 CSF011A
     C**********         EVAL      FORMULATC=%SUBST(Buffer:1970)                    BUG11254 CSF011A
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1992)                   BUG11254 CSF011A
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:2017)                   BUG11254 CSF011A
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:2042)+Buffer2            BUG11254 CSF011A
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:842)+BufferEx2          BUG11254 CSF011A
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:1643)                 BUG11254 CSF011A
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:6443)+BufferEx3       BUG11254 CSF011A
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:1244)+BufferEx4         BUG11254 CSF011A
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:4445)+BufferEx5         BUG11254 CSF011A
     C**********         EVAL      PCSAST=%SUBST(BufferEx5:7646)+BufferEx6+         BUG11254 CSF011A
     C**********                                       BufferEx7                    BUG11254 CSF011A
                                                                                            BUG11254
     C**********         EVAL      SUINFD=%SUBST(Buffer:2538)                         CSF011A CIR017
     C**********         EVAL      STINFD=%SUBST(Buffer:2544)                         CSF011A CIR017
     C**********         EVAL      CPST=%SUBST(Buffer:2550)                           CSF011A CIR017
     C**********         EVAL      DSPCP=%SUBST(Buffer:2552)                          CSF011A CIR017
     C**********         EVAL      BKST=%SUBST(Buffer:2553)                           CSF011A CIR017
     C**********         EVAL      DSPBK=%SUBST(Buffer:2555)                          CSF011A CIR017
     C**********         EVAL      DDSTS=%SUBST(Buffer:2556)                          CSF011A CIR017
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:2580)                      CSF011A CIR017
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:2588)                      CSF011A CIR017
     C**********         EVAL      FORMULATR=%SUBST(Buffer:2596)                      CSF011A CIR017
     C**********         EVAL      FORMULATP=%SUBST(Buffer:2604)                      CSF011A CIR017
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:2612)                      CSF011A CIR017
     C**********         EVAL      FORMULATC=%SUBST(Buffer:2634)                      CSF011A CIR017
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:2656)                     CSF011A CIR017
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:2681)                     CSF011A CIR017
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:2706)+Buffer2              CSF011A CSW213
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:1506)+BufferEx2           CSF011A CSW213
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:2307)                   CSF011A CSW213
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:7107)+BufferEx3         CSF011A CSW213
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:1908)+BufferEx4           CSF011A CSW213
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:5109)+BufferEx5           CSF011A CSW213
     C**********         EVAL      PCSAST=%SUBST(BufferEx5:8310)+BufferEx6+           CSF011A CSW213
     C**********                                       BufferEx7                      CSF011A CSW213
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:4638)+Buffer2               CSW213 CIR017
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:3438)+BufferEx2            CSW213 CIR017
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:4239)                    CSW213 CIR017
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:9039)+BufferEx3          CSW213 CIR017
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:3840)+BufferEx4            CSW213 CIR017
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:7041)+BufferEx5+           CSW213 CIR017
     C**********                                       BufferEx6                       CSW213 CIR017
     C**********         EVAL      PCSAST=%SUBST(BufferEx6:243)+BufferEx7              CSW213 CIR017
     C**********                                                                       CSW213 CIR017
     C**********         EVAL      SUINFD=%SUBST(Buffer:2602)                        CIR017 MD031775
     C**********         EVAL      STINFD=%SUBST(Buffer:2608)                        CIR017 MD031775
     C**********         EVAL      CPST=%SUBST(Buffer:2614)                          CIR017 MD031775
     C**********         EVAL      DSPCP=%SUBST(Buffer:2616)                         CIR017 MD031775
     C**********         EVAL      BKST=%SUBST(Buffer:2617)                          CIR017 MD031775
     C**********         EVAL      DSPBK=%SUBST(Buffer:2619)                         CIR017 MD031775
     C**********         EVAL      DDSTS=%SUBST(Buffer:2620)                         CIR017 MD031775
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:2644)                     CIR017 MD031775
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:2652)                     CIR017 MD031775
     C**********         EVAL      FORMULATR=%SUBST(Buffer:2660)                     CIR017 MD031775
     C**********         EVAL      FORMULATP=%SUBST(Buffer:2668)                     CIR017 MD031775
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:2676)                     CIR017 MD031775
     C**********         EVAL      FORMULATC=%SUBST(Buffer:2698)                     CIR017 MD031775
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:2720)                    CIR017 MD031775
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:2745)                    CIR017 MD031775
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:4702)+Buffer2               CIR017 CSW214
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:3502)+BufferEx2            CIR017 CSW214
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:4303)                    CIR017 CSW214
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:9103)+BufferEx3          CIR017 CSW214
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:3904)+BufferEx4            CIR017 CSW214
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:7105)+BufferEx5            CIR017 CSW214
     C**********         EVAL      PCSAST=%SUBST(BufferEx5:307)+BufferEx6+             CIR017 CSW214
     C**********                                       BufferEx7                       CIR017 CSW214
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:4864)+Buffer2             CSW214 MD031775
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:3664)+BufferEx2          CSW214 MD031775
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:4465)                  CSW214 MD031775
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:9265)+BufferEx3        CSW214 MD031775
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:4066)+BufferEx4          CSW214 MD031775
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:7267)+BufferEx5+         CSW214 MD031775
     C**********                                       BufferEx6                     CSW214 MD031775
     C**********         EVAL      PCSAST=%SUBST(BufferEx6:469)+BufferEx7            CSW214 MD031775
                                                                                             CSF011A
     C                   EVAL      SUINFD=%SUBST(Buffer:2812)                               MD031775
     C                   EVAL      STINFD=%SUBST(Buffer:2818)                               MD031775
     C                   EVAL      CPST=%SUBST(Buffer:2824)                                 MD031775
     C                   EVAL      DSPCP=%SUBST(Buffer:2826)                                MD031775
     C                   EVAL      BKST=%SUBST(Buffer:2827)                                 MD031775
     C                   EVAL      DSPBK=%SUBST(Buffer:2829)                                MD031775
     C                   EVAL      DDSTS=%SUBST(Buffer:2830)                                MD031775
     C                   EVAL      FORMULAOR=%SUBST(Buffer:2854)                            MD031775
     C                   EVAL      FORMULAOP=%SUBST(Buffer:2862)                            MD031775
     C                   EVAL      FORMULATR=%SUBST(Buffer:2870)                            MD031775
     C                   EVAL      FORMULATP=%SUBST(Buffer:2878)                            MD031775
     C                   EVAL      FORMULAOC=%SUBST(Buffer:2886)                            MD031775
     C                   EVAL      FORMULATC=%SUBST(Buffer:2908)                            MD031775
     C                   EVAL      FORMULAOPC=%SUBST(Buffer:2930)                           MD031775
     C                   EVAL      FORMULATPC=%SUBST(Buffer:2955)                           MD031775
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:5074)+Buffer2             MD031775 CSW216
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:3874)+BufferEx2          MD031775 CSW216
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:4675)                  MD031775 CSW216
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:9475)+BufferEx3        MD031775 CSW216
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:4276)+BufferEx4          MD031775 CSW216
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:7477)+BufferEx5+         MD031775 CSW216
     C**********                                       BufferEx6                     MD031775 CSW216
     C**********         EVAL      PCSAST=%SUBST(BufferEx6:679)+BufferEx7            MD031775 CSW216
                                                                                              CSW216
     C                   EVAL      ORDATEAST=%SUBST(Buffer:5114)+Buffer2                      CSW216
     C                   EVAL      OPDATEAST=%SUBST(Buffer2:3914)+BufferEx2                   CSW216
     C                   EVAL      TRDATEAST=%SUBST(BufferEx2:4715)                           CSW216
     C                   EVAL      TPDATEAST=%SUBST(BufferEx2:9515)+BufferEx3                 CSW216
     C                   EVAL      OCFSAST=%SUBST(BufferEx3:4316)+BufferEx4                   CSW216
     C                   EVAL      TCFSAST=%SUBST(BufferEx4:7517)+BufferEx5+                  CSW216
     C                                                 BufferEx6                              CSW216
     C                   EVAL      PCSAST=%SUBST(BufferEx6:719)+BufferEx7                     CSW216 
     C                   MOVEA     ORDATEAST     ORDATEA                        BUG4646
     C                   MOVEA     OPDATEAST     OPDATEA                        BUG4646
     C                   MOVEA     TRDATEAST     TRDATEA                        BUG4646
     C                   MOVEA     TPDATEAST     TPDATEA                        BUG4646
     C                   MOVEA     OCFSAST       OCFSA                          BUG4646
     C                   MOVEA     TCFSAST       TCFSA                          BUG4646
     C                   MOVEA     PCSAST        PCSA                           BUG4646
      ** If CAP041 is installed, move Fees/Buy-Outs fields to one DS for
      ** processing later.
 
     C                   IF        CAP041 = 'Y'
     C                   EVAL      ASOIPM  = SOIPM
     C                   EVAL      ASONPCD = SONPCD
     C                   EVAL      ASTIPM  = STIPM
     C                   EVAL      ASTNPCD = STNPCD
     C                   EVAL      ASUFVD  = SUFVD
     C                   EVAL      ASUFEE  = SUFEE
     C                   EVAL      ASUFPR  = SUFPR
     C                   EVAL      ASBOVD  = SBOVD
     C                   EVAL      ASBUYA  = SBUYA
     C                   EVAL      ASBOPR  = SBOPR
     C                   ENDIF
 
      ***If*Interest*Rate Calendars are in use there will be four blocks        BUG4646
      ***of*data,*each*containing up to 82 dates, which represent Our/Their     BUG4646
      ***Rate*change*and*Interest Payment Dates. These must be loaded into      BUG4646
      ***appropriate*(externally described) data structures.                    BUG4646
      *******************                                                       BUG4646
     C*****CIR001********IFEQ      'Y'                                          BUG4646
     C*******************MOVEL     TransB500     OurRatChgD                     BUG4646
     C*******************MOVEL     TransC500     OurIntPayD                     BUG4646
     C*******************MOVEL     TransD500     ThrRatChgD                     BUG4646
     C*******************MOVEL     TransE500     ThrIntPayD                     BUG4646
     C*******************ENDIF                                                  BUG4646
 
      ** Generate a timestamp for this transaction
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Some fields from the common header DS are renamed to prevent compile
      ** problems, as they are used on other Data Structures.
      ** Data from these must be copied over to the fields used for output
      ** or parameters.
 
      * Reset variables gradually updated, once only at start
 
     C                   EXSR      RESETCYCLE
 
      ** Validate Action Code
 
     C                   EXSR      ValidateAc
 
      ** If error in validation of action code, fail this input
 
     C                   IF        Idx <> *ZERO
     C                   GOTO      INVALID
     C                   ENDIF
                                                                                             BUG6512
      *                                                                                      BUG6512
      * Retrieve TRAM details                                                                BUG6512
      *                                                                                      BUG6512
     C                   EXSR      ZACFFEERTV                                                BUG6512
 
      ** Processing depends upon Action Code
 
     C                   SELECT
 
      ** Processing for Inserts
 
     C                   WHEN      SACCD = 'I'
 
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt
 
      ** If IRCs on in system and no previous errors validate IRC dates
 
     C     CIR001        IFEQ      'Y'
     C*****Idx**         ANDEQ     0                                                         BUG6577
     C                   EXSR      ValidateIC
     C                   ENDIF
 
      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change
      ** Date) is installed and no previous errors, then perform validation of fields.
 
     C**********         IF        CAP041 = 'Y' AND Idx = 0                                  BUG6577
     C                   IF        CAP041 = 'Y'                                              BUG6577
     C                   EXSR      ValidateFE
                                                                                BUG4646
      ** Validate Principle change date schedules                               BUG4646
                                                                                BUG4646
     C     CIR001        IFEQ      'Y'                                          BUG4646
     C*****Idx**         ANDEQ     0                                            BUG4646      BUG6577
     C                   EXSR      ValidatePC                                   BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF
 
      ** Processing for Amends
 
     C                   WHEN      SACCD = 'A'
 
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      TranIn                                 99
     C     *in99         ifeq      *on
     C                   EXSR      TDtDtaSubs
     C                   endif
     C                   endif
 
     C                   EXSR      SetupAmend
     C                   EXSR      ValdateAmd                                                BUG6876
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt
 
      ** If IRCs on in system and no previous errors validate IRC dates
 
     C     CIR001        IFEQ      'Y'
     C*****Idx**         ANDEQ     0                                                         BUG6577
     C                   EXSR      ValidateIC
     C                   ENDIF
 
      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change
      ** Date) is installed and no previous errors, then perform validation of fields.
 
     C**********         IF        CAP041 = 'Y' and Idx = 0                                  BUG6577
     C                   IF        CAP041 = 'Y'                                              BUG6577
     C                   EXSR      ValidateFE
                                                                                BUG4646
      ** Validate Principle change date schedules                               BUG4646
                                                                                BUG4646
     C     CIR001        IFEQ      'Y'                                          BUG4646
     C*****Idx           ANDEQ     0                                            BUG4646      BUG6577
     C                   EXSR      ValidatePC                                   BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF
 
     C**********         EXSR      ValdateAmd                                                BUG6876
                                                                                             BUG4482
     C                   WHEN      SACCD  = 'X'                                              BUG4482
      *  Processing for Authorises                                                           BUG4482
     C                   EXSR      ValidateTr                                                BUG4482
     C                   EXSR      ValidateSt                                                BUG4482
                                                                                             BUG4482
      ** If IRCs on in system and no previous errors validate IRC dates                      BUG4482
                                                                                             BUG4482
     C     CIR001        IFEQ      'Y'                                                       BUG4482
     C*****Idx**         ANDEQ     0                                                 BUG4482 BUG6577
     C                   EXSR      ValidateIC                                                BUG4482
     C                   ENDIF                                                               BUG4482
                                                                                             BUG4482
      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change           BUG4482
      ** Date) is installed and no previous errors, then perform validation of fields.       BUG4482
                                                                                             BUG4482
     C**********         IF        CAP041 = 'Y' and Idx = 0                          BUG4482 BUG6577
     C                   IF        CAP041 = 'Y'                                              BUG6577
     C                   EXSR      ValidateFE                                                BUG4482
                                                                                BUG4646
      ** Validate Principle change date schedules                               BUG4646
                                                                                BUG4646
     C     CIR001        IFEQ      'Y'                                          BUG4646
     C*****Idx**         ANDEQ     0                                            BUG4646      BUG6577
     C                   EXSR      ValidatePC                                   BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                               BUG4482
 
     C****************** OTHER                                                  BUG4646
      ******************                                                        BUG4646
      ***If*CAP041*(APIs for Fees/Buy-Outs/Processing Method/Next Principal Change     BUG4646
      ***Date)*is*installed and no previous errors, then perform validation of fields. BUG4646
      ******************                                                        BUG4646
     C****************** IF        CAP041 = 'Y' and Idx = 0                     BUG4646
     C****************** EXSR      ValidateFE                                   BUG4646
     C****************** ENDIF                                                  BUG4646
      ******************                                                        BUG4646
     C                   ENDSL
 
      ** Write to the database
 
     C     INVALID       TAG
                                                                                              CSW213
      ** Call DLRPIFVU - Midas DL Reporting Information Validate and Update                   CSW213
                                                                                              CSW213
     C                   IF        CSW213 = 'Y' AND                                           CSW213
     C                             UPDateYN <> 'Y'                                            CSW213
     C                   EXSR      SrSIRSvu                                                   CSW213
     C                   ENDIF                                                                CSW213
 
     C                   IF        UpdateYN = 'Y' AND Idx = *ZERO
                                                                                BUG6075
     C                   IF        SACCD = 'I'                                  BUG6075
     C                   EXSR      SETUPDEALN                                   BUG6075
     C                   ENDIF                                                  BUG6075
                                                                                BUG6075
     C                   EXSR      SETUPVALID
 
      ** If Interest Rate Calendars are in use write to valid IRC file
      ** (dont bother setting up for delete)
 
     C     CIR001        IFEQ      'Y'
     C*****SACCD*********ANDNE     'R'                                          BUG4646
     C                   EXSR      SUPVALIRC
     C                   ENDIF
 
     C                   EXSR      WriteToDB
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
      ** If action is for Update, get the correct record information                         BUG6377
      ** from file as UPD module may have changed certain fields                             BUG6377
     C                   IF        UpdateYN = 'Y' and Idx = *ZERO                            BUG6377
      *                                                                                      BUG6377
     C                   MOVE      RSDLNO        DDDLNO_IN                                   BUG6377
     C                   CALL      'IRSIRSR'                                                 BUG6377
     C                   PARM                    AuthComp          1                         BUG6377
     C                   PARM                    FwdBck            1                         BUG6377
     C                   PARM                    DDDLNO_IN         6                         BUG6377
     C                   PARM                    Buffer                                      BUG6377
     C                   PARM                    Buffer2                                     BUG6377
     C                   PARM                    BufferEx2                                   BUG6377
     C                   PARM                    BufferEx3                                   BUG6377
     C                   PARM                    BufferEx4                                   BUG6377
     C                   PARM                    BufferEx5                                   BUG6377
     C                   PARM                    BufferEx6                                   BUG6377
     C                   PARM                    BufferEx7                                   BUG6377
     C                   PARM                    BufferEx8                                   BUG6377
     C                   PARM                    BufferEx9                                   BUG6377
     C                   PARM                    FldNameArr                                  BUG6377
     C                   PARM                    MsgIDArr                                    BUG6377
     C                   PARM                    MsgDtaArr                                   BUG6377
     C                   PARM                    MsgFArray                                   BUG6377
     C                   PARM                    APIRetC                                     BUG6377
     C                   MOVEL     SACCD         Buffer                                      BUG6377
      *                                                                                      BUG6377
     C                   ELSE                                                                BUG6377
      *                                                                                      BUG6377
     C                   MOVEA     ORDATEA       ORDATEAST                      BUG4646
     C                   MOVEA     OPDATEA       OPDATEAST                      BUG4646
     C                   MOVEA     TRDATEA       TRDATEAST                      BUG4646
     C                   MOVEA     TPDATEA       TPDATEAST                      BUG4646
     C                   MOVEA     OCFSA         OCFSAST                        BUG4646
     C                   MOVEA     TCFSA         TCFSAST                        BUG4646
     C                   MOVEA     PCSA          PCSAST                         BUG4646
 
      ** Remerge buffer with all relevant data structures
 
     C                   EVAL      Buffer = TranIn +
     C*******************                   OurRatChgD +                        BUG4646
     C*******************                   OurIntPayD +                        BUG4646
     C*******************                   ThrRatChgD +                        BUG4646
     C*******************                   ThrIntPayD +                        BUG4646
     C                                      InRecSttmt +
     C                                      InPaySttmt +
     C*******************                   InFRASttmt                          BUG4646
     C**********                            InFRASttmt +                        BUG4646      BUG6377
     C**********                            InFRASttmt + SUINFD + STINFD +           BUG6377 BUG6671
     C                                      InFRASttmt +                                     BUG6671
     C                                      InfData + ExtData +                              BUG6671
     C                                      SUINFD + STINFD +                                BUG6671
     C                                           CPST     + DSPCP +                          BUG6512
     C                                           BKST     + DSPBK +                          BUG6512
     C                                           DDSTS +                                     BUG5871
     C                                      FORMULAOR + FORMULAOP +             BUG4646
     C                                      FORMULATR + FORMULATP +             BUG4646
     C                                      FORMULAOC + FORMULATC +             BUG4646
     C**********                            FORMULAOPC+ FORMULATPC + ORDATEAST        BUG4646 CSW213
     C                                      FORMULAOPC+ FORMULATPC +                          CSW213
     C                                      OutSwift2013 + ORDATEAST                          CSW213
     C*******************EVAL      Buffer2=%SUBST(ORDATEAST:4239)+OPDATEAST     BUG4646BUG5357
     C*******************EVAL      BufferEx2=%SUBST(OPDATEAST:3438)+TRDATEAST   BUG4646BUG5357
     C*******************                      +TPDATEAST                       BUG4646BUG5357
     C*******************EVAL      BufferEx3=%SUBST(TPDATEAST:3837)+OCFSAST     BUG4646BUG5357
     C*******************EVAL      BufferEx4=%SUBST(OCFSAST:9036)+TCFSAST       BUG4646BUG5357
     C*******************EVAL      BufferEx5=%SUBST(TCFSAST:5835)+PCSAST        BUG4646BUG5357
     C*******************EVAL      BufferEx6=%SUBST(PCSAST:2634)                BUG4646BUG5357
     C*******************EVAL      BufferEx7=%SUBST(PCSAST:12633)               BUG4646BUG5357
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4177)+OPDATEAST     BUG5357      BUG6377
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3376)+TRDATEAST   BUG5357      BUG6377
     C**********                               +TPDATEAST                       BUG5357      BUG6377
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3775)+OCFSAST     BUG5357      BUG6377
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8974)+TCFSAST       BUG5357      BUG6377
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5773)+PCSAST        BUG5357      BUG6377
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2572)                BUG5357      BUG6377
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12571)               BUG5357      BUG6377
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4165)+OPDATEAST           BUG6377 CDL028
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3364)+TRDATEAST         BUG6377 CDL028
     C**********                               +TPDATEAST                             BUG6377 CDL028
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3763)+OCFSAST           BUG6377 CDL028
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8962)+TCFSAST             BUG6377 CDL028
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5761)+PCSAST              BUG6377 CDL028
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2560)                      BUG6377 CDL028
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12559)                     BUG6377 CDL028
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4077)+OPDATEAST           CDL028 BUG6472
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3276)+TRDATEAST         CDL028 BUG6472
     C**********                               +TPDATEAST                             CDL028 BUG6472
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3675)+OCFSAST           CDL028 BUG6472
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8874)+TCFSAST             CDL028 BUG6472
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5673)+PCSAST              CDL028 BUG6472
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2472)                      CDL028 BUG6472
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12471)                     CDL028 BUG6472
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4075)+OPDATEAST          BUG6472 BUG6671
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3274)+TRDATEAST        BUG6472 BUG6671
     C**********                               +TPDATEAST                            BUG6472 BUG6671
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3673)+OCFSAST          BUG6472 BUG6671
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8872)+TCFSAST            BUG6472 BUG6671
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5671)+PCSAST             BUG6472 BUG6671
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2470)                     BUG6472 BUG6671
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12469)                    BUG6472 BUG6671
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4024)+OPDATEAST          BUG6671 BUG6512
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3223)+TRDATEAST        BUG6671 BUG6512
     C**********                               +TPDATEAST                            BUG6671 BUG6512
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3622)+OCFSAST          BUG6671 BUG6512
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8821)+TCFSAST            BUG6671 BUG6512
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5620)+PCSAST             BUG6671 BUG6512
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2419)                     BUG6671 BUG6512
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12418)                    BUG6671 BUG6512
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:4018)+OPDATEAST          BUG6512 BUG5871
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3217)+TRDATEAST        BUG6512 BUG5871
     C**********                               +TPDATEAST                            BUG6512 BUG5871
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3616)+OCFSAST          BUG6512 BUG5871
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8815)+TCFSAST            BUG6512 BUG5871
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5614)+PCSAST             BUG6512 BUG5871
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2413)                     BUG6512 BUG5871
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12412)                    BUG6512 BUG5871
     C*******************EVAL      Buffer2=%SUBST(ORDATEAST:3994)+OPDATEAST           BUG5871 CDL038
     C*******************EVAL      BufferEx2=%SUBST(OPDATEAST:3193)+TRDATEAST         BUG5871 CDL038
     C*******************                      +TPDATEAST                             BUG5871 CDL038
     C*******************EVAL      BufferEx3=%SUBST(TPDATEAST:3592)+OCFSAST           BUG5871 CDL038
     C*******************EVAL      BufferEx4=%SUBST(OCFSAST:8791)+TCFSAST             BUG5871 CDL038
     C*******************EVAL      BufferEx5=%SUBST(TCFSAST:5590)+PCSAST              BUG5871 CDL038
     C*******************EVAL      BufferEx6=%SUBST(PCSAST:2389)                      BUG5871 CDL038
     C*******************EVAL      BufferEx7=%SUBST(PCSAST:12388)                     BUG5871 CDL038
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:3998)+OPDATEAST          CDL038 BUG11254
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3197)+TRDATEAST        CDL038 BUG11254
     C**********                               +TPDATEAST                            CDL038 BUG11254
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3596)+OCFSAST          CDL038 BUG11254
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8795)+TCFSAST            CDL038 BUG11254
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5594)+PCSAST             CDL038 BUG11254
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2393)                     CDL038 BUG11254
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12392)                    CDL038 BUG11254
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:3960)+OPDATEAST         BUG11254 CSF011A
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:3159)+TRDATEAST       BUG11254 CSF011A
     C**********                               +TPDATEAST                           BUG11254 CSF011A
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:3558)+OCFSAST         BUG11254 CSF011A
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8757)+TCFSAST           BUG11254 CSF011A
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:5556)+PCSAST            BUG11254 CSF011A
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:2355)                    BUG11254 CSF011A
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:12354)                   BUG11254 CSF011A
                                                                                             CSF011A
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:3296)+OPDATEAST           CSF011A CSW213
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:2495)+TRDATEAST         CSF011A CSW213
     C**********                               +TPDATEAST                             CSF011A CSW213
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2894)+OCFSAST           CSF011A CSW213
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:8093)+TCFSAST             CSF011A CSW213
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4892)+PCSAST              CSF011A CSW213
     C**********         EVAL      BufferEx6=%SUBST(PCSAST:1691)                      CSF011A CSW213
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:11690)                     CSF011A CSW213
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:1364)+OPDATEAST            CSW213 CIR017
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:563)+TRDATEAST           CSW213 CIR017
     C**********                               +TPDATEAST                              CSW213 CIR017
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:962)+OCFSAST             CSW213 CIR017
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:6161)+TCFSAST              CSW213 CIR017
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:2960)                      CSW213 CIR017
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:12959)+PCSAST              CSW213 CIR017
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:9758)                       CSW213 CIR017
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:1300)+OPDATEAST            CIR017 CSW214
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:499)+TRDATEAST           CIR017 CSW214
     C**********                               +TPDATEAST                              CIR017 CSW214
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:898)+OCFSAST             CIR017 CSW214
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:6097)+TCFSAST              CIR017 CSW214
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:2896)                      CIR017 CSW214
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:12895)+PCSAST              CIR017 CSW214
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:9694)                       CIR017 CSW214
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:1138)+OPDATEAST          CSW214 MD031775
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:337)+TRDATEAST         CSW214 MD031775
     C**********                               +TPDATEAST                            CSW214 MD031775
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:736)+OCFSAST           CSW214 MD031775
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:5935)+TCFSAST            CSW214 MD031775
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:2734)                    CSW214 MD031775
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:12733)+PCSAST            CSW214 MD031775
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:9532)                     CSW214 MD031775
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:928)+OPDATEAST           MD031775 CSW216
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:127)+TRDATEAST         MD031775 CSW216
     C**********                               +TPDATEAST                            MD031775 CSW216
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:526)+OCFSAST           MD031775 CSW216
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:5725)+TCFSAST            MD031775 CSW216	
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:2524)                    MD031775 CSW216
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:12523)+PCSAST            MD031775 CSW216
     C**********         EVAL      BufferEx7=%SUBST(PCSAST:9322)                     MD031775 CSW216
                                                                                              CSW216
     C                   EVAL      Buffer2=%SUBST(ORDATEAST:888)+OPDATEAST                    CSW216
     C                   EVAL      BufferEx2=%SUBST(OPDATEAST:87)+TRDATEAST                   CSW216
     C                                         +TPDATEAST                                     CSW216
     C                   EVAL      BufferEx3=%SUBST(TPDATEAST:486)+OCFSAST                    CSW216
     C                   EVAL      BufferEx4=%SUBST(OCFSAST:5685)+TCFSAST                     CSW216
     C                   EVAL      BufferEx5=%SUBST(TCFSAST:2484)                             CSW216
     C                   EVAL      BufferEx6=%SUBST(TCFSAST:12483)+PCSAST                     CSW216
     C                   EVAL      BufferEx7=%SUBST(PCSAST:9282)                              CSW216
     C                   ENDIF                                                               BUG6377
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *****************************************************************
     C     ValidateAc    BEGSR
      *******************                                                                    BUG6075
      ***Set*retrieve*mode to '*FRONT' (Access using Front Office ID)                        BUG6075
      *****if*insert*****                                                                    BUG6075
      *****if*not*insert*and Midas transaction ID is not present                             BUG6075
      ***Otherwise*******                                                                    BUG6075
      *****Set*retrieve*mode to blank  (Access using Midas transaction ID).                  BUG6075
      *******************                                                                    BUG6075
     C*****SACCD*********IFEQ      'I'                                                       BUG6075
     C*******************MOVEL     '*FRONT'      ModeofOp                                    BUG6075
      *******************                                                                    BUG6075
      ***Also*setup*deal*number as Front Office ID                                           BUG6075
      ***(If*SDLNO*is*blank, autogenerate by calling SETUPDEALN)                             BUG6075
      *******************                                                                    BUG6075
     C*******************IF        SDLNO = *BLANKS                                           BUG6075
     C*******************EXSR      SETUPDEALN                                                BUG6075
     C*******************MOVEL     RSDLNO        APFOTranID                                  BUG6075
     C*******************ELSE                                                                BUG6075
     C*******************MOVEL     SDLNO         APFOTranID                                  BUG6075
     C*******************MOVEL     SDLNO         RSDLNO                         BUG4646      BUG6075
     C*******************ENDIF                                                               BUG6075
      *******************                                                                    BUG6075
     C*******************ELSE                                                                BUG6075
     C*****SDLNO*********IFEQ      *BLANK                                                    BUG6075
     C*******************MOVEL     '*FRONT'      ModeofOp                                    BUG6075
     C*******************ELSE                                                                BUG6075
     C*******************MOVEL     '      '      ModeofOp                                    BUG6075
     C*******************ENDIF                                                               BUG6075
     C*******************ENDIF                                                               BUG6075
 
      ** Validate action code versus transaction IDs supplied
      ** This function will set the Midas deal number
      ** The deal in file format from the database is retrieved as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'IRSIRSRTV'
      ** INPUTS
      ** Return code
     C                   PARM                    ReturnCode
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      ** Response mode
     C                   PARM      'S'           APRESPMODE
      ** Action Code
     C                   PARM                    SACCD
      ** Front Office Transaction ID
     C                   PARM                    APFOTranID
      ** Front Office Associated Transaction Id
     C                   PARM                    APFOAsocID
      ** (Midas) Deal Number
     C                   PARM                    SDLNO
      ** (Midas) Associated Deal Number
     C                   PARM                    SLNKDN
      ** Booking branch
     C                   PARM                    SBRCA
      ** FRA/IRS Deals Authorisation
     C                   PARM                    CIR008
      ** OUTPUTS
      ** (Current) deal in file format
      ** (Current) deal extenstion in file format                               BUG4646
     C                   PARM                    DealFilFmt
     C                   PARM                    DealXFilFmt                    BUG4646
                                                                                BUG4646
      ** OK - Action code
     C                   PARM                    SAccdOK
      ** OK - Deal Number
     C                   PARM                    SDlNoOK
      ** OK - Booking branch
     C                   PARM                    SBrcaOK
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
                                                                                BUG4646
      ** Warning flds/message IDs/message data (arrays) from/to caller          BUG4646
                                                                                BUG4646
     C                   PARM                    WFldNamArr                     BUG4646
     C                   PARM                    WMsgIdArr                      BUG4646
     C                   PARM                    WMsgDtaArr                     BUG4646
                                                                                BUG4646
      ** Array index (3P0) from/to caller                                       BUG4646
                                                                                BUG4646
     C                   PARM                    WIdx                           BUG4646
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DftSettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *****************************************************************
     C     DftSettmts    BEGSR
 
      ** ISDA - Overwrite defaulted values from ICD if the screen details are not blank      BUG6940
      ** If the customer has SSI for this currency then these are defaulted in ZASETINDFT    BUG6940
     C                   If        DDISDA <> *blanks                                         BUG6940
     C                   Eval      BQISDA = DDISDA                                           BUG6940
     C                   EndIf                                                               BUG6940
     C                   If        DDAGTY <> *blanks                                         BUG6940
     C                   Eval      BQAGTY = DDAGTY                                           BUG6940
     C                   EndIf                                                               BUG6940
     C                   If        DDAGDT <> *blanks                                         BUG6940
     C                   Eval      BQAGDT = DDAGDT                                           BUG6940
     C                   EndIf                                                               BUG6940
     C                   If        DDAGVV <> *blanks                                         BUG6940
     C                   Eval      WWAGVV = DDAGVV                                           BUG6940
     C                   Eval      BQAGVV = WDAGVV                                           BUG6940
     C                   Eval      BQAGVC = WDAGVC                                           BUG6940
     C                   EndIf                                                               BUG6940
                                                                                             BUG6940
      ** If ANY of the Settlements fields have been entered, bypass this
      **  routine.
      ** Otherwise, use modules which will use Standard Settlement
      **  Instructions to apply defaults.
 
     C                   IF            (InRecSttmt = *blank)
     C                             AND (InPaySttmt = *blank)
     C                             AND InFraSttmt = *blank                                   BUG8997
 
     C                   CALLB     'ZASETINDFT'
      ** Output
      ** Calling function type
     C                   PARM                    SIRS
      ** Payment currency (or deal cuurency if only one currency on deal)
     C                   PARM                    SuCucy
      ** Receive currency (only if deal has two currencies)
     C                   PARM                    Blank3
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
      ** Version of ISDA Agreement century
     C                   PARM                    BQAGVC            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
                                                                                              CSD095
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt
 
      ** The defaulted instructions are in file format, but the
      ** Settlements validation requires that they are in the input format.
      ** Therefore run them through a conversion module.
 
     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      SUCUCY        InRCCY                                      CSF011A
     C                   PARM      SUCUCY        InPCCY                                      CSF011A
                                                                                              244254
      ** else, if pay/rec details are manually entered on the screen,                         244254
      ** try to retrieve and default the ISDA details.                                        244254
     C                   ELSE                                                                 244254
     C                   EXSR      DefISDA                                                    244254
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETUPAMEND - Set up fields that are needed in the validation  *
      *    of Amendments.                                             *
      *****************************************************************
     C     SetupAmend    BEGSR
 
      ** For Amends, put the complete (pre-existing) FRA into the Valid
      ** file record - fields in this will be updated during  processing
 
     C                   MOVEL     DealFilFmt    ValidDeal
     C                   MOVEL     FSOYLC        RSOYLC                         BUG4646
     C                   MOVEL     FIUSRI        RSUSRI                         BUG4646
     C                   MOVEL     FIDSTS        RSDSTS                         BUG4646
     C**********         MOVEL     FIAUTH        RSAUTH                             BUG4646 AR981707
     C                   MOVEL     *BLANK        RSAUTH                                     AR981707
     C                   MOVEL     URACC         RSURACC                        BUG4646
     C                   MOVEL     UPACC         RSUPACC                        BUG4646
     C                   MOVEL     RONS          RSRONS                         BUG4646
     C                   MOVEL     PONS          RSPONS                         BUG4646
 
     C*******************EVAL      DBRecSttmt = SIRSRecIns + RSROBR             BUG4646
     C                   EVAL      %SUBST(DBRecSttmt:1:2)=%SUBST(SIRSRecIns:1:2)BUG4646
     C                   EVAL      %SUBST(DBRecSttmt:3:18)=RSRONS               BUG4646
     C                   EVAL      %SUBST(DBRecSttmt:21:55)=                    BUG4646
     C                             %SUBST(SIRSRecIns:15:55)                     BUG4646
     C                   EVAL      FLROBR     = RSROBR                          BUG4646
     C                   EVAL      FLRSCY     = RSRSCY
     C*******************EVAL      DBPaySttmt = SIRSPayIns + RSPOBR + RSCVMR    BUG4646
     C                   EVAL      %SUBST(DBPaySttmt:1:2)=%SUBST(SIRSPayIns:1:2)BUG4646
     C                   EVAL      %SUBST(DBPaySttmt:3:18)=RSPONS               BUG4646
     C                   EVAL      %SUBST(DBPaySttmt:21:545)=                   BUG4646
     C                             %SUBST(SIRSPayIns:15:545)                    BUG4646
     C                   EVAL      FLPOBR     = RSPOBR                          BUG4646
     C                   EVAL      FLCVMR     = RSCVMR                          BUG4646
     C                   EVAL      FLPSCY     = RSPSCY
     C                   EVAL      FLIC72     = RSIC72
     C                   EVAL      DBFraSttmt = SIRSFraIns
     C                   MOVE      RSAGVC        FLAGVC
 
      ** .... and then convert these to the screen format
 
     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Current Settlement Instruction in input format
     C                   PARM                    CrPaySttmt
     C                   PARM                    CrRecSttmt
     C                   PARM                    CrFRASttmt
     C                   PARM      @SUCUCY       InRCCY                                      CSF011A
     C                   PARM      @SUCUCY       InPCCY                                      CSF011A
 
      ** If no Payment or Receive instructions have been supplied
      ** Default them to those currently on the deal.
 
     C                   IF            (InPaySttmt = *blank)
     C                   EVAL      InPaySttmt = CrPaySttmt
     C                   ENDIF
 
     C                   IF            (InRecSttmt = *blank)
     C                   EVAL      InRecSttmt = CrRecSttmt
     C                   ENDIF
 
     C                   IF            (InFRASttmt = *blank)
     C                   EVAL      InFRASttmt = CrFRASttmt
     C                   ENDIF
 
      ** Do data substitution for Settlement Instructions
 
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      InPaySttmt                             99
     C  N99GHSUBS        scan      InRecSttmt                             99
     C  N99GHSUBS        scan      InFRASttmt                             99
     C     *in99         ifeq      *on
     C                   EXSR      SDtDtaSubs
     C                   endif
     C                   endif
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValidateTr - Routine to validate the main transaction details *
      *****************************************************************
     C     ValidateTr    BEGSR
 
      ** Set up the settlemnt information needed for holidays validation:
      ** - default fields for Inserts
      ** - existing d/b fields for Amends
 
     C                   IF        SACCD = 'I'
 
      ** This block assumes that Settlement Instructions are never received
 
     C                   EVAL      RecSetMeth = RSRSTM
     C                   EVAL      RecNostro  = RSRONS
     C                   EVAL      PaySetMeth = RSPSTM
     C                   EVAL      PayNostro  = RSPONS
     C                   ENDIF
 
     C                   IF        SACCD = 'A'
     C                   EVAL      RecSetMeth = RSRSTM
     C                   EVAL      RecNostro  = RSRONS
     C                   EVAL      PaySetMeth = RSPSTM
     C                   EVAL      PayNostro  = RSPONS
     C                   ENDIF
 
      ** Business Day Convention enhancement is installed, allow valida
      ** tion of dates through currency conventions, otherwise valida -
      ** tion against BDC not needed.
 
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WValBDC = 'Y'
     C                   ELSE
     C                   EVAL      WValBDC = 'N'
     C                   ENDIF
 
     C                   CALLB     'IRSIRSVAL'
     C                   PARM      '*FRONT'      ModeOfOp
      ** Response mode (1A), from source system common header
     C                   PARM      'S'           APRespMode
      ** Transaction information (DS) from source system
     C                   PARM                    TranIn
      ** Receive Settlement Method & Nostro and  Pay Settlement Method &
      ** Nostro, from default (Action = I) or valid deal (Action = A)
     C                   PARM      *BLANKS       RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM      *BLANKS       PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    ExtData
      ** Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      ** Validate business day convention flag
     C                   PARM                    WValBDC
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
     C                   PARM                    ValidXDeal                     BUG4646
     C                   PARM                    SACCD
     C                   PARM                    USLIP
     C                   PARM                    TSLIP
      ** Current Deal in Screen Format
     C                   PARM                    DealScnfmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValidateSt - Routine to validate the settlement instructions  *
      *****************************************************************
     C     ValidateSt    BEGSR
 
      ** The called module requires that the customer number/name is valid,
      ** if it is not, exit from this subroutine.
 
     C                   IF        NOT (SCNumOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF
                                                                                            BUG27882
      ** Store the Up-front and Buy-out Details                                             BUG27882
                                                                                            BUG27882
     C                   IF        CGL014 = 'Y'                                             BUG27882
     C     *LOCK         IN        DLUFBO                                                   BUG27882
     C                   MOVE      SDLNO         DLDLNO                                     BUG27882
     C                   EVAL      DLUPVD = RSUPVD                                          BUG27882
     C                   EVAL      DLUPFE = RSUPFE                                          BUG27882
     C                   EVAL      DLUPPR = RSUPPR                                          BUG27882
     C                   EVAL      DLUCCY = RSUCUCY                                         BUG27882
     C                   EVAL      DLBOVD = RSBOVD                                          BUG27882
     C                   EVAL      DLBOAM = RSBOAM                                          BUG27882
     C                   EVAL      DLBOPR = RSBAPR                                          BUG27882
     C                   OUT       DLUFBO                                                   BUG27882
     C                   ENDIF                                                              BUG27882
 
      ** Set pay and receive dates to run date
 
     C                   EVAL      PayDat = BJRDNB
     C                   EVAL      RecDat = BJRDNB
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'
      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    SIRS
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM                    SUCUCY
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM                    SUCUCY
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
     C                   PARM                    SACCD
      ** Protect Payment Field
     C                   PARM                    ##PPAY            1
      ** Protect Receipt Field
     C                   PARM                    ##PREC            1
      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKSIRSInDS
      ** Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                       BUG4646
     C                   PARM                    WFldNamArr                     BUG4646
     C                   PARM                    WMsgIdArr                      BUG4646
     C                   PARM                    WMsgDtaArr                     BUG4646
     C                   PARM                    WIdx                           BUG4646
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Extra Input
      ** Action Code used
     C                   PARM      SACCD         ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
 
     C     ValSetExit    TAG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *****************************************************************
     C     TDtDtaSubs    BEGSR
 
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
 
     C                   RESET                   ReturnCode
     C                   CALLB     'IRSIRSCVT'
      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode
      ** (Current) Deal in file format
     C                   PARM                    DealFilfmt
     C                   PARM                    DealXFilFmt                    BUG4646
                                                                                BUG4646
      ** FRA/IRS Deals Authorisation
     C                   PARM                    CIR008
      ** OUTPUTS
      ** (Current) Deal in screen format
      ** (Current) deal extenstion in file format                               BUG4646
     C                   PARM                    DealScnfmt
      ** Deal Status
     C                   PARM                    DDSTS
 
      ** DATA SUBSTITUTION
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      ** Return Code
     C                   PARM                    ReturnCode       10
      ** Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      ** Incoming Data
     C                   PARM      TranIn        IncDATA        2000
      ** Current Data
     C                   PARM      DealScnfmt    CurDATA        2000
 
     C                   MOVEL     IncDATA       TranIn
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *****************************************************************
     C     SDtDtaSubs    BEGSR
 
      ** PAYMENT INSTRUCTIONS
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      ** Return Code
     C                   PARM                    ReturnCode
      ** Substitution character
     C                   PARM      GHSUBS        SubsChar
      ** Incoming Data
     C                   PARM      InPaySttmt    IncDATA
      ** Current Data
     C                   PARM      CrPaySttmt    CurDATA
 
     C                   MOVEL     IncDATA       InPaySttmt
 
      ** RECEIPT INSTRUCTIONS
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      ** Return Code
     C                   PARM                    ReturnCode
      ** Substitution character
     C                   PARM      GHSUBS        SubsChar
      ** Incoming Data
     C                   PARM      InRecSttmt    IncDATA
      ** Current Data
     C                   PARM      CrRecSttmt    CurDATA
 
     C                   MOVEL     IncDATA       InRecSttmt
 
      ** FRA/IRS INSTRUCTIONS
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      ** Return Code
     C                   PARM                    ReturnCode
      ** Substitution character
     C                   PARM      GHSUBS        SubsChar
      ** Incoming Data
     C                   PARM      InFRASttmt    IncDATA
      ** Current Data
     C                   PARM      CrFRASttmt    CurDATA
 
     C                   MOVEL     IncDATA       InFRASttmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValidateIC - Routine to validate Interest Rate Calendars      *
      *****************************************************************
     C     ValidateIC    BEGSR
     C                   MOVEL     RSDLNO        WDealNo                        BUG4646
     C                   IF        SMDAT <> *BLANKS                             BUG4646
     C                   EVAL      InDate = SMDAT                               BUG4646
      ** Convert date from DDMMYY to Midas day number                           BUG4646
     C                   CALLB     'ZDATE1'                                     BUG4646
     C                   PARM                    InDate                         BUG4646
     C                   PARM                    InDateMDN                      BUG4646
     C                   PARM                    BJDFIN                         BUG4646
     C                   PARM                    ErrorFlag                      BUG4646
     C                   Z-ADD     InDateMDN     CMDYN             5 0          BUG4646
     C                   ELSE                                                   BUG4646
     C                   Z-ADD     0             CMDYN                          BUG4646
     C                   ENDIF                                                  BUG4646
      ** Clear Unprocessed schedules data structure                                          BUG7621
     C                   CLEAR                   UPPSCH                                      BUG7621
                                                                                BUG4646
      ** Our rate change date Schedule                                          BUG4646
     C     SUICFR        IFEQ      'Z'                                          BUG4646
     C     ORDATEA(1)    ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'R'                               BUG4646
     C                   EVAL      POurTheir= 'U'                               BUG4646
     C                   EVAL      WRatePay = 'R'                               BUG4646
     C                   MOVEL     *BLANKS       SDATENAME        10            BUG5438
     C                   MOVEL     'SDATEOR'     SDATENAME                      BUG5438
     C                   MOVEL     *BLANKS       SCHEDNAME        35            BUG5438
     C                   MOVEL     OurRate       SCHEDNAME                      BUG5438
     C                   EXSR      CheckCurr                                    BUG4646
     C                   EVAL      X=%LOOKUP('        ':ORDATEA)                BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   EXSR      SRGetCtlDate                                 BUG4646
      * Default with control date                                               BUG4646
     C                   IF        X=1                                          BUG4646
     C                             and SUNICD <> *blanks                                     BUG7621
     C                   EVAL      ORDATEA(X)=SUNICD                            BUG4646
     C                   ADD       1             X                              BUG4646
     C                   ELSE                                                   BUG5964
      * Check if all dates are processed                                        BUG5964
     C                   EVAL      A=1                                          BUG5964
     C                   EVAL      B=1                                          BUG5964
     C                   DOW       A<X                                          BUG5964
     C                   IF        %SUBST(ORDATEA(A):8:1)='Y' OR                BUG5964
     C                             %SUBST(ORDATEA(A):8:1)='y'                   BUG5964
     C                   ADD       1             B                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             A                              BUG5964
     C                   ENDDO                                                  BUG5964
      * Default with control date                                               BUG5964
     C                   IF        X=B                                          BUG5964
     C                             and SUNICD <> *blanks                                     BUG7621
     C                   EVAL      ORDATEA(X)=SUNICD                            BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG4646
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      DATESCH=ORDATEA(I)                           BUG4646
     C                   EVAL      InDate = DSDATE                              BUG4646
     C                   EVAL      CHol = DSCHOL                                BUG4646
     C                   EVAL      PDAT = DSPDAT                                BUG4646
     C                   MOVEL     DSDATE        MSGDATE           6            BUG5438
     C                   EXSR      SRZEDIT                                      BUG5438
                                                                                BUG4646
      * Validate date                                                           BUG4646
     C                   EXSR      CheckDate                                    BUG4646
     C     INDATEMDN     LOOKUP    ORMDATE                                24    BUG4646
     C                   IF        *IN24 = *ON                                  BUG4646
     C                   ADD       1             Idx                            BUG4646
     C**********         MOVEL     'DLM0150'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      ORMDATE(I)=INDATEMDN                         BUG4646
      * Validate confirm holiday flag                                           BUG4646
     C                   EXSR      ConfHol                                      BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
                                                                                BUG5964
      * Find first non processed date                                           BUG5964
     C                   IF        Idx=0                                        BUG5964
     C                   EVAL      WCTLDYN = 0                                  BUG5964
     C                   EVAL      I=1                                          BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        %SUBST(ORDATEA(I):8:1)<>'Y' AND              BUG5964
     C                             %SUBST(ORDATEA(I):8:1)<>'y'                  BUG5964
     C                   EVAL      WCTLDYN = ORMDATE(I)                         BUG5964
     C                   LEAVE                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
     C                   EVAL      I=1                                          BUG5964
                                                                                BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        ORMDATE(I) < WCTLDYN AND                     BUG5964
     C                             %SUBST(ORDATEA(I):8:1)<>'Y' AND              BUG5964
     C                             %SUBST(ORDATEA(I):8:1)<>'y'                  BUG5964
     C                   EVAL      WCTLDYN = ORMDATE(I)                         BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
     C                   IF        WCTLDYN <> 0                                 BUG5964
     C                   EVAL      ZDAYNO =  WCTLDYN                            BUG5964
     C                   CALLB     'ZDATE2'                                     BUG5964
     C                   PARM                    ZDAYNO                         BUG5964
     C                   PARM                    BJDFIN                         BUG5964
     C                   PARM      *ZEROS        ZDATE                          BUG5964
     C                   PARM      *BLANKS       ZADATE                         BUG5964
                                                                                BUG5964
     C                   MOVEL     ZDATE         CZDATE            6            BUG5964
     C                   IF        CZDATE <> SUNICD                             BUG5964
     C                   MOVEL     ZDATE         SUNICD                         BUG5964
     C                   EVAL      RSUNICD=ZDAYNO                               BUG5964
     C                   If        SUICFR = *blanks                                          BUG7621
     C                   Eval      SUICFR = 'Z'                                              BUG7621
     C                   Eval      RSUICFR = 'Z'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'SUNICD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0600'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                            MD031224
      * Display warning if date falls on holiday                                            MD031224
     C                   EVAL      InDate = CZDATE                                          MD031224
     C                   EXSR      CheckDate                                                MD031224
     C                   IF        WHoliday='Y'                                             MD031224
     C                   ADD       1             WIdx                                       MD031224
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA1112'                              MD031224
     C                   EVAL      WFldNamArr(WIdx) = 'SUNICD'                              MD031224
     C                   EVAL      WMsgDtaArr(WIdx) = SUCUCY                                MD031224
     C                   ENDIF                                                              MD031224
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG4646
      * Validate formula                                                        BUG4646
     C                   IF        Idx=0                                        BUG4646
     C                   EVAL      SFREQF = SFREQFOR                            BUG4646
     C                   EVAL      SFORM = SFORMOR                              BUG4646
     C                   MOVEL     *BLANKS       SFORMNAME        10            BUG5357
     C                   MOVEL     'SFREQFOR'    SFORMNAME                      BUG5357
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR              BUG4646
     C                             SFREQF = 'X' OR SFREQF = 'Y'                 BUG4646
     C                   EXSR      ValFormula                                   BUG4646
                                                                                BUG4646
      * Generate Dates                                                          BUG4646
     C                   IF        Idx=0 AND SFORM <> *BLANKS                   BUG4646
      *******************                                                       BUG5357BUG5964
     C*******************IF        SACCD = 'I' AND X>1                          BUG5357BUG5964
     C*******************EVAL      WCTLDYN = ORMDATE(1)                         BUG5357BUG5964
     C*******************EVAL      I=1                                          BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************DOW       I<X                                          BUG5357BUG5964
     C*******************IF        ORMDATE(I) < WCTLDYN                         BUG5357BUG5964
     C*******************EVAL      WCTLDYN = ORMDATE(I)                         BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
     C*******************ADD       1             I                              BUG5357BUG5964
     C*******************ENDDO                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C                   MOVEL     SFORM         FFDATC                         BUG4646
     C                   MOVEL     SUCUCY        FFCCY1                         BUG4646
     C                   MOVEL     *BLANK        FFCCY2                         BUG4646
     C                   MOVE      *BLANK        FFCCY3                         BUG4646
     C                   Z-ADD     *ZERO         PRDT                           BUG4646
     C                   EVAL      K=X                                          BUG4646
     C                   MOVEA     ORMDATE       WMDATE                         BUG4646
     C                   EXSR      GENDATES                                     BUG4646
     C                   MOVEA     WMDATE        ORMDATE                        BUG4646
     C                   EVAL      L = 1                                        BUG4646
     C                   DOW       L < K                                        BUG4646
                                                                                BUG4646
      ** Check if it is a saturday or a sunday                                  BUG4646
      ** and treat it as holiday                                                BUG4646
                                                                                BUG4646
     C                   EVAL      WRK153 = ORMDATE(L)/7                        BUG4646
     C                   MOVE      WRK153        WRK30                          BUG4646
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG4646
     C                   EVAL      %SUBST(ORDATEA(L):7:1)='Y'                   BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      ZDAYNO =  ORMDATE(L)                         BUG4646
     C                   CALLB     'ZDATE2'                                     BUG4646
     C                   PARM                    ZDAYNO                         BUG4646
     C                   PARM                    BJDFIN                         BUG4646
     C                   PARM      *ZEROS        ZDATE                          BUG4646
     C                   PARM      *BLANKS       ZADATE            7            BUG4646
                                                                                BUG4646
     C                   MOVEL     ZDATE         ORDATEA(L)                     BUG4646
     C                   ADD       1             L                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
      ** Our Interest Payment dates                                             BUG4646
     C     SUIPFR        IFEQ      'Z'                                          BUG4646
     C     OPDATEA(1)    ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'I'                               BUG4646
     C                   EVAL      WRatePay = 'P'                               BUG4646
     C                   EVAL      POurTheir= 'U'                               BUG4646
     C                   MOVEL     *BLANKS       SDATENAME                      BUG5438
     C                   MOVEL     'SDATEOP'     SDATENAME                      BUG5438
     C                   MOVEL     *BLANKS       SCHEDNAME                      BUG5438
     C                   MOVEL     OurPay        SCHEDNAME                      BUG5438
     C                   EXSR      CheckCurr                                    BUG4646
     C                   EVAL      X=%LOOKUP('        ':OPDATEA)                BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   EXSR      SRGetCtlDate                                 BUG4646
      * Default with control date                                               BUG4646
     C                   IF        X=1                                          BUG4646
     C                             and SUNIPD <> *blanks                                     BUG7621
     C                   EVAL      OPDATEA(X)=SUNIPD                            BUG4646
     C                   ADD       1             X                              BUG4646
     C                   ELSE                                                   BUG5964
      * Check if all dates are processed                                        BUG5964
     C                   EVAL      A=1                                          BUG5964
     C                   EVAL      B=1                                          BUG5964
     C                   DOW       A<X                                          BUG5964
     C                   IF        %SUBST(OPDATEA(A):8:1)='Y' OR                BUG5964
     C                             %SUBST(OPDATEA(A):8:1)='y'                   BUG5964
     C                   ADD       1             B                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             A                              BUG5964
     C                   ENDDO                                                  BUG5964
      * Default with control date                                               BUG5964
     C                   IF        X=B                                          BUG5964
     C                             and SUNIPD <> *blanks                                     BUG7621
     C                             and SUIPFR <> 'C'                                         BUG7621
     C                   EVAL      OPDATEA(X)=SUNIPD                            BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG4646
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      DATESCH=OPDATEA(I)                           BUG4646
     C                   EVAL      InDate = DSDATE                              BUG4646
     C                   EVAL      CHol = DSCHOL                                BUG4646
     C                   EVAL      PDAT = DSPDAT                                BUG4646
     C                   MOVEL     DSDATE        MSGDATE                        BUG5438
     C                   EXSR      SRZEDIT                                      BUG5438
     C                   EXSR      CheckDate                                    BUG4646
                                                                                BUG4646
     C     INDATEMDN     LOOKUP    OPMDATE                                24    BUG4646
     C                   IF        *IN24 = *ON                                  BUG4646
     C                   ADD       1             Idx                            BUG4646
     C**********         MOVEL     'DLM0150'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      OPMDATE(I)=INDATEMDN                         BUG4646
     C                   EXSR      ConfHol                                      BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
                                                                                BUG5964
      * Find first non processed date                                           BUG5964
     C                   IF        Idx=0                                        BUG5964
     C                   EVAL      WCTLDYN = 0                                  BUG5964
     C                   EVAL      I=1                                          BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        %SUBST(OPDATEA(I):8:1)<>'Y' AND              BUG5964
     C                             %SUBST(OPDATEA(I):8:1)<>'y'                  BUG5964
     C                   EVAL      WCTLDYN = OPMDATE(I)                         BUG5964
     C                   Eval      UPOPSCH = 'Y'                                             BUG7621
     C                   LEAVE                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
      ** Error if both cashflow and int. payment schedule records exist,                     BUG7621
      ** Frequency doesn't match up with schedule records                                    BUG7621
     C                   If        UPOPSCH = 'Y'                                             BUG7621
     C                             and SUIPFR = 'C'                                          BUG7621
     C                   ADD       1             Idx                                         BUG7621
     C                   EVAL      FldNameArr(Idx) = 'SUIPFR'                                BUG7621
     C                   MOVEL     'DLM2012'     MsgIDArr(Idx)                               BUG7621
     C                   Else                                                                BUG7621
      *                                                                                      BUG7621
     C                   EVAL      I=1                                          BUG5964
                                                                                BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        OPMDATE(I) < WCTLDYN AND                     BUG5964
     C                             %SUBST(OPDATEA(I):8:1)<>'Y' AND              BUG5964
     C                             %SUBST(OPDATEA(I):8:1)<>'y'                  BUG5964
     C                   EVAL      WCTLDYN = OPMDATE(I)                         BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
     C                   IF        WCTLDYN <> 0                                 BUG5964
     C                   EVAL      ZDAYNO =  WCTLDYN                            BUG5964
     C                   CALLB     'ZDATE2'                                     BUG5964
     C                   PARM                    ZDAYNO                         BUG5964
     C                   PARM                    BJDFIN                         BUG5964
     C                   PARM      *ZEROS        ZDATE                          BUG5964
     C                   PARM      *BLANKS       ZADATE                         BUG5964
                                                                                BUG5964
     C                   MOVEL     ZDATE         CZDATE                         BUG5964
     C                   IF        CZDATE <> SUNIPD                             BUG5964
     C                   MOVEL     ZDATE         SUNIPD                         BUG5964
     C                   EVAL      RSUNIPD=ZDAYNO                               BUG5964
     C                   If        SUIPFR = *blanks                                          BUG7621
     C                   Eval      SUIPFR = 'Z'                                              BUG7621
     C                   Eval      RSUIPFR = 'Z'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'SUNIPD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0601'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                            MD031224
      * Display warning if date falls on holiday                                            MD031224
     C                   EVAL      InDate = CZDATE                                          MD031224
     C                   EXSR      CheckDate                                                MD031224
     C                   IF        WHoliday='Y'                                             MD031224
     C                   ADD       1             WIdx                                       MD031224
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA1113'                              MD031224
     C                   EVAL      WFldNamArr(WIdx) = 'SUNIPD'                              MD031224
     C                   EVAL      WMsgDtaArr(WIdx) = SUCUCY                                MD031224
     C                   ENDIF                                                              MD031224
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   EndIf                                                               BUG7621
     C                   ENDIF                                                  BUG5964
                                                                                BUG4646
      * Validate formula                                                        BUG4646
     C                   IF        Idx=0                                        BUG4646
     C                   EVAL      SFREQF = SFREQFOP                            BUG4646
     C                   EVAL      SFORM = SFORMOP                              BUG4646
     C                   MOVEL     *BLANKS       SFORMNAME                      BUG5357
     C                   MOVEL     'SFREQFOP'    SFORMNAME                      BUG5357
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR              BUG4646
     C                             SFREQF = 'X' OR SFREQF = 'Y'                 BUG4646
     C                   EXSR      ValFormula                                   BUG4646
                                                                                BUG4646
      * Generate Dates                                                          BUG4646
     C                   IF        Idx=0 AND SFORM <> *BLANKS                   BUG4646
      *******************                                                       BUG5357BUG5964
     C*******************IF        SACCD = 'I' AND X>1                          BUG5357BUG5964
     C*******************EVAL      WCTLDYN = OPMDATE(1)                         BUG5357BUG5964
     C*******************EVAL      I=1                                          BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************DOW       I<X                                          BUG5357BUG5964
     C*******************IF        OPMDATE(I) < WCTLDYN                         BUG5357BUG5964
     C*******************EVAL      WCTLDYN = OPMDATE(I)                         BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
     C*******************ADD       1             I                              BUG5357BUG5964
     C*******************ENDDO                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C                   MOVEL     SFORM         FFDATC                         BUG4646
     C                   MOVEL     WPSCY         FFCCY1                         BUG4646
     C                   MOVEL     *BLANK        FFCCY2                         BUG4646
     C                   MOVE      *BLANK        FFCCY3                         BUG4646
     C                   Z-ADD     *ZERO         PRDT                           BUG4646
     C                   EVAL      K=X                                          BUG4646
     C                   MOVEA     OPMDATE       WMDATE                         BUG4646
     C                   EXSR      GENDATES                                     BUG4646
     C                   MOVEA     WMDATE        OPMDATE                        BUG4646
     C                   EVAL      L = 1                                        BUG4646
     C                   DOW       L < K                                        BUG4646
                                                                                BUG4646
      ** Check if it is a saturday or a sunday                                  BUG4646
      ** and treat it as holiday                                                BUG4646
                                                                                BUG4646
     C                   EVAL      WRK153 = OPMDATE(L)/7                        BUG4646
     C                   MOVE      WRK153        WRK30                          BUG4646
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG4646
     C                   EVAL      %SUBST(OPDATEA(L):7:1)='Y'                   BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      ZDAYNO =  OPMDATE(L)                         BUG4646
     C                   CALLB     'ZDATE2'                                     BUG4646
     C                   PARM                    ZDAYNO                         BUG4646
     C                   PARM                    BJDFIN                         BUG4646
     C                   PARM      *ZEROS        ZDATE                          BUG4646
     C                   PARM      *BLANKS       ZADATE            7            BUG4646
                                                                                BUG4646
     C                   MOVEL     ZDATE         OPDATEA(L)                     BUG4646
     C                   ADD       1             L                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
      ** Their rate change date Schedule                                        BUG4646
     C     STICFR        IFEQ      'Z'                                          BUG4646
     C     TRDATEA(1)    ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'R'                               BUG4646
     C                   EVAL      WRatePay = 'R'                               BUG4646
     C                   EVAL      POurTheir= 'T'                               BUG4646
     C                   MOVEL     *BLANKS       SDATENAME                      BUG5438
     C                   MOVEL     'SDATETR'     SDATENAME                      BUG5438
     C                   MOVEL     *BLANKS       SCHEDNAME                      BUG5438
     C                   MOVEL     TheirRate     SCHEDNAME                      BUG5438
     C                   EXSR      CheckCurr                                    BUG4646
     C                   EVAL      X=%LOOKUP('        ':TRDATEA)                BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   EXSR      SRGetCtlDate                                 BUG4646
      * Default with control date                                               BUG4646
     C                   IF        X=1                                          BUG4646
     C                             and STNICD <> *blanks                                     BUG7621
     C                   EVAL      TRDATEA(X)=STNICD                            BUG4646
     C                   ADD       1             X                              BUG4646
     C                   ELSE                                                   BUG5964
      * Check if all dates are processed                                        BUG5964
     C                   EVAL      A=1                                          BUG5964
     C                   EVAL      B=1                                          BUG5964
     C                   DOW       A<X                                          BUG5964
     C                   IF        %SUBST(TRDATEA(A):8:1)='Y' OR                BUG5964
     C                             %SUBST(TRDATEA(A):8:1)='y'                   BUG5964
     C                   ADD       1             B                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             A                              BUG5964
     C                   ENDDO                                                  BUG5964
      * Default with control date                                               BUG5964
     C                   IF        X=B                                          BUG5964
     C                             and STNICD <> *blanks                                     BUG7621
     C                   EVAL      TRDATEA(X)=STNICD                            BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG4646
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      DATESCH=TRDATEA(I)                           BUG4646
     C                   EVAL      InDate = DSDATE                              BUG4646
     C                   EVAL      CHol = DSCHOL                                BUG4646
     C                   EVAL      PDAT = DSPDAT                                BUG4646
     C                   MOVEL     DSDATE        MSGDATE                        BUG5438
     C                   EXSR      SRZEDIT                                      BUG5438
     C                   EXSR      CheckDate                                    BUG4646
                                                                                BUG4646
     C     INDATEMDN     LOOKUP    TRMDATE                                24    BUG4646
     C                   IF        *IN24 = *ON                                  BUG4646
     C                   ADD       1             Idx                            BUG4646
     C**********         MOVEL     'DLM0150'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      TRMDATE(I)=INDATEMDN                         BUG4646
     C                   EXSR      ConfHol                                      BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
                                                                                BUG5964
      * Find first non processed date                                           BUG5964
     C                   IF        Idx=0                                        BUG5964
     C                   EVAL      WCTLDYN = 0                                  BUG5964
     C                   EVAL      I=1                                          BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        %SUBST(TRDATEA(I):8:1)<>'Y' AND              BUG5964
     C                             %SUBST(TRDATEA(I):8:1)<>'y'                  BUG5964
     C                   EVAL      WCTLDYN = TRMDATE(I)                         BUG5964
     C                   LEAVE                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
     C                   EVAL      I=1                                          BUG5964
                                                                                BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        TRMDATE(I) < WCTLDYN AND                     BUG5964
     C                             %SUBST(TRDATEA(I):8:1)<>'Y' AND              BUG5964
     C                             %SUBST(TRDATEA(I):8:1)<>'y'                  BUG5964
     C                   EVAL      WCTLDYN = TRMDATE(I)                         BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
     C                   IF        WCTLDYN <> 0                                 BUG5964
     C                   EVAL      ZDAYNO =  WCTLDYN                            BUG5964
     C                   CALLB     'ZDATE2'                                     BUG5964
     C                   PARM                    ZDAYNO                         BUG5964
     C                   PARM                    BJDFIN                         BUG5964
     C                   PARM      *ZEROS        ZDATE                          BUG5964
     C                   PARM      *BLANKS       ZADATE                         BUG5964
                                                                                BUG5964
     C                   MOVEL     ZDATE         CZDATE                         BUG5964
     C                   IF        CZDATE <> STNICD                             BUG5964
     C                   MOVEL     ZDATE         STNICD                         BUG5964
     C                   EVAL      RSTNICD=ZDAYNO                               BUG5964
     C                   If        STICFR = *blanks                                          BUG7621
     C                   Eval      STICFR = 'Z'                                              BUG7621
     C                   Eval      RSTICFR = 'Z'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'STNICD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0602'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                            MD031224
      * Display warning if date falls on holiday                                            MD031224
     C                   EVAL      InDate = CZDATE                                          MD031224
     C                   EXSR      CheckDate                                                MD031224
     C                   IF        WHoliday='Y'                                             MD031224
     C                   ADD       1             WIdx                                       MD031224
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA1112'                              MD031224
     C                   EVAL      WFldNamArr(WIdx) = 'STNICD'                              MD031224
     C                   EVAL      WMsgDtaArr(WIdx) = SUCUCY                                MD031224
     C                   ENDIF                                                              MD031224
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG4646
      * Validate formula                                                        BUG4646
     C                   IF        Idx=0                                        BUG4646
     C                   EVAL      SFREQF = SFREQFTR                            BUG4646
     C                   EVAL      SFORM = SFORMTR                              BUG4646
     C                   MOVEL     *BLANKS       SFORMNAME                      BUG5357
     C                   MOVEL     'SFREQFTR'    SFORMNAME                      BUG5357
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR              BUG4646
     C                             SFREQF = 'X' OR SFREQF = 'Y'                 BUG4646
     C                   EXSR      ValFormula                                   BUG4646
                                                                                BUG4646
      * Generate Dates                                                          BUG4646
     C                   IF        Idx=0 AND SFORM <> *BLANKS                   BUG4646
      *******************                                                       BUG5357BUG5964
     C*******************IF        SACCD = 'I' AND X>1                          BUG5357BUG5964
     C*******************EVAL      WCTLDYN = TRMDATE(1)                         BUG5357BUG5964
     C*******************EVAL      I=1                                          BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************DOW       I<X                                          BUG5357BUG5964
     C*******************IF        TRMDATE(I) < WCTLDYN                         BUG5357BUG5964
     C*******************EVAL      WCTLDYN = TRMDATE(I)                         BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
     C*******************ADD       1             I                              BUG5357BUG5964
     C*******************ENDDO                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C                   MOVEL     SFORM         FFDATC                         BUG4646
     C                   MOVEL     SUCUCY        FFCCY1                         BUG4646
     C                   MOVEL     *BLANK        FFCCY2                         BUG4646
     C                   MOVE      *BLANK        FFCCY3                         BUG4646
     C                   Z-ADD     *ZERO         PRDT                           BUG4646
     C                   EVAL      K=X                                          BUG4646
     C                   MOVEA     TRMDATE       WMDATE                         BUG4646
     C                   EXSR      GENDATES                                     BUG4646
     C                   MOVEA     WMDATE        TRMDATE                        BUG4646
     C                   EVAL      L = 1                                        BUG4646
     C                   DOW       L < K                                        BUG4646
                                                                                BUG4646
      ** Check if it is a saturday or a sunday                                  BUG4646
      ** and treat it as holiday                                                BUG4646
                                                                                BUG4646
     C                   EVAL      WRK153 = TRMDATE(L)/7                        BUG4646
     C                   MOVE      WRK153        WRK30                          BUG4646
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG4646
     C                   EVAL      %SUBST(TRDATEA(L):7:1)='Y'                   BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      ZDAYNO =  TRMDATE(L)                         BUG4646
     C                   CALLB     'ZDATE2'                                     BUG4646
     C                   PARM                    ZDAYNO                         BUG4646
     C                   PARM                    BJDFIN                         BUG4646
     C                   PARM      *ZEROS        ZDATE                          BUG4646
     C                   PARM      *BLANKS       ZADATE            7            BUG4646
                                                                                BUG4646
     C                   MOVEL     ZDATE         TRDATEA(L)                     BUG4646
     C                   ADD       1             L                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
      ** Their Interest Payment dates                                           BUG4646
     C     STIPFR        IFEQ      'Z'                                          BUG4646
     C     TPDATEA(1)    ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'I'                               BUG4646
     C                   EVAL      WRatePay = 'P'                               BUG4646
     C                   EVAL      POurTheir= 'T'                               BUG4646
     C                   MOVEL     *BLANKS       SDATENAME                      BUG5438
     C                   MOVEL     'SDATETP'     SDATENAME                      BUG5438
     C                   MOVEL     *BLANKS       SCHEDNAME                      BUG5438
     C                   MOVEL     TheirPay      SCHEDNAME                      BUG5438
     C                   EXSR      CheckCurr                                    BUG4646
     C                   EVAL      X=%LOOKUP('        ':TPDATEA)                BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   EXSR      SRGetCtlDate                                 BUG4646
      * Default with control date                                               BUG4646
     C                   IF        X=1                                          BUG4646
     C                             and STNIPD <> *blanks                                     BUG7621
     C                   EVAL      TPDATEA(X)=STNIPD                            BUG4646
     C                   ADD       1             X                              BUG4646
     C                   ELSE                                                   BUG5964
      * Check if all dates are processed                                        BUG5964
     C                   EVAL      A=1                                          BUG5964
     C                   EVAL      B=1                                          BUG5964
     C                   DOW       A<X                                          BUG5964
     C                   IF        %SUBST(TPDATEA(A):8:1)='Y' OR                BUG5964
     C                             %SUBST(TPDATEA(A):8:1)='y'                   BUG5964
     C                   ADD       1             B                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             A                              BUG5964
     C                   ENDDO                                                  BUG5964
      * Default with control date                                               BUG5964
     C                   IF        X=B                                          BUG5964
     C                             and STNIPD <> *blanks                                     BUG7621
     C                             and STIPFR <> 'C'                                         BUG7621
     C                   EVAL      TPDATEA(X)=STNIPD                            BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG4646
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      DATESCH=TPDATEA(I)                           BUG4646
     C                   EVAL      InDate = DSDATE                              BUG4646
     C                   EVAL      CHol = DSCHOL                                BUG4646
     C                   EVAL      PDAT = DSPDAT                                BUG4646
     C                   MOVEL     DSDATE        MSGDATE                        BUG5438
     C                   EXSR      SRZEDIT                                      BUG5438
     C                   EXSR      CheckDate                                    BUG4646
                                                                                BUG4646
     C     INDATEMDN     LOOKUP    TPMDATE                                24    BUG4646
     C                   IF        *IN24 = *ON                                  BUG4646
     C                   ADD       1             Idx                            BUG4646
     C**********         MOVEL     'DLM0150'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      TPMDATE(I)=INDATEMDN                         BUG4646
     C                   EXSR      ConfHol                                      BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
                                                                                BUG5964
      * Find first non processed date                                           BUG5964
     C                   IF        Idx=0                                        BUG5964
     C                   EVAL      WCTLDYN = 0                                  BUG5964
     C                   EVAL      I=1                                          BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        %SUBST(TPDATEA(I):8:1)<>'Y' AND              BUG5964
     C                             %SUBST(TPDATEA(I):8:1)<>'y'                  BUG5964
     C                   EVAL      WCTLDYN = TPMDATE(I)                         BUG5964
     C                   Eval      UPTPSCH = 'Y'                                             BUG7621
     C                   LEAVE                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
      ** Error if both cashflow and int. payment schedule records exist,                     BUG7621
      ** Frequency doesn't match up with schedule records                                    BUG7621
     C                   If        UPTPSCH = 'Y'                                             BUG7621
     C                             and STIPFR = 'C'                                          BUG7621
     C                   ADD       1             Idx                                         BUG7621
     C                   EVAL      FldNameArr(Idx) = 'STIPFR'                                BUG7621
     C                   MOVEL     'DLM2013'     MsgIDArr(Idx)                               BUG7621
     C                   Else                                                                BUG7621
      *                                                                                      BUG7621
     C                   EVAL      I=1                                          BUG5964
                                                                                BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        TPMDATE(I) < WCTLDYN AND                     BUG5964
     C                             %SUBST(TPDATEA(I):8:1)<>'Y' AND              BUG5964
     C                             %SUBST(TPDATEA(I):8:1)<>'y'                  BUG5964
     C                   EVAL      WCTLDYN = TPMDATE(I)                         BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
     C                   IF        WCTLDYN <> 0                                 BUG5964
     C                   EVAL      ZDAYNO =  WCTLDYN                            BUG5964
     C                   CALLB     'ZDATE2'                                     BUG5964
     C                   PARM                    ZDAYNO                         BUG5964
     C                   PARM                    BJDFIN                         BUG5964
     C                   PARM      *ZEROS        ZDATE                          BUG5964
     C                   PARM      *BLANKS       ZADATE                         BUG5964
                                                                                BUG5964
     C                   MOVEL     ZDATE         CZDATE                         BUG5964
     C                   IF        CZDATE <> STNIPD                             BUG5964
     C                   MOVEL     ZDATE         STNIPD                         BUG5964
     C                   EVAL      RSTNIPD=ZDAYNO                               BUG5964
     C                   If        STIPFR = *blanks                                          BUG7621
     C                   Eval      STIPFR = 'Z'                                              BUG7621
     C                   Eval      RSTIPFR = 'Z'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'STNIPD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0603'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                            MD031224
      * Display warning if date falls on holiday                                            MD031224
     C                   EVAL      InDate = CZDATE                                          MD031224
     C                   EXSR      CheckDate                                                MD031224
     C                   IF        WHoliday='Y'                                             MD031224
     C                   ADD       1             WIdx                                       MD031224
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA1113'                              MD031224
     C                   EVAL      WFldNamArr(WIdx) = 'STNIPD'                              MD031224
     C                   EVAL      WMsgDtaArr(WIdx) = SUCUCY                                MD031224
     C                   ENDIF                                                              MD031224
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   EndIf                                                               BUG7621
     C                   ENDIF                                                  BUG5964
                                                                                BUG4646
      * Validate formula                                                        BUG4646
     C                   IF        Idx=0                                        BUG4646
     C                   EVAL      SFREQF = SFREQFTP                            BUG4646
     C                   EVAL      SFORM = SFORMTP                              BUG4646
     C                   MOVEL     *BLANKS       SFORMNAME                      BUG5357
     C                   MOVEL     'SFREQFTP'    SFORMNAME                      BUG5357
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR              BUG4646
     C                             SFREQF = 'X' OR SFREQF = 'Y'                 BUG4646
     C                   EXSR      ValFormula                                   BUG4646
                                                                                BUG4646
      * Generate Dates                                                          BUG4646
     C                   IF        Idx=0 AND SFORM <> *BLANKS                   BUG4646
      *******************                                                       BUG5357BUG5964
     C*******************IF        SACCD = 'I' AND X>1                          BUG5357BUG5964
     C*******************EVAL      WCTLDYN = TPMDATE(1)                         BUG5357BUG5964
     C*******************EVAL      I=1                                          BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************DOW       I<X                                          BUG5357BUG5964
     C*******************IF        TPMDATE(I) < WCTLDYN                         BUG5357BUG5964
     C*******************EVAL      WCTLDYN = TPMDATE(I)                         BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
     C*******************ADD       1             I                              BUG5357BUG5964
     C*******************ENDDO                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C                   MOVEL     SFORM         FFDATC                         BUG4646
     C                   MOVEL     WRSCY         FFCCY1                         BUG4646
     C                   MOVEL     *BLANK        FFCCY2                         BUG4646
     C                   MOVE      *BLANK        FFCCY3                         BUG4646
     C                   Z-ADD     *ZERO         PRDT                           BUG4646
     C                   EVAL      K=X                                          BUG4646
     C                   MOVEA     TPMDATE       WMDATE                         BUG4646
     C                   EXSR      GENDATES                                     BUG4646
     C                   MOVEA     WMDATE        TPMDATE                        BUG4646
     C                   EVAL      L = 1                                        BUG4646
     C                   DOW       L < K                                        BUG4646
                                                                                BUG4646
      ** Check if it is a saturday or a sunday                                  BUG4646
      ** and treat it as holiday                                                BUG4646
                                                                                BUG4646
     C                   EVAL      WRK153 = TPMDATE(L)/7                        BUG4646
     C                   MOVE      WRK153        WRK30                          BUG4646
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG4646
     C                   EVAL      %SUBST(TPDATEA(L):7:1)='Y'                   BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      ZDAYNO =  TPMDATE(L)                         BUG4646
     C                   CALLB     'ZDATE2'                                     BUG4646
     C                   PARM                    ZDAYNO                         BUG4646
     C                   PARM                    BJDFIN                         BUG4646
     C                   PARM      *ZEROS        ZDATE                          BUG4646
     C                   PARM      *BLANKS       ZADATE            7            BUG4646
                                                                                BUG4646
     C                   MOVEL     ZDATE         TPDATEA(L)                     BUG4646
     C                   ADD       1             L                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
      ** Our cash flow                                                          BUG4646
     C     SUIPFR        IFEQ      'C'                                          BUG4646
     C     OCFSA(1)      ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'C'                               BUG4646
     C                   EVAL      POurTheir= 'U'                               BUG4646
     C                   MOVEL     *BLANKS       SDATENAME                      BUG5438
     C                   MOVEL     'SDATEOC'     SDATENAME                      BUG5438
     C                   MOVEL     *BLANKS       SCHEDNAME                      BUG5438
     C                   MOVEL     OurCash       SCHEDNAME                      BUG5438
     C                   EXSR      CheckCurr                                    BUG4646
     C                   EVAL      X=%LOOKUP('        ':OCFSA)                  BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   EXSR      SRGetCtlDate                                 BUG4646
      * Default with control date                                               BUG5964
     C                   IF        X=1                                          BUG5964
     C                             and SUNIPD <> *blanks                                     BUG7621
     C                   EVAL      OCFSA(X)=SUNIPD                              BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ELSE                                                   BUG5964
      * Check if all dates are processed                                        BUG5964
     C                   EVAL      A=1                                          BUG5964
     C                   EVAL      B=1                                          BUG5964
     C                   DOW       A<X                                          BUG5964
     C                   IF        %SUBST(OCFSA(A):22:1)='Y' OR                 BUG5964
     C                             %SUBST(OCFSA(A):22:1)='y'                    BUG5964
     C                   ADD       1             B                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             A                              BUG5964
     C                   ENDDO                                                  BUG5964
      * Default with control date                                               BUG5964
     C                   IF        X=B                                          BUG5964
     C                             and SUNIPD <> *blanks                                     BUG7621
     C                             and SUIPFR <> 'Z'                                         BUG7621
     C                   EVAL      OCFSA(X)=SUNIPD                              BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      CASHFSCH=OCFSA(I)                            BUG4646
     C                   EVAL      InDate = CFDATE                              BUG4646
     C                   EVAL      CHol = CFCHOL                                BUG4646
     C                   EVAL      WAmount=*BLANKS                              BUG4646
     C                   EVAL      WAmount=CFAMT                                BUG4646
      *                                                                                       245692
     C     WAmount       IFEQ      *BLANKS                                                    245692
     C     FORMULAOC     ANDNE     *BLANKS                                                    245692
     C                   EVAL      WAmount=SFORMAMTOC                                         245692
     C                   ENDIF                                                                245692
      *                                                                                       245692
     C                   EVAL      PDAT = CFPDAT                                BUG4646
     C                   MOVEL     CFDATE        MSGDATE                        BUG5438
     C                   EXSR      SRZEDIT                                      BUG5438
     C                   EXSR      CheckDate                                    BUG4646
                                                                                BUG4646
     C     INDATEMDN     LOOKUP    OCFMDAT                                24    BUG4646
     C                   IF        *IN24 = *ON                                  BUG4646
     C                   ADD       1             Idx                            BUG4646
     C**********         MOVEL     'DLM0150'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      OCFMDAT(I)=INDATEMDN                         BUG4646
     C                   EXSR      ConfHol                                      BUG4646
     C                   MOVEL     *BLANKS       SFORMAMT         10            BUG5357
     C                   MOVEL     'SAMT'        SFORMAMT                       BUG5357
     C                   EXSR      CheckAmt                                     BUG4646
     C                   MOVE      PZFIELD       OCFAMT(I)                      BUG4646
     C                   IF        WZFIELD <> *BLANKS                           BUG5610
     C                   MOVE      WZFIELD       WAMT14           14            BUG5610
     C                   EVAL      %SUBST(OCFSA(I):8:14)=WAMT14                 BUG5610
     C                   ENDIF                                                  BUG5610
                                                                                BUG5610
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
                                                                                BUG5964
      * Find first non processed date                                           BUG5964
     C                   IF        Idx=0                                        BUG5964
     C                   EVAL      WCTLDYN = 0                                  BUG5964
     C                   EVAL      I=1                                          BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        %SUBST(OCFSA(I):22:1)<>'Y' AND               BUG5964
     C                             %SUBST(OCFSA(I):22:1)<>'y'                   BUG5964
     C                   EVAL      WCTLDYN = OCFMDAT(I)                         BUG5964
     C                   Eval      UPOCSCH = 'Y'                                             BUG7621
     C                   LEAVE                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
      ** Error if both cashflow and int. payment schedule records exist,                     BUG7621
      ** Frequency doesn't match up with schedule records                                    BUG7621
     C                   If        UPOCSCH = 'Y'                                             BUG7621
     C                             and SUIPFR = 'Z'                                          BUG7621
     C                   ADD       1             Idx                                         BUG7621
     C                   EVAL      FldNameArr(Idx) = 'SUIPFR'                                BUG7621
     C                   MOVEL     'DLM2014'     MsgIDArr(Idx)                               BUG7621
     C                   Else                                                                BUG7621
      *                                                                                      BUG7621
     C                   EVAL      I=1                                          BUG5964
                                                                                BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        OCFMDAT(I) < WCTLDYN AND                     BUG5964
     C                             %SUBST(OCFSA(I):22:1)<>'Y' AND               BUG5964
     C                             %SUBST(OCFSA(I):22:1)<>'y'                   BUG5964
     C                   EVAL      WCTLDYN = OCFMDAT(I)                         BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
     C                   IF        WCTLDYN <> 0                                 BUG5964
     C                   EVAL      ZDAYNO =  WCTLDYN                            BUG5964
     C                   CALLB     'ZDATE2'                                     BUG5964
     C                   PARM                    ZDAYNO                         BUG5964
     C                   PARM                    BJDFIN                         BUG5964
     C                   PARM      *ZEROS        ZDATE                          BUG5964
     C                   PARM      *BLANKS       ZADATE                         BUG5964
                                                                                BUG5964
     C                   MOVEL     ZDATE         CZDATE                         BUG5964
     C                   IF        CZDATE <> SUNIPD                             BUG5964
     C                   MOVEL     ZDATE         SUNIPD                         BUG5964
     C                   EVAL      RSUNIPD=ZDAYNO                               BUG5964
     C                   If        SUIPFR = *Blanks                                          BUG7621
     C                   Eval      SUIPFR = 'C'                                              BUG7621
     C                   Eval      RSUIPFR = 'C'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'SUNIPD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0601'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   EndIf                                                               BUG7621
     C                   ENDIF                                                  BUG5964
                                                                                BUG4646
      * Validate formula                                                        BUG4646
     C                   IF        Idx=0                                        BUG4646
     C                   EVAL      SFREQF = SFREQFOC                            BUG4646
     C                   EVAL      SFORM = SFORMOC                              BUG4646
     C                   MOVEL     *BLANKS       SFORMNAME                      BUG5357
     C                   MOVEL     'SFREQFOC'    SFORMNAME                      BUG5357
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR              BUG4646
     C                             SFREQF = 'X' OR SFREQF = 'Y'                 BUG4646
     C                   EXSR      ValFormula                                   BUG4646
                                                                                BUG4646
      * Generate Dates                                                          BUG4646
     C                   IF        Idx=0 AND SFORM <> *BLANKS                   BUG4646
      * Amount must be specified                                                BUG5357
     C                   IF        SFORMAMTOC <> *BLANKS                        BUG5357
     C                   EVAL      WAmount=*BLANKS                              BUG5357
     C                   EVAL      WAmount=SFORMAMTOC                           BUG5357
     C                   MOVEL     *BLANKS       SFORMAMT                       BUG5357
     C                   MOVEL     'SFORMAMTOC'  SFORMAMT                       BUG5357
     C                   EXSR      CheckAmt                                     BUG5357
     C                   IF        WZFIELD <> *BLANKS                           BUG5610
     C                   MOVE      WZFIELD       SFORMAMTOC                     BUG5610
     C                   ENDIF                                                  BUG5610
                                                                                BUG5610
     C                   ELSE                                                   BUG5357
     C                   ADD       1             Idx                            BUG5357
     C                   MOVEL     'DLM0148'     MsgIDArr(Idx)                  BUG5357
     C                   EVAL      FldNameArr(Idx) = 'SFORMAMTOC'               BUG5357
     C                   ENDIF                                                  BUG5357
      *                                                                         BUG5357
     C                   IF        Idx=0                                        BUG5357
     C                   IF        X<>1                                         BUG4646
      *******************                                                       BUG5357BUG5964
     C*******************IF        SACCD = 'I' AND X>1                          BUG5357BUG5964
     C*******************EVAL      WCTLDYN = OCFMDAT(1)                         BUG5357BUG5964
     C*******************EVAL      I=1                                          BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************DOW       I<X                                          BUG5357BUG5964
     C*******************IF        OCFMDAT(I) < WCTLDYN                         BUG5357BUG5964
     C*******************EVAL      WCTLDYN = OCFMDAT(I)                         BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
     C*******************ADD       1             I                              BUG5357BUG5964
     C*******************ENDDO                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C                   MOVEL     SFORM         FFDATC                         BUG4646
     C                   MOVEL     WPSCY         FFCCY1                         BUG4646
     C                   MOVEL     *BLANK        FFCCY2                         BUG4646
     C                   MOVE      *BLANK        FFCCY3                         BUG4646
     C                   Z-ADD     *ZERO         PRDT                           BUG4646
     C                   EVAL      K=X                                          BUG4646
     C                   MOVEA     OCFMDAT       WMDATE                         BUG4646
     C                   MOVEA     OCFAMT        WCFAMT                         BUG5357
     C                   EXSR      GENDATES                                     BUG4646
     C                   MOVEA     WCFAMT        OCFAMT                         BUG5357
     C                   MOVEA     WMDATE        OCFMDAT                        BUG4646
     C                   EVAL      L = 1                                        BUG4646
     C                   DOW       L < K                                        BUG4646
                                                                                BUG4646
      ** Check if it is a saturday or a sunday                                  BUG4646
      ** and treat it as holiday                                                BUG4646
                                                                                BUG4646
     C                   EVAL      WRK153 = OCFMDAT(L)/7                        BUG4646
     C                   MOVE      WRK153        WRK30                          BUG4646
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG4646
     C                   EVAL      %SUBST(OCFSA(L):7:1)='Y'                     BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      ZDAYNO =  OCFMDAT(L)                         BUG4646
     C                   CALLB     'ZDATE2'                                     BUG4646
     C                   PARM                    ZDAYNO                         BUG4646
     C                   PARM                    BJDFIN                         BUG4646
     C                   PARM      *ZEROS        ZDATE                          BUG4646
     C                   PARM      *BLANKS       ZADATE            7            BUG4646
                                                                                BUG4646
     C                   MOVEL     ZDATE         OCFSA(L)                       BUG4646
     C                   ADD       1             L                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ELSE                                                   BUG4646
     C                   ADD       1             Idx                            BUG4646
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)                  BUG4646
     C*******************EVAL      FldNameArr(Idx) = 'SFORM'                    BUG4646BUG5357
     C                   EVAL      FldNameArr(Idx) = 'SFREQFOC'                 BUG5357
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG5357
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
      ** Their cash flow                                                        BUG4646
     C     STIPFR        IFEQ      'C'                                          BUG4646
     C     TCFSA(1)      ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'C'                               BUG4646
     C                   EVAL      POurTheir= 'T'                               BUG4646
     C                   MOVEL     *BLANKS       SDATENAME                      BUG5438
     C                   MOVEL     'SDATETC'     SDATENAME                      BUG5438
     C                   MOVEL     *BLANKS       SCHEDNAME                      BUG5438
     C                   MOVEL     TheirCash     SCHEDNAME                      BUG5438
     C                   EXSR      CheckCurr                                    BUG4646
     C                   EVAL      X=%LOOKUP('        ':TCFSA)                  BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   EXSR      SRGetCtlDate                                 BUG4646
      * Default with control date                                               BUG5964
     C                   IF        X=1                                          BUG5964
     C                             and STNIPD <> *blanks                                     BUG7621
     C                   EVAL      TCFSA(X)=STNIPD                              BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ELSE                                                   BUG5964
      * Check if all dates are processed                                        BUG5964
     C                   EVAL      A=1                                          BUG5964
     C                   EVAL      B=1                                          BUG5964
     C                   DOW       A<X                                          BUG5964
     C                   IF        %SUBST(TCFSA(A):22:1)='Y' OR                 BUG5964
     C                             %SUBST(TCFSA(A):22:1)='y'                    BUG5964
     C                   ADD       1             B                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             A                              BUG5964
     C                   ENDDO                                                  BUG5964
      * Default with control date                                               BUG5964
     C                   IF        X=B                                          BUG5964
     C                             and STNIPD <> *blanks                                     BUG7621
     C                             and STIPFR <> 'Z'                                         BUG7621
     C                   EVAL      TCFSA(X)=STNIPD                              BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      CASHFSCH=TCFSA(I)                            BUG4646
     C                   EVAL      InDate = CFDATE                              BUG4646
     C                   EVAL      CHol = CFCHOL                                BUG4646
     C                   EVAL      WAmount=*BLANKS                              BUG4646
     C                   EVAL      WAmount=CFAMT                                BUG4646
      *                                                                                       245692
     C     WAmount       IFEQ      *BLANKS                                                    245692
     C     FORMULATC     ANDNE     *BLANKS                                                    245692
     C                   EVAL      WAmount=SFORMAMTTC                                         245692
     C                   ENDIF                                                                245692
      *                                                                                       245692
     C                   EVAL      PDAT = CFPDAT                                BUG4646
     C                   MOVEL     CFDATE        MSGDATE                        BUG5438
     C                   EXSR      SRZEDIT                                      BUG5438
     C                   EXSR      CheckDate                                    BUG4646
                                                                                BUG4646
     C     INDATEMDN     LOOKUP    TCFMDAT                                24    BUG4646
     C                   IF        *IN24 = *ON                                  BUG4646
     C                   ADD       1             Idx                            BUG4646
     C**********         MOVEL     'DLM0150'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      TCFMDAT(I)=INDATEMDN                         BUG4646
     C                   EXSR      ConfHol                                      BUG4646
     C                   MOVEL     *BLANKS       SFORMAMT                       BUG5357
     C                   MOVEL     'SAMT'        SFORMAMT                       BUG5357
     C                   EXSR      CheckAmt                                     BUG4646
     C                   MOVE      PZFIELD       TCFAMT(I)                      BUG4646
     C                   IF        WZFIELD <> *BLANKS                           BUG5610
     C                   MOVE      WZFIELD       WAMT14                         BUG5610
     C                   EVAL      %SUBST(TCFSA(I):8:14)=WAMT14                 BUG5610
     C                   ENDIF                                                  BUG5610
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
                                                                                BUG5964
      * Find first non processed date                                           BUG5964
     C                   IF        Idx=0                                        BUG5964
     C                   EVAL      WCTLDYN = 0                                  BUG5964
     C                   EVAL      I=1                                          BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        %SUBST(TCFSA(I):22:1)<>'Y' AND               BUG5964
     C                             %SUBST(TCFSA(I):22:1)<>'y'                   BUG5964
     C                   EVAL      WCTLDYN = TCFMDAT(I)                         BUG5964
     C                   Eval      UPTCSCH = 'Y'                                             BUG7621
     C                   LEAVE                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
      ** Error if both cashflow and int. payment schedule records exist,                     BUG7621
      ** Frequency doesn't match up with schedule records                                    BUG7621
     C                   If        UPTCSCH = 'Y'                                             BUG7621
     C                             and STIPFR = 'Z'                                          BUG7621
     C                   ADD       1             Idx                                         BUG7621
     C                   EVAL      FldNameArr(Idx) = 'STIPFR'                                BUG7621
     C                   MOVEL     'DLM2015'     MsgIDArr(Idx)                               BUG7621
     C                   Else                                                                BUG7621
      *                                                                                      BUG7621
     C                   EVAL      I=1                                          BUG5964
                                                                                BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        TCFMDAT(I) < WCTLDYN AND                     BUG5964
     C                             %SUBST(TCFSA(I):22:1)<>'Y' AND               BUG5964
     C                             %SUBST(TCFSA(I):22:1)<>'y'                   BUG5964
     C                   EVAL      WCTLDYN = TCFMDAT(I)                         BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
     C                   IF        WCTLDYN <> 0                                 BUG5964
     C                   EVAL      ZDAYNO =  WCTLDYN                            BUG5964
     C                   CALLB     'ZDATE2'                                     BUG5964
     C                   PARM                    ZDAYNO                         BUG5964
     C                   PARM                    BJDFIN                         BUG5964
     C                   PARM      *ZEROS        ZDATE                          BUG5964
     C                   PARM      *BLANKS       ZADATE                         BUG5964
                                                                                BUG5964
     C                   MOVEL     ZDATE         CZDATE                         BUG5964
     C                   IF        CZDATE <> STNIPD                             BUG5964
     C                   MOVEL     ZDATE         STNIPD                         BUG5964
     C                   EVAL      RSTNIPD=ZDAYNO                               BUG5964
     C                   If        STIPFR = *Blanks                                          BUG7621
     C                   Eval      STIPFR = 'C'                                              BUG7621
     C                   Eval      RSTIPFR = 'C'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'STNIPD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0603'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   EndIf                                                               BUG7621
     C                   ENDIF                                                  BUG5964
                                                                                BUG4646
      * Validate formula                                                        BUG4646
     C                   IF        Idx=0                                        BUG4646
     C                   EVAL      SFREQF = SFREQFTC                            BUG4646
     C                   EVAL      SFORM = SFORMTC                              BUG4646
     C                   MOVEL     *BLANKS       SFORMNAME                      BUG5357
     C                   MOVEL     'SFREQFTC'    SFORMNAME                      BUG5357
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR              BUG4646
     C                             SFREQF = 'X' OR SFREQF = 'Y'                 BUG4646
     C                   EXSR      ValFormula                                   BUG4646
                                                                                BUG4646
      * Generate Dates                                                          BUG4646
     C                   IF        Idx=0 AND SFORM <> *BLANKS                   BUG4646
      * Amount must be specified                                                BUG5357
     C                   IF        SFORMAMTTC <> *BLANKS                        BUG5357
     C                   EVAL      WAmount=*BLANKS                              BUG5357
     C                   EVAL      WAmount=SFORMAMTTC                           BUG5357
     C                   MOVEL     *BLANKS       SFORMAMT                       BUG5357
     C                   MOVEL     'SFORMAMTTC'  SFORMAMT                       BUG5357
     C                   EXSR      CheckAmt                                     BUG5357
     C                   IF        WZFIELD <> *BLANKS                           BUG5610
     C                   MOVE      WZFIELD       SFORMAMTTC                     BUG5610
     C                   ENDIF                                                  BUG5610
                                                                                BUG5610
     C                   ELSE                                                   BUG5357
     C                   ADD       1             Idx                            BUG5357
     C                   MOVEL     'DLM0148'     MsgIDArr(Idx)                  BUG5357
     C                   EVAL      FldNameArr(Idx) = 'SFORMAMTTC'               BUG5357
     C                   ENDIF                                                  BUG5357
      *                                                                         BUG5357
     C                   IF        Idx=0                                        BUG5357
     C                   IF        X<>1                                         BUG4646
      *******************                                                       BUG5357BUG5964
     C*******************IF        SACCD = 'I' AND X>1                          BUG5357BUG5964
     C*******************EVAL      WCTLDYN = TCFMDAT(1)                         BUG5357BUG5964
     C*******************EVAL      I=1                                          BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************DOW       I<X                                          BUG5357BUG5964
     C*******************IF        TCFMDAT(I) < WCTLDYN                         BUG5357BUG5964
     C*******************EVAL      WCTLDYN = TCFMDAT(I)                         BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
     C*******************ADD       1             I                              BUG5357BUG5964
     C*******************ENDDO                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C                   MOVEL     SFORM         FFDATC                         BUG4646
     C                   MOVEL     WRSCY         FFCCY1                         BUG4646
     C                   MOVEL     *BLANK        FFCCY2                         BUG4646
     C                   MOVE      *BLANK        FFCCY3                         BUG4646
     C                   Z-ADD     *ZERO         PRDT                           BUG4646
     C                   EVAL      K=X                                          BUG4646
     C                   MOVEA     TCFMDAT       WMDATE                         BUG4646
     C                   MOVEA     TCFAMT        WCFAMT                         BUG5357
     C                   EXSR      GENDATES                                     BUG4646
     C                   MOVEA     WCFAMT        TCFAMT                         BUG5357
     C                   MOVEA     WMDATE        TCFMDAT                        BUG4646
     C                   EVAL      L = 1                                        BUG4646
     C                   DOW       L < K                                        BUG4646
                                                                                BUG4646
      ** Check if it is a saturday or a sunday                                  BUG4646
      ** and treat it as holiday                                                BUG4646
                                                                                BUG4646
     C                   EVAL      WRK153 = TCFMDAT(L)/7                        BUG4646
     C                   MOVE      WRK153        WRK30                          BUG4646
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG4646
     C                   EVAL      %SUBST(TCFSA(L):7:1)='Y'                     BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      ZDAYNO =  TCFMDAT(L)                         BUG4646
     C                   CALLB     'ZDATE2'                                     BUG4646
     C                   PARM                    ZDAYNO                         BUG4646
     C                   PARM                    BJDFIN                         BUG4646
     C                   PARM      *ZEROS        ZDATE                          BUG4646
     C                   PARM      *BLANKS       ZADATE            7            BUG4646
                                                                                BUG4646
     C                   MOVEL     ZDATE         TCFSA(L)                       BUG4646
     C                   ADD       1             L                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ELSE                                                   BUG4646
     C                   ADD       1             Idx                            BUG4646
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)                  BUG4646
     C*******************EVAL      FldNameArr(Idx) = 'SFORM'                    BUG4646BUG5357
     C                   EVAL      FldNameArr(Idx) = 'SFREQFTC'                 BUG5357
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG5357
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
      ************************                                                  BUG4646
      ***Validate*Our*Rate*Change Dates                                         BUG4646
      ************************                                                  BUG4646
      ***Invalid*if*Our*Rate*Change Frequency indicator not 'Z'                 BUG4646
      ************************                                                  BUG4646
     C*****ORDatesAlp****IFNE*     *BLANKS                                      BUG4646
     C*****ORDatesAlp****ANDNE     *ZEROS                                       BUG4646
     C*****RSUICFR*******ANDNE     'Z'                                          BUG4646
     C*******************MOVE*     'N'           OKInRatCal                     BUG4646
     C*******************ADD**     1             Idx                            BUG4646
     C*******************EVAL*     FldNameArr(Idx) = 'SUICFR'                   BUG4646
     C*******************EVAL*     MsgIDArr(Idx) = 'MMA0678'                    BUG4646
     C*******************ELSE*                                                  BUG4646
      ************************                                                  BUG4646
     C*****RSUICFR*******IFEQ*     'Z'                                          BUG4646
     C*******************CALLB     'IRVIRCVAL'                                  BUG4646
      ***Following*parameters*are output to called module                       BUG4646
      ***Return*Code**********                                                  BUG4646
     C*******************PARM*                   ReturnCode                     BUG4646
      ***Valid*Value*date*in*5,0 format                                         BUG4646
     C*******************PARM*                   RSVDAT                         BUG4646
      ***Valid*Maturity*date*in 5,0 format                                      BUG4646
     C*******************PARM*                   RSMDAT                         BUG4646
      ***Date*format*indicator                                                  BUG4646
     C*******************PARM*                   BJDFIN                         BUG4646
      ***Our*Rate*Change*dates (82 x 6A)                                        BUG4646
     C*******************PARM*     ORDatesAlp    DatesToVal                     BUG4646
      ***Following*parameters*are returned by called module                     BUG4646
      ***IRC*Dates*OK*flag****                                                  BUG4646
     C*******************PARM*                   OKInRatCal                     BUG4646
      ***Error*fields/message*IDs (arrays) from/to caller                       BUG4646
     C*******************PARM*                   FldNameArr                     BUG4646
     C*******************PARM*                   MsgIDArr                       BUG4646
      ***Array*index*(3P0)*from/to caller                                       BUG4646
     C*******************PARM*                   Idx                            BUG4646
      ***Our*Rate*Change*dates in day number format (82 x 3A)                   BUG4646
     C*******************PARM*                   ValidDates                     BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
     C*****OKInRatCal****IFNE*     'Y'                                          BUG4646
     C*******************GOTO*     ValIRCExit                                   BUG4646
     C*******************ELSE*                                                  BUG4646
     C*******************MOVE*     ValidDates    ORDates                        BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
      ***Validate*Our*Interest Payment Dates                                    BUG4646
      ************************                                                  BUG4646
      ***Invalid*if*Our*Interest Payment Frequency indicator not 'Z'            BUG4646
      ************************                                                  BUG4646
     C*****OPDatesAlp****IFNE*     *BLANKS                                      BUG4646
     C*****OPDatesAlp****ANDNE     *ZEROS                                       BUG4646
     C*****RSUIPFR*******ANDNE     'Z'                                          BUG4646
     C*******************MOVE*     'N'           OKInRatCal                     BUG4646
     C*******************ADD**     1             Idx                            BUG4646
     C*******************EVAL*     FldNameArr(Idx) = 'SUIPFR'                   BUG4646
     C*******************EVAL*     MsgIDArr(Idx) = 'MMA0678'                    BUG4646
     C*******************ELSE*                                                  BUG4646
      ************************                                                  BUG4646
     C*****RSUIPFR*******IFEQ*     'Z'                                          BUG4646
     C*******************CALLB     'IRVIRCVAL'                                  BUG4646
      ***Following*parameters*are output to called module                       BUG4646
      ***Return*Code**********                                                  BUG4646
     C*******************PARM*                   ReturnCode                     BUG4646
      ***Valid*Value*date*in*5,0 format                                         BUG4646
     C*******************PARM*                   RSVDAT                         BUG4646
      ***Valid*Maturity*date*in 5,0 format                                      BUG4646
     C*******************PARM*                   RSMDAT                         BUG4646
      ***Date*format*indicator                                                  BUG4646
     C*******************PARM*                   BJDFIN                         BUG4646
      ***Our*Interest*Payment*dates                                             BUG4646
     C*******************PARM*     OPDatesAlp    DatesToVal                     BUG4646
      ***Following*parameters*are returned by called module                     BUG4646
      ***IRC*Dates*OK*flag****                                                  BUG4646
     C*******************PARM*                   OKInRatCal                     BUG4646
      ***Error*fields/message*IDs (arrays) from/to caller                       BUG4646
     C*******************PARM*                   FldNameArr                     BUG4646
     C*******************PARM*                   MsgIDArr                       BUG4646
      ***Array*index*(3P0)*from/to caller                                       BUG4646
     C*******************PARM*                   Idx                            BUG4646
      ***Our*Interest*Payment*dates in day number format (82 x 3A)              BUG4646
     C*******************PARM*                   ValidDates                     BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
     C*****OKInRatCal****IFNE*     'Y'                                          BUG4646
     C*******************GOTO*     ValIRCExit                                   BUG4646
     C*******************ELSE*                                                  BUG4646
     C*******************MOVE*     ValidDates    OPDates                        BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
      ***Validate*Their*Rate*Change Dates                                       BUG4646
      ************************                                                  BUG4646
      ***Invalid*if*Their*Rate Change Frequency indicator not 'Z'               BUG4646
      ************************                                                  BUG4646
     C*****TRDatesAlp****IFNE*     *BLANKS                                      BUG4646
     C*****TRDatesAlp****ANDNE     *ZEROS                                       BUG4646
     C*****RSTICFR*******ANDNE     'Z'                                          BUG4646
     C*******************MOVE*     'N'           OKInRatCal                     BUG4646
     C*******************ADD**     1             Idx                            BUG4646
     C*******************EVAL*     FldNameArr(Idx) = 'STICFR'                   BUG4646
     C*******************EVAL*     MsgIDArr(Idx) = 'MMA0678'                    BUG4646
     C*******************ELSE*                                                  BUG4646
      ************************                                                  BUG4646
     C*****RSTICFR*******IFEQ*     'Z'                                          BUG4646
     C*******************CALLB     'IRVIRCVAL'                                  BUG4646
      ***Following*parameters*are output to called module                       BUG4646
      ***Return*Code**********                                                  BUG4646
     C*******************PARM*                   ReturnCode                     BUG4646
      ***Valid*Value*date*in*5,0 format                                         BUG4646
     C*******************PARM*                   RSVDAT                         BUG4646
      ***Valid*Maturity*date*in 5,0 format                                      BUG4646
     C*******************PARM*                   RSMDAT                         BUG4646
      ***Date*format*indicator                                                  BUG4646
     C*******************PARM*                   BJDFIN                         BUG4646
      ***Their*Rate*Change*dates                                                BUG4646
     C*******************PARM*     TRDatesAlp    DatesToVal                     BUG4646
      ***Following*parameters*are returned by called module                     BUG4646
      ***IRC*Dates*OK*flag****                                                  BUG4646
     C*******************PARM*                   OKInRatCal                     BUG4646
      ***Error*fields/message*IDs (arrays) from/to caller                       BUG4646
     C*******************PARM*                   FldNameArr                     BUG4646
     C*******************PARM*                   MsgIDArr                       BUG4646
      ***Array*index*(3P0)*from/to caller                                       BUG4646
     C*******************PARM*                   Idx                            BUG4646
      ***Their*Rate*Change*dates in day number format (82 x 3A)                 BUG4646
     C*******************PARM*                   ValidDates                     BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
     C*****OKInRatCal****IFNE*     'Y'                                          BUG4646
     C*******************GOTO*     ValIRCExit                                   BUG4646
     C*******************ELSE*                                                  BUG4646
     C*******************MOVE*     ValidDates    TRDates                        BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
      ***Validate*Their*Interest Payment Dates                                  BUG4646
      ************************                                                  BUG4646
      ***Invalid*if*Their*Interest Payment Frequency indicator not 'Z'          BUG4646
      ************************                                                  BUG4646
     C*****TPDatesAlp****IFNE*     *BLANKS                                      BUG4646
     C*****TPDatesAlp****ANDNE     *ZEROS                                       BUG4646
     C*****RSTIPFR*******ANDNE     'Z'                                          BUG4646
     C*******************MOVE*     'N'           OKInRatCal                     BUG4646
     C*******************ADD**     1             Idx                            BUG4646
     C*******************EVAL*     FldNameArr(Idx) = 'STIPFR'                   BUG4646
     C*******************EVAL*     MsgIDArr(Idx) = 'MMA0678'                    BUG4646
     C*******************ELSE*                                                  BUG4646
      ************************                                                  BUG4646
     C*****RSTIPFR*******IFEQ*     'Z'                                          BUG4646
     C*******************CALLB     'IRVIRCVAL'                                  BUG4646
      ***Following*parameters*are output to called module                       BUG4646
      ***Return*Code**********                                                  BUG4646
     C*******************PARM*                   ReturnCode                     BUG4646
      ***Valid*Value*date*in*5,0 format                                         BUG4646
     C*******************PARM*                   RSVDAT                         BUG4646
      ***Valid*Maturity*date*in 5,0 format                                      BUG4646
     C*******************PARM*                   RSMDAT                         BUG4646
      ***Date*format*indicator                                                  BUG4646
     C*******************PARM*                   BJDFIN                         BUG4646
      ***Their*Interest*Payment dates                                           BUG4646
     C*******************PARM*     TPDatesAlp    DatesToVal                     BUG4646
      ***Following*parameters*are returned by called module                     BUG4646
      ***IRC*Dates*OK*flag****                                                  BUG4646
     C*******************PARM*                   OKInRatCal                     BUG4646
      ***Error*fields/message*IDs (arrays) from/to caller                       BUG4646
     C*******************PARM*                   FldNameArr                     BUG4646
     C*******************PARM*                   MsgIDArr                       BUG4646
      ***Array*index*(3P0)*from/to caller                                       BUG4646
     C*******************PARM*                   Idx                            BUG4646
      ***Their*Interest*Payment dates in day number format (82 x 3A)            BUG4646
     C*******************PARM*                   ValidDates                     BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
     C*****OKInRatCal****IFNE*     'Y'                                          BUG4646
     C*******************GOTO*     ValIRCExit                                   BUG4646
     C*******************ELSE*                                                  BUG4646
     C*******************MOVE*     ValidDates    TPDates                        BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
     C*****ValIRCExit****TAG**                                                  BUG4646
      ************************                                                  BUG4646
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    BUG4646
      *****************************************************************         BUG4646
      * ValidatePC - Routine to validate principle change date schedules        BUG4646
      *****************************************************************         BUG4646
     C     ValidatePC    BEGSR                                                  BUG4646
      ** Principle change                                                       BUG4646
     C     SONPCD        IFNE      *BLANKS                                      BUG4646
     C     PCSA(1)       ORNE      *BLANKS                                                   BUG7046
     C                   EVAL      PValType = 'P'                               BUG4646
     C****************** EVAL      POurTheir= ' '                        BUG4646BUG5964
     C*******************EVAL      POurTheir= 'U'                                    BUG5964 BUG6386
     C                   EVAL      POurTheir= ' '                                            BUG6386
     C                   MOVEL     *BLANKS       SDATENAME                      BUG5438
     C                   MOVEL     'SDATEOPC'    SDATENAME                      BUG5438
     C                   MOVEL     *BLANKS       SCHEDNAME                      BUG5438
     C                   MOVEL     PrinChg       SCHEDNAME                      BUG5438
     C                   EXSR      CheckCurr                                    BUG4646
     C                   EVAL      X=%LOOKUP('        ':PCSA)                   BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   EXSR      SRGetCtlDate                                 BUG4646
      * Default with control date                                               BUG5964
     C                   IF        X=1                                          BUG5964
     C                             and SONPCD <> *blanks                                     BUG7046
     C                   EVAL      PCSA(X)=SONPCD                               BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ELSE                                                   BUG5964
      * Check if all dates are processed                                        BUG5964
     C                   EVAL      A=1                                          BUG5964
     C                   EVAL      B=1                                          BUG5964
     C                   DOW       A<X                                          BUG5964
     C                   IF        %SUBST(PCSA(A):25:1)='Y' OR                  BUG5964
     C                             %SUBST(PCSA(A):25:1)='y'                     BUG5964
     C                   ADD       1             B                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             A                              BUG5964
     C                   ENDDO                                                  BUG5964
      * Default with control date                                               BUG5964
     C                   IF        X=B                                          BUG5964
     C                             and SONPCD <> *blanks                                     BUG7046
     C                   EVAL      PCSA(X)=SONPCD                               BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      PCHGSCH=PCSA(I)                              BUG4646
     C                   EVAL      InDate = PCDATE                              BUG4646
     C                   EVAL      CHol = PCCHOL                                BUG4646
     C                   EVAL      WAmount=*BLANKS                              BUG4646
     C                   EVAL      WAmount=PCAMT                                BUG4646
     C     WAmount       IFEQ      '0'                                                        240134
     C     WAmount       OREQ      *BLANKS                                                    240134
     C                   EVAL      WAmount=SFORMAMOPC                                         240134
     C                   ENDIF                                                                240134
     C                   EVAL      PDAT = PCPDAT                                BUG4646
                                                                                BUG4646
     C                   MOVEL     PCDATE        MSGDATE                        BUG5438
     C                   EXSR      SRZEDIT                                      BUG5438
     C                   EXSR      CheckDate                                    BUG4646
                                                                                BUG4646
     C     INDATEMDN     LOOKUP    TPCMDAT                                24    BUG4646
     C                   IF        *IN24 = *ON                                  BUG4646
     C                   ADD       1             Idx                            BUG4646
     C**********         MOVEL     'DLM0150'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      TPCMDAT(I)=INDATEMDN                         BUG4646
     C                   EXSR      ConfHol                                      BUG4646
     C                   MOVEL     *BLANKS       SFORMAMT                       BUG5357
     C                   MOVEL     'SAMT'        SFORMAMT                       BUG5357
     C                   EXSR      CheckAmt                                     BUG4646
     C                   MOVE      PZFIELD       TPCAMT(I)                      BUG4646
     C                   IF        WZFIELD <> *BLANKS                           BUG5610
     C                   MOVE      WZFIELD       WAMT16           16            BUG5610
     C                   EVAL      %SUBST(PCSA(I):8:16)=WAMT16                  BUG5610
     C                   ENDIF                                                  BUG5610
                                                                                BUG5610
     C                   EXSR      CheckInDeInd                                 BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
                                                                                BUG5964
      * Find first non processed date                                           BUG5964
     C                   IF        Idx=0                                        BUG5964
     C                   EVAL      WCTLDYN = 0                                  BUG5964
     C                   EVAL      I=1                                          BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        %SUBST(PCSA(I):25:1)<>'Y' AND                BUG5964
     C                             %SUBST(PCSA(I):25:1)<>'y'                    BUG5964
     C                   EVAL      WCTLDYN = TPCMDAT(I)                         BUG5964
     C                   LEAVE                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
     C                   EVAL      I=1                                          BUG5964
                                                                                BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        TPCMDAT(I) < WCTLDYN AND                     BUG5964
     C                             %SUBST(PCSA(I):25:1)<>'Y' AND                BUG5964
     C                             %SUBST(PCSA(I):25:1)<>'y'                    BUG5964
     C                   EVAL      WCTLDYN = TPCMDAT(I)                         BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
      *                                                                                       264029
      ** xNPCD cannot be cleared bec principal change schedule exists.                        264029
      *                                                                                       264029
     C                   If        WCTLDYN <> 0                                               264029
     C                             And SONPCD = *Blanks                                       264029
     C                   Add       1             Idx                                          264029
     C                   Eval      FldNameArr(Idx) = 'SONPCD    '                             264029
     C                   Eval      MsgIdArr(Idx) = 'RS00076'                                  264029
     C                   EndIf                                                                264029
                                                                                BUG5964
     C                   IF        WCTLDYN <> 0                                 BUG5964
     C                   EVAL      ZDAYNO =  WCTLDYN                            BUG5964
     C                   CALLB     'ZDATE2'                                     BUG5964
     C                   PARM                    ZDAYNO                         BUG5964
     C                   PARM                    BJDFIN                         BUG5964
     C                   PARM      *ZEROS        ZDATE                          BUG5964
     C                   PARM      *BLANKS       ZADATE                         BUG5964
                                                                                BUG5964
     C                   MOVEL     ZDATE         CZDATE                         BUG5964
     C                   IF        CZDATE <> SONPCD                             BUG5964
     C                   MOVEL     ZDATE         SONPCD                         BUG5964
     C                   MOVEL     ZDATE         STNPCD                         BUG5964
     C                   EVAL      RSUNPCD=ZDAYNO                               BUG5964
     C                   EVAL      RSTNPCD=ZDAYNO                               BUG5964
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'SONPCD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'RS00055'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG4646
      * Validate formula                                                        BUG4646
     C                   IF        Idx=0                                        BUG4646
     C                   EVAL      SFREQF = SFREQFOPC                           BUG4646
     C                   EVAL      SFORM = SFORMOPC                             BUG4646
     C                   MOVEL     *BLANKS       SFORMNAME                      BUG5357
     C                   MOVEL     'SFREQFOPC'   SFORMNAME                      BUG5357
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR              BUG4646
     C                             SFREQF = 'X' OR SFREQF = 'Y'                 BUG4646
     C                   EXSR      ValFormula                                   BUG4646
                                                                                BUG4646
      * Generate Dates                                                          BUG4646
     C                   IF        Idx=0 AND SFORM <> *BLANKS                   BUG4646
      * Amount must be specified                                                BUG5357
     C                   IF        SFORMAMOPC <> *BLANKS                        BUG5357
     C                   EVAL      WAmount=*BLANKS                              BUG5357
     C                   EVAL      WAmount=SFORMAMOPC                           BUG5357
     C                   MOVEL     *BLANKS       SFORMAMT                       BUG5357
     C                   MOVEL     'SFORMAMOPC'  SFORMAMT                       BUG5357
     C                   EXSR      CheckAmt                                     BUG5357
     C                   IF        WZFIELD <> *BLANKS                           BUG5610
     C                   MOVE      WZFIELD       SFORMAMOPC                     BUG5610
     C                   ENDIF                                                  BUG5610
                                                                                BUG5610
     C                   ELSE                                                   BUG5357
     C                   ADD       1             Idx                            BUG5357
     C                   MOVEL     'DLM0148'     MsgIDArr(Idx)                  BUG5357
     C                   EVAL      FldNameArr(Idx) = 'SFORMAMOPC'               BUG5357
     C                   ENDIF                                                  BUG5357
      * Increase/decrease flag must be specified                                BUG5357
     C                   IF        BGN2ST = 'Y'                                 BUG5357
     C                   IF        SFORMIDOPC = *BLANKS                         BUG5357
     C                   ADD       1             Idx                            BUG5357
     C                   MOVEL     'DLM1022'     MsgIDArr(Idx)                  BUG5357
     C                   EVAL      FldNameArr(Idx) = 'SFORMIDOPC'               BUG5357
     C                   ENDIF                                                  BUG5357
     C                   ENDIF                                                  BUG5357
      *                                                                         BUG5357
     C                   IF        Idx=0                                        BUG5357
     C                   IF        X<>1                                         BUG4646
      *******************                                                       BUG5357BUG5964
     C*******************IF        SACCD = 'I' AND X>1                          BUG5357BUG5964
     C*******************EVAL      WCTLDYN = TPCMDAT(1)                         BUG5357BUG5964
     C*******************EVAL      I=1                                          BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************DOW       I<X                                          BUG5357BUG5964
     C*******************IF        TPCMDAT(I) < WCTLDYN                         BUG5357BUG5964
     C*******************EVAL      WCTLDYN = TPCMDAT(I)                         BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
     C*******************ADD       1             I                              BUG5357BUG5964
     C*******************ENDDO                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C*******************ENDIF                                                  BUG5357BUG5964
      *******************                                                       BUG5357BUG5964
     C                   MOVEL     SFORM         FFDATC                         BUG4646
     C                   MOVEL     WPSCY         FFCCY1                         BUG4646
     C                   MOVEL     *BLANK        FFCCY2                         BUG4646
     C                   MOVE      *BLANK        FFCCY3                         BUG4646
     C                   Z-ADD     *ZERO         PRDT                           BUG4646
     C                   EVAL      K=X                                          BUG4646
     C                   MOVEA     TPCMDAT       WMDATE                         BUG4646
     C                   MOVEA     TPCAMT        WPCAMT                         BUG5357
     C                   EXSR      GENDATES                                     BUG4646
     C                   MOVEA     WPCAMT        TPCAMT                         BUG5357
     C                   MOVEA     WMDATE        TPCMDAT                        BUG4646
     C                   EVAL      L = 1                                        BUG4646
     C                   DOW       L < K                                        BUG4646
                                                                                BUG4646
      ** Check if it is a saturday or a sunday                                  BUG4646
      ** and treat it as holiday                                                BUG4646
                                                                                BUG4646
     C                   EVAL      WRK153 = TPCMDAT(L)/7                        BUG4646
     C                   MOVE      WRK153        WRK30                          BUG4646
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG4646
     C                   EVAL      %SUBST(PCSA(L):7:1)='Y'                      BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   EVAL      ZDAYNO =  TPCMDAT(L)                         BUG4646
     C                   CALLB     'ZDATE2'                                     BUG4646
     C                   PARM                    ZDAYNO                         BUG4646
     C                   PARM                    BJDFIN                         BUG4646
     C                   PARM      *ZEROS        ZDATE                          BUG4646
     C                   PARM      *BLANKS       ZADATE            7            BUG4646
                                                                                BUG4646
     C                   MOVEL     ZDATE         PCSA(L)                        BUG4646
     C                   ADD       1             L                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ELSE                                                   BUG4646
     C                   ADD       1             Idx                            BUG4646
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)                  BUG4646
     C*******************EVAL      FldNameArr(Idx) = 'SFORM'                    BUG4646BUG5357
     C                   EVAL      FldNameArr(Idx) = 'SFREQFOPC'                BUG5357
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG5357
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG4646
      *****************************************************************         BUG4646
      * CheckDate - Routine to validate date schedules                *         BUG4646
      *****************************************************************         BUG4646
     C     CheckDate     BEGSR                                                  BUG4646
     C                   EVAL      WHoliday = ' '                               BUG4646
      ** Convert date from DDMMYY to Midas day number and check                 BUG4646
      ** for valid date.                                                        BUG4646
     C                   CALLB     'ZDATE1'                                     BUG4646
     C                   PARM                    InDate                         BUG4646
     C                   PARM                    InDateMDN                      BUG4646
     C                   PARM                    BJDFIN                         BUG4646
     C                   PARM                    ErrorFlag                      BUG4646
                                                                                BUG4646
     C                   IF        ErrorFlag='Y'                                BUG4646
     C                   ADD       1             Idx                            BUG4646
     C*******************MOVEL     'DLM0142'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2003'     MsgIDArr(Idx)                  BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
      * If date is not processed, validate                                      BUG4646
     C                   IF        PDAT <> 'Y' AND PDAT <> 'y'                  BUG4646
     C* Date must be after the value date                                       BUG4646
                                                                                BUG4646
     C     InDateMDN     IFLT      RSVDAT                                       BUG4646
     C     InDateMDN     OREQ      RSVDAT                                       BUG4646
     C     PValType      ANDEQ     'R'                                          BUG4646
     C     InDateMDN     OREQ      RSVDAT                                       BUG4646
     C     PValType      ANDEQ     'P'                                          BUG4646
     C                   ADD       1             Idx                            BUG4646
     C*******************IF        PValType = 'P'                        BUG4646BUG5438
     C*******************MOVEL     'DLM0143'     MsgIDArr(Idx)           BUG4646BUG5438
     C*******************ELSE                                            BUG4646BUG5438
     C*******************MOVEL     'DLM0167'     MsgIDArr(Idx)           BUG4646BUG5438
     C*******************ENDIF                                           BUG4646BUG5438
     C                   MOVEL     'DLM2004'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C* Date must be before the maturity date                                   BUG4646
                                                                                BUG4646
     C     InDateMDN     IFGT      RSMDAT                                       BUG4646
     C     InDateMDN     OREQ      RSMDAT                                       BUG4646
     C     PValType      ANDEQ     'R'                                          BUG4646
     C                   ADD       1             Idx                            BUG4646
     C*******************MOVEL     'DLM0168'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2005'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C                   EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME             BUG5438
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
      **************************************************************************BUG4646BUG5964
      ***Date*cannot*be*less*than*the*control*date*for*principal****************BUG4646BUG5964
      ***change*****************************************************************BUG4646BUG5964
      ** Date cannot be less than the last processed date                       BUG5964
     C     InDateMDN     IFLT      WCTLDYN                                      BUG4646
     C     WCTLDYN       ANDNE     *ZEROS                                       BUG5964
     C*****PValType***** IFEQ      'P'                                          BUG4646BUG5964
     C****************** ADD       1             Idx                            BUG4646BUG5964
     C*******************MOVEL     'DLM0176'     MsgIDArr(Idx)           BUG4646BUG5438
     C****************** MOVEL     'DLM2006'     MsgIDArr(Idx)                  BUG5438BUG5964
     C****************** ELSE                                                   BUG4646BUG5964
     C                   ADD       1             Idx                            BUG4646
     C*******************MOVEL     'DLM0145'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2007'     MsgIDArr(Idx)                  BUG5438
     C****************** ENDIF                                                  BUG4646BUG5964
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
      ** Action code is 'I' and date already existing from file                 BUG4646
                                                                                BUG4646
     C                   IF         SACCD = 'I'                                 BUG4646
     C                   EVAL       WDTSCFound = 'N'                            BUG4646
     C                   EVAL       WCFSCFound = 'N'                            BUG4646
     C                   EVAL       WPCSCFound = 'N'                            BUG4646
     C                   SELECT                                                 BUG4646
     C                   WHEN      (PValType = 'R') OR (PValType = 'I')         BUG4646
     C     KIRSDV        CHAIN     DLDTSCD0                                     BUG4646
     C                   IF        %FOUND                                       BUG4646
     C                   EVAL      WDTSCFound = 'Y'                             BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   WHEN      (PValType = 'C')                             BUG4646
     C     KCFPC         CHAIN     DLCFSCD0                                     BUG4646
     C                   IF        %FOUND                                       BUG4646
     C                   EVAL      WCFSCFound = 'Y'                             BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   WHEN      (PValType = 'P')                             BUG4646
     C     KCFPC         CHAIN     DLPCSCD0                                     BUG4646
     C                   IF        %FOUND                                       BUG4646
     C                   EVAL      WPCSCFound = 'Y'                             BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDSL                                                  BUG4646
                                                                                BUG4646
     C                   IF        (WDTSCFound = 'Y') OR (WCFSCFound = 'Y') OR  BUG4646
     C                             (WPCSCFound = 'Y')                           BUG4646
     C                   ADD       1             Idx                            BUG4646
     C**********         MOVEL     'DLM0150'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   EVAL      PBDCCcyArr = PBDCCcy                         BUG4646
     C                   EVAL      WHoliday = 'N'                               BUG4646
                                                                                BUG4646
      ** Check if date is a holiday                                             BUG4646
                                                                                BUG4646
                                                                                BUG4646
     C                   IF        WVALBDC = 'N' OR                             BUG4646
     C                             WVALBDC = 'Y' AND  PBDCCcyArr(1) = *BLANK    BUG4646
     C                   Z-ADD     InDateMDN     PZDateIn                       BUG4646
     C                   CALLB     'ZCHKH'                                      BUG4646
     C                   PARM                    PZDateIn          5 0          BUG4646
     C                   PARM      SUCUCY        PZCcy             3            BUG4646
     C                   PARM      *BLANK        PZLoc             3            BUG4646
     C                   PARM      *BLANK        PZHol             1            BUG4646
                                                                                BUG4646
      ** Set a flag to be use in updating 'Confirmed Holiday' indicator         BUG4646
      ** when the date is a holiday                                             BUG4646
                                                                                BUG4646
     C                   IF        PZHol = 'H'                                  BUG4646
     C                   EVAL      WHoliday = 'Y'                               BUG4646
     C                   ELSE                                                   BUG4646
                                                                                BUG4646
      ** Else, if not a holiday, check if it is a saturday or a sunday          BUG4646
      ** and treat it as holiday                                                BUG4646
                                                                                BUG4646
     C                   EVAL      WRK153 = InDateMDN/7                         BUG4646
     C                   MOVE      WRK153        WRK30                          BUG4646
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG4646
     C                   EVAL      WHoliday = 'Y'                               BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ELSE                                                   BUG4646
                                                                                BUG4646
      ** Check date if holiday using business day convention currencies when    BUG4646
      ** CIR005 is on (for interest dates only)                                 BUG4646
                                                                                BUG4646
     C                   IF        (PValType = 'I') OR (PValType = 'R')         BUG4646
     C     1             DO        10            Y                 2 0          BUG4646
     C                   EVAL      PZCcy = PBDCCcyArr(Y)                        BUG4646
     C                   IF        PZCcy <> *BLANK                              BUG4646
     C                   Z-ADD     InDateMDN     PZDateIn                       BUG4646
     C                   CALLB     'ZCHKH'                                      BUG4646
     C                   PARM                    PZDateIn                       BUG4646
     C                   PARM                    PZCcy                          BUG4646
     C                   PARM      *BLANK        PZLoc                          BUG4646
     C                   PARM      *BLANK        PZHol                          BUG4646
     C                   IF        PZHol = 'H'                                  BUG4646
     C                   EVAL      WHoliday = 'Y'                               BUG4646
     C                   LEAVE                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   IF        WHoliday <> 'Y'                              BUG4646
     C                   Z-ADD     InDateMDN     PZDateIn                       BUG4646
     C                   CALLB     'ZCHKH'                                      BUG4646
     C                   PARM                    PZDateIn                       BUG4646
     C                   PARM      SUCUCY        PZCcy                          BUG4646
     C                   PARM      *BLANK        PZLoc                          BUG4646
     C                   PARM      *BLANK        PZHol                          BUG4646
                                                                                BUG4646
     C                   IF        PZHol = 'H'                                  BUG4646
     C                   EVAL      WHoliday = 'Y'                               BUG4646
     C                   ELSE                                                   BUG4646
                                                                                BUG4646
      ** Else, if not a holiday, check if it is a saturday or a sunday          BUG4646
      ** and treat it as holiday                                                BUG4646
                                                                                BUG4646
     C                   EVAL      WRK153 = InDateMDN/7                         BUG4646
     C                   MOVE      WRK153        WRK30                          BUG4646
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG4646
     C                   EVAL      WHoliday = 'Y'                               BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG4646
      ********************************************************************      BUG4646
      *                                                                  *      BUG4646
      * SRGetCtlDate - Get Control Date                                  *      BUG4646
      *                                                                  *      BUG4646
      ********************************************************************      BUG4646
                                                                                BUG4646
     C     SRGetCtlDate  BEGSR                                                  BUG4646
                                                                                BUG4646
     ****Get*control*date*-*the*first*non-processed*date*****************BUG4646BUG5964
      ** Get control date - the last processed date                             BUG5964
                                                                                BUG4646
     C                   EVAL      PRDT = *ZERO                                 BUG4646
     C                   EVAL      WCTLDYN = *ZERO                              BUG4646
                                                                                BUG4646
      * Principle Change                                                        BUG4646
     C                   IF        PValType = 'P'                               BUG4646
     C     KIRSDL        SETLL     DLPCSCD0                                     BUG4646
     C     KIRSDP        READE     DLPCSCD0                               30    BUG4646
                                                                                BUG4646
     C                   DOW       (*IN30 = *OFF) AND                           BUG4646
     C                             (WCTLDYN = *ZERO)                            BUG4646
     C*******************IF        DTPR <> 'Y'                           BUG4646BUG5964
     C                   IF        DTPR = 'Y' OR DTPR = 'y'                     BUG5964
     C                   Z-ADD     PRDT          WCTLDYN                        BUG4646
     C                   ENDIF                                                  BUG4646
     C     KIRSDP        READE     DLPCSCD0                               30    BUG4646
     C                   ENDDO                                                  BUG4646
      *******************                                                       BUG4646BUG5964
      ***If*nothing*was*found, default control date to next principal           BUG4646BUG5964
      ***change*date*****                                                       BUG4646BUG5964
      *******************                                                       BUG4646BUG5964
     C*******************IF        (WCTLDYN = *ZERO) AND (RSUNPCD <> *ZERO)     BUG4646BUG5357
     C*******************IF        (WCTLDYN = *ZERO)                            BUG5357BUG5964
     C*******************CALLB     'ZDATE1'                                     BUG5357BUG5964
     C*******************PARM      SONPCD        SCDate            6            BUG5357BUG5964
     C*******************PARM                    MidDate           5 0          BUG5357BUG5964
     C*******************PARM                    BJDFIN                         BUG5357BUG5964
     C*******************PARM                    ErrorFlag                      BUG5357BUG5964
     C*******************EVAL      WCTLDYN = RSUNPCD                            BUG4646BUG5357
     C*******************EVAL      WCTLDYN = MidDate                            BUG5357BUG5964
     C*******************ENDIF                                                  BUG4646BUG5964
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
      * Cash Flow                                                               BUG4646
     C                   IF        PValType = 'C'                               BUG4646
     C     KIRSDL        SETLL     DLCFSCD0                                     BUG4646
     C     KIRSDP        READE     DLCFSCD0                               30    BUG4646
                                                                                BUG4646
     C                   DOW       (*IN30 = *OFF) AND                           BUG4646
     C                             (WCTLDYN = *ZERO)                            BUG4646
     C*******************IF        DTPR <> 'Y'                           BUG4646BUG5964
     C                   IF        DTPR = 'Y' OR DTPR = 'y'                     BUG5964
     C                   Z-ADD     PRDT          WCTLDYN                        BUG4646
     C                   ENDIF                                                  BUG4646
     C     KIRSDP        READE     DLCFSCD0                               30    BUG4646
     C                   ENDDO                                                  BUG4646
      *******************                                                       BUG4646BUG5964
      ***If*nothing*was*found, default control date                             BUG4646BUG5964
      *******************                                                       BUG4646BUG5964
     C*******************IF        (WCTLDYN = *ZERO)                            BUG4646BUG5964
     C*******************IF        POurTheir= 'T'                               BUG4646BUG5964
     C*******************EVAL      WCTLDYN = RSTNIPD                            BUG4646BUG5964
     C*******************ELSE                                                   BUG4646BUG5964
     C*******************EVAL      WCTLDYN = RSUNIPD                            BUG4646BUG5964
     C*******************ENDIF                                                  BUG4646BUG5964
     C*******************ENDIF                                                  BUG4646BUG5964
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
      * Date Schedule                                                           BUG4646
     C                   IF        PValType = 'R' OR PValType = 'I'             BUG4646
     C     KIRSDM        SETLL     DLDTSCD0                                     BUG4646
     C     KIRSDN        READE     DLDTSCD0                               30    BUG4646
                                                                                BUG4646
     C                   DOW       (*IN30 = *OFF) AND                           BUG4646
     C                             (WCTLDYN = *ZERO)                            BUG4646
     C*******************IF        DTPR <> 'Y'                           BUG4646BUG5964
     C                   IF        DTPR = 'Y' OR DTPR = 'y'                     BUG5964
     C                   Z-ADD     PRDT          WCTLDYN                        BUG4646
     C                   ENDIF                                                  BUG4646
     C     KIRSDN        READE     DLDTSCD0                               30    BUG4646
     C                   ENDDO                                                  BUG4646
      *******************                                                       BUG4646BUG5964
      ***If*nothing*was*found, default control date                             BUG4646BUG5964
      *******************                                                       BUG4646BUG5964
     C*******************IF        (WCTLDYN = *ZERO)                            BUG4646BUG5964
     C*******************IF        POurTheir= 'T'                               BUG4646BUG5964
     C*******************IF        PValType = 'R'                               BUG4646BUG5964
     C*******************EVAL      WCTLDYN = RSTNICD                            BUG4646BUG5964
     C*******************ELSE                                                   BUG4646BUG5964
     C*******************EVAL      WCTLDYN = RSTNIPD                            BUG4646BUG5964
     C*******************ENDIF                                                  BUG4646BUG5964
     C*******************ELSE                                                   BUG4646BUG5964
     C*******************IF        PValType = 'R'                               BUG4646BUG5964
     C*******************EVAL      WCTLDYN = RSUNICD                            BUG4646BUG5964
     C*******************ELSE                                                   BUG4646BUG5964
     C*******************EVAL      WCTLDYN = RSUNIPD                            BUG4646BUG5964
     C*******************ENDIF                                                  BUG4646BUG5964
     C*******************ENDIF                                                  BUG4646BUG5964
     C*******************ENDIF                                                  BUG4646BUG5964
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG4646
      *****************************************************************         BUG4646
      * CheckAmt - Routine to validate amount in date schedules       *         BUG4646
      *****************************************************************         BUG4646
     C     CheckAmt      BEGSR                                                  BUG4646
                                                                                BUG4646
      ** Check amount if numeric                                                BUG4646
                                                                                BUG4646
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
     C**********         MOVE      *BLANKS       WZFIELD                              BUG5610 245692
     C**********         MOVE      WAmount       PZFIELD                              BUG4646 245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      WAmount       @@ALPH                                       245692
     C                   Z-ADD     PZADEC        @@IDP                                        245692
     C                   Z-ADD     PZADIG        @@IINT                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
     C**********         CALLB     'ZALIGN'                                           BUG4646 245692
     C**********         PARM                    PZALIGNOK         1                  BUG4646 245692
     C**********         PARM                    PZFIELD          16                  BUG4646 245692
     C**********         PARM                    PZADEC            1 0                BUG4646 245692
     C**********         PARM                    PZADIG            2 0                BUG4646 245692
     C                   CALLB     'ZA0840'                                                   245692
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
                                                                                BUG4646
      ** Amount not valid                                                       BUG4646
                                                                                BUG4646
     C**********         IF        (PZALIGNOK = 'N') OR (PZFIELD = *ALL'0')           BUG4646 245692
     C     @@ERCD        IFNE      0                                                          245692
     C     @@AMT         OREQ      0                                                          245692
     C                   EVAL      Idx = Idx + 1                                BUG4646
     C                   IF        SFORMAMT = 'SAMT'                            BUG5438
     C                   MOVEL     'DLM2011'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C                   ELSE                                                   BUG5438
     C                   EVAL      MsgIDArr(Idx) = 'DLM0149'                    BUG4646
     C*******************EVAL      FldNameArr(Idx) = 'SAMT'                     BUG4646BUG5357
     C                   EVAL      FldNameArr(Idx) = SFORMAMT                   BUG5357
     C                   ENDIF                                                  BUG5438
     C                   ELSE                                                   BUG5610
     C                   MOVE      @@ALPH        WZFIELD          16                          245692
     C                   MOVE      @@AMT         PZFIELD          16                          245692
     C**********         CALLB     'ZEDIT'                                            BUG5610 245692
     C**********         PARM      PZFIELD       WZFIELD          16                  BUG5610 245692
     C**********         PARM                    PZADEC                               BUG5610 245692
     C                   ENDIF                                                  BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG4646
      *****************************************************************         BUG4646
      * CheckCurr- Routine to access currency details                 *         BUG4646
      *****************************************************************         BUG4646
     C     CheckCurr     BEGSR                                                  BUG4646
                                                                                BUG4646
      ** Access currency details to get the number of decimal places            BUG4646
     C                   CALL      'AOCURRR0'                                   BUG4646
     C                   PARM      *BLANKS       PRtcd                          BUG4646
     C                   PARM      '*KEY   '     POptn                          BUG4646
     C                   PARM      SUCUCY        PCcy                           BUG4646
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG4646
                                                                                BUG4646
     C                   MOVE      A6NBDP        WONBDP                         BUG4646
      *                                                                         BUG4646
      ** Get decimal places for settlement currencies, if used                  BUG4646
      *                                                                         BUG4646
     C     RSPSCY        IFNE      *BLANK                                       BUG4646
     C                   CALL      'AOCURRR0'                                   BUG4646
     C                   PARM      *BLANKS       PRtcd                          BUG4646
     C                   PARM      '*KEY   '     POptn                          BUG4646
     C                   PARM      RSPSCY        PCcy                           BUG4646
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG4646
     C                   MOVE      A6NBDP        WPNBDP                         BUG4646
     C                   MOVE      RSPSCY        WPSCY                          BUG4646
     C                   ELSE                                                   BUG4646
     C                   MOVE      SUCUCY        WPSCY                          BUG4646
     C                   MOVE      WONBDP        WPNBDP                         BUG4646
     C                   ENDIF                                                  BUG4646
      *                                                                         BUG4646
     C     RSRSCY        IFNE      *BLANK                                       BUG4646
     C                   CALL      'AOCURRR0'                                   BUG4646
     C                   PARM      *BLANKS       PRtcd                          BUG4646
     C                   PARM      '*KEY   '     POptn                          BUG4646
     C                   PARM      RSRSCY        PCcy                           BUG4646
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG4646
     C                   MOVE      A6NBDP        WRNBDP                         BUG4646
     C                   MOVE      RSRSCY        WRSCY                          BUG4646
     C                   ELSE                                                   BUG4646
     C                   MOVE      SUCUCY        WRSCY                          BUG4646
     C                   MOVE      WONBDP        WRNBDP                         BUG4646
     C                   ENDIF                                                  BUG4646
      *                                                                         BUG4646
     C                   Z-ADD     0             PZADEC            1 0                        245692
     C                   Z-ADD     0             PZADIG            2 0                        245692
     C                   SELECT                                                 BUG4646
     C                   WHEN      PValType = 'C' AND POurTheir= 'U'            BUG4646
     C                   EVAL      PZADEC = WPNBDP                              BUG4646
     C                   EVAL      PZADIG = 13 - PZADEC                         BUG4646
      *                                                                         BUG4646
     C                   WHEN      PValType = 'C' AND POurTheir= 'T'            BUG4646
     C                   EVAL      PZADEC = WRNBDP                              BUG4646
     C                   EVAL      PZADIG = 13 - PZADEC                         BUG4646
      *                                                                         BUG4646
     C*******************WHEN      PValType = 'P' AND POurTheir= ' '     BUG4646BUG5964
     C*******************WHEN      PValType = 'P' AND POurTheir= 'U'                 BUG5964 BUG6386
     C                   WHEN      PValType = 'P' AND POurTheir= ' '                         BUG6386
     C                   EVAL      PZADEC = WPNBDP                              BUG4646
     C                   EVAL      PZADIG = 15 - PZADEC                         BUG4646
     C                   ENDSL                                                  BUG4646
      *                                                                         BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG4646
      *****************************************************************         BUG4646
      * ConfHol - Routine to validate confirm holiday flag            *         BUG4646
      *****************************************************************         BUG4646
     C     ConfHol       BEGSR                                                  BUG4646
      *                                                                         BUG4646
      **  Confirmed holiday ind. must be 'Y' if date is a holiday, else *BLANK  BUG4646
      *                                                                         BUG4646
     C                   IF        WHoliday='Y' AND CHol<>'Y'                   BUG4646
     C                             OR WHoliday='N' AND CHol='Y'                 BUG4646
     C                   EVAL      Idx = Idx + 1                                BUG4646
     C*******************EVAL      MsgIDArr(Idx) = 'DLM0146'             BUG4646BUG5438
     C                   MOVEL     'DLM2008'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SCOL'              BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG4646
      *****************************************************************         BUG4646
      * CheckInDeInd - Routine to validate increase/decrease flag     *         BUG4646
      *****************************************************************         BUG4646
     C     CheckInDeInd  BEGSR                                                  BUG4646
     C                   IF        BGN2ST = 'Y'                                 BUG4646
     C                   IF        PCIDFLG = *BLANKS                            BUG4646
     C                   ADD       1             Idx                            BUG4646
     C*******************MOVEL     'DLM1022'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2009'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SPIDF'             BUG4646BUG5438
     C                   ELSE                                                   BUG4646
     C                   IF        PCIDFLG <> 'D' AND PCIDFLG <> 'I'            BUG4646
     C                   ADD       1             Idx                            BUG4646
     C*******************MOVEL     'DLM1021'     MsgIDArr(Idx)           BUG4646BUG5438
     C                   MOVEL     'DLM2010'     MsgIDArr(Idx)                  BUG5438
                                                                                BUG5438
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5438 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5438
     C*******************EVAL      FldNameArr(Idx) = 'SPIDF'             BUG4646BUG5438
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG4646
      *****************************************************************         BUG4646
      * ValFormula - Routine to validate formula                      *         BUG4646
      *****************************************************************         BUG4646
     C     ValFormula    BEGSR                                                  BUG4646
      *   Formula must be specified                                             BUG4646
     C                   IF        SFORM = *BLANKS                              BUG4646
     C                   ADD       1             Idx                            BUG4646
     C                   MOVEL     'DLM0153'     MsgIDArr(Idx)                  BUG4646
     C*******************EVAL      FldNameArr(Idx) = 'SFORM'                    BUG4646BUG5357
     C                   EVAL      FldNameArr(Idx) = SFORMNAME                  BUG5357
     C                   ELSE                                                   BUG4646
      *                                                                         BUG4646
      *   Date must be a formula                                                BUG4646
     C                   EVAL      *IN99=*OFF                                   BUG4646
      *                                                                         BUG4646
      **  Validate first two positions                                          BUG4646
      **    First two positions are mandatory                                   BUG4646
      *                                                                         BUG4646
     C                   IF        SDN1=*BLANK                                  BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**       Are positions 1&2 numeric  ?                                     BUG4646
     C*                                                                         BUG4646
     C                   MOVE      0             WRK3A             3            BUG4646
     C                   MOVEL     SDN1          WRK3A                          BUG4646
     C                   TESTN                   WRK3A                24        BUG4646
     C*                                                                         BUG4646
     C**       If SDN1   is numeric                                             BUG4646
     C*                                                                         BUG4646
     C                   IF        *IN24=*ON                                    BUG4646
     C                   MOVE      SDN1          WRK2N             2 0          BUG4646
     C*                                                                         BUG4646
     C**       Number must be between 1 and 28, or be 31.                       BUG4646
     C*                                                                         BUG4646
     C                   IF        WRK2N > 28 AND SDN1 <> '31'                  BUG4646
     C                             OR WRK2N < 1                                 BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**    If not numeric                                                      BUG4646
     C*                                                                         BUG4646
     C                   ELSE                                                   BUG4646
     C*                                                                         BUG4646
     C**   Position 1 to be numeric  1-4 incl                                   BUG4646
     C*                                                                         BUG4646
     C                   IF        SWRK1 < '1' OR SWRK1 > '4'                   BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**  1ST character valid - check 2ND is in array of day in week codes      BUG4646
     C*                                                                         BUG4646
     C     SWRK2         LOOKUP    LETT                                   24    BUG4646
     C                   IF        *IN24 = *OFF                                 BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**  End of non-numeric validation                                         BUG4646
     C*                                                                         BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**  Validate position 3                                                   BUG4646
     C*                                                                         BUG4646
     C**  If position 1/2 is 31, pos 3 must be blank, or 4,5,6 have entry       BUG4646
     C**  If position 1 and 2 are not '31' pos.3 must be '+' or '-'             BUG4646
     C*                                                                         BUG4646
     C*                                                                         BUG4646
     C                   IF        SDN1 = '31' AND SWRK3 <> *BLANK              BUG4646
     C                             AND S456 = *BLANK                            BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C                   IF        SDN1 <> '31' AND SWRK3 <> '+'                BUG4646
     C                             AND SWRK3 <> '-'                             BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C                   IF        SDN1 = '31' AND SWRK3 <> '+'                 BUG4646
     C                             AND SWRK3 <> '-' AND SWRK3 <> ' '            BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**  Validate positions 4 and 5                                            BUG4646
     C**    If entered must be numeric, between 1 and 28 inclusive              BUG4646
     C*                                                                         BUG4646
     C                   IF        SDN2 <> *BLANK                               BUG4646
     C*                                                                         BUG4646
     C                   MOVE      0             WRK3A                          BUG4646
     C                   MOVEL     SDN2          WRK3A                          BUG4646
     C                   TESTN                   WRK3A                24        BUG4646
     C*                                                                         BUG4646
     C**  Not valid numeric                                                     BUG4646
     C*                                                                         BUG4646
     C                   IF        *IN24 = *OFF                                 BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ELSE                                                   BUG4646
     C*                                                                         BUG4646
     C**  Valid number, check range                                             BUG4646
     C*                                                                         BUG4646
     C                   MOVE      SDN2          WRK2N                          BUG4646
     C                   IF        WRK2N < 1 OR WRK2N > 28                      BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**  End of numeric validation for pos 4/5                                 BUG4646
     C*                                                                         BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**  Validate position 6                                                   BUG4646
     C*                                                                         BUG4646
     C**    If positions 4 and 5 are entered pos.6 must be A,B or C             BUG4646
     C*                                                                         BUG4646
     C                   IF        SDN2 <> *BLANK AND SWRK6 <> 'A'              BUG4646
     C                             AND SWRK6 <> 'B' AND SWRK6 <> 'C'            BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**  Validate position 7                                                   BUG4646
     C*                                                                         BUG4646
     C**  If position 6 is 'A' then pos 7 must be '+' or'-'                     BUG4646
     C**  otherwise it must be blank.                                           BUG4646
     C*                                                                         BUG4646
     C                   IF        SWRK6 = 'A'                                  BUG4646
     C                   IF        SWRK7 <> '+' AND SWRK7 <> '-'                BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C                   ELSE                                                   BUG4646
     C                   IF        SWRK7 <> ' '                                 BUG4646
     C                   EVAL      *IN99=*ON                                    BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C                   IF        *IN99=*ON                                    BUG4646
     C                   EVAL      Idx = Idx + 1                                BUG4646
     C                   EVAL      MsgIDArr(Idx) = 'DLM0154'                    BUG4646
     C*******************EVAL      FldNameArr(Idx) = 'SFORM'                    BUG4646BUG5357
     C                   EVAL      FldNameArr(Idx) = SFORMNAME                  BUG5357
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**  Get DD/MM/YY format of date, and month and year                       BUG4646
     C*                                                                         BUG4646
     C                   IF        WCTLDYN <> 0 AND Idx=0                       BUG4646
     C                   EVAL      ZDAYNO = WCTLDYN                             BUG4646
     C                   EXSR      SRZDATE2                                     BUG4646
     C                   ELSE                                                   BUG4646
      *   If no start date present, formula cannot be used                      BUG4646
     C                   Z-ADD     *ZERO         YRNO                           BUG4646
     C                   Z-ADD     *ZERO         MTHN                           BUG4646
     C                   ADD       1             Idx                            BUG4646
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)                  BUG4646
     C*******************EVAL      FldNameArr(Idx) = 'SFORM'                    BUG4646BUG5357
     C                   EVAL      FldNameArr(Idx) = SFORMNAME                  BUG5357
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG4646
      *****************************************************************         BUG4646
      * GENDATES - Routine to generate dates                          *         BUG4646
      *****************************************************************         BUG4646
     C     GENDATES      BEGSR                                                  BUG4646
     C*                                                                         BUG4646
     C**  Calculate next settlement date using SR.FFDATE                        BUG4646
     C*                                                                         BUG4646
     C                   DOW       PRDT < CMDYN                                 BUG4646
     C                   Z-ADD     YRNO          FFYR                           BUG4646
     C                   Z-ADD     MTHN          FFMTH                          BUG4646
     C                   MOVE      *BLANKS       FFLOC                          BUG4646
      *                                                                         BUG4646
      **  Bypass call to FFDATE if Bus. Day Conventions Enhancement on.         BUG4646
      *                                                                         BUG4646
     C                   IF        CIR005 = 'Y'                                 BUG4646
     C                   MOVEA     PBDCCcyArr    FFPCCY           30            BUG4646
     C                   CALL      'DLZIRF'                                     BUG4646
     C                   PARM                    FFDATC                         BUG4646
     C                   PARM                    FFMTH                          BUG4646
     C                   PARM                    FFYR                           BUG4646
     C                   PARM                    FFPCCY                         BUG4646
     C                   PARM                    FFLOC                          BUG4646
     C                   PARM                    BJDFIN                         BUG4646
     C                   PARM                    WADJWD            5 0          BUG4646
     C                   PARM                    PBSDAY            5 0          BUG4646
      *                                                                         BUG4646
     C                   IF        PRDT >= WADJWD                               BUG4646
     C                   MOVE      PBSDAY        PRDT                           BUG4646
     C                   ELSE                                                   BUG4646
     C                   MOVE      WADJWD        PRDT                           BUG4646
     C                   ENDIF                                                  BUG4646
      *                                                                         BUG4646
     C                   ELSE                                                   BUG4646
     C**********         CALL      'FFDATE'                                           BUG4646 240240
     C                   CALLB     'FFDATE'                                                   240240
      ** Return code (10A, returned to caller)                                  BUG4646
     C                   PARM                    ReturnCode                     BUG4646
      ** Working day (5,0P)                                                     BUG4646
     C                   PARM                    FFDAY             5 0          BUG4646
                                                                                BUG4646
      ** Parameters received from caller                                        BUG4646
      ** -------------------------------                                        BUG4646
      ** Date formula (7A)                                                      BUG4646
     C                   PARM                    FFDATC            7            BUG4646
      ** Month of required date (2,0P)                                          BUG4646
     C                   PARM                    FFMTH             2 0          BUG4646
      ** Year of required date (2,0P)                                           BUG4646
     C                   PARM                    FFYR              2 0          BUG4646
      ** Market currency (3A)                                                   BUG4646
     C                   PARM                    FFCCY1            3            BUG4646
      ** Market location (3A)                                                   BUG4646
     C                   PARM                    FFLOC             3            BUG4646
      ** Instrument currency (3A)                                               BUG4646
     C                   PARM                    FFCCY2            3            BUG4646
      ** Other currency (3A)                                                    BUG4646
     C                   PARM                    FFCCY3            3            BUG4646
      ** Date format indicator (1A, from RUNDAT or SDBANKPD)                    BUG4646
     C                   PARM                    BJDFIN                         BUG4646
                                                                                BUG4646
     C                   MOVE      FFDAY         PRDT                           BUG4646
     C                   ENDIF                                                  BUG4646
     C                   IF        PRDT < CMDYN AND PRDT >= WCTLDYN             BUG4646
     C     PRDT          LOOKUP    WMDATE                                 99    BUG4646
     C                   IF        *IN99 = *OFF                                 BUG4646
     C                   MOVE      PRDT          WMDATE(K)                      BUG4646
                                                                                BUG5357
     C                   IF        PValType = 'C'                               BUG5357
     C                   MOVE      PZFIELD       WCFAMT(K)                      BUG5357
     C                   ENDIF                                                  BUG5357
                                                                                BUG5357
     C                   IF        PValType = 'P'                               BUG5357
     C                   MOVE      PZFIELD       WPCAMT(K)                      BUG5357
     C                   ENDIF                                                  BUG5357
                                                                                BUG5357
     C                   IF        PValType = 'C' AND POurTheir = 'U'           BUG5357
     C                   EVAL      %SUBST(OCFSA(K):8:14)=SFORMAMTOC             BUG5357
     C                   ENDIF                                                  BUG5357
                                                                                BUG5357
     C                   IF        PValType = 'C' AND POurTheir = 'T'           BUG5357
     C                   EVAL      %SUBST(TCFSA(K):8:14)=SFORMAMTTC             BUG5357
     C                   ENDIF                                                  BUG5357
                                                                                BUG5357
     C                   IF        PValType = 'P'                               BUG5357
     C                   EVAL      %SUBST(PCSA(K):8:16)=SFORMAMOPC              BUG5357
     C                   EVAL      %SUBST(PCSA(K):24:1)=SFORMIDOPC              BUG5357
     C                   ENDIF                                                  BUG5357
                                                                                BUG5357
     C                   ADD       1             K                              BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**  Update year/month according to frequency                              BUG4646
     C*                                                                         BUG4646
     C                   IF        SFREQF = 'M'                                 BUG4646
     C                   ADD       1             MTHN                           BUG4646
     C                   ENDIF                                                  BUG4646
     C                   IF        SFREQF = 'Q'                                 BUG4646
     C                   ADD       3             MTHN                           BUG4646
     C                   ENDIF                                                  BUG4646
     C                   IF        SFREQF = 'X'                                 BUG4646
     C                   ADD       6             MTHN                           BUG4646
     C                   ENDIF                                                  BUG4646
     C                   IF        SFREQF = 'Y'                                 BUG4646
     C                   ADD       1             MTHN                           BUG4646
     C                   ENDIF                                                  BUG4646
     C*                                                                         BUG4646
     C**  If past end of year                                                   BUG4646
     C*                                                                         BUG4646
     C                   IF        MTHN > 12                                    BUG4646
     C                   ADD       1             YRNO                           BUG4646
     C                   SUB       12            MTHN                           BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG4646
     C****************************************************************          BUG4646
     C*                                                              *          BUG4646
     C* CLEARIRCS - Clear Interest Rate Calendar date records        *          BUG4646
     C*                                                              *          BUG4646
     C****************************************************************          BUG4646
     C     CLEARIRCS     BEGSR                                                  BUG4646
      *                                                                         BUG4646
      ** Clear all dates for this transaction except those already              BUG4646
      ** processed.                                                             BUG4646
      *                                                                         BUG4646
     C     KDTSC         SETLL     DLDTSCD0                                     BUG4646
     C     KDTSC         READE     DLDTSCD0                               98    BUG4646
      *                                                                         BUG4646
     C                   DOW       *IN98=*OFF                                   BUG4646
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG4646
     C                   DELETE    DLDTSCD0                                     BUG4646
     C                   ENDIF                                                  BUG4646
     C     KDTSC         READE     DLDTSCD0                               98    BUG4646
     C                   ENDDO                                                  BUG4646
                                                                                BUG4646
      ** Clear all dates for this transaction except those already              BUG4646
      ** processed (Cash Flow)                                                  BUG4646
                                                                                BUG4646
     C     KDTSC         SETLL     DLCFSCD0                                     BUG4646
     C     KDTSC         READE     DLCFSCD0                               98    BUG4646
                                                                                BUG4646
     C                   DOW       *IN98=*OFF                                   BUG4646
      *                                                                         BUG4646
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG4646
     C                   DELETE    DLCFSCD0                                     BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C     KDTSC         READE     DLCFSCD0                               98    BUG4646
     C                   ENDDO                                                  BUG4646
                                                                                BUG4646
      ** Clear all dates for this transaction except those already              BUG4646
      ** processed (Principal Change)                                           BUG4646
                                                                                BUG4646
     C                   IF        CAP041 = 'Y'                                 BUG4646
     C                   IF        SACCD <> 'R'                                              BUG7587
     C     KDTSC         SETLL     DLPCSCD0                                     BUG4646
     C     KDTSC         READE     DLPCSCD0                               98    BUG4646
                                                                                BUG4646
     C                   DOW       *IN98=*OFF                                   BUG4646
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG4646
     C                   DELETE    DLPCSCD0                                     BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C     KDTSC         READE     DLPCSCD0                               98    BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                               BUG7587
     C                   ENDIF                                                  BUG4646
      *                                                                         BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT
      *****************************************************************
      * ValidateFE - Routine to validate Fees\Buy-Outs fields         *
      *****************************************************************
     C     ValidateFE    BEGSR
 
      ** Set up details of DS DATA before calling validation.
     C/COPY QWINDSRC,IRSIRSMOV1                                                 BUG4646
 
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
     C*******************PARM      *BLANKS       PAccd             4            BUG4646
     C                   PARM      *BLANKS       PAccd            10            BUG4646
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
      ** INPUTS
      ** ======
      ** Response mode
     C                   PARM      'S'           APRespMode
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
                                                                                            BUG12565
      ** (Midas) Deal Number                                                                BUG12565
                                                                                            BUG12565
     C                   PARM                    SDLNO                                      BUG12565
                                                                                            BUG12565
      ** OTHERS
      ** ======
      ** Decimal Places based on Up-Front Pay/Receive (Our)
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    PWUCDP
     C                   PARM                    PWTCDP
      ** Settlement currency
      ** Receivers currency
     C                   PARM                    PWPSCY
     C                   PARM                    PWRSCY
      ** Nostro Locations
     C                   PARM                    PWPNLOC
     C                   PARM                    PWRNLOC
      ** OUTPUTS
      ** =======
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Deal info passed from calling programs
     C                   PARM                    Data
     C                   PARM                    BNDCSP                                       245692
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
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
     C                   CALLB     'IRSIRSCVT'
      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode
      ** (Current) Deal in file format
     C                   PARM                    DealFilfmt
     C                   PARM                    DealXFilFmt                    BUG4646
                                                                                BUG4646
      ** FRA/IRS Deals Authorisation
     C                   PARM                    CIR008
      ** OUTPUTS
      ** (Current) Deal in screen format
      ** (Current) deal extenstion in file format                               BUG4646
     C                   PARM                    DealScnfmt
      ** Deal Status
     C                   PARM                    DDSTS            24
 
      ** AMEND CHECKING
 
     C                   RESET                   ReturnCode
                                                                                             BUG6470
      * Need to right adjust the current screen shortterm rate field                         BUG6470
     C                   Eval      @SUEINR = %triml(@SUEINR)                                 BUG6470
     C                   Eval      @STEINR = %triml(@STEINR)                                 BUG6470
 
     C                   CALLB     'IRSIRSAMD'
      ** INPUTS
      ** Return Code
     C                   PARM                    ReturnCode
      ** New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranIn
      ** (Current) Deal in Screen Format
     C                   PARM                    DealScnfmt
      ** (Current) Deal in file format
     C                   PARM                    DealFilfmt
      ** OUTPUTS
      ** Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      ** Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      ** Amendments OK
     C                   PARM                    AmendOk           1
      ** Reset of Fields in Error Required (Y/N)
     C*******************PARM      'N'           ResetErrs         1                          CDL038
     C                   PARM      'Y'           ResetErrs         1                          CDL038
 
     C                   IF        CAP041 = 'Y' AND AmIdx = 0
 
     C                   EVAL      BSOIPM  = @SOIPM
     C                   EVAL      BSONPCD = @SONPCD
     C                   EVAL      BSTIPM  = @STIPM
     C                   EVAL      BSTNPCD = @STNPCD
     C                   EVAL      BSUFVD  = @SUFVD
     C                   EVAL      BSUFEE  = @SUFEE
     C                   EVAL      BSUFPR  = @SUFPR
     C                   EVAL      BSBOVD  = @SBOVD
     C                   EVAL      BSBUYA  = @SBUYA
     C                   EVAL      BSBOPR  = @SBOPR
 
     C                   CALLB     'IRSFBOAMD'
      ** INPUT
      ** =====
      ** Return Code
     C                   PARM                    ReturnCode
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      ** Transaction Details retrieved from file - in screen
     C                   PARM                    CrFBScnFmt
      ** Deal information details
     C                   PARM                    Data
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           PResetFld         1
      ** Decimal Places based on Up-Front Pay/Receive (Our)
     C                   PARM                    PWUCDP
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    PWTCDP
      ** STANDING DATA
      ** =============
      ** SDBANK - Rundate
     C                   PARM                    BJRDNB
      ** SWITCHABLE FEATURES
      ** ===================
      ** Overnight index swaps
     C                   PARM                    CIR007
      ** OUTPUT
      ** ======
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      ** Array index (3P0) from/to caller
     C                   PARM                    AmIDx
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      ** OK Amendments field
     C                   PARM                    AmendOK
     C                   PARM                    BNDCSP                                       245692
 
     C                   ENDIF
 
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
      *  WriteToDB - File Updates                                     *
      *****************************************************************
     C     WriteToDB     BEGSR
 
     C                   CALLB     'IRSIRSUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ModeOfOp
     C                   PARM                    ValidDeal
     C                   PARM                    ValidXDeal                     BUG4646
     C*******************PARM                    DBORatChgD                     BUG4646
     C*******************PARM                    DBOIntPayD                     BUG4646
     C*******************PARM                    DBTRatChgD                     BUG4646
     C*******************PARM                    DBTIntPayD                     BUG4646
     C*******************PARM      'N'           ScreenInpt        1            BUG4646
     C                   PARM      'Y'           ScreenInpt        1
     C                   PARM                    CIR008
     C                   PARM                    CAP056
                                                                                              CSW213
      ** Call DLRPIFVU - Midas DL Reporting Information Validate and Update                   CSW213
                                                                                              CSW213
     C                   IF        CSW213 = 'Y'                                               CSW213
     C                   EXSR      SrSIRSvu                                                   CSW213
     C                   ENDIF                                                                CSW213
 
      ** IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTION, ROLLBACK ANY
      ** UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
 
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   EVAL      APIRetC = '0'
     C     CSC022        IFEQ      'N'                                          BUG4646
     C                   ROLBK
     C                   ELSE                                                   BUG4646
     C     WCMT01        IFNE      'Y'                                          BUG4646
     C                   ROLBK                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   EXSR      *PSSR
     C                   ELSE
     C     CSC022        IFEQ      'N'                                          BUG4646
     C     WCMT01        OREQ      'N'                                          BUG4646
     C     CSC022        ANDEQ     'Y'                                          BUG4646
     C                   COMMIT
     C                   ENDIF                                                  BUG4646       CSC022
     C                   END
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *****************************************************************
     C     CheckWrite    BEGSR
 
      *  If no errors were found:
      *  - If Action Code is Insert and Deal Number is not supplied
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
 
      ** If Interest Rate Calendars are in use write to valid IRC file
      ** (dont bother setting up for delete)
 
     C     CIR001        IFEQ      'Y'
     C*****SACCD*********ANDNE     'R'                                          BUG4646
     C                   EXSR      SUPVALIRC
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If support system is active, write invalid transaction to
      ** log file via APLOGTRAN standard module.
 
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)
 
     C                   EVAL      TRANSDTL = TranIn                            BUG4646
      *******************                                                       BUG4646
     C*******************EVAL      TRANSDTL = TranIn + OurRatChgD               BUG4646
     C*******************                     + OurIntPayD                      BUG4646
     C*******************                     + ThrRatChgD                      BUG4646
     C*******************                     + ThrIntPayD                      BUG4646
     C                                        + InRecSttmt
     C                                        + InPaySttmt
     C                                        + InFRASttmt
     C                                        + ExtData
     C                   EVAL      APTGTTYPE = 'IRSIRS'
     C                   EVAL      PDealNum = SDLNO
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    Timestamp
     C                   PARM                    PDealNum
     C                   PARM      *BLANKS       PADealNo
 
     C                   IF        RetCodeOut <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PDealNum
     C                   EVAL      DBFile = 'APLOGTRAN'
     C                   EVAL      DBase = 907
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
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
     C                   RESET                   OKSIRSInDS
     C*************      RESET                   OKInRatCal                     BUG4646
     C                   MOVE      *ALL'Y'       OKFEBO
 
     C                   RESET                   PayDat
     C                   RESET                   RecDat
 
     C                   CLEAR                   ValidDeal
     C                   CLEAR                   ValidXDeal                     BUG4646
 
      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields
 
     C                   Z-ADD     *ZERO         RSRSTM
     C**********         Z-ADD     *ZERO         RSROBN                                       CSD027
     C**********         Z-ADD     *ZERO         RSROCN                                       CSD027
     C                   EVAL      RSROBN = *BLANKS                                           CSD027
     C                   EVAL      RSROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         RSPSTM
     C**********         Z-ADD     *ZERO         RSPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         RSPOCN                                       CSD027
     C                   EVAL      RSPOBN = *BLANKS                                           CSD027
     C                   EVAL      RSPOCN = *BLANKS                                           CSD027
 
      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
 
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt
      *******************                                                       BUG4646
     C*******************CLEAR                   DBORatChgD                     BUG4646
     C*******************CLEAR                   DBOIntPayD                     BUG4646
     C*******************CLEAR                   DBTRatChgD                     BUG4646
     C*******************CLEAR                   DBTIntPayD                     BUG4646
     C                   CLEAR                   DATA                           BUG4646
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SUPVALIRC  - Set up valid Interest Rate Calendar details      *
      *****************************************************************
     C     SUPVALIRC     BEGSR
     C                   IF        SACCD = 'A' OR SACCD = 'R'                   BUG4646
     C                   MOVEL     RSDLNO        WDEALNO                        BUG4646
     C                   EXSR      CLEARIRCS                                    BUG4646
     C                   ENDIF                                                  BUG4646
 
     C                   IF        SACCD = 'I' OR SACCD = 'A'                   BUG4646
     C                   MOVEL     RSDLNO        DLNO                           BUG4646
      ** Our Rate Change Dates.
     C     SUICFR        IFEQ      'Z'                                          BUG4646
     C                   EVAL      OTIN = 'U'                                   BUG4646
     C                   EVAL      RCIP = 'R'                                   BUG4646
     C                   EVAL      X=%LOOKUP('        ':ORDATEA)                BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      DATESCH=ORDATEA(I)                           BUG4646
     C                   EVAL      PRDT = ORMDATE(I)                            BUG4646
     C                   EVAL      COHO = DSCHOL                                BUG4646
     C                   EVAL      DTPR = DSPDAT                                BUG4646
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG4646
     C                   WRITE     DLDTSCD0                                     BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
      ** Our Interest Payment dates                                             BUG4646
     C     SUIPFR        IFEQ      'Z'                                          BUG4646
     C                   EVAL      OTIN = 'U'                                   BUG4646
     C                   EVAL      RCIP = 'P'                                   BUG4646
     C                   EVAL      X=%LOOKUP('        ':OPDATEA)                BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      DATESCH=OPDATEA(I)                           BUG4646
     C                   EVAL      PRDT = OPMDATE(I)                            BUG4646
     C                   EVAL      COHO = DSCHOL                                BUG4646
     C                   EVAL      DTPR = DSPDAT                                BUG4646
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG4646
     C                   WRITE     DLDTSCD0                                     BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
      ** Their rate change date Schedule                                        BUG4646
     C     STICFR        IFEQ      'Z'                                          BUG4646
     C                   EVAL      OTIN = 'T'                                   BUG4646
     C                   EVAL      RCIP = 'R'                                   BUG4646
     C                   EVAL      X=%LOOKUP('        ':TRDATEA)                BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      DATESCH=TRDATEA(I)                           BUG4646
     C                   EVAL      PRDT = TRMDATE(I)                            BUG4646
     C                   EVAL      COHO = DSCHOL                                BUG4646
     C                   EVAL      DTPR = DSPDAT                                BUG4646
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG4646
     C                   WRITE     DLDTSCD0                                     BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
      ** Their Interest Payment dates                                           BUG4646
     C     STIPFR        IFEQ      'Z'                                          BUG4646
     C                   EVAL      OTIN = 'T'                                   BUG4646
     C                   EVAL      RCIP = 'P'                                   BUG4646
     C                   EVAL      X=%LOOKUP('        ':TPDATEA)                BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      DATESCH=TPDATEA(I)                           BUG4646
     C                   EVAL      PRDT = TPMDATE(I)                            BUG4646
     C                   EVAL      COHO = DSCHOL                                BUG4646
     C                   EVAL      DTPR = DSPDAT                                BUG4646
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG4646
     C                   WRITE     DLDTSCD0                                     BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
      ** Our cash flow                                                          BUG4646
     C     SUIPFR        IFEQ      'C'                                          BUG4646
     C                   EVAL      OTIN = 'U'                                   BUG4646
     C                   EVAL      X=%LOOKUP('        ':OCFSA)                  BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      CASHFSCH=OCFSA(I)                            BUG4646
     C                   EVAL      PRDT = OCFMDAT(I)                            BUG4646
     C                   EVAL      COHO = CFCHOL                                BUG4646
     C                   EVAL      DTPR = CFPDAT                                BUG4646
     C                   EVAL      CFLA = OCFAMT(I)                             BUG4646
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG4646
     C                   WRITE     DLCFSCD0                                     BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
      ** Their cash flow                                                        BUG4646
     C     STIPFR        IFEQ      'C'                                          BUG4646
     C                   EVAL      OTIN = 'T'                                   BUG4646
     C                   EVAL      X=%LOOKUP('        ':TCFSA)                  BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      CASHFSCH=TCFSA(I)                            BUG4646
     C                   EVAL      PRDT = TCFMDAT(I)                            BUG4646
     C                   EVAL      COHO = CFCHOL                                BUG4646
     C                   EVAL      DTPR = CFPDAT                                BUG4646
     C                   EVAL      CFLA = TCFAMT(I)                             BUG4646
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG4646
     C                   WRITE     DLCFSCD0                                     BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
      ** Principle change                                                       BUG4646
     C     SONPCD        IFNE      *BLANKS                                      BUG4646
     C     CAP041        ANDEQ     'Y'                                          BUG4646
     C*******************EVAL      OTIN = 'U'                                        BUG4646 BUG6386
     C                   EVAL      OTIN = ' '                                                BUG6386
     C                   EVAL      X=%LOOKUP('        ':PCSA)                   BUG4646
     C                   EVAL      I=1                                          BUG4646
     C                   DOW       I<X                                          BUG4646
                                                                                BUG4646
     C                   EVAL      PCHGSCH=PCSA(I)                              BUG4646
     C                   EVAL      PRDT = TPCMDAT(I)                            BUG4646
     C                   EVAL      COHO = PCCHOL                                BUG4646
     C                   EVAL      DTPR = PCPDAT                                BUG4646
     C                   EVAL      PAMT = TPCAMT(I)                             BUG4646
     C                   EVAL      CAMT = 0                                     BUG4646
     C                   EVAL      PMTP = *BLANK                                BUG4646
     C                   IF        BGN2ST='Y'                                   BUG4646
     C                   EVAL      WPAMT = PAMT                                 BUG4646
                                                                                BUG4646
      ** Calculate for the new principal amount                                 BUG4646
                                                                                BUG4646
     C                   IF        PCIDFLG = 'D'                                BUG4646
     C                   Z-SUB     WPAMT         WPAMT                          BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
      ** If date entered is on or prior to the control date, add the change amouBUG4646
      ** to original principal amount                                           BUG4646
                                                                                BUG4646
     C                   IF        PRDT <= WCTLDYN                              BUG4646
     C                   EVAL      PAMT = RSUPAMT + WPAMT                       BUG4646
     C                   ELSE                                                   BUG4646
                                                                                BUG4646
      ** If date entered is between existing records, access the previous recordBUG4646
      ** change amount to the principal amount on this record                   BUG4646
                                                                                BUG4646
     C                   MOVEL     RSDLNO        WDealNo                        BUG4646
     C*******************EVAL      POurTheir= ' '                        BUG4646BUG5964
     C*******************EVAL      POurTheir= 'U'                                    BUG5964 BUG6386
     C                   EVAL      POurTheir= ' '                                            BUG6386
     C     KIRSDL        SETLL     DLPCSCL0                                     BUG4646
     C                   READP     DLPCSCL0                                     BUG4646
                                                                                BUG4646
     C                   IF        NOT %EOF(DLPCSCL0) AND (WDealNo=XXDLNO) AND  BUG4646
     C                             (OTIN = XXOTIN)                              BUG4646
     C                   EVAL      PAMT = XXPAMT + WPAMT                        BUG4646
     C                   ELSE                                                   BUG4646
     C                   EVAL      PAMT = RSUPAMT + WPAMT                       BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   Z-ADD     WPAMT         CAMT                           BUG4646
     C                   ENDIF                                                  BUG4646
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG4646
     C                   WRITE     DLPCSCD0                                     BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
      ** Update records with processing dates greater than the processing       BUG4646
      ** date of the inserted record                                            BUG4646
                                                                                BUG4646
     C                   IF        BGN2ST = 'Y'                                 BUG4646
     C                   EXSR      SRUpdPCSC                                    BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ADD       1             I                              BUG4646
     C                   ENDDO                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
 
     C*****RSUICFR*******IFEQ      'Z'                                          BUG4646
     C*******************EVAL*     ORFOtran   = APFOTranID                      BUG4646
     C*******************EVAL*     ORXTmeStmp = TimeStamp                       BUG4646
     C*******************MOVE*     'U'           ORXOURTHR                      BUG4646
     C*******************MOVE*     'R'           ORXRATPAY                      BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
      ***Our*Interest*Payment*Dates.                                            BUG4646
      ************************                                                  BUG4646
     C*****RSUIPFR*******IFEQ*     'Z'                                          BUG4646
     C*******************EVAL*     OPFOtran   = APFOTranID                      BUG4646
     C*******************EVAL*     OPXTmeStmp = TimeStamp                       BUG4646
     C*******************MOVE*     'U'           OPXOURTHR                      BUG4646
     C*******************MOVE*     'P'           OPXRATPAY                      BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
      ***Their*Rate*Change*Dates.                                               BUG4646
      ************************                                                  BUG4646
     C*****RSTICFR*******IFEQ*     'Z'                                          BUG4646
     C*******************EVAL*     TRFOtran   = APFOTranID                      BUG4646
     C*******************EVAL*     TRXTmeStmp = TimeStamp                       BUG4646
     C*******************MOVE*     'T'           TRXOURTHR                      BUG4646
     C*******************MOVE*     'R'           TRXRATPAY                      BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
      ***Their*Interest*Payment Dates.                                          BUG4646
      ************************                                                  BUG4646
     C*****RSTIPFR*******IFEQ*     'Z'                                          BUG4646
     C*******************EVAL*     TPFOtran   = APFOTranID                      BUG4646
     C*******************EVAL*     TPXTmeStmp = TimeStamp                       BUG4646
     C*******************MOVE*     'T'           TPXOURTHR                      BUG4646
     C*******************MOVE*     'P'           TPXRATPAY                      BUG4646
     C*******************ENDIF                                                  BUG4646
      ************************                                                  BUG4646
      ************************                                                  BUG4646
     C                   ENDSR                                                  BUG4646
      *****************************************************************         BUG4646
      /EJECT                                                                    BUG4646
      ********************************************************************      BUG4646
      *                                                                  *      BUG4646
      * SRUpdPCSC - Change Principal Amount of affected record           *      BUG4646
      *                                                                  *      BUG4646
      ********************************************************************      BUG4646
                                                                                BUG4646
     C     SRUpdPCSC     BEGSR                                                  BUG4646
                                                                                BUG4646
     C     KIRSDL        SETGT     DLPCSCL0                                     BUG4646
     C     KIRSDP        READE     DLPCSCL0                                     BUG4646
                                                                                BUG4646
     C                   DOW       NOT %EOF(DLPCSCL0)                           BUG4646
     C                   EVAL      XXPAMT = XXPAMT + WPAMT                      BUG4646
     C                   UPDATE    DLPCSCX0                                     BUG4646
     C     KIRSDP        READE     DLPCSCL0                                     BUG4646
     C                   ENDDO                                                  BUG4646
                                                                                BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG4646
      ********************************************************************      BUG4646
      *                                                                  *      BUG4646
      * SRZDATE2  - Convert Midas Day Number                             *      BUG4646
      *                                                                  *      BUG4646
      ********************************************************************      BUG4646
                                                                                BUG4646
     C     SRZDATE2      BEGSR                                                  BUG4646
     C                   CALLB     'ZDATE2'                                     BUG4646
     C                   PARM                    ZDAYNO                         BUG4646
     C                   PARM                    BJDFIN                         BUG4646
     C                   PARM      *ZEROS        ZDATE                          BUG4646
     C                   PARM      *BLANKS       ZADATE            7            BUG4646
                                                                                BUG4646
     C                   MOVEL     ZDATE         DateDS                         BUG4646
                                                                                BUG4646
     C     BJDFIN        IFEQ      'M'                                          BUG4646
     C                   MOVE      DteMth        MTHN              2 0          BUG4646
     C                   ELSE                                                   BUG4646
     C                   MOVE      DteDay        MTHN                           BUG4646
     C                   ENDIF                                                  BUG4646
     C                   MOVE      DteYr         YRNO              2 0          BUG4646
     C                   ENDSR                                                  BUG4646
      /EJECT                                                                    BUG5438
      ********************************************************************      BUG5438
      *                                                                  *      BUG5438
      * SRZEDIT   - Format number                                        *      BUG5438
      *                                                                  *      BUG5438
      ********************************************************************      BUG5438
                                                                                BUG5438
     C     SRZEDIT       BEGSR                                                  BUG5438
     C                   MOVE      I             ZFIELD                         BUG5438
                                                                                BUG5438
     C                   CALLB     'ZEDIT'                                      BUG5438
     C                   PARM                    ZFIELD           16            BUG5438
     C                   PARM      0             ZADEC             1 0          BUG5438
                                                                                BUG5438
     C                   MOVE      ZFIELD        T                 3            BUG5438
     C                   ENDSR                                                  BUG5438
      /EJECT
      *****************************************************************
      * SETUPDEALN - Set up Deal Number for Inserts                   *
      *****************************************************************
     C     SETUPDEALN    BEGSR
 
     C     SDLNO         IFEQ      *BLANKS
     C     SDLNO         OREQ      *ZEROS
 
     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SDLNO
     C                   PARM                    RSDLNO
                                                                                BUG6075
      ** Set up extension file deal number                                      BUG6075
     C                   Eval      RDLNO = SDLNO                                BUG6075
 
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
     C                   MOVE      SDLNO         RSDLNO
     C                   EVAL      RDLNO = SDLNO                                              239204
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *****************************************************************
     C     SETUPVALID    BEGSR
 
      ** For Inserts and Amends, put the Settlement Instructions (input or
      ** defaulted) into the Valid file record.
      ** Two DSs (one Pay, one Receive) contain the Settlement Instructions
      ** in contiguous areas, which must be placed into the correct parts
      ** of the Valid file record
 
     C                   IF        SACCD = 'I'
     C                             OR (SACCD = 'A')
     C*******************MOVEL     DBPaySttmt    SIRSPayIns                     BUG4646
     C*******************MOVEL     DBRecSttmt    SIRSRecIns                     BUG4646
     C                   EVAL      %SUBST(SIRSPayIns:1:2) =                     BUG4646
     C                             %SUBST(DBPaySttmt:1:2)                       BUG4646
     C                   EVAL      RSPONS = %SUBST(DBPaySttmt:3:18)             BUG4646
     C                   EVAL      %SUBST(SIRSPayIns:15:545) =                  BUG4646
     C                             %SUBST(DBPaySttmt:21:545)                    BUG4646
     C                   EVAL      %SUBST(SIRSRecIns:1:2) =                     BUG4646
     C                             %SUBST(DBRecSttmt:1:2)                       BUG4646
     C                   EVAL      RSRONS = %SUBST(DBRecSttmt:3:18)             BUG4646
     C                   EVAL      %SUBST(SIRSRecIns:15:55) =                   BUG4646
     C                             %SUBST(DBRecSttmt:21:55)                     BUG4646
     C                   MOVE      FLPOBR        RSPOBR
     C                   MOVE      FLROBR        RSROBR
     C                   MOVE      FLCVMR        RSCVMR
     C                   MOVE      FLPSCY        RSPSCY
     C                   MOVE      FLRSCY        RSRSCY
     C                   MOVE      FLIC72        RSIC72
     C                   MOVEL     DBFraSttmt    SIRSFraIns
     C                   MOVE      FLAGVC        RSAGVC
 
      ** Ensure numeric fields are zero if not entered.
 
     C     FLISDA        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        RSISDA
     C                   ENDIF
 
     C     FLAGDT        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        RSAGDT
     C                   ENDIF
 
     C     FLAGVV        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        RSAGVV
     C                   ENDIF
 
     C     FLAGVC        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        RSAGVC
     C                   ENDIF
 
     C                   ENDIF
 
      ** For Deletes & Authorises, put the complete (pre-existing) deal
      ** into the Valid file record
 
     C                   IF        SACCD = 'R'
     C                             OR CIR008 = 'Y' AND SACCD = 'X'
     C                   MOVEL     DealFilFmt    ValidDeal
     C                   MOVEL     FSOYLC        RSOYLC                         BUG4646
     C                   MOVEL     FIUSRI        RSUSRI                         BUG4646
     C                   MOVEL     FIDSTS        RSDSTS                         BUG4646
     C                   MOVEL     FIAUTH        RSAUTH                         BUG4646
     C                   MOVEL     URACC         RSURACC                        BUG4646
     C                   MOVEL     UPACC         RSUPACC                        BUG4646
     C                   MOVEL     RONS          RSRONS                         BUG4646
     C                   MOVEL     PONS          RSPONS                         BUG4646
     C                   ENDIF
 
      ** Set Fees/Buy-Outs fields for update to the valids file if CAP041 is installed
 
     C                   IF        CAP041 = 'Y'
     C                   EXSR      SRFileFlds
     C                   ENDIF
 
      ** Set Valid file field(s) that are needed for all Action Codes
 
     C                   EVAL      RSCHTP = SACCD
 
      ** Include Header fields that need to be o/p to the Valid file
 
     C**********         EVAL      RSFRNT = APFOTranID                                        248489
     C**********         EVAL      RSREPA = APRprLocn                                         248489
     C                   IF        SACCD = 'I'                                              MD029596
     C                   EVAL      RSFRNT = APFOTranID                                      MD029596
     C                   ENDIF                                                              MD029596
                                                                                            MD029596
     C                   EVAL      RSTMESTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'S'
                                                                                             BUG6671
      ** Setup the Valid file with 'Authomatic Authorisation' from                           BUG6671
      ** Interface file IRRSIFPD                                                             BUG6671
                                                                                             BUG6671
     C**********         IF        CAP056 = 'Y' and                                 BUG6671 AR664921
     C**********                   AUTH = 'Y'                                       BUG6671 AR664921
     C                   IF        CAP056 = 'Y'                                             AR664921
     C                             OR CAP051 = 'Y' and                                       BUG6671
     C                             AUTH = 'Y'                                                BUG6671
     C                   EVAL      RSAUTH = AUTH                                             BUG6671
     C                   ENDIF                                                               BUG6671
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFileFlds - Set up file fields                              *
      *****************************************************************
     C     SRFileFlds    BEGSR
 
      ** If any of the Up-front fee details have been
      ** amended, set Confirmation Required indicator to Y
      ** otherwise, set to N.
 
     C                   IF        #1UPVD <> RSUPVD OR
     C                             #1UPFE <> RSUPFE OR
     C                             #1UPPR <> RSUPPR
     C                   EVAL      #1CNRQ = 'Y'
     C                   EXSR      SRUpdUpF
     C                   ELSE
     C                   EVAL      #1CNRQ = 'N'
     C                   ENDIF
 
     C/COPY QWINDSRC,IRSIRSMOV2                                                 BUG4646
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRUpdUpF -  Write into PF/DLDGUPFE old values of up-front    *
      *              value date, fee and P/R indicator                *
      *****************************************************************
     C     SRUpdUpF      BEGSR
 
     C     #1ACTN        IFEQ      'A'
     C                   MOVE      #1DLNO        DDLNO             6 0
     C     DDLNO         CHAIN     DLDGUPL1                           01
 
     C                   IF        *IN01
     C                   MOVE      DDLNO         DLNO
     C                   MOVE      RSUPVD        UPVD
     C                   MOVE      RSUPFE        UPFE
     C                   MOVE      RSUPPR        UPPR
     C                   WRITE     DLDGREFF
     C                   ELSE
     C                   MOVE      RSUPVD        UPVD
     C                   MOVE      RSUPFE        UPFE
     C                   MOVE      RSUPPR        UPPR
     C                   UPDATE    DLDGREF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  244254
      *****************************************************************                       244254
      * DefISDA - Retrieve and default ISDA details for the customer  *                       244254
      *****************************************************************                       244254
     C     DefISDA       BEGSR                                                                244254
                                                                                              244254
      ** To allow user override - only default FRA/IRS details                                244254
      ***if*DDISDA*is*blank*and*not*already*entered*by*the*user.                     244254 MD029165
      ** if all of the fields in Settlement Confirmation is blank                           MD029165
      ** and not already entered by the user                                                MD029165
      *                                                                                     MD029165
     C**********         IF        DDISDA = *BLANK                                   244254 MD029165
     C                   IF        InFRASttmt = *BLANK                                      MD029165
                                                                                              244254
      ** Set up key for chain to default settlements file                                     244254
     C     KeySett       KLIST                                                                244254
     C                   KFLD                    KYCYCD            3                          244254
     C                   KFLD                    KYCUST            6                          244254
     C                   KFLD                    KYTRTY            2                          244254
                                                                                              244254
     C                   MOVEL     SUCUCY        KYCYCD                                       244254
     C                   MOVEL     SCNUM         KYCUST                                       244254
     C                   MOVEL     SDTYP         KYTRTY                                       244254
                                                                                              244254
      ** Chain to default extended settlements file                                           244254
                                                                                              244254
     C     KeySett       CHAIN     SDEXSTL1                           90                      244254
                                                                                              244254
     C                   IF        *IN90 = *OFF                                               244254
      ** ISDA details                                                                         244254
     C                   EVAL      DDISDA = BYISDA                                            244254
     C                   EVAL      DDAGTY = BYAGTY                                            244254
     C                   EVAL      DDAGDT = BYAGDT                                            244254
     C                   EVAL      WDAGVC = BYAGVC                                            244254
     C                   EVAL      WDAGVV = BYAGVV                                            244254
     C                   EVAL      DDAGVV = WWAGVV                                            244254
      ** Definition Confirmation Sender to Receiver Info                                      244254
     C                   EVAL      DDDSR1 = BYDSR1                                            244254
     C                   EVAL      DDDSR2 = BYDSR2                                            244254
     C                   EVAL      DDDSR3 = BYDSR3                                            244254
     C                   EVAL      DDDSR4 = BYDSR4                                            244254
     C                   EVAL      DDDSR5 = BYDSR5                                            244254
     C                   EVAL      DDDSR6 = BYDSR6                                            244254
      ** Settlement / reset Confirmation                                                      244254
     C                   EVAL      DDSSR1 = BYSSR1                                            244254
     C                   EVAL      DDSSR2 = BYSSR2                                            244254
     C                   EVAL      DDSSR3 = BYSSR3                                            244254
     C                   EVAL      DDSSR4 = BYSSR4                                            244254
     C                   EVAL      DDSSR5 = BYSSR5                                            244254
     C                   EVAL      DDSSR6 = BYSSR6                                            244254
      ** Settlement / reset Confirmation                                                      244254
     C                   EVAL      DDCND1 = BYCND1                                            244254
     C                   EVAL      DDCND2 = BYCND2                                            244254
     C                   EVAL      DDCND3 = BYCND3                                            244254
     C                   EVAL      DDCND4 = BYCND4                                            244254
     C                   EVAL      DDCND5 = BYCND5                                            244254
     C                   EVAL      DDCND6 = BYCND6                                            244254
                                                                                            MD025726
     C                   ELSE                                                               MD025726
      ** Default ISDA fields from FRA/IRS ICD                                               MD025726
     C                   EVAL      DDISDA = BQISDA                                          MD025726
     C                   EVAL      DDAGTY = BQAGTY                                          MD025726
     C                   EVAL      DDAGDT = BQAGDT                                          MD025726
     C                   EVAL      WDAGVC = BQAGVC                                          MD025726
     C                   EVAL      WDAGVV = BQAGVV                                          MD025726
     C                   EVAL      DDAGVV = WWAGVV                                          MD025726
                                                                                            MD025726
     C                   ENDIF                                                                244254
                                                                                              244254
     C                   ENDIF                                                                244254
                                                                                              244254
     C                   ENDSR                                                                244254
      *****************************************************************                       244254
      /EJECT
      *****************************************************************                       CSW213
      * SrSIRSvu - Call DLRPIFVU - Reporting Information Validate     *                       CSW213
      *            and Update                                         *                       CSW213
      *****************************************************************                       CSW213
     C     SrSIRSvu      BEGSR                                                                CSW213
                                                                                              CSW213
      ** Set-up input fields                                                                  CSW213
                                                                                              CSW213
     C                   IF        SACCD = 'R'                                                CSW213
     C                   EVAL      RLACTN = 'D'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      RLACTN = SACCD                                             CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C                   EVAL      RLAPID = 'SIRS'                                            CSW213
     C                   EVAL      RLDTYP = SDTYP                                             CSW213
     C                   EVAL      RLDLST = SDLST                                             CSW213
     C                   EVAL      RLTRRF = SDLNO                                             CSW213
     C                   EVAL      RLLTRF = SLNKDN                                            CSW213
     C                   EVAL      RLFOID = APFOTranID                                        CSW213
     C                   EVAL      RLBRCA = SBRCA                                             CSW213
     C                   EVAL      RLBCCY = SUCUCY                                            CSW213
     C                   EVAL      RLSCCY = SUCUCY                                            CSW213
     C                   EVAL      RLCNUM = SCNUM                                             CSW213
     C                   EVAL      RLVALD = SVDAT                                           MD022508
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
     C                   PARM                    SUPAMT                                     MD023734
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
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Common header information (DS) from source system
     C                   PARM                    HeadIn
      ** Transaction information in a single large field from source system
     C**********         PARM                    Trans500                                     CIR017
     C                   PARM                    Trans1000                                    CIR017
      ***Interest*Rate*Calendar info: (Only set up if CIR001 on)                BUG4646
      ***Our*Rate*Change*dates                                                  BUG4646
     C*******************PARM                    TRANSB500                      BUG4646
      ***Our*Interest*Payment dates                                             BUG4646
     C*******************PARM                    TRANSC500                      BUG4646
      ***Their*Rate*Change dates                                                BUG4646
     C*******************PARM                    TRANSD500                      BUG4646
      ***Their*Interest*Payment dates                                           BUG4646
     C*******************PARM                    TRANSE500                      BUG4646
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InRecSttmt
     C                   PARM                    InPaySttmt
     C                   PARM                    InFRASttmt
 
     C                   PARM                    InfData500                                  BUG6671
     C                   PARM                    ExtData500                                  BUG6671
     C                   PARM                    InSwift2013                                  CSW213
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                        BUG4646
     C                   PARM                    BufferEx2                      BUG4646
     C                   PARM                    BufferEx3                      BUG4646
     C                   PARM                    BufferEx4                      BUG4646
     C                   PARM                    BufferEx5                      BUG4646
     C                   PARM                    BufferEx6                      BUG4646
     C                   PARM                    BufferEx7                      BUG4646
     C                   PARM                    BufferEx8                      BUG4646
     C                   PARM                    BufferEx9                      BUG4646
     C                   PARM                    APIRetc
 
      * Set up the names of the message files from which the
      * message handler will get the messages
 
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,IRSIRSM01
 
      ** Access Bank details via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access API ICD via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Call Access Program for FRA/IRS I.C.D. details
 
     C                   CALLB     'AOFAISR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFAIS        PARM      SDFAIS        DSFDY
      *                                                                         BUG4646
      ** Access Module Details                                                  BUG4646
      *                                                                         BUG4646
     C                   CALL      'AOMMODR0'                                   BUG4646
     C                   PARM      *BLANKS       @RTCD                          BUG4646
     C                   PARM      '*FIRST '     @OPTN                          BUG4646
     C     SDMMOD        PARM      SDMMOD        DSFDY                          BUG4646
 
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
     C                   EVAL      DBASE = 917                                                245692
     C                   EVAL      DBKEY = @OPTN                                              245692
     C                   OUT       LDA                                                        245692
     C                   EXSR      *PSSR                                                      245692
     C                   ENDIF                                                                245692
                                                                                              245692
      ** Access SAR Details for Interest Rate Calendars
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CIR001'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CIR001            1
     C                   ELSE
     C                   MOVEL     'N'           CIR001
     C                   ENDIF
 
      ** Access SAR details file to determine if FRA/IRS Business Day
      ** Day Convention is switched on.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        (@RTCD <> *BLANKS) And (@RTCD <> '*NRF   ')
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   MOVEL     'CIR005'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     'Y'           CIR005            1
     C                   ELSE
     C                   MOVEL     'N'           CIR005
     C                   ENDIF
 
      ** Access SAR details file to determine if CAP041 is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP041'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     908           DBASE
     C                   MOVEL     'CAP041'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     'Y'           CAP041            1
     C                   ELSE
     C                   MOVEL     'N'           CAP041
     C                   ENDIF
 
      ** Access SAR details file to determine if CEU003 is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     909           DBASE
     C                   MOVEL     'CEU003'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     'Y'           CEU003            1
     C                   ELSE
     C                   MOVEL     'N'           CEU003
     C                   ENDIF
 
      ** Access SAR details file to determine if CIR002 is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     910           DBASE
     C                   MOVEL     'CIR002'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     'Y'           CIR002            1
     C                   ELSE
     C                   MOVEL     'N'           CIR002
     C                   ENDIF
 
      ** Access SAR details file to determine if CIR006 is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     911           DBASE
     C                   MOVEL     'CIR006'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     'Y'           CIR006            1
     C                   ELSE
     C                   MOVEL     'N'           CIR006
     C                   ENDIF
 
      ** Access SAR details file to determine if CIR007 is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     912           DBASE
     C                   MOVEL     'CIR007'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     'Y'           CIR007            1
     C                   ELSE
     C                   MOVEL     'N'           CIR007
     C                   ENDIF
 
      ** Access SAR details file to determine if CIR008 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 913
     C                   EVAL      DBKEY = 'CIR008'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CIR008 = 'Y'
     C                   ELSE
     C                   EVAL      CIR008 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if CAP056 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP056'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 914
     C                   EVAL      DBKEY = 'CAP056'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CAP056 = 'Y'
     C                   ELSE
     C                   EVAL      CAP056 = 'N'
     C                   ENDIF
 
      ** Initialise Data queue names
 
     C                   EVAL      DtaQName = 'APSIRSDTQ'
 
      ** Check if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
 
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 908
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                      BUG6671
      ** Access SAR details file to determine if                                             BUG6671
      ** Automatic Authorisation is installed                                                BUG6671
      *                                                                                      BUG6671
     C                   CALL      'AOSARDR0'                                                BUG6671
     C                   PARM      *BLANKS       PRTCD                                       BUG6671
     C                   PARM      '*VERIFY'     POPTN                                       BUG6671
     C                   PARM      'CAP051'      PSARD                                       BUG6671
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG6671
                                                                                             BUG6671
     C                   If        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                   BUG6671
     C     *LOCK         IN        LDA                                                       BUG6671
     C                   Eval      DBKEY = 'CAP051'                                          BUG6671
     C                   Eval      DBFILE = 'SCSARDPD'                                       BUG6671
     C                   Eval      DBASE = 916                                               BUG6671
     C                   OUT       LDA                                                       BUG6671
     C                   EXSR      *PSSR                                                     BUG6671
     C                   ENDIF                                                               BUG6671
      *                                                                                      BUG6671
     C                   If        PRTCD = *Blanks                                           BUG6671
     C                   Eval      CAP051 = 'Y'                                              BUG6671
     C                   Else                                                                BUG6671
     C                   Eval      CAP051 = 'N'                                              BUG6671
     C                   EndIf                                                               BUG6671
 
      * Determine if CSC022 is switched on                                      BUG4646
     C                   CALLB     'AOSARDR0'                                   BUG4646
     C                   PARM      *BLANKS       PRtCd                          BUG4646
     C                   PARM      '*VERIFY'     POptn                          BUG4646
     C                   PARM      'CSC022'      PSard                          BUG4646
     C     SCSARD        PARM      SCSARD        DSFDY                          BUG4646
                                                                                BUG4646
     C                   IF        PRtCd = *Blanks                              BUG4646
     C                   EVAL      CSC022 = 'Y'                                 BUG4646
     C                   EVAL      WCMT01 ='N'                                  BUG4646
      * SCCMTJOB data area                                                      BUG4646
     C                   IN        SCCMTJOB                                     BUG4646
      * Move data area to commitment array                                      BUG4646
     C                   IF        COMITNOM > 0                                 BUG4646
     C                   MOVEA     COMITJOB      ARRJBNAM                       BUG4646
      *                                                                         BUG4646
      * Check if PSJOBNAME exist.                                               BUG4646
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17    BUG4646
     C                   IF        *IN17 = *ON                                  BUG4646
     C                   EVAL      WCMT01= 'Y'                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ENDIF                                                  BUG4646
     C                   ELSE                                                   BUG4646
     C                   EVAL      CSC022 = 'N'                                 BUG4646
                                                                                BUG4646
     C                   IF        PRtCd <> '*NRF'                              BUG4646
     C     *LOCK         IN        LDA                                          BUG4646
     C                   EVAL      DBKEY = 'CSC022'                             BUG4646
     C                   EVAL      DBFILE = 'SCSARDPD'                          BUG4646
     C                   EVAL      DBASE = 915                                  BUG4646
     C                   OUT       LDA                                          BUG4646
     C                   EXSR      *PSSR                                        BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                BUG4646
     C                   ENDIF                                                  BUG4646
                                                                                            BUG27882
      ** Check if enhancement CGL014 (Collaterals Processing) is on                         BUG27882
                                                                                            BUG27882
     C                   CALL      'AOSARDR0'                                               BUG27882
     C                   PARM      *BLANKS       PRTCD                                      BUG27882
     C                   PARM      '*VERIFY'     POPTN                                      BUG27882
     C                   PARM      'CGL014'      PSARD                                      BUG27882
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG27882
                                                                                            BUG27882
     C                   IF        PRTCD <> *BLANKS AND                                     BUG27882
     C                             PRTCD <> '*NRF   '                                       BUG27882
     C                   MOVEL     'SCSARDPD'    DBFILE                                     BUG27882
     C                   MOVEL     '917'         DBASE                                      BUG27882
     C                   MOVEL     'CGL014'      DBKEY                                      BUG27882
     C                   EXSR      *PSSR                                                    BUG27882
     C                   ENDIF                                                              BUG27882
                                                                                            BUG27882
     C                   IF        PRTCD = *BLANKS                                          BUG27882
     C                   EVAL      CGL014 = 'Y'                                             BUG27882
     C                   ELSE                                                               BUG27882
     C                   EVAL      CGL014 = 'N'                                             BUG27882
     C                   ENDIF                                                              BUG27882
                                                                                            BUG27882
                                                                                              CSW213
      ** Check if SWIFT 2013 is on                                                            CSW213
                                                                                              CSW213
     C                   EVAL      CSW213 = *BLANKS                                           CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       @RTCD                                        CSW213
                                                                                              CSW213
     C                   IF        @RTCD = 'CSW2013'                                          CSW213
     C                   EVAL      CSW213 = 'Y'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      CSW213 = 'N'                                               CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C     KIRSDL        KLIST                                                  BUG4646
     C                   KFLD                    WDealNo                        BUG4646
     C                   KFLD                    POurTheir                      BUG4646
     C                   KFLD                    PRDT                           BUG4646
                                                                                BUG4646
     C     KIRSDP        KLIST                                                  BUG4646
     C                   KFLD                    WDealNo                        BUG4646
     C                   KFLD                    POurTheir                      BUG4646
                                                                                BUG4646
     C     KIRSDV        KLIST                                                  BUG4646
     C                   KFLD                    WDealNo                        BUG4646
     C                   KFLD                    POurTheir                      BUG4646
     C                   KFLD                    WRatePay                       BUG4646
     C                   KFLD                    InDateMDN                      BUG4646
                                                                                BUG4646
     C     KCFPC         KLIST                                                  BUG4646
     C                   KFLD                    WDealNo                        BUG4646
     C                   KFLD                    POurTheir                      BUG4646
     C                   KFLD                    InDateMDN                      BUG4646
                                                                                BUG4646
      ** Partial Key for DLDTSCPD                                               BUG4646
     C     KDTSC         KLIST                                                  BUG4646
     C                   KFLD                    WDealNo                        BUG4646
                                                                                BUG4646
     C     KIRSDM        KLIST                                                  BUG4646
     C                   KFLD                    WDealNo                        BUG4646
     C                   KFLD                    POurTheir                      BUG4646
     C                   KFLD                    WRatePay                       BUG4646
     C                   KFLD                    PRDT                           BUG4646
                                                                                BUG4646
     C     KIRSDN        KLIST                                                  BUG4646
     C                   KFLD                    WDealNo                        BUG4646
     C                   KFLD                    POurTheir                      BUG4646
     C                   KFLD                    WRatePay                       BUG4646
     C                   ENDSR                                                  BUG4646
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
     C                   PARM                    SACCD             1                         BUG6512
      *                                                                                      BUG6512
      * (Midas) Deal Number                                                                  BUG6512
     C                   PARM                    SDLNO             6                         BUG6512
      *                                                                                      BUG6512
      * Broker                                                                               BUG6512
     C                   PARM                    SBRKC             4                         BUG6512
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
     C                   PARM      *BLANKS       WFldNamArr                                  BUG6512
     C                   PARM      *BLANKS       WMsgIdArr                                   BUG6512
     C                   PARM      *BLANKS       WMsgDtaArr                                  BUG6512
                                                                                             BUG6512
      ** Warning array index (3P0) from/to caller                                            BUG6512
                                                                                             BUG6512
     C                   PARM      *ZEROS        WIdx                                        BUG6512
                                                                                             BUG6512
     C                   ENDSR                                                               BUG6512
      **********************************************************************                 BUG6512
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
** LETT - LETTERS FOR DAYS TO VALIDATE DATE FORMULAS
MUWTFSX
