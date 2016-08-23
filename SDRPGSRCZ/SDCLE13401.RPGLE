     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Initialise New Fields (CLOANCL & LEFEED)')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  SDCLE13401 - Initialise New Fields on CLOANCL and LEFEED     *
      *               and Populate Extension Reference/Sequence       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CLE141             Date 08Feb16               *
      *  Prev Amend No. AR1022006          Date 01Aug12               *
      *                 AR318270           Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  AR1022006 - COB Performance Optimisation                     *
      *  AR318270 - Make FEFSFA 'N' rather than blank (Child:AR321380)*
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
     FCLOAN     UP   E           K DISK    INCLUDE(CLOANCLF)

     FLEFEEDL1  US   E           K DISK

      ***Account*Postings*Next*Available*Number*file*******************                    AR1022006
     F***GLAPNAPD  UF A E           K DISK                                                 AR1022006

      ***Account*Shadow*Postings***************************************                    AR1022006
     F***RSACMTLX  IF   E           K DISK    PREFIX(SP)                                   AR1022006

      *****************************************************************
     D/EJECT
      *****************************************************************
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

     D*KGLNARI**       S                   INZ LIKE(GLNARI)                                AR1022006

     D*KSPXRFI**       S                   INZ LIKE(SPXRFI)                                AR1022006
     D*KSPXRFN**       S                   INZ LIKE(SPXRFN)                                AR1022006

     D DSLoop          S              9  0 INZ

     I/EJECT

     ICLOANCLF      01

     ILEFEEDF       02

      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Main Processing Control
      ** Process Request

     C   01              EXSR      SRCLOANCL
     C   02              EXSR      SRLEFEED

      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRCLOANCL -  Process Loan Details                            *
      *****************************************************************
     C     SRCLOANCL     BEGSR

      ** Initialise Miscellaneous Values

     C                   EVAL      FAMU = *BLANKS
     C                   EVAL      FPNR = *BLANKS

      ** Initialise Reporting Values

     C                   EVAL      RIDT = 0
     C                   EVAL      RIDC = 0

     C                   EVAL      RCAT = 0
     C                   EVAL      RCAC = 0

     C                   EVAL      RCSD = 0
     C                   EVAL      RCDY = 0
     C                   EVAL      RICC = 0

      ** Initialise Basel II Values

     C                   EVAL      BIDT = 0
     C                   EVAL      BIDC = 0

     C                   EVAL      BCAT = 0
     C                   EVAL      BCAC = 0

     C                   EVAL      BCSD = 0
     C                   EVAL      BCDY = 0
     C                   EVAL      BICC = 0

      ** Set Extension Reference

     C                   IF        XRFI = *BLANKS
     C**********         EVAL      XRFN = 0                                                AR1022006
     C**********         EVAL      KGLNARI = 'CLI'                                         AR1022006
     C**********         EXSR      SReXRF                                                  AR1022006
     C                   ENDIF

      ** Update Loan Details

     C                   UPDATE(E) CLOANCLF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRLEFEED - Process Fee Details                                *
      *****************************************************************
     C     SRLEFEED      BEGSR

      ** Initialisae Miscellaneous Values

     C                   EVAL      FEAUT2 = FEAUTO
     C                   EVAL      FEPLNR = *BLANKS

      ** Initialise Reporting Values

     C                   EVAL      FERIDT = 0
     C                   EVAL      FERIDC = 0

     C                   EVAL      FERCAT = 0
     C                   EVAL      FERCAC = 0

     C                   EVAL      FERCSD = 0
     C                   EVAL      FERCDY = 0
     C                   EVAL      FERICC = 0

      ** Initialise Basel II Values

     C                   EVAL      FEBIDT = 0
     C                   EVAL      FEBIDC = 0

     C                   EVAL      FEBCAT = 0
     C                   EVAL      FEBCAC = 0

     C                   EVAL      FEBCSD = 0
     C                   EVAL      FEBCDY = 0
     C                   EVAL      FEBICC = 0

      ** Initialise Suspended Fee Details

     C**********         EVAL      FEFSFA = *BLANKS                                         AR318270
     C                   EVAL      FEFSFA = 'N'                                             AR318270
     C                   EVAL      FESFA  = 0
     C                   EVAL      FESFAM = 0

     C                   EVAL      FESFP = 0
     C                   EVAL      FESFPM = 0

     C                   EVAL      FEFPPA = *BLANK
     C                   EVAL      FEPSIN = *BLANK
     C                   EVAL      FEPSLM = 0
     C                   EVAL      FEFEMC = *BLANK

      ** Set Extension Reference

     C                   IF        FEXRFI = *BLANKS
     C**********         EVAL      FEXRFN = 0                                              AR1022006
     C**********         EVAL      KGLNARI = 'FEE'                                         AR1022006
     C**********         EXSR      SReXRF                                                  AR1022006
     C                   ENDIF

      ** Update Fee Details

     C                   UPDATE(E) LEFEEDF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ***SREXRF*-*Evaluate*Extension*Reference*Index/Number************                    AR1022006
      *****************************************************************
     C*****SREXRF        BEGSR                                                             AR1022006

      ***This*routine*checks*whether*the*next*available*number*********                    AR1022006
      ***is*truly*available.**It*also*resuses*earlier******************                    AR1022006
      ***sequence*numbers*if*they*are*available************************                    AR1022006
      ***once*the*maximum*has*been*exceeded****************************                    AR1022006

      ***Retrieve*Next*Available*Key***********************************                    AR1022006

     C*****KAPNAPD       CHAIN(E)  GLAPNAPD                                                AR1022006

     C**********         IF        %ERROR                                                  AR1022006
     C**********         EVAL      DBFILE = 'GLAPNAPD'                                     AR1022006
     C**********         EVAL      DBKEY = KGLNARI                                         AR1022006
     C**********         EVAL      DBASE = 210                                             AR1022006
     C**********         DUMP                                                              AR1022006
     C**********         EVAL      *INU7 = *ON                                             AR1022006
     C**********         EVAL      *INU8 = *ON                                             AR1022006
     C**********         EVAL      *INLR = *ON                                             AR1022006
     C**********         RETURN                                                            AR1022006
     C**********         ENDIF                                                             AR1022006

     C**********         IF        NOT %FOUND(GLAPNAPD)                                    AR1022006
     C**********         EVAL      KSPXRFN = 1                                             AR1022006

     C**********         ELSE                                                              AR1022006
     C**********         EVAL      KSPXRFN = GLNARN                                        AR1022006
     C**********         ENDIF                                                             AR1022006

      ***Check*Key*Not*Already*Allocated*******************************                    AR1022006

     C**********         EVAL      KSPXRFI = KGLNARI                                       AR1022006
     C*****KACMTLX       CHAIN(E)  RSACMTLX                                                AR1022006

     C**********         EVAL      DSLoop = 0                                              AR1022006

     C**********         DOW       %FOUND(RSACMTLX)                                        AR1022006
     C**********         IF        KSPXRFN = 9999999999                                    AR1022006
     C**********         IF        DSLoop = 0                                              AR1022006
     C**********         EVAL      DSLoop = 1                                              AR1022006
     C**********         EVAL      KSPXRFN = 0                                             AR1022006

     C**********         ELSE                                                              AR1022006
     C**********         EVAL      DBFILE = 'RSACMTLX'                                     AR1022006
     C**********         EVAL      DBKEY = 'NO AVAIL KEY'                                  AR1022006
     C**********         EVAL      DBASE = 215                                             AR1022006
     C**********         DUMP                                                              AR1022006
     C**********         EVAL      *INU7 = *ON                                             AR1022006
     C**********         EVAL      *INU8 = *ON                                             AR1022006
     C**********         EVAL      *INLR = *ON                                             AR1022006
     C**********         RETURN                                                            AR1022006
     C**********         ENDIF                                                             AR1022006
     C**********         ENDIF                                                             AR1022006

     C**********         EVAL      KSPXRFN += 1                                            AR1022006
     C*****KACMTLX       CHAIN(E)  RSACMTLX                                                AR1022006
     C**********         ENDDO                                                             AR1022006

      ***Set*Extension*Reference*(Loan/Fee)****************************                    AR1022006

     C**********         IF        KGLNARI = 'CLI'                                         AR1022006
     C**********         EVAL      XRFI = KSPXRFI                                          AR1022006
     C**********         EVAL      XRFN = KSPXRFN                                          AR1022006

     C**********         ELSE                                                              AR1022006
     C**********         EVAL      FEXRFI = KSPXRFI                                        AR1022006
     C**********         EVAL      FEXRFN = KSPXRFN                                        AR1022006
     C**********         ENDIF                                                             AR1022006

      ***Update*GLAPNAPD*with*the*Next*Sequence*Number*****************                    AR1022006

     C**********         EVAL      GLNARI = KGLNARI                                        AR1022006
     C**********         EVAL      GLNARN = KSPXRFN + 1                                    AR1022006

     C**********         IF        NOT %FOUND(GLAPNAPD)                                    AR1022006
     C**********         WRITE(E)  GLAPNAPF                                                AR1022006

     C**********         ELSE                                                              AR1022006
     C**********         UPDATE(E) GLAPNAPF                                                AR1022006
     C**********         ENDIF                                                             AR1022006

     C**********         ENDSR                                                             AR1022006
      *****************************************************************
     C/SPACE
      *****************************************************************
     C     @DEFN         BEGSR

      ** @DEFN: Definition Rountine

      ** Key List...

     C*****KAPNAPD       KLIST                                                             AR1022006
     C**********         KFLD                    KGLNARI                                   AR1022006

     C*****KACMTLX       KLIST                                                             AR1022006
     C**********         KFLD                    KSPXRFI                                   AR1022006
     C**********         KFLD                    KSPXRFN                                   AR1022006

     C                   ENDSR
      *****************************************************************
