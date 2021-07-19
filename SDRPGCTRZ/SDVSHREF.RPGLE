     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Addnl Cust. Validate Spouse/Husband Ref')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVSHREF - SD Additional Customer Validate Spouse/Husband    *
      *             Reference                                         *
      *                                                               *
      *  Function:  This module validates the Spouse Reference        *
      *             entered on screen                                 *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 17Aug17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD025586           Date 23Mar14               *
      *                 AR786101           Date 09Jun11               *
      *                 AR744062           Date 14Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender fields for Non-Account Holder *
      *           (Recompile)                                         *      
      *  MD046248 - Finastra Rebranding                               *
      *  MD025586 - Incorrect error message displayed when 'Spouse    *
      *             Reference' field is left blank                    *
      *  AR786101 - Error encountered due to closed customer          *
      *  AR744062 - "Spouse Reference" field should be in red font    *
      *             (Child: AR744063)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVSHRef - Validate Spouse/Husband Reference                 *
      *  *INZSR   - Program Initialisation Routine                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
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
      ** External DS for Non-account Holders Details
      *
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      *
      ** External DS for Customer Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Long DS for access programs
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** External DS for Tax codes details
      *
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
      *
      ** External DS based on Branch file
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  WQQDFAC      E                     EXTFLD(QQDFAC)
      *
      ** External DS based on Location Codes
      *
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
     D DDSHRF          S             10A
     D DDJATP          S              1A
     D DDCUST          S              6A
     D DDEXTH          S              6A
     D OKSHRF          S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D PKyst           S              7A
     D PKey            S             10A
     D PColc           S              2A
     D PCntry          S              2A
     D WExThVal        S              6P 0
     D NewCus          S              1A                                                    MD025586
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
      ** Validate Spouse/Husband Reference
      *
     C                   EXSR      SRVSHRef
      *
     C                   IF        OKSHRF = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSHRef - Validate Spouse/Husband Reference                 *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVSHRef      BEGSR
      *
     C                   IF        DDSHRF <> *BLANKS
      *
      ** Check if it is a valid Customer Number
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C     PKey          PARM      DDSHRF        PKey
     C                   PARM                    PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
     C                             AND PRtcd <> '*CUSDEL'                                   AR786101
     C                             AND PRtcd <> '*CUSCLS'                                   AR786101
      *
      ** Check if it is a valid Non - Account Holder
      *
     C                   CALLB     'AONAHOR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C     PKey          PARM      DDSHRF        PKey
     C     SDNAHO        PARM      SDNAHO        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      OKSHRF = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDSHRF'                                AR744062
     C                   EVAL      FldNamXAr(Idx) = 'E5SHRF'                                AR744062
     C                   EVAL      MsgIdXAr (Idx) = 'USR5901'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDSHRF = '?'
     C                   EVAL      DDSHRF = PKey
     C                   ENDIF
      *
      ** Setup key for Country of Tax
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDCUST        PKey
     C                   PARM                    PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      PColc = BBCOLC
     C                   ENDIF
     C                   IF        PRtcd = '*NRF'                                           MD025586
     C                   EVAL      NewCus = 'Y'                                             MD025586
     C                   ENDIF                                                              MD025586
      *
      ** Accessing the Branch Details of the Customer
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    BBBRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** Accessing the Location Details from the Branch Location
      *
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    A8LCCD
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *
     C                   IF        PRtCd =  *BLANKS
     C                   EVAL      PCntry = DVCNCD
     C                   ENDIF
      *
      ** Retrieve the Individual Threshold value
      *
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCntry
     C                   PARM                    PColc
     C     SDCTTX        PARM      SDCTTX        DSLDY
      *
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      EWINTH = *ZEROS
     C                   ENDIF
      *
      ** Move Exemption Threshold to Numeric field
      *
     C                   MOVEL     DDEXTH        WExThVal
      *
      ** If Joint Account Type is 'Y', and Exemption Threshold is
      ** greater than the Individual Threshold, then Spouse/Husband
      ** Reference cannot be BLANKS
      *
     C                   IF        DDJATP = 'Y' AND
     C                             WExThVal > EWINTH AND
     C                             DDSHRF = *BLANKS
      *
     C                   EVAL      OKSHRF = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDSHRF'                                AR744062
     C                   EVAL      FldNamXAr(Idx) = 'E5SHRF'                                AR744062
     C                   IF        NewCus = 'Y' AND EWINTH = 0                              MD025586
     C                   EVAL      MsgIdXAr (Idx) = '5046500'                               MD025586
     C                   ELSE                                                               MD025586
     C                   EVAL      MsgIdXAr (Idx) = 'USR5902'
     C                   ENDIF                                                              MD025586
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
      ** Spouse/Husband Reference
      *
     C                   PARM                    DDSHRF
      *
      ** Other fields
      *
     C                   PARM                    DDJATP
     C                   PARM                    DDEXTH
     C                   PARM                    DDCUST
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Spouse/Husband Reference
      *
     C                   PARM                    OKSHRF
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
