     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward Rates Interface Controller')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing ILE Module                                   *
      *                                                               *
      *  FDFWRTCTL - FD Forward Rates  Interface Controller           *
      *                                                               *
      *  Function: This Program Validates Forward Rates Input into    *
      *            the Midas database.                                *
      *            Even though no data is passed in the action code,  *
      *            the implied action code of this function is always *
      *            I (=Insert) = overwrite existing data if it        *
      *                          already exists for currency          *
      *            The decision as to whether to write to the Valid   *
      *            or Invalid file and the call to the Message        *
      *            Handler will take place in this module.            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 241919             Date 22Dec06               *
      *                 243720             Date 15Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8233            Date 23Aug05               *
      *                 BUG8141            Date 11Aug05               *
      *                 238595 (Reopen)    Date 03Apr06               *
      *                 BUG1056            Date 20May04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 196570             Date 24Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 04Oct00               *
      *                 CAP059             Date 04Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP005  *CREATE    Date 17Oct98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  241919 - Recompiled due to changes done to FDVFWRTPD.        *
      *  243720 - Incorrect passing of parameters for FDFWRTCVT.      *
      *  BUG8233- Error in Forward Rates upload via File Adapter API  *
      *           (Recompile)                                         *
      *  BUG8141- Recompiled due to changes to FDVFWRTPD              *
      *  238595 (Reopen) - Pass new parameter to FDFWRTVAL.           *
      *  BUG1056 - (CSC022) Commitment Control Changes for MidasPlus  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  196570 - Patch for Market Data Feed (recompile)              *
      *  CSD006 - Market Data Feed                                    *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Increased length of Transaction        *
      *           Reference ID from 6A to 20A.                        *
      *  CAP005 - Conversion of Citydealer Rates upload to use APIs   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Forward Rates
     FFDVFWRTPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
      * Invalid Forward Rates                                                   CAP059
     FFDIFWRTPD UF A E             DISK    INFSR(*pssr)                         CAP059
     F                                     COMMIT                               CAP059
                                                                                CAP059
      * Valid Forward Rates by Front Office Id                                  CAP059
     FFDVFWRTL0 IF   E           K DISK    RENAME(FDVFWRTD0:FDVFWRTCH0)         CAP059
                                                                                CAP059
     FFDVFWRTL1 IF   E           K DISK    RENAME(FDVFWRTD0:FDVFWRTCHK)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FDFWRTC001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
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
 
      ** Commitment Control Job Array                                                        BUG1056
     D WJobs           S             10A   Dim(10)                                           BUG1056
      **                                                                                     BUG1056
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Forward Rates Record
     D TranIn        E DS                  EXTNAME(FDFWRTPD)
     D  TranIn1                1    484                                         CAP059
     D  TranIn2              485    551                                         CAP059
 
      * Valid Forward Rates layout
     D ValidFWRT     E DS                  EXTNAME(FDVFWRTPD)
 
     D PrvFRFilFmt   E DS                  EXTNAME(FDVFWRTPD)                   CAP059
     D                                     PREFIX(P_)                           CAP059
      ** Previous Forward Rates Detail in File Format                           CAP059
 
      * (Current) Forward Rates record in File Format
     D FWRTFilFmt    E DS                  EXTNAME(FWDRTFE)
                                                                                CAP059
      * (Current) Transaction in Screen Format - Main Details                   CAP059
     D CURTRFWRT     E DS                  EXTNAME(FDFWRTPD)                    CAP059
     D                                     PREFIX(C_)                           CAP059
 
 
      ** Flags to indicate whether forward rates fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FDEFWRTPD)
 
 
      * Forward Rates Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(FDFREXPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
                                                                                CAP059
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP059
      ** External DS for API ICD                                                CAP059
                                                                                CAP059
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP059
     D                                     PREFIX(S_)                           CAP059
      ** External DS for API ICD                                                CAP059
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
      ** SCCMTJOB DataArea Layout                                                            BUG1056
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG1056
     D  WDSJobs                4    103A                                                     BUG1056
      **                                                                                     BUG1056
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Field (500A) to receive the incoming forward rates record
     D*Trans500********S            500A                                        CAP059
     D Trans5001       S            500A                                        CAP059
     D Trans5002       S            500A                                        CAP059
 
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** The transaction's status
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A   INZ('FD')
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Update Y/N?                                                                          238595
     D UpdateYN        S              1A   INZ(*BLANK)                                        238595
                                                                                              238595
      ** Fields for data area locking
     D Object          S             10A   INZ('FDFWRTUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Parameters and work fields for ZAMSGTOOPR
     D LongError       S            132A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** Flags to indicate whether substitution is required in                  CAP059
      ** each of the various parts the transaction                              CAP059
     D RepFWRT         S              1A   inz('N')                             CAP059
                                                                                              CSC011
      ** Fields defined for CSC011                                                            CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PDealNum        S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
                                                                                              CSC011
      ** CSC022 work fields                                                                  BUG1056
     D WArrPtr         S              3S 0                                                   BUG1056
     D WSkpComtRolbk   S              1A                                                     BUG1056
      **                                                                                     BUG1056
      ** CSC022 switchable field                                                             BUG1056
     D CSC022          S              1A                                                     BUG1056
      **                                                                                     BUG1056
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FDFWRTC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FDFWRTC003
 
      * Incoming forward rates rec is in a 500A field, so that a common CLP
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break that 500A by loading it into the
      * appropriate (externally described) data structure.
     C*******************MOVEL     Trans500      TranIn                         CAP059
     C                   MOVEL     Trans5001     TranIn1                        CAP059
     C                   MOVEL     Trans5002     TranIn2                        CAP059
     C                   MOVEL     Extdata500    Extdata
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
                                                                                CAP059
      *  Check if forward rates record exists for Front Office Id               CAP059
                                                                                CAP059
     C                   IF        CAP059 = 'Y'                                 CAP059
     C                   EXSR      ChkVFWRFO                                    CAP059
     C                   ENDIF                                                  CAP059
                                                                                CAP059
      *  If valid fwd rates do exist (even after delay), fail this input        CAP059
                                                                                CAP059
     C     Idx           IFNE      0                                            CAP059
     C                   GOTO      INVALID                                      CAP059
     C                   END                                                    CAP059
 
      /COPY WNCPYSRC,FDFWRTC004
 
      *  Check if forward rates record is valid
 
     C                   EXSR      ChkValFWRT
      *
      *  If valid fwd rates do exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid forward rates file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,FDFWRTC005
      *
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
 
      *  If error in validation of action code, fail this input                 CAP059
      *                                                                         CAP059
     C     Idx           IFNE      0                                            CAP059
     C                   GOTO      INVALID                                      CAP059
     C                   ENDIF                                                  CAP059
                                                                                CAP059
                                                                                CAP059
      * Call defaulting sub-routine                                             CAP059
     C                   IF        CAP059 = 'Y'                                 CAP059
     C                   IF        DDACTN = 'I'                                 CAP059
     C                   EVAL      C_DDACTN = DDACTN                            CAP059
     C                   EVAL      C_DDCCY  = DDCCY                             CAP059
     C                   ENDIF                                                  CAP059
     C                   EXSR      SRDFT                                        CAP059
     C                   ENDIF                                                  CAP059
      *
      /COPY WNCPYSRC,FDFWRTC006
 
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      ** Validate the main details of the transaction
 
      /COPY WNCPYSRC,FDFWRTC007
     C                   IF        CAP059 = 'N'                                 CAP059
     C                   EXSR      ValidateTr
     C                   ENDIF                                                  CAP059
      /COPY WNCPYSRC,FDFWRTC008
 
      *  Processing depends upon Action Code                                    CAP059
                                                                                CAP059
     C                   IF        CAP059 = 'Y'                                 CAP059
     C                   SELECT                                                 CAP059
                                                                                CAP059
     C                   WHEN         DDACTN = 'I'                              CAP059
                                                                                CAP059
      /COPY WNCPYSRC,FDFWRTC007                                                 CAP059
     C                   EXSR      ValidateTr                                   CAP059
      /COPY WNCPYSRC,FDFWRTC008                                                 CAP059
                                                                                CAP059
      *  Processing for Inserts                                                 CAP059
     C                   WHEN         DDACTN = 'A'                              CAP059
     C                             OR DDACTN = 'D'                              CAP059
      *  Processing for Amends or Changes                                       CAP059
      /COPY WNCPYSRC,FDFWRTC009                                                 CAP059
      * Check for the existence of the replacement character; if this is        CAP059
      * used, only the changed data has been sent, and all occurrences of       CAP059
      * the replacement character must be replaced with the corresponding       CAP059
      * character from the original transaction.                                CAP059
     C                   if        DDACTN = 'A' AND GHSUBS <> *blank            CAP059
                                                                                CAP059
     C     GHSUBS        scan      TranIn                                 99    CAP059
     C                   if        *in99                                        CAP059
     C                   eval      RepFWRT = 'Y'                                CAP059
     C                   endif                                                  CAP059
                                                                                CAP059
      ** If any of the flags set above is true, do the data                     CAP059
      ** substution subroutine.                                                 CAP059
     C                   if        RepFWRT = 'Y'                                CAP059
     C                   EXSR      DtaSubs                                      CAP059
     C                   endif                                                  CAP059
                                                                                CAP059
     C                   endif                                                  CAP059
      **                 (End of "if DDACTN = 'A' and GHSUBS <> *blank")        CAP059
                                                                                CAP059
     C                   EXSR      SetupAmd                                     CAP059
      /COPY WNCPYSRC,FDFWRTC010                                                 CAP059
     C                   EXSR      ValidateTr                                   CAP059
      /COPY WNCPYSRC,FDFWRTC011                                                 CAP059
                                                                                CAP059
     C                   ENDSL                                                  CAP059
     C                   ENDIF                                                  CAP059
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      ** prompting the database update program (LogError SR
      ** includes a RETURN).
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,FDFWRTC009
 
     C                   IF        ARERRMOD <> *blank
     C                   EXSR      LogError
     C                   ENDIF
 
      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,FDFWRTC010
     C                   EXSR      CheckWrite
 
      /COPY WNCPYSRC,FDFWRTC011
 
      ** If valid, send data queue entry to prompt DB update program
     C                   IF        Idx = 0
     C                   EXSR      SndPrompt
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FDFWRTC012
 
      *****************************************************************
      /EJECT                                                                    CAP059
      *****************************************************************         CAP059
      *                                                               *         CAP059
      * SrDFT - Default first rate                                    *         CAP059
      *                                                               *         CAP059
      *****************************************************************         CAP059
     C     SrDFT         BEGSR                                                  CAP059
                                                                                CAP059
      ** Call Retrieve Module                                                   CAP059
                                                                                CAP059
     C                   CALLB     'FDFWRTDFT'                                  CAP059
      * Return Code                                                             CAP059
     C                   PARM                    RetCodeIn                      CAP059
      ** Action Code                                                            CAP059
     C                   PARM                    DDACTN            1            CAP059
      ** Currency Code                                                          CAP059
     C                   PARM                    DDCCY             3            CAP059
      ** First Rate                                                             CAP059
     C                   PARM                    DDRTE1           14            CAP059
      * OUTPUTS                                                                 CAP059
      *                                                                         CAP059
      * Field OK flags (DS) from/to caller                                      CAP059
     C                   PARM                    OKFLAGSDS                      CAP059
      * Error fields/message IDs/message data (arrays) from/to caller           CAP059
     C                   PARM                    FldNameArr                     CAP059
     C                   PARM                    MsgIdArr                       CAP059
     C                   PARM                    MsgDtaArr                      CAP059
      *                                                                         CAP059
      * Array index (3P0) from/to caller                                        CAP059
      *                                                                         CAP059
     C                   PARM                    Idx                            CAP059
      *                                                                         CAP059
      * Reset of Fields in Error Required (Y/N)                                 CAP059
     C                   PARM      'Y'           ResetErrs         1            CAP059
     C                   IF        IDX = 0  AND                                 CAP059
     C                             DDACTN = 'I'                                 CAP059
     C                   EVAL      C_DDRTE1 = DDRTE1                            CAP059
     C                   ENDIF                                                  CAP059
     C                   ENDSR                                                  CAP059
      *****************************************************************         CAP059
      /EJECT                                                                    CAP059
      *****************************************************************         CAP059
      *                                                               *         CAP059
      * ChkVFWRFO - Routine to check if valid forward rates record    *         CAP059
      *             exists for Front Office Id.                       *         CAP059
      *                                                               *         CAP059
      *****************************************************************         CAP059
                                                                                CAP059
     C     ChkVFWRFO     BEGSR                                                  CAP059
                                                                                CAP059
      * Check for forward rates record on Valid file                            CAP059
     C     APFOTranID    CHAIN     FDVFWRTL0                          99        CAP059
                                                                                CAP059
      * If record found...                                                      CAP059
     C     *IN99         IFEQ      '0'                                          CAP059
                                                                                CAP059
      * ..delay, then repeat check                                              CAP059
     C                   CALLB     'ZACDELAY'                                   CAP059
                                                                                CAP059
     C     APFOTranId    CHAIN     FDVFWRTL0                          99        CAP059
                                                                                CAP059
      * Error if still present                                                  CAP059
     C     *IN99         IFEQ      '0'                                          CAP059
     C                   ADD       1             Idx                            CAP059
     C                   EVAL      FldNameArr(Idx) = 'FWFRNT'                   CAP059
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP059
     C                   ENDIF                                                  CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
     C                   ENDSR                                                  CAP059
      *****************************************************************         CAP059
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValFWRT - Routine to check if valid forward rates record   *
      *              exists for currency.                             *
      *                                                               *
      *****************************************************************
 
     C     ChkValFWRT    BEGSR
 
      * Check for forward rates record on Valid file
     C     DDCCY         CHAIN     FDVFWRTL1                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     DDCCY         CHAIN     FDVFWRTL1                          99
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCY'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              currency supplied.                               *
      *              Implied action code is always 'I', therefore,    *
      *              simply validate that currency exists.            *
      *****************************************************************
 
     C     ValidateAc    BEGSR
      *                                                                         CAP059
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP059
      * if insert or if not insert and currency code is not present.            CAP059
      * Otherwise set the mode to blanks.                                       CAP059
      * We assume no substitution has been defined for the transaction ID       CAP059
      *                                                                         CAP059
      ** Check for the existence of the replacement character at the            CAP059
      ** Transaction Id level.                                                  CAP059
     C                   IF        GHSUBS <> *blank                             CAP059
     C     GHSUBS        SCAN      DDCCY         SubForCCY         2 0          CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
     C     CSD006        IFEQ      'Y'                                          CAP059
     C     DDACTN        IFEQ      'I'                                          CAP059
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP059
                                                                                CAP059
     C                   ELSE                                                   CAP059
                                                                                CAP059
     C     DDCCY         IFEQ      *BLANK                                       CAP059
     C     SubForCCY     ORNE      0                                            CAP059
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP059
                                                                                CAP059
     C                   ELSE                                                   CAP059
                                                                                CAP059
     C                   MOVEL     *BLANK        ModeofOp                       CAP059
     C                   ENDIF                                                  CAP059
     C                   ENDIF                                                  CAP059
     C                   ELSE                                                   CAP059
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP059
     C                   ENDIF                                                  CAP059
 
      * Validate action code versus currency code supplied.
      * The forward rates record in file format from the FD database is
      * retrieved as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FDFWRTRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
     C***********        PARM      '*FRONT'      ModeofOp          6            CAP059
     C                   PARM                    ModeofOp          6            CAP059
      *
      * Response mode
     C                   PARM                    APRESPMODE
 
      * Action Code
     C                   PARM                    DDACTN
 
      * Currency
     C                   PARM                    DDCCY
                                                                                 CAP059
      * Front Office Transaction ID                                              CAP059
     C                   PARM                    APFOTranID                      CAP059
 
      * OUTPUTS
 
      * (Current) forward rates record in file format
     C                   PARM                    FWRTFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK
 
      * OK - Currency
     C                   PARM                    DDCcyOK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
                                                                                CAP059
     C                   IF        DDACTN = 'A'                                 CAP059
     C                   MOVEL     FWRTFilFmt    PrvFRFilFmt                    CAP059
     C                   ENDIF                                                  CAP059
 
     C                   ENDSR
      *****************************************************************         CAP059
      /EJECT                                                                    CAP059
      *****************************************************************         CAP059
      *                                                               *         CAP059
      * SETUPAMD - Set up fields that are needed in the validation    *         CAP059
      *    of amendments and changes.                                 *         CAP059
      *                                                               *         CAP059
      *****************************************************************         CAP059
     C     SetupAmd      BEGSR                                                  CAP059
                                                                                CAP059
      * For Amends, put the complete (pre-existing) Transaction into the Valid  CAP059
      *  file record - fields in this will be updated during processing         CAP059
                                                                                CAP059
     C**********         MOVE      FWRTFilFmt    ValidFWRT                             CAP059 243720
     C                   MOVEL     FWRTFilFmt    ValidFWRT                                    243720
                                                                                CAP059
      * For Amends, convert the forward rates transaction to screen format      CAP059
                                                                                CAP059
     C                   CALLB     'FDFWRTCVT'                                  CAP059
      * INPUTS                                                                  CAP059
      *                                                                         CAP059
      * Return Code                                                             CAP059
     C                   PARM                    RetCodeIn                      CAP059
      *                                                                         CAP059
      * Forward Rates Transaction - file formats                                CAP059
     C                   PARM                    ValidFWRT                      CAP059
      *                                                                         CAP059
      * Output parameters                                                       CAP059
      *                                                                         CAP059
      * Forward Rates Transaction Details - screen formats                      CAP059
     C                   PARM                    CURTRFWRT                      CAP059
                                                                                CAP059
                                                                                CAP059
     C                   ENDSR                                                  CAP059
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main fwd rates details   *
      *                                                               *
      *****************************************************************
 
     C     ValidateTr    BEGSR
 
     C                   IF        DDACTN = 'A' AND CSD006 = 'Y'                             196570
     C                   EVAL      C_DDACTN = 'A'                                            196570
     C                   ENDIF                                                               196570
 
     C                   IF         DDACTN = 'A' OR DDACTN = 'I'                CAP059
                                                                                CAP059
     C                   CALLB     'FDFWRTAMD'                                  CAP059
     C                   PARM                    RetCodeIn                      CAP059
     C                   PARM                    CURTRFWRT                      CAP059
     C                   PARM                    TRANIN                         CAP059
     C                   PARM                    OKFLAGSDS                      CAP059
     C                   PARM                    FldNameArr                     CAP059
     C                   PARM                    MsgIdArr                       CAP059
     C                   PARM                    MsgDtaArr                      CAP059
     C                   PARM                    Idx                            CAP059
     C                   PARM                    AmendOk           1            CAP059
     C                   PARM      'N'           ResetErrs         1            CAP059
     C                   ENDIF                                                  CAP059
 
     C                   CALLB     'FDFWRTVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    ExtData
     C                   PARM                    PrvFRFilFmt                    CAP059
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr                     CAP059
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Forward Rates layout (DS) from/to caller
     C                   PARM                    ValidFWRT
      * Update Y/N                                                                            238595
     C                   PARM                    UpdateYN                                     238595
 
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
 
      *  If no errors were found:
      *   - set up additional data
      *   - write a record to the Valid file
      *   - use std message handler to report forward rates status
      *  If any errors were found:
      *  - write a record to the Invalid file
      *  - call the message handler to pass the errors back
      *  - use std message handler to report forward rates status
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
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   WRITE     FDVFWRTD0
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C     Idx           IFGT      0
     C     CAP059        IFNE      'Y'                                          CAP059
     C                   EVAL      TranStatus = 'F'
     C                   ELSE                                                   CAP059
     C                   EXSR      SETUPINVAL                                   CAP059
      *                                                                         CAP059
      ** Only write to invalid files if repair in back office                   CAP059
      *                                                                         CAP059
     C     APRprLocn     IFEQ      'B'                                          CAP059
     C                   WRITE     FDIFWRTD0                                    CAP059
                                                                                              CSC011
      ** If support system is active, write invalid transaction to                            CSC011
      ** log file via APLOGTRAN standard module.                                              CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranIn + ExtData                                CSC011
     C                   EVAL      APTGTTYPE = 'FDFWRT'                                       CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = PDealNum                                           CSC011
     C                   EVAL      DBFile = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBase = 2                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                  CAP059
     C                   ENDIF                                                  CAP059
      ***********                                                               CAP059
      **N.B.*Repair*location*is*front*office*for*forward*rates.********         CAP059
      **Therefore,*do*NOT*write*to*invalid*files.**********************         CAP059
      *
      * Execute message handling routine.
      *
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
      **                                                                                     BUG1056
      ** Execute commit if SAR CSC022 is not enrolled or                                     BUG1056
      **   job is not currently running in batch mode                                        BUG1056
      **                                                                                     BUG1056
     C                   If        CSC022 = 'N'                                              BUG1056
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                 BUG1056
     C                   COMMIT
     C                   EndIf                                                               BUG1056
 
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
 
     C                   MOVE      *ALL'Y'       OKFlagsDS
 
     C                   CLEAR                   ValidFWRT
 
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
     C                   EVAL      FWREPA = APRprLocn
                                                                                CAP059
     C     DDACTN        IFEQ      'I'                                          CAP059
     C                   EVAL      FWTMESTMP = TimeStamp
     C                   ELSE                                                   CAP059
     C                   EVAL      FWTMESTMP = FRTMST                           CAP059
     C                   ENDIF                                                  CAP059
                                                                                CAP059
     C     CAP059        IFEQ      'Y'                                          CAP059
     C                   EVAL      FWFRNT = APFOTranID                          CAP059
     C                   ENDIF                                                  CAP059
 
     C     DDDFTS        IFEQ      *BLANK                                       CSD006
     C                   EVAL      FWDFTS = 0                                   CSD006
     C                   ENDIF                                                  CSD006
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,FDFWRTC013
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP059
      *****************************************************************         CAP059
      *                                                               *         CAP059
      * SETUPINVAL - Set up additional fields that are needed on the  *         CAP059
      *              Invalid file record.                             *         CAP059
      *                                                               *         CAP059
      *****************************************************************         CAP059
     C     SETUPINVAL    BEGSR                                                  CAP059
                                                                                CAP059
      ** Include Header fields that need to be o/p to the Invalid files         CAP059
                                                                                CAP059
     C                   EVAL      DDFOTRANID = APFOTranID                      CAP059
     C                   EVAL      DDRPRLOCN = APRprLocn                        CAP059
     C                   EVAL      DDTMESTMP = TimeStamp                        CAP059
                                                                                CAP059
     C                   EVAL      TranStatus = 'F'                             CAP059
                                                                                CAP059
     C                   ENDSR                                                  CAP059
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
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************
     C     CallMsgHdl    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C     FldNameArr(Ix)IFNE      *BLANKS
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
     C                   ENDDO
 
     C                   RESET                   ReturnCode
 
     C                   MOVE      *BLANKS       CCY6A
     C                   MOVEL     DDCCY         CCY6A             6
 
     C                   MOVEL     CCY6A         PTranID          20                          CAP033
                                                                                              CAP033
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Repair location (1A, from caller)
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
     C***********        PARM      *BLANKS       APFOTranID                     CAP059
     C                   PARM                    APFOTranID                     CAP059
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ***Midas*transaction*ID*(6A,*from*caller)********************************************** CAP033
      ** Midas transaction ID (20A, from caller)                                              CAP033
     C***********        PARM                    CCY6A                                        CAP033
     C                   PARM                    PTranID                                      CAP033
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
      /EJECT                                                                    CAP059
      *****************************************************************         CAP059
      *                                                               *         CAP059
      * DtaSubs - Data Substitution                                   *         CAP059
      *                                                               *         CAP059
      *****************************************************************         CAP059
                                                                                CAP059
     C     DtaSubs       begsr                                                  CAP059
                                                                                CAP059
      ** Convert file fields to screen format                                   CAP059
     C                   reset                   ReturnCode                     CAP059
     C                   CALLB     'FDFWRTCVT'                                  CAP059
      * Return Code                                                             CAP059
     C                   PARM                    ReturnCode                     CAP059
      * Input parameters                                                        CAP059
      * Forward Rate Transaction - file formats                                 CAP059
     C                   PARM                    FWRTFilFmt                     CAP059
      *                                                                         CAP059
      * Output parameters                                                       CAP059
      * Forward Rate Transaction Details - screen formats                       CAP059
     C                   PARM                    CURTRFWRT                      CAP059
                                                                                CAP059
      ** Substitute the data for the various parts of the transaction,          CAP059
      ** dependent on the flags that were set earlier.                          CAP059
                                                                                CAP059
     C                   if        RepFWRT = 'Y'                                CAP059
                                                                                CAP059
     C                   clear                   IncData                        CAP059
     C                   clear                   CurData                        CAP059
     C                   RESET                   ReturnCode                     CAP059
     C                   CALLB     'APDTASUBS'                                  CAP059
      * Return Code                                                             CAP059
     C                   PARM                    ReturnCode                     CAP059
      * Substitution character                                                  CAP059
     C                   PARM                    GHSUBS                         CAP059
      * Incoming Data                                                           CAP059
     C                   PARM      TranIn        IncData        2000            CAP059
      * Current Data                                                            CAP059
     C                   PARM      CURTRFWRT     CurData        2000            CAP059
                                                                                CAP059
     C                   MOVEL     IncDATA       TranIn                         CAP059
                                                                                CAP059
     C                   endif                                                  CAP059
                                                                                CAP059
     C                   endsr                                                  CAP059
                                                                                CAP059
      *****************************************************************         CAP059
      /EJECT                                                                    CAP059
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
      * Transaction information in a single large field from source system
     C*******************PARM                    Trans500                       CAP059
     C                   PARM                    Trans5001                      CAP059
     C                   PARM                    Trans5002                      CAP059
     C                   PARM                    ExtData500
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *                                                                         CAP059
      ** Access SAR details file to determine if Forward Rates API              CAP059
      ** Switchable feature is switched on                                      CAP059
      *                                                                         CAP059
     C                   CALLB     'AOSARDR0'                                   CAP059
     C                   PARM      *BLANKS       @RTCD                          CAP059
     C                   PARM      '*VERIFY'     @OPTN                          CAP059
     C                   PARM      'CAP059'      @SARD             6            CAP059
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP059
     C     @RTCD         IFEQ      *BLANK                                       CAP059
     C                   MOVEL     'Y'           CAP059            1            CAP059
     C                   ELSE                                                   CAP059
     C                   MOVEL     'N'           CAP059                         CAP059
     C                   END                                                    CAP059
      *                                                                                       CSD006
      ** Access SAR details file to determine if MDF Switchable feature                       CSD006
      ** is switched on                                                                       CSD006
      *                                                                                       CSD006
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD006
     C     @RTCD         IFEQ      *BLANK                                                     CSD006
     C                   MOVEL     'Y'           CSD006            1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVEL     'N'           CSD006                                       CSD006
     C                   END                                                                  CSD006
                                                                                              CSC011
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
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 1                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      **                                                                                     BUG1056
      ** Access SAR details to see if CSC022 is switched on                                  BUG1056
      **                                                                                     BUG1056
     C                   CallB     'AOSARDR0'                                                BUG1056
     C                   Parm      *Blanks       PRtCd                                       BUG1056
     C                   Parm      '*VERIFY'     POptn                                       BUG1056
     C                   Parm      'CSC022'      PSard                                       BUG1056
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG1056
      ** Initialize CSC022 and Skip Commit Flags                                             BUG1056
     C                   Eval      CSC022 = 'N'                                              BUG1056
     C                   Eval      WSkpComtRolbk = 'N'                                       BUG1056
      **                                                                                     BUG1056
     C                   If        PRtCd = *BLANKS                                           BUG1056
     C                   Eval      CSC022 = 'Y'                                              BUG1056
      **                                                                                     BUG1056
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                     BUG1056
      **                                                                                     BUG1056
     C                   In        SCCMTJOB                                                  BUG1056
     C                   If        ComitNum > 0                                              BUG1056
      ** Move committed jobs to arrary for checking                                          BUG1056
     C                   MoveA     WDSJobs       WJobs                                       BUG1056
      ** Verify if job running exists in array                                               BUG1056
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                        BUG1056
     C                   If        WArrPtr > 0                                               BUG1056
     C                   Eval      WSkpComtRolbk = 'Y'                                       BUG1056
     C                   EndIf                                                               BUG1056
     C                   EndIf                                                               BUG1056
      **                                                                                     BUG1056
     C                   Else                                                                BUG1056
      ** Execute *PSSR if CSC022 is not found or Database error                              BUG1056
     C                   If        PRtCd <> '*NRF'                                           BUG1056
     C     *Lock         In        LDA                                                       BUG1056
     C                   Eval      DBFile = 'SCSARDPD'                                       BUG1056
     C                   Eval      DBPgm  = 'FDFWRTCTL'                                      BUG1056
     C                   Eval      DBKey  = 'CSC022'                                         BUG1056
     C                   Eval      DBase  = 900                                              BUG1056
     C                   Out       LDA                                                       BUG1056
     C                   Exsr      *PSSR                                                     BUG1056
     C                   EndIf                                                               BUG1056
     C                   EndIf                                                               BUG1056
      **                                                                                     BUG1056
      ** Access API ICD via access program                                      CAP059
     C                   CALLB     'AOAPIR0'                                    CAP059
     C                   PARM      '*DBERR '     @RTCD                          CAP059
     C                   PARM      '*FIRST '     @OPTN                          CAP059
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP059
                                                                                CAP059
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APFWRTDTQ'
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FDFWRTC014
 
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
**  CPY@
(c) Finastra International Limited 2001
