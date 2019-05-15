     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Credit Card Dates')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Cheques and Cards details     *
      *                                 Validation                    *
      *                                                               *
      *  SDVCADT - Validate Credit Card Dates                         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, Cheques and Cards details amendments must not be    *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      ** Parameters
     D DATEN           S              6P 0
     D DATEA           S              6A
     D WWCAI1          S              5P 0
     D WWCAE1          S              5P 0
     D DDCANX          S              1A
     D DDCAIX          S              6A
     D DDCAEX          S              6A
     D FldNme1         S             10A
     D FldNme2         S             10A
     D DDCAIXOK        S              1A
     D DDCAEXOK        S              1A
     D CCCAIX          S              5P 0
     D CCCAEX          S              5P 0
 
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
 
      ** Validate issued date 1
      ** Mandatory entry
 
     C     DDCANX        IFNE      *BLANKS
 
     C     DDCAIX        IFNE      *BLANKS
 
      ** The date is invalid if the input date is not equal to a
      ** Numeric field transferred in an alphanumeric field
 
     C                   MOVE      DDCAIX        DATEN
     C                   MOVE      DATEN         DATEA
     C     DDCAIX        IFNE      DATEA
     C                   EVAL      DDCAIXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNme1
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1104'
     C                   ELSE
     C                   MOVE      DDCAIX        DateIn
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   PARM      'D'           DatFmt
     C                   PARM      *BLANKS       ErrorFlag
 
      ** Invalid date
      ** Invalid issued date 1
 
     C     ErrorFlag     IFEQ      'Y'
     C                   EVAL      DDCAIXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNme1
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1104'
     C                   ELSE
     C                   MOVE      DaynoOut      WWCAI1
     C                   MOVE      DaynoOut      CCCAIX
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate expiry date 1
      ** Mandatory entry
 
     C     DDCAEX        IFNE      *BLANKS
 
      ** The date is invalid if the input date is not equal to a
      ** numeric field transferred in an alphanumeric field
 
     C                   MOVE      DDCAEX        DATEN
     C                   MOVE      DATEN         DATEA
     C     DDCAEX        IFNE      DATEA
     C                   EVAL      DDCAEXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNme2
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1105'
     C                   ELSE
 
     C                   MOVE      DDCAEX        DateIn
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   PARM      'D'           DatFmt
     C                   PARM      *BLANKS       ErrorFlag
 
      ** Invalid date
      ** Invalid expiry date 1
 
     C     ErrorFlag     IFEQ      'Y'
     C                   EVAL      DDCAEXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNme2
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1105'
     C                   ELSE
     C                   MOVE      DaynoOut      WWCAE1
     C                   MOVE      DaynoOut      CCCAEX
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Expiry Date 1 must be superior than isseed date 1
 
     C     WWCAE1        IFLT      WWCAI1
     C                   EVAL      DDCAEXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNme2
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1106'
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
      ** Credit Card
     C                   PARM                    DDCANX
      ** Issued Date
     C                   PARM                    DDCAIX
      ** Expiry Date
     C                   PARM                    DDCAEX
      ** Field Name 1
     C                   PARM                    FldNme1
      ** Field Name 2
     C                   PARM                    FldNme2
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Issued Date - OK
     C                   PARM                    DDCAIXOK
      ** Expiry Date - OK
     C                   PARM                    DDCAEXOK
      ** Issued Date
     C                   PARM                    CCCAIX
      ** Expiry Date
     C                   PARM                    CCCAEX
 
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
