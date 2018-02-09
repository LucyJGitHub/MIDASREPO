     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Basel II Past Due Customer')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVPDCU  - Validate Basel II Past Due Customer               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 263079             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  263079 - Allow blank, Y and N to be accepted.                *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
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
     D DDPDCU          S              1
     D DDPDCUOK        S              1
 
      ** Index for arrays of error message IDs, etc.
     D Idx             S              3P 0
 
      ** Index for arrays of warning message IDs, etc.
     D WIx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialise parameters
 
     C                   MOVE      *BLANKS       RetCodeIn
     C                   MOVE      *BLANKS       FldNamXAr
     C                   MOVE      *BLANKS       MsgIDXAr
     C                   MOVE      *BLANKS       MsgDtaXAr
     C                   MOVE      *BLANKS       WFldNmXAr
     C                   MOVE      *BLANKS       WMsgIDXAr
     C                   MOVE      *BLANKS       WMsgDtXAr
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIx
 
      ** Validate 'Basel II Past Due Customer'.
 
     C                   EXSR      SR_PDCU
 
      ** If an error has occurred, set the Return Code.
 
     C     DDPDCUOK      IFEQ      'N'
     C                   EVAL      RetCodeIn  = 'Error'
     C                   ENDIF
 
 
      ** Return to calling program
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_PDCU - Validate Basel II Past Due Customer                 *
      *                                                               *
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SR_PDCU       BEGSR
 
     C**********         IF        DDPDCU      = *BLANK                                       263079
     C**********         EVAL      DDPDCU      = 'N'                                          263079
     C**********         ENDIF                                                                263079
 
     C     DDPDCU        IFNE      'Y'
     C     DDPDCU        ANDNE     'N'
     C     DDPDCU        ANDNE     *BLANK                                                     263079
     C                   MOVE      'N'           DDPDCUOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPDCU'      FldNamXAr(Idx)
     C                   MOVEL     'USR5441'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR  - Program Initialisation routine                      *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** Received Parameters
      ** -------------------
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Basel II Past Due Customer (1A)
 
     C                   PARM                    DDPDCU
 
      ** Returned Parameters
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Other parms
 
      ** Basel II Past Due Customer - OK
 
     C                   PARM                    DDPDCUOK
 
      ** Program, module and procedure names for database error process
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2012
