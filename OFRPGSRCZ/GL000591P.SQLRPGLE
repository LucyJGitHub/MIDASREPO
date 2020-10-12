     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Forecast List/Audit report')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000591P - Midas OF Forecast List/Audit report              *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD025030           Date 13Feb14               *
      *                 CGL145A            Date 08Oct13               *
      *                 CGL145   *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD025030 - Issue with overflow in forecast details output    *
      *  CGL145A - Subsidiaries Daily Sweeping Forecast               *
      *  CGL145 - Subsidiaries Daily Sweeping Forecast                *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas OF Foreacast Audit/List report - Detail
     FGL000591P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Midas OF Foreacast Audit/List report - Audit
     FGL000591AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** External DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A_)

      ** External DS for Retail ICD
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D                                     PREFIX(B_)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     ** File DS
     **   Midas OF Total Forecast
     D FORTT         E DS                  EXTNAME(GLFORTTD)

     **   Midas OF Individual Forecast
     D FORIT         E DS                  EXTNAME(GLFORITD)

     **   Midas SD Forecast Static Data                                                      CGL145A
     D FCSDT         E DS                  EXTNAME(SDFCSDTD)                                 CGL145A
                                                                                             CGL145A
      ** File Information Data Structure for GL000591P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for GL000591AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** Parameter data
     D PData           DS
     D  Data                   1    100A

     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PSARD           S              6

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3

      ** Other fields used
     D WRun            S              1A   Inz
     D WRecNo          S              7S 0 Inz
     D WRecNo2         S              7S 0 Inz
     D RqdLn1          S              3  0
     D DifLn1          S              4  0

      ** Parameter list fields for AOCUSTR0
     D @KEY1           S             10
     D @KYST           S              7

      ** Parameter list fields for ZDATE2
     D PzDayNo         S              5  0
     D PBJDFIN         S              1
     D PzDate          S              6  0
     D PZADate         S              7

     D WField          S             21A
     D PEdtCode        S              1A
     D PDecPlace       S              1  0
     D WAmount         S             15  0

      ** Time data
     D PTimestamp      DS            26
     D  Hour1                 12     13
     D  Min1                  15     16
     D  Sec1                  18     19

     D PTime           DS
     D  Hour2                  1      2
     D  Colon1                 3      3    INZ(':')
     D  Min2                   4      5
     D  Colon2                 6      6    INZ(':')
     D  Sec2                   7      8

     D A#User          DS            10
     D A@User                         1    DIM(10)
     D B#User          DS            10
     D B@User                         1    DIM(10)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Set file pointer to first record and do initial read for the Total Forecast

     C/exec SQL
     C+ declare LIST cursor for
     C+ select * from GLFORTTD
     C+ order by
     C+       TFCUST, TFCSAC,
     C+       TFCCY, TFNOSC,
     C+       TFDATE, TFFACN
     C/end-exec

     C/exec SQL
     C+ open LIST
     C/end-exec

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCOD < 0

     C     *LOCK         IN        LDA
     C**********         EVAL      DBASE = 3                                                 CGL145A
     C                   EVAL      DBASE = 7                                                 CGL145A
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf


     C/exec SQL
     C+ fetch next
     C+ from LIST
     C+ into: FORTT
     C/end-exec

      ** Read Total Forecast Table until end of file

     C                   DOW       SQLCode <> 100

     C                   IF        ((PMode = 'A') AND (TFLCD = BJRDNB))
     C                             OR ((PMode <> 'A') AND
     C                             (TFRECI = 'D'))
      ** Print Report Header 1

     C                   EXSR      SRPrintHdr1

      ** Print Report Header 2

     C                   EXSR      SRPrintHdr2

      ** Print Report Header 3 only if Audit Mode

     C                   IF        PMode = 'A'
     C                   EXSR      SRPrintHdr3
     C                   ENDIF

      ** Print Report Header 4

     C                   EXSR      SRPrintHdr4

      ** Print Details

     C                   EXSR      SRPrintDtl

      ** Count Total Forecast
     C                   EVAL      WRecNo = WRecNo + 1

     C                   ENDIF

     C/exec SQL
     C+ fetch next from LIST
     C+ into: FORTT
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCode < 100

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C/exec SQL
     C+ close LIST
     C/end-exec

     C                   EXSR      SRPrintFtr

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr1- Print Header 1 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr1   BEGSR

     C                   WRITE     HEADER1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr2- Print Header 2 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr2   BEGSR

      ** Set up Header 2 details

     C                   CLEAR                   HEADER2

      ** Prepare the Header Title to be used (must be centered)

     C                   IF        PMode = 'L'
     C                   EVAL      FTITLE = 'FORECAST REPORT - LIST MODE'
     C                   EVAL      FUNDRS = '---------------------------'
     C                   EVAL      PRAMNT = ' Amount'
     C                   EVAL      PROPTP = 'Operation Type'
     C                   EVAL      PROAMT = ' Original Amount'
     C                   EVAL      PRNARR = 'Narrative'
     C                   EVAL      *IN01 = *OFF
     C                   ELSE
     C                   EVAL      FTITLE = 'FORECAST REPORT - AUDIT MODE'
     C                   EVAL      FUNDRS = '----------------------------'
     C                   EVAL      PRAMNT = 'Amount/'
     C                   EVAL      PROPTP = 'Operation Type/'
     C                   EVAL      PROAMT = 'Original Amount/'
     C                   EVAL      PRNARR = 'Narrative/'
     C                   EVAL      *IN01 = *ON
     C                   ENDIF

      ** Customer Number
     C                   EVAL      FCUSTNUM = TFCUST

      ** Get Customer Details (Report Name and Town)
     C                   EXSR      GetCustDtls

      ** Customer Source A/C
     C                   EVAL      FCUSTAC = TFCSAC

      ** Currency
     C                   EVAL      FCCYS = TFCCY

      ** Get Currency Details
     C                   EXSR      GetCurrDtls

      ** Nostro Code
     C                   EVAL      FNOSTCDE = TFNOSC

      ** Get Full Account
      ** via AONOSTR0
     C                   EXSR      GetNostDtls

      ** Convert Forecast Date to DDMMMYY
     C                   EVAL      PZDayNo = TFDATE
     C                   EXSR      CnvFcastDat
     C                   MOVE      *Blanks       FDATE
     C                   MOVE      PZADate       FDATE

      ** Retail A/C
     C                   IF        B_BMRANR = 'Y'

     C                   IF        TFACNO <> 0
     C                   MOVE      TFACNO        FRETACCT
     C                   ELSE
     C                   EVAL      FRETACCT = TFFACN
     C                   ENDIF

     C                   ELSE
     C                   EVAL      FRETACCT = TFFACN
     C                   ENDIF

      ** Total Amount
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = TFAMNT
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        FTOTAMNT

      ** Actual Amount
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = TFACTL
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        FACTAMNT

      ** Total Actual Amount
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = TFTATL
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        FTOTACAMT

      ** Alternative Customer Source A/C                                                     CGL145A
                                                                                             CGL145A
     C/exec SQL                                                                              CGL145A
     C+ declare LISTC cursor for                                                             CGL145A
     C+ select * from SDFCSDTD                                                               CGL145A
     C+ where FCCUST = :TFCUST and                                                           CGL145A
     C+ FCCSRC = :TFCSAC and                                                                 CGL145A
     C+ FCCURR = :TFCCY and                                                                  CGL145A
     C+ FCNOTR = :TFNOSC                                                                     CGL145A
     C/end-exec                                                                              CGL145A
                                                                                             CGL145A
     C/exec SQL                                                                              CGL145A
     C+ open LISTC                                                                           CGL145A
     C/end-exec                                                                              CGL145A
                                                                                             CGL145A
      ** Handle SQL Error (if not %EOF)                                                      CGL145A
                                                                                             CGL145A
     C                   If        SQLCOD < 0                                                CGL145A
                                                                                             CGL145A
     C     *LOCK         IN        LDA                                                       CGL145A
     C                   EVAL      DBASE = 6                                                 CGL145A
     C                   EVAL      DBFILE = 'SQL STM'                                        CGL145A
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                              CGL145A
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                    CGL145A
     C                   OUT       LDA                                                       CGL145A
     C                   EXSR      *PSSR                                                     CGL145A
                                                                                             CGL145A
     C                   EndIf                                                               CGL145A
                                                                                             CGL145A
     C/exec SQL                                                                              CGL145A
     C+ fetch next                                                                           CGL145A
     C+ from LISTC                                                                           CGL145A
     C+ into: FCSDT                                                                          CGL145A
     C/end-exec                                                                              CGL145A
                                                                                             CGL145A
     C                   IF        SQLCOD = 100                                              CGL145A
     C                   EVAL      FALCUSTAC = *BLANKS                                       CGL145A
     C                   ELSEIF    SQLCOD = 0                                                CGL145A
     C                   EVAL      FALCUSTAC = FCACSA                                        CGL145A
     C                   ENDIF                                                               CGL145A
                                                                                             CGL145A
     C/exec SQL                                                                              CGL145A
     C+ close LISTC                                                                          CGL145A
     C/end-exec                                                                              CGL145A
                                                                                             CGL145A
     C                   WRITE     HEADER2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr3- Print Header 3 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr3   BEGSR

     ** Audit fields

     **  Last Change User
     C                   IF        TFAUSR = *BLANKS
     C                   EVAL      PUSER1 = TFIUSR
     C                   ELSE
     C                   EVAL      PUSER1 = TFAUSR
     C                   ENDIF

     **  Date
     C                   EVAL      PZDayNo = TFLCD
     C                   EXSR      CnvFcastDat
     C                   MOVE      *Blanks       PDATE1
     C                   MOVE      PZADate       PDATE1

     **  Time
     C                   MOVEL     TFTMST        PTimestamp
     C                   EVAL      Hour2 = Hour1
     C                   EVAL      Min2  = Min1
     C                   EVAL      Sec2  = Sec1
     C                   EVAL      PTIME1 = Ptime

     **  Last action type
     C                   SELECT
     C                   WHEN      TFCHTP = 'I'
     C                   EVAL      PACT1  = 'INSERT'
     C                   WHEN      TFCHTP = 'A'
     C                   EVAL      PACT1  = 'AMEND'
     C                   WHEN      TFCHTP = 'D'
     C                   EVAL      PACT1  = 'DELETE'
     C                   ENDSL
     C                   WRITE     HEADER3

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr4- Print Header 4 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr4   BEGSR

     C                   WRITE     HEADER4

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCustDtls - Get Customer Details (Report Name and Town)    *
      *                                                               *
      *****************************************************************
     C     GetCustDtls   BEGSR

     C                   EVAL      @KEY1 = TFCUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      FCUSTNAM = BBCRNM
     C                   EVAL      FCUSTTWN = BBCRTN
     C                   ELSE
     C                   EVAL      FCUSTNAM = *Blanks
     C                   EVAL      FCUSTTWN = *Blanks
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCurrDtls - Get Currency Details                           *
      *                                                               *
      *****************************************************************
     C     GetCurrDtls   BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      TFCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY

     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      FCCYL = A6CYNM
     C                   ELSE
     C                   EVAL      FCCYL = *Blanks
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FormatAmount - Format Amount Routine                         *
      *                                                               *
      *****************************************************************
     C     FormatAmount  BEGSR

      ** If non-zero, format amount
     C                   IF        WAmount <> 0

     C                   CALL      'ZSEDIT'
     C                   PARM                    WAmount
     C                   PARM                    PDecPlace
     C                   PARM      'J'           PEdtCode
     C                   PARM                    WField

     C                   ELSE

      * If zero, check number of decimal places
     C                   IF        PDecPlace = 0
     C                   EVAL      WField = '                   0 '
     C                   ELSEIF    PDecPlace = 1
     C                   EVAL      WField = '                 0.0 '
     C                   ELSEIF    PDecPlace = 2
     C                   EVAL      WField = '                0.00 '
     C                   ELSEIF    PDecPlace = 3
     C                   EVAL      WField = '               0.000 '
     C                   ELSEIF    PDecPlace = 4
     C                   EVAL      WField = '              0.0000 '
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetNostDtls - Get Nostro Details                             *
      *                                                               *
      *****************************************************************
     C     GetNostDtls   BEGSR

     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUST             6
     C                   PARM      TFCCY         @CCY
     C                   PARM      *BLANKS       @ACCD            10
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM      TFNOSC        @NOST             2
     C                   PARM      *BLANKS       @BRCA             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSSDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A7CUST        @CUST
     C                   MOVE      A7CYCD        @CCY
     C                   MOVE      A7ACCD        @ACCD
     C                   MOVE      A7ACSN        @ACSN
     C                   MOVE      A7BRCD        @BRCA
      ** Get Account Name
     C                   EXSR      GetAcctDtls
     C                   ELSE
     C                   EVAL      FACCTNAM = *Blanks
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetAcctDtls - Get Account Details (Account Name)             *
      *                                                               *
      *****************************************************************
     C     GetAcctDtls   BEGSR

     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      *BLANKS       @ACNO            10
     C                   PARM                    @CUST
     C                   PARM                    @CCY
     C                   PARM                    @ACCD
     C                   PARM                    @ACSN
     C                   PARM                    @BRCA
     C     SDACCT        PARM      SDACCT        DSSDY

     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      FACCTNAM = A_ANAM
     C                   ELSE
     C                   EVAL      FACCTNAM = *Blanks
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CnvFcastDat - Convert Forecast Date to DDMMYY                *
      *                                                               *
      *****************************************************************
     C     CnvFcastDat   BEGSR

      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMMYY format.
     C                   CALL      'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    PBJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintDtl - Print Detail Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintDtl    BEGSR

      ** Set up Details

     C                   CLEAR                   DETAIL

      ** Set file pointer to first record and do initial read for the Total Forecast

     C/exec SQL
     C+ declare LISTB cursor for
     C+ select * from GLFORITD
     C+ where IFCUST = :TFCUST and
     C+ IFCSAC = :TFCSAC and
     C+ IFCCY = :TFCCY and
     C+ IFNOSC = :TFNOSC and
     C+ IFDATE = :TFDATE and
     C+ IFFACN = :TFFACN
     C+ order by
     C+       IFOPTY, IFSEQN
     C/end-exec

     C/exec SQL
     C+ open LISTB
     C/end-exec

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LISTB
     C+ into: FORIT
     C/end-exec

      ** Read Individual Forecast Table until end of file

     C                   DOW       SQLCode <> 100

     C                   IF        ((PMode = 'A') AND (IFLCD = BJRDNB))
     C                             OR ((PMode <> 'A') AND
     C                             (IFRECI = 'D'))
      ** Amount
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = IFAMNT
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        FDAMNT
      ** Actual Amount
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = IFACTL
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        FDACTAMT
      ** Original Amount
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = IFORIG
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        FDORGAMT
      ** Reference
     C                   EVAL      FDREFN = IFREFN
      ** Narrative
     C                   EVAL      FDNARR = IFNARR
      ** Operation Type
     C                   EVAL      FDOPTYP = IFOPTY
      ** Project on Nostro
     C                   EVAL      FDPROJN = IFPRON
      ** Project on Retail
     C                   EVAL      FDPROJR = IFPROR
      ** Sequence Number
     C                   EVAL      FDSEQN = IFSEQN

      ** Print Report Header 3 only if Audit Mode


      ** Print Report Headers for every new page

     C********           EVAL      RqdLn1 = 1                                            MD025030
     C                   EVAL      RqdLn1 = 3                                            MD025030
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRPrintHdr1
     C                   EXSR      SRPrintHdr2

     C                   IF        PMODE = 'A'
     C                   EXSR      SRPrintHdr3
     C                   ENDIF
                                                                                         MD025030
     C                   EXSR      SRPrintHdr4                                           MD025030

     C                   ENDIF

     C                   IF        PMODE = 'A'
     C                   EXSR      SRWrtDtl2
     C                   ENDIF

     C                   WRITE     DETAIL


      ** Count Individual Forecast
     C                   EVAL      WRecNo2 = WRecNo2 + 1

     C                   ENDIF

     C/exec SQL
     C+ fetch next from LISTB
     C+ into: FORIT
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCode < 100

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C/exec SQL
     C+ close LISTB
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrtDtl2 - Write Details 2 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRWrtDtl2     BEGSR

     ** Audit fields

     **  Last Change User
     C                   MOVE      *Blanks       DUSER1
     C                   MOVE      0             POS               2 0
     C                   MOVE      1             X                 2 0
     C                   MOVE      0             START             2 0

     C                   IF        IFAUSR = *BLANKS
     C                   EVAL      A#User = IFIUSR
     C                   EVAL      B#User = *Blanks
     C                   EVAL      POS = %SCAN(' ':A#User)
     C                   EVAL      START = 12 - POS

     C                   IF        START > 1
     C                   DOW       START <= 10
     C                   EVAL      B@USER(START) = A@USER(X)
     C                   EVAL      START = START + 1
     C                   EVAL      X = X + 1
     C                   ENDDO
     C                   MOVE      B#USER        DUSER1
     C                   ELSE
     C                   MOVE      IFIUSR        DUSER1
     C                   ENDIF

     C                   ELSE
     C                   EVAL      A#User = IFAUSR
     C                   EVAL      B#User = *Blanks
     C                   EVAL      POS = %SCAN(' ':A#User)
     C                   EVAL      START = 12 - POS

     C                   IF        START > 1

     C                   DOW       START <= 10
     C                   EVAL      B@USER(START) = A@USER(X)
     C                   EVAL      START = START + 1
     C                   EVAL      X = X + 1
     C                   ENDDO
     C                   MOVE      B#USER        DUSER1

     C                   ELSE
     C                   MOVE      IFAUSR        DUSER1
     C                   ENDIF
     C                   ENDIF

     **  Date
     C                   EVAL      PZDayNo = IFLCD
     C                   EXSR      CnvFcastDat
     C                   MOVE      *Blanks       DDATE1
     C                   MOVE      PZADate       DDATE1

     **  Time
     C                   MOVEL     IFTMST        PTimestamp
     C                   EVAL      Hour2 = Hour1
     C                   EVAL      Min2  = Min1
     C                   EVAL      Sec2  = Sec1
     C                   EVAL      DTIME1 = Ptime

     **  Last action type
     C                   SELECT
     C                   WHEN      IFCHTP = 'I'
     C                   EVAL      DACT1  = 'INSERT'
     C                   WHEN      IFCHTP = 'A'
     C                   EVAL      DACT1  = 'AMEND'
     C                   WHEN      IFCHTP = 'D'
     C                   EVAL      DACT1  = 'DELETE'
     C                   ENDSL

     C                   EVAL      *IN01 = *ON

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintFtr - Print Footer Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintFtr    BEGSR

     C                   IF        WRecNo > 0
     C                   WRITE     FOOTER
     C                   ENDIF

     C                   EXSR      SRAudit

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR

      ** Ensure Audit Spool File recorded by RCF.

     C                   EVAL      ZSnumU = SFNUMU

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *InU7 = *On
     C                   EVAL      *InU8 = *On
     C                   EVAL      *InLR = *On
     C                   RETURN
     C                   ENDIF

     C                   WRITE     HEADAU

      ** Total Forecast
     C                   EVAL      TCOUNT = WRecNo

      ** Individual Forecast
     C                   EVAL      ICOUNT = WRecNo2

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE

      ** If there is a record read, write audit control report.

     C                   IF        WRecNo <> 0
     C                   WRITE     CONTROL
     C                   ELSE

      ** Or, if no records read, Output "No Details" message.

     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty

      ** Set off program indicators

     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

      *   Check ICD retail
      *
     C                   CALL      'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY

      ** Access Bank details
      **   Retrieve Run day number

     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RRPTDS = BJURPT
     C                   EVAL      PBJDFIN = BJDFIN
     C                   ENDIF

      ** Ensure Detail Spool File recorded by RCF.

     C                   EVAL      ZSnum = SFNUM1

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blanks       ZSerr

     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   EVAL      ReturnCode = '*ERROR'

     C                   EXSR      SRAUDIT

     C                   RETURN

     C                   ENDSR
      /EJECT
      *****************************************************************
