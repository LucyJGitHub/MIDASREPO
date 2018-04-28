     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Customer Reqd for Bundesbank Rpt')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVBEXT - SD Validate Customer Required for Bundesbank       *
      *              Reporting                                        *
      *                                                               *
      *  Function:  This module validates the field Customer Required *
      *             for Bundesbank Reporting                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. MK024991           Date 24Mar14               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG26637           Date 03Nov09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024991 - Error appears upon deleting customer.             *
      *           - Do not perform defaulting if action code is 'D'.  *
      *           - Do not perform validation if action code is 'D'.  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26637 - Unable to exit to the main screen                 *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  VALBEXT - Validate Customer Required for Bundesbank Reporting*
      *                                                               *
      *  *INZSR - Program initialisation routine                      *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      *
      ** The following /COPY line include (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line include the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D DDBEXT          S              1A
     D DDACTN          S              1A                                                    MD024991
     D OKBEXT          S              1A
     D CER045          S              1A
     D Idx             S              3P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *inzsr  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Validate Customer Required for Bundesbank Reporting
      *
     C                   EXSR      VALBEXT
      *
     C                   IF        OKBEXT = 'N'
      *
     C                   EVAL      RetCodeIn = 'ERROR'
      *
     C                   ENDIF
      *
      ** Return from Program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALBEXT - Validate Customer Required for Bundesbank Reporting*
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     VALBEXT       BEGSR
      *
     C                   IF        DDBEXT <> *BLANKS AND
     C                             DDBEXT <> 'Y'     AND
     C                             DDBEXT <> 'N'
      *
     C                   EVAL      OKBEXT = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBEXT'
     C                   EVAL      MsgIdXAr(Idx) = 'USR8431'
      *
     C                   ENDIF
      *
     C                   IF        DDBEXT = *BLANKS
     C                             AND DDACTN <> 'D'                                        MD024991
      *
     C                   EVAL      OKBEXT = 'Y'
     C                   EVAL      DDBEXT = 'Y'
      *
     C                   ENDIF
      *
     C                   IF        DDBEXT = 'Y'
     C                             or DDBEXT = 'N'                                          BUG26637
      *
     C                   EVAL      OKBEXT = 'Y'
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
                                                                                            MD024991
      * Action Code                                                                         MD024991
     C                   PARM                    DDACTN                                     MD024991
      *
      ** Customer Required for Bundesbank Reporting
      *
     C                   PARM                    DDBEXT
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM      *ZEROS        Idx
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Customer Required for Bundesbank Reporting
      *
     C                   PARM                    OKBEXT
      *
     C                   EVAL       RetCodeIn = *BLANKS
     C                   EVAL       Idx       = *ZEROS
     C                   EVAL       FldNamXAr = *BLANKS
     C                   EVAL       MsgIdXAr  = *BLANKS
     C                   EVAL       MsgDtaXAr = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2009
