     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Past Due Call Loans/Origin Loan report')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000081 - Past Due Call Loans by Original Loan or Fees rpt  *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  This report will include live 'origin' loans & fees which    *
      *  have a non-zero 'Reporting Past Due Classification' or a     *
      *  non-zero 'Basel II Past Due Classification', i.e.            *
      *  rcat > 0 or bcat > 0                                         *
      *                                                               *
      *  The exception to the above is when the report is generated   *
      *  for a single loan                                            *
      *                                                               *
      *****************************************************************

     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLOANCLF: CLOANCKF)

     FCLOANLB   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF: CLOANLBF)

     FLEFEED    IF   E           K DISK    INFSR(*PSSR)

     FLEFEEDLU  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF: LEFEEDLUF)

     FLEPDUEL1  IF   E           K DISK    INFSR(*PSSR)
     FLEPDUFL1  IF   E           K DISK    INFSR(*PSSR)

     FLEPDUEL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPDUED0: LEPDUEL2F)
     FLEPDUFL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPDUFD0: LEPDUFL2F)

     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(FCLTYFMF)

     FLE000081P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN

      *****************************************************************

     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS

     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFACX      E                     EXTFLD(QQDFAC)

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
     D  B2PDCLDS              92    316    DIM(9)
     D  RPPDCLDS             336    560    DIM(9)

     D DSFDY         E DS
     D DSSDY         E DS

     D                 DS
     D BRCA
     D FEBRCA                              OVERLAY(BRCA)

     D                 DS
     D LTYP
     D  LTYP1                         1    OVERLAY(LTYP)

     D                 DS
     D FEFACL
     D  FTYPA                  1      3
     D  FSEQA                  4      5

     D PDCLFLDSXZ      DS
     D  #2LNRF
     D  #2LTSTCL
     D  #2LNTD
     D  #2FCLT
     D  #2FCTI
     D  #2FCTIDSC
     D  #2CCY
     D  #2OPAM
     D  #2CPAM
     D  #2ACRINT
     D  #2DDAT
     D  #2VDAT
     D  #2MDAT

     D W               DS                  LIKEDS(PDCLFLDSXZ)

     D PDCLFLDSY       DS
     D  #3LNRF
     D  #3LTSTCL
     D  #3LNTD
     D  #3FCLT
     D  #3FCTI
     D  #3FCTIDSC
     D  #3CCY
     D  #3OPAM
     D  #3CPAM
     D  #3ACRINT
     D  #3DDAT
     D  #3VDAT
     D  #3MDAT

     D                 DS
     D P@LNRFA                 1      6

     D WLNRF           S                   LIKE(LNRF)

     D @DATOUT         S              8

     D PTR             S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(PTR)
     D PRINTINGFEE            30     30N

     D CLE042          S               N

     D DSCURR          S                   INZ DIM(500) LIKE(SDCURR)
     D DSCYCD          S                   INZ DIM(500) LIKE(A6CYCD)

     D DSLOAN          S                   INZ DIM(500) LIKE(SDLOAN)
     D DSLTST          S                   INZ DIM(500) LIKE(DSLTSTX)
     D DSLTSTX         S              8    INZ

     D #C              S              9S 0 INZ

      ** Additional Field Definitions
     D P@SEQ           S              5
     D P@LEVEL         S              1
     D P@ENTITY        S              3
     D P@LNRF          S              6
     D @NUMB           S             15  0
     D @DECS           S              1  0
     D @EDTC           S              1
     D @CHAR           S             21
     D @DATIN          S              5  0
     D @DATFM          S              1
     D @DATE6          S              6  0
     D @DATE7          S              7
     D @LNTY           S              2
     D @LNST           S              2
     D @LNCL           S              4
     D @BRCD           S              3
     D @CUST           S             10
     D @KYSTS          S              7
     D @CURR           S              3
     D ZSSEQ           S              5
     D ZSENTITY        S              3
     D ZSFILE          S             10
     D ZSNUM           S              6  0
     D ZSERR           S              1

     C/EJECT

      ** +--- Start of Main processing -----------------------------------+
      ** Ê                                                                Ê
      ** Ê Initial processing is performed automatically: the *INZSR is   Ê
      ** Ê executed at program activation.                                Ê
      ** Ê                                                                Ê
      ** +----------------------------------------------------------------+

     C     *ENTRY        PLIST
     C                   PARM                    P@SEQ
     C                   PARM                    P@LEVEL
     C                   PARM                    P@ENTITY
     C     P@LNRFA       PARM                    P@LNRF

     C     LEFEEDK       KLIST
     C                   KFLD                    YBRCA
     C                   KFLD                    YECNUM
     C                   KFLD                    YEFACL
     C                   KFLD                    YPORG
     C                   KFLD                    YESEQ

     C     LEPDUFK       KLIST
     C                   KFLD                    FELOAN
     C                   KFLD                    FECNUM
     C                   KFLD                    FEFACL
     C                   KFLD                    FEFSEQ
     C                   KFLD                    FEBRCA

     C     FCLTYK        KLIST
     C                   KFLD                    FCUS
     C                   KFLD                    FTYP
     C                   KFLD                    FSEQ

      ** Print request is for a single loan

     C                   IF        P@LNRF <> *BLANKS AND
     C                             P@LNRF <> 'ALL'
     C                   EXSR      RPT1LOAN

      ** Print request is for all loans & fees

     C                   ELSE
     C                   EXSR      RPTALLLOANS
     C                   EXSR      RPTALLFEES
     C                   ENDIF

     C                   EXSR      CLOSEDOWN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RPTALLLOANS - Report All Loans                               *
      *****************************************************************
     C     RPTALLLOANS   BEGSR

      ** For individual branch, read the records by branch;
      ** otherwise read all records

     C                   IF            P@LEVEL = 'B'
     C                             AND P@ENTITY <> 'ALL'
     C     P@ENTITY      SETLL     CLOANLB
     C     P@ENTITY      READE     CLOANLB
     C                   ELSE
     C     *START        SETLL     CLOANLB
     C                   READ      CLOANLB
     C                   ENDIF

     C                   DOW       NOT %EOF

      ** Select the live 'origin' loans with non-zero Reporting
      ** or Basel II Past Due Classification

     C                   IF            RECI = 'D'
     C                             AND LTYP1 <> 'X'
     C                             AND LTYP1 <> 'Y'
     C                             AND LTYP1 <> 'Z'
     C                             AND (  RCAT > 0
     C                                 OR BCAT > 0 )
     C                   EXSR      ORIGINLOAN
     C                   EXSR      PDCLTYPEXY
     C                   ENDIF

     C                   IF            P@LEVEL = 'B'
     C                             AND P@ENTITY <> 'ALL'
     C     P@ENTITY      READE     CLOANLB
     C                   ELSE
     C                   READ      CLOANLB
     C                   ENDIF
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RPTALLFEES - Report All Fees                                 *
      *****************************************************************
     C     RPTALLFEES    BEGSR

      ** For individual branch, read the records by branch;
      ** otherwise read all records

     C                   IF            P@LEVEL = 'B'
     C                             AND P@ENTITY <> 'ALL'
     C     P@ENTITY      SETLL     LEFEEDLU
     C     P@ENTITY      READE     LEFEEDLU
     C                   ELSE
     C     *START        SETLL     LEFEEDLU
     C                   READ      LEFEEDLU
     C                   ENDIF

     C                   DOW       NOT %EOF

      ** Select the live 'origin' loans with non-zero Reporting
      ** or Basel II Past Due Classification

     C                   IF            FERECI = 'D'
     C                               AND (FERCAT > 0
     C                                 OR FEBCAT > 0)
     C                   EXSR      ORIGINFEE
     C                   EXSR      PDCLTYPEZ
     C                   ENDIF

     C                   IF            P@LEVEL = 'B'
     C                             AND P@ENTITY <> 'ALL'
     C     P@ENTITY      READE     LEFEEDLU
     C                   ELSE
     C                   READ      LEFEEDLU
     C                   ENDIF
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RPT1LOAN - Report is for a single loan                        *
      ** Report is for a single loan. Determine whether the loan is   *
      ** a) past due call loan from a loan                            *
      ** b) past due call loan from a fee                             *
      ** c) 'origin' loan                                             *
      *                                                               *
      *****************************************************************
     C     RPT1LOAN      BEGSR


     C     P@LNRFA       CHAIN     CLOANCLF

     C                   SELECT
     C                   WHEN      NOT %FOUND
     C                   EXSR      CLOSEDOWN

      ** PDCL from loan

     C                   WHEN          LTYP1 = 'X'
     C                             OR LTYP1 = 'Y'
     C     LNRF          CHAIN     LEPDUEL1
     C                   IF        NOT %FOUND
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'LEPDUEL1'
     C                   EXSR      *PSSR
     C                   ENDIF

     C     YPORG         CHAIN     CLOANCLF
     C                   IF        NOT %FOUND
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'CLOAN'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EXSR      ORIGINLOAN
     C                   EXSR      PDCLTYPEXY

      ** PDCL from fee

     C                   WHEN      LTYP1 = 'Z'
     C     LNRF          CHAIN     LEPDUFL1
     C                   IF        NOT %FOUND
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'LEPDUFL1'
     C                   EXSR      *PSSR
     C                   ENDIF

     C     LEFEEDK       CHAIN     LEFEED
     C                   IF        NOT %FOUND
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'LEFEED'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EXSR      ORIGINFEE
     C                   EXSR      PDCLTYPEZ

      ** 'Origin' loan

     C                   OTHER
     C                   EXSR      ORIGINLOAN
     C                   EXSR      PDCLTYPEXY
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ORIGINLOAN - Origin Loan                                     *
      *****************************************************************
     C     ORIGINLOAN    BEGSR

     C                   CLEAR                   DETAIL01L
     C                   CLEAR                   DETAIL02
     C                   EVAL      PRINTINGFEE = *OFF

      ** Set up the print fields for the 'origin' loan

     C                   IF        BRCA <> H#BRCA

     C                   IF        P@LEVEL = 'B'
     C                   EXSR      OPENPRTF
     C                   ENDIF

     C                   EVAL      H#BRCA = BRCA
     C                   EVAL      @BRCD = BRCA
     C                   EXSR      GETBRANCH
     C                   EVAL      H#BRNM = A8BRNM
     C                   ENDIF

     C     LNRF          CHAIN     CLOANCKF
     C                   IF        NOT %FOUND
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'CLOAN'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      #1CNUM = CNUM
     C                   EVAL      @CUST = CNUM
     C                   EXSR      GETCUSTOMER
     C                   EVAL      #1CRNM = BBCRNM

     C                   EVAL      #1LNRF = LNRF

     C                   IF        CLE042
     C                   EVAL      #1LTSTCL = LTYP + '/'
     C                                      + SUTP + '/'
     C                                      + CLAS
     C                   ELSE
     C                   EVAL      #1LTSTCL = LTYP
     C                                      + ' / '
     C                                      + SUTP
     C                   ENDIF

     C                   EVAL      @LNTY = LTYP
     C                   EVAL      @LNST = SUTP
     C                   EVAL      @LNCL = CLAS
     C                   EXSR      GETLOANTYPE
     C                   EVAL      #1LNTD = AYLNTD

     C                   EVAL      #1FCLT = FCUS
     C                                    + '-'
     C                                    + %EDITC(FTYP: 'X')
     C                                    + '-'
     C                                    + %EDITC(FSEQ: 'X')

     C                   EVAL      #1FCTI = *BLANK
     C     FCLTYK        CHAIN     FCLTY
     C                   EVAL      #1FCTI = FCTI

     C                   IF        FCTI = 'C'
     C                   EVAL      #1FCTIDSC = 'Commitment'
     C                   ELSEIF    FCTI = 'F'
     C                   EVAL      #1FCTIDSC = 'Confirmed'
     C                   ELSEIF    FCTI = 'G'
     C                   EVAL      #1FCTIDSC = 'Guidance'
     C                   ELSE
     C                   EVAL      #1FCTIDSC = *BLANKS
     C                   ENDIF

     C                   EVAL      #1CCY = CCY
     C                   EXSR      GETCURRENCY

      ** Convert dates

     C                   EVAL      @DATIN = DDAT
     C                   EXSR      CVTDATE
     C                   EVAL      #1DDAT = @DATOUT

     C                   EVAL      @DATIN = VDAT
     C                   EXSR      CVTDATE
     C                   EVAL      #1VDAT = @DATOUT

     C                   EVAL      @DATIN = MDAT
     C                   EXSR      CVTDATE
     C                   EVAL      #1MDAT = @DATOUT

      ** Edit amounts

     C                   CALL      'ZSEDIT'
     C                   PARM      OPAM          @NUMB
     C                   PARM      A6NBDP        @DECS
     C                   PARM      'J'           @EDTC
     C     #1OPAM        PARM                    @CHAR

     C                   CALL      'ZSEDIT'
     C                   PARM      CPAM          @NUMB
     C                   PARM      A6NBDP        @DECS
     C                   PARM      'J'           @EDTC
     C     #1CPAM        PARM                    @CHAR

     C                   EVAL      @NUMB = AIPD - IPRD - ICTD
     C                   CALL      'ZSEDIT'
     C                   PARM                    @NUMB
     C                   PARM      A6NBDP        @DECS
     C                   PARM      'J'           @EDTC
     C     #1ACRINT      PARM                    @CHAR

      ** Reporting Past Due fields

     C                   EVAL      #1RCAT = %EDITC(RCAT: 'X')
     C                   IF        RCAT > 0
     C                   EVAL      #1RCATDSC = RPPDCLDS(RCAT)
     C                   ELSE
     C                   EVAL      #1RCATDSC = 'Normal status'
     C                   ENDIF

     C                   EVAL      @DATIN = RCSD
     C                   EXSR      CVTDATE
     C                   EVAL      #1RCSD = @DATOUT

     C                   EVAL      @DATIN = RIDT
     C                   EXSR      CVTDATE
     C                   EVAL      #1RIDT = @DATOUT

      ** Basel II Past Due fields

     C                   EVAL      #1BCAT = %EDITC(BCAT: 'X')
     C                   IF        BCAT > 0
     C                   EVAL      #1BCATDSC = B2PDCLDS(BCAT)
     C                   ELSE
     C                   EVAL      #1BCATDSC = 'Normal status'
     C                   ENDIF

     C                   EVAL      @DATIN = BCSD
     C                   EXSR      CVTDATE
     C                   EVAL      #1BCSD = @DATOUT

     C                   EVAL      @DATIN = BIDT
     C                   EXSR      CVTDATE
     C                   EVAL      #1BIDT = @DATOUT

     C                   IF        NOT %OPEN(LE000081P1)
     C                   EXSR      OPENPRTF
     C                   ENDIF

     C                   WRITE     HEAD01
     C                   WRITE     DETAIL01L

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ORIGINFEE - Origin Fee                                       *
      *****************************************************************
     C     ORIGINFEE     BEGSR

     C                   CLEAR                   DETAIL01F
     C                   CLEAR                   DETAIL02
     C                   EVAL      PRINTINGFEE = *ON

      ** Set up the print fields for the 'origin' fee

     C                   EVAL      H#BRCA = FEBRCA
     C                   EVAL      @BRCD = FEBRCA
     C                   EXSR      GETBRANCH
     C                   EVAL      H#BRNM = A8BRNM

     C                   EVAL      #1CNUM = FECNUM
     C                   EVAL      @CUST = FECNUM
     C                   EXSR      GETCUSTOMER
     C                   EVAL      #1CRNM = BBCRNM

     C                   IF        FELOAN = *BLANKS
     C                   EVAL      #1LNRF = *BLANKS
     C                   ELSE
     C                   EVAL      #1LNRF = FELOAN
     C                   ENDIF

     C                   IF        FEFACL = 0
     C                   EVAL      #1FCLT = *BLANKS
     C                   ELSE
     C                   EVAL      #1FCLT = FTYPA
     C                                    + '-'
     C                                    + FSEQA
     C                   ENDIF

     C                   EVAL      #1FSEQ = %EDITC(FEFSEQ: 'X')
     C                   EVAL      #1FCOD = %EDITC(FEFCOD: 'X')

     C                   EVAL      #1CCY = FEFCCY
     C                   EXSR      GETCURRENCY

      ** Edit amount

     C                   CALL      'ZSEDIT'
     C                   PARM      FEFAMT        @NUMB
     C                   PARM      A6NBDP        @DECS
     C                   PARM      'J'           @EDTC
     C     #1FAMT        PARM                    @CHAR

      ** Convert dates

     C                   EVAL      @DATIN = FEPSTD
     C                   EXSR      CVTDATE
     C                   EVAL      #1PSTD = @DATOUT

     C                   EVAL      @DATIN = FEPEND
     C                   EXSR      CVTDATE
     C                   EVAL      #1PEND = @DATOUT

      ** Reporting Past Due fields

     C                   EVAL      #1RCAT = %EDITC(FERCAT: 'X')
     C                   IF        FERCAT > 0
     C                   EVAL      #1RCATDSC = RPPDCLDS(FERCAT)
     C                   ELSE
     C                   EVAL      #1RCATDSC = 'Normal status'
     C                   ENDIF

     C                   EVAL      @DATIN = FERCSD
     C                   EXSR      CVTDATE
     C                   EVAL      #1RCSD = @DATOUT

     C                   EVAL      @DATIN = FERIDT
     C                   EXSR      CVTDATE
     C                   EVAL      #1RIDT = @DATOUT

      ** Basel II Past Due fields

     C                   EVAL      #1BCAT = %EDITC(FEBCAT: 'X')
     C                   IF        FEBCAT > 0
     C                   EVAL      #1BCATDSC = B2PDCLDS(FEBCAT)
     C                   ELSE
     C                   EVAL      #1BCATDSC = 'Normal status'
     C                   ENDIF

     C                   EVAL      @DATIN = FEBCSD
     C                   EXSR      CVTDATE
     C                   EVAL      #1BCSD = @DATOUT

     C                   EVAL      @DATIN = FEBIDT
     C                   EXSR      CVTDATE
     C                   EVAL      #1BIDT = @DATOUT

     C                   IF        NOT %OPEN(LE000081P1)
     C                   EXSR      OPENPRTF
     C                   ENDIF

     C                   WRITE     HEAD01
     C                   WRITE     DETAIL01F

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  PDCLTYPEXY - Get the PDCLs for the 'origin' loan             *
      *****************************************************************
     C     PDCLTYPEXY    BEGSR

      ** Get the PDCLs for the 'origin' loan: one X-type and one Y-type

     C                   EVAL      WLNRF = LNRF
     C     WLNRF         SETLL     LEPDUEL2

     C                   DO        2
     C     WLNRF         READE     LEPDUEL2
     C                   IF        %EOF
     C                   LEAVE
     C                   ENDIF

     C                   EXSR      PDCLFLDS
     C                   ENDDO

     C                   WRITE     DETAIL02

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  PDCLTYPEZ - Get the PDCL for the 'origin' fee: one Z-type    *
      *****************************************************************
     C     PDCLTYPEZ     BEGSR

     C     LEPDUFK       CHAIN     LEPDUFL2

     C                   IF        %FOUND
     C                   EXSR      PDCLFLDS
     C                   ENDIF

     C                   WRITE     DETAIL02

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  PDCLFLDS - Get PDCL Fields                                   *
      *****************************************************************
     C     PDCLFLDS      BEGSR

      ** Get A and B records

     C     YPLON         CHAIN     CLOANCLF
     C     YPLON         READE     CLOANCKF
     C                   IF        NOT %FOUND
     C                             OR  %EOF
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'CLOAN'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      W.#2LNRF = LNRF

     C                   IF        CLE042
     C                   EVAL      W.#2LTSTCL = LTYP + '/'
     C                                        + SUTP + '/'
     C                                        + CLAS
     C                   ELSE
     C                   EVAL      W.#2LTSTCL = LTYP
     C                                        + ' / '
     C                                        + SUTP
     C                   ENDIF

     C                   EVAL      @LNTY = LTYP
     C                   EVAL      @LNST = SUTP
     C                   EVAL      @LNCL = CLAS
     C                   EXSR      GETLOANTYPE
     C                   EVAL      W.#2LNTD = AYLNTD

     C                   EVAL      W.#2FCLT = FCUS
     C                                      + '-'
     C                                      + %EDITC(FTYP: 'X')
     C                                      + '-'
     C                                      + %EDITC(FSEQ: 'X')

     C                   EVAL      W.#2FCTI = *BLANK
     C     FCLTYK        CHAIN     FCLTY
     C                   EVAL      W.#2FCTI = FCTI

     C                   IF        FCTI = 'C'
     C                   EVAL      W.#2FCTIDSC = 'Commitment'
     C                   ELSEIF    FCTI = 'F'
     C                   EVAL      W.#2FCTIDSC = 'Confirmed'
     C                   ELSEIF    FCTI = 'G'
     C                   EVAL      W.#2FCTIDSC = 'Guidance'
     C                   ELSE
     C                   EVAL      W.#2FCTIDSC = *BLANKS
     C                   ENDIF

     C                   EVAL      W.#2CCY = CCY
     C                   EXSR      GETCURRENCY

      ** Convert dates

     C                   EVAL      @DATIN = DDAT
     C                   EXSR      CVTDATE
     C                   EVAL      W.#2DDAT = @DATOUT

     C                   EVAL      @DATIN = VDAT
     C                   EXSR      CVTDATE
     C                   EVAL      W.#2VDAT = @DATOUT

     C                   EVAL      @DATIN = MDAT
     C                   EXSR      CVTDATE
     C                   EVAL      W.#2MDAT = @DATOUT

      ** Edit amounts

     C                   CALL      'ZSEDIT'
     C                   PARM      OPAM          @NUMB
     C                   PARM      A6NBDP        @DECS
     C                   PARM      'J'           @EDTC
     C     W.#2OPAM      PARM                    @CHAR

     C                   CALL      'ZSEDIT'
     C                   PARM      CPAM          @NUMB
     C                   PARM      A6NBDP        @DECS
     C                   PARM      'J'           @EDTC
     C     W.#2CPAM      PARM                    @CHAR

     C                   EVAL      @NUMB = AIPD - IPRD - ICTD
     C                   CALL      'ZSEDIT'
     C                   PARM                    @NUMB
     C                   PARM      A6NBDP        @DECS
     C                   PARM      'J'           @EDTC
     C     W.#2ACRINT    PARM                    @CHAR

     C                   IF            LTYP1 = 'X'
     C                             OR LTYP1 = 'Z'
     C                   EVAL      PDCLFLDSXZ = W
     C                   ELSE
     C                   EVAL      PDCLFLDSY = W
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CVTDATE - Convert Date                                       *
      *****************************************************************
     C     CVTDATE       BEGSR

     C                   IF        @DATIN > 0
     C                   CALL      'ZDATE2'
     C                   PARM                    @DATIN
     C                   PARM      BJDFIN        @DATFM
     C                   PARM      *ZEROS        @DATE6
     C                   PARM                    @DATE7
     C                   EVAL      @DATOUT = %EDITC(@DATE6: 'Y')

     C                   ELSE
     C                   EVAL      @DATOUT = *BLANKS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  GETLOANTYPE - Get Loan Type                                  *
      *****************************************************************
     C     GETLOANTYPE   BEGSR

     C                   EVAL      DSLTSTX = @LNTY + @LNST + @LNCL
     C                   EVAL      #C = %LOOKUP(DSLTSTX:DSLTST)

     C                   IF        #C > 0
     C                   EVAL      SDLOAN = DSLOAN(#C)

     C                   ELSE
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @LNTY
     C                   PARM                    @LNST
     C                   PARM                    @LNCL
     C     SDLOAN        PARM      SDLOAN        DSFDY

     C                   EVAL      #C = %LOOKUP(' ':DSLTST)

     C                   IF        #C = 0
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBKEY = DSLTSTX
     C                   EVAL      DBASE = 40
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      #C = %LOOKUP(' ':DSLTST)

     C                   IF        #C = 0
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBKEY = DSLTSTX
     C                   EVAL      DBASE = 40
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      DSLTST(#C) = DSLTSTX
     C                   EVAL      DSLOAN(#C) = SDLOAN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  GETBRANCH - Get Branch                                       *
      *****************************************************************
     C     GETBRANCH     BEGSR

     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @BRCD
     C     SDBRCH        PARM      SDBRCH        DSFDY

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      A8BRNM = *BLANKS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  GETCUSTOMER - Get Customer                                   *
      *****************************************************************
     C     GETCUSTOMER   BEGSR

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @CUST
     C                   PARM      *BLANKS       @KYSTS
     C     SDCUST        PARM      *BLANKS       DSSDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  GETCURRENCY - Get Currency                                   *
      *****************************************************************
     C     GETCURRENCY   BEGSR

     C                   EVAL      #C = %LOOKUP(#1CCY:DSCYCD)

     C                   IF        #C > 0
     C                   EVAL      SDCURR = DSCURR(#C)

     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #1CCY         @CURR
     C     SDCURR        PARM      *BLANKS       DSSDY

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = @CURR
     C                   EVAL      DBASE = 7
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      #C = %LOOKUP(' ':DSCYCD)

     C                   IF        #C = 0
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = @CURR
     C                   EVAL      DBASE = 30
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      DSCYCD(#C) = #1CCY
     C                   EVAL      DSCURR(#C) = SDCURR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  OPENPRTF - Open Prtf                                         *
      *****************************************************************
     C     OPENPRTF      BEGSR

     C                   IF        %OPEN(LE000081P1)
     C                   WRITE     FOOT01
     C                   CLOSE     LE000081P1
     C                   ENDIF

     C                   OPEN      LE000081P1

      ** Record spooled file details in RCF

     C                   IF            P@LEVEL = 'B'
     C                             AND P@ENTITY <> 'ALL'
     C                   EVAL      ZSENTITY = P@ENTITY
     C                   ELSEIF    P@LEVEL = 'B'
     C                   EVAL      ZSENTITY = BRCA
     C                   ELSE
     C                   EVAL      ZSENTITY = *BLANKS
     C                   ENDIF

     C                   CALL      'ZSFILE'
     C                   PARM      P@SEQ         ZSSEQ
     C                   PARM                    ZSENTITY
     C                   PARM      SFILE1        ZSFILE
     C                   PARM      SFNUM1        ZSNUM
     C                   PARM      *BLANK        ZSERR

     C                   IF        ZSERR = 'Y'
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EVAL      DBASE = 8
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CLOSEDOWN - Close Down Program                               *
      *****************************************************************
     C     CLOSEDOWN     BEGSR

     C                   IF        NOT %OPEN(LE000081P1)
     C                             AND P@ENTITY <> 'ALL'
     C                   EXSR      OPENPRTF

     C                   EVAL      @BRCD = P@ENTITY
     C                   EXSR      GETBRANCH
     C                   EVAL      H#BRCA = P@ENTITY
     C                   EVAL      H#BRNM = A8BRNM
     C                   WRITE     HEAD01
     C                   ENDIF

     C                   IF        %OPEN(LE000081P1)
     C                   IF        P@LEVEL = 'B'
     C                   WRITE     FOOT01
     C                   ELSE
     C                   WRITE     FOOT02
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Default Initialisation Subroutine                   *
      *****************************************************************
     C     *INZSR        BEGSR

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBASE = 9
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSSDY

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCLNDPD'
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBASE = 10
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check for presence of feature CLE042

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE042'      @SARD

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE042 = *ON
     C                   EVAL      #1LTSTCLTX = 'Type/Subtype/Class'
     C                   ELSE
     C                   EVAL      CLE042 = *OFF
     C                   EVAL      #1LTSTCLTX = 'Loan Type / Subtype'
     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
      *  *PSSR - Default Error Handling Subroutine                    *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        RUNBEFORE = *BLANK
     C                   EVAL      RUNBEFORE = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
