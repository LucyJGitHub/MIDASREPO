     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Reporting Past Due Classificatn')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVRCAT - Validate Reporting Past Due Classification         *
      *                                                               *
      *  Function: This function receives a parameter containing the  *
      *            Reporting Past Due Classification value and        *
      *            confirms whether it is a valid entry or not        *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CLE071             Date 18Jul18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      /EJECT
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
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)   PREFIX(@@)
      *
      ** Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)  PREFIX(CL_)
      *
      ** Short data structure for access objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long data structure for access objects
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D DSRCD           S             25    INZ DIM(9)
      *
     D DSRCAT          S              1S 0 INZ
      *
     D #A              S              9S 0 INZ
      *
     D P@RCAT          S              1S 0
     D P@RIDTFm        S              5S 0
     D P@RIDTTo        S              5S 0
     D P@MXCH          S              3S 0

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
     C                   IF        DDRCAT <> *BLANKS
     C                   EXSR      VRCAT
     C                   ENDIF
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRCAT - Validate Reporting Past Due Classification           *
      *****************************************************************
      *
     C     VRCAT         BEGSR
      *
      ** Check if Numeric and in Range
      *
     C                   IF        DDRCAT < '0'
     C                             OR DDRCAT > '9'
     C                   EVAL      #MsgID = '5045795'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Check if Active Value
      *
     C                   ELSE
     C                   MOVE      DDRCAT        #A
      *
     C                   IF        #A > 0
     C                             AND DSRCD(#A) = *BLANKS
     C                   EVAL      #MsgID = '5045795'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Check if Correct Classification level for Initial Date
      *
     C                   ELSE
     C                   IF        P@RCAT <> 0
     C                             AND P@RCAT <> #A
     C                   EVAL      #MsgID = '5045771'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** Check if Maximum No of Changes Exceeded
      *
     C                   ELSE
     C                   IF        P@MXCH > 0
     C                             AND P@MXCH <= @@FERICC
     C                   EVAL      #MsgID = '5045772'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Warning'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** *INZSR: Initialisation Rountine                              *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialisation
      *
     C                   EVAL      RetCodeIn = *BLANKS
      *
      ** Set Reporting Classification Descriptions
      *
     C                   EVAL      DSRCD(1) = BPRCD1
     C                   EVAL      DSRCD(2) = BPRCD2
     C                   EVAL      DSRCD(3) = BPRCD3
     C                   EVAL      DSRCD(4) = BPRCD4
     C                   EVAL      DSRCD(5) = BPRCD5
     C                   EVAL      DSRCD(6) = BPRCD6
     C                   EVAL      DSRCD(7) = BPRCD7
     C                   EVAL      DSRCD(8) = BPRCD8
     C                   EVAL      DSRCD(9) = BPRCD9
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
      ** @DEFN - Definition Rountine                                  *
      *****************************************************************
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
