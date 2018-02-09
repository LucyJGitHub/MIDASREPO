     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Revaluation Base Day')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Validate Revaluation Base Day *
      *                                                               *
      *                                                               *
      *  SDVRVBD - Validate Revaluation Base Day                      *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  /COPY, Customer Future and Options Details amendments must   *
      *  not be applied to this source.                               *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 15May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
      ** Define work field Err Code
     D WUERCD          S              1
      ** Define work field ZALIGN No Of Decimals
     D WUZAND          S             10
      ** Define work field for return code
     D W0RTN           S              7
      ** Work Field number of Decimal,
     D WUDEC           S              1  0
      ** Work field number of Digits
     D WUDIG           S              2  0
      ** Return Value, Revaluation Base Day,
     D FORVBD          S              2S 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters
     D DDRVBD          S              2A
     D DDRVFQ          S              1A
     D DDRVBDOK        S              1A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
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
      ** Validate Revaluation Day in Month(Base Day only)
      ** Revaluation Frequency is equal to M,T,Q,X,Y
     C                   IF        DDRVFQ = 'T' OR
     C                             DDRVFQ = 'M' OR
     C                             DDRVFQ = 'Q' OR
     C                             DDRVFQ = 'X' OR
     C                             DDRVFQ = 'Y'
      ** Revaluation Base Day Screen field is Not Blank
     C                   IF        DDRVBD <> *BLANK
     C                   EVAL      WUZASF = *BLANK
     C                   EVAL      WUZASF = DDRVBD
      ** Call ZALIGN & ZEDIT
      ** ZALIGN Screen Field - Standard Functions  *
     C                   EVAL       WUDEC = *ZERO
     C                   EVAL       WUDIG = 2
 
     C                   CALL      'ZALIGN'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUZASF        PARM                    WUZASF
     C                   PARM                    WUDEC
     C                   PARM                    WUDIG
     C     WUZAFF        PARM      *BLANK        WUZAFF
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occured on CALL...'
     C                   EVAL      DDRVBDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRVBD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx) = 'ZALIGN'                                MD000091
     C                   EVAL      MsgDtaTmp = 'ZALIGN'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
 
      ** Return code is Old Table Error
     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      WUERCD = 'Y'
     C                   ELSE
      ** Otherwise
     C                   EVAL      WUERCD = 'N'
      ** ZEDIT Screen Field - Standard Functions  *
     C                   EVAL      WUDEC = *ZERO
 
     C                   CALL      'ZEDIT'                              90
     C     WUZASF        PARM                    WUZASF
     C                   PARM                    WUDEC
 
     C                   IF          *IN90 = *ON
      ** Send message '*Error occured on CALL...'
     C                   EVAL        DDRVBDOK = 'N'
     C                   EVAL        Idx = Idx + 1
     C                   EVAL        FldNamXAr(Idx) = 'DDRVBD    '
     C                   EVAL        MsgIdXAr(Idx)  = 'Y2U0032'
     C                   EVAL        MsgDtaXAr(Idx) = 'ZEDIT'
     C                   ENDIF
 
     C                   ENDIF
      ** WRK.Err Code is Error Found
     C                   IF         WUERCD  = 'Y'
      ** Send message 'Revaluation Day Numeric'
     C                   EVAL      DDRVBDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRVBD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1188'
 
     C                   ELSE
      ** Otherwise
      ** Move Revaluation Base Day - Futures & Options Clients  *
      ** ZALIGN Revaluation Base Day Screen
     C                   MOVE      WUZASF        DDRVBD
     C                   MOVE      WUZAFF        FORVBD
      ** Revaluation Base Day is Valid Range
     C     FORVBD        IFLT      01
     C     FORVBD        ORGT      31
      ** Otherwise
      ** Send message 'Not within valid range 2'
     C                   EVAL        DDRVBDOK = 'N'
     C                   EVAL        Idx = Idx + 1
     C                   EVAL        FldNamXAr(Idx) = 'DDRVBD    '
     C                   EVAL        MsgIdXAr(Idx)  = 'USR0309'
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
      ** Otherwise
      ** Send message 'Not within valid range 2'
     C                   EVAL      DDRVBDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRVBD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0309'
 
     C                   ENDIF
     C                   ELSE
      ** Otherwise
      ** Revaluation Base Day Scrn is Not Blank
     C                   IF        DDRVBD <> *BLANK
      ** Send message 'Rev. base day must be 0'
     C                   EVAL      DDRVBDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRVBD    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0310'
 
     C                   ELSE
      ** Otherwise
     C                   EVAL      FORVBD = *ZERO
 
     C                   ENDIF
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
      ** Revaluation Base Day,
     C                   PARM                    DDRVBD
      ** Revaluation Frequency,
     C                   PARM                    DDRVFQ
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Revaluation Base Day - OK
     C                   PARM                    DDRVBDOK
      ** Return Value, Revaluation Base Day,
     C                   PARM                    FORVBD
 
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
(c) Finastra International Limited 2006
