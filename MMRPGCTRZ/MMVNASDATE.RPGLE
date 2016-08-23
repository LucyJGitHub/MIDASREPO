     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate dates for NAs bought and sold')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVNASSDAT - Validate dates for negotiable assets sold.      *
      *                                                               *
      *  Function:  This module cross-validates the various date      *
      *             fields on a NASS transaction.                     *
      *                                                               *
      *  Component of: MMVALIDATE - Money Market validation service   *
      *                             program                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 249967             Date 13Sep07               *
      *                 BUG12893A          Date 28Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249967 - Restrict validation of VDAT to insert               *
      *  BUG12893A- Start/Last Int Date must not be entered for a     *
      *             a deal type not eq to 'C2','BP','BD'.(Recompile)  *
      *             additional delivery for BUG12893.                 *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Message ID 1 (7A, returned to caller)
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Message ID 2 (7A, returned to caller)
     D Msgid2          S                   LIKE(#MsgID)
 
      ** Message ID 3 (7A, returned to caller)
     D Msgid3          S                   LIKE(#MsgID)
 
      ** Warning message ID 1 (7A, returned to caller)
     D WMsgid1         S                   LIKE(#MsgID)
 
      ** Warning message ID 2 (7A, returned to caller)
     D WMsgid2         S                   LIKE(#MsgID)
 
      ** Warning message ID 3 (7A, returned to caller)
     D WMsgid3         S                   LIKE(#MsgID)
 
      ** Error in deal date flag (1A, returned to caller)
     D ErrDealDat      S                   LIKE(ErrorFound)
 
      ** Error in value date flag (1A, returned to caller)
     D ErrValDate      S                   LIKE(ErrorFound)
 
      ** Deal file version of deal date (5,0P, returned from
      ** this module)
     D ILDDND          S              5P 0
 
      ** Deal file version of value date (5,0P, returned from
      ** this module)
     D ILDVSD          S                   LIKE(ILDDND)
 
      ** Deal file version of start/last interest date
      ** (5,0P, returned from this module)
     D ILSLID          S                   LIKE(ILDDND)
 
      ** Deal date (6A, from transaction)
     D DDDLDT          S              6A
 
      ** Value date (6A, from transaction)
     D DDVDAT          S                   LIKE(DDDLDT)
 
      ** Run date (5,0P (Midas day number) from SDBANKPD via caller)
     D BJRDNB          S                   LIKE(ILDDND)
 
      ** Date format indicator (1A, from SDBANKPD via caller)
     D BJDFIN          S              1A
 
      ** Local Currency code (3A, from SDBANKPD via caller)
     D BJLCCY          S              3A
 
      ** Branch Location Code (3A, from SDBRCHPD via caller)
     D A8LCCD          S              3A
 
      ** Deal currency (3A, from transaction)
     D DDCCY           S                   LIKE(BJLCCY)
 
      ** Deal type (2A, from transaction)
     D DDTYPE          S              2A
                                                                                              249967
      ** Action Code (1A, from transaction)                                                   249967
     D DDACTN          S              1A                                                      249967
 
      ** Error codes (150A, from caller)
     D PMERCD          S            150A
 
      ** Pay - settlement currency (3A, from caller)
     D PMPSCY          S              3A
 
      ** Pay - our nostro (12A, from caller)
     D***PMPONS*         S             12A                                                    CGL029
     D PMPONS          S             18A                                                      CGL029
 
      ** Pay - settlement method (2,0S, from caller)
     D PMPSTM          S              2S 0
 
      ** Receive - settlement currency (3A, from caller)
     D PMRSCY          S              3A
 
      ** Receive - our nostro (12A, from caller)
     D PMRONS          S                   LIKE(PMPONS)
 
      ** Receive - settlement method (2,0S, from caller)
     D PMRSTM          S                   LIKE(PMPSTM)
 
      ** End of parameters
      ** =================
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Return the error flags for the two date fields to their starting
      ** values
     C                   RESET                   ErrDealDat
     C                   RESET                   ErrValDate
      *
      * Effective settlement currency
      *
     C     PMPSCY        IFNE      *BLANKS
     C                   MOVEL     PMPSCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     DDCCY         EffSetCcy         3
     C                   ENDIF
 
      ** Do the validation of the individual date fields
     C                   EXSR      ValDates
 
      ** Do the cross-validation
     C                   EXSR      CrossVal
 
      ** Return code set in /COPY
     C/COPY ZACPYSRC,SETRETCDE
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CrossVal - Does cross-validation among the various date fields*
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: DealDate, MatDate, NextIntDat                          *
      *                                                               *
      *****************************************************************
 
     C     CrossVal      BEGSR
 
      ** +--------------------------------------+
      ** ¦ Deal date                            ¦
      ** ¦ =========                            ¦
      ** +--------------------------------------+
 
     C                   EXSR      DealDate
 
      ** +--------------------------------------+
      ** ¦ Value date                           ¦
      ** ¦ ==========                           ¦
      ** ¦ No extra cross-checks for value date ¦
      ** +--------------------------------------+
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DealDate - Cross-validation of deal date                      *
      *                                                               *
      * Called by: CrossVal                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DealDate      BEGSR
 
     C*
     C**  The deal date must not be greater than the value date.
     C*
     C**  If the value date is invalid then this check is not carried
     C**  out.
     C                   IF        ErrValDate <> 'Y'
     C     ILDDND        IFGT      ILDVSD
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrDealDat  ='Y'
     C                   MOVEL     'MMM0250'     MsgID2
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValDates - Validate the individual date fields                *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: External routines MMVDLDATE, MMVVALDAT, MMVMATDAT,     *
      *                          MMVNXINTDT                           *
      *                                                               *
      *****************************************************************
 
     C     ValDates      BEGSR
 
      ** Validate Deal date
     C                   RESET                   ReturnCode
     C                   CALLB     'MMVDLDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    WMsgid1
     C                   PARM                    ILDDND
     C                   PARM                    DDDldt
     C                   PARM                    BJRdnb
     C                   PARM                    BJDfin
     C                   PARM                    WarnGlobal
     C                   PARM                    BJLCCY
     C                   PARM                    A8LCCD
 
      ** If errors and/or warnings found in deal date, set the appropriate
      ** return code and error flag
     C                   SELECT
 
     C                   WHEN      ReturnCode = 'Error'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrDealDat = 'Y'
 
     C                   WHEN      ReturnCode = 'Warning'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrDealDat = 'W'
 
     C                   WHEN      ReturnCode = 'ErrAndWarn'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrDealDat = 'Y'
 
     C                   ENDSL
 
      ** Validate value date
     C                   RESET                   ReturnCode
     C                   CALLB     'MMVVALDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid3
     C                   PARM                    WMsgid2
     C                   PARM                    WMsgid3
     C                   PARM                    ILDVSD
     C                   PARM                    ILSLID
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    BJRDNB
     C                   PARM                    A8LCCD
     C                   PARM                    EffSetccy
     C                   PARM                    DDTYPE
     C                   PARM                    DDVDAT
     C                   PARM                    PMERCD
     C                   PARM                    PMPONS
     C                   PARM                    PMPSTM
     C                   PARM                    PMRONS
     C                   PARM                    PMRSTM
     C                   PARM                    TransType
     C                   PARM                    DDACTN                                       249967
 
      ** If errors and/or warnings found in value date, set the appropriate
      ** return code and error flag
     C                   SELECT
 
     C                   WHEN      ReturnCode = 'Error'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrValDate = 'Y'
 
     C                   WHEN      ReturnCode = 'Warning'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrValDate = 'W'
 
     C                   WHEN      ReturnCode = 'ErrAndWarn'
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ErrValDate = 'Y'
 
     C                   ENDSL
 
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
 
     C     *entry        PLIST
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** -------------------------------------------------------------------
      ** All message IDs are 7A, returned to caller
      ** Message IDs 1 and 2 indicate errors in Deal Date
      ** Message ID 3 indicates error in Value Date
      ** -------------------------------------------------------------------
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    Msgid3
      ** -------------------------------------------------------------------
      ** All Warning message IDs are 7A, returned to caller
      ** Warning Message ID 1 indicates warnings in Deal Date
      ** Warning Message IDs 2 and 3 indicate warnings in Value Date
      ** -------------------------------------------------------------------
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    WMsgid3
      ** Error in deal date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrDealDat
      ** Error in value date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrValDate
      ** Deal file version of deal date (5,0P, returned from
      ** this module)
     C                   PARM                    ILDDND
      ** Deal file version of value date (5,0P, returned from
      ** this module)
     C                   PARM                    ILDVSD
      ** Deal file version of start/last interest date
      ** (5,0P, returned from this module)
     C                   PARM                    ILSLID
      ** Deal date (6A, from transaction)
     C                   PARM                    DDDLDT
      ** Value date (6A, from transaction)
     C                   PARM                    DDVDAT
      ** Run date (5,0P (Midas day number) from SDBANKPD via caller)
     C                   PARM                    BJRDNB
      ** Date format indicator (1A, from SDBANKPD via caller)
     C                   PARM                    BJDFIN
      ** Local Currency code (3A, from SDBANKPD via caller)
     C                   PARM                    BJLCCY
      ** Branch Location Code (3A, from SDBRCHPD via caller)
     C                   PARM                    A8LCCD
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Deal type (2A, from transaction)
     C                   PARM                    DDTYPE
      ** Error codes (150A, from caller)
     C                   PARM                    PMERCD
      ** Pay - settlement currency (3A, from caller)
     C                   PARM                    PMPSCY                        12A
      ** Pay - our nostro (12A, from caller)
     C                   PARM                    PMPONS
      ** Pay - settlement method (2,0S, from caller)
     C                   PARM                    PMPSTM
      ** Receive - settlement currency (3A, from caller)
     C                   PARM                    PMRSCY                        12A
      ** Receive - our nostro (12A, from caller)
     C                   PARM                    PMRONS
      ** Receive - settlement method (2,0S, from caller)
     C                   PARM                    PMRSTM
      ** Global warning flag (1A, from caller)
     C                   PARM                    WarnGlobal
      ** Transaction type (4A, from caller)
     C                   PARM                    TransType
      *                                                                                       249967
      ** Action code                                                                          249967
      *                                                                                       249967
     C                   PARM                    DDACTN                                       249967
 
      ** Initialise error flags (can't be done using INZ keyword in
      ** D-specs because they are on the parameter list)
     C                   EVAL            ErrDealDat = 'N'
     C                   EVAL            ErrValDate = 'N'
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
