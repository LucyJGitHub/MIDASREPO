     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Net Notice Days')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - FX Netting details data       *
      *                                                               *
      *  SDVNTND - Validate Net Notice Days                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    /COPY, FX Netting Details amendments must not be           *
      *    applied to this source.                                    *
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
     D WUERCD          S              1
     D WUZASF          S             16
     D W0RTN           S              7
     D WUZAFF          S             16
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Net Notice Days
     D CUNTND          S              2S 0
 
      ** Index for arrays of error message ids etc
     D WQ0004          S              7A
     D WQ0005          S             16A
     D WQ0006          S              1P 0
     D WQ0007          S              2P 0
     D WQ0008          S             16A
     D WQ0009          S             16A
     D WQ0010          S              1P 0
     D DDNTND          S              2A
     D DDNET           S              1A
     D DDNTGP          S              4A
     D DDCUSN          S              6A
     D DDNTNDOK        S              1A
 
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
 
      ** Validate Net Notice Days
      ** DTL.Net Settlement is No
     C                   IF        DDNET = 'N'
     C                   EVAL      DDNTND = *BLANK
     C                   ENDIF
      ** DTL.Netting Group is Not Blank
     C                   IF        DDNTGP <> *BLANKS
 
     C                   IF        DDNTND <> *BLANKS AND
     C                             DDNTND <> '00'
     C                   EVAL      DDNTNDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNTND'
     C                   EVAL      MsgIdXAr(Idx) = 'USR3180'
     C                   ENDIF
 
     C                   ELSE
 
      ** DTL.Net Settlement is Yes
     C                   IF        DDNET = 'Y'
      ** DTL.Net Notice Days Screen fd is Not Blank
     C                   IF        DDNTND <> *BLANK
     C                   EVAL      WUZASF = DDNTND
      ** Call ZALIGN & ZEDIT
      ** ZALIGN Screen Field - Standard Functions
     C                   CALL      'ZALIGN'                             90
     C     W0RTN         PARM      *BLANKS       WQ0004
     C     WUZASF        PARM      WUZASF        WQ0005
     C                   PARM      *ZERO         WQ0006
     C                   PARM      2             WQ0007
     C     WUZAFF        PARM      *BLANK        WQ0008
 
     C                   IF        *IN90 = *ON  OR
     C                             W0RTN = '*ERROR*'
      ** Call to program ended in error
     C                   EVAL      WUERCD = 'Y'
     C                   ELSE
 
     C                   EVAL      WUERCD = 'N'
      ** ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90
     C     WUZASF        PARM      WUZASF        WQ0009
     C                   PARM      *ZERO         WQ0010
      **
     C                   IF        *IN90 = *ON
      ** Call to program ended in error
     C                   EVAL      WUERCD = 'Y'
     C                   ENDIF
 
     C                   ENDIF
      ** WRK.Err Code is Error Found
     C                   IF        WUERCD = 'Y'
     C                   EVAL      DDNTNDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNTND'
     C                   EVAL      MsgIdXAr(Idx) = 'USR3144'
     C                   ELSE
     C                   MOVE      WUZAFF        CUNTND
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DDNTND = *BLANKS OR
     C                             DDNTND = '00'
     C                   EVAL      CUNTND = *ZERO
     C                   ELSE
     C                   EVAL      DDNTNDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNTND'
     C                   EVAL      MsgIdXAr(Idx) = 'USR3145'
     C                   ENDIF
 
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
     C                   PARM                    DDNTND
     C                   PARM                    DDNET
     C                   PARM                    DDNTGP
     C                   PARM                    DDCUSN
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Net Notice Days -      OK
     C                   PARM                    DDNTNDOK
      ** Net Notice Days
     C                   PARM                    CUNTND
 
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
