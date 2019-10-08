     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Country Defaulting')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCRSDDFT - CRS Country Defaulting                           *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD052566           Date 24Jan19               *
      *  Prev Amend No. MD052431           Date 18Dec18               *
      *                 MD051393           Date 29Jun18               *
      *                 MD050493           Date 05May18               *
      *                 MD041522           Date 21Sep16               *
      *                 MD040627           Date 18Aug16               *
      *                 CGL177             Date 11Jan16               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052566 - Indicia "CRS Agreement" was not retrieved from    *
      *             the country of tax code table                     *
      *  MD052431 - CGL157 CRS - Maintain Customer got error 45049010 *
      *             (The TIN for DE is not set when Local TIN         *
      *             Mandatory is Y) even if Local TIN is input        *
      *  MD051393 - Authority Holder indicia                          *
      *  MD050493 - Phone Number and mailing Country values becomes   *
      *             blank after Confirm Authorise                     *
      *  MD041522 - Additional Customers Details MQ and Non-Account   *
      *             Holder MQ Repair Queue                            *
      *  MD040627 - Changing CRS Type of the Customer/NAH will make   *
      *             it appear again in CRS Ind Search tool            *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  CGL157 - CRS Reporting                                       *
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
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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

     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CGL177
                                                                                              CGL177
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CGL177
     D                                     PREFIX(DS_)                                        CGL177

      ** External DS for Country of Tax Codes
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)

      ** External DS for Custoter Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Long DS for access programs                                                          CGL177
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL177

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** CRS Country details 1
     D TrnDets       E DS                  EXTNAME(SDCUADPD)

      ** Valid CRS Country Details layout                                                   MD041522
     D ValidCRSCtry  E DS                  Extname(SDVCRSDPD)                               MD041522
                                                                                            MD041522
     D ArAuthCust    E DS                  EXTNAME(SDCUAHDPD)

     D*PCrsdF***       S            217A   DIM(30)                                            CGL177
     D*PCrsdS***       S            350A   DIM(30)                                            CGL177
     D PCrsdF          S            219A   DIM(30)                                            CGL177
     D PCrsdS          S            223A   DIM(30)                                            CGL177
     D PCtry           S              2A   DIM(30)
     D PCountry        S              2A   DIM(30)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Prtcd           S              7A
     D Poptn           S              7A
     D WWCTRY          S              2A
     D DFCRSA          S              1A
     D WCNCD           S              2A
     D WCOLC           S              2A
     D @PCTRT          S              2A
     D @PCTRR          S              2A
     D PKey2           S             10A
     D PKySt           S              7A
     D DDCTRY          S              2A
     D PReturn         S              7A
     D PColc           S              2A
     D PBRCH           S              3                                                       CGL177

     D PCRSDT          DS
     D  DDCTRR                 1      2
     D  DDREPT                 3      3
     D  DDREPU                 4     13
     D  DDREPD                14     19
     D  DDREPM                20     25
     D  DDREP1                26     89
     D  DDREP2                90    153
     D  DDEVD1               154    155
     D  DDEVS1               156    158
     D  DDEVD2               159    160
     D  DDEVS2               161    163
     D  DDEVD3               164    165
     D  DDEVS3               166    168
     D  DDEVD4               169    170
     D  DDEVS4               171    173
     D  DDEVD5               174    175
     D  DDEVS5               176    178
     D  DDTINN               179    203
     D  DDEFFD               204    209
     D  DDEXPD               210    215
     D  DDCODO               216    216
     D  DDJACM               217    217
     D  DDMAIL               218    218
     D  DDPHON               219    219
     D  DDRPAY               220    220
     D  DDCRSA               221    221
     D  DDTINS               222    222                                                       CGL177
     D  DDAUHO               223    223

     D PCRSDU          DS
     D  DFCTRY                 1      2
     D  DFFIL1                 3      8
     D  DFREPT                 9      9
     D**DFFIL2**              10    212                                                       CGL157
     D  DFFIL2                10    181                                                       CGL157
     D  DFTINO               182    206                                                       CGL157
     D  DFFIL3               207    212                                                       CGL157
     D  DFCODO               213    213
     D  DFJACM               214    214
     D  DFMAIL               215    215
     D  DFPHON               216    216
     D  DFRPAY               217    217
     D  DFTINS               218    218                                                       CGL177
     D  DFAUHO               219    219                                                       CGL177

     D PCRSDQ          DS
     D  D1FIL1                 1      3
     D  D1REPT                 3      3
     D  D1FIL2                 4    215
     D  D1CODO               216    216
     D  D1JACM               217    217
     D  D1MAIL               218    218
     D  D1PHON               219    219
     D  D1RPAY               220    220
     D  D1TINS               221    221                                                       CGL177

     D PCRSDR          DS
     D  D2FIL1                 1      8
     D  D2REPT                 9      9
     D  D2FIL2                10    212
     D  D2CODO               213    213
     D  D2JACM               214    214
     D  D2MAIL               215    215
     D  D2PHON               216    216
     D  D2RPAY               217    217
     D  D2TINS               218    218                                                       CGL177
     D  D2AUHO               219    219                                                       CGL177

     D CUAHArrDS       DS
     D  CUAHArr                      26A   DIM(50)

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

     D I               S              3  0
     D PMode           S              1
     D X               S              2S 0
     D Y               S              2S 0
     D WReset          S              1
     D WDATEA          S              6                                                     MD041522
     D ZDAYNO          S              5  0                                                  MD041522
     D ErrorFlag       S              1                                                     MD041522
     D WChar3          S              3A                                                    MD041522
     D DDCUST          S              6A

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

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   MOVEL     *Blanks       PCtry
     C                   MOVEA     *Blanks       PCrsdF                                     MD041522
     C                   EVAL      PKey2 = DDCUST

     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey2
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PColc = *Blanks
     C                   EVAL      WCOLC = BBCOLC
     C                   ELSE
     C                   EVAL      WCOLC = PColc
     C                   ENDIF

      ** Default countries

     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   EVAL      PCRSDU = PCrsdF(X)                                         CGL177
     C                   IF        DDCTRR <> *Blanks
     C                   EVAL      DDCODO = ' '
     C                   EVAL      DDJACM = ' '
     C                   EVAL      DDMAIL = ' '
     C                   EVAL      DDPHON = ' '
     C                   EVAL      DDRPAY = ' '
     C                   EVAL      DDAUHO = ' '
     C                   EVAL      DFAUHO = ' '
     C                   EVAL      DFCODO = ' '
     C                   EVAL      DFJACM = ' '
     C                   EVAL      DFMAIL = ' '
     C                   EVAL      DFPHON = ' '
     C                   EVAL      DFRPAY = ' '
     C                   EVAL      DFTINS = ' '                                               CGL177
     C                   EVAL      CVCODO = ' '                                             MD050493
     C                   EVAL      CVJACM = ' '                                             MD050493
     C                   EVAL      CVMAIL = ' '                                             MD050493
     C                   EVAL      CVPHON = ' '                                             MD050493
     C                   EVAL      CVRPAY = ' '                                             MD050493
     C                   EVAL      CVTINS = ' '                                             MD050493
     C                   EVAL      CVCTRY = %SUBST(PCrsdT:1:2)                              MD041522
     C                   EVAL      CVREPT = %SUBST(PCrsdT:3:1)                              MD041522
     C                   EVAL      CVREPR = %SUBST(PCrsdT:26:128)                           MD041522
     C                   EVAL      WDATEA = %SUBST(PCrsdT:14:6)                             MD041522
     C                   IF        WDATEA <> *Blanks                                        MD041522
     C                   EXSR      SrConv                                                   MD041522
     C                   EVAL      CVREPD = ZDAYNO                                          MD041522
     C                   ELSE                                                               MD041522
     C                   EVAL      CVREPD = 0                                               MD041522
     C                   ENDIF                                                              MD041522
     C                   EVAL      CVREPM = %SUBST(PCrsdT:20:6)                             MD041522
     C                   EVAL      CVREPU = %SUBST(PCrsdT:4:10)                             MD041522
     C                   EVAL      CVEVE1 = %SUBST(PCrsdT:154:2)                            MD041522
     C                   EVAL      WCHAR3 = %SUBST(PCrsdT:156:3)                            MD041522
     C                   IF        WCHAR3 <> '   '                                          MD041522
     C                   MOVE      WCHAR3        CVEVS1                                     MD041522
     C                   ELSE                                                               MD041522
     C                   EVAL      CVEVS1 = 0                                               MD041522
     C                   ENDIF                                                              MD041522
     C                   EVAL      CVEVE2 = %SUBST(PCrsdT:158:2)                            MD041522
     C                   EVAL      WCHAR3 = %SUBST(PCrsdT:160:3)                            MD041522
     C                   IF        WCHAR3 <> '   '                                          MD041522
     C                   MOVE      WCHAR3        CVEVS2                                     MD041522
     C                   ELSE                                                               MD041522
     C                   EVAL      CVEVS2 = 0                                               MD041522
     C                   ENDIF                                                              MD041522
     C                   EVAL      CVEVE3 = %SUBST(PCrsdT:164:2)                            MD041522
     C                   EVAL      WCHAR3 = %SUBST(PCrsdT:166:3)                            MD041522
     C                   IF        WCHAR3 <> '   '                                          MD041522
     C                   MOVE      WCHAR3        CVEVS3                                     MD041522
     C                   ELSE                                                               MD041522
     C                   EVAL      CVEVS3 = 0                                               MD041522
     C                   ENDIF                                                              MD041522
     C                   EVAL      CVEVE4 = %SUBST(PCrsdT:169:2)                            MD041522
     C                   EVAL      WCHAR3 = %SUBST(PCrsdT:171:3)                            MD041522
     C                   IF        WCHAR3 <> '   '                                          MD041522
     C                   MOVE      WCHAR3        CVEVS4                                     MD041522
     C                   ELSE                                                               MD041522
     C                   EVAL      CVEVS4 = 0                                               MD041522
     C                   ENDIF                                                              MD041522
     C                   EVAL      CVEVE5 = %SUBST(PCrsdT:174:2)                            MD041522
     C                   EVAL      WCHAR3 = %SUBST(PCrsdT:176:3)                            MD041522
     C                   IF        WCHAR3 <> '   '                                          MD041522
     C                   MOVE      WCHAR3        CVEVS5                                     MD041522
     C                   ELSE                                                               MD041522
     C                   EVAL      CVEVS5 = 0                                               MD041522
     C                   ENDIF                                                              MD041522
     C                   EVAL      CVTINN = %SUBST(PCrsdT:179:25)                           MD041522
     C                   EVAL      WDATEA = %SUBST(PCrsdT:204:6)                            MD041522
     C                   IF        WDATEA <> *Blanks                                        MD041522
     C                   EXSR      SrConv                                                   MD041522
     C                   EVAL      CVEFFD = ZDAYNO                                          MD041522
     C                   ELSE                                                               MD041522
     C                   EVAL      CVEFFD = 0                                               MD041522
     C                   ENDIF                                                              MD041522
     C                   EVAL      WDATEA = %SUBST(PCrsdT:210:6)                            MD041522
     C                   IF        WDATEA <> *Blanks                                        MD041522
     C                   EXSR      SrConv                                                   MD041522
     C                   EVAL      CVEXPD = ZDAYNO                                          MD041522
     C                   ELSE                                                               MD041522
     C                   EVAL      CVEXPD = 0                                               MD041522
     C                   ENDIF                                                              MD041522

     C                   EXSR      SRVChk

     C                   EVAL      WCNCD = DDCTRR

      ** Get CRS agreement

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      WCNCD         @PCTRT                                       CGL177
     C**********         PARM      WCOLC         @PCTRR                                       CGL177
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM      WCNCD         @PCTRR                                       CGL177
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      @PCTRR = *Blanks
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      WCNCD         @PCTRT                                       CGL177
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM                    @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
     C                   ENDIF

     C                   IF        PRTCD = *BLANK
     C                   EVAL      DFCRSA = EWCRSA
     C                   ELSE
     C                   EVAL      DFCRSA = *Blanks
     C                   ENDIF
     C                   EVAL      DDCRSA = DFCRSA

     C                   EVAL      PCrsdS(X) = PCRSDT
     C**********         EVAL      PCrsdF(X) = PCRSDU                                CGL177 MD041522
     C                   MOVEL     ValidCRSCtry  PCrsdF(X)                                  MD041522
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO


      ** Load countries

     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   IF        DDCTRR <> *Blanks
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   EVAL      PCtry(X) = DDCTRR
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO

      ** Process country of domicile
     C                   EVAL      WWCTRY = WCOLC
     C                   IF        %LOOKUP(WWCTRY:PCtry:1:30) <> 0
     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   IF        DDCTRR = WWCTRY
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   EVAL      PCRSDU = PCrsdF(X)                                         CGL177
     C                   EVAL      DDCODO = 'Y'
     C                   EVAL      DFCODO = 'Y'
     C                   EVAL      CVCODO = 'Y'                                             MD050493
     C                   IF        DDTINN = *BLANKS                                         MD052431
     C                             AND DDTINO <> *BLANKS                                    MD052431
     C                   EVAL      DDTINN = DDTINO
     C                   ENDIF                                                              MD052431
     C                   EVAL      DFTINO = DDTINO
     C                   IF        DDREPT <> 'N'
     C                             AND DDREPT <> ' '
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   ENDIF
     C                   EVAL      WCNCD = WWCTRY

      ** Get CRS agreement

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      WCNCD         @PCTRT                                       CGL177
     C**********         PARM      WCOLC         @PCTRR                                       CGL177
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM      WCNCD         @PCTRR                                       CGL177
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      @PCTRR = *Blanks
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      WCNCD         @PCTRT                                       CGL177
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM                    @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
     C                   ENDIF

     C                   IF        PRTCD = *BLANK
     C                   EVAL      DFCRSA = EWCRSA
     C                   ELSE
     C                   EVAL      DFCRSA = *Blanks
     C                   ENDIF
     C                   EVAL      DDCRSA = DFCRSA

     C                   EVAL      PCrsdS(X) = PCRSDT
     C                   EVAL      PCrsdF(X) = PCRSDU                                         CGL177
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO
     C                   ELSE
     C                   EVAL      DDCTRR = WWCTRY
     C                   EVAL      DDCTRY = WWCTRY
     C                   EVAL      DDCODO = 'Y'
     C                   EVAL      DFCODO = 'Y'
     C                   EVAL      CVCODO = 'Y'                                             MD050493
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EVAL      DDJACM = ' '
     C                   EVAL      DDMAIL = ' '
     C                   EVAL      DDPHON = ' '
     C                   EVAL      DDRPAY = ' '
     C                   EVAL      DDAUHO = ' '
     C                   EVAL      DFAUHO = ' '
     C                   EVAL      DFJACM = ' '
     C                   EVAL      DFMAIL = ' '
     C                   EVAL      DFPHON = ' '
     C                   EVAL      DFRPAY = ' '
     C                   EVAL      DFTINS = ' '                                               CGL177
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF

      ** Load countries

     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   IF        DDCTRR <> *Blanks
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   EVAL      PCtry(X) = DDCTRR
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO

      ** Process Joint Account
     C                   EVAL      PCountry = *Blanks
     C                   CALL      'SD000557'
     C                   PARM                    PReturn
     C                   PARM                    DDCUST
     C                   PARM                    DDJACM
     C                   PARM                    PCountry

     C                   IF        DDJACM = 'Y'
     C                   EVAL      Y = 1
     C                   DOW       Y < 31
     C                   EVAL      WWCTRY = PCountry(Y)
     C                   IF        WWCTRY <> *Blanks
     C                   IF        %LOOKUP(WWCTRY:PCtry:1:30) <> 0
     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   IF        DDCTRR = WWCTRY
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   EVAL      PCRSDU = PCrsdF(X)                                         CGL177
     C                   EVAL      DDJACM = 'Y'
     C                   EVAL      DFJACM = 'Y'
     C                   EVAL      CVJACM = 'Y'                                             MD050493
     C                   IF        DDREPT <> 'N'
     C                             AND DDREPT <> ' '
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   ENDIF
     C                   EVAL      WCNCD = DDCTRR

      ** Get CRS agreement

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      WCNCD         @PCTRT                                       CGL177
     C**********         PARM      WCOLC         @PCTRR                                       CGL177
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM      WCNCD         @PCTRR                                       CGL177
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      @PCTRR = *Blanks
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      WCNCD         @PCTRT                                       CGL177
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM                    @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
     C                   ENDIF

     C                   IF        PRTCD = *BLANK
     C                   EVAL      DFCRSA = EWCRSA
     C                   ELSE
     C                   EVAL      DFCRSA = *Blanks
     C                   ENDIF
     C                   EVAL      DDCRSA = DFCRSA

     C                   EVAL      PCrsdS(X) = PCRSDT
     C                   EVAL      PCrsdF(X) = PCRSDU                                         CGL177
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO
     C                   ELSE
     C                   EVAL      DDCTRR = WWCTRY
     C                   EVAL      DDCTRY = WWCTRY
     C                   EVAL      DDJACM = 'Y'
     C                   EVAL      DFJACM = 'Y'
     C                   EVAL      CVJACM = 'Y'                                             MD050493
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EVAL      DDCODO = ' '
     C                   EVAL      DDMAIL = ' '
     C                   EVAL      DDPHON = ' '
     C                   EVAL      DDAUHO = ' '
     C                   EVAL      DFAUHO = ' '
     C                   EVAL      DDRPAY = ' '
     C                   EVAL      DFCODO = ' '
     C                   EVAL      DFMAIL = ' '
     C                   EVAL      DFPHON = ' '
     C                   EVAL      DFRPAY = ' '
     C                   EVAL      DFTINS = ' '                                               CGL177
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      Y = Y + 1
     C                   ENDDO
     C                   ENDIF

      ** Process Regular Payment Instruction
     C                   EVAL      PCountry = *Blanks
     C                   CALL      'SD000558'
     C                   PARM                    PReturn
     C                   PARM                    DDCUST
     C                   PARM                    DDRPAY
     C                   PARM                    PCountry

     C                   IF        DDRPAY = 'Y'
     C                   EVAL      Y = 1
     C                   DOW       Y < 31
     C                   EVAL      WWCTRY = PCountry(Y)
     C                   IF        WWCTRY <> *Blanks
     C                   IF        %LOOKUP(WWCTRY:PCtry:1:30) <> 0
     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   IF        DDCTRR = WWCTRY
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   EVAL      PCRSDU = PCrsdF(X)                                         CGL177
     C                   EVAL      DDRPAY = 'Y'
     C                   EVAL      DFRPAY = 'Y'
     C                   EVAL      CVRPAY = 'Y'                                             MD050493
     C                   IF        DDREPT <> 'N'
     C                             AND DDREPT <> ' '
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   ENDIF
     C                   EVAL      WCNCD = DDCTRR

      ** Get CRS agreement

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      WCNCD         @PCTRT                                       CGL177
     C**********         PARM      WCOLC         @PCTRR                                       CGL177
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM      WCNCD         @PCTRR                                       CGL177
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      @PCTRR = *Blanks
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      WCNCD         @PCTRT                                       CGL177
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM                    @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
     C                   ENDIF

     C                   IF        PRTCD = *BLANK
     C                   EVAL      DFCRSA = EWCRSA
     C                   ELSE
     C                   EVAL      DFCRSA = *Blanks
     C                   ENDIF
     C                   EVAL      DDCRSA = DFCRSA
     C                   EVAL      PCrsdS(X) = PCRSDT
     C                   EVAL      PCrsdF(X) = PCRSDU                                         CGL177
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO
     C                   ELSE
     C                   EVAL      DDCTRR = WWCTRY
     C                   EVAL      DDCTRY = WWCTRY
     C                   EVAL      DDRPAY = 'Y'
     C                   EVAL      DFRPAY = 'Y'
     C                   EVAL      CVRPAY = 'Y'                                             MD050493
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EVAL      DDCODO = ' '
     C                   EVAL      DDJACM = ' '
     C                   EVAL      DDMAIL = ' '
     C                   EVAL      DDPHON = ' '
     C                   EVAL      DDAUHO = ' '
     C                   EVAL      DFAUHO = ' '
     C                   EVAL      DFCODO = ' '
     C                   EVAL      DFJACM = ' '
     C                   EVAL      DFMAIL = ' '
     C                   EVAL      DFPHON = ' '
     C                   EVAL      DFTINS = ' '                                               CGL177
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      Y = Y + 1
     C                   ENDDO
     C                   ENDIF
                                                                                            MD051393
      ** Process Authority Holder                                                           MD051393
     C                   EVAL      PCountry = *Blanks                                       MD051393
     C                   EVAL      CUAHArrDS = ArAuthCust                                   MD051393
                                                                                            MD051393
     C                   CALL      'SD000564'                                               MD051393
     C                   PARM                    PReturn                                    MD051393
     C                   PARM                    DDCUST                                     MD051393
     C                   PARM                    CUAHArrDS                                  MD051393
     C                   PARM                    DDAUHO                                     MD051393
     C                   PARM                    PCountry                                   MD051393
                                                                                            MD051393
     C                   IF        DDAUHO = 'Y'                                             MD051393
     C                   EVAL      Y = 1                                                    MD051393
     C                   DOW       Y < 31                                                   MD051393
     C                   EVAL      WWCTRY = PCountry(Y)                                     MD051393
     C                   IF        WWCTRY <> *Blanks                                        MD051393
     C                   IF        %LOOKUP(WWCTRY:PCtry:1:30) <> 0                          MD051393
     C                   EVAL      X = 1                                                    MD051393
     C                   DOW       X < 31                                                   MD051393
     C                   EVAL      PCRSDT = PCrsdS(X)                                       MD051393
     C                   IF        DDCTRR = WWCTRY                                          MD051393
     C                   EVAL      PCRSDT = PCrsdS(X)                                       MD051393
     C                   EVAL      PCRSDU = PCrsdF(X)                                       MD051393
     C                   EVAL      DDAUHO = 'Y'                                             MD051393
     C                   EVAL      DFAUHO = 'Y'                                             MD051393
     C                   IF        DDREPT <> 'N'                                            MD051393
     C                             AND DDREPT <> ' '                                        MD051393
     C                   EVAL      DDREPT = 'Y'                                             MD051393
     C                   EVAL      DFREPT = 'Y'                                             MD051393
     C                   ENDIF                                                              MD051393
     C                   EVAL      WCNCD = DDCTRR                                           MD051393
                                                                                            MD051393
      ** Get CRS agreement                                                                  MD051393
                                                                                            MD051393
     C                   CALL      'AOCTTXR0'                                               MD051393
     C                   PARM      *BLANKS       PRTCD                                      MD051393
     C                   PARM      '*KEY   '     POPTN                                      MD051393
     C                   PARM      DS_A8LCCD     @PCTRT                                     MD051393
     C                   PARM      WCNCD         @PCTRR                                     MD051393
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      MD051393
                                                                                            MD051393
     C                   IF        PRTCD = '*NRF   '                                        MD051393
     C                   EVAL      @PCTRR = *Blanks                                         MD051393
     C                   CALL      'AOCTTXR0'                                               MD051393
     C                   PARM      *BLANKS       PRTCD                                      MD051393
     C                   PARM      '*KEY   '     POPTN                                      MD051393
     C                   PARM      DS_A8LCCD     @PCTRT                                     MD051393
     C                   PARM                    @PCTRR                                     MD051393
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      MD051393
     C                   ENDIF                                                              MD051393
                                                                                            MD051393
     C                   IF        PRTCD = *BLANK                                           MD051393
     C                   EVAL      DFCRSA = EWCRSA                                          MD051393
     C                   ELSE                                                               MD051393
     C                   EVAL      DFCRSA = *Blanks                                         MD051393
     C                   ENDIF                                                              MD051393
     C                   EVAL      DDCRSA = DFCRSA                                          MD051393
                                                                                            MD051393
     C                   EVAL      PCrsdS(X) = PCRSDT                                       MD051393
     C                   EVAL      PCrsdF(X) = PCRSDU                                       MD051393
     C                   ENDIF                                                              MD051393
     C                   EVAL      X = X + 1                                                MD051393
     C                   ENDDO                                                              MD051393
     C                   ELSE                                                               MD051393
     C                   EVAL      DDCTRR = WWCTRY                                          MD051393
     C                   EVAL      DDCTRY = WWCTRY                                          MD051393
     C                   EVAL      DDAUHO = 'Y'                                             MD051393
     C                   EVAL      DFAUHO = 'Y'                                             MD051393
     C                   EVAL      CVAUHO = 'Y'                                             MD051393
     C                   EVAL      DDREPT = 'Y'                                             MD051393
     C                   EVAL      DFREPT = 'Y'                                             MD051393
     C                   EVAL      CVREPT = 'Y'                                             MD051393
     C                   EVAL      DDCODO = ' '                                             MD051393
     C                   EVAL      DDMAIL = ' '                                             MD051393
     C                   EVAL      DDPHON = ' '                                             MD051393
     C                   EVAL      DDRPAY = ' '                                             MD051393
     C                   EVAL      DDJACM = ' '                                             MD051393
     C                   EVAL      DFJACM = ' '                                             MD051393
     C                   EVAL      DFCODO = ' '                                             MD051393
     C                   EVAL      DFMAIL = ' '                                             MD051393
     C                   EVAL      DFPHON = ' '                                             MD051393
     C                   EVAL      DFRPAY = ' '                                             MD051393
     C                   EVAL      DFTINS = ' '                                             MD051393
     C                   EXSR      SRVChk                                                   MD051393
     C                   EXSR      SRVDft                                                   MD051393
     C                   ENDIF                                                              MD051393
     C                   ENDIF                                                              MD051393
     C                   EVAL      Y = Y + 1                                                MD051393
     C                   ENDDO                                                              MD051393
     C                   ENDIF                                                              MD051393

      ** Load countries

     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   IF        DDCTRR <> *Blanks
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   EVAL      PCtry(X) = DDCTRR
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   EVAL      PCRSDT = *Blanks
     C                   EVAL      PCRSDU = *Blanks

     C                   IF        WCOLC <> *Blanks
     C                   IF        %LOOKUP(WCOLC:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = WCOLC
     C                   EVAL      DDCTRY = WCOLC
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   IF        DDTINN = *BLANKS                                         MD052431
     C                             AND DDTINO <> *BLANKS                                    MD052431
     C                   EVAL      DDTINN = DDTINO
     C                   ENDIF                                                              MD052431
     C                   EVAL      DFTINO = DDTINO
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

      ** Reset Countries array
     C                   MOVEL     *BLANKS       PCtry
     C                   EVAL      X = 1
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   IF        DDCTRR <> *Blanks
     C                   EVAL      PCtry(X) = DDCTRR
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   EVAL      DDMAIL = 'Y'
     C                   EVAL      DFMAIL = 'Y'
     C                   EVAL      CVMAIL = 'Y'                                             MD050493
     C                   EVAL      DDCODO = ' '
     C                   EVAL      DDJACM = ' '
     C                   EVAL      DDPHON = ' '
     C                   EVAL      DDRPAY = ' '
     C                   EVAL      DDAUHO = ' '
     C                   EVAL      DFAUHO = ' '
     C                   EVAL      DFCODO = ' '
     C                   EVAL      DFJACM = ' '
     C                   EVAL      DFPHON = ' '
     C                   EVAL      DFRPAY = ' '
     C                   EVAL      DFTINS = ' '                                               CGL177

     C                   IF        DDCTR1 <> *Blanks
     C                   IF        %LOOKUP(DDCTR1:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDCTR1
     C                   EVAL      DDCTRY = DDCTR1
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDCTR2 <> *Blanks
     C                   IF        %LOOKUP(DDCTR2:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDCTR2
     C                   EVAL      DDCTRY = DDCTR2
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDCTR3 <> *Blanks
     C                   IF        %LOOKUP(DDCTR3:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDCTR3
     C                   EVAL      DDCTRY = DDCTR3
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDCTR4 <> *Blanks
     C                   IF        %LOOKUP(DDCTR4:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDCTR4
     C                   EVAL      DDCTRY = DDCTR4
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDCTR5 <> *Blanks
     C                   IF        %LOOKUP(DDCTR5:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDCTR5
     C                   EVAL      DDCTRY = DDCTR5
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

      ** Reset Countries array
     C                   MOVEL     *BLANKS       PCtry
     C                   EVAL      X = 1
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   IF        DDCTRR <> *Blanks
     C                   EVAL      PCtry(X) = DDCTRR
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   EVAL      DDPHON = 'Y'
     C                   EVAL      DFPHON = 'Y'
     C                   EVAL      CVPHON = 'Y'                                             MD050493
     C                   EVAL      DDCODO = ' '
     C                   EVAL      DDJACM = ' '
     C                   EVAL      DDMAIL = ' '
     C                   EVAL      DDRPAY = ' '
     C                   EVAL      DDAUHO = ' '
     C                   EVAL      DFAUHO = ' '
     C                   EVAL      DFCODO = ' '
     C                   EVAL      DFJACM = ' '
     C                   EVAL      DFMAIL = ' '
     C                   EVAL      DFRPAY = ' '
     C                   EVAL      DFTINS = ' '                                               CGL177

     C                   IF        DDPHN1 <> *Blanks
     C                   IF        %LOOKUP(DDPHN1:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDPHN1
     C                   EVAL      DDCTRY = DDPHN1
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDPHN2 <> *Blanks
     C                   IF        %LOOKUP(DDPHN2:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDPHN2
     C                   EVAL      DDCTRY = DDPHN2
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDPHN3 <> *Blanks
     C                   IF        %LOOKUP(DDPHN3:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDPHN3
     C                   EVAL      DDCTRY = DDPHN3
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDPHN4 <> *Blanks
     C                   IF        %LOOKUP(DDPHN4:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDPHN4
     C                   EVAL      DDCTRY = DDPHN4
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDPHN5 <> *Blanks
     C                   IF        %LOOKUP(DDPHN5:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDPHN5
     C                   EVAL      DDCTRY = DDPHN5
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      ** SRVChk - Check country indicia
      *****************************************************************

     C     SRVChk        BEGSR

     C                   IF        DDCTRR = WCOLC
     C                   IF        DDTINN = *BLANKS                                         MD052431
     C                             AND DDTINO <> *BLANKS                                    MD052431
     C                   EVAL      DDTINN = DDTINO
     C                   ENDIF                                                              MD052431
     C                   EVAL      DFTINO = DDTINO
     C                   EVAL      DDCODO = 'Y'
     C                   EVAL      DFCODO = 'Y'
     C                   EVAL      CVCODO = 'Y'                                             MD050493
     C                   IF        DDTINO <> *Blanks                                          CGL177
     C                   EVAL      DDTINS = 'Y'                                               CGL177
     C                   EVAL      DFTINS = 'Y'                                               CGL177
     C                   EVAL      CVTINS = 'Y'                                             MD050493
     C                   ENDIF                                                                CGL177
     C                   IF        DDREPT <> 'N'
     C                             AND DDREPT <> ' '
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   ENDIF
     C                   ENDIF
     C                   IF        DDCTRR <> WCOLC                                          MD040627
     C                   IF        DDTINN <> *Blanks                                        MD040627
     C                   EVAL      DDTINS = 'Y'                                             MD040627
     C                   EVAL      DFTINS = 'Y'                                             MD040627
     C                   EVAL      CVTINS = 'Y'                                             MD050493
     C                   ENDIF                                                              MD040627
     C                   ENDIF                                                              MD040627

     C                   IF        (DDCTRR = DDCTR1
     C                             OR DDCTRR = DDCTR2
     C                             OR DDCTRR = DDCTR3
     C                             OR DDCTRR = DDCTR4
     C                             OR DDCTRR = DDCTR5)
     C                   EVAL      DDMAIL = 'Y'
     C                   EVAL      DFMAIL = 'Y'
     C                   EVAL      CVMAIL = 'Y'                                             MD050493
     C                   IF        DDREPT <> 'N'
     C                             AND DDREPT <> ' '
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   ENDIF
     C                   ENDIF

     C                   IF        (DDCTRR = DDPHN1
     C                             OR DDCTRR = DDPHN2
     C                             OR DDCTRR = DDPHN3
     C                             OR DDCTRR = DDPHN4
     C                             OR DDCTRR = DDPHN5)
     C                   EVAL      DDPHON = 'Y'
     C                   EVAL      DFPHON = 'Y'
     C                   EVAL      CVPHON = 'Y'                                             MD050493
     C                   IF        DDREPT <> 'N'
     C                             AND DDREPT <> ' '
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      CVREPT = 'Y'                                             MD050493
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      ** SRVDft - Default Countries
      *****************************************************************

     C     SRVDft        BEGSR

     C                   EVAL      WCNCD = DDCTRY

      ** Get CRS agreement

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      WCNCD         @PCTRT                                       CGL177
     C**********         PARM      WCOLC         @PCTRR                                       CGL177
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM      WCNCD         @PCTRR                                       CGL177
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      @PCTRR = *Blanks
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      WCNCD         @PCTRT                                       CGL177
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM                    @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
     C                   ENDIF

     C                   IF        PRTCD = *BLANK
     C                   EVAL      DFCRSA = EWCRSA
     C                   ELSE
     C                   EVAL      DFCRSA = *Blanks
     C                   ENDIF

     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   IF        PCrsdS(X) = *Blanks
     C                   EVAL      DDCRSA = DFCRSA
     C                   EVAL      PCrsdS(X) = PCRSDT
     C                   EVAL      PCrsdF(X) = *Blanks
     C                   EVAL      DFCTRY = DDCTRY
     C                   IF        %SUBST(PCrsdU:138:3) = *Blanks                           MD041522
     C                   EVAL      %SUBST(PCrsdU:138:3) = x'00000f'                         MD041522
     C                   ENDIF                                                              MD041522
     C                   IF        %SUBST(PCrsdU:207:3) = *Blanks                           MD041522
     C                   EVAL      %SUBST(PCrsdU:207:3) = x'00000f'                         MD041522
     C                   ENDIF                                                              MD041522
     C                   IF        %SUBST(PCrsdU:210:3) = *Blanks                           MD041522
     C                   EVAL      %SUBST(PCrsdU:210:3) = x'00000f'                         MD041522
     C                   ENDIF                                                              MD041522
     C                   EVAL      PCrsdF(X) = PCRSDU
     C                   EVAL      X = 31
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   EVAL      PCRSDT = *Blanks
     C                   EVAL      PCRSDU = *Blanks

     C                   ENDSR

      *****************************************************************                     MD041522
      /EJECT                                                                                MD041522
      *****************************************************************                     MD041522
      ** SRConv - Convert date                                        *                     MD041522
      *****************************************************************                     MD041522
     C     SRConv        BEGSR                                                              MD041522
                                                                                            MD041522
     C                   CALLB     'ZDATE1'                                                 MD041522
     C                   PARM                    WDATEA                                     MD041522
     C                   PARM                    ZDAYNO                                     MD041522
     C                   PARM                    BJDFIN                                     MD041522
     C                   PARM                    ErrorFlag                                  MD041522
                                                                                            MD041522
     C                   ENDSR                                                              MD041522
                                                                                            MD041522
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        PLIST

     C                   PARM                    PColc
     C                   PARM                    DDCUST
     C                   PARM                    TrnDets
     C                   PARM                    ArAuthCust
     C                   PARM                    PCrsdS
     C                   PARM                    PCrsdF


      ** ACCESS BANK DETAILS                                                                  CGL177
                                                                                              CGL177
     C                   CALL      'AOBANKR0'                                                 CGL177
     C                   PARM      '*DBERR '     PRTCD                                        CGL177
     C                   PARM      '*FIRST '     POPTN                                        CGL177
     C     SDBANK        PARM      SDBANK        DSFDY                                        CGL177
                                                                                              CGL177
      ** DATABASE ERROR                                                                       CGL177
                                                                                              CGL177
     C                   IF        PRTCD <> *Blanks                                           CGL177
     C                   MOVEL     'SDBANKPD'    DBFILE                                       CGL177
     C                   MOVEL     '001'         DBASE                                        CGL177
     C                   MOVEL     POPTN         DBKEY                                        CGL177
     C                   EXSR      *PSSR                                                      CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   CALL      'AOCUSTR0'                                                 CGL177
     C                   PARM      *BLANKS       Prtcd                                        CGL177
     C                   PARM      '*KEY   '     Poptn                                        CGL177
     C                   PARM      BJCUST        Pkey2                                        CGL177
     C                   PARM                    Pkyst                                        CGL177
     C     SDCUST        PARM      SDCUST        DSSDY                                        CGL177
                                                                                              CGL177
     C                   CALL      'AOBRCHR1'                                                 CGL177
     C                   PARM      *BLANKS       Prtcd                                        CGL177
     C                   PARM      '*KEY   '     Poptn                                        CGL177
     C                   PARM      BBBRCD        PBRCH                                        CGL177
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL177
                                                                                            MD052566
      ** Access Customer detail of branch to retrieve country of loation                    MD052566
      *                                                                                     MD052566
     C                   MOVEL     *BLANKS       ##CTRY            3                        MD052566
     C                   IF        PRTCD = *Blanks                                          MD052566
     C                   CALL      'AOCUSTR0'                                               MD052566
     C                   PARM      *BLANKS       PRTCD                                      MD052566
     C                   PARM      '*KEY   '     POPTN                                      MD052566
     C                   PARM      DS_A8BICN     Pkey2                                      MD052566
     C                   PARM      *BLANKS       Pkyst                                      MD052566
     C     SDCUST        PARM      SDCUST        DSSDY                                      MD052566
                                                                                            MD052566
     C                   IF        PRTCD = *BLANKS                                          MD052566
     C                   EVAL      ##CTRY = BBCOLC                                          MD052566
     C                   ENDIF                                                              MD052566
     C                   ENDIF                                                              MD052566

      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRERR - Exception Errors                                     *
      *****************************************************************
     C     SRERR         BEGSR

     C                   MOVEL     'SDCRSDDFT'   Dbpgm
     C                   MOVE      *On           *INU7
     C                   MOVE      *On           *INU8
     C                   MOVE      *On           *INLR

     C                   DUMP

      **  Terminate the program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2015
