     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Day in Month for Statement')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Validate Day in Month for     *
      *                                 Statement                     *
      *  SDVDMFS - Validate Day in Month for Statement                *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, Customer Future and Options Details amendments must *
      *           not be applied to this source.                      *
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
      ** ZALIGN Screen Field
     D WUZASF          S             16A
      ** ZALIGN File Field
     D WUZAFF          S             16A
      ** Work variable Return Code
     D W0RTN           S              7A
      ** Work variable Error Code
     D WUERCD          S              1A
      ** Work field no of Decimals
     D WUDEC           S              1  0
      ** Work field no of Digits
     D WUDIG           S              2  0
      ** Return Value, Validate Day In Month for Statement
     D FODMFS          S              2S 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Work Variables
     D DDDMFS          S              2A
     D DDSTFQ          S              1A
     D DDDMFSOK        S              1A
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
 
      ** Validate Day in Month for Statement
      ** Statement frequency is equal to M,T,Q,X,Y
     C                   IF        DDSTFQ = 'T' OR
     C                             DDSTFQ = 'M' OR
     C                             DDSTFQ = 'Q' OR
     C                             DDSTFQ = 'X' OR
     C                             DDSTFQ = 'Y'
      ** Statement Base Day Screen field is Not Blank
     C                   IF        DDDMFS <> *BLANK
     C                   EVAL      WUZASF = *BLANK
     C                   EVAL      WUZASF = DDDMFS
      ** Call ZALIGN & ZEDIT
      ** ZALIGN Screen Field - Standard Functions
     C                   EVAL      WUDEC = *ZERO
     C                   EVAL      WUDIG =  2
 
     C                   CALL      'ZALIGN'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUZASF        PARM                    WUZASF
     C                   PARM                    WUDEC
     C                   PARM                    WUDIG
     C     WUZAFF        PARM      *BLANK        WUZAFF
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occurred on CALL...'
     C                   EVAL      DDDMFSOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDMFS    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx) = 'ZALIGN'                                MD000091
     C                   EVAL      MsgDtaTmp = 'ZALIGN'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
      ** Return code (*Error)
     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      WUERCD = 'Y'
     C                   ELSE
 
     C                   EVAL      WUERCD = 'N'
 
      ** ZEDIT Screen Field - Standard Functions
     C                   EVAL      WUDEC = *ZERO
 
     C                   CALL      'ZEDIT'                              90
     C     WUZASF        PARM                    WUZASF
     C                   PARM                    WUDEC
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occured on CALL...'
     C                   EVAL      DDDMFSOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDMFS    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx) = 'ZEDIT'                                 MD000091
     C                   EVAL      MsgDtaTmp = 'ZEDIT'                                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
 
     C                   ENDIF
      ** End If for '*ERROR*'
     C                   ENDIF
     C
 
      ** WRK.Err Code is Error Found
     C                   IF        WUERCD  = 'Y'
      ** Send message 'Statement Base Day Numeric'
     C                   EVAL      DDDMFSOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDMFS    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1187'
     C                   ELSE
      ** Otherwise
     C                   MOVE      WUZAFF        FODMFS
 
      ** Move Statement Base Day - Futures & Options Clients
      ** ZALIGN Statement Base Day Screen
     C                   MOVE      WUZASF        DDDMFS
      ** Day in month for statement is Valid Range
     C     FODMFS        IFLT      01
     C     FODMFS        ORGT      31
      ** Send message 'Not within valid range'
     C                   EVAL      DDDMFSOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDMFS    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0306'
 
     C                   ENDIF
      ** End If for WUERCD
     C                   ENDIF
 
     C                   ELSE
      ** Send message 'Not within valid range'
     C                   EVAL      DDDMFSOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDMFS    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0306'
 
     C                   ENDIF
 
     C                   ELSE
      ** OTHERWISE
      ** Statement Base Day Screen field is Not Blank
     C                   IF        DDDMFS <> *BLANK
      ** Send message 'St. base day must be zero'
     C                   EVAL      DDDMFSOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDMFS    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0307'
 
     C                   ELSE
 
     C                   EVAL      FODMFS = *ZERO
      ** End If for DDDMFS
     C                   ENDIF
      ** End If for DDSTFQ
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
      ** Day in month for statement,
     C                   PARM                    DDDMFS
      ** Statement Frequency
     C                   PARM                    DDSTFQ
      ** Outputs
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Day in Month for Statement - OK
 
     C                   PARM                    DDDMFSOK
      ** Return Value, Validate Day In Month for Statement
     C                   PARM                    FODMFS
 
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
