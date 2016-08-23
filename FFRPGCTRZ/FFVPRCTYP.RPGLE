     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate instrument processing type')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVPRCTYP - Validate instrument processing type              *
      *                                                               *
      *  Function:  This module checks whether the instrument         *
      *             processing type field of an OTC transaction       *
      *             is a legitimate value.                            *
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
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CAP166             Date 15Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP004  *CREATE    Date 01Jun98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP166 - API for Non-Currency OTC                            *
      *  CAP004 - Conversion of Midas inputs to APIs.                 *
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
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** File version of processing type
     D ISPT            S              1S 0
 
      ** Transaction version of processing type
     D SISPT           S              1A
 
      ** Action code
     D SACTN           S              1A
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx; and to warning message handling: WarnFound,
      ** FldNamWArr, MsgIDWArr, MsgDtaWArr, WIdx.
      ** It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      **   - If insertion
     C     SACTN         IFEQ      'I'
 
      **   - Default Processing Type to 5
     C     SISPT         IFEQ      *BLANK
     C     TransType     ANDEQ     'OTCC'                                                     CAP166
     C                   MOVEL     '5'           SISPT
     C                   ENDIF
 
      *****-*Processing*Type*must*be*4,*5*or*6*****************************                   CAP166
     C*****SISPT         IFNE      '4'                                                        CAP166
     C*****SISPT         ANDNE     '5'                                                        CAP166
     C*****SISPT         ANDNE     '6'                                                        CAP166
     **********************************************************************                   CAP166
     C**********         EVAL      ErrorFound = 'Y'                                           CAP166
     C**********         EVAL      XIdx = XIdx + 1                                            CAP166
     C**********         EVAL      FldNamXArr(XIdx) = 'SISPT'                                 CAP166
     C**********         EVAL      MsgIDXArr(XIdx) = 'MMA0531'                                CAP166
                                                                                              CAP166
      ** Processing type must be 5 for OTCC and 4 or 6 for OTCO                               CAP166
                                                                                              CAP166
     C                   IF        TransType = 'OTCC' and SISPT <> '5'                        CAP166
     C                   EVAL      ErrorFound = 'Y'                                           CAP166
     C                   EVAL      XIdx = XIdx + 1                                            CAP166
     C                   EVAL      FldNamXArr(XIdx) = 'SISPT'                                 CAP166
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1223'                                CAP166
     C                   ELSE                                                                 CAP166
                                                                                              CAP166
     C                   IF        TransType = 'OTCO' and SISPT <> '4' and                    CAP166
     C                             SISPT <> '6'                                               CAP166
     C                   EVAL      ErrorFound = 'Y'                                           CAP166
     C                   EVAL      XIdx = XIdx + 1                                            CAP166
     C                   EVAL      FldNamXArr(XIdx) = 'SISPT'                                 CAP166
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1224'                                CAP166
     C                   ENDIF                                                                CAP166
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up the file version of the field, if no errors
     C                   IF        ErrorFound = 'N'
     C                   MOVE      SISPT         ISPT
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
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
      ** Outputs from this procedure
      ** ---------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Numeric (file) version of processing type (1,0S)
     C                   PARM                    ISPT
 
      ** Inputs to this procedure
      ** ------------------------
      ** Processing type (1A, from transaction)
     C                   PARM                    SISPT
      ** Action code (1A, from transaction)
     C                   PARM                    SACTN
      ** Transaction type                                                                     CAP166
     C                   PARM                    TransType                                    CAP166
 
 
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
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
