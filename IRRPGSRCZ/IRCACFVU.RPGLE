     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/Collars/Floors Validate & Update')       *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCACFVU - Caps/Collars/Floors - Validate and Update         *
      *                                                               *
      *  Function: This program validates IR Caps/Collars/Floors for  *
      *            input into the Midas database.                     *
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
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSD095CC1          Date 13Sep16               *
      *  Prev Amend No. MD031861           Date 12Jan15               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR314712           Date 13Apr10               *
      *                 AR218555           Date 26Mar10               *
      *                 245692             Date 11Dec13               *
      *                 MD023734           Date 30Nov13               *
      *                 CSW213             Date 03Jun13               *
      *                 MD000091           Date 08May13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                BUG12542            Date 09Nov06               *
      *                240240              Date 26Jun06               *
      *                239130              Date 23Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                BUG11254            Date 19Apr06               *
      *                CSD027              Date 09Dec05               *
      *                BUG8550             Date 05Oct05               *
      *                BUG7923             Date 21Jul05               *
      *                BUG8560             Date 19Sep05               *
      *                BUG7659             Date 23Jun05               *
      *                BUG5871             Date 23May05               *
      *                BUG7166             Date 12May05               *
      *                CDL038              Date 10May05               *
      *                BUG7046             Date 06May05               *
      *                BUG6719             Date 20Apr05               *
      *                BUG6671             Date 26Apr05               *
      *                CLE031              Date 26Apr05               *
      *                BUG6472             Date 23Apr05               *
      *                CDL028              Date 07Feb05               *
      *                BUG6377             Date 11Apr05               *
      *                BUG6386             Date 23Mar05               *
      *                BUG5964             Date 17Feb05               *
      *                BUG5610             Date 27Jan05               *
      *                BUG5453             Date 13Jan05               *
      *                BUG5403             Date 10Jan05               *
      *                BUG5181             Date 16Dec04               *
      *                BUG4390             Date 29Sep04               *
      *                BUG4044             Date 18Aug04               *
      *                BUG4023             Date 12Aug04               *
      *                 CDL018             Date 03Feb04               *
      *                 CAP084  *CREATE    Date 04Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD095CC1 - Allow Deal Sub-Type and Branch for IRS, FRA and  *
      *              CCF SSIs                                         *
      *  MD031861 - Cannot insert transaction due to errors. Correct  *
      *             mapping to include CDL094 fields.                 *
      *  CSW214 - SWIFT Changes 2014                                  *
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
      *  MD023734 - Clearing Threshold Indicator not defaulted.       *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  MD000091 - Event Codes Substitution                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  BUG12542 - Failed to insert new Transaction due to Serious   *
      *             MidasPlus Error.                                  *
      *  240240 - Ensure locks don't remain on DLPCSCPD.              *
      *         - Apply 239130 to update DLPCSCPD when authorizing.   *
      *         - CALLB FFDATE. Call results in 'cannot resolve' bug. *
      *  239130 - Update DLPCSCPD file when authorizing.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11254-Positions of the schedules on the buffer were not   *
      *           changed to cope with impact of CLE031 changes.      *
      *           Also there are no CDL038 changes to rebuild buffer  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      * BUG7923 - Don't validate transaction for deletes, when delete *
      *           via soap only deal number is a screen field         *
      * BUG8560 - Premium amount incorrectly setup if CIR006 is off   *
      * BUG7659 - Setup settlements correctly to validate holidays    *
      * BUG5871 - Send deal status to MidasPlus                       *
      * BUG7166- Valid file does not match DEALSDG (Recompile)        *
      *  CDL038 - Extended Deal Sub Type                              *
      * BUG7046 - Validate principal change schedule if present       *
      * BUG6719 - Return all errors at once                           *
      * BUG6671 - Implement Auto Authorisation                        *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      * BUG6472 - Added a sign field for short term rate              *
      *  CDL028 - Automatic Rate Interpolations                       *
      * BUG6377 - Need Fixing Dates (Ours and Theirs) ADDED to        *
      *          the confirmation screens                             *
      * BUG6386 - Principal Change schedules not showing for migrated *
      *            deals                                              *
      * BUG5964- Schedule 1st non processed date should be the same as*
      *          the date in the main details                         *
      * BUG5610- Amount formatting                                    *
      * BUG5453- Error messages relating to edit table need more      *
      *          detailed information                                 *
      * BUG5403 - Principle Change Schedule missing in CACF           *
      * BUG5181 - Addition of parameter in IRCACFCVT, IRCACFVAL       *
      * BUG4390 - Serious Midas error during amend of CACF            *
      *           Condition update of upfront fees and buy out details*
      * BUG4044 - Need to initialise additional fields                *
      * BUG4023 - Decimal data error because fields are not intialised*
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAP084 - API Wrapper project.  This will replace version     *
      *           found in core.                                      *
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

     FDLDETUL0  UF A E           K DISK    INFSR(*PSSR)                         BUG5403
     F                                     COMMIT                               BUG5403
     F*DLPCSCL0**UF***E           K DISK    RENAME(DLPCSCD0:DLPCSCX0)           BUG5403       240240
     FDLPCSCL0  UF   E           K DISK    INFSR(*PSSR)                                       240240
     F                                     RENAME(DLPCSCD0:DLPCSCX0)                          240240
     F                                     PREFIX(XX)                           BUG5403
     F                                     COMMIT                               BUG5403
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

      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      ** Incoming transaction
     D TranInCACF    E DS                  EXTNAME(IRCACFPD)
     D PBDCCcy               205    268                                         BUG5403

      ** Valid deals layout
     D NwIRFilFmt    E DS                  EXTNAME(IRVCACFPD)
      *
     D CACFRecIns            730    784
     D CACFPayIns            799   1343
     D CACFFraIns           1345   1992

     D***BsDayConv***********205    268                                                      BUG6377
     D***RtFxConv************239    268                                                      BUG6377

      ** Current deal in File format
     D CrIRFilFmt    E DS                  EXTNAME(DEALSDG)

      ** Current deal in Screen format
     D CrIRScnFmt    E DS                  EXTNAME(IRCACFPD)
     D                                     PREFIX(@)

     D CrIRScn2Fmt   E DS                  EXTNAME(IRCACF2PD)
     D                                     PREFIX(@)
      ** Current Deal in Work Screen Format

      ** Pay/Rcv/FRA-IRS Settlement Instructions - Input
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)

      ** FRA/IRS Interface Non-Screen Data
     D InfData       E DS                  EXTNAME(IRRPIFPD)

      ** Pay/Rcv/FRA-IRS Settlement Instructions - Current
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)

      ** Pay/Rcv/FRA-IRS Settlement Instructions - File (D/B) format
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D   FLPAY                21    575
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D  FLREC                 21     75
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
     D  FLIRS                  1    650

      ** Caps/Collars/Floors Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(IRCPEXPD)

      ** Array message for RPIF                                                               CSW213
     D DFldNameArr     S             10A   DIM(ArrayMax)                                      CSW213
     D DMsgIDArr       S              7A   DIM(ArrayMax)                                      CSW213
     D DMsgDtaArr      S             45A   DIM(ArrayMax)                                      CSW213
     D DWFldNamArr     S             10A   DIM(ArrayMax)                                      CSW213
     D DWMsgIDArr      S              7A   DIM(ArrayMax)                                      CSW213
     D DWMsgDtaArr     S             45A   DIM(ArrayMax)                                      CSW213
                                                                                              CSW213
      ** Error indicators/OK flags
     D IRECACF       E DS                  EXTNAME(IRECACFPD)

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
      * RPIF Error File - Screen 1                                                            CSW213
     D DLError1      E DS                  EXTNAME(DLERI1PD)                                  CSW213
                                                                                              CSW213
      * RPIF Error File - Screen 2                                                            CSW213
     D DLError2      E DS                  EXTNAME(DLERI2PD)                                  CSW213
                                                                                              CSW213
      * RPIF Error File - Screen 3                                                            CSW213
     D DLError3      E DS                  EXTNAME(DLERI3PD)                                  CSW213
                                                                                              CSW213
      * RPIF Error File - Screen 4                                                            CSW214
     D DLError4      E DS                  EXTNAME(DLERI4PD)                                  CSW214
                                                                                              CSW214
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

      ** Array for UpFront Fee and Buy Amount Fields
     D SFEBO           S             10    DIM(10) PERRCD(1) CTDATA
     D #0FEBO          S             10    DIM(10) ALT(SFEBO)
     D LETT            S              1    DIM(7) CTDATA PERRCD(7)              BUG5403

      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Module details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External DS for Deal details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)

      ** External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC1       E                     EXTFLD(QQACCD)

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** External DS for FRA/IRS ICD
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)

      ** External DS for Trading details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC2       E                     EXTFLD(QQACCD)

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

      ** External DS Retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC3       E                     EXTFLD(QQACCD)

      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC4       E                     EXTFLD(QQACCD)

      ** First DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)
     D  WCMTJOBS               4    103A
      ** Commitment Control dataarea
      *  Array for Principle change Schedule                                    BUG5403
     D PCSA            S             25A   DIM(600)                             BUG5403
     D TPCMDAT         S              5  0 DIM(600)                             BUG5403
     D TPCAMT          S             15  0 DIM(600)                             BUG5403
     D PCSAST          S          15000A                                        BUG5403
      *  Principle Change Schedule                                              BUG5403
     D PCHGSCH         DS                                                       BUG5403
     D  PCDATE                        6A                                        BUG5403
     D  PCCHOL                        1A                                        BUG5403
     D  PCAMT                        16A                                        BUG5403
     D  PCIDFLG                       1A                                        BUG5403
     D  PCPDAT                        1A                                        BUG5403
      *  Array for Business Day Convention currencies                           BUG5403
     D  PBDCCcyArr                    3A   DIM(10)                              BUG5403
     D WMDATE          S              5  0 DIM(600)                             BUG5403
     D WPCAMT          S             15  0 DIM(600)                             BUG5403
      *  Date schedule formula for generating dates                             BUG5403
     D FORMULAOPC      DS                                                       BUG5403
     D  SFREQFOPC                     1A                                        BUG5403
     D  SFORMOPC                      7A                                        BUG5403
     D  SFORMAMOPC                   16A                                        BUG5403
     D  SFORMIDOPC                    1A                                        BUG5403
     D FORMULA         DS                                                       BUG5403
     D  SFORM                  1      7                                         BUG5403
     D  SWRK1                  1      1                                         BUG5403
     D  SWRK2                  2      2                                         BUG5403
     D  SDN1                   1      2                                         BUG5403
     D  SWRK3                  3      3                                         BUG5403
     D  SWRK4                  4      4                                         BUG5403
     D  SWRK5                  5      5                                         BUG5403
     D  SDN2                   4      5                                         BUG5403
     D  SWRK6                  6      6                                         BUG5403
     D  S456                   4      6                                         BUG5403
     D  SWRK7                  7      7                                         BUG5403
      ** Internally described data structure for ZDATE                          BUG5403
     D DateDS          DS             6                                         BUG5403
     D  DteMth                 1      2A                                        BUG5403
     D  DteDay                 3      4A                                        BUG5403
     D  DteYr                  5      6A                                        BUG5403

     D Buffer2         S           3999                                         BUG5403
     D BufferEx2       S           9999                                         BUG5403
                                                                                BUG5403
      ** Date converted to Midas Dayno format                                   BUG5403
     D   InDateMDN     S              5P 0                                      BUG5403
                                                                                BUG5403
      ** Date to be validated                                                   BUG5403
     D   InDate        S              6                                         BUG5403
                                                                                BUG5403
      ** Confirm holiday to be validated                                        BUG5403
     D   CHol          S              1                                         BUG5403
                                                                                BUG5403
      ** Processed date flag                                                    BUG5403
     D   ProcDate      S              1                                         BUG5403
                                                                                BUG5403
      ** Array index                                                            BUG5403
     D X               S              3  0                                      BUG5403
     D I               S              3  0                                      BUG5403
     D K               S              3  0                                      BUG5403
     D L               S              3  0                                      BUG5403
     D A               S              3  0                                      BUG5964
     D B               S              3  0                                      BUG5964
     D PValType        S              1A                                        BUG5403
     D WDealNo         S              6  0                                      BUG5403
     D POurTheir       S              1A                                        BUG5403
     D WCTLDYN         S              5P 0                                      BUG5403
     D WPCSCFound      S              1A                                        BUG5403
     D WRatePay        S              1A                                        BUG5403
     D WAmount         S             16A                                        BUG5403
     D WONBDP          S                   LIKE(A6NBDP)                         BUG5403
     D WPNBDP          S                   LIKE(A6NBDP)                         BUG5403
     D WRNBDP          S                   LIKE(A6NBDP)                         BUG5403
     D WRSCY           S              3A                                        BUG5403
     D WPSCY           S              3A                                        BUG5403
     D WHoliday        S              1A                                        BUG5403
     D WRK153          S             15  3                                      BUG5403
     D WRK30           S              3  0                                      BUG5403
     D WPAMT           S             15  0                                      BUG5403
     D SFREQF          S              1A                                        BUG5403
     D ZDATE           S              6P 0                                      BUG5403
     D ZDAYNO          S              5P 0                                      BUG5403
     D PDAT            S              1A                                        BUG5403
     D SFORMAMT        S             10A                                        BUG5403
     D SFORMNAME       S             10A                                        BUG5403
     D SUINFD          S              6A                                        BUG6377
     D STINFD          S              6A                                        BUG6377
                                                                                BUG5403
     D PrinChg         C                   CONST('Principle Change Schedule')   BUG5453
     D WRPUPFE         S                   LIKE(RPUPFE)                                      BUG8560
     D WRPUPVD         S                   LIKE(RPUPVD)                                      BUG8560
      ** Array to hold commitment jobs name
     D WCMT            S             10A   DIM(10)

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
     D CAP051          S              1A                                                     BUG6671
     D CSC011          S              1A
     D CAP041          S              1A
     D CEU003          S              1A
     D CDE001          S              1A
     D CSW213          S              1                                                       CSW213

      ** Indexes
     D AmIdx           S              3P 0
     D Idx             S              3P 0
     D Ix              S              3P 0
     D Iy              S              3P 0
     D WIdx            S              3P 0

      ** Entry Parameters
     D ExtData500      S            500A
     D InfData500      S            500A
     D Trans5001       S            500A
     D Trans5002       S            500A

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
     D*PDealSts*       S             24A                                                     BUG5871
     D #1STAT          S             24A                                                     BUG5871

      ** Parameters for IRCACFVAL
     D ModeOfOp        S              6A
     D PayNostro       S             18A
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D RecNostro       S             18A
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D WValBDC         S              1A

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

      ** Parameters for APLOGTRAN
     D TRANSDTL        S           5800A
     D PDealNo         S             18A
     D PADealNo        S             18A

     D PGnDlNo         S              6A

      ** Whether or not to clear the program message queue
     D ClearPgmQ       S              1A
     D PScreenInpt     S              1A
      *
      ** Fields for enhancement CSC022
     D CSC022          S              1A   INZ('N')
     D WCmtSk          S              1A
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
                                                                                              CSW213
      ** Work Variables for DLRPIFR                                                           CSW213
     D ValScrnNo       S              1  0                                                    CSW213
     D PModeOp         S              6                                                       CSW213
     D PTranRefOK      S              1                                                       CSW213
     D DFOfcrIDOK      S              1                                                       CSW213
     D WNoRepFlag      S              1                                                       CSW213
     D CtrX            S              3S 0                                                    CSW213
     D RIdx            S              3P 0                                                    CSW213
     D WRIdx           S              3P 0                                                    CSW213
     D DUpdateYN       S              1A                                                      CSW213
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

      ** Retrieve ZMUSER details                                                             BUG8550
                                                                                             BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
                                                                                             BUG8550
      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used b/w this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.

     C                   MOVEL     Trans5001     TranInCACF
     C                   MOVEL     Trans5002     CrIRScn2Fmt
     C                   MOVEL     Extdata500    Extdata
     C                   MOVEL     InfData500    InfData
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1120)               BUG5403      BUG6377
     C**********         EVAL      PCSAST=%SUBST(Buffer:1145)+Buffer2+          BUG5403      BUG6377
     C**********                   BufferEx2                                    BUG5403      BUG6377
     C****************** EVAL      SUINFD=%SUBST(Buffer:1120)                          BUG6377CDL028
     C****************** EVAL      STINFD=%SUBST(Buffer:1126)                          BUG6377CDL028
     C****************** EVAL      FORMULAOPC=%SUBST(Buffer:1132)                      BUG6377CDL028
     C****************** EVAL      PCSAST=%SUBST(Buffer:1157)+Buffer2+                 BUG6377CDL028
     C**********         EVAL      SUINFD=%SUBST(Buffer:1164)                         CDL028 BUG6472
     C**********         EVAL      STINFD=%SUBST(Buffer:1170)                         CDL028 BUG6472
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1176)                     CDL028 BUG6472
     C**********         EVAL      PCSAST=%SUBST(Buffer:1201)+Buffer2+                CDL028 BUG6472
     C**********         EVAL      SUINFD=%SUBST(Buffer:1165)                       BUG6472 BUG11254
     C**********         EVAL      SUINFD=%SUBST(Buffer:1199)                       BUG11254 CSF011A
     C**********         EVAL      SUINFD=%SUBST(Buffer:1863)                       CSF011A MD031861
     C**********         EVAL      STINFD=%SUBST(Buffer:1171)                       BUG6472 BUG11254
     C**********         EVAL      STINFD=%SUBST(Buffer:1205)                       BUG11254 CSF011A
     C**********         EVAL      STINFD=%SUBST(Buffer:1869)                       CSF011A MD031861
     C**********         EVAL      #1STAT=%SUBST(Buffer:1195)                       BUG5871 BUG11254
     C**********         EVAL      #1STAT=%SUBST(Buffer:1211)                       BUG11254 CSF011A
     C**********         EVAL      #1STAT=%SUBST(Buffer:1875)                       CSF011A MD031861
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1177)                    BUG6472 BUG5871
     C**********         EVAL      PCSAST=%SUBST(Buffer:1202)+Buffer2+               BUG6472 BUG5871
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1201)                   BUG5871 BUG11254
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1235)                   BUG11254 CSF011A
     C**********         EVAL      FORMULAOPC=%SUBST(Buffer:1899)                   CSF011A MD031861
     C                   EVAL      DLRPIFScn1Fmt = DLRPIFS1In                                 CSW213
     C                   EVAL      DLRPIFScn2Fmt = DLRPIFS2In                                 CSW213
     C                   EVAL      DLRPIFScn3Fmt = DLRPIFS3In                                 CSW213
     C                   EVAL      DLRPIFScn4Fmt = DLRPIFS4In                                 CSW214
     C**********         EVAL      PCSAST=%SUBST(Buffer:1226)+Buffer2+              BUG5871 BUG11254
     C**********         EVAL      PCSAST=%SUBST(Buffer:1260)+Buffer2+              BUG11254 CSF011A
     C**********         EVAL      PCSAST=%SUBST(Buffer:1924)+Buffer2+                CSF011A CSW213
     C**********         EVAL      PCSAST=%SUBST(Buffer:3856)+Buffer2+                 CSW213 CSW214
     C**********                   BufferEx2                                          BUG6377 CSW214
     C**********         EVAL      PCSAST=%SUBST(Buffer:4018)+Buffer2+               CSW214 MD031861
     C**********                   BufferEx2                                         CSW214 MD031861
     C                   EVAL      SUINFD=%SUBST(Buffer:2073)                               MD031861
     C                   EVAL      STINFD=%SUBST(Buffer:2079)                               MD031861
     C                   EVAL      #1STAT=%SUBST(Buffer:2085)                               MD031861
     C                   EVAL      FORMULAOPC=%SUBST(Buffer:2109)                           MD031861
     C                   EVAL      PCSAST=%SUBST(Buffer:4228) + Buffer2 +                   MD031861
     C                             BufferEx2                                                MD031861
     C
     C                   MOVEA     PCSAST        PCSA                           BUG5403

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

      /COPY WNCPYSRC,IRCACFC005
      ** Validate Action code

     C                   EXSR      SrValActCde

      ** If error in validation of action code, fail this input

     C                   IF        Idx <> *ZERO
     C                   GOTO      INVALID
     C                   ENDIF

      ** Process depending on Action Code:

     C                   SELECT

      ** For INSERT

     C                   WHEN      #0ACCD = 'I'
     C                   EXSR      SrDefaultSSI
     C                   EXSR      SrValTrans
     C                   EXSR      SrValSSI

      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change
      ** Date) is installed and no previous errors, then perform validation of fields.

     C**********         IF        CAP041 = 'Y' AND Idx = 0                                  BUG6719
     C                   IF        CAP041 = 'Y'                                              BUG6719
     C                             AND CIR006 = 'Y'                                         AR218555
     C                   EXSR      SrValidFE
                                                                                BUG5403
      ** Validate Principle change date schedules                               BUG5403
                                                                                BUG5403
     C     CIR001        IFEQ      'Y'                                          BUG5403
     C*****Idx           ANDEQ     0                                            BUG5403     BUG6719
     C                   EXSR      ValidatePC                                   BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ELSE                                                               BUG4023
      ** Initialise packed numeric fields from Data                                         BUG4023
     C                   Eval      #1TNPC = 0                                               BUG4023
     C                   Eval      #1UNPC = 0                                               BUG4023
     C                   Eval      #1UPVD = 0                                               BUG4023
     C                   Eval      #1UPFE = 0                                               BUG4023
     C                   Eval      #1BODD = 0                                               BUG4023
     C                   Eval      #1BOVD = 0                                               BUG4023
     C                   Eval      #1BOAM = 0                                               BUG4023
     C                   Eval      #1OUSI = 0                                               BUG4023
     C                   Eval      #1OUSA = 0                                               BUG4023
     C                   Eval      #1TUSI = 0                                               BUG4023
     C                   Eval      #1TUSA = 0                                               BUG4023
     C                   ENDIF

      ** For Amends

     C                   WHEN      #0ACCD = 'A'
      /COPY WNCPYSRC,IRCACFC011
     C                   IF        GHSUBS <> *BLANKS
     C     GHSUBS        SCAN      TranInCACF                             80
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

     C**********         IF        CAP041 = 'Y' AND Idx = 0                                  BUG6719
     C                   IF        CAP041 = 'Y'                                              BUG6719
     C                             AND CIR006 = 'Y'                                         AR218555
     C                   EXSR      SrValidFE
                                                                                BUG5403
      ** Validate Principle change date schedules                               BUG5403
                                                                                BUG5403
     C     CIR001        IFEQ      'Y'                                          BUG5403
     C*****Idx           ANDEQ     0                                            BUG5403     BUG6719
     C                   EXSR      ValidatePC                                   BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF

      /COPY WNCPYSRC,IRCACFC014
     C                   EXSR      SrValAmend
      /COPY WNCPYSRC,IRCACFC015

      ** Processing for Authorise or Delete
     C                   WHEN      #0ACCD = 'X' OR #0ACCD = 'R'
     C                   EXSR      SrSetupAmd
     C                   If        #0ACCD = 'X'                                              BUG7923
     C                   EXSR      SrValTrans
     C                   EXSR      SrValSSI

      ** If CAP041 (APIs for Fees/Buy-Outs/Processing Method/Next Principal Change
      ** Date) is installed and no previous errors, then perform validation of fields.

     C**********         IF        CAP041 = 'Y' AND Idx = 0                                  BUG6719
     C                   IF        CAP041 = 'Y'                                              BUG6719
     C                             AND CIR006 = 'Y'                                         AR218555
     C                   EXSR      SrValidFE
                                                                                BUG5403
      ** Validate Principle change date schedules                               BUG5403
                                                                                BUG5403
     C     CIR001        IFEQ      'Y'                                          BUG5403
     C*****Idx           ANDEQ     0                                            BUG5403      BUG6719
     C                   EXSR      ValidatePC                                   BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF
     C                   ENDIF                                                               BUG7923

     C                   ENDSL

     C     INVALID       TAG
                                                                                              CSW213
      ** Call DLRPIFVU - Midas DL Reporting Information Validate                              CSW213
      ** and Update                                                                           CSW213
                                                                                              CSW213
     C                   IF        CSW213 = 'Y' AND                                           CSW213
     C                             UPDateYN <> 'Y'                                            CSW213
     C                   EXSR      SrCACFvu                                                   CSW213
     C                   ENDIF                                                                CSW213
      *
      ** Call update subroutines if no errors during validation.
      *
     C                   IF        (Idx = *ZERO) AND (UpdateYN = 'Y')
     C                   EXSR      SrUpdate
                                                                                BUG5403
      ** If Interest Rate Calendars are in use write to valid IRC file          BUG5403
      ** (dont bother setting up for delete)                                    BUG5403
                                                                                BUG5403
     C     CIR001        IFEQ      'Y'                                          BUG5403
     C                   EXSR      SUPVALIRC                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C                   IF        CAP041 = 'Y'                                              BUG4390
     C                   EXSR      SrFileFlds
     C                   ELSE                                                                BUG4390
     C                   EVAL      #1CNRQ = 'N'                                              BUG4390
     C                   ENDIF                                                               BUG4390
     C                   ENDIF

     C                   SETON                                        LR

     C                   IF        UpdateYN = 'Y' and Idx = 0                                BUG6377
      *                                                                                      BUG6377
     C                   MOVE      RPDLNO        DDDLNO_IN         6                         BUG6377
     C                   CALL      'IRCACFR'                                                 BUG6377
     C                   PARM                    AuthComp          1                         BUG6377
     C                   PARM                    FwdBck            1                         BUG6377
     C                   PARM                    DDDLNO_In                                   BUG6377
     C                   PARM                    Buffer                                      BUG6377
     C                   PARM                    Buffer2                                     BUG6377
     C                   PARM                    BufferEx2                                   BUG6377
     C                   PARM                    FldNameArr                                  BUG6377
     C                   PARM                    MsgIDArr                                    BUG6377
     C                   PARM                    MsgDtaArr                                   BUG6377
     C                   PARM                    MsgFArray                                   BUG6377
     C                   PARM                    APIRetC                                     BUG6377
     C                   MOVEL     #0ACCD        Buffer                                      BUG6377
      *                                                                                      BUG6377
     C                   ELSE                                                                BUG6377
     C                   MOVEA     PCSA          PCSAST                         BUG5403
      * Remerge buffer with all relevant data structures

     C                   EVAL      Buffer = TranInCACF + CrIRScn2Fmt + InfData
     C                                     + InRecSttmt + InPaySttmt + ExtData
     C**********                           + FORMULAOPC + PCSAST                BUG5403      BUG6377
     C**********                        + SUINFD + STINFD + FORMULAOPC + PCSAST      BUG6377 BUG5871
     C                                  + SUINFD + STINFD + #1STAT                           BUG5871
     C**********                        + FORMULAOPC + PCSAST                         BUG5871 CSW213
     C                                  + FORMULAOPC                                          CSW213
     C                                  + OutSwift2013                                        CSW213
     C                                  + PCSAST                                              CSW213
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4857)                  BUG5403      BUG6377
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7857)                BUG5403      BUG6377
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4845)                         BUG6377CDL028
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7845)                       BUG6377CDL028
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4801)                        CDL028 BUG6472
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7801)                      CDL028 BUG6472
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4800)                       BUG6472 BUG5871
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7800)                     BUG6472 BUG5871
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4776)                      BUG5871 BUG11254
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4742)                      BUG11254 CSF011A
     C**********         EVAL      Buffer2=%SUBST(PCSAST:4078)                        CSF011A CSW213
     C**********         EVAL      Buffer2=%SUBST(PCSAST:2146)                         CSW213 CSW214
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7776)                    BUG5871 BUG11254
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:7742)                    BUG11254 CSF011A
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:8078)                      CSF011A CSW213
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:6145)                       CSW213 CSW214
     C**********         EVAL      Buffer2=%SUBST(PCSAST:1984)                       CSW214 MD031861
     C**********         EVAL      BufferEx2=%SUBST(PCSAST:5983)                     CSW214 MD031861
     C                   EVAL      Buffer2=%SUBST(PCSAST:1774)                                CSW214
     C                   EVAL      BufferEx2=%SUBST(PCSAST:5773)                              CSW214
     C                   ENDIF                                                               BUG6377

     C                   RETURN

      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRCACFC019
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValidFE  - Routine to validate Fees\Buy-Outs fields         *
      *                                                               *
      *****************************************************************

     C     SrValidFE     BEGSR

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

     C                   CALLB     'IRSFBOVAL'
      *
      ** INPUTS
      ** ======
      *
      * Response mode
     C                   PARM      'S'           APRespMode
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** (Midas) Deal Number                                                                BUG12542
                                                                                            BUG12542
     C                   PARM                    #0DLNO                                     BUG12542
                                                                                            BUG12542
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

      ** Convert the Error and Warning Fields to CACF format  FldNameArr

     C     1             DO        ArrayMax      W                 2 0

     C                   If        FldNameArr(W)  = *BLANKS
     C                   ITER
     C                   EndIf

     C                   Z-ADD     1             Xi                2 0
     C     FldNameArr(W) LOOKUP    SFEBO(Xi)                              10
     C                   If        *IN10 = '1'
     C                   EVAL      FldNameArr(W) = #0FEBO(Xi)
     C                   EndIf

     C                   ENDDO

     C     1             DO        ArrayMax      W                 2 0

     C                   If        WFldNamArr(W)  = *BLANKS
     C                   ITER
     C                   EndIf

     C                   Z-ADD     1             Xi                2 0
     C     WFldNamArr(W) LOOKUP    SFEBO(Xi)                              10
     C                   If        *IN10 = '1'
     C                   EVAL      WFldNamArr(W) = #0FEBO(Xi)
     C                   EndIf

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValActCde - Validate Action Code VS Deal Number Supplied   *
      *                                                               *
      *****************************************************************
     C     SrValActCde   BEGSR

      ** Validate Action code versus Deal number supplied

     C                   CALLB     'IRCACFRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    ModeOfOp
     C                   PARM      'S'           APRESPMODE
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
     C                   PARM                    BQFIAU
     C                   PARM                    BQFIRA
     C                   PARM                    CIR008
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
      *  SrDefaultSSI - Apply Default Settlement Instructions         *
      *                 (if none have been supplied).                 *
      *                                                               *
      *****************************************************************
     C     SrDefaultSSI  BEGSR

     C                   EVAL      FLREC      = CACFRecIns
     C                   EVAL      FLRSTM     = RPRSTM
     C                   EVAL      FLRONS     = RPRONS
     C                   EVAL      FLROBR     = RPROBR
     C                   EVAL      FLRSCY     = RPRSCY
      *
     C                   EVAL      FLPAY      = CACFPayIns
     C                   EVAL      FLPSTM     = RPPSTM
     C                   EVAL      FLPONS     = RPPONS
     C                   EVAL      FLPOBR     = RPPOBR
     C                   EVAL      FLCVMR     = RPCVMR
     C                   EVAL      FLPSCY     = RPPSCY
     C                   EVAL      FLIC72     = RPIC72
      *
     C                   EVAL      FLIRS      = CACFFraIns
     C                   MOVE      RPAGVC        FLAGVC

      ** If ANY of Settlement fields were entered, bypass this routine.
      ** Otherwise, use modules that will use SSIs to apply defaults

     C                   IF        InRecSttmt = *BLANKS AND
     C                             InPaySttmt = *BLANKS
      *
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
     C*****              PARM      *BLANK        BlankSTYP                          CSD095 CSD095CC1
     C                   PARM      #0DLST        BlankSTYP                                 CSD095CC1
      ** Branch                                                                               CSD095
     C*****              PARM      *BLANK        BlankBRCA                          CSD095 CSD095CC1
     C                   PARM      #0BRCA        BlankBRCA                                 CSD095CC1

     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt

      ** Defaulted instructions are in file format, but the Settlements
      ** validation requires that they are in the screen format.
      ** Therefore run them through a conversion module.

     C                   CALLB     'ZASETINCVT'
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      #0CUCY        INRCCY            3                         CSF011A
     C                   PARM      #0CUCY        INPCCY            3                         CSF011A

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
      *
     C                   EVAL      FLREC      = CACFRecIns
     C                   EVAL      FLRSTM     = RPRSTM
     C                   EVAL      FLRONS     = RPRONS
     C                   EVAL      FLROBR     = RPROBR
     C                   EVAL      FLRSCY     = RPRSCY
      *
     C                   EVAL      FLPAY      = CACFPayIns
     C                   EVAL      FLPSTM     = RPPSTM
     C                   EVAL      FLPONS     = RPPONS
     C                   EVAL      FLPOBR     = RPPOBR
     C                   EVAL      FLCVMR     = RPCVMR
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
     C                   PARM      #0CUCY        INRCCY                                      CSF011A
     C                   PARM      #0CUCY        INPCCY                                      CSF011A

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

      ** Set up settlement information needed for holidays validation:
      ** - default fields for Inserts
      ** - existing d/b fields for Amends (also uses InPaySttmt etc.)

     C                   IF        (#0ACCD = 'I') OR (#0ACCD = 'A')
     C**********         EVAL      RecSetMeth = FLRSTM                                       BUG7659
     C**********         EVAL      RecNostro  = FLRONS                                       BUG7659
     C**********         EVAL      PaySetMeth = FLPSTM                                       BUG7659
     C**********         EVAL      PayNostro  = FLPONS                                       BUG7659
     C                   MOVE      DDRSTM        RecSetMeth                                  BUG7659
     C                   MOVEL     DDRONX        RecNostro                                   BUG7659
     C                   MOVEL     DDPSTM        PaySetMeth                                  BUG7659
     C                   MOVEL     DDPONX        PayNostro                                   BUG7659
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
     C                   PARM      'S'           APRespMode
     C                   PARM                    CrIRScnFmt
     C                   PARM                    TranInCACF
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
      ***Sign*of*Short Term Rate                                                     BUG5181 BUG6472
     C**********         PARM                    #0SIGN            1                 BUG5181 BUG6472

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
     C                   PARM                    ##PPAY            1
     C                   PARM                    ##PREC            1
     C                   PARM                    OKPaySSI
     C                   PARM                    OKRcvSSI
     C                   PARM                    OKFraSSI
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
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
     C                   PARM                    CIR008
     C                   PARM                    BJDFIN
     C                   PARM                    BGPFMG
     C                   PARM                    BNDCSP
     C                   PARM                    CrIRScnFmt
     C**********         PARM                    PDealSts                                    BUG5871
     C                   PARM                    #1STAT                                      BUG5871
      ***Sign*of Short Term Rate                                                     BUG5181 BUG6472
     C**********         PARM                    #0SIGN                              BUG5181 BUG6472

      ** Data substitution

     C                   CALLB     'APDTASUBS'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      GHSUBS        PSubsChar
     C                   PARM      TranInCACF    IncDATA
     C                   PARM      CrIRScnFmt    CurDATA

     C                   MOVEL     IncDATA       TranInCACF

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
     C                   PARM                    CIR008
     C                   PARM                    BJDFIN
     C                   PARM                    BGPFMG
     C                   PARM                    BNDCSP
     C                   PARM                    CrIRScnFmt
     C**********         PARM                    PDealSts                                    BUG5871
     C                   PARM                    #1STAT                                      BUG5871
      ***Sign*of Short Term Rate                                                     BUG5181 BUG6472
     C**********         PARM                    #0SIGN                              BUG5181 BUG6472

     C                   CALLB     'IRCACFAMD'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    TranInCACF
     C                   PARM                    CrIRScnFmt
     C                   PARM                    CrIRFilFmt
     C*******************PARM      'N'           PResetErrs                                   CDL038
     C                   PARM      'Y'           PResetErrs                                   CDL038
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

     C                   EVAL      OKPaySSI  = *ALL'Y'
     C                   EVAL      OKRcvSSI  = *ALL'Y'
     C                   EVAL      OKFraSSI  = *ALL'Y'

     C                   MOVE      *ALL'Y'       OKFEBO

     C                   RESET                   PayDat
     C                   RESET                   RecDat

      ** Numeric fields within 'NwIRFilFmt' have to be reset explicitly
      ** as there are long alpha fileds overlapping these which cause
      ** the CLEAR to put blanks in the numeric fields

     C                   CLEAR                   NwIRFilFmt

     C                   EVAL      RPRSTM = *ZERO
     C**********         EVAL      RPROBN = *ZERO                                             CSD027
     C**********         EVAL      RPROCN = *ZERO                                             CSD027
     C                   EVAL      RPPSTM = *ZERO
     C**********         EVAL      RPPOBN = *ZERO                                             CSD027
     C**********         EVAL      RPPOCN = *ZERO                                             CSD027
     C                   EVAL      RPTRTSP = *ZERO                                           BUG4044
     C                   EVAL      RPTEINR = *ZERO                                           BUG4044
     C                   EVAL      RPTINFD = *ZERO                                           BUG4044
     C                   EVAL      RPTSLIP = *ZERO                                           BUG4044
     C                   EVAL      RPTNICD = *ZERO                                           BUG4044
     C                   EVAL      RPTICBD = *ZERO                                           BUG4044
     C                   EVAL      RPTICFR = *ZERO                                           BUG4044
     C                   EVAL      RPTNIPD = *ZERO                                           BUG4044
     C                   EVAL      RPTIPBD = *ZERO                                           BUG4044

      ** Have to clear the settlement data structure, or the packed
      ** numeric fields are not initialised correctly

     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt
                                                                                             BUG7923
     C                   CLEAR                   DATA                                        BUG7923

     C                   ENDSR
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

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdate -  Call IRCACFUPD to perform write/update/          *
      *              authorise/delete of deals.                       *
      *                                                               *
      *****************************************************************
     C     SrUpdate      BEGSR

      ** If deal number not defined (on Insert), get next available

     C                   IF        #0DLNO = *BLANKS
     C                   EXSR      SrSetupDLNO
     C                   ENDIF

      ** For insert, load the settlement details (use the file format) and
      ** other relevant fields for update.

     C                   IF        (#0ACCD = 'I') OR (#0ACCD = 'A')

     C                   MOVEL     FLPAY         CACFPayIns
     C                   MOVEL     FLREC         CACFRecIns
     C                   MOVEL     FLIRS         CACFFraIns

     C                   EVAL      RPPSTM = FLPSTM
     C                   EVAL      RPPONS = FLPONS
     C                   EVAL      RPPOBR = FLPOBR
     C                   EVAL      RPPOBR = FLPOBR
     C                   EVAL      RPPSCY = FLPSCY
     C                   EVAL      RPCVMR = FLCVMR
     C                   EVAL      RPIC72 = FLIC72
      *
     C                   EVAL      RPRSTM = FLRSTM
     C                   EVAL      RPRONS = FLRONS
     C                   EVAL      RPROBR = FLROBR
     C                   EVAL      RPRSCY = FLRSCY

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

      ** Setup the Valid file with 'Automatic Authorisation' from
      ** Interface file IRRPIFPD

     C                   IF        CAP056 = 'Y'
     C                             OR CAP051 = 'Y'                                          BUG6671
     C                   EVAL      RPAUTH = AUTH
     C                   ENDIF

     C                   ENDIF
                                                                                             BUG8560
      * If CIR006 is OFF then RPUPFE was setup in VAL module                                 BUG8560
     C                   If        CIR006 <> 'Y'                                             BUG8560
     C                   EVAL      WRPUPFE = RPUPFE                                          BUG8560
     C                   EVAL      WRPUPVD = RPUPVD                                          BUG8560
     C                   EndIf                                                               BUG8560

     C                   IF        CAP041 = 'Y' AND Idx = 0                                  BUG4390
     C/COPY QWINDSRC,IRCACFMOV2
     C                   ENDIF                                                               BUG4390

      ** Update Valid fields

      * If CIR006 is OFF then RPUPFE was setup in VAL module                                 BUG8560
     C                   If        CIR006 <> 'Y'                                             BUG8560
     C                   EVAL      RPUPFE = WRPUPFE                                          BUG8560
     C                   EVAL      RPUPVD = WRPUPVD                                          BUG8560
     C                   EndIf                                                               BUG8560
                                                                                             BUG8560
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
     C                   MOVEL     #0DLNO        RPDLNO
     C                   EVAL      RPCHTP = #0ACCD
     C                   EVAL      RPFRNT = APFOTranID

      ** Update timestamp field

     C                   EVAL      RPTMESTMP = PTimeStamp

      ** Deals file Updates

     C                   CALLB     'IRCACFUPD'
      ** INPUT:
      ** Return Code
      ** Mode of Operation
      ** Deal Transaction in File format
      ** Screen Input
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    ModeOfOp
     C                   PARM                    NwIRFilFmt
     C                   PARM      'N'           PScreenInpt       1

      ** Default Branch for ZMUSER
      ** Bank Details (SDBANKPD)
      ** General Ledger ICD (SDGELRPD)
      ** Trading ICD (SDTRADPD)
      ** Retail ICD (SDRETLPD)
      ** FRA/IRS ICD (SDFAISPD)
     C                   PARM                    DBRN
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDTRAD
     C                   PARM                    SDRETL
     C                   PARM                    SDFAIS

      ** Business Day Convention
      ** Amortisation of Caps/Collars/Floors
      ** 24x7 Midas Availability
      ** CCRM Limits
      ** FRA/IRS Deals Authorisations
      ** Automatic Authorisation of Interface deals
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CSC011
     C                   PARM                    CDE001
     C                   PARM                    CIR008
     C                   PARM                    CAP056
                                                                                              CSW213
      ** Call DLRPIFVU - Midas DL Reporting Information Validate                              CSW213
      ** and Update                                                                           CSW213
                                                                                              CSW213
     C                   IF        CSW213 = 'Y'                                               CSW213
     C                   EXSR      SrCACFvu                                                   CSW213
     C                   ENDIF                                                                CSW213

      ** If there were any errors in the Update function,
      ** rollback and end this program

     C     RetCodeOut    IFNE      *BLANK
     C     RetCodeOut    ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   IF        (CSC022 = 'N')
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')
     C                   ROLBK
     C                   ENDIF
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        (CSC022 = 'N')
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')
     C                   COMMIT
     C                   ENDIF
     C                   EndIf

      ** If update not done due to record being updated by another
      ** workstation send message to screen.

     C                   IF        PRtCd = '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   ENDIF
      ***Blank*the Business Day Convention fields                                            BUG6377
      **********                                                                             BUG6377
     C**********         IF        CIR005 = 'Y'                                              BUG6377
     C**********         EVAL      BsDayConv = *BLANKS                                       BUG6377
     C**********         ENDIF                                                               BUG6377

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
     C                   MOVE      RPUPVD        UPVD
     C                   MOVE      RPUPFE        UPFE
     C                   MOVE      RPUPPR        UPPR
     C                   WRITE     DLDGREFF
     C                   ELSE
     C                   MOVE      RPUPVD        UPVD
     C                   MOVE      RPUPFE        UPFE
     C                   MOVE      RPUPPR        UPPR
     C                   UPDATE    DLDGREF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    BUG5403
      *****************************************************************         BUG5403
      * ValidatePC - Routine to validate principle change date schedules        BUG5403
      *****************************************************************         BUG5403
     C     ValidatePC    BEGSR                                                  BUG5403
      ** Principle change                                                       BUG5403
     C     #0ONPCD       IFNE      *BLANKS                                      BUG5403
     C     PCSA(1)       ORNE      *BLANKS                                                   BUG7046
     C                   MOVEL     RPDLNO        WDealNo                        BUG5403
     C                   IF        #0MDAT <> *BLANKS                            BUG5403
     C                   EVAL      InDate = #0MDAT                              BUG5403
      ** Convert date from DDMMYY to Midas day number                           BUG5403
     C                   CALLB     'ZDATE1'                                     BUG5403
     C                   PARM                    InDate                         BUG5403
     C                   PARM                    InDateMDN                      BUG5403
     C                   PARM                    BJDFIN                         BUG5403
     C                   PARM                    ErrorFlag                      BUG5403
     C                   Z-ADD     InDateMDN     CMDYN             5 0          BUG5403
     C                   ELSE                                                   BUG5403
     C                   Z-ADD     0             CMDYN                          BUG5403
     C                   ENDIF                                                  BUG5403
     C                   EVAL      PValType = 'P'                               BUG5403
     C*******************EVAL      POurTheir= ' '                               BUG5403BUG5964
     C*******************EVAL      POurTheir= 'U'                                     BUG5964BUG6386
     C                   EVAL      POurTheir= ' '                                            BUG6386
     C                   MOVEL     *BLANKS       SDATENAME        10            BUG5453
     C                   MOVEL     'SDATEOPC'    SDATENAME                      BUG5453
     C                   MOVEL     *BLANKS       SCHEDNAME        35            BUG5453
     C                   MOVEL     PrinChg       SCHEDNAME                      BUG5453
     C                   EXSR      CheckCurr                                    BUG5403
     C                   EVAL      X=%LOOKUP('        ':PCSA)                   BUG5403
     C                   EVAL      I=1                                          BUG5403
     C                   EXSR      SRGetCtlDate                                 BUG5403
      * Default with control date                                               BUG5964
     C                   IF        X=1                                          BUG5964
     C                             and #0ONPCD <> *blanks                                    BUG7046
     C                   EVAL      PCSA(X)=#0ONPCD                              BUG5964
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
     C                             and #0ONPCD <> *blanks                                    BUG7046
     C                   EVAL      PCSA(X)=#0ONPCD                              BUG5964
     C                   ADD       1             X                              BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
     C                   DOW       I<X                                          BUG5403
                                                                                BUG5403
     C                   EVAL      PCHGSCH=PCSA(I)                              BUG5403
     C                   EVAL      InDate = PCDATE                              BUG5403
     C                   EVAL      CHol = PCCHOL                                BUG5403
     C                   EVAL      WAmount=*BLANKS                              BUG5403
     C                   EVAL      WAmount=PCAMT                                BUG5403
      *                                                                                       245692
     C     WAmount       IFEQ      *BLANKS                                                    245692
     C     FORMULAOPC    ANDNE     *BLANKS                                                    245692
     C                   EVAL      WAmount=SFORMAMOPC                                         245692
     C                   ENDIF                                                                245692
      *                                                                                       245692
     C                   EVAL      PDAT = PCPDAT                                BUG5403
                                                                                BUG5403
     C                   MOVEL     PCDATE        MSGDATE           6            BUG5453
     C                   EXSR      SRZEDIT                                      BUG5453
     C                   EXSR      CheckDate                                    BUG5403
                                                                                BUG5403
     C     INDATEMDN     LOOKUP    TPCMDAT                                24    BUG5403
     C                   IF        *IN24 = *ON                                  BUG5403
     C                   ADD       1             Idx                            BUG5403
     C*******************MOVEL     'DLM0150'     MsgIDArr(Idx)           BUG5403BUG5453
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                  BUG5453
                                                                                BUG5453
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5453 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5453
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG5403BUG5453
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C                   EVAL      TPCMDAT(I)=INDATEMDN                         BUG5403
     C                   EXSR      ConfHol                                      BUG5403
     C                   MOVEL     *BLANKS       SFORMAMT                       BUG5403
     C                   MOVEL     'SAMT'        SFORMAMT                       BUG5403
     C                   EXSR      CheckAmt                                     BUG5403
     C                   MOVE      PZFIELD       TPCAMT(I)                      BUG5403
     C                   IF        WZFIELD <> *BLANKS                           BUG5610
     C                   MOVE      WZFIELD       WAMT16           16            BUG5610
     C                   EVAL      %SUBST(PCSA(I):8:16)=WAMT16                  BUG5610
     C                   ENDIF                                                  BUG5610
                                                                                BUG5610
     C                   EXSR      CheckInDeInd                                 BUG5403
                                                                                BUG5403
     C                   ADD       1             I                              BUG5403
     C                   ENDDO                                                  BUG5403
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
     C                   IF        CZDATE <> #0ONPCD                            BUG5964
     C                   MOVEL     ZDATE         #0ONPCD                        BUG5964
     C                   MOVEL     ZDATE         #0TNPCD                        BUG5964
     C                   EVAL      RPUNPCD=ZDAYNO                               BUG5964
     C                   EVAL      RPTNPCD=ZDAYNO                               BUG5964
     C                   ADD       1             WIdx                           BUG5964
     C                   EVAL      WFldNamArr(WIdx) = '#0ONPCD'                 BUG5964
     C                   EVAL      WMsgIDArr(WIdx) = 'RS00055'                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5964
     C                   ENDIF                                                  BUG5964
     C                   ENDIF                                                  BUG5964
                                                                                BUG5403
      * Validate formula                                                        BUG5403
     C                   IF        Idx=0                                        BUG5403
     C                   EVAL      SFREQF = SFREQFOPC                           BUG5403
     C                   EVAL      SFORM = SFORMOPC                             BUG5403
     C                   MOVEL     *BLANKS       SFORMNAME                      BUG5403
     C                   MOVEL     'SFREQFOPC'   SFORMNAME                      BUG5403
     C                   IF        SFREQF = 'M' OR SFREQF = 'Q' OR              BUG5403
     C                             SFREQF = 'X' OR SFREQF = 'Y'                 BUG5403
     C                   EXSR      ValFormula                                   BUG5403
                                                                                BUG5403
      * Generate Dates                                                          BUG5403
     C                   IF        Idx=0 AND SFORM <> *BLANKS                   BUG5403
      * Amount must be specified                                                BUG5403
     C                   IF        SFORMAMOPC <> *BLANKS                        BUG5403
     C                   EVAL      WAmount=*BLANKS                              BUG5403
     C                   EVAL      WAmount=SFORMAMOPC                           BUG5403
     C                   MOVEL     *BLANKS       SFORMAMT                       BUG5403
     C                   MOVEL     'SFORMAMOPC'  SFORMAMT                       BUG5403
     C                   EXSR      CheckAmt                                     BUG5403
     C                   IF        WZFIELD <> *BLANKS                           BUG5610
     C                   MOVE      WZFIELD       SFORMAMOPC                     BUG5610
     C                   ENDIF                                                  BUG5610
                                                                                BUG5610
     C                   ELSE                                                   BUG5403
     C                   ADD       1             Idx                            BUG5403
     C                   MOVEL     'DLM0148'     MsgIDArr(Idx)                  BUG5403
     C                   EVAL      FldNameArr(Idx) = 'SFORMAMOPC'               BUG5403
     C                   ENDIF                                                  BUG5403
      * Increase/decrease flag must be specified                                BUG5403
     C                   IF        BGN2ST = 'Y'                                 BUG5403
     C                   IF        SFORMIDOPC = *BLANKS                         BUG5403
     C                   ADD       1             Idx                            BUG5403
     C                   MOVEL     'DLM1022'     MsgIDArr(Idx)                  BUG5403
     C                   EVAL      FldNameArr(Idx) = 'SFORMIDOPC'               BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
      *                                                                         BUG5403
     C                   IF        Idx=0                                        BUG5403
     C                   IF        X<>1                                         BUG5403
      *******************                                                       BUG5403BUG5964
     C*******************IF        #0ACCD = 'I' AND X>1                         BUG5403BUG5964
     C*******************EVAL      WCTLDYN = TPCMDAT(1)                         BUG5403BUG5964
     C*******************EVAL      I=1                                          BUG5403BUG5964
      *******************                                                       BUG5403BUG5964
     C*******************DOW       I<X                                          BUG5403BUG5964
     C*******************IF        TPCMDAT(I) < WCTLDYN                         BUG5403BUG5964
     C*******************EVAL      WCTLDYN = TPCMDAT(I)                         BUG5403BUG5964
     C*******************ENDIF                                                  BUG5403BUG5964
     C*******************ADD       1             I                              BUG5403BUG5964
     C*******************ENDDO                                                  BUG5403BUG5964
      *******************                                                       BUG5403BUG5964
     C*******************ENDIF                                                  BUG5403BUG5964
      *******************                                                       BUG5403BUG5964
     C                   MOVEL     SFORM         FFDATC                         BUG5403
     C                   MOVEL     WPSCY         FFCCY1                         BUG5403
     C                   MOVEL     *BLANK        FFCCY2                         BUG5403
     C                   MOVE      *BLANK        FFCCY3                         BUG5403
     C                   Z-ADD     *ZERO         PRDT                           BUG5403
     C                   EVAL      K=X                                          BUG5403
     C                   MOVEA     TPCMDAT       WMDATE                         BUG5403
     C                   MOVEA     TPCAMT        WPCAMT                         BUG5403
     C                   EXSR      GENDATES                                     BUG5403
     C                   MOVEA     WPCAMT        TPCAMT                         BUG5403
     C                   MOVEA     WMDATE        TPCMDAT                        BUG5403
     C                   EVAL      L = 1                                        BUG5403
     C                   DOW       L < K                                        BUG5403
                                                                                BUG5403
      ** Check if it is a saturday or a sunday                                  BUG5403
      ** and treat it as holiday                                                BUG5403
                                                                                BUG5403
     C                   EVAL      WRK153 = TPCMDAT(L)/7                        BUG5403
     C                   MOVE      WRK153        WRK30                          BUG5403
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG5403
     C                   EVAL      %SUBST(PCSA(L):7:1)='Y'                      BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C                   EVAL      ZDAYNO =  TPCMDAT(L)                         BUG5403
     C                   CALLB     'ZDATE2'                                     BUG5403
     C                   PARM                    ZDAYNO                         BUG5403
     C                   PARM                    BJDFIN                         BUG5403
     C                   PARM      *ZEROS        ZDATE                          BUG5403
     C                   PARM      *BLANKS       ZADATE            7            BUG5403
                                                                                BUG5403
     C                   MOVEL     ZDATE         PCSA(L)                        BUG5403
     C                   ADD       1             L                              BUG5403
     C                   ENDDO                                                  BUG5403
     C                   ELSE                                                   BUG5403
     C                   ADD       1             Idx                            BUG5403
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)                  BUG5403
     C                   EVAL      FldNameArr(Idx) = 'SFREQFOPC'                BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5403
      *****************************************************************         BUG5403
      * CheckDate - Routine to validate date schedules                *         BUG5403
      *****************************************************************         BUG5403
     C     CheckDate     BEGSR                                                  BUG5403
     C                   EVAL      WHoliday = ' '                               BUG5403
      ** Convert date from DDMMYY to Midas day number and check                 BUG5403
      ** for valid date.                                                        BUG5403
     C                   CALLB     'ZDATE1'                                     BUG5403
     C                   PARM                    InDate                         BUG5403
     C                   PARM                    InDateMDN                      BUG5403
     C                   PARM                    BJDFIN                         BUG5403
     C                   PARM                    ErrorFlag         1            BUG5403
                                                                                BUG5403
     C                   IF        ErrorFlag='Y'                                BUG5403
     C                   ADD       1             Idx                            BUG5403
     C****************** MOVEL     'DLM0142'     MsgIDArr(Idx)           BUG5403BUG5453
     C                   MOVEL     'DLM2003'     MsgIDArr(Idx)                  BUG5453
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5453 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5453
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG5403BUG5453
     C                   ENDIF                                                  BUG5403
      * If date is not processed, validate                                      BUG5403
     C                   IF        PDAT <> 'Y' AND PDAT <> 'y'                  BUG5403
     C* Date must be after the value date                                       BUG5403
                                                                                BUG5403
     C     InDateMDN     IFLT      RPVDAT                                       BUG5403
     C     InDateMDN     OREQ      RPVDAT                                       BUG5403
     C                   ADD       1             Idx                            BUG5403
     C*******************MOVEL     'DLM0143'     MsgIDArr(Idx)           BUG5403BUG5453
     C                   MOVEL     'DLM2004'     MsgIDArr(Idx)                  BUG5453
                                                                                BUG5453
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5453 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5453
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG5403BUG5453
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C* Date must be before the maturity date                                   BUG5403
                                                                                BUG5403
     C     InDateMDN     IFGT      RPMDAT                                       BUG5403
     C                   ADD       1             Idx                            BUG5403
     C*******************MOVEL     'DLM0168'     MsgIDArr(Idx)           BUG5403BUG5453
     C                   MOVEL     'DLM2005'     MsgIDArr(Idx)                  BUG5453
                                                                                BUG5453
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5453 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5453
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG5403BUG5453
     C                   ENDIF                                                  BUG5403
      **************************************************************************BUG5403BUG5964
      ***Date*cannot*be*less*than*the*control*date*for*principal****************BUG5403BUG5964
      ***change*****************************************************************BUG5403BUG5964
      ** Date cannot be less than the last processed date                       BUG5964
     C     InDateMDN     IFLT      WCTLDYN                                      BUG5403
     C     WCTLDYN       ANDNE     *ZEROS                                       BUG5964
     C                   ADD       1             Idx                            BUG5403
     C*******************MOVEL     'DLM0176'     MsgIDArr(Idx)           BUG5403BUG5453
     C*******************MOVEL     'DLM2006'     MsgIDArr(Idx)                  BUG5453BUG5964
     C                   MOVEL     'DLM2007'     MsgIDArr(Idx)                  BUG5964
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5453 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5453
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG5403BUG5453
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
      ** Action code is 'I' and date already existing from file                 BUG5403
                                                                                BUG5403
     C                   IF         #0ACCD = 'I'                                BUG5403
     C                   EVAL       WPCSCFound = 'N'                            BUG5403
     C     KCFPC         CHAIN     DLPCSCD0                                     BUG5403
     C                   IF        %FOUND                                       BUG5403
     C                   EVAL      WPCSCFound = 'Y'                             BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C                   IF        (WPCSCFound = 'Y')                           BUG5403
     C                   ADD       1             Idx                            BUG5403
     C*******************MOVEL     'DLM0150'     MsgIDArr(Idx)           BUG5403BUG5453
     C                   MOVEL     'DLM2002'     MsgIDArr(Idx)                  BUG5453
                                                                                BUG5453
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5453 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5453
     C*******************EVAL      FldNameArr(Idx) = 'SDATE'             BUG5403BUG5453
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   EVAL      PBDCCcyArr = PBDCCcy                         BUG5403
     C                   EVAL      WHoliday = 'N'                               BUG5403
                                                                                BUG5403
      ** Check if date is a holiday                                             BUG5403
                                                                                BUG5403
                                                                                BUG5403
     C                   IF        WVALBDC = 'N' OR                             BUG5403
     C                             WVALBDC = 'Y' AND  PBDCCcyArr(1) = *BLANK    BUG5403
     C                   Z-ADD     InDateMDN     PZDateIn                       BUG5403
     C                   CALLB     'ZCHKH'                                      BUG5403
     C                   PARM                    PZDateIn          5 0          BUG5403
     C                   PARM      #0CUCY        PZCcy             3            BUG5403
     C                   PARM      *BLANK        PZLoc             3            BUG5403
     C                   PARM      *BLANK        PZHol             1            BUG5403
                                                                                BUG5403
      ** Set a flag to be use in updating 'Confirmed Holiday' indicator         BUG5403
      ** when the date is a holiday                                             BUG5403
                                                                                BUG5403
     C                   IF        PZHol = 'H'                                  BUG5403
     C                   EVAL      WHoliday = 'Y'                               BUG5403
     C                   ELSE                                                   BUG5403
                                                                                BUG5403
      ** Else, if not a holiday, check if it is a saturday or a sunday          BUG5403
      ** and treat it as holiday                                                BUG5403
                                                                                BUG5403
     C                   EVAL      WRK153 = InDateMDN/7                         BUG5403
     C                   MOVE      WRK153        WRK30                          BUG5403
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG5403
     C                   EVAL      WHoliday = 'Y'                               BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C                   ELSE                                                   BUG5403
                                                                                BUG5403
     C                   IF        WHoliday <> 'Y'                              BUG5403
     C                   Z-ADD     InDateMDN     PZDateIn                       BUG5403
     C                   CALLB     'ZCHKH'                                      BUG5403
     C                   PARM                    PZDateIn                       BUG5403
     C                   PARM      #0CUCY        PZCcy                          BUG5403
     C                   PARM      *BLANK        PZLoc                          BUG5403
     C                   PARM      *BLANK        PZHol                          BUG5403
                                                                                BUG5403
     C                   IF        PZHol = 'H'                                  BUG5403
     C                   EVAL      WHoliday = 'Y'                               BUG5403
     C                   ELSE                                                   BUG5403
                                                                                BUG5403
      ** Else, if not a holiday, check if it is a saturday or a sunday          BUG5403
      ** and treat it as holiday                                                BUG5403
                                                                                BUG5403
     C                   EVAL      WRK153 = InDateMDN/7                         BUG5403
     C                   MOVE      WRK153        WRK30                          BUG5403
     C                   IF        (WRK30 = 142) OR (WRK30 = 285)               BUG5403
     C                   EVAL      WHoliday = 'Y'                               BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5403
      ********************************************************************      BUG5403
      *                                                                  *      BUG5403
      * SRGetCtlDate - Get Control Date                                  *      BUG5403
      *                                                                  *      BUG5403
      ********************************************************************      BUG5403
                                                                                BUG5403
     C     SRGetCtlDate  BEGSR                                                  BUG5403
                                                                                BUG5403
    *****Get*control*date*-*the*first*non-processed*date**********************  BUG5403BUG5964
      ** Get control date - the last processed date                             BUG5964
                                                                                BUG5403
     C                   EVAL      PRDT = *ZERO                                 BUG5403
     C                   EVAL      WCTLDYN = *ZERO                              BUG5403
                                                                                BUG5403
      * Principle Change                                                        BUG5403
     C                   IF        PValType = 'P'                               BUG5403
     C     KIRSDL        SETLL     DLPCSCD0                                     BUG5403
     C     KIRSDP        READE     DLPCSCD0                               30    BUG5403
                                                                                BUG5403
     C                   DOW       (*IN30 = *OFF) AND                           BUG5403
     C                             (WCTLDYN = *ZERO)                            BUG5403
     C*******************IF        DTPR <> 'Y'                                  BUG5403BUG5964
     C                   IF        DTPR = 'Y' OR DTPR = 'y'                     BUG5964
     C                   Z-ADD     PRDT          WCTLDYN                        BUG5403
     C                   ENDIF                                                  BUG5403
     C     KIRSDP        READE     DLPCSCD0                               30    BUG5403
     C                   ENDDO                                                  BUG5403
                                                                                BUG5403
     ****If*nothing*was*found, default control date to next principal           BUG5403BUG5964
     ****change*date*****                                                       BUG5403BUG5964
     ********************                                                       BUG5403BUG5964
     C*******************IF        (WCTLDYN = *ZERO)                            BUG5403BUG5964
     C*******************CALLB     'ZDATE1'                                     BUG5403BUG5964
     C*******************PARM      #0ONPCD       SCDate            6            BUG5403BUG5964
     C*******************PARM                    MidDate           5 0          BUG5403BUG5964
     C*******************PARM                    BJDFIN                         BUG5403BUG5964
     C*******************PARM                    ErrorFlag                      BUG5403BUG5964
     C*******************EVAL      WCTLDYN = MidDate                            BUG5403BUG5964
     C*******************ENDIF                                                  BUG5403BUG5964
     C                   ENDIF                                                  BUG5403
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5403
      *****************************************************************         BUG5403
      * CheckAmt - Routine to validate amount in date schedules       *         BUG5403
      *****************************************************************         BUG5403
     C     CheckAmt      BEGSR                                                  BUG5403
                                                                                BUG5403
      ** Check amount if numeric                                                BUG5403
                                                                                BUG5403
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
     C**********         MOVE      *BLANKS       WZFIELD                              BUG5610 245692
     C**********         MOVE      WAmount       PZFIELD                              BUG5403 245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      WAmount       @@ALPH                                       245692
     C                   Z-ADD     PZADEC        @@IDP                                        245692
     C                   Z-ADD     PZADIG        @@IINT                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
     C**********         CALLB     'ZALIGN'                                           BUG5403 245692
     C**********         PARM                    PZALIGNOK         1                  BUG5403 245692
     C**********         PARM                    PZFIELD          16                  BUG5403 245692
     C**********         PARM                    PZADEC            1 0                BUG5403 245692
     C**********         PARM                    PZADIG            2 0                BUG5403 245692
     C                   CALLB     'ZA0840'                                                   245692
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
                                                                                BUG5403
      ** Amount not valid                                                       BUG5403
                                                                                BUG5403
     C**********         IF        (PZALIGNOK = 'N') OR (PZFIELD = *ALL'0')           BUG5403 245692
     C     @@ERCD        IFNE      0                                                          245692
     C     @@AMT         OREQ      0                                                          245692
     C                   EVAL      Idx = Idx + 1                                BUG5403
     C                   IF        SFORMAMT = 'SAMT'                            BUG5453
     C                   MOVEL     'DLM2011'     MsgIDArr(Idx)                  BUG5453
                                                                                BUG5453
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5453 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5453
     C                   ELSE                                                   BUG5453
     C                   EVAL      MsgIDArr(Idx) = 'DLM0149'                    BUG5403
     C                   EVAL      FldNameArr(Idx) = SFORMAMT                   BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ELSE                                                   BUG5610
     C**********         CALLB     'ZEDIT'                                            BUG5610 245692
     C**********         PARM      PZFIELD       WZFIELD          16                  BUG5610 245692
     C**********         PARM                    PZADEC                               BUG5610 245692
     C                   MOVE      @@ALPH        WZFIELD          16                          245692
     C                   MOVE      @@AMT         PZFIELD          16                          245692
     C                   ENDIF                                                  BUG5453
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5403
      *****************************************************************         BUG5403
      * CheckCurr- Routine to access currency details                 *         BUG5403
      *****************************************************************         BUG5403
     C     CheckCurr     BEGSR                                                  BUG5403
                                                                                BUG5403
      ** Access currency details to get the number of decimal places            BUG5403
     C                   CALL      'AOCURRR0'                                   BUG5403
     C                   PARM      *BLANKS       PRtcd                          BUG5403
     C                   PARM      '*KEY   '     POptn                          BUG5403
     C                   PARM      #0CUCY        PCcy                           BUG5403
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG5403
                                                                                BUG5403
     C                   MOVE      A6NBDP        WONBDP                         BUG5403
      *                                                                         BUG5403
      ** Get decimal places for settlement currencies, if used                  BUG5403
      *                                                                         BUG5403
     C     RPPSCY        IFNE      *BLANK                                       BUG5403
     C                   CALL      'AOCURRR0'                                   BUG5403
     C                   PARM      *BLANKS       PRtcd                          BUG5403
     C                   PARM      '*KEY   '     POptn                          BUG5403
     C                   PARM      RPPSCY        PCcy                           BUG5403
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG5403
     C                   MOVE      A6NBDP        WPNBDP                         BUG5403
     C                   MOVE      RPPSCY        WPSCY                          BUG5403
     C                   ELSE                                                   BUG5403
     C                   MOVE      #0CUCY        WPSCY                          BUG5403
     C                   MOVE      WONBDP        WPNBDP                         BUG5403
     C                   ENDIF                                                  BUG5403
      *                                                                         BUG5403
     C     RPRSCY        IFNE      *BLANK                                       BUG5403
     C                   CALL      'AOCURRR0'                                   BUG5403
     C                   PARM      *BLANKS       PRtcd                          BUG5403
     C                   PARM      '*KEY   '     POptn                          BUG5403
     C                   PARM      RPRSCY        PCcy                           BUG5403
     C     SDCURR        PARM      SDCURR        DSSDY                          BUG5403
     C                   MOVE      A6NBDP        WRNBDP                         BUG5403
     C                   MOVE      RPRSCY        WRSCY                          BUG5403
     C                   ELSE                                                   BUG5403
     C                   MOVE      #0CUCY        WRSCY                          BUG5403
     C                   MOVE      WONBDP        WRNBDP                         BUG5403
     C                   ENDIF                                                  BUG5403
      *                                                                         BUG5403
     C                   Z-ADD     0             PZADEC            1 0                        245692
     C                   Z-ADD     0             PZADIG            2 0                        245692
     C                   EVAL      PZADEC = WPNBDP                              BUG5403
     C                   EVAL      PZADIG = 15 - PZADEC                         BUG5403
      *                                                                         BUG5403
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5403
      *****************************************************************         BUG5403
      * ConfHol - Routine to validate confirm holiday flag            *         BUG5403
      *****************************************************************         BUG5403
     C     ConfHol       BEGSR                                                  BUG5403
      *                                                                         BUG5403
      **  Confirmed holiday ind. must be 'Y' if date is a holiday, else *BLANK  BUG5403
      *                                                                         BUG5403
     C                   IF        WHoliday='Y' AND CHol<>'Y'                   BUG5403
     C                             OR WHoliday='N' AND CHol='Y'                 BUG5403
     C                   EVAL      Idx = Idx + 1                                BUG5403
     C*******************EVAL      MsgIDArr(Idx) = 'DLM0146'             BUG5403BUG5453
     C                   MOVEL     'DLM2008'     MsgIDArr(Idx)                  BUG5453
                                                                                BUG5453
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5453 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5453
     C*******************EVAL      FldNameArr(Idx) = 'SCOL'              BUG5403BUG5453
     C                   ENDIF                                                  BUG5403
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5403
      *****************************************************************         BUG5403
      * CheckInDeInd - Routine to validate increase/decrease flag     *         BUG5403
      *****************************************************************         BUG5403
     C     CheckInDeInd  BEGSR                                                  BUG5403
     C                   IF        BGN2ST = 'Y'                                 BUG5403
     C                   IF        PCIDFLG = *BLANKS                            BUG5403
     C                   ADD       1             Idx                            BUG5403
     C*******************MOVEL     'DLM1022'     MsgIDArr(Idx)           BUG5403BUG5453
     C                   MOVEL     'DLM2009'     MsgIDArr(Idx)                  BUG5453
                                                                                BUG5453
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5453 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5453
     C*******************EVAL      FldNameArr(Idx) = 'SPIDF'             BUG5403BUG5453
     C                   ELSE                                                   BUG5403
     C                   IF        PCIDFLG <> 'D' AND PCIDFLG <> 'I'            BUG5403
     C                   ADD       1             Idx                            BUG5403
     C*******************MOVEL     'DLM1021'     MsgIDArr(Idx)           BUG5403BUG5453
     C                   MOVEL     'DLM2010'     MsgIDArr(Idx)                  BUG5453
                                                                                BUG5453
     C**********         EVAL      MsgDtaArr(Idx)=MSGDATE+SCHEDNAME                 BUG5453 MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATE)                  MD000091
     C                   EVAL      BLen = %Len(%Trim(SCHEDNAME))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MsgDtaArr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SCHEDNAME)                MD000091
     C                   EVAL      FldNameArr(Idx) = %TRIM(SDATENAME)+%TRIM(T)  BUG5453
     C*******************EVAL      FldNameArr(Idx) = 'SPIDF'             BUG5403BUG5453
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5403
      *****************************************************************         BUG5403
      * ValFormula - Routine to validate formula                      *         BUG5403
      *****************************************************************         BUG5403
     C     ValFormula    BEGSR                                                  BUG5403
      *   Formula must be specified                                             BUG5403
     C                   IF        SFORM = *BLANKS                              BUG5403
     C                   ADD       1             Idx                            BUG5403
     C                   MOVEL     'DLM0153'     MsgIDArr(Idx)                  BUG5403
     C                   EVAL      FldNameArr(Idx) = SFORMNAME                  BUG5403
     C                   ELSE                                                   BUG5403
      *                                                                         BUG5403
      *   Date must be a formula                                                BUG5403
     C                   EVAL      *IN99=*OFF                                   BUG5403
      *                                                                         BUG5403
      **  Validate first two positions                                          BUG5403
      **    First two positions are mandatory                                   BUG5403
      *                                                                         BUG5403
     C                   IF        SDN1=*BLANK                                  BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**       Are positions 1&2 numeric  ?                                     BUG5403
     C*                                                                         BUG5403
     C                   MOVE      0             WRK3A             3            BUG5403
     C                   MOVEL     SDN1          WRK3A                          BUG5403
     C                   TESTN                   WRK3A                24        BUG5403
     C*                                                                         BUG5403
     C**       If SDN1   is numeric                                             BUG5403
     C*                                                                         BUG5403
     C                   IF        *IN24=*ON                                    BUG5403
     C                   MOVE      SDN1          WRK2N             2 0          BUG5403
     C*                                                                         BUG5403
     C**       Number must be between 1 and 28, or be 31.                       BUG5403
     C*                                                                         BUG5403
     C                   IF        WRK2N > 28 AND SDN1 <> '31'                  BUG5403
     C                             OR WRK2N < 1                                 BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**    If not numeric                                                      BUG5403
     C*                                                                         BUG5403
     C                   ELSE                                                   BUG5403
     C*                                                                         BUG5403
     C**   Position 1 to be numeric  1-4 incl                                   BUG5403
     C*                                                                         BUG5403
     C                   IF        SWRK1 < '1' OR SWRK1 > '4'                   BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**  1ST character valid - check 2ND is in array of day in week codes      BUG5403
     C*                                                                         BUG5403
     C     SWRK2         LOOKUP    LETT                                   24    BUG5403
     C                   IF        *IN24 = *OFF                                 BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**  End of non-numeric validation                                         BUG5403
     C*                                                                         BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**  Validate position 3                                                   BUG5403
     C*                                                                         BUG5403
     C**  If position 1/2 is 31, pos 3 must be blank, or 4,5,6 have entry       BUG5403
     C**  If position 1 and 2 are not '31' pos.3 must be '+' or '-'             BUG5403
     C*                                                                         BUG5403
     C*                                                                         BUG5403
     C                   IF        SDN1 = '31' AND SWRK3 <> *BLANK              BUG5403
     C                             AND S456 = *BLANK                            BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C                   IF        SDN1 <> '31' AND SWRK3 <> '+'                BUG5403
     C                             AND SWRK3 <> '-'                             BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C                   IF        SDN1 = '31' AND SWRK3 <> '+'                 BUG5403
     C                             AND SWRK3 <> '-' AND SWRK3 <> ' '            BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**  Validate positions 4 and 5                                            BUG5403
     C**    If entered must be numeric, between 1 and 28 inclusive              BUG5403
     C*                                                                         BUG5403
     C                   IF        SDN2 <> *BLANK                               BUG5403
     C*                                                                         BUG5403
     C                   MOVE      0             WRK3A                          BUG5403
     C                   MOVEL     SDN2          WRK3A                          BUG5403
     C                   TESTN                   WRK3A                24        BUG5403
     C*                                                                         BUG5403
     C**  Not valid numeric                                                     BUG5403
     C*                                                                         BUG5403
     C                   IF        *IN24 = *OFF                                 BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ELSE                                                   BUG5403
     C*                                                                         BUG5403
     C**  Valid number, check range                                             BUG5403
     C*                                                                         BUG5403
     C                   MOVE      SDN2          WRK2N                          BUG5403
     C                   IF        WRK2N < 1 OR WRK2N > 28                      BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**  End of numeric validation for pos 4/5                                 BUG5403
     C*                                                                         BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**  Validate position 6                                                   BUG5403
     C*                                                                         BUG5403
     C**    If positions 4 and 5 are entered pos.6 must be A,B or C             BUG5403
     C*                                                                         BUG5403
     C                   IF        SDN2 <> *BLANK AND SWRK6 <> 'A'              BUG5403
     C                             AND SWRK6 <> 'B' AND SWRK6 <> 'C'            BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**  Validate position 7                                                   BUG5403
     C*                                                                         BUG5403
     C**  If position 6 is 'A' then pos 7 must be '+' or'-'                     BUG5403
     C**  otherwise it must be blank.                                           BUG5403
     C*                                                                         BUG5403
     C                   IF        SWRK6 = 'A'                                  BUG5403
     C                   IF        SWRK7 <> '+' AND SWRK7 <> '-'                BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C                   ELSE                                                   BUG5403
     C                   IF        SWRK7 <> ' '                                 BUG5403
     C                   EVAL      *IN99=*ON                                    BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C                   IF        *IN99=*ON                                    BUG5403
     C                   EVAL      Idx = Idx + 1                                BUG5403
     C                   EVAL      MsgIDArr(Idx) = 'DLM0154'                    BUG5403
     C                   EVAL      FldNameArr(Idx) = SFORMNAME                  BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**  Get DD/MM/YY format of date, and month and year                       BUG5403
     C*                                                                         BUG5403
     C                   IF        WCTLDYN <> 0 AND Idx=0                       BUG5403
     C                   EVAL      ZDAYNO = WCTLDYN                             BUG5403
     C                   EXSR      SRZDATE2                                     BUG5403
     C                   ELSE                                                   BUG5403
      *   If no start date present, formula cannot be used                      BUG5403
     C                   Z-ADD     *ZERO         YRNO                           BUG5403
     C                   Z-ADD     *ZERO         MTHN                           BUG5403
     C                   ADD       1             Idx                            BUG5403
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)                  BUG5403
     C                   EVAL      FldNameArr(Idx) = SFORMNAME                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5403
      *****************************************************************         BUG5403
      * GENDATES - Routine to generate dates                          *         BUG5403
      *****************************************************************         BUG5403
     C     GENDATES      BEGSR                                                  BUG5403
     C*                                                                         BUG5403
     C**  Calculate next settlement date using SR.FFDATE                        BUG5403
     C*                                                                         BUG5403
     C                   DOW       PRDT < CMDYN                                 BUG5403
     C                   Z-ADD     YRNO          FFYR                           BUG5403
     C                   Z-ADD     MTHN          FFMTH                          BUG5403
     C                   MOVE      *BLANKS       FFLOC                          BUG5403
      *                                                                         BUG5403
      **  Bypass call to FFDATE if Bus. Day Conventions Enhancement on.         BUG5403
      *                                                                         BUG5403
     C                   IF        CIR005 = 'Y'                                 BUG5403
     C                   MOVEA     PBDCCcyArr    FFPCCY           30            BUG5403
     C                   CALL      'DLZIRF'                                     BUG5403
     C                   PARM                    FFDATC                         BUG5403
     C                   PARM                    FFMTH                          BUG5403
     C                   PARM                    FFYR                           BUG5403
     C                   PARM                    FFPCCY                         BUG5403
     C                   PARM                    FFLOC                          BUG5403
     C                   PARM                    BJDFIN                         BUG5403
     C                   PARM                    WADJWD            5 0          BUG5403
     C                   PARM                    PBSDAY            5 0          BUG5403
      *                                                                         BUG5403
     C                   IF        PRDT >= WADJWD                               BUG5403
     C                   MOVE      PBSDAY        PRDT                           BUG5403
     C                   ELSE                                                   BUG5403
     C                   MOVE      WADJWD        PRDT                           BUG5403
     C                   ENDIF                                                  BUG5403
      *                                                                         BUG5403
     C                   ELSE                                                   BUG5403
     C**********         CALL      'FFDATE'                                     BUG5403       240240
     C                   CALLB     'FFDATE'                                                   240240
      ** Return code (10A, returned to caller)                                  BUG5403
     C                   PARM                    ReturnCode                     BUG5403
      ** Working day (5,0P)                                                     BUG5403
     C                   PARM                    FFDAY             5 0          BUG5403
                                                                                BUG5403
      ** Parameters received from caller                                        BUG5403
      ** -------------------------------                                        BUG5403
      ** Date formula (7A)                                                      BUG5403
     C                   PARM                    FFDATC            7            BUG5403
      ** Month of required date (2,0P)                                          BUG5403
     C                   PARM                    FFMTH             2 0          BUG5403
      ** Year of required date (2,0P)                                           BUG5403
     C                   PARM                    FFYR              2 0          BUG5403
      ** Market currency (3A)                                                   BUG5403
     C                   PARM                    FFCCY1            3            BUG5403
      ** Market location (3A)                                                   BUG5403
     C                   PARM                    FFLOC             3            BUG5403
      ** Instrument currency (3A)                                               BUG5403
     C                   PARM                    FFCCY2            3            BUG5403
      ** Other currency (3A)                                                    BUG5403
     C                   PARM                    FFCCY3            3            BUG5403
      ** Date format indicator (1A, from RUNDAT or SDBANKPD)                    BUG5403
     C                   PARM                    BJDFIN                         BUG5403
                                                                                BUG5403
     C                   MOVE      FFDAY         PRDT                           BUG5403
     C                   ENDIF                                                  BUG5403
     C                   IF        PRDT < CMDYN AND PRDT >= WCTLDYN             BUG5403
     C     PRDT          LOOKUP    WMDATE                                 99    BUG5403
     C                   IF        *IN99 = *OFF                                 BUG5403
     C                   MOVE      PRDT          WMDATE(K)                      BUG5403
                                                                                BUG5403
     C                   MOVE      PZFIELD       WPCAMT(K)                      BUG5403
                                                                                BUG5403
     C                   EVAL      %SUBST(PCSA(K):8:16)=SFORMAMOPC              BUG5403
     C                   EVAL      %SUBST(PCSA(K):24:1)=SFORMIDOPC              BUG5403
                                                                                BUG5403
     C                   ADD       1             K                              BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**  Update year/month according to frequency                              BUG5403
     C*                                                                         BUG5403
     C                   IF        SFREQF = 'M'                                 BUG5403
     C                   ADD       1             MTHN                           BUG5403
     C                   ENDIF                                                  BUG5403
     C                   IF        SFREQF = 'Q'                                 BUG5403
     C                   ADD       3             MTHN                           BUG5403
     C                   ENDIF                                                  BUG5403
     C                   IF        SFREQF = 'X'                                 BUG5403
     C                   ADD       6             MTHN                           BUG5403
     C                   ENDIF                                                  BUG5403
     C                   IF        SFREQF = 'Y'                                 BUG5403
     C                   ADD       1             MTHN                           BUG5403
     C                   ENDIF                                                  BUG5403
     C*                                                                         BUG5403
     C**  If past end of year                                                   BUG5403
     C*                                                                         BUG5403
     C                   IF        MTHN > 12                                    BUG5403
     C                   ADD       1             YRNO                           BUG5403
     C                   SUB       12            MTHN                           BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDDO                                                  BUG5403
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5403
     C****************************************************************          BUG5403
     C*                                                              *          BUG5403
     C* CLEARIRCS - Clear Interest Rate Calendar date records        *          BUG5403
     C*                                                              *          BUG5403
     C****************************************************************          BUG5403
     C     CLEARIRCS     BEGSR                                                  BUG5403
      *                                                                         BUG5403
      ** Clear all dates for this transaction except those already              BUG5403
      ** processed.                                                             BUG5403
                                                                                BUG5403
      ** Clear all dates for this transaction except those already              BUG5403
      ** processed (Principal Change)                                           BUG5403
                                                                                BUG5403
     C                   IF        CAP041 = 'Y'                                 BUG5403
     C     KDTSC         SETLL     DLPCSCD0                                     BUG5403
     C     KDTSC         READE     DLPCSCD0                               98    BUG5403
                                                                                BUG5403
     C                   DOW       *IN98=*OFF                                   BUG5403
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG5403
     C                   DELETE    DLPCSCD0                                     BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C     KDTSC         READE     DLPCSCD0                               98    BUG5403
     C                   ENDDO                                                  BUG5403
     C                   ENDIF                                                  BUG5403
      *                                                                         BUG5403
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5403
      *****************************************************************         BUG5403
      * SUPVALIRC  - Set up valid Interest Rate Calendar details      *         BUG5403
      *****************************************************************         BUG5403
     C     SUPVALIRC     BEGSR                                                  BUG5403
     C                   IF        #0ACCD = 'A' OR #0ACCD = 'R'                 BUG5403
     C                             OR #0ACCD = 'X'                                            239130
     C                   MOVEL     RPDLNO        WDEALNO                        BUG5403
     C                   EXSR      CLEARIRCS                                    BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C                   IF        #0ACCD = 'I' OR #0ACCD = 'A'                 BUG5403
     C                             OR #0ACCD = 'X'                                            239130
     C                   MOVEL     RPDLNO        DLNO                           BUG5403
     C     #0ONPCD       IFNE      *BLANKS                                      BUG5403
     C     CAP041        ANDEQ     'Y'                                          BUG5403
     C*******************EVAL      OTIN = 'U'                                         BUG5403BUG6386
     C                   EVAL      OTIN = ' '                                                BUG6386
     C                   EVAL      X=%LOOKUP('        ':PCSA)                   BUG5403
     C                   EVAL      I=1                                          BUG5403
     C                   DOW       I<X                                          BUG5403
                                                                                BUG5403
     C                   EVAL      PCHGSCH=PCSA(I)                              BUG5403
     C                   EVAL      PRDT = TPCMDAT(I)                            BUG5403
     C                   EVAL      COHO = PCCHOL                                BUG5403
     C                   EVAL      DTPR = PCPDAT                                BUG5403
     C                   EVAL      PAMT = TPCAMT(I)                             BUG5403
     C                   EVAL      CAMT = 0                                     BUG5403
     C                   EVAL      PMTP = *BLANK                                BUG5403
     C                   IF        BGN2ST='Y'                                   BUG5403
     C                   EVAL      WPAMT = PAMT                                 BUG5403
                                                                                BUG5403
      ** Calculate for the new principal amount                                 BUG5403
                                                                                BUG5403
     C                   IF        PCIDFLG = 'D'                                BUG5403
     C                   Z-SUB     WPAMT         WPAMT                          BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
      ** If date entered is on or prior to the control date, add the change amouBUG5403
      ** to original principal amount                                           BUG5403
                                                                                BUG5403
     C                   IF        PRDT <= WCTLDYN                              BUG5403
     C                   EVAL      PAMT = RPUPAMT + WPAMT                       BUG5403
     C                   ELSE                                                   BUG5403
                                                                                BUG5403
      ** If date entered is between existing records, access the previous recordBUG5403
      ** change amount to the principal amount on this record                   BUG5403
                                                                                BUG5403
     C                   MOVEL     RPDLNO        WDealNo                        BUG5403
     C*******************EVAL      POurTheir= ' '                               BUG5403BUG5964
     C*******************EVAL      POurTheir= 'U'                                     BUG5964BUG6386
     C                   EVAL      POurTheir= ' '                                            BUG6386
     C     KIRSDL        SETLL     DLPCSCL0                                     BUG5403
     C                   READP     DLPCSCL0                                     BUG5403
                                                                                BUG5403
     C                   IF        NOT %EOF(DLPCSCL0) AND (WDealNo=XXDLNO) AND  BUG5403
     C                             (OTIN = XXOTIN)                              BUG5403
     C                   EVAL      PAMT = XXPAMT + WPAMT                        BUG5403
     C                   ELSE                                                   BUG5403
     C                   EVAL      PAMT = RPUPAMT + WPAMT                       BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C                   Z-ADD     WPAMT         CAMT                           BUG5403
     C                   ENDIF                                                  BUG5403
     C                   IF        DTPR <> 'Y' AND  DTPR <> 'y'                 BUG5403
     C                   WRITE     DLPCSCD0                                     BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
      ** Update records with processing dates greater than the processing       BUG5403
      ** date of the inserted record                                            BUG5403
                                                                                BUG5403
     C                   IF        BGN2ST = 'Y'                                 BUG5403
     C                   EXSR      SRUpdPCSC                                    BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C                   ADD       1             I                              BUG5403
     C                   ENDDO                                                  BUG5403
     C                   ENDIF                                                  BUG5403
     C                   ENDIF                                                  BUG5403
                                                                                BUG5403
     C                   ENDSR                                                  BUG5403
      *****************************************************************         BUG5403
      /EJECT                                                                    BUG5403
      ********************************************************************      BUG5403
      *                                                                  *      BUG5403
      * SRUpdPCSC - Change Principal Amount of affected record           *      BUG5403
      *                                                                  *      BUG5403
      ********************************************************************      BUG5403
                                                                                BUG5403
     C     SRUpdPCSC     BEGSR                                                  BUG5403
                                                                                BUG5403
     C     KIRSDL        SETGT     DLPCSCL0                                     BUG5403
     C     KIRSDP        READE     DLPCSCL0                                     BUG5403
                                                                                BUG5403
     C                   DOW       NOT %EOF(DLPCSCL0)                           BUG5403
     C                   EVAL      XXPAMT = XXPAMT + WPAMT                      BUG5403
     C                   UPDATE    DLPCSCX0                                     BUG5403
     C     KIRSDP        READE     DLPCSCL0                                     BUG5403
     C                   ENDDO                                                  BUG5403
                                                                                BUG5403
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5403
      ********************************************************************      BUG5403
      *                                                                  *      BUG5403
      * SRZDATE2  - Convert Midas Day Number                             *      BUG5403
      *                                                                  *      BUG5403
      ********************************************************************      BUG5403
                                                                                BUG5403
     C     SRZDATE2      BEGSR                                                  BUG5403
     C                   CALLB     'ZDATE2'                                     BUG5403
     C                   PARM                    ZDAYNO                         BUG5403
     C                   PARM                    BJDFIN                         BUG5403
     C                   PARM      *ZEROS        ZDATE                          BUG5403
     C                   PARM      *BLANKS       ZADATE            7            BUG5403
                                                                                BUG5403
     C                   MOVEL     ZDATE         DateDS                         BUG5403
                                                                                BUG5403
     C     BJDFIN        IFEQ      'M'                                          BUG5403
     C                   MOVE      DteMth        MTHN              2 0          BUG5403
     C                   ELSE                                                   BUG5403
     C                   MOVE      DteDay        MTHN                           BUG5403
     C                   ENDIF                                                  BUG5403
     C                   MOVE      DteYr         YRNO              2 0          BUG5403
     C                   ENDSR                                                  BUG5403
      /EJECT                                                                    BUG5453
      ********************************************************************      BUG5453
      *                                                                  *      BUG5453
      * SRZEDIT   - Format number                                        *      BUG5453
      *                                                                  *      BUG5453
      ********************************************************************      BUG5453
                                                                                BUG5453
     C     SRZEDIT       BEGSR                                                  BUG5453
     C                   MOVE      I             ZFIELD                         BUG5453
                                                                                BUG5453
     C                   CALLB     'ZEDIT'                                      BUG5453
     C                   PARM                    ZFIELD           16            BUG5453
     C                   PARM      0             ZADEC             1 0          BUG5453
                                                                                BUG5453
     C                   MOVE      ZFIELD        T                 3            BUG5453
     C                   ENDSR                                                  BUG5453
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
     C                   PARM      'S'           APRespMode
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
     C                   PARM                    APRpyQueue
     C                   PARM                    PTimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClearPgmQ

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW213
      *                                                               *                       CSW213
      * SrCACFvu - Call DLRPIFVU - Reporting Information Validate     *                       CSW213
      *            and Update                                         *                       CSW213
      *                                                               *                       CSW213
      *****************************************************************                       CSW213
     C     SrCACFvu      BEGSR                                                                CSW213
                                                                                              CSW213
      ** Set-up input fields                                                                  CSW213
                                                                                              CSW213
     C                   EVAL      RLAPID = 'CACF'                                            CSW213
                                                                                              CSW213
     C                   IF        #0ACCD = 'R'                                               CSW213
     C                   EVAL      RLACTN = 'D'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      RLACTN = #0ACCD                                            CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C                   EVAL      RLBRCA = #0BRCA                                            CSW213
     C                   EVAL      RLTRRF = #0DLNO                                            CSW213
     C                   EVAL      RLLTRF = #0LNKD                                            CSW213
     C                   EVAL      RLDTYP = #0DTYP                                            CSW213
     C                   EVAL      RLDLST = #0DLST                                            CSW213
     C                   EVAL      RLVALD = #0VDAT                                            CSW213
     C                   EVAL      RLCNUM = #0CNUM                                            CSW213
     C                   EVAL      RLBCCY = #0CUCY                                            CSW213
     C                   EVAL      RLSCCY = #0CUCY                                            CSW213
     C                   EVAL      RLFOID = APFOTranID                                        CSW213
     C                   EVAL      RLAFOI = APFOAsocID                                        CSW213
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
     C                   PARM                    #0PAMT                                     MD023734
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
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    InfData500
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
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
     C                   PARM                    Buffer2                                     BUG5403
     C                   PARM                    BufferEx2                                   BUG5403
     C                   PARM                    APIRetc           1

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,IRCACFM01

      ** Initialise variables

     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550

     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EVAL      PModuleID = 'IR'
     C                   EVAL      DtaQName = 'APCACFDTQ'
     C                   EVAL      DBPGM = 'IRCACFCTL'
     C                   EVAL      IRECACF = *ALL'Y'

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

     C                   CALL      'AODEALR1'
     C                   PARM      '*DBERR '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDDEAL        PARM      SDDEAL        DSSDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access General Ledger details

     C                   CALL      'AOGELRR1'
     C                   PARM      '*DBERR '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSSDY

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

      ** Check if CCRM Limits feature is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CDE001'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 019
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CDE001 = 'Y'
     C                   ELSE
     C                   EVAL      CDE001 = 'N'
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

      ** Check if Automatic Authorisation feature is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CAP056'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 012
     C                   EVAL      DBKEY = PSarD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CAP056 = 'Y'
     C                   ELSE
     C                   EVAL      CAP056 = 'N'
     C                   ENDIF

      **  Check if FRA/IRS Deals Authorisation is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CIR008'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 013
     C                   EVAL      DBKEY = 'CIR008'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CIR008 = 'Y'
     C                   ELSE
     C                   EVAL      CIR008 = 'N'
     C                   ENDIF

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
      *
      ** Access SAR details file to determine if CSC022 switchable feature
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC022'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD = *Blanks

     C                   EVAL      CSC022 = 'Y'
     C                   EVAL      WCMTSK = 'N'

     C                   IN        SCCMTJOB

     C                   IF        COMITNUM > 0

     C                   MOVEA     WCMTJOBS      WCMT

     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0
     C                   EVAL      WCMTSK = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   ELSE
     C                   IF        @RTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC022'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 901
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
     C                   Eval      DBASE = 018                                               BUG6671
     C                   OUT       LDA                                                       BUG6671
     C                   EXSR      *PSSR                                                     BUG6671
     C                   ENDIF                                                               BUG6671
      *                                                                                      BUG6671
     C                   If        PRTCD = *Blanks                                           BUG6671
     C                   Eval      CAP051 = 'Y'                                              BUG6671
     C                   Else                                                                BUG6671
     C                   Eval      CAP051 = 'N'                                              BUG6671
     C                   EndIf                                                               BUG6671
                                                                                              CSW213
      ** Check if SWIFT 2013  is on                                                           CSW213
                                                                                              CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       PRtCd                                        CSW213
                                                                                              CSW213
     C     PRtCd         IFEQ      'CSW2013'                                                  CSW213
     C                   MOVEL     'Y'           CSW213                                       CSW213
     C                   ELSE                                                                 CSW213
     C                   MOVEL     'N'           CSW213                                       CSW213
     C                   ENDIF                                                                CSW213

      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRCACFC022
     C     KIRSDL        KLIST                                                  BUG5403
     C                   KFLD                    WDealNo                        BUG5403
     C                   KFLD                    POurTheir                      BUG5403
     C                   KFLD                    PRDT                           BUG5403
                                                                                BUG5403
     C     KIRSDP        KLIST                                                  BUG5403
     C                   KFLD                    WDealNo                        BUG5403
     C                   KFLD                    POurTheir                      BUG5403
     C     KCFPC         KLIST                                                  BUG5403
     C                   KFLD                    WDealNo                        BUG5403
     C                   KFLD                    POurTheir                      BUG5403
     C                   KFLD                    InDateMDN                      BUG5403
                                                                                BUG5403
      ** Partial Key for DLDTSCPD                                               BUG5403
     C     KDTSC         KLIST                                                  BUG5403
     C                   KFLD                    WDealNo                        BUG5403
                                                                                BUG5403
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
(c) Misys International Banking Systems Ltd. 2003
**  SFEBO/#0SFEBO
SUFVD     #0UFVD
SUFEE     #0UFEE
SUFPR     #0UFPR
SBOVD     #0BOVD
SBUYA     #0BUYA
SBOPR     #0BOPR
SONPCD    #0ONPCD
SOIPM     #0OIPM
STNPCD    #0TNPCD
STIPM     #0TIPM
** LETT - LETTERS FOR DAYS TO VALIDATE DATE FORMULAS
MUWTFSX
