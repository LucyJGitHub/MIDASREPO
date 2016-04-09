     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Past Due Call Loans Maintenance Today')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000082 - Past Due Call Loans Maintenance Today             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
     FCLOANLB   IF   E           K DISK    INFSR(*PSSR)
 
     FLEPDUEL1  IF   E           K DISK    INFSR(*PSSR)
     FLEPDUFL1  IF   E           K DISK    INFSR(*PSSR)
 
     FLE000082P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
     F                                     OFLIND(P1OVERFLOW)
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS
 
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D DSFDY         E DS
     D DSSDY         E DS
 
     D DSCURR          S                   INZ DIM(500) LIKE(SDCURR)
     D DSCYCD          S                   INZ DIM(500) LIKE(A6CYCD)
 
     D                 DS
     D LTYP
     D  LTYP1                         1    OVERLAY(LTYP)
 
     D @DATOUT         S              8
 
     D PTR             S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(PTR)
     D CLE042                 30     30N
 
     D #C              S              9S 0 INZ
 
      ** Additional Field Definitions
     D P@SEQ           S              5
     D P@LEVEL         S              1
     D P@ENTITY        S              3
     D @NUMB           S             15  0
     D @DECS           S              1  0
     D @EDTC           S              1
     D @CHAR           S             21
     D @DATIN          S              5  0
     D @DATFM          S              1
     D @DATE6          S              6  0
     D @DATE7          S              7
     D @BRCD           S              3
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
 
     C                   EXSR      EXTRACT
 
     C                   EXSR      CLOSEDOWN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXTRACT - Extract Subroutine                                  *
      *****************************************************************
     C     EXTRACT       BEGSR
 
     C                   IF            P@LEVEL = 'B'
     C                             AND P@ENTITY <> 'ALL'
     C     P@ENTITY      SETLL     CLOANLB
     C     P@ENTITY      READE     CLOANLB
     C                   ELSE
     C     *START        SETLL     CLOANLB
     C                   READ      CLOANLB
     C                   ENDIF
 
     C                   DOW       NOT %EOF(CLOANLB)
 
     C                   IF            LCD = BJRDNB
     C                             AND (   LTYP1 = 'X'
     C                                 OR  LTYP1 = 'Y'
     C                                 OR  LTYP1 = 'Z' )
     C                   EXSR      REPORT
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
      *  REPORT - Write Report                                        *
      *****************************************************************
 
     C     REPORT        BEGSR
 
     C                   IF        BRCA <> H#BRCA
     C                   IF        P@LEVEL = 'B'
     C                   EXSR      OPENPRTF
     C                   ELSE
     C                   EVAL      P1OVERFLOW = *ON
     C                   ENDIF
 
     C                   EVAL      @BRCD = BRCA
     C                   EXSR      GETBRANCH
     C                   EVAL      H#BRCA = BRCA
     C                   EVAL      H#BRNM = A8BRNM
     C                   ENDIF
 
      ** Set up report fields
 
     C                   EVAL      #1LNRF = LNRF
     C                   EVAL      #1CNUM = CNUM
 
      ** Derive 'origin' loan or fee
 
     C                   EXSR      ORGNLNFE
 
      ** Get currency decimal places for amount formatting
 
     C                   EVAL      #1CCY = CCY
     C                   EXSR      GETCURRENCY
 
     C                   EVAL      @DATIN = VDAT
     C                   EXSR      CVTDATE
     C                   EVAL      #1VDAT = @DATOUT
 
     C                   IF        CLE042
     C                   EVAL      #1LTSTCL = LTYP + '-'
     C                                      + SUTP + '-'
     C                                      + CLAS
     C                   ELSE
     C                   EVAL      #1LTSTCL = ' '
     C                                      + LTYP + ' - '
     C                                      + SUTP
     C                   ENDIF
 
     C                   CALL      'ZSEDIT'
     C                   PARM      CPAM          @NUMB
     C                   PARM      A6NBDP        @DECS
     C                   PARM      'J'           @EDTC
     C     #1CPAM        PARM                    @CHAR
 
     C                   EVAL      #1INTR = %EDITC(INTR: 'J')
     C                   EVAL      #1ICBS = %EDITC(ICBS: 'X')
     C                   EVAL      #1CHTP = CHTP
 
     C                   EXSR      CHKHEADS
     C                   WRITE     DETAIL01
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ORGNLNFE - Derive Origin Loan or Fee                         *
      *****************************************************************
     C     ORGNLNFE      BEGSR
 
     C                   IF        LTYP1 = 'Z'
     C     LNRF          CHAIN     LEPDUFL1
     C                   ELSE
     C     LNRF          CHAIN     LEPDUEL1
     C                   ENDIF
 
     C                   IF        NOT %FOUND(LEPDUEL1)
     C                   EVAL      #1OGNLNF = *BLANKS
 
     C                   ELSEIF        LTYP1 = 'Z'
     C                             AND YEFACL > 0
     C                   EVAL      #1OGNLNF = %EDITC(YEFACL: 'X')
     C                                      + '-'
     C                                      + %EDITC(YESEQ: 'X')
 
     C                   ELSEIF    LTYP1 = 'Z'
     C                   EVAL      #1OGNLNF = YPORG
     C                                      + '-'
     C                                      + %EDITC(YESEQ: 'X')
 
     C                   ELSE
     C                   EVAL      #1OGNLNF = YPORG
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
      *  GETCURRENCY - Get Currency                                   *
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
     C                   EVAL      DBKEY  = @CURR
     C                   EVAL      DBASE  = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #C     = %LOOKUP(' ':DSCYCD)
 
     C                   IF        #C     = 0
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = @CURR
     C                   EVAL      DBASE  = 30
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      DSCYCD(#C) = CCY
     C                   EVAL      DSCURR(#C) = SDCURR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CHKHEADS - Check OverFlow                                    *
      *****************************************************************
     C     CHKHEADS      BEGSR
 
     C                   IF        P1OVERFLOW
     C                   WRITE     HEAD01
     C                   EVAL      P1OVERFLOW = *OFF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  OPENPRTF - Open Printerfile                                  *
      *****************************************************************
     C     OPENPRTF      BEGSR
 
 
     C                   IF        %OPEN(LE000082P1)
     C                   WRITE     FOOT01
     C                   CLOSE     LE000082P1
     C                   ENDIF
 
     C                   OPEN      LE000082P1
 
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
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      P1OVERFLOW = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CLOSEDOWN - Close Down Program                               *
      *****************************************************************
     C     CLOSEDOWN     BEGSR
 
     C                   IF        NOT %OPEN(LE000082P1)
     C                             AND P@ENTITY <> 'ALL'
     C                   EXSR      OPENPRTF
 
     C                   EVAL      @BRCD = P@ENTITY
     C                   EXSR      GETBRANCH
     C                   EVAL      H#BRCA = P@ENTITY
     C                   EVAL      H#BRNM = A8BRNM
     C                   ENDIF
 
     C                   IF        %OPEN(LE000082P1)
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
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check for presence of feature CLE042
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE042'      @SARD
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE042 = *ON
     C                   ELSE
     C                   EVAL      CLE042 = *OFF
     C                   ENDIF
 
     C                   IF        P@LEVEL <> 'B'
     C                   EXSR      OPENPRTF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
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
      *****************************************************************
