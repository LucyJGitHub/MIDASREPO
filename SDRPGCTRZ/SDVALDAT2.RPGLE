     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Exemption Threshold Dates')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVALDAT2 - SD Additional Customer Validate Date Fields - 2  *
      *                                                               *
      *  Function:  This module validates the different Date fields   *
      *             on the new Additional Customer Details screen     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 AR741461           Date 06May11               *
      *                 AR737976           Date 14Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24701           Date 01Jul09               *
      *                 BUG23883           Date 04May09               *
      *                 BUG23779           Date 21Apr09               *
      *                 BUG23657           Date 14Apr09               *
      *                 BUG22535           Date 24Feb09               *
      *                 BUG22751           Date 10Feb09               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *--------------------------------------------------------------**
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR741461 - CUSD Usability Issues (Child: AR741462)           *
      *  AR737976 - Three (3) fields were not highlighted to reflect  *
      *             that these needs to be populated (Child: AR737977)*
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24701 - Problem with Threshold Expiry Date Default        *
      *  BUG23883 - Certificate dates do not default until validation *
      *             on last screen                                    *
      *  BUG23779 - Threshold Expiry Date error should only check if  *
      *             record is changed                                 *
      *  BUG23657 - Threshold/Certificate Value date and expiry date  *
      *  BUG22535 - Additional Cusd Problem with Date fields          *
      *  BUG22751 - Date fields retain values even when blanked out   *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SRValDate - Validate Exemption Threshold Dates               *
      *  *INZSR - Program Initialisation Routine                      *
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
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *                                                                                     BUG23657
      ** Midas SD Cust Details by Country of Tax                                            BUG23657
      *                                                                                     BUG23657
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG23657
      *
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
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                     BUG23657
      ** Second DS for access programs, long data structure                                 BUG23657
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   BUG23657
      *                                                                                     BUG23657
      ** Third DS for access programs, long data structure                                  BUG23779
     D DSLDY         E DS                  Extname(DSLDY)                                   BUG23779
      *                                                                                     BUG23779
      ** External DS based on Customer                                                      BUG23657
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG23657
      *                                                                                     BUG23657
      ** External DS for Additional Customer Details                                        BUG23779
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                                BUG23779
      *
      ** External DS for accessing Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
     D PDatFld         S              6A
     D OKDatFld        S              1A
     D DDEXTH          S              6A
     D DDCUST          S              6A                                                    BUG23657
     D DDJATP          S              1A
     D PFldName        S             10A
     D PDateOut        S              5P 0
     D PZDate          S              6A
     D PZDayNo         S              5P 0
     D PErrorFlag      S              1A
     D PRtcd           S              7A
     D POptn           S              7A
     D PKySt           S              7A                                                    BUG23657
     D PColc           S              2A                                                    BUG23657
     D KFCusn          S              6A                                                    BUG23657
     D KFCTax          S              2A                                                    BUG23657
     D WCrtp           S              1A                                                    BUG23657
      ** Parameter for ZDATE2                                                               BUG23657
     D ZDate           S              6  0                                                  BUG23657
     D ZADATE          S              7A                                                    BUG23657
     D DfltFlag        S              1A                                                    BUG23883
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
      *                                                                                     BUG23657
      ** Get customer certificate dates                                                     BUG23657
     C                   EXSR      SrGetCerDt                                               BUG23657
      *                                                                                     BUG23657
      ** Get additional customer details                                                    BUG23779
     C                   EXSR      SrGetACust                                               BUG23779
      *
      ** Date Fields Validation
      *
     C                   EXSR      SRValDate
      *                                                                                     BUG22751
      ** Reset Output field when Date on screen is BLANKS                                   BUG22751
      *                                                                                     BUG22751
     C                   IF        OKDatFld  = 'Y' AND                                      BUG22751
     C                             PDatFld = *BLANKS                                        BUG22751
     C                   EVAL      PDateOut = *ZEROS                                        BUG22751
     C                   ENDIF                                                              BUG22751
      *
      ** Incase of an Error
      *
     C                   IF        OKDatFld  = 'N'
     C                   EVAL      RetCodeIn  = '*ERROR'
     C                   ENDIF
      *
      ** Return from program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDate - Validate Exemption Threshold Dates               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRValDate     BEGSR
      *
      ** If Exemption Threshold is BLANKS, Expiry Date may or may
      ** not be BLANKS
      *
     C                   IF        DDEXTH = *BLANKS AND
     C                             PDatFld <> *BLANKS AND
     C                             PFldName <> 'DDETXT'
      *
     C                   EVAL      OKDatFld = 'N'
     C                   EVAL      Idx = Idx + 1
      *
      ** Populate appropriate Error Field Name
      *
     C                   IF        PFldName = 'DDEADT'
     C**********         EVAL      FldNamXAr(Idx) = 'DDEADT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EADT'                                AR737976
     C                   EVAL      MsgIdXAr(Idx) = 'USR6502'
     C                   ENDIF
      *
     C                   IF        PFldName = 'DDEVDT'
     C**********         EVAL      FldNamXAr(Idx) = 'DDEVDT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EVDT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR6503'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Joint Account Type is 'Y' or 'I' and Exemption Threshold
      ** is not BLANKS, Approval and Value Date cannot be BLANKS
      *
     C                   IF        (DDJATP = 'Y' or DDJATP = 'I') AND
     C                             DDEXTH <> *BLANKS
      *
     C                   IF        PFldName <> 'DDETXT'
      *
     C                   IF        PDatFld = *BLANKS
      *                                                                                     BUG23657
     C                   IF        WCrtp = 'Y'                                              BUG23657
     C                   SELECT                                                             BUG23657
     C                   WHEN      PFldName = 'DDEADT'                                      BUG23657
     C                   EVAL      PZDayNo = AXCADT                                         BUG23657
     C                   WHEN      PFldName = 'DDEVDT'                                      BUG23657
     C                   EVAL      PZDayNo = AXCVDT                                         BUG23657
     C                   ENDSL                                                              BUG23657
     C                   EXSR      SRZDate2                                                 BUG23657
     C                   MOVEL     ZDate         PDatFld                                    BUG23657
     C                   EVAL      DfltFlag = 'Y'                                           BUG23883
     C                   ELSE                                                               BUG23657
      *
     C                   EVAL      OKDatFld = 'N'
     C                   EVAL      Idx = Idx + 1
      *
      ** Populate appropriate Error Field Name
      *
     C                   IF        PFldName = 'DDEADT'
     C**********         EVAL      FldNamXAr(Idx) = 'DDEADT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EADT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx) = 'USR5906'
     C                   ENDIF
      *
     C                   IF        PFldName = 'DDEVDT'
     C**********         EVAL      FldNamXAr(Idx) = 'DDEVDT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EVDT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5910'
     C                   ENDIF
     C                   ENDIF                                                              BUG23657
      *
     C                   ELSE
      *
     C                   TESTN                   PDatFld              9798                  BUG22535
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDatFld
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      'N'           PErrorFlag
      *
     C                   IF        PErrorFlag = 'Y'
     C                             or (*IN97 = '0' and *IN98 = '0')                         BUG22535
      *
     C                   EVAL      OKDatFld = 'N'
     C                   EVAL      Idx = Idx + 1
      *
      ** Populate appropriate Error Field Name
      *
     C                   IF        PFldName = 'DDEADT'
     C**********         EVAL      FldNamXAr(Idx) = 'DDEADT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EADT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5907'
     C                   ENDIF
      *
     C                   IF        PFldName = 'DDEVDT'
     C**********         EVAL      FldNamXAr(Idx) = 'DDEVDT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EVDT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5911'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        PFldName = 'DDEADT' OR
     C                             PFldName = 'DDEVDT'
      *
      ** Date Cannot be later than Run Day Number
      *
     C                   IF        PZDayNo > BJRDNB
      *
     C                   EVAL      OKDatFld = 'N'
     C                   EVAL      Idx = Idx + 1
      *
      ** Populate appropriate Error Field Name
      *
     C                   IF        PFldName = 'DDEADT'
     C**********         EVAL      FldNamXAr(Idx) = 'DDEADT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EADT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx) = 'USR5908'
     C                   ENDIF
      *
     C                   IF        PFldName = 'DDEVDT'
     C**********         EVAL      FldNamXAr(Idx) = 'DDEVDT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EVDT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5912'
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      PDateOut = PZDayNo
      *
     C                   ENDIF
      *
     C                   ENDIF
      ** PFldName = 'DDETXT'                                                                BUG23657
      *                                                                                     BUG23657
     C                   ELSE                                                               BUG23657
     C                   IF        PDatFld = *BLANKS  AND                                   BUG23657
     C                             WCrtp = 'Y'                                              BUG23657
     C                   IF        AXCEEX <> *ZERO                                          BUG24701
     C                   EVAL      PZDayNo = AXCEEX                                         BUG23657
     C                   EXSR      SRZDate2                                                 BUG23657
     C                   MOVEL     ZDate         PDatFld                                    BUG23657
     C                   EVAL      DfltFlag = 'Y'                                           BUG23883
     C                   ENDIF                                                              BUG24701
     C                   ENDIF                                                              BUG23657
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** For Exemption Expiry Date
      *
     C                   IF        (DDJATP = 'Y' or DDJATP = 'I') AND
     C                             PFldName = 'DDETXT' AND
     C                             PDatFld <> *BLANKS
      *
     C                   TESTN                   PDatFld              9798                  BUG22535
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDatFld
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      'N'           PErrorFlag
      *
     C                   IF        PErrorFlag = 'Y'
     C                             or (*IN97 = '0' and *IN98 = '0')                         BUG22535
      *
     C                   EVAL      OKDatFld = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDETXT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5ETXT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5915'
      *
     C                   ELSE
      *
      ** Date Cannot be earlier than Run Day Number
      *
     C                   IF        PZDayNo < BJRDNB
     C                             AND PZDayNo <> E5ETXT                                    BUG23779
      *
     C                   EVAL      OKDatFld = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'DDETXT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5ETXT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx) = 'USR5916'
      *
     C                   ELSE
      *
     C                   EVAL      PDateOut = PZDayNo
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Entry only permitted for Joint Account Type 'Y' or 'I'
      *
     C                   IF        DDJATP <> 'Y' AND
     C                             DDJATP <> 'I' AND
     C                             PDatFld <> *BLANKS
      *
     C                   EVAL      OKDatFld = 'N'
     C                   EVAL      Idx = Idx + 1
      *
      ** Populate appropriate Error Field Name
      *
     C                   IF        PFldName = 'DDEADT'
     C**********         EVAL      FldNamXAr(Idx) = 'DDEADT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EADT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5909'
     C                   ENDIF
      *
     C                   IF        PFldName = 'DDEVDT'
     C**********         EVAL      FldNamXAr(Idx) = 'DDEVDT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5EVDT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5913'
     C                   ENDIF
      *
     C                   IF        PFldName = 'DDETXT'
     C**********         EVAL      FldNamXAr(Idx) = 'DDETXT'                                AR737976
     C                   EVAL      FldNamXAr(Idx) = 'E5ETXT'                                AR737976
     C                   EVAL      MsgIDXAr(Idx)  = 'USR5917'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                     BUG23657
      /EJECT                                                                                BUG23657
      *****************************************************************                     BUG23657
      *                                                               *                     BUG23657
      *  SrGetCerDt - Get customer certificate dates                  *                     BUG23657
      *                                                               *                     BUG23657
      *  Called by: MAIN Processing                                   *                     BUG23657
      *                                                               *                     BUG23657
      *  Calls: None                                                  *                     BUG23657
      *                                                               *                     BUG23657
      *****************************************************************                     BUG23657
     C     SrGetCerDt    BEGSR                                                              BUG23657
      *                                                                                     BUG23657
     C                   CALL      'AOCUSTR0'                                               BUG23657
     C                   PARM      *BLANKS       PRtCd                                      BUG23657
     C                   PARM      '*KEY'        POptn                                      BUG23657
     C                   PARM                    DDCUST                                     BUG23657
     C                   PARM                    PKySt                                      BUG23657
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG23657
      *                                                                                     BUG23657
     C                   IF        PRtCd =  *BLANKS                                         BUG23657
     C                   EVAL      PColc  = BBCOLC                                          BUG23657
     C                   ENDIF                                                              BUG23657
      *                                                                                     BUG23657
     C                   EVAL      KFCusn = DDCUST                                          BUG23657
     C                   EVAL      KFCTax = BBCOLC                                          BUG23657
      *                                                                                     BUG23657
     C                   EVAL      WCrtp = 'N'                                              BUG23657
     C     KLActx        CHAIN     SDACTXL1                                                 BUG23657
     C                   IF        %FOUND(SDACTXL1)                                         BUG23657
     C                   IF        AXCRTP <> *BLANKS                                        BUG23657
     C                   EVAL      WCrtp = 'Y'                                              BUG23657
     C                   ENDIF                                                              BUG23657
     C                   ENDIF                                                              BUG23657
      *                                                                                     BUG23657
     C                   ENDSR                                                              BUG23657
      *****************************************************************                     BUG23657
      /EJECT                                                                                BUG23657
      *****************************************************************                     BUG23657
      *                                                               *                     BUG23657
      *  SRZDate2 - Format a date for output                          *                     BUG23657
      *                                                               *                     BUG23657
      *  Called by: SRValDate                                         *                     BUG23657
      *                                                               *                     BUG23657
      *  Calls: None                                                  *                     BUG23657
      *                                                               *                     BUG23657
      *****************************************************************                     BUG23657
     C     SRZDate2      BEGSR                                                              BUG23657
      *                                                                                     BUG23657
     C                   CALLB     'ZDATE2'                                                 BUG23657
     C                   PARM                    PZDayNo                                    BUG23657
     C                   PARM                    BJDFIN                                     BUG23657
     C                   PARM                    ZDate                                      BUG23657
     C                   PARM                    ZADATE                                     BUG23657
      *                                                                                     BUG23657
     C                   ENDSR                                                              BUG23657
      *****************************************************************                     BUG23779
      /EJECT                                                                                BUG23779
      *****************************************************************                     BUG23779
      *                                                               *                     BUG23779
      *  SrGetACust - Get additional customer details                 *                     BUG23779
      *                                                               *                     BUG23779
      *  Called by: MAIN Processing                                   *                     BUG23779
      *                                                               *                     BUG23779
      *  Calls: None                                                  *                     BUG23779
      *                                                               *                     BUG23779
      *****************************************************************                     BUG23779
     C     SrGetACust    BEGSR                                                              BUG23779
      *                                                                                     BUG23779
     C                   CALL      'AOACUSR0'                                               BUG23779
     C                   PARM      *Blanks       PRTCD                                      BUG23779
     C                   PARM      '*KEY   '     POPTN                                      BUG23779
     C                   PARM                    DDCUST                                     BUG23779
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG23779
      *                                                                                     BUG23779
      ** Database Error                                                                     BUG23779
      *                                                                                     BUG23779
     C                   IF        PRTCD <> *Blanks                                         BUG23779
     C                             AND PRTCD <> '*NRF   '                                   BUG23779
     C                   EVAL      DBFILE = 'SDACUSPD'                                      BUG23779
     C                   EVAL      DBASE = 902                                              BUG23779
     C                   EVAL      DBKEY = DDCUST                                           BUG23779
     C                   EXSR      *PSSR                                                    BUG23779
     C                   ENDIF                                                              BUG23779
      *                                                                                     BUG23779
     C                   IF        PRTCD = '*NRF'                                           AR741461
     C                   CLEAR                   SDACUS                                     AR741461
     C                   ENDIF                                                              AR741461
      *                                                                                     AR741461
     C                   ENDSR                                                              BUG23779
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
      ** Date Field to be Validated
      *
     C                   PARM                    PDatFld
      *
      ** Exemption Threshold
      *
     C                   PARM                    DDEXTH
      *
      ** Joint Account Type
      *
     C                   PARM                    DDJATP
      *
      ** Field Name to be Validated
      *
     C                   PARM                    PFldName
      *                                                                                     BUG23657
      ** Customer Number to get Certificate dates                                           BUG23657
      *                                                                                     BUG23657
     C                   PARM                    DDCUST                                     BUG23657
      *
      ** Outputs
      *
      ** Valid Date Field
      *
     C                   PARM                    PDateOut
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Approval Date
      *
     C                   PARM                    OKDatFld
      *                                                                                     BUG23883
      ** Indicator to check if defaulting has occured on this screen                        BUG23883
      *                                                                                     BUG23883
     C                   PARM                    DfltFlag                                   BUG23883
      *
      ** Access Bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *                                                                                     BUG23657
     C     KLActx        KLIST                                                              BUG23657
     C                   KFLD                    KFCusn                                     BUG23657
     C                   KFLD                    KFCTax                                     BUG23657
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
