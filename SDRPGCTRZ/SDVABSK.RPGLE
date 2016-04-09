     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Addt'l Borrower Statistics Key')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVABSK - SD Validate Additional Borrower Statistics Key     *
      *              Reporting                                        *
      *                                                               *
      *  Function:  This module validates the field Additional        *
      *             Borrower Statistics Key                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  VALABSK - Validate Additional Borrowers Statistics Key       *
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
     D DDABSK          S              1A
     D DDBEXT          S              1A
     D OKABSK          S              1A
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
      ** Validate Additional Borrowers Statistics Key
      *
     C                   EXSR      VALABSK
      *
     C                   IF        OKABSK = 'N'
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
      *  VALABSK - Validate Additional Borrowers Statistics Key       *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     VALABSK       BEGSR
      *
     C                   IF        DDABSK <> *BLANKS AND
     C                             DDABSK <> 'H'
      *
     C                   EVAL      OKABSK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDABSK'
      *
      * USR8424: Additional Borrowers Statistics Key must be blank OR 'H'.
      *
     C                   EVAL      MsgIdXAr(Idx) = 'USR8424'
      *
     C                   ENDIF
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
     C                   PARM                    RetCodeIn
      *
      ** Additional Borrower Sector Key
      *
     C                   PARM                    DDABSK
      *
      ** Customer Required for Bundesbank Reporting
      *
     C                   PARM                    DDBEXT
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    Idx
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Additional Borrower Sector Key
      *
     C                   PARM                    OKABSK
      ** Return Code
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
