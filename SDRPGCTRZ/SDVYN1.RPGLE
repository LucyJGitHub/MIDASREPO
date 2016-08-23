     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate 'Y/N' Fields')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVYN1 - SD Additional Customer Validate Screen Y/N Fields   *
      *                                                               *
      *  Function:  This module validates the FX Customer, Staff      *
      *             Member and Zero Confirmation Flag on the new      *
      *             Additional Details Screen                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER034  *CREATE    Date 06Aug08               *
      *                                                               *
      *--------------------------------------------------------------**
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRValYNFlds - Validate FX Customer, Staff Member, Zero       *
      *                Confirmation Flag, Partner/Associated and      *
      *                Subject to 24c Flag                            *
      *  *INZSR    - Program Initialisation Routine                   *
      *                                                               *
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
     D Idx             S              3P 0
     D PYNFld          S              1A
     D OKYNFld         S              1A
     D PFldName        S             10A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      Idx = *ZEROS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
      *
      ** Validate Y/N Fields
      *
     C                   EXSR      SRValYNFlds
      *
      ** Incase of an Error
      *
     C                   IF        OKYNFld = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
      *
      ** Return from program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValYNFlds - Validate FX Customer, Staff Member, Zero       *
      *                Confirmation Flag, Partner/Associated and      *
      *                Subject to 24c Flag                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRValYNFlds   BEGSR
      *
      ** Validate Y/N Fields
      *
      ** If Blank, default with 'N'
      *
     C                   IF        PYNFld = *BLANKS
     C                   EVAL      PYNFld = 'N'
     C                   ENDIF
      *
      ** Valid values are Y/N
      *
     C                   IF        PYNFld <> 'Y' AND
     C                             PYNFld <> 'N'
      *
     C                   EVAL      OKYNFld = 'N'
     C                   EVAL      Idx = Idx + 1
      *
      ** Populate appropriate Error Field/Message Id
      *
     C                   IF        PFldName = 'DDFXCU'
     C                   EVAL      FldNamXAr(Idx) = 'DDFXCU'
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5952'
     C                   ENDIF
      *
     C                   IF        PFldName = 'DDSMBR'
     C                   EVAL      FldNamXAr(Idx) = 'DDSMBR'
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5953'
     C                   ENDIF
      *
     C                   IF        PFldName = 'DDZCFG'
     C                   EVAL      FldNamXAr(Idx) = 'DDZCFG'
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5976'
     C                   ENDIF
      *
     C                   IF        PFldName = 'DDPIND'
     C                   EVAL      FldNamXAr(Idx) = 'DDPIND'
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5905'
     C                   ENDIF
      *
     C                   IF        PFldName = 'DDS24C'
     C                   EVAL      FldNamXAr(Idx) = 'DDS24C'
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5904'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
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
      ** Validate Y/N Field
      *
     C                   PARM                    PYNFld
      *
      ** Field name to be Validated
      *
     C                   PARM                    PFldName
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag
      *
     C                   PARM                    OKYNFld
      *
      ** Program, module and procedure names for database error
      ** processing.
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
