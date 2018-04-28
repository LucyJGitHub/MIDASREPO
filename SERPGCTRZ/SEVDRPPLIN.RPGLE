     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Repo/Pledge Indicator')
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SEVDRPPLIN - This module validates the Repo/Pledge Indicator *
      *               field.                                          *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said field. This routine has been retrieved  *
      *  from SE0070 and has been converted to ILE RPG and copied into*
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
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
      *  Last Amend No. CAP087             Date 05Sep05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP003  *CREATE    Date 23Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP087 - Depot Movement - Java Wrapper in MidasPlus.         *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
      ** Screen fields
     D DDRPIN          S              1A
     D DDDPID          S             10A
     D DDDPOD          S             10A
     D DDDPMD          S              6A
     D DDDPDO          S              6A
 
      ** Output fields
      ** -------------
 
     D DDRPINOk        S              1A
     D RPIN            S              1A
 
     ** ICD
     ** System Info
 
      * Deal Present Indicator
     D DealPreInd      S              1A
 
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
 
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
     C                   MOVE      *BLANK        RPIN
      *
      ** Validate
      *
     C                   EXSR      RPINV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDRPINOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
     C*
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RPINV - Validation Routine for Repo/Pledge indicator          *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RPINV         BEGSR
      *
      ** Dealing Module present
      *
     C     DealPreInd    IFEQ      'Y'
      *
      ** If entered must be 'R' or 'P'.
      *
     C     DDRPIN        IFNE      *BLANKS
 
     C     DDRPIN        IFNE      'P'
     C     DDRPIN        ANDNE     'R'
     C     DDRPIN        ANDNE     'B'                                                        CAP087
      *
      ** Error 221
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPIN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0202'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDRPINOk
     C                   ELSE
      *
      ** Update field
      *
     C                   MOVEL     DDRPIN        RPIN
     C                   END
      *
      ** If entered, both dates and both depots must be entered.
      *
     C     DDDPID        IFEQ      *BLANKS
     C     DDDPMD        OREQ      *BLANKS
     C     DDDPOD        OREQ      *BLANKS
     C     DDDPDO        OREQ      *BLANKS
      *
      ** Error 221
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPIN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0203'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDRPINOk
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
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
      ** Received Parameters
      ** -------------------
 
      ** Screen Fields
 
      ** Repo/Pledge Indicator (1A)
      ** In Date (6A)
      ** Out Date (6A)
      ** In Depot (10A)
      ** Out Depot (10A)
     C                   PARM                    DDRPIN
     C                   PARM                    DDDPMD
     C                   PARM                    DDDPDO
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
 
      ** System Info
      *  Dealing Module Present Indicator (1A)
     C                   PARM                    DealPreInd
 
     ** Returned Parameters
     ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      * Repo/Pledge Ok Indicator (1A)
      * Repo/Pledge Indicator (1A)
     C                   PARM                    DDRPINOk
     C                   PARM                    RPIN
 
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
