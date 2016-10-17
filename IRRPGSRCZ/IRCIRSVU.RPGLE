     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross Ccy IRS Validate and Update')           *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCIRSVU - Validate and Update IRS Deals                     *
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
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSD095CC1          Date 13Sep16               *
      *  Prev Amend No. MD035359           Date 14Apr16               *
      *                 MD031584           Date 10Dec14               *
      *                 MD029165           Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 MD030454           Date 29Sep14               *
      *                 CDL094             Date 03Sep14               *
      *                 MD029596           Date 03Sep14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD025726           Date 19Mar14               *
      *                 264029             Date 22Feb10               *
      *                 245692             Date 11Dec13               *
      *                 MD023734           Date 30Nov13               *
      *                 CSW213             Date 03Jun13               *
      *                 MD000091           Date 08May13               *
      *                 AR981707           Date 19Nov12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248489             Date 14Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244254             Date 13Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240134             Date 09Sep06               *
      *                 BUG11950           Date 24Aug06               *
      *                 240412             Date 03Jul06               *
      *                 240240             Date 26Jun06               *
      *                 BUG8997            Date 26Oct05               *
      *                 CSD031             Date 10Apr06               *
      *                 CIR014             Date 11May06               *
      *                 BUG11254           Date 18Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9714            Date 16Jan06               *
      *                 CDL038             Date 10May05               *
      *                 BUG7621            Date 17Jun05               *
      *                 BUG5871            Date 20May05               *
      *                 BUG6512            Date 17May05               *
      *                 BUG7209            Date 17May05               *
      *                 BUG7046            Date 06May05               *
      *                 BUG6671            Date 25Apr05               *
      *                 BUG6940            Date 29Apr05               *
      *                 BUG6876            Date 27Apr05               *
      *                 BUG6472            Date 20Apr05               *
      *                 BUG6419            Date 14Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6517            Date 07Apr05               *
      *                 BUG6377            Date 11Apr05               *
      *                 BUG6494            Date 06Apr05               *
      *                 BUG6418            Date 31Mar05               *
      *                 BUG6326            Date 18Mar05               *
      *                 BUG5962RP          Date 07Mar05               *
      *                 BUG5964            Date 17Feb05               *
      *                 BUG5962            Date 22Feb05               *
      *                 BUG5967            Date 22Feb05               *
      *                 BUG5610            Date 27Jan05               *
      *                 BUG5449            Date 05Jan05               *
      *                 BUG5291 *CREATE    Date 18Nov03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD095CC1 - Allow Deal Sub-Type and Branch for IRS, FRA and  *
      *              CCF SSIs                                         *
      *  MD035359 - Buffer issue in CIRS due to CDL094                *
      *           - Applied for MD038200.                             *
      *  MD031584 - Error encountered during complete. Added parameter*
      *             entries for CSW214 changes.                       *
      *  MD029165 - Manually defined values in field 72 of Settlement *
      *             Confirmation tab are being overwritten            *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD030454 - Errors encountered during confirm authorise.      *
      *             Correct mapping to include fields for CDL094.     *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD029596 - FRNT of DEALSDG not being populated. Remove part  *
      *             of GEMS248489.                                    *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD025726 - Retrieve ISDA details from FRA/IRS ICD for        *
      *             customers with no extended settlement details     *
      *             (SSI).                                            *
      *  264029 - Fix 233467 from IRVNPCD01 was moved here. Error msg *
      *           RS00076 and RS00077 will appear when xNPCD = blanks *
      *           while principal change schedules <> blanks.         *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  MD023734 - Clearing Threshold Indicator not defaulted.       *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  MD000091 - Event Codes Substitution                          *
      *  AR981707 - Cannot authorise an amendment to IRS deal when    *
      *             auto-authorised flag is 'Y'. Blank-out RXAUTH     *
      *             in SETUPAMEND subroutine. (Child: AR981710)       *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248489 - Front Office ID blanked out when deal is edited.    *
      *  244254 - Retrieve ISDA details from customer's default       *
      *           settlement details even if the pay/recv details     *
      *           are manually input on the screen.                   *
      *  240134 - Ensure to pass the principal amount.                *
      *  BUG11950 - A serious Midas error upon completion of          *
      *             Transaction                                       *
      *  240412 - Projected Account Movement not updated for RX       *
      *           Principal Change Amount amendment. Apply 236794.    *
      *  240240 - CALLB FFDATE. Call results in 'cannot resolve' bug. *
      *  BUG8997 - Do not default settlements if any of the FRA/IRS   *
      *            extended settlements have been entered             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  BUG11254-Positions of the schedules on the buffer were not   *
      *           changed to cope with impact of CLE031 changes.      *
      *           Also CDL038 changes when rebuilding buffer is wrong *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9714- Must be included in SynMan's delivery due to        *
      *           changes made by CLE031 in files SDESFPPD, SDESFRPD, *
      *           SDESSPPD, and SDESSRPD.(Recompile)                  *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG7621 - Retrieve schedules even if related frequency is    *
      *            not 'Z' or 'C' in the case of cashflow schedules   *
      *  BUG5871 - Send deal status to MidasPlus                      *
      *  BUG6512 - Retrieve TRAM details                              *
      *  BUG7209 - Need to distinguish which settlement tab an error  *
      *            message refers to                                  *
      *  BUG7046 - Validate principal change schedule if present      *
      *  BUG6671 - Implement Auto Authorisation                       *
      *  BUG6940 - Default ISDA fields correctly                      *
      *  BUG6876 - Need the current deal in screen format before      *
      *            the call to the VAL module                         *
      *  BUG6472- Added a sign field to short term rate               *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG6419 - Use correct currency for schedule amounts          *
      *  BUG6517 - Principle change schedule amounts are lost if      *
      *            there is an error because they are not validated   *
      *  BUG6377 - Need Fixing Dates (Ours and Theirs) ADDED to       *
      *            the confirmation screens                           *
      *  BUG6494 - Need to validate details in authorisation mode     *
      *  BUG6418 - Do not produce MT202/MT210 for backvalued CIRS's   *
      *  BUG6326 - Extra Settlements are not setup correctly          *
      *  BUG5962RP- Default Maturity Date Settlements from Interest   *
      *             settlements if Interest settlements entered       *
      *  BUG5964-Schedule 1st non processed date should be the same as*
      *          the date in the main details                         *
      *  BUG5962- Check on CIR003 is invalid                          *
      *  BUG5967- Default ISDA settlement fields                      *
      *  BUG5610- Amount formatting                                   *
      *  BUG5449- Schedules added to CIRS                             *
      *  BUG5291- MidasPlus Completion of CIRS                        *
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

     F**********IRVDTSCPD UF A E             DISK    INFSR(*PSSR)                            BUG5449
     F**********                                     COMMIT                                  BUG5449
      **********                                                                             BUG5449
     F**********IRVCFSCPD UF A E             DISK    INFSR(*PSSR) PREFIX(CV)                 BUG5449
     F**********                                     COMMIT                                  BUG5449
      **********                                                                             BUG5449
     F**********IRVPCSCPD UF A E             DISK    INFSR(*PSSR) PREFIX(PV)                 BUG5449
     F**********                                     COMMIT                                  BUG5449
      **********                                                                             BUG5449
     F**********IRWDTSCL0 UF A E           K DISK    INFSR(*PSSR)                            BUG5449
     F**********                                     COMMIT                                  BUG5449
      **********                                                                             BUG5449
     F**********IRWCFSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(C)                  BUG5449
     F**********                                     COMMIT                                  BUG5449
      **********                                                                             BUG5449
     F**********IRWPCSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(P)                  BUG5449
     F**********                                     COMMIT                                  BUG5449
      **********                                                                             BUG5449
     F**********IRWCIRSL0 UF A E           K DISK    INFSR(*PSSR)                            BUG5449
     F**********                                     COMMIT                                  BUG5449
      **********                                                                             BUG5449
     F**********IRTDTSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(D)                  BUG5449
     F**********                                     RENAME(IRVDTSCD0:IRTDTSCD0)             BUG5449
     F**********                                     COMMIT                                  BUG5449
      **********                                                                             BUG5449
     F**********IRTCFSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(C)                  BUG5449
     F**********                                     RENAME(IRVCFSCD0:IRTCFSCD0)             BUG5449
     F**********                                     COMMIT                                  BUG5449
      **********                                                                             BUG5449
     F**********IRTPCSCL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(P)                  BUG5449
     F**********                                     RENAME(IRVPCSCD0:IRTPCSCD0)             BUG5449
     F**********                                     COMMIT                                  BUG5449
     FDLDETUL0  UF A E           K DISK    INFSR(*PSSR)                                      BUG5449
     F                                               COMMIT                                  BUG5449
     FDLPCSCL0  UF   E           K DISK    RENAME(DLPCSCD0:DLPCSCX0)                         BUG5449
     F                                               PREFIX(XX)                              BUG5449
     F                                     COMMIT                                            BUG5449

                                                                                              244254
     FSDEXSTL1  IF   E           K DISK                                                       244254
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

     D********** OurRDTSC        S            492A   DIM(ArrayMax)                           BUG5449
     D********** OurIDTSC        S            492A   DIM(ArrayMax)                           BUG5449
     D********** ThrRDTSC        S            492A   DIM(ArrayMax)                           BUG5449
     D********** ThrIDTSC        S            492A   DIM(ArrayMax)                           BUG5449
     D********** OurCFSC         S           1640A   DIM(ArrayMax)                           BUG5449
     D********** ThrCFSC         S           1640A   DIM(ArrayMax)                           BUG5449
     D********** OurPCSC         S           1886A   DIM(ArrayMax)                           BUG5449
     D***********ThrPCSC         S           1886A   DIM(ArrayMax)                           BUG5449
      *  Array for job name                                                                  BUG5449
     D ARRJBNAM        S             10A   DIM(10)                                           BUG5449
      *  Array for Our rate change date Schedule                                             BUG5449
     D ORDATEA         S              8A   DIM(600)                                          BUG5449
     D ORMDATE         S              5  0 DIM(600)                                          BUG5449
     D ORDATEAST       S           4800A                                                     BUG5449
      *  Array for Our interest payment date Schedule                                        BUG5449
     D OPDATEA         S              8A   DIM(600)                                          BUG5449
     D OPMDATE         S              5  0 DIM(600)                                          BUG5449
     D OPDATEAST       S           4800A                                                     BUG5449
      *  Array for Their rate change date Schedule                                           BUG5449
     D TRDATEA         S              8A   DIM(600)                                          BUG5449
     D TRMDATE         S              5  0 DIM(600)                                          BUG5449
     D TRDATEAST       S           4800A                                                     BUG5449
      *  Array for Their interest payment date Schedule                                      BUG5449
     D TPDATEA         S              8A   DIM(600)                                          BUG5449
     D TPMDATE         S              5  0 DIM(600)                                          BUG5449
     D TPDATEAST       S           4800A                                                     BUG5449
      ** for Transaction Currencies (Receipt and Payment Currency)                           CSF011A
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      *  Date schedule                                                                       BUG5449
     D DATESCH         DS                                                                    BUG5449
     D  DSDATE                        6A                                                     BUG5449
     D  DSCHOL                        1A                                                     BUG5449
     D  DSPDAT                        1A                                                     BUG5449
      *  Array for Our cash flow Schedule                                                    BUG5449
     D OCFSA           S             22A   DIM(600)                                          BUG5449
     D OCFMDAT         S              5  0 DIM(600)                                          BUG5449
     D OCFAMT          S             13  0 DIM(600)                                          BUG5449
     D OCFSAST         S          13200A                                                     BUG5449
      *  Array for Their cash flow Schedule                                                  BUG5449
     D TCFSA           S             22A   DIM(600)                                          BUG5449
     D TCFMDAT         S              5  0 DIM(600)                                          BUG5449
     D TCFAMT          S             13  0 DIM(600)                                          BUG5449
     D TCFSAST         S          13200A                                                     BUG5449
      *  Cash Flow schedule                                                                  BUG5449
     D CASHFSCH        DS                                                                    BUG5449
     D  CFDATE                        6A                                                     BUG5449
     D  CFCHOL                        1A                                                     BUG5449
     D  CFAMT                        14A                                                     BUG5449
     D  CFPDAT                        1A                                                     BUG5449
      *  Array for our Principal change schedule                                             BUG5449
     D OPCSA           S             25A   DIM(600)                                          BUG5449
     D OPCMDAT         S              5  0 DIM(600)                                          BUG5449
     D OPCAMT          S             15  0 DIM(600)                                          BUG5449
     D OPCSAST         S          15000A                                                     BUG5449
      *  Array for their principle change schedule                                           BUG5449
     D TPCSA           S             25A   DIM(600)                                          BUG5449
     D TPCMDAT         S              5  0 DIM(600)                                          BUG5449
     D TPCAMT          S             15  0 DIM(600)                                          BUG5449
     D TPCSAST         S          15000A                                                     BUG5449
      *  Principle Change Schedule                                                           BUG5449
     D PCHGSCH         DS                                                                    BUG5449
     D  PCDATE                        6A                                                     BUG5449
     D  PCCHOL                        1A                                                     BUG5449
     D  PCAMT                        16A                                                     BUG5449
     D  PCIDFLG                       1A                                                     BUG5449
     D  PCPDAT                        1A                                                     BUG5449
      *  Array for Business Day Convention currencies                                        BUG5449
     D  PBDCCcyArr                    3A   DIM(10)                                           BUG5449
     D WMDATE          S              5  0 DIM(600)                                          BUG5449
     D WCFAMT          S             13  0 DIM(600)                                          BUG5449
     D WPCAMT          S             15  0 DIM(600)                                          BUG5449
      *  Date schedule formula for generating dates                                          BUG5449
     D FORMULAOR       DS                                                                    BUG5449
     D  SFREQFOR                      1A                                                     BUG5449
     D  SFORMOR                       7A                                                     BUG5449
     D FORMULAOP       DS                                                                    BUG5449
     D  SFREQFOP                      1A                                                     BUG5449
     D  SFORMOP                       7A                                                     BUG5449
     D FORMULATR       DS                                                                    BUG5449
     D  SFREQFTR                      1A                                                     BUG5449
     D  SFORMTR                       7A                                                     BUG5449
     D FORMULATP       DS                                                                    BUG5449
     D  SFREQFTP                      1A                                                     BUG5449
     D  SFORMTP                       7A                                                     BUG5449
     D FORMULAOC       DS                                                                    BUG5449
     D  SFREQFOC                      1A                                                     BUG5449
     D  SFORMOC                       7A                                                     BUG5449
     D  SFORMAMTOC                   14A                                                     BUG5449
     D FORMULATC       DS                                                                    BUG5449
     D  SFREQFTC                      1A                                                     BUG5449
     D  SFORMTC                       7A                                                     BUG5449
     D  SFORMAMTTC                   14A                                                     BUG5449
     D FORMULAOPC      DS                                                                    BUG5449
     D  SFREQFOPC                     1A                                                     BUG5449
     D  SFORMOPC                      7A                                                     BUG5449
     D  SFORMAMOPC                   16A                                                     BUG5449
     D  SFORMIDOPC                    1A                                                     BUG5449
     D FORMULATPC      DS                                                                    BUG5449
     D  SFREQFTPC                     1A                                                     BUG5449
     D  SFORMTPC                      7A                                                     BUG5449
     D  SFORMAMTPC                   16A                                                     BUG5449
     D  SFORMIDTPC                    1A                                                     BUG5449
     D FORMULA         DS                                                                    BUG5449
     D  SFORM                  1      7                                                      BUG5449
     D  SWRK1                  1      1                                                      BUG5449
     D  SWRK2                  2      2                                                      BUG5449
     D  SDN1                   1      2                                                      BUG5449
     D  SWRK3                  3      3                                                      BUG5449
     D  SWRK4                  4      4                                                      BUG5449
     D  SWRK5                  5      5                                                      BUG5449
     D  SDN2                   4      5                                                      BUG5449
     D  SWRK6                  6      6                                                      BUG5449
     D  S456                   4      6                                                      BUG5449
     D  SWRK7                  7      7                                                      BUG5449
     D LETT            S              1    DIM(7) CTDATA PERRCD(7)                           BUG5449
      ** Internally described data structure for ZDATE                                       BUG5449
     D DateDS          DS             6                                                      BUG5449
     D  DteMth                 1      2A                                                     BUG5449
     D  DteDay                 3      4A                                                     BUG5449
     D  DteYr                  5      6A                                                     BUG5449

     D HeadIn        E DS                  EXTNAME(APHEADPD)
      * Incoming Header
     D WMSGTYPE                1      6

     D TranIn        E DS                  EXTNAME(IRCIRSPD)
     D**********PBDCCcy                243    306                                    BUG5449 BUG6472
     D PBDCCcy               288    317                                                      BUG6472
      * Incoming Transaction
     D**********WBDCLeg1              243    272                                             BUG6472
     D**********WBDCLeg2              307    336                                             BUG6472

     D ValidDeal     E DS                  EXTNAME(IRVCIRSPD)
      * Valid Deals layout
     D CIRSRecIns            716    784
     D CIRSPayIns            785   1343
     D CIRSFraIns           1345   1992
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
                                                                                             BUG5291
     D ValidXDeal    E DS                  EXTNAME(IRVXSIRPD)                                BUG5291
      * Valid Deals layout                                                                   BUG5291

     D DealFilFmt    E DS                  EXTNAME(DEALSDG)
      * (Current) Deal in File Format
     D DGRecIns              716    784
     D DGPayIns              785   1343
     D DGFraIns             1345   1992
      * Large fields to include
      * - Receive instructions (RSTM to ROCN)
      * - Pay     instructions (PSTM to BTB6)
                                                                                             BUG5291
     D DealXFilFmt   E DS                  EXTNAME(DLDLDGQD)                                 BUG5291
      ** Deal Extension File Format                                                          BUG5291

     D DealScnFmt    E DS                  EXTNAME(IRCIRSPD)
     D                                     PREFIX(@)
      * (Current) Deal in Screen Format

     D**********OurRatChgD    E DS                  EXTNAME(IRDTSCPD)                        BUG5449
      **Our*Rate*Change Dates (IRCs)                                                         BUG5449
     D**********                                    PREFIX(OR)                               BUG5449
     D**********ORDatesAlp              1    492                                             BUG5449
      **********                                                                             BUG5449
     D********** OurIntPayD    E DS                  EXTNAME(IRDTSCPD)                       BUG5449
      **Our*Interest*Payment Dates (IRCs)                                                    BUG5449
     D**********                           PREFIX(OP)                                        BUG5449
     D**********OPDatesAlp              1    492                                             BUG5449
      **********                                                                             BUG5449
     D**********ThrRatChgD    E DS                  EXTNAME(IRDTSCPD)                        BUG5449
      **Their*Rate Change Dates (IRCs)                                                       BUG5449
     D**********                           PREFIX(TR)                                        BUG5449
     D**********TRDatesAlp              1    492                                             BUG5449
      **********                                                                             BUG5449
     D**********ThrIntPayD    E DS                  EXTNAME(IRDTSCPD)                        BUG5449
      **Their*Interest Payment Dates (IRCs)                                                  BUG5449
     D**********                           PREFIX(TP)                                        BUG5449
     D**********TPDatesAlp              1    492                                             BUG5449
      **********                                                                             BUG5449
     D**********OurRatChgD2   E DS                  EXTNAME(IRDTSCPD) PREFIX(OR2)            BUG5449
      ***Our*Rate Change Dates (IRCs)                                                        BUG5449
     D**********ORDatesAlp2             1    492                                             BUG5449
      **********                                                                             BUG5449
     D**********OurIntPayD2   E DS                  EXTNAME(IRDTSCPD) PREFIX(OP2)            BUG5449
      ***Our*Interest Payment Dates (IRCs)                                                   BUG5449
     D**********OPDatesAlp2             1    492                                             BUG5449
      **********                                                                             BUG5449
     D**********ThrRatChgD2   E DS                  EXTNAME(IRDTSCPD) PREFIX(TR2)            BUG5449
      ***Their*Rate Change Dates (IRCs)                                                      BUG5449
     D**********TRDatesAlp2             1    492                                             BUG5449
      **********                                                                             BUG5449
     D**********ThrIntPayD2   E DS                  EXTNAME(IRDTSCPD) PREFIX(TP2)            BUG5449
      ***Their* Interest Payment Dates (IRCs)                                                BUG5449
     D**********TPDatesAlp2             1    492                                             BUG5449
      **********                                                                             BUG5449
     D**********CshFlwDS      E DS                  EXTNAME(IRCFSCPD) PREFIX(CS)             BUG5449
      ***Cash*Flow Schedule (used to save cash flow records in IRWCFSCPD file)               BUG5449
     D**********WCshFlw1                1    492                                             BUG5449
     D**********WCshFlw2              493    982                                             BUG5449
     D**********WCshFlw3              983   1472                                             BUG5449
     D**********WCshFlw4             1473   1640                                             BUG5449
      **********                                                                             BUG5449
     D**********PrcChgDS      E DS                  EXTNAME(IRPCSCPD) PREFIX(PR)             BUG5449
      **********Principal Change Schedule (used to save principal change records             BUG5449
      ***in*IRWPCSCPD file)                                                                  BUG5449
     D**********WPrcChg1                1    492                                             BUG5449
     D**********WPrcChg2              493    988                                             BUG5449
     D**********WPrcChg3              989   1484                                             BUG5449
     D**********WPrcChg4             1485   1886                                             BUG5449
      **********                                                                             BUG5449
     D**********WCshFlwDS     E DS                  EXTNAME(IRWCFSCPD) PREFIX(C)             BUG5449
      **********Cash Flow Schedule work definition file (DS of IRWCFSCL0 defined in F Specs) BUG5449
     D**********WCashFlw               43   1682                                             BUG5449
      **********                                                                             BUG5449
     D**********WPrcChgDS     E DS                  EXTNAME(IRWPCSCPD) PREFIX(P)             BUG5449
      **********Principal Change Schedule work definition file (DS of IRWPCSCL0 defined      BUG5449
      **********in F Specs)                                                                  BUG5449
     D**********WPrinChg               43   1928                                             BUG5449
      **********                                                                             BUG5449
     D**********OurCshFDS     E DS                  EXTNAME(IRWCFSCPD) PREFIX(OC)            BUG5449
      ***Our*Cash Flow Schedule (used to validate our cash flow)                             BUG5449
     D**********WOurCshFD              43    534                                             BUG5449
     D**********WOurCshFA             535   1682                                             BUG5449
     D**********WOurCash               43   1682                                             BUG5449
      **********                                                                             BUG5449
     D**********ThrCshFDS     E DS                  EXTNAME(IRWCFSCPD) PREFIX(TC)            BUG5449
      **********Their Cash Flow Schedule (used to validate their cash flow)                  BUG5449
     D**********WThrCshFD              43    534                                             BUG5449
     D**********WThrCshFA             535   1682                                             BUG5449
     D**********WThrCash               43   1682                                             BUG5449
      **********                                                                             BUG5449
     D**********OurPrcCDS     E DS                  EXTNAME(IRWPCSCPD) PREFIX(OP)            BUG5449
      ***Our*Principal Change Schedule (used to validate our prin change)                    BUG5449
     D**********WOurPrcCD              43    534                                             BUG5449
     D**********WOurPrcCA             535   1846                                             BUG5449
     D**********WOurPrcCI            1847   1928                                             BUG5449
     D**********WOurPrin               43   1928                                             BUG5449
                                                                                             BUG5449
     D**********ThrPrcCDS     E DS                  EXTNAME(IRWPCSCPD) PREFIX(TP)            BUG5449
      **Their*Principal Change Schedule (used to validate their prin change)                 BUG5449
     D**********WThrPrcCD              43    534                                             BUG5449
     D**********WThrPrcCA             535   1846                                             BUG5449
     D**********WThrPrcCI            1847   1928                                             BUG5449
     D**********WThrPrin               43   1928                                             BUG5449
      **********                                                                             BUG5449
     D**********WrkCIRSDS     E DS                  EXTNAME(IRWCIRSPD)                       BUG5449
      ***CIRS*work file DS (used to save x-ccy records in IRWCIRSPD)                         BUG5449
     D**********WIRCIRS                42    477                                             BUG5449
      **********                                                                             BUG5449
     D**********WrkDTSCDS     E DS                  EXTNAME(IRWDTSCPD)                       BUG5449
      **DTSC work file DS (used to save irc records in IRWDTSCPD)                            BUG5449
     D**********WDFOTRANID    E                     EXTFLD(WSFOTRANID)                       BUG5449
     D**********WDFOASOCID    E                     EXTFLD(WSFOASOCID)                       BUG5449
     D**********WDRPRLOCN     E                     EXTFLD(WSRPRLOCN)                        BUG5449
     D**********WIRDTSC                44    535                                             BUG5449
      **********                                                                             BUG5449
     D**********TIntRtCDS     E DS                  EXTNAME(IRTDTSCPD) PREFIX(D)             BUG5449
      **Cash*Flow Schedule temporary definition file (used to save valid records             BUG5449
      **in*IRTDTSCPD)                                                                        BUG5449
     D**********WIntRtC                23    268                                             BUG5449
     D**********WDTSCConfH            269    350                                             BUG5449
      **********                                                                             BUG5449
     D**********TCshFlwDS     E DS                  EXTNAME(IRTCFSCPD) PREFIX(C)             BUG5449
      ***Cash*Flow Schedule temporary definition file (used to save valid records            BUG5449
      ***in*IRTCFSCPD)                                                                       BUG5449
     D**********WCashFlwD              22    267                                             BUG5449
     D**********WCashFlwA             268    841                                             BUG5449
     D**********WCFSCConfH            842    923                                             BUG5449
      **********                                                                             BUG5449
     D**********TPrcChgDS     E DS                  EXTNAME(IRTPCSCPD) PREFIX(P)             BUG5449
      ***Principal Change Schedule temporary definition file (used to save valid             BUG5449
      ***records*in IRTPCSCPD)                                                               BUG5449
     D**********WPrinChgD              22    267                                             BUG5449
     D**********WPrinChgA             268    923                                             BUG5449
     D**********WPrinChgCA            924   1579                                             BUG5449
     D**********WPCSCConfH           1580   1661                                             BUG5449
     D**********WPCSCIDInd           1662   1743                                             BUG5449
      **********                                                                             BUG5449
     D**********VldCashFlw    E DS                  EXTNAME(IRVCFSCPD) PREFIX(CV)            BUG5449
      ***Valid*Cash Flow definition file (use to write valid records in IRVCFSCPD)           BUG5449
      **********                                                                             BUG5449
     D**********VldPrinChg    E DS                  EXTNAME(IRVPCSCPD) PREFIX(PV)            BUG5449
      ***Valid*Prin Change def file (use to write valid records in IRVPCSCPD)                BUG5449
      **********                                                                             BUG5449
     D**********InvCashFlw    E DS                  EXTNAME(IRICFSCPD) PREFIX(CI)            BUG5449
      ***Invld*Cash Flow definition file (use to write invld records in IRICFSCPD)           BUG5449
     D**********WInvCshFlw             23   1662                                             BUG5449
      **********                                                                             BUG5449
     D**********InvPrinChg    E DS                  EXTNAME(IRIPCSCPD) PREFIX(PI)            BUG5449
      ***Invld*Prin Change def file (use to write invld records in IRIPCSCPD)                BUG5449
     D**********WInvPrcChg             23   1908                                             BUG5449
      **********                                                                             BUG5449
     D**********TrailerDS     E DS                  EXTNAME(IRTRSCPD)                        BUG5449
      ***Trailer file DS                                                                     BUG5449
      **********                                                                             BUG5449
     D**********DatesToVal      S            492A                                            BUG5449
      ***Date*array parameter passed to IRVIRCVAL                                            BUG5449
      **********                                                                             BUG5449
     D**********ValidDates      S            246A   INZ(*BLANKS)                             BUG5449
      ***IRC*valid dates returned from IRVIRCVAL                                             BUG5449

     D*ValidExt******E DS                  EXTNAME(IRVXSETPD)  PREFIX(EX)                    BUG6326
     D**ExRSet********        10     84                                                      BUG6326
     D**ExPSet********        85    653                                                      BUG6326

     D ExtSetV       E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(VD)
     D**ExRValDat*****        10     84                                                      BUG6326
     D**ExPValDat*****        85    653                                                      BUG6326
     D  ExRValDat             10     90                                                      BUG6326
     D  ExPValDat             91    665                                                      BUG6326

     D ExtSetM       E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(MD)
     D**ExRMatDat*****        10     84                                                      BUG6326
     D**ExPMatDat*****        85    653                                                      BUG6326
     D  ExRMatDat             10     90                                                      BUG6326
     D  ExPMatDat             91    665                                                      BUG6326

     D ExtSetI       E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(ID)
     D  ExRIntDat             10     90                                                      BUG6326
     D  ExPIntDat             91    665                                                      BUG6326
     D  ExFIntDat            666   1315                                                      BUG6326

     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions - Input

     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions - Input

     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions - Input

     D InPayStmtE    E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(E)
      * Pay Settlement Instructions - Extra Settlements

     D InRecStmtE    E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(E)
      * Receive Settlement Instructions - Extra Settlements

     D InFRAStmtE    E DS                  EXTNAME(SDESSFPD)
     D                                     PREFIX(E)
      * FRA/IRS Settlement Instructions - Extra Settlements

     D InPayStmtV    E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(V)
      * Pay Settlement Instructions - Value date

     D InRecStmtV    E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(V)
      * Receive Settlement Instructions - Vaue Date

     D InPayStmtM    E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(M)
      * Pay Settlement Instructions - Maturity Date

     D InRecStmtM    E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(M)
      * Receive Settlement Instructions - Maturity Date

     D CrPayStmtE    E DS                  EXTNAME(SDESSPPD) PREFIX(C)
      * Pay Settlement Instructions - Current  (Extra)

     D CrRecStmtE    E DS                  EXTNAME(SDESSRPD) PREFIX(C)
      * Receive Settlement Instructions - Current  (Extra)

     D CrFRAStmtE    E DS                  EXTNAME(SDESSFPD) PREFIX(C)
      * FRA/IRS Settlement Instructions - Current (Extra)

     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
      * Pay Settlement Instructions - Current

     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
      * Receive Settlement Instructions - Current

     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
      * FRA/IRS Settlement Instructions - Current

     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
      * Pay Settlement Instructions - File (D/B) format

     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
      * Receive Settlement Instructions - File (D/B) format

     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS Settlement Instructions - File (D/B) format

     D DBPayStmtE    E DS                  EXTNAME(SDESFPPD)
     D                                     PREFIX(E)
      * Pay Settlement Instructions - File (D/B) format (Extra)

     D DBRecStmtE    E DS                  EXTNAME(SDESFRPD)
     D                                     PREFIX(E)
      * Receive Settlement Instructions - File (D/B) format (Extra)

     D DBFRAStmtE    E DS                  EXTNAME(SDESFFPD)
     D                                     PREFIX(E)
      * FRA/IRS Settlement Instructions - File (D/B) format (Extra)

     D DBPayStmtV    E DS                  EXTNAME(SDESFPPD)
     D                                     PREFIX(V)
      * Pay Settlement Instructions - File (D/B) format (Value date)

     D DBRecStmtV    E DS                  EXTNAME(SDESFRPD)
     D                                     PREFIX(V)
      * Receive Settlement Instructions - File (D/B) format (Value date)

     D DBPayStmtM    E DS                  EXTNAME(SDESFPPD)
     D                                     PREFIX(M)
      * Pay Settlement Instructions - File (D/B) format (Maturity date)

     D DBRecStmtM    E DS                  EXTNAME(SDESFRPD)
     D                                     PREFIX(M)
      * Receive Settlement Instructions - File (D/B) format (Maturity date)

      ** FRA/IRS Interface Non-Screen Data
     D InfData       E DS                  EXTNAME(IRRXIFPD)

     D ExtData       E DS                  EXTNAME(IRCSEXPD)
      * IR Cross Ccy IRS Extra Data - File (D/B) format

     D ValIRCData    E DS                  EXTNAME(IRVDTSCPD)
      * Valid Interest Rate Calendar Dates

     D DBORatChgD    E DS                  EXTNAME(IRVDTSCPD)
      * Our Rate Change Dates (IRCs) - Midas Day Number format
     D                                     PREFIX(OR)
     D ORFoTran      E                     EXTFLD(XFOTRANID)
     D ORDates                23    268A
     D ORConfH               269    350A

     D DBOIntPayD    E DS                  EXTNAME(IRVDTSCPD)
      * Our Interest Payment Dates (IRCs) - Midas Day Number format
     D                                     PREFIX(OP)
     D OPFoTran      E                     EXTFLD(XFOTRANID)
     D OPDates                23    268A
     D OPConfH               269    350A

     D DBTRatChgD    E DS                  EXTNAME(IRVDTSCPD)
      * Their Rate Change Dates (IRCs) - Midas Day Number format
     D                                     PREFIX(TR)
     D TRFoTran      E                     EXTFLD(XFOTRANID)
     D TRDates                23    268A
     D TRConfH               269    350A

     D DBTIntPayD    E DS                  EXTNAME(IRVDTSCPD)
      * Their Interest Payment Dates (IRCs) - Midas Day Number format
     D                                     PREFIX(TP)
     D TPFoTran      E                     EXTFLD(XFOTRANID)
     D TPDates                23    268A
     D TPConfH               269    350A

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                 BUG5449
      ** Midas Modules Details Accessed via access program                                   BUG5449

      ** External DS for Deal details                                                         245692
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692
     D W#ACCD        E                     EXTFLD(QQACCD)                                     245692
                                                                                              245692
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
      ** External data structure for FRA/IRS I.C.D. details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
     D XLCD          E                     EXTFLD(LCD)
      *
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
     D                                     PREFIX(A)
      *
      ** Transaction Details retrieved from file - in screen
      ** format
     D CrFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
     D                                     PREFIX(B)
      *
      ** Transaction Details OK indicators
     D OKFBScnFmt    E DS                  EXTNAME(IREFEBOPD)
      *
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      ** First DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status data area

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
      *                                                                                      BUG5449
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG5449
      ** Midas SC Jobs handling commitment control data area                                 BUG5449
     D  COMITNOM               1      3S 0                                                   BUG5449
     D  COMITJOB               4    103                                                      BUG5449
      *                                                                                      BUG5449
      **ISDA settlement fields                                                               BUG5967
     D WWAGVV          DS             4                                                      BUG5967
     D WDAGVC                  1      2                                                      BUG5967
     D WDAGVV                  3      4                                                      BUG5967
                                                                                              CSW213
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
     D  DLRPIFS1In                         LIKE(DLRPIFScn1Fmt)                                CSW213
     D  DLRPIFS2In                         LIKE(DLRPIFScn2Fmt)                                CSW213
     D  DLRPIFS3In                         LIKE(DLRPIFScn3Fmt)                                CSW213
