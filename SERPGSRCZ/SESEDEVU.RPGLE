     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security diary events interface cntroller')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDEVU - Security Diary Events Validate and Update         *
      *                                                               *
      *  Function: This module validates Security Diary Events input  *
      *            into the Midas database.                           *
      *            Processes to be executed controlled by input       *
      *            Action Code:                                       *
      *            - For I (=INSERT) or A (=AMEND), validate the      *
      *              Security Diary Events.                           *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE) and E (=Enquire), call a         *
      *              seperate function to process the transaction and *
      *              bypass the rest of the validation.               *
      *                                                               *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. MD037742           Date 01Apr16               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 237063             Date 20Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG7029            Date 09Jun05               *
      *                 BUG6782            Date 11May05               *
      *                 CSE072             Date 05Apr05               *
      *                 BUG4728            Date 05Nov04               *
      *                 BUG4258            Date 13Sep04               *
      *                 CAP084  *Create    Date 08Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD037742 - Security diary events - pool factor reversal.     *
      *             Patterned after 260331 changes in SESEDESIN.      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG6782- Redeliver to core.                                  *
      *  CSE072 - INT-CC3 - Brazilian C-Bonds                         *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  BUG4258- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRChkValMTran - Routine to check if valid security diary     *
      *                  events exist for security shortname, event   *
      *                  date and event type in the valid security    *
      *                  diary events file.                           *
      *  SRValAction - Routine to validate Action Code for the        *
      *                security shortname, event date and event type  *
      *                supplied                                       *
      *  SRValDetails - Routine to validate Security Diary Events Det.*
      *  SRDefault1 - Defaulting for screen 1                         *
      *  SRVScrn1  - Validate screen 1 details                        *
      *  SRCvtSeDE - Convert security diary events details from file  *
      *              to screen format                                 *
      *  SRDtaSubs - Data Substitution Routine                        *
      *  SRValAmend - Routine to check whether the fields are         *
      *               amendable                                       *
      *  SetupValid - Routine to set up fields in the valid file      *
      *               record.                                         *
      *  SRResetFld - Routine to reset fields                         *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Valid security diary events by key fields and timestamp
     FSEVSEDEL1 IF   E           K DISK    RENAME(SEVSEDED0:SEVSEDECHM)
      *
      ** Sequence number for input fields
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      ** Midas Module Flag file
     FMMODF     IF   E             DISK    INFSR(*PSSR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESEDEC001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes definition  for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
      /COPY ZACPYSRC,PROCPARMS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
 
      /COPY ZACPYSRC,APICTLARR
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
 
      /COPY ZACPYSRC,DTAQCHKDCL
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      *
      ** Message header details
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
      *
      ** SE Diary Events Screen details from incoming transaction -
      ** - screen format
     D SedeScnFmt    E DS                  EXTNAME(SESEDEPD)
      *
      ** SE Diary Events for file update - file format
     D Sede1FilFmt   E DS                  EXTNAME(SEVSEDEPD)
     D*Sede1FilFmt1            1    231                                                CSE065 237063
      *
      ** SE Diary Events Screen details retrieved from file
      ** - screen format
     D Sede1ScnFmt   E DS                  EXTNAME(SESEDEPD)
     D                                     PREFIX(O)
      *
      ** Security diary events retrieved from file - file format
     D SedeFilFmt    E DS                  EXTNAME(SEDEVD)
     D*SedeFilFmt1             1    231                                                CSE065 237063
      *
      ** SE Diary Events screen error indicators
     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
      *
      ** Security Diary Events extra data
     D PExtData      E DS                  EXTNAME(SESDEXPD)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(D1)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for API ICD details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for securities trading icd details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** 24x7 Status Dataarea
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      *
      ** SD Data Area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             01     01
      * Array to hold Commitment Job Names
     D CmtJobNArr      S             10A   DIM(10)
 
      ** Commitment Control Data Area
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)
     D  wComitJob              4    103
 
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *
      ** Index for arrays of error messages
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
      ** Pointer for the indicator array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D W1              S              3P 0
     D W2              S              3P 0
      *
      ** Index for arrays of error message Ids in amend validation
     D AMIDx           S              3P 0
      *
      ** Fields (500A) to receive the incoming transaction
     D PTrans5001      S            500A
      *
      ** Parametes for data substitution program.
     D PIncData        S           2000A
     D PCurData        S           2000A
      *
      ** Field (500A) to receive the incoming extra data
     D PExtData500     S            500A
      *
      ** Timestamp for the transaction
     D PTimestamp      S               Z
      *
      ** Fields to be used on call to module APCALOBJ (Allocate Object API)
     D PObject         S             10A   INZ('SESEDEUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A
     D PLockState      S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcObj         S              1A   INZ('Y')
     D PReturn         S              7A
      *
      ** Module Id to be passed to the message handler
     D PModuleId       S              2A   INZ('SE')
      *
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list)
     D PClrPgmMsgQ     S              1A   INZ('Y')
      *
      ** Overall Transaction status, to be passed to the message handler
     D PTranStatus     S              1A
      *
      ** Dummy message Id and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgId     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     D PMode           S              6A
      *
      ** Work parameters
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PTranID         S             20A
     D PResetFld       S              1A
     D PAmendOk        S              1A
     D PMQReturn       S             10A
     D PMQErrLong      S            132A
     D PEvtDno         S              5P 0
     D PPayCcy         S              3A
     D PPROT           S              1A
     D OKFLDS          S              1A   INZ('N')
      *
      ** Switchable features
     D CSE010          S              1A
     D S01509          S              1A
     D S01510          S              1A
     D CSE031          S              1A
     D CAS006          S              1A
     D CSC011          S              1A
     D CSE072          S              1A                                                      CSE072
     D CSE065          S              1A                                                      CSE065
     D CGL031          S              1A                                                      CGL031
      *
      ** Redisplay screen flag
     D PReDsp          S              1A
      *
      ** Work variables
     D WSubDE1         S              1A
     D WMQError        S             28A
     D WEvtDno         S              5P 0
     D DDCUCR          S             12A
     D DDSEXR          S             14A
     D DDNTCR          S             11A
     D DDMATY          S              8A                                                      CSE065
      *
      ** Parameters for ZDATE1
     D PDateIn         S              6A
     D PDayNoOut       S              5P 0
     D PErrorFlag      S              1A
      *
      ** Define parameter to be passed to APLOGTRAN.
     D TRANSDTL        S           5800A   INZ(*BLANKS)
      *
      ** Transaction number to be pass to APLOGTRAN.
     D PDealNo         S             18A   INZ(*BLANKS)
      *
      ** Associated transaction number
     D PADealNo        S             18A   INZ(*BLANKS)
      *
      ** Work variable for Diary event date -alpha
     D WSDED           S              5A
      *
      ** Processing date
     D WRDAY           S                   LIKE(BJRDNB)
      *
      ** Parameters for ZEDIT
     D ZField          S             16A
     D ZADec           S              1P 0
      ** Work variables for CSC022
     D CSC022          S              1A   INZ('N')
     D wCommitSkip     S              1A   INZ('N')
 
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SESEDEC002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
      *
      /COPY WNCPYSRC,SESEDEC003
      *
      ** Incoming transaction is in 500A fields, so that a common
      ** CLP can be used between this module and the one that
      ** read the MQ queue.  Break the 500A data by loading
      ** them into the appropriate (externally-described)
      ** data structures.
     C                   MOVEL     PTrans5001    SedeScnFmt
     C                   MOVEL     PExtData500   PExtData
      *
      ** Reset fields.
     C                   EXSR      SRResetFld
      /COPY WNCPYSRC,SESEDEC004
      *
      ** Check if valid security diary event exist for security shortname,
      ** event date and event type.
     C                   EXSR      SRChkValMTran
      *
      ** If valid security diary event does exist even after delay,
      ** fail this input.
     C                   IF        IDx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDEC005
      *
      ** Validate action code versus the security shortname, event date
      ** and event type supplied. Original security diary events details
      ** are retrieved during the validation process.
     C                   EXSR      SRValAction
      *
      /COPY WNCPYSRC,SESEDEC006
      *
      ** If errors occurred in the initial validation, fail this input.
     C                   IF        IDx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Processing depends upon action code.
     C                   SELECT
      *
      ** Insert
      ** ======
     C                   WHEN      DDACTN = 'I'
      *
      /COPY WNCPYSRC,SESEDEC007
      *
      ** Validate incoming Security Diary Event details.
     C                   EXSR      SRValDetails
      *
      /COPY WNCPYSRC,SESEDEC008
      *
      ** Check if amended fields are amendable.
     C                   EXSR      SRValAmend
      *
      ** Setup field DDNTCR
     C                   IF        CAS006 = 'Y'  AND
     C                             DDSDET = 'IR' AND
     C                             D1CPNN <> *ZEROS
     C                   EXSR      SRSetupDDNTCR
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDEC009
      *
      ** Amend
      ** =====
     C                   WHEN      DDACTN = 'A' OR
     C                             DDACTN = 'D'
      *
      /COPY WNCPYSRC,SESEDEC010
      *
      ** Convert original security diary events details from file
      ** to screen format.
     C                   EXSR      SRCvtSeDE
      *
      /COPY WNCPYSRC,SESEDEC011
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
     C                   IF        GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      SedeScnFmt                             99
     C                   IF        *IN99
     C                   MOVE      'Y'           WSubDE1
     C                   ELSE
     C                   MOVE      'N'           WSubDE1
     C                   ENDIF
      *
      ** Do data substitution.
     C                   IF        WSubDE1 = 'Y'
     C                   EXSR      SRDtaSubs
     C                   ENDIF
 
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDEC012
      *
      ** Validate incoming Security Diary Event details.
     C                   EXSR      SRValDetails
      *
      /COPY WNCPYSRC,SESEDEC013
      *
      ** Check if amended fields are amendable.
     C                   EXSR      SRValAmend
      *
      ** Setup field DDNTCR
     C                   IF        CAS006 = 'Y'  AND
     C                             DDSDET = 'IR' AND
     C                             D1CPNN <> *ZEROS
     C                   EXSR      SRSetupDDNTCR
     C                   ENDIF
      /COPY WNCPYSRC,SESEDEC014
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *
      **Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     Idx           IFEQ      0
     C                   EXSR      SetupValid
     C                   EXSR      UpdateDB
     C                   ENDIF
     C                   ENDIF
 
     C                   SETON                                        LR
     C     OKSDSN        IFEQ      'Y'
     C     OKSDED        ANDEQ     'Y'
     C     OKSDET        ANDEQ     'Y'
     C                   EVAL      OKFLDS = 'Y'
     C                   ENDIF
 
      *
      **Remerge buffer with all relevant data structures
     C*************      EVAL      Buffer = SedeScnFmt +PPROT + RMFL                         BUG4258
     C                   EVAL      Buffer = SedeScnFmt                                       BUG4258
     C                                      + @TimeStamp                                     BUG4258
     C                                      +PPROT + RMFL                                    BUG4258
     C                                 + DDCUCR + DDSEXR +DDNTCR + OKFLDS
     C                   RETURN
      *
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SESEDEC018
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkValMTran - Routine to check if valid security diary     *
      *                  events exist for security shortname, event   *
      *                  date and event type in the valid security    *
      *                  diary events file.                           *
      *                                                               *
      *****************************************************************
      *
     C     SRChkValMTran BEGSR
      *
      ** Convert event date into numeric format.
     C                   IF        DDSDED <> '999999'
     C                   EVAL      PDateIn = DDSDED
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateIn
     C                   PARM      *ZERO         PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
     C                   Z-ADD     PDaynoOut     WEvtDno
     C                   ELSE
     C                   Z-ADD     99999         WEvtDno
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAction - Routine to validate Action Code for the        *
      *                security shortname, event date and event type  *
      *                supplied                                       *
      *              - Original Security Diary Events details are     *
      *                retrieve during the validation process         *
      *                                                               *
      *****************************************************************
     C     SRValAction   BEGSR
     C                   EVAL      PMode = *BLANKS
 
     C                   EVAL      WRDAY = BJRDNB
      *
      ** If CSC011 is present and CTL is still running in the support
      ** system, set the rundate to processing date in dtaara SC24X7,
      ** to be used by RTV module.
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)
     C                   EVAL      WRDAY = S1DATE
     C                   ENDIF
 
     C                   CALLB     'SESEDERTV'
      *                             =========
      ** INPUT
      ** =====
 
      *
      ** Retun Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front office transaction identifier (20A from caller)
     C                   PARM                    APFOTRANID
      *
      ** Security Shortname
     C                   PARM                    DDSDSN
      *
      ** Event Date
     C                   PARM                    DDSDED
      *
      ** Event Type
     C                   PARM                    DDSDET
      *
      ** STANDING DATA
      ** =============
 
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Run day number
     C                   PARM                    WRDAY
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDSTRD - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
 
      *
      ** SE Transaction Enhancement
     C                   PARM                    CSE010
      *
      ** value Ccy to be Ccy of Issuer Payment
     C                   PARM                    S01509
      *
      ** Coupon Fixing for Floating Rate Notes
     C                   PARM                    CSE031
                                                                                              CSE065
      ** Constant Yield Amortisation                                                          CSE065
     C                   PARM                    CSE065                                       CSE065
      *
      ** OUTPUT
      ** ======
 
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Security Shortname
     C                   PARM                    OKSDSN
      *
      ** OK Event Date
     C                   PARM                    OKSDED
      *
      ** OK Event Type
     C                   PARM                    OKSDET
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    SedeFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Event date (Day Number)
     C                   PARM                    PEvtDno
      *
      ** Redisplay screen
     C                   PARM      *BLANK        PReDsp
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDetails - Routine to validate Security Diary Events Det.*
      *               - Amended file fields (for update) are set up   *
      *                 during the validation process                 *
      *                                                               *
      *****************************************************************
     C     SRValDetails  BEGSR
      *
      ** Move Security Diary Event details retrieved from the midas
      ** database file into the update file record.  If no
      ** record has been retrieved (i.e. in Insert), fields
      ** contain initial values (zeros, blanks).
     C**********         MOVEL     SedeFilFmt    Sede1FilFmt                                  CSE065
     C**********         MOVEL     SedeFilFmt1   Sede1FilFmt1                          CSE065 237063
     C                   MOVEL     SedeFilFmt    Sede1FilFmt                                  237063
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** Setup defaults on screen 1.
     C                   EXSR      SRDefault1
      *
      ** Validate screen 1 details.
     C                   EXSR      SRVScrn1
 
     C     EValDetails   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault1 - Defaulting for screen 1                         *
      *                                                               *
      *****************************************************************
     C     SRDefault1    BEGSR
 
     C                   CALLB     'SESEDE1DT'
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    SedeFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Event date (Day Number)
     C                   PARM                    PEvtDno
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Dividend payments
     C                   PARM                    S01510
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
                                                                                              CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    SedeScnFmt
      *
      ** Pay currency
     C                   PARM                    PPayCcy
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
                                                                                              CSE065
     C                   PARM                    DDMATY                                       CSE065
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVScrn1  - Validate screen 1 details                        *
      *                                                               *
      *****************************************************************
     C     SRVScrn1      BEGSR
 
     C                   CALLB     'SESEDE1VL'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Response mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    SedeScnFmt
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    SedeFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Event date (Day Number)
     C                   PARM                    PEvtDno
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
                                                                                              CSE065
      ** SDBANK - Rundate                                                                     CSE065
     C                   PARM                    BJRDNB                                       CSE065
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE Transactions Enhancement
     C                   PARM                    CSE010
      *
      ** Value CCY to be CCY of Issuer Payment
     C                   PARM                    S01509
      *
      ** Dividend Payments Base on EX-Date
     C                   PARM                    S01510
 
      ** Hedge Accounting Phase B
     C                   PARM                    CAS006
                                                                                              CSE072
      ** Brazilian C Bonds                                                                    CSE072
     C                   PARM                    CSE072                                       CSE072
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    Sede1FilFmt
      *
      ** Redisplay screen
     C                   PARM      *BLANK        PReDsp
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtSeDE - Convert security diary events details from file  *
      *              to screen format                                 *
      *                                                               *
      *****************************************************************
     C     SRCvtSeDE     BEGSR
 
     C                   CALLB     'SESEDECVT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    SedeFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
 
      ** Hedge Accounting Phase B
     C                   PARM                    CAS006
      *
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
      *                                                                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      ** OUTPUT
      ** ======
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    Sede1ScnFmt
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDtaSubs - Data Substitution Routine                        *
      *                                                               *
      *****************************************************************
      *
     C     SRDtaSubs     BEGSR
      *
      ** Substitute the data for the various parts of the transaction.
      *
     C                   IF        WSUBDE1 = 'Y'
     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData
 
     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution character
     C                   PARM                    GHSUBS
      *
      ** Incoming data
     C                   PARM      SedeScnFmt    PIncData
      *
      ** Current data
     C                   PARM      Sede1ScnFmt   PCurData
 
     C                   MOVEL     PIncData      SedeScnFmt
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAmend - Routine to check whether the fields are         *
      *               amendable                                       *
      *             - This subroutine calls a procedure which checks  *
      *               whether it is valid to amend the fields which   *
      *               have been altered.  To determine what fields    *
      *               have been changed, the current fields on file   *
      *               must be converted first to their screen formats.*
      *               These fields are then compared with the fields  *
      *               on the input transaction.  Any errors detected  *
      *               by the called procedure take precedence over    *
      *               any errors found during the validation of the   *
      *               transaction.  The errors from the called        *
      *               procedure are kept separately and if any are    *
      *               found, these errors will REPLACE the normal     *
      *               validation errors.                              *
      *                                                               *
      *****************************************************************
     C     SRValAmend    BEGSR
 
     C                   CALLB     'SESEDE1MD'
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    SedeScnFmt
      *
      ** SE Diary events screen details retrieved from file
      ** - screen format
     C                   PARM                    Sede1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    SedeFilFmt
      *
      ** Reset of fields in error required (Y/N)
     C                   PARM      'N'           PResetFld
      *
      ** Pay currency
     C                   PARM                    PPayCcy
      *
      ** STANDING DATA
      ** =============
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
 
      ** Hedge Accounting Phase B
     C                   PARM                    CAS006
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    AMFldNamAr
     C                   PARM                    AMMsgIdArr
     C                   PARM                    AMMsgDtaAr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    AMIDx
      *
      ** SE Diary events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *
      ** If errors occurred, overwrite previous error information.
      *
     C                   IF        AMIDx <> 0
     C                   MOVEA     AMFldNamAr    FldNameArr
     C                   MOVEA     AMMsgIdArr    MsgIdArr
     C                   MOVEA     AMMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AMIDx         IDx
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SetupValid - Routine to set up fields in the valid file      *
      *               record.                                         *
      *                                                               *
      *****************************************************************
      *
     C     SetupValid    BEGSR
      *
      ** Action is delete.
      ** =================
      *
     C                   IF        DDACTN = 'D'
      *
      ** Move security diary events details retrieved from file
      ** directly to the valid record data structure.
     C**********         EVAL      Sede1FilFmt= SedeFilFmt                                    CSE065
     C**********         EVAL      Sede1FilFmt1 = SedeFilFmt1                          CSE065 237063
     C                   EVAL      Sede1FilFmt= SedeFilFmt                                    237063
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
     C                   ENDIF                                                                CSE065
      *                                                                                     MD037742
      ** If Record Id is 'D', reset SDDT to zero                                            MD037742
      *                                                                                     MD037742
     C                   IF        S2RECI = 'D'                                             MD037742
     C                   IF        S2SDET = 'MP' OR S2SDET = 'DV'                           MD037742
     C                               OR S2SDET = 'PP'                                       MD037742
     C                   Z-ADD     0             S2SDDT                                     MD037742
     C                   ENDIF                                                              MD037742
     C                   ENDIF                                                              MD037742
      *                                                                                     MD037742
      *
      ** Record Id - update to 'C'.
     C                   EVAL      S2RECI = 'C'
     C                   ENDIF
      *
      ** Action is enquire.
      ** ==================
     C                   IF        DDACTN = 'E'
      *
      ** Move security diary events details retrieved from file
      ** directly to the valid record data structure.
     C**********         EVAL      Sede1FilFmt= SedeFilFmt                                    CSE065
     C**********         EVAL      Sede1FilFmt1 = SedeFilFmt1                          CSE065 237063
     C                   EVAL      Sede1FilFmt= SedeFilFmt                                    237063
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF
      *
      ** Action is insert.
      ** =================
     C                   IF        DDACTN = 'I'
      *
      ** Record Id.
     C                   EVAL      S2RECI = 'D'
      *
      ** Nominal currency.
     C                   EVAL      S2NMCY = D1NMCY
      *
     C                   ENDIF
      *
      ** Security shortname
     C                   EVAL      S2SDSN = DDSDSN
      *
      ** Event Date
     C                   EVAL      S2SDED = WEvtDno
      *
      ** Event Type
     C                   EVAL      S2SDET = DDSDET
      *
      ** Last change type
     C                   EVAL      S2CHTP = DDACTN
                                                                                             BUG4258
      * Restore Timestamp from the original record                                           BUG4258
     C                   IF        DDACTN <> 'I'                                             BUG4258
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C                   MOVEL     @TimeStamp    S2TMST                                      BUG4258
     C                   ENDIF                                                               BUG4258
      *
      /COPY WNCPYSRC,SESEDEC019
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
      *
      ** Update file.
     C                   CALLB     'SESEDEUPD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events for file update - file format
     C                   PARM                    Sede1FilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Run day number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDSTRD - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE Transaction enhancement
     C                   PARM                    CSE010
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Coupon Fixing for Floating Rate Notes
     C                   PARM                    CSE031
                                                                                              CSE065
     C                   PARM                    CSE065                                       CSE065
      *
      ** If errors occurred on update, rollback uncommitted file
      ** changes.
     C                   IF        RetCodeOut <> *BLANKS AND
     C                             RetCodeOut <> '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   ROLBK
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   If        (CSC022 <> 'Y')
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')
     C                   COMMIT
     C                   EndIf
     C                   EndIf
      *
      ** If update not done due to record being updated by another
      ** workstation, display message "The last transaction was not
      ** applied to the database." to the next screen.
     C                   IF        RetCodeOut = '*RECUPD'
     C                   Z-ADD     1             IDx
     C                   Eval      FldNameArr(IDx) = '*ANY'
     C                   Eval      MsgIdArr(IDx) = 'APM1000'
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRSetupDDNTCR - Routine to setup DDNTCR field.               *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRSetupDDNTCR BEGSR
     C                   EVAL      DDNTCR = *BLANKS
     C                   EVAL      ZField = *BLANKS
     C                   MOVE      D1CPNN        ZField
     C                   EVAL      ZADec = 7
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM                    ZADec
     C                   EVAL      DDNTCR = ZField
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFld - Routine to reset fields                         *
      *                                                               *
      *****************************************************************
     C     SRResetFld    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIdArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   IDx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIDx
 
     C                   RESET                   AMFldNamAr
     C                   RESET                   AMMsgIdArr
     C                   RESET                   AMMsgDtaAr
     C                   RESET                   AMIDx
 
     C                   RESET                   FldNoArr
 
     C                   MOVE      *ALL'Y'       SEESEDE
 
     C                   CLEAR                   Sede1ScnFmt
 
     C                   ENDSR
      *
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Common header information (DS) from source system
     C                   PARM                    PHeadIn
      *
      ** Incoming transaction details
     C                   PARM                    PTrans5001
      *
      ** Incoming transaction extra data
     C                   PARM                    PExtData500
      *
      ** Error information
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning Error information
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Message File
     C                   PARM                    MsgFArray
      *
      ** Update Transaction
     C                   PARM                    UpdateYN          1
      *
      ** Output Buffer
     C                   PARM                    Buffer         6000
      *
      ** API Return Code
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp       26                         BUG4258
      *
      ** Set up the name of the module Id used to make the transaction
      ** number unique.
     C                   EVAL      PModuleId = 'SE'
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages.
     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'
      *
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DTAQNAME = 'APSEDEDTQ'
      *
      ** Access bank details.
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access API ICD details.
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDAPIPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve ICD for securities trading.
     C                   CALLB     'AOSTRDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDSTRDPD'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE010
      ** (SE Transaction Enhancement) is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE010'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSE010'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSE010 = 'Y'
     C                   ELSE
     C                   EVAL      CSE010 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01509
      ** (Value Ccy to be Ccy of Issuer Payment) is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01509'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'S01509'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01509 = 'Y'
     C                   ELSE
     C                   EVAL      S01509 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01510
      ** (Dividend Payments) is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01510'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'S01510'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01510 = 'Y'
     C                   ELSE
     C                   EVAL      S01510 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE031
      ** (Coupon Fixing for Floating Rate Notes) is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE031'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSE031'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSE031 = 'Y'
     C                   ELSE
     C                   EVAL      CSE031 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Hedge Accounting
      ** Phase B(CAS006)' is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CAS006'
     C                   EVAL      DBFILE= 'SCSARDPD'
     C                   EVAL      DBASE = 8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     'Y'           CAS006
     C                   ELSE
     C                   MOVEL     'N'           CAS006
     C                   ENDIF
      *
      ** Check if CSC011 is installed
     C                   EVAL      CSC011 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        PRTCD = *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CSC011'
     C                   EVAL      DBASE = 9
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
      ** Access SAR details file to determine if Commitment Control
      ** Changes is switched on.
      *
     C                   CallB     'AOSARDR0'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*VERIFY'     POPTN
     C                   Parm      'CSC022'      PSARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        PRTCD = *BLANKS
      *
     C                   Eval      CSC022 = 'Y'
     C                   In        SCCMTJOB
     C                   If        ComitNum > 0
      ** Access SAR file to determine if 'Brazilian C-Bonds                                   CSE072
      ** (CSE072)' is installed.                                                              CSE072
                                                                                              CSE072
     C                   CALLB     'AOSARDR0'                                                 CSE072
     C                   PARM      *BLANKS       PRTCD                                        CSE072
     C                   PARM      '*VERIFY'     POPTN                                        CSE072
     C                   PARM      'CSE072'      PSARD                                        CSE072
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE072
                                                                                              CSE072
      ** An NRF (No Record Found) return code is valid.                                       CSE072
      ** Issue database error only for error return codes.                                    CSE072
     C                   IF        PRtcd <> *BLANKS AND                                       CSE072
     C                             PRtcd <> '*NRF   '                                         CSE072
     C     *LOCK         IN        LDA                                                        CSE072
     C                   EVAL      DBKEY = 'CSE072'                                           CSE072
     C                   EVAL      DBFILE= 'SCSARDPD'                                         CSE072
     C                   EVAL      DBASE = 011                                                CSE072
     C                   OUT       LDA                                                        CSE072
     C                   EXSR      *PSSR                                                      CSE072
     C                   ENDIF                                                                CSE072
                                                                                              CSE072
     C                   IF        PRtcd = *BLANKS                                            CSE072
     C                   MOVEL     'Y'           CSE072                                       CSE072
     C                   ELSE                                                                 CSE072
     C                   MOVEL     'N'           CSE072                                       CSE072
     C                   ENDIF                                                                CSE072
                                                                                              CSE065
      ** Access SAR file to determine if CSE065 is installed                                  CSE065
                                                                                              CSE065
     C                   CALL      'AOSARDR0'                                                 CSE065
     C                   PARM      *BLANKS       PRtcd                                        CSE065
     C                   PARM      '*VERIFY'     POptn                                        CSE065
     C                   PARM      'CSE065'      PSarD                                        CSE065
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
                                                                                              CSE065
      ** An NRF (No Record Found) return code is valid.                                       CSE065
      ** Issue database error only for error return codes.                                    CSE065
                                                                                              CSE065
     C                   IF        PRtcd <> *BLANKS AND                                       CSE065
     C                             PRtcd <> '*NRF   '                                         CSE065
     C     *LOCK         IN        LDA                                                        CSE065
     C                   EVAL      DBKey = 'CSE065'                                           CSE065
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE065
     C                   EVAL      DBase = 12                                                 CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      *PSSR                                                      CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C                   IF        PRtcd = *BLANKS                                            CSE065
     C                   MOVEL     'Y'           CSE065                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   MOVEL     'N'           CSE065                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** Check if Current Job exists in the Commitment Job Names
      ** Data Area.
      *
     C                   MoveA     wComitJob     CmtJobNArr
     C     PSJOBNAME     LookUp    CmtJobNArr                             20
     C                   If        *IN20
     C                   Eval      wCommitSkip = 'Y'
     C                   EndIf
     C                   EndIf
      *
     C                   Else
      *
      ** Database error
      *
     C                   If        PRTCD <> '*NRF'
     C     *LOCK         In        LDA
     C                   Eval      DBKey = 'CSC022'
     C                   Eval      DBPgm = 'SESEDEVU'
     C                   Eval      DBFile = 'SCSARDPD'
     C                   Eval      DBase = 10
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   EndIf
                                                                                              CGL031
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtCd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
                                                                                              CGL031
     C                   IF        PRtCd = *BLANKS                                            CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRtCd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = PSARD                                              CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *
      *
      ** Retrieve Midas Module Flag details
     C                   READ      MMODF                                  01
      **********                                                                             BUG7029
      ***Retrieve*ZMUSER*details.                                                            BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
      *
      ** Key fields for LF/SEDEV
     C     KDEVKA        KLIST
     C                   KFLD                    DDSDSN
     C                   KFLD                    WEvtDno
     C                   KFLD                    DDSDET
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SESEDEC021
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRETC = '0'
     C                   RETURN
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
