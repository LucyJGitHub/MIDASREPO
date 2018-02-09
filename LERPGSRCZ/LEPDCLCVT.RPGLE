     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - File to Screen Fmt')        *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEPDCLCVT - Past Due Call Loan Conversion: File to Screen    *
      *                                                               *
      *  Function:  This module converts the fields of the Past Due   *
      *             Call Loan Details from file to screen format      *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR401133           Date 01Aug12               *
      *                 264044             Date 01Aug12               *
      *                 263289             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR401133- PDCL returned incorrect value for DDFAMT           *
      *            (Child: AR401134)                                  *
      *  264044 - CLE134 Test PDCL SOAP API                           *
      *  263289 - CLE134 Principal Account fields updated for a Fee.  *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
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
 
     D PDCLFilFmtLnkLE DS                  EXTNAME(LEPDUEPD)
     D                                     PREFIX(X_)
 
      ** Past Due & Original Loan Link File Format
 
     D PDCLFilFmtLnkFE DS                  EXTNAME(LEPDUFPD)
     D                                     PREFIX(Z_)
 
      ** Past Due & Original Fees Link File Format
 
     D TranFilFmtLoanE DS                  EXTNAME(CLOANCL )
     D                                     PREFIX(C_)
 
      ** Loans File Format
 
     D TranFilFmtLoaKE DS                  EXTNAME(CLOANCK )
     D                                     PREFIX(K_)
 
      ** Loans File Format 2
 
     D TranFilFmtFee E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(E_)
 
      ** Fees File Format
 
     D TranFilFmtFctyE DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(M_)
 
      ** Facilities File Format
 
     D TrnDets       E DS                  EXTNAME(LEPDCLPD)
 
      ** Past Due Loans Details in Screen Format
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
     D DSSDY         E DS
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
 
     D ##ACTN          S              1A
     D DDTMST          S             26Z
 
     D WORLN           S              6A
     D WFECU           S              6A
     D WFFAC           S              5A
     D WFSEQ           S              2A
     D WFLNO           S              6A
     D WPLON           S              6A
     D WPLO2           S              6A
 
     D ##ORLN          S              6A
     D ##FECU          S              6A
     D ##FFAC          S              5A
     D ##FSEQ          S              2A
     D ##FLNO          S              6A
     D ##PLON          S              6A
     D ##PLO2          S              6A
 
      ** Take on account - Principal
 
     D WTLPR           DS
     D  WKPABR                 1      3
     D  WKPACL                 4      9
     D  WKPACY                10     12
     D  WKPAAC                13     22  0
     D  WKPASE                23     24  0
 
      ** Take on account - Interest
 
     D WTLIN           DS
     D  WKIABR                 1      3
     D  WKIACL                 4      9
     D  WKIACY                10     12
     D  WKIAAC                13     22  0
     D  WKIASE                23     24  0
 
      ** Take on account - Fee
 
     D*WPDFA****       DS                                                                     263289
     D WTLFE           DS                                                                     263289
     D  WKFABR                 1      3
     D  WKFACL                 4      9
     D  WKFACY                10     12
     D  WKFAAC                13     22  0
     D  WKFASE                23     24  0
 
      ** Establish the transaction type
 
     D RecordType      S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
 
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
     D #@AMTD          S             17
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialisation
 
     C                   EXSR      INIT
 
      ** Set screen fields
 
     C                   IF        RecordType = Loan
     C                   EXSR      SRSCRLN
     C                   ELSE
     C                   EXSR      SRSCRFE
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
     C                   PARM                    WORLN
     C                   PARM                    WFECU
     C                   PARM                    WFFAC
     C                   PARM                    WFSEQ
     C                   PARM                    WFLNO
 
     C                   PARM                    WPLON
     C                   PARM                    WPLO2
 
     C                   PARM                    RecordType
 
      ** Past Due & Original Loan Link File Format
 
     C                   PARM                    PDCLFilFmtLnkL
 
      ** Past Due & Original Fees Link File Format
 
     C                   PARM                    PDCLFilFmtLnkF
 
      ** Loans File Format
 
     C                   PARM                    TranFilFmtLoan
 
      ** Loans File Format 2
 
     C                   PARM                    TranFilFmtLoaK
 
      ** Fee File Format
 
     C                   PARM                    TranFilFmtFee
 
      ** Facility File Format
 
     C                   PARM                    TranFilFmtFcty
 
      ** Output Parameters
 
      ** Interest Type/sub-type Details Screen Format
 
     C                   PARM                    TrnDets
 
      ** Timestamp
 
     C                   PARM                    DDTMST
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'LEPDCLCVT'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Formatting info
 
     C                   CALL      'AODEALR1'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
 
 
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INIT - Initialisation                                         *
      *                                                               *
      *****************************************************************
 
     C     INIT          BEGSR
 
      ** Blank outputs (Apart from the keys)
 
     C                   MOVEL     DDACTN        ##ACTN
     C                   MOVEL     WORLN         ##ORLN
     C                   MOVEL     WFECU         ##FECU
     C                   MOVEL     WFFAC         ##FFAC
     C                   MOVEL     WFSEQ         ##FSEQ
     C                   MOVEL     WFLNO         ##FLNO
     C                   MOVEL     WPLON         ##PLON
     C                   MOVEL     WPLO2         ##PLO2
     C                   CLEAR                   TrnDets
     C                   MOVEL     ##ACTN        DDACTN
     C                   MOVEL     ##ORLN        WORLN
     C                   MOVEL     ##FECU        WFECU
     C                   MOVEL     ##FFAC        WFFAC
     C                   MOVEL     ##FSEQ        WFSEQ
     C                   MOVEL     ##FLNO        WFLNO
     C                   MOVEL     ##PLON        WPLON
     C                   MOVEL     ##PLO2        WPLO2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** SRSCRLN - SET SCREEN FIELDS FOR LOANS                        *
      *                                                               *
      *****************************************************************
 
     C     SRSCRLN       BEGSR
 
      ** Main Key Details
 
     C                   MOVE      WORLN         DDORLN
     C                   MOVE      WFECU         DDFECU
     C                   MOVE      WFFAC         DDFFAC
     C                   MOVE      WFSEQ         DDFSEQ
     C                   MOVE      WFLNO         DDFLNO
 
      ** Return Key Details
 
     C                   IF        WPLON = *BLANKS or WPLON = '000000'
     C                   MOVE      *BLANKS       DDPLON
     C                   ELSE
     C                   MOVE      WPLON         DDPLON
     C                   ENDIF
     C                   IF        WPLO2 = *BLANKS or WPLO2 = '000000'
     C                   MOVE      *BLANKS       DDPLO2
     C                   ELSE
     C                   MOVE      WPLO2         DDPLO2
     C                   ENDIF
 
      ** Setup fields for Loan or Fee
 
     C                   IF        RecordType = Loan
     C                   EVAL      @KEY1 = C_CNUM
     C                   EVAL      DDLTYP = C_LTYP
     C                   EVAL      DDSUTP = C_SUTP
     C                   EVAL      DDLNCL = C_CLAS
     C                   MOVE      C_FCUS        DDFACU
     C                   MOVE      C_FTYP        DDFACT
     C                   MOVE      C_FSEQ        DDFCNO
     C                   EVAL      DDCCY = C_CCY
     C                   ELSE
     C                   EVAL      @KEY1 = E_FECNUM
     C                   MOVE      E_FEFCOD      DDFCOD
     C                   MOVE      M_CNUM        DDFACU
     C                   MOVE      M_FACT        DDFACT
     C                   MOVE      M_FCNO        DDFCNO
     C                   EVAL      DDCCY = E_FEFCCY
     C                   ENDIF
 
      ** Customer details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
 
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = @KEY1
     C                   EVAL      DBASE  = 902
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      DDCUST = BBCUST
     C                   EVAL      DDCREP = BBCRNM
     C                   ENDIF
 
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
     C                   MOVE      '0'           DDFAMT                                     AR401134
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
 
      ** Outstanding Principal Amount
 
     C                   IF        C_CPAM = *ZEROS
     C                   EVAL      DDLOAM = *BLANKS
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
 
      ** Accrued Interest (Posted)
 
     C                   IF        C_AIPD = *ZEROS
     C                   EVAL      DDAIPD = *BLANKS
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
 
      ** Start Date
 
     C                   EVAL      ZDAYNO = X_YVDAT
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         DDSDAT
 
      ** Past Due Principal (both loan and fee)
 
     C                   IF        X_YPCPAM = *ZEROS
     C                   EVAL      DDPDPR = *BLANKS
     C                   ELSE
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC
     C                   PARM      X_YPCPAM      @@AMTW
     C                   PARM      A6NBDP        W@DECP
     C                   PARM      BNDCSP        @@DCSP
     C                   PARM      *BLANK        @@AMTP
     C                   PARM      *BLANK        @@AMTD
     C**********         MOVE      @@AMTD        DDPDPR                                       264044
     C                   EVALR     DDPDPR = %TRIM(@@AMTD)                                     264044
     C                   ENDIF
 
      ** Past Due Interest (loan only)
 
     C                   IF        X_YPDINT = *ZEROS
     C                   EVAL      DDPDIN = *BLANKS
     C                   ELSE
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC
     C                   PARM      X_YPDINT      @@AMTW
     C                   PARM      A6NBDP        W@DECP
     C                   PARM      BNDCSP        @@DCSP
     C                   PARM      *BLANK        @@AMTP
     C                   PARM      *BLANK        @@AMTD
     C**********         MOVE      @@AMTD        DDPDIN                                       264044
     C                   EVALR     DDPDIN = %TRIM(@@AMTD)                                     264044
     C                   ENDIF
 
      ** Indicators
 
     C                   EVAL      DDCAPI = X_YPCIIN
     C                   EVAL      DDDEPI = X_YDECRE
     C                   EVAL      DDFAMU = X_YPFAMU
     C                   EVAL      DDSEIN = X_YPSIIN
 
      ** Report Classification
 
     C                   MOVE      X_YRCAT       DDRCAT
     C                   EVAL      ZDAYNO = X_YRIDT
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         DDRIDT
 
      ** Basel II Classification
 
     C                   MOVE      X_YBCAT       DDBCAT
     C                   EVAL      ZDAYNO = X_YBIDT
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         DDBIDT
 
      ** Accounts
 
     C                   EVAL      WKPABR = X_YTKPABR
     C                   EVAL      WKPACL = X_YTKPACL
     C                   EVAL      WKPACY = X_YTKPACY
     C                   EVAL      WKPAAC = X_YTKPAAC
     C                   EVAL      WKPASE = X_YTKPASE
     C                   IF        WKPACL <> *BLANKS
     C                   EVAL      DDTLPR = WTLPR
     C                   ELSE
     C                   EVAL      DDTLPR = *BLANKS
     C                   ENDIF
 
     C                   EVAL      WKIABR = X_YTKIABR
     C                   EVAL      WKIACL = X_YTKIACL
     C                   EVAL      WKIACY = X_YTKIACY
     C                   EVAL      WKIAAC = X_YTKIAAC
     C                   EVAL      WKIASE = X_YTKIASE
     C                   IF        WKIACL <> *BLANKS
     C                   EVAL      DDTLIN = WTLIN
     C                   ELSE
     C                   EVAL      DDTLIN = *BLANKS
     C                   ENDIF
 
      ** Timestamp
 
     C                   MOVE      X_YPTMST      DDTMST
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** SRSCRFE - SET SCREEN FIELDS FOR FEES                         *
      *                                                               *
      *****************************************************************
 
     C     SRSCRFE       BEGSR
 
      ** Main Key Details
 
     C                   MOVE      WORLN         DDORLN
     C                   MOVE      WFECU         DDFECU
     C                   MOVE      WFFAC         DDFFAC
     C                   MOVE      WFSEQ         DDFSEQ
     C                   MOVE      WFLNO         DDFLNO
 
      ** Return Key Details
 
     C                   IF        WPLON <> *BLANKS
     C                   MOVE      WPLON         DDPLON
     C                   ELSE
     C                   MOVE      *BLANKS       DDPLON
     C                   ENDIF
     C                   MOVE      *BLANKS       DDPLO2
 
      ** Setup fields for Loan or Fee
 
     C                   IF        RecordType = Loan
     C                   EVAL      @KEY1 = C_CNUM
     C                   EVAL      DDLTYP = C_LTYP
     C                   EVAL      DDSUTP = C_SUTP
     C                   EVAL      DDLNCL = C_CLAS
     C                   EVAL      DDCCY = C_CCY
     C                   ELSE
     C                   EVAL      @KEY1 = E_FECNUM
     C                   MOVE      E_FEFCOD      DDFCOD
     C                   EVAL      DDCCY = E_FEFCCY
     C                   ENDIF
     C                   EVAL      DDFACU = M_CNUM
     C                   MOVE      M_FACT        DDFACT
     C                   MOVE      M_FCNO        DDFCNO
 
      ** Customer details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
 
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = @KEY1
     C                   EVAL      DBASE  = 902
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      DDCUST = BBCUST
     C                   EVAL      DDCREP = BBCRNM
     C                   ENDIF
 
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
     C**********         PARM      *BLANK        #@AMTD                                     AR401134
     C                   PARM      *BLANK        @@AMTD                                     AR401134
     C**********         MOVE      @@AMTD        DDFAMT                                       264044
     C                   EVALR     DDFAMT = %TRIM(@@AMTD)                                     264044
     C                   ENDIF
 
      ** Outstanding Principal Amount
 
     C                   EVAL      DDLOAM = *BLANKS
 
      ** Accrued Interest (Posted)
 
     C                   EVAL      DDAIPD = *BLANKS
 
      ** Start Date
 
     C                   EVAL      ZDAYNO = Z_YVDAT
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         DDSDAT
 
      ** Past Due Principal (both loan and fee)
 
     C                   IF        Z_YPCPAM = *ZEROS
     C**********         EVAL      DDPDPR = *BLANKS                                           263289
     C                   EVAL      DDPDFA = *BLANKS                                           263289
     C                   ELSE
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC
     C                   PARM      Z_YPCPAM      @@AMTW
     C                   PARM      A6NBDP        W@DECP
     C                   PARM      BNDCSP        @@DCSP
     C                   PARM      *BLANK        @@AMTP
     C                   PARM      *BLANK        @@AMTD
     C**********         MOVE      @@AMTD        DDPDFA                                       264044
     C                   EVALR     DDPDFA = %TRIM(@@AMTD)                                     264044
     C                   ENDIF
 
      ** Indicators
 
     C                   EVAL      DDCAPI = Z_YPCIIN
     C                   EVAL      DDDEPI = Z_YDECRE
     C                   EVAL      DDFAMU = Z_YPFAMU
     C                   EVAL      DDSEIN = Z_YPSIIN
 
      ** Report Classification
 
     C                   MOVE      Z_YRCAT       DDRCAT
     C                   EVAL      ZDAYNO = Z_YRIDT
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         DDRIDT
 
      ** Basel II Classification
 
     C                   MOVE      Z_YBCAT       DDBCAT
     C                   EVAL      ZDAYNO = Z_YBIDT
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         DDBIDT
 
      ** Accounts
 
     C**********         EVAL      WKPABR = Z_YTKPABR                                         263289
     C**********         EVAL      WKPACL = Z_YTKPACL                                         263289
     C**********         EVAL      WKPACY = Z_YTKPACY                                         263289
     C**********         EVAL      WKPAAC = Z_YTKPAAC                                         263289
     C**********         EVAL      WKPASE = Z_YTKPASE                                         263289
     C**********         IF        WKPACL <> *BLANKS                                          263289
     C**********         EVAL      DDTLPR = WTLPR                                             263289
     C**********         ELSE                                                                 263289
     C**********         EVAL      DDTLPR = *BLANKS                                           263289
     C**********         ENDIF                                                                263289
     C                   EVAL      WKFABR = Z_YTKPABR                                         263289
     C                   EVAL      WKFACL = Z_YTKPACL                                         263289
     C                   EVAL      WKFACY = Z_YTKPACY                                         263289
     C                   EVAL      WKFAAC = Z_YTKPAAC                                         263289
     C                   EVAL      WKFASE = Z_YTKPASE                                         263289
     C                   IF        WKFACL <> *BLANKS                                          263289
     C                   EVAL      DDTLFE = WTLFE                                             263289
     C                   ELSE                                                                 263289
     C                   EVAL      DDTLFE = *BLANKS                                           263289
     C                   ENDIF                                                                263289
 
      ** Timestamp
 
     C                   MOVE      Z_YPTMST      DDTMST
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
 
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status     *
      ** subroutine, including a bound call to the DBERRCTL module.   *
     C/COPY ZACPYSRC,PSSR_ILE
 
      ** Note: if non-standard processing required, use the PSSR_ILENE*
      ** subroutine                                                   *
      *****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2012
