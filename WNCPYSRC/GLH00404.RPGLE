      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001425)                              *
      *                                                               *
      *  GLH00404 - Midas GL Retrieve Postings by Network Account     *
      *                                                               *
      *  Last Amend No. MD059143        Date 28Oct21                  *
      *  Prev Amend No. MD058767        Date 07Sep21                  *
      *                 MD058751        Date 03Sep21                  *
      *                 UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD059143 - Third line of fld86 is getting ommitted. Upgrade  *
      *             fix MMFIX3 from BF Midas 1106.                    *
      *  MD058767 - MT940s are producing many extra spaces in tag 86. *
      *             Upgraded CAR UUC061 fix MD030976.                 *
      *  MD058751 - Missing tag :86: on MT940s as not extracted by    *
      *             CAR UUC103. Alphanumeric batch numbers not        *
      *             checked correctly.                                *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
     C                   MOVEL     *Blanks       WKEXRF           35                        MD058767
     C                   Z-ADD     1             TOTL              1 0          UUC103
     C                   IF        @DTA = '#'                                   UUC103
     C                             AND UUC103 ='Y'                              UUC103
     C                   MOVEL     BTNB          NUM1              4 0          UUC103
     C                   MOVEL     BINB          NUM2              4 0          UUC103
     C                   MOVEL     NUM1          ALP1              3            UUC103
     C                   MOVEL     NUM2          ALP2              3            UUC103
                                                                                UUC103
     C                   IF        BTNB = ALP1                                  UUC103
     C                             AND BINN = ALP2                              UUC103
     C                             OR BINN = ALP2                                           MD058751
     C     KBTBI         SETLL     GLJENAP0                                     UUC103
     C     KBTBI         READE     GLJENAP0                               89    UUC103
                                                                                UUC103
     C                   DOW       *IN89 = '0'                                  UUC103
      *                                                                         UUC103
      *  Old narrative from SWITI                                               UUC103
      *                                                                         UUC103
     C                   IF        UUC103 <> 'Y'                                UUC103
      *                                                                         UUC103
     C                   IF        ZAEXTP = '00'                                UUC103
     C                   EXSR      ACTION                                       UUC103
     C                   ELSE                                                   UUC103
     C                   IF        ZAEXTP <> '99'                               UUC103
     C                   EXSR      ACTION                                       UUC103
     C                   ENDIF                                                  UUC103
     C                   ENDIF                                                  UUC103
                                                                                UUC103
      ** When UUC103 is on, the extended narratives should be concatenated      UUC103
      ** into the 6 available SWIFT lines                                       UUC103
      *                                                                         UUC103
     C                   ELSE                                                   UUC103
      *                                                                         UUC103
     C                   IF        ZAEXTP <> '99'                               UUC103
      *                                                                         UUC103
     C                   IF        %Subst(ZAEXRF:1:1) = '-' OR                  UUC103
     C                             %Subst(ZAEXRF:1:1) = ':'                     UUC103
     C                   MOVEL     ' '           ZAEXRF                         UUC103
     C                   ENDIF                                                  UUC103
      *                                                                         UUC103
     c                   IF        %Subst(WKEXRF:35:1) = ' '                                MD058767
     C                   EVAL      GLExtNarr = %Trim(GLExtNarr) + ' ' + ZAEXRF  UUC103
     c                   ELSE                                                               MD058767
     c                   EVAL      GLExtNarr = %Trim(GLExtNarr) +  ZAEXRF                   MD058767
     C                   ENDIF                                                              MD058767
      *                                                                                     MD058767
      ** Make sure first char is not blank                                                  MD058767
      *                                                                                     MD058767
     c                   EVAL      GLExtNarr = %Trim(GLExtNarr)                             MD058767
      *                                                                                     MD058767
     c                   MOVEL     ZAEXRF        WKEXRF                                     MD058767
      *                                                                                     MD058767
     C                   ENDIF                                                  UUC103
      *                                                                         UUC103
     C                   ENDIF                                                  UUC103
                                                                                UUC103
     C     KBTBI         READE     GLJENAP0                               89    UUC103
     C                   END                                                    UUC103
      *                                                                         UUC103
     C                   IF        UUC103 = 'Y'                                 UUC103
     C                   EVAL      TOTL = %Len(%Trim(GLExtNarr)) / 65           UUC103
      *                                                                         UUC103
     C                   IF        (TOTL * 65) < %Len(%Trim(GLExtNarr))         UUC103
     C                   ADD       1             TOTL                           UUC103
     C                   ENDIF                                                  UUC103
      *                                                                         UUC103
     C                   ENDIF                                                  UUC103
      *                                                                         UUC103
     C                   END                                                    UUC103
     C                   ELSE                                                   UUC103
     C                   IF        UUC103 = 'Y'                                 UUC103
     C                   MOVE      BRCA          BKBRCA            3            UUC103
     C                   MOVE      RECI          FTRECI                         UUC103
     C                   MOVE      CNUM          FTCNUM                         UUC103
     C                   MOVE      CCY           FTCCY                          UUC103
     C                   MOVE      ACOD          FTACOD                         UUC103
     C                   MOVE      ACSQ          FTACSQ                         UUC103
     C                   MOVE      IPDN          FTIPDN                         UUC103
     C                   MOVE      ACNO          FTACNO                         UUC103
     C                   MOVE      PSTD          FTPSTD                         UUC103
     C                   MOVE      VALD          FTVALD                         UUC103
     C                   MOVE      TRAT          FTTRAT                         UUC103
     C                   MOVE      PNAR          FTPNAR                         UUC103
     C                   MOVE      PSTA          FTPSTA                         UUC103
     C                   MOVE      DRCR          FTDRCR                         UUC103
     C                   MOVE      ASOC          FTASOC                         UUC103
     C                   MOVE      CHQN          FTCHQN                         UUC103
     C                   MOVE      SPOS          FTSPOS                         UUC103
     C                   MOVE      BRCA          FTBRCA                         UUC103
     C                   MOVE      RIND          FTRIND                         UUC103
     C                   MOVE      REJC          FTREJC                         UUC103
     C                   MOVE      DPMT          FTDPMT                         UUC103
     C                   MOVE      RRNM          FTRRNM                         UUC103
     C                   MOVE      ZZ009         FTZZ009                        UUC103
     C                   MOVE      ATYP          FTATYP                         UUC103
     C                   MOVE      ZZ002         FTZZ002                        UUC103
     C                   MOVE      EXIN          FTEXIN                         UUC103
     C                   MOVE      PRIN          FTPRIN                         UUC103
     C                   MOVE      GETP          FTGETP                         UUC103
     C                   MOVE      ACUM          FTACUM                         UUC103
     C                   MOVE      PRFC          FTPRFC                         UUC103
     C                   MOVE      PTIM          FTPTIM                         UUC103
     C                   MOVE      VOIN          FTVOIN                         UUC103
     C                   MOVE      MGTT          FTMGTT                         UUC103
     C                   MOVE      ACSC          FTACSC                         UUC103
     C                   MOVE      LTAI          FTLTAI                         UUC103
     C                   MOVE      ZZ007         FTZZ007                        UUC103
     C                   MOVE      RINO          FTRINO                         UUC103
     C                   MOVE      SWCR          FTSWCR                         UUC103
     C                   MOVE      DLREF         FTDLREF                        UUC103
     C                   MOVE      FACO          FTFACO                         UUC103
     C                   MOVE      DBCNUM        FTDBCNUM                       UUC103
     C                   MOVE      PREF          FTPREF                         UUC103
     C                   MOVE      OTRF          FTOTRF                         UUC103
     C                   MOVE      OTST          FTOTST                         UUC103
     C                   MOVE      OTTP          FTOTTP                         UUC103
     C                   MOVE      SDCB          FTSDCB                         UUC103
     C                   MOVE      SDLB          FTSDLB                         UUC103
     C                   MOVE      BOKC          FTBOKC                         UUC103
     C                   MOVE      NITMS         FTNITMS                        UUC103
     C                   MOVE      REBI          FTREBI                         UUC103
     C                   MOVE      CHGA          FTCHGA                         UUC103
     C                   MOVE      ZZ019         FTZZ019                        UUC103
     C                   MOVE      TLIN          FTTLIN                         UUC103
     C                   MOVE      TRCCY         FTTRCCY                        UUC103
     C                   MOVE      STYP          FTSTYP                         UUC103
     C                   MOVE      CQRI          FTCQRI                         UUC103
     C                   MOVE      PBTT          FTPBTT                         UUC103
     C                   MOVE      ORBR          FTORBR                         UUC103
     C                   MOVE      ORAMT         FTORAMT                        UUC103
     C                   MOVE      XRFI          FTXRFI                         UUC103
     C                   MOVE      XRFN          FTXRFN                         UUC103
     C                   CALL      CXT01A                                       UUC103
     C                   PARM                    POSTD                          UUC103
     C                   PARM                    FTREF                          UUC103
     C                   MOVE      BKBRCA        BRCA              3            UUC103
      *                                                                                     MD058767
     c                   IF        getp = 'G'                                               MD058767
     c                   MOVE      *blanks       wkftref                                    MD058767
     c                   EVAL      ftrefxx(1) = FTREF2                                      MD058767
     c                   EVAL      ftrefxx(2) = FTREF3                                      MD058767
     c**********         EVAL      ftrefxx(3) = FTREF5                             MD058767 MD059143
     c**********         EVAL      ftrefxx(4) = FTREF6                             MD058767 MD059143
     C                   EVAL      ftrefxx(3) = FTREF4                                      MD059143
     C                   EVAL      ftrefxx(4) = FTREF5                                      MD059143
     c                   Z-ADD     1             @xx               1 0                      MD058767
     c                   Z-ADD     0             @yy               1 0                      MD058767
      *                                                                                     MD058767
     c                   DOW       @xx < 5                                                  MD058767
     c                   IF        ftrefxx(@xx) = *blanks                                   MD058767
     c                   LEAVE                                                              MD058767
     c                   ENDIF                                                              MD058767
      *                                                                                     MD058767
     c                   IF        %subst(WKEXRF:34:2) = '  '                               MD058767
     c                             and @xx > 1                                              MD058767
      *                                                                                     MD058767
     c                   IF        wkftre1 <> *blanks                                       MD058767
     c                   ADD       1             @yy                                        MD058767
     c                   EVAL      MGADXX(@yy) = wkftre1                                    MD058767
     c                   ENDIF                                                              MD058767
     c                   IF        wkftre2 <> *blanks                                       MD058767
     c                   ADD       1             @yy                                        MD058767
     c                   EVAL      MGADXX(@yy) = wkftre2                                    MD058767
     c                   ENDIF                                                              MD058767
     c                   IF        wkftre3 <> *blanks                                       MD058767
     c                   ADD       1             @yy                                        MD058767
     c                   EVAL      MGADXX(@yy) = wkftre3                                    MD058767
     c                   ENDIF                                                              MD058767
                                                                                            MD058767
     c                   MOVE      *blanks       wkftref                                    MD058767
     C                   EVAL      wkftref = ftrefxx(@xx)                                   MD058767
                                                                                            MD058767
     c                   ELSE                                                               MD058767
     c                   EVAL      wkftref = %Trim(wkftref) +  ftrefxx(@xx)                 MD058767
     C                   ENDIF                                                              MD058767
      *                                                                                     MD058767
      ** Make sure first char is not blank                                                  MD058767
      *                                                                                     MD058767
     c                   EVAL      wkftref = %Trim(wkftref)                                 MD058767
      *                                                                                     MD058767
     c                   MOVEL     ftrefxx(@xx)  WKEXRF                                     MD058767
     c                   ADD       1             @xx                                        MD058767
     c                   ENDDO                                                              MD058767
      *                                                                                     MD058767
     c                   IF        wkftre1 <> *blanks                                       MD058767
     c                   ADD       1             @yy                                        MD058767
     c                   EVAL      MGADXX(@yy) = wkftre1                                    MD058767
     c                   ENDIF                                                              MD058767
     c                   IF        wkftre2 <> *blanks                                       MD058767
     c                   ADD       1             @yy                                        MD058767
     c                   EVAL      MGADXX(@yy) = wkftre2                                    MD058767
     c                   ENDIF                                                              MD058767
     c                   IF        wkftre3 <> *blanks                                       MD058767
     c                   ADD       1             @yy                                        MD058767
     c                   EVAL      MGADXX(@yy) = wkftre3                                    MD058767
     c                   ENDIF                                                              MD058767
      *                                                                                     MD058767
      ** Skip following codes                                                               MD058767
      *                                                                                     MD058767
     c                   ELSE                                                               MD058767
     C                   IF        FTREF2 <> ' '                                UUC103
     C                   MOVEL     FTREF2        ZAEXRF                         UUC103
     C                   EXSR      ACTION                                       UUC103
      *                                                                         UUC103
     C                   IF        FTREF3 <> ' '                                UUC103
     C                   MOVEL     FTREF3        ZAEXRF                         UUC103
     C                   EXSR      ACTION                                       UUC103
     C                   IF        FTREF4 <> ' '                                UUC103
     C                   MOVEL     FTREF4        ZAEXRF                         UUC103
     C                   EXSR      ACTION                                       UUC103
     C                   IF        FTREF5 <> ' '                                UUC103
     C                   MOVEL     FTREF5        ZAEXRF                         UUC103
     C                   EXSR      ACTION                                       UUC103
     C                   IF        FTREF6 <> ' '                                UUC103
     C                   MOVEL     FTREF6        ZAEXRF                         UUC103
     C                   EXSR      ACTION                                       UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
      *                                                                                     MD058767
     c                   ENDIF                                                              MD058767
      *                                                                                     MD058767
     C                   END                                                    UUC103
     C                   END                                                    UUC103

