     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Charge Settlement Branch')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEVDSETBRH - Validate Charge Settlement Branch.              *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Charge Settlement Branch.                         *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said field. This routine has been retrieved  *
      *  from SE0070 and has been converted to ILE RPG and copied into*
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
      *                                                               *
      *  Component of: SE0070 - Depot Movement Maintenance            *
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
      *                 BUG1046            Date 15Mar06               *
      *                 CAP087             Date 14Aug05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003 *CREATE     Date 13Mar98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10469 - Fees functionality is missing from Bond           *
      *             Borrowing and Bond Lending input.                 *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
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
 
      ** Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** DS for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
      ** Screen fields
     D DDDCHC          S              2A
     D DDDCCE          S              3A
     D DDDCHA          S             14A
     D DDDCSE          S              2A
     D***DDDCAT*         S             12A                                                    CGL029
     D DDDCAT          S             18A                                                      CGL029
     D DDDCAB          S              3A
 
      ** Depot Movement details
     D ACTNTP          S              2A
     D DPBA            S              3A
 
      ** System input
     D BVACOP          S              1A
     D S01445          S              1A
     D BGRTBN          S              1A
     D MBIN            S              1A
 
      ** Output
     D DCAB            S              3A
     D DDDCABOk        S              1A
 
      ** Working Variables
      ** -----------------
 
     D @DSNB           S              3A
 
      ** Index for arrays of error message ids etc
 
     D Idx             S              3P 0
 
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
      *
      ** Process '?' entry since it would be bypass in the validation
      ** routine if other relevant fields are invalid.
      *
     C     DDDCAB        IFEQ      '?  '
     C     DDDCAB        OREQ      ' ? '
     C     DDDCAB        OREQ      '  ?'
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDDCAB        @DSNB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A8BRCD        DDDCAB
     C                   END
 
     C                   END
      *
      ** Validate
      *
     C                   EXSR      DCABV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDCABOK      IFEQ      'N'
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
      * DCABV - Validation routine for Charge Settlement Branch       *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DCABV         BEGSR
      *
      ** If Autocharge is switched on, and SAR 01445 is ON, validate
      *
     C     BVACOP        IFEQ      'Y'
     C     S01445        ANDEQ     'Y'
      *                                                                                     BUG10469
      * Also validate for Bonds even if Autocharge and S01445 are OFF.                      BUG10469
     C     ACTNTP        OREQ      'BB'                                                     BUG10469
     C     ACTNTP        OREQ      'BL'                                                     BUG10469
      *
      ** If any charge values entered, go on to validate them
      *
     C     DDDCHC        IFNE      *BLANK
     C     DDDCCE        ORNE      *BLANK
     C     DDDCHA        ORNE      *BLANK
     C     DDDCSE        ORNE      *BLANK
     C     DDDCAT        ORNE      *BLANK
     C     DDDCAB        ORNE      *BLANK
      *
      ** If depot movement is type = Walk-In/Walk-Out, validate
      ** Otherwise, Error.
      ** Also validate for Bond Borrowing (BB) or Bond Lending (BL),                          CAP087
      ** Pledge Deposit (PD) and Pledge Loan (PL).                                            CAP087
      *
     C     ACTNTP        IFEQ      'WI'
     C     ACTNTP        OREQ      'WO'
     C     ACTNTP        OREQ      'BB'                                                       CAP087
     C     ACTNTP        OREQ      'BL'                                                       CAP087
     C     ACTNTP        OREQ      'PD'                                                       CAP087
     C     ACTNTP        OREQ      'PL'                                                       CAP087
      *
      ** Validate Charge Settlement Branch
      ** - if multi-branching off, set branch to default branch
      *
     C     MBIN          IFNE      'Y'
     C                   MOVE      DPBA          DDDCAB
     C                   MOVE      DDDCAB        DCAB
     C                   ELSE
      *
     C                   MOVE      DDDCAB        DCAB
      *
     C     DDDCSE        IFNE      '05'
     C     DDDCAB        ANDNE     *BLANKS
      *
      ** Error 248
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAB'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0241'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCABOk
     C                   END
      *
      ** Update Branch field if Settlement Method is 14 or 04.
      *
     C     DDDCAB        IFEQ      *BLANKS
 
     C                   IF        DDDCSE = '04'
     C                             OR DDDCSE = '14'
     C                   EVAL      DCAB = RBranch
     C                   ENDIF
 
     C                   ENDIF
 
     C     DDDCSE        IFEQ      '05'
 
     C     DDDCAB        IFEQ      *BLANKS
      *
      ** Error 249
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAB'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0242'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCABOk
     C                   ELSE
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDDCAB        @DSNB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      **  Invalid Branch
      *
     C     @RTCD         IFNE      *BLANKS
      *
      ** Error 250
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAB'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0362'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCABOk
     C                   ELSE
 
     C                   MOVE      A8BRCD        DDDCAB
     C                   MOVE      DDDCAB        DCAB
 
     C                   END
 
     C                   END
     C                   END
     C                   END
      *
     C                   ELSE
      *
     C     DDDCAB        IFNE      *BLANKS
      *
      ** Error 240
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAB'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0240'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCABOk
     C                   END
 
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
 
      **--------------------------------------------------------------**
      **                                                              **
      ** This module should be called after the execution of the      **
      ** validation module for Charge Currency.  This module uses the **
      ** field OK indicator of the Charge Currency field which is set **
      ** on the said module.                                          **
      **                                                              **
      **--------------------------------------------------------------**
 
      ** Return Code Error Indicator
     C                   PARM                    RetCodeIn
 
      ** Received Parameters
      ** -------------------
 
      ** Screen fields
      ** Charge Code (2A)
      ** Charge Currency (3A)
      ** Charge Amount   (14A)
      ** Charge Settlement Method (2A)
      ** Charge Settlement Account (12A)
      ** Charge Settlement Branch (3A)
     C                   PARM                    DDDCHC
     C                   PARM                    DDDCCE
     C                   PARM                    DDDCHA
     C                   PARM                    DDDCSE
     C                   PARM                    DDDCAT
     C                   PARM                    DDDCAB
 
      ** Depot Movement details
 
      ** Depot Movement type (2A)
      ** Depot Movement Branch (used as default) (3A)
      ** Retail Account Branch Set in validation module for Settlement A/C.
     C                   PARM                    ACTNTP
     C                   PARM                    DPBA
     C                   PARM                    RBranch           3
 
      ** System input
 
      ** AutoCharge Indicator (1A)
      ** S01445 Indicator (1A)
      ** MultiBranch Indicator (1A)
     C                   PARM                    BVACOP
     C                   PARM                    S01445
     C                   PARM                    MBIN
 
      ** Returned parameters
      ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Charge Settlement Branch Ok Indicator
      ** Charge Settlement Branch (3A)
     C                   PARM                    DDDCABOk
     C                   PARM                    DCAB
 
 
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
