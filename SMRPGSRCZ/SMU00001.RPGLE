     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration SDACUSPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00001 - German Feature migration for SDACUSPD             *
      *                                                               *
      *  Called By: SMUC00000                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25856           Date 04Sep09               *
      *                 BUG25441           Date 12Aug09               *
      *                 CER045             Date 20Jul09               *
      *                 B24746A            Date 16Jun09               *
      *                 B24416             Date 16Jun09               *
      *                 CSM011  *CREATE    Date 08May09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25856 - Customer details by country of tax                *
      *  BUG25441 - Migration issue on Additional Customer Details.   *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  B24746A - Further migration refinement.                      *
      *  B24416 - Additional changes for join type.                   *
      *  CSM011 - Midas SM Process CAR migration                      *
      *                                                               *
      *****************************************************************
     FSMUGF01PD IF   E             DISK
      * Template file for SDCUSTX0
     FSMUGF02PD IF   E           K DISK    PREFIX(X)
      * Template file for SDCUSTX2
     FSDACUSL0  UF A E           K DISK
      * Additional customer details file                                                      B24416
     FSDACTXL4  UF A E           K DISK                                                      B24746A
      * Country tax by customer                                                              B24746A
      *
      /EJECT
      /COPY ZSRSRC,ZDATE9Z1LE
      *
      /COPY ZSRSRC,ZDAT10Z1LE
      *
     D UorW            S              1
     D Recursive       S              1
     D IssuedDate      S              8                                                      B24746A
      *
     D                 DS                                                                    B24746A
     D IssuedDateN             1      8  0                                                   B24746A
     D IssuedDateA             1      8                                                      B24746A
      *                                                                                     BUG25441
     D WBRTHD          S              8                                                     BUG25441
      *                                                                                     BUG25441
     D                 DS                                                                   BUG25441
     D WBRTHDN                 1      8  0                                                  BUG25441
     D WBRTHDA                 1      8                                                     BUG25441
      *
     D  E5EXDTJ        DS
     D BBDay                   1      2
     D BBMonth                 3      4
     D BBYear                  5      8
      *
     D  E5EXDTJ2       DS
     D BBYear2                 1      4
     D BBMonth2                5      6
     D BBDay2                  7      8
      *
     D WFound          S              1                                                     BUG25856
      *                                                                                     BUG25856
     C     1             SETLL     SMUGF01D0
     C                   READ      SMUGF01D0
     C                   DOW       NOT %EOF
      *
      * Update fields from template files.
     C                   EXSR      UpdateFields
     C     CustomerNo    CHAIN     @ACUSL0
      * Check if add/update required.
     C                   IF        %FOUND
     C                   EVAL      UorW = 'U'
     C                   ENDIF
      *
      * Check SDCUSTX2 for record.
     C     CustomerNo    CHAIN     SMUGF02D0
     C                   IF        %FOUND
     C                   EVAL      E5CDCL = XBBCDCL
     C                   EVAL      E5TINO = XBBTINO                                         BUG25441
     C                   EVAL      E5ISCT = XBBCIDI                                         BUG25441
     C                   ELSE
     C                   EVAL      E5CDCL = *blanks
     C                   ENDIF
      *
     C                   IF        UorW = 'U'
     C                   UPDATE    @ACUSL0
     C                   ELSE
     C                   EVAL      E5CUST = BBCUST
     C                   WRITE     @ACUSL0
     C                   ENDIF
      *
     C                   EVAL      UorW = *blanks
     C                   READ      SMUGF01D0
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
     C     CustomerNo    KLIST
     C                   KFLD                    BBCUST
      *
     C                   ENDSR
      *
      *****************************************************************
      * UpdateFields - Move fields from template file.                *
      *****************************************************************
 
     C     UpdateFields  BEGSR
      *
     C                   EVAL      E5EXTH = BBCEXT
     C                   EVAL      E5EADT = BBTRAP
     C                   EVAL      E5EVDT = BBTRVD
     C                   EVAL      E5ETXT = BBTRMD
     C                   EVAL      E5MDNM = BBMNMC
     C                   EVAL      E5TITL = BBTTLC
     C                   EVAL      E5LNID = BBLANG
     C                   EVAL      E5CTYP = BBCOTP
     C                   EVAL      E5FXCU = BBFXKN
     C                   EVAL      E5DCID = BBIDNR
     C                   EVAL      E5DIPL = BBISPL
     C                   EVAL      E5S24C = BBS24C
     C                   EVAL      E5REM1 = BBREM1
     C                   EVAL      E5REM2 = BBREM2
     C                   EVAL      E5REM3 = BBREM3
     C                   EVAL      E5PIND = BBPAAS
     C                   EVAL      E5SECU = BBSECU
     C                   EVAL      E5CNA1 = BBSNMC                                          BUG25441
     C                   EVAL      E5CNA2 = BBTTLC                                          BUG25441
     C                   EVAL      E5CNA3 = BBADRS                                          BUG25441
     C                   MOVE      BBPLTZ        E5ZIPC                                     BUG25441
     C                   EVAL      E5CITY = BBTOWN                                          BUG25441
     C                   EVAL      E5BTHT = BBPLBR                                          BUG25441
     C                   EVAL      E5BTHC = BBCNBR                                          BUG25441
     C                   EVAL      WBRTHDN = BBDBRC                                         BUG25441
     C                   EVAL      %SUBST(WBRTHD:1:4) =                                     BUG25441
     C                             %SUBST(WBRTHDA:5:4)                                      BUG25441
     C                   EVAL      %SUBST(WBRTHD:5:2) =                                     BUG25441
     C                             %SUBST(WBRTHDA:3:2)                                      BUG25441
     C                   EVAL      %SUBST(WBRTHD:7:2) =                                     BUG25441
     C                             %SUBST(WBRTHDA:1:2)                                      BUG25441
     C                   EVAL      E5DBTH = WBRTHD                                          BUG25441
      *                                                                                     BUG25441
     C                   SELECT                                                               B24416
     C                   WHEN      BBCTAX = 'Z'                                               B24416
     C                   EVAL      E5JATP = 'I'                                               B24416
     C                   WHEN      BBCTAX = 'G'                                               B24416
     C                   EVAL      E5JATP = 'I'                                               B24416
     C                   WHEN      BBCTAX = 'E'                                               B24416
     C***********        IF        BBCEXT <> 0                                      B24746A BUG25441
     C                   EVAL      E5JATP = 'I'                                               B24416
     C***********        ELSE                                                       B24746A BUG25441
     C***********        EVAL      E5JATP = 'N'                                     B24746A BUG25441
     C***********        ENDIF                                                      B24746A BUG25441
     C                   OTHER                                                                B24416
     C                   EVAL      E5JATP = 'N'                                               B24416
     C                   ENDSL                                                                B24416
     C                   IF        BBJACC = 'Y'                                               B24416
     C                   EVAL      E5JATP = 'Y'                                               B24416
     C                   ENDIF                                                                B24416
      *
     C**********         IF        BBNVTY <> *blanks                                B24746A BUG25441
     C                   EVAL      E5IDTP = BBIDCA                                           B24746A
     C                   EVAL      E5ISCT = 'DE'                                             B24746A
     C                   EVAL      IssuedDateN = BBISDT                                      B24746A
     C                   EVAL      %SUBST(IssuedDate:1:4) =                                  B24746A
     C                             %SUBST(IssuedDateA:5:4)                                   B24746A
     C                   EVAL      %SUBST(IssuedDate:5:2) =                                  B24746A
     C                             %SUBST(IssuedDateA:3:2)                                   B24746A
     C                   EVAL      %SUBST(IssuedDate:7:2) =                                  B24746A
     C                             %SUBST(IssuedDateA:1:2)                                   B24746A
     C                   EVAL      E5ISDT = IssuedDate                                       B24746A
     C                   EVAL      E5ISCD = BBISAU                                          BUG25441
     C                   EXSR      UpdateSDACTX                                              B24746A
     C**********         ENDIF                                                      B24746A BUG25441
      *
     C                   MOVE      BBEXDT        E5EXDTJ
     C                   MOVE      BBDAY         BBDAY2
     C                   MOVE      BBMONTH       BBMONTH2
     C                   MOVE      BBYEAR        BBYEAR2
     C                   MOVE      E5EXDTJ2      ZZDTIN
      *
     C                   EXSR      ZDAT10
     C                   EVAL      E5EXDT = ZZMDNO
      *
     C     UpdateFieldsE ENDSR
      *
      *****************************************************************                      B24746A
      * UpdateSDACTX - Update file SDACTXPD                           *                      B24746A
      *****************************************************************                      B24746A
      *
     C     UpdateSDACTX  BEGSR                                                               B24746A
      *
     C                   EVAL      WFound = 'N'                                             BUG25856
                                                                                            BUG25856
     C     CustomerNo    CHAIN     SDACTXL4                                                 BUG25856
     C                   IF        (%FOUND)                                                 BUG25856
     C                   EVAL      WFound = 'Y'                                             BUG25856
     C                   ENDIF                                                              BUG25856
                                                                                            BUG25856
     C                   EVAL      AXCTTX = 'DE'                                             B24746A
     C                   EVAL      AXCERF = 'NV'                                             B24746A
     C                   EVAL      AXCEEX = BBTTMD                                           B24746A
     C                   EVAL      AXCADT = BBTTAP                                           B24746A
     C                   EVAL      AXCVDT = BBTTVD                                           B24746A
     C                   EVAL      AXCRTP = BBNVTY                                          BUG25441
     C                   EVAL      AXCSTS = 'A'                                             BUG25856
      *
     C*****CustomerNo    CHAIN     SDACTXL4                                         B24746A BUG25856
     C**********         IF        NOT(%FOUND)                                      B24746A BUG25856
     C                   IF        WFound = 'N'                                             BUG25856
     C                   EVAL      AXCUST = BBCUST                                           B24746A
     C                   WRITE     SDACTXD0                                                  B24746A
     C                   ELSE                                                                B24746A
     C                   UPDATE    SDACTXD0                                                  B24746A
     C                   ENDIF                                                               B24746A
      *
     C     UpdateSDACTXE ENDSR                                                               B24746A
      *
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      /COPY ZSRSRC,ZDAT10Z2LE
      *
      /COPY ZSRSRC,ZDATE9Z4
