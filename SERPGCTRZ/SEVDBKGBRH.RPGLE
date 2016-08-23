     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Booking Branch Code')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  SEVDBKGBRH - Validate Booking Brancd Code field.             *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Booking Branch Code field.                        *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said field. This routine has been retrieved  *
      *  from SE0070 and has been converted to ILE RPG and copied into*
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  Component of: SE0070 (Depot Movements Maintenance)           *
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
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 22Apr98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
     D FldNamXAr       S             10A   DIM(XArrayMax)
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Branch Details Data Structure
      ** DS used for Access Objects pgm
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
 
     ** Input field(s)
     ** --------------
 
      ** Screen Field(s)
     D  DDDPBA         S              3A
 
      ** ICD
      ** System Details
 
     D  MBIN           S              1A
     D  USRBCH         S              3A
 
      ** Output field(s)
      ** ---------------
 
     D DDDPBAOk        S              1A
     D DPBA            S              3A
 
      ** Working Variables
      ** -----------------
 
     D @DSNB           S              3A
     D @ERR            S              1P 0
     D @ZBR            S              3A
 
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
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
     C                   MOVE      *Blanks       DPBA
      *
      ** Validation
      *
     C                   EXSR      DPBAV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDPBAOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DPBAV - Validation routine for Booking Branch                 *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DPBAV         BEGSR
      *
      ** MultiBranch = ON
      *
     C     MBIN          IFEQ      'Y'
      *
      ** Booking Branch code
      *
     C     DDDPBA        IFNE      '   '
      *
      ** must reference an active Branch Code
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDDPBA        @DSNB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      **  Invalid Branch
      *
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error 212
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0342'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBAOK
     C                   ELSE
      *
      ** Update Screen/File
      *
     C                   MOVE      A8BRCD        DDDPBA
     C                   MOVE      A8BRCD        DPBA
     C                   END
      *
      ** Update file
      *
 
     C                   ELSE
      *
      ** No branch entered
      ** - Use default branch
      *
     C                   MOVE      USRBCH        DPBA
      *
      ** Fetch default Branch Internal Customer Number for default branch
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DPBA          @DSNB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C                   END
      *
      **  Validate SPF - User's authority to booking branch
      *
     C     RespMode      IFEQ      'S'
 
     C                   CALL      'ZVBBU'
     C                   PARM      DPBA          @ZBR
     C                   PARM                    @ERR
      *
     C     @ERR          IFEQ      2
      *
      ** Error 307
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0343'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBAOK
     C                   END
 
     C     @ERR          IFEQ      1
      *
      ** Error 308
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0344'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPBAOK
     C                   END
 
     C                   END
      *
      ** Fetch default Branch Internal Customer Number for single branch
      ** environment.
      *
     C                   ELSE
      *
      ** - Use default branch
      *
     C                   MOVE      USRBCH        DPBA
      *
      ** Fetch default Branch Internal Customer Number for default branch
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DPBA          @DSNB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      ** Return Error code Indicator
     C                   PARM                    RetCodeIn
 
      ** Received parameters
      ** -------------------
 
      ** Screen Fields
      *  Booking Branch Code (3A)
     C                   PARM                    DDDPBA
 
      ** System Details
      *  Multi-Branch Indicator  (1A)
      *  Default User's Branch (3A)
      *  Response Mode (1A) (A/S)
     C                   PARM                    MBIN
     C                   PARM                    USRBCH
     C                   PARM                    RespMode          1
 
      ** Returned parameters
      ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Data structure for the branch details
     C                   PARM                    SDBRCH
 
      ** Branch Code Ok Indicator (1A)
      ** Branch Code (3A)
     C                   PARM                    DDDPBAOk
     C                   PARM                    DPBA
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
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
(c) Misys International Banking Systems Ltd. 2001
