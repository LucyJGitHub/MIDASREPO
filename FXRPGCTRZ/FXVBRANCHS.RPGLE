     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate booking and originating branch')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVBRANCHS - Validate Booking and Originating Branch         *
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
      *  Prev Amend No. 248269             Date 25Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 08Sep97               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248269 - Use original spot rate in validating the exchange   *
      *           rate of an Option takedown deal.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
 
     D*RelDealDts      DS           100                                                       248269
     D RelDealDts      DS           113                                                       248269
      ** Related Deal Details (when deal is option takedown or swap.
      ** Thus related deal will be other leg of swap or option).
     D  RelDBRC                1      3
 
 
      ** External data structure for branch codes file
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      *
      * BOOKING BRANCH VALIDATION - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      BRSNVS
     C                   END
      *
      * BOOKING BRANCH VALIDATION - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   EXSR      BRSNVM
     C                   END
      *
      * ORIGINATING BRANCH VALIDATION - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      ORBRVS
     C                   END
      *
      * ORIGINATING BRANCH VALIDATION - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   EXSR      ORBRVM
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDActnOK      IFEQ      'N'
     C     DDBrsnOK      OREQ      'N'
     C     DDOrbrOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * BRSNVS - BOOKING BRANCH VALIDATION - SINGLE BRANCHING
      *****************************************************************
     C     BRSNVS        BEGSR
      *
      * If branch is not yet defined
      * Default booking branch
      *
     C     DDBRSN        IFEQ      *BLANKS
     C                   MOVE      BJSBRC        DDBRSN
     C                   END
      *
      * Update booking branch on deal
      *
     C                   MOVE      DDBRSN        F3DBRC
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * BRSNVM - BOOKING BRANCH VALIDATION - MULTI-BRANCHING
      *****************************************************************
     C     BRSNVM        BEGSR
      *
      * Default booking branch
      *
     C     DDBRSN        IFEQ      *BLANKS
     C                   MOVE      BRC           DDBRSN
     C                   END
      *
      * Check that booking branch exists
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRSN        @DSNB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      * error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDBrsnOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRSN'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0115'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVEL     A8BRCD        DDBRSN
     C                   END
      *
      * Check that authorities to booking branch exist for action code
      * if this function is operating is synchronous mode.
      *
     C     RespMode      IFEQ      'S'
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM      DDBRSN        ZBRCDX            3
     C                   PARM                    ERR               1 0
      *
      * no valid action codes for user/branch combination
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           DDActnOK
     C                   MOVE      'N'           DDBrsnOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRSN'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0290'     MsgIDXAr(Idx)
     C                   END
      *
      * this action code invalid for user/branch combination
      *
     C     ERR           IFEQ      2
     C                   MOVE      'N'           DDActnOK
     C                   MOVE      'N'           DDBrsnOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRSN'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0291'     MsgIDXAr(Idx)
     C                   END
     C                   END
      *
      * If not authorization and a swap or option takedown
      * and swap/option deal number is OK
      *
     C     DDACTN        IFNE      'X'
     C     DDDLTP        ANDEQ     'SW'
     C     DDSdnoOK      ANDEQ     'Y'
     C     DDACTN        ORNE      'X'
     C     DDDLTP        ANDEQ     'OT'
     C     DDSdnoOK      ANDEQ     'Y'
      *
      * Booking branch different from branch on deal
      *
     C     RelDBRC       IFNE      DDBRSN
     C                   MOVE      'N'           DDBrsnOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRSN'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0116'     MsgIDXAr(Idx)
     C                   END
      *
     C                   END                                                    DDACTN IFNE 'X'
      *
      * Update booking branch on deal
      *
     C                   MOVE      DDBRSN        F3DBRC
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ORBRVS - ORIGINATING BRANCH VALIDATION - SINGLE BRANCHING
      *****************************************************************
     C     ORBRVS        BEGSR
      *
      * Default originating branch to booking branch (if valid)
      *
     C     DDORBR        IFEQ      *BLANKS
     C     DDBrsnOK      ANDEQ     'Y'
     C                   MOVE      DDBRSN        DDORBR
     C                   END
      *
      * Update originating branch on deal
      *
     C                   MOVEL     DDORBR        F3ORBR
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ORBRVM - ORIGINATING BRANCH VALIDATION - MULTI-BRANCHING
      *****************************************************************
     C     ORBRVM        BEGSR
      *
      * Default originating branch to booking branch (if valid)
      *
     C     DDORBR        IFEQ      *BLANKS
     C     DDBrsnOK      ANDEQ     'Y'
     C                   MOVE      DDBRSN        DDORBR
     C                   END
      *
      * If originating branches used
      * Check that originating branch exists
      *
     C     BKOBRU        IFEQ      'Y'
     C     DDORBR        ANDNE     *BLANKS
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDORBR        @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      * error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDOrbrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0289'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVEL     A8BRCD        DDORBR
     C                   END
      *
      * If originating branch/user validation
      * and if this function is operating is synchronous mode.
      *
     C     RespMode      IFEQ      'S'
     C     BKOBUV        ANDEQ     'Y'
     C                   CALL      'ZVOBU'
     C                   PARM      DDORBR        ZOBRX             3
     C                   PARM                    ERR               1 0
      *
      * no valid origination branches for this user
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           DDOrbrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0287'     MsgIDXAr(Idx)
     C                   END
      *
      * this originating branch invalid for user
      *
     C     ERR           IFEQ      2
     C                   MOVE      'N'           DDOrbrOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0288'     MsgIDXAr(Idx)
     C                   END
      *
     C                   END                                                    BKOBUV IFEQ 'Y'
     C                   END                                                    BKOBRU IFEQ 'Y'
      *
      * Update originating branch on deal
      *
     C                   MOVEL     DDORBR        F3ORBR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDBRSN            3            booking branch
     C                   PARM                    DDORBR            3            origin. branch
      *
      ** Swap/Opt Deal no OK
     C                   PARM                    ddSDNOok          1              SW/OP deal no.
      *
      ** Related deal details
     C                   PARM                    RelDealDts                     SW/OP branch
      *
      ** ICD
     C                   PARM                    BJSBRC            3
     C                   PARM                    BKOBRU            1
     C                   PARM                    BKOBUV            1
      *
      ** Response mode (from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    RespMode          1
      *
      ** Default branch code from ZMUSER
     C                   PARM                    BRC               3
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Action code - OK
      ** Booking branch - OK
      ** Originating branch - OK
     C                   PARM                    DDActnOK          1              action code
     C                   PARM                    DDBrsnOK          1              booking branch
     C                   PARM                    DDOrbrOK          1              origin. branch
      *
      ** Deal Booking Branch & Originating Branch
     C                   PARM                    F3DBRC            3            booking branch
     C                   PARM                    F3ORBR            3            origin. branch
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
