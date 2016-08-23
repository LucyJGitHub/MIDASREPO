     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Valuation Day in Month')                               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - valuation Day in Month        *
      *                                                               *
      *  SDVVLDM - Validate Valuation Day in Month                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *   /COPY, Customer Portfolio Management Details amendments     *
      *          must not be applied to this source.                  *
      *                                                               *
      *  Last Amend No. MD000091           Date 15May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
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
      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Err Code
     D WUERCD          S              1
      ** Define work field No of Decimals
     D WUDEC           S              1  0
      ** Define work field No of Digits
     D WUDIG           S              2  0
      **
     D PMVLDM          S              2S 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters
     D DDVLDM          S              2A
     D DDVLFQ          S              1A
     D DDVLDMOK        S              1A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
 
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
      ** Valuation Day in Month
      ** Valuation Frequency is Monthly
     C                   IF        DDVLFQ = 'M' OR
     C                             DDVLFQ = 'Q' OR
     C                             DDVLFQ = 'X' OR
     C                             DDVLFQ = 'Y'
      ** Valuation day in Month screen file field,
     C                   IF        DDVLDM <> *BLANK
     C                   EVAL      WUZASF = *BLANK
     C                   EVAL      WUZASF = DDVLDM
      ** Call ZALIGN & ZEDIT
      ** ZALIGN Screen Field - Standard Functions  *
     C                   EVAL      WUDEC = *ZERO
     C                   EVAL      WUDIG = 2
 
     C                   CALL      'ZALIGN'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUZASF        PARM                    WUZASF
     C                   PARM                    WUDEC
     C                   PARM                    WUDIG
     C     WUZAFF        PARM      *BLANK        WUZAFF
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occurred on CALL...'
     C                   EVAL      DDVLDMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDVLDM    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx) = 'ZALIGN'                                MD000091
     C                   EVAL      MsgDtaTmp = 'ZALIGN'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
 
      ** Return code is an Error
     C                   IF        W0RTN  = '*ERROR*'
     C                   EVAL      WUERCD = 'Y'
     C                   ELSE
 
     C                   EVAL      WUERCD = 'N'
      ** ZEDIT Screen Field - Standard Functions *
     C                   EVAL      WUDEC = *ZERO
 
     C                   CALL      'ZEDIT'                              90
     C     WUZASF        PARM                    WUZASF
     C                   PARM                    WUDEC
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occured on CALL...'
     C                   EVAL      DDVLDMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDVLDM    '
     C                   EVAL      MsgIdXAr(Idx) = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx) = 'ZEDIT'                                 MD000091
     C                   EVAL      MsgDtaTmp = 'ZEDIT'                                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
      ** End If for W0RTN If *error,
     C                   ENDIF
      ** Err Code is Error Found
     C                   IF        WUERCD =  'Y'
      ** Send message 'Valuation day must be num'
     C                   EVAL      DDVLDMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDVLDM    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR2380'
 
     C                   ELSE
 
     C                   MOVE      WUZAFF        PMVLDM
      ** Zalign Valuation Day in M - Portfolio Management Customer Dtls  *
     C                   MOVE      WUZASF        DDVLDM
      ** Valid range for 'Valuation day in month' is 1-30 inclusive.
      ** Valuation Day in Month is Valid Range
     C     PMVLDM        IFLT      01
     C     PMVLDM        ORGT      30
      ** Send message 'Valuation day invld range'
     C                   EVAL      DDVLDMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDVLDM    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR2381'
 
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      ** The Valuation Day is blank
     C                   EVAL       PMVLDM = *ZEROS
      ** End If for DDVLDM,
     C                   ENDIF
      ** End If for DDVLFQ,
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
      ** Valuation Day in Month
     C                   PARM                    DDVLDM
      ** Valuation Frequency
     C                   PARM                    DDVLFQ
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Valuation Day in Month - OK
     C                   PARM                    DDVLDMOK
      ** Return value valuation day in Month.
     C                   PARM                    PMVLDM
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
