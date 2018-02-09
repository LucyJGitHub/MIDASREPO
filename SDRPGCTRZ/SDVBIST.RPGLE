     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Borrower Sector Class./BISTA')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVBIST - SD Validate Borrower Sector Classification/BISTA   *
      *                                                               *
      *  Function:  This module validates the field Borrower Sector   *
      *             Classification/BISTA                              *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR737976           Date 14Apr11               *
      *                 BUG26756           Date 16Nov09               *
      *                 BUG26637           Date 03Nov09               *
      *                 BUG25957           Date 09Sep09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR737976 - Three (3) fields were not highlighted to reflect  *
      *             that these needs to be populated (Child: AR737977)*
      *  BUG26756 - Errors occurred in 'Borrower Sector Classification*
      *             Code' and 'Borrower Sector Classification/BISTA'  *
      *             due to defaulted values when 'Amend' action is    *
      *             being done.                                       *
      *  BUG26637 - Unable to exit to the main screen                 *
      *  BUG25957 - Link Test Error: Error in prompt                  *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  VALBIST - Validate Borrower Sector Classification/BISTA      *
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
     D SDBIST        E DS                  EXTNAME(SDBISTPD)
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D DDBEXT          S              1A
     D DDBIST          S              3A
     D OKBIST          S              1A
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
     C                   EXSR      VALBIST
      *
     C                   IF        OKBIST = 'N'
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
      *  VALBIST - Validate Borrower Sector Classification/BISTA      *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     VALBIST       BEGSR
      *
     C                   IF        DDBIST = *BLANKS AND
     C                             DDBEXT = 'Y'
      *
     C                   EVAL      OKBIST = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDBIST'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5BIST'                                AR737976
      *
      * USR8427: Borrower Sector Classification Code/BISTA is required
      *
     C                   EVAL      MsgIdXAr(Idx) = 'USR8427'
      *
     C                   ENDIF
      *
     C**********         IF        DDBIST <> '?' AND                                        BUG25957
     C                   IF        %TRIM(DDBIST) <> '?' AND                                 BUG25957
     C                             DDBIST <> *ZEROS     AND                                 BUG26756
     C                             DDBIST <> *BLANKS
      *
     C                   EVAL      WNumChk = %CHECK('0123456789':DDBIST)
      *
     C                   IF        WNumChk <> 0
     C                   EVAL      OKBIST = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDBIST'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5BIST'                                AR737976
      *
      * USR8423: Borrower Sector Classification/BISTA is invalid.
      *
     C                   EVAL      MsgIdXAr(Idx) = 'USR8423'
      *
     C                   ELSE
      *
      ** Access Borrower Sector Classification/BISTA Table
      *
     C                   CALL      'AOBISTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM                    DDBIST
     C     SDBIST        PARM      SDBIST        DSFDY
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C                   EVAL      OKBIST = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDBIST'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5BIST'                                AR737976
      *
      * USR8423: Borrower Sector Classification/BISTA is invalid.
      *
     C                   EVAL      MsgIdXAr(Idx) = 'USR8423'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C**********         IF        DDBIST = '?'                                             BUG25957
     C                   IF        %TRIM(DDBIST) = '?'                                      BUG25957
      *
      ** Access Borrower Sector Classification/BISTA
      *
     C                   CALL      'AOBISTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    DDBIST
     C     SDBIST        PARM      SDBIST        DSFDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     N7BIST        DDBIST
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDBIST <> *BLANKS AND
     C                             DDBIST <> *ZEROS  AND                                    BUG26756
     C                             DDBEXT = 'N'
      *
     C                   EVAL      OKBIST = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDBIST'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5BIST'                                AR737976
     C                   EVAL      MsgIdXAr(Idx) = 'ERC0032'
      *                                                                                     BUG26637
      * added message file in MSGHNDDATA under MsgFArray                                    BUG26637
     C**********         EVAL      #MsgFile = 'GBSTUSRMSG'                                  BUG26637
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
      *
      ** Borrower Sector Classification/BISTA
      *
     C                   PARM                    DDBIST
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
      ** Ok Flag for Borrower Sector Classification/BISTA
      *
     C                   PARM                    OKBIST
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
(c) Finastra International Limited 2009
