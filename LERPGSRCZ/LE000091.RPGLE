     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Past Due Overdraft report')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000091 - Past Due Overdraft Report                         *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
     FACCBR     IF   E           K DISK    INFSR(*PSSR)
 
     FPMHPOSL1  IF   E           K DISK    INFSR(*PSSR)
 
     FLEODXTPD  IF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(X_)
 
     FLE000091P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
     F                                     OFLIND(P1OVERFLOW)
 
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
 
     D DSCURR          S                   INZ DIM(500) LIKE(SDCURR)
     D DSCYCD          S                   INZ DIM(500) LIKE(A6CYCD)
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
     D  B2PDCLDSC             92    316    DIM(9)
     D  B2PDCLDYS            317    334P 0 DIM(9)
     D  RPPDCLDSC            336    560    DIM(9)
     D  RPPDCLDYS            561    578P 0 DIM(9)
 
     D DSFDY         E DS
     D DSSDY         E DS
 
     D PDCLDSC         S                   LIKE(B2PDCLDSC) DIM(9)
     D PDCLDYS         S                   LIKE(B2PDCLDYS) DIM(9) ASCEND
 
     D LSTASCNDG       S              3U 0
     D IDX             S              3U 0
 
     D X_KEY           DS
     D  X_BRCA
     D  X_PDCLAS
 
     D Y_KEY           S                   LIKE(X_KEY)
 
     D ODLNDP          S                   LIKE(CLBL)
     D DAYSINPD        S                   LIKE(X_DYPD)
     D LSTPAYDATE      S                   LIKE(VALD)
     D CLBLHST         S                   LIKE(CLBL)
 
     D PTR             S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(PTR)
     D BASEL2MODE             30     30N
 
     D #C              S              9S 0 INZ
 
      ** Additional Field Definitions
     D P@SEQ           S              5
     D P@LEVEL         S              1
     D P@ENTITY        S              3
     D P@MODE          S             10
     D @NUMB           S             15  0
     D @DECS           S              1  0
     D @EDTC           S              1
     D @CHAR           S             21
     D @DATIN          S              5  0
     D @DATFM          S              1
     D @DATE6          S              6  0
     D @DATE7          S              7
     D @BRCD           S              3
     D @CUST           S             10
     D @KYSTS          S              7
     D @CURR           S              3
     D ZSSEQ           S              5
     D ZSENTITY        S              3
     D ZSFILE          S             10
     D ZSNUM           S              6  0
     D ZSERR           S              1
 
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P@SEQ
     C                   PARM                    P@LEVEL
     C                   PARM                    P@ENTITY
     C                   PARM                    P@MODE
 
     C     PMHPOSK1      KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BJRDNB
 
     C     PMHPOSK2      KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
 
      *****************************************************************
     C                   EXSR      EXTRACT
 
     C                   EXSR      REPORT
 
     C                   EXSR      CLOSEDOWN
 
      /EJECT
      *****************************************************************
      *  EXTRACT - Extract Accounts                                   *
      *****************************************************************
     C     EXTRACT       BEGSR
 
      ** For individual branch, Extract The Accounts For The Branch;
      ** otherwise extract all accounts.
 
     C                   IF            P@LEVEL = 'B'
     C                             AND P@ENTITY <> 'ALL'
     C     P@ENTITY      SETLL     ACCBR
     C     P@ENTITY      READE     ACCBR
     C                   ELSE
     C                   READ      ACCBR
     C                   ENDIF
 
     C                   DOW       NOT %EOF
 
     C                   IF            RECI = 'D'
     C                             AND ATYP = 'R'
     C                             AND CLBL < 0
 
      ** Overdraft Line is held as a whole number with no CDP factored
      ** in, so adjustment is necessary to enable comparison.
 
     C                   EXSR      GETCURRENCY
     C                   EVAL(H)   ODLNDP = ODLN
     C                                         * (10 ** A6NBDP)
 
     C                   IF        CLBL < -(ODLNDP)
     C                   EXSR      WRTEXTRACT
     C                   ENDIF
     C                   ENDIF
 
     C                   IF            P@LEVEL = 'B'
     C                             AND P@ENTITY <> 'ALL'
     C     P@ENTITY      READE     ACCBR
     C                   ELSE
     C                   READ      ACCBR
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  WRTEXTRACT - Extract The Accounts For The Branch             *
      *****************************************************************
     C     WRTEXTRACT    BEGSR
 
     C                   EXSR      CHKPSTNGREC
     C                   EVAL      X_DYPD = DAYSINPD
 
     C                   EVAL      X_PDCLAS = %LOOKUPGE(DAYSINPD
     C                                                   : PDCLDYS
     C                                                   : 1
     C                                                   : LSTASCNDG  )
     C                   IF        X_PDCLAS = 0
     C                   EVAL      X_PDCLAS = LSTASCNDG
     C                   ENDIF
 
     C                   EVAL      X_BRCA = BRCA
     C                   EVAL      X_CNUM = CNUM
     C                   EVAL      X_CCY = CCY
     C                   EVAL      X_NBDP = A6NBDP
     C                   EVAL      X_ACOD = ACOD
     C                   EVAL      X_ACSQ = ACSQ
     C                   EVAL      X_ACNO = ACNO
     C                   EVAL      X_ANAM = ANAM
     C                   EVAL      X_CLBL = CLBL
     C                   EVAL      X_LDBL = LDBL
     C                   EVAL      X_ODLN = ODLN
     C                   EVAL      X_LPYD = LSTPAYDATE
 
     C                   WRITE     LEODXTPDF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  CHKPSTNGREC - Check Posting Records                          *
      *                                                               *
      ** This subroutine will derive:                                 *
      ** 1) date of the last debit (credit to the customer)           *
      ** 2) number of days the account has been overdrawn beyond the  *
      ** overdraft line.                                              *
      *                                                               *
      *****************************************************************
     C     CHKPSTNGREC   BEGSR
 
     C                   EVAL      LSTPAYDATE = 0
     C                   EVAL      DAYSINPD = 0
     C                   EVAL      CLBLHST = CLBL
 
     C     PMHPOSK1      SETGT     PMHPOSL1
     C     PMHPOSK2      READPE    PMHPOSL1
 
     C                   DOW       NOT %EOF
 
     C                   IF        (   LSTPAYDATE = 0
     C                             AND PSTA > 0
     C                             AND DRCR = 0 )
     C                   EVAL      LSTPAYDATE = VALD
     C                   ENDIF
 
     C                   IF        DRCR = 0
     C                   EVAL      CLBLHST += PSTA
     C                   ELSE
     C                   EVAL      CLBLHST -= PSTA
     C                   ENDIF
 
     C                   EVAL      DAYSINPD = BJRDNB - VALD
 
      ** Not exceeding overdraft limit at this point in the past
 
     C                   IF        CLBLHST >= -(ODLNDP)
     C                   LEAVE
     C                   ENDIF
 
     C     PMHPOSK2      READPE    PMHPOSL1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *  REPORT - Prepare Printer File for Reporting Process          *
      *****************************************************************
     C     REPORT        BEGSR
      *****************************************************************
 
     C     *START        SETLL     LEODXTPD
     C                   READ      LEODXTPD
 
     C                   DOW       NOT %EOF
 
     C                   IF        X_BRCA <> H#BRCA
     C                   IF        P@LEVEL = 'B'
     C                   EXSR      OPENPRTF
     C                   ELSE
     C                   EVAL      P1OVERFLOW = *ON
     C                   ENDIF
 
     C                   EVAL      @BRCD = X_BRCA
     C                   EXSR      GETBRANCH
     C                   EVAL      H#BRCA = X_BRCA
     C                   EVAL      H#BRNM = A8BRNM
     C                   ENDIF
 
     C                   EXSR      WRTREPORT
 
     C                   READ      LEODXTPD
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  WRTREPORT - Write Report                                     *
      *****************************************************************
     C     WRTREPORT     BEGSR
 
     C                   EVAL      #1GLACNT = X_CNUM
     C                                      + '-'
     C                                      + X_CCY
     C                                      + '-'
     C                                      + %EDITC(X_ACOD: 'X')
     C                                      + '-'
     C                                      + %EDITC(X_ACSQ: 'X')
 
     C                   IF        X_ACNO = *ZEROS
     C                   EVAL      #1RTACNO = *BLANKS
     C                   ELSE
     C                   EVAL      #1RTACNO = %EDITC(X_ACNO: 'X')
     C                   ENDIF
 
     C                   EVAL      #1ANAM = X_ANAM
 
     C                   EXSR      GETCUSTOMER
     C                   EVAL      #1CRNM = BBCRNM
 
      ** Cleared balance
 
     C                   CALL      'ZSEDIT'
     C                   PARM      X_CLBL        @NUMB
     C                   PARM      X_NBDP        @DECS
     C                   PARM      'J'           @EDTC
     C     #1CLBL        PARM                    @CHAR
 
      ** Ledger balance
 
     C                   CALL      'ZSEDIT'
     C                   PARM      X_LDBL        @NUMB
     C                   PARM      X_NBDP        @DECS
     C                   PARM      'J'           @EDTC
     C     #1LDBL        PARM                    @CHAR
 
     C                   EVAL      #1ODLN = %EDITC(X_ODLN: 'J')
 
     C                   EVAL      #1DAYSPD = %EDITC(X_DYPD: '1')
 
     C                   IF        X_LPYD = 0
     C                   EVAL      #1LSTPYD = *BLANKS
     C                   ELSE
     C                   CALL      'ZDATE2'
     C                   PARM      X_LPYD        @DATIN
     C                   PARM      BJDFIN        @DATFM
     C                   PARM      *ZEROS        @DATE6
     C                   PARM                    @DATE7
     C                   EVAL      #1LSTPYD = %EDITC(@DATE6: 'Y')
     C                   ENDIF
 
     C                   EXSR      CHKHEADS
     C                   WRITE     DETAIL01
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  GETBRANCH - Get Branch From File                             *
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
 
      /EJECT
      *****************************************************************
      *  GETCUSTOMER - Get Customer From File                         *
      *****************************************************************
     C     GETCUSTOMER   BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      X_CNUM        @CUST
     C                   PARM      *BLANKS       @KYSTS
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      BBCRNM = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  GETCURRENCY - Get Currency From File                         *
      *****************************************************************
     C     GETCURRENCY   BEGSR
 
     C                   EVAL      #C = %LOOKUP(CCY:DSCYCD)
 
     C                   IF        #C > 0
     C                   EVAL      SDCURR = DSCURR(#C)
 
     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      CCY           @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = @CURR
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #C = %LOOKUP(' ':DSCYCD)
 
     C                   IF        #C = 0
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = @CURR
     C                   EVAL      DBASE = 30
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      DSCYCD(#C) = CCY
     C                   EVAL      DSCURR(#C) = SDCURR
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  CHKHEADS - Check Headers                                     *
      *****************************************************************
     C     CHKHEADS      BEGSR
 
     C                   IF        P1OVERFLOW
     C                   WRITE     HEAD01
     C                   EVAL      P1OVERFLOW = *OFF
     C                   ENDIF
 
     C                   IF        X_KEY <> Y_KEY
     C                   IF            X_PDCLAS > 0
     C                             AND X_PDCLAS <= %ELEM(PDCLDSC)
     C                   EVAL      H#PDCLDSC = PDCLDSC(X_PDCLAS)
     C                   ELSE
     C                   EVAL      H#PDCLDSC = *BLANKS
     C                   ENDIF
     C                   WRITE     HEAD02
     C                   EVAL      Y_KEY = X_KEY
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  OPENPRTF - Open Printer File                                 *
      *****************************************************************
     C     OPENPRTF      BEGSR
 
 
     C                   IF        %OPEN(LE000091P1)
     C                   WRITE     FOOT01
     C                   CLOSE     LE000091P1
     C                   ENDIF
 
     C                   OPEN      LE000091P1
 
      ** Record spooled file details in RCF
 
     C                   IF            P@LEVEL = 'B'
     C                             AND P@ENTITY <> 'ALL'
     C                   EVAL      ZSENTITY = P@ENTITY
     C                   ELSEIF    P@LEVEL = 'B'
     C                   EVAL      ZSENTITY = X_BRCA
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
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      P1OVERFLOW = *ON
 
     C                   ENDSR
 
 
      /EJECT
      *****************************************************************
      *  CLOSEDOWN - End Program                                      *
      *****************************************************************
     C     CLOSEDOWN     BEGSR
 
     C                   IF        NOT %OPEN(LE000091P1)
     C                             AND P@ENTITY <> 'ALL'
     C                   EXSR      OPENPRTF
 
     C                   EVAL      @BRCD = P@ENTITY
     C                   EXSR      GETBRANCH
     C                   EVAL      H#BRCA = P@ENTITY
     C                   EVAL      H#BRNM = A8BRNM
     C                   ENDIF
 
     C                   IF        %OPEN(LE000091P1)
     C                   EXSR      CHKHEADS
     C                   IF        P@LEVEL = 'B'
     C                   WRITE     FOOT01
     C                   ELSE
     C                   WRITE     FOOT02
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
 
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
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCLNDPD'
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set past due class arrays according to mode
 
     C                   IF        P@MODE = 'BASEL2'
     C                   EVAL      BASEL2MODE = *ON
     C                   EVAL      PDCLDSC = B2PDCLDSC
     C                   EVAL      PDCLDYS = B2PDCLDYS
     C                   ELSE
     C                   EVAL      PDCLDSC = RPPDCLDSC
     C                   EVAL      PDCLDYS = RPPDCLDYS
     C                   ENDIF
 
      ** Derive 'Last Ascending' element of the days array;
      ** for use with look-up, to follow.
 
     C                   EVAL      LSTASCNDG = %ELEM(PDCLDYS)
     C                   FOR       IDX = 2 TO %ELEM(PDCLDYS)
     C                   IF        PDCLDYS(IDX) <= PDCLDYS(IDX-1)
     C                   EVAL      LSTASCNDG = IDX - 1
     C                   LEAVE
     C                   ENDIF
     C                   ENDFOR
 
     C                   IF        P@LEVEL <> 'B'
     C                   EXSR      OPENPRTF
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  *PSSR - Default Error Subroutine                             *
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
