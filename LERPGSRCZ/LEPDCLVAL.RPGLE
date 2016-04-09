     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - validation')                *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEPDCLR - Past Due Call Loan Conversion: Validation          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD020029           Date 12Apr13               *
      *  Prev Amend No. AR1078092          Date 20Jan13               *
      *                 264044             Date 01Aug12               *
      *                 263415             Date 01Aug12               *
      *                 263627             Date 01Aug12               *
      *                 263289             Date 01Aug12               *
      *                 262431             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020029 - Fees transactions went into repair queue          *
      *  AR1078092 - Event Code of 45021706 (settlement account is    *
      *              (blocked) is not user configurable               *
      *  264044 - CLE134 Test PDCL SOAP API                           *
      *  263415 - Add extra parameter to call of LEVPDAM.             *
      *  263627 - Facility Details aren't on LEFEED for Loan Fees.    *
      *  263289 - FSEQ is Fee Sequence not Facility Sequence.         *
      *  262431 - P2: CLE134 Serious Midas Error                      *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
 
      ** The following /COPY includes (among others) the LDA layout
      ** and the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
 
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
 
      ** Transaction Details in screen format
 
     D TrnDets       E DS                  EXTNAME(LEPDCLPD)
 
      ** Transaction Details OK indicators
 
     D OKTrnDets     E DS                  EXTNAME(LEEPDCLPD)
 
      ** Valid Transaction Details layout
 
     D ValidPDCL     E DS                  EXTNAME(LEVPDCLPD)
 
      ** Loans File Format
 
     D PDCLFilFmtLoanE DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(C_)
 
      ** Loans File Format 2
 
     D PDCLFilFmtLoaKE DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(K_)
 
      ** Fees File Format
 
     D PDCLFilFmtFee E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(E_)
 
      ** Facilities File Format
 
     D PDCLFilFmtFctyE DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(M_)
 
      ** Formatting Details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** Formatting Details
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
      ** Formatting Details
 
     D DSSDY         E DS
 
      ** Short data structure for access objects
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Formatting Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Formatting Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Formatting Details
 
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
 
      ** Formatting Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
 
      ** External DS for Fee Details
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
 
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
 
     D WIdx            S              3P 0
     D I               S              3p 0
 
     D RespMode        S              1A
 
      ** Establish the transaction type
 
     D RecordType      S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
 
     D NBCDY           S              3  0
     D NBCSD           S              5  0
     D NRCDY           S              3  0
     D NRCSD           S              5  0
 
      ** Additional Field Definitions
     D @KEY1           S             10
     D @KYST           S              7
     D @CCY            S              3
     D @@RETC          S             10
     D @@AMTW          S             15  0
     D W@DECP          S              1  0
     D @@DCSP          S              1
     D @@AMTP          S             16
     D @@AMTD          S             17
     D @FECD           S              2
     D PLoanType       S              2
     D PLSubType       S              2
     D PLClass         S              4
     D WSTDT           S              5  0
     D WENDT           S              5  0
     D PRtcd           S              7
     D POptn           S              7
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------+
      ** ¦                                                          ¦
      ** ¦ Initial processing is performed automatically:           ¦
      ** ¦ the *INZSR is executed at program activation.            ¦
      ** ¦                                                          ¦
      ** +----------------------------------------------------------+
      ** Initial processing is performed automatically: *inzsr is
      ** executed at program activation.
 
      ** Setup fields that do not need validation
 
     C                   EXSR      FLDCNST
 
      ** Validate indicators
 
     C                   EXSR      VINDIC
 
      ** Validate Start Value Date
 
     C                   EXSR      VSTVALD
 
      ** Validate Classifications
 
     C                   EXSR      VCLASS
 
      ** Validate Classification Dates
 
     C                   EXSR      VCLASD
 
      ** Validate the take on accounts, if entered
 
     C                   EXSR      VTKONAC
 
      ** Validate Past Due Amounts
 
     C                   EXSR      VPDCLAM
 
      ** Validate Indicators combinations
 
     C                   EXSR      VCXFLD
 
      ** Validate extra Loan/Fees values/combinations before reaching                         262431
      ** LEPDCLUPD/LECLIPUPD                                                                  262431
 
     C                   EXSR      VLNFLD                                                     262431
                                                                                              262431
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Setup fields which are not validated
      *****************************************************************
 
     C     FLDCNST       BEGSR
 
     C                   EXSR      RESETERRS
 
      ** If this is a Fee based PDCL
 
     C                   IF        RecordType = FeeLoan
     C                             or RecordType = FeeFacility
 
      ** Fee original data
 
     C                   MOVE      DDFECU        NFECU
     C                   MOVE      DDFFAC        NFFAC
     C                   MOVE      DDFSEQ        NFSEQ
     C                   MOVE      DDFLNO        NFLNO
 
      ** Fee Code
 
     C                   MOVE      E_FEFCOD      DDFCOD
     C                   MOVE      E_FEFCOD      NFCOD
 
      ** Facility details
 
     C                   MOVE      E_FECNUM      DDFACU
     C**********         MOVE      E_FEFACL      DDFACT                                       263289
     C**********         MOVE      E_FEFSEQ      DDFCNO                                       263289
     C                   IF        RecordType = FeeLoan                                       263627
     C                   MOVEL     C_FTYP        DDFACT                                       263627
     C                   MOVE      C_FSEQ        DDFCNO                                       263627
     C                   ELSE                                                                 263627
     C                   MOVEL     E_FEFACL      DDFACT                                       263289
     C                   MOVE      E_FEFACL      DDFCNO                                       263289
     C                   ENDIF                                                                263627
 
     C                   MOVE      E_FECNUM      NFACU
     C**********         MOVE      E_FEFACL      NFACT                                        263289
     C**********         MOVE      E_FEFSEQ      NFCNO                                        263289
     C                   IF        RecordType = FeeLoan                                       263627
     C                   MOVEL     C_FTYP        NFACT                                        263627
     C                   MOVE      C_FSEQ        NFCNO                                        263627
     C                   ELSE                                                                 263627
     C                   MOVEL     E_FEFACL      NFACT                                        263289
     C                   MOVE      E_FEFACL      NFCNO                                        263289
     C                   ENDIF                                                                263627
 
      ** Customer Details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      E_FECNUM      @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
 
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DDCUSTOK    = 'N'
     C                   EVAL      Idx        += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCUST'
     C                   EVAL      MsgIdXAr(Idx)  = '5045626'
     C                   EVAL      DDCUST = *BLANKS
     C                   EVAL      DDCREP = *BLANKS
     C                   ELSE
     C                   EVAL      DDCUST = BBCUST
     C                   EVAL      DDCREP = BBCRNM
     C                   EVAL      NCUST = BBCUST
     C                   EVAL      NCREP = BBCRNM
     C                   ENDIF
 
      ** Currency
 
     C                   EVAL      DDCCY = E_FEFCCY
     C                   EVAL      NCCY = E_FEFCCY
 
      ** Get Transaction ccy decimal places (for editing purposes)
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @CCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD      <> *BLANKS
     C                   EVAL      DBKEY       = @CCY
     C                   EVAL      DBFILE      = 'SDCURRPD'
     C                   EVAL      DBASE       = 901
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Fee Amount
 
     C                   IF        E_FEFAMT= *ZEROS
     C                   EVAL      DDFAMT = *BLANKS
     C                   MOVE      '0'           DDFAMT
 
     C                   ELSE
 
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC
     C                   PARM      E_FEFAMT      @@AMTW
     C                   PARM      A6NBDP        W@DECP
     C                   PARM      BNDCSP        @@DCSP
     C                   PARM      *BLANK        @@AMTP
     C                   PARM      *BLANK        @@AMTD
 
     C**********         MOVE      @@AMTD        DDFAMT                                       264044
     C                   EVALR     DDFAMT = %TRIM(@@AMTD)                                     264044
     C                   ENDIF
 
     C                   Z-ADD     E_FEFAMT      NFAMT
 
      ** Retrieve FAMU indicator for Fees
 
     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDFCOD        @FECD
     C     SDFEE         PARM      SDFEE         DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DDFCODOK    = 'N'
     C                   EVAL      Idx        += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDFCOD'
     C                   EVAL      MsgIdXAr(Idx)  = '5045647'
     C                   ELSE
     C                   EVAL      DDFAMU = AUFAMU
     C                   EVAL      NFAMU = AUFAMU
     C                   ENDIF
 
     C                   ENDIF
 
      ** If this is a Loan based PDCL
 
     C                   IF        RecordType = Loan
 
      ** Original Loan number
 
     C                   MOVE      DDORLN        NORLN
 
      ** Loan Type
 
     C                   EVAL      DDLTYP = C_LTYP
     C                   EVAL      NLTYP = C_LTYP
 
      ** Loan Sub-Type
 
     C                   EVAL      DDSUTP = C_SUTP
     C                   EVAL      NSUTP = C_SUTP
     C                   EVAL      NLNCL = C_CLAS
 
      ** Facility details
 
     C                   MOVE      C_FCUS        DDFACU
     C                   MOVE      C_FTYP        DDFACT
     C                   MOVE      C_FSEQ        DDFCNO
     C                   MOVE      C_FCUS        NFACU
     C                   MOVE      C_FTYP        NFACT
     C                   MOVE      C_FSEQ        NFCNO
 
      ** Customer Details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      C_CNUM        @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
 
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DDCUSTOK    = 'N'
     C                   EVAL      Idx        += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCUST'
     C                   EVAL      MsgIdXAr(Idx)  = '5045626'
     C                   EVAL      DDCUST = *BLANKS
     C                   EVAL      DDCREP = *BLANKS
     C                   ELSE
     C                   EVAL      DDCUST = BBCUST
     C                   EVAL      DDCREP = BBCRNM
     C                   EVAL      NCUST = BBCUST
     C                   EVAL      NCREP = BBCRNM
     C                   ENDIF
 
      ** Currency
 
     C                   EVAL      DDCCY = C_CCY
     C                   EVAL      NCCY = C_CCY
 
      ** Get Transaction ccy decimal places (for editing purposes)
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @CCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD      <> *BLANKS
     C                   EVAL      DBKEY       = @CCY
     C                   EVAL      DBFILE      = 'SDCURRPD'
     C                   EVAL      DBASE       = 901
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Outstanding Principal Amount
 
     C                   IF        C_CPAM = *ZEROS
     C                   EVAL      DDLOAM = *BLANKS
     C                   MOVE      '0'           DDLOAM
 
     C                   ELSE
 
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC
     C                   PARM      C_CPAM        @@AMTW
     C                   PARM      A6NBDP        W@DECP
     C                   PARM      BNDCSP        @@DCSP
     C                   PARM      *BLANK        @@AMTP
     C                   PARM      *BLANK        @@AMTD
 
     C**********         MOVE      @@AMTD        DDLOAM                                       264044
     C                   EVALR     DDLOAM = %TRIM(@@AMTD)                                     264044
     C                   ENDIF
 
     C                   Z-ADD     C_CPAM        NLOAM
 
      ** Accrued Interest (Posted)
 
     C                   IF        C_AIPD = *ZEROS
     C                   EVAL      DDAIPD = *BLANKS
     C                   MOVE      '0'           DDAIPD
 
     C                   ELSE
 
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC
     C                   PARM      C_AIPD        @@AMTW
     C                   PARM      A6NBDP        W@DECP
     C                   PARM      BNDCSP        @@DCSP
     C                   PARM      *BLANK        @@AMTP
     C                   PARM      *BLANK        @@AMTD
 
     C**********         MOVE      @@AMTD        DDAIPD                                       264044
     C                   EVALR     DDAIPD = %TRIM(@@AMTD)                                     264044
     C                   ENDIF
 
     C                   Z-ADD     C_AIPD        NAIPD
 
      ** Loan Type/Sub-Type
 
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      C_LTYP        PLoanType
     C                   PARM      C_SUTP        PLSubType
     C                   PARM      C_CLAS        PLClass
     C     SDLOAN        PARM      SDLOAN        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DDORLNOK    = 'N'
     C                   EVAL      Idx        += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDORLN'
     C                   EVAL      MsgIdXAr(Idx)  = '5045646'
     C                   ELSE
     C                   EVAL      DDFAMU = AYFAMU
     C                   EVAL      NFAMU = AYFAMU
 
     C                   IF        DDSEIN = *BLANKS
     C                   EVAL      DDSEIN = AYSIIN
     C                   EVAL      NSEIN = AYSIIN
     C                   ENDIF
 
     C                   IF        DDCAPI = *BLANKS
     C                   EVAL      DDCAPI = AYCAPI
     C                   EVAL      NCAPI = AYCAPI
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Update error info with that returned
      ** from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Start Date
      *****************************************************************
 
     C     VINDIC        BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
 
     C                   CALLB     'LEVINDC'
     C                   PARM                    RetCodeIn
 
      ** Input
 
     C                   PARM                    DDCAPI
     C                   PARM                    DDDEPI
     C                   PARM                    DDSEIN
     C                   PARM                    DDORLN
     C                   PARM                    C_AUTO
     C                   PARM                    RecordType
     C                   PARM                    COBMode           1
 
      ** Output
 
     C                   PARM                    NCAPI
     C                   PARM                    NDEPI
     C                   PARM                    NSEIN
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     C                   PARM                    DDCAPIOK
     C                   PARM                    DDDEPIOK
     C                   PARM                    DDSEINOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Start Date
      *****************************************************************
 
     C     VSTVALD       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
     C                   IF        RecordType = Loan
     C                   EVAL      WSTDT = C_VDAT
     C                   EVAL      WENDT = BJRDNB
     C                   ELSE
     C                   EVAL      WSTDT = E_FEPSTD
     C                   EVAL      WENDT = E_FEPEND
     C                   ENDIF
 
     C                   CALLB     'LEVSTVL'
     C                   PARM                    RetCodeIn
 
      ** Input
 
     C                   PARM                    DDSDAT
     C                   PARM                    WSTDT
     C                   PARM                    WENDT
     C                   PARM                    RecordType
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
 
      ** Output
 
     C                   PARM                    NSDAT
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     C                   PARM                    DDSDATOK
     C                   PARM                    CobMode                                    MD020029
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Classifications
      *****************************************************************
 
     C     VCLASS        BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
 
     C                   CALLB     'LEVCLASS'
     C                   PARM                    RetCodeIn
 
      ** Input
 
     C                   PARM                    DDRCAT
     C                   PARM                    DDBCAT
     C                   PARM                    C_RCAT
     C                   PARM                    C_BCAT
     C                   PARM                    E_FERCAT
     C                   PARM                    E_FEBCAT
     C                   PARM                    RecordType
 
      ** Output
 
     C                   PARM                    NRCAT
     C                   PARM                    NBCAT
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     C                   PARM                    DDRCATOK
     C                   PARM                    DDBCATOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Classification Dates
      *****************************************************************
 
     C     VCLASD        BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
 
     C                   CALLB     'LEVCLASD'
     C                   PARM                    RetCodeIn
 
      ** Input
 
     C                   PARM                    DDRIDT
     C                   PARM                    DDBIDT
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    NSDAT
     C                   PARM                    C_RIDT
     C                   PARM                    C_BIDT
     C                   PARM                    E_FERIDT
     C                   PARM                    E_FEBIDT
     C                   PARM                    RecordType
 
      ** Output
 
     C                   PARM                    NRIDT
     C                   PARM                    NBIDT
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     C                   PARM                    DDRIDTOK
     C                   PARM                    DDBIDTOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Take On Accounts
      *****************************************************************
 
     C     VTKONAC       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'LEVTKAC'
     C                   PARM                    RetCodeIn
 
      ** Input
 
     C                   PARM                    TrnDets
     C                   PARM                    RecordType
 
      ** Output
 
     C                   PARM                    NTLPR
     C                   PARM                    NTLIN
     C                   PARM                    NTLFE
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     C                   PARM                    DDTLPROK
     C                   PARM                    DDTLINOK
     C                   PARM                    DDTLFEOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Amounts
      *****************************************************************
 
     C     VPDCLAM       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'LEVPDAM'
     C                   PARM                    RetCodeIn
 
      ** Input
 
     C                   PARM                    TrnDets
     C                   PARM                    C_AUTO
     C                   PARM                    E_FEAUTO
     C                   PARM                    E_FEAMTP
     C                   PARM                    BNDCSP
     C                   PARM                    RecordType
 
      ** Output
 
     C                   PARM                    NPDPR
     C                   PARM                    NPDIN
     C                   PARM                    NPDFA
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     C                   PARM                    DDPDPROK
     C                   PARM                    DDPDINOK
     C                   PARM                    DDPDFAOK
     C                   PARM                    DDSEINOK                                     263415
     C                   PARM                    COBMode                                   AR1078092
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Cross validate indicators with other fields
      *****************************************************************
 
     C     VCXFLD        BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'LEVCXFLD'
     C                   PARM                    RetCodeIn
 
      ** Input
 
     C                   PARM                    TrnDets
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    RecordType
 
      ** Output
 
     C                   PARM                    ValidPDCL
     C                   PARM                    NBCDY
     C                   PARM                    NBCSD
     C                   PARM                    NRCDY
     C                   PARM                    NRCSD
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     C                   PARM                    OKTrnDets
     C                   PARM                    COBMode
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  262431
      *****************************************************************                       262431
      ** Loan and Fees extra fields validations                                               262431
      *****************************************************************                       262431
                                                                                              262431
     C     VLNFLD        BEGSR                                                                262431
                                                                                              262431
      ** Reset variables updated by validation                                                262431
                                                                                              262431
     C                   EXSR      RESETERRS                                                  262431
                                                                                              262431
     C                   CALLB     'LEVLNFLD'                                                 262431
     C                   PARM                    RetCodeIn                                    262431
                                                                                              262431
      ** Input                                                                                262431
                                                                                              262431
     C                   PARM                    TrnDets                                      262431
     C                   PARM                    BJRDNB                                       262431
     C                   PARM                    BJDFIN                                       262431
     C                   PARM                    RecordType                                   262431
                                                                                              262431
      ** Output                                                                               262431
                                                                                              262431
     C                   PARM                    ValidPDCL                                    262431
                                                                                              262431
      ** Error fields/message IDs/message data (arrays) from/to caller                        262431
                                                                                              262431
     C                   PARM                    FldNamXAr                                    262431
     C                   PARM                    MsgIDXAr                                     262431
     C                   PARM                    MsgDtaXAr                                    262431
                                                                                              262431
     C                   PARM                    OKTrnDets                                    262431
                                                                                              262431
      ** Update error info with that returned from                                            262431
      ** the validation module                                                                262431
                                                                                              262431
     C                   EXSR      UPDATERRS                                                  262431
                                                                                              262431
     C                   ENDSR                                                                262431
      *****************************************************************                       262431
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      WFldNmXAr = *BLANK
     C                   EVAL      WMsgIDXAr = *BLANK
     C                   EVAL      WMsgDtXAr = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      ** Inputs
 
      ** Response mode
     C                   PARM                    RespMode
 
      ** PDCL Details
 
     C                   PARM                    TrnDets
     C                   PARM                    NBCDY
     C                   PARM                    NBCSD
     C                   PARM                    NRCDY
     C                   PARM                    NRCSD
 
      ** Record Type
 
     C                   PARM                    RecordType
 
      ** Transaction Details in File Format: Loan 2
 
     C                   PARM                    PDCLFilFmtLoan
 
      ** Transaction Details in File Format: Loan 2
 
     C                   PARM                    PDCLFilFmtLoaK
 
      ** Transaction Details in File Format: Fee
 
     C                   PARM                    PDCLFilFmtFee
 
      ** Transaction Details in File Format: Facility
 
     C                   PARM                    PDCLFilFmtFcty
 
      ** COB Mode
 
     C                   PARM                    COBMode           1
 
      ** Outputs
      ** PDCL Details OK inds
 
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid PDCL layout (DS) from/to caller
 
     C                   PARM                    ValidPDCL
 
      ** Formatting info
 
     C                   CALL      'AODEALR1'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDDEAL        PARM      SDDEAL        DSSDY
 
      ** Access the Lending ICD file
 
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSSDY
 
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DBFILE = 'SDCLNDPD'
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access the Bank ICD file
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      DBFILE      = 'SDBANKPD'
     C                   EVAL      DBASE       = 900
     C                   EVAL      DBKEY       = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
**  CPY@
(c) MIsys International Banking Systems Ltd. 2012
