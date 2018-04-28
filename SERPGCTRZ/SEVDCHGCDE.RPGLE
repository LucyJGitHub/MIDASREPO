     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Charge Code')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEVDCHGCDE - Validate Charge Code field.                     *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Charge Code field.                                *
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
      *  Last Amend No. CAP087             Date 08Sep05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003 *CREATE     Date 24Apr98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      ** Array of error message IDs
      ** Array of error message data.
     D FldNamXAr       S             10A   DIM(XArrayMax)
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      **  External DS for charge type details
     D SECGT         E DS                  EXTNAME(SECGTD)
      ** DS for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
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
     D DDDCCEOK        S              1A
 
      ** System input
     D BVACOP          S              1A
     D S01445          S              1A
 
      *** Output ***
     D DCHC            S              2A
     D DDDCHCOk        S              1A
 
      ** Working Variables
      ** -----------------
 
     D @CCOM           S              2A
     D @CCY            S              3A
 
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
      ** Validate
      *
     C                   EXSR      DCHCV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDCHCOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return                                                             ------------------------
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DCHCV - Validation routine for Charge Code field.             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DCHCV         BEGSR
      *
      ** If Autocharge is switched on, and SAR 01445 is ON, validate
      *
     C     BVACOP        IFEQ      'Y'
     C     S01445        ANDEQ     'Y'
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
      ** Validate Charge Code (only if charge currency is valid)
      *
     C     DDDCCEOk      IFEQ      'Y'
 
     C     DDDCHC        IFEQ      *BLANKS
      *
      ** 241 Error
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCHC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0231'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCHCOk
 
     C                   ELSE
      *
     C                   CALLB     'AOCHGTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      DDDCCE        @CCY
     C                   PARM      DDDCHC        @CCOM
     C     SECGT         PARM      SECGT         DSFDY
      *
     C     @RTCD         IFNE      *BLANK
      *
      ** 242 Error
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCHC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0232'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCHCOk
     C                   ELSE
     C                   MOVE      DDDCHC        DCHC
     C                   END
 
     C                   END
     C                   END
      *
     C                   ELSE
      *
     C     DDDCHC        IFNE      *BLANKS
      *
      ** Error 240
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCHC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0233'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCHCOk
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
      ** Charge Currency indicator (1A)
     C                   PARM                    ACTNTP
     C                   PARM                    DDDCCEOK
 
      ** System input
      ** AutoCharge Indicator (1A)
      ** S01445 Indicator (1A)
     C                   PARM                    BVACOP
     C                   PARM                    S01445
 
      ** Returned parameters
      ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Charge Code Ok Indicator (1A)
      ** Charge Code (2A)
     C                   PARM                    DDDCHCOk
     C                   PARM                    DCHC
 
 
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
