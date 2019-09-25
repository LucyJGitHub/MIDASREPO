     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Basel II Past Due Initial Date')     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVBIDT - Validate Basel II Past Due Initial Date            *
      *                                                               *
      *  Function: This function receives a parameter containing the  *
      *            Basel II Past Due Initial Date value and confirms  *
      *            whether it is a valid entry or not                 *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *
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
      ** names, prefixed by 'PS'
      *
     D/COPY ZACPYSRC,PSDS
      *
      /EJECT
      *
      ** Arrays and Data Structures
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
      ** Short data structure for access objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long data structure for access objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Declared variables
      *
     D DSBIDT          S              5S 0
     D P@BCAT          S              1S 0
     D P@BIDTFm        S              5S 0
     D P@BIDTTo        S              5S 0
     D P@MXCH          S              3S 0
     D P@PDSts         S             10A
     D P@PDVlD         S              5S 0
     D DATEA           S              6A
     D ZDAYNO          S              5P 0
     D ErrorFlag       S              1A
      *
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
     C                   EXSR      VBIDT
      *
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      ** VBIDT - Validate Basel II Past Due Initial Date              *
      *****************************************************************
     C     VBIDT         BEGSR
      *
      ** If Active PDCL exists;
      ** Initial Date must be entered;
      *
     C                   IF        P@PDSts = '*LIVE'
     C                   IF        DDBIDT = *BLANKS
     C                   EVAL      #MsgID = '5045701'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Else;
      ** Initial Date must not be entered
      *
     C                   ELSE
     C                   IF        DDBIDT <> *BLANKS
     C                   EVAL      #MsgID = '5045705'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
      *
      ** Convert Inital Date to Midas Day
      *
     C                   IF        DDBIDT <> *BLANKS
     C                             AND ErrorFound <> 'Y'
     C                   MOVE      DDBIDT        DATEA
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
     C                   EVAL      #MsgID = '5045691'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
     C                   EVAL      DSBIDT = ZDAYNO
      *
      ** If the Date has Changed;
      ** Ensure Date isn't in the Future
      *
     C                   IF        DSBIDT <> CL_BIDT
     C                   IF        DSBIDT > BJRDNB
     C                   EVAL      #MsgID = '5045693'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Ensure date falls within valid range
      *
     C                   ELSE
     C                   IF        P@BIDTFm <> 0
     C                             AND (DSBIDT < P@BIDTFm
     C                             OR DSBIDT > P@BIDTTo)
     C                   EVAL      #MsgID = '5045695'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Ensure date on or after PDCL value date
      *
     C                   ELSE
     C                   IF        P@PDSts = '*LIVE'
     C                             AND P@PDVlD > DSBIDT
     C                   EVAL      #MsgID = '5045704'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Ensure maximum no of changes not exceeded
      *
     C                   ELSE
     C                   IF        P@MXCH > 0
     C                             AND P@MXCH <= @@FERIDC
     C                   EVAL      #MsgID = '5045703'
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
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Initialisation Rountine                             *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialisation
      *
     C                   EVAL      RetCodeIn = *BLANKS
      *
      ** Program, module and procedure names for DB error processing
      ** The following /COPY sets these values, and also defines LDA
      ** as external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  @DEFN - Definition Rountine                                  *
      *****************************************************************
     C     @DEFN         BEGSR
      *
      ** Entry List
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
      *
     C                   PARM                    P@BCAT
     C                   PARM                    P@BIDTFm
     C                   PARM                    P@BIDTTo
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
     C/EJECT
      /COPY ZACPYSRC,PSSR_ILE
