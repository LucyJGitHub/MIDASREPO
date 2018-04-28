     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Reporting Past Due Initial Date')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVRIDT - Validate Reporting Past Due Initial Date           *
      *                                                               *
      *  Function: This function receives a parameter containing the  *
      *            Reporting Past Due Initial Date value and confirms *
      *            whether it is a valid entry or not                 *
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
      *
      ** Additional Field Definitions
     D DATEA           S              6
     D ZDAYNO          S              5  0
     D ErrorFlag       S              1
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Customer Lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      *
      ** Loan Details
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      *
      ** Fee Details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
      *
      ** Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(LEFEEMPD)
      *
      ** (Current) Fee record in file Format
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)  PREFIX(@@)
      *
      ** Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL) PREFIX(CL_)
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
      *
     D DSRIDT          S              5S 0
      *
     D P@RCAT          S              1S 0
     D P@RIDTFm        S              5S 0
     D P@RIDTTo        S              5S 0
     D P@MXCH          S              3S 0
     D P@PDSts         S             10A
     D P@PDVlD         S              5S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
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
     C                   EXSR      VRIDT
      *
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRIDT - Validate Reporting Past Due Initial Date             *
      *****************************************************************
      *
     C     VRIDT         BEGSR
      *
      ** If Active PDCL exists, Initial Date must be entered
      *
     C                   IF        P@PDSts = '*LIVE'
     C                   IF        DDRIDT = *BLANKS
     C                   EVAL      #MsgID = '5045776'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Else, Initial Date must NOT be entered
      *
     C                   ELSE
     C                   IF        DDRIDT <> *BLANKS
     C                   EVAL      #MsgID = '5045779'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
      *
      ** Convert Inital Date to Midas Day
      *
     C                   IF        DDRIDT <> *BLANKS
     C                             AND ErrorFound <> 'Y'
     C                   MOVE      DDRIDT        DATEA
     C                   TESTN                   DATEA                9798
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
      ** Invalid Format or Not Numeric
      *
     C                   IF        ErrorFlag = 'Y'
     C                             OR *IN97 = '0'
     C                             AND *IN98 = '0'
     C                   EVAL      #MsgID = '5045773'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
     C                   EVAL      DSRIDT = ZDAYNO
      *
      ** If the date has changed, Ensure date isn't in the future
      *
     C                   IF        DSRIDT <> CL_RIDT
     C                   IF        DSRIDT > BJRDNB
     C                   EVAL      #MsgID = '5045774'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Ensure date falls within valid range
      *
     C                   ELSE
     C                   IF        P@RIDTFm <> 0
     C                             AND (DSRIDT < P@RIDTFm OR
     C                             DSRIDT > P@RIDTTo)
     C                   EVAL      #MsgID  = '5045775'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Ensure date on or after PDCL value date
      *
     C                   ELSE
     C                   IF        P@PDSts = '*LIVE' AND
     C                             P@PDVlD > DSRIDT
     C                   EVAL      #MsgID  = '5045778'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Ensure maximum no of changes not exceeded
      *
     C                   ELSE
     C                   IF        P@MXCH > 0
     C                             AND P@MXCH <= @@FERIDC
     C                   EVAL      #MsgID = '5045777'
     C                   EVAL      ErrorFound = 'W'
     C                   EVAL      RetCodeIn = 'Warning'
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
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
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /SPACE
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
      *
     C                   PARM                    P@RCAT
     C                   PARM                    P@RIDTFm
     C                   PARM                    P@RIDTTo
     C                   PARM                    P@MXCH
     C                   PARM                    P@PDSts
     C                   PARM                    P@PDVlD
      *
     C                   PARM                    SDBANK
     C                   PARM                    SDCLND
     C                   PARM                    SDLOAN
     C                   PARM                    SDFEE
     C                   PARM                    TranInPrim
     C                   PARM                    CrFeFilFmt
     C                   PARM                    ClilFilFmt
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
