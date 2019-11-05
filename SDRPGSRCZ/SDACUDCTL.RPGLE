     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Interface Controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUDCTL - SD Additional Customer Details                   *
      *              Interface Contoller                              *
      *                                                               *
      *  Function: This Program Validates SD Additional Customer      *
      *            Details for Input into the Midas database.         *
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
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG2553            Date 19Aug09               *
      *                 BUG25956           Date 09Sep09               *
      *                 BUG25877           Date 03Sep09               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24013           Date 15May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23518A          Date 07Apr09               *
      *                 BUG23518           Date 30Mar09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER034A            Date 19May08               *
      *                 CER034             Date 16Jan09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. CSW207A            Date 06Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD029             Date 22Aug05               *
      *                 232543             Date 31Mar05               *
      *                 CGL031             Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *           (Recompile)                                         *
      *  BUG25533 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *             (Applied BUG24714 fix)                            *
      *  BUG24714 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *  BUG25956 - New fields in SDACUSPD are not updated after ACUD *
      *             CTL api is called.                                *
      *  BUG25877 - Data is always truncated and ends in ACUD repair  *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  BUG24013 - Religious Affiliation Code in SDACUSPD has been   *
      *             deleted. (Recompile)                              *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23518A - Display 'Close/Release' key in Repair            *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER034A - German Features - New Fields and Enquiries         *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207A - SWIFT 2007 Changes (Recompile)                     *
      *  CSD029 - Customer Details Additional Fields (Recompile)      *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation on Savings Income                          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      ** Midas SD Valid Additional Customers Details
     FSDVACUDPD UF A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(V_)
     F                                     COMMIT

      ** Midas SD Invalid Additional Customers Details
     FSDIACUDPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Midas SD Valid ACUD by Customer & Timestamp
     FSDVACUDL1 IF   E           K DISK    RENAME(SDVACUDD0:SDVACUDCHK)

      ** Midas ZA Sequence numbers for input fields
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      ** Hook to enable non-core files to be included

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

      /COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      /COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

      /COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
      /COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      /COPY ZACPYSRC,DTAQCHKDCL
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
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      ** Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(SDACUDPD)
      *                                                                                      CER034A
      ** Screen 2 Incoming Transaction                                                       CER034A
     D TranInDet2    E DS                  EXTNAME(SDACU3DPD)                                CER034A
      *                                                                                      CER034A
      ** Screen 3 Incoming Transaction                                                       CER034A
     D TranInDet3    E DS                  EXTNAME(SDACU4DPD)                                CER034A

      ** Valid Additional Customer layout
     D ValidAcud     E DS                  EXTNAME(SDVACUDPD)
     D                                     PREFIX(V_)

      ** (Current) Additional Customer record in file Format
     D AcusFilFmt    E DS                  EXTNAME(SDACUSPD)

      ** (Current) Additional Customer in Screen Format - Primary Details
     D CurCuPrim     E DS                  EXTNAME(SDACUDPD)
     D                                     PREFIX(@)
      *                                                                                      CER034A
      ** (Current) Additional Customer in Screen Format - Screen 2                           CER034A
     D CurCustDet2   E DS                  EXTNAME(SDACU3DPD)                                CER034A
     D                                     PREFIX(C1)                                        CER034A
      *                                                                                      CER034A
      ** (Current) Additional Customer in Screen Format - Screen 3                           CER034A
     D CurCustDet3   E DS                  EXTNAME(SDACU4DPD)                                CER034A
     D                                     PREFIX(C1)                                        CER034A

      ** Error indicators
     D OKCuPrim      E DS                  EXTNAME(SDEACUDPD)
     D OKCustDet2    E DS                  EXTNAME(SDEACU3PD)                                CER034A
     D OKCustDet3    E DS                  EXTNAME(SDEACU4PD)                                CER034A

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

     D SCA_LCD       E                     EXTFLD(LCD)

      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message field(s)
     D Msg1            S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Fields (500A) to receive the incoming transaction
     D*Trans5001       S            500A
     D Trans5001       S           1500A                                                    BUG25877
     D PTrans5002      S            500A                                                     CER034A
     D PTrans5003      S            500A                                                     CER034A

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

      ** Parameter for APCALCOBJ
     D Object          S             10A   INZ('SDACUDUPC')
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

      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   inz('N')

      ** Parameters for Access Object
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A

      ** Parameters for ZAMSGTOOPR
     D MQReturn        S             10A
     D MQErrlong       S            132A
     D MQError         S             28A

      ** Parameter for SDACUDRTV
     D ModeofOp        S              6A
     D PSDACUDENQ      S              1A
     D DDACTNOK        S              1A
     D DDCUSTOK        S              1A

      ** Parameter for SDACUDVAL
     D CGL032          S              1A
     D RespMode        S              1A

      ** Parameter for APDTASUBS
     D IncData         S           2000A
     D CurData         S           2000A

      ** Key Fields for SDVACUDL1
     D KCUST           S              6A

     D CSC011          S              1A
     D TransDtl        S           5800A
     D PCustNum        S             18A
     D PACustNo        S             18A
      *                                                                                      CER034A
      ** Switchable Features                                                                 CER034A
     D CER034          S              1A                                                     CER034A
     D CER038          S              1A                                                     CER034A
     D CER041          S              1A                                                     CER034A
     D CER047          S              1A                                                     CER034A
     D CER048          S              1A                                                     CER034A
     D CER045          S              1A                                                      CER045
     D CER054          S              1A                                                    BUG24714
      *                                                                                      CER034A
      ** Validate Screens Y/N Flag                                                           CER034A
     D WValScrn1       S              1A                                                     CER034A
     D WValScrn2       S              1A                                                     CER034A

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

     C**********         EVAL      TranInPrim = Trans5001 + ExtData500                       CER034A
     C                   EVAL      TranInPrim = Trans5001                                    CER034A
     C                   EVAL      TranInDet2 = PTrans5002                                   CER034A
     C                   EVAL      TranInDet3 = PTrans5003                                   CER034A

      ** Generate a timestamp for this transaction

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      ** Reset variables gradually updated

     C                   EXSR      SRResetCycle

      **  Check if valid Additional Customer details exists

     C                   EXSR      SRChkValAcud

      **  If valid Cust.det. does exist (even after delay), fail this input

     C                   IF        Idx <> 0
     C                   GOTO      InValid
     C                   ENDIF

      **  Check if valid Customer exists for Midas Customer Number

     C                   EXSR      SRChkValMiCu

      **  If valid Customer does exist (even after delay), fail this input

     C                   IF        Idx <> 0
     C                   GOTO      InValid
     C                   ENDIF

      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid Customer details file.

     C                   EXSR      SRResetCycle

      **  Validate Action Code

     C                   EXSR      SRValidateAc


      **  If error in validation of action code, fail this input

     C                   IF        Idx <> 0
     C                   GOTO      InValid
     C                   ENDIF

      **  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN         DDACTN = 'I'

      **  Processing for Inserts

     C                   EXSR      SRValidateTr

     C**********         WHEN         DDACTN = 'A' or                                      BUG23518A
     C                   WHEN         DDACTN = 'A'                                         BUG23518A
     C**********                      DDACTN = 'D'                                BUG23518 BUG23518A
     C**********                      DDACTN = 'D' OR                             BUG23518 BUG23518A
     C**********                      DDACTN = 'C' OR                             BUG23518 BUG23518A
     C**********                      DDACTN = 'R'                                BUG23518 BUG23518A

      **  Processing for Amends or Changes

      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.

     C                   IF        DDACTN = 'A' AND GHSUBS <> *Blanks

     C     GHSUBS        SCAN      TranInPrim                             99
     C                   IF        *IN99 = *ON
     C                   EVAL      RepPrim = 'Y'
     C                   ENDIF

      ** If any of the flags set above is true, do the data
      ** substitution subroutine.

     C                   IF        (RepPrim = 'Y')
     C                   EXSR      SRDtaSubs
     C                   ENDIF

     C                   ENDIF

     C                   EXSR      SRSetUpAmd
     C                   EXSR      SRValidateTr

     C                   ENDSL

     C     InValid       TAG

      **  Check for exception error from any program lower in the stack
      **  If error detected, send message to system operator and
      **  return to calling program without updating database or
      ** prompting the database update program

     C                   IN        APDUMP

     C                   IF        ARERRMOD <> *Blanks
     C                   EVAL      MQErrlong  = *Blanks
     C                   EVAL      MQError = ProcErr + '  ' + ARERRMOD
     C                   EVAL      MQErrlong = MQError

     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn
     C                   PARM                    MQErrlong
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF

     C                   EVAL      APRETCODE = ARERRMOD
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *Blanks
     C                   OUT       APDUMP
     C                   RETURN

     C                   ELSE

      **  Processing for Error checking/write to database

     C                   EXSR      SRCheckWrite

      ** If valid, send data queue entry to prompt DB update program

     C                   IF        Idx = 0
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
     C                   PARM      *Blanks       Return

     C                   IF        Return = *Blanks

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
      /COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Hook to enable non-core subroutines to be included

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkValAcud - Routine to check if valid Additional Customer  *
      *                details exist                                  *
      *                                                               *
      *****************************************************************
     C     SRChkValAcud  BEGSR

      ** Check for Customer on Valid file

     C                   EVAL      ACCUST = DDCUST
     C     ACCUST        CHAIN     SDVACUDL1                          99

      ** If record found...

     C                   IF        *IN99 = *OFF

      ** ..delay, then repeat check

     C                   CALLB     'ZACDELAY'

     C     ACCUST        CHAIN     SDVACUDL1                          99

      ** Error if still present

     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'ACCUST'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkValMiCu - Routine to check if valid Customer exists for  *
      *                Midas Customer Number                          *
      *                                                               *
      *****************************************************************
     C     SRChkValMiCu  BEGSR

      ** Key list for file SDVACUDL1
     C     KMICus        KLIST
     C                   KFLD                    KCUST

      ** If (numeric) Midas Customer number supplied

     C                   TESTN                   DDCUST               9898

     C                   IF        DDCUST <> *Blanks and
     C                             *IN98 = *ON

      ** Check for Customer on Valid file

     C                   EVAL      KCUST = DDCUST
     C     KMICus        CHAIN     SDVACUDL1                          99

      ** If record found...

     C                   IF        *IN99 = *OFF

      ** ..delay, then repeat check

     C                   CALLB     'ZACDELAY'

     C     KMICus        CHAIN     SDVACUDL1                          99

      ** Error if still present

     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidateAc - Routine to validate action code versus the       *
      *    Customer number supplied                                   *
      *                                                               *
      *****************************************************************
     C     SRValidateAc  BEGSR

      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas transaction ID is not present
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).

     C                   IF        DDACTN = 'I'
     C                   EVAL      ModeofOp = '*FRONT'
     C                   ELSE
     C                   IF        DDCUST = *Blanks
     C                   EVAL      ModeofOp = '*FRONT'
     C                   ELSE
     C                   EVAL      ModeofOp = *Blanks
     C                   ENDIF
     C                   ENDIF

      ** Validate action code versus transaction IDs supplied.
      ** The Additional Customer in file format from the SD database
      ** is retrieved as well.

     C                   RESET                   ReturnCode
     C                   CALLB     'SDACUDRTV'

      ** INPUTS
      ** Return code
     C                   PARM      *Blanks       ReturnCode

      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)

     C                   PARM                    ModeofOp

      ** Response mode
     C                   PARM                    APRESPMODE

      ** Action Code
     C                   PARM                    DDACTN

      ** Front Office Transaction ID
     C                   PARM                    APFOTRANID

      ** (Midas) Customer Number
     C                   PARM                    DDCUST

      ** Value is ' ' to have the same effect as SDACUDSIN
     C                   PARM      *Blanks       PSDACUDENQ

      ** OUTPUTS
      ** (Current) Additional Customer in file format
     C                   PARM                    AcusFilFmt

      ** OK - Action code
     C                   PARM                    DDACTNOK

      ** OK - Customer Number
     C                   PARM                    DDCUSTOK

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *                                                                                      CER034A
      ** Warning fields/message IDs/message data (arrays) from/to caller                     CER034A
      *                                                                                      CER034A
     C                   PARM                    WFldNamArr                                  CER034A
     C                   PARM                    WMsgIDArr                                   CER034A
     C                   PARM                    WMsgDtaArr                                  CER034A
      *                                                                                      CER034A
      ** Array index (3P0) from/to caller                                                    CER034A
      *                                                                                      CER034A
     C                   PARM                    WIdx                                        CER034A

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetUpAmd - Set up fields that are needed in the validation  *
      *              of amendments and changes.                       *
      *                                                               *
      *****************************************************************
     C     SRSetUpAmd    BEGSR

      ** For Amends, put the complete (pre-existing) Additional Customer into the
      ** Valid file record - fields in this will be updated during processing

     C                   EVAL      ValidAcud = AcusFilFmt

      ** For Amends, convert the Additional Customer to screen format

     C                   CALLB     'SDACUDCVT'

      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn

      ** Additional Customer - file formats
     C                   PARM                    ValidAcud

      ** Output parameters
      ** Additional Customer Details - screen formats
     C                   PARM                    CurCuPrim
     C                   PARM                    CurCustDet2                                 CER034A
     C                   PARM                    CurCustDet3                                 CER034A

      ** Customer Details

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidateTr - Routine to validate the main transaction       *
      *                details                                        *
      *                                                               *
      *****************************************************************
     C     SRValidateTr  BEGSR

      ** Validate Customer Primary details

     C                   EXSR      SRValdCuPrim

      **  If error in validation, fail this input

     C                   IF        Idx <> 0
     C                   GOTO      EValidTr
     C                   ENDIF
      *                                                                                      CER034A
      ** Validate Customer Details Screen 2                                                  CER034A
      *                                                                                      CER034A
     C                   IF        WValScrn1 = 'Y'                                           CER034A
     C                   EXSR      SRValDetl1                                                CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      **  If error in validation, fail this input                                            CER034A
      *                                                                                      CER034A
     C                   IF        Idx <> 0                                                  CER034A
     C                   LEAVESR                                                             CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Validate Customer Details Screen 3                                                  CER034A
      *                                                                                      CER034A
     C                   IF        WValScrn2 = 'Y'                                           CER034A
     C                   EXSR      SRValDetl2                                                CER034A
     C                   IF        Idx =  0                                                 BUG25956
     C                   MOVEL     DDBSCC        V_ACBSCC                                   BUG25956
     C                   EVAL      V_ACECAC = DDECAC                                        BUG25956
     C                   MOVEL     DDBIST        V_ACBIST                                   BUG25956
     C                   EVAL      V_ACABSK = DDABSK                                        BUG25956
     C                   EVAL      V_ACBEXT = DDBEXT                                        BUG25956
     C                   ENDIF                                                              BUG25956
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      **  If error in validation, fail this input                                            CER034A
      *                                                                                      CER034A
     C                   IF        Idx <> 0                                                  CER034A
     C                   LEAVESR                                                             CER034A
     C                   ENDIF                                                               CER034A

     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValdCuPrim - Validate Additional Customer Primary Details   *
      *                                                               *
      *****************************************************************
     C     SRValdCuPrim  BEGSR

     C                   MOVE      *All'Y'       OkCuPrim

     C                   CALLB     'SDACUDVAL'

      ** INPUTS
      ** Response mode
     C                   PARM                    RespMode

      ** Additional Customer Primary Details
     C                   PARM                    TranInPrim

      ** Switchable feature CGL032
     C                   PARM                    CGL032

      ** OUTPUTS
      ** Additional Customer Primary Details OK inds
     C                   PARM                    OKCuPrim

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Valid Additional Customer layout (DS) from/to caller
     C                   PARM                    ValidAcud

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                 CER034A
      *****************************************************************                      CER034A
      *                                                               *                      CER034A
      *  SRValDetl1 - Validate Input to Additional Customer Details 2 *                      CER034A
      *                                                               *                      CER034A
      *  Called By: SRValidateTr                                      *                      CER034A
      *                                                               *                      CER034A
      *  Calls: None                                                  *                      CER034A
      *                                                               *                      CER034A
      *****************************************************************                      CER034A
     C     SRValDetl1    BEGSR                                                               CER034A
      *                                                                                      CER034A
      ** Clear Error Indicators                                                              CER034A
      *                                                                                      CER034A
     C                   MOVE      *ALL'Y'       OKCustDet2                                  CER034A
      *                                                                                      CER034A
     C                   CALLB     'SDACUD3VL'                                               CER034A
      *                                                                                      CER034A
      ** Inputs                                                                              CER034A
      *                                                                                      CER034A
      ** Response Mode                                                                       CER034A
      *                                                                                      CER034A
     C                   PARM      *BLANKS       RespMode                                    CER034A
      *                                                                                      CER034A
      ** Screen 2 Incoming Transaction                                                       CER034A
      *                                                                                      CER034A
     C                   PARM                    TranInDet2                                  CER034A
      *                                                                                      CER034A
      ** Customer                                                                            CER034A
      *                                                                                      CER034A
     C                   PARM                    DDCUST                                      CER034A
      *                                                                                      CER034A
      ** Joint Account Type                                                                  CER034A
      *                                                                                      CER034A
     C                   PARM                    DDJATP                                      CER034A
      *                                                                                      CER034A
      ** Tax Identification Number                                                           CER034A
      *                                                                                      CER034A
     C                   PARM                    DDTINO                                      CER034A
      *                                                                                      CER034A
      ** Switchable Features                                                                 CER034A
      *                                                                                      CER034A
     C                   PARM                    CER047                                      CER034A
     C                   PARM                    CER048                                      CER034A
     C                   PARM                    CER054                                     BUG24714
      *                                                                                      CER034A
      ** Outputs                                                                             CER034A
      *                                                                                      CER034A
      ** Transaction Details OK Inds                                                         CER034A
      *                                                                                      CER034A
     C                   PARM                    OKCustDet2                                  CER034A
      *                                                                                      CER034A
      ** Error fields/message IDs/message data (arrays) from/to caller                       CER034A
      *                                                                                      CER034A
     C                   PARM                    FldNameArr                                  CER034A
     C                   PARM                    MsgIDArr                                    CER034A
     C                   PARM                    MsgDtaArr                                   CER034A
      *                                                                                      CER034A
      ** Array index (3P0) from/to caller                                                    CER034A
      *                                                                                      CER034A
     C                   PARM                    Idx                                         CER034A
      *                                                                                      CER034A
      ** Warning fields/message IDs/message data (arrays) from/to caller                     CER034A
      *                                                                                      CER034A
     C                   PARM                    WFldNamArr                                  CER034A
     C                   PARM                    WMsgIDArr                                   CER034A
     C                   PARM                    WMsgDtaArr                                  CER034A
      *                                                                                      CER034A
      ** Array index (3P0) from/to caller                                                    CER034A
      *                                                                                      CER034A
     C                   PARM                    WIdx                                        CER034A
      *                                                                                      CER034A
      ** Valid Transaction details layout (DS) from/to caller                                CER034A
      *                                                                                      CER034A
     C                   PARM                    ValidAcud                                   CER034A
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT                                                                                 CER034A
      *****************************************************************                      CER034A
      *                                                               *                      CER034A
      *  SRValDetl2 - Validate Input to Additional Customer Details 3 *                      CER034A
      *                                                               *                      CER034A
      *  Called By: SRValidateTr                                      *                      CER034A
      *                                                               *                      CER034A
      *  Calls: None                                                  *                      CER034A
      *                                                               *                      CER034A
      *****************************************************************                      CER034A
     C     SRValDetl2    BEGSR                                                               CER034A
      *                                                                                      CER034A
      ** Clear Error Indicators                                                              CER034A
      *                                                                                      CER034A
     C                   MOVE      *ALL'Y'       OKCustDet2                                  CER034A
      *                                                                                      CER034A
     C                   CALLB     'SDACUD4VL'                                               CER034A
      *                                                                                      CER034A
      ** Inputs                                                                              CER034A
      *                                                                                      CER034A
      ** Response Mode                                                                       CER034A
      *                                                                                      CER034A
     C                   PARM      *BLANKS       RespMode                                    CER034A
      *                                                                                      CER034A
      ** Screen 3 Incoming Transaction                                                       CER034A
      *                                                                                      CER034A
     C                   PARM                    TranInDet3                                  CER034A
      *                                                                                      CER034A
      ** Customer                                                                            CER034A
      *                                                                                      CER034A
     C                   PARM                    DDCUST                                      CER034A
      *                                                                                      CER034A
      ** Switchable Features                                                                 CER034A
      *                                                                                      CER034A
     C                   PARM                    CER034                                      CER034A
     C                   PARM                    CER038                                      CER034A
     C                   PARM                    CER041                                      CER034A
      *                                                                                      CER034A
      ** Outputs                                                                             CER034A
      *                                                                                      CER034A
      ** Transaction Details OK Inds                                                         CER034A
      *                                                                                      CER034A
     C                   PARM                    OKCustDet3                                  CER034A
      *                                                                                      CER034A
      ** Error fields/message IDs/message data (arrays) from/to caller                       CER034A
      *                                                                                      CER034A
     C                   PARM                    FldNameArr                                  CER034A
     C                   PARM                    MsgIDArr                                    CER034A
     C                   PARM                    MsgDtaArr                                   CER034A
      *                                                                                      CER034A
      ** Array index (3P0) from/to caller                                                    CER034A
      *                                                                                      CER034A
     C                   PARM                    Idx                                         CER034A
      *                                                                                      CER034A
      ** Warning fields/message IDs/message data (arrays) from/to caller                     CER034A
      *                                                                                      CER034A
     C                   PARM                    WFldNamArr                                  CER034A
     C                   PARM                    WMsgIDArr                                   CER034A
     C                   PARM                    WMsgDtaArr                                  CER034A
      *                                                                                      CER034A
      ** Array index (3P0) from/to caller                                                    CER034A
      *                                                                                      CER034A
     C                   PARM                    WIdx                                        CER034A
      *                                                                                      CER034A
      ** Valid Transaction details layout (DS) from/to caller                                CER034A
      *                                                                                      CER034A
     C                   PARM                    ValidAcud                                   CER034A
      *                                                                                       CER045
      * Pass the value of CER045                                                              CER045
      *                                                                                       CER045
     C                   PARM                    CER045                                       CER045
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCheck/Write - Routine to control checking of error status   *
      *                 and sending of messages/writing to the        *
      *                 database                                      *
      *                                                               *
      *****************************************************************
     C     SRCheckWrite  BEGSR

      **  If no errors were found:
      **     - set up additional data
      **     - write a record to the Valid file
      **     - use std message handler to report customer status
      **  If any errors were found:
      **     - write a record to the Invalid file
      **     - call the message handler to pass the errors back
      **     - use std message handler to report trade status
      **  The index to the error arrays is checked for presence/absence
      **  of errors
     
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

     C                   EXSR      SRSetUpValid
     C                   WRITE     SDVACUDD0

     C                   EXSR      SRCallMsgHdl

     C                   ENDIF

     C                   IF        Idx > 0
     C                   EXSR      SRSetUpInVal

      ** Only write to Invalid files if repair in back office

     C                   IF        APRPRLOCN = 'B'
     C                   WRITE     SDIACUDD0
     C                   ENDIF

      ** If support system is active, write invalid transaction to
      ** log file via APLOGTRAN standard module.

     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)

     C**********         EVAL      TransDtl = TranInPrim + ExtData500                        CER034A
     C                   EVAL      TransDtl = TranInPrim + TranInDet2 +                      CER034A
     C                                        TranInDet3 + ExtData500                        CER034A
     C                   EVAL      APTGTTYPE = 'SDACUD'
     C                   EVAL      PCustNum = ACCUST

     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TransDtl
     C                   PARM                    Timestamp
     C                   PARM                    PCustNum
     C                   PARM      *BLANKS       PACustNo

     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      DBKEY = PCustNum
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
      *                                                               *
      * SRResetCycle - Reset error information that is gradually      *
      *                updated during each run of this program        *
      *                                                               *
      *****************************************************************
     C     SRResetCycle  BEGSR

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

     C                   CLEAR                   CurCuPrim
     C                   CLEAR                   CurCustDet2                                 CER034A
     C                   CLEAR                   CurCustDet3                                 CER034A

     C                   MOVE      *ALL'Y'       OKCuPrim
     C                   MOVE      *ALL'Y'       OKCustDet2                                  CER034A
     C                   MOVE      *ALL'Y'       OKCustDet3                                  CER034A

     C                   CLEAR                   ValidAcud

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetUpInVal - Set up Invalid File Records                    *
      *                                                               *
      *****************************************************************
     C     SRSetUpInVal  BEGSR

      ** Include Header fields that need to be o/p to the Invalid files

     C                   EVAL      DDFRNT = APFOTRANID
     C                   EVAL      DDREPA = APRPRLOCN
     C                   EVAL      DDTMST = TimeStamp

     C                   EVAL      TranStatus = 'F'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetUpValid - Set up Valid File Record                       *
      *                                                               *
      *****************************************************************
     C     SRSetUpValid  BEGSR

      ** For Deletes put the complete (pre-existing) Additional Customer
      ** into the Valid file record.

     C**********         IF           DDACTN = 'D'                                          BUG23518
     C                   IF           DDACTN = 'D' OR DDACTN = 'C' OR                       BUG23518
     C                                DDACTN = 'R'                                          BUG23518
     C                   EVAL      ValidAcud = AcusFilFmt
     C                   ENDIF

      ** Set Valid file field(s) that are needed for all Action Codes

     C                   EVAL      V_ACTYLC = DDACTN
     C                   EVAL      V_ACCUST = DDCUST

      ** Include Header fields that need to be o/p to the Valid file

     C                   EVAL      V_ACFRNT = APFOTRANID
     C                   EVAL      V_ACREPA = APRPRLOCN
     C                   EVAL      V_ACTMST = TimeStamp

     C                   EVAL      TranStatus = 'S'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCallMsgHdl - Call the Message Handling module               *
      *                                                               *
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
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    APRPRLOCN
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
     C                   PARM                    APFOTRANID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (6A, from caller)
     C                   PARM                    DDCUST
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
      * SRDtaSubs - Data Substitution                                 *
      *                                                               *
      *****************************************************************
     C     SRDtaSubs     BEGSR

      ** Convert file fields to screen format

     C                   RESET                   ReturnCode
     C                   CALLB     'SDACUDCVT'

      ** Return Code
     C                   PARM                    ReturnCode
      ** Input parameters
      ** Additional Customer - file formats
     C                   PARM                    AcusFilFmt

      ** Output parameters
      ** Additional Customer Details - screen formats
     C                   PARM                    CurCuPrim
     C                   PARM                    CurCustDet2                                 CER034A
     C                   PARM                    CurCustDet3                                 CER034A

      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.

     C                   IF        RepPrim = 'Y'

     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      ** Return Code
     C                   PARM                    ReturnCode

      ** Substitution character
     C                   PARM                    GHSUBS

      ** Incoming Data
     C                   PARM      TranInPrim    IncData

      ** Current Data
     C                   PARM      CurCuPrim     CurData

     C                   EVAL      TranInPrim = IncData

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Common header information (DS) from source system
     C                   PARM                    HeadIn

      ** Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    PTrans5002                                  CER034A
     C                   PARM                    PTrans5003                                  CER034A
     C                   PARM                    ExtData500

      ** Ultimate calling Program/Module/Procedure
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
      **  (database error handling done in access program)

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDAPI         PARM      SDAPI         DSFDY

      ** Check for Switchable Feature for CGL032

     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CGL032'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        (PRtCd <> *Blanks) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CGL032'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRtCd = *Blanks
     C                   EVAL      CGL032 = 'Y'
     C                   ELSE
     C                   EVAL      CGL032 = 'N'
     C                   ENDIF

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
      *                                                                                      CER034A
      ** Check if CER034 is enabled                                                          CER034A
      *                                                                                      CER034A
     C                   CALLB     'AOSARDR0'                                                CER034A
     C                   PARM      *BLANKS       PRtcd                                       CER034A
     C                   PARM      '*VERIFY'     POptn                                       CER034A
     C                   PARM      'CER034'      PSard                                       CER034A
     C     SCSARD        PARM      SCSARD        DSFDY                                       CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd = *BLANKS                                           CER034A
      *                                                                                      CER034A
     C                   EVAL      CER034 = 'Y'                                              CER034A
     C                   ELSE                                                                CER034A
      *                                                                                      CER034A
     C                   EVAL      CER034 = 'N'                                              CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd <> '*NRF   '                                        CER034A
      *                                                                                      CER034A
     C     *LOCK         IN        LDA                                                       CER034A
     C                   EVAL      DBFILE = 'SCSARDPD'                                       CER034A
     C                   EVAL      DBKEY = 'CER034'                                          CER034A
     C                   EVAL      DBASE = 902                                               CER034A
     C                   OUT       LDA                                                       CER034A
     C                   EXSR      *PSSR                                                     CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Check if CER038 is installed                                                        CER034A
      *                                                                                      CER034A
     C                   CALLB     'AOSARDR0'                                                CER034A
     C                   PARM      *BLANKS       PRtcd                                       CER034A
     C                   PARM      '*VERIFY '    POptn                                       CER034A
     C                   PARM      'CER038'      PSarD                                       CER034A
     C     SCSARD        PARM      SCSARD        DSFDY                                       CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd = *BLANKS                                           CER034A
      *                                                                                      CER034A
     C                   EVAL      CER038 = 'Y'                                              CER034A
     C                   ELSE                                                                CER034A
      *                                                                                      CER034A
     C                   EVAL      CER038 = 'N'                                              CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd <> '*NRF   '                                        CER034A
      *                                                                                      CER034A
     C     *LOCK         IN        LDA                                                       CER034A
     C                   EVAL      DBFILE = 'SCSARDPD'                                       CER034A
     C                   EVAL      DBKEY = 'CER038'                                          CER034A
     C                   EVAL      DBASE = 902                                               CER034A
     C                   OUT       LDA                                                       CER034A
     C                   EXSR      *PSSR                                                     CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Check if CER041 is installed                                                        CER034A
      *                                                                                      CER034A
     C                   CALLB     'AOSARDR0'                                                CER034A
     C                   PARM      *BLANKS       PRtcd                                       CER034A
     C                   PARM      '*VERIFY '    POptn                                       CER034A
     C                   PARM      'CER041'      PSarD                                       CER034A
     C     SCSARD        PARM      SCSARD        DSFDY                                       CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd = *BLANKS                                           CER034A
      *                                                                                      CER034A
     C                   EVAL      CER041 = 'Y'                                              CER034A
     C                   ELSE                                                                CER034A
      *                                                                                      CER034A
     C                   EVAL      CER041 = 'N'                                              CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd <> '*NRF   '                                        CER034A
      *                                                                                      CER034A
     C     *LOCK         IN        LDA                                                       CER034A
     C                   EVAL      DBFILE = 'SCSARDPD'                                       CER034A
     C                   EVAL      DBKEY = 'CER041'                                          CER034A
     C                   EVAL      DBASE = 902                                               CER034A
     C                   OUT       LDA                                                       CER034A
     C                   EXSR      *PSSR                                                     CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Check if CER047 is installed                                                        CER034A
      *                                                                                      CER034A
     C                   CALLB     'AOSARDR0'                                                CER034A
     C                   PARM      *BLANKS       PRtcd                                       CER034A
     C                   PARM      '*VERIFY '    POptn                                       CER034A
     C                   PARM      'CER047'      PSarD                                       CER034A
     C     SCSARD        PARM      SCSARD        DSFDY                                       CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd = *Blanks                                           CER034A
      *                                                                                      CER034A
     C                   EVAL      CER047 = 'Y'                                              CER034A
     C                   ELSE                                                                CER034A
      *                                                                                      CER034A
     C                   EVAL      CER047 = 'N'                                              CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd <> '*NRF   '                                        CER034A
      *                                                                                      CER034A
     C     *LOCK         IN        LDA                                                       CER034A
     C                   EVAL      DBFILE = 'SCSARDPD'                                       CER034A
     C                   EVAL      DBKEY = 'CER047'                                          CER034A
     C                   EVAL      DBASE = 902                                               CER034A
     C                   OUT       LDA                                                       CER034A
     C                   EXSR      *PSSR                                                     CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
      ** Check if CER048 is installed                                                        CER034A
      *                                                                                      CER034A
     C                   CALLB     'AOSARDR0'                                                CER034A
     C                   PARM      *BLANKS       PRtcd                                       CER034A
     C                   PARM      '*VERIFY '    POptn                                       CER034A
     C                   PARM      'CER048'      PSarD                                       CER034A
     C     SCSARD        PARM      SCSARD        DSFDY                                       CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd = *BLANKS                                           CER034A
      *                                                                                      CER034A
     C                   EVAL      CER048 = 'Y'                                              CER034A
     C                   ELSE                                                                CER034A
      *                                                                                      CER034A
     C                   EVAL      CER048 = 'N'                                              CER034A
      *                                                                                      CER034A
     C                   IF        PRtcd <> '*NRF   '                                        CER034A
      *                                                                                      CER034A
     C     *LOCK         IN        LDA                                                       CER034A
     C                   EVAL      DBFILE = 'SCSARDPD'                                       CER034A
     C                   EVAL      DBKEY = 'CER048'                                          CER034A
     C                   EVAL      DBASE = 902                                               CER034A
     C                   OUT       LDA                                                       CER034A
     C                   EXSR      *PSSR                                                     CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                       CER045
      ** Check if CER045 is enabled                                                           CER045
      *                                                                                       CER045
     C                   CALL      'AOSARDR0'                                                 CER045
     C                   PARM      *BLANKS       PRtcd                                        CER045
     C                   PARM      '*VERIFY'     POptn                                        CER045
     C                   PARM      'CER045'      PSard                                        CER045
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER045
      *                                                                                       CER045
     C                   EVAL      CER045 = 'N'                                               CER045
      *                                                                                       CER045
     C                   IF        PRtcd = *BLANKS                                            CER045
      *                                                                                       CER045
     C                   EVAL      CER045 = 'Y'                                               CER045
     C                   ELSE                                                                 CER045
      *                                                                                       CER045
      ** Handle Datebase Error.                                                               CER045
      *                                                                                       CER045
     C                   IF        PRtcd <> '*NRF   '                                         CER045
     C     *LOCK         IN        LDA                                                        CER045
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER045
     C                   EVAL      DBKEY = 'CER045'                                           CER045
     C                   EVAL      DBASE = 103                                                CER045
     C                   OUT       LDA                                                        CER045
     C                   EXSR      *PSSR                                                      CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER045
     C                   ENDIF                                                                CER045
      *                                                                                      CER034A
      ** Check if CER054 is installed                                                       BUG24714
      *                                                                                     BUG24714
     C                   CALLB     'AOSARDR0'                                               BUG24714
     C                   PARM      *BLANKS       PRtcd                                      BUG24714
     C                   PARM      '*VERIFY '    POptn                                      BUG24714
     C                   PARM      'CER054'      PSarD                                      BUG24714
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG24714
      *                                                                                     BUG24714
     C                   IF        PRtcd = *BLANKS                                          BUG24714
      *                                                                                     BUG24714
     C                   EVAL      CER054 = 'Y'                                             BUG24714
     C                   ELSE                                                               BUG24714
      *                                                                                     BUG24714
     C                   EVAL      CER054 = 'N'                                             BUG24714
      *                                                                                     BUG24714
     C                   IF        PRtcd <> '*NRF   '                                       BUG24714
      *                                                                                     BUG24714
     C     *LOCK         IN        LDA                                                      BUG24714
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG24714
     C                   EVAL      DBKEY = 'CER054'                                         BUG24714
     C                   EVAL      DBASE = 902                                              BUG24714
     C                   OUT       LDA                                                      BUG24714
     C                   EXSR      *PSSR                                                    BUG24714
      *                                                                                     BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
      ** Set Validate Flags                                                                  CER034A
      *                                                                                      CER034A
     C                   IF        CER047 = 'Y' OR CER048 = 'Y'                              CER034A
      *                                                                                      CER034A
     C                   EVAL      WValScrn1 = 'Y'                                           CER034A
     C                   ELSE                                                                CER034A
     C                   EVAL      WValScrn1 = 'N'                                           CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A
      *                                                                                      CER034A
     C**********         IF        CER034 = 'Y' OR                                    CER034A CER045
     C**********                   CER038 = 'Y' OR                                    CER034A CER045
     C**********                   CER041 = 'Y'                                       CER034A CER045
     C                   IF        CER034 = 'Y' OR                                            CER045
     C                             CER038 = 'Y' OR                                            CER045
     C                             CER041 = 'Y' OR                                            CER045
     C                             CER045 = 'Y'                                               CER045
      *                                                                                      CER034A
     C                   EVAL      WValScrn2 = 'Y'                                           CER034A
     C                   ELSE                                                                CER034A
     C                   EVAL      WValScrn2 = 'N'                                           CER034A
      *                                                                                      CER034A
     C                   ENDIF                                                               CER034A

      ** Set up the name of the server/database updater data queue.

     C                   EVAL      DtaQName = 'APACUDDTQ'

     C                   ENDSR
      *****************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2004
