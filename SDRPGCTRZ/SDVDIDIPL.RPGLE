     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Document Id and Place')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVDIDIPL - SD Additional Customer Validate Document Id and  *
      *              Issuing Place                                    *
      *                                                               *
      *  Function:  This module validates the Document Id and         *
      *             Issuing Place on the new Details screen           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. AR738849           Date 13Apr11               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24346           Date 16Jun09               *
      *                 CER034  *CREATE    Date 06Aug08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR738849 - If Identification Type is not blanks, Documents   *
      *             Id is mandatory but the word in error is not      *
      *             highlighted (Child: AR738850)                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24346 - Change validation from tax ID to Identification   *
      *             type                                              *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVDocIPlc - Validate Document Id and Issuing Place          *
      *  *INZSR     - Program Initialisation Routine                  *
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
     D DDDCNM          S             20A
     D DDISPL          S             40A
     D OKDCNM          S              1A
     D OKISPL          S              1A
     D*DDTINO***       S             25A                                                    BUG24346
     D DDIDTP          S              2A                                                    BUG24346
     D CER048          S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
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
      ** Validate Document Id and Issuing Place only if CER048 is ON
      *
     C                   IF        CER048 = 'Y'
     C                   EXSR      SRVDocIPlc
     C                   ENDIF
      *
      ** If error
      *
     C                   IF        OKDCNM = 'N' OR OKISPL = 'N'
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
      *  SRVDocIPlc - Validate Document Id and Issuing Place          *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVDocIPlc    BEGSR
      *
      ***If*Tax*Identification*Number*is*BLANKS,*Document*Id*cannot*be*                     BUG24346
      ***entered*******************************************************                     BUG24346
      ** If Identification Type is BLANKS, Document Id cannot be                            BUG24346
      ** entered                                                                            BUG24346
      *
     C**********         IF        DDTINO = *BLANKS AND                                     BUG24346
     C                   IF        DDIDTP = *BLANKS AND                                     BUG24346
     C                             DDDCNM <> *BLANKS
      *
     C                   EVAL      OKDCNM = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDDCNM'                                AR738849
     C                   EVAL      FldNamXAr(Idx) = 'E5DCID'                                AR738849
     C                   EVAL      MsgIdXAr (Idx) = 'USR5972'
      *
     C                   ENDIF
      *
      ***If*Tax*Identification*Number*is*not*BLANKS,*Document*Id*is****                     BUG24346
      ***mandatory*****************************************************                     BUG24346
      ** If Identification Type is not BLANKS, Document Id is mandatory                     BUG24346
      *
     C**********         IF        DDTINO <> *BLANKS AND                                    BUG24346
     C                   IF        DDIDTP <> *BLANKS AND                                    BUG24346
     C                             DDDCNM = *BLANKS
      *
     C                   EVAL      OKDCNM = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDDCNM'                                AR738849
     C                   EVAL      FldNamXAr(Idx) = 'E5DCID'                                AR738849
     C                   EVAL      MsgIdXAr (Idx) = 'USR5973'
      *
     C                   ENDIF
      *
      ***If*Tax*Identification*Number*is*BLANKS,*issuing*place*cannot                       BUG24346
      ***be*entered****************************************************                     BUG24346
      ** If Identification Type is BLANKS, issuing place cannot                             BUG24346
      ** be entered                                                                         BUG24346
      *
     C**********         IF        DDTINO = *BLANKS AND                                     BUG24346
     C                   IF        DDIDTP = *BLANKS AND                                     BUG24346
     C                             DDISPL <> *BLANKS
      *
     C                   EVAL      OKISPL = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDISPL'                                AR738849
     C                   EVAL      FldNamXAr(Idx) = 'E5DIPL'                                AR738849
     C                   EVAL      MsgIdXAr (Idx) = 'USR5974'
      *
     C                   ENDIF
      *
      ***If*Tax*Identification*Number*is*not*BLANKS,*issuing*place*is**                     BUG24346
      ***mandatory*****************************************************                     BUG24346
      ** If Identification Type is not BLANKS, issuing place is                             BUG24346
      ** mandatory                                                                          BUG24346
      *
     C**********         IF        DDTINO <> *BLANKS AND                                    BUG24346
     C                   IF        DDIDTP <> *BLANKS AND                                    BUG24346
     C                             DDISPL = *BLANKS
      *
     C                   EVAL      OKISPL = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDISPL'                                AR738849
     C                   EVAL      FldNamXAr(Idx) = 'E5DIPL'                                AR738849
     C                   EVAL      MsgIdXAr (Idx) = 'USR5975'
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
      ** Document Id
      *
     C                   PARM                    DDDCNM
      *
      ** Issuing Place
      *
     C                   PARM                    DDISPL
      *
      ***Tax*Identification*Number*************************************                     BUG24346
      ** Identification Type                                                                BUG24346
      *
     C**********         PARM                    DDTINO                                     BUG24346
     C                   PARM                    DDIDTP                                     BUG24346
      *
      ** Switchable Feature
      *
     C                   PARM                    CER048
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Document Id
      *
     C                   PARM                    OKDCNM
      *
      ** Ok Flag for Issuing Place
      *
     C                   PARM                    OKISPL
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
