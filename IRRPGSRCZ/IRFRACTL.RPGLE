     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR FRA validation controller')                   *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRFRACTL - Validate FRA Deals - Controlling program          *
      *                                                               *
      *  Function: This Program Validates FRA Deals for Input into    *
      *            the Midas database.                                *
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
      *            For all action codes, the decision as to           *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247888             Date 18May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 242010             Date 15Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7166            Date 12May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA011             Date 31Mar04               *
      *                 225362             Date 30Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 31Oct03               *
      *                 CAP084             Date 30Jul03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CRE008             Date 19Feb02               *
      *                 CAS004             Date 26Jun02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196461             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 199787             Date 06Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.04 -----------------------------------------------*
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
      * Midas DBA 3.00 -----------------------------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003  *CREATE    Date 06May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247888 - Missing record in CLE025 files.                     *
      *  242010 - Match entry parameters with the calling parameters  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA011 - Rate Fix Ccy writes to the wrong field (Recompile)  *
      *  225362 - Amend the position of field FRARFCy (Currency Rate  *
      *           Fixing Convention) to align with the new position   *
      *           of fields in file IRVFRAPD.                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  222727 - Release 5.0 errors (Parameter in wrong sequence)    *
      *  222373 - Correct parameters on program calls                 *
      *  CAP084 - API wrapper project                                 *
      *         - Re-compile due to change in IRFRAPD                 *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CRE008 - Cash Management  Added parameters to ZASETINVAL     *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  196461 - Additional parameter ##PREC and ##PPAY in ZASETINVAL*
      *  CAP056 - Automatic Authorisation of Interface Deals.         *
      *  CIR008 - FRA/IRS Deals Authorisation.                        *
      *  199787 - Add Action Code parameter when calling ZASETINVAL   *
      *  CSC011 - 24x7 Midas Availability                             *
      *  200400 - Reverse fix 179510.                                 *
      *  179510 - Added  @MORPI  parameter at call to  ZASETINVAL     *
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
      *  CSW097 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  170909 - Settlement instructions not updated on amendment    *
      *  167475 - If FRA/IRS CTL functions fail, they loop.           *
      *  162497 - Errors in processing of settlement instructions     *
      *           (within ZASETINVAL and ZASETINSIN).                 *
      *  168981 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*       *
      *           (recompiled)                                        *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *           Add hooks                                           *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FIRVFRAPD  UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FIRIFRAPD  UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FAPIDSETPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
      ** FX/MM/FRA/IRS Extension files                                                        247888
     FDLDEALL5  UF A E           K DISK    PREFIX(DX_)                                        247888
     F                                     INFSR(*pssr)                                       247888
     F                                     COMMIT                                             247888
                                                                                              247888
 
     FIRVFRAL0  IF   E           K DISK    RENAME(IRVFRAD0:IRVFRACHK)
     F                                     INFSR(*pssr)                         CAP013
     FIRVFRAL1  IF   E           K DISK    RENAME(IRVFRAD0:IRVFRACK1)           CAP013
     F                                     INFSR(*pssr)                         CAP013
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRFRACT019
 
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
 
      * Array to hold Commitment Job Names                                                    CSC022
     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** Commitment Control Data Area                                                         CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitJob              4    103                                                       CSC022
                                                                                              CSC022
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      * Incoming Header
 
     D TranIn        E DS                  EXTNAME(IRFRAPD)
      * Incoming Transaction
 
     D ValidDeal     E DS                  EXTNAME(IRVFRAPD)
      * Valid Deals layout
     D FRARecIns             716    784
     D FRAPayIns             785   1343
     D FRAFraIns            1345   1992
     D*FRARFCy**************2063   2092                                  CIR005 222727
     D FRARFCy              2097   2126                                                       225362
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
 
     D DealFilFmt    E DS                  EXTNAME(DEALSDG)
      * (Current) Deal in File Format
     D DGRecIns              716    784
     D DGPayIns              785   1343
     D DGFraIns             1345   1992
     D*DGFRFCy**************2097   2126                                  CIR005 222727
     D DGFRFCy              2097   2126                                                       225362
      * Large fields to include
      * - Receive instructions (RSTM to ROCN)
      * - Pay     instructions (PSTM to BTB6)
 
     D DealScnFmt    E DS                  EXTNAME(IRFRAPD)
     D                                     PREFIX(@)
      * (Current) Deal in Screen Format
 
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions - Input
 
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions - Input
 
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions - Input
 
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
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CIR005
     D                                     PREFIX(@S)                           CIR005
      ** External DS for SAR Details                                            CIR005
      *                                                                         CIR005
                                                                                CAP004
      ** FRA/IRS Interface Non-Screen Data                                                    CAP056
     D InfData       E DS                  EXTNAME(IRFRIFPD)                                  CAP056
                                                                                              CAP056
     D ExtData       E DS                  EXTNAME(IRFREXPD)                    CAP004
      * IR FRA Extra Data - File (D/B) format                                   CAP004
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** External DS for API ICD                                                CAP011
 
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
      ** External data structure for FRA/IRS I.C.D. details
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
      *                                                                                       CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
     I*
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
     D Trans500        S            500A
     D Trans500B       S            500A                                                      242010
     D Trans500C       S            500A                                                      242010
     D Trans500D       S            500A                                                      242010
                                                                                CAP004
      ** Field (500A) to receive the incoming Extra Data                        CAP004
     D ExtData500      S            500A                                        CAP004
                                                                                              CAP056
      ** Field (500A) to receive the incoming Interface Non-Screen Data                       CAP056
     D InfData500      S            500A                                                      CAP056
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
      ** These have been declared for all DL1601 fields, some may not
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
     D  SUIcbsOK                      1A   INZ('Y')
     D  STaxiOK                       1A   INZ('Y')
     D  SUFrfdOK                      1A   INZ('Y')
     D  SPrfCOK                       1A   INZ('Y')
     D  SOrBrOK                       1A   INZ('Y')
     D  SBySlOK                       1A   INZ('Y')
     D  SSetFOK                       1A   INZ('Y')
     D  SRfRteOK                      1A   INZ('Y')
     D  SCRteOK                       1A   INZ('Y')
     D  SCAInOK                       1A   INZ('Y')                                           CDL038
     D  SCYr1OK                       1A   INZ('Y')                             CIR005
     D  SCYr2OK                       1A   INZ('Y')                             CIR005
     D  SCYr3OK                       1A   INZ('Y')                             CIR005
     D  SCYr4OK                       1A   INZ('Y')                             CIR005
     D  SCYr5OK                       1A   INZ('Y')                             CIR005
     D  SCYr6OK                       1A   INZ('Y')                             CIR005
     D  SCYr7OK                       1A   INZ('Y')                             CIR005
     D  SCYr8OK                       1A   INZ('Y')                             CIR005
     D  SCYr9OK                       1A   INZ('Y')                             CIR005
     D  SCYr0OK                       1A   INZ('Y')                             CIR005
     D  SRKVLOK                       1A   INZ('Y')                                           CDL038
     D  SRKSNOK                       1A   INZ('Y')                                           CDL038
     D  SCLasOK                       1A   INZ('Y')                                           CDL038
     D**SRSetMOK**********************1A   INZ('Y')                                           CDL038
     D**SPSetMOK**********************1A   INZ('Y')                                           CDL038
     D**SURAccOK**********************1A   INZ('Y')                                           CDL038
     D**SROBrOK***********************1A   INZ('Y')                                           CDL038
     D**SORAccOK**********************1A   INZ('Y')                                           CDL038
     D**SUPAccOK**********************1A   INZ('Y')                                           CDL038
     D**SPOBrOK***********************1A   INZ('Y')                                           CDL038
     D**SOPAccOK**********************1A   INZ('Y')                                           CDL038
     D**SCpPBkOK**********************1A   INZ('Y')                                           CDL038
     D**SCpRBkOK**********************1A   INZ('Y')                                           CDL038
     D**SFAcOOK***********************1A   INZ('Y')                                           CDL038
     D**SSPiOK************************1A   INZ('Y')                                           CDL038
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
 
      ** Error flags from Dates validation routine
     D ErrDealDat      S              1A   INZ('N')
     D ErrValDate      S              1A   INZ('N')
     D ErrMatDate      S              1A   INZ('N')
     D ErrNxInDat      S              1A   INZ('N')
 
      ** Flags to indicate outcome of calls to lower level modules
     D AmendOK         S              1A   INZ('Y')
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Numeric version of spread/rate
     D @SPRD           S             11P 7
 
      ** A code to indicate the calling function to the lower level modules
     D FRA             S              4A   INZ('FRA ')
 
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
 
     D Object          S             10A   INZ('IRFRAUPC')
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
                                                                                              CIR008
      ** Switchable Feature Parameter                                                         CIR008
     D CIR008          S              1A                                                      CIR008
     D CAP056          S              1A                                                      CAP056
 
      ** Fields defined for enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PDealNum        S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
                                                                                              CSC011
      ** Whether or not to clear the program message queue                                    222373
     D ClearPgmQ       S              1A                                                      222373
                                                                                              CSC022
      ** Work variables for CSC022                                                            CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wCommitSkip     S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
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
      /COPY WNCPYSRC,IRFRACT020
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,IRFRACT001                                                 CAP004
                                                                                CAP004
      * Incoming transaction is in a 500A field, so that a common CLP
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break that 500A by loading it into the
      * appropriate (externally described) data structure.
     C                   MOVEL     Trans500      TranIn
     C                   MOVEL     Extdata500    Extdata                        CAP004
     C                   MOVEL     InfData500    InfData                                      CAP056
 
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
                                                                                CAP004
      /COPY WNCPYSRC,IRFRACT002                                                 CAP004
 
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
                                                                                CAP004
      /COPY WNCPYSRC,IRFRACT003                                                 CAP004
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
                                                                                CAP004
      /COPY WNCPYSRC,IRFRACT004                                                 CAP004
      *
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depend upon Action Code
 
     C                   SELECT
 
     C                   WHEN      SACCD = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,IRFRACT005                                                 CAP004
     C                   EXSR      DftSettmts
      /COPY WNCPYSRC,IRFRACT006                                                 CAP004
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,IRFRACT007                                                 CAP004
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,IRFRACT008                                                 CAP004
 
     C                   WHEN      SACCD = 'A'
      *  Processing for Amends
      /COPY WNCPYSRC,IRFRACT009                                                 CAP004
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      TranIn                                 99    CAP011
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011
     C                   EXSR      SetupAmend
      /COPY WNCPYSRC,IRFRACT010                                                 CAP004
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,IRFRACT011                                                 CAP004
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,IRFRACT012                                                 CAP004
     C                   EXSR      ValdateAmd
      /COPY WNCPYSRC,IRFRACT013                                                 CAP004
 
     C                   ENDSL
 
     C     INVALID       TAG
                                                                                167475
      *  Check for exception error from any program lower in the stack          167475
      *  If error detected, send message to system operator and                 167475
      *  return to calling program without updating database or                 167475
      *  prompting the database update program                                  167475
     C                   IN        APDUMP                                       167475
                                                                                167475
      /COPY WNCPYSRC,IRFRACT014                                                 167475
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
      /COPY WNCPYSRC,IRFRACT015                                                 CAP004
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,IRFRACT016                                                 CAP004
 
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
      /COPY WNCPYSRC,IRFRACT021
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValDeal - Routine to check if valid FRA  exists for        *
      *    Front Office ID                                            *
      *                                                               *
      *****************************************************************
 
     C     ChkValDeal    BEGSR
 
      * Check for FRA on Valid file
     C     APFOTranID    CHAIN     IRVFRAL0                           99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     APFOTranID    CHAIN     IRVFRAL0                           99
 
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
     C                   MOVEL     SDLNO         FRDLNO                         CAP013
     C     FRDLNO        CHAIN     IRVFRAL1                           99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     FRDLNO        CHAIN     IRVFRAL1                           99        CAP013
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
     C                   CALLB     'IRFRARTV'
 
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
      ** FRA/IRS Deals Authorisation                                                          CIR008
     C                   PARM                    CIR008                                       CIR008
 
      * OUTPUTS
 
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
 
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
     C                   PARM                    FRA
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
     C                   PARM      SUCUCY        InRCCY                                      CSF011A
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
 
      * For Amends, put the complete (pre-existing) FRA into the Valid
      *  file record - fields in this will be updated during  processing
     C                   MOVEL     DealFilFmt    ValidDeal
     C                   MOVEL     FIUSRI        FRUSRI                                       CGL029
     C                   MOVEL     FIDSTS        FRDSTS                                       CGL029
     C                   MOVEL     FIAUTH        FRAUTH                                       CGL029
     C                   MOVEL     URACC         FRURACC                                      CGL029
     C                   MOVEL     UPACC         FRUPACC                                      CGL029
     C                   MOVEL     RONS          FRRONS                                       CGL029
     C                   MOVEL     PONS          FRPONS                                       CGL029
     C*****CIR005********IFEQ      'Y'                                   CIR005 222727
     C*******************MOVEL     DGFRFCy       FRARFCy                 CIR005 222727
     C*******************ENDIF                                           CIR005 222727
     C     CIR005        IFEQ      'Y'                                                        225362
     C                   MOVEL     DGFRFCy       FRARFCy                                      225362
     C                   ENDIF                                                                225362
 
      **The*Settlement*Instructions*fields*are*unlikely*to*be*supplied*****     CAP011
      ***for*an*amendment.*For*each*of*Pay/Receive,*if*it*hasn't*been******     CAP011
      ***supplied*(i.e.*it*is*blank)*default*in*the*existing*database******     CAP011
      ***values*into*the*special*DB*Settlement*Instructions*DSs*....*******     CAP011
      *****************************                                             CAP011
     C*******************IF********InRecSttmt = *Blank                          CAP011
     C*******************EVAL******DBRecSttmt = FRARecIns + FRROBR              CAP011
     C*******************EVAL******FLRSCY     = FRRSCY                          CAP011
     C*******************ENDIF*****                                             CAP011
      *****************************                                             CAP011
     C*******************IF********InPaySttmt = *Blank                          CAP011
     C*******************EVAL******DBPaySttmt = FRAPayIns + FRPOBR + FRCVMR     CAP011
     C*******************EVAL******FLPSCY     = FRPSCY                          CAP011
     C*******************EVAL******FLIC72     = FRIC72                          CAP011
     C*******************ENDIF*****                                             CAP011
      *****************************                                             CAP011
     C*******************IF********InFRASttmt = *Blank                          CAP011
     C*******************EVAL******DBFraSttmt = FRAFraIns                       CAP011
     C*******************ENDIF*****                                             CAP011
                                                                                CAP011
     C**********         EVAL      DBRecSttmt = FRARecIns + FRROBR                     CAP011 CGL029
     C                   EVAL      %SUBST(DBRecSttmt:1:2)=%SUBST(FRARecIns:1:2)               CGL029
     C                   EVAL      %SUBST(DBRecSttmt:3:18)=FRRONS                             CGL029
     C                   EVAL      %SUBST(DBRecSttmt:21:55)=                                  CGL029
     C                             %SUBST(FRARecIns:15:55)                                    CGL029
     C                   EVAL      FLROBR     = FRROBR                                        CGL029
     C                   EVAL      FLRSCY     = FRRSCY                          CAP011
     C**********         EVAL      DBPaySttmt = FRAPayIns + FRPOBR + FRCVMR            CAP011 CGL029
     C                   EVAL      %SUBST(DBPaySttmt:1:2)=%SUBST(FRAPayIns:1:2)               CGL029
     C                   EVAL      %SUBST(DBPaySttmt:3:18)=FRPONS                             CGL029
     C                   EVAL      %SUBST(DBPaySttmt:21:545)=                                 CGL029
     C                             %SUBST(FRAPayIns:15:545)                                   CGL029
     C                   EVAL      FLPOBR     = FRPOBR                                        CGL029
     C                   EVAL      FLCVMR     = FRCVMR                                        CGL029
     C                   EVAL      FLPSCY     = FRPSCY                          CAP011
     C                   EVAL      FLIC72     = FRIC72                          CAP011
     C                   EVAL      DBFraSttmt = FRAFraIns                       CAP011
     C                   MOVE      FRAGVC        FLAGVC                         CSW097
 
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
                                                                                CAP011
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main tranaction details  *
      *                                                               *
      *****************************************************************
 
     C     ValidateTr    BEGSR
 
      * Set up the settlemnt information needed for holidays validation:
      * - default fields for Inserts
      * - existing d/b fields for Amends
 
     C                   IF        SACCD = 'I'
      * This block assumes that Settlement Instructions are never received
     C                   EVAL      RecSetMeth = FLRSTM
     C                   EVAL      RecNostro  = FLRONS
     C                   EVAL      PaySetMeth = FLPSTM
     C                   EVAL      PayNostro  = FLPONS
     C                   ENDIF
 
     C                   IF        SACCD = 'A'
     C                   EVAL      RecSetMeth = FRRSTM
     C                   EVAL      RecNostro  = FRRONS
     C                   EVAL      PaySetMeth = FRPSTM
     C                   EVAL      PayNostro  = FRPONS
     C                   ENDIF
 
     C                   CALLB     'IRFRAVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
      * Receive Settlement Method & Nostro and  Pay Settlement Method &
      *  Nostro, from default (Action = I) or valid deal (Action = A)
      * Also pass Pay/Receive currency (only used in screen validation)
      * Extra Data                                                              CAP004
     C                   PARM      *BLANK        RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM      *BLANK        PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    ExtData                        CAP004
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
     C                   PARM                    FRA
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
      ** Receipt Date (Value Date for FRAs)
     C                   PARM                    RecDat
      ** Payment Date (Value Date for FRAs)
     C                   PARM                    Paydat
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
                                                                                              199787
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
     C                   PARM                    OKFRAInsDS
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
     C                   CALLB     'IRFRACVT'                                   CAP011
                                                                                CAP011
      * INPUTS                                                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * (Current) Deal in file format                                           CAP011
     C                   PARM                    DealFilfmt                     CAP011
      ** FRA/IRS Deals Authorisation                                                          CIR008
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
     C                   CALLB     'IRFRACVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
      ** FRA/IRS Deals Authorisation                                                          CIR008
     C                   PARM                    CIR008                                       CIR008
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
     C                   CALLB     'IRFRAAMD'
 
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
      *    sending of messgaes/writing to the database                *
      *                                                               *
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
     C                   WRITE     IRVFRAD0
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C                   ENDIF
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *                                                                         CAP004
      * Only write to invalid files if repair in back office                    CAP004
      *                                                                         CAP004
     C     APRprLocn     IFEQ      'B'                                          CAP004
     C                   WRITE     IRIFRAD0
     C                   WRITE     APIDSETD0
                                                                                              CSC011
      ** If support system is active, write invalid transaction to                            CSC011
      ** log file via APLOGTRAN standard module.                                              CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranIn + InRecSttmt                             CSC011
     C                                        + InPaySttmt                                    CSC011
     C                                        + InFRASttmt                                    CSC011
     C                                        + ExtData                                       CSC011
     C                   EVAL      APTGTTYPE = 'IRFRA'                                        CSC011
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
     C                   EVAL      DBase = 002                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                  CAP004
      ** Insert DLDLDGQD record for CLE025 processing                                         247888
     C                   IF        ##ACTN = 'I' AND CLE025 = 'Y'                              247888
     C     SDLNO         CHAIN     DLDLDGD0                           12                      247888
     C     *IN12         IFEQ      *ON                                                        247888
     C                   EVAL      DX_F1DLNO = SDLNO                                          247888
     C                   EVAL      DX_F1BRCA = SBRCA                                          247888
     C                   WRITE     DLDLDGD0                                                   247888
     C                   ENDIF                                                                247888
     C                   ENDIF                                                                247888
                                                                                              247888
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
 
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
     C                   RESET                   OKFRAInsDS
 
     C                   RESET                   PayDat
     C                   RESET                   RecDat
 
     C                   CLEAR                   ValidDeal
 
      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields
     C                   Z-ADD     *ZERO         FRRSTM
     C**********         Z-ADD     *ZERO         FRROBN                                       CSD027
     C**********         Z-ADD     *ZERO         FRROCN                                       CSD027
     C                   EVAL      FRROBN = *BLANKS                                           CSD027
     C                   EVAL      FRROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         FRPSTM
     C**********         Z-ADD     *ZERO         FRPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         FRPOCN                                       CSD027
     C                   EVAL      FRPOBN = *BLANKS                                           CSD027
     C                   EVAL      FRPOCN = *BLANKS                                           CSD027
 
 
      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt
 
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
     C                   EVAL      DDMsgType  = 'IRFRA '
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'F'
                                                                                              CAP056
      ** Setup the InValid file with 'Authomatic Authorisation' from                          CAP056
      ** Interface file IRFRIFPD                                                              CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                   EVAL      SAUTH = AUTH                                               CAP056
     C                   ENDIF                                                                CAP056
 
      /COPY WNCPYSRC,IRFRACT017                                                 CAP004
 
     C                   ENDSR
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
     C                   PARM      *ZEROS        FRDLNO
 
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
     C                   MOVE      SDLNO         FRDLNO
 
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
     C**********         MOVEL     DBPaySttmt    FRAPayIns                                    CGL029
     C**********         MOVEL     DBRecSttmt    FRARecIns                                    CGL029
     C                   EVAL      %SUBST(FRAPayIns:1:2) =                                    CGL029
     C                             %SUBST(DBPaySttmt:1:2)                                     CGL029
     C                   EVAL      FRPONS = %SUBST(DBPaySttmt:3:18)                           CGL029
     C                   EVAL      %SUBST(FRAPayIns:15:545) =                                 CGL029
     C                             %SUBST(DBPaySttmt:21:545)                                  CGL029
     C                   EVAL      %SUBST(FRARecIns:1:2) =                                    CGL029
     C                             %SUBST(DBRecSttmt:1:2)                                     CGL029
     C                   EVAL      FRRONS = %SUBST(DBRecSttmt:3:18)                           CGL029
     C                   EVAL      %SUBST(FRARecIns:15:55) =                                  CGL029
     C                             %SUBST(DBRecSttmt:21:55)                                   CGL029
     C                   MOVE      FLPOBR        FRPOBR
     C                   MOVE      FLROBR        FRROBR
     C                   MOVE      FLCVMR        FRCVMR
     C                   MOVE      FLPSCY        FRPSCY
     C                   MOVE      FLRSCY        FRRSCY
     C                   MOVE      FLIC72        FRIC72
     C                   MOVEL     DBFraSttmt    FRAFraIns
     C******             Z-ADD     *ZEROS        FRISDA                         CSW097
     C******             Z-ADD     *ZEROS        FRAGDT                         CSW097
     C******             Z-ADD     *ZEROS        FRAGVV                         CSW097
                                                                                CSW097
     C** Ensure numeric fields are zero if not entered.                         CSW097
     C     FLISDA        IFEQ      *BLANKS                                      CSW097
     C                   Z-ADD     *ZEROS        FRISDA                         CSW097
     C                   END                                                    CSW097
                                                                                CSW097
     C     FLAGDT        IFEQ      *BLANKS                                      CSW097
     C                   Z-ADD     *ZEROS        FRAGDT                         CSW097
     C                   END                                                    CSW097
                                                                                CSW097
     C     FLAGVV        IFEQ      *BLANKS                                      CSW097
     C                   Z-ADD     *ZEROS        FRAGVV                         CSW097
     C                   END                                                    CSW097
                                                                                CSW097
     C     FLAGVC        IFEQ      *BLANKS                                      CSW097
     C                   Z-ADD     *ZEROS        FRAGVC                         CSW097
     C                   END                                                    CSW097
     C                   ENDIF
 
      **For*Amends,*put*the*pre-existing*Settlement*Instructions*into*******    170909
      ***the*Valid*file*record**********************************************    170909
      **Two*large*fields*(one*Pay,*one*Receive)*do*most*of*this*but*a*few***    170909
      ***(physically*separate)*fields*also*need*to*be*done******************    170909
     C*******************IF********SACCD*=*'A'*************                     170909
     C*******************MOVE******DGRecIns******FRARecIns*                     170909
     C*******************MOVE******DGPayIns******FRAPayIns*                     170909
     C*******************MOVE******POBR**********FRPOBR****                     170909
     C*******************MOVE******ROBR**********FRROBR****                     170909
     C*******************MOVE******CVMR**********FRCVMR****                     170909
     C*******************MOVE******PSCY**********FRPSCY****                     170909
     C*******************MOVE******RSCY**********FRRSCY****                     170909
     C*******************MOVE******IC72**********FRIC72****                     170909
     C*******************MOVEL*****DGFraIns******FRAFraIns*                     170909
     C*******************ENDIF*****************************                     170909
 
      **For*Deletes,*put*the*complete*(pre-existing)*deal**************                       CIR008
      ***into*the*Valid*file*record************************************                       CIR008
      ** For Deletes & Authorises, put the complete (pre-existing) deal                       CIR008
      ** into the Valid file record                                                           CIR008
                                                                                              CIR008
     C                   IF           SACCD = 'R'
     C                             OR CIR008 = 'Y' AND SACCD = 'X'                            CIR008
     C                   MOVEL     DealFilFmt    ValidDeal
     C                   MOVEL     FIUSRI        FRUSRI                                       CGL029
     C                   MOVEL     FIDSTS        FRDSTS                                       CGL029
     C                   MOVEL     FIAUTH        FRAUTH                                       CGL029
     C                   MOVEL     URACC         FRURACC                                      CGL029
     C                   MOVEL     UPACC         FRUPACC                                      CGL029
     C                   MOVEL     RONS          FRRONS                                       CGL029
     C                   MOVEL     PONS          FRPONS                                       CGL029
     C*****CIR005********IFEQ      'Y'                                          CIR005 222727
     C*******************MOVEL     DGFRFCy       FRARFCy                        CIR005 222727
     C*******************ENDIF                                                  CIR005 222727
     C     CIR005        IFEQ      'Y'                                                        225362
     C                   MOVEL     DGFRFCy       FRARFCy                                      225362
     C                   ENDIF                                                                225362
     C                   ENDIF
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      FRCHTP = SACCD
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      FRFRNT = APFOTranID
     C                   EVAL      FRREPA = APRprLocn
     C                   EVAL      FRTMESTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'S'
                                                                                              CAP056
      ** Setup the Valid file with 'Authomatic Authorisation' from                            CAP056
      ** Interface file IRFRIFPD                                                              CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                   EVAL      FRAUTH = AUTH                                              CAP056
     C                   ENDIF                                                                CAP056
 
      /COPY WNCPYSRC,IRFRACT018                                                 CAP004
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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
      /EJECT
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
      * Transaction information in a single large field from source system
     C                   PARM                    Trans500
     C**********         PARM                    InfData500                            222727 242010
     C                   PARM                    Trans500B                                    242010
     C                   PARM                    Trans500C                                    242010
     C                   PARM                    Trans500D                                    242010
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
      ** FRA/IRS Interface Non-Screen Data                                                    CAP056
     C*******************PARM                    InfData500                            CAP056 222727
     C                   PARM                    InfData500                                   242010
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
 
      ** Call Access Program for FRA/IRS I.C.D. details
      *
     C                   CALLB     'AOFAISR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFAIS        PARM      SDFAIS        DSFDY
      *                                                                         CIR005
      **  Access SAR details file to determine if Bus. Day Convention is on.    CIR005
      *                                                                         CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
      *                                                                         CIR005
     C     @RTCD         IFNE      *BLANKS                                      CIR005
     C     @RTCD         ANDNE     '*NRF   '                                    CIR005
     C     *LOCK         IN        LDA                                          CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   Z-ADD     900           DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   OUT       LDA                                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C     @RTCD         IFEQ      *BLANKS                                      CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
                                                                                              CIR008
      **  Access SAR details file to determine if CIR008 is installed                         CIR008
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
     C                   EVAL      DBASE = 901                                                CIR008
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
                                                                                              CAP056
      **  Access SAR details file to determine if CAP056 is installed                         CAP056
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
     C                   EVAL      DBASE = 902                                                CAP056
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
 
      *  Initialise Data queue name
     C                   EVAL      DtaQName = 'APFRADTQ'
     C*
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = 'CSC011'                                           CSC011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBase = 001                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
 
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
     C                   Eval      DBPgm = 'IRFRACTL '                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBase = 903                                                CSC022
     C                   Out       LDA                                                        CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
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
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRFRACT022
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
