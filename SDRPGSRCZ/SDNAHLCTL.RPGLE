     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Interface controller')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLCTL - SD Non-A/C Holders Details Maintenance           *
      *                                                               *
      *  Function: This Program Validates SD Non-A/C Holder details   *
      *            for input into the Midas database.                 *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Non-A/C Holder details fields     *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For D (=Delete) call a separate function to      *
      *              process this Non-A/C Holder and bypass the rest  *
      *              of the validation                                *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. MD029805           Date 05Sep14               *
      *  Prev Amend No. MD026550           Date 22May14               *
      *                 CGL132             Date 01May13               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029805 - GIIN number validation (Recompile)                *
      *  MD026550 - Require US TIN when Subject to Reporting is 'Y'   *
      *             for all new FATCA Customers/Non-Account Holders   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax                        *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Standard Changes (Recompile)             *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** Valid Non-A/C Holders
     FSDVNAHLPD UF A E             DISK    Infsr(*PSSR)
     F                                     Prefix(V_)
     F                                     Commit
     FSDVFTNHPD UF A E             DISK    INFSR(*PSSR)                                       CGL132
     F                                     PREFIX(V_)                                         CGL132
     F                                     COMMIT                                             CGL132
 
      ** Invalid Non-A/C Holders
     FSDINAHLPD UF A E             DISK    Infsr(*PSSR)
     F                                     Commit
     FSDIFTNHPD UF A E             DISK    INFSR(*PSSR)                                       CGL132
     F                                     COMMIT                                             CGL132
 
     FSDVNAHLL1 IF   E           K DISK    RENAME(SDVNAHLD0:SDVNAHLCHK)
 
     FZAFLDNPD  IT   F   15        DISK    Infsr(*PSSR)
 
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
 
      ** Incoming Header
     D HeadIn        E DS                  Extname(APHEADPD)
 
      ** Incoming Transaction
     D*TranInPrim    E DS                  Extname(SDNAHLPD)                                  CER047
     D TranInPrim    E DS                  Extname(SDNAHLPD)                                  CER047
     D***TranInPrim1             1    500                                              CER047 CGL132
     D*TranInPrim2           501    866                                              CER047 BUG22580
     D*TranInPrim2           501    911                                              BUG22580 CER054
     D***TranInPrim2           501    917                                              CER054 CGL132
     D TranInPrim1             1   1000                                                       CER047
     D TranInPrim2          1001   1417                                                       CER054
     D TranInFatca   E DS                  EXTNAME(SDFTNRPD)                                  CGL132
 
      ** Valid Non-A/C Holder layout
     D ValidNaho     E DS                  Extname(SDVNAHLPD)
     D                                     Prefix(V_)
 
      ** (Current) Non-A/C Holder record in file Format
     D NahoFilFmt    E DS                  Extname(SDNAHOPD)
 
      ** (Current) Non-A/C Holder in Screen Format - Primary Details
     D CurNaPrim     E DS                  Extname(SDNAHLPD)
     D                                     Prefix(@)
                                                                                              CGL132
      ** Current Non-A/C Holder in File Format - FATCA details                                CGL132
     D CrFaFilFmt    E DS                  EXTNAME(SDFTNHPD)                                  CGL132
     D                                     PREFIX(C_)                                         CGL132
                                                                                              CGL132
      ** Current Non-A/C Holder in Screen Format - FATCA Details                              CGL132
     D CurCuFATC     E DS                  EXTNAME(SDFTNRPD)                                  CGL132
     D                                     PREFIX(@)                                          CGL132
                                                                                              CGL132
      ** New Non-A/C Holder in File Format - FATCA Details                                    CGL132
     D ValidFatca    E DS                  EXTNAME(SDVFTNHPD)                                 CGL132
     D                                     PREFIX(V_)                                         CGL132
 
      ** Error indicators
     D OKNaPrim      E DS                  Extname(SDENAHLPD)
     D OKFATCAdet    E DS                  EXTNAME(SDEFTNHPD)                                 CGL132
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  Extname(SDAPIPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)
     D  SCA_LCD      E                     Extfld(LCD)
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  Extname(DSSDY)
 
     D CrFoFilFmt      DS                                                                     CGL132
     D  WCDESC                 1     50                                                       CGL132
     D  WPDESC                51    100                                                       CGL132
     D  WWBRTH               101    105                                                       CGL132
     D  WWCBTH               106    107                                                       CGL132
     D  WWBTHT               108    142                                                       CGL132
     D  WWCNCZ               143    144                                                       CGL132
     D  WWCDOM               145    146                                                       CGL132
     D  WWACCZ               147    148                                                       CGL132
     D  WWTINO               149    173                                                       CGL132
                                                                                              CGL132
     D CurCuFOTH       DS                                                                     CGL132
     D  WCDESC2                1     50                                                       CGL132
     D  WPDESC2               51    100                                                       CGL132
     D  WNBRTH2              101    106                                                       CGL132
     D  WWCBTH2              107    108                                                       CGL132
     D  WWBTHT2              109    143                                                       CGL132
     D  WWCNCZ2              144    145                                                       CGL132
     D  WWCDOM2              146    147                                                       CGL132
     D  WWACCZ2              148    149                                                       CGL132
     D  WWTINO2              150    174                                                       CGL132
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field(s)
     D ExtData         S            500
 
 
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D***Trans5001       S            500A                                                    CGL132
     D Trans5001       S           1000A                                                      CGL132
     D Trans5003       S           3000A                                                      CGL132
     D ExtData500      S            500A                                                      CGL132
      *                                                                                       CER047
      ** Fields (500A) to receive the incoming transaction                                    CER047
      *                                                                                       CER047
     D Trans5002       S            500A                                                      CER047
 
 
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
 
     D CGL032          S              1A
     D Retcd           S              7A
     D Option          S              7A
     D Sardesc         S              6A
 
     D WNAHO           S                   LIKE(DDNAHO)
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   Inz('SDNAHLUPC')
     D Lib             S             10A   Inz('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   Inz('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   Inz('0     ')
     D Dlcobj          S              1A   Inz('Y')
     D Return          S              7A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   Like(#MsgID)
     D DummyMsgF       S             10A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   Inz('Y')
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   Inz('N')
 
      ** MQ fields
     D MQError         S             28
     D MQReturn        S             10
     D MQErrLong       S            132
 
      ** RTV parameter fields
     D ModeofOp        S              6
     D @in36           S              1
 
      ** 2VL parameter field
     D RespMode        S              1
 
      ** APDTASUBS parameter fields
     D IncData         S           2000
     D CurData         S           2000
 
      ** Keyfields used
     D KNaho           S             10
 
     D CSC011          S              1A
     D TransDtl        S           5800A
     D PNahoNum        S             18A
     D PANahoNo        S             18A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Incoming transaction is broken into 500A fields, so that a common CL
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structure.
 
     C                   EVAL      TranInPrim1 = Trans5001                                    CER047
     C                   EVAL      TranInPrim2 = Trans5002                                    CER047
     C**********         EVAL      TranInPrim = Trans5001 + extdata                           CER047
     C                   EVAL      TranInPrim = TranInPrim + extdata                          CER047
     C                   EVAL      TranInFatca = Trans5003                                    CGL132
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset variables gradually updated
 
     C                   EXSR      SRResetCycle
 
      **  Check if valid Non-A/C Holder details exists
 
     C                   EXSR      SRChkValNaho
 
      **  If valid Non-A/C Holder details does exist (even after delay), fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      **  Check if valid Non-A/C Holder exists for Midas Non-A/C Holder
 
     C                   EXSR      SRChkValMiCu
 
      **  If valid Non-A/C Holder does exist (even after delay), fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid Non-A/C Holder details file.
 
     C                   EXSR      SRResetCycle
 
      **  Validate Action Code
 
     C                   EXSR      SRValidateAc
 
      **  If error in validation of action code, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      **  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
 
      **  Processing for Inserts
 
     C                   EXSR      SRValidateTr
 
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'D'
 
      **  Processing for Amends or Changes
 
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
 
     C                   IF        DDACTN = 'A' AND GHSUBS <> *blank
 
     C     GHSUBS        SCAN      TranInPrim                             99
     C                   IF        *In99
     C                   EVAL      RepPrim = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
 
     C                   IF        (RepPrim = 'Y')
     C                   EXSR      SRDtaSubs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRSetupAmd
     C                   EXSR      SRValidateTr
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      **  Check for exception error from any program lower in the stack
      **  If error detected, send message to system operator and
      **  return to calling program without updating database or
      **  prompting the database update program
 
     C                   IN        APDUMP
 
     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError
     C                   MOVEL     MQError       MQErrlong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn
     C                   PARM                    MQErrlong
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *Lock         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
 
      **  Processing for Error checking/write to database
 
     C                   EXSR      SRCheckWrite
 
      **  If valid, send data queue entry to prompt DB update program
 
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
 
      **  Check if update program active using Allocate Object API
      **  No prompting necessary if program is running
 
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
     C/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRChkValNaho - Check if valid Non-A/C Holder details exist   *
      *****************************************************************
 
     C     SRChkValNaho  BEGSR
 
      ** Check for Non-A/C Holder on Valid file
 
     C                   MOVEL     DDNAHO        WNAHO
     C     WNAHO         CHAIN     SDVNAHLL1                          99
 
      ** If record found...
 
     C     *In99         IFEQ      *Off
 
      ** ..delay, then repeat check
 
     C                   CALLB     'ZACDELAY'
 
     C     WNAHO         CHAIN     SDVNAHLL1                          99
 
      ** Error if still present
 
     C     *In99         IFEQ      *Off
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'NHNAHO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRChkValMiCu - Routine to check if valid Non-A/C Holder      *
      **    exists for Midas Non-A/C Holder                           *
      *****************************************************************
 
     C     SRChkValMiCu  BEGSR
 
      ** Key list for file SDVNAHLL1
 
     C     KMINah        Klist
     C                   Kfld                    KNAHO
 
     C
     C     DDNAHO        IFNE      *BLANKS
 
      ** Check for Customer on Valid file
 
     C                   MOVEL     DDNAHO        KNAHO
     C     KMINah        CHAIN     SDVNAHLL1                          99
 
      ** If record found...
 
     C     *In99         IFEQ      *Off
 
      ** ..delay, then repeat check
 
     C                   CALLB     'ZACDELAY'
 
     C     KMINah        CHAIN     SDVNAHLL1                          99
 
      ** Error if still present
 
     C     *In99         IFEQ      *Off
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNAHO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRValidateAc - Routine to validate action code versus the    *
      **                Customer number supplied                      *
      *****************************************************************
 
     C     SRValidateAc  BEGSR
 
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas transaction ID is not present
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).
 
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
 
     C     DDNAHO        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate action code versus transaction IDs supplied
      ** The Customer in file format from the SD database is retrieved
      ** as well.
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'SDNAHLRTV'
      ** INPUTS :         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Return code
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      ** Response mode
      ** Action Code
      ** Front Office Transaction ID
      ** (Midas) Non-A/C Holder Number
 
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    ModeofOp
     C                   PARM                    APRESPMODE
     C                   PARM                    DDACTN
     C                   PARM                    APFOTranID
     C                   PARM                    DDNAHO
     C                   PARM                    @IN36
 
      ** OUTPUTS :
      ** (Current) Non-A/C Holder in file format
      ** OK - Action code
      ** OK - Non-A/C Holder Number
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    NahoFilFmt
     C                   PARM                    CrFaFilFmt                                   CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
     C                   PARM                    OkActn
     C                   PARM                    OKNaho
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSetUpAmd - Set up fields that are needed in the validation *
      **    of amendments and changes.                                *
      *****************************************************************
 
     C     SRSetupAmd    BEGSR
 
      ** For Amends, put the complete (pre-existing) Non-A/C Holder into the Valid
      **  file record - fields in this will be updated during processing
 
     C                   MOVE      NahoFilFmt    ValidNaho
     C                   MOVE      CrFaFilFmt    ValidFatca                                   CGL132
 
      ** For Amends, convert the Non-A/C Holder to screen format
 
     C                   CALLB     'SDNAHLCVT'
      ** INPUTS :         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Return Code
      ** Non-A/C Holder - file formats
 
     C                   PARM                    RetCodeIn
     C                   PARM                    ValidNaho
     C                   PARM                    CrFaFilFmt                                   CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
 
      ** OUTPUTS :
      ** Non-A/C Holder Details - screen formats
 
     C                   PARM                    CurNaPrim
     C                   PARM                    CurCuFATC                                    CGL132
     C                   PARM                    CurCuFOTH                                    CGL132
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ******************************************************************
      ** SRValidateTr - Routine to validate the main transaction details
      ******************************************************************
 
     C     SRValidateTr  BEGSR
 
      ** Validate Non-A/C Holder Primary details
 
     C                   EXSR      SRValdNaPrim
 
      **  If error in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      EVALidTr
     C                   ENDIF
 
     C                   EXSR      SRValdNaFatca                                              CGL132
                                                                                              CGL132
      **  If error in validation, fail this input                                             CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EVALidTr                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C     EVALidTr      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRValdNaPrim - Validate Non-A/C Holder Primary details       *
      *****************************************************************
 
     C     SRValdNaPrim  BEGSR
 
     C                   CALLB     'SDNAHL2VL'
      ** INPUTS :        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Response mode
      ** Non-A/C Holder Primary Details
      ** Non-A/C Holder Extra Data
 
     C                   PARM                    RespMode
     C                   PARM                    TranInPrim
     C                   PARM                    ExtData
 
      ** OUTPUTS :
      ** Non-A/C Holder Primary Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Valid Non-A/C Holder layout (DS) from/to caller
 
     C                   PARM                    OKNaPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidNaho
     C                   PARM                    CGL032
 
     C                   ENDSR
 
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** SRValdNaFatca- Validate Non-A/C Holder FATCA details         *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SRValdNaFatca BEGSR                                                                CGL132
                                                                                              CGL132
      ** Validate FATCA details 1                                                             CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH5VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    TranInFatca                                  CGL132
     C                   PARM                    CurCuFATC                                    CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
     C                   PARM                    ValidNaho                                    CGL132
     C                   PARM      DDCRDT        P_CRDT            8                        MD026550
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx                                         CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    ValidFatca                                   CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      ESRValdNaFatca                                             CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Validate FATCA details 2                                                             CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH1VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    TranInFatca                                  CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx                                         CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    ValidFatca                                   CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      ESRValdNaFatca                                             CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Validate FATCA details 3                                                             CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH2VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    TranInFatca                                  CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx                                         CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    ValidFatca                                   CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      ESRValdNaFatca                                             CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Validate FATCA details 4                                                             CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH3VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    TranInFatca                                  CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx                                         CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    ValidFatca                                   CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      ESRValdNaFatca                                             CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Validate US Indicia details 4                                                        CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH4VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    TranInFatca                                  CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx                                         CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    ValidFatca                                   CGL132
                                                                                              CGL132
                                                                                              CGL132
     C     ESRValdNaFatcaENDSR                                                                CGL132
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCheck/Write - Routine to control checking of error status and
      **    sending of messages/writing to the database
      *****************************************************************
 
     C     SRCheckWrite  BEGSR
 
      **  If no errors were found:
      **     - set up additional data
      **     - write a record to the Valid file
      **     - use std message handler to report Non-A/C Holder status
      **  If any errors were found:
      **     - write a record to the Invalid file
      **     - call the message handler to pass the errors back
      **     - use std message handler to report trade status
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
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   ELSE                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   ENDIF                                                  |
      ** |                                                            |
      ** | ENDIF                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... ELSE ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
 
     C                   IF        Idx = 0
     C                   EXSR      SRSetUpValid
     C                   WRITE     SDVNAHLD0
     C                   WRITE     SDVFTNHD0                                                  CGL132
     C                   EXSR      SRCallMsgHdl
     C                   ENDIF
 
     C                   IF        Idx > 0
     C                   EXSR      SRSetUpInVal
 
      ** Only write to invalid files if repair in back office
 
     C                   IF        APRprLocn = 'B'
     C                   WRITE     SDINAHLD0
     C                   WRITE     SDIFTNHD0                                                  CGL132
     C                   ENDIF
 
      ** If support system is active, write invalid transaction to
      ** log file via APLOGTRAN standard module.
 
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)
 
     C**********         EVAL      TransDtl = TranInPrim + ExtData                            CGL132
     C                   EVAL      TransDtl = TranInPrim + TranInFatca + ExtData              CGL132
     C                   EVAL      APTGTTYPE = 'SDNAHL'
     C                   EVAL      PNahoNum = DDNAHO
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TransDtl
     C                   PARM                    Timestamp
     C                   PARM                    PNahoNum
     C                   PARM      *BLANKS       PANahoNo
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      DBKEY = PNahoNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRCallMsgHdl
     C                   ENDIF
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRResetCYCLE - Reset error information that is gradually     *
      **              updated during each run of this program         *
      *****************************************************************
 
     C     SRResetCYCLE  BEGSR
 
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
     C                   CLEAR                   CurNaPrim
     C                   CLEAR                   CurCuFATC                                    CGL132
     C                   MOVE      *ALL'Y'       OKNaPrim
     C                   CLEAR                   ValidNaho
     C                   CLEAR                   ValidFatca                                   CGL132
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSetUpInVal - Set up additional fields that are needed on the
      **        Valid file record.
      *****************************************************************
 
     C     SRSetupInVal  BEGSR
 
      ** Include Header fields that need to be o/p to the Invalid files
 
     C                   EVAL      DDFRNT = APFOTranID
     C                   EVAL      DDREPA = APRprLocn
     C                   EVAL      DDFOTRANID = APFOTranID                                    CGL132
     C                   EVAL      DDRPRLOCN  = APRprLocn                                     CGL132
     C                   MOVE      TimeStamp     DDTMESTMP                                    CGL132
     C                   MOVE      TimeStamp     DDTMST
 
     C                   EVAL      TranStatus = 'F'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSetUpValid - Set up additional fields that are needed on the
      **    Valid file record.
      *****************************************************************
 
     C     SRSetUpValid  BEGSR
 
      ** For Deletes put the complete (pre-existing) Non-A/C Holder
      **  into the Valid file record
 
     C                   IF           DDACTN = 'D'
     C                   MOVE      NahoFilFmt    ValidNaho
     C                   MOVE      CrFaFilFmt    ValidFatca                                   CGL132
     C                   ENDIF
 
      ** Set Valid file field(s) that are needed for all Action Codes
 
     C                   EVAL      V_NACHTP = DDACTN
     C                   EVAL      V_NANAHO = DDNAHO
     C                   EVAL      V_FVNAHO = DDNAHO                                          CGL132
     C                   EVAL      V_NALUSR = DDLUSR                                          CGL132
 
      ** Include Header fields that need to be o/p to the Valid file
 
     C                   EVAL      V_NAFRNT = APFOTranID
     C                   EVAL      V_NAREPA = APRprLocn
     C                   EVAL      V_NATMST = TimeStamp
     C                   EVAL      V_FVFOID = APFOTranID                                      CGL132
     C                   EVAL      V_FVREPA = APRprLocn                                       CGL132
     C                   MOVE      TimeStamp     V_FVTMST                                     CGL132
 
     C                   EVAL      TranStatus = 'S'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCallMsgHdl - Call the Message Handling module
      *****************************************************************
 
     C     SRCallMsgHdl  BEGSR
 
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
 
     C                   CALLB     'ZAMSGHNDLE'
     C                   PARM                    ReturnCode
     C                   PARM                    APRprLocn
     C                   PARM                    APCnfValFO
     C                   PARM                    MsgIDArr
     C                   PARM                    FldNoArr
     C                   PARM                    FldNameArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    APFOTranID
     C                   PARM                    ModuleID
     C                   PARM                    DDNAHO
     C                   PARM                    #MsgFile
     C                   PARM                    DDACTN
     C                   PARM                    TranStatus
     C                   PARM                    APRespMode
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
     C                   PARM                    APRpyQueue
     C                   PARM                    TimeStamp
     C                   PARM                    MsgFArray
     C                   PARM                    ClrPgmMsgQ
 
     C                   ENDSR
      *****************************************************************
      /eject
      *****************************************************************
      ** SRDtaSubs - Data Substitution                                *
      *****************************************************************
 
     C     SRDtaSubs     BEGSR
 
      ** Convert file fields to screen format
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'SDNAHLCVT'
      ** Return Code     ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Non-A/C Holder - file formats
      ** Non-A/C Holder Details - screen formats
 
     C                   PARM                    ReturnCode
     C                   PARM                    NahoFilFmt
     C                   PARM                    CurNaPrim
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   IF        RepPrim = 'Y'
 
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
 
     C                   CALLB     'APDTASUBS'
      ** Return code     ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Substitution character
      ** Incoming Data
      ** Current Data
 
     C                   PARM                    ReturnCode
     C                   PARM                    GHSUBS
     C                   PARM      TranInPrim    IncData        2000
     C                   PARM      CurNaPrim     CurData        2000
 
     C                   MOVEL     IncDATA       TranInPrim
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Program Initialisation routine                      *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** Common header information (DS) from source system
      ** Transaction information
      ** Ultimate calling Program/Module/Procedure
 
     C                   PARM                    HeadIn
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002                                    CER047
     C                   PARM                    Trans5003                                    CGL132
     C                   PARM                    ExtData
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
 
     C                   EVAL      #MsgFile     = 'SDUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'Y2USRMSG'
 
      **  Set up the Module ID, used to make the Transaction number unique
 
     C                   EVAL      ModuleID = 'SD'
 
 
      ** Access Bank details via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access API ICD via access program
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     Retcd
     C                   PARM      '*FIRST '     Option
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Check if CSC011 is installed
 
     C                   EVAL      CSC011 = 'N'
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
 
      ** Set up the name of the server/database updater data queue.
 
     C                   EVAL      DtaQName = 'APNAHLDTQ'
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
