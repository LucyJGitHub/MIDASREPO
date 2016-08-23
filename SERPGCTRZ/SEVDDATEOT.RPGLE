     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate date out')
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SEVDDATEOT - This module validates the Date Out field.       *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Last Amend No. CSE015             Date 06Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP003  *CREATE    Date 22Apr98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSE015 - Forward Valued Depot Movements                      *
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
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
      ** Screen Inputs
     D DDDPID          S             10A
     D DDDPOD          S             10A
     D DDDPMD          S              6A
     D DDDPDO          S              6A
 
      ** ICD
      ** System Info
 
     D BFCLASOtDp      S              1A
     D BVBVP           S              3P 0
     D BVCCCY          S              3A
     D BVEUCY          S              3A
     D RUND            S              5P 0
     D BJDFIN          S              1A
 
      ** Security Details
     D MATY            S              5P 0
     D NMCY            S              3A
 
      ** Output(s)
      ** ---------
 
     D DPDO            S              5P 0
     D DDDPDOOk        S              1A
 
      ** Working variables
      ** -----------------
 
      ** Index for arrays of error message ids etc
      ** Index for arrays of warning message ids etc
 
     D Idx             S              3P 0
     D WIx             S              3P 0
 
      * Parameters for other modules
     D ZCCY            S              3A
     D ZDATE           S              6A
     D ZDAYNO          S              5P 0
     D ZIND            S              1A
     D ZLOC            S              3A
 
     D ErrorFlag       S              1A
     D DATEN           S              6P 0
     D DATEA           S              6A
     D WBKVP           S              5P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
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
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
     C                   Z-ADD     *ZEROS        DPDO
      *
      ** Validate Date Out field
      *
     C                   EXSR      DPDOV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDPDOOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      **  Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DPDOV - Validation Routine for the Out Date field             *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DPDOV         BEGSR
 
     C     DDDPDO        IFNE      *BLANKS
      *
      ** Allowed only if depot entered
      *
     C     DDDPOD        IFEQ      *BLANKS
      *
      ** Error 207
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0184'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPDOOk
     C                   ELSE
     C*
     C* must be a valid date (999999 allowed)
     C*
     C                   MOVE      DDDPDO        DATEN
     C                   MOVE      DATEN         DATEA
 
     C     DDDPDO        IFNE      DATEA
      *
      ** Error 208
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0185'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPDOOk
     C                   ELSE
 
     C     DDDPDO        IFEQ      '999999'
     C                   MOVE      DDDPDO        DPDO
     C                   ELSE
     C                   MOVE      DDDPDO        ZDATE
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
     C     ErrorFlag     IFEQ      'Y'
      *
      ** Error 208
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0185'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPDOOk
     C                   ELSE
 
     C                   Z-ADD     ZDAYNO        DPDO
      *
      ** If In Date not entered, must not be after rundate
      ** and Out Date must be entered
      *
     C     DDDPMD        IFEQ      *BLANKS
     C     DPDO          ANDGT     RUND
     C     CSE015        ANDEQ     'N'                                                        CSE015
      *
      ** Error 209
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0186'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPDOOk
     C                   END
      *
      ** If Date out GT run date AND NE 99999 -
      ** then date out must be LE maturity date
      *
     C     DPDO          IFGT      RUND
     C     DPDO          ANDNE     99999
 
     C     DPDO          IFGT      MATY
     C     MATY          ANDNE     *ZEROS
      *
      ** Error 209
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0333'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPDOOk
     C                   END
 
     C                   END
      *
      ** Must fall within back value period on TABTB36
      *
     C     RUND          SUB       BVBVP         WBKVP
 
     C     DPDO          IFLT      RUND
     C     DPDO          ANDLT     WBKVP
      *
      ** Error 232
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0334'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPDOOk
     C                   END
      *
      ** If In depot is Euroclear or Cedel, should not be a holiday in the
      ** clearing house currency
      *
      ** Euroclear
      *
     C     BFCLASOtDp    IFEQ      'E'
     C                   MOVEL     BVEUCY        ZCCY
     C                   MOVEL     DPDO          ZDAYNO
     C                   MOVEL     *BLANKS       ZLOC
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
 
     C     ZIND          IFEQ      'H'
      *
      ** Warning W03
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPDO'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0189'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPDOOk
     C                   END
 
     C                   ELSE
      *
      ** Cedel
      *
     C     BFCLASOtDp    IFEQ      'C'
     C                   MOVEL     BVCCCY        ZCCY
     C                   MOVEL     DPDO          ZDAYNO
     C                   MOVEL     *BLANKS       ZLOC
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
 
     C     ZIND          IFEQ      'H'
      *
      ** Warning W03
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPDO'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0189'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPDOOk
     C                   END
 
     C                   ELSE
      *
      ** If In depot is not Euroclear or Cedel, should not be a holiday in
      ** nominal currency
      *
     C                   MOVE      NMCY          ZCCY
     C                   MOVEL     DPDO          ZDAYNO
     C                   MOVEL     *BLANKS       ZLOC
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
 
     C     ZIND          IFEQ      'H'
      *
      ** Warning W03
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPDO'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0190'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPDOOk
     C                   END
 
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
 
     C                   ELSE
      *
      ** If no In depot, Out date can not be zero
      *
     C     DDDPID        IFEQ      *BLANKS
     C     DDDPDO        ANDEQ     *BLANKS
      *
      ** Error 209
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0186'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPDOOk
     C                   END
 
     C                   END
      *
      ** Date In can not equal date Out
      *
     C     DDDPMD        IFEQ      DDDPDO
     C     DDDPDO        ANDNE     *BLANKS
      *
      ** Error 210
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0187'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPDOOk
     C                   END
      *
      ** Depots can not both be same unless both dates have been entered
      *
     C     DDDPID        IFNE      *BLANKS
     C     DDDPOD        ANDNE     *BLANKS
 
     C     DDDPID        IFEQ      DDDPOD
 
     C     DDDPMD        IFEQ      *BLANKS
     C     DDDPDO        OREQ      *BLANKS
      *
      ** Error 211
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0188'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPDOOk
     C                   END
 
     C                   END
     C                   END
      *
      ** Both In and Out dates cannot be blank if both depots have been
      ** entered
      *
     C     DDDPID        IFNE      *BLANKS
     C     DDDPOD        ANDNE     *BLANKS
     C     DDDPMD        ANDEQ     *BLANKS
     C     DDDPDO        ANDEQ     *BLANKS
      *
      ** Error 210
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0187'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPDOOk
     C                   END
 
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
 
      * Return Code Error Indicator
 
     C                   PARM                    RetCodeIn
      ** Received Parameters
      ** -------------------
 
      ** Screen fields
      * Out Date (6A)
      * In Date (6A)
      * Out Depot (10A)
      * In Depot (10A)
     C                   PARM                    DDDPDO
     C                   PARM                    DDDPMD
     C                   PARM                    DDDPOD
     C                   PARM                    DDDPID
      ** Security Details
      * Maturity Date  (5P 0)
      * Nominal Currency  (3A)
     C                   PARM                    MATY
     C                   PARM                    NMCY
 
      ** Transaction Details
      * Out Depot Customer Classification (1A)
     C                   PARM                    BFCLASOtDp
 
      ** ICD
      ** System Details
 
      * Date format Indicator (1A)
      * Rundate (5P 0)
      * EuroClear currency Code (3A)
      * Cedel currency Code (3A)
      * Back value period (3P 0)
     C                   PARM                    BJDFIN
     C                   PARM                    RUND
     C                   PARM                    BVEUCY
     C                   PARM                    BVCCCY
     C                   PARM                    BVBVP
 
      ** Returned Parameters
      ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Out Date Ok Indicator (1A)
      ** Out Date (5P 0)
     C                   PARM                    DDDPDOOk
     C                   PARM                    DPDO
      *                                                                                       CSE015
      ** Check if switchable feature CSE015 is installed.                                     CSE015
      *                                                                                       CSE015
     C                   MOVE      'N'           CSE015            1                          CSE015
     C                   CALLB     'AOSARDR0'                                                 CSE015
     C                   PARM      *BLANKS       @RTCD                                        CSE015
     C                   PARM      '*VERIFY'     @OPTN                                        CSE015
     C                   PARM      'CSE015'      @SARD                                        CSE015
      *                                                                                       CSE015
      ** Database error                                                                       CSE015
      *                                                                                       CSE015
     C     @RTCD         IFNE      *BLANKS                                                    CSE015
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE015
     C                   MOVEL     'CSE015'      DBKEY                                        CSE015
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE015
     C                   MOVEL     '901'         DBASE                                        CSE015
     C                   EXSR      *PSSR                                                      CSE015
      *                                                                                       CSE015
     C                   ELSE                                                                 CSE015
     C     @RTCD         IFEQ      *BLANKS                                                    CSE015
     C                   MOVE      'Y'           CSE015                                       CSE015
     C                   ENDIF                                                                CSE015
     C                   ENDIF                                                                CSE015
 
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
