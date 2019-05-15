     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Suspend Fee Amount Maximum')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVSFAM  - Validate Suspend Fee Amount Maximum               *
      *                                                               *
      *  Function: This function receives a parameter containing the  *
      *            Suspend Fee Amount Maximum value and confirms      *
      *            whether it's a valid entry or not                  *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR318270           Date 01Aug12               *
      *                 262513             Date 01Aug12               *
      *                 CLE134   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR318270 - Specific Fee amendment ends in error              *
      *             (Child: AR321380)                                 *
      *  262513 - Amendment to correct numeric formatting error       *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     D P@NBDP          S              1S 0                                                    262513
      *
     D P@AlignOk       S              1A
     D P@ADig          S              2P 0
     D P@ADec          S              1P 0
     D P@Field         S             16A
 
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
      *
      ** Additional Field Definitions
     D @CYCD           S              3
 
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
      ** Data Structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Currency Details.
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External DS for Fee Details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
      *
      ** External DS for Fee Details
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      *
      ** Short data structure for access objects.
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long data structure for access objects.
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D DSSFAM          S             15A   INZ
     D DSNBDP          S              1S 0 INZ
     D W#SFAM          S             13S 0
      *
     D                 DS
     D  DSSFAM0                      15S 0 INZ
     D  DSSFAM1                      15S 1     OVERLAY(DSSFAM0)
     D  DSSFAM2                      15S 2     OVERLAY(DSSFAM0)
     D  DSSFAM3                      15S 3     OVERLAY(DSSFAM0)
 
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
     C                   EXSR      VSFAM
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSFAM - Validate Suspend Fee Amount Maximum                  *
      *****************************************************************
      *
     C     VSFAM         BEGSR
      *
      ** If No Max Amount Entered and Early Maturity Cond is A, Error
      *
     C                   IF        DDSFAM = *BLANKS
     C                   IF        DDFEMC = 'A'
     C                   EVAL      #MsgID = '5045578'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Ensure Valid Value
      *
     C                   ELSE
     C                   EVAL      P@Field = DDSFAM
     C                   EVAL      P@ADec = DSNBDP
     C**********         EVAL      P@ADig = 15 - DSNBDP                                     AR318270
     C                   EVAL      P@ADig = 12 - DSNBDP                                     AR318270
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    P@AlignOk
     C                   PARM                    P@Field
     C                   PARM                    P@ADec
     C                   PARM                    P@ADig
      *
     C                   IF        P@AlignOk = 'N'
     C                   EVAL      #MsgID = '5045581'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Must Not be Entered if Early Maturity Condition is not "A"
      *
     C                   ELSE
     C                   MOVE      DDSFAM        W#SFAM
     C                   IF        DDFEMC <> 'A' AND
     C                             W#SFAM <> 0
     C                   EVAL      #MsgID = '5045579'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** XRSDCURR - Retrieve Currency Facility                        *
      *****************************************************************
      *
     C     XRSDCURR      BEGSR
      *
      ** Retrieve Details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = @CYCD
     C                   EVAL      DBASE = 020
     C                   EXSR      *PSSR
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
      ** Program, module and procedure names for DB Error processing
      ** ===========================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE
      *****************************************************************
      ** @DEFN: Definition Rountine
      *****************************************************************
      *
     C     @DEFN         BEGSR
      *
      ** Entry Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C     DSNBDP        PARM                    P@NBDP                                       262513
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
