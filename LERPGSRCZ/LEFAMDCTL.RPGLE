     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility amendment interface controller')     *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  LEFAMDCTL - Facility Amendments Interface Controller         *
      *                                                               *
      *  Function: This Program Validates Facility Amendments for     *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. 259946             Date 30Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 256704             Date 10Oct08               *
      *                 256647             Date 03Oct08               *
      *                 247549             Date 03May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234239             Date 06Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10384           Date 06Feb06               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC022             Date 24Feb04               *
      *                 CAP084             Date 20Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP071  *CREATE    Date 19Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00253                                 *
      *             WNCPYSRC,LEH00254                                 *
      *  259946 - Override FCLTY to SHARE(*NO). Return key values on  *
      *           reply to API. Add array record to ##OX1, which is   *
      *           OVRDBF FCLTY.                                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  256704 - Corrected input validation for facility amendments. *
      *  256647 - Amend/Delete. Check index error before executing    *
      *           DtaSubs OR SetupAmd. if FAMDFilFmt is not properly  *
      *           populated before passing, this will cause error.    *
      *  247549 - Review delay processing.                            *
      *  234239 - Pass correct parameter to VAL module                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10384 - Display Facility UTN and Facility Event UTN       *
      *             correctly.                                        *
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it                                          *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CAP084 - Change S#CUM to be 10 long instead of 6             *
      *  CAP071 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Transaction file
     FLEVFAMDPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Invalid Transactions
     FLEIFAMDPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FLEVFAMDL0 IF   E           K DISK    RENAME(LEVFAMDD0:LEVFAMDCHK)
     F                                     INFSR(*PSSR)
     FLEVFAMDL1 IF   E           K DISK    RENAME(LEVFAMDD0:LEVFAMDCK1)
     F                                     INFSR(*PSSR)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SKFFFFC001
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInFAMD    E DS                  EXTNAME(LEFAMDPD)
 
      * Valid Customer Securities Details layout
     D ValidFAMD     E DS                  EXTNAME(LEVFAMDPD)
     D                                     PREFIX(V_)
 
 
      * (Current) Transaction record in file Format
     D FAMDFilFmt    E DS                  EXTNAME(LEFCAMPD)
 
 
      * (Current) Transaction in Screen Format - Main Details
     D CurTrFAMD     E DS                  EXTNAME(LEFAMDPD)
     D                                     PREFIX(@)
 
 
      * Error indicators
     D OKTrFAMD      E DS                  EXTNAME(LEEFAMDPD)
 
 
      *                                                                                       CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
      *                                                                                       CSC022
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
                                                                                              CAP086
     D  @RUNA          DS            50                                                       CAP086
      * Facility run dates                                                                    CAP086
                                                                                              CAP086
     D  @OAMA          DS           130                                                       CAP086
      * Facility drawn amounts                                                                CAP086
                                                                                              CAP086
      ** +--------------------------------------+                                             CSC022
      ** ¦ Use of Indicator                     ¦                                             CSC022
      ** ¦ ================                     ¦                                             CSC022
      ** |                                      |                                             CSC022
      ** | 17      Used by LOOKUP               |                                             CSC022
      ** +--------------------------------------+                                             CSC022
 
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
 
      ** Indices for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('LEFAMDUPC')
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
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
      ** Override Database Table
     D*##OX1****       S              1    DIM(50) CTDATA PERRCD(50)                          259946
     D##OX1            S             50    DIM(2) CTDATA PERRCD(1)                            259946
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepFAMD         S              1A   INZ('N')
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEFAMDC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,LEFAMDC003
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInFAMD
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,LEFAMDC004
 
      *  Check if valid Facility Amendment details exists
 
     C                   EXSR      ChkValFAMD
      *
      *  If valid FAMD details does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Check if valid Transaction exists for Midas Transaction Number
 
     C                   EXSR      ChkValMiAm
      *
      *  If valid Transaction does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Transaction details file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,LEFAMDC005
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,LEFAMDC006
 
      *  If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         S#ACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,LEFAMDC007
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,LEFAMDC008
 
     C                   WHEN         S#ACTN = 'A'
     C                             OR S#ACTN = 'D'
      *  Processing for Amends or Changes
      /COPY WNCPYSRC,LEFAMDC009
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   IF        S#ACTN = 'A' AND GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      TranInFAMD                             99
     C                   IF        *in99
     C                   EVAL      RepFAMD = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   IF        RepFAMD = 'Y'
     C                             AND Ix = 0                                                 256647
     C                   EXSR      DtaSubs
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "if S#ACTN = 'A' AND GHSUBS <> *blank")
 
     C                   IF        Ix = 0                                                     256647
     C                   EXSR      SetupAmd
     C                   ENDIF                                                                256647
      /COPY WNCPYSRC,LEFAMDC010
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,LEFAMDC011
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,LEFAMDC012
 
     C                   IF        ARERRMOD <> *BLANK
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
      /COPY WNCPYSRC,LEFAMDC013
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,LEFAMDC014
 
      *  If valid, send data queue entry to prompt DB update program
     C                   IF        Idx = 0
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
 
     C                   IF        RETURN = *BLANK
 
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
      /COPY WNCPYSRC,LEFAMDC015
 
     C                   RETURN
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * ChkValFAMD - Routine to check if valid Transaction details exist *
      *                                                                  *
      ********************************************************************
     C     ChkValFAMD    BEGSR
 
     C     APFOTranID    CHAIN     LEVFAMDL0                          99
 
      * If record found...
     C                   IF        *IN99 = *OFF
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     APFOTranID    CHAIN     LEVFAMDL0                          99
     C                   END                                                                  247549
 
      * Error if still present
     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'APFOTranID'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValMiAm - Routine to check if valid Transaction Facility   *
      * Amendment exists for Midas Transaction number                 *
      *                                                               *
      *****************************************************************
 
     C     ChkValMiAm    BEGSR
 
      * Check for Facility Amendment on Valid file
 
     C                   MOVE      RECI          K#RECI            1
     C                   MOVE      BRCA          K#BRCA            3
     C**********         MOVE      CNUM          K#CNUM            6 0                        CSD027
     C                   MOVE      CNUM          K#CNUM            6                          CSD027
     C                   MOVE      FACT          K#FACT            3 0
     C                   MOVE      FCNO          K#FCNO            2 0
 
      * Check for Transaction on valid file
 
     C     KMFAMD        CHAIN     LEVFAMDL1                          99
 
      * If record found...
     C                   IF        *IN99 = *OFF
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     KMFAMD        CHAIN     LEVFAMDL1                          99
     C                   END                                                                  247549
 
      * Error if still present
     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'FCNO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Transaction number supplied                                *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Set retrieve mode to 'B' (Access using Front Office ID)
      *  if insert
      *  if not insert and Midas transaction ID is not present
      * Otherwise
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
      *  We assume no substitution has been defined for the transaction ID
      *
      ** Check for the existence of the replacement character at the
      ** Transaction Id level.
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      TranInFAMD    SubForTRNN        2 0
     C                   ENDIF
     C                   IF        S#ACTN = 'I'
     C                   MOVEL     'B'           P#MODE
     C                   ELSE
     C                   IF        TranInFAMD = *BLANK
     C                             OR SubForTRNN <> 0
     C                   MOVEL     'B'           P#MODE
     C                   ELSE
     C                   MOVEL     ' '           P#MODE
     C                   ENDIF
     C                   ENDIF
 
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the mm database is retrieved
      * as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'LEFAMDRTV'
      *
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
     C                   PARM                    P#MODE            1
      * Response Code
     C                   PARM      ' '           RESPMODE          1
      *
      * Action Code, Facility Customer & Type
 
     C                   PARM                    S#ACTN
     C                   PARM                    S#CSSN
     C                   PARM                    S#FACT
      *
      * Facility Amendment Number, Type, Value Date & Seq no.
 
     C                   PARM                    S#FCNO
     C                   PARM                    S#FATP
     C                   PARM                    S#VLDT
     C                   PARM                    S#SQNO
      *
      * Outputs
      *
      * (Current) Transaction in file format
     C                   PARM                    FAMDFilFmt
      *
      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FATPok          1
     C                   PARM                    S#VLDTok          1
     C                   PARM                    S#SQNOok          1
 
      * Customer number
     C**********         PARM                    S#CNUM            6                          CAP084
     C                   PARM                    S#CNUM           10                          CAP084
 
      * Value date of amendment
     C                   PARM                    W#VLDT            5 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
      * Facility tranche/credit agreement ind
      * Facility revolving credit indicator
      * Facility record ID
      * Facility date of expiry
      * Facility closure date
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C                   PARM                    FcrvRVCR          1
     C                   PARM                    FcRECI            1
     C                   PARM                    FcDTEX            5 0
     C                   PARM                    FcCDTE            5 0
     C/COPY WNCPYSRC,LEH00253
 
      * Facility run dates
      * Facility drawn amounts
     C**********         PARM                    @RUNA             5 0                        CAP086
     C**********         PARM                    @OAMA            13 0                        CAP086
     C                   PARM                    @RUNA                                        CAP086
     C                   PARM                    @OAMA                                        CAP086
                                                                                            BUG10384
      ** Facility UTN                                                                       BUG10384
     C                   PARM                    S#FUTN           15                        BUG10384
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C**********         PARM                    Ix                3 0                        256704
     C                   PARM                    Idx                                          256704
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
 
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
 
     C                   MOVE      FAMDFilFmt    ValidFAMD
 
      * For Amends, convert the Facility Amendment transaction to screen format
 
     C                   CALLB     'LEFAMDCVT'
      * Inputs
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Facility Amendment Transaction - file formats
     C                   PARM                    ValidFAMD
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * OUTPUTS
      *
      * Facility Amendment Transaction Details - screen formats
     C                   PARM                    CurTrFAMD
 
      * Customer details
     C**********         PARM                    S#CNUM            6                          CAP084
     C                   PARM                    S#CNUM           10                          CAP084
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Facility amendment type narrative
      * Record status
      * Value date in alpha format
     C                   PARM                    S#FATN           24
     C                   PARM                    S#STAT           10
     C                   PARM                    S#VLDA            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Facility Amendment Transaction details
 
     C                   EXSR      ValdTrFAMD
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
      * ValdTrFAMD - Validate Facility Amendment Transaction details  *
      *                                                               *
      *****************************************************************
     C     ValdTrFAMD    BEGSR
 
     C                   CALLB     'LEFAMDVAL'
 
      * Inputs
 
      * Return code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      ** Facility Amendment Transaction Details
     C                   PARM                    TranInFAMD
 
      * Value date of amendment
     C                   PARM                    W#VLDT            5 0
 
      * Generated by assignment
     C                   PARM                    A5GASS            1
      * Facility Amount
      * Facility Branch
      * Facility Branch details
      * Facility Currency
      * Facility Currency decimal places
     C**********         PARM                    W#FAMTSV         13 0                        234239
     C                   PARM                    W#FAMT                                       234239
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C                   PARM                    FcrvRVCR          1
     C                   PARM                    FcRECI            1
     C                   PARM                    FcDTEX            5 0
     C                   PARM                    FcCDTE            5 0
     C/COPY WNCPYSRC,LEH00254
 
      * Front Office Inputs (if mode = 'B')
     C                   PARM                    A5PCOB            3
     C                   PARM                    A5TNRF           15
 
      * Facility run dates
      * Facility drawn amount
     C                   PARM                    @RUNA
     C                   PARM                    @OAMA
 
      * Outputs
      *
      * Amendment amount
     C                   PARM                    W#AAMT           13 0
 
      ** Facility Amendment Transaction Details OK inds
     C                   PARM                    OKTrFAMD
 
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
     C                   PARM                    WIdx              3 0
 
      * Valid Facility Amendment Transaction (DS) from/to caller
     C                   PARM                    ValidFAMD
 
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
     C                   WRITE     LEVFAMDD0
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *
      * Only write to invalid files if repair in back office
     C                   IF        APRprLocn = 'B'
 
      *
      * Get next repair number if back office repair
 
     C                   CALL      'LEC0215'
     C                   PARM                    XREPN
 
     C                   WRITE     LEIFAMDD0
 
      ** Write all invalid records to the support log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      TRANSDTL = TranInFAMD
 
     C                   EVAL      APTGTTYPE  = 'LEFAMD'
     C                   EVAL      PDealNo = S#CSSN + S#FACT +
     C                                       S#FCNO + S#FATP
 
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
 
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
 
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
 
     C                   CLEAR                   CurTrFAMD
 
     C                   MOVE      *ALL'Y'       OKTrFAMD
 
     C                   CLEAR                   ValidFAMD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        invalid file record.                                   *
      *                                                               *
      *****************************************************************
 
     C     SETUPINVAL    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid file
     C                   EVAL      S#FRNT = APFOTranID
     C                   EVAL      S#AFRT = APFOAsocID
     C                   EVAL      S#REPA = APRprLocn
     C                   MOVE      TimeStamp     XTMST
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,LEFAMDC016
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
 
      * Include Header fields that need to be o/p to the Valid file
      * If there is no front office ID, use the PCREF created by LEFAMDVAL.
     C     APFOTranID    Ifeq      *Blank
     C                   MOVEL     V_AMPCRF      V_AMFRNT
     C                   Else
     C                   EVAL      V_AMFRNT = APFOTranID
     C                   EndIf
     C                   EVAL      V_AMAFRT = APFOAsocID
     C                   EVAL      V_AMREPA = APRprLocn
     C                   EVAL      V_AMSTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,LEFAMDC017
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
      *                                                                                       259946
     C                   EVAL      WTransID = *Blanks                                         259946
     C                   MOVEL     S#CSSN        S#CSSN6           6                          259946
     C                   MOVEL     V_AMSQNO      S#SQNO3           3                          259946
     C                   EVAL      WTransID = S#CSSN6 + S#FACT + S#FCNO +                     259946
     C                                        S#VLDT + S#SQNO3                                259946
 
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
     C                   PARM                    WTRANSID         20
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    S#ACTN
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
 
     C     DtaSubs       BEGSR
 
      ** Convert file fields to screen format
     C                   RESET                   ReturnCode
     C                   CALLB     'LEFAMDCVT'
      * Return Code
     C                   PARM                    RetCodeIn
      * Input parameters
      * Facility Amendment Transaction - file formats
     C                   PARM                    FAMDFilFmt
 
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * Output parameters
      * Facility Amendment transaction Details - screen formats
     C                   PARM                    CurTrFAMD
      * Customer details
     C**********         PARM                    S#CNUM            6                          CAP084
     C                   PARM                    S#CNUM           10                          CAP084
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Facility amendment type narrative
      * Record status
      * Value date in alpha format
     C                   PARM                    S#FATN           24
     C                   PARM                    S#STAT           10
     C                   PARM                    S#VLDA            7
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   IF        RepFAMD = 'Y'
 
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInFAMD    IncData        2000
      * Current Data
     C                   PARM      CurTrFAMD     CurData        2000
 
     C                   MOVEL     IncDATA       TranInFAMD
 
     C                   ENDIF
 
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
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'LERMSGF'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'LE'
 
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
      ** Access SAR details file to determine if MDF Switchable feature
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD006'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSD006            1
     C                   ELSE
     C                   MOVEL     'N'           CSD006
     C                   END
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APFAMDDTQ'
 
      * Override LEFAMDLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C**********         PARM                    ##OX1                                        259946
     C                   PARM                    ##OX1(1)                                     259946
     C                   PARM                    MESLEN
      *                                                                                       259946
      ** Override FCLTY                                                                       259946
      *                                                                                       259946
     C                   CALL      'QCMDEXC'                                                  259946
     C                   PARM                    ##OX1(2)                                     259946
     C                   PARM                    MESLEN                                       259946
 
      ** Check if CSC011 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ELSE
 
      ** Database error
 
     C                   IF        PRTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 900
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Key Lists
 
     C     KMFAMD        KLIST
     C                   KFLD                    K#RECI
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEFAMDC018
 
      * Determine if CSC022 is switched on                                                    CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
     C                   IF        @RTCD = *BLANK                                             CSC022
     C                   EVAL      CSC022 ='Y'                                                CSC022
     C                   EVAL      WCMT01 ='N'                                                CSC022
      * SCCMTJOB data area                                                                    CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      * Move data area to commitment array                                                    CSC022
     C                   IF        COMITNOM > 0                                               CSC022
     C                   MOVEA     COMITJOB      ARRJBNAM                                     CSC022
      *                                                                                       CSC022
      * Check if PSJOBNAME exist.                                                             CSC022
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                  CSC022
     C                   IF        *IN17 = *ON                                                CSC022
     C                   EVAL      WCMT01= 'Y'                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C                   ELSE                                                                 CSC022
      * @rtcd not found                                                                       CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBPGM = 'LEFAMDCTL'                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC022
     C                   EVAL      DBASE  = 902                                               CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** ##OX1
OVRDBF FILE(LEFAMDLR) TOFILE(LEFAMDL0) SHARE(*NO)
OVRDBF FILE(FCLTY) TOFILE(FCLTY) SHARE(*NO)
