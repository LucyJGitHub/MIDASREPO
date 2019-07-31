     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Charge Amount')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEVDCHGAMT - Validate Charge Amount field.                   *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Charge Amount field.                              *
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
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10469           Date 15Mar06               *
      *                 CAP087             Date 08Sep05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003 *CREATE     Date 24Apr98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
      ** Array of error message IDs
      ** Array of error message data.
     D FldNamXAr       S             10A   DIM(XArrayMax)
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
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
     D A6NBDP          S              1S 0
 
      *** Output ***
     D DCHA            S             13P 0
     D DDDCHAOk        S              1A
 
      ** Working Variables
      ** -----------------
 
     D ZAlignOk        S              1A
     D ZADIG           S              2P 0
     D ZADEC           S              1P 0
     D ZFIELD          S             16A
 
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
     C                   Z-ADD     0             DCHA
      *
      ** Validate
      *
     C                   EXSR      DCHAV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDCHAOK      IFEQ      'N'
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
      * DCHAV - Validation routine for Charge Amount entry            *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DCHAV         BEGSR
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
      ** Validate Charge Amount (only if currency is valid)
      *
     C     DDDCCEOk      IFEQ      'Y'
 
     C     DDDCHA        IFEQ      *BLANKS
      *
      ** Error 245
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCHA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0237'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCHAOk
     C                   Z-ADD     *ZEROS        DCHA
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDDCHA        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     13            SUB       A6NBDP        ZADIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZALIGNok      IFEQ      'N'
      *
      ** Error 246
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCHA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0371'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCHAOk
     C                   Z-ADD     *ZEROS        DCHA
     C                   ELSE
 
     C                   MOVE      ZFIELD        DCHA
      *
     C     DCHA          IFEQ      *ZEROS
      *
      ** Error 246
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCHA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0371'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCHAOk
     C                   END
 
     C                   END
     C                   END
 
     C                   END
      *
     C                   ELSE
      *
     C     DDDCHA        IFNE      *BLANKS
      *
      ** Error 240
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCHA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0336'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCHAOk
     C                   Z-ADD     *ZEROS        DCHA
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
      ** Currency Number of Decimal Places  <from SDCURR> (1S 0)
     C                   PARM                    BVACOP
     C                   PARM                    S01445
     C                   PARM                    A6NBDP
 
      ** Returned parameters
      ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Charge Amount Ok Indicator (1A)
      ** Charge Amount (13P 0)
     C                   PARM                    DDDCHAOk
     C                   PARM                    DCHA
 
 
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
(c) Finastra International Limited 2001
