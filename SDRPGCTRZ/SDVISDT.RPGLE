     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Document Issuing Date')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVISDT - Validate Issuing Date                              *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
     C                   IF        DDISDT = *BLANKS
     C                   EVAL      DVISDT = *ZERO
     C                   ELSE
 
      ** Issuing date must be a valid date
 
     C                   TESTN                   DDISDT               98
     C                   IF        *IN98 = *OFF
     C                   EVAL      DDISDTOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDISDT    '
     C                   EVAL      MsgIdXAr(Idx) = 'USS0408'
     C                   ELSE
 
      ** The Issuing Date must be a valid date
 
     C                   EVAL      ZDATEA = DDISDT
     C                   EXSR      ZDATE1
     C                   IF        ErrorFlag  = 'Y'
     C                   EVAL      DDISDTOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDISDT    '
     C                   EVAL      MsgIdXAr(Idx) = 'USS0408'
     C                   ELSE
 
      ** The Issuing Date must be less than or equal to the current
      ** run date
 
     C                   IF        ZDAYNO > DRUND
     C                   EVAL      DDISDTOK = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDISDT    '
     C                   EVAL      MsgIdXAr(Idx) = 'USS0409'
     C                   ELSE
     C                   Z-ADD     ZDAYNO        DVISDT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
 
     C     DDISDTOK      IFEQ      'N'
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
      ** Private Banking Start Date - alpha
     C                   PARM                    DDISDT            6
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
      ** Valid Issuing Date - OK
     C                   PARM                    DDISDTOK          1
     C                   PARM                    DVISDT            5 0
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
**  CPY@
(c) Finastra International Limited 2013
