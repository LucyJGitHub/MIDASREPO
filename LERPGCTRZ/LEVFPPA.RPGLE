     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Partial Payment Allowed')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVPPA  - Validate Partial Payment Allowed                   *
      *                                                               *
      *  Function: This function receives a parameter containing the  *
      *            Partial Payment Allowed value and confirms whether *
      *            it's a valid entry or not                          *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      /EJECT                                                    3
      *================================================================
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      /EJECT
      ** Manually included D-specs
      ** =========================
 
      ** Named constants
      ** ===============
 
      ** Arrays and Data Structures
      ** ==========================
      *
      ** Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
      *
      ** Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(LEFEEMPD)
      *
      ** External DS for Fee Details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
      *
      ** External DS for Fee Details
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      *
      ** Data Structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Declared variables
      ** ==================
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * Main Processing Control                                       *
      *****************************************************************
      *
      ** Initialization
      *
     C                   RESET                   ErrorFound
      *
      ** Process Request
      *
     C                   EXSR      VFPPA
      *
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFPPA - Validate Partial Payment Allowed                     *
      *****************************************************************
      *
     C     VFPPA         BEGSR
      *
      ** Check if Valid Option
      *
     C                   SELECT
     C                   WHEN      DDFPPA <> 'Y' AND
     C                             DDFPPA <> 'N' AND
     C                             DDFPPA <> 'P' AND
     C                             DDFPPA <> *BLANKS
     C                   EVAL      #MsgID = '5045585'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** If Partial Subsequent Payments Allowed, Check Early
      ** Maturity Condition
      *
     C                   WHEN      DDFPPA = 'P'
     C                             AND DDFEMC <> 'S'
     C                   EVAL      #MsgID = '5045586'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** *INZSR - Initialisation Rountine                             *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Initialisation
      *
     C                   EVAL      RetCodeIn   = *BLANKS
      *
      ** Program, module and procedure names for DB Error processing
      ** ===========================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE
      *****************************************************************
      ** @DEFN - Definition Routine                                   *
      *****************************************************************
      *
     C     @DEFN         BEGSR
      *
      ** Entry List
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    TranInPrim
     C                   PARM                    SDFEE
     C                   PARM                    SDLOAN
     C                   PARM                    SDBANK
     C                   PARM                    ClilFilFmt
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
