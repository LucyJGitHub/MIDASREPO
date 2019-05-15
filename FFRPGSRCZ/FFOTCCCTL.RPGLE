     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Currency OTC input control')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFOTCCCTL - Currency over-the-counter options interface      *
      *              controller                                       *
      *                                                               *
      *  Function:  This module receives the data from the FF OTCC    *
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
      *                 CER001             Date 25Apr05               *
      *                 BG9185             Date 08Nov05               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 28Oct03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 208635             Date 16Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002             Date 14Jan02               *
      *                 CAP166             Date 15Oct01               *
      *                 201923             Date 18Sep01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 25Oct99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 CAP033             Date 26Apr99               *
      * Midas DBA 3.01 Patch E ---------------------------------------*
      *                 170520             Date 19Nov99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 147775             Date 30Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - Lux Upgrade to MidasPlus                            *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CGL014 - Collaterals Processing                              *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  208635 - Allow broker if S01457 is installed.                *
      *  CAS002 - Hedge Strategy/Linkage (recompile).                 *
      *  CAP166 - API for Non-Currency OTC                            *
      *  201923 - During amend, settlement details are not converted  *
      *           to screen format so incorrect details are shown.    *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Increased length of Transaction        *
      *           Reference ID from 6A to 20A.                        *
      *  170520 - Recompile over changed TRANSD file                  *
      *  CPL002 - Midas-Plato Interface (Recomipled)                  *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - APIs Phase 3.                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Valid transactions
     FFFVTRANPD O    E             DISK    COMMIT RENAME(TRANSDF : FFVTRAND0)
     F                                     PREFIX(V_) INFSR(*pssr)
 
      ** Valid settlement instructions
     FFFVSETLPD O    E             DISK    COMMIT RENAME(TRSETDF : FFVSETLD0)
     F                                     PREFIX(VS) INFSR(*pssr)
 
      ** Valid instrument types
     FFFVINSTPD O    E             DISK    COMMIT INFSR(*pssr)
     F                                     PREFIX(VI)
 
      ** Invalid transactions
     FFFIOTCCPD O    E             DISK    COMMIT INFSR(*pssr)
 
      ** Invalid customer settlement instructions
     FFFICSETPD O    E             DISK    COMMIT INFSR(*pssr)
 
      ** Valid transactions by front-office ID
     FFFVTRANL0 IF   E           K DISK    RENAME(TRANSDF : FFVTRANL)
     F                                     INFSR(*pssr)
     FFFVTRANL1 IF   E           K DISK    RENAME(TRANSDF : FFVTRANCK1)         CAP013
     F                                     INFSR(*pssr)                         CAP013
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFOTCCC001
     FFFVTNLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
     FFFIOTLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes definitions for thefields
      ** #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member.
     D/COPY ZACPYSRC,PROCPARMS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
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
     D  NoRecFound            99     99
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
 
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      ** Incoming Header
 
     D TranIn        E DS                  EXTNAME(FFOTCCPD)
      ** Incoming (new) Transaction in screen format
 
      ** Dummy incoming Transaction in screen format                                          CAP166
     D DummyTIn      E DS                  EXTNAME(FFOTCOPD)                                  CAP166
                                                                                              CAP166
     D ValidTran     E DS                  EXTNAME(FFVTRANPD) PREFIX(V_)
      ** Valid (new) transaction in file format; prefixed with V_ for valid
 
     D TranFilFmt    E DS                  EXTNAME(TRANSD) PREFIX(D_)
      ** Old transaction in File Format; prefixed with D_ for database
 
     D ValidSett     E DS                  EXTNAME(FFVSETLPD) PREFIX(VS)
      ** Valid (new) settlement instructions in file format; prefixed
      ** with VS for settlements.
 
     D ValidInst     E DS                  EXTNAME(FFVINSTPD) PREFIX(VI)
      ** Valid (new) instrument type details, prefixed with VI for
      ** valid instrument.
 
     D TranScnFmt    E DS                  EXTNAME(FFOTCCPD)
      ** Old transaction in Screen Format
     D                                     PREFIX(@)
 
     D CurCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** Customer settlement instructions (old) in screen format
     D                                     PREFIX(OC)
     D CurBrStScn    E DS                  EXTNAME(FFBSETPD)                    CAP011
      ** Broker settlement instructions (old) in screen format                  CAP011
     D                                     PREFIX(OB)                           CAP011
 
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** Customer settlement instructions (new) in screen format
 
     D NewBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** Broker Settlement Instructions (new) in screen format
      ** (not used for OTCs, but required by some called procedures).
 
 
     D OKTransDet    E DS                  EXTNAME(FFEOTCCPD)
      ** The OK flags for the transaction details
 
      ** The OK flags for the OTCO transaction details                                        CAP166
     D OKDummyDS     E DS                  EXTNAME(FFEOTCOPD)                                 CAP166
     D                                     PREFIX(A)                                          CAP166
                                                                                              CAP166
     D OKCustSet     E DS                  EXTNAME(FFECSETPD)
      ** The customer settlement details OK flags
 
     D OKBrokSet     E DS                  EXTNAME(FFEBSETPD)
      ** The broker settlement details OK flags
      ** (not used for OTCs, but required by some called procedures).
 
 
     D ExtData       E DS                  EXTNAME(FFOTEXPD)
      * FF Extension data (Over the Counter) - File (D/B) format
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(FFOTRXPD)                                  CER001
      *                                                                                       CER001
      ** FF Extension data (Over the Counter) - File (D/B) format (Regional)                  CER001
      *                                                                                       CER001
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for Access Programs
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details ICD
                                                                                CAP011
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** External DS for API ICD                                                CAP011
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas module flags
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFF007
     D  SLCD         E                     EXTFLD(LCD)                                        CFF007
      ** Switchable Features Details                                                          CFF007
                                                                                              CFF007
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  #ACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ** Trading details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  #ACCD2       E                     EXTFLD(QQACCD)                                     CGL029
      ** Dealing ICD
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** Portfolio Management ICD
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  #ACCD3       E                     EXTFLD(QQACCD)                                     CGL029
      ** Retail ICD
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  #ACCD4       E                     EXTFLD(QQACCD)                                     CGL029
      ** Futures and Options ICD
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch details
 
 
     D InstTypes     E DS                  EXTNAME(INTYPD)
      ** Instrument types
 
 
     D FFTRANUPC       DS                  DTAARA(FFTRANUPC)
      ** DS for allocation data area
                                                                                              CSC011
      ** Data structure for data area SC24X7                                                  CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Data structure for data area SDSTAT                                                  CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
 
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
 
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
      *                                                                                       CER001
      ** Field (500A) to receive the incoming extension data                                  CER001
      *                                                                                       CER001
     D RegData500      S            500A                                                      CER001
 
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
 
      ** --- Parameters for ZATRNRTV ---------------------------------------------------------------
      ** Module ID
     D Module          S              2A   INZ('FF')
 
      ** Transaction type (dummy field as it is not needed for FF)
     D DummyTRTY       S              1A
      ** --- End of parameters for ZATRNRTV --------------------------------------------------------
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A   INZ('FF')
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ***Front*or*back*office*processing***                                     CAP013
     D*ModeOfOp********S**************6A***INZ('*FRONT')                        CAP013
 
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
 
      ** Enhanced OTCs feature flag
     D CFF001          S              1A
 
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
 
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
                                                                                              CFF007
      ** PB customer indicator - Customer                                                     CFF007
     D PPBFLG          S              1A                                                      CFF007
                                                                                              CFF007
      ** PB customer indicator - Broker                                                       CFF007
     D PPBBFLG         S              1A                                                      CFF007
                                                                                              CFF007
      ** Switchable feature                                                                   CFF007
     D PSARD           S              6A                                                      CFF007
                                                                                              CFF007
      ** Market                                                                               CFF007
     D PMRKT           S              2A                                                      CFF007
                                                                                              CFF007
      ** Instrument                                                                           CFF007
     D PISTC           S              3A                                                      CFF007
                                                                                              CSC011
      ** CSC011 enhancement                                                                   CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
                                                                                              CSC011
      ** Define parameter to be passed to APLOGTRAN.                                          CSC011
     D TRANSDTL        S           5800A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Transaction number to be pass to APLOGTRAN.                                          CSC011
     D PDealNo         S             18A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Associated transaction number                                                        CSC011
     D PADealNo        S             18A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Define parameters for AOSARDR0                                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
                                                                                              CSC011
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFOTCCC002
     D DataLux         DS          1024                                                       CER001
     D  #1ISTT                 1      5                                                       CER001
     D  #1TNBR                 6     11                                                       CER001
     D  #1MRKT                12     13                                                       CER001
     D  #1FOTR                14     33                                                       CER001
     D  #1TMST                34     59Z                                                      CER001
      *                                                                                       CER001
      ** Valid Extended Exchange-trade in File Format                                         CER001
      *                                                                                       CER001
     D ValidFilExt   E DS                  EXTNAME(FFVTNLX1PD)                                CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Errors Indicators Extended Fields                                                    CER001
      *                                                                                       CER001
     D OkFlagsExt    E DS                  EXTNAME(FFEOTLX1PD)                                CER001
      *                                                                                       CER001
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FFOTCCC003
 
      ** Incoming transaction is in 2 500A fields, so that a common CLP
      ** can be used between this module and the one that reads the MQ
      ** queue.  This module needs to break those 500A by loading them into
      ** the appropriate (externally described) data structures.
     C                   EVAL      TranIn     = Trans5001
     C                   EVAL      NewCuStScn = Trans5002
     C                   EVAL      Regdata = Regdata500                                       CER001
     C                   EVAL      Extdata = Extdata500
     C                   EVAL      DummyTIn = *BLANKS                                         CAP166
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset variables gradually updated
 
     C                   EXSR      ResetCycle
 
      /COPY WNCPYSRC,FFOTCCC004
 
      ** Do initial checks on the transaction
      ** ------------------------------------
 
      ** Check if valid transaction exists for Front Office ID
 
     C                   EXSR      ChkValTran
      *
      ***If*valid*transaction*doesn't*exist,*fail*this*input                    CAP013
      *  If valid transaction does exist (even after delay), fail this input    CAP013
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
                                                                                CAP013
      *  Check if valid transaction exists for Midas Transaction Number         CAP013
                                                                                CAP013
     C                   EXSR      ChkValMiTr                                   CAP013
      *                                                                         CAP013
      *  If valid transaction does exist (even after delay), fail this input    CAP013
      *                                                                         CAP013
     C     Idx           IFNE      0                                            CAP013
     C                   GOTO      INVALID                                      CAP013
     C                   END                                                    CAP013
 
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid transactions file.
 
     C                   EXSR      ResetCycle
 
      ** Apply the overrides for the FF multimembered files
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFAPYOVR'
     C                   PARM                    ReturnCode
     C                   PARM                    OTCMember
 
      /COPY WNCPYSRC,FFOTCCC005
 
      ** Validate Action Code
 
     C                   EXSR      ValidateAc
 
      /COPY WNCPYSRC,FFOTCCC006
 
      *  If error in validation of action code, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      ** Processing depends upon Action Code
 
     C                   SELECT
 
      ** Processing for Inserts
 
     C                   WHEN      SACTN = 'I'
      **                 ----
 
      ** Validate the main details of the transaction
      /COPY WNCPYSRC,FFOTCCC007
     C                   EXSR      ValidateTr
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      ** Do the settlements defaulting
      /COPY WNCPYSRC,FFOTCCC008
     C                   EXSR      DftSettmts
 
      ** Validate the charges and commission details
      /COPY WNCPYSRC,FFOTCCC009
     C                   EXSR      ValidateCC
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      ** Validate the settlement instructions
      /COPY WNCPYSRC,FFOTCCC010
     C                   EXSR      ValidateSt
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
                                                                                              CFF007
      ** Validate Private Banking Fields                                                      CFF007
                                                                                              CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     BGN4ST        ANDEQ     'Y'                                                        CFF007
     C                   EXSR      ValidatePB                                                 CFF007
                                                                                              CFF007
      *  If errors in validation, fail this input                                             CFF007
                                                                                              CFF007
     C     Idx           IFNE      0                                                          CFF007
     C                   GOTO      INVALID                                                    CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
 
      ** Processing for Amends
 
     C                   WHEN      SACTN = 'A'
      **                 ----
 
      ** Set up amendment details
      /COPY WNCPYSRC,FFOTCCC011
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      TranIn                                 99    CAP011
     C  N99GHSUBS        scan      NewCuStScn                             99    CAP011
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011
     C                   EXSR      SetupAmend
 
      ** Validate the main details of the transaction
      /COPY WNCPYSRC,FFOTCCC012
     C                   EXSR      ValidateTr
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      ** Validate the charges and commission details
      /COPY WNCPYSRC,FFOTCCC013
     C                   EXSR      ValidateCC
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      ** Validate the settlement instructions
      /COPY WNCPYSRC,FFOTCCC014
     C                   EXSR      ValidateSt
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      ** Check that the amendment is legitimate
      /COPY WNCPYSRC,FFOTCCC015
     C                   EXSR      ValAmend
 
      /COPY WNCPYSRC,FFOTCCC016
                                                                                              CFF007
      *  If errors in validation, fail this input                                             CFF007
                                                                                              CFF007
     C     Idx           IFNE      0                                                          CFF007
     C                   GOTO      INVALID                                                    CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** Validate Private Banking Fields                                                      CFF007
                                                                                              CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     BGN4ST        ANDEQ     'Y'                                                        CFF007
     C                   EXSR      ValidatePB                                                 CFF007
                                                                                              CFF007
      *  If errors in validation, fail this input                                             CFF007
                                                                                              CFF007
     C     Idx           IFNE      0                                                          CFF007
     C                   GOTO      INVALID                                                    CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
 
     C                   ENDSL
      **                 -----
 
     C     INVALID       TAG
 
      ** Check for exception error from any module lower in the stack
      ** If error detected, send message to system operator and
      ** return to caller without updating database or
      ** prompting the database update program (LogError SR
      ** includes a RETURN).
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,FFOTCCC017
 
     C                   IF        ARERRMOD <> *blank
     C                   EXSR      LogError
     C                   ENDIF
 
      ** Processing for error checking/write to database
      /COPY WNCPYSRC,FFOTCCC018
      *                                                                                       CER001
     C     ULX605        IFEQ      'Y'                                                        CER001
     C     ULX008        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsExt                                   CER001
      *                                                                                       CER001
      ** Validate the extension transaction details                                           CER001
      *                                                                                       CER001
     C                   MOVEL     SISTT         #1ISTT                                       CER001
     C                   MOVE      SISPT         #1TNBR                                       CER001
     C                   MOVEL     *BLANKS       #1MRKT                                       CER001
     C                   MOVE      SOFOTRANID    #1FOTR                                       CER001
     C                   MOVE      SOTMESTMP     #1TMST                                       CER001
      *                                                                                       CER001
     C                   CALLB     'FFOTCC3VL'                                                CER001
     C                   PARM                    SACTN                                        CER001
     C                   PARM                    DataLux                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OkFlagsExt                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExt                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C     Idx           IFEQ      0                                                          CER001
      *                                                                                       CER001
     C     ULX605        IFEQ      'Y'                                                        CER001
     C     ULX008        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
     C     SACTN         IFEQ      'I'                                                        CER001
     C                   EXSR      SetupTranN                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      STNBR         #6LXFFTNBR                                   CER001
     C                   EVAL      #6LXFFFOTR = APFOTranID                                    CER001
     C                   MOVE      L6LXTIME      #6LXFFTIME                                   CER001
     C                   MOVE      L6LXCABR      #6LXFFCABR                                   CER001
     C                   WRITE     FFVTNLXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Errors, write in invalid file                                                        CER001
      ** Only write to invalid files if repair in back office                                 CER001
      *                                                                                       CER001
     C     Idx           IFGT      0                                                          CER001
     C     APRprLocn     ANDEQ     'B'                                                        CER001
      *                                                                                       CER001
     C     ULX605        IFEQ      'Y'                                                        CER001
     C     ULX008        ANDEQ     'Y'                                                        CER001
     C                   EVAL      #6LXFOTR = APFOTranID                                      CER001
     C                   EVAL      #6LXTMES = TimeStamp                                       CER001
     C                   MOVE      L6LXTIME      #6LXTIME                                     CER001
     C                   MOVE      L6LXCABR      #6LXCABR                                     CER001
     C                   WRITE     FFIOTLXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EXSR      CheckWrite
 
      /COPY WNCPYSRC,FFOTCCC019
 
      ** If valid, send data queue entry to prompt DB update program
     C                   IF        Idx = 0
     C                   EXSR      SndPrompt
     C                   ENDIF
 
      ** Remove the multimember file overrides for this transaction
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFOTCCC020
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupAmend - Set up fields that are needed in the validation  *
      *              of Amendments.                                   *
      *                                                               *
      *****************************************************************
 
     C     SetupAmend    BEGSR
 
      ** For Amends, put the complete (pre-existing) transaction into
      ** the Valid file record - fields in this will be updated during
      ** processing.
     C                   EVAL      ValidTran = TranFilFmt
 
     C                   EVAL      CustBrokFl = 'C'                                           201923
     C                   RESET                   ReturnCode                                   201923
                                                                                              201923
     C                   CALLB     'FFSETLCVT'                                                201923
                                                                                              201923
      ** Outputs                                                                              201923
                                                                                              201923
     C                   PARM                    ReturnCode                                   201923
     C                   PARM                    CurCuStScn                                   201923
     C                   PARM                    CurBrStScn                                   201923
                                                                                              201923
      ** Inputs                                                                               201923
                                                                                              201923
     C                   PARM                    ValidSett                                    201923
     C                   PARM                    CustBrokFl                                   201923
     C                   PARM                    STNBR                                        201923
     C                   PARM                    ISCY                                         201923
 
     C                   ENDSR
 
      *****************************************************************
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
 
      ** Conversion of file fields to screen format
     C                   RESET                   ReturnCode
     C                   CALLB     'FFOTCCCVT'
      ** Inputs
      ** ------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Old transaction in file format
     C                   PARM                    TranFilfmt
      * Instrument types
     C                   PARM                    InstTypes
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      ** Outputs
      ** -------
      ** Old transaction in screen format
     C                   PARM                    TranScnfmt
      * Premium
     C                   PARM                    SPREM            15
      ** Transaction Status
     C                   PARM                    StatusText
      ** CFF001 Enhancement                                                                   CFF007
     C                   PARM                    CFF001                                       CFF007
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
 
      ** Amend checking
     C                   RESET                   ReturnCode
     C                   CALLB     'FFOTCCAMD'
      ** Outputs
      ** -------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Transaction Details OK flags (DS) from/to caller
     C                   PARM                    OKTransDet
      ** Customer Settlement OK flags(DS) from/to caller
     C                   PARM                    OKCustSet
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      ** Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      ** Amendments OK
     C                   PARM                    AmendOk
      ** Inputs
      ** ------
      ** New transaction in Screen Format
     C                   PARM                    TranIn
      ** New Customer Settlement deatils in screen format
     C                   PARM                    NewCuStScn
      ** Old transaction in Screen Format
     C                   PARM                    TranScnfmt
      ** Old Customer Settlement Details in Screen Format
     C                   PARM                    CurCuStScn
      ** Old transaction in file format
     C                   PARM                    TranFilfmt
      ** Bank details ICD
     C                   PARM                    SDBANK
      ** Midas module flags
     C                   PARM                    SDMMOD
      ** General Ledger ICD
     C                   PARM                    SDGELR
      ** O.T.C. instrument switchable field
     C                   PARM                    CFF001
      ** Portfolio Management Details                                           CPB001
     C                   PARM                    SDPORT                         CPB001
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
 
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
      * ValidateTr - Validate the main tranaction details             *
      *                                                               *
      *****************************************************************
 
     C     ValidateTr    BEGSR
 
     C                   CALLB     'FFOTCCVAL'
      ** Outputs
      ** -------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      * Transaction Details OK flags (data structure, from/to caller)
     C                   PARM                    OKTransDet
      * Array index (3,0P, from/to caller)
     C                   PARM                    Idx
      ** Field name array (<ArrayMax> x 10A, returned to caller)
     C                   PARM                    FldNameArr
      ** Error message ID array (<ArrayMax> x 7A, returned to caller)
     C                   PARM                    MsgIDArr
      ** Error message data array (<ArrayMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Field name array (<ArrayMax> x 10A, returned to caller)
     C                   PARM                    WFldNamArr
      ** Warning message ID array (<ArrayMax> x 7A, returned to caller)
     C                   PARM                    WMsgIDArr
      ** Warning message data array (<ArrayMax> x 45A, returned to caller)
     C                   PARM                    WMsgDtaArr
      ** Valid transaction layout (data structure, from/to caller)
     C                   PARM                    ValidTran
      ** The branch details format (data structure, from SDBRCHPD)
     C                   PARM                    SDBRCH
      ** The current trading date (Midas day number)
     C                   PARM                    CTDATE
      ** Instrument details (DS based on INTYPD)
     C                   PARM                    InstTypes
      * Premium
     C                   PARM                    SPREM
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBFLG                                       CFF007
 
      ** Inputs
      ** ------
      ** Response mode (1A), from source system common header
     C                   PARM                    APRESPMODE
      ** Transaction information (data structure, from source system)
     C                   PARM                    TranIn
      * Extension data
     C                   PARM                    ExtData
      ** Bank details (data structure based on SDBANKPD)
     C                   PARM                    SDBANK
      ** Module flags (data structure based on SDMMODPD)
     C                   PARM                    SDMMOD
      ** General Ledger ICD (data structure, from SDGELRPD)
     C                   PARM                    SDGELR
      ** Futures and Options ICD (data structure based on SDFODAPD)
     C                   PARM                    SDFODA
      ** Dealing ICD (data structure based on SDDEALPD)
     C                   PARM                    SDDEAL
      ** Portfolio Management ICD (data structure based on SDPORTPD)
     C                   PARM                    SDPORT                                        CPM00
      ** O.T.C. instrument switchable field
     C                   PARM                    CFF001
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
     C                   PARM                    S01457                                       208635
 
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
      ** Outputs from called procedure
      ** -----------------------------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaWArr
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    ValidSett
 
      ** Inputs to called procedure
      ** --------------------------
      ** Data structure containing broker settlement details
     C                   PARM                    NewBrStScn
      ** Data structure containing customer settlement details
     C                   PARM                    NewCuStScn
      ** Data structure containing broker settlement OK flags
     C                   PARM                    OKBrokSet
      ** Data structure containing customer settlement OK flags
     C                   PARM                    OKCustSet
      ** Customer/ Broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Branch code (3A, from transaction)
     C                   PARM                    SBRCD
      ** Portfolio reference (4A)
     C                   PARM                    SPTFR
      ** Instrument currency (3A)
     C                   PARM                    ISCY
      ** Trade date in Midas day number format (5,0P)
     C                   PARM                    V_TRSD
      ** Broker Code (6S,0 from FFVTRANPD)
     C                   PARM                    V_BOCO
      ** Customer Code (6S,0 from FFVTRANPD)
     C                   PARM                    V_CUSC
      ** Branch internal customer number (from SDBRCHPD)
     C                   PARM                    A8BICN
      ** Current trading date
     C                   PARM                    CTDATE
      ** Bank Details ICD
     C                   PARM                    SDBANK
      ** General Ledger ICD
     C                   PARM                    SDGELR
      ** Midas Modules ICD
     C                   PARM                    SDMMOD
      ** Trading ICD
     C                   PARM                    SDTRAD
      ** Portfolio Management ICD
     C                   PARM                    SDPORT
      ** Retail ICD
     C                   PARM                    SDRETL
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBFLG                                       CFF007
      ** Collaterals Processing enhancement                                                   CGL014
     C                   PARM                    CGL014                                       CGL014
 
      ** Record any failure to ensure that the correct details get
      ** written to the invalid files.
     C                   IF        ReturnCode <> *blanks
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
     C                   RESET                   ReturnCode
     C                   CALLB     'FFVCHGCOM'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Broker settlement OK flags.
     C                   PARM                    OKBrokSet
      ** Customer settlement OK flags
     C                   PARM                    OKCustSet
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    ValidSett
 
      ** Inputs to called procedure
      ** --------------------------
      ** Data structure containing customer settlement details
     C                   PARM                    NewCuStScn
      ** Customer/ Broker flag (1A, Y = Broker, N = Customer)
     C                   PARM                    BrokerFlag
      ** Instrument currency (3A)
     C                   PARM                    ISCY
      ** Broker Chrg./Comm. Pattern                                                           CFF007
     C                   PARM                    BCPT                                         CFF007
      ** Market                                                                               CFF007
     C                   PARM      *Blanks       PMRKT                                        CFF007
      ** Instrument                                                                           CFF007
     C                   PARM      *Blanks       PISTC                                        CFF007
      ** No. of contracts                                                                     CFF007
     C                   PARM                    NUCO                                         CFF007
      ** Action code                                                                          CFF007
     C                   PARM                    SACTN                                        CFF007
      ** Broker                                                                               CFF007
     C                   PARM                    V_BOCO                                       CFF007
      ** CFF007 Enhancement                                                                   222373
     C                   PARM                    CFF007                                       222373
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBFLG                                       CFF007
 
      ** Record any failure to ensure that the correct details get
      ** written to the invalid files.
     C                   IF        ReturnCode <> *blanks
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
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     SACTN         IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     STNBR         IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
 
      ** Validate action code versus transaction IDs supplied.
      ** This function will set the Midas transaction number.
      ** The transaction in file format from the Midas database is
      ** also retrieved.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFOTCCRTV'
      ** Return code
     C                   PARM                    ReturnCode
      ** Inputs to called procedure
      ** --------------------------
      ** Mode = '*FRONT' (Front-office processing)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)               CAP013
     C*******************PARM                    ModeofOp                       CAP013
     C                   PARM                    ModeofOp          6            CAP013
      ** Response mode
     C                   PARM                    APRESPMODE
      ** Action Code
     C                   PARM                    SACTN
      ** Front Office Transaction ID
     C                   PARM                    APFOTranID
      ** Midas Transaction Number
     C                   PARM                    STNBR
      ** Flag to indicate module is (not) being called as a linked enquiry
     C                   PARM                    LinkEnq
      ** Bank details ICD
     C                   PARM                    SDBANK
      ** General Ledger ICD
     C                   PARM                    SDGELR
      ** Multibranching indicator
     C                   PARM                    BGMBIN
                                                                                              CAP166
      ** Transaction type                                                                     CAP166
                                                                                              CAP166
     C                   PARM      'OTCC'        TransType                                    CAP166
                                                                                              CAP166
      ** Outputs from called procedure
      ** -----------------------------
      ** Transaction in file format
     C                   PARM                    TranFilFmt
      ** Settlements in file format
     C                   PARM                    ValidSett
      ** Instrument Types
     C                   PARM                    InstTypes
      ** OK - Action code
     C                   PARM                    OKACTN
      ** OK - Deal Number
     C                   PARM                    OKTNBR
      ** Error fields/message IDs/message data (arrays)
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index
     C                   PARM                    Idx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                    CAP011
      *****************************************************************                       CFF007
      *                                                               *                       CFF007
      * ValidatePB - Validate Private Banking Details                 *                       CFF007
      *                                                               *                       CFF007
      *****************************************************************                       CFF007
      *                                                                                       CFF007
     C     ValidatePB    BEGSR                                                                CFF007
                                                                                              CFF007
     C                   CALLB     'FFOTCC2VL'                                                CFF007
      ** Outputs                                                                              CFF007
     C                   PARM      *BLANKS       ReturnCode                                   CFF007
     C                   PARM                    OKTransDet                                   CFF007
     C                   PARM                    OKDummyDS                                    CAP166
     C                   PARM                    Idx                                          CFF007
     C                   PARM                    FldNameArr                                   CFF007
     C                   PARM                    MsgIDArr                                     CFF007
     C                   PARM                    MsgDtaArr                                    CFF007
     C                   PARM                    WIdx                                         CFF007
     C                   PARM                    WFldNamArr                                   CFF007
     C                   PARM                    WMsgIDArr                                    CFF007
     C                   PARM                    WMsgDtaArr                                   CFF007
     C                   PARM                    ValidTran                                    CFF007
     C                   PARM                    InstTypes                                    CFF007
      ** Inputs                                                                               CFF007
     C                   PARM                    TranIn                                       CFF007
     C                   PARM                    DummyTIn                                     CAP166
     C                   PARM                    NewInst                                      CFF007
     C                   PARM                    SDBANK                                       CFF007
     C                   PARM                    SDMMOD                                       CFF007
     C                   PARM                    SDGELR                                       CFF007
     C                   PARM                    SDFODA                                       CFF007
     C                   PARM      'OTCC'        TransType                                    CAP166
                                                                                              CFF007
     C                   ENDSR                                                                CFF007
      *****************************************************************                       CFF007
      /EJECT                                                                                  CFF007
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
     C                   CALLB     'FFOTCCCVT'                                  CAP011
                                                                                CAP011
      * INPUTS                                                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      ** Old transaction in file format                                         CAP011
     C                   PARM                    TranFilfmt                     CAP011
      * Instrument types                                                        CAP011
     C                   PARM                    InstTypes                      CAP011
      * ICD                                                                     CAP011
     C                   PARM                    SDBANK                         CAP011
     C                   PARM                    SDDEAL                         CAP011
     C                   PARM                    SDMMOD                         CAP011
     C                   PARM                    SDPORT                         CAP011
      ** Outputs                                                                CAP011
      ** -------                                                                CAP011
      ** Old transaction in screen format                                       CAP011
     C                   PARM                    TranScnfmt                     CAP011
      * Premium                                                                 CAP011
     C                   PARM                    SPREM                          CAP011
      ** Transaction Status                                                     CAP011
     C                   PARM                    StatusText                     CAP011
      ** CFF001 Enhancement                                                                   CFF007
     C                   PARM                    CFF001                                       CFF007
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
                                                                                CAP011
     C                   EVAL      CustBrokFl = 'C'                             CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'FFSETLCVT'                                  CAP011
      * Outputs                                                                 CAP011
      * ~~~~~~~                                                                 CAP011
      ** Return code (10A, returned to caller)                                  CAP011
     C                   PARM                    ReturnCode                     CAP011
      ** Customer settlement instructions, screen format                        CAP011
     C                   PARM                    CurCuStScn                     CAP011
      ** Broker settlement instructions, screen format                          CAP011
     C                   PARM                    CurBrStScn                     CAP011
      *                                                                         CAP011
      * Inputs                                                                  CAP011
      * ~~~~~~                                                                  CAP011
      * Settlements in file format                                              CAP011
     C                   PARM                    ValidSett                      CAP011
      ** Customer/broker flag (1A)                                              CAP011
     C                   PARM                    CustBrokFl                     CAP011
      ** Midas Transaction Number                                               CAP011
     C                   PARM                    STNBR                          CAP011
      ** Instrument currency                                                    CAP011
     C                   PARM                    ISCY                           CAP011
                                                                                CAP011
      ** DATA SUBSTITUTION                                                      CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
                                                                                CAP011
      * TRANSACTION DETAILS                                                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TranIn        IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      TranScnfmt    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranIn                         CAP011
                                                                                CAP011
      * CUSTOMER SETTLEMENT DETAILS                                             CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewCuStScn    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurCuStScn    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewCuStScn                     CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
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
 
     C                   IF        NewCuStScn = *blank
 
     C                   EVAL      CustBrokFl = 'C'
     C                   EVAL      CustBrokNo = V_CUSC
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLDFT'
      ** Outputs
      ** -------
      **                     Return code
     C                   PARM                    ReturnCode
      **                     Broker settlement instructions
     C                   PARM                    NewBrStScn
      **                     Customer settlement instructions
     C                   PARM                    NewCuStScn
      ** Inputs
      ** ------
      ** Customer/broker flag
     C                   PARM                    CustBrokFl
      ** Customer or broker number
     C                   PARM                    CustBrokNo
      ** Market centre
     C                   PARM                    DummyMark
      ** Instrument code
     C                   PARM                    DummyInst
      ** Transaction type (purchase or sale)                                                  222373
     C                   PARM                    STRTY                                        222373
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
     C                   CLEAR                   Return
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
     C                   IF        Return = *blank
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
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
 
     C                   IF        SACTN = 'I'
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
      **                 (End of "If Idx = 0")
 
      ** If there were errors:
     C                   IF        Idx > 0
     C                   EXSR      SetupInval
 
      ** Only write to invalid files if repair in back office
     C                   IF        APRPRLOCN = 'B'
 
     C                   WRITE     FFIOTCCD0
 
     C                   EXSR      SetCustInv
     C                   WRITE     FFICSETD0
                                                                                              CSC011
      ** If CSC011 is present and CTL is still running in the support                         CSC011
      ** system, write invalid details to APIlogfile.                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EXSR      SRWriteLog                                                 CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
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
 
     C                   IF        FldNameArr(Ix) <> *blanks
 
     C                   EVAL      Iy = 1
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
      ** If a blank array entry is found, leave the DO loop.
     C                   LEAVE
 
     C                   ENDIF
      **                 End of "if FldNameArr(Ix) <> *blanks"
 
     C                   ADD       1             Ix
     C                   ENDDO
      **                 End of "DO ArrayMax"
 
     C                   RESET                   ReturnCode
 
     C                   MOVEL     STNBR         PTranID          20                          CAP033
                                                                                              CAP033
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Repair location (1A)
     C                   PARM                    APRPRLOCN
      ** Confirm validity to front office (1A)
     C                   PARM                    APCNFVALFO
      ** List of messages (Array of <ArrayMax>x7A message ids)              )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax> packed)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A)
     C                   PARM                    APFOTRANID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ***Midas*transaction*ID*(6A)*********************************************************** CAP033
      ** Midas transaction ID (20A, from caller)                                              CAP033
     C***********        PARM                    STNBR                                        CAP033
     C                   PARM                    PTranID                                      CAP033
      ** Message file (10A)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    SACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRESPMODE
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A)
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
 
      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      SOFOTRANID = APFOTRANID
     C                   EVAL      SOASOCFOID = APFOASOCID
     C                   EVAL      SORPRLOC = APRPRLOCN
     C                   EVAL      SOTMESTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,FFOTCCC021
 
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
 
      * Include Header fields that need to be o/p to the Invalid files
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
     C                   IF           STNBR = *blanks
     C                             OR STNBR = *zeros
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZATRNRTV'
     C                   PARM                    ReturnCode
     C                   PARM                    Module
     C                   PARM                    DummyTRTY
     C                   PARM                    STNBR
     C                   PARM                    V_TNBR
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKTNBR
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** If transaction number was entered, put it in the file field
     C                   ELSE
     C                   MOVE      STNBR         V_TNBR
 
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
 
      ** Check for trabsaction on Valid file
     C     APFOTranID    CHAIN     FFVTRANL0                          99
 
      ** If record found (variable NoRecFound is mapped to indicator 99)...
     C                   IF        NoRecFound = False
 
      ** ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     APFOTranID    CHAIN     FFVTRANL0                          99
 
      ** Error if still present
     C                   IF        NoRecFound = False
     C                   ADD       1             Idx
     C*******************EVAL      FldNameArr(Idx) = 'APFOTranID'               CAP013
     C                   EVAL      FldNameArr(Idx) = 'STNBR'                    CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP013
      *****************************************************************         CAP013
      *                                                               *         CAP013
      * ChkValMiTr - Check whether valid transaction exists for       *         CAP013
      *    Midas Transaction Number                                   *         CAP013
      *                                                               *         CAP013
      *****************************************************************         CAP013
                                                                                CAP013
     C     ChkValMiTr    BEGSR                                                  CAP013
                                                                                CAP013
      * If (numeric) Midas transaction number supplied                          CAP013
                                                                                CAP013
     C                   TESTN                   STNBR                9898      CAP013
                                                                                CAP013
     C     STNBR         IFNE      *BLANKS                                      CAP013
     C     *IN98         ANDEQ     '1'                                          CAP013
                                                                                CAP013
      ** Check for transaction on Valid file                                    CAP013
     C                   MOVEL     STNBR         TNBR                           CAP013
     C     TNBR          CHAIN     FFVTRANL1                          99        CAP013
                                                                                CAP013
      ** If record found (variable NoRecFound is mapped to indicator 99)...     CAP013
     C                   IF        NoRecFound = False                           CAP013
                                                                                CAP013
      ** ..delay, then repeat check                                             CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     TNBR          CHAIN     FFVTRANL1                          99        CAP013
                                                                                CAP013
      ** Error if still present                                                 CAP013
     C                   IF        NoRecFound = False                           CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'STNBR'                    CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDSR                                                  CAP013
      *****************************************************************         CAP013
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
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
 
     C                   RESET                   AmendOK
 
     C                   CLEAR                   ValidTran
     C                   CLEAR                   ValidSett
     C                   CLEAR                   ValidInst
 
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
     C                   IF           SACTN = 'D'
     C                   EVAL      ValidTran = TranFilFmt
     C                   ENDIF
 
      ** Set the change type equal to the action code to indicate the
      ** action to the database updater
     C                   EVAL      V_CHTP = SACTN
 
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
     C                   EVAL      VIUNSE = UNSE                                              CFF007
     C                   EVAL      VITECO = TECO                                              CFF007
     C                   EVAL      VITNAT = TNAT                                              CFF007
     C                   EVAL      VICRIK = CRIK                                              CFF007
     C                   EVAL      VICCYR = CCYR                                              CFF007
     C                   EVAL      VITWEI = TWEI                                              CFF007
 
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCCC022
 
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
     C                   PARM                    Idx
      ** Field names with errors array (<ArrayMax> x 10A)
     C                   PARM                    FldNameArr
      ** Error message ID array (<ArrayMax> x 7A)
     C                   PARM                    MsgIDArr
      ** Error message data array (<ArrayMax> x 45A)
     C                   PARM                    MsgDtaArr
      ** Warning array index (3,0P)
     C                   PARM                    WIdx
      ** Field names with warnings array (<ArrayMax> x 10A)
     C                   PARM                    WFldNamArr
      ** Warning message ID array (<ArrayMax> x 7A)
     C                   PARM                    WMsgIDArr
      ** Warning message data array (<ArrayMax> x 45A)
     C                   PARM                    WMsgDtaArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Field name array (<ErrArrMax> x 10A)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A)
     C                   PARM                    MsgDtaWArr
 
     C                   ENDSR
 
 
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      *                                                               *                       CSC011
      *  SRWriteLog - Setup data to be written to standard API log    *                       CSC011
      *               Calls APLOGTRAN                                 *                       CSC011
      *                                                               *                       CSC011
      *  Called by:  CheckWrite                                       *                       CSC011
      *                                                               *                       CSC011
      *  Calls: APLOGTRAN - API standard Log module                   *                       CSC011
      *                                                               *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRWriteLog    BEGSR                                                                CSC011
                                                                                              CSC011
      ** Setup value of TRANSDTL                                                              CSC011
     C                   EVAL      TRANSDTL = TranIn + NewCuStScn +                           CSC011
     C**********                   ExtData500                                          CSC011 CER001
     C                             RegData500 + ExtData500                                    CER001
                                                                                              CSC011
      ** Initialise Deal no to pass                                                           CSC011
     C                   EVAL      PDealNo = STNBR                                            CSC011
                                                                                              CSC011
      ** Call program that will write to API standard log file.                               CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       ReturnCode                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    TimeStamp                                    CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
      ** If error occurred, perform abnormal termination                                      CSC011
     C     ReturnCode    IFNE      *BLANKS                                                    CSC011
     C                   EVAL      DBASE = 2                                                  CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBKEY = '*CALL'                                            CSC011
     C                   EXSR      *pssr                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
                                                                                              CSC011
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Parameters received from caller
      ** -------------------------------
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    RegData500                                   CER001
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
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                CAP011
      ** Access API ICD via access program                                      CAP011
      *  (database error handling done in access program)                       CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      '*DBERR '     @RTCD                          CAP011
     C                   PARM      '*FIRST '     @OPTN                          CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
 
      ** Get the module flags
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Get the General Ledger ICD
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Get the trading details
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
      ** Get the Dealing ICD
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
 
      ** Get the portfolio ICD
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
 
      ** Get the retail ICD
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
 
      ** Futures and Options ICD
     C                   CALL      'AOFODAR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFODA        PARM      SDFODA        DSFDY
 
      ** Access SAR Details to determine whether Enhanced OTCs is present
     C                   MOVE      'N'           CFF001                                       CFF007
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFF001'      @SARD             6
 
     C                   IF        @RTCD = *blank
     C                   EVAL      CFF001 = 'Y'
     C                   ENDIF
 
      ** Determine if CFF007 is installed                                                     CFF007
                                                                                              CFF007
     C                   CALLB     'AOSARDR0'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD                                        CFF007
     C                   PARM      '*VERIFY'     @OPTN                                        CFF007
     C                   PARM      'CFF007'      PSARD                                        CFF007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFF007
                                                                                              CFF007
     C     @RTCD         IFEQ      *BLANKS                                                    CFF007
     C                   MOVE      'Y'           CFF007                                       CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      'N'           CFF007                                       CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CSC011
      ** Determine if 24x7 Midas availability is installed                                    CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** An NRF (No Record Found) return code is valid.                                       CSC011
      ** Issue database error only for error return codes.                                    CSC011
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBASE = 1                                                  CSC011
     C                   EXSR      *pssr                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Determine if S01457 is installed                                                     208635
                                                                                              208635
     C                   CALLB     'AOSARDR0'                                                 208635
     C                   PARM      *BLANKS       @RTCD                                        208635
     C                   PARM      '*VERIFY'     @OPTN                                        208635
     C                   PARM      'S01457'      PSARD                                        208635
     C     SCSARD        PARM      SCSARD        DSFDY                                        208635
                                                                                              208635
     C     @RTCD         IFEQ      *BLANKS                                                    208635
     C                   MOVE      'Y'           S01457            1                          208635
     C                   ELSE                                                                 208635
     C                   MOVE      'N'           S01457                                       208635
     C                   ENDIF                                                                208635
      ** Determine if enhancement CSC022 is switched on                                       CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APTRANDTQ'
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFOTCCC023
      *                                                                                       CER001
      ** ULX008 - Commissariat Aux Bourses                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX008            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX008'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX008                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   If        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX008'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 4                                                  CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX605 - API Luxembourg - Function FFOTCC                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX605            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX605'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX605                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   If        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX605'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 5                                                  CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX008        IFEQ      'Y'                                                        CER001
     C     ULX605        ANDEQ     'Y'                                                        CER001
     C                   OPEN      FFVTNLX1PD                                                 CER001
     C                   OPEN      FFIOTLX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
