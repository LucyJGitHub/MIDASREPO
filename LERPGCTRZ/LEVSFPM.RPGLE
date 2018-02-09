     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Suspend Fee Payment Maximum')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVSFPM - Validate Suspend Fee Payment Maximum               *
      *                                                               *
      *  Function: This function receives a parameter containing the  *
      *            Suspend Fee Payment Maximum value                  *
      *            and confirms whether it's a valid entry or not     *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 263801             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  263801 - API FEEM Wrong interpretation of DDSFPM (SOAP)      *
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
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
      *  Main Processing Control                                      *
      *****************************************************************
      *
      ** Initialization
      *
     C                   RESET                   ErrorFound
      *
      ** Process Request
      *
     C                   EXSR      VSFPM
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSFPM - Validate Suspend Fee Payment Maximum                 *
      *****************************************************************
      *
     C     VSFPM         BEGSR
      *
      ** If No Max Payment Entered and Early Maturity Cond
      ** is S or T, Error
      *
     C                   IF        DDSFPM = *BLANKS
     C                   IF        DDFEMC = 'S'
     C                             OR DDFEMC = 'T'
      *
     C                   IF        AUSFPM <> 0                                                263801
     C                             AND DDACTN = 'I'                                           263801
     C                   MOVE      AUSFPM        DDSFPM                                       263801
     C                   ELSE                                                                 263801
     C                   EVAL      #MsgID = '5045582'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF                                                                263801
      *
     C                   ENDIF
      *
      ** Ensure Valid Value
      *
     C                   ELSE
     C**********         EVALR     DDSFPM = '00000' + %TRIM(DDSFPM)                           263801
     C                   EVALR     DDSFPM = '000' + %TRIM(DDSFPM)                             263801
     C                   TESTN                   DDSFPM               9798
      *
     C                   SELECT
     C                   WHEN      *IN97 = '0'
     C                             AND *IN98 = '0'
     C                   EVAL      #MsgID = '5045584'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Must Not be Entered if Early Maturity Condition
      ** is not "S" or "T"
      *
     C                   WHEN      DDFEMC <> 'S'
     C                             AND DDFEMC <> 'T'
     C                   EVAL      #MsgID = '5045583'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDSL
     C                   ENDIF
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
     C                   EVAL      RetCodeIn = *BLANKS
      *
      ** Program, module and procedure names for DB error processing
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
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
