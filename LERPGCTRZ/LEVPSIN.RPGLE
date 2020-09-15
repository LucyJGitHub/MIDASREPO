     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Partial Indicator')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVPSIN - Validate Partial Indicator                         *
      *                                                               *
      *  Function: This function receives a parameter containing the  *
      *            Partial Indicator value and confirms whether it's  *
      *            a valid entry or not                               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Main Processing Control
      *****************************************************************
      *
      ** Initialization
      *
     C                   RESET                   ErrorFound
      *
      ** Process Request
      *
     C                   EXSR      VSFA
      *
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPSIN - Validate Partial Indicator                           *
      *****************************************************************
      *
     C     VSFA          BEGSR
      *
      ** If Partial Payments Allowed, Check if Valid Option.
      *
     C                   SELECT
     C                   WHEN      DDPSIN <> 'P'
     C                             AND DDPSIN <> 'A'
     C                             AND DDPSIN <> *BLANKS
     C                   EVAL      #MsgID = '5045587'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   WHEN      DDPSIN = *BLANKS
     C                             AND DDFPPA = 'P'
     C                   EVAL      #MsgID = '5045588'
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
      ** @DEFN - Definition Rountine                                  *
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
