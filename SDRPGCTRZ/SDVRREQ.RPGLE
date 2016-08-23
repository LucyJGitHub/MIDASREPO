     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Repo Claims Required')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Security Customer Details Val.*
      *                                                               *
      *  SDVRREQ - Validate Repo Claims Required                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
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
      *  Last Amend No. BUG8799            Date 15Feb05               *
      *  Prev Amend No. CSE070  *CREATE    Date 15Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG8799- CSE070 field is not switchable & in wrong place     *
      *  CSE070 - Repo Coupon Claims Report                           *
      *                                                               *
      *****************************************************************
 
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      *
      ** VALIDATION
      *
     C                   EXSR      VRREQ
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDRREQOK      IFEQ      'N'
     C     DDCLASOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     VRREQ         BEGSR
 
      ** Default to 'N'                                                                      BUG8799
     C                   IF        DDRREQ = *BLANKS                                          BUG8799
     C                   Eval      DDRREQ = 'N'                                              BUG8799
     C                   EndIf                                                               BUG8799
 
     C                   SELECT
 
      ** Repo Claims Required must be 'Y' or 'N'
     C                   WHEN      DDRREQ <> 'Y' and DDRREQ <> 'N'
 
      ** Err: 'The Repo Claims Req is invalid'
     C                   Eval      DDRREQOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDRREQ    '
     C                   Eval      MsgIdXAr(Idx) = 'USR5720'
 
      ** When Repo Claims Required is 'Y'
     C                   WHEN      DDRREQ = 'Y'
 
      ** Classification must be 'X', 'E', 'C', 'M', or 'I'
     C                   IF        DDCLAS <> 'X' and DDCLAS <> 'E' and
     C                             DDCLAS <> 'C' and DDCLAS <> 'M' and
     C                             DDCLAS <> 'I'
     C
      ** Err: 'Customer Classification must be 'X', 'E', 'C', 'M', or 'I' '
     C**********         Eval      DDCLASOK = 'N'                                            BUG8799
     C                   Eval      DDRREQOK = 'N'                                            BUG8799
     C                   Eval      Idx = Idx + 1
     C**********         Eval      FldNamXAr(Idx) = 'DDCLAS    '                             BUG8799
     C                   Eval      FldNamXAr(Idx) = 'DDRREQ    '                             BUG8799
     C                   Eval      MsgIdXAr(Idx) = 'USR5721'
     C                   ENDIF
 
     C                   ENDSL
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Repo Claims Required
     C                   PARM                    DDRREQ            1
      *
      ** Classification
     C                   PARM                    DDCLAS            1
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Repo Claims Required - OK
     C                   PARM                    DDRREQOK          1
      *
      ** Classification - OK
     C                   PARM                    DDCLASOK          1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
