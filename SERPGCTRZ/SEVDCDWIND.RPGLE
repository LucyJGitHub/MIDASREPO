     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Customer Delivery/Withdrawal In')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEVDCDWIND - Validate Customer Delivery/Withdrawal Indicator *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Customer Delivery/Withdrawal Indicator. This      *
      *             validation process is only performed if the       *
      *             Portfolio Management Module is switched on.       *
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
      *  Component of: SE0070- Depot Movement Maintenance.            *
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
      *  Prev Amend No. CAP087             Date 12Sep05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003 *C *CREATE  Date 22Apr98               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
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
 
     ** Screen Fields
 
     D DDCWDI          S              1A
 
     ** System/Transaction Details
 
     D BFCLASCus       S              1A
     D PortPreIn       S              1A
     D PortCusInd      S              1A
 
      ** Working fields
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Output
      ** ------
 
     D DDCWDIOk        S              1A
     D CWDI            S              1A
 
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
 
     C                   MOVE      *BLANK        CWDI
      *
      ** Validation
      *
     C                   EXSR      CWDIV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCWDIOK      IFEQ      'N'
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
      * CWDIV - Customer Withdrawal/Delivery Indicator                *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     CWDIV         BEGSR
 
     C     PortPreIn     IFEQ      'Y'
      *
      ** Validate 'CUSTOMER WITHDRAWAL / DELIVERY INDICATOR'
      ** Default to Yes
      ** If Customer is Safe Custody or Discretionary
      *
     C     DDCWDI        IFEQ      *BLANKS
     C     PortCusInd    ANDEQ     'Y'
 
     C     BFCLASCus     IFEQ      'D'
     C     BFCLASCus     OREQ      'S'
     C                   MOVEL     'Y'           DDCWDI
     C                   END
 
     C                   END
 
     C     PortCusInd    IFEQ      'Y'
      *
      ** Mandatory Entry Y, or N,
      *
     C     DDCWDI        IFNE      'Y'
     C     DDCWDI        ANDNE     'N'
      *
      ** Error 242
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDCWDI'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0225'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDCWDIOK
     C                   END
 
     C                   ELSE
 
     C     DDCWDI        IFNE      *BLANKS
      *
      ** Error 242
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDCWDI'      FldNamXAr(Idx)
      * Display more appropriate error message.                                               CAP087
     C*******************MOVEL     'MMA0225'     MsgIdXAr(Idx)                                CAP087
     C                   MOVEL     'MMA2045'     MsgIdXAr(Idx)                                CAP087
     C                   MOVE      'N'           DDCWDIOK
     C                   END
 
     C                   END
      *
      ** May only Enter 'Y' if Customer is Safe Custody or Discretionary
      *
     C     DDCWDI        IFEQ      'Y'
 
     C     BFCLASCus     IFNE      'D'
     C     BFCLASCus     ANDNE     'S'
      *
      ** Error 242
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDCWDI'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0225'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDCWDIOK
     C                   END
 
     C                   END
 
     C     DDCWDIOK      IFNE      'N'
     C                   MOVEL     DDCWDI        CWDI
     C                   ENDIF
 
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
 
      ** Return Code Error Indicator
     C                   PARM                    RetCodeIn
 
      ** Received Parameters
      ** -------------------
 
      ** Screen Inputs
      *  Customer Withdrawal/Delivery indicator (1A)
     C                   PARM                    DDCWDI
 
      ** ICD
      ** System Information
      *  Portfolio module indicator (Y)
     C                   PARM                    PortPreIn
 
      ** Transaction Details
      *  Customer Classification (1A)
      *  Portfolio Customer Indicator (1A)
     C                   PARM                    BFCLASCus
     C                   PARM                    PortCusInd
 
      ** Returned parameters
      ** -------------------
 
     ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Customer Withdrawal/Delivery Ok indicator (1A)
      ** Customer Withdrawal/Delivery Indicator (1A)
 
     C                   PARM                    DDCWDIOk
     C                   PARM                    CWDI
 
 
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
