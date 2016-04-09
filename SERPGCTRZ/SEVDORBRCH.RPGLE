     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Originating Branch')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  SEVDORBRCH - Validate Originating Branch field               *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Originating Branch Code field.                    *
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
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
 
      ** Input Field(s)
      ** --------------
 
     ** Screen Fields
     D  DDORBR         S              3A
 
     ** Transaction Details
     D  DPBA           S              3A
 
     ** ICD
     ** System Info
     D  MBIN           S              1A
     D  BKOBRU         S              1A
     D  BKOBUV         S              1A
 
      ** Output field(s)
      ** ---------------
 
     D DDORBROk        S              1A
     D ORBR            S              3A
 
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
 
     C                   MOVE      *Blanks       ORBR
      *
      ** Validation
      *
     C                   EXSR      ORBRV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDORBROk      IFEQ      'N'
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
      * ORBRV - Validation Routine for the Original Branch field      *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ORBRV         BEGSR
      *
      ** MultiBranch = ON
      ** Originating Branch used indicator = 'Y'
      ** Originating Branch <> *BLANKS
      *
     C     MBIN          IFEQ      'Y'
     C     BKOBRU        ANDEQ     'Y'
 
     C     DDORBR        IFNE      '   '
      *
      ** Must reference an active Branch code
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDORBR        @DSNB
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
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0345'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDORBROK
     C                   END
      *
     C                   MOVE      DDORBR        ORBR
     C                   ELSE
      *
      ** No Originating branch entered - Use booking branch
      *
     C                   MOVE      DPBA          ORBR
     C                   END
      *
      **  Validate SPF - User's authority to Originating Branch
      **  if Originating branch/user validation is switched on
      **  and Response Mode is 'S'.
      *
     C     BKOBUV        IFEQ      'Y'
     C     RespMode      ANDEQ     'S'
 
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          @ZBR
     C                   PARM                    @ERR
      *
     C     @ERR          IFEQ      2
      *
      ** Error 306
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0199'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDORBROK
     C                   END
 
     C     @ERR          IFEQ      1
      *
      ** Error 305
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0198'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDORBROK
     C                   END
 
     C                   END
 
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
      ** Return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
 
      ** Received parameters
      ** -------------------
 
      ** Screen Fields **
      *  Originating Branch (3A)
     C                   PARM                    DDORBR
 
      ** Transaction details
      *  Booking Branch Code (3A)
     C                   PARM                    DPBA
 
      ** ICD
      ** System Info
      *  Multi-Branch Indicator  (1A)
      *  Originating Branch used indicator (1A)
      *  Originating Branch User/Validation required indicator (1A)
      *  Response Mode (A/S) (1A)
 
     C                   PARM                    MBIN
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
     C                   PARM                    RespMode          1
 
      ** Returned parameters
      ** -------------------
      * Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Originating Branch Ok Indicator (1A)
      ** Originating Branch Code (3A)
 
     C                   PARM                    DDORBROk
     C                   PARM                    ORBR
 
 
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
