     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Borrower Sector ClassificationCd')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVBSCC - SD Validate Borrower Sector Classification Code    *
      *                                                               *
      *  Function:  This module validates the field Borrower Sector   *
      *             Classification Code                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. AR737976           Date 14Apr11               *
      *  Prev Amedn No. BUG26756           Date 16Nov09               *
      *                 BUG25957           Date 09Sep09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR737976 - Three (3) fields were not highlighted to reflect  *
      *             that these needs to be populated (Child: AR737977)*
      *  BUG26756 - Errors occurred in 'Borrower Sector Classification*
      *             Code' and 'Borrower Sector Classification/BISTA'  *
      *             due to defaulted values when 'Amend' action is    *
      *             being done.                                       *
      *  BUG25957 - Link Test Error: Error in prompt                  *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  VALBEXT - Validate Borrower Sector Classification Code       *
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
      ** External DS for Borrower Sector Classification Code
      *
     D SDBSCC        E DS                  EXTNAME(SDBSCCPD)
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D DDBEXT          S              1A
     D DDBSCC          S              2A
     D OKBSCC          S              1A
     D CER045          S              1A
     D Idx             S              3P 0
     D PRtCd           S              7A
     D POptn           S              7A
     D WNumChk         S             10P 0
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
      ** Validate Borrower Sector Classification Code
      *
     C                   EXSR      VALBSCC
      *
     C                   IF        OKBSCC = 'N'
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
      *  VALBSCC - Validate Borrower Sector Classification Code       *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     VALBSCC       BEGSR
      *
     C                   IF        DDBSCC = *BLANKS AND
     C                             DDBEXT = 'Y'
      *
     C                   EVAL      OKBSCC = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDBSCC'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5BSCC'                                AR737976
      *
      * USR8425: Borrower Sector Classification Code is required
      *
     C                   EVAL      MsgIdXAr(Idx) = 'USR8425'
      *
     C                   ENDIF
      *
     C**********         IF        DDBSCC <> '?' AND                                        BUG25957
     C                   IF        %TRIM(DDBSCC) <> '?' AND                                 BUG25957
     C                             DDBSCC <> *ZEROS     AND                                 BUG26756
     C                             DDBSCC <> *BLANKS
      *
     C                   EVAL      WNumChk = %CHECK('0123456789':DDBSCC)
      *
     C                   IF        WNumChk <> 0
      *
     C                   EVAL      OKBSCC = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDBSCC'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5BSCC'                                AR737976
      *
      * USR8421: Borrower Sector Classification Code is invalid
      *
     C                   EVAL      MsgIdXAr(Idx) = 'USR8421'
      *
     C                   ELSE
      *
      ** Access Borrower Sector Classification Code Table
      *
     C                   CALL      'AOBSCCR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM                    DDBSCC
     C     SDBSCC        PARM      SDBSCC        DSFDY
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C                   EVAL      OKBSCC = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDBSCC'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5BSCC'                                AR737976
      *
      * USR8421: Borrower Sector Classification Code is invalid
      *
     C                   EVAL      MsgIdXAr(Idx) = 'USR8421'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C**********         IF        DDBSCC = '?'                                             BUG25957
     C                   IF        %TRIM(DDBSCC) = '?'                                      BUG25957
      *
      ** Access Borrower Sector Classification Code Table
      *
     C                   CALL      'AOBSCCR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    DDBSCC
     C     SDBSCC        PARM      SDBSCC        DSFDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     N5BSCC        DDBSCC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDBSCC <> *BLANKS AND
     C                             DDBSCC <> *ZEROS  AND                                    BUG26756
     C                             DDBEXT = 'N'
      *
     C                   EVAL      OKBSCC = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDBSCC'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5BSCC'                                AR737976
      *
      * USR8425: Borrower Sector Classification Code is required
      *
     C                   EVAL      MsgIdXAr(Idx) = 'ERC0032'
     C                   EVAL      #MsgFile = 'GBSTUSRMSG'
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
     C                   PARM                    RetCodeIn
      *
      ** Borrower Sector Classification Code
      *
     C                   PARM                    DDBSCC
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
      ** Ok Flag for Borrower Sector Classification Code
      *
     C                   PARM                    OKBSCC
      *
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
