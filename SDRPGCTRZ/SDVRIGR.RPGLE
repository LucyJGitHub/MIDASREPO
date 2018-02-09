     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Risk Classification Code')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVRIGR - SD Validate Risk Classification Code               *
      *                                                               *
      *  Function:  This module validates the field Risk              *
      *             Classification Code                               *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER070  *CREATE    Date 20Aug14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  VALRIGR - Validate Risk Classification Code                  *
      *                                                               *
      *  *INZSR - Program initialisation routine                      *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
     FSDPDWNL1  IF   E           K DISK
      * RTV : Midas SD Midas system pulldown lists
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
     D DDRIGR          S              1A
     D OKRIGR          S              1A
     D Idx             S              3P 0
     D KGLHIND         S                   LIKE(GLHIND)
     D KGLVDTA         S                   LIKE(GLVDTA)
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
      ** Validate Risk Classification Code
      *
     C                   EXSR      VALRIGR
      *
     C                   IF        OKRIGR = 'N'
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
      *  VALRIGR - Validate Risk Classification Code                  *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     VALRIGR       BEGSR
      *
     C                   IF        DDRIGR = *BLANKS AND
     C                             DDBEXT = 'Y'
      *
     C                   EVAL      OKRIGR = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'E5RISG'
      *
      * CER0612: Risk Classification Code is required
      *
     C                   EVAL      MsgIdXAr(Idx) = 'USR9634'
      *
     C                   ENDIF
      *
     C                   IF        DDRIGR <> *BLANKS
     C                   EVAL      KGLHIND = 659
     C                   EVAL      KGLVDTA = DDRIGR
      *
     C     KPDWN         CHAIN(e)  SDPDWNL1
      *
      ** Access Risk Classification Code Table
      *
     C                   IF        %error or not %found
      *
     C                   EVAL      OKRIGR = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'E5RISG'
      *
      * CER0611: Risk Classification Code is invalid
      *
     C                   EVAL      MsgIdXAr(Idx) = 'USR9633'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDRIGR <> *BLANKS AND
     C                             DDBEXT <> 'Y'
      *
     C                   EVAL      OKRIGR = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'E5RISG'
      *
      * ERC0032: Field should be blank if Customer Required for Bundesbank is 'N'
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
      ** Risk Classification Code
      *
     C                   PARM                    DDRIGR
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
      ** Ok Flag for Risk Classification Code
      *
     C                   PARM                    OKRIGR
      *
      ** Define keylist for SDPDWNL1
      *
     C     KPDWN         KLIST
     C                   KFLD                    KGLHIND
     C                   KFLD                    KGLVDTA
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
(c) Finastra International Limited 2011
