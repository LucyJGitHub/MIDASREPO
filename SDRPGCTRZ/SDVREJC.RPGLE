     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Document Rejected Date')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVREJC - Validate Rejected Date                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSD093   *CREATE   Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD093 - Document Management                                 *
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
 
     C                   EVAL      RetCodeIn = *BLANK
 
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   Z-ADD     0             Idx
 
      ** Validation
 
     C                   IF        DDREJC = *BLANKS
 
      ** The Rejected Date must be input when Document Status is 'Rejected'
 
     C                   IF        DVSTCD = 'Z'
     C                   EVAL      DDREJCOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDREJC    '
     C                   EVAL      MsgIdXAr(Idx) = 'USS0423'
     C                   ELSE
     C                   Z-ADD     0             DVREJC
     C                   ENDIF
     C                   ELSE
 
      ** The Rejected Date must be a  valid date
 
     C                   TESTN                   DDREJC               98
     C                   IF        *IN98 = *OFF
     C                   EVAL      DDREJCOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDREJC    '
     C                   EVAL      MsgIdXAr(Idx) = 'USS0416'
     C                   ELSE
 
      ** The Rejected Date must be a valid date
 
     C                   EVAL      ZDATEA = DDREJC
     C                   EXSR      ZDATE1
 
     C                   IF        ErrorFlag  = 'Y'
     C                   EVAL      DDREJCOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDREJC    '
     C                   EVAL      MsgIdXAr(Idx) = 'USS0416'
     C                   ELSE
 
      ** The Rejected Date must be equal or lower than the run date
 
     C                   IF        ZDAYNO > DRUND
     C                   EVAL      DDREJCOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDREJC    '
     C                   EVAL      MsgIdXAr(Idx) = 'USS0417'
     C                   ELSE
     C                   Z-ADD     ZDAYNO        DVREJC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
 
     C     DDREJCOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      ** RETURN
 
     C                   RETURN
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE1 - Validate & convert date to a day number             *
      *                                                               *
      *****************************************************************
     C     ZDATE1        BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    DFIN
     C                   PARM                    ErrorFlag         1
 
     C                   ENDSR
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
      ** Rejected Date
     C                   PARM                    DDREJC            6
      *
      ** Document Status Code
     C                   PARM                    DVSTCD            1
      *
      ** MIDAS date format
     C                   PARM                    DRUND             5 0
     C                   PARM                    DFIN              1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Valid Requested Date - OK
     C                   PARM                    DDREJCOK          1
     C                   PARM                    DVREJC            5 0
      *
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
(c) Misys International Banking Systems Ltd. 2013
