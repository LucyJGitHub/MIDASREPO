     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal Funding Deals Interface Ctrller')    *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDCTL - Internal Funding Deals Interface Controller      *
      *                                                               *
      *  Function:  This module will be the entry module for the API  *
      *             function for Internal Funding Deals.  It will     *
      *             validate incoming Internal Funding Deals from an  *
      *             external system and will determine whether they   *
      *             are valid or not.                                 *
      *             Processes executed control    by input Action Code*
      *             - For I (Insert)                                  *
      *               - validate the Internal Funding Deal            *
      *             - For A (Amend)                                   *
      *               - if transation is a partial amendment, call a  *
      *                 separate function to complete the transaction *
      *                 details                                       *
      *               - if transaction is valid, call a separate      *
      *                 function to check whteher it is a valid       *
      *                 amendment                                     *
      *             - For D (Delete) and E (Enquire)                  *
      *               - call a separate function to process the       *
      *                 transaction and bypass the rest of the        *
      *                 validation                                    *
      *             For all action codes, the decision to as to       *
      *             whether to write to the Valid or Invalid file and *
      *             the call to the Message Handler will take place   *
      *             in this module                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 261140             Date 16Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CAP076             Date 03Jun02               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.03-----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 195001             Date 09Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  261140 - Missing Front Office ID / Assoc Front Office ID     *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in MM1010                   *
      *           (new parameter to ZINTDY)                           *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMVLDNIPD*
      *  CSC011 - 24x7 Midas Availability                             *
      *  195001 - Don't access SDBRTDPD if BRT not switched on.       *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Used for Scan Indicator                         *
      *    02         Used for Chain Indicator                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRCallMsgH  - Call the Message Handling module                *
      * SRChkWrite  - Controls the checking of error status and       *
      *               sending of messages/writing to the database     *
      * SRReset     - Reset error information that is gradually       *
      *               updated during each run of this program         *
      * SRSetIMAT   - Calculate Interest at Maturity                  *
      * SRSetInval  - Set up additional fields that are needed on the *
      *               valid file record                               *
      * SRSetupDln  - Set up Deal Number for Inserts                  *
      * SRSetValid  - Set up additional fields that are needed on the *
      *               valid file record                               *
      * SRSubsDtas  - Transaction Details Data Substitution           *
      * SRValActCde - Validate action code versus the transaction     *
      *               IDs supplied                                    *
      * SRValAmd    - Check whether the fields amended are amendable  *
      * SRValDeal   - Check if valid deal exists for Front Office ID  *
      * SRValMiDeal - Check if valid deal exists for Midas Deal No.   *
      * SRValTrans  - Validate the main Transaction details           *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
      ** MM Valid Loan/Deposit/NA Issued
     FMMVLDNIPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Invalid Internal Funding Deals File
     FABIFUNDPD UF A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(DD:2)
     F                                     COMMIT
 
      ** BRT Control Data
     FSDBRTDL1  IF A E           K DISK    INFSR(*PSSR)
 
      ** MM Valid Loans & Deposits by Front Office ID
     FMMVLDNIL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMVLDNID0:MMVLDNICHK)
 
      ** MM Valid Deals by Deal no/timestamp
     FMMVLDNIL1 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMVLDNID0:MMVLDNICK1)
 
      ** ZA Sequence numbbers for input fields
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,ABFUNDC001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes definition  for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
      /COPY ZACPYSRC,PROCPARMS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
 
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
 
      * Incoming Header
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D NwDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     Prefix(DD:2)
 
      * MM Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(ABFUEXPD)
 
      ** Valid Deals layout
     D ValidDeal     E DS                  EXTNAME(MMVLDNIPD)
 
      ** AB Internal Funding for file update - file format
     D CrDlFilFmt1   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(C1:2)
     D  QQDoriC1     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriC1     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiC1     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiC1     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsC1     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsC1     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaC1     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** AB Internal Funding for file update - file format
     D CrDlFilFmt2   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(C2:2)
     D  QQDoriC2     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriC2     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiC2     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiC2     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsC2     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsC2     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaC2     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Deal in File Format
     D DealFilFmt1   E DS                  EXTNAME(MMDELDPP)
     D                                     PREFIX(D1:2)
     D  QQDoriD1     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriD1     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiD1     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiD1     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsD1     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsD1     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaD1     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Associated Deal in File Format
     D DealFilFmt2   E DS                  EXTNAME(MMDELDPP)
     D                                     PREFIX(D2:2)
     D  QQDoriD2     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriD2     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiD2     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiD2     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsD2     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsD2     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaD2     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** (Current) Deal in Screen Format
     D CrDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     PREFIX(Cr)
 
      ** Internal Funding Deals Error Indicator File
     D OkFlagsDS     E DS                  EXTNAME(ABEFUNDPD)
 
      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS Trading ICD
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQAccd1      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS Dealing Data
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  QQAccd2      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Externam DS SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D MMLDNIUPC       DS             1    DTAARA(MMLDNIUPC)
 
      ** Midas Run Date
     D                 DS
     D WkBJMRDT                1      7
     D WkDLUP                  1      2  0
     D WkMLUP                  3      5
     D WkYLUP                  6      7  0
 
      ** YYYYMMDD date format of Deal Date
     D PDateOutZ9      DS
     D  DDATYr                 1      4  0
     D  DDATMn                 5      6  0
     D  DDATDy                 7      8  0
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
     D ZMUSER        E DS                  EXTNAME(ZMUSER)
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** Jobs Handling Commitment Control                                                     CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PLnkFlag        S              1A
     D PValFlg         S              1A
 
     D PKey            S              1A
     D PReDsp          S              1A
 
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
      ** Mode of Operation
     D PModeofop       S              6A
 
      ** Reset of Fields required
     D PResetErrs      S              1A
 
      ** Error message field(s)
     D PMsg1           S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D PIdx            S              3P 0
 
      ** Index for arrays of warning message ids etc
     D PWIdx           S              3P 0
 
      ** Field (500A) to receive the incoming transaction
     D PTrans500       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D PExtData500     S            500A
 
      ** Index for arrays of error message ids etc in Amend validation
     D PAmIdx          S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Flag to indicate outcome of call to lower level module
     D PAmendOK        S              1A   INZ('Y')
 
      ** Substitution Character
     D PSubsChar       S              1A
 
      ** Incoming Data
     D PIncDATA        S           2000A
 
      ** Current Data
     D PCurDATA        S           2000A
 
      ** Overall Transaction status, to be passed to the Message Handler
     D PTranStatus     S              1A
 
      ** Whether or not to clear the program message queue
     D PClrPgmMsgQ     S              1A
 
      ** Module ID, to be passed to the Message Handler
     D PModuleID       S              2A
 
      ** Deal Status Flag
     D PStatus         S              7A
 
      ** Generated Deal Number
     D PDealNo         S              6S 0
 
      ** Work Variables
     D WMQError        S             28A
     D PMQErrLong      S            132A
     D PMQReturn       S             10A
     D WSetFld         S              1A
 
      ** Parameters for APCALCOBJ
     D PObject         S             10A   INZ('MMLDNIUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A
     D PLockState      S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcobj         S              1A   INZ('Y')
     D PReturn         S              7A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
 
      ** Profit Centre Description
     D PPCDesc1        S             30A
     D PPCDesc2        S             30A
 
      ** Front Office Transaction ID                                                          261140
     D FRNT            S             20A                                                      261140
     D AFRT            S             20A                                                      261140
                                                                                              261140
      ** Timestamp for the transaction
     D PTimeStamp      S               Z
 
      ** Midas Transaction ID
     D PTranID         S             20A
 
      ** Parameters for ZDATE2
     D PDaynoIn        S              5P 0
     D PRetCode        S              1  0
 
      ** Parameters for MM1010
     D PMTTI           S             15P 0
     D PINTD           S             13P 0
     D PIPFQ           S              1A
     D PNIPD           S              5P 0
     D PDVSD           S              5P 0
     D PICMT           S              1A
     D PAMNP           S             15P 0
     D PINTR           S             11P 7
     D PRDFC           S              1A
     D PMTAX           S              1A
     D PDeal           S              6  0
     D PBRMD           S              5P 0
     D S01383          S              1A
     D*PCNUM****       S              6  0                                                    CSD027
     D PCNUM           S              6A                                                      CSD027
     D PZCCY           S              3A
     D PZLOC           S              3A
     D PIMAT           S             15  0
 
      ** Parameters for ZALIGN
     D PZAlignOk       S              1A
     D PZField         S             16A
     D PZADEC          S              1P 0
     D PZADIG          S              2P 0
 
     D CSC011          S              1A                                                      CSC011
     D CSC022          S              1A   INZ('N')                                           CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
     D***PDealNum        S             18A                                             CSC011 CGL029
     D***PADealNum       S             18A                                             CSC011 CGL029
     D PDealNum        S             24A                                                      CGL029
     D PADealNum       S             24A                                                      CGL029
     D TRANSDTL        S           5800A                                                      CSC011
                                                                                              CSC011
     D CAS004          S              1A                                                      CAS004
                                                                                              CAS004
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D CDL019          S              1A                                                      CDL019
                                                                                              CDL019
     D CDL020          S              1A                                                      CDL020
                                                                                              CDL020
      /COPY WNCPYSRC,ABFUNDC002
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      /COPY WNCPYSRC,ABFUNDC003
 
      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.
 
     C                   EVAL      NwDlScnFmt = PTrans500
     C                   EVAL      Extdata = PExtData500
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp
 
      ** Reset variables gradually updated
 
     C                   EXSR      SRReset
     C
 
      /COPY WNCPYSRC,ABFUNDC004
 
      ** Check if valid deal exists for Front Office ID
 
     C                   EXSR      SRValDeal
 
      ** If valid deal does exist (even after delay), fail this input
 
     C                   IF        PIdx <> 0
     C                   GOTO      INVALID
     C                   END
 
      ** Check if valid deal exists for Midas Deal Number
 
     C                   EXSR      SRValMiDeal
 
      ** If valid deal does exist (even after delay), fail this input
 
     C                   IF        PIdx <> 0
     C                   GOTO      INVALID
     C                   END
 
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid deals file.
 
     C                   EXSR      SRReset
     C
 
      /COPY WNCPYSRC,ABFUNDC005
 
      ** Validate Action Code
 
     C                   EXSR      SRValActCde
 
      /COPY WNCPYSRC,ABFUNDC006
 
      ** If error in validation of action code, fail this input
 
     C                   IF        PIdx <> 0
     C                   GOTO      INVALID
     C                   END
 
      ** Processing depends upon Action Code
 
     C                   SELECT
 
      ** Processing for Inserts
 
     C                   WHEN      DDACTN = 'I'
 
      /COPY WNCPYSRC,ABFUNDC007
 
      ** Validate Main Transaction Details
 
     C                   EXSR      SRValTrans
 
      /COPY WNCPYSRC,ABFUNDC008
 
      ** Processing for Amends, Deletes, and Enquiries
 
     C                   OTHER
 
      /COPY WNCPYSRC,ABFUNDC009
 
      ** Convert original details from file to screen format
 
     C                   EXSR      SRCvtDta
 
      /COPY WNCPYSRC,ABFUNDC010
 
      ** Transaction Details Data Substitution
 
     C                   IF        GHSUBS <> *Blanks
     C     GHSUBS        SCAN      NwDlScnFmt                             01
     C                   IF        *IN01 = *On
     C                   EXSR      SRSubsDtas
     C                   ENDIF
     C                   ENDIF
 
      /COPY WNCPYSRC,ABFUNDC011
 
      ** Processing for Amend Only
 
     C                   IF        DDACTN = 'A'
 
      ** Validate Main transaction details
 
     C                   EXSR      SRValTrans
 
      /COPY WNCPYSRC,ABFUNDC012
 
      ** Check whether fields amended are amendable
 
     C                   EXSR      SRValAmd
 
      /COPY WNCPYSRC,ABFUNDC013
 
     C                   ELSE
     C                   EVAL      DealFilFmt1 = CrDlFilFmt1
     C                   EVAL      DealFilFmt2 = CrDlFilFmt2
     C                   ENDIF
 
      /COPY WNCPYSRC,ABFUNDC014
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      ** Check for exception error from any program lower in the stack
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program
 
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,ABFUNDC015
 
     C                   IF        ARERRMOD <> *BLANK
     C                   EVAL      PMQErrLong = *Blanks
     C                   EVAL      WMQError = ProcErr
     C                   EVAL      WMQError = ARERRMOD
     C                   EVAL      PMQErrLong = WMQError
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMQReturn
     C                   PARM                    PMQErrLong
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
 
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
 
      /COPY WNCPYSRC,ABFUNDC016
 
      ** Processing for Error checking/write to database
 
     C                   EXSR      SRChkWrite
 
      /COPY WNCPYSRC,ABFUNDC017
 
      ** If valid, send data queue entry to prompt DB update program
 
     C                   IF        PIdx = 0
     C                   EVAL      PObjType = '*DTAARA'
 
      ** Check if update program active using Allocate Object API
      ** No prompting necessary if program is running
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockState
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM      *BLANK        PReturn
 
     C                   IF        PReturn = *Blanks
 
      ** Check if any messages are already on the data queue
      ** No need to send duplicate prompt messages
 
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
      /COPY ZACPYSRC,DTAQCHK
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
 
      /COPY WNCPYSRC,ABFUNDC018
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValDeal  - Check if valid deal exists for Front Office ID   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValDeal     BEGSR
 
      ** Check for front office Id in the valid records file.
      ** Run delay program if record found.
 
     C     APFOTRANID    CHAIN     MMVLDNIL0                          02
 
      ** If record found...
 
     C                   IF        *IN02 = *Off
 
      ** ..delay, then repeat check
 
     C                   CALLB     'ZACDELAY'
 
     C     APFOTRANID    CHAIN     MMVLDNIL0                          02
 
      ** Error if still present
 
     C                   IF        *IN02 = *Off
     C                   ADD       1             PIdx
     C                   EVAL      FldNameArr(PIdx) = '#1DLNO'
     C                   EVAL      MsgIDArr(PIdx) = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check for associated front office Id in the valid records file.
 
     C                   IF        APFOASOCID <> *BLANK
 
     C     APFOASOCID    CHAIN     MMVLDNIL0                          02
 
      ** If record found...
 
     C                   IF        *IN02 = *Off
 
      ** ..delay, then repeat check
 
     C                   CALLB     'ZACDELAY'
 
     C     APFOASOCID    CHAIN     MMVLDNIL0                          02
 
      ** Error if still present
 
     C                   IF        *IN02 = *Off
     C                   ADD       1             PIdx
     C                   EVAL      FldNameArr(PIdx) = '#1DADN'
     C                   EVAL      MsgIDArr(PIdx) = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValMiDeal- Check if valid deal exists for Midas Deal number *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValMiDeal   BEGSR
 
      ** If (numeric) Midas deal number supplied
 
     C                   IF        DDDLNO <> *BLANKS
 
     C                   MOVE      *Blanks       PZField
     C                   MOVE      DDDLNO        PZField
     C                   Z-ADD     0             PZADEC
     C                   Z-ADD     6             PZADIG
     C                   EXSR      SRZAlign
 
     C                   IF        PZAlignOk = 'Y'
 
      ** Check for deal on Valid file
 
     C                   MOVEL     DDDLNO        IKDN38
     C     IKDN38        CHAIN     MMVLDNIL1                          02
 
      ** If record found...
 
     C                   IF        *IN02 = *Off
 
      ** ..delay, then repeat check
 
     C                   CALLB     'ZACDELAY'
 
     C     IKDN38        CHAIN     MMVLDNIL1                          02
 
      ** Error if still present
 
     C                   IF        *IN02 = *Off
     C                   ADD       1             PIdx
     C                   EVAL      FldNameArr(PIdx) = '#1DLNO'
     C                   EVAL      MsgIDArr(PIdx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If (numeric) Midas associated deal number supplied
 
     C                   IF        DDDADN <> *BLANKS
 
     C                   MOVE      *Blanks       PZField
     C                   MOVE      DDDADN        PZField
     C                   Z-ADD     0             PZADEC
     C                   Z-ADD     6             PZADIG
     C                   EXSR      SRZAlign
 
     C                   IF        PZAlignOk = 'Y'
 
      ** Check for associated deal on Valid file
 
     C                   MOVEL     DDDADN        IKDN38
     C     IKDN38        CHAIN     MMVLDNIL1                          02
 
      ** If record found...
 
     C                   IF        *IN02 = *Off
 
      ** ..delay, then repeat check
 
     C                   CALLB     'ZACDELAY'
 
     C     IKDN38        CHAIN     MMVLDNIL1                          02
 
      ** Error if still present
 
     C                   IF        *IN02 = *Off
     C                   ADD       1             PIdx
     C                   EVAL      FldNameArr(PIdx) = '#1DADN'
     C                   EVAL      MsgIDArr(PIdx) = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValActCde - Validate action code versus the transaction IDs *
      *               supplied                                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValActCde   BEGSR
 
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ** if insert
      ** if not insert and Midas transaction ID is not present
      ** Otherwise
      ** Set retrieve mode to blank  (Access using Midas transaction ID).
 
     C                   IF        DDACTN = 'I'
     C                   EVAL      PModeofOp = '*FRONT'
     C                   ELSE
     C                   IF        DDDLNO = *BLANK
     C                   EVAL      PModeofOp = '*FRONT'
     C                   ELSE
     C                   EVAL      PModeofOp = *Blanks
     C                   ENDIF
     C                   ENDIF
 
      ** Validate action code versus transaction IDs supplied
      ** This function will set the Midas deal number and the Midas
      ** associated deal number.
      ** The deal in file format from the MM database is retrieved as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ABFUNDRTV'
 
      ** Inputs
      ** ======
      ** Return code
      ** Mode= '*FRONT' (Front Office Transaction Interface)
      ** Mode = '     ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM                    ReturnCode
     C                   PARM                    PModeofOp
 
      ** Response mode
      ** Action Code
      ** Front Office Transaction ID
      ** Front Office Associated Transaction Id
      ** (Midas) Deal Number
      ** (Midas) Associated Deal Number
      ** (Midas) Booking Branch
      ** (Midas) Booking Branch for Associated Deal
 
     C                   PARM                    APRESPMODE
     C                   PARM                    DDACTN
     C                   PARM                    APFOTRANID
     C                   PARM                    APFOASOCID
     C                   PARM                    DDDLNO
     C                   PARM                    DDDADN
     C                   PARM                    DDBRC1
     C                   PARM                    DDBRC2
 
      ** Linked maintenance flag
 
     C                   PARM                    PLnkFlag
 
      ** Standing Data
      ** =============
      ** SDBANKPD
 
     C                   PARM                    BJSBRC
 
      ** SDGELRPD
 
     C                   PARM                    BKOBUV
 
      ** ZMUSER
 
     C                   PARM                    DBRN
 
      ** Outputs
      ** =======
      ** Current deal in file format
      ** Associated deal in file format
      ** OK - Action code
      ** OK - Deal Number
      ** OK - Booking branch
      ** OK - Booking branch for associated deal number
 
     C                   PARM                    CrDlFilFmt1
     C                   PARM                    CrDlFilFmt2
     C                   PARM                    OkACTN
     C                   PARM                    OkDLNO
     C                   PARM                    OkBRC1
     C                   PARM                    OkBRC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    PIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValTrans - Validate the main transaction details            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValTrans    BEGSR
 
     C                   MOVE      *All'Y'       OkFlagsDS
     C                   MOVE      CrDlFilFmt1   DealFilFmt1
     C                   MOVE      CrDlFilFmt2   DealFilFmt2
 
     C                   CALLB     'ABFUNDVAL'
 
      ** Input
      ** =====
      ** Return Code
 
     C                   PARM                    ReturnCode
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM                    PModeOfOp
 
      ** Response mode (1A), from source system common header
 
     C                   PARM                    APRESPMODE
 
      ** Transaction information (DS) from source system
 
     C                   PARM                    NwDlScnFmt
 
      ** Current Screen Format
 
     C                   PARM                    CrDlScnFmt
 
      ** Current File Format 1
      ** Current File Format 2
 
     C                   PARM                    CrDlFilFmt1
     C                   PARM                    CrDlFilFmt2
 
      ** STANDING DATA
      ** =============
 
      ** SDBANKPD
      ** ========
      ** Date Format Indicator
      ** Currency Code
      ** Single Branch Code
      ** System Location Code
      ** Local Currency Code
      ** Customer Number
      ** Run Day Number
      ** Back Value Period in Days
 
     C                   PARM                    BJDFIN
     C                   PARM                    BJCYCD
     C                   PARM                    BJSBRC
     C                   PARM                    BJSLCD
     C                   PARM                    BJLCCY
     C                   PARM                    BJCUST
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJBVPD
 
      ** SDGELRPD
      ** ========
      ** Profit Centres Used
      ** Originating Branch Used
      ** Originating Branch/User Valid
      ** Profit Centres Amendable
      ** Profit Centre Deafults Used
 
     C                   PARM                    BKPRCU
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
 
      ** SDDEALPD
      ** ========
      ** Decimal Separator
 
     C                   PARM                    BNDCSP
 
      ** SDMMODPD
      ** ========
      ** Leo Letters of Credit
 
     C                   PARM                    BGNOST
 
      ** SDTRADPD
      ** ========
      ** Base Rate Change Facility
 
     C                   PARM                    BLBRCF
 
      ** RUNDAT: Multibranching Indicator
 
     C                   PARM                    AGMBIN
 
      ** ZMUSER: Default Branch
      ** Department Code
 
     C                   PARM                    DBRN
     C                   PARM                    DPPT
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Output
      ** ======
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    PIdx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    PWIdx
 
      ** AB Internal Funding screen error indicators
 
     C                   PARM                    OkFlagsDS
 
      ** AB Internal Funding for file update - file format
 
     C                   PARM                    DealFilFmt1
 
      ** Associated Deal Number fields
 
     C                   PARM                    DealFilFmt2
 
      ** Redisplay flag
 
     C                   PARM                    PReDsp
 
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    PPCDesc1
     C                   PARM                    PPCDesc2
 
      ** Amended by validation module flag
 
     C                   PARM                    PValFlg
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtDta - Convert Data                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCvtDTa      BEGSR
 
      ** Conversion of file fields to screen format
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ABFUNDCVT'
 
      ** Inputs
      ** ======
      ** Return Code
      ** Action Code
 
     C                   PARM                    ReturnCode
     C                   PARM                    DDACTN
 
      ** Current Deal in file format
      ** Current Associated Deal in file format
 
     C                   PARM                    CrDlFilfmt1
     C                   PARM                    CrDlFilfmt2
 
      ** Standing Data
      ** =============
      ** SDBANKPD
 
     C                   PARM                    BJDFIN
 
      ** SDDEALPD
 
     C                   PARM                    BNDCSP
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Outputs
      ** =======
      ** Current Deal in screen format
      ** Deal Status Flag
 
     C                   PARM                    CrDlScnFmt
     C                   PARM                    PStatus
 
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    PPCDesc1
     C                   PARM                    PPCDesc2
 
      ** Front Office Transaction ID                                                          261140
     C                   PARM                    FRNT                                         261140
                                                                                              261140
      ** Associated Front Office Transaction ID                                               261140
     C                   PARM                    AFRT                                         261140
                                                                                              261140
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSubsDtas - Transaction Details Data Substitution            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSubsDtas    BEGSR
 
      ** Data Substitution
 
     C                   RESET                   ReturnCode
     C                   CLEAR                   PIncDATA
     C                   CLEAR                   PCurDATA
     C                   CALLB     'APDTASUBS'
 
      ** Return Code
      ** Substitution character
      ** Incoming Data
      ** Current Data
 
     C                   PARM                    ReturnCode
     C                   PARM      GHSUBS        PSubsChar
     C                   PARM      NwDlScnFmt    PIncDATA
     C                   PARM      CrDlScnFmt    PCurDATA
 
     C                   EVAL      NwDlScnFmt = PIncDATA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValAmd   - Check whether the fields amended are amendable   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValAmd      BEGSR
 
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
 
      ** Amend Checking
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ABFUNDAMD'
 
      ** Inputs
      ** ======
      ** Return Code
      ** New Deal in Screen Format (Incoming Transaction)
      ** Current Deal in Screen Format
      ** Reset of Fields in Error Required (Y/N)
      ** Originating Branch Used
      ** Decimal Separator
 
     C                   PARM                    ReturnCode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    CrDlScnfmt
     C                   PARM      'N'           PResetErrs
     C                   PARM                    BKOBRU
     C                   PARM                    BNDCSP
     C                   PARM                    CDL019                                       CDL019
     C                   PARM                    CDL020                                       CDL020
 
      ** Outputs
      ** =======
      ** Field OK flags (DS) from/to caller
 
     C                   PARM                    OKFlagsDS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    PAmIdx
 
      ** Amendments OK
 
     C                   PARM                    PAmendOK
 
      ** Amended by validation module flag
 
     C                   PARM                    PValFlg
 
      ** If any errors overwrite previous error information
 
     C                   IF        PAmIdx <> 0
     C                   EVAL      MsgidArr = AmMsgIdArr
     C                   EVAL      FldNameArr = AmFldNamAr
     C                   EVAL      MsgDtaArr = AmMsgDtaAr
     C                   EVAL      PIdx = PAmIdx
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkWrite  - Controls the checking of error status and       *
      *               sending of messgaes/writing to the database     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SRSetupDln                                         *
      *            SRSetValid                                         *
      *            SRCallMsgH                                         *
      *            SRSetInval                                         *
      *                                                               *
      *****************************************************************
 
     C     SRChkWrite    BEGSR
 
      **  If no errors were found:
      **  - If Action Code is Insert and Deal Number is not supplied
      **     - set up the deal number
      **  - If there are still no errors
      **     - set up additional data
      **     - write a record to the Valid file
      **     - use std message handler to report deal status
      **  If any errors were found:
      **  - write a record to the Invalid file
      **  - call the message handler to pass the errors back
      **  - use std message handler to report deal status
      **  The index to the error arrays is checked for presence/absence of
      **   errors
     
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date this routine will have to cater for        |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (PWIdx <> 0)            |
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
 
     C                   IF        PIdx = 0
 
      ** Write to Valids file the First Deal
 
     C                   EVAL      WSetFld = '1'
 
     C                   EXSR      SRSetValid
 
     C                   WRITE     MMVLDNID0
     C                   EXSR      SRCallMsgH
 
      ** Write to Valids file the Second deal
 
     C                   EXSR      SRSetValid
 
     C                   WRITE     MMVLDNID0
     C                   EXSR      SRCallMsgH
 
     C                   ENDIF
 
      ** If Record is invalid
 
     C                   IF        PIdx > 0
     C                   EXSR      SRSetInval
 
      ** Only write to invalid files if repair in back office
 
     C                   IF        APRPRLOCN = 'B'
     C                   WRITE     ABIFUNDD0
                                                                                              CSC011
      ** If support system is active, write invalid transaction to                            CSC011
      ** log file via APLOGTRAN standard module.                                              CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = NwDlScnFmt + ExtData                            CSC011
     C                   EVAL      APTGTTYPE = 'ABFUND'                                       CSC011
     C                   EVAL      PDealNum = DDDLNO                                          CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    PHeadIn                                      CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    PTimeStamp                                   CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNum                                    CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = PDealNum                                           CSC011
     C                   EVAL      DBFile = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBase = 010                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
     C                   EXSR      SRCallMsgH
     C                   ENDIF
 
     C/COPY WNCPYSRC,ABFUNDCC01
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   COMMIT
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                                               CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReset   - Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRReset       BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   PIdx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   PWIdx
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   PAmIdx
 
     C                   RESET                   FldNoArr
 
     C                   RESET                   OKFlagsDS
 
     C                   RESET                   PAmendOK
 
     C                   CLEAR                   ValidDeal
 
      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields
 
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetInval - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      * Called by: SRChkWrite                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSetInval    BEGSR
 
      ** Include Header fields that need to be o/p to the Invalid files
 
     C                   EVAL      DDFRNT = APFOTRANID
     C                   EVAL      DDAFRT = APFOASOCID
     C                   EVAL      DDREPA  = APRPRLOCN
     C                   EVAL      DDTMST = PTimeStamp
 
     C                   EVAL      PTranStatus = 'F'
 
      /COPY WNCPYSRC,ABFUNDC019
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetupDln - Set up Deal Number for Inserts                   *
      *                                                               *
      * Called by: SRChkWrite                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSetupDln    BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    PMsg1
     C                   PARM                    DDDLNO
     C                   PARM      *ZEROS        PDealNo
 
     C                   IF        PMsg1 <> *Blanks
     C                   ADD       1             PIdx
     C                   EVAL      FldNameArr(PIdx) = '#1DLNO'
     C                   EVAL      MsgIDArr(PIdx) = PMsg1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
 
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OkDLNO
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetValid - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      * Called by: SRChkWrite                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSetValid    BEGSR
 
      ** Generate the first Deal
 
     C                   IF        WSetFld = '1'
 
     C                   IF        DDACTN = 'I' AND
     C                             DDDLNO = *Blanks
     C                   EXSR      SRSetupDln
     C                   EVAL      D1DN38 = PDealNo
     C                   MOVE      PDealno       D1PCDN
     C                   MOVE      PDealno       D2DADN
     C                   ELSE
     C                   MOVE      DDDLNO        D1DN38
     C                   MOVE      DDDLNO        D1PCDN
     C                   MOVE      DDDLNO        D2DADN
     C                   ENDIF
 
      ** Generate the second deal
 
     C                   IF        DDACTN = 'I' AND
     C                             DDDADN = *Blanks
     C                   EXSR      SRSetupDln
     C                   EVAL      D2DN38 = PDealNo
     C                   MOVE      PDealno       D2PCDN
     C                   MOVE      PDealno       D1DADN
     C                   ELSE
     C                   MOVE      DDDADN        D2DN38
     C                   MOVE      DDDADN        D2PCDN
     C                   MOVE      DDDADN        D1DADN
     C                   ENDIF
 
     C                   ENDIF
 
      ** Deal Type, Amount, and Branches
 
     C                   IF        WSetFld = '1'
     C                   EVAL      ValidDeal = DealFilFmt1
     C                   EVAL      IKMTYP = 'IL'
     C                   EVAL      IKTYPE = 'IL'
     C                   EVAL      IKPOBR = DDBRC2
     C                   EVAL      IKROBR = DDBRC2
     C                   Z-SUB     IKAMNP        IKAMNP
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      IKOYLC = DDOYC1                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ELSE
     C                   EVAL      ValidDeal = DealFilFmt2
     C                   EVAL      IKMTYP = 'ID'
     C                   EVAL      IKTYPE = 'ID'
     C                   EVAL      IKPOBR = DDBRC1
     C                   EVAL      IKROBR = DDBRC1
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      IKOYLC = DDOYC2                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   IF        IKMTTI > 0
     C                   Z-SUB     IKMTTI        IKMTTI
     C                   ENDIF
     C                   ENDIF
 
      ** Time of Input
 
     C                   TIME                    IKTIME
 
      ** Record Identifier
 
     C                   EVAL      IKRCID = 'HK'
 
      ** Logical Delete Flag
 
     C                   EVAL      IKDLTF = ' '
 
      ** Date and Time of Last Update
 
     C                   EVAL      IKDLUP = WkDLUP
     C                   EVAL      IKMLUP = WkMLUP
     C                   EVAL      IKYLUP = WkYLUP
     C                   TIME                    IKTLUP
 
      ** Type of last change
 
     C                   EVAL      IKCHTP = DDACTN
 
      ** Last Change Date
 
     C**********         EVAL      IKLCD  = BJRDNB                                            CSC011
     C                   EVAL      IKLCD  = WRunDay                                           CSC011
 
      ** Last Update User ID
 
     C                   EVAL      IKLUID = PSUser
 
      ** Broker Code
 
     C                   EVAL      IKBKCD = 'PHON'
 
      ** Deal Transaction Date
 
     C                   EVAL      IKDTYY = DDATYr
     C                   EVAL      IKDTMM = DDATMn
     C                   EVAL      IKDTDD = DDATDy
 
      ** Deal Deleted indicator
 
     C                   IF        DDACTN = 'D'
     C                   EVAL      IKDDLT = 'D'
     C                   ELSE
     C                   EVAL      IKDDLT = ' '
     C                   ENDIF
 
      ** Deal Status Indicator
 
     C                   EVAL      IKDSTS = 'A'
 
      ** Rollover indicator
 
     C                   EVAL      IKRBSI = ' '
 
      ** Deal PC Transaction number
 
     C                   EVAL      IKPCTN = *Zeros
 
      ** Deal last action
 
     C                   EVAL      IKLACT = DDACTN
 
      ** Deal Brokerage
 
     C                   MOVE      *ALL'9'       IKBRKG
 
      ** Deal User Code
      ** Deal authorisation officer
 
     C                   EVAL      IKDUSC = PSUser
     C                   EVAL      IKAOFR = PSUser
 
      ** Deal action date
 
     C                   MOVE      PDateOutZ9    IKLDAT
 
      ** Start/Last interest date = Deal value date
 
     C                   EVAL      IKSLYY = IKVDYY
     C                   EVAL      IKSLMM = IKVDMM
     C                   EVAL      IKSLDD = IKVDDD
 
      ** Input Interest Rate
 
     C                   Z-ADD     IKINTR        IKIIRT
 
      ** Account Sequence Number
 
     C                   EVAL      IKACSQ = 1
 
      ** Negative Interest Indicator
 
     C                   IF        IKINTR < 0
     C                   EVAL      IKNGVI = 'Y'
     C                   ENDIF
 
      ** Midas Taxable Indicator
 
     C                   EVAL      IKMTAX = 'N'
 
      ** Interest accrual contr year = Deal value date
 
     C                   EVAL      IKIAYY = IKVDYY
     C                   EVAL      IKIAMM = IKVDMM
     C                   EVAL      IKIADD = IKVDDD
 
      ** Interest at Maturity
 
     C                   EXSR      SRSetIMAT
 
      ** If Amount is negative
 
     C                   IF        IKAMNP < 0
 
     C                   IF        PIMAT < 0
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PIMAT < 0
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Ensure Interest at Maturity is same sign as amt if -VE INT.
 
     C                   IF        IKNGVI = 'Y'
     C                   IF        IKAMNP < 0
 
     C                   IF        PIMAT < 0
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PIMAT < 0
     C                   Z-SUB     PIMAT         IKIMAT
     C                   ELSE
     C                   Z-ADD     PIMAT         IKIMAT
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Automatic Authorisation
 
     C                   EVAL      IKAUTH = 'Y'
 
      ** Include Header fields that need to be o/p to the Valid file
 
     C                   EVAL      IKFRNT = APFOTRANID
     C                   EVAL      IKAFRT = APFOASOCID
     C                   EVAL      IKREPA = APRPRLOCN
     C                   EVAL      IKTMESTMP = PTimeStamp
 
     C                   EVAL      PTranStatus = 'S'
 
      ** If first time around setup WSetFld to '2'
 
     C                   IF        WSetFld = '1'
     C                   EVAL      WSetFld = '2'
     C                   ENDIF
 
      /COPY WNCPYSRC,ABFUNDC020
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetIMAT - Calulate Interest at Maturity                     *
      *                                                               *
      * Called by: SRSetValid                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SRSetIMAT     BEGSR
 
     C                   CALLB     'MM1010'
 
      ** Input Parameters
      ** ================
      ** Total Interest
      ** Interest to date
      ** Interest Payment Frequency
      ** Next interest payment date
      ** Value Date
      ** Interest Calculation Method
      ** Deal Amount
      ** Effective Interest rate
      ** Round Down Interest Indicator
      ** Taxable Indicator
      ** Deal Number
 
     C                   PARM      IKMTTI        PMTTI
     C                   PARM                    PINTD
     C                   PARM      IKIPFQ        PIPFQ
     C                   PARM      IKNIPD        PNIPD
     C                   PARM      IKDVSD        PDVSD
     C                   PARM      IKICMT        PICMT
     C                   PARM      IKAMNP        PAMNP
     C                   PARM      IKINTR        PINTR
     C                   PARM      IKRDFC        PRDFC
     C                   PARM      IKMTAX        PMTAX
     C                   PARM      IKDN38        PDeal
 
      ** Maturity Date for BRT Calculation
 
     C                   PARM                    PBRMD
 
      **  Hong Kong Tax Rate from Dealing ICD
 
     C                   PARM                    BNHKTR
     C                   PARM                    S01383
 
      ** SDBRTDPD
      ** ========
      ** BRT Rate
      ** Date Effective From
      ** BRT Rate - Previous
 
     C                   PARM                    BRTR
     C                   PARM                    DEFF
     C                   PARM                    PBRTR
 
      ** Customer Number
 
     C                   PARM      IKCNUM        PCNUM
 
      ** Currency Code
      ** Location Code
 
     C                   PARM                    PZCCY
     C                   PARM                    PZLOC
 
      ** Interest at Maturity
 
     C                   PARM                    PIMAT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZAlign - Validate numeric fields                            *
      *                                                               *
      * Called by: SRValMiDeal                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZAlignOk
     C                   PARM                    PZField
     C                   PARM                    PZADEC
     C                   PARM                    PZADIG
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCallMsgH - Call the Message Handling module                 *
      *                                                               *
      * Called by: SRChkWrite                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCallMsgH    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C                   IF        FldNameArr(Ix) <> *Blanks
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
     C                   ENDDO
 
     C                   RESET                   ReturnCode
 
     C                   EVAL      PTranID = DDDLNO
 
     C                   CALLB     'ZAMSGHNDLE'
 
      ** Return code (10A, returned to this procedure)
      ** Deal repair location (1A, from caller)
      ** Confirm validity to front office (1A, from caller)
 
     C                   PARM                    ReturnCode
     C                   PARM                    APRPRLOCN
     C                   PARM                    APCNFVALFO
 
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
 
     C                   PARM                    MsgIDArr
 
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
 
     C                   PARM                    FldNoArr
     C                   PARM                    FldNameArr
     C                   PARM                    MsgDtaArr
 
      ** Front office transaction identifier (20A, from caller)
      ** Midas module ID (2A)
      ** Midas transaction ID (20A, from caller)
      ** Message file (10A, from caller)
 
     C                   PARM                    APFOTRANID
     C                   PARM                    PModuleID
     C                   PARM                    PTranID
     C                   PARM                    #MsgFile
 
      ** Action code of transaction (1A, from transaction)
      ** Status of transaction (1A, F=Failure, S=Success)
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
 
     C                   PARM                    DDACTN
     C                   PARM                    PTranStatus
     C                   PARM                    APRESPMODE
 
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
      ** Screen-handling module (10A, from caller)
      ** Screen-handling procedure (10A, from caller)
 
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** The MQSeries queue to send replies to
      ** The transaction's timestamp
      ** Additional Message files to check
      ** Whether or not to clear the program message queue.
 
     C                   PARM                    APRPYQUEUE
     C                   PARM                    PTimeStamp
     C                   PARM                    MsgFArray
     C                   PARM                    PClrPgmMsgQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Common header information (DS) from source system
 
     C                   PARM                    PHeadIn
 
      ** Transaction information in a single large field from source system
 
     C                   PARM                    PTrans500
     C                   PARM                    PExtData500
 
      ** Ultimate calling Program/Module/Procedure
 
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the MSGF from which the message handler will
      **  get the messages
 
     C                   EVAL      #MsgFile = 'ABUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
 
      ** Set up the Module ID, used to make the Transaction number unique
 
     C                   EVAL      PModuleID = 'DL'
 
      ** Set up the name of the server/database updater data queue.
 
     C                   EVAL      DtaQName = 'APLDNIDTQ'
 
      ** Access Bank details via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDAPIPD '
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger ICD via access program
      ** (database error handling done in access program)
 
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SD Dealing Data via access program
 
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SD Midas Module via access program
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SD Trading ICD  via access program
 
     C                   CALLB     'AOTRADR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDTRADPD'
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if S01383 is installed                                                         195001
                                                                                              195001
     C                   EVAL      S01383 = 'N'                                               195001
     C                   CALL      'AOSARDR0'                                                 195001
     C                   PARM      *Blanks       PRTCD                                        195001
     C                   PARM      '*VERIFY'     POPTN                                        195001
     C                   PARM      'S01383'      PSARD                                        195001
     C     SCSARD        PARM      SCSARD        DSFDY                                        195001
                                                                                              195001
     C                   IF        PRTCD = *Blanks                                            195001
     C                   EVAL      S01383 = 'Y'                                               195001
     C                   ELSE                                                                 195001
     C                   EVAL      S01383 = 'N'                                               195001
     C                   ENDIF                                                                195001
                                                                                              195001
      ** Database error.                                                                      195001
                                                                                              195001
     C                   IF        PRTCD <> *BLANKS  AND                                      195001
     C                             PRTCD <> '*NRF   '                                         195001
     C                   EVAL      DBKEY = PSARD                                              195001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        195001
     C                   EVAL      DBASE = 008                                                195001
     C                   EXSR      *PSSR                                                      195001
     C                   ENDIF                                                                195001
                                                                                              195001
      ** Access SD BRT Control Data
 
     C                   IF        S01383 = 'Y'                                               195001
     C                   EVAL      PKey = 'D'
     C     PKey          CHAIN     SDBRTDL1                           02
 
      ** Database error.
 
     C                   IF        *IN02 = *On  OR
     C                             RECI <> 'D'
     C                   EVAL      DBKEY = PKey
     C                   EVAL      DBFILE = 'SDBRTDPD'
     C                   Z-ADD     7             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                                195001
 
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT                                          CSC022
     C                   MOVEL     *BLANKS       COMITSKIP                                    CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
      ** Database error                                                                       CSC022
                                                                                              CSC022
     C                   IF        PRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = PSARD                                              CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 012                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
 
      ***Check*if*S01383*is*installed                                                         195001
      **********                                                                              195001
     C**********         EVAL      S01383 = 'N'                                               195001
     C**********         CALL      'AOSARDR0'                                                 195001
     C**********         PARM      *Blanks       PRTCD                                        195001
     C**********         PARM      '*VERIFY'     POPTN                                        195001
     C**********         PARM      'S01383'      PSARD                                        195001
     C*****SCSARD        PARM      SCSARD        DSFDY                                        195001
      **********                                                                              195001
     C**********         IF        PRTCD = *Blanks                                            195001
     C**********         EVAL      S01383 = 'Y'                                               195001
     C**********         ELSE                                                                 195001
     C**********         EVAL      S01383 = 'N'                                               195001
     C**********         ENDIF                                                                195001
      **********                                                                              195001
      ***Database*error.                                                                      195001
      **********                                                                              195001
     C**********         IF        PRTCD <> *BLANKS  AND                                      195001
     C**********                   PRTCD <> '*NRF   '                                         195001
     C**********         EVAL      DBKEY = PSARD                                              195001
     C**********         EVAL      DBFILE = 'SCSARDPD'                                        195001
     C**********         Z-ADD     8             DBASE                                        195001
     C**********         EXSR      *PSSR                                                      195001
     C**********         ENDIF                                                                195001
 
      ** Retrieve ZMUSER details.
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
      ** Retrieve RUNDAT details.
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Save Midas Run Date
 
     C                   EVAL      WkBJMRDT = BJMRDT
 
      ** Check if CSC011 is installed                                                         CSC011
      ** If CSC011 is installed and in switchover mode, use                                   CSC011
      ** S1DATE from DTAARA/SC24x7 as the rundate.                                            CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
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
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 009                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Check if CAS004 is installed                                                         CAS004
                                                                                              CAS004
     C                   CALLB     'AOSARDR0'                                                 CAS004
     C                   PARM      *BLANKS       PRtCd                                        CAS004
     C                   PARM      '*VERIFY'     POptn                                        CAS004
     C                   PARM      'CAS004'      PSard                                        CAS004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS004
                                                                                              CAS004
     C                   IF        PRtCd <> *BLANKS  and                                      CAS004
     C                             PRtCd <> '*NRF   '                                         CAS004
     C                   EVAL      DBKEY = PSard                                              CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBASE = 10                                                 CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   IF        PRtCd = *Blanks                                            CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CDL019
      ** Check if CDL019 is installed                                                         CDL019
                                                                                              CDL019
     C                   CALLB     'AOSARDR0'                                                 CDL019
     C                   PARM      *BLANKS       PRtCd                                        CDL019
     C                   PARM      '*VERIFY'     POptn                                        CDL019
     C                   PARM      'CDL019'      PSard                                        CDL019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL019
                                                                                              CDL019
     C                   IF        PRtCd = *Blanks                                            CDL019
     C                   EVAL      CDL019 = 'Y'                                               CDL019
     C                   ELSE                                                                 CDL019
     C                   EVAL      CDL019 = 'N'                                               CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL020
      ** Check if CDL020 is installed                                                         CDL020
                                                                                              CDL020
     C                   CALLB     'AOSARDR0'                                                 CDL020
     C                   PARM      *BLANKS       PRtCd                                        CDL020
     C                   PARM      '*VERIFY'     POptn                                        CDL020
     C                   PARM      'CDL020'      PSard                                        CDL020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL020
                                                                                              CDL020
     C                   IF        PRtCd = *Blanks                                            CDL020
     C                   EVAL      CDL020 = 'Y'                                               CDL020
     C                   ELSE                                                                 CDL020
     C                   EVAL      CDL020 = 'N'                                               CDL020
     C                   ENDIF                                                                CDL020
      ** Convert Midas Day Number to YYYYMMDD format
 
     C                   CALLB     'ZDATE9'
     C**********         PARM      BJRDNB        PDayNoIn                                     CSC011
     C                   PARM      WRunDay       PDayNoIn                                     CSC011
     C                   PARM      *ZERO         PDateOutZ9
     C                   PARM                    PRetCode
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
      /COPY WNCPYSRC,ABFUNDC021
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