RGC  D  DLRPIFS4In                         LIKE(DLRPIFScn4Fmt)                                CSW214
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
                                                                                              CSW213

      ** RPIF Error File - Screen 4                                                           CSW214
     D DLError4      E DS                  EXTNAME(DLERI4PD)                                  CSW214
                                                                                              CSW214
     D/COPY QWINDSRC,IRCIRSGDTA

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
     D*Trans500********S            500A                                                      CDL028
     D Trans1000       S           1000A                                                      CDL028

      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      ** Field (500A) to receive the incoming Interface Non-Screen Data
     D InfData500      S            500A

      ** Fields (500A) to receive the incoming Interest Rate Calendar info
     D TransB500       S            500A
     D TransC500       S            500A
     D TransD500       S            500A
     D TransE500       S            500A
     D TransF500       S            500A
     D TransG500       S            500A
     D TransH500       S            500A

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

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
     D  SCAInOK                       1A   INZ('Y')
     D  SOYLCOK                       1A   INZ('Y')                                           CDL038
     D  STYLCOK                       1A   INZ('Y')                                           CDL038
     D  SOFYCOK                       1A   INZ('Y')                                           CDL038
     D  STFYCOK                       1A   INZ('Y')                                           CDL038
     D  SFCCUOK                       1A   INZ('Y')                                           CDL038
     D  SFACTOK                       1A   INZ('Y')                                           CDL038
     D  SFCNOOK                       1A   INZ('Y')                                           CDL038
     D  SOFCCOK                       1A   INZ('Y')                                           CDL038
     D  STFCCOK                       1A   INZ('Y')                                           CDL038
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
     D  OKC1P2                        1A   INZ('Y')
     D  OKC2P2                        1A   INZ('Y')
     D  OKC3P2                        1A   INZ('Y')
     D  OKC4P2                        1A   INZ('Y')
     D  OKC5P2                        1A   INZ('Y')
     D  OKC6P2                        1A   INZ('Y')
     D  OKC7P2                        1A   INZ('Y')
     D  OKC8P2                        1A   INZ('Y')
     D  OKC9P2                        1A   INZ('Y')
     D  OKC0P2                        1A   INZ('Y')
     D  OKPDC2                        1A   INZ('Y')
     D  OKAMC2                        1A   INZ('Y')
     D  OKC1R2                        1A   INZ('Y')
     D  OKC2R2                        1A   INZ('Y')
     D  OKC3R2                        1A   INZ('Y')
     D  OKC4R2                        1A   INZ('Y')
     D  OKC5R2                        1A   INZ('Y')
     D  OKC6R2                        1A   INZ('Y')
     D  OKC7R2                        1A   INZ('Y')
     D  OKC8R2                        1A   INZ('Y')
     D  OKC9R2                        1A   INZ('Y')
     D  OKC0R2                        1A   INZ('Y')
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
     D**OKOYLC************************1A   INZ('Y')                                           CDL038
     D**OKTYLC************************1A   INZ('Y')                                           CDL038
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

      ** Flags to indicate whether Extra Pay Settlement instruction fields
      **  are valid
     D OKPayInsDSE     DS
     D  DDPscyOKE                     1A   INZ('Y')
     D  DDPstmOKE                     1A   INZ('Y')
     D  DDPonxOKE                     1A   INZ('Y')
     D  DDRvnoOKE                     1A   INZ('Y')
     D  DDCvmrOKE                     1A   INZ('Y')
     D  DDPocnOKE                     1A   INZ('Y')
     D  DDPobnOKE                     1A   INZ('Y')
     D  DDRcrnOKE                     1A   INZ('Y')
     D  DDRcraOKE                     1A   INZ('Y')
     D  DDPibnOKE                     1A   INZ('Y')
     D  DDPibaOKE                     1A   INZ('Y')
     D  DDAwbnOKE                     1A   INZ('Y')
     D  DDAwbaOKE                     1A   INZ('Y')
     D  DDBennOKE                     1A   INZ('Y')
     D  DDBenaOKE                     1A   INZ('Y')
     D  DDDtp1OKE                     1A   INZ('Y')
     D  DDDtp2OKE                     1A   INZ('Y')
     D  DDDtp3OKE                     1A   INZ('Y')
     D  DDDtp4OKE                     1A   INZ('Y')
     D  DDDchgOKE                     1A   INZ('Y')
     D  DDIc72OKE                     1A   INZ('Y')
     D  DDBtb1OKE                     1A   INZ('Y')
     D  DDBtb2OKE                     1A   INZ('Y')
     D  DDBtb3OKE                     1A   INZ('Y')
     D  DDBtb4OKE                     1A   INZ('Y')
     D  DDBtb5OKE                     1A   INZ('Y')
     D  DDBtb6OKE                     1A   INZ('Y')

      ** Flags to indicate whether Extra Receive Settlement instruction fields
      **  are valid
     D OKRecInsDSE     DS
     D  DDRscyOKE                     1A   INZ('Y')
     D  DDRstmOKE                     1A   INZ('Y')
     D  DDRonxOKE                     1A   INZ('Y')
     D  DDRocnOKE                     1A   INZ('Y')
     D  DDRobnOKE                     1A   INZ('Y')
     D  DDRibnOKE                     1A   INZ('Y')
     D  DDRibaOKE                     1A   INZ('Y')

      ** Flags to indicate whether Extra FRA/IRS instruction fields are valid
     D OKCIRSInDSE     DS
     D  DDDsr1OKE                     1A   INZ('Y')
     D  DDDsr2OKE                     1A   INZ('Y')
     D  DDDsr3OKE                     1A   INZ('Y')
     D  DDDsr4OKE                     1A   INZ('Y')
     D  DDDsr5OKE                     1A   INZ('Y')
     D  DDDsr6OKE                     1A   INZ('Y')
     D  DDSsr1OKE                     1A   INZ('Y')
     D  DDSsr2OKE                     1A   INZ('Y')
     D  DDSsr3OKE                     1A   INZ('Y')
     D  DDSsr4OKE                     1A   INZ('Y')
     D  DDSsr5OKE                     1A   INZ('Y')
     D  DDSsr6OKE                     1A   INZ('Y')
     D  DDCnd1OKE                     1A   INZ('Y')
     D  DDCnd2OKE                     1A   INZ('Y')
     D  DDCnd3OKE                     1A   INZ('Y')
     D  DDCnd4OKE                     1A   INZ('Y')
     D  DDCnd5OKE                     1A   INZ('Y')
     D  DDCnd6OKE                     1A   INZ('Y')
     D  DDIsdaOKE                     1A   INZ('Y')
     D  DDAgtyOKE                     1A   INZ('Y')
     D  DDAgdtOKE                     1A   INZ('Y')
     D  DDAgvvOKE                     1A   INZ('Y')

      ** Flags to indicate outcome of calls to lower level modules
     D AmendOK         S              1A   INZ('Y')
     **********                                                                              BUG5449
     ****Flag*to indicate whether Interest Rate Calendars data valid                         BUG5449
     D*OKInRatCal**    S              1A   INZ('Y')                                          BUG5449

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
     D RecNostro       S             18A                                                      CDL038
     D*RecNostro*******S             12A                                                      CDL038
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             18A                                                      CDL038
     D*PayNostro*******S             12A                                                      CDL038

      ** Validate Business Day Convention flag
     D WValBDC         S              1A   INZ('N')

      ** Switchable Feature Parameter
     D CIR001          S              1A
     D CIR002          S              1A
     D CIR003          S              1A
     D CIR005          S              1A
     D CIR006          S              1A
     D CIR007          S              1A
     D CIR008          S              1A
     D CAP056          S              1A
     D CAP051          S              1A                                                     BUG6671
     D CLE025          S              1    INZ('N')                                          BUG5291

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
     D PDealNum        S             18A
     D PADealNo        S             18A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A

     D ModeofOp        S              6
     D ScreenInpt      S              1
     D APIRetc         S              1
     D Buffer          S           6000
     D Buffer2         S           3999                                                      BUG5449
     D BufferEx2       S           9999                                                      BUG5449
     D BufferEx3       S           9999                                                      BUG5449
     D BufferEx4       S           9999                                                      BUG5449
     D BufferEx5       S           9999                                                      BUG5449
     D BufferEx6       S           9999                                                      BUG5449
     D BufferEx7       S           9999                                                      BUG5449
     D BufferEx8       S           9999                                                      BUG5449
     D BufferEx9       S           9999                                                      BUG5449
     D UpdateYN        S              1

      ** Fields defined
     D OKCshFlw        S              1A   INZ('Y')
     D OKPrcChg        S              1A   INZ('Y')
     D PAction         S              1A
     D PDealNo         S              6A
     D PPrevDate       S              5P 0
     D PValType        S              1A
     D POurTheir       S              1A
     D PCurrency       S              3A
     D PAmtToVal1      S           1148A
     D PAmtToVal2      S           1312A
     D PIncDecInd      S             82A
     D PConfHol        S             82A
     D PBDConvtn       S             30A
     D PValidCAmt      S            656A
     D PValidAmnt      S            574A
     D WMSGTYPE2       S              6A
     D WORPrvDate      S              5P 0
     D WOPPrvDate      S              5P 0
     D WTRPrvDate      S              5P 0
     D WTPPrvDate      S              5P 0
     D WRatePay        S              1A
     D WOurTheir       S              1A
     D X               S              3  0
     D PCtlDate        S              5P 0

     D ##ACTN          S              1
     D ##ValIter       S              3
     D CurDATA         S           2000
     D IncDATA         S           2000
     D SubsChar        S              1
                                                                                             BUG5449
     D CSC022          S              1A   INZ('N')                                          BUG5449
      ** Counter variable                                                                    BUG5449
     D WCMT01          S              1A                                                     BUG5449
      ** Commitment Flag                                                                     BUG5449
                                                                                             BUG5449
      ** Date converted to Midas Dayno format                                                BUG5449
     D   InDateMDN     S              5P 0                                                   BUG5449
                                                                                             BUG5449
      ** Date to be validated                                                                BUG5449
     D   InDate        S              6                                                      BUG5449
                                                                                             BUG5449
      ** Confirm holiday to be validated                                                     BUG5449
     D   CHol          S              1                                                      BUG5449
                                                                                             BUG5449
      ** Processed date flag                                                                 BUG5449
     D   ProcDate      S              1                                                      BUG5449
                                                                                             BUG5449
      ** Array index                                                                         BUG5449
     D I               S              3  0                                                   BUG5449
     D K               S              3  0                                                   BUG5449
     D L               S              3  0                                                   BUG5449
     D A               S              3  0                                      BUG5964
     D B               S              3  0                                      BUG5964
      ** Date schedule type                                                                  BUG5449
     D WDealNo         S              6  0                                                   BUG5449
     D WCTLDYN         S              5P 0                                                   BUG5449
     D WDTSCFound      S              1A                                                     BUG5449
     D WCFSCFound      S              1A                                                     BUG5449
     D WPCSCFound      S              1A                                                     BUG5449
     D WAmount         S             16A                                                     BUG5449
     D WONBDP          S                   LIKE(A6NBDP)                                      BUG5449
     D WPNBDP          S                   LIKE(A6NBDP)                                      BUG5449
     D WRNBDP          S                   LIKE(A6NBDP)                                      BUG5449
     D WRSCY           S              3A                                                     BUG5449
     D WPSCY           S              3A                                                     BUG5449
     D WHoliday        S              1A                                                     BUG5449
     D WRK153          S             15  3                                                   BUG5449
     D WRK30           S              3  0                                                   BUG5449
     D WPAMT           S             15  0                                                   BUG5449
     D SFREQF          S              1A                                                     BUG5449
     D ZDATE           S              6P 0                                                   BUG5449
     D ZDAYNO          S              5P 0                                                   BUG5449
     D PDAT            S              1A                                                     BUG5449
     D SUINFD          S              6A                                                     BUG6377
     D STINFD          S              6A                                                     BUG6377
     D OurRate         C                   CONST('Our Interest Rate Change +                 BUG5449
     D                                                 Schedule')                            BUG5449
     D OurPay          C                   CONST('Our Interest Payment +                     BUG5449
     D                                                 Schedule')                            BUG5449
     D TheirRate       C                   CONST('Their Interest Rate Change +               BUG5449
     D                                                 Schedule')                            BUG5449
     D TheirPay        C                   CONST('Their Interest Payment +                   BUG5449
     D                                                 Schedule')                            BUG5449
     D OurCash         C                   CONST('Our Cash Flow Schedule')                   BUG5449
     D TheirCash       C                   CONST('Their Cash Flow Schedule')                 BUG5449
     D OurPrinChg      C                   CONST('Our Principle Change +                     BUG5449
     D                                                 Schedule')                            BUG5449
     D TheirPrinChg    C                   CONST('Their Principle Change +                   BUG5449
     D                                                 Schedule')                            BUG5449
                                                                                             BUG7209
      ** Fields needed to correctly setup error msgs on the three settlement screens         BUG7209
     D BfIdx           S              3P 0                                                   BUG7209
     D BfWIdx          S              3P 0                                                   BUG7209
     D AfIdx           S              3P 0                                                   BUG7209
     D AfWIdx          S              3P 0                                                   BUG7209
     D mNo             S              3P 0                                                   BUG7209
     D SetPrfx         S              1A                                                     BUG7209
      ** Fields needed to note whether unprocessed schedules exist                           BUG7621
     D UPPSCH          DS                                                                    BUG7621
     D UPOPSCH                        1A                                                     BUG7621
     D UPTPSCH                        1A                                                     BUG7621
     D UPOCSCH                        1A                                                     BUG7621
     D UPTCSCH                        1A                                                     BUG7621
      ** Work Variables for RPIF                                                              CSW213
     D ValScrnNo       S              1  0                                                    CSW213
     D CSW213          S              1                                                       CSW213
     D CtrX            S              3S 0                                                    CSW213
     D RIdx            S              3P 0                                                    CSW213
     D WRIdx           S              3P 0                                                    CSW213
     D DUpdateYN       S              1A                                                      CSW213

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

      /COPY WNCPYSRC,IRCIRSC001

      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.
     C**********         MOVEL     Trans500      TranIn                                       CDL028
     C                   MOVEL     Trans1000     TranIn                                       CDL028
     C**********         MOVEL     Extdata500    Extdata                                     BUG5449
     C**********         MOVEL     InfData500    InfData                                     BUG5449
     C                   MOVEL     InfData500    InfData                                     BUG6671
     C                   MOVEL     Extdata500    Extdata                                     BUG6671
     C                   EVAL      DLRPIFScn1Fmt = DLRPIFS1In                                 CSW213
     C                   EVAL      DLRPIFScn2Fmt = DLRPIFS2In                                 CSW213
     C                   EVAL      DLRPIFScn3Fmt = DLRPIFS3In                                 CSW213
     C                   EVAL      DLRPIFScn4Fmt = DLRPIFS4In                                 CSW214
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:1699)                             BUG5449
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:3170)                     BUG5449 BUG6377
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:3178)                     BUG5449 BUG6377
     C**********         EVAL      FORMULATR=%SUBST(Buffer:3186)                     BUG5449 BUG6377
     C**********         EVAL      FORMULATP=%SUBST(Buffer:3194)                     BUG5449 BUG6377
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:3202)                     BUG5449 BUG6377
     C**********         EVAL      FORMULATC=%SUBST(Buffer:3224)                     BUG5449 BUG6377
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:3246)                    BUG5449 BUG6377
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:3271)                    BUG5449 BUG6377
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:3296)+Buffer2             BUG5449 BUG6377
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:2096)+BufferEx2          BUG5449 BUG6377
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:2897)                  BUG5449 BUG6377
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:7697)+BufferEx3        BUG5449 BUG6377
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:2498)+BufferEx4          BUG5449 BUG6377
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:5699)+BufferEx5          BUG5449 BUG6377
     C**********         EVAL      OPCSAST=%SUBST(BufferEx5:8900)+BufferEx6+         BUG5449 BUG6377
     C**********                                       BufferEx7                     BUG5449 BUG6377
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:3778)+BufferEx8          BUG5449 BUG5610
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:3902)+BufferEx8          BUG5610 BUG6377
     C**********         EVAL      SUINFD=%SUBST(Buffer:1699)                          BUG6377CDL028
     C**********         EVAL      STINFD=%SUBST(Buffer:1705)                          BUG6377CDL028
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:1711)                       BUG6377CDL028
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:3182)                       BUG6377CDL028
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:3190)                       BUG6377CDL028
     C**********         EVAL      FORMULATR=%SUBST(Buffer:3198)                       BUG6377CDL028
     C**********         EVAL      FORMULATP=%SUBST(Buffer:3206)                       BUG6377CDL028
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:3214)                      BUG6377 CDL028
     C**********         EVAL      FORMULATC=%SUBST(Buffer:3236)                      BUG6377 CDL028
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:3258)                     BUG6377 CDL028
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:3283)                     BUG6377 CDL028
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:3308)+Buffer2              BUG6377 CDL028
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:2108)+BufferEx2           BUG6377 CDL028
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:2909)                   BUG6377 CDL028
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:7709)+BufferEx3         BUG6377 CDL028
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:2510)+BufferEx4           BUG6377 CDL028
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:5711)+BufferEx5           BUG6377 CDL028
     C**********         EVAL      OPCSAST=%SUBST(BufferEx5:8912)+BufferEx6+          BUG6377 CDL028
     C**********                                       BufferEx7                      BUG6377 CDL028
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:3914)+BufferEx8           BUG6377 CDL028
     C**********         EVAL      SUINFD=%SUBST(Buffer:1797)                         CDL028 BUG6472
     C**********         EVAL      STINFD=%SUBST(Buffer:1803)                         CDL028 BUG6472
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:3280)                      CDL028 BUG6472
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:3288)                      CDL028 BUG6472
     C**********         EVAL      FORMULATR=%SUBST(Buffer:3296)                      CDL028 BUG6472
     C**********         EVAL      FORMULATP=%SUBST(Buffer:3304)                      CDL028 BUG6472
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:3312)                      CDL028 BUG6472
     C**********         EVAL      FORMULATC=%SUBST(Buffer:3334)                      CDL028 BUG6472
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:3356)                     CDL028 BUG6472
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:3381)                     CDL028 BUG6472
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:3406)+Buffer2              CDL028 BUG6472
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:2206)+BufferEx2           CDL028 BUG6472
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:3007)                   CDL028 BUG6472
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:7807)+BufferEx3         CDL028 BUG6472
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:2608)+BufferEx4           CDL028 BUG6472
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:5809)+BufferEx5           CDL028 BUG6472
     C**********         EVAL      OPCSAST=%SUBST(BufferEx5:9010)+BufferEx6+          CDL028 BUG6472
     C**********                                       BufferEx7                      CDL028 BUG6472
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:4012)+BufferEx8           CDL028 BUG6472
     C**********         EVAL      SUINFD=%SUBST(Buffer:1799)                        BUG6472 BUG6671
     C**********         EVAL      STINFD=%SUBST(Buffer:1805)                        BUG6472 BUG6671
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:3282)                     BUG6472 BUG6671
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:3290)                     BUG6472 BUG6671
     C**********         EVAL      FORMULATR=%SUBST(Buffer:3298)                     BUG6472 BUG6671
     C**********         EVAL      FORMULATP=%SUBST(Buffer:3306)                     BUG6472 BUG6671
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:3314)                     BUG6472 BUG6671
     C**********         EVAL      FORMULATC=%SUBST(Buffer:3336)                     BUG6472 BUG6671
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:3358)                    BUG6472 BUG6671
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:3383)                    BUG6472 BUG6671
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:3408)+Buffer2             BUG6472 BUG6671
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:2208)+BufferEx2          BUG6472 BUG6671
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:3009)                  BUG6472 BUG6671
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:7809)+BufferEx3        BUG6472 BUG6671
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:2610)+BufferEx4          BUG6472 BUG6671
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:5811)+BufferEx5          BUG6472 BUG6671
     C**********         EVAL      OPCSAST=%SUBST(BufferEx5:9012)+BufferEx6+         BUG6472 BUG6671
     C**********                                       BufferEx7                     BUG6472 BUG6671
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:4014)+BufferEx8          BUG6472 BUG6671
     C**********         EVAL      SUINFD=%SUBST(Buffer:1850)                        BUG6671 BUG5871
     C**********         EVAL      STINFD=%SUBST(Buffer:1856)                        BUG6671 BUG5871
     C**********         EVAL      CPST=%SUBST(Buffer:1862)                          BUG6512 BUG5871
     C**********         EVAL      DSPCP=%SUBST(Buffer:1865)                         BUG6512 BUG5871
     C**********         EVAL      BKST=%SUBST(Buffer:1866)                          BUG6512 BUG5871
     C**********         EVAL      DSPBK=%SUBST(Buffer:1869)                         BUG6512 BUG5871
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:3333)                     BUG6671 BUG6671
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:3341)                     BUG6671 BUG6671
     C**********         EVAL      FORMULATR=%SUBST(Buffer:3349)                     BUG6671 BUG6671
     C**********         EVAL      FORMULATP=%SUBST(Buffer:3357)                     BUG6671 BUG6671
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:3365)                     BUG6671 BUG6671
     C**********         EVAL      FORMULATC=%SUBST(Buffer:3387)                     BUG6671 BUG6671
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:3409)                    BUG6671 BUG6671
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:3434)                    BUG6671 BUG6671
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:3459)+Buffer2             BUG6671 BUG6671
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:2259)+BufferEx2          BUG6671 BUG6671
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:3060)                  BUG6671 BUG6671
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:7860)+BufferEx3        BUG6671 BUG6671
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:2661)+BufferEx4          BUG6671 BUG6671
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:5862)+BufferEx5          BUG6671 BUG6671
     C**********         EVAL      OPCSAST=%SUBST(BufferEx5:9063)+BufferEx6+         BUG6671 BUG6671
     C**********                                       BufferEx7                     BUG6671 BUG6671
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:4065)+BufferEx8          BUG6671 BUG6671
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:3339)                     BUG6512 BUG5871
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:3347)                     BUG6512 BUG5871
     C**********         EVAL      FORMULATR=%SUBST(Buffer:3355)                     BUG6512 BUG5871
     C**********         EVAL      FORMULATP=%SUBST(Buffer:3363)                     BUG6512 BUG5871
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:3371)                     BUG6512 BUG5871
     C**********         EVAL      FORMULATC=%SUBST(Buffer:3393)                     BUG6512 BUG5871
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:3415)                    BUG6512 BUG5871
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:3440)                    BUG6512 BUG5871
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:3465)+Buffer2             BUG6512 BUG5871
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:2265)+BufferEx2          BUG6512 BUG5871
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:3066)                  BUG6512 BUG5871
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:7866)+BufferEx3        BUG6512 BUG5871
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:2667)+BufferEx4          BUG6512 BUG5871
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:5868)+BufferEx5          BUG6512 BUG5871
     C**********         EVAL      OPCSAST=%SUBST(BufferEx5:9069)+BufferEx6+         BUG6512 BUG5871
     C**********                                       BufferEx7                     BUG6512 BUG5871
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:4071)+BufferEx8          BUG6512 BUG5871
     C*******************EVAL      SUINFD=%SUBST(Buffer:3321)                         BUG5871 CDL038
     C*******************EVAL      STINFD=%SUBST(Buffer:3327)                         BUG5871 CDL038
     C*******************EVAL      CPST=%SUBST(Buffer:3333)                           BUG5871 CDL038
     C*******************EVAL      DSPCP=%SUBST(Buffer:3335)                          BUG5871 CDL038
     C*******************EVAL      BKST=%SUBST(Buffer:3336)                           BUG5871 CDL038
     C*******************EVAL      DSPBK=%SUBST(Buffer:3338)                          BUG5871 CDL038
     C*******************EVAL      DDSTS=%SUBST(Buffer:3339)                          BUG5871 CDL038
     C*******************EVAL      FORMULAOR=%SUBST(Buffer:3363)                      BUG5871 CDL038
     C*******************EVAL      FORMULAOP=%SUBST(Buffer:3371)                      BUG5871 CDL038
     C*******************EVAL      FORMULATR=%SUBST(Buffer:3379)                      BUG5871 CDL038
     C*******************EVAL      FORMULATP=%SUBST(Buffer:3387)                      BUG5871 CDL038
     C*******************EVAL      FORMULAOC=%SUBST(Buffer:3395)                      BUG5871 CDL038
     C*******************EVAL      FORMULATC=%SUBST(Buffer:3317)                      BUG5871 CDL038
     C*******************EVAL      FORMULAOPC=%SUBST(Buffer:3439)                     BUG5871 CDL038
     C*******************EVAL      FORMULATPC=%SUBST(Buffer:3464)                     BUG5871 CDL038
     C*******************EVAL      ORDATEAST=%SUBST(Buffer:3489)+Buffer2              BUG5871 CDL038
     C*******************EVAL      OPDATEAST=%SUBST(Buffer2:2289)+BufferEx2           BUG5871 CDL038
     C*******************EVAL      TRDATEAST=%SUBST(BufferEx2:3090)                   BUG5871 CDL038
     C*******************EVAL      TPDATEAST=%SUBST(BufferEx2:7890)+BufferEx3         BUG5871 CDL038
     C*******************EVAL      OCFSAST=%SUBST(BufferEx3:2691)+BufferEx4           BUG5871 CDL038
     C*******************EVAL      TCFSAST=%SUBST(BufferEx4:5892)+BufferEx5           BUG5871 CDL038
     C*******************EVAL      OPCSAST=%SUBST(BufferEx5:9093)+BufferEx6+          BUG5871 CDL038
     C*******************                              BufferEx7                      BUG5871 CDL038
     C*******************EVAL      TPCSAST=%SUBST(BufferEx7:4095)+BufferEx8           BUG5871 CDL038
     C**********         EVAL      SUINFD=%SUBST(Buffer:3325)                        CDL038 BUG11254
     C**********         EVAL      STINFD=%SUBST(Buffer:3331)                        CDL038 BUG11254
     C**********         EVAL      CPST=%SUBST(Buffer:3337)                          CDL038 BUG11254
     C**********         EVAL      DSPCP=%SUBST(Buffer:3339)                         CDL038 BUG11254
     C**********         EVAL      BKST=%SUBST(Buffer:3340)                          CDL038 BUG11254
     C**********         EVAL      DSPBK=%SUBST(Buffer:3342)                         CDL038 BUG11254
     C**********         EVAL      DDSTS=%SUBST(Buffer:3343)                         CDL038 BUG11254
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:3367)                     CDL038 BUG11254
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:3375)                     CDL038 BUG11254
     C**********         EVAL      FORMULATR=%SUBST(Buffer:3383)                     CDL038 BUG11254
     C**********         EVAL      FORMULATP=%SUBST(Buffer:3391)                     CDL038 BUG11254
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:3399)                     CDL038 BUG11254
     C**********         EVAL      FORMULATC=%SUBST(Buffer:3421)                     CDL038 BUG11254
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:3443)                    CDL038 BUG11254
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:3468)                    CDL038 BUG11254
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:3493)+Buffer2             CDL038 BUG11254
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:2293)+BufferEx2          CDL038 BUG11254
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:3094)                  CDL038 BUG11254
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:7894)+BufferEx3        CDL038 BUG11254
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:2695)+BufferEx4          CDL038 BUG11254
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:5896)+BufferEx5          CDL038 BUG11254
     C**********         EVAL      OPCSAST=%SUBST(BufferEx5:9097)+BufferEx6+         CDL038 BUG11254
     C**********                                       BufferEx7                     CDL038 BUG11254
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:4099)+BufferEx8          CDL038 BUG11254
      **********                                                                     CDL038 BUG11254
     C**********         EVAL      SUINFD=%SUBST(Buffer:3415)                       BUG11254 CSF011A
     C**********         EVAL      STINFD=%SUBST(Buffer:3421)                       BUG11254 CSF011A
     C**********         EVAL      CPST=%SUBST(Buffer:3427)                         BUG11254 CSF011A
     C**********         EVAL      DSPCP=%SUBST(Buffer:3429)                        BUG11254 CSF011A
     C**********         EVAL      BKST=%SUBST(Buffer:3430)                         BUG11254 CSF011A
     C**********         EVAL      DSPBK=%SUBST(Buffer:3432)                        BUG11254 CSF011A
     C**********         EVAL      DDSTS=%SUBST(Buffer:3433)                        BUG11254 CSF011A
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:3457)                    BUG11254 CSF011A
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:3465)                    BUG11254 CSF011A
     C**********         EVAL      FORMULATR=%SUBST(Buffer:3473)                    BUG11254 CSF011A
     C**********         EVAL      FORMULATP=%SUBST(Buffer:3481)                    BUG11254 CSF011A
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:3489)                    BUG11254 CSF011A
     C**********         EVAL      FORMULATC=%SUBST(Buffer:3511)                    BUG11254 CSF011A
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:3533)                   BUG11254 CSF011A
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:3558)                   BUG11254 CSF011A
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:3583)+Buffer2            BUG11254 CSF011A
     C**********         EVAL      OPDATEAST=%SUBST(Buffer2:2383)+BufferEx2         BUG11254 CSF011A
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:3184)                 BUG11254 CSF011A
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:7984)+BufferEx3       BUG11254 CSF011A
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:2785)+BufferEx4         BUG11254 CSF011A
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:5986)+BufferEx5         BUG11254 CSF011A
     C**********         EVAL      OPCSAST=%SUBST(BufferEx5:9187)+BufferEx6+        BUG11254 CSF011A
     C**********                                       BufferEx7                    BUG11254 CSF011A
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:4189)+BufferEx8         BUG11254 CSF011A
                                                                                            BUG11254
      *
     C**********         EVAL      SUINFD=%SUBST(Buffer:5407)                       CSF011A MD030454
     C**********         EVAL      STINFD=%SUBST(Buffer:5413)                       CSF011A MD030454
     C**********         EVAL      CPST=%SUBST(Buffer:5419)                         CSF011A MD030454
     C**********         EVAL      DSPCP=%SUBST(Buffer:5421)                        CSF011A MD030454
     C**********         EVAL      BKST=%SUBST(Buffer:5422)                         CSF011A MD030454
     C**********         EVAL      DSPBK=%SUBST(Buffer:5424)                        CSF011A MD030454
     C**********         EVAL      DDSTS=%SUBST(Buffer:5425)                        CSF011A MD030454
     C**********         EVAL      FORMULAOR=%SUBST(Buffer:5449)                    CSF011A MD030454
     C**********         EVAL      FORMULAOP=%SUBST(Buffer:5457)                    CSF011A MD030454
     C**********         EVAL      FORMULATR=%SUBST(Buffer:5465)                    CSF011A MD030454
     C**********         EVAL      FORMULATP=%SUBST(Buffer:5473)                    CSF011A MD030454
     C**********         EVAL      FORMULAOC=%SUBST(Buffer:5481)                    CSF011A MD030454
     C**********         EVAL      FORMULATC=%SUBST(Buffer:5503)                    CSF011A MD030454
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:5525)                   CSF011A MD030454
     C**********         EVAL      FORMULATPC=%SUBST(Buffer:5550)                   CSF011A MD030454
     C**********         EVAL      ORDATEAST=%SUBST(Buffer:5575)+Buffer2+             CSF011A CSW213
     C**********                                       BufferEx2                      CSF011A CSW213
     C**********         EVAL      OPDATEAST=%SUBST(BufferEx2:376)                    CSF011A CSW213
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:5176)                   CSF011A CSW213
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx2:9976)+BufferEx3         CSF011A CSW213
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:4777)+BufferEx4           CSF011A CSW213
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:7978)+BufferEx5+          CSF011A CSW213
     C**********                                       BufferEx6                      CSF011A CSW213
     C**********         EVAL      OPCSAST=%SUBST(BufferEx6:1180)+BufferEx7           CSF011A CSW213
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:6181)+BufferEx8+          CSF011A CSW213
     C**********                                       BufferEx9                      CSF011A CSW213
     C**********         EVAL      ORDATEAST=%SUBST(Buffer2:1507)+                   CSW213 MD030454
     C**********                                       BufferEx2                     CSW213 MD030454
     C**********         EVAL      OPDATEAST=%SUBST(BufferEx2:2308)                  CSW213 MD030454
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:7108)+BufferEx3        CSW213 MD030454
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx3:1909)                  CSW213 MD030454
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:6709)+BufferEx4          CSW213 MD030454
     C**********         EVAL      TCFSAST=%SUBST(BufferEx4:9910)+BufferEx5+         CSW213 MD030454
     C**********                                       BufferEx6                     CSW213 MD030454
     C**********         EVAL      OPCSAST=%SUBST(BufferEx6:3112)+BufferEx7          CSW213 MD030454
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:8113)+BufferEx8+         CSW213 MD030454
     C**********                                       BufferEx9                     CSW213 MD030454
     C                   EVAL      SUINFD=%SUBST(Buffer2:37)                                MD030454
     C                   EVAL      STINFD=%SUBST(Buffer2:43)                                MD030454
     C                   EVAL      CPST=%SUBST(Buffer2:49)                                  MD030454
     C                   EVAL      DSPCP=%SUBST(Buffer2:51)                                 MD030454
     C                   EVAL      BKST=%SUBST(Buffer2:52)                                  MD030454
     C                   EVAL      DSPBK=%SUBST(Buffer2:54)                                 MD030454
     C                   EVAL      DDSTS=%SUBST(Buffer2:55)                                 MD030454
     C                   EVAL      FORMULAOR=%SUBST(Buffer2:79)                             MD030454
     C                   EVAL      FORMULAOP=%SUBST(Buffer2:87)                             MD030454
     C                   EVAL      FORMULATR=%SUBST(Buffer2:95)                             MD030454
     C                   EVAL      FORMULATP=%SUBST(Buffer2:103)                            MD030454
     C                   EVAL      FORMULAOC=%SUBST(Buffer2:111)                            MD030454
     C**********         EVAL      FORMULATC=%SUBST(Buffer2:113)                   MD030454 MD035359
     C                   EVAL      FORMULATC=%SUBST(Buffer2:133)                            MD035359
     C                   EVAL      FORMULAOPC=%SUBST(Buffer2:155)                           MD030454
     C                   EVAL      FORMULATPC=%SUBST(Buffer2:180)                           MD030454
     C**********         EVAL      ORDATEAST=%SUBST(Buffer2:2137)                    MD030454 CSW214
     C**********                   + BufferEx2                                       MD030454 CSW214
     C**********         EVAL      OPDATEAST=%SUBST(BufferEx2:2938)                  MD030454 CSW214
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:7738)                  MD030454 CSW214
     C**********                   + BufferEx3                                       MD030454 CSW214
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx3:2539)                  MD030454 CSW214
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:7339)                    MD030454 CSW214
     C**********                   + BufferEx4                                       MD030454 CSW214
     C**********         EVAL      TCFSAST=%SUBST(BufferEx5:541)                     MD030454 CSW214
     C**********                   + BufferEx6                                       MD030454 CSW214
     C**********         EVAL      OPCSAST=%SUBST(BufferEx6:3742)+BufferEx7          MD030454 CSW214
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:8743)+BufferEx8+         MD030454 CSW214
     C**********                                       BufferEx9                     MD030454 CSW214
     C**********         EVAL      ORDATEAST=%SUBST(Buffer2:2837)                    CSW214 MD035359
     C**********                   + BufferEx2                                       CSW214 MD035359
     C**********         EVAL      OPDATEAST=%SUBST(BufferEx2:3638)                  CSW214 MD035359
     C**********         EVAL      TRDATEAST=%SUBST(BufferEx2:8438)                  CSW214 MD035359
     C**********                   + BufferEx3                                       CSW214 MD035359
     C**********         EVAL      TPDATEAST=%SUBST(BufferEx3:3239)                  CSW214 MD035359
     C**********         EVAL      OCFSAST=%SUBST(BufferEx3:8039)                    CSW214 MD035359
     C**********                   + BufferEx4                                       CSW214 MD035359
     C**********         EVAL      TCFSAST=%SUBST(BufferEx5:1241)                    CSW214 MD035359
     C**********                   + BufferEx6                                       CSW214 MD035359
     C**********         EVAL      OPCSAST=%SUBST(BufferEx6:4442)+BufferEx7          CSW214 MD035359
     C**********         EVAL      TPCSAST=%SUBST(BufferEx7:9443)+BufferEx8+         CSW214 MD035359
     C**********                                       BufferEx9                     CSW214 MD035359
      *                                                                                     MD035359
     C                   EVAL      ORDATEAST=%SUBST(Buffer2:2299)                           MD035359
     C                             + BufferEx2                                              MD035359
     C                   EVAL      OPDATEAST=%SUBST(BufferEx2:3100)                         MD035359
     C                   EVAL      TRDATEAST=%SUBST(BufferEx2:7900)                         MD035359
     C                             + BufferEx3                                              MD035359
     C                   EVAL      TPDATEAST=%SUBST(BufferEx3:2701)                         MD035359
     C                   EVAL      OCFSAST=%SUBST(BufferEx3:7501)                           MD035359
     C                             + BufferEx4 + BufferEx5                                  MD035359
     C                   EVAL      TCFSAST=%SUBST(BufferEx5:703)                            MD035359
     C                             + BufferEx6                                              MD035359
     C                   EVAL      OPCSAST=%SUBST(BufferEx6:3904)+BufferEx7                 MD035359
     C                   EVAL      TPCSAST=%SUBST(BufferEx7:8905)+BufferEx8+                MD035359
     C                                                 BufferEx9                            MD035359
      *                                                                                      BUG5449
     C                   MOVEA     ORDATEAST     ORDATEA                                     BUG5449
     C                   MOVEA     OPDATEAST     OPDATEA                                     BUG5449
     C                   MOVEA     TRDATEAST     TRDATEA                                     BUG5449
     C                   MOVEA     TPDATEAST     TPDATEA                                     BUG5449
     C                   MOVEA     OCFSAST       OCFSA                                       BUG5449
     C                   MOVEA     TCFSAST       TCFSA                                       BUG5449
     C                   MOVEA     OPCSAST       OPCSA                                       BUG5449
     C                   MOVEA     TPCSAST       TPCSA                                       BUG5449

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

      ** Generate a timestamp for this transaction
     C                   RESET                   ReturnCode
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      ** Some fields from the common header DS are renamed to prevent compile
      **  problems, as they are used on other Data Structures.
      ** Data from these must be copied over to the fields used for output
      **  or parameters.

      ** Reset variables gradually updated, once only at start
     C                   EXSR      RESETCYCLE

      ** Validate Action Code

     C                   EXSR      ValidateAc

      ** If error in validation of action code, fail this input

     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
     C                   EVAL      ValIter = '1ST'
                                                                                             BUG6512
      *                                                                                      BUG6512
      * Retrieve TRAM details                                                                BUG6512
      *                                                                                      BUG6512
     C                   EXSR      ZACFFEERTV                                                BUG6512

      ** Processing depends upon Action Code

     C                   SELECT

     C                   WHEN      SACCD = 'I'
      ** Processing for Inserts
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt

     C                   IF        CIR003 = 'Y'
     C                   IF        SVDEI = 'Y'
     C                             OR SPDEI = 'Y'
     C                             OR SMDEI = 'Y'
     C                   EXSR      ValidateEx
     C                   ENDIF
     C                   ENDIF

      /COPY WNCPYSRC,IRCIRSC008
      ** If IRCs on in system and no previous errors validate IRC dates
     C                   IF        CIR001 = 'Y'
     C**********                   AND Idx = 0                                               BUG6517
     C                   EXSR      ValidateIC
     C**********         IF        Idx = 0                                                   BUG5449
     C**********         EXSR      ValidateIC2                                               BUG5449
     C**********         ENDIF                                                               BUG5449
     C                   ENDIF

      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change
      ** Date) is installed and no previous errors, then perform validation of fields.

     C**********         IF        CAP041 = 'Y' AND Idx = 0                                  BUG6517
     C                   IF        CAP041 = 'Y'                                              BUG6517
     C                   EXSR      ValidateFE
     C**********         IF        Idx = 0                                                   BUG6517
     C                   EXSR      ValidateIC3
     C**********         ENDIF                                                               BUG6517
     C                   ENDIF

     C                   WHEN      SACCD = 'A'
      ** Processing for Amends
     C                   IF        GHSUBS <> *Blank
     C     GHSUBS        SCAN      TranIn                                 99
     C                   IF        *IN99 = *ON
     C                   EXSR      TDtDtaSubs
     C                   ENDIF
     C                   ENDIF

     C                   EXSR      SetupAmend
     C                   EXSR      ValdateAmd                                                BUG6876
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt

     C                   IF        CIR003 = 'Y'
     C                   IF        SVDEI = 'Y'
     C                             OR SPDEI = 'Y'
     C                             OR SMDEI = 'Y'
     C                   EXSR      ValidateEx
     C                   ENDIF
     C                   ENDIF

      /COPY WNCPYSRC,IRCIRSC012
      ** If IRCs on in system and no previous errors validate IRC dates
     C                   IF        CIR001 = 'Y'
     C**********                   AND Idx = 0                                               BUG6517
     C                   EXSR      ValidateIC
     C**********         IF        Idx = 0                                                   BUG5449
     C**********         EXSR      ValidateIC2                                               BUG5449
     C**********         ENDIF                                                               BUG5449
     C                   ENDIF

      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change
      ** Date) is installed and no previous errors, then perform validation of fields.

     C**********         IF        CAP041 = 'Y' AND Idx = 0                                  BUG6517
     C                   IF        CAP041 = 'Y'                                              BUG6517
     C                   EXSR      ValidateFE
     C**********         IF        Idx = 0                                                   BUG6517
     C                   EXSR      ValidateIC3
     C**********         ENDIF                                                               BUG6517
     C                   ENDIF

     C**********         EXSR      ValdateAmd                                                BUG6876
                                                                                             BUG6494
     C                   WHEN      SACCD  = 'X'                                              BUG6494
      *  Processing for Authorises                                                           BUG6494
     C                   EXSR      ValidateTr                                                BUG6494
     C                   EXSR      ValidateSt                                                BUG6494
     C                   IF        CIR003 = 'Y'                                              BUG6494
     C                   IF        SVDEI = 'Y'                                               BUG6494
     C                             OR SPDEI = 'Y'                                            BUG6494
     C                             OR SMDEI = 'Y'                                            BUG6494
     C                   EXSR      ValidateEx                                                BUG6494
     C                   ENDIF                                                               BUG6494
     C                   ENDIF                                                               BUG6494
                                                                                             BUG6494
      ** If IRCs on in system and no previous errors validate IRC dates                      BUG6494
                                                                                             BUG6494
     C     CIR001        IFEQ      'Y'                                                       BUG6494
     C*****Idx           ANDEQ     0                                                 BUG6494 BUG6517
     C                   EXSR      ValidateIC                                                BUG6494
     C                   ENDIF                                                               BUG6494
                                                                                             BUG6494
      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change           BUG6494
      ** Date) is installed and no previous errors, then perform validation of fields.       BUG6494
                                                                                             BUG6494
     C**********         IF        CAP041 = 'Y' and Idx = 0                          BUG6494 BUG6517
     C                   IF        CAP041 = 'Y'                                              BUG6517
     C                   EXSR      ValidateFE                                                BUG6494
                                                                                             BUG6494
      ** Validate Principle change date schedules                                            BUG6494
                                                                                             BUG6494
     C     CIR001        IFEQ      'Y'                                                       BUG6494
     C*****Idx           ANDEQ     0                                                 BUG6494 BUG6517
     C                   EXSR      ValidateIC3                                               BUG6494
     C                   ENDIF                                                               BUG6494
     C                   ENDIF                                                               BUG6494

     C                   ENDSL

     C     INVALID       TAG
                                                                                              CSW213
      ** Call DLRPIFVU - Midas DL Reporting Information Validate and Update                   CSW213
                                                                                              CSW213
     C                   IF        CSW213 = 'Y' AND                                           CSW213
     C                             UPDateYN <> 'Y'                                            CSW213
     C                   EXSR      SRCIRSVU                                                   CSW213
     C                   ENDIF                                                                CSW213

     C                   IF        UpdateYN = 'Y'
     C                             AND Idx = 0

     C                   IF        Idx = 0

     C                   IF        SACCD = 'I'
     C                   EXSR      SETUPDEALN
     C                   ENDIF

     C                   EXSR      SETUPVALID
     C                   EXSR      SrValidEx

      ** If Interest Rate Calendars are in use write to valid IRC file
      ** (dont bother setting up for delete)
     C                   IF        CIR001 = 'Y'
     C*****************************AND SACCD <> 'R'                                          BUG5610
     C                   EXSR      SUPVALIRC
     C**********         IF        CIR001 = 'Y'                                              BUG5449
     C                   EXSR      SUPVALICP
     C**********         ENDIF                                                               BUG5449
     C                   ENDIF

     C                   EXSR      UpdateDB
     C                   ENDIF
     C                   ENDIF

     C                   SETON                                        LR

     C                   IF        UpdateYN = 'Y' and Idx = 0                                BUG6377
      *                                                                                      BUG6377
     C                   MOVE      RXDLNO        DDDLNO_IN                                   BUG6377
     C                   CALL      'IRCIRSR'                                                 BUG6377
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
                                                                                             BUG6377
     C                   EVAL      ZDAYNO =  RXUINFD                                         BUG6377
     C                   CALLB     'ZDATE2'                                                  BUG6377
     C                   PARM                    ZDAYNO                                      BUG6377
     C                   PARM                    BJDFIN                                      BUG6377
     C                   PARM      *ZEROS        ZDATE                                       BUG6377
     C                   PARM      *BLANKS       ZADATE                                      BUG6377
                                                                                             BUG6377
     C                   MOVEL     ZDATE         SUINFD                                      BUG6377
                                                                                             BUG6377
     C                   EVAL      ZDAYNO =  RXTINFD                                         BUG6377
     C                   CALLB     'ZDATE2'                                                  BUG6377
     C                   PARM                    ZDAYNO                                      BUG6377
     C                   PARM                    BJDFIN                                      BUG6377
     C                   PARM      *ZEROS        ZDATE                                       BUG6377
     C                   PARM      *BLANKS       ZADATE                                      BUG6377
                                                                                             BUG6377
     C                   MOVEL     ZDATE         STINFD                                      BUG6377
                                                                                             BUG6377
     C                   MOVEA     ORDATEA       ORDATEAST                                   BUG5610
     C                   MOVEA     OPDATEA       OPDATEAST                                   BUG5610
     C                   MOVEA     TRDATEA       TRDATEAST                                   BUG5610
     C                   MOVEA     TPDATEA       TPDATEAST                                   BUG5610
     C                   MOVEA     OCFSA         OCFSAST                                     BUG5610
     C                   MOVEA     TCFSA         TCFSAST                                     BUG5610
     C                   MOVEA     OPCSA         OPCSAST                                     BUG5610
     C                   MOVEA     TPCSA         TPCSAST                                     BUG5610
                                                                                             BUG5610
     C                   EVAL      Buffer = TranIn + InRecSttmt +
     C                               InPaySttmt + InFRASttmt +
     C                               InRecStmtV + InPayStmtV +
     C**********                     InRecStmtM + InPayStmtM                                 BUG5449
     C                               InRecStmtM + InPayStmtM +                               BUG5449
     C**********                     InfData + ExtData +                            BUG6671 MD030454
     C**********                            SUINFD + STINFD +                       BUG6377 MD030454
     C**********                            CPST   + DSPCP  +                       BUG6512 MD030454
     C**********                            BKST   + DSPBK  +                       BUG6512 MD030454
     C**********                            DDSTS +                                 BUG5871 MD030454
     C**********                            FORMULAOR + FORMULAOP +                 BUG5449 MD030454
     C**********                            FORMULATR + FORMULATP +                 BUG5449 MD030454
     C**********                            FORMULAOC + FORMULATC +                 BUG5449 MD030454
     C**********                            FORMULAOPC+ FORMULATPC + ORDATEAST        BUG5449 CSW213
     C**********                            FORMULAOPC+ FORMULATPC +                 CSW213 MD030454
     C**********                            OutSwift2013                             CSW213 MD030454
     C                                      InfData                                         MD030454
     C                                      + ExtData                                       MD030454
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2706)+OPDATEAST          BUG5449 BUG6377
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1905)+TRDATEAST        BUG5449 BUG6377
     C**********                               +TPDATEAST                            BUG5449 BUG6377
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2304)+OCFSAST          BUG5449 BUG6377
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7503)+TCFSAST            BUG5449 BUG6377
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4302)+OPCSAST            BUG5449 BUG6377
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:1101)                    BUG5449 BUG6377
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:11100)+TPCSAST           BUG5449 BUG6377
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:6100)                    BUG5449 BUG6377
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2694)+OPDATEAST           BUG6377 CDL028
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1893)+TRDATEAST         BUG6377 CDL028
     C**********                               +TPDATEAST                             BUG6377 CDL028
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2292)+OCFSAST           BUG6377 CDL028
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7491)+TCFSAST             BUG6377 CDL028
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4290)+OPCSAST             BUG6377 CDL028
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:1089)                     BUG6377 CDL028
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:11088)+TPCSAST            BUG6377 CDL028
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:6087)                     BUG6377 CDL028
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2596)+OPDATEAST           CDL028 BUG6472
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1795)+TRDATEAST         CDL028 BUG6472
     C**********                               +TPDATEAST                             CDL028 BUG6472
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2194)+OCFSAST           CDL028 BUG6472
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7393)+TCFSAST             CDL028 BUG6472
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4192)+OPCSAST             CDL028 BUG6472
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:991)                      CDL028 BUG6472
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10990)+TPCSAST            CDL028 BUG6472
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5989)                     CDL028 BUG6472
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2594)+OPDATEAST          BUG6472 BUG6671
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1793)+TRDATEAST        BUG6472 BUG6671
     C**********                               +TPDATEAST                            BUG6472 BUG6671
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2192)+OCFSAST          BUG6472 BUG6671
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7391)+TCFSAST            BUG6472 BUG6671
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4190)+OPCSAST            BUG6472 BUG6671
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:989)                     BUG6472 BUG6671
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10988)+TPCSAST           BUG6472 BUG6671
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5987)                    BUG6472 BUG6671
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2543)+OPDATEAST          BUG6671 BUG6512
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1742)+TRDATEAST        BUG6671 BUG6512
     C**********                               +TPDATEAST                            BUG6671 BUG6512
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2141)+OCFSAST          BUG6671 BUG6512
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7340)+TCFSAST            BUG6671 BUG6512
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4139)+OPCSAST            BUG6671 BUG6512
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:938)                     BUG6671 BUG6512
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10937)+TPCSAST           BUG6671 BUG6512
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5936)                    BUG6671 BUG6512
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2537)+OPDATEAST          BUG6512 BUG5871
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1736)+TRDATEAST        BUG6512 BUG5871
     C**********                               +TPDATEAST                            BUG6512 BUG5871
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2135)+OCFSAST          BUG6512 BUG5871
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7334)+TCFSAST            BUG6512 BUG5871
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4133)+OPCSAST            BUG6512 BUG5871
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:932)                     BUG6512 BUG5871
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10931)+TPCSAST           BUG6512 BGU5871
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5930)                    BUG6512 BUG5871
     C*******************EVAL      Buffer2=%SUBST(ORDATEAST:2513)+OPDATEAST           BUG5871 CDL038
     C*******************EVAL      BufferEx2=%SUBST(OPDATEAST:1712)+TRDATEAST         BUG5871 CDL038
     C*******************                      +TPDATEAST                             BUG5871 CDL038
     C*******************EVAL      BufferEx3=%SUBST(TPDATEAST:2111)+OCFSAST           BUG5871 CDL038
     C*******************EVAL      BufferEx4=%SUBST(OCFSAST:7310)+TCFSAST             BUG5871 CDL038
     C*******************EVAL      BufferEx5=%SUBST(TCFSAST:4109)+OPCSAST             BUG5871 CDL038
     C*******************EVAL      BufferEx6=%SUBST(OPCSAST:908)                      BUG5871 CDL038
     C*******************EVAL      BufferEx7=%SUBST(OPCSAST:10907)+TPCSAST            BUG5871 CDL038
     C*******************EVAL      BufferEx8=%SUBST(TPCSAST:5906)                     BUG5871 CDL038
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2517)+OPDATEAST          CDL038 BUG11254
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1716)+TRDATEAST        CDL038 BUG11254
     C**********                               +TPDATEAST                            CDL038 BUG11254
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2115)+OCFSAST          CDL038 BUG11254
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7314)+TCFSAST            CDL038 BUG11254
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4113)+OPCSAST            CDL038 BUG11254
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:912)                     CDL038 BUG11254
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10911)+TPCSAST           CDL038 BUG11254
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5910)                    CDL038 BUG11254
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:2419)+OPDATEAST         BUG11254 CSF011A
     C**********         EVAL      BufferEx2=%SUBST(OPDATEAST:1618)+TRDATEAST       BUG11254 CSF011A
     C**********                               +TPDATEAST                           BUG11254 CSF011A
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:2017)+OCFSAST         BUG11254 CSF011A
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:7216)+TCFSAST           BUG11254 CSF011A
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:4015)+OPCSAST           BUG11254 CSF011A
     C**********         EVAL      BufferEx6=%SUBST(OPCSAST:814)                    BUG11254 CSF011A
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:10813)+TPCSAST          BUG11254 CSF011A
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:5812)                   BUG11254 CSF011A
      *
     C**********         EVAL      Buffer2=%SUBST(ORDATEAST:427)                      CSF011A CSW213
     C**********         EVAL      BufferEx2=%SUBST(ORDATEAST:4426)+OPDATEAST         CSF011A CSW213
     C**********                               +TRDATEAST+TPDATEAST                   CSF011A CSW213
     C**********         EVAL      BufferEx3=%SUBST(TPDATEAST:25)+OCFSAST             CSF011A CSW213
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:5224)+TCFSAST             CSF011A CSW213
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:2023)                     CSF011A CSW213
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:12022)+OPCSAST            CSF011A CSW213
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:8821)+TPCSAST             CSF011A CSW213
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:3820)                     CSF011A CSW213
     C**********         EVAL      BufferEx9=%SUBST(TPCSAST:13819)                    CSF011A CSW213
     C**********         EVAL      Buffer2 = %SUBST(OutSwift2013:427)                CSW213 MD030454
     C**********                               +ORDATEAST                            CSW213 MD030454
     C**********         EVAL      BufferEx2=%SUBST(ORDATEAST:2494)+OPDATEAST        CSW213 MD030454
     C**********                               +TRDATEAST                            CSW213 MD030454
     C**********         EVAL      BufferEx3=%SUBST(TRDATEAST:2893)+TPDATEAST        CSW213 MD030454
     C**********                               +OCFSAST                              CSW213 MD030454
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:3292)+TCFSAST            CSW213 MD030454
     C**********         EVAL      BufferEx5=%SUBST(TCFSAST:91)                      CSW213 MD030454
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:10090)+OPCSAST           CSW213 MD030454
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:6889)+TPCSAST            CSW213 MD030454
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:1888)                    CSW213 MD030454
     C**********         EVAL      BufferEx9=%SUBST(TPCSAST:11887)                   CSW213 MD030454
     C                   EVAL      Buffer2 = %SUBST(ExtData:15)                             MD030454
     C                                      + SUINFD + STINFD                               MD030454
     C                                      + CPST + DSPCP                                  MD030454
     C                                      + BKST + DSPBK                                  MD030454
     C                                      + DDSTS                                         MD030454
     C                                      + FORMULAOR + FORMULAOP                         MD030454
     C                                      + FORMULATR + FORMULATP                         MD030454
     C                                      + FORMULAOC + FORMULATC                         MD030454
     C                                      + FORMULAOPC+ FORMULATPC                        MD030454
     C                                      + OutSwift2013                                  MD030454
     C                                      + ORDATEAST                                     MD030454
     C**********         EVAL      BufferEx2=%SUBST(ORDATEAST:1864)+OPDATEAST        MD030454 CSW214
     C**********                            + TRDATEAST                              MD030454 CSW214
     C**********         EVAL      BufferEx3=%SUBST(TRDATEAST:2263)+TPDATEAST        MD030454 CSW214
     C**********                               +OCFSAST                              MD030454 CSW214
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:2662)                    MD030454 CSW214
     C**********         EVAL      BufferEx5=%SUBST(OCFSAST:12661)                   MD030454 CSW214
     C**********                            + TCFSAST                                MD030454 CSW214
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:9460)                    MD030454 CSW214
     C**********                            + OPCSAST                                MD030454 CSW214
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:6259)+TPCSAST            MD030454 CSW214
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:1258)                    MD030454 CSW214
     C**********         EVAL      BufferEx9=%SUBST(TPCSAST:11257)                   MD030454 CSW214
                                                                                            MD030454
     C**********         EVAL      BufferEx2=%SUBST(ORDATEAST:1164)+OPDATEAST        CSW214 MD035359
     C**********                            + TRDATEAST                              CSW214 MD035359
     C**********         EVAL      BufferEx3=%SUBST(TRDATEAST:1563)+TPDATEAST        CSW214 MD035359
     C**********                               +OCFSAST                              CSW214 MD035359
     C**********         EVAL      BufferEx4=%SUBST(OCFSAST:1962)                    CSW214 MD035359
     C**********         EVAL      BufferEx5=%SUBST(OCFSAST:11961)                   CSW214 MD035359
     C**********                            + TCFSAST                                CSW214 MD035359
     C**********         EVAL      BufferEx6=%SUBST(TCFSAST:8760)                    CSW214 MD035359
     C**********                            + OPCSAST                                CSW214 MD035359
     C**********         EVAL      BufferEx7=%SUBST(OPCSAST:5559)+TPCSAST            CSW214 MD035359
     C**********         EVAL      BufferEx8=%SUBST(TPCSAST:558)                     CSW214 MD035359
     C**********         EVAL      BufferEx9=%SUBST(TPCSAST:10557)                   CSW214 MD035359
      *                                                                                     MD035359
     C                   EVAL      BufferEx2=%SUBST(ORDATEAST:1702)+OPDATEAST               MD035359
     C                                      + TRDATEAST                                     MD035359
     C                   EVAL      BufferEx3=%SUBST(TRDATEAST:2101)+TPDATEAST               MD035359
     C                                         +OCFSAST                                     MD035359
     C                   EVAL      BufferEx4=%SUBST(OCFSAST:2500)                           MD035359
     C                   EVAL      BufferEx5=%SUBST(OCFSAST:12499)                          MD035359
     C                                      + TCFSAST                                       MD035359
     C                   EVAL      BufferEx6=%SUBST(TCFSAST:9298)                           MD035359
     C                                      + OPCSAST                                       MD035359
     C                   EVAL      BufferEx7=%SUBST(OPCSAST:6097)+TPCSAST                   MD035359
     C                   EVAL      BufferEx8=%SUBST(TPCSAST:1096)                           MD035359
     C                   EVAL      BufferEx9=%SUBST(TPCSAST:11095)                          MD035359
     C                   ENDIF                                                               BUG6377

     C                   RETURN

      ********************************************************************
      /EJECT
      ********************************************************************
      ***********                                                        *                   BUG5449
      ***SRRtvCIRS - Retrieve Cross Currency Transaction Details         *                   BUG5449
      **********                                                         *                   BUG5449
      ********************************************************************
      **********                                                                             BUG5449
     C*****SRRtvCIRS     BEGSR                                                               BUG5449
      **********                                                                             BUG5449
     C*****APFOAsocID    CHAIN     IRWCIRSL0                                                 BUG5449
      **********                                                                             BUG5449
     C**********         IF        %FOUND(IRWCIRSL0)                                         BUG5449
     C**********         CLEAR                   Trans500                                    BUG5449
     C**********         CLEAR                   TransB500                                   BUG5449
     C**********         CLEAR                   TransC500                                   BUG5449
     C**********         CLEAR                   TransD500                                   BUG5449
     C**********         CLEAR                   TransE500                                   BUG5449
     C**********         MOVEL     WIRCIRS       Trans500                                    BUG5449
     C**********         MOVEL     WSCORAT       TransB500                                   BUG5449
     C**********         MOVEL     WSCOINT       TransC500                                   BUG5449
     C**********         MOVEL     WSCTRAT       TransD500                                   BUG5449
     C**********         MOVEL     WSCTINT       TransE500                                   BUG5449
      **********                                                                             BUG5449
      ***Override Front Office and Associated Front Office Id                                BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      APFOTRANID =  WSFOTRANID                                  BUG5449
     C**********         EVAL      APFOASOCID =  WSFOASOCID                                  BUG5449
     C**********                                                                             BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDSR                                                               BUG5449
      **********                                                                             BUG5449
      ********************************************************************                   BUG5449
      **********/EJECT                                                                       BUG5449
      ********************************************************************
      **********                                                         *                   BUG5449
      ***SRLoadArr - Load Work File Records to Array                     *                   BUG5449
      **********                                                         *                   BUG5449
      ********************************************************************
      **********                                                                             BUG5449
     C*****SRLoadArr     BEGSR                                                               BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      OurRDTSC = *BLANK                                         BUG5449
     C**********         EVAL      OurIDTSC = *BLANK                                         BUG5449
     C**********         EVAL      ThrRDTSC = *BLANK                                         BUG5449
     C**********         EVAL      ThrIDTSC = *BLANK                                         BUG5449
     C**********         EVAL      OurCFSC = *BLANK                                          BUG5449
     C**********         EVAL      ThrCFSC = *BLANK                                          BUG5449
     C**********         IF        CAP041 = 'Y'                                              BUG5449
     C**********         EVAL      OurPCSC = *BLANK                                          BUG5449
     C**********         EVAL      ThrPCSC = *BLANK                                          BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Our*Rate                                                                            BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      WOurTheir = 'U'                                           BUG5449
     C**********         EVAL      WRatePay = 'R'                                            BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
      **********                                                                             BUG5449
     C*****KDTSCList     SETLL     IRWDTSCL0                                                 BUG5449
     C*****KDTSCList     READE     IRWDTSCL0                                                 BUG5449
      **********                                                                             BUG5449
     C**********         DOW       NOT %EOF(IRWDTSCL0)                                       BUG5449
     C**********         EVAL      OurRDTSC(X) = WIRDTSC                                     BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C*****KDTSCList     READE     IRWDTSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***Our*Interest Payment                                                                BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      WOurTheir = 'U'                                           BUG5449
     C**********         EVAL      WRatePay = 'P'                                            BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
      **********                                                                             BUG5449
     C*****KDTSCList     SETLL     IRWDTSCL0                                                 BUG5449
     C*****KDTSCList     READE     IRWDTSCL0                                                 BUG5449
      **********                                                                             BUG5449
     C**********         DOW       NOT %EOF(IRWDTSCL0)                                       BUG5449
     C**********         EVAL      OurIDTSC(X) = WIRDTSC                                     BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C*****KDTSCList     READE     IRWDTSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***Their*Rate                                                                          BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      WOurTheir = 'T'                                           BUG5449
     C**********         EVAL      WRatePay = 'R'                                            BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
      **********                                                                             BUG5449
     C*****KDTSCList     SETLL     IRWDTSCL0                                                 BUG5449
     C*****KDTSCList     READE     IRWDTSCL0                                                 BUG5449
      **********                                                                             BUG5449
     C**********         DOW       NOT %EOF(IRWDTSCL0)                                       BUG5449
     C**********         EVAL      ThrRDTSC(X) = WIRDTSC                                     BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C*****KDTSCList     READE     IRWDTSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***Their*Interest Payment                                                              BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      WOurTheir = 'T'                                           BUG5449
     C**********         EVAL      WRatePay = 'P'                                            BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
      **********                                                                             BUG5449
     C*****KDTSCList     SETLL     IRWDTSCL0                                                 BUG5449
     C*****KDTSCList     READE     IRWDTSCL0                                                 BUG5449
      **********                                                                             BUG5449
     C**********         DOW       NOT %EOF(IRWDTSCL0)                                       BUG5449
     C**********         EVAL      ThrIDTSC(X) = WIRDTSC                                     BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C*****KDTSCList     READE     IRWDTSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***Our*Cash Flow                                                                       BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      WOurTheir = 'U'                                           BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
      **********                                                                             BUG5449
     C*****KCFPCList     SETLL     IRWCFSCL0                                                 BUG5449
     C*****KCFPCList     READE     IRWCFSCL0                                                 BUG5449
      **********                                                                             BUG5449
     C**********         DOW       NOT %EOF(IRWCFSCL0)                                       BUG5449
     C**********         EVAL      OurCFSC(X) = WCashFlw                                     BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C*****KCFPCList     READE     IRWCFSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***Their*Cash Flow                                                                     BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      WOurTheir = 'T'                                           BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
      **********                                                                             BUG5449
     C*****KCFPCList     SETLL     IRWCFSCL0                                                 BUG5449
     C*****KCFPCList     READE     IRWCFSCL0                                                 BUG5449
      **********                                                                             BUG5449
     C**********         DOW       NOT %EOF(IRWCFSCL0)                                       BUG5449
     C**********         EVAL      ThrCFSC(X) = WCashFlw                                     BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C*****KCFPCList     READE     IRWCFSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***Our*Principal Change                                                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        CAP041 = 'Y'                                              BUG5449
     C**********         EVAL      WOurTheir = 'U'                                           BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
      **********                                                                             BUG5449
     C*****KCFPCList     SETLL     IRWPCSCL0                                                 BUG5449
     C*****KCFPCList     READE     IRWPCSCL0                                                 BUG5449
      **********                                                                             BUG5449
     C**********         DOW       NOT %EOF(IRWPCSCL0)                                       BUG5449
     C**********         EVAL      OurPCSC(X) = WPrinChg                                     BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C*****KCFPCList     READE     IRWPCSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***Their*Principal Change                                                              BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      WOurTheir = 'T'                                           BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
      **********                                                                             BUG5449
     C*****KCFPCList     SETLL     IRWPCSCL0                                                 BUG5449
     C*****KCFPCList     READE     IRWPCSCL0                                                 BUG5449
      **********                                                                             BUG5449
     C**********         DOW       NOT %EOF(IRWPCSCL0)                                       BUG5449
     C**********         EVAL      ThrPCSC(X) = WPrinChg                                     BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C*****KCFPCList     READE     IRWPCSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDSR                                                               BUG5449
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateAc - Routine to validate action code versus the      *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************

     C     ValidateAc    BEGSR

      ** Validate action code versus transaction IDs supplied
      ** This function will set the Midas deal number
      ** The deal in file format from the database is retrieved as well.

     C                   RESET                   ReturnCode

     C                   CALLB     'IRCIRSRTV'

      ** INPUTS

      * Return code
     C                   PARM                    ReturnCode

      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE

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

      ** Switchable feature CIR008

     C                   PARM                    CIR008

      * OUTPUTS

      * (Current) deal in file format
     C                   PARM                    DealFilFmt
     C                   PARM                    DealXFilFmt

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
     C                   PARM                    CIR003
     C                   PARM                    ExtSetV
     C                   PARM                    ExtSetI
     C                   PARM                    ExtSetM

      ** Warning flds/message IDs/message data (arrays) from/to caller

     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    WIdx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DftSettmts - Routine to apply default settlement instructions*
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************

     C     DftSettmts    BEGSR

      ** Set up ISDA fields so that defaulting module will not change them if                BUG5967
      ** have been entered already.                                                          BUG5967
      ** But only overwrite the defaulted values from ICD if the screen details are not blankBUG6940
      ** If the customer has SSI for this currency then these are defaulted in ZASETINDFT    BUG6940
     C                   If        DDISDA <> *blanks                                         BUG6940
     C                   Eval      BQISDA = DDISDA                                           BUG5967
     C                   EndIf                                                               BUG6940
     C                   If        DDAGTY <> *blanks                                         BUG6940
     C                   Eval      BQAGTY = DDAGTY                                           BUG5967
     C                   EndIf                                                               BUG6940
     C                   If        DDAGDT <> *blanks                                         BUG6940
     C                   Eval      BQAGDT = DDAGDT                                           BUG5967
     C                   EndIf                                                               BUG6940
     C                   If        DDAGVV <> *blanks                                         BUG6940
     C                   Eval      WWAGVV = DDAGVV                                           BUG5967
     C                   Eval      BQAGVV = WDAGVV                                           BUG5967
     C                   Eval      BQAGVC = WDAGVC                                           BUG5967
     C                   EndIf                                                               BUG6940
      *                                                                                      BUG5967
      ** If ANY of the Settlements fields have been entered, bypass this
      **  routine.
      ** Otherwise, use modules which will use Standard Settlement
      **  Instructions to apply defaults.

     C                   IF        InRecSttmt = *blank
     C                             AND InPaySttmt = *blank
     C                             AND InFraSttmt = *blank                                   BUG8997
      **Save*the*ISDA*fields                                                                 BUG5967
     C**********         MOVE      DDISDA        DDISDASV          4                         BUG5967
     C**********         MOVE      DDAGTY        DDAGTYSV          6                         BUG5967
     C**********         MOVE      DDAGDT        DDAGDTSV          6                         BUG5967
     C**********         MOVE      DDAGVV        DDAGVVSV          4                         BUG5967

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
     C                   PARM                    BQISDA
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV

      ** Version of ISDA Agreement century
     C                   PARM                    BQAGVC
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C******             PARM      *BLANK        BlankSTYP                          CSD095 CSD095CC1
     C                   PARM      SDLST         BlankSTYP                                 CSD095CC1
      ** Branch                                                                               CSD095
     C******             PARM      *BLANK        BlankBRCA                          CSD095 CSD095CC1
     C                   PARM      SBRCA         BlankBRCA                                 CSD095CC1
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt

      *  The defaulted instructions are in file format, but the
      *  Settlements validation requires that they are in the input format.
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

      **Restore*the saved ISBA fields                                                        BUG5967
     C**********         MOVE      DDISDASV      DDISDA            4                         BUG5967
     C**********         MOVE      DDAGTYSV      DDAGTY            6                         BUG5967
     C**********         MOVE      DDAGDTSV      DDAGDT            6                         BUG5967
     C**********         MOVE      DDAGVVSV      DDAGVV            4                         BUG5967

     C                   Else                                                                BUG5967
      ***Even*if*settlement details have been entered, default the ISDA fields if theBUG5967 BUG6940
      ***haven't*been*entered.  Call settlement default module again but this time onBUG5967 BUG6940
      ***default*the*ISDA fields                                                     BUG5967 BUG6940
     C**********         If        DDISDA = *blank                                   BUG5967 BUG6940
     C**********                   and DDAGTY = *blank                               BUG5967 BUG6940
     C**********                   and DDAGDT = *blank                               BUG5967 BUG6940
     C**********                   and DDAGVV = *blank                               BUG5967 BUG6940
     C**********                                                                     BUG5967 BUG6940
     C**********         CALLB     'ZASETINDFT'                                      BUG5967 BUG6940
     C**********         PARM                    CIRS                                BUG5967 BUG6940
     C**********         PARM                    SuCucy                              BUG5967 BUG6940
     C**********         PARM                    StCucy                              BUG5967 BUG6940
     C**********         PARM                    SCNum                               BUG5967 BUG6940
     C**********         PARM                    SDTyp                               BUG5967 BUG6940
     C**********         PARM                    SuFFI                               BUG5967 BUG6940
      ** Version of ISDA Rules govern                                                BUG5967 BUG6940
     C**********         PARM                    BQISDA                              BUG5967 BUG6940
      ** Type of ISDA agreement                                                      BUG5967 BUG6940
     C**********         PARM                    BQAGTY                              BUG5967 BUG6940
      ** Date of ISDA Agreement                                                      BUG5967 BUG6940
     C**********         PARM                    BQAGDT                              BUG5967 BUG6940
      ** Version of ISDA Agreement                                                   BUG5967 BUG6940
     C**********         PARM                    BQAGVV                              BUG5967 BUG6940
      ** Version of ISDA Agreement century                                           BUG5967 BUG6940
     C**********         PARM                    BQAGVC                              BUG5967 BUG6940
     C**********         PARM                    DBPaySttmt                          BUG5967 BUG6940
     C**********         PARM                    DBRecSttmt                          BUG5967 BUG6940
      ** Defaulted FRA/IRS Settlement Instruction in file format                     BUG5967 BUG6940
     C**********         PARM                    DBFRASttmt                          BUG5967 BUG6940
      **********                                                                     BUG5967 BUG6940
      ** Setup the ISDA fields                                                       BUG5967 BUG6940
     C**********         Eval      DDISDA = FLISDA                                   BUG5967 BUG6940
     C**********         Eval      DDAGTY = FLAGTY                                   BUG5967 BUG6940
     C**********         Eval      DDAGDT = FLAGDT                                   BUG5967 BUG6940
     C**********         Eval      WDAGVV = FLAGVV                                   BUG5967 BUG6940
     C**********         Eval      WDAGVC = FLAGVC                                   BUG5967 BUG6940
     C**********         Eval      DDAGVV = WWAGVV                                   BUG5967 BUG6940
     C**********         EndIf                                                       BUG5967 BUG6940
                                                                                              244254
      ** else, if pay/rec details are manually entered on the screen,                         244254
      ** try to retrieve and default the ISDA details.                                        244254
     C                   EXSR      DefISDA                                                    244254
      *                                                                                    BUG5962RP
      ** Default Maturity Date Settlements from Interest Settlements                       BUG5962RP
     C                   If        InRecStmtM = *blanks                                    BUG5962RP
     C                             AND InPayStmtM = *blanks                                BUG5962RP
     C                   Eval      InRecStmtM = InRecSttmt                                 BUG5962RP
     C                   Eval      InPayStmtM = InPaySttmt                                 BUG5962RP
     C                   EndIf                                                             BUG5962RP
                                                                                           BUG5962RP
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SetupAmend - Set up fields that are needed in the validation *
      *    of Amendments.                                             *
      *                                                               *
      *****************************************************************

     C     SetupAmend    BEGSR

      ** For Amends, put the complete (pre-existing) IRS into the Valid
      ** file record - fields in this will be updated during  processing
     C                   MOVEL     DealFilFmt    ValidDeal

     C                   Eval      %SUBST(DBRecSttmt:21:55) =
     C                               %SUBST(CIRSRecIns:15:55)
     C                   Eval      FLRSTM = RXRSTM
     C                   Eval      FLRONS = RXRONS
     C                   Eval      FLROBR = RXROBR
     C                   EVAL      FLRSCY     = RXRSCY
     C                   Eval      %SUBST(DBPaySttmt:21:545)=
     C                                %SUBST(CIRSPayIns:15:545)
     C                   Eval      FLPSTM = RXPSTM
     C                   Eval      FLPONS = RXPONS
     C                   Eval      FLPOBR = RXPOBR
     C                   Eval      FLCVMR = RXCVMR
     C                   EVAL      FLPSCY     = RXPSCY
     C                   EVAL      FLIC72     = RXIC72
     C                   EVAL      DBFraSttmt = CIRSFraIns
     C                   MOVE      RXAGVC        FLAGVC
     C                   MOVEL     *BLANK        RXAUTH                                     AR981707

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
     C                   PARM      @STCUCY       InRCCY                                      CSF011A
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

     C                   IF        GHSUBS <> *Blank
     C     GHSUBS        SCAN      InPaySttmt                             99

     C                   IF        *IN99 = *OFF
     C     GHSUBS        SCAN      InRecSttmt                             99
     C                   ENDIF

     C                   IF        *IN99 = *OFF
     C     GHSUBS        SCAN      InFRASttmt                             99
     C                   ENDIF

     C                   IF        *IN99 = *ON
     C                   EXSR      SDtDtaSubs
     C                   ENDIF
     C                   ENDIF

     C                   IF        CIR003 = 'Y'
     C                   CLEAR                   DBFRAStmtE
     C                   IF        SVDEI = 'Y'
     C                             OR   SPDEI = 'Y'
     C                   EVAL      DBRecStmtE = ExRValDat
     C                   EVAL      DBPayStmtE = ExPValDat
     C                   EXSR      SrAmdCvt

     C                   IF        InPayStmtV = *blanks
     C                   EVAL      InPayStmtV = CrPayStmtE
     C                   ENDIF

     C                   IF        InRecStmtV = *blanks
     C                   EVAL      InRecStmtV = CrRecStmtE
     C                   ENDIF
     C                   EVAL      InPayStmtE = InPayStmtV
     C                   EVAL      InRecStmtE = InRecStmtV

      ** Do data substitution for Settlement Instructions

     C                   IF        GHSUBS <> *blanks
     C     GHSUBS        SCAN      InPayStmtV                             99
     C                   IF        *IN99 = *OFF
     C     GHSUBS        SCAN      InRecStmtV                             99
     C                   ENDIF
     C                   IF        *IN99 = *ON
     C                   EXSR      SExDtaSubs
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   IF        SMDEI = 'Y'
     C                             OR   SPDEI = 'Y'
     C                   EVAL      DBRecStmtE = ExRMatDat
     C                   EVAL      DBPayStmtE = ExPMatDat
     C                   EXSR      SrAmdCvt

     C                   IF        InPayStmtM = *blanks
     C                   EVAL      InPayStmtM = CrPayStmtE
     C                   ENDIF

     C                   IF        InRecStmtM = *blanks
     C                   EVAL      InRecStmtM = CrRecStmtE
     C                   ENDIF
     C                   EVAL      InPayStmtE = InPayStmtM
     C                   EVAL      InRecStmtE = InRecStmtM

      ** Do data substitution for Settlement Instructions

     C                   IF        GHSUBS <> *blanks
     C     GHSUBS        SCAN      InPayStmtM                             99
     C                   IF        *IN99 = *OFF
     C     GHSUBS        SCAN      InRecStmtM                             99
     C                   ENDIF
     C                   IF        *IN99 = *ON
     C                   EXSR      SExDtaSubs
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateTr - Routine to validate the main transaction details*
      *                                                               *
      *****************************************************************

     C     ValidateTr    BEGSR

      ** Set up the settlemnt information needed for holidays validation:
      ** - default fields for Inserts
      ** - existing d/b fields for Amends

     C                   IF        SACCD = 'I'
      ** This block assumes that Settlement Instructions are never received
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

      ** Business Day Convention enhancement is installed, allow
      ** validation of dates through currency conventions, otherwise
      ** validation against BDC not needed.
     C                   IF        CIR005 = 'Y'
     C                   EVAL      WValBDC = 'Y'
     C                   ENDIF

     C                   CALLB     'IRCIRSVAL'
     C                   PARM                    ModeOfOp
      ** Response mode (1A), from source system common header
     C                   PARM      'S'           APRespMode
      ** Transaction information (DS) from source system
     C                   PARM                    TranIn
      ** Receive Settlement Method & Nostro and  Pay Settlement Method &
      **  Nostro, from default (Action = I) or valid deal (Action = A)
      ** Extra Data
     C                   PARM      *BLANKS       RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM      *BLANKS       PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    ExtData
      ** Business Day Validation
     C                   PARM                    WValBDC
      ** Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
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
     C                   PARM                    ValidXDeal
      *
     C                   PARM                    SACCD
     C                   PARM                    USLIP
     C                   PARM                    TSLIP

      ** Current Deal in Screen Format
     C                   PARM                    DealScnfmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateSt - Routine to validate the settlemnt instructions  *
      *                                                               *
      *****************************************************************

     C     ValidateSt    BEGSR

      ** The called module requires that the customer number/name is valid,
      **  if it is not, exit from this subroutine.
     C                   IF        NOT (SCNumOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF

      ** Set pay and receive dates to run date
     C                   EVAL      PayDat = BJRDNB
     C                   EVAL      RecDat = BJRDNB

      * Store number of errors before call to settlement validation module                   BUG7209
     C                   Eval      BfIdx = Idx                                               BUG7209
     C                   Eval      BfWIdx = WIdx                                             BUG7209
                                                                                             BUG7209
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
      ** Action Code
     C                   PARM                    SACCD
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
     C                   PARM                    OKCIRSInDS
      ** Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Extra Input
      ** Action Code used
     C                   PARM      SACCD         ##ACTN
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter

      * Setup correct field names if there are any settlement errors                         BUG7209
     C                   Eval      AfIdx = Idx                                               BUG7209
     C                   Eval      SetPrfx = 'A'                                             BUG7209
                                                                                             BUG7209
     C                   If        AfIdx <> BfIdx                                            BUG7209
     C                   EXSR      SettMsg                                                   BUG7209
     C                   EndIf                                                               BUG7209
      * Warning messages                                                                     BUG7209
     C                   Eval      AfWIdx = WIdx                                             BUG7209
     C                   If        AfWIdx <> BfWIdx                                          BUG7209
     C                   EXSR      SettWrnMsg                                                BUG7209
     C                   EndIf                                                               BUG7209
                                                                                             BUG7209
     C     ValSetExit    TAG

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  TDtDtaSubs - Transaction Details Data Substitution           *
      *                                                               *
      *****************************************************************

     C     TDtDtaSubs    BEGSR

      ** Conversion of file fields to screen format

     C                   RESET                   ReturnCode
     C                   CALLB     'IRCIRSCVT'

      ** INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      ** (Current) Deal in file format
     C                   PARM                    DealFilfmt
     C                   PARM                    DealXFilFmt
      ** Switchable feature CIR008
     C                   PARM                    CIR008

      ** OUTPUTS
      ** (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      ** Deal Status
     C                   PARM                    DDSTS

      ** Data Sunstitution

     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      ** Return Code
     C                   PARM                    ReturnCode
      ** Substitution character
     C                   PARM      GHSUBS        SubsChar
      ** Incoming Data
     C                   PARM      TranIn        IncDATA
      ** Current Data
     C                   PARM      DealScnfmt    CurDATA

     C                   MOVEL     IncDATA       TranIn

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SDtDtaSubs - Settlement Details Data Substitution            *
      *                                                               *
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
      *                                                               *
      *  ValidateIC - Routine to validate Interest Rate Calendars     *
      *                                                               *
      *****************************************************************

     C     ValidateIC    BEGSR

      ** Validate Our Rate Change Dates

      ***Invalid if Our Rate Change Frequency indicator not 'Z'                              BUG5449
      **********                                                                             BUG5449
     C**********         IF        ORDatesAlp <> *BLANKS                                     BUG5449
     C**********                   AND ORDatesAlp <> *ZEROS                                  BUG5449
     C**********                   AND RXUICFR <> 'Z'                                        BUG5449
     C**********         MOVE      'N'           OKInRatCal                                  BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SUICFR'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1246'                                 BUG5449
     C**********         ELSE                                                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXUICFR = 'Z'                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
      ***Following parameters are output to called module                                    BUG5449
      ***Return Code                                                                         BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
      ***Valid*Value date in 5,0 format                                                      BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
      ***Valid*Maturity date in 5,0 format                                                   BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      *ZERO         PCtlDate                                    BUG5449
      ***Date*format indicator                                                               BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM      *ZEROS        PPrevDate                                   BUG5449
     C**********         PARM      'R'           PValType                                    BUG5449
     C**********         PARM      'U'           POurTheir                                   BUG5449
     C**********         PARM      SUCUCY        PCurrency                                   BUG5449
      ***Our*Rate Change dates (82 x 6A)                                                     BUG5449
     C**********         PARM      ORDatesAlp    DatesToVal                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal1                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal2                                  BUG5449
     C**********         PARM      *BLANK        PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg1      PBDConvtn                                   BUG5449
      **********                                                                             BUG5449
      ***Following parameters are returned by called module                                  BUG5449
      ***IRC Dates OK flag                                                                   BUG5449
     C**********         PARM                    OKInRatCal                                  BUG5449
      ***Error*fields/message IDs (arrays) from/to caller                                    BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
      ***Array*index (3P0) from/to caller                                                    BUG5449
     C**********         PARM                    Idx                                         BUG5449
      ***Our*Rate Change dates in day number format (82 x 3A)                                BUG5449
     C**********         PARM                    ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKInRatCal <> 'Y'                                         BUG5449
     C**********         GOTO      ValIRCExit                                                BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         MOVE      ValidDates    ORDates                                     BUG5449
     C**********         MOVE      PConfHol      ORConfH                                     BUG5449
     C**********         EVAL      WORPrvDate = PPrevDate                                    BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Validate Our Interest Payment Dates                                                 BUG5449
      **********                                                                             BUG5449
      ***Invalid if Our Interest Payment Frequency indicator not 'Z'                         BUG5449
      **********                                                                             BUG5449
     C*****OPDatesAlp    IFNE      *BLANKS                                                   BUG5449
     C*****OPDatesAlp    ANDNE     *ZEROS                                                    BUG5449
     C*****RXUIPFR       ANDNE     'Z'                                                       BUG5449
     C**********         MOVE      'N'           OKInRatCal                                  BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SUIPFR'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1246'                                 BUG5449
     C**********         ELSE                                                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXUIPFR = 'Z'                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
      ***Following parameters are output to called module                                    BUG5449
      ***Return Code                                                                         BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
      ***Valid*Value date in 5,0 format                                                      BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
      ***Valid*Maturity date in 5,0 format                                                   BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      *ZERO         PCtlDate                                    BUG5449
      ***Date*format indicator                                                               BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM      *ZEROS        PPrevDate                                   BUG5449
     C**********         PARM      'I'           PValType                                    BUG5449
     C**********         PARM      'U'           POurTheir                                   BUG5449
     C**********         PARM      SUCUCY        PCurrency                                   BUG5449
      ***Our*Interest Payment dates                                                          BUG5449
     C**********         PARM      OPDatesAlp    DatesToVal                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal1                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal2                                  BUG5449
     C**********         PARM      *BLANK        PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg1      PBDConvtn                                   BUG5449
      **********                                                                             BUG5449
      ***Following parameters are returned by called module                                  BUG5449
      ***IRC*Dates OK flag                                                                   BUG5449
     C**********         PARM                    OKInRatCal                                  BUG5449
      ***Error*fields/message IDs (arrays) from/to caller                                    BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
      ***Array*index (3P0) from/to caller                                                    BUG5449
     C**********         PARM                    Idx                                         BUG5449
      ***Our*Interest Payment dates in day number format (82 x 3A)                           BUG5449
     C**********         PARM                    ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKInRatCal <> 'Y'                                         BUG5449
     C**********         GOTO      ValIRCExit                                                BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         MOVE      ValidDates    OPDates                                     BUG5449
     C**********         MOVE      PConfHol      OPConfH                                     BUG5449
     C**********         EVAL      WOPPrvDate = PPrevDate                                    BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Validate Their Rate Change Dates                                                    BUG5449
      **********                                                                             BUG5449
      ***Invalid if Their Rate Change Frequency indicator not 'Z'                            BUG5449
      **********                                                                             BUG5449
     C**********         IF        TRDatesAlp <> *BLANKS                                     BUG5449
     C**********                   AND TRDatesAlp <>*ZEROS                                   BUG5449
     C**********                   AND RXTICFR <> 'Z'                                        BUG5449
     C**********         MOVE      'N'           OKInRatCal                                  BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'STICFR'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1246'                                 BUG5449
     C**********         ELSE                                                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXTICFR = 'Z'                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
      ***Following parameters are output to called module                                    BUG5449
      ***Return*Code                                                                         BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
      ***Valid*Value date in 5,0 format                                                      BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
      ***Valid*Maturity date in 5,0 format                                                   BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      *ZERO         PCtlDate                                    BUG5449
      ***Date*format indicator                                                               BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM      *ZEROS        PPrevDate                                   BUG5449
     C**********         PARM      'R'           PValType                                    BUG5449
     C**********         PARM      'T'           POurTheir                                   BUG5449
     C**********         PARM      STCUCY        PCurrency                                   BUG5449
      ***Their*Rate Change dates                                                             BUG5449
     C**********         PARM      TRDatesAlp    DatesToVal                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal1                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal2                                  BUG5449
     C**********         PARM      *BLANK        PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg2      PBDConvtn                                   BUG5449
      **********                                                                             BUG5449
      ***Following parameters are returned by called module                                  BUG5449
      ***IRC*Dates OK flag                                                                   BUG5449
     C**********         PARM                    OKInRatCal                                  BUG5449
      ***Error*fields/message IDs (arrays) from/to caller                                    BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
      ***Array*index (3P0) from/to caller                                                    BUG5449
     C**********         PARM                    Idx                                         BUG5449
      ***Their*Rate Change dates in day number format (82 x 3A)                              BUG5449
     C**********         PARM                    ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKInRatCal <> 'Y'                                         BUG5449
     C**********         GOTO      ValIRCExit                                                BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         MOVE      ValidDates    TRDates                                     BUG5449
     C**********         MOVE      PConfHol      TRConfH                                     BUG5449
     C**********         EVAL      WTRPrvDate = PPrevDate                                    BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Validate Their Interest Payment Dates                                               BUG5449
      **********                                                                             BUG5449
     C**********         IF        TPDatesAlp <> *BLANKS                                     BUG5449
     C**********                   AND TPDatesAlp <> *ZEROS                                  BUG5449
     C**********                   AND RXTIPFR <> 'Z'                                        BUG5449
     C**********         MOVE      'N'           OKInRatCal                                  BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'STIPFR'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1246'                                 BUG5449
     C**********         ELSE                                                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXTIPFR = 'Z'                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
      ***Following parameters are output to called module                                    BUG5449
      ***Return*Code                                                                         BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
      ***Valid*Value date in 5,0 format                                                      BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
      ***Valid*Maturity date in 5,0 format                                                   BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      *ZERO         PCtlDate                                    BUG5449
      ***Date*format indicator                                                               BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM      *ZEROS        PPrevDate                                   BUG5449
     C**********         PARM      'I'           PValType                                    BUG5449
     C**********         PARM      'T'           POurTheir                                   BUG5449
     C**********         PARM      STCUCY        PCurrency                                   BUG5449
      ***Their*Interest Payment dates                                                        BUG5449
     C**********         PARM      TPDatesAlp    DatesToVal                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal1                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal2                                  BUG5449
     C**********         PARM      *BLANK        PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg2      PBDConvtn                                   BUG5449
      **********                                                                             BUG5449
      ***Following parameters are returned by called module                                  BUG5449
      ***IRC*Dates OK flag                                                                   BUG5449
     C**********         PARM                    OKInRatCal                                  BUG5449
      **Error*fields/message IDs (arrays) from/to caller                                     BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
      **Array*index (3P0) from/to caller                                                     BUG5449
     C**********         PARM                    Idx                                         BUG5449
      ***Their*Interest Payment dates in day number format (82 x 3A)                         BUG5449
     C**********         PARM                    ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKInRatCal <> 'Y'                                         BUG5449
     C**********         GOTO      ValIRCExit                                                BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         MOVE      ValidDates    TPDates                                     BUG5449
     C**********         MOVE      PConfHol      TPConfH                                     BUG5449
     C**********         EVAL      WTPPrvDate = PPrevDate                                    BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C*****ValIRCExit    TAG                                                                 BUG5449
      **********                                                                             BUG5449
     C                   MOVEL     RXDLNO        WDealNo                                     BUG5449
     C                   IF        SMDAT <> *BLANKS                                          BUG5449
     C                   EVAL      InDate = SMDAT                                            BUG5449
      ** Convert date from DDMMYY to Midas day number                                        BUG5449
     C                   CALLB     'ZDATE1'                                                  BUG5449
     C                   PARM                    InDate                                      BUG5449
     C                   PARM                    InDateMDN                                   BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM                    ErrorFlag                                   BUG5449
     C                   Z-ADD     InDateMDN     CMDYN             5 0                       BUG5449
     C                   ELSE                                                                BUG5449
     C                   Z-ADD     0             CMDYN                                       BUG5449
     C                   ENDIF                                                               BUG5449
      ** Clear Unprocessed schedules data structure                                          BUG7621
     C                   CLEAR                   UPPSCH                                      BUG7621
                                                                                             BUG5449
      ** Our rate change date Schedule                                                       BUG5449
     C     SUICFR        IFEQ      'Z'                                                       BUG5449
     C     ORDATEA(1)    ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'R'                                            BUG5449
     C                   EVAL      POurTheir= 'U'                                            BUG5449
     C                   EVAL      WRatePay = 'R'                                            BUG5449
     C                   MOVEL     *BLANKS       SDATENAME        10                         BUG5449
     C                   MOVEL     'SDATEOR'     SDATENAME                                   BUG5449
     C                   MOVEL     *BLANKS       SCHEDNAME        35                         BUG5449
     C                   MOVEL     OurRate       SCHEDNAME                                   BUG5449
     C                   EXSR      CheckCurr                                                 BUG5449
     C                   EVAL      X=%LOOKUP('        ':ORDATEA)                             BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   EXSR      SRGetCtlDate                                              BUG5449
      * Default with control date                                                            BUG5449
     C                   IF        X=1                                                       BUG5449
     C                             and SUNICD <> *blanks                                     BUG7621
     C                   EVAL      ORDATEA(X)=SUNICD                                         BUG5449
     C                   ADD       1             X                                           BUG5449
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
     C                   ENDIF                                                               BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      DATESCH=ORDATEA(I)                                        BUG5449
     C                   EVAL      InDate = DSDATE                                           BUG5449
     C                   EVAL      CHol = DSCHOL                                             BUG5449
     C                   EVAL      PDAT = DSPDAT                                             BUG5449
     C                   MOVEL     DSDATE        MSGDATE           6                         BUG5449
     C                   EXSR      SRZEDIT                                                   BUG5449
      * Validate date                                                                        BUG5449
     C                   EXSR      CheckDate                                                 BUG5449
     C     INDATEMDN     LOOKUP    ORMDATE                                24                 BUG5449
     C                   IF        *IN24 = *ON                                               BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      ORMDATE(I)=INDATEMDN                                      BUG5449
      * Validate confirm holiday flag                                                        BUG5449
     C                   EXSR      ConfHol                                                   BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
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
     C                   EVAL      RXUNICD=ZDAYNO                               BUG5964
     C                   If        SUICFR = *blanks                                          BUG7621
     C                   Eval      SUICFR = 'Z'                                              BUG7621
     C                   Eval      RXUICFR = 'Z'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'SUNICD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0600'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                             BUG5449
      * Validate formula                                                                     BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C                   EVAL      SFREQF = SFREQFOR                                         BUG5449
     C                   EVAL      SFORM = SFORMOR                                           BUG5449
     C                   MOVEL     *BLANKS       SFORMNAME        10                         BUG5449
     C                   MOVEL     'SFREQFOR'    SFORMNAME                                   BUG5449
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR                           BUG5449
     C                             SFREQF = 'X' OR SFREQF = 'Y'                              BUG5449
     C                   EXSR      ValFormula                                                BUG5449
                                                                                             BUG5449
      * Generate Dates                                                                       BUG5449
     C                   IF        Idx=0 AND SFORM <> *BLANKS                                BUG5449
      *******************                                                             BUG5449BUG5964
     C*******************IF        SACCD = 'I' AND X>1                                BUG5449BUG5964
     C*******************EVAL      WCTLDYN = ORMDATE(1)                               BUG5449BUG5964
     C*******************EVAL      I=1                                                BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************DOW       I<X                                                BUG5449BUG5964
     C*******************IF        ORMDATE(I) < WCTLDYN                               BUG5449BUG5964
     C*******************EVAL      WCTLDYN = ORMDATE(I)                               BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ADD       1             I                                    BUG5449BUG5964
     C*******************ENDDO                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C                   MOVEL     SFORM         FFDATC                                      BUG5449
     C                   MOVEL     SUCUCY        FFCCY1                                      BUG5449
     C                   MOVEL     *BLANK        FFCCY2                                      BUG5449
     C                   MOVE      *BLANK        FFCCY3                                      BUG5449
     C                   Z-ADD     *ZERO         PRDT                                        BUG5449
     C                   EVAL      K=X                                                       BUG5449
     C                   MOVEA     ORMDATE       WMDATE                                      BUG5449
     C                   EXSR      GENDATES                                                  BUG5449
     C                   MOVEA     WMDATE        ORMDATE                                     BUG5449
     C                   EVAL      L = 1                                                     BUG5449
     C                   DOW       L < K                                                     BUG5449
                                                                                             BUG5449
      ** Check if it is a saturday or a sunday                                               BUG5449
      ** and treat it as holiday                                                             BUG5449
                                                                                             BUG5449
     C                   EVAL      WRK153 = ORMDATE(L)/7                                     BUG5449
     C                   MOVE      WRK153        WRK30                                       BUG5449
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                            BUG5449
     C                   EVAL      %SUBST(ORDATEA(L):7:1)='Y'                                BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      ZDAYNO =  ORMDATE(L)                                      BUG5449
     C                   CALLB     'ZDATE2'                                                  BUG5449
     C                   PARM                    ZDAYNO                                      BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM      *ZEROS        ZDATE                                       BUG5449
     C                   PARM      *BLANKS       ZADATE            7                         BUG5449
                                                                                             BUG5449
     C                   MOVEL     ZDATE         ORDATEA(L)                                  BUG5449
     C                   ADD       1             L                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      ** Our Interest Payment dates                                                          BUG5449
     C     SUIPFR        IFEQ      'Z'                                                       BUG5449
     C     OPDATEA(1)    ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'I'                                            BUG5449
     C                   EVAL      WRatePay = 'P'                                            BUG5449
     C                   EVAL      POurTheir= 'U'                                            BUG5449
     C                   MOVEL     *BLANKS       SDATENAME                                   BUG5449
     C                   MOVEL     'SDATEOP'     SDATENAME                                   BUG5449
     C                   MOVEL     *BLANKS       SCHEDNAME                                   BUG5449
     C                   MOVEL     OurPay        SCHEDNAME                                   BUG5449
     C                   EXSR      CheckCurr                                                 BUG5449
     C                   EVAL      X=%LOOKUP('        ':OPDATEA)                             BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   EXSR      SRGetCtlDate                                              BUG5449
      * Default with control date                                                            BUG5449
     C                   IF        X=1                                                       BUG5449
     C                             and SUNIPD <> *blanks                                     BUG7621
     C                   EVAL      OPDATEA(X)=SUNIPD                                         BUG5449
     C                   ADD       1             X                                           BUG5449
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
     C                   ENDIF                                                               BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      DATESCH=OPDATEA(I)                                        BUG5449
     C                   EVAL      InDate = DSDATE                                           BUG5449
     C                   EVAL      CHol = DSCHOL                                             BUG5449
     C                   EVAL      PDAT = DSPDAT                                             BUG5449
     C                   MOVEL     DSDATE        MSGDATE                                     BUG5449
     C                   EXSR      SRZEDIT                                                   BUG5449
     C                   EXSR      CheckDate                                                 BUG5449
                                                                                             BUG5449
     C     INDATEMDN     LOOKUP    OPMDATE                                24                 BUG5449
     C                   IF        *IN24 = *ON                                               BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      OPMDATE(I)=INDATEMDN                                      BUG5449
     C                   EXSR      ConfHol                                                   BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
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
     C                   EVAL      RXUNIPD=ZDAYNO                               BUG5964
     C                   If        SUIPFR = *blanks                                          BUG7621
     C                   Eval      SUIPFR = 'Z'                                              BUG7621
     C                   Eval      RXUIPFR = 'Z'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'SUNIPD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0601'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   EndIf                                                               BUG7621
     C                   ENDIF                                                  BUG5964
                                                                                             BUG5449
      * Validate formula                                                                     BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C                   EVAL      SFREQF = SFREQFOP                                         BUG5449
     C                   EVAL      SFORM = SFORMOP                                           BUG5449
     C                   MOVEL     *BLANKS       SFORMNAME                                   BUG5449
     C                   MOVEL     'SFREQFOP'    SFORMNAME                                   BUG5449
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR                           BUG5449
     C                             SFREQF = 'X' OR SFREQF = 'Y'                              BUG5449
     C                   EXSR      ValFormula                                                BUG5449
                                                                                             BUG5449
      * Generate Dates                                                                       BUG5449
     C                   IF        Idx=0 AND SFORM <> *BLANKS                                BUG5449
      *******************                                                             BUG5449BUG5964
     C*******************IF        SACCD = 'I' AND X>1                                BUG5449BUG5964
     C*******************EVAL      WCTLDYN = OPMDATE(1)                               BUG5449BUG5964
     C*******************EVAL      I=1                                                BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************DOW       I<X                                                BUG5449BUG5964
     C*******************IF        OPMDATE(I) < WCTLDYN                               BUG5449BUG5964
     C*******************EVAL      WCTLDYN = OPMDATE(I)                               BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ADD       1             I                                    BUG5449BUG5964
     C*******************ENDDO                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C                   MOVEL     SFORM         FFDATC                                      BUG5449
     C                   MOVEL     WPSCY         FFCCY1                                      BUG5449
     C                   MOVEL     *BLANK        FFCCY2                                      BUG5449
     C                   MOVE      *BLANK        FFCCY3                                      BUG5449
     C                   Z-ADD     *ZERO         PRDT                                        BUG5449
     C                   EVAL      K=X                                                       BUG5449
     C                   MOVEA     OPMDATE       WMDATE                                      BUG5449
     C                   EXSR      GENDATES                                                  BUG5449
     C                   MOVEA     WMDATE        OPMDATE                                     BUG5449
     C                   EVAL      L = 1                                                     BUG5449
     C                   DOW       L < K                                                     BUG5449
                                                                                             BUG5449
      ** Check if it is a saturday or a sunday                                               BUG5449
      ** and treat it as holiday                                                             BUG5449
                                                                                             BUG5449
     C                   EVAL      WRK153 = OPMDATE(L)/7                                     BUG5449
     C                   MOVE      WRK153        WRK30                                       BUG5449
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                            BUG5449
     C                   EVAL      %SUBST(OPDATEA(L):7:1)='Y'                                BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      ZDAYNO =  OPMDATE(L)                                      BUG5449
     C                   CALLB     'ZDATE2'                                                  BUG5449
     C                   PARM                    ZDAYNO                                      BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM      *ZEROS        ZDATE                                       BUG5449
     C                   PARM      *BLANKS       ZADATE            7                         BUG5449
                                                                                             BUG5449
     C                   MOVEL     ZDATE         OPDATEA(L)                                  BUG5449
     C                   ADD       1             L                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      ** Their rate change date Schedule                                                     BUG5449
     C     STICFR        IFEQ      'Z'                                                       BUG5449
     C     TRDATEA(1)    ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'R'                                            BUG5449
     C                   EVAL      WRatePay = 'R'                                            BUG5449
     C                   EVAL      POurTheir= 'T'                                            BUG5449
     C                   MOVEL     *BLANKS       SDATENAME                                   BUG5449
     C                   MOVEL     'SDATETR'     SDATENAME                                   BUG5449
     C                   MOVEL     *BLANKS       SCHEDNAME                                   BUG5449
     C                   MOVEL     TheirRate     SCHEDNAME                                   BUG5449
     C                   EXSR      CheckCurr                                                 BUG5449
     C                   EVAL      X=%LOOKUP('        ':TRDATEA)                             BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   EXSR      SRGetCtlDate                                              BUG5449
      * Default with control date                                                            BUG5449
     C                   IF        X=1                                                       BUG5449
     C                             and STNICD <> *blanks                                     BUG7621
     C                   EVAL      TRDATEA(X)=STNICD                                         BUG5449
     C                   ADD       1             X                                           BUG5449
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
     C                   ENDIF                                                               BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      DATESCH=TRDATEA(I)                                        BUG5449
     C                   EVAL      InDate = DSDATE                                           BUG5449
     C                   EVAL      CHol = DSCHOL                                             BUG5449
     C                   EVAL      PDAT = DSPDAT                                             BUG5449
     C                   MOVEL     DSDATE        MSGDATE                                     BUG5449
     C                   EXSR      SRZEDIT                                                   BUG5449
     C                   EXSR      CheckDate                                                 BUG5449
                                                                                             BUG5449
     C     INDATEMDN     LOOKUP    TRMDATE                                24                 BUG5449
     C                   IF        *IN24 = *ON                                               BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      TRMDATE(I)=INDATEMDN                                      BUG5449
     C                   EXSR      ConfHol                                                   BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
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
     C                   EVAL      RXTNICD=ZDAYNO                               BUG5964
     C                   If        STICFR = *blanks                                          BUG7621
     C                   Eval      STICFR = 'Z'                                              BUG7621
     C                   Eval      RXTICFR = 'Z'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'STNICD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0602'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                             BUG5449
      * Validate formula                                                                     BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C                   EVAL      SFREQF = SFREQFTR                                         BUG5449
     C                   EVAL      SFORM = SFORMTR                                           BUG5449
     C                   MOVEL     *BLANKS       SFORMNAME                                   BUG5449
     C                   MOVEL     'SFREQFTR'    SFORMNAME                                   BUG5449
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR                           BUG5449
     C                             SFREQF = 'X' OR SFREQF = 'Y'                              BUG5449
     C                   EXSR      ValFormula                                                BUG5449
                                                                                             BUG5449
      * Generate Dates                                                                       BUG5449
     C                   IF        Idx=0 AND SFORM <> *BLANKS                                BUG5449
      *******************                                                             BUG5449BUG5964
     C*******************IF        SACCD = 'I' AND X>1                                BUG5449BUG5964
     C*******************EVAL      WCTLDYN = TRMDATE(1)                               BUG5449BUG5964
     C*******************EVAL      I=1                                                BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************DOW       I<X                                                BUG5449BUG5964
     C*******************IF        TRMDATE(I) < WCTLDYN                               BUG5449BUG5964
     C*******************EVAL      WCTLDYN = TRMDATE(I)                               BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ADD       1             I                                    BUG5449BUG5964
     C*******************ENDDO                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C                   MOVEL     SFORM         FFDATC                                      BUG5449
     C                   MOVEL     SUCUCY        FFCCY1                                      BUG5449
     C                   MOVEL     *BLANK        FFCCY2                                      BUG5449
     C                   MOVE      *BLANK        FFCCY3                                      BUG5449
     C                   Z-ADD     *ZERO         PRDT                                        BUG5449
     C                   EVAL      K=X                                                       BUG5449
     C                   MOVEA     TRMDATE       WMDATE                                      BUG5449
     C                   EXSR      GENDATES                                                  BUG5449
     C                   MOVEA     WMDATE        TRMDATE                                     BUG5449
     C                   EVAL      L = 1                                                     BUG5449
     C                   DOW       L < K                                                     BUG5449
                                                                                             BUG5449
      ** Check if it is a saturday or a sunday                                               BUG5449
      ** and treat it as holiday                                                             BUG5449
                                                                                             BUG5449
     C                   EVAL      WRK153 = TRMDATE(L)/7                                     BUG5449
     C                   MOVE      WRK153        WRK30                                       BUG5449
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                            BUG5449
     C                   EVAL      %SUBST(TRDATEA(L):7:1)='Y'                                BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      ZDAYNO =  TRMDATE(L)                                      BUG5449
     C                   CALLB     'ZDATE2'                                                  BUG5449
     C                   PARM                    ZDAYNO                                      BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM      *ZEROS        ZDATE                                       BUG5449
     C                   PARM      *BLANKS       ZADATE            7                         BUG5449
                                                                                             BUG5449
     C                   MOVEL     ZDATE         TRDATEA(L)                                  BUG5449
     C                   ADD       1             L                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      ** Their Interest Payment dates                                                        BUG5449
     C     STIPFR        IFEQ      'Z'                                                       BUG5449
     C     TPDATEA(1)    ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'I'                                            BUG5449
     C                   EVAL      WRatePay = 'P'                                            BUG5449
     C                   EVAL      POurTheir= 'T'                                            BUG5449
     C                   MOVEL     *BLANKS       SDATENAME                                   BUG5449
     C                   MOVEL     'SDATETP'     SDATENAME                                   BUG5449
     C                   MOVEL     *BLANKS       SCHEDNAME                                   BUG5449
     C                   MOVEL     TheirPay      SCHEDNAME                                   BUG5449
     C                   EXSR      CheckCurr                                                 BUG5449
     C                   EVAL      X=%LOOKUP('        ':TPDATEA)                             BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   EXSR      SRGetCtlDate                                              BUG5449
      * Default with control date                                                            BUG5449
     C                   IF        X=1                                                       BUG5449
     C                             and STNIPD <> *blanks                                     BUG7621
     C                   EVAL      TPDATEA(X)=STNIPD                                         BUG5449
     C                   ADD       1             X                                           BUG5449
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
     C                   ENDIF                                                               BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      DATESCH=TPDATEA(I)                                        BUG5449
     C                   EVAL      InDate = DSDATE                                           BUG5449
     C                   EVAL      CHol = DSCHOL                                             BUG5449
     C                   EVAL      PDAT = DSPDAT                                             BUG5449
     C                   MOVEL     DSDATE        MSGDATE                                     BUG5449
     C                   EXSR      SRZEDIT                                                   BUG5449
     C                   EXSR      CheckDate                                                 BUG5449
                                                                                             BUG5449
     C     INDATEMDN     LOOKUP    TPMDATE                                24                 BUG5449
     C                   IF        *IN24 = *ON                                               BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      TPMDATE(I)=INDATEMDN                                      BUG5449
     C                   EXSR      ConfHol                                                   BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
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
     C                   EVAL      RXTNIPD=ZDAYNO                               BUG5964
     C                   If        STIPFR = *blanks                                          BUG7621
     C                   Eval      STIPFR = 'Z'                                              BUG7621
     C                   Eval      RXTIPFR = 'Z'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'STNIPD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0603'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   EndIf                                                               BUG7621
     C                   ENDIF                                                  BUG5964
                                                                                             BUG5449
      * Validate formula                                                                     BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C                   EVAL      SFREQF = SFREQFTP                                         BUG5449
     C                   EVAL      SFORM = SFORMTP                                           BUG5449
     C                   MOVEL     *BLANKS       SFORMNAME                                   BUG5449
     C                   MOVEL     'SFREQFTP'    SFORMNAME                                   BUG5449
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR                           BUG5449
     C                             SFREQF = 'X' OR SFREQF = 'Y'                              BUG5449
     C                   EXSR      ValFormula                                                BUG5449
                                                                                             BUG5449
      * Generate Dates                                                                       BUG5449
     C                   IF        Idx=0 AND SFORM <> *BLANKS                                BUG5449
      *******************                                                             BUG5449BUG5964
     C*******************IF        SACCD = 'I' AND X>1                                BUG5449BUG5964
     C*******************EVAL      WCTLDYN = TPMDATE(1)                               BUG5449BUG5964
     C*******************EVAL      I=1                                                BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************DOW       I<X                                                BUG5449BUG5964
     C*******************IF        TPMDATE(I) < WCTLDYN                               BUG5449BUG5964
     C*******************EVAL      WCTLDYN = TPMDATE(I)                               BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ADD       1             I                                    BUG5449BUG5964
     C*******************ENDDO                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C                   MOVEL     SFORM         FFDATC                                      BUG5449
     C                   MOVEL     WRSCY         FFCCY1                                      BUG5449
     C                   MOVEL     *BLANK        FFCCY2                                      BUG5449
     C                   MOVE      *BLANK        FFCCY3                                      BUG5449
     C                   Z-ADD     *ZERO         PRDT                                        BUG5449
     C                   EVAL      K=X                                                       BUG5449
     C                   MOVEA     TPMDATE       WMDATE                                      BUG5449
     C                   EXSR      GENDATES                                                  BUG5449
     C                   MOVEA     WMDATE        TPMDATE                                     BUG5449
     C                   EVAL      L = 1                                                     BUG5449
     C                   DOW       L < K                                                     BUG5449
                                                                                             BUG5449
      ** Check if it is a saturday or a sunday                                               BUG5449
      ** and treat it as holiday                                                             BUG5449
                                                                                             BUG5449
     C                   EVAL      WRK153 = TPMDATE(L)/7                                     BUG5449
     C                   MOVE      WRK153        WRK30                                       BUG5449
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                            BUG5449
     C                   EVAL      %SUBST(TPDATEA(L):7:1)='Y'                                BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      ZDAYNO =  TPMDATE(L)                                      BUG5449
     C                   CALLB     'ZDATE2'                                                  BUG5449
     C                   PARM                    ZDAYNO                                      BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM      *ZEROS        ZDATE                                       BUG5449
     C                   PARM      *BLANKS       ZADATE            7                         BUG5449
                                                                                             BUG5449
     C                   MOVEL     ZDATE         TPDATEA(L)                                  BUG5449
     C                   ADD       1             L                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
      ** Our cash flow                                                                       BUG5449
     C     SUIPFR        IFEQ      'C'                                                       BUG5449
     C     OCFSA(1)      ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'C'                                            BUG5449
     C                   EVAL      POurTheir= 'U'                                            BUG5449
     C                   MOVEL     *BLANKS       SDATENAME                                   BUG5449
     C                   MOVEL     'SDATEOC'     SDATENAME                                   BUG5449
     C                   MOVEL     *BLANKS       SCHEDNAME                                   BUG5449
     C                   MOVEL     OurCash       SCHEDNAME                                   BUG5449
     C                   EXSR      CheckCurr                                                 BUG5449
     C                   EVAL      X=%LOOKUP('        ':OCFSA)                               BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   EXSR      SRGetCtlDate                                              BUG5449
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
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      CASHFSCH=OCFSA(I)                                         BUG5449
     C                   EVAL      InDate = CFDATE                                           BUG5449
     C                   EVAL      CHol = CFCHOL                                             BUG5449
     C                   EVAL      WAmount=*BLANKS                                           BUG5449
     C                   EVAL      WAmount=CFAMT                                             BUG5449
      *                                                                                       245692
     C     WAmount       IFEQ      *BLANKS                                                    245692
     C     FORMULAOC     ANDNE     *BLANKS                                                    245692
     C                   EVAL      WAmount=SFORMAMTOC                                         245692
     C                   ENDIF                                                                245692
      *                                                                                       245692
     C                   EVAL      PDAT = CFPDAT                                             BUG5449
     C                   MOVEL     CFDATE        MSGDATE                                     BUG5449
     C                   EXSR      SRZEDIT                                                   BUG5449
     C                   EXSR      CheckDate                                                 BUG5449
                                                                                             BUG5449
     C     INDATEMDN     LOOKUP    OCFMDAT                                24                 BUG5449
     C                   IF        *IN24 = *ON                                               BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      OCFMDAT(I)=INDATEMDN                                      BUG5449
     C                   EXSR      ConfHol                                                   BUG5449
     C                   MOVEL     *BLANKS       SFORMAMT         10                         BUG5449
     C                   MOVEL     'SAMT'        SFORMAMT                                    BUG5449
     C                   EXSR      CheckAmt                                                  BUG5449
     C                   MOVE      PZFIELD       OCFAMT(I)                                   BUG5449
     C                   IF        WZFIELD <> *BLANKS                                        BUG5610
     C                   MOVE      WZFIELD       WAMT14           14                         BUG5610
     C                   EVAL      %SUBST(OCFSA(I):8:14)=WAMT14                              BUG5610
     C                   ENDIF                                                               BUG5610
                                                                                             BUG5610
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
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
     C                   EVAL      RXUNIPD=ZDAYNO                               BUG5964
     C                   If        SUIPFR = *Blanks                                          BUG7621
     C                   Eval      SUIPFR = 'C'                                              BUG7621
     C                   Eval      RXUIPFR = 'C'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'SUNIPD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0601'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   EndIf                                                               BUG7621
     C                   ENDIF                                                  BUG5964
                                                                                             BUG5449
      * Validate formula                                                                     BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C                   EVAL      SFREQF = SFREQFOC                                         BUG5449
     C                   EVAL      SFORM = SFORMOC                                           BUG5449
     C                   MOVEL     *BLANKS       SFORMNAME                                   BUG5449
     C                   MOVEL     'SFREQFOC'    SFORMNAME                                   BUG5449
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR                           BUG5449
     C                             SFREQF = 'X' OR SFREQF = 'Y'                              BUG5449
     C                   EXSR      ValFormula                                                BUG5449
                                                                                             BUG5449
      * Generate Dates                                                                       BUG5449
     C                   IF        Idx=0 AND SFORM <> *BLANKS                                BUG5449
      * Amount must be specified                                                             BUG5449
     C                   IF        SFORMAMTOC <> *BLANKS                                     BUG5449
     C                   EVAL      WAmount=*BLANKS                                           BUG5449
     C                   EVAL      WAmount=SFORMAMTOC                                        BUG5449
     C                   MOVEL     *BLANKS       SFORMAMT                                    BUG5449
     C                   MOVEL     'SFORMAMTOC'  SFORMAMT                                    BUG5449
     C                   EXSR      CheckAmt                                                  BUG5449
     C                   IF        WZFIELD <> *BLANKS                                        BUG5610
     C                   MOVE      WZFIELD       SFORMAMTOC                                  BUG5610
     C                   ENDIF                                                               BUG5610
                                                                                             BUG5610
     C                   ELSE                                                                BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM0148'     MsgIDArr(Idx)                               BUG5449
     C                   EVAL      FldNameArr(Idx) = 'SFORMAMTOC'                            BUG5449
     C                   ENDIF                                                               BUG5449
      *                                                                                      BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C                   IF        X<>1                                                      BUG5449
      *******************                                                             BUG5449BUG5964
     C*******************IF        SACCD = 'I' AND X>1                                BUG5449BUG5964
     C*******************EVAL      WCTLDYN = OCFMDAT(1)                               BUG5449BUG5964
     C*******************EVAL      I=1                                                BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************DOW       I<X                                                BUG5449BUG5964
     C*******************IF        OCFMDAT(I) < WCTLDYN                               BUG5449BUG5964
     C*******************EVAL      WCTLDYN = OCFMDAT(I)                               BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ADD       1             I                                    BUG5449BUG5964
     C*******************ENDDO                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C                   MOVEL     SFORM         FFDATC                                      BUG5449
     C                   MOVEL     WPSCY         FFCCY1                                      BUG5449
     C                   MOVEL     *BLANK        FFCCY2                                      BUG5449
     C                   MOVE      *BLANK        FFCCY3                                      BUG5449
     C                   Z-ADD     *ZERO         PRDT                                        BUG5449
     C                   EVAL      K=X                                                       BUG5449
     C                   MOVEA     OCFMDAT       WMDATE                                      BUG5449
     C                   MOVEA     OCFAMT        WCFAMT                                      BUG5449
     C                   EXSR      GENDATES                                                  BUG5449
     C                   MOVEA     WCFAMT        OCFAMT                                      BUG5449
     C                   MOVEA     WMDATE        OCFMDAT                                     BUG5449
     C                   EVAL      L = 1                                                     BUG5449
     C                   DOW       L < K                                                     BUG5449
                                                                                             BUG5449
      ** Check if it is a saturday or a sunday                                               BUG5449
      ** and treat it as holiday                                                             BUG5449
                                                                                             BUG5449
     C                   EVAL      WRK153 = OCFMDAT(L)/7                                     BUG5449
     C                   MOVE      WRK153        WRK30                                       BUG5449
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                            BUG5449
     C                   EVAL      %SUBST(OCFSA(L):7:1)='Y'                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      ZDAYNO =  OCFMDAT(L)                                      BUG5449
     C                   CALLB     'ZDATE2'                                                  BUG5449
     C                   PARM                    ZDAYNO                                      BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM      *ZEROS        ZDATE                                       BUG5449
     C                   PARM      *BLANKS       ZADATE            7                         BUG5449
                                                                                             BUG5449
     C                   MOVEL     ZDATE         OCFSA(L)                                    BUG5449
     C                   ADD       1             L                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ELSE                                                                BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)                               BUG5449
     C                   EVAL      FldNameArr(Idx) = 'SFREQFOC'                              BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
      ** Their cash flow                                                                     BUG5449
     C     STIPFR        IFEQ      'C'                                                       BUG5449
     C     TCFSA(1)      ORNE      *Blanks                                                   BUG7621
     C                   EVAL      PValType = 'C'                                            BUG5449
     C                   EVAL      POurTheir= 'T'                                            BUG5449
     C                   MOVEL     *BLANKS       SDATENAME                                   BUG5449
     C                   MOVEL     'SDATETC'     SDATENAME                                   BUG5449
     C                   MOVEL     *BLANKS       SCHEDNAME                                   BUG5449
     C                   MOVEL     TheirCash     SCHEDNAME                                   BUG5449
     C                   EXSR      CheckCurr                                                 BUG5449
     C                   EVAL      X=%LOOKUP('        ':TCFSA)                               BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   EXSR      SRGetCtlDate                                              BUG5449
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
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      CASHFSCH=TCFSA(I)                                         BUG5449
     C                   EVAL      InDate = CFDATE                                           BUG5449
     C                   EVAL      CHol = CFCHOL                                             BUG5449
     C                   EVAL      WAmount=*BLANKS                                           BUG5449
     C                   EVAL      WAmount=CFAMT                                             BUG5449
      *                                                                                       245692
     C     WAmount       IFEQ      *BLANKS                                                    245692
     C     FORMULATC     ANDNE     *BLANKS                                                    245692
     C                   EVAL      WAmount=SFORMAMTTC                                         245692
     C                   ENDIF                                                                245692
      *                                                                                       245692
     C                   EVAL      PDAT = CFPDAT                                             BUG5449
     C                   MOVEL     CFDATE        MSGDATE                                     BUG5449
     C                   EXSR      SRZEDIT                                                   BUG5449
     C                   EXSR      CheckDate                                                 BUG5449
                                                                                             BUG5449
     C     INDATEMDN     LOOKUP    TCFMDAT                                24                 BUG5449
     C                   IF        *IN24 = *ON                                               BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      TCFMDAT(I)=INDATEMDN                                      BUG5449
     C                   EXSR      ConfHol                                                   BUG5449
     C                   MOVEL     *BLANKS       SFORMAMT                                    BUG5449
     C                   MOVEL     'SAMT'        SFORMAMT                                    BUG5449
     C                   EXSR      CheckAmt                                                  BUG5449
     C                   MOVE      PZFIELD       TCFAMT(I)                                   BUG5449
     C                   IF        WZFIELD <> *BLANKS                                        BUG5610
     C                   MOVE      WZFIELD       WAMT14                                      BUG5610
     C                   EVAL      %SUBST(TCFSA(I):8:14)=WAMT14                              BUG5610
     C                   ENDIF                                                               BUG5610
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
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
     C                   EVAL      RXTNIPD=ZDAYNO                               BUG5964
     C                   If        STIPFR = *Blanks                                          BUG7621
     C                   Eval      STIPFR = 'C'                                              BUG7621
     C                   Eval      RXTIPFR = 'C'                                             BUG7621
     C                   EndIf                                                               BUG7621
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'STNIPD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0603'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   EndIf                                                               BUG7621
     C                   ENDIF                                                  BUG5964
                                                                                             BUG5449
      * Validate formula                                                                     BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C                   EVAL      SFREQF = SFREQFTC                                         BUG5449
     C                   EVAL      SFORM = SFORMTC                                           BUG5449
     C                   MOVEL     *BLANKS       SFORMNAME                                   BUG5449
     C                   MOVEL     'SFREQFTC'    SFORMNAME                                   BUG5449
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR                           BUG5449
     C                             SFREQF = 'X' OR SFREQF = 'Y'                              BUG5449
     C                   EXSR      ValFormula                                                BUG5449
                                                                                             BUG5449
      * Generate Dates                                                                       BUG5449
     C                   IF        Idx=0 AND SFORM <> *BLANKS                                BUG5449
      * Amount must be specified                                                             BUG5449
     C                   IF        SFORMAMTTC <> *BLANKS                                     BUG5449
     C                   EVAL      WAmount=*BLANKS                                           BUG5449
     C                   EVAL      WAmount=SFORMAMTTC                                        BUG5449
     C                   MOVEL     *BLANKS       SFORMAMT                                    BUG5449
     C                   MOVEL     'SFORMAMTTC'  SFORMAMT                                    BUG5449
     C                   EXSR      CheckAmt                                                  BUG5449
     C                   IF        WZFIELD <> *BLANKS                                        BUG5610
     C                   MOVE      WZFIELD       SFORMAMTTC                                  BUG5610
     C                   ENDIF                                                               BUG5610
                                                                                             BUG5610
     C                   ELSE                                                                BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM0148'     MsgIDArr(Idx)                               BUG5449
     C                   EVAL      FldNameArr(Idx) = 'SFORMAMTTC'                            BUG5449
     C                   ENDIF                                                               BUG5449
      *                                                                                      BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C                   IF        X<>1                                                      BUG5449
      *******************                                                             BUG5449BUG5964
     C*******************IF        SACCD = 'I' AND X>1                                BUG5449BUG5964
     C*******************EVAL      WCTLDYN = TCFMDAT(1)                               BUG5449BUG5964
     C*******************EVAL      I=1                                                BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************DOW       I<X                                                BUG5449BUG5964
     C*******************IF        TCFMDAT(I) < WCTLDYN                               BUG5449BUG5964
     C*******************EVAL      WCTLDYN = TCFMDAT(I)                               BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ADD       1             I                                    BUG5449BUG5964
     C*******************ENDDO                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C                   MOVEL     SFORM         FFDATC                                      BUG5449
     C                   MOVEL     WRSCY         FFCCY1                                      BUG5449
     C                   MOVEL     *BLANK        FFCCY2                                      BUG5449
     C                   MOVE      *BLANK        FFCCY3                                      BUG5449
     C                   Z-ADD     *ZERO         PRDT                                        BUG5449
     C                   EVAL      K=X                                                       BUG5449
     C                   MOVEA     TCFMDAT       WMDATE                                      BUG5449
     C                   MOVEA     TCFAMT        WCFAMT                                      BUG5449
     C                   EXSR      GENDATES                                                  BUG5449
     C                   MOVEA     WCFAMT        TCFAMT                                      BUG5449
     C                   MOVEA     WMDATE        TCFMDAT                                     BUG5449
     C                   EVAL      L = 1                                                     BUG5449
     C                   DOW       L < K                                                     BUG5449
                                                                                             BUG5449
      ** Check if it is a saturday or a sunday                                               BUG5449
      ** and treat it as holiday                                                             BUG5449
                                                                                             BUG5449
     C                   EVAL      WRK153 = TCFMDAT(L)/7                                     BUG5449
     C                   MOVE      WRK153        WRK30                                       BUG5449
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                            BUG5449
     C                   EVAL      %SUBST(TCFSA(L):7:1)='Y'                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      ZDAYNO =  TCFMDAT(L)                                      BUG5449
     C                   CALLB     'ZDATE2'                                                  BUG5449
     C                   PARM                    ZDAYNO                                      BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM      *ZEROS        ZDATE                                       BUG5449
     C                   PARM      *BLANKS       ZADATE            7                         BUG5449
                                                                                             BUG5449
     C                   MOVEL     ZDATE         TCFSA(L)                                    BUG5449
     C                   ADD       1             L                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ELSE                                                                BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)                               BUG5449
     C                   EVAL      FldNameArr(Idx) = 'SFREQFTC'                              BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
      *                                                                                      BUG5449
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **********                                                      *                      BUG5449
      ***ValidateIC2 - Routine to validate Interest Rate Calendars    *                      BUG5449
      **********      and Cash Flows                                  *                      BUG5449
      **********                                                      *                      BUG5449
      *****************************************************************
      **********                                                                             BUG5449
     C*****ValidateIC2   BEGSR                                                               BUG5449
      **********                                                                             BUG5449
      ***Retrieve our/rates IRC records                                                      BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
     C**********         EVAL      PPrevDate = WORPrvDate                                    BUG5449
      **********                                                                             BUG5449
      ***Validate Our Rate Change Dates                                                      BUG5449
      **********                                                                             BUG5449
     C**********         DOW       OurRDTSC(X) <> *BLANK                                     BUG5449
     C**********         CLEAR                   OurRatChgD2                                 BUG5449
     C**********         MOVEA     OurRDTSC(X)   OurRatChgD2                                 BUG5449
      **********                                                                             BUG5449
      ***Invalid if Our Rate Change Frequency indicator not 'Z'                              BUG5449
      **********                                                                             BUG5449
     C**********         IF        ORDatesAlp2 <> *BLANKS                                    BUG5449
     C**********                   AND ORDatesAlp2 <>*ZEROS                                  BUG5449
     C**********                   AND RXUICFR <> 'Z'                                        BUG5449
     C**********         MOVE      'N'           OKInRatCal                                  BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SUICFR'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1246'                                 BUG5449
     C**********         ELSE                                                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXUICFR = 'Z'                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      *ZERO         PCtlDate                                    BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM                    PPrevDate                                   BUG5449
     C**********         PARM      'R'           PValType                                    BUG5449
     C**********         PARM      'U'           POurTheir                                   BUG5449
     C**********         PARM      SUCUCY        PCurrency                                   BUG5449
     C**********         PARM      ORDatesAlp2   DatesToVal                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal1                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal2                                  BUG5449
     C**********         PARM      *BLANK        PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg1      PBDConvtn                                   BUG5449
     C**********         PARM                    OKInRatCal                                  BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
     C**********         PARM                    Idx                                         BUG5449
     C**********         PARM      *BLANK        ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKInRatCal <> 'Y'                                         BUG5449
     C**********         GOTO      ValIRCExit2                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         EVAL      DXFOTRANID = APFOTRANID                                   BUG5449
     C**********         EVAL      DXRATPAY = 'R'                                            BUG5449
     C**********         EVAL      DXOURTHR = 'U'                                            BUG5449
     C**********         EVAL      DXTMESTMP = TimeStamp                                     BUG5449
     C**********         MOVEL     ValidDates    WIntRtC                                     BUG5449
     C**********         MOVEL     PConfHol      WDTSCConfH                                  BUG5449
     C**********         WRITE     IRTDTSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Read*next DTSC record                                                               BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***Retrieve our/payment IRC records                                                    BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
     C**********         EVAL      PPrevDate = WOPPrvDate                                    BUG5449
      **********                                                                             BUG5449
      ***Validate Our Interest Payment Dates                                                 BUG5449
      **********                                                                             BUG5449
     C**********         DOW       OurIDTSC(X) <> *BLANK                                     BUG5449
     C**********         CLEAR                   OurIntPayD2                                 BUG5449
     C**********         MOVEA     OurIDTSC(X)   OurIntPayD2                                 BUG5449
      **********                                                                             BUG5449
      ***Invalid if Our Interest Payment Frequency indicator not 'Z'                         BUG5449
      **********                                                                             BUG5449
     C**********         IF        OPDatesAlp2 <> *BLANKS                                    BUG5449
     C**********                   AND OPDatesAlp2 <>*ZEROS                                  BUG5449
     C**********                   AND RXUIPFR <> 'Z'                                        BUG5449
     C**********         MOVE      'N'           OKInRatCal                                  BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SUIPFR'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1246'                                 BUG5449
     C**********         ELSE                                                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXUIPFR = 'Z'                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      *ZERO         PCtlDate                                    BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM                    PPrevDate                                   BUG5449
     C**********         PARM      'I'           PValType                                    BUG5449
     C**********         PARM      'U'           POurTheir                                   BUG5449
     C**********         PARM      SUCUCY        PCurrency                                   BUG5449
     C**********         PARM      OPDatesAlp2   DatesToVal                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal1                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal2                                  BUG5449
     C**********         PARM      *BLANK        PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg1      PBDConvtn                                   BUG5449
     C**********         PARM                    OKInRatCal                                  BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
     C**********         PARM                    Idx                                         BUG5449
     C**********         PARM      *BLANK        ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKInRatCal <> 'Y'                                         BUG5449
     C**********         GOTO      ValIRCExit2                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         EVAL      DXFOTRANID = APFOTRANID                                   BUG5449
     C**********         EVAL      DXRATPAY = 'P'                                            BUG5449
     C**********         EVAL      DXOURTHR = 'U'                                            BUG5449
     C**********         EVAL      DXTMESTMP = TimeStamp                                     BUG5449
     C**********         MOVEL     ValidDates    WIntRtC                                     BUG5449
     C**********         MOVEL     PConfHol      WDTSCConfH                                  BUG5449
     C**********         WRITE     IRTDTSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Read*next DTSC record                                                               BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***Retrieve their/rates IRC records                                                    BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
     C**********         EVAL      PPrevDate = WTRPrvDate                                    BUG5449
      **********                                                                             BUG5449
      ***Validate Their Rate Change Dates                                                    BUG5449
      **********                                                                             BUG5449
     C**********         DOW       ThrRDTSC(X) <> *BLANK                                     BUG5449
     C**********         CLEAR                   ThrRatChgD2                                 BUG5449
     C**********         MOVEA     ThrRDTSC(X)   ThrRatChgD2                                 BUG5449
      **********                                                                             BUG5449
      ***Invalid if Their Rate Change Frequency indicator not 'Z'                            BUG5449
      **********                                                                             BUG5449
     C**********         IF        TRDatesAlp2 <> *BLANKS                                    BUG5449
     C**********                   AND TRDatesAlp2 <> *ZEROS                                 BUG5449
     C**********                   AND RXTICFR <> 'Z'                                        BUG5449
     C**********         MOVE      'N'           OKInRatCal                                  BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'STICFR'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1246'                                 BUG5449
     C**********         ELSE                                                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXTICFR = 'Z'                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      *ZERO         PCtlDate                                    BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM                    PPrevDate                                   BUG5449
     C**********         PARM      'R'           PValType                                    BUG5449
     C**********         PARM      'T'           POurTheir                                   BUG5449
     C**********         PARM      STCUCY        PCurrency                                   BUG5449
     C**********         PARM      TRDatesAlp2   DatesToVal                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal1                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal2                                  BUG5449
     C**********         PARM      *BLANK        PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg2      PBDConvtn                                   BUG5449
     C**********         PARM                    OKInRatCal                                  BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
     C**********         PARM                    Idx                                         BUG5449
     C**********         PARM      *BLANK        ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKInRatCal <> 'Y'                                         BUG5449
     C**********         GOTO      ValIRCExit2                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         EVAL      DXFOTRANID = APFOTRANID                                   BUG5449
     C**********         EVAL      DXRATPAY = 'R'                                            BUG5449
     C**********         EVAL      DXOURTHR = 'T'                                            BUG5449
     C**********         EVAL      DXTMESTMP = TimeStamp                                     BUG5449
     C**********         MOVEL     ValidDates    WIntRtC                                     BUG5449
     C**********         MOVEL     PConfHol      WDTSCConfH                                  BUG5449
     C**********         WRITE     IRTDTSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Read*next DTSC record                                                               BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***Retrieve their/payment IRC records                                                  BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
     C**********         EVAL      PPrevDate = WTPPrvDate                                    BUG5449
      **********                                                                             BUG5449
      ***Validate Their Interest Payment Dates                                               BUG5449
      **********                                                                             BUG5449
     C**********         DOW       ThrIDTSC(X) <> *BLANK                                     BUG5449
     C**********         CLEAR                   ThrIntPayD2                                 BUG5449
     C**********         MOVEA     ThrIDTSC(X)   ThrIntPayD2                                 BUG5449
      **********                                                                             BUG5449
      ***Invalid if Their Payment Change Freq. indicator not 'Z'                             BUG5449
      **********                                                                             BUG5449
     C**********         IF        TPDatesAlp2 <> *BLANKS                                    BUG5449
     C**********                   AND TPDatesAlp2 <> *ZEROS                                 BUG5449
     C**********                   AND RXTIPFR <> 'Z'                                        BUG5449
     C**********         MOVE      'N'           OKInRatCal                                  BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'STIPFR'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1246'                                 BUG5449
     C**********         ELSE                                                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXTIPFR = 'Z'                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      *ZERO         PCtlDate                                    BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM                    PPrevDate                                   BUG5449
     C**********         PARM      'I'           PValType                                    BUG5449
     C**********         PARM      'T'           POurTheir                                   BUG5449
     C**********         PARM      STCUCY        PCurrency                                   BUG5449
     C**********         PARM      TPDatesAlp2   DatesToVal                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal1                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal2                                  BUG5449
     C**********         PARM      *BLANK        PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg2      PBDConvtn                                   BUG5449
     C**********         PARM                    OKInRatCal                                  BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
     C**********         PARM                    Idx                                         BUG5449
     C**********         PARM      *BLANK        ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKInRatCal <> 'Y'                                         BUG5449
     C**********         GOTO      ValIRCExit2                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         EVAL      DXFOTRANID = APFOTRANID                                   BUG5449
     C**********         EVAL      DXRATPAY = 'P'                                            BUG5449
     C**********         EVAL      DXOURTHR = 'T'                                            BUG5449
     C**********         EVAL      DXTMESTMP = TimeStamp                                     BUG5449
     C**********         MOVEL     ValidDates    WIntRtC                                     BUG5449
     C**********         MOVEL     PConfHol      WDTSCConfH                                  BUG5449
     C**********         WRITE     IRTDTSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Read*next DTSC record                                                               BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***Retrieve Our Cash Flow records                                                      BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
     C**********         EVAL      PPrevDate = *ZERO                                         BUG5449
      **********                                                                             BUG5449
      ***Check*if Cash Flow Schedule not entered when Interest Payment Date                  BUG5449
      ***not*blank or vice versa                                                             BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXUIPFR = 'C'                                             BUG5449
     C**********         IF        (OurCFSC(X) <> *BLANK)                                    BUG5449
     C**********         IF        (SUNIPD = *BLANK)                                         BUG5449
     C**********         MOVE      'N'           OKCshFlw                                    BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SDAT01'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1263'                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         IF        (SUNIPD <> *BLANK)                                        BUG5449
     C**********         MOVE      'N'           OKCshFlw                                    BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SDAT01'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1264'                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Validate Our Cash Flow Schedules                                                    BUG5449
      **********                                                                             BUG5449
     C**********         IF        Idx = 0                                                   BUG5449
     C**********         DOW       OurCFSC(X) <> *BLANK                                      BUG5449
     C**********         CLEAR                   WOurCash                                    BUG5449
     C**********         MOVEA     OurCFSC(X)    WOurCash                                    BUG5449
      **********                                                                             BUG5449
      ***Our*Interest Payment Frequency must be 'C'                                          BUG5449
      **********                                                                             BUG5449
     C**********         IF        WOurCshFD <> *BLANKS                                      BUG5449
     C**********                   AND WOurCshFD <> *ZEROS                                   BUG5449
     C**********                   AND RXUIPFR <> 'C'                                        BUG5449
     C**********         MOVE      'N'           OKCshFlw                                    BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SUIPFR'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1247'                                 BUG5449
     C**********         ELSE                                                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXUIPFR = 'C'                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      *ZERO         PCtlDate                                    BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM                    PPrevDate                                   BUG5449
     C**********         PARM      'C'           PValType                                    BUG5449
     C**********         PARM      'U'           POurTheir                                   BUG5449
     C**********         PARM      SUCUCY        PCurrency                                   BUG5449
     C**********         PARM      WOurCshFD     DatesToVal                                  BUG5449
     C**********         PARM      WOurCshFA     PAmtToVal1                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal2                                  BUG5449
     C**********         PARM      *BLANK        PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg1      PBDConvtn                                   BUG5449
     C**********         PARM                    OKCshFlw                                    BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
     C**********         PARM                    Idx                                         BUG5449
     C**********         PARM      *BLANK        ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKCshFlw <> 'Y'                                           BUG5449
     C**********         GOTO      ValIRCExit2                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         EVAL      CXFOTRANID = APFOTRANID                                   BUG5449
     C**********         EVAL      CXOURTHR = 'U'                                            BUG5449
     C**********         EVAL      CXTMESTMP = TimeStamp                                     BUG5449
     C**********         MOVEL     ValidDates    WCashFlwD                                   BUG5449
     C**********         MOVEL     PValidAmnt    WCashFlwA                                   BUG5449
     C**********         MOVEL     PConfHol      WCFSCConfH                                  BUG5449
     C**********         WRITE     IRTCFSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Read*next cash flow schedule record                                                 BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Retrieve Their Cash Flow records                                                    BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
     C**********         EVAL      PPrevDate = *ZERO                                         BUG5449
      **********                                                                             BUG5449
      ***Check*if Cash Flow Schedule not entered when Interest Payment Date                  BUG5449
      ***not*blank or vice versa                                                             BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXTIPFR = 'C'                                             BUG5449
     C**********         IF        (ThrCFSC(X) <> *BLANK)                                    BUG5449
     C**********         IF        (STNIPD = *BLANK)                                         BUG5449
     C**********         MOVE      'N'           OKCshFlw                                    BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SDAT01'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1263'                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         IF        (STNIPD <> *BLANK)                                        BUG5449
     C**********         MOVE      'N'           OKCshFlw                                    BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SDAT01'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1264'                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Validate Their Cash Flow Schedules                                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        Idx = 0                                                   BUG5449
     C**********         DOW       ThrCFSC(X) <> *BLANK                                      BUG5449
     C**********         CLEAR                   WThrCash                                    BUG5449
     C**********         MOVEA     ThrCFSC(X)    WThrCash                                    BUG5449
      **********                                                                             BUG5449
      ***Their*Interest Payment Frequency must be 'C'                                        BUG5449
      **********                                                                             BUG5449
     C**********         IF        WThrCshFD <> *BLANKS                                      BUG5449
     C**********                   AND WThrCshFD <>*ZEROS                                    BUG5449
     C**********                   AND RXTIPFR <>  'C'                                       BUG5449
     C**********         MOVE      'N'           OKCshFlw                                    BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'STIPFR'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1247'                                 BUG5449
     C**********         ELSE                                                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        RXTIPFR = 'C'                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      *ZERO         PCtlDate                                    BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM                    PPrevDate                                   BUG5449
     C**********         PARM      'C'           PValType                                    BUG5449
     C**********         PARM      'T'           POurTheir                                   BUG5449
     C**********         PARM      STCUCY        PCurrency                                   BUG5449
     C**********         PARM      WThrCshFD     DatesToVal                                  BUG5449
     C**********         PARM      WThrCshFA     PAmtToVal1                                  BUG5449
     C**********         PARM                    PAmtToVal2                                  BUG5449
     C**********         PARM      *BLANK        PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg2      PBDConvtn                                   BUG5449
     C**********         PARM                    OKCshFlw                                    BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
     C**********         PARM                    Idx                                         BUG5449
     C**********         PARM      *BLANK        ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKCshFlw <> 'Y'                                           BUG5449
     C**********         GOTO      ValIRCExit2                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         EVAL      CXFOTRANID = APFOTRANID                                   BUG5449
     C**********         EVAL      CXOURTHR = 'T'                                            BUG5449
     C**********         EVAL      CXTMESTMP = TimeStamp                                     BUG5449
     C**********         MOVEL     ValidDates    WCashFlwD                                   BUG5449
     C**********         MOVEL     PValidAmnt    WCashFlwA                                   BUG5449
     C**********         MOVEL     PConfHol      WCFSCConfH                                  BUG5449
     C**********         WRITE     IRTCFSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Read*next cash flow schedule record                                                 BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C*****ValIRCExit2   TAG                                                                 BUG5449
      **********                                                                             BUG5449
     C**********         ENDSR                                                               BUG5449
      **********                                                                             BUG5449
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateIC3 - Routine to validate Principal Change Dates      *
      *                                                               *
      *****************************************************************

     C     ValidateIC3   BEGSR
      **********                                                                             BUG5449
      ***Retrieve Our Principal Change records                                               BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
     C**********         EVAL      PPrevDate = *ZERO                                         BUG5449
      **********                                                                             BUG5449
      ***Check*if Principal Change Schedule not entered when Next Principal Change           BUG5449
      ***Date*not blank or vice versa                                                        BUG5449
      **********                                                                             BUG5449
     C**********         IF        (OurPCSC(X) <> *BLANK)                                    BUG5449
     C**********         IF        (SONPCD = *BLANK)                                         BUG5449
     C**********         MOVE      'N'           OKPrcChg                                    BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SDAT01'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1248'                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         IF        (SONPCD <> *BLANK)                                        BUG5449
     C**********         MOVE      'N'           OKPrcChg                                    BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SDAT01'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1249'                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Validate Our Principal Change Schedule if no error                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        Idx = 0                                                   BUG5449
      **********                                                                             BUG5449
     C**********         DOW       OurPCSC(X) <> *BLANK                                      BUG5449
     C**********         CLEAR                   WOurPrin                                    BUG5449
     C**********         MOVEA     OurPCSC(X)    WOurPrin                                    BUG5449
      **********                                                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      #1UNPC        PCtlDate                                    BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM                    PPrevDate                                   BUG5449
     C**********         PARM      'P'           PValType                                    BUG5449
     C**********         PARM      'U'           POurTheir                                   BUG5449
     C**********         PARM      SUCUCY        PCurrency                                   BUG5449
     C**********         PARM      WOurPrcCD     DatesToVal                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal1                                  BUG5449
     C**********         PARM      WOurPrcCA     PAmtToVal2                                  BUG5449
     C**********         PARM      WOurPrcCI     PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg1      PBDConvtn                                   BUG5449
     C**********         PARM                    OKPrcChg                                    BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
     C**********         PARM                    Idx                                         BUG5449
     C**********         PARM      *BLANK        ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKPrcChg <> 'Y'                                           BUG5449
     C**********         GOTO      ValIRCExit3                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         EVAL      PYFOTRANID = APFOTRANID                                   BUG5449
     C**********         EVAL      PYOURTHR = 'U'                                            BUG5449
     C**********         EVAL      PYTMESTMP = TimeStamp                                     BUG5449
     C**********         MOVEL     ValidDates    WPrinChgD                                   BUG5449
     C**********         MOVEL     PValidCAmt    WPrinChgA                                   BUG5449
     C**********         MOVEL     PValidCAmt    WPrinChgCA                                  BUG5449
     C**********         MOVEL     PConfHol      WPCSCConfH                                  BUG5449
     C**********         MOVEL     PIncDecInd    WPCSCIDInd                                  BUG5449
     C**********         WRITE     IRTPCSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Read*next principal change schedule record                                          BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Retrieve Their Principal Change records                                             BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = 1                                                     BUG5449
     C**********         EVAL      PPrevDate = *ZERO                                         BUG5449
      **********                                                                             BUG5449
      ***Check*if Principal Change Schedule not entered when Next Principal Change           BUG5449
      ***Date*not blank or vice versa                                                        BUG5449
      **********                                                                             BUG5449
     C**********         IF        (ThrPCSC(X) <> *BLANK)                                    BUG5449
     C**********         IF        (STNPCD = *BLANK)                                         BUG5449
     C**********         MOVE      'N'           OKPrcChg                                    BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SDAT01'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1248'                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         IF        (STNPCD <> *BLANK)                                        BUG5449
     C**********         MOVE      'N'           OKPrcChg                                    BUG5449
     C**********         ADD       1             Idx                                         BUG5449
     C**********         EVAL      FldNameArr(Idx) = 'SDAT01'                                BUG5449
     C**********         EVAL      MsgIDArr(Idx) = 'MMA1249'                                 BUG5449
     C**********         ENDIF                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Validate Their Principal Change Schedule if no error                                BUG5449
      **********                                                                             BUG5449
     C**********         IF        Idx = 0                                                   BUG5449
      **********                                                                             BUG5449
     C**********         DOW       ThrPCSC(X) <> *BLANK                                      BUG5449
     C**********         CLEAR                   WThrPrin                                    BUG5449
     C**********         MOVEA     ThrPCSC(X)    WThrPrin                                    BUG5449
      **********                                                                             BUG5449
     C**********         CALLB     'IRVIRCVAL'                                               BUG5449
     C**********         PARM                    ReturnCode                                  BUG5449
     C**********         PARM                    RXVDAT                                      BUG5449
     C**********         PARM                    RXMDAT                                      BUG5449
     C**********         PARM      #1TNPC        PCtlDate                                    BUG5449
     C**********         PARM                    BJDFIN                                      BUG5449
     C**********         PARM      SACCD         PAction                                     BUG5449
     C**********         PARM      SDLNO         PDealNo                                     BUG5449
     C**********         PARM                    PPrevDate                                   BUG5449
     C**********         PARM      'P'           PValType                                    BUG5449
     C**********         PARM      'T'           POurTheir                                   BUG5449
     C**********         PARM      STCUCY        PCurrency                                   BUG5449
     C**********         PARM      WThrPrcCD     DatesToVal                                  BUG5449
     C**********         PARM      *BLANK        PAmtToVal1                                  BUG5449
     C**********         PARM      WThrPrcCA     PAmtToVal2                                  BUG5449
     C**********         PARM      WThrPrcCI     PIncDecInd                                  BUG5449
     C**********         PARM      *BLANK        PConfHol                                    BUG5449
     C**********         PARM      WBDCLeg2      PBDConvtn                                   BUG5449
     C**********         PARM                    OKPrcChg                                    BUG5449
     C**********         PARM                    FldNameArr                                  BUG5449
     C**********         PARM                    MsgIDArr                                    BUG5449
     C**********         PARM                    Idx                                         BUG5449
     C**********         PARM      *BLANK        ValidDates                                  BUG5449
     C**********         PARM      *BLANK        PValidAmnt                                  BUG5449
     C**********         PARM      *BLANK        PValidCAmt                                  BUG5449
      **********                                                                             BUG5449
     C**********         IF        OKPrcChg <> 'Y'                                           BUG5449
     C**********         GOTO      ValIRCExit3                                               BUG5449
     C**********         ELSE                                                                BUG5449
     C**********         EVAL      PYFOTRANID = APFOTRANID                                   BUG5449
     C**********         EVAL      PYOURTHR = 'T'                                            BUG5449
     C**********         EVAL      PYTMESTMP = TimeStamp                                     BUG5449
     C**********         MOVEL     ValidDates    WPrinChgD                                   BUG5449
     C**********         MOVEL     PValidCAmt    WPrinChgA                                   BUG5449
     C**********         MOVEL     PValidCAmt    WPrinChgCA                                  BUG5449
     C**********         MOVEL     PConfHol      WPCSCConfH                                  BUG5449
     C**********         MOVEL     PIncDecInd    WPCSCIDInd                                  BUG5449
     C**********         WRITE     IRTPCSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Read*next principal change schedule record                                          BUG5449
      **********                                                                             BUG5449
     C**********         EVAL      X = X + 1                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C*****ValIRCExit3   TAG                                                                 BUG5449
      ** Our Principle change date                                                           BUG5449
     C     SONPCD        IFNE      *BLANKS                                                   BUG5449
     C     OPCSA(1)      ORNE      *BLANKS                                                   BUG7046
     C                   EVAL      PValType = 'P'                                            BUG5449
     C                   EVAL      POurTheir= 'U'                                            BUG5449
     C                   MOVEL     *BLANKS       SDATENAME                                   BUG5449
     C                   MOVEL     'SDATEOPC'    SDATENAME                                   BUG5449
     C                   MOVEL     *BLANKS       SCHEDNAME                                   BUG5449
     C                   MOVEL     OurPrinChg    SCHEDNAME                                   BUG5449
     C                   EXSR      CheckCurr                                                 BUG5449
     C                   EVAL      X=%LOOKUP('        ':OPCSA)                               BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   EXSR      SRGetCtlDate                                              BUG5449
      * Default with control date                                               BUG5964
     C                   IF        X=1                                          BUG5964
     C                             and SONPCD <> *blanks                                     BUG7046
     C                   EVAL      OPCSA(X)=SONPCD                              BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ELSE                                                   BUG5964
      * Check if all dates are processed                                        BUG5964
     C                   EVAL      A=1                                          BUG5964
     C                   EVAL      B=1                                          BUG5964
     C                   DOW       A<X                                          BUG5964
     C                   IF        %SUBST(OPCSA(A):25:1)='Y' OR                 BUG5964
     C                             %SUBST(OPCSA(A):25:1)='y'                    BUG5964
     C                   ADD       1             B                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             A                              BUG5964
     C                   ENDDO                                                  BUG5964
      * Default with control date                                               BUG5964
     C                   IF        X=B                                          BUG5964
     C                             and SONPCD <> *blanks                                     BUG7046
     C                   EVAL      OPCSA(X)=SONPCD                              BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      PCHGSCH=OPCSA(I)                                          BUG5449
     C                   EVAL      InDate = PCDATE                                           BUG5449
     C                   EVAL      CHol = PCCHOL                                             BUG5449
     C                   EVAL      WAmount=*BLANKS                                           BUG5449
     C                   EVAL      WAmount=PCAMT                                             BUG5449
     C     WAmount       IFEQ      '0'                                                        240134
     C     WAmount       OREQ      *BLANKS                                                    240134
     C                   EVAL      WAmount=SFORMAMOPC                                         240134
     C                   ENDIF                                                                240134
     C                   EVAL      PDAT = PCPDAT                                             BUG5449
                                                                                             BUG5449
     C                   MOVEL     PCDATE        MSGDATE                                     BUG5449
     C                   EXSR      SRZEDIT                                                   BUG5449
     C                   EXSR      CheckDate                                                 BUG5449
                                                                                             BUG5449
     C     INDATEMDN     LOOKUP    OPCMDAT                                24                 BUG5449
     C                   IF        *IN24 = *ON                                               BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      OPCMDAT(I)=INDATEMDN                                      BUG5449
     C                   EXSR      ConfHol                                                   BUG5449
     C                   MOVEL     *BLANKS       SFORMAMT                                    BUG5449
     C                   MOVEL     'SAMT'        SFORMAMT                                    BUG5449
     C                   EXSR      CheckAmt                                                  BUG5449
     C                   MOVE      PZFIELD       OPCAMT(I)                                   BUG5449
     C                   IF        WZFIELD <> *BLANKS                                        BUG5610
     C                   MOVE      WZFIELD       WAMT16           16                         BUG5610
     C                   EVAL      %SUBST(OPCSA(I):8:16)=WAMT16                              BUG5610
     C                   ENDIF                                                               BUG5610
                                                                                             BUG5610
     C                   EXSR      CheckInDeInd                                              BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
                                                                                BUG5964
      * Find first non processed date                                           BUG5964
     C                   IF        Idx=0                                        BUG5964
     C                   EVAL      WCTLDYN = 0                                  BUG5964
     C                   EVAL      I=1                                          BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        %SUBST(OPCSA(I):25:1)<>'Y' AND               BUG5964
     C                             %SUBST(OPCSA(I):25:1)<>'y'                   BUG5964
     C                   EVAL      WCTLDYN = OPCMDAT(I)                         BUG5964
     C                   LEAVE                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
                                                                                BUG5964
     C                   EVAL      I=1                                          BUG5964
                                                                                BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        OPCMDAT(I) < WCTLDYN AND                     BUG5964
     C                             %SUBST(OPCSA(I):25:1)<>'Y' AND               BUG5964
     C                             %SUBST(OPCSA(I):25:1)<>'y'                   BUG5964
     C                   EVAL      WCTLDYN = OPCMDAT(I)                         BUG5964
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
     C                   EVAL      RXUNPCD=ZDAYNO                               BUG5964
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'SONPCD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'RS00055'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                             BUG5449
      * Validate formula                                                                     BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C                   EVAL      SFREQF = SFREQFOPC                                        BUG5449
     C                   EVAL      SFORM = SFORMOPC                                          BUG5449
     C                   MOVEL     *BLANKS       SFORMNAME                                   BUG5449
     C                   MOVEL     'SFREQFOPC'   SFORMNAME                                   BUG5449
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR                           BUG5449
     C                             SFREQF = 'X' OR SFREQF = 'Y'                              BUG5449
     C                   EXSR      ValFormula                                                BUG5449
                                                                                             BUG5449
      * Generate Dates                                                                       BUG5449
     C                   IF        Idx=0 AND SFORM <> *BLANKS                                BUG5449
      * Amount must be specified                                                             BUG5449
     C                   IF        SFORMAMOPC <> *BLANKS                                     BUG5449
     C                   EVAL      WAmount=*BLANKS                                           BUG5449
     C                   EVAL      WAmount=SFORMAMOPC                                        BUG5449
     C                   MOVEL     *BLANKS       SFORMAMT                                    BUG5449
     C                   MOVEL     'SFORMAMOPC'  SFORMAMT                                    BUG5449
     C                   EXSR      CheckAmt                                                  BUG5449
     C                   IF        WZFIELD <> *BLANKS                                        BUG5610
     C                   MOVE      WZFIELD       SFORMAMOPC                                  BUG5610
     C                   ENDIF                                                               BUG5610
                                                                                             BUG5610
     C                   ELSE                                                                BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM0148'     MsgIDArr(Idx)                               BUG5449
     C                   EVAL      FldNameArr(Idx) = 'SFORMAMOPC'                            BUG5449
     C                   ENDIF                                                               BUG5449
      * Increase/decrease flag must be specified                                             BUG5449
     C                   IF        BGN2ST = 'Y'                                              BUG5449
     C                   IF        SFORMIDOPC = *BLANKS                                      BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM1022'     MsgIDArr(Idx)                               BUG5449
     C                   EVAL      FldNameArr(Idx) = 'SFORMIDOPC'                            BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
      *                                                                                      BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C                   IF        X<>1                                                      BUG5449
      *******************                                                             BUG5449BUG5964
     C*******************IF        SACCD = 'I' AND X>1                                BUG5449BUG5964
     C*******************EVAL      WCTLDYN = TPCMDAT(1)                               BUG5449BUG5610
     C*******************EVAL      WCTLDYN = OPCMDAT(1)                               BUG5610BUG5964
     C*******************EVAL      I=1                                                BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************DOW       I<X                                                BUG5449BUG5964
     C*******************IF        TPCMDAT(I) < WCTLDYN                               BUG5449BUG5610
     C*******************IF        OPCMDAT(I) < WCTLDYN                               BUG5449BUG5964
     C*******************EVAL      WCTLDYN = TPCMDAT(I)                               BUG5449BUG5610
     C*******************EVAL      WCTLDYN = OPCMDAT(I)                               BUG5610BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ADD       1             I                                    BUG5449BUG5964
     C*******************ENDDO                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
                                                                                             BUG5449
     C                   MOVEL     SFORM         FFDATC                                      BUG5449
     C                   MOVEL     WPSCY         FFCCY1                                      BUG5449
     C                   MOVEL     *BLANK        FFCCY2                                      BUG5449
     C                   MOVE      *BLANK        FFCCY3                                      BUG5449
     C                   Z-ADD     *ZERO         PRDT                                        BUG5449
     C                   EVAL      K=X                                                       BUG5449
     C                   MOVEA     OPCMDAT       WMDATE                                      BUG5449
     C                   MOVEA     OPCAMT        WPCAMT                                      BUG5449
     C                   EXSR      GENDATES                                                  BUG5449
     C                   MOVEA     WPCAMT        OPCAMT                                      BUG5449
     C                   MOVEA     WMDATE        OPCMDAT                                     BUG5449
     C                   EVAL      L = 1                                                     BUG5449
     C                   DOW       L < K                                                     BUG5449
                                                                                             BUG5449
      ** Check if it is a saturday or a sunday                                               BUG5449
      ** and treat it as holiday                                                             BUG5449
                                                                                             BUG5449
     C                   EVAL      WRK153 = OPCMDAT(L)/7                                     BUG5449
     C                   MOVE      WRK153        WRK30                                       BUG5449
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                            BUG5449
     C                   EVAL      %SUBST(OPCSA(L):7:1)='Y'                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      ZDAYNO =  OPCMDAT(L)                                      BUG5449
     C                   CALLB     'ZDATE2'                                                  BUG5449
     C                   PARM                    ZDAYNO                                      BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM      *ZEROS        ZDATE                                       BUG5449
     C                   PARM      *BLANKS       ZADATE            7                         BUG5449
                                                                                             BUG5449
     C                   MOVEL     ZDATE         OPCSA(L)                                    BUG5449
     C                   ADD       1             L                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ELSE                                                                BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)                               BUG5449
     C                   EVAL      FldNameArr(Idx) = 'SFREQFOPC'                             BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449

      * Their Principle Change Date

     C     STNPCD        IFNE      *BLANKS                                                   BUG5449
     C     TPCSA(1)      ORNE      *blanks                                                   BUG7046
     C                   EVAL      PValType = 'P'                                            BUG5449
     C                   EVAL      POurTheir= 'T'                                            BUG5449
     C                   MOVEL     *BLANKS       SDATENAME                                   BUG5449
     C*******************MOVEL     'SDATEOPC'    SDATENAME                            BUG5449BUG5610
     C                   MOVEL     'SDATETPC'    SDATENAME                                   BUG5610
     C                   MOVEL     *BLANKS       SCHEDNAME                                   BUG5449
     C                   MOVEL     TheirPrinChg  SCHEDNAME                                   BUG5449
     C                   EXSR      CheckCurr                                                 BUG5449
     C                   EVAL      X=%LOOKUP('        ':TPCSA)                               BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   EXSR      SRGetCtlDate                                              BUG5449
      * Default with control date                                               BUG5964
     C                   IF        X=1                                          BUG5964
     C                             and STNPCD <> *blanks                                     BUG7046
     C                   EVAL      TPCSA(X)=STNPCD                              BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ELSE                                                   BUG5964
      * Check if all dates are processed                                        BUG5964
     C                   EVAL      A=1                                          BUG5964
     C                   EVAL      B=1                                          BUG5964
     C                   DOW       A<X                                          BUG5964
     C                   IF        %SUBST(TPCSA(A):25:1)='Y' OR                 BUG5964
     C                             %SUBST(TPCSA(A):25:1)='y'                    BUG5964
     C                   ADD       1             B                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             A                              BUG5964
     C                   ENDDO                                                  BUG5964
      * Default with control date                                               BUG5964
     C                   IF        X=B                                          BUG5964
     C                             and STNPCD <> *blanks                                     BUG7046
     C                   EVAL      TPCSA(X)=STNPCD                              BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      PCHGSCH=TPCSA(I)                                          BUG5449
     C                   EVAL      InDate = PCDATE                                           BUG5449
     C                   EVAL      CHol = PCCHOL                                             BUG5449
     C                   EVAL      WAmount=*BLANKS                                           BUG5449
     C                   EVAL      WAmount=PCAMT                                             BUG5449
     C     WAmount       IFEQ      '0'                                                        240134
     C     WAmount       OREQ      *BLANKS                                                    240134
     C                   EVAL      WAmount=SFORMAMTPC                                         240134
     C                   ENDIF                                                                240134
     C                   EVAL      PDAT = PCPDAT                                             BUG5449
     C                   MOVEL     PCDATE        MSGDATE                                     BUG5449
     C                   EXSR      SRZEDIT                                                   BUG5449
                                                                                             BUG5449
     C                   EXSR      CheckDate                                                 BUG5449
                                                                                             BUG5449
     C     INDATEMDN     LOOKUP    TPCMDAT                                24                 BUG5449
     C                   IF        *IN24 = *ON                                               BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      TPCMDAT(I)=INDATEMDN                                      BUG5449
     C                   EXSR      ConfHol                                                   BUG5449
     C                   MOVEL     *BLANKS       SFORMAMT                                    BUG5449
     C                   MOVEL     'SAMT'        SFORMAMT                                    BUG5449
     C                   EXSR      CheckAmt                                                  BUG5449
     C                   MOVE      PZFIELD       TPCAMT(I)                                   BUG5449
     C                   IF        WZFIELD <> *BLANKS                                        BUG5610
     C                   MOVE      WZFIELD       WAMT16                                      BUG5610
     C                   EVAL      %SUBST(TPCSA(I):8:16)=WAMT16                              BUG5610
     C                   ENDIF                                                               BUG5610
                                                                                             BUG5610
     C                   EXSR      CheckInDeInd                                              BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
                                                                                BUG5964
      * Find first non processed date                                           BUG5964
     C                   IF        Idx=0                                        BUG5964
     C                   EVAL      WCTLDYN = 0                                  BUG5964
     C                   EVAL      I=1                                          BUG5964
     C                   DOW       I<X                                          BUG5964
     C                   IF        %SUBST(TPCSA(I):25:1)<>'Y' AND               BUG5964
     C                             %SUBST(TPCSA(I):25:1)<>'y'                   BUG5964
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
     C                             %SUBST(TPCSA(I):25:1)<>'Y' AND               BUG5964
     C                             %SUBST(TPCSA(I):25:1)<>'y'                   BUG5964
     C                   EVAL      WCTLDYN = TPCMDAT(I)                         BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ADD       1             I                              BUG5964
     C                   ENDDO                                                  BUG5964
      *                                                                                       264029
      ** xNPCD cannot be cleared bec principal change schedule exists.                        264029
      *                                                                                       264029
     C                   If        WCTLDYN <> 0                                               264029
     C                             And STNPCD = *Blanks                                       264029
     C                   Add       1             Idx                                          264029
     C                   Eval      FldNameArr(Idx) = 'STNPCD    '                             264029
     C                   Eval      MsgIdArr(Idx) = 'RS00077'                                  264029
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
     C                   IF        CZDATE <> STNPCD                             BUG5964
     C                   MOVEL     ZDATE         STNPCD                         BUG5964
     C                   EVAL      RXTNPCD=ZDAYNO                               BUG5964
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = 'STNPCD'                  BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'RS00055'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                             BUG5449
      * Validate formula                                                                     BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C*******************EVAL      SFREQF = SFREQFOPC                                 BUG5449BUG5610
     C                   EVAL      SFREQF = SFREQFTPC                                        BUG5610
     C                   EVAL      SFORM = SFORMTPC                                          BUG5449
     C                   MOVEL     *BLANKS       SFORMNAME                                   BUG5449
     C*******************MOVEL     'SFREQFOPC'   SFORMNAME                            BUG5449BUG5610
     C                   MOVEL     'SFREQFTPC'   SFORMNAME                                   BUG5610
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR                           BUG5449
     C                             SFREQF = 'X' OR SFREQF = 'Y'                              BUG5449
     C                   EXSR      ValFormula                                                BUG5449
                                                                                             BUG5449
      * Generate Dates                                                                       BUG5449
     C                   IF        Idx=0 AND SFORM <> *BLANKS                                BUG5449
      * Amount must be specified                                                             BUG5449
     C*******************IF        SFORMAMOPC <> *BLANKS                              BUG5449BUG5610
     C                   IF        SFORMAMTPC <> *BLANKS                                     BUG5610
     C                   EVAL      WAmount=*BLANKS                                           BUG5449
     C*******************EVAL      WAmount=SFORMAMOPC                                 BUG5449BUG5610
     C                   EVAL      WAmount=SFORMAMTPC                                        BUG5610
     C                   MOVEL     *BLANKS       SFORMAMT                                    BUG5449
     C*******************MOVEL     'SFORMAMOPC'  SFORMAMT                             BUG5449BUG5610
     C                   MOVEL     'SFORMAMTPC'  SFORMAMT                                    BUG5610
     C                   EXSR      CheckAmt                                                  BUG5449
     C                   IF        WZFIELD <> *BLANKS                                        BUG5610
     C                   MOVE      WZFIELD       SFORMAMTPC                                  BUG5610
     C                   ENDIF                                                               BUG5610
                                                                                             BUG5610
     C                   ELSE                                                                BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM0148'     MsgIDArr(Idx)                               BUG5449
     C*******************EVAL      FldNameArr(Idx) = 'SFORMAMOPC'                     BUG5449BUG5610
     C                   EVAL      FldNameArr(Idx) = 'SFORMAMTPC'                            BUG5610
     C                   ENDIF                                                               BUG5449
      * Increase/decrease flag must be specified                                             BUG5449
     C                   IF        BGN2ST = 'Y'                                              BUG5449
     C*******************IF        SFORMIDOPC = *BLANKS                               BUG5449BUG5610
     C                   IF        SFORMIDTPC = *BLANKS                                      BUG5610
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM1022'     MsgIDArr(Idx)                               BUG5449
     C*******************EVAL      FldNameArr(Idx) = 'SFORMIDOPC'                     BUG5449BUG5610
     C                   EVAL      FldNameArr(Idx) = 'SFORMIDTPC'                            BUG5610
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
      *                                                                                      BUG5449
     C                   IF        Idx=0                                                     BUG5449
     C                   IF        X<>1                                                      BUG5449
      *******************                                                             BUG5449BUG5964
     C*******************IF        SACCD = 'I' AND X>1                                BUG5449BUG5964
     C*******************EVAL      WCTLDYN = TPCMDAT(1)                               BUG5449BUG5964
     C*******************EVAL      I=1                                                BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************DOW       I<X                                                BUG5449BUG5964
     C*******************IF        TPCMDAT(I) < WCTLDYN                               BUG5449BUG5964
     C*******************EVAL      WCTLDYN = TPCMDAT(I)                               BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ADD       1             I                                    BUG5449BUG5964
     C*******************ENDDO                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C                   MOVEL     SFORM         FFDATC                                      BUG5449
     C                   MOVEL     WPSCY         FFCCY1                                      BUG5449
     C                   MOVEL     *BLANK        FFCCY2                                      BUG5449
     C                   MOVE      *BLANK        FFCCY3                                      BUG5449
     C                   Z-ADD     *ZERO         PRDT                                        BUG5449
     C                   EVAL      K=X                                                       BUG5449
     C                   MOVEA     TPCMDAT       WMDATE                                      BUG5449
     C                   MOVEA     TPCAMT        WPCAMT                                      BUG5449
     C                   EXSR      GENDATES                                                  BUG5449
     C                   MOVEA     WPCAMT        TPCAMT                                      BUG5449
     C                   MOVEA     WMDATE        TPCMDAT                                     BUG5449
     C                   EVAL      L = 1                                                     BUG5449
     C                   DOW       L < K                                                     BUG5449
                                                                                             BUG5449
      ** Check if it is a saturday or a sunday                                               BUG5449
      ** and treat it as holiday                                                             BUG5449
                                                                                             BUG5449
     C                   EVAL      WRK153 = TPCMDAT(L)/7                                     BUG5449
     C                   MOVE      WRK153        WRK30                                       BUG5449
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                            BUG5449
     C                   EVAL      %SUBST(TPCSA(L):7:1)='Y'                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   EVAL      ZDAYNO =  TPCMDAT(L)                                      BUG5449
     C                   CALLB     'ZDATE2'                                                  BUG5449
     C                   PARM                    ZDAYNO                                      BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM      *ZEROS        ZDATE                                       BUG5449
     C                   PARM      *BLANKS       ZADATE            7                         BUG5449
                                                                                             BUG5449
     C                   MOVEL     ZDATE         TPCSA(L)                                    BUG5449
     C                   ADD       1             L                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ELSE                                                                BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)                               BUG5449
     C*******************EVAL      FldNameArr(Idx) = 'SFREQFOPC'                      BUG5449BUG5610
     C                   EVAL      FldNameArr(Idx) = 'SFREQFTPC'                             BUG5610
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDSR

      *****************************************************************
      * CheckDate - Routine to validate date schedules                *                      BUG5449
      *****************************************************************                      BUG5449
     C     CheckDate     BEGSR                                                               BUG5449
     C                   EVAL      WHoliday = ' '                                            BUG5449
      ** Convert date from DDMMYY to Midas day number and check                              BUG5449
      ** for valid date.                                                                     BUG5449
     C                   CALLB     'ZDATE1'                                                  BUG5449
     C                   PARM                    InDate                                      BUG5449
     C                   PARM                    InDateMDN                                   BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM                    ErrorFlag                                   BUG5449
                                                                                             BUG5449
     C                   IF        ErrorFlag='Y'                                             BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2003'     MsgIDArr(Idx)                               BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
      * If date is not processed, validate                                                   BUG5449
     C                   IF        PDAT <> 'Y' AND PDAT <> 'y'                               BUG5449
     C* Date must be after the value date                                                    BUG5449
                                                                                             BUG5449
     C     InDateMDN     IFLT      RXVDAT                                                    BUG5449
     C     InDateMDN     OREQ      RXVDAT                                                    BUG5449
     C     PValType      ANDEQ     'R'                                                       BUG5449
     C     InDateMDN     OREQ      RXVDAT                                                    BUG5449
     C     PValType      ANDEQ     'P'                                                       BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2004'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C* Date must be before the maturity date                                                BUG5449
                                                                                             BUG5449
     C     InDateMDN     IFGT      RXMDAT                                                    BUG5449
     C     InDateMDN     OREQ      RXMDAT                                                    BUG5449
     C     PValType      ANDEQ     'R'                                                       BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2005'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
      *****************************************************************************   BUG5449BUG5964
      ***Date*cannot*be*less*than*the*control*date*for*principal*******************   BUG5449BUG5964
      ***change********************************************************************   BUG5449BUG5964
      ** Date cannot be less than the last processed date                                    BUG5964
     C     InDateMDN     IFLT      WCTLDYN                                                   BUG5449
     C     WCTLDYN       ANDNE     *ZEROS                                                    BUG5964
     C*****PValType******IFEQ      'P'                                                BUG5449BUG5964
     C*******************ADD       1             Idx                                  BUG5449BUG5964
     C*******************MOVEL     'DLM2006'     MsgIDArr(Idx)                        BUG5449BUG5964
     C*******************ELSE                                                         BUG5449BUG5964
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2007'     MsgIDArr(Idx)                               BUG5449
     C*******************ENDIF                                                        BUG5449BUG5964
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      ** Action code is 'I' and date already existing from file                              BUG5449
                                                                                             BUG5449
     C                   IF         SACCD = 'I'                                              BUG5449
     C                   EVAL       WDTSCFound = 'N'                                         BUG5449
     C                   EVAL       WCFSCFound = 'N'                                         BUG5449
     C                   EVAL       WPCSCFound = 'N'                                         BUG5449
     C                   SELECT                                                              BUG5449
     C                   WHEN      (PValType = 'R') OR (PValType = 'I')                      BUG5449
     C     KIRSDV        CHAIN     DLDTSCD0                                                  BUG5449
     C                   IF        %FOUND                                                    BUG5449
     C                   EVAL      WDTSCFound = 'Y'                                          BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   WHEN      (PValType = 'C')                                          BUG5449
     C     KCFPC         CHAIN     DLCFSCD0                                                  BUG5449
     C                   IF        %FOUND                                                    BUG5449
     C                   EVAL      WCFSCFound = 'Y'                                          BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   WHEN      (PValType = 'P')                                          BUG5449
     C     KCFPC         CHAIN     DLPCSCD0                                                  BUG5449
     C                   IF        %FOUND                                                    BUG5449
     C                   EVAL      WPCSCFound = 'Y'                                          BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDSL                                                               BUG5449
                                                                                             BUG5449
     C                   IF        (WDTSCFound = 'Y') OR (WCFSCFound = 'Y') OR               BUG5449
     C                             (WPCSCFound = 'Y')                                        BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   EVAL      PBDCCcyArr = PBDCCcy                                      BUG5449
     C                   EVAL      WHoliday = 'N'                                            BUG5449
                                                                                             BUG5449
      ** Check if date is a holiday                                                          BUG5449
                                                                                             BUG5449
                                                                                             BUG5449
     C                   IF        WVALBDC = 'N' OR                                          BUG5449
     C                             WVALBDC = 'Y' AND  PBDCCcyArr(1) = *BLANK                 BUG5449
     C                   Z-ADD     InDateMDN     PZDateIn                                    BUG5449
     C                   CALLB     'ZCHKH'                                                   BUG5449
     C                   PARM                    PZDateIn          5 0                       BUG5449
     C                   PARM      SUCUCY        PZCcy             3                         BUG5449
     C                   PARM      *BLANK        PZLoc             3                         BUG5449
     C                   PARM      *BLANK        PZHol             1                         BUG5449
                                                                                             BUG5449
      ** Set a flag to be use in updating 'Confirmed Holiday' indicator                      BUG5449
      ** when the date is a holiday                                                          BUG5449
                                                                                             BUG5449
     C                   IF        PZHol = 'H'                                               BUG5449
     C                   EVAL      WHoliday = 'Y'                                            BUG5449
     C                   ELSE                                                                BUG5449
                                                                                             BUG5449
      ** Else, if not a holiday, check if it is a saturday or a sunday                       BUG5449
      ** and treat it as holiday                                                             BUG5449
                                                                                             BUG5449
     C                   EVAL      WRK153 = InDateMDN/7                                      BUG5449
     C                   MOVE      WRK153        WRK30                                       BUG5449
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                            BUG5449
     C                   EVAL      WHoliday = 'Y'                                            BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ELSE                                                                BUG5449
                                                                                             BUG5449
      ** Check date if holiday using business day convention currencies when                 BUG5449
      ** CIR005 is on (for interest dates only)                                              BUG5449
                                                                                             BUG5449
     C                   IF        (PValType = 'I') OR (PValType = 'R')                      BUG5449
     C     1             DO        10            Y                 2 0                       BUG5449
     C                   EVAL      PZCcy = PBDCCcyArr(Y)                                     BUG5449
     C                   IF        PZCcy <> *BLANK                                           BUG5449
     C                   Z-ADD     InDateMDN     PZDateIn                                    BUG5449
     C                   CALLB     'ZCHKH'                                                   BUG5449
     C                   PARM                    PZDateIn                                    BUG5449
     C                   PARM                    PZCcy                                       BUG5449
     C                   PARM      *BLANK        PZLoc                                       BUG5449
     C                   PARM      *BLANK        PZHol                                       BUG5449
     C                   IF        PZHol = 'H'                                               BUG5449
     C                   EVAL      WHoliday = 'Y'                                            BUG5449
     C                   LEAVE                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   IF        WHoliday <> 'Y'                                           BUG5449
     C                   Z-ADD     InDateMDN     PZDateIn                                    BUG5449
     C                   CALLB     'ZCHKH'                                                   BUG5449
     C                   PARM                    PZDateIn                                    BUG5449
     C                   PARM      SUCUCY        PZCcy                                       BUG5449
     C                   PARM      *BLANK        PZLoc                                       BUG5449
     C                   PARM      *BLANK        PZHol                                       BUG5449
                                                                                             BUG5449
     C                   IF        PZHol = 'H'                                               BUG5449
     C                   EVAL      WHoliday = 'Y'                                            BUG5449
     C                   ELSE                                                                BUG5449
                                                                                             BUG5449
      ** Else, if not a holiday, check if it is a saturday or a sunday                       BUG5449
      ** and treat it as holiday                                                             BUG5449
                                                                                             BUG5449
     C                   EVAL      WRK153 = InDateMDN/7                                      BUG5449
     C                   MOVE      WRK153        WRK30                                       BUG5449
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)                            BUG5449
     C                   EVAL      WHoliday = 'Y'                                            BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT                                                                                 BUG5449
      ********************************************************************                   BUG5449
      *                                                                  *                   BUG5449
      * SRGetCtlDate - Get Control Date                                  *                   BUG5449
      *                                                                  *                   BUG5449
      ********************************************************************                   BUG5449
                                                                                             BUG5449
     C     SRGetCtlDate  BEGSR                                                               BUG5449
                                                                                             BUG5449
     ****Get*control*date*-*the*first*non-processed*date*****************             BUG5449BUG5964
      ** Get control date - the last processed date                             BUG5964
                                                                                             BUG5449
     C                   EVAL      PRDT = *ZERO                                              BUG5449
     C                   EVAL      WCTLDYN = *ZERO                                           BUG5449
                                                                                             BUG5449
      * Principle Change                                                                     BUG5449
     C                   IF        PValType = 'P'                                            BUG5449
     C     KIRSDL        SETLL     DLPCSCD0                                                  BUG5449
     C     KIRSDP        READE     DLPCSCD0                               30                 BUG5449
                                                                                             BUG5449
     C                   DOW       (*IN30 = *OFF) AND                                        BUG5449
     C                             (WCTLDYN = *ZERO)                                         BUG5449
     C*******************IF        DTPR <> 'Y'                                        BUG5449BUG5964
     C                   IF        DTPR = 'Y' OR DTPR = 'y'                     BUG5964
     C                   Z-ADD     PRDT          WCTLDYN                                     BUG5449
     C                   ENDIF                                                               BUG5449
     C     KIRSDP        READE     DLPCSCD0                               30                 BUG5449
     C                   ENDDO                                                               BUG5449
      *******************                                                             BUG5449BUG5964
      ***If*nothing*was*found, default control date to next principal                 BUG5449BUG5964
      ***change*date*****                                                             BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************IF        (WCTLDYN = *ZERO)                                  BUG5449BUG5964
     C*******************CALLB     'ZDATE1'                                           BUG5449BUG5964
     C*******************PARM      SONPCD        SCDate            6                  BUG5449BUG5964
     C*******************PARM                    MidDate           5 0                BUG5449BUG5964
     C*******************PARM                    BJDFIN                               BUG5449BUG5964
     C*******************PARM                    ErrorFlag                            BUG5449BUG5964
     C*******************EVAL      WCTLDYN = MidDate                                  BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      * Cash Flow                                                                            BUG5449
     C                   IF        PValType = 'C'                                            BUG5449
     C     KIRSDL        SETLL     DLCFSCD0                                                  BUG5449
     C     KIRSDP        READE     DLCFSCD0                               30                 BUG5449
                                                                                             BUG5449
     C                   DOW       (*IN30 = *OFF) AND                                        BUG5449
     C                             (WCTLDYN = *ZERO)                                         BUG5449
     C*******************IF        DTPR <> 'Y'                                        BUG5449BUG5964
     C                   IF        DTPR = 'Y' OR DTPR = 'y'                     BUG5964
     C                   Z-ADD     PRDT          WCTLDYN                                     BUG5449
     C                   ENDIF                                                               BUG5449
     C     KIRSDP        READE     DLCFSCD0                               30                 BUG5449
     C                   ENDDO                                                               BUG5449
      *******************                                                             BUG5449BUG5964
      ***If*nothing*was*found, default control date                                   BUG5449BUG5964
      *******************                                                             BUG5449BUG5964
     C*******************IF        (WCTLDYN = *ZERO)                                  BUG5449BUG5964
     C*******************IF        POurTheir= 'T'                                     BUG5449BUG5964
     C*******************EVAL      WCTLDYN = RXTNIPD                                  BUG5449BUG5964
     C*******************ELSE                                                         BUG5449BUG5964
     C*******************EVAL      WCTLDYN = RXUNIPD                                  BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      * Date Schedule                                                                        BUG5449
     C                   IF        PValType = 'R' OR PValType = 'I'                          BUG5449
     C     KIRSDM        SETLL     DLDTSCD0                                                  BUG5449
     C     KIRSDN        READE     DLDTSCD0                               30                 BUG5449
                                                                                             BUG5449
     C                   DOW       (*IN30 = *OFF) AND                                        BUG5449
     C                             (WCTLDYN = *ZERO)                                         BUG5449
     C*******************IF        DTPR <> 'Y'                                        BUG5449BUG5964
     C                   IF        DTPR = 'Y' OR DTPR = 'y'                     BUG5964
     C                   Z-ADD     PRDT          WCTLDYN                                     BUG5449
     C                   ENDIF                                                               BUG5449
     C     KIRSDN        READE     DLDTSCD0                               30                 BUG5449
     C                   ENDDO                                                               BUG5449
      *******************                                                             BUG5449BUG5964
      ***If*nothing*was*found, default control date                                          BUG5449
      *******************                                                             BUG5449BUG5964
     C*******************IF        (WCTLDYN = *ZERO)                                  BUG5449BUG5964
     C*******************IF        POurTheir= 'T'                                     BUG5449BUG5964
     C*******************IF        PValType = 'R'                                     BUG5449BUG5964
     C*******************EVAL      WCTLDYN = RXTNICD                                  BUG5449BUG5964
     C*******************ELSE                                                         BUG5449BUG5964
     C*******************EVAL      WCTLDYN = RXTNIPD                                  BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ELSE                                                         BUG5449BUG5964
     C*******************IF        PValType = 'R'                                     BUG5449BUG5964
     C*******************EVAL      WCTLDYN = RXUNICD                                  BUG5449BUG5964
     C*******************ELSE                                                         BUG5449BUG5964
     C*******************EVAL      WCTLDYN = RXUNIPD                                  BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C*******************ENDIF                                                        BUG5449BUG5964
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT                                                                                 BUG5449
      *****************************************************************                      BUG5449
      * CheckAmt - Routine to validate amount in date schedules       *                      BUG5449
      *****************************************************************                      BUG5449
     C     CheckAmt      BEGSR                                                               BUG5449
                                                                                             BUG5449
      ** Check amount if numeric                                                             BUG5449
                                                                                             BUG5449
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
     C**********         MOVE      *BLANKS       WZFIELD                              BUG5610 245692
     C**********         MOVE      WAmount       PZFIELD                              BUG5449 245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      WAmount       @@ALPH                                       245692
     C                   Z-ADD     PZADEC        @@IDP                                        245692
     C                   Z-ADD     PZADIG        @@IINT                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
     C**********         CALLB     'ZALIGN'                                           BUG5449 245692
     C**********         PARM                    PZALIGNOK         1                  BUG5449 245692
     C**********         PARM                    PZFIELD          16                  BUG5449 245692
     C**********         PARM                    PZADEC            1 0                BUG5449 245692
     C**********         PARM                    PZADIG            2 0                BUG5449 245692
     C                   CALLB     'ZA0840'                                                   245692
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
                                                                                             BUG5449
      ** Amount not valid                                                                    BUG5449
                                                                                             BUG5449
     C**********         IF        (PZALIGNOK = 'N') OR (PZFIELD = *ALL'0')           BUG5449 245692
     C     @@ERCD        IFNE      0                                                          245692
     C     @@AMT         OREQ      0                                                          245692
     C                   EVAL      Idx = Idx + 1                                             BUG5449
     C                   IF        SFORMAMT = 'SAMT'                                         BUG5449
     C                   MOVEL     'DLM2011'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ELSE                                                                BUG5449
     C                   EVAL      MsgIDArr(Idx) = 'DLM0149'                                 BUG5449
     C                   EVAL      FldNameArr(Idx) = SFORMAMT                                BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ELSE                                                                BUG5610
     C                   MOVE      @@ALPH        WZFIELD          16                          245692
     C                   MOVE      @@AMT         PZFIELD          16                          245692
     C**********         CALLB     'ZEDIT'                                            BUG5610 245692
     C**********         PARM      PZFIELD       WZFIELD          16                  BUG5610 245692
     C**********         PARM                    PZADEC                               BUG5610 245692
     C                   ENDIF                                                               BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT                                                                                 BUG5449
      *****************************************************************                      BUG5449
      * CheckCurr- Routine to access currency details                 *                      BUG5449
      *****************************************************************                      BUG5449
     C     CheckCurr     BEGSR                                                               BUG5449
                                                                                             BUG5449
     C                   If        POurTheir = 'T'                                           BUG6419
     C                   Eval      PCcy = STCUCY                                             BUG6419
     C                   Else                                                                BUG6419
     C                   Eval      PCcy = SUCUCY                                             BUG6419
     C                   EndIf                                                               BUG6419
                                                                                             BUG6419
      ** Access currency details to get the number of decimal places                         BUG5449
     C                   CALL      'AOCURRR0'                                                BUG5449
     C                   PARM      *BLANKS       PRtcd                                       BUG5449
     C                   PARM      '*KEY   '     POptn                                       BUG5449
     C**********         PARM      SUCUCY        PCcy                                BUG5449 BUG6419
     C                   PARM                    PCcy                                        BUG6419
     C     SDCURR        PARM      SDCURR        DSSDY                                       BUG5449
                                                                                             BUG5449
     C                   MOVE      A6NBDP        WONBDP                                      BUG5449
      **********                                                                     BUG5449 BUG6419
      ***Get*decimal places for settlement currencies, if used                       BUG5449 BUG6419
      **********                                                                     BUG5449 BUG6419
     C*****RXPSCY        IFNE      *BLANK                                            BUG5449 BUG6419
     C**********         CALL      'AOCURRR0'                                        BUG5449 BUG6419
     C**********         PARM      *BLANKS       PRtcd                               BUG5449 BUG6419
     C**********         PARM      '*KEY   '     POptn                               BUG5449 BUG6419
     C**********         PARM      RXPSCY        PCcy                                BUG5449 BUG6419
     C*****SDCURR        PARM      SDCURR        DSSDY                               BUG5449 BUG6419
     C**********         MOVE      A6NBDP        WPNBDP                              BUG5449 BUG6419
     C**********         MOVE      RXPSCY        WPSCY                               BUG5449 BUG6419
     C**********         ELSE                                                        BUG5449 BUG6419
     C**********         MOVE      SUCUCY        WPSCY                               BUG5449 BUG6419
     C**********         MOVE      WONBDP        WPNBDP                              BUG5449 BUG6419
     C**********         ENDIF                                                       BUG5449 BUG6419
      **********                                                                     BUG5449 BUG6419
     C*****RXRSCY        IFNE      *BLANK                                            BUG5449 BUG6419
     C**********         CALL      'AOCURRR0'                                        BUG5449 BUG6419
     C**********         PARM      *BLANKS       PRtcd                               BUG5449 BUG6419
     C**********         PARM      '*KEY   '     POptn                               BUG5449 BUG6419
     C**********         PARM      RXRSCY        PCcy                                BUG5449 BUG6419
     C*****SDCURR        PARM      SDCURR        DSSDY                               BUG5449 BUG6419
     C**********         MOVE      A6NBDP        WRNBDP                              BUG5449 BUG6419
     C**********         MOVE      RXRSCY        WRSCY                               BUG5449 BUG6419
     C**********         ELSE                                                        BUG5449 BUG6419
     C**********         MOVE      SUCUCY        WRSCY                               BUG5449 BUG6419
     C**********         MOVE      WONBDP        WRNBDP                              BUG5449 BUG6419
     C**********         ENDIF                                                       BUG5449 BUG6419
      *                                                                                      BUG6419
     C                   Z-ADD     0             PZADEC            1 0                        245692
     C                   Z-ADD     0             PZADIG            2 0                        245692
     C                   EVAL      PZADEC = WONBDP                                           BUG6419
      *                                                                                      BUG5449
     C                   SELECT                                                              BUG5449
     C**********         WHEN      PValType = 'C' AND POurTheir= 'U'                 BUG5449 BUG6419
     C**********         EVAL      PZADEC = WPNBDP                                   BUG5449 BUG6419
     C                   WHEN      PValType = 'C'                                            BUG6419
     C                   EVAL      PZADIG = 13 - PZADEC                                      BUG5449
      *                                                                                      BUG5449
     C**********         WHEN      PValType = 'C' AND POurTheir= 'T'                 BUG5449 BUG6419
     C**********         EVAL      PZADEC = WRNBDP                                   BUG5449 BUG6419
     C**********         EVAL      PZADIG = 13 - PZADEC                              BUG5449 BUG6419
      *                                                                                      BUG5449
     C**********         WHEN      PValType = 'P' AND POurTheir= 'U'                 BUG5449 BUG6419
     C**********         EVAL      PZADEC = WPNBDP                                   BUG5449 BUG6419
     C                   WHEN      PValType = 'P'                                            BUG6419
     C                   EVAL      PZADIG = 15 - PZADEC                                      BUG5449
      *                                                                                      BUG5449
     C**********         WHEN      PValType = 'P' AND POurTheir= 'T'                 BUG5449 BUG6419
     C**********         EVAL      PZADEC = WPNBDP                                   BUG5449 BUG6419
     C**********         EVAL      PZADIG = 15 - PZADEC                              BUG5449 BUG6419
     C                   ENDSL                                                               BUG5449
      *                                                                                      BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT                                                                                 BUG5449
      *****************************************************************                      BUG5449
      * ConfHol - Routine to validate confirm holiday flag            *                      BUG5449
      *****************************************************************                      BUG5449
     C     ConfHol       BEGSR                                                               BUG5449
      *                                                                                      BUG5449
      **  Confirmed holiday ind. must be 'Y' if date is a holiday, else *BLANK               BUG5449
      *                                                                                      BUG5449
     C                   IF        WHoliday='Y' AND CHol<>'Y'                                BUG5449
     C                             OR WHoliday='N' AND CHol='Y'                              BUG5449
     C                   EVAL      Idx = Idx + 1                                             BUG5449
     C                   MOVEL     'DLM2008'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT                                                                                 BUG5449
      *****************************************************************                      BUG5449
      * CheckInDeInd - Routine to validate increase/decrease flag     *                      BUG5449
      *****************************************************************                      BUG5449
     C     CheckInDeInd  BEGSR                                                               BUG5449
     C                   IF        BGN2ST = 'Y'                                              BUG5449
     C                   IF        PCIDFLG = *BLANKS                                         BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2009'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ELSE                                                                BUG5449
     C                   IF        PCIDFLG <> 'D' AND PCIDFLG <> 'I'                         BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM2010'     MsgIDArr(Idx)                               BUG5449
                                                                                             BUG5449
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5449 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT                                                                                 BUG5449
      *****************************************************************                      BUG5449
      * ValFormula - Routine to validate formula                      *                      BUG5449
      *****************************************************************                      BUG5449
     C     ValFormula    BEGSR                                                               BUG5449
      *   Formula must be specified                                                          BUG5449
     C                   IF        SFORM = *BLANKS                                           BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM0153'     MsgIDArr(Idx)                               BUG5449
     C                   EVAL      FldNameArr(Idx) = SFORMNAME                               BUG5449
     C                   ELSE                                                                BUG5449
      *                                                                                      BUG5449
      *   Date must be a formula                                                             BUG5449
     C                   EVAL      *IN99=*OFF                                                BUG5449
      *                                                                                      BUG5449
      **  Validate first two positions                                                       BUG5449
      **    First two positions are mandatory                                                BUG5449
      *                                                                                      BUG5449
     C                   IF        SDN1=*BLANK                                               BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**       Are positions 1&2 numeric  ?                                                  BUG5449
     C*                                                                                      BUG5449
     C                   MOVE      0             WRK3A             3                         BUG5449
     C                   MOVEL     SDN1          WRK3A                                       BUG5449
     C                   TESTN                   WRK3A                24                     BUG5449
     C*                                                                                      BUG5449
     C**       If SDN1   is numeric                                                          BUG5449
     C*                                                                                      BUG5449
     C                   IF        *IN24=*ON                                                 BUG5449
     C                   MOVE      SDN1          WRK2N             2 0                       BUG5449
     C*                                                                                      BUG5449
     C**       Number must be between 1 and 28, or be 31.                                    BUG5449
     C*                                                                                      BUG5449
     C                   IF        WRK2N > 28 AND SDN1 <> '31'                               BUG5449
     C                             OR WRK2N < 1                                              BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**    If not numeric                                                                   BUG5449
     C*                                                                                      BUG5449
     C                   ELSE                                                                BUG5449
     C*                                                                                      BUG5449
     C**   Position 1 to be numeric  1-4 incl                                                BUG5449
     C*                                                                                      BUG5449
     C                   IF        SWRK1 < '1' OR SWRK1 > '4'                                BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**  1ST character valid - check 2ND is in array of day in week codes                   BUG5449
     C*                                                                                      BUG5449
     C     SWRK2         LOOKUP    LETT                                   24                 BUG5449
     C                   IF        *IN24 = *OFF                                              BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**  End of non-numeric validation                                                      BUG5449
     C*                                                                                      BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**  Validate position 3                                                                BUG5449
     C*                                                                                      BUG5449
     C**  If position 1/2 is 31, pos 3 must be blank, or 4,5,6 have entry                    BUG5449
     C**  If position 1 and 2 are not '31' pos.3 must be '+' or '-'                          BUG5449
     C*                                                                                      BUG5449
     C*                                                                                      BUG5449
     C                   IF        SDN1 = '31' AND SWRK3 <> *BLANK                           BUG5449
     C                             AND S456 = *BLANK                                         BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C                   IF        SDN1 <> '31' AND SWRK3 <> '+'                             BUG5449
     C                             AND SWRK3 <> '-'                                          BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C                   IF        SDN1 = '31' AND SWRK3 <> '+'                              BUG5449
     C                             AND SWRK3 <> '-' AND SWRK3 <> ' '                         BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**  Validate positions 4 and 5                                                         BUG5449
     C**    If entered must be numeric, between 1 and 28 inclusive                           BUG5449
     C*                                                                                      BUG5449
     C                   IF        SDN2 <> *BLANK                                            BUG5449
     C*                                                                                      BUG5449
     C                   MOVE      0             WRK3A                                       BUG5449
     C                   MOVEL     SDN2          WRK3A                                       BUG5449
     C                   TESTN                   WRK3A                24                     BUG5449
     C*                                                                                      BUG5449
     C**  Not valid numeric                                                                  BUG5449
     C*                                                                                      BUG5449
     C                   IF        *IN24 = *OFF                                              BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ELSE                                                                BUG5449
     C*                                                                                      BUG5449
     C**  Valid number, check range                                                          BUG5449
     C*                                                                                      BUG5449
     C                   MOVE      SDN2          WRK2N                                       BUG5449
     C                   IF        WRK2N < 1 OR WRK2N > 28                                   BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**  End of numeric validation for pos 4/5                                              BUG5449
     C*                                                                                      BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**  Validate position 6                                                                BUG5449
     C*                                                                                      BUG5449
     C**    If positions 4 and 5 are entered pos.6 must be A,B or C                          BUG5449
     C*                                                                                      BUG5449
     C                   IF        SDN2 <> *BLANK AND SWRK6 <> 'A'                           BUG5449
     C                             AND SWRK6 <> 'B' AND SWRK6 <> 'C'                         BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**  Validate position 7                                                                BUG5449
     C*                                                                                      BUG5449
     C**  If position 6 is 'A' then pos 7 must be '+' or'-'                                  BUG5449
     C**  otherwise it must be blank.                                                        BUG5449
     C*                                                                                      BUG5449
     C                   IF        SWRK6 = 'A'                                               BUG5449
     C                   IF        SWRK7 <> '+' AND SWRK7 <> '-'                             BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C                   ELSE                                                                BUG5449
     C                   IF        SWRK7 <> ' '                                              BUG5449
     C                   EVAL      *IN99=*ON                                                 BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C                   IF        *IN99=*ON                                                 BUG5449
     C                   EVAL      Idx = Idx + 1                                             BUG5449
     C                   EVAL      MsgIDArr(Idx) = 'DLM0154'                                 BUG5449
     C                   EVAL      FldNameArr(Idx) = SFORMNAME                               BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**  Get DD/MM/YY format of date, and month and year                                    BUG5449
     C*                                                                                      BUG5449
     C                   IF        WCTLDYN <> 0 AND Idx=0                                    BUG5449
     C                   EVAL      ZDAYNO = WCTLDYN                                          BUG5449
     C                   EXSR      SRZDATE2                                                  BUG5449
     C                   ELSE                                                                BUG5449
      *   If no start date present, formula cannot be used                                   BUG5449
     C                   Z-ADD     *ZERO         YRNO                                        BUG5449
     C                   Z-ADD     *ZERO         MTHN                                        BUG5449
     C                   ADD       1             Idx                                         BUG5449
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)                               BUG5449
     C                   EVAL      FldNameArr(Idx) = SFORMNAME                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT                                                                                 BUG5449
      *****************************************************************                      BUG5449
      * GENDATES - Routine to generate dates                          *                      BUG5449
      *****************************************************************                      BUG5449
     C     GENDATES      BEGSR                                                               BUG5449
     C*                                                                                      BUG5449
     C**  Calculate next settlement date using SR.FFDATE                                     BUG5449
     C*                                                                                      BUG5449
     C                   DOW       PRDT < CMDYN                                              BUG5449
     C                   Z-ADD     YRNO          FFYR                                        BUG5449
     C                   Z-ADD     MTHN          FFMTH                                       BUG5449
     C                   MOVE      *BLANKS       FFLOC                                       BUG5449
      *                                                                                      BUG5449
      **  Bypass call to FFDATE if Bus. Day Conventions Enhancement on.                      BUG5449
      *                                                                                      BUG5449
     C                   IF        CIR005 = 'Y'                                              BUG5449
     C                   MOVEA     PBDCCcyArr    FFPCCY           30                         BUG5449
     C                   CALL      'DLZIRF'                                                  BUG5449
     C                   PARM                    FFDATC                                      BUG5449
     C                   PARM                    FFMTH                                       BUG5449
     C                   PARM                    FFYR                                        BUG5449
     C                   PARM                    FFPCCY                                      BUG5449
     C                   PARM                    FFLOC                                       BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM                    WADJWD            5 0                       BUG5449
     C                   PARM                    PBSDAY            5 0                       BUG5449
      *                                                                                      BUG5449
     C                   IF        PRDT >= WADJWD                                            BUG5449
     C                   MOVE      PBSDAY        PRDT                                        BUG5449
     C                   ELSE                                                                BUG5449
     C                   MOVE      WADJWD        PRDT                                        BUG5449
     C                   ENDIF                                                               BUG5449
      *                                                                                      BUG5449
     C                   ELSE                                                                BUG5449
     C**********         CALL      'FFDATE'                                          BUG5499  240240
     C                   CALLB     'FFDATE'                                                   240240
      ** Return code (10A, returned to caller)                                               BUG5449
     C                   PARM                    ReturnCode                                  BUG5449
      ** Working day (5,0P)                                                                  BUG5449
     C                   PARM                    FFDAY             5 0                       BUG5449
                                                                                             BUG5449
      ** Parameters received from caller                                                     BUG5449
      ** -------------------------------                                                     BUG5449
      ** Date formula (7A)                                                                   BUG5449
     C                   PARM                    FFDATC            7                         BUG5449
      ** Month of required date (2,0P)                                                       BUG5449
     C                   PARM                    FFMTH             2 0                       BUG5449
      ** Year of required date (2,0P)                                                        BUG5449
     C                   PARM                    FFYR              2 0                       BUG5449
      ** Market currency (3A)                                                                BUG5449
     C                   PARM                    FFCCY1            3                         BUG5449
      ** Market location (3A)                                                                BUG5449
     C                   PARM                    FFLOC             3                         BUG5449
      ** Instrument currency (3A)                                                            BUG5449
     C                   PARM                    FFCCY2            3                         BUG5449
      ** Other currency (3A)                                                                 BUG5449
     C                   PARM                    FFCCY3            3                         BUG5449
      ** Date format indicator (1A, from RUNDAT or SDBANKPD)                                 BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
                                                                                             BUG5449
     C                   MOVE      FFDAY         PRDT                                        BUG5449
     C                   ENDIF                                                               BUG5449
     C                   IF        PRDT < CMDYN AND PRDT >= WCTLDYN                          BUG5449
     C     PRDT          LOOKUP    WMDATE                                 99                 BUG5449
     C                   IF        *IN99 = *OFF                                              BUG5449
     C                   MOVE      PRDT          WMDATE(K)                                   BUG5449
                                                                                             BUG5449
     C                   IF        PValType = 'C'                                            BUG5449
     C                   MOVE      PZFIELD       WCFAMT(K)                                   BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   IF        PValType = 'P'                                            BUG5449
     C                   MOVE      PZFIELD       WPCAMT(K)                                   BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   IF        PValType = 'C' AND POurTheir = 'U'                        BUG5449
     C                   EVAL      %SUBST(OCFSA(K):8:14)=SFORMAMTOC                          BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   IF        PValType = 'C' AND POurTheir = 'T'                        BUG5449
     C                   EVAL      %SUBST(TCFSA(K):8:14)=SFORMAMTTC                          BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C*******************IF        PValType = 'P'                                     BUG5449BUG5610
     C                   IF        PValType = 'P'AND POurTheir = 'U'                         BUG5610
     C                   EVAL      %SUBST(OPCSA(K):8:16)=SFORMAMOPC                          BUG5449
     C                   EVAL      %SUBST(OPCSA(K):24:1)=SFORMIDOPC                          BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5610
     C                   IF        PValType = 'P' AND POurTheir = 'T'                        BUG5610
     C                   EVAL      %SUBST(TPCSA(K):8:16)=SFORMAMTPC                          BUG5610
     C                   EVAL      %SUBST(TPCSA(K):24:1)=SFORMIDTPC                          BUG5610
     C                   ENDIF                                                               BUG5610
                                                                                             BUG5449
     C                   ADD       1             K                                           BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**  Update year/month according to frequency                                           BUG5449
     C*                                                                                      BUG5449
     C                   IF        SFREQF = 'M'                                              BUG5449
     C                   ADD       1             MTHN                                        BUG5449
     C                   ENDIF                                                               BUG5449
     C                   IF        SFREQF = 'Q'                                              BUG5449
     C                   ADD       3             MTHN                                        BUG5449
     C                   ENDIF                                                               BUG5449
     C                   IF        SFREQF = 'X'                                              BUG5449
     C                   ADD       6             MTHN                                        BUG5449
     C                   ENDIF                                                               BUG5449
     C                   IF        SFREQF = 'Y'                                              BUG5449
     C                   ADD       1             MTHN                                        BUG5449
     C                   ENDIF                                                               BUG5449
     C*                                                                                      BUG5449
     C**  If past end of year                                                                BUG5449
     C*                                                                                      BUG5449
     C                   IF        MTHN > 12                                                 BUG5449
     C                   ADD       1             YRNO                                        BUG5449
     C                   SUB       12            MTHN                                        BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT                                                                                 BUG5449
     C****************************************************************                       BUG5449
     C*                                                              *                       BUG5449
     C* CLEARIRCS - Clear Interest Rate Calendar date records        *                       BUG5449
     C*                                                              *                       BUG5449
     C****************************************************************                       BUG5449
     C     CLEARIRCS     BEGSR                                                               BUG5449
      *                                                                                      BUG5449
      ** Clear all dates for this transaction except those already                           BUG5449
      ** processed.                                                                          BUG5449
      *                                                                                      BUG5449
     C     KDTSC         SETLL     DLDTSCD0                                                  BUG5449
     C     KDTSC         READE     DLDTSCD0                               98                 BUG5449
      *                                                                                      BUG5449
     C                   DOW       *IN98=*OFF                                                BUG5449
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                              BUG5449
     C                   DELETE    DLDTSCD0                                                  BUG5449
     C                   ENDIF                                                               BUG5449
     C     KDTSC         READE     DLDTSCD0                               98                 BUG5449
     C                   ENDDO                                                               BUG5449
                                                                                             BUG5449
      ** Clear all dates for this transaction except those already                           BUG5449
      ** processed (Cash Flow)                                                               BUG5449
                                                                                             BUG5449
     C     KDTSC         SETLL     DLCFSCD0                                                  BUG5449
     C     KDTSC         READE     DLCFSCD0                               98                 BUG5449
                                                                                             BUG5449
     C                   DOW       *IN98=*OFF                                                BUG5449
      *                                                                                      BUG5449
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                              BUG5449
     C                   DELETE    DLCFSCD0                                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C     KDTSC         READE     DLCFSCD0                               98                 BUG5449
     C                   ENDDO                                                               BUG5449
                                                                                             BUG5449
      ** Clear all dates for this transaction except those already                           BUG5449
      ** processed (Principal Change)                                                        BUG5449
                                                                                             BUG5449
     C                   IF        CAP041 = 'Y'                                              BUG5449
     C     KDTSC         SETLL     DLPCSCD0                                                  BUG5449
     C     KDTSC         READE     DLPCSCD0                               98                 BUG5449
                                                                                             BUG5449
     C                   DOW       *IN98=*OFF                                                BUG5449
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                              BUG5449
     C                   DELETE    DLPCSCD0                                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C     KDTSC         READE     DLPCSCD0                               98                 BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
      *                                                                                      BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateFE - Routine to validate Fees\Buy-Outs fields        *
      *                                                               *
      *****************************************************************

     C     ValidateFE    BEGSR

     C**********         IF        SACCD = 'I'
     C**********         EXSR      SETUPDEALN
     C**********         ENDIF

      ** Set up details of DS DATA before calling validation.
     C/COPY QWINDSRC,IRCIRSMOV1                                                              BUG5449

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

     C                   IF        CEU003 = 'Y' and #1PSCY <> *BLANKS
     C                   MOVEL     #1PSCY        PWPSCY
     C                   ELSE
     C                   MOVEL     #1UCUC        PWPSCY
     C                   ENDIF

     C                   IF        CEU003 = 'Y' and #1RSCY <> *BLANKS
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
     C                   PARM      *BLANKS       PAccd             4
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

     C                   CALLB     'IRCFBOVAL'

      ** INPUTS
      ** ======

      * Response mode
     C                   PARM      'S'           APRespMode

      ** Transaction Details
     C                   PARM                    NwFBScnFmt

      ** (Midas) Deal Number                                                                BUG11950
     C                   PARM                    SDLNO                                      BUG11950
                                                                                            BUG11950
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
     C                   PARM                    OKFBScnFmt

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

      ** Conversion of file fields to screen format

     C                   RESET                   ReturnCode
     C                   CALLB     'IRCIRSCVT'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
     C                   PARM                    DealXFilFmt
      ** Switchable feature CIR008
     C                   PARM                    CIR008

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
     C                   PARM                    AmendOk
      * Reset of Fields in Error Required (Y/N)
     C*******************PARM      'N'           ResetErrs         1                          CDL038
     C                   PARM      'Y'           ResetErrs         1                          CDL038

     C                   IF        CAP041 = 'Y' and AmIdx = 0
      *
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
      *
     C                   CALLB     'IRCFBOAMD'
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
     C                   PARM                    OKFBScnFmt
      *
      ** OK Amendments field
     C                   PARM                    AmendOK
     C                   PARM                    BNDCSP                                       245692
      *
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

     C                   RESET                   AmendOK

     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKCIRSInDS
     C                   RESET                   OKPayInsDSE
     C                   RESET                   OKRecInsDSE
     C                   RESET                   OKCIRSInDSE
     C                   RESET                   OKCshFlw
     C                   RESET                   OKPrcChg
     C                   MOVE      *ALL'Y'       OKFBScnFmt

     C                   RESET                   PayDat
     C                   RESET                   RecDat

     C                   CLEAR                   ValidDeal
     C                   CLEAR                   ValidXDeal

      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields
     C                   Z-ADD     *ZERO         RXRSTM
     C**********         Z-ADD     *ZERO         RXROBN                                       CSD027
     C**********         Z-ADD     *ZERO         RXROCN                                       CSD027
     C                   EVAL      RXROBN=*BLANKS                                             CSD027
     C                   EVAL      RXROCN=*BLANKS                                             CSD027
     C                   Z-ADD     *ZERO         RXPSTM
     C**********         Z-ADD     *ZERO         RXPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         RXPOCN                                       CSD027
     C                   EVAL      RXPOBN=*BLANKS                                             CSD027
     C                   EVAL      RXPOCN=*BLANKS                                             CSD027

      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt
     C                   CLEAR                   DBPayStmtE
     C                   CLEAR                   DBRecStmtE
     C                   CLEAR                   DBFRAStmtE
     C                   CLEAR                   DBPayStmtV
     C                   CLEAR                   DBRecStmtV
     C                   CLEAR                   DBPayStmtM
     C                   CLEAR                   DBRecStmtM

     C                   CLEAR                   ValIRCData
     C**********         CLEAR                   VldCashFlw                                  BUG5449
     C**********         CLEAR                   VldPrinChg                                  BUG5449

     C                   CLEAR                   DBORatChgD
     C                   CLEAR                   DBOIntPayD
     C                   CLEAR                   DBTRatChgD
     C                   CLEAR                   DBTIntPayD

     C                   IF        CLE025 = 'Y'
     C                   CLEAR                   DealXFilFmt
     C                   ENDIF
     C                   CLEAR                   DATA
     C                   Z-ADD     0             #1DDAT
     C                   Z-ADD     0             #1BAGE
     C                   Z-ADD     0             #1VDAT
     C                   Z-ADD     0             #1MDAT
     C                   Z-ADD     0             #1UPAM
     C                   Z-ADD     0             #1UNPC
     C                   Z-ADD     0             #1UIAC
     C                   Z-ADD     0             #1OUSI
     C                   Z-ADD     0             #1OUSA
     C                   Z-ADD     0             #1TPAM
     C                   Z-ADD     0             #1TNPC
     C                   Z-ADD     0             #1TIAC
     C                   Z-ADD     0             #1TUSI
     C                   Z-ADD     0             #1TUSA
     C                   Z-ADD     0             #1UPFE
     C                   Z-ADD     0             #1BODD
     C                   Z-ADD     0             #1BOVD
     C                   Z-ADD     0             #1BOAM
     C                   Z-ADD     0             #1ORED

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * SUPVALICP - Set up valid Principal Change                        *
      *                                                                  *
      ********************************************************************

     C     SUPVALICP     BEGSR

      ** Interest Rate Calendar

     C*****APFOTRANID    SETLL     IRTDTSCL0                                                 BUG5449
     C*****APFOTRANID    READE     IRTDTSCL0                                                 BUG5449
      **********                                                                             BUG5449
     C**********         DOW       NOT %EOF(IRTDTSCL0)                                       BUG5449
     C**********         EVAL      VALIRCData = TIntRtCDS                                    BUG5449
     C**********         WRITE     IRVDTSCD0                                                 BUG5449
     C*****APFOTRANID    READE     IRTDTSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
     ***********                                                                             BUG5449
      ***Cash*Flow Schedule                                                                  BUG5449
     ***********                                                                             BUG5449
     C*****APFOTRANID    SETLL     IRTCFSCL0                                                 BUG5449
     C*****APFOTRANID    READE     IRTCFSCL0                                                 BUG5449
     ***********                                                                             BUG5449
     C**********         DOW       NOT %EOF(IRTCFSCL0)                                       BUG5449
     C**********         EVAL      VldCashFlw = TCshFlwDS                                    BUG5449
     C**********         WRITE     IRVCFSCD0                                                 BUG5449
     C*****APFOTRANID    READE     IRTCFSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ** Principal Change Schedule                                                           BUG5449
      **********                                                                             BUG5449
     C**********         IF        CAP041 = 'Y'                                              BUG5449
     C*****APFOTRANID    SETLL     IRTPCSCL0                                                 BUG5449
     C*****APFOTRANID    READE     IRTPCSCL0                                                 BUG5449
      **********                                                                             BUG5449
     C**********         DOW       NOT %EOF(IRTPCSCL0)                                       BUG5449
     C**********         EVAL      VldPrinChg =TPrcChgDS                                     BUG5449
     C**********         WRITE     IRVPCSCD0                                                 BUG5449
     C*****APFOTRANID    READE     IRTPCSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   IF        SACCD = 'I' OR SACCD = 'A'                                BUG5610
      ** Our Principle Change                                                                BUG5449
     C     SONPCD        IFNE      *BLANKS                                                   BUG5449
     C     CAP041        ANDEQ     'Y'                                                       BUG5449
     C                   EVAL      OTIN = 'U'                                                BUG5449
     C                   EVAL      POurTheir= 'U'                                            BUG5610
     C                   EVAL      X=%LOOKUP('        ':OPCSA)                               BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      PCHGSCH=OPCSA(I)                                          BUG5449
     C                   EVAL      PRDT = OPCMDAT(I)                                         BUG5449
     C                   EVAL      COHO = PCCHOL                                             BUG5449
     C                   EVAL      DTPR = PCPDAT                                             BUG5449
     C                   EVAL      PAMT = OPCAMT(I)                                          BUG5449
     C                   EVAL      CAMT = 0                                                  BUG5449
     C                   EVAL      PMTP = *BLANK                                             BUG5449
     C                   IF        BGN2ST='Y'                                                BUG5449
     C                   EVAL      WPAMT = PAMT                                              BUG5449
                                                                                             BUG5449
      ** Calculate for the new principal amount                                              BUG5449
                                                                                             BUG5449
     C                   IF        PCIDFLG = 'D'                                             BUG5449
     C                   Z-SUB     WPAMT         WPAMT                                       BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      ** If date entered is on or prior to the control date, add the change amount           BUG5449
      ** to original principal amount                                                        BUG5449
                                                                                             BUG5449
     C                   IF        PRDT <= WCTLDYN                                           BUG5449
     C                   EVAL      PAMT = RXUPAMT + WPAMT                                    BUG5449
     C                   ELSE                                                                BUG5449
                                                                                             BUG5449
      ** If date entered is between existing records, access the previous record             BUG5449
      ** change amount to the principal amount on this record                                BUG5449
                                                                                             BUG5449
     C                   MOVEL     RXDLNO        WDealNo                                     BUG5449
     C*******************EVAL      POurTheir= ' '                                     BUG5449BUG5610
     C     KIRSDL        SETLL     DLPCSCL0                                                  BUG5449
     C                   READP     DLPCSCL0                                                  BUG5449
                                                                                             BUG5449
     C                   IF        NOT %EOF(DLPCSCL0) AND (WDealNo=XXDLNO) AND               BUG5449
     C                             (OTIN = XXOTIN)                                           BUG5449
     C                   EVAL      PAMT = XXPAMT + WPAMT                                     BUG5449
     C                   ELSE                                                                BUG5449
     C                   EVAL      PAMT = RXUPAMT + WPAMT                                    BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   Z-ADD     WPAMT         CAMT                                        BUG5449
     C                   ENDIF                                                               BUG5449
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                              BUG5449
     C                   WRITE     DLPCSCD0                                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      ** Update records with processing dates greater than the processing                    BUG5449
      ** date of the inserted record                                                         BUG5449
                                                                                             BUG5449
     C                   IF        BGN2ST = 'Y'                                              BUG5449
     C                   EXSR      SRUpdPCSC                                                 BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      ** Our Principle Change                                                                BUG5449
     C     STNPCD        IFNE      *BLANKS                                                   BUG5449
     C     CAP041        ANDEQ     'Y'                                                       BUG5449
     C*******************EVAL      OTIN = 'U'                                         BUG5449BUG5610
     C                   EVAL      OTIN = 'T'                                                BUG5610
     C                   EVAL      POurTheir= 'T'                                            BUG5610
     C                   EVAL      X=%LOOKUP('        ':TPCSA)                               BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      PCHGSCH=TPCSA(I)                                          BUG5449
     C                   EVAL      PRDT = TPCMDAT(I)                                         BUG5449
     C                   EVAL      COHO = PCCHOL                                             BUG5449
     C                   EVAL      DTPR = PCPDAT                                             BUG5449
     C                   EVAL      PAMT = TPCAMT(I)                                          BUG5449
     C                   EVAL      CAMT = 0                                                  BUG5449
     C                   EVAL      PMTP = *BLANK                                             BUG5449
     C                   IF        BGN2ST='Y'                                                BUG5449
     C                   EVAL      WPAMT = PAMT                                              BUG5449
                                                                                             BUG5449
      ** Calculate for the new principal amount                                              BUG5449
                                                                                             BUG5449
     C                   IF        PCIDFLG = 'D'                                             BUG5449
     C                   Z-SUB     WPAMT         WPAMT                                       BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      ** If date entered is on or prior to the control date, add the change amount           BUG5449
      ** to original principal amount                                                        BUG5449
                                                                                             BUG5449
     C                   IF        PRDT <= WCTLDYN                                           BUG5449
     C                   EVAL      PAMT = RXTPAMT + WPAMT                                    BUG5449
     C                   ELSE                                                                BUG5449
                                                                                             BUG5449
      ** If date entered is between existing records, access the previous record             BUG5449
      ** change amount to the principal amount on this record                                BUG5449
                                                                                             BUG5449
     C                   MOVEL     RXDLNO        WDealNo                                     BUG5449
     C*******************EVAL      POurTheir= ' '                                     BUG5449BUG5610
     C     KIRSDL        SETLL     DLPCSCL0                                                  BUG5449
     C                   READP     DLPCSCL0                                                  BUG5449
                                                                                             BUG5449
     C                   IF        NOT %EOF(DLPCSCL0) AND (WDealNo=XXDLNO) AND               BUG5449
     C                             (OTIN = XXOTIN)                                           BUG5449
     C                   EVAL      PAMT = XXPAMT + WPAMT                                     BUG5449
     C                   ELSE                                                                BUG5449
     C                   EVAL      PAMT = RXTPAMT + WPAMT                                    BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   Z-ADD     WPAMT         CAMT                                        BUG5449
     C                   ENDIF                                                               BUG5449
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                              BUG5449
     C                   WRITE     DLPCSCD0                                                  BUG5449
     C                   ENDIF                                                               BUG5449
      ** Update records with processing dates greater than the processing                    BUG5449
      ** date of the inserted record                                                         BUG5449
                                                                                             BUG5449
     C                   IF        BGN2ST = 'Y'                                              BUG5449
     C                   EXSR      SRUpdPCSC                                                 BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5610

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SUPVALIRC  - Set up valid Interest Rate Calendar details      *
      *                                                               *
      *****************************************************************

     C     SUPVALIRC     BEGSR

     C                   IF        SACCD = 'A' OR SACCD = 'R'                                BUG5449
     C                   MOVEL     RXDLNO        WDEALNO                                     BUG5449
     C                   EXSR      CLEARIRCS                                                 BUG5449
     C                   ENDIF                                                               BUG5449

      ***Our*Rate Change Dates.                                                              BUG5449
     C*****RXUICFR       IFEQ      'Z'                                                       BUG5449
     C**********         EVAL      ORFOtran   = APFOTranID                                   BUG5449
     C**********         EVAL      ORXTmeStmp = TimeStamp                                    BUG5449
     C**********         MOVE      'U'           ORXOURTHR                                   BUG5449
     C**********         MOVE      'R'           ORXRATPAY                                   BUG5449
     C**********         MOVE      DBORatChgD    ValIRCData                                  BUG5449
     C**********         WRITE     IRVDTSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Our*Interest Payment Dates.                                                         BUG5449
     C*****RXUIPFR       IFEQ      'Z'                                                       BUG5449
     C**********         EVAL      OPFOtran   = APFOTranID                                   BUG5449
     C**********         EVAL      OPXTmeStmp = TimeStamp                                    BUG5449
     C**********         MOVE      'U'           OPXOURTHR                                   BUG5449
     C**********         MOVE      'P'           OPXRATPAY                                   BUG5449
     C**********         MOVE      DBOIntPayD    ValIRCData                                  BUG5449
     C**********         WRITE     IRVDTSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Their Rate Change Dates.                                                            BUG5449
     C*****RXTICFR       IFEQ      'Z'                                                       BUG5449
     C**********         EVAL      TRFOtran   = APFOTranID                                   BUG5449
     C**********         EVAL      TRXTmeStmp = TimeStamp                                    BUG5449
     C**********         MOVE      'T'           TRXOURTHR                                   BUG5449
     C**********         MOVE      'R'           TRXRATPAY                                   BUG5449
     C**********         MOVE      DBTRatChgD    ValIRCData                                  BUG5449
     C**********         WRITE     IRVDTSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
      ***Their*Interest Payment Dates.                                                       BUG5449
     C*****RXTIPFR       IFEQ      'Z'                                                       BUG5449
     C**********         EVAL      TPFOtran   = APFOTranID                                   BUG5449
     C**********         EVAL      TPXTmeStmp = TimeStamp                                    BUG5449
     C**********         MOVE      'T'           TPXOURTHR                                   BUG5449
     C**********         MOVE      'P'           TPXRATPAY                                   BUG5449
     C**********         MOVE      DBTIntPayD    ValIRCData                                  BUG5449
     C**********         WRITE     IRVDTSCD0                                                 BUG5449
     C**********         ENDIF                                                               BUG5449

     C                   IF        SACCD = 'I' OR SACCD = 'A'                                BUG5449
     C                   MOVEL     RXDLNO        DLNO                                        BUG5449
      ** Our Rate Change Dates.                                                              BUG5449
     C     SUICFR        IFEQ      'Z'                                                       BUG5449
     C                   EVAL      OTIN = 'U'                                                BUG5449
     C                   EVAL      RCIP = 'R'                                                BUG5449
     C                   EVAL      X=%LOOKUP('        ':ORDATEA)                             BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      DATESCH=ORDATEA(I)                                        BUG5449
     C                   EVAL      PRDT = ORMDATE(I)                                         BUG5449
     C                   EVAL      COHO = DSCHOL                                             BUG5449
     C                   EVAL      DTPR = DSPDAT                                             BUG5449
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                              BUG5449
     C                   WRITE     DLDTSCD0                                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      ** Our Interest Payment dates                                                          BUG5449
     C     SUIPFR        IFEQ      'Z'                                                       BUG5449
     C                   EVAL      OTIN = 'U'                                                BUG5449
     C                   EVAL      RCIP = 'P'                                                BUG5449
     C                   EVAL      X=%LOOKUP('        ':OPDATEA)                             BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      DATESCH=OPDATEA(I)                                        BUG5449
     C                   EVAL      PRDT = OPMDATE(I)                                         BUG5449
     C                   EVAL      COHO = DSCHOL                                             BUG5449
     C                   EVAL      DTPR = DSPDAT                                             BUG5449
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                              BUG5449
     C                   WRITE     DLDTSCD0                                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      ** Their rate change date Schedule                                                     BUG5449
     C     STICFR        IFEQ      'Z'                                                       BUG5449
     C                   EVAL      OTIN = 'T'                                                BUG5449
     C                   EVAL      RCIP = 'R'                                                BUG5449
     C                   EVAL      X=%LOOKUP('        ':TRDATEA)                             BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      DATESCH=TRDATEA(I)                                        BUG5449
     C                   EVAL      PRDT = TRMDATE(I)                                         BUG5449
     C                   EVAL      COHO = DSCHOL                                             BUG5449
     C                   EVAL      DTPR = DSPDAT                                             BUG5449
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                              BUG5449
     C                   WRITE     DLDTSCD0                                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
      ** Their Interest Payment dates                                                        BUG5449
     C     STIPFR        IFEQ      'Z'                                                       BUG5449
     C                   EVAL      OTIN = 'T'                                                BUG5449
     C                   EVAL      RCIP = 'P'                                                BUG5449
     C                   EVAL      X=%LOOKUP('        ':TPDATEA)                             BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      DATESCH=TPDATEA(I)                                        BUG5449
     C                   EVAL      PRDT = TPMDATE(I)                                         BUG5449
     C                   EVAL      COHO = DSCHOL                                             BUG5449
     C                   EVAL      DTPR = DSPDAT                                             BUG5449
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                              BUG5449
     C                   WRITE     DLDTSCD0                                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
      ** Our cash flow                                                                       BUG5449
     C     SUIPFR        IFEQ      'C'                                                       BUG5449
     C                   EVAL      OTIN = 'U'                                                BUG5449
     C                   EVAL      X=%LOOKUP('        ':OCFSA)                               BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      CASHFSCH=OCFSA(I)                                         BUG5449
     C                   EVAL      PRDT = OCFMDAT(I)                                         BUG5449
     C                   EVAL      COHO = CFCHOL                                             BUG5449
     C                   EVAL      DTPR = CFPDAT                                             BUG5449
     C                   EVAL      CFLA = OCFAMT(I)                                          BUG5449
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                              BUG5449
     C                   WRITE     DLCFSCD0                                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449
      ** Their cash flow                                                                     BUG5449
     C     STIPFR        IFEQ      'C'                                                       BUG5449
     C                   EVAL      OTIN = 'T'                                                BUG5449
     C                   EVAL      X=%LOOKUP('        ':TCFSA)                               BUG5449
     C                   EVAL      I=1                                                       BUG5449
     C                   DOW       I<X                                                       BUG5449
                                                                                             BUG5449
     C                   EVAL      CASHFSCH=TCFSA(I)                                         BUG5449
     C                   EVAL      PRDT = TCFMDAT(I)                                         BUG5449
     C                   EVAL      COHO = CFCHOL                                             BUG5449
     C                   EVAL      DTPR = CFPDAT                                             BUG5449
     C                   EVAL      CFLA = TCFAMT(I)                                          BUG5449
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                              BUG5449
     C                   WRITE     DLCFSCD0                                                  BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ADD       1             I                                           BUG5449
     C                   ENDDO                                                               BUG5449
     C                   ENDIF                                                               BUG5449

     C                   ENDIF                                                               BUG5449
     C                   ENDSR
      *****************************************************************                      BUG5449
      /EJECT                                                                                 BUG5449
      ********************************************************************                   BUG5449
      *                                                                  *                   BUG5449
      * SRUpdPCSC - Change Principal Amount of affected record           *                   BUG5449
      *                                                                  *                   BUG5449
      ********************************************************************                   BUG5449
                                                                                             BUG5449
     C     SRUpdPCSC     BEGSR                                                               BUG5449
                                                                                             BUG5449
     C     KIRSDL        SETGT     DLPCSCL0                                                  BUG5449
     C     KIRSDP        READE     DLPCSCL0                                                  BUG5449
                                                                                             BUG5449
     C                   DOW       NOT %EOF(DLPCSCL0)                                        BUG5449
     C                   EVAL      XXPAMT = XXPAMT + WPAMT                                   BUG5449
     C                   UPDATE    DLPCSCX0                                                  BUG5449
     C     KIRSDP        READE     DLPCSCL0                                                  BUG5449
     C                   ENDDO                                                               BUG5449
                                                                                             BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT                                                                                 BUG5449
      ********************************************************************                   BUG5449
      *                                                                  *                   BUG5449
      * SRZDATE2  - Convert Midas Day Number                             *                   BUG5449
      *                                                                  *                   BUG5449
      ********************************************************************                   BUG5449
                                                                                             BUG5449
     C     SRZDATE2      BEGSR                                                               BUG5449
     C                   CALLB     'ZDATE2'                                                  BUG5449
     C                   PARM                    ZDAYNO                                      BUG5449
     C                   PARM                    BJDFIN                                      BUG5449
     C                   PARM      *ZEROS        ZDATE                                       BUG5449
     C                   PARM      *BLANKS       ZADATE            7                         BUG5449
                                                                                             BUG5449
     C                   MOVEL     ZDATE         DateDS                                      BUG5449
                                                                                             BUG5449
     C     BJDFIN        IFEQ      'M'                                                       BUG5449
     C                   MOVE      DteMth        MTHN              2 0                       BUG5449
     C                   ELSE                                                                BUG5449
     C                   MOVE      DteDay        MTHN                                        BUG5449
     C                   ENDIF                                                               BUG5449
     C                   MOVE      DteYr         YRNO              2 0                       BUG5449
     C                   ENDSR                                                               BUG5449
      ********************************************************************
      /EJECT                                                                                 BUG5449
      ********************************************************************                   BUG5449
      *                                                                  *                   BUG5449
      * SRZEDIT   - Format number                                        *                   BUG5449
      *                                                                  *                   BUG5449
      ********************************************************************                   BUG5449
                                                                                             BUG5449
     C     SRZEDIT       BEGSR                                                               BUG5449
     C                   MOVE      I             ZFIELD                                      BUG5449
                                                                                             BUG5449
     C                   CALLB     'ZEDIT'                                                   BUG5449
     C                   PARM                    ZFIELD           16                         BUG5449
     C                   PARM      0             ZADEC             1 0                       BUG5449
                                                                                             BUG5449
     C                   MOVE      ZFIELD        T                 3                         BUG5449
     C                   ENDSR                                                               BUG5449
      /EJECT
      ********************************************************************
      ***********                                                        *                   BUG5449
      **SRClrWrkTmp - Clears records from work and temporary file        *                   BUG5449
      ***********                                                        *                   BUG5449
      ********************************************************************                   BUG5449
      **********                                                                             BUG5449
     C*****SRClrWrkTmp   BEGSR                                                               BUG5449
      **********                                                                             BUG5449
      ***CIRS*work file                                                                      BUG5449
      **********                                                                             BUG5449
     C*****APFOTRANID    SETLL     IRWCIRSL0                                                 BUG5449
     C*****APFOTRANID    READE     IRWCIRSL0                                                 BUG5449
     C**********         DOW       NOT %EOF                                                  BUG5449
     C**********         DELETE    IRWCIRSD0                                                 BUG5449
     C*****APFOTRANID    READE     IRWCIRSL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***DTSC*work file                                                                      BUG5449
      **********                                                                             BUG5449
     C*****APFOTRANID    SETLL     IRWDTSCL0                                                 BUG5449
     C*****APFOTRANID    READE     IRWDTSCL0                                                 BUG5449
     C**********         DOW       NOT %EOF                                                  BUG5449
     C**********         DELETE    IRWDTSCD0                                                 BUG5449
     C*****APFOTRANID    READE     IRWDTSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***DTSC*temp file                                                                      BUG5449
      **********                                                                             BUG5449
     C*****APFOTRANID    SETLL     IRTDTSCL0                                                 BUG5449
     C*****APFOTRANID    READE     IRTDTSCL0                                                 BUG5449
     C**********         DOW       NOT %EOF                                                  BUG5449
     C**********         DELETE    IRTDTSCD0                                                 BUG5449
     C*****APFOTRANID    READE     IRTDTSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***CFSC*work file                                                                      BUG5449
      **********                                                                             BUG5449
     C*****APFOTRANID    SETLL     IRWCFSCL0                                                 BUG5449
     C*****APFOTRANID    READE     IRWCFSCL0                                                 BUG5449
     C**********         DOW       NOT %EOF                                                  BUG5449
     C**********         DELETE    IRWCFSCD0                                                 BUG5449
     C*****APFOTRANID    READE     IRWCFSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***CFSC*temp file                                                                      BUG5449
      **********                                                                             BUG5449
     C*****APFOTRANID    SETLL     IRTCFSCL0                                                 BUG5449
     C*****APFOTRANID    READE     IRTCFSCL0                                                 BUG5449
     C**********         DOW       NOT %EOF                                                  BUG5449
     C**********         DELETE    IRTCFSCD0                                                 BUG5449
     C*****APFOTRANID    READE     IRTCFSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***PCSC*work file                                                                      BUG5449
      **********                                                                             BUG5449
     C**********         IF        CAP041 = 'Y'                                              BUG5449
     C*****APFOTRANID    SETLL     IRWPCSCL0                                                 BUG5449
     C*****APFOTRANID    READE     IRWPCSCL0                                                 BUG5449
     C**********         DOW       NOT %EOF                                                  BUG5449
     C**********         DELETE    IRWPCSCD0                                                 BUG5449
     C*****APFOTRANID    READE     IRWPCSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
      **********                                                                             BUG5449
      ***CFSC*temp file                                                                      BUG5449
      **********                                                                             BUG5449
     C*****APFOTRANID    SETLL     IRTPCSCL0                                                 BUG5449
     C*****APFOTRANID    READE     IRTPCSCL0                                                 BUG5449
     C**********         DOW       NOT %EOF                                                  BUG5449
     C**********         DELETE    IRTPCSCD0                                                 BUG5449
     C*****APFOTRANID    READE     IRTPCSCL0                                                 BUG5449
     C**********         ENDDO                                                               BUG5449
     C**********         ENDIF                                                               BUG5449
      **********                                                                             BUG5449
     C**********         ENDSR                                                               BUG5449

      *****************************************************************
      /EJECT
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

      ** Set up extension file deal number
     C                   Eval      RDLNO = SDLNO

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

      * For Inserts and Amends, put the Settlement Instructions (input or
      *  defaulted) into the Valid file record.
      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
      *  in contiguous areas, which must be placed into the correct parts
      *  of the Valid file record

     C                   IF        SACCD = 'I'
     C                             OR (SACCD = 'A')
     C                   Eval      RXPSTM = FLPSTM
     C                   Eval      RXPONS = FLPONS
     C                   Eval      %SUBST(CIRSPayIns:15:545)
     C                             = %SUBST(DBPAYSttmt:21:545)
     C                   Eval      RXRSTM = FLRSTM
     C                   Eval      RXRONS = FLRONS
     C                   Eval      %SUBST(CIRSRecIns:15:55)
     C                             = %SUBST(DBRecSttmt:21:55)
     C                   MOVE      FLPOBR        RXPOBR
     C                   MOVE      FLROBR        RXROBR
     C                   MOVE      FLCVMR        RXCVMR
     C                   MOVE      FLPSCY        RXPSCY
     C                   MOVE      FLRSCY        RXRSCY
     C                   MOVE      FLIC72        RXIC72
     C                   MOVEL     DBFraSttmt    CIRSFraIns
     C                   MOVE      FLAGVC        RXAGVC

      ** Ensure numeric fields are zero if not entered.
     C     FLISDA        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        RXISDA
     C                   END

     C     FLAGDT        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        RXAGDT
     C                   END

     C     FLAGVV        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        RXAGVV
     C                   END

     C     FLAGVC        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        RXAGVC
     C                   END

     C                   ENDIF

      ** For Deletes & Authorises, put the complete (pre-existing) deal
      *  into the Valid file record
     C                   IF        SACCD = 'R'
     C                             OR CIR008 = 'Y' AND SACCD = 'X'
     C                   MOVEL     DealFilFmt    ValidDeal
     C                   ENDIF

      * Set Fees/Buy-Outs fields for update to the valids file if CAP041 is installed.
     C                   IF        CAP041 = 'Y'
     C                   EXSR      SRFileFlds
                                                                                              240412
     C                   IF        SACCD = 'R'                                                240412
     C                   Z-ADD     UNPCD         RXUNPCD                                      240412
     C                   Z-ADD     TNPCD         RXTNPCD                                      240412
     C                   ENDIF                                                                240412
                                                                                              240412
     C                   ENDIF

      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      RXCHTP = SACCD

      * Include Header fields that need to be o/p to the Valid file
     C**********         EVAL      RXFRNT = APFOTranID                                        248489
     C**********         EVAL      RXREPA = APRprLocn                                         248489
     C                   IF        SACCD = 'I'                                              MD029596
     C                   EVAL      RXFRNT = APFOTranID                                      MD029596
     C                   ENDIF                                                              MD029596
                                                                                            MD029596
     C                   EVAL      RXTMESTMP = TimeStamp

      ** Setup the Valid file with 'Authomatic Authorisation' from
      ** Interface file IRRXIFPD

     C                   IF        CAP056 = 'Y'
     C                             OR CAP051 = 'Y' and                                       BUG6671
     C                             AUTH = 'Y'                                                BUG6671
     C                   EVAL      RXAUTH = AUTH
     C                   ENDIF

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
     C                   IF        #1UPVD <> RXUPVD OR
     C                             #1UPFE <> RXUPFE OR
     C                             #1UPPR <> RXUPPR
     C                   EVAL      #1CNRQ = 'Y'
     C                   EXSR      SRUpdUpF
     C                   ELSE
     C                   EVAL      #1CNRQ = 'N'
     C                   ENDIF

     C/COPY QWINDSRC,IRCIRSMOV2

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
     C                   MOVE      #1UPVD        UPVD
     C                   MOVE      #1UPFE        UPFE
     C                   MOVE      #1UPPR        UPPR
     C                   WRITE     DLDGREFF
     C                   ELSE
     C                   MOVE      #1UPFE        UPFE
     C                   MOVE      #1UPVD        UPVD
     C                   MOVE      #1UPPR        UPPR
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
      * ValidateEx - Process Extra Settlements                        *
      *                                                               *
      *****************************************************************
     C     ValidateEx    BEGSR

      ** For value date settlements
     C                   IF        SVDEI = 'Y'
     C                             OR  SPDEI = 'Y'
     C                   EVAL      InRecStmtE = InRecStmtV
     C                   EVAL      InPayStmtE = InPayStmtV
     C                   EVAL      PRCcy = SUCUCY
     C                   EVAL      PPCcy = STCUCY
     C                   EVAL      PCalp = 'CXSV'
     C                   EXSR      SrDftExS
     C                   EXSR      SrValExS
     C                   EVAL      InRecStmtV = InRecStmtE
     C                   EVAL      InPayStmtV = InPayStmtE
     C                   EVAL      DBRecStmtV = DBRecStmtE
     C                   EVAL      DBPayStmtV = DBPayStmtE
     C                   ENDIF

      ** For maturity date settlements
     C                   IF        SMDEI = 'Y'
     C                             OR  SPDEI = 'Y'
     C                   EVAL      InRecStmtE = InRecStmtM
     C                   EVAL      InPayStmtE = InPayStmtM
     C                   EVAL      PRCcy = STCUCY
     C                   EVAL      PPCcy = SUCUCY
     C                   EVAL      PCalp = 'CXSM'
     C                   EXSR      SrDftExS
     C                   EXSR      SrValExS
     C                   EVAL      InRecStmtM = InRecStmtE
     C                   EVAL      InPayStmtM = InPayStmtE
     C                   EVAL      DBRecStmtM = DBRecStmtE
     C                   EVAL      DBPayStmtM = DBPayStmtE
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDftExs - Default Extra Settlements                          *
      *                                                               *
      *****************************************************************
     C     SrDftExS      BEGSR

      ** If ANY of the Settlements fields have been entered, bypass this
      **  routine.
      ** Otherwise, use modules which will use Standard Settlement
      **  Instructions to apply defaults.

     C                   IF        InRecStmtE = *blanks
     C                             AND  InPayStmtE = *blanks
     C                             AND  SACCD = 'I'                                          BUG6326

     C                   CALLB     'ZASETINDFT'
      *
      ** Output
      ** Calling function type
     C                   PARM                    CIRS
      ** Payment currency (or deal cuurency if only one currency on deal)
     C                   PARM                    PPCcy             3
      ** Receive currency (only if deal has two currencies)
     C                   PARM                    PRCcy             3
      ** Customer (shortname or number)
     C                   PARM                    SCNum
      ** Deal type
     C                   PARM                    SDTyp
      ** Federal Funds Ind.
     C                   PARM                    SuFFI
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    PISDA             4
      ** Type of ISDA agreement
     C                   PARM                    PAGTY             6
      ** Date of ISDA Agreement
     C                   PARM                    PAGDT             6
      ** Version of ISDA Agreement
     C                   PARM                    PAGVV             2
      ** Version of ISDA Agreement century
     C                   PARM                    PAGVC             2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C********           PARM      *BLANK        BlankSTYP                          CSD095 CSD095CC1
     C                   PARM      SDLST         BlankSTYP                                 CSD095CC1
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C********           PARM      *BLANK        BlankBRCA                          CSD095 CSD095CC1
     C                   PARM      SBRCA         BlankBRCA                                 CSD095CC1

      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPayStmtE
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecStmtE
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRAStmtE

      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.

     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPayStmtE
     C                   PARM                    DBRecStmtE
     C                   PARM                    DBFRAStmtE

      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPayStmtE
     C                   PARM                    InRecStmtE
     C                   PARM                    InFRAStmtE
     C                   PARM      STCUCY        PRCcy                                       CSF011A
     C                   PARM      SUCUCY        PPCcy                                       CSF011A

      ** else, if pay/rec details are manually entered on the screen,                         244254
      ** try to retrieve and default the ISDA details.                                        244254
     C                   ELSE                                                                 244254
     C                   EXSR      DefISDA                                                    244254
                                                                                              244254
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValExs - Validate Extra Settelements                        *
      *                                                               *
      *****************************************************************
     C     SrValExS      BEGSR

     C                   RESET                   ReturnCode
     C                   EVAL       OKPayInsDSE = *ALL'Y'
     C                   EVAL       OKRecInsDSE = *ALL'Y'
     C                   EVAL       OKCirsInDSE = *ALL'Y'
                                                                                             BUG7209
     C                   Eval      BfIdx = Idx                                               BUG7209
     C                   Eval      BfWIdx = WIdx                                             BUG7209

     C                   CALLB     'ZASETINVAL'

      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    PCalp             4
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM                    PPCcy
      ** Receive currency (only if deal has two currencies)
     C                   PARM                    PRCcy
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
     C                   PARM                    InPayStmtE
     C                   PARM                    InRecStmtE
     C                   PARM                    InFRAStmtE

      ** Action Code
     C                   PARM                    SACCD
      * Protect Payment Field
     C                   PARM                    ##PPAY            1
      * Protect Receipt Field
     C                   PARM                    ##PREC            1

      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDSE
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDSE
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKCIRSInDSE
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
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPayStmtE
     C                   PARM                    DBRecStmtE
     C                   PARM                    DBFRAStmtE
     C                   PARM                    SACCD
     C                   PARM                    ValIter           3
                                                                                             BUG7209
      * Setup correct field names if there are any settlement errors                         BUG7209
     C                   If        PCalp = 'CXSV'                                            BUG7209
     C                   Eval      SetPrfx = 'B'                                             BUG7209
     C                   EndIf                                                               BUG7209
     C                   If        PCalp = 'CXSM'                                            BUG7209
     C                   Eval      SetPrfx = 'C'                                             BUG7209
     C                   EndIf                                                               BUG7209
                                                                                             BUG7209
     C                   Eval      AfIdx = Idx                                               BUG7209
     C                   If        AfIdx <> BfIdx                                            BUG7209
     C                   EXSR      SettMsg                                                   BUG7209
     C                   EndIf                                                               BUG7209
      * Warning messages                                                                     BUG7209
     C                   Eval      AfWIdx = WIdx                                             BUG7209
     C                   If        AfWIdx <> BfWIdx                                          BUG7209
     C                   EXSR      SettWrnMsg                                                BUG7209
     C                   EndIf                                                               BUG7209

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValidEx - Set up fields for Extra Settlement Valid File     *
      *             and add record to file                            *
      *                                                               *
      *****************************************************************
     C     SrValidEx     BEGSR

      ** For value date settlement
     C                   IF        SVDEI = 'Y'
     C                             OR  SPDEI = 'Y'
     C**********         MOVEL     DBPayStmtV    ExPSet                                      BUG6326
     C**********         MOVEL     DBRecStmtV    EXRSet                                      BUG6326
     C**********         MOVEL     RXDLNO        EXRXDLNO                                    BUG6326
     C**********         MOVEL     'VAL'         EXRXEDCD                                    BUG6326
     C**********         EVAL      EXRXFRNT = APFOTranID                                     BUG6326
     C**********         EVAL      EXRXTMESTMP = TimeStamp                                   BUG6326
     C                   IF        SACCD = 'I'                                               BUG6418
     C                             OR SACCD = 'A'                                            BUG6418
     C                   MOVEL     DBPayStmtV    ExPValDat                                   BUG6326
     C                   MOVEL     DBRecStmtV    ExRValDat                                   BUG6326
     C                   ENDIF                                                               BUG6418
     C                   MOVEL     RXDLNO        VDRXDLNO                                    BUG6326
     C                   MOVEL     'VAL'         VDRXEDCD                                    BUG6326
     C                   Eval      VDRXFRNT = APFOTranID                                     BUG6326
     C                   Eval      VDRXTMESTMP = TimeStamp                                   BUG6326
     C                   ENDIF

      ** For maturity date settlement
     C                   IF        SMDEI = 'Y'
     C                             OR  SPDEI = 'Y'
     C**********         MOVEL     DBPayStmtM    ExPSet                                      BUG6326
     C**********         MOVEL     DBRecStmtM    EXRSet                                      BUG6326
     C**********         MOVEL     RXDLNO        EXRXDLNO                                    BUG6326
     C**********         MOVEL     'MAT'         EXRXEDCD                                    BUG6326
     C**********         EVAL      EXRXFRNT = APFOTranID                                     BUG6326
     C**********         EVAL      EXRXTMESTMP = TimeStamp                                   BUG6326
     C                   IF        SACCD = 'I'                                               BUG6418
     C                             OR SACCD = 'A'                                            BUG6418
     C                   MOVEL     DBPayStmtM    ExPMatDat                                   BUG6326
     C                   MOVEL     DBRecStmtM    ExRMatDat                                   BUG6326
     C                   ENDIF                                                               BUG6418
     C                   MOVEL     RXDLNO        MDRXDLNO                                    BUG6326
     C                   MOVEL     'MAT'         MDRXEDCD                                    BUG6326
     C                   Eval      MDRXFRNT = APFOTranID                                     BUG6326
     C                   Eval      MDRXTMESTMP = TimeStamp                                   BUG6326
     C                   ENDIF
      ** For value date settlement                                                           BUG6326
     C                   IF        SACCD = 'I'                                               BUG6418
     C                             OR SACCD = 'A'                                            BUG6418
     C                   MOVEL     DBPaySttmt    ExPIntDat                                   BUG6326
     C                   MOVEL     DBRecSttmt    ExRIntDat                                   BUG6326
     C                   MOVEL     DBFRASttmt    ExFIntDat                                   BUG6326
     C                   ENDIF                                                               BUG6418
     C                   MOVEL     RXDLNO        IDRXDLNO                                    BUG6326
     C                   MOVEL     'INT'         IDRXEDCD                                    BUG6326
     C                   Eval      IDRXFRNT = APFOTranID                                     BUG6326
     C                   Eval      IDRXTMESTMP = TimeStamp                                   BUG6326

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAmdCvt - Convert Extra Settlement from File to Screen Format*
      *                                                               *
      *****************************************************************
     C     SrAmdCvt      BEGSR

     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPayStmtE
     C                   PARM                    DBRecStmtE
     C                   PARM                    DBFRAStmtE

      ** Current Settlement Instruction in input format
     C                   PARM                    CrPayStmtE
     C                   PARM                    CrRecStmtE
     C                   PARM                    CrFRAStmtE
     C                   PARM      @STCUCY       InRCCY                                      CSF011A
     C                   PARM      @SUCUCY       InPCCY                                      CSF011A

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SExDtaSubs - Extra Settlement Details Data Substitution       *
      *                                                               *
      *****************************************************************
     C     SExDtaSubs    BEGSR

      ** PAYMENT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InPayStmtE    IncDATA
      * Current Data
     C                   PARM      CrPayStmtE    CurDATA

     C                   MOVEL     IncDATA       InPayStmtE

      ** RECEIPT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InRecStmtE    IncDATA
      * Current Data
     C                   PARM      CrRecStmtE    CurDATA

     C                   MOVEL     IncDATA       InRecStmtE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UpdateDB - Deals Update                                      *
      *                                                               *
      *****************************************************************
     C     UpdateDB      BEGSR

     C                   MOVEL     SACCD         RXCHTP

     C                   CALLB     'IRCIRSUPD'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      *BLANKS       ModeofOp
     C                   PARM                    ValidDeal
     C                   PARM                    ValidXDeal
     C**********         PARM                    ScreenInpt                                BUG5449
     C                   PARM      'Y'           ScreenInpt                                BUG5449
     C                   PARM                    ExtSetV
     C                   PARM                    ExtSetI
     C                   PARM                    ExtSetM
     C                   PARM                    CIR008
     C                   PARM                    CAP056
                                                                                              CSW213
      ** Call DLRPIFVU - Midas DL Reporting Information Validate and Update                   CSW213
                                                                                              CSW213
     C                   IF        CSW213 = 'Y'                                               CSW213
     C                   EXSR      SRCIRSVU                                                   CSW213
     C                   ENDIF                                                                CSW213

      ** If there were any errors in the update function, rollback any
      ** updates and end this program. Otherwise, commit the updates
      *
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*RECUPD'
     C     CSC022        IFEQ      'N'                                                       BUG5449
     C                   ROLBK
     C                   ELSE                                                                BUG5449
     C     WCMT01        IFNE      'Y'                                                       BUG5449
     C                   ROLBK                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   EXSR      *PSSR
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                       BUG5449
     C     WCMT01        OREQ      'N'                                                       BUG5449
     C     CSC022        ANDEQ     'Y'                                                       BUG5449
     C                   COMMIT
     C                   ENDIF                                                               BUG5449
     C                   END
      *
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
     C
     C     PRTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                 BUG7209
      *****************************************************************                      BUG7209
      *                                                               *                      BUG7209
      *  SettMsg  - Setup error message field for settlements         *                      BUG7209
      *                                                               *                      BUG7209
      *****************************************************************                      BUG7209
     C     SettMsg       BEGSR                                                               BUG7209
                                                                                             BUG7209
     C                   Eval      mNo = BfIdx + 1                                           BUG7209
     C     mNo           DOWLE     AfIdx                                                     BUG7209
     C                   Eval      FldNameArr(mNo) = SetPrfx + FldNameArr(mNo)               BUG7209
     C                   Eval      mNo = mNo + 1                                             BUG7209
     C                   ENDDO                                                               BUG7209
                                                                                             BUG7209
     C                   ENDSR                                                               BUG7209
      *****************************************************************                      BUG7209
      /EJECT                                                                                 BUG7209
      *****************************************************************                      BUG7209
      *                                                               *                      BUG7209
      *  SettWrnMsg  - Setup warning message field for settlements    *                      BUG7209
      *                                                               *                      BUG7209
      *****************************************************************                      BUG7209
     C     SettWrnMsg    BEGSR                                                               BUG7209
                                                                                             BUG7209
     C                   Eval      mNo = BfWIdx + 1                                          BUG7209
     C     mNo           DOWLE     AfWIdx                                                    BUG7209
     C                   Eval      WFldNamArr(mNo) = SetPrfx + WFldNamArr(mNo)               BUG7209
     C                   Eval      mNo = mNo + 1                                             BUG7209
     C                   ENDDO                                                               BUG7209
                                                                                             BUG7209
     C                   ENDSR                                                               BUG7209
      *****************************************************************                      BUG7209
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
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW213
      * SRCIRSVU - Call DLRPIFVU - Reporting Information Validate     *                       CSW213
      *            and Update                                         *                       CSW213
      *****************************************************************                       CSW213
     C     SRCIRSVU      BEGSR                                                                CSW213
                                                                                              CSW213
      ** Set-up input fields                                                                  CSW213
                                                                                              CSW213
     C                   IF        SACCD = 'R'                                                CSW213
     C                   EVAL      RLACTN = 'D'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      RLACTN = SACCD                                             CSW213
     C                   ENDIF                                                                CSW213
     C                   EVAL      RLAPID = 'CIRS'                                            CSW213
     C                   EVAL      RLDTYP = SDTYP                                             CSW213
     C                   EVAL      RLDLST = SDLST                                             CSW213
     C                   EVAL      RLVALD = SVDAT                                             CSW213
     C                   EVAL      RLTRRF = SDLNO                                             CSW213
     C                   EVAL      RLLTRF = SLNKDN                                            CSW213
     C                   EVAL      RLFOID  = APFOTranID                                       CSW213
     C                   EVAL      RLBRCA  = SBRCA                                            CSW213
     C**********         EVAL      RLBCCY = SUCUCY                                   CSW213 MD023734
     C**********         EVAL      RLSCCY = STCUCY                                   CSW213 MD023734
     C                   EVAL      RLBCCY = STCUCY                                          MD023734
     C                   EVAL      RLSCCY = SUCUCY                                          MD023734
     C                   EVAL      RLCNUM = SCNUM                                             CSW213
                                                                                              CSW213
     C                   EVAL      ValScrnNo = 0                                              CSW213
                                                                                              CSW213
     C                   CALL      'DLRPIFVU'                                                 CSW213
     C                   PARM                    DLRILKPDIn                                   CSW213
     C                   PARM                    DLRPIFScn1Fmt                                CSW213
     C                   PARM                    DLRPIFScn2Fmt                                CSW213
     C                   PARM                    DLRPIFScn3Fmt                                CSW213
     C                   PARM                    DLRPIFScn4Fmt                              MD031584
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
     C                   PARM                    DLRIS4PDOut                                MD031584
     C                   PARM      UpdateYN      DUpdateYN                                    CSW213
     C                   PARM                    APIRetc                                      CSW213
     C                   PARM                    ValScrnNo                                    CSW213
     C                   PARM                    DLVRPIFileFmt                                CSW213
     C                   PARM                    DLError1                                     CSW213
     C                   PARM                    DLError2                                     CSW213
     C                   PARM                    DLError3                                     CSW213
     C                   PARM                    DLError4                                   MD031584
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
     C                   EVAL      DLRPIFS4Out = DLRIS4PDOut                                MD031584
                                                                                              CSW213
     C                   ENDSR                                                                CSW213
      *****************************************************************                       CSW213
      /EJECT                                                                                  CSW213
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
     C****************** PARM                    Trans500                                     CDL028
     C                   PARM                    Trans1000                                    CDL028

      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    InPayStmtV
     C                   PARM                    InRecStmtV
     C                   PARM                    InPayStmtM
     C                   PARM                    InRecStmtM


     C                   PARM                    InfData500                                  BUG6671
     C                   PARM                    ExtData500
     C                   PARM                    InSwift2013                                  CSW213
      * Error fields/message IDs/message data (arrays)
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Warning fields/message IDs/message data (arrays)
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
      ** Update Transaction
     C                   PARM                    UpdateYN
      ** Buffer
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                     BUG5449
     C                   PARM                    BufferEx2                                   BUG5449
     C                   PARM                    BufferEx3                                   BUG5449
     C                   PARM                    BufferEx4                                   BUG5449
     C                   PARM                    BufferEx5                                   BUG5449
     C                   PARM                    BufferEx6                                   BUG5449
     C                   PARM                    BufferEx7                                   BUG5449
     C                   PARM                    BufferEx8                                   BUG5449
     C                   PARM                    BufferEx9                                   BUG5449
      ** API Return Code
     C                   PARM                    APIRetc

      ** Set up the name of the MSGF from which the message handler will
      **  get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'

      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'IR'

      ***Define key lists for retrieving records from work file                              BUG5449
      **********                                                                             BUG5449
     C*****KDTSCList     KLIST                                                               BUG5449
     C**********         KFLD                    APFOAsocID                                  BUG5449
     C**********         KFLD                    WOurTheir                                   BUG5449
     C**********         KFLD                    WRatePay                                    BUG5449

     C*****KCFPCList     KLIST                                                               BUG5449
     C**********         KFLD                    APFOAsocID                                  BUG5449
     C**********         KFLD                    WOurTheir                                   BUG5449

      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access API ICD via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY

      ** Call Access Program for FRA/IRS I.C.D. details
      *
     C                   CALLB     'AOFAISR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDFAIS        PARM      SDFAIS        DSFDY
      *                                                                                      BUG5449
      ** Access Module Details                                                               BUG5449
      *                                                                                      BUG5449
     C                   CALL      'AOMMODR0'                                                BUG5449
     C                   PARM      *BLANKS       @RTCD                                       BUG5449
     C                   PARM      '*FIRST '     @OPTN                                       BUG5449
     C     SDMMOD        PARM      SDMMOD        DSFDY                                       BUG5449

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
      ** ACCESS SAR DETAILS FOR Interest Rate Calendars
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CIR001'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C*
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CIR001
     C                   ELSE
     C                   MOVEL     'N'           CIR001
     C                   END
      *
      **  Access SAR details file to determine if Bus. Day Convention is on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR005'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     906           DBASE
     C                   MOVEL     'CIR005'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     'Y'           CIR005
     C                   ELSE
     C                   MOVEL     'N'           CIR005
     C                   ENDIF
      *
      **  Access SAR details file to determine if CIR002 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR002'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     907           DBASE
     C                   MOVEL     'CIR002'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     'Y'           CIR002
     C                   ELSE
     C                   MOVEL     'N'           CIR002
     C                   ENDIF
      *
      **  Access SAR details file to determine if CIR003 is installed.
      *
     C                   CALL      'AOSARDR0'
     C**********         PARM      *BLANKS       @RTCD                                       BUG5962
     C**********         PARM      '*VERIFY'     @OPTN                                       BUG5962
     C**********         PARM      'CIR003'      @SARD                                       BUG5962
     C                   PARM      *BLANKS       PRTCD                                       BUG5962
     C                   PARM      '*VERIFY'     POPTN                                       BUG5962
     C                   PARM      'CIR003'      PSARD                                       BUG5962
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     907           DBASE
     C                   MOVEL     'CIR003'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     'Y'           CIR003
     C                   ELSE
     C                   MOVEL     'N'           CIR003
     C                   ENDIF

      **  Access SAR details file to determine if CIR008 is installed.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR008'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 908
     C                   EVAL      DBKEY = 'CIR008'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CIR008 = 'Y'
     C                   ELSE
     C                   EVAL      CIR008 = 'N'
     C                   ENDIF

      **  Access SAR details file to determine if CAP056 is installed.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAP056'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 909
     C                   EVAL      DBKEY = 'CAP056'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CAP056 = 'Y'
     C                   ELSE
     C                   EVAL      CAP056 = 'N'
     C                   ENDIF

      *
      **  Access SAR details file to determine if CAP041 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAP041'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     908           DBASE
     C                   MOVEL     'CAP041'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     'Y'           CAP041            1
     C                   ELSE
     C                   MOVEL     'N'           CAP041
     C                   ENDIF
      *
      **  Access SAR details file to determine if CEU003 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU003'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     909           DBASE
     C                   MOVEL     'CEU003'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     'Y'           CEU003            1
     C                   ELSE
     C                   MOVEL     'N'           CEU003
     C                   ENDIF
      *
      **  Access SAR details file to determine if CIR006 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     911           DBASE
     C                   MOVEL     'CIR006'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     'Y'           CIR006
     C                   ELSE
     C                   MOVEL     'N'           CIR006
     C                   ENDIF

      **  Access SAR details file to determine if CIR007 is installed.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR007'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     912           DBASE
     C                   MOVEL     'CIR007'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     'Y'           CIR007
     C                   ELSE
     C                   MOVEL     'N'           CIR007
     C                   ENDIF

      ** Check if CSC011 is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
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

      ** Check if enhancement CLE025 (Credit Lines) is on

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CLE025'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CLE025'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 007
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CLE025 = 'Y'
     C                   ELSE
     C                   EVAL      CLE025 = 'N'
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
     C                   Eval      DBASE = 913                                               BUG6671
     C                   OUT       LDA                                                       BUG6671
     C                   EXSR      *PSSR                                                     BUG6671
     C                   ENDIF                                                               BUG6671
      *                                                                                      BUG6671
     C                   If        PRTCD = *Blanks                                           BUG6671
     C                   Eval      CAP051 = 'Y'                                              BUG6671
     C                   Else                                                                BUG6671
     C                   Eval      CAP051 = 'N'                                              BUG6671
     C                   EndIf                                                               BUG6671
                                                                                             BUG5449
      * Determine if CSC022 is switched on                                                   BUG5449
     C                   CALLB     'AOSARDR0'                                                BUG5449
     C                   PARM      *BLANKS       PRtCd                                       BUG5449
     C                   PARM      '*VERIFY'     POptn                                       BUG5449
     C                   PARM      'CSC022'      PSard                                       BUG5449
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG5449
                                                                                             BUG5449
     C                   IF        PRtCd = *Blanks                                           BUG5449
     C                   EVAL      CSC022 = 'Y'                                              BUG5449
     C                   EVAL      WCMT01 ='N'                                               BUG5449
      * SCCMTJOB data area                                                                   BUG5449
     C                   IN        SCCMTJOB                                                  BUG5449
      * Move data area to commitment array                                                   BUG5449
     C                   IF        COMITNOM > 0                                              BUG5449
     C                   MOVEA     COMITJOB      ARRJBNAM                                    BUG5449
      *                                                                                      BUG5449
      * Check if PSJOBNAME exist.                                                            BUG5449
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                 BUG5449
     C                   IF        *IN17 = *ON                                               BUG5449
     C                   EVAL      WCMT01= 'Y'                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ENDIF                                                               BUG5449
     C                   ELSE                                                                BUG5449
     C                   EVAL      CSC022 = 'N'                                              BUG5449
                                                                                             BUG5449
     C                   IF        PRtCd <> '*NRF'                                           BUG5449
     C     *LOCK         IN        LDA                                                       BUG5449
     C                   EVAL      DBKEY = 'CSC022'                                          BUG5449
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG5449
     C                   EVAL      DBASE = 915                                               BUG5449
     C                   OUT       LDA                                                       BUG5449
     C                   EXSR      *PSSR                                                     BUG5449
     C                   ENDIF                                                               BUG5449
                                                                                             BUG5449
     C                   ENDIF                                                               BUG5449
     C     KIRSDL        KLIST                                                               BUG5449
     C                   KFLD                    WDealNo                                     BUG5449
     C                   KFLD                    POurTheir                                   BUG5449
     C                   KFLD                    PRDT                                        BUG5449
                                                                                             BUG5449
     C     KIRSDP        KLIST                                                               BUG5449
     C                   KFLD                    WDealNo                                     BUG5449
     C                   KFLD                    POurTheir                                   BUG5449
                                                                                             BUG5449
     C     KIRSDV        KLIST                                                               BUG5449
     C                   KFLD                    WDealNo                                     BUG5449
     C                   KFLD                    POurTheir                                   BUG5449
     C                   KFLD                    WRatePay                                    BUG5449
     C                   KFLD                    InDateMDN                                   BUG5449
                                                                                             BUG5449
     C     KCFPC         KLIST                                                               BUG5449
     C                   KFLD                    WDealNo                                     BUG5449
     C                   KFLD                    POurTheir                                   BUG5449
     C                   KFLD                    InDateMDN                                   BUG5449
                                                                                             BUG5449
      ** Partial Key for DLDTSCPD                                                            BUG5449
     C     KDTSC         KLIST                                                               BUG5449
     C                   KFLD                    WDealNo                                     BUG5449
                                                                                             BUG5449
     C     KIRSDM        KLIST                                                               BUG5449
     C                   KFLD                    WDealNo                                     BUG5449
     C                   KFLD                    POurTheir                                   BUG5449
     C                   KFLD                    WRatePay                                    BUG5449
     C                   KFLD                    PRDT                                        BUG5449
                                                                                             BUG5449
     C     KIRSDN        KLIST                                                               BUG5449
     C                   KFLD                    WDealNo                                     BUG5449
     C                   KFLD                    POurTheir                                   BUG5449
     C                   KFLD                    WRatePay                                    BUG5449

      *                                                                                       CSW213
      ** Check if SWIFT 2013  is on                                                           CSW213
      *                                                                                       CSW213
     C                   EVAL      CSW213 = *BLANKS                                           CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       PRtCd                                        CSW213
      *                                                                                       CSW213
     C                   IF        PRtCd = 'CSW2013'                                          CSW213
     C                   EVAL      CSW213 = 'Y'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      CSW213 = 'N'                                               CSW213
      *                                                                                       CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
