     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Language Id')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVLANG - SD Additional Customer Validate Language Id        *
      *                                                               *
      *  Function:  This module validates the Language Id on the      *
      *             new details screen                                *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER034  *CREATE    Date 06Aug08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVLnID - Validate Language Id                               *
      *  *INZSR  - Program Initialisation Routine                     *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
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
      ** External DS for SD Midas modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** External DS for Customer Details
     D SDLANG        E DS                  EXTNAME(SDLANGPD)
      *
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D PLCD          E                     EXTFLD(LCD)
      *
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
     D DDLNID          S              2A
     D OKLNID          S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D CCG001          S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
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
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = *ZEROS
      *
      ** Validate Language Id
      *
     C                   EXSR      SRVLnID
      *
     C                   IF        OKLNID = 'N'
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
      *  SRVLnID - Validate Language Id                               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVLnID       BEGSR
      *
      ** If User Defined Correspondence is OFF or Add Correspondent
      ** when Customer Details Added feature is OFF, Language Id cannot
      ** be entered
      *
     C                   IF        (BGN1ST <> 'Y' OR CCG001 <> 'Y') AND
     C                             DDLNID <> *BLANKS
      *
     C                   EVAL      OKLNID = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDLNID'
     C                   EVAL      MsgIdXAr (Idx) = 'USR5981'
      *
     C                   ENDIF
      *
      ** If features are ON
      *
     C                   IF        BGN1ST = 'Y' AND CCG001 = 'Y'
      *
      ** Default if BLANKS
      *
     C                   IF        DDLNID = *BLANKS
     C                   EVAL      DDLNID = 'GB'
     C                   ENDIF
      *
      ** Check if language entered is valid
      *
     C                   CALL      'AOLANGR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    DDLNID
     C     SDLANG        PARM      SDLANG        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      OKLNID = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDLNID'
     C                   EVAL      MsgIdXAr (Idx) = 'USR5982'
      *
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
      ** Language Id Flag
      *
     C                   PARM                    DDLNID
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag Language Id
      *
     C                   PARM                    OKLNID
      *
      ** Check if User Defined Correspondence is switched on
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR'      PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Check if Add Correspondent when Customer Details Added feature
      ** is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CCG001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CCG001 = 'Y'
     C                   ELSE
     C                   EVAL      CCG001 = 'N'
     C                   ENDIF
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
