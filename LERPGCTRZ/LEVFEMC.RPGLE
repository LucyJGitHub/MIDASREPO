     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Early Maturity Condition')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVFEMC - Validate Early Maturity Condition                  *
      *                                                               *
      *  Function: This function receives a parameter containing the  *
      *            Early Maturity Condition value and confirms        *
      *            whether it's a valid entry or not                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CLE134   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
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
      *
      ** Manually included D-specs
      ** =========================
      *
      ** Named constants
      ** ===============
      *
      *
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
      ** Data Structure for Bank Details.
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Declared variables
      ** ==================
      *
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
     C                   EXSR      VFEMC
      *
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFEMC - Validate Early Maturity Condition                    *
      *****************************************************************
      *
     C     VFEMC         BEGSR
      *
      ** Check if Valid Option
      *
     C                   SELECT
     C                   WHEN      DDFEMC <> 'A' AND
     C                             DDFEMC <> 'S' AND
     C                             DDFEMC <> 'T' AND
     C                             DDFEMC <> *BLANKS
     C                   EVAL      #MsgID = '5045595'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** If No Option, Check Whether Partial Payments are Allowed
      *
     C                   WHEN      DDFEMC = *BLANKS AND
     C                             (DDFPPA = 'P' OR
     C                              DDFPPA = 'Y')
     C                   EVAL      #MsgID = '5045594'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDSL
      *
     C                   ENDSR
      *
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
     C/SPACE
      *****************************************************************
      ** @DEFN -  Definition Rountine                                 *
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
      ********************************************************************
     C/EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
