     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Non-Currency OTC input control')              *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFOTCOCTL - Non-Currency over-the-counter options interface  *
      *              controller                                       *
      *                                                               *
      *  Function:  This module receives the data from the FF OTCO    *
      *             API, and passes it on to the validation and other *
      *             functions.                                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BG9185             Date 08Nov05               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 28Oct03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 214057             Date 17Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166  *CREATE    Date 15Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CGL014 - Collaterals Processing                              *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  214057 - Allow broker if S01457 is installed.                *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Valid transactions
     FFFVTRANPD O    E             DISK    COMMIT RENAME(TRANSDF : FFVTRAND0)
     F                                     PREFIX(V_) INFSR(*PSSR)
 
      ** Valid settlement instructions
     FFFVSETLPD O    E             DISK    COMMIT RENAME(TRSETDF : FFVSETLD0)
     F                                     PREFIX(VS) INFSR(*PSSR)
 
      ** Valid instrument types
     FFFVINSTPD O    E             DISK    COMMIT INFSR(*PSSR)
     F                                     PREFIX(VI)
 
      ** Invalid transactions
     FFFIOTCOPD O    E             DISK    COMMIT INFSR(*PSSR)
 
      ** Invalid customer settlement instructions
     FFFICSETPD O    E             DISK    COMMIT INFSR(*PSSR)
 
      ** Valid transactions by front-office ID
     FFFVTRANL0 IF   E           K DISK    RENAME(TRANSDF : FFVTRANL)
     F                                     INFSR(*PSSR)
     FFFVTRANL1 IF   E           K DISK    RENAME(TRANSDF : FFVTRANCK1)
     F                                     INFSR(*PSSR)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFOTCOC001
 
      *********************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes definitions for thefields
      ** #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member.
     D/COPY ZACPYSRC,PROCPARMS
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **-------------------------------------------------------------------
 
 
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
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  NoRecFnd              02     02
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** +----------------------------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ The following table shows the various data structure names and ¦
      ** ¦ field prefixes associated with the incoming (screen) and file  ¦
      ** ¦ versions of the transaction details and settlement             ¦
      ** ¦ instructions.                                                  ¦
      ** ¦                                                                ¦
      ** ¦===================¦=============¦===============¦==============¦
      ** ¦                   ¦ Transaction ¦ Customer Sett ¦              ¦
      ** ¦===================¦=============¦===============¦==============¦
      ** ¦ Old screen DS     ¦ TranScnFmt  ¦ CurCuStScn    ¦              ¦
      ** ¦            prefix ¦ @           ¦ OC            ¦              ¦
      ** +-------------------+-------------+---------------+--------------+
      ** ¦ Old file   DS     ¦ TranFilFmt  ¦               ¦              ¦
      ** ¦            prefix ¦ D_          ¦               ¦              ¦
      ** ¦===================¦=============¦===============¦==============¦
      ** ¦ New screen DS     ¦ TranIn      ¦ NewCuStScn    ¦              ¦
      ** ¦            prefix ¦ (none)      ¦ (none)        ¦              ¦
      ** +-------------------+-------------+---------------+--------------+
      ** ¦ New file   DS     ¦ ValidTran   ¦ ValidSett     ¦              ¦
      ** ¦            prefix ¦ V_          ¦ VS            ¦              ¦
      ** +-------------------+-------------+---------------+--------------+
 
      ** Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming (new) Transaction in screen format
     D TranIn        E DS                  EXTNAME(FFOTCOPD)
 
      ** Dummy incoming Transaction in screen format
     D DummyTIn      E DS                  EXTNAME(FFOTCCPD)
 
      ** Valid (new) transaction in file format; prefixed with V_ for valid
     D ValidTran     E DS                  EXTNAME(FFVTRANPD) PREFIX(V_)
 
      ** Old transaction in File Format; prefixed with D_ for database
     D TranFilFmt    E DS                  EXTNAME(TRANSD) PREFIX(D_)
 
      ** Valid (new) settlement instructions in file format; prefixed
      ** with VS for settlements.
     D ValidSett     E DS                  EXTNAME(FFVSETLPD) PREFIX(VS)
 
      ** Valid (new) instrument type details, prefixed with VI for
      ** valid instrument.
     D ValidInst     E DS                  EXTNAME(FFVINSTPD) PREFIX(VI)
 
      ** Old transaction in Screen Format
     D TranScnFmt    E DS                  EXTNAME(FFOTCOPD)
     D                                     PREFIX(@)
 
      ** Customer settlement instructions (old) in screen format
     D CurCuStScn    E DS                  EXTNAME(FFCSETPD)
     D                                     PREFIX(OC)
 
      ** Broker settlement instructions (old) in screen format
     D CurBrStScn    E DS                  EXTNAME(FFBSETPD)
     D                                     PREFIX(OB)
 
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** Customer settlement instructions (new) in screen format
 
     D NewBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** Broker Settlement Instructions (new) in screen format
      ** (not used for OTCs, but required by some called procedures).
 
      ** The OK flags for the transaction details
     D OKTransDet    E DS                  EXTNAME(FFEOTCOPD)
 
      ** The OK flags for the OTCC transaction details
     D OKDummyDS     E DS                  EXTNAME(FFEOTCCPD)
     D                                     PREFIX(A)
 
      ** The customer settlement details OK flags
     D OKCustSet     E DS                  EXTNAME(FFECSETPD)
 
      ** The broker settlement details OK flags
      ** (not used for OTCs, but required by some called procedures).
     D OKBrokSet     E DS                  EXTNAME(FFEBSETPD)
 
      ** FF Extension data (Over the Counter) - File (D/B) format
     D ExtData       E DS                  EXTNAME(FFOTEXPD)
 
      ** Short data structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** Bank Details ICD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Midas module flags
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Switchable Features Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SLCD         E                     EXTFLD(LCD)
 
      ** Trading details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  #ACCD1       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Dealing ICD
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  #ACCD2       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Portfolio Management ICD
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** Retail ICD
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  #ACCD3       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Futures and Options ICD
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  #ACCD4       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Instrument types
     D InstTypes     E DS                  EXTNAME(INTYPD)
 
      ** DS for allocation data area
     D FFTRANUPC       DS                  DTAARA(FFTRANUPC)
 
      ** Data structure for data area SC24X7
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Fields to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
 
      ** Field (500A) to receive the incoming extension data
     D ExtData500      S            500A
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indexes for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Flag to indicate that an amendment is legitimate
     D AmendOK         S              1A
 
      ** Parameters and work fields for ZAMSGTOOPR
     D LongError       S            132A
 
      ** Object type for allocation
     D ObjType         S              7A   INZ('*DTAARA')
 
      ** Fields for data area locking
     D Object          S             10A   INZ('FFTRANUPC')
     D Lib             S             10A   INZ('*LIBL')
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Customer/Broker Flag (Y = Broker, N = Customer)
     D BrokerFlag      S              1A   INZ('N')
 
      ** The current trading date
     D CTDATE          S                   LIKE(BJRDNB)
 
      ** Flags to indicate that the customer settlements
      ** are in error.
     D CustSetErr      S              1A   INZ('N')
 
      ** Flags to indicate that the customer charges and
      ** commission fields are in error.
     D CustCCErr       S              1A   INZ('N')
 
      ** --- Parameters for ZATRNRTV --------------------------------------
      ** Module ID
     D Module          S              2A   INZ('FF')
 
      ** Transaction type (dummy field as it is not needed for FF)
     D DummyTRTY       S              1A
      ** --- End of parameters for ZATRNRTV -------------------------------
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A   INZ('FF')
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Error reset required in amend processing
     D ResetErrs       S              1A   INZ('N')
 
      ** Time stamp for the transaction
     D Timestamp       S                   LIKE(V_TMST)
 
      ** The transaction's status
     D TranStatus      S              1A
 
      ** Flag to indicate that the FFOTCCRTV is not being called
      ** as a linked enquiry.
     D LinkEnq         S              1A   INZ('N')
 
      ** Flag indicating whether details for customer or broker are
      ** required (broker does not apply for OTCs)
     D CustBrokFl      S              1A   INZ('C')
 
      ** Customer or broker number
     D*CustBrokNo      S              6S 0                                                    CSD027
     D CustBrokNo      S              6A                                                      CSD027
 
      ** Enhanced OTCs feature flag & CFF007 enhancement
     D CFF001          S              1A
     D CFF007          S              1A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** Transaction status text field
     D StatusText      S             24A
 
      ** Literal containing 'OT' for the multimembered file overrides
     D OTCMember       S              3A   INZ('OT')
 
      ** Dummy market centre code field for passing to FFSETLDFT
     D DummyMark       S              2A
 
      ** Dummy instrument code field for passing to FFSETLDFT
     D DummyInst       S              3A
 
      ** Flag to indicate that new instrument details must be written
      ** (imported from module FFVOTCCTYP)
     D NewInst         S              1A   IMPORT
 
      ** Screen Mode ('1' for transaction screen & '2' for plato screen)
     D PScnMode        S              1A   INZ('1')
 
     D WrkFldNam       S             10A
     D WDtaSubs1       S              1A
     D WDtaSubs2       S              1A
 
      ** PB customer indicator - Customer
     D PPBFLG          S              1A
 
      ** PB customer indicator - Broker
     D PPBBFLG         S              1A
 
      ** Market
     D PMRKT           S              2A
 
      ** Instrument
     D PISTC           S              3A
 
      ** CSC011 enhancement
     D CSC011          S              1A   INZ('N')
 
      ** Define parameter to be passed to APLOGTRAN.
     D TRANSDTL        S           5800A   INZ(*BLANKS)
 
      ** Transaction number to be pass to APLOGTRAN.
     D PDealNo         S             18A   INZ(*BLANKS)
      ** Associated transaction number                                                        222373
     D PADealNo        S             18A   INZ(*BLANKS)                                       222373
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D PRTCD           S              7                                                       CGL014
     D POPTN           S              7                                                       CGL014
     D PSARD           S              6                                                       CGL014
 
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFOTCOC002
 
      *********************************************************************
      /EJECT
      *********************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FFOTCOC003
 
      ** Incoming transaction is in 2 500A fields, so that a common CLP
      ** can be used between this module and the one that reads the MQ
      ** queue.  This module needs to break those 500A by loading them into
      ** the appropriate (externally described) data structures.
 
     C                   EVAL      TranIn     = Trans5001
     C                   EVAL      NewCuStScn = Trans5002
     C                   EVAL      Extdata = Extdata500
     C                   EVAL      DummyTIn = *BLANKS
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset variables gradually updated
 
     C                   EXSR      ResetCycle
 
      /COPY WNCPYSRC,FFOTCOC004
 
      ** Do initial checks on the transaction
      ** ------------------------------------
 
      ** Check if valid transaction exists for Front Office ID
 
     C                   EXSR      ChkValTran
 
      ** If valid transaction does exist (even after delay), fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Check if valid transaction exists for Midas Transaction Number
 
     C                   EXSR      ChkValMiTr
 
      ** If valid transaction does exist (even after delay), fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid transactions file.
 
     C                   EXSR      ResetCycle
 
      ** Apply the overrides for the FF multimembered files
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFAPYOVR'
     C                   PARM                    ReturnCode
     C                   PARM                    OTCMember
 
      /COPY WNCPYSRC,FFOTCOC005
 
      ** Validate Action Code
 
     C                   EXSR      ValidateAc
 
      /COPY WNCPYSRC,FFOTCOC006
 
      ** If error in validation of action code, fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Processing depends upon Action Code
 
     C                   SELECT
 
      ** Processing for Inserts
      ** ======================
 
     C                   WHEN      NACTN = 'I'
 
      ** Validate the main details of the transaction
      /COPY WNCPYSRC,FFOTCOC007
 
     C                   EVAL      PScnMode = '1'
     C                   EXSR      ValidateTr
 
      ** If errors in validation, fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Do the settlements defaulting
      /COPY WNCPYSRC,FFOTCOC008
 
     C                   EXSR      DftSettmts
 
      ** Validate the charges and commission details
      /COPY WNCPYSRC,FFOTCOC009
 
     C                   EXSR      ValidateCC
 
      ** If errors in validation, fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Validate the settlement instructions
      /COPY WNCPYSRC,FFOTCOC010
     C                   EXSR      ValidateSt
 
      ** If errors in validation, fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Validate Private Banking Fields
 
     C                   IF        CFF007 = 'Y'and BGN4ST = 'Y'
     C                   EXSR      ValidatePB
 
      ** If errors in validation, fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate the Plato Screen if BGN2ST is 'Y'
 
     C                   IF        BGN2ST = 'Y'
     C                   EVAL      PScnMode = '2'
     C                   EXSR      ValidateTr
     C                   ENDIF
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Processing for Amends, Deletes, and Enquiries
      ** =============================================
 
     C                   OTHER
 
      ** Convert transaction file format to screen format
 
     C                   EXSR      SRCvtTrnFle
 
      ** Convert customer settlement file format to screen format
 
     C                   EXSR      SRCvtSetFle
 
      ** Set up amendment details
      /COPY WNCPYSRC,FFOTCOC011
 
     C                   IF        GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      TranIn                                 02
 
     C                   IF        NoRecFnd = True
     C                   EVAL      WDtaSubs1 = 'Y'
     C                   ELSE
     C                   EVAL      WDtaSubs1 = 'N'
     C                   ENDIF
 
     C     GHSUBS        SCAN      NewCuStScn                             02
 
     C                   IF        NoRecFnd = True
     C                   EVAL      WDtaSubs2 = 'Y'
     C                   ELSE
     C                   EVAL      WDtaSubs2 = 'N'
     C                   ENDIF
 
     C                   IF        WDtaSubs1 = 'Y' or WDtaSubs2 = 'Y'
     C                   EXSR      TDtDtaSubs
     C                   ENDIF
 
     C                   ENDIF
 
      ** Processing for Amend Only
 
     C                   IF        NACTN = 'A'
 
      ** Validate the main details of the transaction
      /COPY WNCPYSRC,FFOTCOC012
 
     C                   EVAL      PScnMode = '1'
     C                   EXSR      ValidateTr
 
      ** If errors in validation, fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Validate the charges and commission details
      /COPY WNCPYSRC,FFOTCOC013
 
     C                   EXSR      ValidateCC
 
      ** If errors in validation, fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Validate the settlement instructions
      /COPY WNCPYSRC,FFOTCOC014
 
     C                   EXSR      ValidateSt
 
      ** If errors in validation, fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Validate Private Banking Fields
 
     C                   IF        CFF007 = 'Y'and BGN4ST = 'Y'
     C                   EXSR      ValidatePB
 
      ** If errors in validation, fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate the Plato Screen if BGN2ST is 'Y'
 
     C                   IF        BGN2ST = 'Y'
     C                   EVAL      PScnMode = '2'
     C                   EXSR      ValidateTr
     C                   ENDIF
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
 
      ** Check that the amendment is legitimate
      /COPY WNCPYSRC,FFOTCOC015
 
     C                   EXSR      ValAmend
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOC016
 
     C                   ENDSL
      **                 -----
 
     C     INVALID       TAG
 
      ** Check for exception error from any module lower in the stack
      ** If error detected, send message to system operator and
      ** return to caller without updating database or
      ** prompting the database update program (LogError SR
      ** includes a RETURN).
 
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,FFOTCOC017
 
     C                   IF        ARERRMOD <> *BLANK
     C                   EXSR      LogError
     C                   ENDIF
 
      ** Processing for error checking/write to database
      /COPY WNCPYSRC,FFOTCOC018
 
     C                   EXSR      CheckWrite
 
      /COPY WNCPYSRC,FFOTCOC019
 
      ** If valid, send data queue entry to prompt DB update program
 
     C                   IF        Idx = 0
     C                   EXSR      SndPrompt
     C                   ENDIF
 
      ** Remove the multimember file overrides for this transaction
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
 
      **-------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **-------------------------------------------------------------------
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFOTCOC020
 
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAmend - Check whether the transaction is a valid amendment *
      *                                                               *
      *****************************************************************
 
     C     ValAmend      BEGSR
 
      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.
 
      ** To determine what fields have changed, the current fields
      ** on file must be converted to the'screen' format.
 
      ** These fields are then compared with the fields on the input
      ** transaction.
 
      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the errors from the complete transaction validation.
 
      ** Amend checking
 
     C                   CALLB     'FFOTCOAMD'
 
      ** Return Code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** Input Parameters
      ** ================
 
      ** New transaction in Screen Format
      ** New Customer Settlement deatils in screen format
      ** Current transaction in Screen Format
      ** Current Customer Settlement Details in Screen Format
      ** Reset of Fields in Error Required (Y/N)
 
     C                   PARM                    TranIn
     C                   PARM                    NewCuStScn
     C                   PARM                    TranScnfmt
     C                   PARM                    CurCuStScn
     C                   PARM                    ResetErrs
 
      ** Current transaction in file format
 
     C                   PARM                    TranFilfmt
 
      ** Standing Data ICD
      ** =================
 
      ** SDBANKPD
      ** Midas modules
      ** General Ledger ICD
 
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
 
      ** Switchable feature
      ** ==================
 
      ** O.T.C. instrument switchable field
      ** Futures and Option Enhancement
      ** Portfolio Management Details
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
     C                   PARM                    SDPORT
 
      ** Output Parameters
      ** =================
      ** Transaction Details OK flags(DS) from/to caller
      ** Customer Settlement OK flags(DS) from/to caller
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    OKTransdet
     C                   PARM                    OKCustSet
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
     C                   PARM                    AmIdx
 
      ** Amendments OK
 
     C                   PARM                    AmendOk
 
      ** If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
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
      * ValidateTr - Validate the main transaction details            *
      *                                                               *
      *****************************************************************
 
     C     ValidateTr    BEGSR
 
     C                   CALLB     'FFOTCOVAL'
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Input parameters
      ** ----------------
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
 
     C                   PARM                    APRESPMODE
 
      ** Screen details from incoming transactions
      ** Extension file data
 
     C                   PARM                    TranIn
     C                   PARM                    ExtData
 
      ** Standing data ICD
      ** -----------------
 
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
     C                   PARM                    SDFODA
     C                   PARM                    SDDEAL
     C                   PARM                    SDPORT
 
      ** O.T.C. instrument switchable field
      ** CFF007 Enhancement
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
 
      ** Screen mode ('1' = Transaction screen and '2' = Plato Screen)
 
     C                   PARM                    PScnMode
 
      ** Output Parameters
      ** =================
 
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Warning flds/message IDs/message data (arrays) from/to caller
      ** Warning array index (3P0) from/to caller
      ** Screen error indicators
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    OKTransDet
 
      ** FF Non-currency OTC for file update - detail file format
      ** The branch details format (from SDBRCHPD via MMVBKGBRCH)
      ** The current trading date (Midas day number)
      ** Instrument details (DS based on INTYPD)
      ** Premium
      ** PB customer indicator
 
     C                   PARM                    ValidTran
     C                   PARM                    SDBRCH
     C                   PARM                    CTDATE
     C                   PARM                    InstTypes
     C                   PARM                    SPREM
     C                   PARM                    PPBFLG
     C                   PARM                    S01457                                       214057
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Validate the settlement instructions             *
      *                                                               *
      *****************************************************************
 
     C     ValidateSt    BEGSR
 
     C                   RESET                   CustSetErr
 
      ** Customer
      ** --------
 
     C                   EVAL      CustBrokFl = 'C'
     C                   RESET                   ReturnCode
 
     C                   CALLB     'FFSETLVAL'
 
      ** Outputs
      ** =======
 
      ** Return Code
 
     C                   PARM                    ReturnCode
 
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Field name array (<WArrMax> x 10A, returned to caller)
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
 
     C                   PARM                    FldNamWArr
     C                   PARM                    MsgIDWArr
     C                   PARM                    MsgDtaWArr
 
      ** The valid settlements file format (data structure, from FFVSETLPD)
 
     C                   PARM                    ValidSett
 
      ** Inputs
      ** ======
 
      ** Data structure containing broker settlement details
      ** Data structure containing customer settlement details
 
     C                   PARM                    NewBrStScn
     C                   PARM                    NewCuStScn
 
      ** Data structure containing broker settlement OK flags
      ** Data structure containing customer settlement OK flags
 
     C                   PARM                    OKBrokSet
     C                   PARM                    OKCustSet
 
      ** Customer/ Broker flag (1A)
 
     C                   PARM                    CustBrokFl
 
      ** Branch code (3A, from transaction)
      ** Portfolio reference (4A)
      ** Instrument currency (3A)
      ** Trade date in Midas day number format (5,0P)
      ** Broker Code (6S,0 from FFVTRANPD)
      ** Customer Code (6S,0 from FFVTRANPD)
 
     C                   PARM                    NBRCD
     C                   PARM                    NPTFR
     C                   PARM                    ISCY
     C                   PARM                    V_TRSD
     C                   PARM                    V_BOCO
     C                   PARM                    V_CUSC
 
      ** Branch internal customer number (from SDBRCHPD)
      ** Current trading date
 
     C                   PARM                    A8BICN
     C                   PARM                    CTDATE
 
      ** Standing Data
      ** =============
 
      ** Bank Details ICD
      ** General Ledger ICD
      ** Midas Modules ICD
      ** Trading ICD
      ** Portfolio Management ICD
      ** Retail ICD
 
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
     C                   PARM                    SDTRAD
     C                   PARM                    SDPORT
     C                   PARM                    SDRETL
 
      ** CFF007 Enhancement
      ** PB customer indicator - Broker
      ** PB customer indicator - Customer
      ** Collaterals Processing enhancement                                                   CGL014
 
     C                   PARM                    CFF007
     C                   PARM                    PPBBFLG
     C                   PARM                    PPBFLG
     C                   PARM                    CGL014                                       CGL014
 
      ** Record any failure to ensure that the correct details get
      ** written to the invalid files.
 
     C                   IF        ReturnCode <> *BLANKS
 
     C                   EVAL      CustSetErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
 
     C                   EXSR      AppendArrs
     C                   ENDIF
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateCC - Validate the charges and commission details      *
      *                                                               *
      *****************************************************************
 
     C     ValidateCC    BEGSR
 
     C                   RESET                   CustCCErr
 
      ** Customer
      ** --------
 
     C                   EVAL      BrokerFlag = 'N'
 
     C                   CALLB     'FFVCHGCOM'
 
      ** Outputs from called procedure
      ** -----------------------------
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Broker settlement OK flags.
      ** Customer settlement OK flags
 
     C                   PARM                    OKBrokSet
     C                   PARM                    OKCustSet
 
      ** The valid settlements file format (data structure, from FFVSETLPD)
 
     C                   PARM                    ValidSett
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Data structure containing customer settlement details
 
     C                   PARM                    NewCuStScn
 
      ** Customer/ Broker flag (1A, Y = Broker, N = Customer)
      ** Instrument currency (3A)
 
     C                   PARM                    BrokerFlag
     C                   PARM                    ISCY
 
      ** Broker Chrg./Comm. Pattern
      ** Market
      ** Instrument
      ** No. of contracts
      ** Action code
      ** Broker
      ** PB customer indicator
 
     C                   PARM                    BCPT
     C                   PARM      *BLANKS       PMRKT
     C                   PARM      *BLANKS       PISTC
     C                   PARM                    NUCO
     C                   PARM                    NACTN
     C                   PARM                    V_BOCO
      ** CFF007 Enhancement                                                                   222373
     C                   PARM                    CFF007                                       222373
     C                   PARM                    PPBFLG
 
      ** Record any failure to ensure that the correct details get
      ** written to the invalid files.
 
     C                   IF        ReturnCode <> *BLANKS
     C                   EVAL      CustCCErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Validate action code against the transaction ID  *
      *                                                               *
      *****************************************************************
 
     C     ValidateAc    BEGSR
 
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas transaction ID is not present
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).
 
     C     NACTN         IFEQ      'I'
     C                   EVAL      ModeofOp = '*FRONT'
     C                   ELSE
 
     C     NTNBR         IFEQ      *BLANK
     C                   EVAL      ModeofOp = '*FRONT'
     C                   ELSE
     C                   EVAL      ModeofOp = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate action code versus transaction IDs supplied.
      ** This function will set the Midas transaction number.
      ** The transaction in file format from the Midas database is
      ** also retrieved.
 
     C                   CALLB     'FFOTCCRTV'
 
      ** Return code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Mode = '*FRONT' (Front-office processing)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp          6
 
      ** Response mode
 
     C                   PARM                    APRESPMODE
 
      ** Action Code
      ** Front Office Transaction ID
      ** Midas Transaction Number
      ** Flag to indicate module is (not) being called as a linked enquiry
 
     C                   PARM                    NACTN
     C                   PARM                    APFOTranID
     C                   PARM                    NTNBR
     C                   PARM                    LinkEnq
 
      ** Standing Data
      ** =============
 
      ** Bank details ICD
      ** General Ledger ICD
      ** Multibranching indicator
 
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    BGMBIN
 
      ** Transaction type
 
     C                   PARM      'OTCO'        TransType
 
      ** Outputs from called procedure
      ** -----------------------------
 
      ** Transaction in file format
      ** Settlements in file format
      ** Instrument Types
      ** OK - Action code
      ** OK - Deal Number
 
     C                   PARM                    TranFilFmt
     C                   PARM                    ValidSett
     C                   PARM                    InstTypes
     C                   PARM                    OKACTN
     C                   PARM                    OKTNBR
 
      ** Error fields/message IDs/message data (arrays)
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index
 
     C                   PARM                    Idx
 
     C                   EVAL      ModeofOp = '*FRONT'
     C                   CLEAR                   ValidTran
     C                   CLEAR                   ValidSett
     C                   CLEAR                   ValidInst
     C                   EVAL      ValidTran = TranFilFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidatePB - Validate Private Banking Details                 *
      *                                                               *
      *****************************************************************
      *
     C     ValidatePB    BEGSR
 
     C                   CALLB     'FFOTCC2VL'
 
      ** Outputs
 
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    OKDummyDS
     C                   PARM                    OKTransDet
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    ValidTran
     C                   PARM                    InstTypes
 
      ** Inputs
 
     C                   PARM                    DummyTIn
     C                   PARM                    TranIn
     C                   PARM                    NewInst
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
     C                   PARM                    SDFODA
     C                   PARM      'OTCO'        TransType
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************
 
     C     TDtDtaSubs    BEGSR
 
      ** Data substitution
      ** =================
 
      ** Transaction details
      ** ===================
 
     C                   IF        WDtaSubs1 = 'Y'
 
      ** Clear IncDATA and CurDATA
 
     C                   CLEAR                   IncDATA
     C                   CLEAR                   CurDATA
 
     C                   CALLB     'APDTASUBS'
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Substitution character
 
     C                   PARM      GHSUBS        SubsChar          1
 
      ** Incoming Data
      ** Current Data
 
     C                   PARM      TranIn        IncDATA        2000
     C                   PARM      TranScnfmt    CurDATA        2000
 
     C                   MOVEL     IncDATA       TranIn
 
     C                   ENDIF
 
      ** Customer settlement details
      ** ===========================
 
     C                   IF        WDtaSubs2 = 'Y'
 
      ** Clear IncDATA and CurDATA
 
     C                   CLEAR                   IncDATA
     C                   CLEAR                   CurDATA
 
     C                   CALLB     'APDTASUBS'
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Substitution character
 
     C                   PARM      GHSUBS        SubsChar
 
      ** Incoming Data
      ** Current Data
 
     C                   PARM      NewCuStScn    IncDATA
     C                   PARM      CurCuStScn    CurDATA
 
 
     C                   MOVEL     IncDATA       NewCuStScn
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtTrnFle - Convert transaction file format to screen       *
      *               format.                                         *
      *                                                               *
      *****************************************************************
 
     C     SRCvtTrnFle   BEGSR
 
      ** Conversion of transaction file fields to screen format
      ** ======================================================
 
     C                   CALLB     'FFOTCOCVT'
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Input Parameter
      ** ---------------
 
      ** Old transaction in file format
      ** Instrument types
 
     C                   PARM                    TranFilfmt
     C                   PARM                    InstTypes
 
      ** Standing Data
      ** -------------
 
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
 
      ** CFF001 and CFF007 enhancements
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
 
      ** Output Parameters
      ** -----------------
 
      ** Old transaction in screen format
 
     C                   PARM                    TranScnfmt
 
      ** Premium
      ** Transaction Status
 
     C                   PARM                    SPREM            15
     C                   PARM                    StatusText
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtSetFle - Convertion Details Data Substitution            *
      *                                                               *
      *****************************************************************
 
     C     SRCvtSetFle   BEGSR
 
      ** Conversion of customer settlement file fields to screen format
      ** ==============================================================
 
     C                   EVAL      CustBrokFl = 'C'
 
     C                   CALLB     'FFSETLCVT'
 
      ** Output Parameters
      ** -----------------
      ** Return code (10A, returned to caller)
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Customer settlement instructions, screen format
      ** Broker settlement instructions, screen format
 
     C                   PARM                    CurCuStScn
     C                   PARM                    CurBrStScn
 
      ** Settlements in file format
 
     C                   PARM                    ValidSett
 
      ** Customer/broker flag (1A)
      ** Midas Transaction Number
      ** Instrument currency
 
     C                   PARM                    CustBrokFl
     C                   PARM                    NTNBR
     C                   PARM                    ISCY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Apply default settlement instructions if none    *
      *              have been supplied                               *
      *                                                               *
      *****************************************************************
 
     C     DftSettmts    BEGSR
 
      ** If ANY of the Settlements fields have been entered, bypass this
      ** routine.
      ** Otherwise, use modules which will use Standard Settlement
      ** Instructions to apply defaults.
 
     C                   IF        NewCuStScn = *BLANK
 
     C                   EVAL      CustBrokFl = 'C'
     C                   EVAL      CustBrokNo = V_CUSC
 
     C                   CALLB     'FFSETLDFT'
 
      ** Outputs
      ** -------
 
      ** Return code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Broker settlement instructions
      ** Customer settlement instructions
 
     C                   PARM                    NewBrStScn
     C                   PARM                    NewCuStScn
      ** Inputs
      ** ------
 
      ** Customer/broker flag
 
     C                   PARM                    CustBrokFl
 
      ** Customer or broker number
      ** Market centre
      ** Instrument code
 
     C                   PARM                    CustBrokNo
     C                   PARM                    DummyMark
     C                   PARM                    DummyInst
 
      ** Transaction type (purchase or sale) (1A)
 
     C                   PARM                    NTRTY
 
      ** Enhanced OTCs feature flag
 
     C                   PARM                    CFF001
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SndPrompt - Send a message to prompt the database updater     *
      *                                                               *
      *****************************************************************
 
     C     SndPrompt     BEGSR
 
      ** Check if update program active using Allocate Object API
      ** No prompting necessary if program is running
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANKS       Return
 
     C                   IF        Return = *BLANK
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
      /COPY ZACPYSRC,DTAQCHK
      **-------------------------------------------------------------------
 
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
 
      ** If no errors were found:
      ** - If Action Code is Insert
      **    - set up the deal number
      ** - If there are still no errors
      **    - set up additional data
      **    - write a record to the Valid file
      **    - use std message handler to report deal status
      ** If any errors were found:
      ** - write a record to the Invalid file
      ** - call the message handler to pass the errors back
      ** - use standard message handler to report deal status
      ** The index to the error arrays is checked for presence/absence of
      ** errors
     
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
 
     C                   IF        Idx = 0
 
     C                   IF        NACTN = 'I'
     C                   EXSR      SetupTranN
     C                   ENDIF
 
      ** Index is tested again at this point, as it can be incremented
      ** in SetupTranN
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   WRITE     FFVTRAND0
     C                   WRITE     FFVSETLD0
 
      ** Instrument types
 
     C                   IF        NewInst = 'Y'
     C                   WRITE     FFVINSTD0
     C                   ENDIF
 
      ** The message handler is called to log the transaction.
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
     C                   ENDIF
      ** (End of "If Idx = 0")
 
      ** If there were errors:
 
     C                   IF        Idx > 0
     C                   EXSR      SetupInval
 
      ** Only write to invalid files if repair in back office
 
     C                   IF        APRPRLOCN = 'B'
 
     C                   WRITE     FFIOTCOD0
 
     C                   EXSR      SetCustInv
 
     C                   WRITE     FFICSETD0
 
      ** If CSC011 is present and CTL is still running in the support
      ** system, write invalid details to APIlogfile.
 
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR
     C                   EXSR      SRWriteLog
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      CallMsgHdl
     C                   ENDIF
      **                 (End of "If Idx > 0")
 
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
 
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
 
     C                   IF        FldNameArr(Ix) <> *BLANKS
 
     C                   EVAL      WrkFldNam = FldNameArr(Ix)
     C                   EVAL      %SUBST(WrkFldNam:1:1) = 'N'
     C                   EVAL      FldNameArr(Ix) = WrkFldNam
 
     C                   EVAL      Iy = 1
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
      ** If a blank array entry is found, leave the DO loop.
 
     C                   LEAVE
 
     C                   ENDIF
      ** End of "if FldNameArr(Ix) <> *BLANKS"
 
     C                   ADD       1             Ix
     C                   ENDDO
      ** End of "DO ArrayMax"
 
     C                   MOVEL     NTNBR         PTranID          20
 
     C                   CALLB     'ZAMSGHNDLE'
 
      ** Return code (10A, returned to this procedure)
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Repair location (1A)
      ** Confirm validity to front office (1A)
 
     C                   PARM                    APRPRLOCN
     C                   PARM                    APCNFVALFO
 
      ** List of messages (Array of <ArrayMax>x7A message ids)
      ** List of field numbers (Array of <ArrayMax> packed)
      ** List of field names (Array of <ArrayMax>x10A names)
      ** List of message data entries (Array of <ArrayMax>x45)
 
     C                   PARM                    MsgIDArr
     C                   PARM                    FldNoArr
     C                   PARM                    FldNameArr
     C                   PARM                    MsgDtaArr
 
      ** Front office transaction identifier (20A)
 
     C                   PARM                    APFOTRANID
 
      ** Midas module ID (2A)
      ** Midas transaction ID (20A, from caller)
 
     C                   Parm                    ModuleID
     C                   PARM                    PTranID
 
      ** Message file (10A)
 
     C                   PARM                    #MsgFile
 
      ** Action code of transaction (1A, from transaction)
 
     C                   PARM                    NACTN
 
      ** Status of transaction (1A, F=Failure, S=Success)
      ** Response mode (1A (A=Asynchronous, S=Synchronous))
 
     C                   PARM                    TranStatus
     C                   PARM                    APRESPMODE
 
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
 
      ** Screen-handling program (10A)
      ** Screen-handling module (10A)
      ** Screen-handling procedure (10A)
 
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** The MQSeries queue to send replies to
 
     C                   PARM                    APRPYQUEUE
 
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
      * SetupInval - Set up additional fields that are needed on the  *
      *              Invalid file record.                             *
      *                                                               *
      *****************************************************************
 
     C     SetupInval    BEGSR
 
      ** Include Header fields that need to be o/p to the Invalid files
 
     C                   EVAL      SOFOTRANID = APFOTRANID
     C                   EVAL      SOASOCFOID = APFOASOCID
     C                   EVAL      SORPRLOC = APRPRLOCN
     C                   EVAL      SOTMESTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,FFOTCOC021
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetCustInv - Set up additional fields that are needed on the  *
      *              Invalid Customer file record.                    *
      *                                                               *
      *****************************************************************
 
     C     SetCustInv    BEGSR
 
      ** Include Header fields that need to be o/p to the Invalid files
 
     C                   EVAL      SCFOTRANID = APFOTRANID
     C                   EVAL      SCASOCFOID = APFOASOCID
     C                   EVAL      SCRPRLOC = APRPRLOCN
     C                   EVAL      SCTMESTMP = TimeStamp
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupTranN - Set up new transaction number for inserts        *
      *                                                               *
      *****************************************************************
 
     C     SetupTranN    BEGSR
 
      ** If no transaction reference was entered, retrieve the next
      ** available one.
 
     C                   IF           NTNBR = *BLANKS
     C                             OR NTNBR = *zeros
 
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    Module
     C                   PARM                    DummyTRTY
     C                   PARM                    NTNBR
     C                   PARM                    V_TNBR
 
      ** Use the return code's value to set the field's OK flag
 
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKTNBR
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** If transaction number was entered, put it in the file field
 
     C                   ELSE
     C                   MOVE      NTNBR         V_TNBR
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValTran - Check whether valid transaction exists for       *
      *              Front Office ID                                  *
      *                                                               *
      *****************************************************************
 
     C     ChkValTran    BEGSR
 
      ** Check for transaction on Valid file
 
     C     APFOTranID    CHAIN     FFVTRANL0                          02
 
      ** If record found (variable NoRecFnd is mapped to indicator 02)...
 
     C                   IF        NoRecFnd   = False
 
      ** ..delay, then repeat check
 
     C                   CALLB     'ZACDELAY'
 
     C     APFOTranID    CHAIN     FFVTRANL0                          02
 
      ** Error if still present
 
     C                   IF        NoRecFnd   = False
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'NTNBR'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValMiTr - Check whether valid transaction exists for       *
      *    Midas Transaction Number                                   *
      *                                                               *
      *****************************************************************
 
     C     ChkValMiTr    BEGSR
 
      ** If (numeric) Midas transaction number supplied
 
     C                   TESTN                   NTNBR                9898
 
     C     NTNBR         IFNE      *BLANKS
     C     *IN98         ANDEQ     '1'
 
      ** Check for transaction on Valid file
 
     C                   MOVEL     NTNBR         TNBR
     C     TNBR          CHAIN     FFVTRANL1                          02
 
      ** If record found (variable NoRecFnd   is mapped to indicator 02)...
 
     C                   IF        NoRecFnd   = False
 
      ** ..delay, then repeat check
 
     C                   CALLB     'ZACDELAY'
 
     C     TNBR          CHAIN     FFVTRANL1                          02
 
      ** Error if still present
 
     C                   IF        NoRecFnd   = False
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'NTNBR'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ResetCycle- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
 
     C     ResetCycle    BEGSR
 
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
 
     C                   EVAL      OKTransDet = *ALL'Y'
     C                   EVAL      OKDummyDS  = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
 
     C                   RESET                   AmendOK
 
     C                   MOVE      'N'           NewInst
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LogError - Send a message to the system operator for invalid  *
      *            transactions, and exit.                            *
      *                                                               *
      *****************************************************************
 
     C     LogError      BEGSR
 
      ** Set up the message to send to the operator
 
     C                   CLEAR                   LongError
     C                   RESET                   ReturnCode
     C                   EVAL      LongError = ProcErr + '   ' + ARERRMOD
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    ReturnCode
     C                   PARM                    LongError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
      ** Indicate the failing module to the caller
 
     C                   EVAL      APRETCODE = ARERRMOD
 
      ** Remove the failing module's details from the dump information
      ** data area.
 
     C     *LOCK         IN        APDUMP
     C                   CLEAR                   ARERRMOD
     C                   OUT       APDUMP
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupValid - Set up additional fields that are needed on the  *
      *              Valid file record.                               *
      *                                                               *
      *****************************************************************
 
     C     SetupValid    BEGSR
 
      ** For Deletes, put the complete (pre-existing) transaction
      ** into the Valid file record
 
     C                   IF        NACTN = 'D'
     C                   EVAL      ValidTran = TranFilFmt
     C                   ENDIF
 
      ** If transaction number was entered, put it in the file field
 
     C                   IF        NACTN = 'I' and NTNBR <> *BLANKS
     C                   MOVE      NTNBR         V_TNBR
     C                   ENDIF
 
      ** Set the change type equal to the action code to indicate the
      ** action to the database updater
 
     C                   EVAL      V_CHTP = NACTN
 
      ** Include Header fields that need to be o/p to the Valid file
 
     C                   EVAL      V_FRNT = APFOTRANID
     C                   EVAL      V_AFRT = APFOASOCID
     C                   EVAL      V_REPA = APRPRLOCN
     C                   EVAL      V_TMST = TimeStamp
 
     C                   EVAL      TranStatus = 'S'
 
      ** Include Header and other fields for the Valid settlements file
 
     C                   EVAL      VSFRNT = APFOTRANID
     C                   EVAL      VSAFRT = APFOASOCID
     C                   EVAL      VSREPA = APRPRLOCN
     C                   EVAL      VSTMST = TimeStamp
     C                   EVAL      VSTNBR = V_TNBR
 
      ** Set up data for valid instrument types file
 
     C                   IF        NewInst = 'Y'
 
     C                   EVAL      VIFRNT = APFOTRANID
     C                   EVAL      VIAFRT = APFOASOCID
     C                   EVAL      VIREPA = APRPRLOCN
     C                   EVAL      VITMST = TimeStamp
 
     C                   EVAL      VIRECI = RECI
     C                   EVAL      VIISTT = ISTT
     C                   EVAL      VIISTI = ISTI
     C                   EVAL      VIISPT = ISPT
     C                   EVAL      VIISCY = ISCY
     C                   EVAL      VIQOTC = QOTC
     C                   EVAL      VITKDM = TKDM
     C                   EVAL      VIMNPF = MNPF
     C                   EVAL      VITKVL = TKVL
     C                   EVAL      VICTAM = CTAM
     C                   EVAL      VICMRF = CMRF
     C                   EVAL      VIOTHC = OTHC
     C                   EVAL      VIPUPF = PUPF
     C                   EVAL      VIFTDT = FTDT
     C                   EVAL      VISETD = SETD
     C                   EVAL      VIAEIN = AEIN
     C                   EVAL      VICCAM = CCAM
     C                   EVAL      VICTCY = CTCY
     C                   EVAL      VIFTTM = FTTM
     C                   EVAL      VIINNR = INNR
     C                   EVAL      VIUNSE = UNSE
     C                   EVAL      VITECO = TECO
     C                   EVAL      VITNAT = TNAT
     C                   EVAL      VICRIK = CRIK
     C                   EVAL      VICCYR = CCYR
     C                   EVAL      VITWEI = TWEI
 
      ** Update midas plato fields
 
     C                   EVAL      VIPLMIIT = PLMIIT
     C                   EVAL      VIPLMITM = PLMITM
     C                   EVAL      VIPLMIMD = PLMIMD
     C                   EVAL      VIPLMICP = PLMICP
     C                   EVAL      VIPLMICF = PLMICF
     C                   EVAL      VIPLMIPC = PLMIPC
     C                   EVAL      VIPLMIVT = PLMIVT
     C                   EVAL      VIPLMIPM = PLMIPM
     C                   EVAL      VIPLMIPG = PLMIPG
     C                   EVAL      VIPLMIRG = PLMIRG
     C                   EVAL      VIPLMICR = PLMICR
 
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOC022
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AppendArrs - Append one field's error and warning details to  *
      *              the general error and warning arrays.            *
      *                                                               *
      *****************************************************************
 
     C     AppendArrs    BEGSR
 
     C                   CALLB     'APAPNDARRS'
      ** Outputs from called procedure
      ** -----------------------------
 
      ** Return code (10A, returned to caller)
 
     C                   PARM                    ReturnCode
 
      ** Error array index (3,0P)
      ** Field names with errors array (<ArrayMax> x 10A)
      ** Error message ID array (<ArrayMax> x 7A)
      ** Error message data array (<ArrayMax> x 45A)
 
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Warning array index (3,0P)
      ** Field names with warnings array (<ArrayMax> x 10A)
      ** Warning message ID array (<ArrayMax> x 7A)
      ** Warning message data array (<ArrayMax> x 45A)
 
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Field name array (<ErrArrMax> x 10A)
      ** Error message ID array (<ErrArrMax> x 7A)
      ** Error message data array (<ErrArrMax> x 45A)
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Field name array (<WArrMax> x 10A)
      ** Warning message ID array (<WArrMax> x 7A)
      ** Warning message data array (<WArrMax> x 45A)
 
     C                   PARM                    FldNamWArr
     C                   PARM                    MsgIDWArr
     C                   PARM                    MsgDtaWArr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteLog - Setup data to be written to standard API log    *
      *               Calls APLOGTRAN                                 *
      *                                                               *
      *  Called by:  CheckWrite                                       *
      *                                                               *
      *  Calls: APLOGTRAN - API standard Log module                   *
      *                                                               *
      *****************************************************************
 
     C     SRWriteLog    BEGSR
 
      ** Setup value of TRANSDTL
 
     C                   EVAL      TRANSDTL = TranIn + NewCuStScn +
     C                             ExtData
 
      ** Initialise Deal no to pass
 
     C                   EVAL      PDealNo = NTNBR
 
      ** Call program that will write to API standard log file.
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    TimeStamp
     C                   PARM                    PDealNo
     C                   PARM      *BLANKS       PADealNo                                     222373
 
      ** If error occurred, perform abnormal termination
 
     C     ReturnCode    IFNE      *BLANKS
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
 
      ** Parameters received from caller
      ** -------------------------------
 
      ** Common header information (DS) from source system
 
     C                   PARM                    HeadIn
 
      ** Transaction information in a single large field from source system
 
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    ExtData500
 
      ** Ultimate calling Program/Module/Procedure
 
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the MSGF from which the message handler will
      ** get the messages
 
     C                   EVAL      #MsgFile = 'DRSMM'
 
      ** Access Bank details via access program
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access API ICD via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Get the module flags
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Get the General Ledger ICD
 
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Get the trading details
 
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
      ** Get the Dealing ICD
 
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
 
      ** Get the portfolio ICD
 
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST'      @Optn
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
 
      ** Get the retail ICD
 
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
 
      ** Futures and Options ICD
 
     C                   CALL      'AOFODAR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDFODA        PARM      SDFODA        DSFDY
 
      ** Access SAR Details to determine whether Enhanced OTCs is present
 
     C                   EVAL      CFF001 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CFF001'      @SARD
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CFF001 = 'Y'
     C                   ENDIF
 
      ** Determine if CFF007 is installed
 
     C                   EVAL      CFF007 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CFF007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CFF007 = 'Y'
     C                   ENDIF
 
      ** Determine if 24x7 Midas availability is installed
 
     C                   EVAL      CSC011 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
 
     C                   IF        @RtCd <> *BLANKS AND @RtCd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ENDIF
                                                                                              214057
      ** Determine if S01457 is installed                                                     214057
                                                                                              214057
     C                   CALLB     'AOSARDR0'                                                 214057
     C                   PARM      *BLANKS       @RTCD                                        214057
     C                   PARM      '*VERIFY'     @OPTN                                        214057
     C                   PARM      'S01457'      @SARD                                        214057
     C     SCSARD        PARM      SCSARD        DSFDY                                        214057
                                                                                              214057
     C     @RTCD         IFEQ      *BLANKS                                                    214057
     C                   MOVE      'Y'           S01457            1                          214057
     C                   ELSE                                                                 214057
     C                   MOVE      'N'           S01457                                       214057
     C                   ENDIF                                                                214057
 
      ** Determine if enhancement CSC022 is switched on                                       CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD             7                          CSC022
     C                   PARM      '*VERIFY'     POPTN             7                          CSC022
     C                   PARM      'CSC022'      PSARD             6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      * Initialize work fields                                                                CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      *                                                                                       CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        COMITNUM <> 0                                              CSC022
     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
     C                   If        WPos > 0                                                   CSC022
     C                   Eval      WSkpCom = 'Y'                                              CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Else                                                                 CSC022
      ** An NRF (No Record Found) return code is valid.                                       CSC022
      ** Issue database error only for error return codes.                                    CSC022
     C                   If        PRTCD <> '*NRF'                                            CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   Eval      DBASE = 3                                                  CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 3                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
      **-------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **-------------------------------------------------------------------
 
      ** Set up the name of the server/database updater data queue.
 
     C                   EVAL      DtaQName = 'APTRANDTQ'
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFOTCOC023
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      **-------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------
      *********************************************************************
      /EJECT
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2001
