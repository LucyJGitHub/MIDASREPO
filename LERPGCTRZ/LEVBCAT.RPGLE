     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Basel II Past Due Classification')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVBCAT - Validate Basel II Past Due Classification          *
      *                                                               *
      *  Function: This function receives a parameter containing the  *
      *            Basel II Past Due Classification value and         *
      *            confirms whether it is a valid entry or not        *
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

      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the MM standard declares:

     D/COPY ZACPYSRC,STDDECLARE

      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'

     D/COPY ZACPYSRC,PSDS

      /EJECT

      ** Manually included D-specs
      ** =========================

      ** Named constants
      ** ===============

      ** Arrays and Data Structures
      ** ==========================

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Customer Lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)

      ** Loan Details
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)

      ** Fee Details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)

      ** Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(LEFEEMPD)

      ** (Current) Fee record in file Format
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)   PREFIX(@@)

      ** Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)  PREFIX(CL_)

      ** Short data structure for access objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long data structure for access objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Declared variables
      ** ==================
      *
     D DSBCD           S             25    INZ DIM(9)
      *
     D DSBCAT          S              1S 0 INZ
      *
     D #A              S              9S 0 INZ
      *
     D P@BCAT          S              1S 0
     D P@BIDTFm        S              5S 0
     D P@BIDTTo        S              5S 0
     D P@MXCH          S              3S 0
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
     C                   IF        DDBCAT <> *BLANKS
     C                   EXSR      VBCAT
     C                   ENDIF
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VBCAT - Validate Basel II Past Due Classification            *
      *****************************************************************

     C     VBCAT         BEGSR
      *
      ** Check if Numeric and in Range
      *
     C                   IF        DDBCAT < '0' OR
     C                             DDBCAT > '9'
     C                   EVAL      #MsgID = '5045699'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn  = 'Error'
      *
      ** Check if Active Value
      *
     C                   ELSE
     C                   MOVE      DDBCAT        #A
      *
     C                   IF        #A > 0 AND
     C                             DSBCD(#A) = *BLANKS
     C                   EVAL      #MsgID = '5045699'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Check if Correct Classification level for Initial Date
      *
     C                   ELSE
     C                   IF        P@BCAT <> 0 AND
     C                             P@BCAT <> #A
     C                   EVAL      #MsgID = '5045697'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Check if Maximum No of Changes Exceeded
      *
     C                   ELSE
     C                   IF        P@MXCH > 0 AND
     C                             P@MXCH <= @@FEBICC
     C                   EVAL      #MsgID = '5045702'
     C                   EVAL      ErrorFound = 'W'
     C                   EVAL      RetCodeIn = 'Warning'
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
      ** Set Basel II Classification Descriptions
      *
     C                   EVAL      DSBCD(1) = BPCLD1
     C                   EVAL      DSBCD(2) = BPCLD2
     C                   EVAL      DSBCD(3) = BPCLD3
     C                   EVAL      DSBCD(4) = BPCLD4
     C                   EVAL      DSBCD(5) = BPCLD5
     C                   EVAL      DSBCD(6) = BPCLD6
     C                   EVAL      DSBCD(7) = BPCLD7
     C                   EVAL      DSBCD(8) = BPCLD8
     C                   EVAL      DSBCD(9) = BPCLD9
      *
      ** Program, module and procedure names for DB error processing
      ** The following /COPY sets these values, and also defines LDA
      ** as external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** @DEFN - @DEFN: Definition Rountine                          *
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
      *
     C                   PARM                    SDBANK
     C                   PARM                    SDCLND
     C                   PARM                    SDLOAN
     C                   PARM                    SDFEE
     C                   PARM                    TranInPrim
     C                   PARM                    CrFeFilFmt
     C                   PARM                    ClilFilFmt

     C                   ENDSR
     C/EJECT
      /COPY ZACPYSRC,PSSR_ILE
