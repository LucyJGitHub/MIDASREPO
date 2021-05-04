     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Partial Limit')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVPSLM - Validate Partial Limit                             *
      *                                                               *
      *  Function: This function receives a parameter containing the  *
      *            Partial Limit value and confirms whether it's      *
      *            a valid entry or not                               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR318270           Date 01Aug12               *
      *                 262672             Date 01Aug12               *
      *                 262513             Date 01Aug12               *
      *                 CLE134   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  AR318270 - CLE134 Specific Fee amendment ends in error       *
      *             (Child: AR321380)                                 *
      *  262672 - Fee input fails with MidasPlus error                *
      *         - Modified to only validate when Suspense Fee Allowed *
      *  262513 - Numeric formatting error in Fees input              *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
     D P@NBDP          S              1S 0                                                    262513
     D DSNBDP          S              1S 0 INZ
      *
     D P@AlignOk       S              1A
     D P@ADig          S              2P 0
     D P@ADec          S              1P 0
     D P@Field         S             16A
      *
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
      ** Data Structure for Bank Details.
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D DSField         S             15P 0 INZ
     D DSPSLM          S             15A   INZ
 
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
     C                   IF        DDFSFA = 'Y'                                               262672
     C                   EXSR      VPSLM
     C                   ENDIF                                                                262672
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPSLM - Validate Partial Limit                               *
      *****************************************************************
      *
     C     VPSLM         BEGSR
      *
      ** If Partial Indicator Valid - Set Default
      *
     C                   IF        DDPSIN = 'A'
     C                             OR DDPSIN = 'P'
      *
     C                   IF        DDPSLM = *BLANKS
     C                             AND AUPSLM <> 0
     C                   MOVE      AUPSLM        DDPSLM
     C                   ENDIF
      *
      ** Partial Limit Must be Entered
      *
     C                   IF        DDPSLM = *BLANKS
     C                   EVAL      #MsgID = '5045590'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Ensure Value is Numeric
      *
     C                   ELSE
     C                   EVAL      P@Field = DDPSLM
      *
     C                   IF        DDPSIN = 'P'
     C                   EVAL      P@ADec = 0
     C                   EVAL      P@ADig = 3
      *
     C                   ELSE
     C                   EVAL      P@ADec = DSNBDP
     C**********         EVAL      P@ADig = 15 - DSNBDP                                     AR318270
     C                   EVAL      P@ADig = 12 - DSNBDP                                     AR318270
     C                   ENDIF
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    P@AlignOk
     C                   PARM                    P@Field
     C                   PARM                    P@ADec
     C                   PARM                    P@ADig
      *
     C                   IF        P@AlignOk = 'N'
     C                   IF        DDPSIN = 'P'
     C                   EVAL      #MsgID = '5045591'
      *
     C                   ELSE
     C                   EVAL      #MsgID = '5045593'
     C                   ENDIF
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** If Percentage, Ensure Value is in Range
      *
     C                   ELSE
     C                   CALLB     'ZEDIT'
     C                   PARM                    P@Field
     C                   PARM                    P@ADec
      *
     C                   MOVE      P@Field       DSPSLM
      *
     C                   IF        DDPSIN = 'P'
     C                   IF        %DEC(DSPSLM:15:0) < 0
     C                             OR %DEC(DSPSLM:15:0) > 100
     C                   EVAL      #MsgID = '5045592'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Partial Limit Must not be Entered if indicator is blank                            AR318270
      *
     C                   ELSE                                                               AR318270
     C                   MOVE      DDPSLM        DSFIELD                                    AR318270
     C                   IF        DDPSLM <> *BLANKS                                        AR318270
     C                             AND DSFIELD <> 0                                         AR318270
     C                   EVAL      #MsgID = '5045589'                                       AR318270
     C                   EVAL      ErrorFound = 'Y'                                         AR318270
     C                   EVAL      RetCodeIn = 'Error'                                      AR318270
     C                   ENDIF                                                              AR318270
      *                                                                                     AR318270
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
