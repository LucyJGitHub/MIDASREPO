     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Cheque Number Issue Dates')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Cheques and Cards details     *
      *                                 Validation                    *
      *                                                               *
      *  SDVCQI - Validate Cheque Number Issue Dates                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    /COPY, Cheques and Cards details amendments must not be    *
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
 
      ** Parameters for ZDATE1
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D DatFmt          S              1A
     D ErrorFlag       S              1A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Work Variables
     D DATEN           S              6P 0
     D DATEA           S              6A
     D DDCQFX          S             10A
     D DDCQTX          S             10A
     D DDCQIX          S              6A
     D FldName         S             10A
     D DDCQIXOK        S              1A
     D CCCQIX          S              5P 0
 
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
      ** Validate Issued Date
      ** Mandatory entry
 
     C     DDCQFX        IFNE      *BLANKS
     C     DDCQTX        ANDNE     *BLANKS
 
     C     DDCQIX        IFNE      *BLANKS
 
      **   The date is invalid if the input date is not equal to a
      **   Numeric field transferred in an alphanumeric field
 
     C                   MOVE      DDCQIX        DATEN
     C                   MOVE      DATEN         DATEA
     C     DDCQIX        IFNE      DATEA
     C                   EVAL      DDCQIXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldName
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1104'
     C                   ELSE
     C                   MOVE      DDCQIX        DateIn
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   PARM      'D'           DatFmt
     C                   PARM      *BLANKS       ErrorFlag
 
      ** Invalid date
      ** Invalid issued date 1
 
     C     ErrorFlag     IFEQ      'Y'
     C                   EVAL      DDCQIXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldName
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1104'
     C                   ELSE
     C                   MOVE      DaynoOut      CCCQIX
     C                   ENDIF
 
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
      ** Cheque Number From
     C                   PARM                    DDCQFX
      ** Cheque Number To
     C                   PARM                    DDCQTX
      ** Cheque Number Issue Date
     C                   PARM                    DDCQIX
      ** Field Name
     C                   PARM                    FldName
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Cheque Number Issue Date-      OK
     C                   PARM                    DDCQIXOK
      ** Cheque Number Issue Date
     C                   PARM                    CCCQIX
 
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
