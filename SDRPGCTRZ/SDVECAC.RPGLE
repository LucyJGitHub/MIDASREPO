     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Economic Activity Code')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVECAC - SD Validate Economic Activity Code                 *
      *                                                               *
      *  Function:  This module validates the field Economic Activity *
      *             Code                                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. AR737976           Date 14Apr11               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR737976 - Three (3) fields were not highlighted to reflect  *
      *             that these needs to be populated (Child: AR737977)*
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  VALECAC - Validate Economic Activity Code                    *
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
     D SDECAC        E DS                  EXTNAME(SDECACPD)
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D DDECAC          S              3A
     D DDBEXT          S              1A
     D OKECAC          S              1A
     D CER045          S              1A
     D Idx             S              3P 0
     D PRtCd           S              7A
     D POptn           S              7A
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
     C                   EXSR      VALECAC
      *
     C                   IF        OKECAC = 'N'
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
      *  VALECAC - Validate Economic Activity Code                    *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     VALECAC       BEGSR
      *
     C                   IF        DDECAC = *BLANKS AND
     C                             DDBEXT = 'Y'
      *
     C                   EVAL      OKECAC = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDECAC'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5ECAC'                                AR737976
      *
      * USR8426: Economic Activity Code is required
      *
     C                   EVAL      MsgIdXAr(Idx) = 'USR8426'
      *
     C                   ENDIF
      *
     C                   IF        DDECAC <> '?' AND
     C                             DDECAC <> *BLANKS
      *
      ** Access Economic Activity Code Table
      *
     C                   CALL      'AOECACR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM                    DDECAC
     C     SDECAC        PARM      SDECAC        DSFDY
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C                   EVAL      OKECAC = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDECAC'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5ECAC'                                AR737976
      *
      * USR8422: Economic Activity Code is invalid.
      *
     C                   EVAL      MsgIdXAr(Idx) = 'USR8422'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDECAC = '?'
      *
      ** Access Economic Activity Code Table
      *
     C                   CALL      'AOECACR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    DDECAC
     C     SDECAC        PARM      SDECAC        DSFDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      DDECAC = N6ECAC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDECAC <> *BLANKS AND
     C                             DDBEXT = 'N'
      *
     C                   EVAL      OKECAC = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDECAC'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5ECAC'                                AR737976
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
     C                   PARM                    RetCodeIn
      *
      ** Economic Activity Code
      *
     C                   PARM                    DDECAC
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
      ** Ok Flag for Economic Activity Code
      *
     C                   PARM                    OKECAC
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
