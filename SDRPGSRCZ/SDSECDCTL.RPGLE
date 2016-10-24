     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients Interface controller')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSECDCTL - SECURITY CUSTOMER DETAILS                        *
      *                                                               *
      *  Function: This Program Validates SD Securities Clients for   *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Customer details fields           *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For D (=Delete) call a separate function to      *
      *              process this Customer and bypass the rest        *
      *              of the validation                                *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR1029381          Date 26Sep12               *      
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 243070             Date 10Jul06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSE070             Date 15Feb05               *
      *                 BUG3122            Date 17Jul04               *
      *                 BUG2254            Date 06May04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 24Oct03               *
      *                 CSE042             Date 05Feb03               *
      *                 CSE041             Date 05Feb03               *
      *                 CSE039             Date 05Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP013             Date 31Mar00               *
      *                 CAP039  *CREATE    Date 26Oct99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1029381 - Narrative is not updated. (Child: AR1029382)     *      
      *  243070 - Recompile over changed PF/SDVSECDPD                 *
      *  CSE070 - Repo Coupon Claims Report                           *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  BUG2254 - Recompile over changed PF/SDISECDPD                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CSE042 - Auto Feed of Trades and Movements                   *
      *  CSE041 - DVP/RVP Processing                                  *
      *  CSE039 - Automatic Settlement of Trades                      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP039 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Seccurity Customers Clients
     FSDVSECDPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Invalid Security Customer Clients
     FSDISECDPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FSDVSECDL1 IF   E           K DISK    RENAME(SDVSECDD0:SDVSECDCHK)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
                                                                                              CSE022
      * Midas SD Valid Customer Depository Reference File                                     CSE022
     FSDVCSDRPD UF A E             DISK    INFSR(*pssr)                                       CSE022
     F                                     PREFIX(EV_)                                        CSE022
     F                                     COMMIT                                             CSE022
                                                                                              CSE022
      * Midas SD Invalid Customer Depository Reference File                                   CSE022
     FSDICSDRPD UF A E             DISK    INFSR(*pssr)                                       CSE022
     F                                     PREFIX(EI_)                                        CSE022
     F                                     COMMIT                                             CSE022
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDSECDC001
 
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
     D TranInSecd    E DS                  EXTNAME(SDSECDPD)
 
      * Valid Customer Securities Details layout
     D ValidSecd     E DS                  EXTNAME(SDVSECDPD)
     D                                     PREFIX(V_)
 
 
      * (Current) Customer record in file Format
     D SecdFilFmt    E DS                  EXTNAME(SDSECSPD)
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
 
 
      * (Current) Customer in Screen Format - Main Details
     D CurCuSecd     E DS                  EXTNAME(SDSECDPD)
     D                                     PREFIX(@)
 
 
      * Error indicators
     D OKCuSecd      E DS                  EXTNAME(SDESECDPD)
 
      * Error indicators                                                                      CSE039
     D OKCuSecd2     E DS                  EXTNAME(SDESECD2PD)                                CSE039
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
 
     D DepotNo         S              6    DIM(10)
      ** Depot customer numbers array
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D ExtData       E DS                  EXTNAME(SDSEEXPD)
      * SD Customer Security details Extra Data - File (D/B) format
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
                                                                                              CSE022
      ** Customer Depot Reference                                                             CSE022
     D PDepotRef     E DS                  EXTNAME(SDCSDSPD)                                  CSE022
     D                                     PREFIX(ES_)                                        CSE022
                                                                                              CSE022
      ** Customer Depot Reference OK indicators                                               CSE022
     D PDepotRefOK   E DS                  EXTNAME(SDECSDRPD)                                 CSE022
     D                                     PREFIX(EO_)                                        CSE022
                                                                                              CSE022
      ** Valid Customer Depository Reference File                                             CSE022
     D PValidDepot   E DS                  EXTNAME(SDVCSDRPD)                                 CSE022
                                                                                              CSE022
     D DepData         DS                                                                     CSE022
     D  PDepCtr                1      3  0                                                    CSE022
     D  PDepDet                4   4755                                                       CSE022
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
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
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('SDSECDUPC')
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
     D RepSecd         S              1A   inz('N')
                                                                                              CSE022
      ** Depository Definition Enhancement Indicator                                          CSE022
     D CSE022          S              1A                                                      CSE022
                                                                                              CSE022
      ** Automatic Setllement of Trades Indicator                                             CSE039
     D CSE039          S              1A                                                      CSE039
                                                                                              CSE039
      ** DVP/RVP Processing Indicator                                                         CSE041
     D CSE041          S              1A                                                      CSE041
                                                                                              CSE041
      ** Auto Feed of Trades and Movements Indicator                                          CSE042
     D CSE042          S              1A                                                      CSE042
                                                                                              CSE042
      ** Counter for CSE022 Enhancement                                                       CSE022
     D WCounter        S              3  0                                                    CSE022
     D WkCnt           S              3  0                                                    CSE022
                                                                                              CSE022
     D WFirst          S              1A                                                      CSE022
     D X1              S              4  0                                                    CSE022
     D X2              S              4  0                                                    CSE022
     D X3              S              4  0                                                    CSE022
                                                                                              CSE022
      ** Fields defined for enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PCustNum        S             18A                                                      CSC011
     D PACustNo        S             18A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSECDC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SDSECDC003
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInSecd
     C                   MOVEL     Extdata500    Extdata
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,SDSECDC004
 
      *  Check if valid Security Customer details exists
 
     C                   EXSR      ChkValSecd
      *
      *  If valid Sec.det. does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
                                                                                CAP013
      *  Check if valid Customer exists for Midas Customer Number               CAP013
                                                                                CAP013
     C                   EXSR      ChkValMiSe                                   CAP013
      *                                                                         CAP013
      *  If valid Customer does exist (even after delay), fail this input       CAP013
      *                                                                         CAP013
     C     Idx           IFNE      0                                            CAP013
     C                   GOTO      INVALID                                      CAP013
     C                   END                                                    CAP013
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Customer details file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,SDSECDC005
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,SDSECDC006
 
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,SDSECDC007
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,SDSECDC008
 
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'D'
      *  Processing for Amends or Changes
      /COPY WNCPYSRC,SDSECDC009
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   if        DDACTN = 'A' AND GHSUBS <> *blank
 
     C     GHSUBS        scan      TranInSecd                             99
     C                   if        *in99
     C                   eval      RepSecd = 'Y'
     C                   endif
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   if        RepSecd = 'Y'
     C                   EXSR      DtaSubs
     C                   endif
 
     C                   endif
      **                 (End of "if DDACTN = 'A' and GHSUBS <> *blank")
 
     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,SDSECDC010
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,SDSECDC011
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,SDSECDC012
 
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
      /COPY WNCPYSRC,SDSECDC013
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,SDSECDC014
 
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
      /COPY WNCPYSRC,SDSECDC015
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValSecd - Routine to check if valid Security details exist *
      *                                                               *
      *****************************************************************
     C     ChkValSecd    BEGSR
 
      * Check for Security Customer on Valid file
     C                   MOVEL     DDCUSN        SECUST
     C     SECUST        CHAIN     SDVSECDL1                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     SECUST        CHAIN     SDVSECDL1                          99
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SECUST'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP013
      *****************************************************************         CAP013
      *                                                               *         CAP013
      * ChkValMiSe - Routine to check if valid Security Customer      *         CAP013
      *    exists for Midas Customer Number                           *         CAP013
      *                                                               *         CAP013
      *****************************************************************         CAP013
                                                                                CAP013
     C     ChkValMiSe    BEGSR                                                  CAP013
                                                                                CAP013
      ** Key list for file SDVSECDL1                                            CAP013
     C     KMISec        KLIST                                                  CAP013
     C                   KFLD                    KCUST             6            CAP013
      *                                                                         CAP013
      * If (numeric) Midas Customer number supplied                             CAP013
                                                                                CAP013
     C                   TESTN                   DDCUSN               9898      CAP013
     C                                                                          CAP013
     C     DDCUSN        IFNE      *BLANKS                                      CAP013
     C     *IN98         ANDEQ     '1'                                          CAP013
                                                                                CAP013
      * Check for Customer on Valid file                                        CAP013
     C                   MOVEL     DDCUSN        KCUST                          CAP013
     C     KMISec        CHAIN     SDVSECDL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     KMISec        CHAIN     SDVSECDL1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDCUSN'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   ENDSR                                                  CAP013
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Customer number supplied                                   *
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
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     DDCUSN        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
 
      * Validate action code versus transaction IDs supplied
      * The Customer in file format from the SD database is retrieved
      * as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'SDSECDRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C**********         PARM      '*FRONT'      ModeofOp          6            CAP013
     C                   PARM                    ModeofOp          6            CAP013
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
      * (Midas) Customer Number
     C                   PARM                    DDCUSN            6
      *
      * (Midas) Customer Number/Shortname
     C                   PARM                    DDCSST           10
      *
      * OUTPUTS
      *
      * (Current) Security Customer in file format
     C                   PARM                    SecdFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Customer Number
     C                   PARM                    DDCusnOK          1
      *
      ** Customer Shortname
     C                   PARM                    DDCSSN           10
 
      ** Customer Report Name
     C                   PARM                    DDCRNM           20
 
      ** Customer Report Town
     C                   PARM                    DDCRTN           10
 
      ** Depot Shortnames Array
     C                   PARM                    DepotSn
 
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
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
 
      * For Amends, put the complete (pre-existing) Customer into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVE      SecdFilFmt    ValidSecd
 
      * For Amends, convert the Securities Customer to screen format
 
     C                   CALLB     'SDSECDCVT'
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Security Customer - file formats
     C                   PARM                    ValidSecd
      *
      * Output parameters
      *
      * Security Customer Details - screen formats
     C                   PARM                    CurCuSecd
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Security Customer Client details
 
     C                   EXSR      ValdCuSecd
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Security Customer Client details 2                                           CSE039
                                                                                              CSE039
     C                   EXSR      ValdCuSecd2                                                CSE039
      *                                                                                       CSE039
      *  If error in validation, fail this input                                              CSE039
      *                                                                                       CSE039
     C     Idx           IFNE      0                                                          CSE039
     C                   GOTO      EValidTr                                                   CSE039
     C                   END                                                                  CSE039
 
      ** If CSE022 is installed                                                               CSE022
                                                                                              CSE022
     C                   IF        CSE022 = 'Y'                                               CSE022
                                                                                              CSE022
     C                   EVAL      WCounter = 0                                               CSE022
     C                   EVAL      WFirst = 'Y'                                               CSE022
                                                                                              CSE022
     C                   EVAL      ES_DDCUST = DDCUSN                                         CSE022
                                                                                              CSE022
      ** If classification is 'E' or 'C' other depot not allowed.                             CSE022
                                                                                              CSE022
     C                   IF        PDepCtr > 0                                                CSE022
     C                   IF        DDCLAS = 'C' OR DDCLAS = 'E'                               CSE022
     C                   ADD       1             Idx                                          CSE022
     C                   EVAL      FldNameArr(Idx) = '*ANY  '                                 CSE022
     C                   EVAL      MsgIDArr(Idx) = 'USR9118'                                  CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
      ** Check if all ten depot reference has been entered.                                   CSE022
                                                                                              CSE022
     C                   EVAL      WkCnt = 1                                                  CSE022
     C                   DOW       WkCnt <= 10                                                CSE022
                                                                                              CSE022
     C                   IF        DepotSn(WkCnt) = *BLANKS                                   CSE022
     C                   ADD       1             Idx                                          CSE022
     C                   EVAL      FldNameArr(Idx) = '*ANY  '                                 CSE022
     C                   EVAL      MsgIDArr(Idx) = 'USR9118'                                  CSE022
     C                   LEAVE                                                                CSE022
     C                   ENDIF                                                                CSE022
     C                   EVAL      WkCnt = WkCnt + 1                                          CSE022
     C                   ENDDO                                                                CSE022
     C                   ENDIF                                                                CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
     C                   DOW       PDepCtr > WCounter AND                                     CSE022
     C                             Idx = 0                                                    CSE022
                                                                                              CSE022
     C                   EXSR      SRSetValDep                                                CSE022
                                                                                              CSE022
     C                   CALLB     'SDCDRFVAL'                                                CSE022
                                                                                              CSE022
      * Response mode                                                                         CSE022
     C                   PARM      *BLANKS       RespMode                                     CSE022
                                                                                              CSE022
      ** Customer Depository Reference                                                        CSE022
     C                   PARM                    PDepotRef                                    CSE022
                                                                                              CSE022
      ** Security Customer Client Details                                                     CSE022
     C                   PARM                    TranInSecd                                   CSE022
                                                                                              CSE022
      ** Customer Depository OK Indicators                                                    CSE022
     C                   PARM                    PDepotRefOK                                  CSE022
                                                                                              CSE039
     *** Automatic Settlement of Trades                                                CSE039 222373
     C**********         PARM                    CSE039                                CSE039 222373
      **********                                                                       CSE022 222373
      ***DVP/RVP Processing                                                            CSE041 222373
     C**********         PARM                    CSE041                                CSE041 222373
      **********                                                                       CSE041 222373
      ***Auto*Feed of Trades and Movements                                             CSE042 222373
     C**********         PARM                    CSE042                                CSE042 222373
      **********                                                                       CSE039 222373
      * OUTPUTS                                                                        CSE039 222373
      **********                                                                       CSE039 222373
      **********                                                                       CSE039 222373
      ***Security Details screen 2 OK inds                                             CSE039 222373
     C**********         PARM                    OKCuSecd2                             CSE039 222373
      **********                                                                       CSE039 222373
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE022
     C                   PARM                    FldNameArr                                   CSE022
     C                   PARM                    MsgIdArr                                     CSE022
     C                   PARM                    MsgDtaArr                                    CSE022
                                                                                              CSE022
      ** Array index (3P0) from/to caller                                                     CSE022
     C                   PARM                    Idx                                          CSE022
                                                                                              CSE022
      ** Valid Customer Depository Reference File                                             CSE022
     C                   PARM                    PValidDepot                                  CSE022
      **********                                                                       CSE039 222373
      **Valid*Security Customer Client (DS) from/to caller                             CSE039 222373
     C**********         PARM                    ValidSecd                             CSE039 222373
                                                                                              CSE022
     C                   EVAL      WCounter = WCounter + 1                                    CSE022
                                                                                              CSE022
     C                   ENDDO                                                                CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdCuSecd - Validate Security Customer Client details        *
      *                                                               *
      *****************************************************************
     C     ValdCuSecd    BEGSR
 
     C                   CALLB     'SDSECDVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Security Customer Client Details
     C                   PARM                    TranInSecd
                                                                                              222373
      ** Automatic Settlement of Trades                                                       222373
     C                   PARM                    CSE039            1                          222373
 
      * OUTPUTS
 
      *
      ** Security Details OK inds
     C                   PARM                    OKCuSecd
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Valid Security Customer Client (DS) from/to caller
     C                   PARM                    ValidSecd
 
     C                   ENDSR
      *****************************************************************
      *****************************************************************                       CSE039
      *                                                               *                       CSE039
      * ValdCuSecd2 - Validate Security Customer Client details 2     *                       CSE039
      *                                                               *                       CSE039
      *****************************************************************                       CSE039
     C     ValdCuSecd2   BEGSR                                                                CSE039
                                                                                              CSE039
     C                   CALLB     'SDSECD2VL'                                                CSE039
                                                                                              CSE039
      * INPUTS                                                                                CSE039
                                                                                              CSE039
      * Response mode                                                                         CSE039
     C                   PARM                    RespMode          1                          CSE039
                                                                                              CSE039
      ** Security Customer Client Details                                                     CSE039
     C                   PARM                    TranInSecd                                   CSE039
                                                                                              CSE039
      ** Automatic Settlement of Trades                                                       CSE039
     C                   PARM                    CSE039                                       CSE039
                                                                                              CSE039
      ** DVP/RVP Processing                                                                   CSE041
     C                   PARM                    CSE041                                       CSE041
                                                                                              CSE041
      ** Auto Feed of Trades and Movements                                                    CSE042
     C                   PARM                    CSE042                                       CSE042
                                                                                              CSE039
      * OUTPUTS                                                                               CSE039
                                                                                              CSE039
      *                                                                                       CSE039
      ** Security Details screen 2 OK inds                                                    CSE039
     C                   PARM                    OKCuSecd2                                    CSE039
                                                                                              CSE039
      * Error fields/message IDs/message data (arrays) from/to caller                         CSE039
     C                   PARM                    FldNameArr                                   CSE039
     C                   PARM                    MsgIDArr                                     CSE039
     C                   PARM                    MsgDtaArr                                    CSE039
      * Array index (3P0) from/to caller                                                      CSE039
     C                   PARM                    Idx                                          CSE039
                                                                                              CSE039
      * Valid Security Customer Client (DS) from/to caller                                    CSE039
     C                   PARM                    ValidSecd                                    CSE039
                                                                                              CSE039
     C                   ENDSR                                                                CSE039
      *****************************************************************                       CSE039
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
      *     - use std message handler to report customer status
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
     C                   WRITE     SDVSECDD0
                                                                                              CSE022
      ** If CSE022 is installed                                                               CSE022
                                                                                              CSE022
     C                   IF        CSE022 = 'Y'                                               CSE022
                                                                                              CSE022
     C                   EVAL      EV_DSCUST = DDCUSN                                         CSE022
     C                   EVAL      WFirst = 'Y'                                               CSE022
                                                                                              CSE022
     C                   DO        PDepCtr                                                    CSE022
                                                                                              CSE022
      ** Format fields for output to file                                                     CSE022
                                                                                              CSE022
     C                   EXSR      SRSetDepRef1                                               CSE022
                                                                                              CSE022
     C                   WRITE     SDVCSDRD0                                                  CSE022
                                                                                              CSE022
     C                   ENDDO                                                                CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *
      * Only write to invalid files if repair in back office
     C                   IF        APRprLocn = 'B'
 
     C                   WRITE     SDISECDD0
                                                                                              CSE022
      ** If support system is active, write invalid transaction to                            CSC011
      ** log file via APLOGTRAN standard module.                                              CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranInSecd + ExtData                            CSC011
     C                   EVAL      APTGTTYPE = 'SDSECD'                                       CSC011
     C                   EVAL      PCustNum = DDCUSN                                          CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PCustNum                                     CSC011
     C                   PARM      *BLANKS       PACustNo                                     CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = PCustNum                                           CSC011
     C                   EVAL      DBFile = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBase = 002                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If CSE022 is installed                                                               CSE022
                                                                                              CSE022
     C                   IF        CSE022 = 'Y'                                               CSE022
                                                                                              CSE022
     C                   EVAL      EI_DDCUST = DDCUSN                                         CSE022
     C                   EVAL      WFirst = 'Y'                                               CSE022
                                                                                              CSE022
     C                   DO        PDepCtr                                                    CSE022
                                                                                              CSE022
      ** Format fields for output to file                                                     CSE022
                                                                                              CSE022
     C                   EXSR      SRSetDepRef2                                               CSE022
                                                                                              CSE022
     C                   WRITE     SDICSDRD0                                                  CSE022
                                                                                              CSE022
     C                   ENDDO                                                                CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
 
     C                   ENDIF
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
     C                   COMMIT
 
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
 
     C                   CLEAR                   CurCuSecd
 
     C                   MOVE      *ALL'Y'       OKCuSecd
     C                   MOVE      *ALL'Y'       OKCuSecd2                                    CSE039
 
     C                   CLEAR                   ValidSecd
 
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
     C                   EVAL      DDFOAsocID = APFOAsocID
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
     C                   EVAL      V_SETYLC = DDACTN
     C                   EVAL      V_SECUST = DDCUSN
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_SEFRNT = APFOTranID
     C                   EVAL      V_SEAFRT = APFOAsocID
     C                   EVAL      V_SEREPA = APRprLocn
 
     C                   EVAL      TranStatus = 'S'
      *                                                                                    AR1029381
      ** Narrative is old, because it is not validated.                                    AR1029381
      ** Carry forward file data to valid file                                             AR1029381
      *                                                                                    AR1029381
     C                   Eval      V_SESRCD = DDSRCD                                       AR1029381
     C                   Eval      V_SENARR = DDNARR                                       AR1029381
 
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
     C                   PARM                    DDCUSN
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
 
      ** Convert file fields to screen format
     C                   reset                   ReturnCode
     C                   CALLB     'SDSECDCVT'
      * Return Code
     C                   PARM                    ReturnCode
      * Input parameters
      * Security Customer - file formats
     C                   PARM                    SecdFilFmt
      *
      * Output parameters
      * Security Customer Details - screen formats
     C                   PARM                    CurCuSecd
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   if        RepSecd = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInSecd    IncData        2000
      * Current Data
     C                   PARM      CurCuSecd     CurData        2000
 
     C                   MOVEL     IncDATA       TranInSecd
 
     C                   endif
 
     C                   endsr
                                                                                              CSE022
      *****************************************************************                       CSE022
      /EJECT                                                                                  CSE022
      *****************************************************************                       CSE022
      *                                                               *                       CSE022
      * SRSetValDep - Set-up fields for depot reference validation    *                       CSE022
      *                                                               *                       CSE022
      *****************************************************************                       CSE022
                                                                                              CSE022
     C     SRSetValDep   BEGSR                                                                CSE022
                                                                                              CSE022
     C                   IF        WFirst = 'Y'                                               CSE022
                                                                                              CSE022
     C                   Z-ADD     1             X1                                           CSE022
     C                   Z-ADD     2             X2                                           CSE022
     C                   Z-ADD     8             X3                                           CSE022
                                                                                              CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
     C                   EVAL      X1 = X1 + 27                                               CSE022
     C                   EVAL      X2 = X2 + 27                                               CSE022
     C                   EVAL      X3 = X3 + 27                                               CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
     C                   EVAL      ES_DDACTN = %SUBST(PDepDet:X1:1)                           CSE022
     C                   EVAL      ES_DDDPOT = %SUBST(PDepDet:X2:6)                           CSE022
     C                   EVAL      ES_DDREFN = %SUBST(PDepDet:X3:20)                          CSE022
                                                                                              CSE022
     C                   EVAL      WFIRST = 'N'                                               CSE022
                                                                                              CSE022
     C                   ENDSR                                                                CSE022
                                                                                              CSE022
      *****************************************************************                       CSE022
      /EJECT                                                                                  CSE022
      *****************************************************************                       CSE022
      *                                                               *                       CSE022
      * SRSetDepRef1 - Set-up fields for depot ref. file update       *                       CSE022
      *                                                               *                       CSE022
      *****************************************************************                       CSE022
                                                                                              CSE022
     C     SRSetDepRef1  BEGSR                                                                CSE022
                                                                                              CSE022
     C                   IF        WFirst = 'Y'                                               CSE022
                                                                                              CSE022
     C                   Z-ADD     2             X2                                           CSE022
     C                   Z-ADD     8             X3                                           CSE022
                                                                                              CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
     C                   EVAL      X2 = X2 + 27                                               CSE022
     C                   EVAL      X3 = X3 + 27                                               CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
     C                   EVAL      EV_DSDPOT = %SUBST(PDepDet:X2:6)                           CSE022
     C                   EVAL      EV_DSREFN = %SUBST(PDepDet:X3:20)                          CSE022
                                                                                              CSE022
     C                   EVAL      WFIRST = 'N'                                               CSE022
                                                                                              CSE022
     C                   ENDSR                                                                CSE022
                                                                                              CSE022
      *****************************************************************                       CSE022
      /EJECT                                                                                  CSE022
      *****************************************************************                       CSE022
      *                                                               *                       CSE022
      * SRSetDepRef2 - Set-up fields for depot ref. file update       *                       CSE022
      *                                                               *                       CSE022
      *****************************************************************                       CSE022
                                                                                              CSE022
     C     SRSetDepRef2  BEGSR                                                                CSE022
                                                                                              CSE022
     C                   IF        WFirst = 'Y'                                               CSE022
                                                                                              CSE022
     C                   Z-ADD     1             X1                                           CSE022
     C                   Z-ADD     2             X2                                           CSE022
     C                   Z-ADD     8             X3                                           CSE022
                                                                                              CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
     C                   EVAL      X1 = X1 + 27                                               CSE022
     C                   EVAL      X2 = X2 + 27                                               CSE022
     C                   EVAL      X3 = X3 + 27                                               CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE022
     C                   EVAL      EI_DDACTN = %SUBST(PDepDet:X1:1)                           CSE022
     C                   EVAL      EI_DDDPOT = %SUBST(PDepDet:X2:6)                           CSE022
     C                   EVAL      EI_DDREFN = %SUBST(PDepDet:X3:20)                          CSE022
                                                                                              CSE022
     C                   EVAL      WFIRST = 'N'                                               CSE022
                                                                                              CSE022
     C                   ENDSR                                                                CSE022
 
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
     C                   PARM                    DepData                                      CSE022
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'SDUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'Y2USRMSG'
 
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'SD'
 
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
      *
      ** Access SAR details file to determine if TOF/Midas
      ** Interface is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP050'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP050            1
     C                   ELSE
     C                   MOVEL     'N'           CAP050
     C                   END
                                                                                              CSE022
      ** Access SAR details file to determine if CSE022                                       CSE022
      ** (Depository Definition Enhancement) is on.                                           CSE022
                                                                                              CSE022
     C                   CALLB     'AOSARDR0'                                                 CSE022
     C                   PARM      *BLANKS       @RTCD                                        CSE022
     C                   PARM      '*VERIFY'     @OPTN                                        CSE022
     C                   PARM      'CSE022'      @SARD                                        CSE022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE022
                                                                                              CSE022
     C                   IF        @RTCD = *BLANKS                                            CSE022
                                                                                              CSE022
     C                   MOVEL     'Y'           CSE022                                       CSE022
                                                                                              CSE022
     C                   ELSE                                                                 CSE022
                                                                                              CSE022
     C                   MOVEL     'N'           CSE022                                       CSE022
                                                                                              CSE022
     C                   ENDIF                                                                CSE022
                                                                                              CSE039
      ** Access SAR details file to determine if CSE039                                       CSE039
      ** (Automatic Setllement of Trades) is on                                               CSE039
                                                                                              CSE039
     C                   CALLB     'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD                                        CSE039
     C                   PARM      '*VERIFY'     @OPTN                                        CSE039
     C                   PARM      'CSE039'      @SARD                                        CSE039
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE039
      *                                                                                       CSE039
     C                   IF        @RTCD = *BLANKS                                            CSE039
     C                   EVAL      CSE039 = 'Y'                                               CSE039
     C                   ELSE                                                                 CSE039
     C                   EVAL      CSE039 = 'N'                                               CSE039
     C                   ENDIF                                                                CSE039
                                                                                              CSE041
      ** Access SAR details file to determine if CSE041                                       CSE041
      ** (DVP/RVP Processing) is on                                                           CSE041
                                                                                              CSE041
     C                   CALLB     'AOSARDR0'                                                 CSE041
     C                   PARM      *BLANKS       @RTCD                                        CSE041
     C                   PARM      '*VERIFY'     @OPTN                                        CSE041
     C                   PARM      'CSE041'      @SARD                                        CSE041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE041
      *                                                                                       CSE041
     C                   IF        @RTCD = *BLANKS                                            CSE041
     C                   EVAL      CSE041 = 'Y'                                               CSE041
     C                   ELSE                                                                 CSE041
     C                   EVAL      CSE041 = 'N'                                               CSE041
     C                   ENDIF                                                                CSE041
                                                                                              CSE042
      ** Access SAR details file to determine if CSE042                                       CSE042
      ** (Auto Feed of Trades and Movements) is on                                            CSE042
                                                                                              CSE042
     C                   CALLB     'AOSARDR0'                                                 CSE042
     C                   PARM      *BLANKS       @RTCD                                        CSE042
     C                   PARM      '*VERIFY'     @OPTN                                        CSE042
     C                   PARM      'CSE042'      @SARD                                        CSE042
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE042
      *                                                                                       CSE042
     C                   IF        @RTCD = *BLANKS                                            CSE042
     C                   EVAL      CSE042 = 'Y'                                               CSE042
     C                   ELSE                                                                 CSE042
     C                   EVAL      CSE042 = 'N'                                               CSE042
     C                   ENDIF                                                                CSE042
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APSECDDTQ'
 
     C* Override SDSECSLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
 
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
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> '*NRF') and                                      CSC011
     C                             (PRtCd <> *Blanks)                                         CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = 'CSC011'                                           CSC011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBase = 001                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDSECDC018
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** ##OX1
OVRDBF FILE(SDSECSLR) TOFILE(SDSECSL0) SHARE(*NO)
