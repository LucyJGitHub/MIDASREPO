     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Initialization Program for CER034')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD000099 - SD Additional Customer Initialization Program     *
      *             for CER034                                        *
      *                                                               *
      *  Function:  This module will initialize the newly introduced  *
      *             fields on SDACUSPD                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24075           Date 22May09               *
      *                 BUG22529           Date 09Feb09               *
      *                 BUG22611           Date 02Feb09               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *--------------------------------------------------------------**
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG24075 - Addition of features on SCSARPPD                  *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  BUG22611 - German Features initialization pgm error          *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInitACUS - Initialize fields on SDACUSPD                   *
      *  *INZSR    - Program Initialisation Routine                   *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD Additional customer details update
      *
     FSDACUSL0  UF A E           K DISK    INFSR(*PSSR)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line include (among others) the LDA layout
      ** and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
      *
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
      ** External DS for Securities clients
      *
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** First DS for Access programs - short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access programs - long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for SAR Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D*Indicators      DS                  Based(IndicatorP)                                BUG22611
     D*EndOfFile               1      1                                                     BUG22611
     D*ErrOnFile               2      2                                                     BUG22611
      *
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PCustNo         S              6A
     D CER034          S              1A
     D CER038          S              1A
     D CER041          S              1A
     D CER047          S              1A
     D CER048          S              1A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialize new fields on Additional Customer
      *
     C                   EXSR      SRInitACUS
      *
      ** Program Termination
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitACUS - Initialize fields on SDACUSPD                   *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRInitACUS    BEGSR
      *
      ** Read Additional Customer File
      *
     C     *LOVAL        SETLL     @ACUSL0
     C                   READ      @ACUSL0
     C**********         DOW       EndOfFile = False                                        BUG22611
     C                   DOW       NOT(%EOF(SDACUSL0))                                      BUG22611
      *
      ** Initialize fields for LF037 - KWG Reporting
      *
     C                   IF        CER047 = 'Y'
     C                             AND E5S24C = *BLANKS                                     BUG24075
      *
     C                   EVAL      E5S24C = 'N'
      *
     C                   ENDIF
      *
      ** Initialize fields for LF039 - Correspondence
      *
     C                   IF        CER038 = 'Y'
     C                             AND E5LNID = *BLANKS                                     BUG24075
      *
     C                   EVAL      E5LNID = 'GB'
     C                   EVAL      E5CTYP = 'DEFAULT'
      *
     C                   ENDIF
      *
     C                   IF        CER041 = 'Y'
     C                             AND E5ZCFG = *BLANKS                                     BUG24075
      *
     C                   EVAL      E5ZCFG = 'N'
      *
     C                   ENDIF
      *
      ** Initialize fields for LF046 - New Customer Fields
      ** and Enquiries
      *
     C                   IF        CER034 = 'Y'
     C                             AND E5FXCU = *BLANKS                                     BUG24075
      *
     C                   EVAL      E5FXCU = 'N'
     C                   EVAL      E5SMBR = 'N'
      *
      ** For Securities Customer Flag
      *
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      E5CUST        PCustNo
     C     SDSECS        PARM      SDSECS        DSSDY
      *
      ** If Customer is also a Security Client,
      *
     C                   IF        PRtcd = *BLANKS
      *
      ** Set the Securities Customer flag to 'Y'
      *
     C                   EVAL      E5SECU = 'Y'
      *
      ** If Customer not found on Securities File, set Securities
      ** Customer flag to 'N'
      *
     C                   ELSEIF    PRtCd = '*NRF   '
     C                   EVAL      E5SECU = 'N'
      *
      ** If call to program ended in error'
      *
     C                   ELSEIF    PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCustNo
     C                   EVAL      DBFILE = 'SDSECSPD'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      ** Initialize fields for LF047 - German Taxes
      *
     C                   IF        CER048 = 'Y'
     C                             AND E5PIND = *BLANKS                                     BUG24075
     C                   EVAL      E5PIND = 'N'
     C                   ENDIF
      *
      ** Update Additional Customer Record
      *
     C                   UPDATE    @ACUSL0
     C                   READ      @ACUSL0
      *
     C                   ENDDO
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
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Check for Switchable Feature for CER034
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CER034'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error
      *
     C                   IF        (PRtCd <> *BLANKS) AND
     C                             (PRtCd <> '*NRF')
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CER034'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CER034 = 'Y'
     C                   ELSE
     C                   EVAL      CER034 = 'N'
     C                   ENDIF
      *
      ** Check for Switchable Feature for CER038
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CER038'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error
      *
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF')
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CER038'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CER038 = 'Y'
     C                   ELSE
     C                   EVAL      CER038 = 'N'
     C                   ENDIF
      *
      ** Check for Switchable Feature for CER041
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CER041'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error
      *
     C                   IF        (PRtCd <> *BLANKS) AND
     C                             (PRtCd <> '*NRF')
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CER041'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CER041 = 'Y'
     C                   ELSE
     C                   EVAL      CER041 = 'N'
     C                   ENDIF
      *
      ** Check for Switchable Feature for CER047
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CER047'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error
      *
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF')
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CER047'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CER047 = 'Y'
     C                   ELSE
     C                   EVAL      CER047 = 'N'
     C                   ENDIF
      *
      ** Check for Switchable Feature for CER048
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CER048'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error
      *
     C                   IF        (PRtCd <> *BLANKS) AND
     C                             (PRtCd <> '*NRF')
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CER048'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CER048 = 'Y'
     C                   ELSE
     C                   EVAL      CER048 = 'N'
     C                   ENDIF
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
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: *INZSR, SRInitACUS                                *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
