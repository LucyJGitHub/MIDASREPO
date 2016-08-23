     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rate Interface Controller')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSPTRCTL - Spot Rates Interface Controller                  *
      *                                                               *
      *  Function: This Program Validates Spot Rates for              *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For A (=AMEND),                                  *
      *              - Validate the Transaction details fields        *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT147             Date 14Jan13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 BUG8205            Date 22Aug05               *
      *                 BUG8130            Date 10Aug05               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 25Oct00               *
      *                 CAP057  *CREATE    Date 25Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT147 - Automatic update of payment charges definitions     *
      *           Added hooks: CFT147_022, CFT147_023, CFT147_024     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8205 - Recompiled due to changes in file SDVSPTRPD        *
      *            Applied fix 209061                                 *
      *  BUG8130- Recompiled as there have been changes to SDVSPTRPD  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *           (Recompiled over changed SDVSPTRPD)                 *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Market Data  Feed.                                  *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Transaction file
     FSDVSPTRPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Invalid Transactions
     FSDISPTRPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FSDVSPTRL1 IF   E           K DISK    RENAME(SDVSPTRD0:SDVSPTRCHK)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDSPTRC001
 
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
 
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInTran    E DS                  EXTNAME(SDSPTRPD)
 
      * Valid Customer Securities Details layout
     D ValidTran     E DS                  EXTNAME(SDVSPTRPD)
     D                                     PREFIX(V_)
 
 
      * (Current) Transaction record in file Format
     D/COPY WNCPYSRC,SDH00627
     D/COPY OFCPYSRCZ,CFT147_022                                                              CFT147
     D TranFilFmt    E DS                  EXTNAME(SDCURRPD)
     D/COPY WNCPYSRC,SDH00628
     D/COPY OFCPYSRCZ,CFT147_023                                                              CFT147
 
 
      * (Current) Transaction in Screen Format - Main Details
     D CurTrTran     E DS                  EXTNAME(SDSPTRPD)
     D                                     PREFIX(@)
 
 
      * Error indicators
     D OKTrTran      E DS                  EXTNAME(SDESPTRPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D ExtData       E DS                  EXTNAME(SDSPTXPD)
      * SD Function Spot Rates Extra Data - File (D/B) format
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
 
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitjobs             4    103                                                       CSC022
      ** External DS for Commitment Control Data Area                                         CSC022
                                                                                              CSC022
     D wComitarr       S             10A   DIM(10)                                            CSC022
      ** Commitment Control Array                                                             CSC022
                                                                                              CSC022
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
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
 
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A   INZ('SD')
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('SDSPTRUPC')
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
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepTran         S              1A   inz('N')
 
      ** Define module parameter fields for call to CVT module
     D/COPY WNCPYSRC,SDH00629
     D DDDCY2          S                   LIKE(A6DLCI)
     D DDSWC2          S                   LIKE(A6SWCY)
     D DDVSEU          S                   LIKE(A6CYCD)
     D DDMDI2          S                   LIKE(A6MDIN)
     D/COPY WNCPYSRC,SDH00630
     D DDSPR2          S                   LIKE(DDSPRT)
     D/COPY WNCPYSRC,SDH00631
     D DDCYNM          S                   LIKE(A6CYNM)
     D DDDLCY          S                   LIKE(A6DLCI)
     D DDSWCY          S                   LIKE(A6SWCY)
     D/COPY WNCPYSRC,SDH00632
 
      ** Define module parameter fields for call to VAL
 
      * Limit Exchange Rate
     D/COPY WNCPYSRC,SDH00633
     D #1ERLC          S                   LIKE(A6ERLC)
     D/COPY WNCPYSRC,SDH00634
      * Base Currency Limit Change flag
     D WUBCLC          S              1
      * Save Spot Rate
     D/COPY WNCPYSRC,SDH00635
     D WUSSSR          S                   LIKE(A6ERLC)
     D/COPY WNCPYSRC,SDH00636
      * Save Multiply/Divide Indicator
     D WUSMDI          S              1
      * Out Currency Rate Against Euro
     D/COPY WNCPYSRC,SDH00637
     D POINER          S                   LIKE(A6SPRT)
     D/COPY WNCPYSRC,SDH00638
      * Out Currency Multiply/Divide Indicator Against Euro
     D POMDIN          S              1
 
     D WKCYCD          S                   LIKE(DDCYCD)
                                                                                              CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PDealNo         S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
 
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSPTRC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SDSPTRC003
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInTran
     C                   MOVEL     Extdata500    Extdata
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,SDSPTRC004
 
      *  Check if valid Spot Rates details exists
 
     C                   EXSR      ChkValTran
      *
      *  If valid SPTR details does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      * Reset variables again in case the details have been corrupted
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,SDSPTRC005
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,SDSPTRC006
 
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depends upon Action Code
 
      /COPY WNCPYSRC,SDSPTRC007
      /COPY WNCPYSRC,SDSPTRC008
 
      *  Processing for Amends or Changes
      /COPY WNCPYSRC,SDSPTRC009
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   if        GHSUBS <> *blank
 
     C     GHSUBS        SCAN      TranInTran                             99
     C                   IF        *in99
     C                   EVAL      RepTran = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   IF        RepTran = 'Y'
     C                   EXSR      DtaSubs
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "GHSUBS <> *blank")
 
     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,SDSPTRC010
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,SDSPTRC011
 
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,SDSPTRC012
 
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
      /COPY WNCPYSRC,SDSPTRC013
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,SDSPTRC014
 
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
      /COPY WNCPYSRC,SDSPTRC015
 
     C                   RETURN
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * ChkValTran - Routine to check if Spot Rate item for this currency*
      *              is already on the valid file                        *
      *                                                                  *
      ********************************************************************
     C     ChkValTran    BEGSR
 
      * Check for Spot Rates on Valid file
     C                   MOVEL     DDCYCD        AVCYCD
     C     AVCYCD        CHAIN     SDVSPTRL1                          99
 
     C                   IF        NOT *IN99
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     AVCYCD        CHAIN     SDVSPTRL1                          99
 
      * Error if still present
     C                   IF        NOT *IN99
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'AVCYCD'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Transaction number supplied                                *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      *  Front Office mode.
      *
     C                   MOVEL     '*FRONT'      ModeofOp
 
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the SD database is retrieved
      * as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'SDSPTRRTV'
      *
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      * INPUTS
      *
      * Mode of operation (front office or not front office)
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
      * (Midas) Transaction Number
     C                   PARM                    DDCYCD            3
      *
      * OUTPUTS
      *
      * (Current) Transaction in file format
     C                   PARM                    TranFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Transaction Number
     C                   PARM                    DDCYCDOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C/COPY OFCPYSRCZ,CFT147_024                                                              CFT147
 
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
 
      * For Amends, put the complete (pre-existing) Transaction into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVE      TranFilFmt    ValidTran
 
      * For Amends, convert the Spot Rates transaction to screen format
 
     C                   CALLB     'SDSPTRCVT'
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Spot Rates Transaction - file formats
     C                   PARM                    ValidTran
      *
      * Output parameters
      *
      * Spot Rates Transaction Details - screen formats
     C                   PARM                    CurTrTran
 
      * Currency Name
     C                   PARM                    DDCYNM
 
      * Dealing currency
     C                   PARM                    DDDLCY
 
      * SWIFT currency code
     C                   PARM                    DDSWCY
 
      * BKEURO currency
     C                   PARM                    DDVSEU
 
      * Spot Rate against base currency (when DDSPRT is against BKEURO)
      * (output screen field)
     C                   PARM                    DDSPR2
 
      * Multiply divide indicator tied to DDSPR2
      * (output screen field)
     C                   PARM                    DDMDI2
 
      * Dealing currency tied to DDSPR2 (output screen field)
     C                   PARM                    DDDCY2
 
      * Swift currency code tied to DDSPR2 (output screen field)
     C                   PARM                    DDSWC2
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Spot Rates Transaction details
 
     C                   EXSR      ValdTrTran
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
      * ValdTrTran - Validate Spot Rates Transaction details          *
      *                                                               *
      *****************************************************************
     C     ValdTrTran    BEGSR
      *
     C                   CALLB     'SDSPTRVAL'
      *
      * INPUTS
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      ** Spot Rates  Transaction Details
     C                   PARM                    TranInTran
      *
      * OUTPUTS
      *
      *
      ** Spot Rates Transaction Details OK inds
     C                   PARM                    OKTrTran
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid Spot Rates Transaction (DS) from/to caller
     C                   PARM                    ValidTran
      *
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
      *     - use std message handler to report status
      *  If any errors were found:
      *     - write a record to the Invalid file
      *     - call the message handler to pass the errors back
      *     - use std message handler to report trade status
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
 
 
     C                   IF        Idx = 0
 
     C                   EXSR      SETUPVALID
     C                   WRITE     SDVSPTRD0
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *
      * Only write to invalid files if repair in back office
     C                   IF        APRprLocn = 'B'
 
     C                   WRITE     SDISPTRD0
                                                                                              CSC011
      ** Write all invalid records to the support log file                                    CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranInTran +                                    CSC011
     C                                        ExtData                                         CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE  = 'SDSPTR'                                      CSC011
     C                   EVAL      PDealNo = DDCYCD                                           CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = DDCYCD                                             CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE = 901                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
 
     C                   ENDIF
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
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
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurTrTran
 
     C                   EVAL      DDCYNM = *BLANKS
     C                   EVAL      DDDLCY = *BLANKS
     C                   EVAL      DDSWCY = *BLANKS
 
     C                   MOVE      *ALL'Y'       OKTrTran
 
     C                   CLEAR                   ValidTran
 
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
 
      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,SDSECDC016
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
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_AVTYLC = DDACTN
     C                   EVAL      V_AVCYCD = DDCYCD
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_AVFOTRANID = APFOTranID
     C                   EVAL      V_AVRPRLOCN = APRprLocn
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,SDSECDC017
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
      ** Midas transaction ID (6A, from caller)
     C                   PARM                    DDCYCD
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
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************
 
     C     DtaSubs       begsr
 
      * Convert file fields to screen format
     C                   RESET                   ReturnCode
     C                   CALLB     'SDSPTRCVT'
      * RETURN CODE
     C                   PARM                    ReturnCode
 
      * INPUT PARAMETERS
      * Spot Rates Transaction - file formats
     C                   PARM                    TranFilFmt
 
      * OUTPUT PARAMETERS
      * Spot Rates Transaction Details - screen formats
      * Currency Name
      * Dealing currency
      * SWIFT currency code
      * BKEURO currency
      * Spot Rate against base currency (when DDSPRT is against BKEURO)
      * Multiply divide indicator tied to DDSPR2
      * Dealing currency tied to DDSPR2 (output screen field)
      * Swift currency code tied to DDSPR2 (output screen field)
     C                   PARM                    CurTrTran
     C                   PARM                    DDCYNM
     C                   PARM                    DDDLCY
     C                   PARM                    DDSWCY
     C                   PARM                    DDVSEU
     C                   PARM                    DDSPR2
     C                   PARM                    DDMDI2
     C                   PARM                    DDDCY2
     C                   PARM                    DDSWC2
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   if        RepTran = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
      * Substitution character
      * Incoming Data
      * Current Data
     C                   PARM                    ReturnCode
     C                   PARM                    GHSUBS
     C                   PARM      TranInTran    IncData        2000
     C                   PARM      CurTrTran     CurData        2000
 
     C                   MOVEL     IncDATA       TranInTran
 
     C                   endif
 
     C                   endsr
 
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
     C                   PARM                    ExtData500
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'SDUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'xxUSRMSG'
 
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *                                                                         CSD006
      ** Access SAR details file to determine if MDF Switchable feature         CSD006
      ** is switched on                                                         CSD006
      *                                                                         CSD006
     C                   CALLB     'AOSARDR0'                                   CSD006
     C                   PARM      *BLANKS       @RTCD                          CSD006
     C                   PARM      '*VERIFY'     @OPTN                          CSD006
     C                   PARM      'CSD006'      @SARD             6            CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                          CSD006
     C     @RTCD         IFEQ      *BLANK                                       CSD006
     C                   MOVEL     'Y'           CSD006            1            CSD006
     C                   ELSE                                                   CSD006
     C                   MOVEL     'N'           CSD006                         CSD006
     C                   END                                                    CSD006
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 900                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
 
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      ** Database Error                                                                       CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> *BLANKS and                                       CSC022
     C                             @RTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 902                                                CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *BLANK                                             CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        Comitnum > 0                                               CSC022
     C                   MoveA     wComitjobs    wComitarr                                    CSC022
     C     psJobname     Lookup    wComitarr                              10                  CSC022
     C                   If        *IN10                                                      CSC022
     C                   Eval      wSkip = 'Y'                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC022
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APSPTRDTQ'
 
      * Override SDSPTRLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDSPTRC018
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** ##OX1
OVRDBF FILE(SDSPTRLR) TOFILE(SDSPTRL0) SHARE(*NO)
