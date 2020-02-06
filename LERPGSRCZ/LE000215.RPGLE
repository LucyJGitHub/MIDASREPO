     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Past Due Loans enquiry')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000215 - Midas LE Past Due Loans Enquiry                   *
      *                                                               *
      *  Function:  This function displays the Past Due Loans         *
      *             relating to a loan or a fee                       *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD036918           Date 18Jan16               *
      *                 AR830785           Date 07May13               *
      *                 MD020076           Date 17Apr13               *
      *                 263840             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036918 - Additional screen with PDCL details is absent for *
      *             fee                                               *
      *           - Added Fee code detail                             *
      *  AR830785 - Looping on insert of accrued interest adjustment  *
      *             Extended core fix 263533. (Child: AR830786)       *
      *  MD020076 - Missing Loan number details in PDCL details       *
      *             for Fees                                          *
      *  263840 - FAMU field not output for PDCL Loan.                *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
     FLE000214DFCF   E             WORKSTN
 
     FLEPDUEL1  IF   E           K DISK
     FLEPDUFL1  IF   E           K DISK
 
     FLEPDUEL2  IF   E           K DISK    RENAME(LEPDUED0: LEPDUEL2F)
     FLEPDUFL2  IF   E           K DISK    RENAME(LEPDUFD0: LEPDUFL2F)
 
     FCLOAN     IF   E           K DISK    INCLUDE(CLOANCLF)
     FLEFEEDL1  IF   E           K DISK
     FACCNT     IF   E           K DISK    INCLUDE(ACCNTABF)
 
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** ZFREQ SR. ARRAY
     D/COPY ZACPYSRC,PSDS
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)
     D CLE042          S              1
 
     D PDTAPARM        S             32
     D PRETURNCODE     S              7
 
     D KFECNUM         S                   LIKE(FECNUM)
     D KFEFACL         S                   LIKE(FEFACL)
     D KFELOAN         S                   LIKE(FELOAN)
     D KFEFSEQ         S                   LIKE(FEFSEQ)
 
     D  ZIND           S              1
     D  ZDAYNO         S              5  0
     D  ZCCY           S              3
     D  ZLOC           S              3
 
     D  WCUPR          S             13  0
     D  WCURT          S             11  7
 
     D SECNUM          S                   LIKE(YTKPACL)
     D SEBRCA          S                   LIKE(YTKPABR)
     D SEACOD          S                   LIKE(YTKPAAC)
     D SEACSQ          S                   LIKE(YTKPASE)
     D SEACCY          S                   LIKE(YTKPACY)
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D DSFDY         E DS
     D DSSDY         E DS
 
      ** Past Due Parameter
     D PDDATA          DS
     D  PDTYPE                 1      4
     D  PDLNRF                 5     10
     D  PDCNUM                11     16
     D  PDFACL                17     21  0
     D   PDFTYP               17     19
     D   PDFSEQ               20     21
     D  PDFEESEQ              22     23  0
     D  PDBRCA                24     26
     D  PDLOANTYP1            31     31
 
      ** Additional Field Definitions
     D W#NUMB          S             15  0
     D W#DECS          S              1  0
     D W#EDTC          S              1
     D W#CHAR          S             21
     D WSUBT           S              1
     D WLICD           S              5  0
     D @DATFM          S              1
     D @DATE6          S              6  0
     D @DATE7          S              7
     D @DATIN          S              5  0
     D ZIEND           S              5  0
     D ZICALC          S              1  0
     D ZIAMT           S             15  0
     D ZIRATE          S             11  7
     D ZINTRGC         S             30  9
     D WINTRP          S             16  3
     D ZINTR           S             16  3
     D RDWORK          S             13  0
     D RUWORK          S             13  0
     D W78VDT          S              5  0
     D W78MDT          S              5  0
     D W78FLT          S             15  0
     D W78RPF          S              1
     D W78FRD          S              5  0
     D W78RPM          S              2  0
     D W78CCY          S              3
     D W78LCN          S              3
     D W78BEG          S              5  0
     D W78END          S              5  0
     D W78ROA          S              1
     D W78INT          S             30  9
     D W78SUM          S              6  0
     D W78NPY          S              5  0
     D W78NTH          S              3  0
     D W78PRD          S              3  0
     D WZDAYN          S              5  0
     D WZFREQ          S              1
     D WZMDAY          S              2  0
     D WZCCY           S              3
     D WZLOC           S              3
     D WKSUM           S              8  2
     D WKSAV           S              3  0
     D WINTPD          S             30  9
     D ZFREQ           S              1
     D ZMDAY           S              2  0
     D ZMDAT           S              5  0
     D @KEY1           S             10
     D @KYST           S              7
     D @CCY            S              3
     D CLE028          S              1
     D ZIBEG           S              5  0
 
      ** +--- Start of Main processing -----------------------------------+
      ** Ê                                                                Ê
      ** Ê Initial processing is performed automatically: the *INZSR is   Ê
      ** Ê executed at program activation.                                Ê
      ** Ê                                                                Ê
      ** +----------------------------------------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    PRETURNCODE
     C     PDDATA        PARM                    PDTAPARM
 
 
     C     KACCT         KLIST
     C                   KFLD                    SECNUM
     C                   KFLD                    SEACCY
     C                   KFLD                    SEACOD
     C                   KFLD                    SEACSQ
     C                   KFLD                    SEBRCA
 
     C     KPDUE         KLIST
     C                   KFLD                    PDLNRF
 
     C     KPDUF         KLIST
     C                   KFLD                    PDLNRF
     C                   KFLD                    PDCNUM
     C                   KFLD                    PDFACL
     C                   KFLD                    PDFEESEQ
     C                   KFLD                    PDBRCA
 
     C     KLEFEEDL1     KLIST
     C                   KFLD                    KFECNUM
     C                   KFLD                    KFEFACL
     C                   KFLD                    KFELOAN
     C                   KFLD                    KFEFSEQ
 
     C                   EXSR      MAIN
 
     C                   EXSR      CLOSEDOWN
 
      /EJECT
      *****************************************************************
      *  MAIN - Main Processing Routine                               *
      *****************************************************************
     C     MAIN          BEGSR
 
     C                   EXSR      ADJFORXYZ
 
     C                   CLEAR                   LE0214LN
     C                   CLEAR                   LE0214FE
 
     C                   IF        PDTYPE = 'LOAN'
     C                   EXSR      ORIGINLOAN
     C                   EXSR      PDLOAN
     C                   ELSE
     C                   EXSR      ORIGINFEE
     C                   EXSR      PDFEE
     C                   ENDIF
 
     C                   WRITE     LE0214H1
 
     C                   IF        PDTYPE = 'LOAN'
     C                   EXFMT     LE0214LN
     C     *IN79         DOWEQ     *ON
     C     *IN78         OREQ      *ON
     C     *IN79         IFEQ      '1'
     C                   SETOFF                                       7879
     C                   EXFMT     LE0214L2
     C                   ENDIF
     C     *IN78         IFEQ      '1'
     C                   SETOFF                                       7879
     C                   EXFMT     LE0214LN
     C                   ENDIF
     C                   ENDDO
     C                   ELSE
     C                   EXFMT     LE0214FE
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  ADJFORXYZ - Adjust for Past Due Call Loan Types              *
      *****************************************************************
     C     ADJFORXYZ     BEGSR
 
      ** The calling display is itself for a Past Due Call Loan
 
     C                   IF            PDLOANTYP1 = 'X'
     C                             OR  PDLOANTYP1 = 'Y'
     C                             OR  PDLOANTYP1 = 'Z'
 
      ** Record linking the PDCL to the origin loan (X, Y) or
      ** fee (Z) mst exist
 
     C                   IF        PDLOANTYP1 = 'Z'
     C     PDLNRF        CHAIN     LEPDUFL1
     C                   ELSE
     C     PDLNRF        CHAIN     LEPDUEL1
     C                   ENDIF
 
     C**********         IF        NOT %FOUND(LEPDUEL1)                                     MD036918
     C                   IF        NOT %FOUND                                               MD036918
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Fix parameter values accordingly
 
     C                   IF            PDLOANTYP1 = 'X'
     C                             OR  PDLOANTYP1 = 'Y'
     C                             OR  PDLOANTYP1 = 'Z'
     C                             OR  PDLOANTYP1 = ' '
 
     C                   IF        PDLOANTYP1 = 'Z'
     C                             OR  PDLOANTYP1 = ' '
     C**********         IF        PDTYPE = *BLANKS                                MD020076 MD036918
     C                   IF        YPORG = *BLANKS
     C                   EVAL      PDTYPE = 'FFEE'
     C                   ELSE
     C                   EVAL      PDTYPE = 'LFEE'
     C                   ENDIF
     C**********         ENDIF                                                     MD020076 MD036918
     C                   ENDIF
 
     C                   IF        PDLOANTYP1 <>' '
     C                   EVAL      PDLNRF = YPORG
     C                   EVAL      PDCNUM = YECNUM
     C                   EVAL      PDFACL = YEFACL
     C                   EVAL      PDFEESEQ = YESEQ
     C                   EVAL      PDBRCA = YBRCA
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  ORIGINLOAN - Derive the Origin Loan Details                  *
      *****************************************************************
     C     ORIGINLOAN    BEGSR
 
     C                   EVAL      #1PORG = PDLNRF
 
     C     PDLNRF        CHAIN     CLOAN
     C                   IF        %FOUND(CLOAN)
     C                   EVAL      #1LTYP = LTYP
     C                   EVAL      #1SUTP = SUTP
     C                   EVAL      #1CLAS = CLAS
 
     C                   EVAL      #1CUST = CNUM
     C                   EVAL      @KEY1 = CNUM
     C                   EXSR      GETCUST
     C                   EVAL      #1CRNM = BBCRNM
     C                   EVAL      #1CRTN = BBCRTN
 
     C                   EVAL      #1FTYP = %EDITC(FTYP: 'X')
     C                   EVAL      #1FSEQ = %EDITC(FSEQ: 'X')
 
     C                   EVAL      #1CCY = CCY
     C                   EVAL      @CCY = CCY
     C                   EXSR      GETCCY
 
     C                   CALL      'ZSEDIT'
     C                   PARM      CPAM          W#NUMB
     C                   PARM      A6NBDP        W#DECS
     C                   PARM      'J'           W#EDTC
     C                   PARM                    W#CHAR
     C                   EVAL      #1CPAM = %SUBST(W#CHAR: 4)
     C                   EVAL      W#NUMB = AIPD
     C                                    - IPRD
     C                                    - ICTD
 
      ** Calculate Interest
 
     C                   MOVE      *BLANKS       WSUBT
     C     MDAT          IFLT      IACD
     C     MDAT          ANDNE     0
     C                   EVAL      W#NUMB = AIAP + AIMN + PDIN
     C                   MOVE      'Y'           WSUBT
     C                   ENDIF
 
     C                   EVAL      ZMDAT  = MDAT
 
      ** Calculate Interest
 
     C     RECI          IFEQ      'D'
     C     MDAT          ANDLT     IACD
     C     MDAT          ANDNE     *ZEROS
     C     AIAP          ADD       AIMN          W#NUMB
     C     PDIN          ADD       W#NUMB        W#NUMB
     C                   ENDIF
     C                   Z-ADD     0             WLICD
     C                   Z-ADD     0             ZINTR
     C     CPAM          IFGE      0
     C     MDAT          IFEQ      0
     C     MDAT          ORNE      0
     C     BJRDNB        ANDLT     MDAT
     C                   EVAL      ZIEND = BJRDNB
     C                   ELSE
     C                   EVAL      ZIEND = MDAT
     C                   ENDIF
     C                   EVAL      W78END = ZIEND
     C                   EVAL      ZMDAT = MDAT
     C                   EXSR      ZFLAC
     C                   EVAL      WCUPR = CPAM
     C                   EVAL      WCURT = INTR
     C                   EVAL      W78BEG = VDAT
     C                   EVAL      W78ROA = 'A'
     C                   EXSR      INCL
     C                   EVAL      W#NUMB = ZINTR
     C                   ENDIF
 
      ** Calculate Interest Outstanding
 
     C     CLE028        IFEQ      'N'
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDNE     80
     C                   EVAL      W#NUMB = W#NUMB + AITC + AIAP + AIMN
     C                   EVAL      WSUBT = 'Y'
     C                   ENDIF
 
     C     CLE028        IFEQ      'N'
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDNE     80
     C     WSUBT         IFEQ      *BLANKS
 
     C                   EVAL      W#NUMB = W#NUMB + AITC + AIAP + AIMN
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W#NUMB = W#NUMB - IWOD
 
     C     CLE028        IFEQ      'N'
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDNE     80
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDEQ     80
     C     ADIF          ANDNE     'Y'
     C                   EVAL      W#NUMB = W#NUMB - IPRD
     C                   ENDIF
 
     C                   EVAL      W#NUMB = W#NUMB - ICTD
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB
     C                   PARM      A6NBDP        W#DECS
     C                   PARM      'J'           W#EDTC
     C                   PARM                    W#CHAR
     C                   EVAL      #1OSIN = %SUBST(W#CHAR: 4)
 
     C                   CALL      'ZDATE2'
     C                   PARM      RIDT          @DATIN
     C                   PARM                    @DATFM
     C                   PARM      *ZEROS        @DATE6
     C     #1RIDT        PARM      *BLANKS       @DATE7
 
     C                   EVAL      #1BCAT = %EDITC(BCAT: 'X')
 
     C                   CALL      'ZDATE2'
     C                   PARM      BIDT          @DATIN
     C                   PARM                    @DATFM
     C                   PARM      *ZEROS        @DATE6
     C     #1BIDT        PARM      *BLANKS       @DATE7
 
     C                   EVAL      #1RCAT = %EDITC(RCAT: 'X')
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  PDLOAN - Derive the Past Due Loans Detail (loan origin)      *
      *****************************************************************
     C     PDLOAN        BEGSR
 
     C     KPDUE         SETLL     LEPDUEL2
     C                   DO        *HIVAL
     C     KPDUE         READE     LEPDUEL2
     C                   IF        %EOF(LEPDUEL2)
     C                   LEAVE
     C                   ENDIF
 
     C     YPLON         CHAIN     CLOAN
     C                   IF        NOT %FOUND(CLOAN)
     C                   ITER
     C                   ENDIF
 
     C                   IF        %SUBST(LTYP: 1: 1) = 'X'
     C                   EXSR      TYPEXORZ_PD
     C                   ELSEIF    %SUBST(LTYP: 1: 1) = 'Y'
     C                   EXSR      TYPEY_PD
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      * TYPEXORZ_PD - Derive PDCL detail for ln types starting  X/Z   *
      *****************************************************************
     C     TYPEXORZ_PD   BEGSR
 
     C                   EVAL      #1PLNRF = LNRF
     C                   EVAL      #1PLTYP = LTYP
     C                   EVAL      #1PSUTP = SUTP
     C                   EVAL      #1PCLAS = CLAS
 
     C                   EVAL      #1PCCY = CCY
     C                   EVAL      @CCY = CCY
     C                   EXSR      GETCCY
 
     C                   CALL      'ZSEDIT'
     C                   PARM      CPAM          W#NUMB
     C                   PARM      A6NBDP        W#DECS
     C                   PARM      'J'           W#EDTC
     C                   PARM                    W#CHAR
     C                   EVAL      #1PCPAM = %SUBST(W#CHAR: 4)
 
     C                   EVAL      W#NUMB = AIPD
     C                                    - IPRD
     C                                    - ICTD
 
      ** Calculate Interest
 
     C                   MOVE      *BLANKS       WSUBT
     C     MDAT          IFLT      IACD
     C     MDAT          ANDNE     0
     C                   EVAL      W#NUMB = AIAP + AIMN + PDIN
     C                   MOVE      'Y'           WSUBT
     C                   ENDIF
 
      ** Calculate Interest
 
     C     RECI          IFEQ      'D'
     C     MDAT          ANDLT     IACD
     C     MDAT          ANDNE     *ZEROS
     C     AIAP          ADD       AIMN          W#NUMB
     C     PDIN          ADD       W#NUMB        W#NUMB
     C                   ENDIF
     C                   Z-ADD     0             WLICD
     C                   Z-ADD     0             ZINTR
     C     CPAM          IFGE      0
     C     MDAT          IFEQ      0
     C     MDAT          ORNE      0
     C     BJRDNB        ANDLT     MDAT
     C                   EVAL      ZIEND = BJRDNB
     C                   ELSE
     C                   EVAL      ZIEND = MDAT
     C                   ENDIF
     C                   EVAL      W78END = ZIEND
     C                   EVAL      ZMDAT = MDAT
     C                   EXSR      ZFLAC
     C                   EVAL      WCUPR = CPAM
     C                   EVAL      WCURT = INTR
     C                   EVAL      W78BEG = VDAT
     C                   EVAL      W78ROA = 'A'
     C                   EXSR      INCL
     C                   EVAL      W#NUMB = ZINTR
     C                   ENDIF
 
      ** Calculate Interest outstanding
 
     C                   MOVE      *BLANKS       WSUBT
     C     CLE028        IFEQ      'N'
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDNE     80
     C                   EVAL      W#NUMB = W#NUMB + AITC + AIAP + AIMN
     C                   EVAL      WSUBT = 'Y'
     C                   ENDIF
 
     C     CLE028        IFEQ      'N'
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDNE     80
     C     WSUBT         IFEQ      *BLANKS
 
     C                   EVAL      W#NUMB = W#NUMB + AITC + AIAP + AIMN
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W#NUMB = W#NUMB - IWOD
 
     C     CLE028        IFEQ      'N'
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDNE     80
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDEQ     80
     C     ADIF          ANDNE     'Y'
     C                   EVAL      W#NUMB = W#NUMB - IPRD
     C                   ENDIF
 
     C                   EVAL      W#NUMB = W#NUMB - ICTD
 
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB
     C                   PARM      A6NBDP        W#DECS
     C                   PARM      'J'           W#EDTC
     C                   PARM                    W#CHAR
     C                   EVAL      #1POSIN = %SUBST(W#CHAR: 4)
 
     C                   EVAL      #1PFAMU = FAMU
     C                   EVAL      #1IFAMU = FAMU                                             263840
     C                   EVAL      #1PSIN  = YPSIIN
     C                   EVAL      #1PCIN = YPCIIN
     C                   EVAL      #1PDECR = YDECRE
 
     C                   EVAL      #1PCNUM = YTKPACL
     C                   MOVE      YTKPAAC       #1PACOD
     C                   MOVE      YTKPASE       #1PACSQ
 
     C     YTKPAAC       IFEQ      0
     C                   CLEAR                   #1PACOD
     C                   CLEAR                   #1PACSQ
     C                   ENDIF
 
     C                   MOVE      YTKPACL       SECNUM
     C                   MOVE      YTKPABR       SEBRCA
     C                   MOVE      YTKPAAC       SEACOD
     C                   MOVE      YTKPASE       SEACSQ
     C                   MOVE      YTKPACY       SEACCY
 
     C                   CLEAR                   #1PACNO
     C     KACCT         CHAIN     ACCNT
     C                   IF        %FOUND(ACCNT)
     C                   MOVE      ACNO          #1PACNO
     C                   ENDIF
 
     C                   EVAL      #1PBRCA = YTKPABR
     C                   EVAL      #1TPCCY = YTKPACY
 
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      * TYPEY_PD - Derive PDCL detail for loans with Type starting Y  *
      *****************************************************************
     C     TYPEY_PD      BEGSR
 
     C                   EVAL      #1ILNRF = LNRF
     C                   EVAL      #1ILTYP = LTYP
     C                   EVAL      #1ISUTP = SUTP
     C                   EVAL      #1ICLAS = CLAS
 
     C                   EVAL      #1ICCY = CCY
     C                   EVAL      @CCY = CCY
     C                   EXSR      GETCCY
 
     C                   CALL      'ZSEDIT'
     C                   PARM      CPAM          W#NUMB
     C                   PARM      A6NBDP        W#DECS
     C                   PARM      'J'           W#EDTC
     C                   PARM                    W#CHAR
     C                   EVAL      #1ICPAM = %SUBST(W#CHAR: 4)
 
     C                   EVAL      W#NUMB = AIPD
     C                                    - IPRD
     C                                    - ICTD
 
      ** Calculate interest
 
     C                   MOVE      *BLANKS       WSUBT
     C     MDAT          IFLT      IACD
     C     MDAT          ANDNE     0
     C                   EVAL      W#NUMB = AIAP + AIMN + PDIN
     C                   MOVE      'Y'           WSUBT
     C                   ENDIF
 
      ** Calculate interest
 
     C     RECI          IFEQ      'D'
     C     MDAT          ANDLT     IACD
     C     MDAT          ANDNE     *ZEROS
     C     AIAP          ADD       AIMN          W#NUMB
     C     PDIN          ADD       W#NUMB        W#NUMB
     C                   ENDIF
     C                   Z-ADD     0             WLICD
     C                   Z-ADD     0             ZINTR
     C     CPAM          IFGE      0
     C     MDAT          IFEQ      0
     C     MDAT          ORNE      0
     C     BJRDNB        ANDLT     MDAT
     C                   EVAL      ZIEND = BJRDNB
     C                   ELSE
     C                   EVAL      ZIEND = MDAT
     C                   ENDIF
     C                   EVAL      W78END = ZIEND
     C                   EVAL      ZMDAT = MDAT
     C                   EXSR      ZFLAC
     C                   EVAL      WCUPR = CPAM
     C                   EVAL      WCURT = INTR
     C                   EVAL      W78BEG = VDAT
     C                   EVAL      W78ROA = 'A'
     C                   EXSR      INCL
     C                   EVAL      W#NUMB = ZINTR
     C                   ENDIF
 
      ** Calculate interest outstanding
 
     C                   MOVE      *BLANKS       WSUBT
     C     CLE028        IFEQ      'N'
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDNE     80
     C                   EVAL      W#NUMB = W#NUMB + AITC + AIAP + AIMN
     C                   EVAL      WSUBT = 'Y'
     C                   ENDIF
 
     C     CLE028        IFEQ      'N'
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDNE     80
     C     WSUBT         IFEQ      *BLANKS
 
     C                   EVAL      W#NUMB = W#NUMB + AITC + AIAP + AIMN
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W#NUMB = W#NUMB - IWOD
 
     C     CLE028        IFEQ      'N'
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDNE     80
     C     CLE028        OREQ      'Y'
     C     PTYP          ANDEQ     80
     C     ADIF          ANDNE     'Y'
     C                   EVAL      W#NUMB = W#NUMB - IPRD
     C                   ENDIF
 
     C                   EVAL      W#NUMB = W#NUMB - ICTD
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    W#NUMB
     C                   PARM      A6NBDP        W#DECS
     C                   PARM      'J'           W#EDTC
     C                   PARM                    W#CHAR
     C                   EVAL      #1IOSIN = %SUBST(W#CHAR: 4)
 
     C                   EVAL      #1IFAMU = FAMU
 
      ** Interest
 
     C                   EVAL      #1PSIN = YPSIIN
     C                   EVAL      #1PCIN = YPCIIN
 
      ** Interest
 
     C                   EVAL      #1ISIN = YPSIIN
     C                   EVAL      #1ICIN = YPCIIN
     C                   EVAL      #1IDECR = YDECRE
 
     C                   EVAL      #1ICNUM = YTKIACL
     C                   MOVE      YTKIAAC       #1IACOD
     C                   MOVE      YTKIASE       #1IACSQ
     C                   EVAL      #1IBRCA = YTKIABR
     C                   EVAL      #1TICCY = YTKIACY
 
     C     YTKIAAC       IFEQ      0
     C                   CLEAR                   #1IACOD
     C                   CLEAR                   #1IACSQ
     C                   ENDIF
 
 
     C                   MOVE      YTKIACL       SECNUM
     C                   MOVE      YTKIABR       SEBRCA
     C                   MOVE      YTKIAAC       SEACOD
     C                   MOVE      YTKIASE       SEACSQ
     C                   MOVE      YTKIACY       SEACCY
 
     C                   CLEAR                   #1IACNO
     C     KACCT         CHAIN     ACCNT
     C                   IF        %FOUND(ACCNT)
     C                   MOVE      ACNO          #1IACNO
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  ORIGINFEE - Derive the Origin Fee Details                    *
      *****************************************************************
     C     ORIGINFEE     BEGSR
 
     C                   IF        PDTYPE = 'LFEE'
     C                   EVAL      #1PORG = PDLNRF
     C                   ELSE
     C                   EVAL      #1FTYP = PDFTYP
     C                   EVAL      #1FSEQ = PDFSEQ
     C                   ENDIF
 
     C                   EVAL      #1FBRC = PDBRCA
     C                   EVAL      #1FESQ = %EDITC(PDFEESEQ: 'X')
     C                   EVAL      #1CUST = PDCNUM
     C                   EVAL      @KEY1 = #1CUST
     C                   EXSR      GETCUST
 
     C                   EVAL      KFECNUM = PDCNUM
     C                   EVAL      KFEFACL = PDFACL
     C                   EVAL      KFELOAN = PDLNRF
     C                   EVAL      KFEFSEQ = PDFEESEQ
     C     KLEFEEDL1     CHAIN(E)  LEFEEDL1
 
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'ZDATE2'
     C                   PARM      FERIDT        @DATIN
     C                   PARM                    @DATFM
     C                   PARM      *ZEROS        @DATE6
     C     #1RIDT        PARM      *BLANKS       @DATE7
 
     C                   IF        %FOUND(LEFEEDL1)
     C                   EVAL      #1RCAT = %EDITC(FERCAT: 'X')
 
     C                   CALL      'ZDATE2'
     C                   PARM      FEBIDT        @DATIN
     C                   PARM                    @DATFM
     C                   PARM      *ZEROS        @DATE6
     C     #1BIDT        PARM      *BLANKS       @DATE7
 
     C                   EVAL      #1BCAT = %EDITC(FEBCAT: 'X')
     C                   MOVEL     FEFCOD        #1FCOD                                     MD036918
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  PDFEE - Derive the Past Due Loan Detail (fee origin)         *
      *****************************************************************
     C     PDFEE         BEGSR
 
      ** Derive the Past Due Loan Detail (fee origin)
 
     C     KPDUF         CHAIN     LEPDUFL2
 
     C                   IF        %FOUND(LEPDUFL2)
     C     YPLON         CHAIN     CLOAN
 
     C                   IF        %FOUND(CLOAN)
     C                   EXSR      TYPEXORZ_PD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  INCL  -  Interest calculation                                *
      *  Called by: LOAN - Set up loan header details                 *
      *            HIST  - Process history records                    *
      *            LOAM  - Process loan amendment records             *
      *            RPAY  - Process frequency repayments               *
      *  Calls    : None                                              *
      *****************************************************************
     C     INCL          BEGSR
 
      ** Do not compute for interest if not greater than 0
 
     C     WCURT         IFLE      *ZEROS
     C     WCUPR         OREQ      *ZEROS
     C                   Z-ADD     *ZEROS        ZINTR
     C                   ELSE
 
     C                   Z-ADD     IACD          ZIBEG
 
     C     PDDI          IFEQ      'A'
     C     ZIBEG         ANDGT     ZIEND
     C                   Z-ADD     ZIBEG         ZIEND
     C                   ENDIF
 
     C                   MOVE      ICBS          ZICALC
     C                   Z-ADD     WCUPR         ZIAMT
     C                   Z-ADD     WCURT         ZIRATE
 
      ** Instead of executing SR/GLINTC, process RULE78 if CLE028 on,
      ** and processing type (PTYP) is 80
 
     C     CLE028        IFEQ      'Y'
     C     PTYP          ANDEQ     80
     C                   Z-ADD     VDAT          W78VDT
     C                   Z-ADD     MDAT          W78MDT
     C                   Z-ADD     FLTI          W78FLT
     C                   MOVE      RFRQ          W78RPF
     C                   Z-ADD     FRPD          W78FRD
     C                   Z-ADD     RDYN          W78RPM
     C                   MOVE      CCY           W78CCY
     C                   MOVE      *BLANKS       W78LCN
 
     C                   EXSR      RULE78
     C                   Z-ADD     W78INT        ZINTR
 
     C                   ELSE
 
     C                   CALL      'GLINTC'
     C                   PARM                    ZIBEG
     C                   PARM                    ZIEND
     C                   PARM                    ZICALC
     C                   PARM                    ZIAMT
     C                   PARM                    ZIRATE
     C                   PARM                    ZINTRGC
 
     C                   Z-ADD(H)  ZINTRGC       WINTRP
     C                   Z-ADD(H)  ZINTRGC       ZINTR
     C                   ENDIF
 
      ** Round down interest if required
 
     C     RDFC          IFEQ      'Y'
     C                   Z-ADD     ZINTR         RDWORK
     C                   Z-ADD     RDWORK        ZINTR
     C                   ELSE
     C                   Z-ADD(H)  ZINTR         RUWORK
     C                   Z-ADD     RUWORK        ZINTR
     C                   ENDIF
     C                   Z-ADD     ZIEND         WLICD
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  RULE78 - Calculate Outstanding interest for a given period   *
      *          based on Rule of 78                                  *
      *****************************************************************
     C     RULE78        BEGSR
 
      ** Define input and output fields
 
     C                   Z-ADD     W78VDT        W78VDT
     C                   Z-ADD     W78MDT        W78MDT
     C                   Z-ADD     W78FLT        W78FLT
     C                   MOVE      W78RPF        W78RPF
     C                   Z-ADD     W78FRD        W78FRD
     C                   Z-ADD     W78RPM        W78RPM
     C                   MOVE      W78CCY        W78CCY
     C                   MOVE      W78LCN        W78LCN
     C                   Z-ADD     W78BEG        W78BEG
     C                   Z-ADD     W78END        W78END
     C                   MOVE      W78ROA        W78ROA
     C                   Z-ADD     *ZERO         W78INT
     C                   Z-ADD     *ZERO         W78SUM
     C                   Z-ADD     *ZERO         W78NPY
     C                   Z-ADD     *ZERO         W78NTH
     C                   Z-ADD     *ZERO         W78PRD
 
      ** Save fields, may be used in other programs
 
     C                   Z-ADD     ZDAYNO        WZDAYN
     C                   MOVE      ZFREQ         WZFREQ
     C                   Z-ADD     ZMDAY         WZMDAY
     C                   MOVE      ZCCY          WZCCY
     C                   MOVE      ZLOC          WZLOC
 
      ** Compute for the total number of payments during the life of
      ** the loan, depending on the repayment frequency
 
     C     W78RPF        IFEQ      *BLANKS
     C                   GOTO      ERUL78
     C                   ENDIF
 
     C                   Z-ADD     1             W78NPY
     C                   Z-ADD     W78FRD        ZDAYNO
     C                   MOVE      W78RPF        ZFREQ
     C                   Z-ADD     W78RPM        ZMDAY
     C                   MOVE      W78CCY        ZCCY
     C                   MOVE      W78LCN        ZLOC
     C                   EXSR      ZFREQB
     C     ZDAYNO        DOWLT     W78MDT
     C     ZDAYNO        ANDGE     W78FRD                                                   AR830785
     C                   ADD       1             W78NPY
     C                   EXSR      ZFREQB
     C                   ENDDO
 
      ** Add 1 to total number of payments to include repayment on
      ** maturity date
 
     C                   ADD       1             W78NPY
 
      ** Compute for the sum of digits
 
     C     W78NPY        ADD       1             WKSUM
     C                   DIV       2             WKSUM
     C     WKSUM         MULT      W78NPY        W78SUM
 
      ** If first repayment date is a holiday, move to next working day
 
     C                   Z-ADD     W78FRD        ZDAYNO
     C                   MOVE      W78CCY        ZCCY
     C                   MOVE      W78LCN        ZLOC
     C                   MOVE      *BLANKS       ZIND
     C     ZIND          DOUNE     'H'
     C                   CALL      'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C     ZIND          IFEQ      'H'
     C                   ADD       1             ZDAYNO
     C                   ENDIF
     C                   ENDDO
 
      ** Compute for the Nth payment for interest for a given period
 
     C     W78ROA        IFEQ      'A'
     C     W78VDT        IFEQ      W78BEG
     C                   Z-ADD     1             W78NTH
     C                   ELSE
     C                   Z-ADD     2             W78NTH
     C                   ENDIF
     C                   ELSE
     C     W78BEG        IFLT      ZDAYNO
     C     W78BEG        IFEQ      W78END
     C                   Z-ADD     ZDAYNO        W78END
     C                   ENDIF
     C                   Z-ADD     ZDAYNO        W78BEG
     C                   ENDIF
     C                   Z-ADD     1             W78NTH
     C                   ENDIF
 
     C                   MOVE      W78RPF        ZFREQ
     C                   Z-ADD     W78RPM        ZMDAY
     C                   MOVE      W78CCY        ZCCY
     C                   MOVE      W78LCN        ZLOC
     C                   MOVE      ZDAYNO        TDAYNO            5 0                      AR830785
     C     ZDAYNO        DOWLT     W78BEG
     C     ZDAYNO        ANDGE     TDAYNO                                                   AR830785
     C                   EXSR      ZFREQB
     C                   ADD       1             W78NTH
 
      ** If next  repayment date is a holiday, move to next working day
 
     C     ZIND          DOUNE     'H'
     C                   CALL      'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C     ZIND          IFEQ      'H'
     C                   ADD       1             ZDAYNO
     C                   ENDIF
     C                   ENDDO
     C                   ENDDO
 
      ** If end date < start date, OR amortisation date same or after
      ** maturity date, OR repayment date is after maturity date,
      ** OR repayment date earlier than the first repayment date
      ** - zeroise the interest amount
 
     C     W78END        IFLT      W78BEG
     C     W78BEG        ORGE      W78MDT
     C     W78ROA        ANDEQ     'A'
     C     W78BEG        ORLT      W78VDT
     C     W78ROA        ANDEQ     'A'
     C     W78BEG        ORGT      W78MDT
     C     W78ROA        ANDEQ     'R'
     C     W78BEG        ORLT      W78FRD
     C     W78END        ANDLT     W78FRD
     C     W78ROA        ANDEQ     'R'
     C                   Z-ADD     *ZERO         W78INT
     C                   GOTO      ERUL78
     C                   ENDIF
 
     C                   Z-ADD     W78NTH        WKSAV
 
      ** Compute for outstanding interest for the period
      ** until given end date or until
 
     C     ZDAYNO        DOUGT     W78END
     C     W78NTH        ORGT      W78NPY
     C     W78NPY        SUB       W78NTH        WINTPD
     C                   ADD       1             WINTPD
     C                   MULT      W78FLT        WINTPD
     C                   DIV       W78SUM        WINTPD
     C                   ADD       WINTPD        W78INT
 
      ** Do not process frequency date calculation on first payment
      ** date, i.e., beginning date is less than FRPD
 
     C     W78NTH        IFNE      1
     C     W78ROA        ANDEQ     'A'
     C     W78ROA        OREQ      'R'
     C                   EXSR      ZFREQB
 
      ** If next  repayment date is a holiday, move to next working day
 
     C     ZIND          DOUNE     'H'
     C                   CALL      'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C     ZIND          IFEQ      'H'
     C                   ADD       1             ZDAYNO
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ADD       1             W78NTH
     C                   ADD       1             W78PRD
     C                   ENDDO
     C                   SUB       1             W78PRD
     C                   Z-ADD     WKSAV         W78NTH
 
      ** Restore fields, may be used in other programs
 
     C     ERUL78        TAG
     C                   Z-ADD     WZDAYN        ZDAYNO
     C                   MOVE      WZFREQ        ZFREQ
     C                   Z-ADD     WZMDAY        ZMDAY
     C                   MOVE      WZCCY         ZCCY
     C                   MOVE      WZLOC         ZLOC
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  ZFREQB - Calc day num of next pymnt frq from curr dayno      *
      *****************************************************************
     C     ZFREQB        BEGSR
 
     C                   CALL      'ZFREQB'
     C                   PARM      *BLANKS       RETCODEIN
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZMDAY
     C                   PARM                    BJDFIN
     C                   PARM      SDGELR        SDGELR
 
     C                   ENDSR
 
      /EJECT
     C*****************************************************************
      *  ZFLAC - Calculate end date depending on ADDI                 *
      *                                                               *
      *  FIELDS INPUT:       1.  ZVDAT (VDAT OF LOAN)                 *
      *  2.  ZIBEG (BEG. DATE OF INT COMP.)                           *
      *                                                               *
      *  FIELD OUTPUT:       1.  ZIEND (END. DATE OF INT COMP.)       *
     C*****************************************************************
     C     ZFLAC         BEGSR
 
      ** CALCULATION TO DEFINE OUTPUT
 
     C                   Z-ADD     ZIEND         ZIEND
 
      ** CALCULATION TO DEFINE INPUT
     C**********           Z-ADDZVDAT     ZVDAT   50                                          245082
     C                   Z-ADD     ZMDAT         ZMDAT
 
     C                   Z-ADD     ZIBEG         ZIBEG
 
      ** ADD 1 TO END DATE IF ADDI = 'B' AND INTEREST IS ACCRUED
      ** FROM VALUE DATE I.E. INTEREST ACCRUAL DATE IS SAME AS LOAN
      ** VALUE DATE. INTEREST IS TO BE ACCRUED FOR EACH DAY THE LOAN
      ** IS LIVE, THEREFORE ADD 1 FOR LOAN VALUE DATE SINCE THE
      ** SYSTEM WILL AUTOMATICALLY ACCRUE INTEREST ON MATURITY DATE
      ** BY MEANS OF LAST DAY ACCRUAL PROCESSING.
      **
     C     ADDI          IFEQ      'B'
     C********** ZIBEG     ANDEQZVDAT                                                         245082
     C     ZIEND         ANDEQ     ZMDAT
     C                   ADD       1             ZIEND
     C                   ENDIF
      **
     C     ZFLEN2        ENDSR
 
      /EJECT
     C****************************************************************
      *  ZFLDC - Calculate end date depending on ADDI                *
      *                                                              *
      * FIELDS INPUT:       1.  ZMDAT (MDAT OF LOAN)                 *
      *                                                              *
      * FIELD INPUT/OUTPUT: 1.  ZIEND (END. DATE OF INT COMP.)       *
     C****************************************************************
     C     ZFLDC         BEGSR
 
      ** CALCULATION TO DEFINE INPUT
 
     C                   Z-ADD     ZMDAT         ZMDAT
 
      ** CALCULATION TO DEFINE INPUT/OUTPUT
 
     C                   Z-ADD     ZIEND         ZIEND
 
      ** ADD 1 TO END DATE IF ADDI = 'F' AND MATURITY DATE IS
      ** ZERO OR LATER THAN TODAY I.E. ACCRUE INTEREST EVERY
      ** DAY EXCEPT ON MATURITY DATE
 
     C     ADDI          IFEQ      'F'
     C     ADDI          OREQ      'B'
     C     ZMDAT         IFEQ      0
     C     ZMDAT         ORGT      ZIEND
     C                   ADD       1             ZIEND
     C                   ENDIF
     C                   ENDIF
      **
     C     ZFLEN1        ENDSR
 
      /EJECT
      *****************************************************************
      *   CLOSEDOWN - Close program                                   *
      *****************************************************************
     C     CLOSEDOWN     BEGSR
 
     C                   EVAL      *INLR       = *ON
     C                   RETURN
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  GETCUST - Get Customer                                       *
      *****************************************************************
     C     GETCUST       BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @KEY1
     C                   PARM                    @KYST
     C     SDCUST        PARM                    DSSDY
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  GETCCY - Get Currency                                        *
      *****************************************************************
     C     GETCCY        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @CCY
     C     SDCURR        PARM                    DSSDY
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  *INZSR - Initialisation                                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   EVAL      DBPGM = PSPROCPGM
     C                   EVAL      SUSER = PSUSER
     C                   EVAL      SPGM = PSPROCPGM
     C                   EVAL      SJOB = PSJOBNAME
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Check for presence of feature CLE042
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE042'      @SARD
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE042 = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   ELSE
     C                   EVAL      CLE042 = 'N'
     C                   EVAL      *IN30 = *OFF
     C                   ENDIF
 
      ** Check for presence of feature CLE028
 
     C                   MOVE      'N'           CLE028
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE028'      @SARD
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE028 = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   ELSE
     C                   EVAL      CLE028 = 'N'
     C                   EVAL      *IN30 = *OFF
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *  *PSSR - Error Handling                                       *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        RUNBEFORE <> 'Y'
     C                   EVAL      RUNBEFORE = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      PRETURNCODE = '*ERROR*'
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2012
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
