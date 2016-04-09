     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Controller')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACMCTL - Midas SD Joint Account Member Details Interface  *
      *              Controller                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. AR1067663          Date 08Feb13               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23732           Date 23Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244537             Date 17Aug05               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 30Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1067663 - Joint account member API failure                 *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23732 - Joint Account Threshold (Recompile)               *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  244537 - To avoid overriding front office identifier         *
      *           (Recompile)                                         *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDVJACMPD UF A E             DISK    INFSR(*PSSR) PREFIX(V_:2)
     F                                     COMMIT
      ** Midas SD Valid Joint A/c Members
 
     FSDIJACMPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas SD Invalid Joint A/c Members
 
     FSDVJACML1 IF   E           K DISK    RENAME(SDVJACMD0:SDVJACMD1)
     F                                     INFSR(*PSSR)
      ** Midas SD Valid JAcM by Joint A/c No./Customer No./Timestamp
 
     FSDVJACML2 IF   E           K DISK    RENAME(SDVJACMD0:SDVJACMD2)
     F                                     INFSR(*PSSR)
      ** Midas SD Valid JAcM by Joint A/c No./Non-a/c Holder/Timestamp
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      ** Midas ZA Sequence Numbers for Input Fields
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Program, Module, & Procedure Names for Parameters
     D/COPY ZACPYSRC,PROCPARMS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation Error Array Declarations
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Array Declares for *CTL Modules
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Declares for Data Queue Checking
     D/COPY ZACPYSRC,DTAQCHKDCL
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** String for Operator Error Messages
     D ProcErr         C                   CONST('Error in module')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** 24x7 Status Data Area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Customer Number Array
     D PACUST          S              6A   DIM(100)
 
      ** Non-a/c Holder Array
     D PANAHO          S             10A   DIM(100)
 
      ** Investment Proportion Array
     D PAINVP          S             10A   DIM(100)
 
      ** Prime A/c Holder Array                                                               232543
     D PAPAHO          S              1A   DIM(100)                                           232543
                                                                                              232543
      ** Prime A/c Holder for Tax Array
     D PAPAHT          S              1A   DIM(100)
 
      ** Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming Transaction (Joint A/c Member)
     D TranInJAcM    E DS                  EXTNAME(SDJACMPD)
 
      ** Valid Joint A/c Member Details Layout
     D ValidJAcM     E DS                  EXTNAME(SDVJACMPD)
     D                                     PREFIX(V_:2)
 
      ** (Current) Joint A/c Member Details - File Format
     D JAcMFilFmt    E DS                  EXTNAME(SDJACCPD)
 
      ** (Current) Joint A/c Member Details - Screen Format
     D CurJAcMDet    E DS                  EXTNAME(SDJACMPD)
     D                                     PREFIX(@)
 
      ** OK - Joint A/c Member Details
     D OKJAcMDets    E DS                  EXTNAME(SDEJACMPD)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** API ICD Details Data Structure
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** Switchable Feature Details Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D Trans500        S            500A
     D ExtData500      S            500A
 
      ** API Parameters
     D PRetCode        S             10A
     D PCvtMode        S              6A
     D PValMode        S              6A
     D POprMode        S              6A
     D PResMode        S              1A
     D PDACTD          S              1A
     D OKACTN          S              1A
     D IncData         S           2000A
     D CurData         S           2000A
     D PRetCodeOut     S             10A
     D TRANSDTL        S           5800A
     D PTimestamp      S             26A
     D PKey            S             18A
     D PAKey           S             18A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARD           S              6A
 
      ** Standard Utility Parameters
     D TimeStamp       S               Z
     D TranStatus      S              1A
     D ModuleID        S              2A
     D ClrPgmMsgQ      S              1A   INZ('Y')
     D Object          S             10A   INZ('SDJACMUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
     D MQReturn        S             10A
     D MQErrlong       S            132A
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Switchable Features
     D CSC011          S              1A   INZ('N')
 
      ** Key Fields
     D KJANo           S                   LIKE(JAJANO)
     D KCust           S                   LIKE(JACUST)
     D KNAHo           S                   LIKE(JANAHO)
 
      ** Working Variables
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D Ix              S              3P 0
     D Iy              S              3P 0
     D RepJAcM         S              1A   INZ('N')
     D SubForTRNN      S              2P 0
     D MQError         S             28A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Incoming transaction is broken into 500A fields, so that a common CL
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structure.
 
     C                   MOVEL     Trans500      TranInJAcM
 
      ** Generate a timestamp for this Joint A/c Member.
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset gradually updated variables.
 
     C                   EXSR      SRResCyc
 
      ** Check if valid Joint A/c Member details exist.
 
     C                   EXSR      SRChkVJAcM
 
      ** If valid Joint A/c Member details do exist (even after delay), fail this input.
 
     C                   IF        Idx = *ZERO
 
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid Transaction details file.
 
     C                   EXSR      SRResCyc
 
      ** Validate the Action Code.
 
     C                   EXSR      SRVActn
 
      ** If error occurs in the validation of Action Code, fail this input.
 
     C                   IF        Idx = *ZERO
 
     C                   SELECT
 
     C                   WHEN      DDACTN = 'I'
     C                   EXSR      SRValDet
 
     C                   WHEN      DDACTN = 'A' OR
     C                             DDACTN = 'D'
 
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
 
     C                   IF        DDACTN = 'A' AND
     C                             GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      TranInJAcM
 
     C                   IF        %FOUND
     C                   EVAL      RepJAcM = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, execute the data
      ** substitution subroutine.
 
     C                   IF        RepJAcM = 'Y'
     C                   EXSR      SRDtaSub
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRSetAmd
     C                   EXSR      SRValDet
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check for exception error from any program lower in the stack
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program
 
     C                   IN        APDUMP
 
     C                   IF        ARERRMOD <> *BLANK
 
     C                   EVAL      MQErrlong = *BLANKS
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError
     C                   MOVEL     MQError       MQErrlong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn
     C                   PARM                    MQErrlong
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANKS
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
 
      ** Process error check/database write.
 
     C                   EXSR      SRChkWrt
 
      ** If valid, send data queue entry to prompt DB update program.
 
     C                   IF        Idx = *ZERO
 
     C                   EVAL      ObjType = '*DTAARA'
 
      ** Check if update program active using Allocate Object API.
      ** No prompting necessary if program is running.
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANKS       Return
 
     C                   IF        Return = *BLANKS
 
      **---------------------------------------------------------------
      ** Data Queue Checking
     D/COPY ZACPYSRC,DTAQCHK
      **---------------------------------------------------------------
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkVJAcM - Checks if valid Joint A/c Member details exist. *
      *                                                               *
      *****************************************************************
     C     SRChkVJAcM    BEGSR
 
      ** Check for Joint A/c Member details on the Valid file.
 
     C                   EVAL      KJANo = DDJANO
 
     C                   SELECT
 
     C                   WHEN      DDCUST <> *BLANKS
     C                   EVAL      KCust = DDCUST
     C     KVJA1         CHAIN     SDVJACML1
 
     C                   WHEN      DDNAHO <> *BLANKS
     C                   EVAL      KNAHo = DDNAHO
     C     KVJA2         CHAIN     SDVJACML2
 
     C                   OTHER
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDJANO'
     C                   EVAL      MsgIDArr(Idx) = 'APM1000'
     C                   LEAVESR
     C                   ENDSL
 
     C                   IF        %FOUND
 
      ** Create a delay, then repeat check.
 
     C                   CALLB     'ZACDELAY'
 
     C     KJANo         CHAIN     SDVJACML1
 
     C                   IF        %FOUND
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDJANO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVActn - Validates the Action Code.                         *
      *                                                               *
      *****************************************************************
     C     SRVActn       BEGSR
 
      ** Check for the existence of the replacement character at the
      ** Joint A/c Number level.
 
     C                   IF        GHSUBS <> *BLANK
     C     GHSUBS        SCAN      DDJANO        SubForTRNN
     C                   ENDIF
 
     C                   IF        DDACTN = 'I'
     C                   EVAL      POprMode = '*FRONT'
     C                   ELSE
 
     C                   IF        DDJANO = *BLANKS OR
     C                             SubForTRNN <> 0
     C                   EVAL      POprMode = '*FRONT'
     C                   ELSE
     C                   EVAL      POprMode = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set Action Code Default flag.
 
     C                   IF        DDACTN = 'I' OR
     C                             DDACTN = 'A'
     C                   EVAL      PDACTD = 'Y'
     C                   ELSE
     C                   EVAL      PDACTD = 'N'
     C                   ENDIF
 
      ** Validate the Action Code.
 
     C                   CALLB     'SDJACMRTV'
      **                 *********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Operation Mode
     C                   PARM                    POprMode
 
      ** Response Mode
     C                   PARM                    PResMode
 
      ** Action Code
     C                   PARM                    DDACTN
 
      ** Front Office Transaction ID
     C                   PARM                    APFOTranID
 
      ** Joint A/c Number
     C                   PARM                    DDJANO
 
      ** Customer Number
     C                   PARM                    DDCUST
 
      ** Non-a/c Holder
     C                   PARM                    DDNAHO
 
      ** Action Code Default
     C                   PARM                    PDACTD
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** (Current) Joint A/c Member Details - File Format
     C                   PARM                    JAcMFilFmt
 
      ** OK - Action Code
     C                   PARM                    OKACTN
 
      ** OK - Customer Number
     C                   PARM                    OKCUST
 
      ** OK - Non-a/c Holder
     C                   PARM                    OKNAHO
 
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array Index (3P0) From/To Caller
     C                   PARM                    Idx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetAmd - Set up fields that are needed in the validation   *
      *             of amendments and changes.                        *
      *                                                               *
      *****************************************************************
     C     SRSetAmd      BEGSR
 
      ** For amends, put the complete (pre-existing) Joint A/c Member into the
      ** valid file record - fields in this will be updated during processing.
 
     C**********         MOVE      JAcMFilFmt    ValidJAcM                                 AR1067663
     C                   MOVEL     JAcMFilFmt    ValidJAcM                                 AR1067663
 
      ** Convert the Joint A/c Member detail to screen format.
 
     C                   CALLB     'SDJACMCVT'
      **                 *********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Convert Mode
     C                   PARM      '*SCRN '      PCvtMode
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Joint A/c Member Details - File Format
     C                   PARM                    ValidJAcM
 
      ** Joint A/c Member Details - Screen Format
     C                   PARM                    CurJAcMDet
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      *  SRValDet - Validates the Joint A/c Member details.            *
      *                                                                *
      ******************************************************************
     C     SRValDet      BEGSR
 
      ** Validate Joint A/c Member details.
 
     C                   EXSR      SRJAcMVal
 
     C                   IF        Idx <> *ZERO
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJAcMVal - Joint A/c Member Details Validate.               *
      *                                                               *
      *****************************************************************
     C     SRJAcMVal     BEGSR
 
     C                   CALLB     'SDJACMVAL'
      **                 *********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Response Mode
     C                   PARM                    PResMode
 
      ** Validate Mode
     C                   PARM      '*FIELD'      PValMode
 
      ** Joint A/c Member Details - Screen Format
     C                   PARM                    TranInJAcM
 
      ** Customer Number Array
     C                   PARM                    PACUST
 
      ** Non-a/c Holder Array
     C                   PARM                    PANAHO
 
      ** Investment Proportion Array
     C                   PARM                    PAINVP
 
      ** Prime A/c Holder Array                                                               232543
     C                   PARM                    PAPAHO                                       232543
                                                                                              232543
      ** Prime A/c Holder for Tax Array
     C                   PARM                    PAPAHT
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** OK - Action Code
     C                   PARM                    OKACTN
 
      ** OK - Joint A/c Member Details
     C                   PARM                    OKJAcMDets
 
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array Index (3P0) From/To Caller
     C                   PARM                    Idx
 
      ** Warning Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array Index (3P0) From/To Caller
     C                   PARM                    WIdx
 
      ** Valid Joint A/c Member Details Layout From/To Caller
     C                   PARM                    ValidJAcM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkWrt - Controls checking of error status and sending of  *
      *             messages/writing to the database.                 *
      *                                                               *
      *****************************************************************
     C     SRChkWrt      BEGSR
 
      **  If no errors were found:
      **     - set up additional data
      **     - write a record to the Valid file
      **     - use std message handler to report customer status
      **  If any errors were found:
      **     - write a record to the Invalid file
      **     - call the message handler to pass the errors back
      **     - use std message handler to report trade status
      **  The index to the error arrays is checked for presence/absence of
      **  errors
     
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
 
     C                   EXSR      SRSetVld
     C                   WRITE     SDVJACMD0
 
     C                   EXSR      SRMsgHdl
 
     C                   ENDIF
 
     C                   IF        Idx > *ZERO
 
     C                   EXSR      SRSetInv
 
      ** Only write to invalid files if repair is in back office.
 
     C                   IF        APRprLocn = 'B'
     C                   WRITE     SDIJACMD0
     C                   ENDIF
 
      ** Run 24x7 processing if necessary.
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SOVR = 'S'
     C                   EXSR      SR24x7
     C                   ENDIF
 
     C                   EXSR      SRMsgHdl
 
     C                   ENDIF
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResCyc - Reset error information that is gradually         *
      *             updated during each run of this program.          *
      *                                                               *
      *****************************************************************
     C     SRResCyc      BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurJAcMDet
     C                   CLEAR                   ValidJAcM
 
     C                   EVAL      OKACTN = 'Y'
     C                   MOVE      *ALL'Y'       OKJAcMDets
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetInv - Set up additional fields that are needed on the   *
      *             valid file record.                                *
      *                                                               *
      *****************************************************************
     C     SRSetInv      BEGSR
 
      ** Include header fields that need to be o/p to the Invalid files.
 
     C                   EVAL      DDFRNT = APFOTranID
     C                   EVAL      DDREPA = APRprLocn
     C                   MOVE      TimeStamp     DDTMST
 
     C                   EVAL      TranStatus = 'F'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetVld - Set up additional fields that are needed on the   *
      *             valid file record.                                *
      *                                                               *
      *****************************************************************
     C     SRSetVld      BEGSR
 
      ** Set valid file fields that are needed for all Action Codes.
 
     C                   EVAL      V_CHTP = DDACTN
     C                   EVAL      V_JANO = DDJANO
     C                   EVAL      V_CUST = DDCUST
     C                   EVAL      V_NAHO = DDNAHO
     C                   EVAL      V_INVP = DDINVP
     C                   EVAL      V_PAHT = DDPAHT
     C                   EVAL      V_PAHO = DDPAHO
 
      ** Include header fields that need to be o/p to the valid file.
 
     C                   EVAL      V_FRNT = APFOTranID
     C                   EVAL      V_REPA = APRprLocn
 
     C                   EVAL      TranStatus = 'S'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMsgHdl - Calls the message handling module.                *
      *                                                               *
      *****************************************************************
     C     SRMsgHdl      BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      ** with errors.
 
     C                   EVAL      Ix = 1
 
     C                   DO        ArrayMax
 
     C                   IF        FldNameArr(Ix) <> *blanks
 
     C                   EVAL      Iy = 1
 
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   EVAL      Ix = Ix + 1
 
     C                   ENDDO
 
     C                   CALLB     'ZAMSGHNDLE'
      **                 **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Deal Repair Location
     C                   PARM                    APRprLocn
 
      ** Confirm Validity to Front Office
     C                   PARM                    APCnfValFO
 
      ** List of Messages (Array of <ArrayMax>x7A Message IDs From Caller)
     C                   PARM                    MsgIDArr
 
      ** List of Field Numbers (Array of <ArrayMax>x2 Unsigned Integers - From Caller)
     C                   PARM                    FldNoArr
 
      ** List of Field Names (Array of <ArrayMax>x10A Names - From Caller)
     C                   PARM                    FldNameArr
 
      ** List of Message Data Entries (Array of <ArrayMax>x45 - From Caller)
     C                   PARM                    MsgDtaArr
 
      ** Front Office Transaction ID
     C                   PARM                    APFOTranID
 
      ** Midas Module ID
     C                   Parm                    ModuleID
 
      ** Midas Joint A/c Number
     C                   PARM                    DDJANO
 
      ** Message File (10A, from caller)
     C                   PARM                    #MsgFile
 
      ** Action Code of Transaction
     C                   PARM                    DDACTN
 
      ** Status of Transaction (F=Failure, S=Success)
     C                   PARM                    TranStatus
 
      ** Response Mode
     C                   PARM                    PResMode
 
      ** Screen-handling Program
     C                   PARM                    #ProcPgm
 
      ** Screen-handling Module
     C                   PARM                    #ProcMod
 
      ** Screen-handling Procedure
     C                   PARM                    #ProcName
 
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
 
      ** The Transaction's Timestamp
     C                   PARM                    TimeStamp
 
      ** Additional Message Files to Check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
 
      ** Whether or Not to Clear the Program Message Queue
     C                   PARM                    ClrPgmMsgQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDtaSub - Handles data substitution.                        *
      *                                                               *
      *****************************************************************
     C     SRDtaSub      BEGSR
 
      ** Convert file fields to screen format.
 
     C                   CALLB     'SDJACMCVT'
      **                 *********************
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Convert Mode
     C                   PARM      '*SCRN '      PCvtMode
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Joint A/c Member Details - File Format
     C                   PARM                    JAcMFilFmt
 
      ** Joint A/c Member Details - Screen Format
     C                   PARM                    CurJAcMDet
 
      ** Substitute the data for the various parts of the transaction.
 
     C                   IF        RepJAcM = 'Y'
 
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
 
     C                   CALLB     'APDTASUBS'
      **                 *********************
 
      ** Return Code
     C                   PARM      *BLANKS       PRetCode
 
      ** Substitution Character
     C                   PARM                    GHSUBS
 
      ** Incoming Data
     C                   PARM      TranInJAcM    IncData
 
      ** Current Data
     C                   PARM      CurJAcMDet    CurData
 
     C                   MOVEL     IncDATA       TranInJAcM
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR24x7 - Runs 24x7 processing.                               *
      *                                                               *
      *****************************************************************
     C     SR24x7        BEGSR
 
     C                   EVAL      TRANSDTL = TranInJAcM
 
     C                   EVAL      APTGTTYPE = 'SDJACM'
     C                   EVAL      APFOTRANID = DDFRNT
     C                   EVAL      APRPRLOCN = DDREPA
     C                   EVAL      APUSERID = PSUser
     C                   EVAL      APMIDUSR = PSUser
 
     C                   MOVE      DDTMST        PTimestamp
 
     C                   IF        DDCUST <> *BLANKS
     C                   EVAL      PKey = DDJANO + DDCUST
     C                   ELSE
     C                   EVAL      PKey = DDJANO + DDNAHO
     C                   ENDIF
 
      ** Log this Joint A/c Member.
 
     C                   CALLB     'APLOGTRAN'
      **                 *********************
 
     C                   PARM      *BLANKS       PRetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    PTimestamp
     C                   PARM                    PKey
     C                   PARM      *BLANKS       PAKey
 
     C                   IF        PRetCodeOut <> *BLANKS
     C                   EVAL      PRetCode = '*APLOG    '
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Common Header Information from Source System
     C                   PARM                    HeadIn
 
      ** Joint A/c Member (Transaction) Information
     C                   PARM                    Trans500
     C                   PARM                    ExtData500
 
      ** Ultimate Calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Key Lists
 
     C     KVJA1         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KCust
 
     C     KVJA2         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KNAHo
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages.
 
     C                   EVAL      #MsgFile     = 'SDUSRMSG'
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      ** Set up the Module ID, used to make the Joint A/c Number unique.
 
     C                   EVAL      ModuleID = 'SD'
 
      ** Get bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get API ICD details.
 
     C                   CALL      'AOAPIR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDAPI         PARM      SDAPI         DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDAPIPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC011 is enabled.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = PSARD
     C                   EVAL      DBase = 103
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up the name of the server/database updater data queue.
 
     C                   EVAL      DtaQName = 'APJACMDTQ'
 
      **---------------------------------------------------------------
      ** Program, Module, & Procedure Names for DB Error Processing
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   IN        SC24X7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** ILE RPG Program Status Subroutine
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
