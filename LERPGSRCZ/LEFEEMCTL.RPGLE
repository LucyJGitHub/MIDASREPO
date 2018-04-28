     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee input details interface controller')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFEEMCTL - LE Fee Details Maintenance.                      *
      *                                                               *
      *  Function: This Program Validates LE Fees Details for         *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Fees details fields               *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For D (=Delete) call a separate function to      *
      *              process this Fee and bypass the rest             *
      *              of the validation                                *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. CSD095             Date 08Apr14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247770A            Date 31May07               *
      *                 247770             Date 16May07               *
      *                 247549             Date 03May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 13Feb07               *
      *                 245099             Date 19Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9496            Date 06Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20May04               *
      *                 BUG2571            Date 12May04               *
      *                 CDL018             Date 03Feb04               *
      *                 222373             Date 29Oct03               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247770A- Review 247770.                                      *
      *  247770 - Lending fees amendment are always rejected.         *
      *  247549 - Review delay processing.                            *
      *  244636 - If no settlement details for a fees are entered     *
      *           then default settlement details from related loan   *
      *  245099 - Pass CLE006 to LEFEEMAMD                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9496- Include CAS011 changes in GZLEFEED to align valids  *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2571 - (CSC022) Commitment Control Changes for MidasPlus. *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  222373 - Parameter Mismatch                                  *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Fees file
     FLEVFEEMPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Invalid Fee
     FLEIFEEMPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FLEVFEEML0 IF   E           K DISK
     F                                     RENAME(LEVFEEMD0:LEVFEEMCK0)
     FLEVFEEML1 IF   E           K DISK
     F                                     RENAME(LEVFEEMD0:LEVFEEMCK1)
 
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEEDF1)
     FLEFHSTL1  IF   E           K DISK
      *
     FAPIDSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LEFEEMC001
 
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
 
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
 
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
      *  Array for job name                                                                  BUG2571
     D ARRJBNAM        S             10A   DIM(10)                                           BUG2571
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranIn        E DS                  EXTNAME(LEFEEMPD)
      * Valid Fee layout
     D ValidFeem     E DS                  EXTNAME(LEVFEEMPD)
     D                                     PREFIX(V_)
     D**ValidREC             294    362                                                       247770
     D  ValidREC1            294    295                                                       247770
     D  ValidREC2            308    362                                                       247770
     D  ValidREC3           1076   1093                                                       247770
     D**ValidPAY             363    921                                                       247770
     D  ValidPAY1            363    364                                                       247770
     D  ValidPAY2            377    921                                                       247770
     D  ValidPAY3           1094   1111                                                       247770
 
      * (Current) Fee record in file Format
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(FE_)
     D**FeemREC              294    362                                                       247770
     D  FeemREC1             294    295                                                       247770
     D  FeemREC2             308    362                                                       247770
     D  FeemREC3            1076   1093                                                       247770
     D**FeemPAY              363    921                                                       247770
     D  FeemPAY1             363    364                                                       247770
     D  FeemPAY2             377    921                                                       247770
     D  FeemPAY3            1094   1111                                                       247770
 
      * (Current) Fee in Screen Format
     D CrFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
     D                                     PREFIX(@)
 
      * Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
 
      * Facility record FM in file Format
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FA_)
 
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions - Input
 
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions - Input
 
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions - Input
 
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)
      * Pay Settlement Instructions - Current
 
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)
      * Receive Settlement Instructions - Current
 
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)
      * FRA/IRS Settlement Instructions - Current
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D**FLREC                  1     69                                                       247770
     D  FLREC                  1     90                                                       247770
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D**FLPAY                  1    559                                                       247770
     D  FLPAY                  1    584                                                       247770
 
      * File Fra/irs instructions
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
 
      * Error indicators
     D OkFee         E DS                  EXTNAME(LEEFEEMPD)
 
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
 
      *                                                                                      BUG2571
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG2571
      ** Midas SC Jobs handling commitment control data area                                 BUG2571
     D  COMITNOM               1      3S 0                                                   BUG2571
     D  COMITJOB               4    103                                                      BUG2571
      *                                                                                      BUG2571
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **   CUSTOMER
 
      *
     D ExtData       E DS                  EXTNAME(LEFEEXPD)
      * SD Facility details Extra Data - File (D/B) format
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D                 DS
     D  DDFEER                 1     19
     D  DDCUSNA                1      6
     D  DDFACTA                7      9
     D  DDFCNOA               10     11
     D  DDLNRFA               12     17
     D  DDFSEQA               18     19
      * DS which contains the complete key
 
     D ValidREC        DS                                                                     247770
     D  ValidRECA              1      2                                                       247770
     D**ValidRECB              3     57                                               247770 247770A
     D  ValidRECB              3     20                                                      247770A
     D**ValidRECC             58     75                                               247770 247770A
     D  ValidRECC             21     75                                                      247770A
                                                                                              247770
     D ValidPAY        DS                                                                     247770
     D  ValidPAYA              1      2                                                       247770
     D**ValidPAYB              3    547                                               247770 247770A
     D  ValidPAYB              3     20                                                      247770A
     D**ValidPAYC            548    565                                               247770 247770A
     D  ValidPAYC             21    565                                                      247770A
                                                                                              247770
     D FeemREC         DS                                                                     247770
     D  FeemRECA               1      2                                                       247770
     D**FeemRECB               3     57                                               247770 247770A
     D  FeemRECB               3     20                                                      247770A
     D**FeemRECC              58     75                                               247770 247770A
     D  FeemRECC              21     75                                                      247770A
                                                                                              247770
     D FeemPAY         DS                                                                     247770
     D  FeemPAYA               1      2                                                       247770
     D**FeemPAYB               3    547                                               247770 247770A
     D  FeemPAYB               3     20                                                      247770A
     D**FeemPAYC             548    565                                               247770 247770A
     D  FeemPAYC              21    565                                                      247770A
                                                                                              247770
      ** +--------------------------------------+                                            BUG2571
      **   Use of Indicator                                                                  BUG2571
      **   ================                                                                  BUG2571
      ** ¶                                      ¶                                            BUG2571
      ** ¶ 17      Used by LOOKUP               ¶                                            BUG2571
      ** +--------------------------------------+                                            BUG2571
                                                                                             BUG2571
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
 
     D                 DS
      ** Data structure to set partial key
     D**WCNUM***               1      6  0                                                    CSD027
     D  WCNUM                  1      6A                                                      CSD027
     D  WFAC03                 7      9  0
     D  WFAC02                10     11  0
     D  WFACL                  7     11
     D  WFAC05                 7     11  0
     D**WLOAN***              12     17  0                                                    CLE148
     D  WLOAN                 12     17                                                       CLE148
     D  WFSEQ                 18     19  0
     D  WFPKEY                 1     19  0
 
      ** Branch code
     D  FeeBranch                     3A
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('LEFEEMUPC')
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
 
     D CSC011          S              1A   INZ('N')
     D TRANSDTL        S           5800A
     D PDealNo         S             18A
     D PADealNo        S             18A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
     D CSC022          S              1A   INZ('N')                                          BUG2571
      ** Counter variable                                                                    BUG2571
     D WCMT01          S              1A                                                     BUG2571
      ** Commitment Flag                                                                     BUG2571
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   inz('N')
                                                                                              244636
      ** Parameter for LEFEEMRTV                                                              244636
     D PRcvParm        S             92                                                       244636
 
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
     D WTRCcy          S              3A                                                     CSF011A
     D WTPCcy          S              3A                                                     CSF011A
                                                                                             CSF011A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEFEEMC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,LEFEEMC003
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranIn
     C                   MOVEL     Extdata500    Extdata
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      *  Set user field depending on action
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
     C                   EVAL         F3IUSR = APMIDUSR
     C                   WHEN         DDACTN = 'X'
     C                   EVAL         F3XUSR = APMIDUSR
     C                   WHEN         DDACTN = 'A'
     C                   EVAL         F3AUSR = APMIDUSR
 
     C                   ENDSL
 
      /COPY WNCPYSRC,LEFEEMC004
 
      *  Check if valid Fee details exists
 
     C                   EXSR      ChkValFeem
      *
      *  If valid Fee detail does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Check if valid Fee exists for Midas Fee Number
 
     C                   EXSR      ChkValMiFe
      *
      *  If valid Fee does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Fee details file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,LEFEEMC005
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
 
      /COPY WNCPYSRC,LEFEEMC006
      *
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,LEFEEMC007
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,LEFEEMC008
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateSt
 
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'D'
      *  Processing for Amends or Changes
 
      /COPY WNCPYSRC,LEFEEMC009
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   if        DDACTN = 'A' AND GHSUBS <> *blank
 
     C     GHSUBS        scan      TranIn                                 99
     C                   if        *in99
     C                   eval      RepPrim = 'Y'
     C                   endif
 
      ** If the flag set above is true, do the data
      ** substution subroutine.
     C                   if        (RepPrim = 'Y')
     C                   EXSR      DtaSubs
     C                   endif
 
     C                   endif
 
     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,LEFEEMC010
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,LEFEEMC011
     C                   EXSR      ValidateSt
     C                   EXSR      ValdateAmd
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,LEFEEMC012
 
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
 
      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,LEFEEMC013
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,LEFEEMC014
 
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
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LEFEEMC015
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValFeem - Routine to check if valid Fee details exist      *
      *                                                               *
      *****************************************************************
     C     ChkValFeem    BEGSR
 
 
      * Check for Fee on Valid file
     C     ApFoTranid    CHAIN     LEVFEEML0                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     ApFoTranid    CHAIN     LEVFEEML0                          99
     C                   END                                                                  247549
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFEER'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                               *
      * ChkValMiFe - Routine to check if valid Fee exists for         *
      *    Midas Fee reference                                        *
      *                                                               *
      *****************************************************************
 
     C     ChkValMiFe    BEGSR
 
      ** Key list for file LEVFEEML1
     C     KMIFEE        KLIST
     C**********         KFLD                    KCNUM             6 0                        CSD027
     C                   KFLD                    KCNUM             6                          CSD027
     C                   KFLD                    KFACT             5 0
     C**********         KFLD                    KLNRF             6 0                        CLE148
     C                   KFLD                    KLNRF             6                          CLE148
     C                   KFLD                    KFSEQ             2 0
      *
      * If (numeric) Midas Customer number supplied
 
     C**********         TESTN                   DDCSSN               9898                    CSD027
      *
     C******IN98         IFEQ      *OFF                                                       CSD027
      * If not numeric, retrieve Midas Customer number supplied
     C                   CALLB     'AOCUSTR1'
      *
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCSSN        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C*
     C     @RTCD         IFNE      *BLANKS
     C     @KYST         OREQ      '*ERROR '
     C     @KYST         ORNE      '*CNUM  '                                                  CSD027
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFEER'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ELSE
     C                   MOVEL     *BLANKS       DDCUSN            6
     C                   MOVEL     BBCUST        DDCUSN
     C                   END
      *
     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     DDCSSN        DDCUSN                                       CSD027
     C**********         ENDIF                                                                CSD027
 
      * If (numeric) Midas Facility type is supplied
 
     C                   TESTN                   DDFACT               9797
 
      * If (numeric) Midas Facility sub-type supplied
 
     C                   TESTN                   DDFCNO               9696
 
      * If (numeric) Midas Loan number supplied
 
     C**********         TESTN                   DDLNRF               9595                    CLE148
 
      * If (numeric) Midas Fee sequence supplied
 
     C                   TESTN                   DDFSEQ               9494
 
     C     DDCSSN        IFNE      *BLANKS
     C     *IN97         ANDEQ     '1'
     C     *IN96         ANDEQ     '1'
     C******IN95         ANDEQ     '1'                                                        CLE148
     C     *IN94         ANDEQ     '1'
 
      * Check for Fee on Valid file
     C                   MOVEL     DDCUSN        KCNUM
     C                   MOVEL     DDFACT        KFACT
     C                   MOVE      DDFCNO        KFACT
     C                   MOVEL     DDFSEQ        KFSEQ
     C     KMIFEE        CHAIN     LEVFEEML1                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     KMIFEE        CHAIN     LEVFEEML1                          99
     C                   END                                                                  247549
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFEER'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Fee supplied                                               *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  if insert
      *  if not insert and Midas transaction ID is not present
      * Otherwise
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      TranIn        SubForTRNN        2 0
     C                   ENDIF
     C                   IF        DDACTN = 'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C     DDCSSN        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF
     C                   ENDIF
 
      * Validate action code versus transaction IDs supplied
      * The Fee in file format from the LE database is retrieved
      * as well.
 
     C                   RESET                   ReturnCode
     C                   MOVEL     APUSERID      APFOTranUs
 
     C                   CALLB     'LEFEEMRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * Front Office User
     C                   PARM                    APFOTranUs       16
      *
      * (Midas) Facility Reference Number
     C                   PARM                    DDCSSN
     C                   PARM                    DDFACT
     C                   PARM                    DDFCNO
     C                   PARM                    DDLNRF
     C                   PARM                    DDFSEQ
      *
      * CSC011 processing date
     C                   PARM                    WRNDAY
      *
      * OUTPUTS
      *
      * (Current) Fee in file format
     C                   PARM                    CrFeFilFmt
      *
      * Loan CL in file format
     C                   PARM                    ClilFilFmt
      *
      * Facility FM in file format
     C                   PARM                    FacmFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Customer Number
     C                   PARM                    OKCSSN            1
      *
      * OK - Facility type
     C                   PARM                    OKFACT            1
      *
      * OK - Facility sub type
     C                   PARM                    OKFCNO            1
      *
      * OK - Loan reference
     C                   PARM                    OKLNRF            1
      *
      * OK - Fee sequance
     C                   PARM                    OKFSEQ            1
      *
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      * Expiry date
     C                   PARM                    WDTEX             5 0
      * Facility amount
     C                   PARM                    WFAMT            13 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    PRcvParm                                     244636
 
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
 
      ** Output
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4
      * Payment currency
     C                   PARM      DDECUR        ##PCCY            3
      * Receive currency
     C                   PARM      DDECUR        ##RCCY            3
      ** Customer (shortname or number)
     C                   PARM      DDCSSN        ##CSNM           10
      * Transaction Type
     C                   PARM      *BLANKS       ##TTYP            2
      ** Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND            1
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    Blank4            4
      ** Type of ISDA agreement
     C                   PARM                    Blank6            6
      ** Date of ISDA Agreement
     C                   PARM                    Blank6
      ** Version of ISDA Agreement
     C                   PARM                    Blank2            2
      ** Version of ISDA Agreement century
     C                   PARM                    Blank2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    F_PAY
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    F_REC
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    F_FRI
 
     C                   EVAL      WTRCcy = DDECUR                                           CSF011A
     C                   EVAL      WTPCcy = DDECUR                                           CSF011A
     C                                                                                       CSF011A
      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.
 
     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM      *BLANK        F_FRI
 
      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      WTRCcy        #TRCCY                                      CSF011A
     C                   PARM      WTPCcy        #TPCCY                                      CSF011A
 
     C                   ENDIF
 
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
     C                   IF        NOT (OKCSSN = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF
 
      *
      ** PAYMENT DATE & RECEIVE DATE = RUN DATE
      *
     C                   Z-ADD     BJRDNB        ##DATP
     C                   Z-ADD     BJRDNB        ##DATR
      *
      ** DEFINE FEE BRANCH: IF INSERT MODE IT COMES FROM LOAN FILE OR FACILITY FILE
      ** ELSE FROM FEE FILE
     C                   IF        NOT (DDACTN = 'I')
     C                   EVAL         FeeBranch = FE_FEBRCA
     C                   ELSE
 
     C                   IF        NOT (DDLNRF = *Blanks)
     C                   EVAL         FeeBranch = CL_BRCA
     C                   ELSE
     C                   EVAL         FeeBranch = FA_BRCA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'
 
      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM      'LEND'        ##CALP            4
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM      DDECUR        ##PCCY            3
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM      DDECUR        ##RCCY            3
      ** Customer (shortname or number)
     C                   PARM      DDCSSN        ##CSNM           10
      ** Deal type
     C                   PARM      *BLANKS       ##TTYP            2
      ** Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      ** Booking Branch
     C                   PARM      FeeBranch     ##BRCA            3
      ** Receipt Date
     C                   PARM                    ##DATR            5 0
      ** Payment Date
     C                   PARM                    ##DATP            5 0
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
 
      * Action Code
     C                   PARM      DDACTN        ##ACTN            1
 
      * Protect Payment Field
     C                   PARM                    ##PAYS            1
 
      * Protect Receive Field
     C                   PARM                    ##RECS            1
 
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
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM                    F_FRI
      ** Extra Input
      ** Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
 
      *
      ***  Extra validation after the Extended Settlements
      *
     C                   CALLB     'LEFEEMEVL'
      * INPUTS
 
      * Response mode
     C                   PARM                    APRESPMODE
      * Fee detail file
     C                   PARM                    CrFeFilFmt
      * Fee detail screen
     C                   PARM                    CrFeScnFmt
      * Fee Valid file
     C                   PARM                    ValidFeem
      * CEU004
     C                   PARM                    CEU004
      * Payment instructions
     C                   PARM                    F_Pay
      *
      *  Receive instructions
     C                   PARM                    F_REC
      *
      *  FRA/IRS instructions
     C                   PARM                    F_FRI
 
      * OUTPUTS
 
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFee
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
 
     C                   MOVEL     FLREC         ValidREC
     C                   MOVEL     ValidRECA     ValidREC1                                    247770
     C**********         MOVEL     ValidRECB     ValidREC2                            247770 247770A
     C                   MOVEL     ValidRECB     ValidREC3                                   247770A
     C**********         MOVEL     ValidRECC     ValidREC3                            247770 247770A
     C                   MOVEL     ValidRECC     ValidREC2                                   247770A
     C                   MOVEL     FLPAY         ValidPAY
     C                   MOVEL     ValidPAYA     ValidPAY1                                    247770
     C**********         MOVEL     ValidPAYB     ValidPAY2                            247770 247770A
     C                   MOVEL     ValidPAYB     ValidPAY3                                   247770A
     C**********         MOVEL     ValidPAYC     ValidPAY3                            247770 247770A
     C                   MOVEL     ValidPAYC     ValidPAY2                                   247770A
     C                   MOVE      FLCVMR        V_VFCVMR
     C                   MOVE      FLPOBR        V_VFOMDB
     C                   MOVE      FLROBR        V_VFOSDB
     C                   MOVE      FLPSCY        V_VFSCCY
     C                   MOVE      FLIC72        V_VFICCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        V_VFFEREXR                                   CLE031
     C                   Z-ADD     FLPEXR        V_VFFEPEXR                                   CLE031
     C                   MOVE      FLREXI        V_VFFEREXI                                   CLE031
     C                   MOVE      FLPEXI        V_VFFEPEXI                                   CLE031
     C                   MOVE      FLRSCY        V_VFSCCY                                     CLE031
     C                   MOVE      FLPSCY        V_VFFEPSCY                                   CLE031
     C                   ENDIF                                                                CLE031
 
     C     ValSetExit    TAG
 
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
 
      * For Amends, put the complete (pre-existing) Fee into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVE      CrFeFilFmt    ValidFeem
 
     C                   MOVEL     FeemRecA      FeemRec1                                     247770
     C                   MOVEL     FeemRecB      FeemRec2                                     247770
     C                   MOVEL     FeemRecC      FeemRec3                                     247770
     C                   EVAL      F_REC  = FeemRec + FE_OSDB
     C                   EVAL      FLRSCY = FE_FESCCY
     C                   MOVEL     FeemPayA      FeemPay1                                     247770
     C                   MOVEL     FeemPayB      FeemPay2                                     247770
     C                   MOVEL     FeemPayC      FeemPay3                                     247770
     C                   EVAL      F_PAY  = FeemPay + FE_OMDB + FE_CVMR
     C                   EVAL      FLPSCY = FE_FESCCY
     C                   EVAL      FLIC72 = FE_FEICCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FE_FEREXR     FLREXR                                       CLE031
     C                   Z-ADD     FE_FEPEXR     FLPEXR                                       CLE031
     C                   MOVE      FE_FEREXI     FLREXI                                       CLE031
     C                   MOVE      FE_FEPEXI     FLPEXI                                       CLE031
     C                   MOVE      FE_FESCCY     FLRSCY                                       CLE031
     C                   MOVE      FE_FEPSCY     FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   EVAL      WTRCcy = FE_FEFCCY                                        CSF011A
     C                   EVAL      WTPCcy = FE_FEFCCY                                        CSF011A
     C                                                                                       CSF011A
      *  .... and then convert these to the screen format
     C                   CALLB     'ZASETINCVT'
 
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM                    F_FRI
 
      ** Current Settlement Instruction in input format
     C                   PARM                    CrPaySttmt
     C                   PARM                    CrRecSttmt
     C                   PARM                    CrFRASttmt
     C                   PARM      WTRCcy        #TRCCY                                      CSF011A
     C                   PARM      WTPCcy        #TPCCY                                      CSF011A
 
      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the deal.
 
     C                   IF            (InPaySttmt = *blank)
     C                   EVAL      InPaySttmt = CrPaySttmt
     C                   ENDIF
 
     C                   IF            (InRecSttmt = *blank)
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
 
      * For Amends, convert the Fee to screen format
 
     C                   CALLB     'LEFEEMCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Fee file format
     C                   PARM                    ValidFEEM
      *
      * Loan (LN) file format
     C                   PARM                    ClilFilFmt
      *
      * Facility FM in file format
     C                   PARM                    FacmFilFmt
      * CLE006
     C                   PARM                    CLE006
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      *
      * Output parameters
      *
      * Fee Details - screen format
     C                   PARM                    CrFeScnFmt
      *
      * Participant Fee indicator
     C                   PARM                    WPTFI             1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Fee details
 
     C                   EXSR      ValdFee
      *                                                                                       244636
      ** Default settlement details from related loan                                         244636
     C                   IF        InRecSttmt = *blank AND                                    244636
     C                             PRcvParm <> *blank                                         244636
     C                   MOVEL     PRcvParm      InRecSttmt                                   244636
     C                   ENDIF                                                                244636
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdFee - Validate Fee details                                *
      *                                                               *
      *****************************************************************
     C     ValdFee       BEGSR
 
     C                   CALLB     'LEFEEMVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    APRespMode
      * Mode
     C                   PARM                    ModeOfop
      ** Fee Details
     C                   PARM                    TranIn
      ** Fee Details - Settlement instructions
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFraSttmt
      ** Fee File format
     C                   PARM                    CrFeFilFmt
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      * Loan CL in file format
     C                   PARM                    ClilFilFmt
      * Facility FM in file format
     C                   PARM                    FacmFilFmt
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND
      * Participant Fee indicator
     C                   PARM                    WPTFI
      * Expiry date
     C                   PARM                    WDTEX             5 0
      * Facility amount
     C                   PARM                    WFAMT            13 0
      * CLE006
     C                   PARM                    CLE006
      * CEU004
     C                   PARM                    CEU004
      * Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F3PCOB            3
     C                   PARM                    F3TNRF           15
     C                   PARM                    F3IUSR           10
     C                   PARM                    F3XUSR           10
     C                   PARM                    F3AUSR           10
     C                   PARM                    F3TRDS            8
      * Customer Extra Data file data
     C                   PARM                    ExtData
      * OUTPUTS
      *
      ** Fee Details OK inds
     C                   PARM                    OkFee
 
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
 
      * Valid Fee layout (DS) from/to caller
     C                   PARM                    ValidFeem
 
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
      *
      ** This subroutine calls a procedure which checks whether it
      ** was valid to Amend or Change any of the fields which have been
      ** altered.  Some are never amendable and some are amendable depending
      ** on the Action Code - "A" for Amend.
 
      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.
 
      ** These fields are then compared with the fields on the input
      ** transaction.
 
      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.
 
     C                   CALLB     'LEFEEMAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Fee in Screen Format
     C                   PARM                    TranIn
      *
      * (Current) Fee in Screen Format
     C                   PARM                    CrFeScnFmt
      *
      * Fee in file format
     C                   PARM                    ValidFeem
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OkFee
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
                                                                                              245099
     C                   PARM                    CLE006                                       245099
 
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
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report Fee status
      *  If any errors were found:
      *     - write a record to the Invalid file
      *     - call the message handler to pass the errors back
      *     - use std message handler to report trade status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
†††††
††††† ** +--- Note for a later release -------------------------------+
††††† ** ¶                                                            ¶
††††† ** ¶ At a later date this routine will have to cater for        ¶
††††† ** ¶ warning messages.  The following logic will have to be     ¶
††††† ** ¶ inserted before "If no errors were found", in the          ¶
††††† ** ¶ above comments (and the code):                             ¶
††††† ** ¶                                                            ¶
††††† ** ¶ If 'Ignore warning messages' (from API ICD) is 'N', AND    ¶
††††† ** ¶ any warning messages were returned (WIdx <> 0)             ¶
††††† ** ¶                                                            ¶
††††† ** ¶ -†††If errors exist                                        ¶
††††† ** ¶†††††-†††††Add the warning array index to the error array   ¶
††††† ** ¶†††††††††††index                                            ¶
††††† ** ¶†††††-†††††Append the contents of the warning arrays to the ¶
††††† ** ¶†††††††††††end of the error arrays                          ¶
††††† ** ¶ -†††Else                                                   ¶
††††† ** ¶ ††††-†††††Set the error array index equal to the warning   ¶
††††† ** ¶†††††††††††array index                                      ¶
††††† ** ¶†††††-†††††Copy the contents of the warning arrays to the   ¶
††††† ** ¶†††††††††††error arrays                                     ¶
††††† ** ¶ -†††Endif                                                  ¶
††††† ** ¶                                                            ¶
††††† ** ¶ Endif                                                      ¶
††††† ** ¶                                                            ¶
††††† ** ¶ Note that the "If errors exist ... Else ... " block above  ¶
††††† ** ¶ can probably be implemented unconditionally (ie the same   ¶
††††† ** ¶ logic will apply whether errors exist as well as warnings  ¶
††††† ** ¶ or not).  It is shown in the above form for clarity.       ¶
††††† ** ¶                                                            ¶
††††† ** +------------------------------------------------------------+
 
 
     C                   IF        Idx = 0
 
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPFSEQ
     C                   ENDIF
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   WRITE     LEVFEEMD0
 
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C                   ENDIF
 
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *
      * Only write to invalid files if repair in back office
     C                   IF        APRprLocn = 'B'
 
     C                   WRITE     LEIFEEMD0
     C                   WRITE     APIDSETD0
 
      ** Write all invalid records to the support log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      TRANSDTL = TranIn     +
     C                                        InRecSttmt +
     C                                        InPaySttmt
 
     C                   EVAL      APTGTTYPE  = 'LEFEEM'
 
     C                   IF        DDFACT <> *BLanks
     C                   EVAL      PDealNo = DDCSSN + DDFACT +
     C                                       DDFCNO + DDFSEQ
     C                   ELSE
     C                   EVAL      PDealNo = DDCSSN + DDLNRF +
     C                                       DDFSEQ
     C                   ENDIF
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    Timestamp
     C                   PARM                    PDealNo
     C                   PARM      *BLANKS       PADealNo
 
      ** Database error
 
     C                   IF        RetCodeOut <> *BLanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PDealNo
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
     C     CSC022        IFEQ      'N'                                                       BUG2571
     C     WCMT01        OREQ      'N'                                                       BUG2571
     C     CSC022        ANDEQ     'Y'                                                       BUG2571
     C                   COMMIT
     C                   ENDIF                                                               BUG2571
 
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
 
     C                   CLEAR                   CrFeScnFmt
 
     C                   MOVE      *ALL'Y'       OkFee
 
     C                   CLEAR                   ValidFEEM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *      Invalid file record.                                     *
      *                                                               *
      *****************************************************************
 
     C     SETUPINVAL    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid files
 
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDFOAsocID = APFOAsocID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,LEFEEMC016
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
 
      * For Delete or Authorisation
      * put the complete (pre-existing) Fee
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                                OR DDACTN = 'X'
     C                   MOVE      CrFeFilFmt    ValidFeem
     C                   ENDIF
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_VFLCHT = DDACTN
 
      * Include Header fields that need to be o/p to the Valid file
     C     APFOTranID    Ifeq      *Blank
     C                   MOVEL     V_VFPCRF      V_VFFRNT
     C                   Else
     C                   EVAL      V_VFFRNT = APFOTranID
     C                   EndIf
     C                   EVAL      V_VFAFRT = APFOAsocID
     C                   EVAL      V_VFREPA = APRprLocn
     C                   EVAL      V_VFSTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,LEFEEMC017
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
 
     C                   IF        DDFACT <> *BLanks
     C                   EVAL      PTranid = DDCSSN + DDFACT +
     C                                       DDFCNO + DDFSEQ
     C                   ELSE
     C                   EVAL      PTranid = DDCSSN + DDLNRF +
     C                                       DDFSEQ
     C                   ENDIF
 
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM      *BLANK        ReturnCode
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
      ** Midas transaction ID (20A, from caller)
     C                   PARM                    PTranID          20
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
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
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
 
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
     C                   PARM      GHSUBS        SubsChar          1
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
      /eject
      *****************************************************************
      *                                                               *
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************
 
     C     DtaSubs       begsr
 
      ** Convert file fields to screen format
     C                   reset                   ReturnCode
 
     C                   CALLB     'LEFEEMCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Fee file format
     C                   PARM                    ValidFEEM
      *
      * Loan (LN) file format
     C                   PARM                    ClilFilFmt
      *
      * Facility FM in file format
     C                   PARM                    FacmFilFmt
      * CLE006                                                                               222373
     C                   PARM                    CLE006                                      222373
      * Fee against a syndicated facility/loan                                               222373
     C                   PARM                    WSYND                                       222373
      *
      * Output parameters
      *
      * Fee Details - screen format
     C                   PARM                    CrFeScnFmt
      *                                                                                      222373
      * Participant Fee indicator                                                            222373
     C                   PARM                    WPTFI                                       222373
 
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
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
     C                   PARM      TranIn        IncData        2000
      * Current Data
     C                   PARM      CrFeScnFmt    CurData        2000
 
     C                   MOVEL     IncDATA       TranIn
 
     C                   endif
 
     C                   endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPFSEQ - Set up Sequence for Inserts                       *
      *                                                               *
      *****************************************************************
 
     C     SETUPFSEQ     BEGSR
 
     C                   IF           DDFSEQ = *blanks
     C                             OR DDFSEQ = *zeros
 
     C                   EXSR      SEQGEN
      ** If Fee sequence was entered, put it in the file field
     C                   ENDIF
 
     C                   MOVE      FEFSEQ        V_VFFSEQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SEQGEN - Subroutine to generate fee sequence number          *
      *****************************************************************
     C     SEQGEN        BEGSR                                                  *** SEQGEN ***
      *
     C                   MOVEL     DDCSSN        WCNUM
     C                   MOVE      DDFACT        WFAC02
     C                   MOVE      DDFCNO        WFAC03
     C                   MOVE      DDLNRF        WLOAN
     C                   Z-ADD     99            WFSEQ
      *
      **  Prevent pick up of details from previous fee
     C     KEY002        SETGT     LEFEEDF1
     C     KEY005        READPE    LEFEEDF1                               78
      *
     C     *IN78         IFEQ      '1'
     C                   MOVE      '01'          FEFSEQ
      *
     C                   ELSE
      *
     C     WCNUM         IFEQ      FECNUM
     C     WLOAN         ANDEQ     FELOAN
     C     WFAC05        ANDEQ     FEFACL
     C                   ADD       1             FEFSEQ
      *
     C                   ELSE
      *
      ** There are no existing fee records with the key fields input so
      ** put original values back in key fields ready for file update
      ** and allocate a fee sequence no. of 01.
      *
     C                   MOVE      WCNUM         FECNUM
     C**********         Z-ADD     WLOAN         FELOAN                                       CLE148
     C                   MOVEL     WLOAN         FELOAN                                       CLE148
     C                   Z-ADD     WFAC05        FEFACL
     C                   MOVE      '01'          FEFSEQ
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Having checked the live fees the matured fees need to be
      ** checked in the same way
      *
     C     KEY012        SETGT     LEFHSTF
     C     KEY015        READPE    LEFHSTF                                78
      *
     C     *IN78         IFEQ      '0'
      *
     C     WCNUM         IFEQ      HICNUM
     C     WLOAN         ANDEQ     HILNRF
     C     WFAC05        ANDEQ     HIFACL
     C                   ADD       1             HIFSEQ
      *
     C                   ELSE
     C                   MOVE      '01'          HIFSEQ
      *
     C                   ENDIF
     C                   ENDIF
      *
      **  Store allocated sequence number for output
     C     FEFSEQ        IFGT      HIFSEQ
     C                   MOVE      FEFSEQ        @ALSEQ            2
     C                   ELSE
     C                   MOVE      HIFSEQ        @ALSEQ            2
     C                   ENDIF
      *
     C                   MOVE      @ALSEQ        FEFSEQ
      *
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
      * Transaction information
     C                   PARM                    Trans5001
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    ExtData500
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'LERMSGF '
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'Y2USRMSG'
 
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'LE'
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Determine if EMU LE Settlement Currency Conversion
      ** Upgrade feature is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CEU004            1
     C                   ELSE
     C                   MOVEL     'Y'           CEU004
     C                   ENDIF
 
      ** Determine if CLE006 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE006            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE006
     C                   ENDIF
      *
      ** Determine if CSC011 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CSC011            1
     C                   ELSE
     C                   MOVEL     'Y'           CSC011
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C* Is the support system on?
     C     S1SUPP        IFEQ      LIBR
     C                   Z-ADD     S1DATE        WRNDAY            6 0
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APFeemDTQ'
 
      ** KLIST for file LEFEED
     C     KEY002        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
     C                   KFLD                    WFSEQ
      *
      ** KLIST for file LEFEED
     C     KEY005        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
      *
      ** KLIST for file LEFHSTL1
     C     KEY012        KLIST
     C                   KFLD                    FE_FEBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
     C                   KFLD                    WFSEQ
      *
      ** KLIST for file LEFHSTL1
     C     KEY015        KLIST
     C                   KFLD                    FE_FEBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WFAC05
     C                   KFLD                    WLOAN
     C*
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEFEEMC018
      * Determine if CSC022 is switched on                                                   BUG2571
                                                                                             BUG2571
     C                   CALLB     'AOSARDR0'                                                BUG2571
     C                   PARM      *BLANKS       @RTCD                                       BUG2571
     C                   PARM      '*VERIFY'     @OPTN                                       BUG2571
     C                   PARM      'CSC022'      @SARD                                       BUG2571
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG2571
     C                   IF        @RTCD = *BLANK                                            BUG2571
     C                   EVAL      CSC022 ='Y'                                               BUG2571
     C                   EVAL      WCMT01 ='N'                                               BUG2571
      * SCCMTJOB data area                                                                   BUG2571
     C                   IN        SCCMTJOB                                                  BUG2571
      * Move data area to commitment array                                                   BUG2571
     C                   IF        COMITNOM > 0                                              BUG2571
     C                   MOVEA     COMITJOB      ARRJBNAM                                    BUG2571
      *                                                                                      BUG2571
      * Check if PSJOBNAME exist.                                                            BUG2571
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                 BUG2571
     C                   IF        *IN17 = *ON                                               BUG2571
     C                   EVAL      WCMT01= 'Y'                                               BUG2571
     C                   ENDIF                                                               BUG2571
     C                   ENDIF                                                               BUG2571
      *                                                                                      BUG2571
     C                   ELSE                                                                BUG2571
      * @rtcd not found                                                                      BUG2571
     C                   IF        @RTCD <> '*NRF'                                           BUG2571
     C     *LOCK         IN        LDA                                                       BUG2571
     C                   EVAL      DBPGM = 'LEFEEMCTL'                                       BUG2571
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2571
     C                   EVAL      DBFILE ='SCSARDPD'                                        BUG2571
     C                   EVAL      DBASE  = 902                                              BUG2571
     C                   OUT       LDA                                                       BUG2571
     C                   EXSR      *PSSR                                                     BUG2571
     C                   ENDIF                                                               BUG2571
     C                   ENDIF                                                               BUG2571
                                                                                             BUG2571
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
     C                   ELSE                                                                 CLE031
     C     @RTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '908'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
