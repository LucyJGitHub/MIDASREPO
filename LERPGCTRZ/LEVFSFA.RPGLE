     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Suspend Fee Allowed')                *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVFSFA - Validate Suspend Fee Allowed                       *
      *                                                               *
      *  Function: This function receives a parameter containing the  *
      *            Suspend Fee Allowed value and confirms whether it  *
      *            is a valid entry or not                            *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR314017           Date 01Aug12               *
      *                 262672             Date 01Aug12               *
      *                 CLE134   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  AR314017 - CLE134 LEC0459 failed in COB # 10 in BB           *
      *             Component LEC0459 00001 failed in COB             *
      *             PONS/RONS warning if changed with LEACCNPD records*
      *             (Child: AR314018)                                 *
      *  262672 - Fee Input fails with MidasPlus error                *
      *         - Modified to only validate when Suspense Fee Allowed.*
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** Additional Field Definitions
     D WKPSLM          S             13  0
 
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
      ** Data Structure for Bank Details.
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Main Processing Control                                      *
      *****************************************************************
      *
      ** Initialization
      *
     C                   RESET                   ErrorFound
      *
      ** Process Request
      *
     C                   EXSR      VFSFA
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFSFA  - Validate Suspend Fee Allowed                        *
      *****************************************************************
      *
     C     VFSFA         BEGSR
      *
      ** Clear Values if Zero                                                                 262672
      *                                                                                       262672
     C                   IF        DDFSFA <> 'Y'                                              262672
     C                   EVALR     DDPSLM = DDPSLM                                            262672
     C                   MOVE      DDPSLM        WKPSLM                                       262672
      *                                                                                       262672
     C                   IF        WKPSLM = 0                                                 262672
     C                   EVAL      DDPSLM = *BLANKS                                           262672
     C                   ENDIF                                                                262672
     C                   ENDIF                                                                262672
      *
      ** Check if Valid Option
      *
     C                   SELECT
     C                   WHEN      DDFSFA <> 'Y'
     C                             AND DDFSFA <> 'N'
     C                             AND DDFSFA <> *BLANKS
     C                   EVAL      #MsgID = '5045577'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   WHEN      DDFSFA <> 'Y' AND
     C                             (DDSFAM <> *BLANKS OR
     C                              DDSFPM <> *BLANKS OR
     C                             (DDFPPA <> *BLANKS AND
     C                              DDFPPA <> 'N') OR
     C                              DDPSIN <> *BLANKS OR
     C                              DDPSLM <> *BLANKS OR
     C                              DDFEMC <> *BLANKS)
     C                   EVAL      #MsgID = '5045597'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   WHEN      DDFSFA = 'Y' AND
     C                             DDEPON <> 'N'
     C                   EVAL      #MsgID = '5045598'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *                                                                                     AR314017
      ** Non calculated fees cannot be suspended                                            AR314017
      *                                                                                     AR314017
     C                   WHEN      DDFSFA = 'Y' AND                                         AR314017
     C                             DDCALT = *BLANKS                                         AR314017
     C                   EVAL      #MsgID = '5045679'                                       AR314017
     C                   EVAL      ErrorFound = 'Y'                                         AR314017
     C                   EVAL      RetCodeIn = 'Error'                                      AR314017
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
      *****************************************************************
     C/EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
