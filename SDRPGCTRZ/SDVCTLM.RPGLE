     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Contract Limit')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Contract limit                *
      *                                                               *
      *  SDVCTLM - Validate Contract limit                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *   /COPY, Customer Future and Options Details amendments must  *
      *   not be applied to this source.                              *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
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
      ** Define work field ZALIGN Screen Fun Field
     D WUZASF          S             16
      ** Define work field ZALIGN File Field
     D WUZAFF          S             16
      ** Define work field Err Code
     D WUERCD          S              1
      ** Define work field for return code
     D W0RTN           S              7
      ** Work field number of Decimal,
     D WUDEC           S              1  0
      ** Work field number of Digits,
     D WUDIG           S              2  0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Index for arrays of error message ids etc
     D DDCTLM          S              5A
     D DDCTLMOK        S              1A
     D FOCTLM          S              5P 0
 
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
     C                   Z-ADD     0             WIdx
 
      ** Validation
      ** Validate Contract limit
      ** Contract Limit Screen field is Not Blank
     C                   IF        DDCTLM <> *BLANK
     C                   EVAL      WUZASF = *BLANK
     C                   EVAL      WUZASF= DDCTLM
      ** Call ZALIGN & ZEDIT
      ** ZALIGN Screen Field - Standard Functions
 
     C                   EVAL      WUDEC = *ZERO
     C                   EVAL      WUDIG = 5
 
     C                   CALL      'ZALIGN'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUZASF        PARM                    WUZASF
     C                   PARM                    WUDEC
     C                   PARM                    WUDIG
     C     WUZAFF        PARM      *BLANK        WUZAFF
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occured on CALL...'
     C                   EVAL      DDCTLMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCTLM    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C                   EVAL      MsgDtaXAr(Idx) = 'ZALIGN'
     C                   ENDIF
 
      ** Return code is Old Table Error
     C                   IF         W0RTN = '*ERROR*'
     C                   EVAL       WUERCD = 'Y'
     C                   ELSE
 
     C                   EVAL        WUERCD = 'N'
      ** ZEDIT Screen Field - Standard Functions
     C                   EVAL       WUDEC = *ZERO
 
     C                   CALL      'ZEDIT'                              90
     C     WUZASF        PARM                    WUZASF
     C                   PARM                    WUDEC
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occured on CALL...'
     C                   EVAL      DDCTLMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCTLM    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C                   EVAL      MsgDtaXAr(Idx) = 'ZEDIT'
     C                   ENDIF
      ** EndIf for '*ERROR*'
     C                   ENDIF
      ** WRK.Err Code is Error Found
     C                   IF        WUERCD = 'Y'
      ** Send message 'Contract Limit 5 Numeric'
     C                   EVAL      DDCTLMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCTLM    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1186'
 
     C                   ELSE
      ** Move Contract Limit - Futures & Options Clients  *
      ** ZALIGN Contract Limit Screen
     C                   MOVE      WUZASF        DDCTLM
     C                   MOVE      WUZAFF        FOCTLM
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      FOCTLM = *ZERO
      ** EndIf for DDCTLM
     C                   ENDIF
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Field(s) requiring validation
      ** Contract Limit
     C                   PARM                    DDCTLM
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Contract limit - OK
 
     C                   PARM                    DDCTLMOK
      ** Return Value for Contract Limit,
     C                   PARM                    FOCTLM
 
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
