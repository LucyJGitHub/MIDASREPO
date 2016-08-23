     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate In Depot')
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SEVDINDP - This module validates the In Depot field.         *
      *                                                               *
      *  Component of: SE0070 (Depot movements maintenance)           *
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
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAP087             Date 22Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039             Date 29Mar00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 19Mar99               *
      *                 CAP003  *CREATE    Date 21Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE022 - Depository Definition Enhancement (Recompile)       *
      *  CAP039 - Security customer details API. Fields added to      *
      *           SDSECSPD (recompile)                                *
      *  CAP006 - Bypass initial search (AOCUSTR0) if prompt (?)      *
      *           requested.                                          *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
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
 
      ** Second DS for access programs, long data structure                 1117
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Client Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      * Client Details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
      ** Screen input
 
     D DDDPID          S             10A
     D DDDPAD          S              6A
 
      ** Output fields
      ** -------------
 
     D*DPID*****       S              6S 0                                                    CSD027
     D DPID            S              6A                                                      CSD027
     D DDDPIDOk        S              1A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
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
      ** Validation
      *
     C                   EXSR      DPIDV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDPIDOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DPIDV - Validate In Depot field                               *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DPIDV         BEGSR
      *
      ** 'In' depot - mandatory only if associated deal number entered
      *
     C     DDDPID        IFEQ      *BLANKS
 
      ** IN depot is mandatory for Walk-In/Repo/Pledge/Depot Transfer types.                  CAP087
      *                                                                                       CAP087
     C     DDDPAD        IFNE      *BLANKS
     C     DPMVType      OREQ      'WI'
     C     DPMVType      OREQ      'RP'                                                       CAP087
     C     DPMVType      OREQ      'RR'                                                       CAP087
     C     DPMVType      OREQ      'PL'                                                       CAP087
     C     DPMVType      OREQ      'PD'                                                       CAP087
     C     DPMVType      OREQ      'DT'                                                       CAP087
      *
      ** Error mesage (200)
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPID'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0175'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPIDOK
     C                   END
      *                                                                                       CAP087
      ** IN Depot is mandatory for Bond Borrowing (BB) or Bond Lending (BL).                  CAP087
      *                                                                                       CAP087
     C     DDDPAD        IFEQ      *BLANKS                                                    CAP087
     C     DPMVType      IFEQ      'BB'                                                       CAP087
     C     DPMVType      OREQ      'BL'                                                       CAP087
     C                   ADD       1             Idx                                          CAP087
     C                   MOVEL     'DDDPID'      FldNamXAr(Idx)                               CAP087
     C                   MOVEL     'MMA2020'     MsgIdXAr(Idx)                                CAP087
     C                   MOVE      'N'           DDDPIDOK                                     CAP087
     C                   END                                                                  CAP087
     C                   END                                                                  CAP087
      *
      ** Update Trade
      *
     C**********         Z-ADD     *ZEROS        DPID                                         CSD027
     C                   EVAL      DPID = *BLANKS                                             CSD027
 
     C                   ELSE
      *
      ** else must reference an active securities customer
      *
      ** Test for numeric
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM      DDDPID        ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C                   MOVE      ZFIELD        @AENB             6
     C
     C     ZALIGNOk      IFEQ      'N'
      *
      ** In Depot is not numeric
      *
     C                   IF        %subst(DDDPID:1:1) <> '?'                    CAP0006
      *
     C                   MOVE      DDDPID        @KEY1
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCUST        @AENB
     C                   END
      *
     C                   ELSE                                                   CAP006
     C                   MOVEL     '?'           @AENB                          CAP006
     C                   END                                                    CAP006
     C                   END
 
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @AENB
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error mesage (201)
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPID'      FldNamXAr(Idx)
      * Display a more meaningful error message (In depot must be a Securities Cust).         CAP087
     C*******************MOVEL     'MMA0176'     MsgIdXAr(Idx)                                CAP087
     C                   MOVEL     'MMA2041'     MsgIdXAr(Idx)                                CAP087
     C                   MOVE      'N'           DDDPIDOK
     C                   ELSE
      *
      ** with Classification NE to 'S' or 'D'
      *
     C     BFCLAS        IFEQ      'S'
     C     BFCLAS        OREQ      'D'
      *
      ** Error mesage (201)
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPID'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0176'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPIDOK
     C**********         ELSE                                                   CAP006
     C                   END                                                    CAP006
      *
      ** Update screen/file fields
      *
     C                   MOVE      *BLANKS       DDDPID
     C                   MOVEL     BFCUST        DDDPID
     C                   MOVEL     BFCUST        DPID
     C                   END
     C                   END
     C**********         END                                                    CAP006
 
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
 
      ** Return Code Error Indicator
 
     C                   PARM                    RetCodeIn
      ** Received Parameter
      ** ------------------
 
      ** Screen Fields
      * In Depot (10A)
      * Associated Deal Number (6A)
 
     C                   PARM                    DDDPID
     C                   PARM                    DDDPAD
 
      ** Transaction Details
      * Movement type (2A)
     C                   PARM                    DPMVType          2
 
      ** Returned parameters
      ** -------------------
 
      * Security Client details
     C                   PARM                    SDSECS
 
      * Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      * In Depot Ok Indicator (1A)
      * In Depot (6S 0)
     C                   PARM                    DDDPIDOk
     C                   PARM                    DPID
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
