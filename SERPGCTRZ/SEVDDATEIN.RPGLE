     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate date in')
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SEVDDATEIN - This module validates the Date In field.        *
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
      *  Prev Amend No. CAP003  *CREATE    Date 23Feb98               *
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
 
     ** Screen Inputs
     D DDDPID          S             10A
     D DDDPOD          S             10A
     D DDDPMD          S              6A
 
     D BFCLASInDp      S              1A
 
     ** ICD
     ** System Input
 
     D BVBVP           S              3P 0
     D BVCCCY          S              3A
     D BVEUCY          S              3A
     D RUND            S              5P 0
     D BJDFIN          S              1A
 
 
      ** Security Details
 
     D MATY            S              5P 0
     D NMCY            S              3A
 
      ** Output
     D DDDPMDOk        S              1A
     D DPMD            S              5P 0
 
      ** Working Variables
 
     D ZCCY            S              3A
     D ZDATE           S              6A
     D ZDAYNO          S              5P 0
     D ZIND            S              1A
     D ZLOC            S              3A
     D ErrorFlag       S              1A
     D DATEN           S              6P 0
     D DATEA           S              6A
     D WBKVP           S              5P 0
 
      ** Index for arrays of error message ids etc
      ** Index for arrays of warning message ids etc
 
     D Idx             S              3P 0
     D WIx             S              3P 0
 
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
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
     C                   Z-ADD     *ZEROS        DPMD
      *
      ** VALIDATION
      *
     C                   EXSR      DPMDV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDPMDOK      IFEQ      'N'
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
      * DPMDV - Validation routine for Date In field                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DPMDV         BEGSR
 
     C     DDDPMD        IFNE      *BLANKS
      *
      ** Prohibited if depot not entered
      *
     C     DDDPID        IFEQ      *BLANKS
      *
      ** Error 202
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPMD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0177'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPMDOk
     C                   ELSE
      *
      ** must be a valid date (999999 allowed)
      *
     C                   MOVE      DDDPMD        DATEN
     C                   MOVE      DATEN         DATEA
 
     C     DDDPMD        IFNE      DATEA
      *
      ** Error 203
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPMD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0178'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPMDOk
     C                   ELSE
 
     C     DDDPMD        IFEQ      '999999'
     C                   MOVE      DDDPMD        DPMD
     C                   ELSE
     C                   MOVE      DDDPMD        ZDATE
     C*
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
     C     ErrorFlag     IFEQ      'Y'
      *
      ** Error 203
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPMD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0178'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPMDOk
     C                   ELSE
      *
      ** Update field
      *
     C                   Z-ADD     ZDAYNO        DPMD
      *
      ** If Out depot not entered, must not be after run date
      *
     C     DDDPOD        IFEQ      *BLANKS
      *
      ** Error 204
      *
     C     DPMD          ANDGT     RUND
     C     CSE015        ANDEQ     'N'                                                        CSE015
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPMD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0179'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPMDOk
     C                   END
      *
      **   If Date in GT run date AND NE 99999 -
      **   then date in must be LE maturity date
      *
     C     DPMD          IFGT      RUND
     C     DPMD          ANDNE     99999
 
     C     DPMD          IFGT      MATY
     C     MATY          ANDNE     *ZEROS
      *
      ** Error 229
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPMD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0180'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPMDOk
     C                   END
 
     C                   END
      *
      **    must fall within back value period on TABTB36
      *
     C     RUND          SUB       BVBVP         WBKVP
 
     C     DPMD          IFLT      RUND
     C     DPMD          ANDLT     WBKVP
      *
      ** Error 232
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPMD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0181'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPMDOk
     C                   END
      *
      ** If In depot is Euroclear or Cedel, should not be a holiday in the
      ** clearing house currency
      ** Euroclear
      *
     C     BFCLASInDp    IFEQ      'E'
     C                   MOVEL     BVEUCY        ZCCY
     C                   MOVEL     DPMD          ZDAYNO
     C                   MOVEL     *BLANKS       ZLOC
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
     C*
     C     ZIND          IFEQ      'H'
      *
      ** Warning W01
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPMD'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0182'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPMDOk
     C                   END
 
     C                   ELSE
      *
      ** Cedel
      *
     C     BFCLASInDp    IFEQ      'C'
     C                   MOVEL     BVCCCY        ZCCY
     C                   MOVEL     DPMD          ZDAYNO
     C                   MOVEL     *BLANKS       ZLOC
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
     C*
     C     ZIND          IFEQ      'H'
      *
      ** Warning W01
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPMD'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0182'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPMDOk
     C                   END
 
     C                   ELSE
      *
      ** If In depot is not Euroclear or Cedel, should not be a holiday in
      ** nominal currency
      *
     C                   MOVE      NMCY          ZCCY
     C                   MOVEL     DPMD          ZDAYNO
     C                   MOVEL     *BLANKS       ZLOC
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
     C*
     C     ZIND          IFEQ      'H'
      *
      ** Warning W02
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPMD'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0183'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPMDOk
     C                   END
 
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ELSE
      *
      ** No date entered - error if In Depot present
      *
     C     DDDPID        IFNE      *BLANKS
      *
      ** Error 202
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPMD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0177'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPMDOk
     C                   END
 
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
 
      ** Return Code error indicator (1A)
     C                   PARM                    RetCodeIn
      ** Received Parameters
      ** -------------------
 
      ** Screen fields
      * Date In (6A)
      * In Depot (10A)
      * Out Depot (10A)
     C                   PARM                    DDDPMD
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
 
      ** Security Details
      *  Maturity Date (5P 0)
      *  Nominal Currency (3A)
     C                   PARM                    MATY
     C                   PARM                    NMCY
 
      ** Transaction Details
      ** In Depot Customer Classification  (1A)
     C                   PARM                    BFCLASInDp
 
      ** ICD Info
      ** System details
 
      * Date Format (1A)
      * Run Date (5P 0)
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
      *
      ** In Date Ok Indicator (1A)
      ** In Date (5P 0)
     C                   PARM                    DDDPMDOk
     C                   PARM                    DPMD
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
