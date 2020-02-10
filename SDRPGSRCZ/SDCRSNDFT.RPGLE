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
      *  Prev Amend No. MD050480           Date 04May18               *
      *                 MD041294           Date 19Sep16               *
      *                 MD041311           Date 19Sep16               *
      *                 MD040876           Date 13Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052566 - Indicia "CRS Agreement" was not retrieved from    *
      *             the country of tax code table                     *
      *  MD050480 - Deleted country cannot be defined as mailing /    *
      *             phone country                                     *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD041311 - CRS Type is populated even if there is no CRS Type*
      *             defined in MQ input                               *
      *  MD040876 - CRS MQ                                            *
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
                                                                                              CGL177
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CGL177

      ** External DS for Country of Tax Codes
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)

      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Non-account Holder Details Data Structure
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)

      ** New Non-A/C Holder in Screen Format - Primary Details
     D NewNaPrim     E DS                  Extname(SDNAHLPD)

      ** Valid Non-A/C Holder Details layout                                                MD041311
     D ValidCRSCtry  E DS                  Extname(SDVCRSNPD)                               MD041311

     D PCrsdF          S            222A   DIM(30)                                            CGL177
     D PCrsdS          S            351A   DIM(30)                                            CGL177
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
     D PNaho           S             10A
     D PBRCH           S              3A                                                      CGL177

     D PCRSDT          DS
     D  DDCTRR                 1      2
     D  DDPREP                 3      3
     D  DDREPT                 4      4
     D  DDREPU                 5     14
     D  DDREPD                15     20
     D  DDREPM                21     26
     D  DDREP1                27     90
     D  DDREP2                91    154
     D  DDEVD1               155    156
     D  DDEVS1               157    159
     D  DDEVD2               160    161
     D  DDEVS2               162    164
     D  DDEVD3               165    166
     D  DDEVS3               167    169
     D  DDEVD4               170    171
     D  DDEVS4               172    174
     D  DDEVD5               175    176
     D  DDEVS5               177    179
     D  DDTINN               180    204
     D  DDEFFD               205    210
     D  DDEXPD               211    216
     D  DDCODO               217    217
     D  DDJACM               218    218
     D  DDMAIL               219    219
     D  DDPHN1               220    220
     D  DDRPAY               221    221
     D  DDPEP1               222    285
     D  DDPEP2               286    349
     D  DDCRSA               350    350
     D  DDTINS               351    351                                                       CGL177

     D PCRSDU          DS
     D  DFCTRY                 1      2
     D  DFFIL1                 3     12
     D  DFREPT                13     13
     D  DFFIL2                14    185                                                       CGL157
     D  DFTINO               186    210                                                       CGL157
     D  DFFIL3               211    216                                                       CGL157
     D  DFCODO               217    217
     D  DFJACM               218    218
     D  DFMAIL               219    219
     D  DFPHON               220    220
     D  DFRPAY               221    221
     D  DFTINS               222    222                                                       CGL177

     D PCRSDQ          DS
     D  D1FIL1                 1      3
     D  D1REPT                 4      4
     D  D1FIL2                 5    216
     D  D1CODO               217    217
     D  D1JACM               218    218
     D  D1MAIL               219    219
     D  D1PHON               220    220
     D  D1RPAY               221    221
     D  D1FIL3               222    350
     D  D1TINS               351    351                                                       CGL177

     D PCRSDR          DS
     D  D2FIL1                 1     12
     D  D2REPT                13     13
     D  D2FIL2                14    216
     D  D2CODO               217    217
     D  D2JACM               218    218
     D  D2MAIL               219    219
     D  D2PHON               220    220
     D  D2RPAY               221    221
     D  D2TINS               222    222                                                       CGL177

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

     D I               S              3  0
     D PMode           S              1
     D X               S              2S 0
     D Y               S              2S 0
     D WReset          S              1
     D WDATEA          S              6                                                     MD041311
     D ZDAYNO          S              5  0                                                  MD041311
     D ErrorFlag       S              1                                                     MD041311
     D WChar3          S              3A                                                    MD041311

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
     C                   MOVEA     *Blanks       PCrsdF                                     MD041311
     C                   EVAL      WCOLC = DDCOLC

      ** Default countries

     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   EVAL      PCRSDU = PCrsdF(X)
     C                   IF        DDCTRR <> *Blanks
     C                   EVAL      DDCODO = ' '
     C                   EVAL      DDJACM = ' '
     C                   EVAL      DDMAIL = ' '
     C                   EVAL      DDPHN1 = ' '
     C                   EVAL      DDRPAY = ' '
     C                   EVAL      DFCODO = ' '
     C                   EVAL      DFJACM = ' '
     C                   EVAL      DFMAIL = ' '
     C                   EVAL      DFPHON = ' '
     C                   EVAL      DFRPAY = ' '
     C                   EVAL      DDTINS = ' '                                               CGL177
     C                   EVAL      DFTINS = ' '                                               CGL177
     C                   EVAL      RVCTRY = %SUBST(PCrsdT:1:2)                              MD041311
     C                   EVAL      RVREPT = %SUBST(PCrsdT:4:1)                              MD041311
     C                   EVAL      RVREPR = %SUBST(PCrsdT:27:128)                           MD041311
     C                   EVAL      WDATEA = %SUBST(PCrsdT:15:6)                             MD041311
     C                   IF        WDATEA <> *Blanks                                        MD041311
     C                   EXSR      SrConv                                                   MD041311
     C                   EVAL      RVREPD = ZDAYNO                                          MD041311
     C                   ELSE                                                               MD041311
     C                   EVAL      RVREPD = 0                                               MD041311
     C                   ENDIF                                                              MD041311
     C                   EVAL      RVREPM = %SUBST(PCrsdT:21:6)                             MD041311
     C                   EVAL      RVREPU = %SUBST(PCrsdT:5:10)                             MD041311
     C                   EVAL      RVEVE1 = %SUBST(PCrsdT:155:2)                            MD041311
     C                   EVAL      WCHAR3 = %SUBST(PCrsdT:157:3)                            MD041311
     C                   IF        WCHAR3 <> '   '                                          MD041311
     C                   MOVE      WCHAR3        RVEVS1                                     MD041311
     C                   ELSE                                                               MD041311
     C                   EVAL      RVEVS1 = 0                                               MD041311
     C                   ENDIF                                                              MD041311
     C                   EVAL      RVEVE2 = %SUBST(PCrsdT:160:2)                            MD041311
     C                   EVAL      WCHAR3 = %SUBST(PCrsdT:162:3)                            MD041311
     C                   IF        WCHAR3 <> '   '                                          MD041311
     C                   MOVE      WCHAR3        RVEVS2                                     MD041311
     C                   ELSE                                                               MD041311
     C                   EVAL      RVEVS2 = 0                                               MD041311
     C                   ENDIF                                                              MD041311
     C                   EVAL      RVEVE3 = %SUBST(PCrsdT:165:2)                            MD041311
     C                   EVAL      WCHAR3 = %SUBST(PCrsdT:167:3)                            MD041311
     C                   IF        WCHAR3 <> '   '                                          MD041311
     C                   MOVE      WCHAR3        RVEVS3                                     MD041311
     C                   ELSE                                                               MD041311
     C                   EVAL      RVEVS3 = 0                                               MD041311
     C                   ENDIF                                                              MD041311
     C                   EVAL      RVEVE4 = %SUBST(PCrsdT:170:2)                            MD041311
     C                   EVAL      WCHAR3 = %SUBST(PCrsdT:172:3)                            MD041311
     C                   IF        WCHAR3 <> '   '                                          MD041311
     C                   MOVE      WCHAR3        RVEVS4                                     MD041311
     C                   ELSE                                                               MD041311
     C                   EVAL      RVEVS4 = 0                                               MD041311
     C                   ENDIF                                                              MD041311
     C                   EVAL      RVEVE5 = %SUBST(PCrsdT:175:2)                            MD041311
     C                   EVAL      WCHAR3 = %SUBST(PCrsdT:177:3)                            MD041311
     C                   IF        WCHAR3 <> '   '                                          MD041311
     C                   MOVE      WCHAR3        RVEVS5                                     MD041311
     C                   ELSE                                                               MD041311
     C                   EVAL      RVEVS5 = 0                                               MD041311
     C                   ENDIF                                                              MD041311
     C                   EVAL      RVTINN = %SUBST(PCrsdT:180:25)                           MD041311
     C                   EVAL      WDATEA = %SUBST(PCrsdT:205:6)                            MD041311
     C                   IF        WDATEA <> *Blanks                                        MD041311
     C                   EXSR      SrConv                                                   MD041311
     C                   EVAL      RVEFFD = ZDAYNO                                          MD041311
     C                   ELSE                                                               MD041311
     C                   EVAL      RVEFFD = 0                                               MD041311
     C                   ENDIF                                                              MD041311
     C                   EVAL      WDATEA = %SUBST(PCrsdT:211:6)                            MD041311
     C                   IF        WDATEA <> *Blanks                                        MD041311
     C                   EXSR      SrConv                                                   MD041311
     C                   EVAL      RVEXPD = ZDAYNO                                          MD041311
     C                   ELSE                                                               MD041311
     C                   EVAL      RVEXPD = 0                                               MD041311
     C                   ENDIF                                                              MD041311


     C                   EXSR      SRVChk

     C                   EVAL      WCNCD = DDCTRR

      ** Get CRS agreement

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM      WCNCD         @PCTRR                                       CGL177
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      @PCTRR = *Blanks
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
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
     C                   MOVEL     ValidCRSCtry  PCrsdF(X)                                  MD041311
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
     C                   EVAL      DDCODO = 'Y'
     C                   EVAL      DFCODO = 'Y'
     C                   EVAL      DDTINN = DDTINO                                            CGL157
     C                   EVAL      DFTINO = DDTINO                                            CGL157
     C                   EVAL      DDPREP = ' '                                             MD050480
     C                   IF        DDREPT <> 'N'
     C                             AND DDREPT <> ' '
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   ENDIF
     C                   EVAL      WCNCD = WWCTRY

      ** Get CRS agreement

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM      WCNCD         @PCTRR                                       CGL177
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      @PCTRR = *Blanks
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
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
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO
     C                   ELSE
     C                   EVAL      DDCTRR = WWCTRY
     C                   EVAL      DDCTRY = WWCTRY
     C                   EVAL      DDTINN = DDTINO                                            CGL157
     C                   EVAL      DFTINO = DDTINO                                            CGL157
     C                   EVAL      DDCODO = 'Y'
     C                   EVAL      DFCODO = 'Y'
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EVAL      DDJACM = ' '
     C                   EVAL      DDMAIL = ' '
     C                   EVAL      DDPHN1 = ' '
     C                   EVAL      DDRPAY = ' '
     C                   EVAL      DFJACM = ' '
     C                   EVAL      DFMAIL = ' '
     C                   EVAL      DFPHON = ' '
     C                   EVAL      DFRPAY = ' '
     C                   EVAL      DDTINS = ' '                                               CGL177
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

     C                   EVAL      PCRSDT = *Blanks
     C                   EVAL      PCRSDU = *Blanks

     C                   IF        WCOLC <> *Blanks
     C                   IF        %LOOKUP(WCOLC:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = WCOLC
     C                   EVAL      DDCTRY = WCOLC
     C                   EVAL      DDTINN = DDTINO
     C                   EVAL      DFTINO = DDTINO                                            CGL157
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
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
     C                   EVAL      DDCODO = ' '
     C                   EVAL      DDJACM = ' '
     C                   EVAL      DDPHN1 = ' '
     C                   EVAL      DDRPAY = ' '
     C                   EVAL      DFCODO = ' '
     C                   EVAL      DFJACM = ' '
     C                   EVAL      DFPHON = ' '
     C                   EVAL      DFRPAY = ' '
     C                   EVAL      DDTINS = ' '                                               CGL177
     C                   EVAL      DFTINS = ' '                                               CGL177

     C                   IF        DDMCT1 <> *Blanks
     C                   IF        %LOOKUP(DDMCT1:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDMCT1
     C                   EVAL      DDCTRY = DDMCT1
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDMCT2 <> *Blanks
     C                             AND DDMCT1 <> DDMCT2                                     MD041294
     C                   IF        %LOOKUP(DDMCT2:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDMCT2
     C                   EVAL      DDCTRY = DDMCT2
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDMCT3 <> *Blanks
     C                             AND DDMCT1 <> DDMCT3                                     MD041294
     C                             AND DDMCT2 <> DDMCT3                                     MD041294
     C                   IF        %LOOKUP(DDMCT3:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDMCT3
     C                   EVAL      DDCTRY = DDMCT3
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDMCT4 <> *Blanks
     C                             AND DDMCT1 <> DDMCT4                                     MD041294
     C                             AND DDMCT2 <> DDMCT4                                     MD041294
     C                             AND DDMCT3 <> DDMCT4                                     MD041294
     C                   IF        %LOOKUP(DDMCT4:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDMCT4
     C                   EVAL      DDCTRY = DDMCT4
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDMCT5 <> *Blanks
     C                             AND DDMCT1 <> DDMCT5                                     MD041294
     C                             AND DDMCT2 <> DDMCT5                                     MD041294
     C                             AND DDMCT3 <> DDMCT5                                     MD041294
     C                             AND DDMCT4 <> DDMCT5                                     MD041294
     C                   IF        %LOOKUP(DDMCT5:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDMCT5
     C                   EVAL      DDCTRY = DDMCT5
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
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

     C                   EVAL      DDPHN1 = 'Y'
     C                   EVAL      DFPHON = 'Y'
     C                   EVAL      DDCODO = ' '
     C                   EVAL      DDJACM = ' '
     C                   EVAL      DDMAIL = ' '
     C                   EVAL      DDRPAY = ' '
     C                   EVAL      DFCODO = ' '
     C                   EVAL      DFJACM = ' '
     C                   EVAL      DFMAIL = ' '
     C                   EVAL      DFRPAY = ' '
     C                   EVAL      DDTINS = ' '                                               CGL177
     C                   EVAL      DFTINS = ' '                                               CGL177

     C                   IF        DDPCT1 <> *Blanks
     C                   IF        %LOOKUP(DDPCT1:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDPCT1
     C                   EVAL      DDCTRY = DDPCT1
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDPCT2 <> *Blanks
     C                             AND DDPCT1 <> DDPCT2                                     MD041294
     C                   IF        %LOOKUP(DDPCT2:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDPCT2
     C                   EVAL      DDCTRY = DDPCT2
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDPCT3 <> *Blanks
     C                             AND DDPCT1 <> DDPCT3                                     MD041294
     C                             AND DDPCT2 <> DDPCT3                                     MD041294
     C                   IF        %LOOKUP(DDPCT3:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDPCT3
     C                   EVAL      DDCTRY = DDPCT3
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDPCT4 <> *Blanks
     C                             AND DDPCT1 <> DDPCT4                                     MD041294
     C                             AND DDPCT2 <> DDPCT4                                     MD041294
     C                             AND DDPCT3 <> DDPCT4                                     MD041294
     C                   IF        %LOOKUP(DDPCT4:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDPCT4
     C                   EVAL      DDCTRY = DDPCT4
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   EXSR      SRVChk
     C                   EXSR      SRVDft
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDPCT5 <> *Blanks
     C                             AND DDPCT1 <> DDPCT5                                     MD041294
     C                             AND DDPCT2 <> DDPCT5                                     MD041294
     C                             AND DDPCT3 <> DDPCT5                                     MD041294
     C                             AND DDPCT4 <> DDPCT5                                     MD041294
     C                   IF        %LOOKUP(DDPCT5:PCtry:1:30) <> 0
     C                   ELSE
     C                   EVAL      DDCTRR = DDPCT5
     C                   EVAL      DDCTRY = DDPCT5
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
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
     C                   EVAL      DDCODO = 'Y'
     C                   EVAL      DFCODO = 'Y'
     C                   EVAL      DDTINN = DDTINO
     C                   EVAL      DFTINO = DDTINO                                            CGL157
     C                   IF        DDTINO <> *Blanks                                          CGL177
     C                   EVAL      DDTINS = 'Y'                                               CGL177
     C                   EVAL      DFTINS = 'Y'                                               CGL177
     C                   ENDIF                                                                CGL177
     C                   IF        DDREPT <> 'N'
     C                             AND DDREPT <> ' '
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        (DDCTRR = DDMCT1
     C                             OR DDCTRR = DDMCT2
     C                             OR DDCTRR = DDMCT3
     C                             OR DDCTRR = DDMCT4
     C                             OR DDCTRR = DDMCT5)
     C                   EVAL      DDMAIL = 'Y'
     C                   EVAL      DFMAIL = 'Y'
     C                   EVAL      DDPREP = ' '                                             MD050480
     C                   IF        DDREPT <> 'N'
     C                             AND DDREPT <> ' '
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        (DDCTRR = DDPCT1
     C                             OR DDCTRR = DDPCT2
     C                             OR DDCTRR = DDPCT3
     C                             OR DDCTRR = DDPCT4
     C                             OR DDCTRR = DDPCT5)
     C                   EVAL      DDPHN1 = 'Y'
     C                   EVAL      DFPHON = 'Y'
     C                   EVAL      DDPREP = ' '                                             MD050480
     C                   IF        DDREPT <> 'N'
     C                             AND DDREPT <> ' '
     C                   EVAL      DDREPT = 'Y'
     C                   EVAL      DFREPT = 'Y'
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
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM      WCNCD         @PCTRR                                       CGL177
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      WCOLC = *BLANK
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      DS_A8LCCD     @PCTRT                              CGL177 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM                    @PCTRR                                       CGL177
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
     C                   IF        %SUBST(PCrsdU:142:3) = *Blanks                           MD041311
     C                   EVAL      %SUBST(PCrsdU:142:3) = x'00000f'                         MD041311
     C                   ENDIF                                                              MD041311
     C                   IF        %SUBST(PCrsdU:211:3) = *Blanks                           MD041311
     C                   EVAL      %SUBST(PCrsdU:211:3) = x'00000f'                         MD041311
     C                   ENDIF                                                              MD041311
     C                   IF        %SUBST(PCrsdU:214:3) = *Blanks                           MD041311
     C                   EVAL      %SUBST(PCrsdU:214:3) = x'00000f'                         MD041311
     C                   ENDIF                                                              MD041311
     C                   EVAL      PCrsdF(X) = PCRSDU
     C                   EVAL      X = 31
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   EVAL      PCRSDT = *Blanks
     C                   EVAL      PCRSDU = *Blanks

     C                   ENDSR

      *****************************************************************                     MD041311
      /EJECT                                                                                MD041311
      *****************************************************************                     MD041311
      ** SRConv - Convert date                                        *                     MD041311
      *****************************************************************                     MD041311
     C     SRConv        BEGSR                                                              MD041311
                                                                                            MD041311
     C                   CALLB     'ZDATE1'                                                 MD041311
     C                   PARM                    WDATEA                                     MD041311
     C                   PARM                    ZDAYNO                                     MD041311
     C                   PARM                    BJDFIN                                     MD041311
     C                   PARM                    ErrorFlag                                  MD041311
                                                                                            MD041311
     C                   ENDSR                                                              MD041311
                                                                                            MD041311
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        PLIST

     C                   PARM                    NewNaPrim
     C                   PARM                    PCrsdS
     C                   PARM                    PCrsdF

                                                                                              CGL177
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

     C                   MOVEL     'SDCRSNDFT'   Dbpgm
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
