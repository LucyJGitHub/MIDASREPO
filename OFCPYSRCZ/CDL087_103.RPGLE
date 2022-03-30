      *****************************************************************                     MD059723
      *                                                               *                     MD059723
      *  Midas - /COPY Member (RPG)                                   *                     MD059723
      *                                                               *                     MD059723
      *  CDL087_103 - /COPY FOR GL008900                              *                     MD059723
      *                                                               *                     MD059723
      *   (c) Finastra International Limited 2022                     *                     MD059723
      *                                                               *                     MD059723
      *  Last Amend No. MD059723           Date 29Mar22               *                     MD059723
      *  Prev Amend No. MD048076           Date 30Jan18               *                     MD059723
      *                 MD046073           Date 20Jun17               *                     MD059723
      *                 AR1093845 *CREATE  Date 06Mar13               *                     MD059723
      *                                                               *                     MD059723
      *---------------------------------------------------------------*                     MD059723
      *                                                               *                     MD059723
      *  MD059723 - Changes for FM 2.1 upgrade.                       *                     MD059723
      *  MD048076 - Incorrect Spot Trade Equivalent Account is used   *                     MD059723
      *             for foreign ccy. save first A6SPAE before calling *                     MD059723
      *             SR/#GLBCV                                         *                     MD059723
      *             Applied for MD059723.                             *                     MD059723
      *  MD046073 - Missing postings on PT                            *                     MD059723
      *             Applied for MD059723.                             *                     MD059723
      *  AR1093845 - Incorporate CDL087 Changes                       *                     MD059723
      *             Applied for MD059723.                             *                     MD059723
      *                                                               *                     MD059723
      *****************************************************************                     MD059723
      /SPACE                                                                               AR1093845
      *****************************************************************                    AR1093845
      * #GNS37    - Access Enhancement details file to determine if   *                    AR1093845
      *             CDL087 is installed.                              *                    AR1093845
      *                                                               *                    AR1093845
      * CALLS                                                         *                    AR1093845
      *                                                               *                    AR1093845
      * CALLED BY   *INZSR                                            *                    AR1093845
      *                                                               *                    AR1093845
      * FLDS USED -                                                   *                    AR1093845
      *                                                               *                    AR1093845
      *****************************************************************                    AR1093845
     C     #GNS37        BEGSR                                                             AR1093845
     C**                                                                                   AR1093845
     C** ACCESS SAR DETAILS FILE TO DETERMINE IF CDL087 IS INSTALLED                       AR1093845
     C**                                                                                   AR1093845
     C                   CALL      'AOSARDR0'                                              AR1093845
     C                   PARM      *BLANKS       PRtCd                                     AR1093845
     C                   PARM      '*VERIFY'     POptn                                     AR1093845
     C                   PARM      'CDL087'      @SARD             6                       AR1093845
     C                   IF        PRtCD <> *BLANKS AND                                    AR1093845
     C                             PRtCD <> '*NRF'                                         AR1093845
     C     *LOCK         IN        LDA                                                     AR1093845
     C                   EVAL      DBFile = 'SCSARDPD'                                     AR1093845
     C                   EVAL      DBKey =  POptn                                          AR1093845
     C                   EVAL      DBase =  009                                            AR1093845
     C                   OUT       LDA                                                     AR1093845
     C                   EXSR      *PSSR                                                   AR1093845
     C                   ENDIF                                                             AR1093845
     C                   IF        PRtCD = *BLANKS                                         AR1093845
     C                   MOVEL     'Y'           CDL087            1                       AR1093845
     C                   ELSE                                                              AR1093845
     C*                                                                                    AR1093845
     c** If enhancement flag is off, set enhancement flag to 'N' and                       AR1093845
     c** initialise transfer flag to 'N'.                                                  AR1093845
     C                   MOVEL     'N'           CDL087                                    AR1093845
     C*************      MOVE      'N'           GTFRI                            AR1093845 MD059723
     C                   MOVE      'N'           X0GTFRI                                    MD059723
     C                   ENDIF                                                             AR1093845
      *                                                                                    AR1093845
      ** Move 'Y' to test flag if testing if done                                          AR1093845
     C                   MOVE      'N'           TEST              1                       AR1093845
      *                                                                                    AR1093845
     C                   ENDSR                                                             AR1093845
      *****************************************************************                    AR1093845
      /SPACE                                                                               AR1093845
      *****************************************************************                    AR1093845
      *                                                               *                    AR1093845
      * #GLBDT    - Access branch extension file to retrieve local    *                    AR1093845
      *             base currency, transfer flag, trade a/c code,     *                    AR1093845
      *             a/c type, a/c section and ccy decimal position.   *                    AR1093845
      *                                                               *                    AR1093845
      * CALLS       *PSSR      - Dump prgram                          *                    AR1093845
      *             AOBRCXR0   - Access program for branch extension  *                    AR1093845
      *                          file                                 *                    AR1093845
      * CALLED BY   Main                                              *                    AR1093845
      *                                                               *                    AR1093845
      * FLDS USED -                                                   *                    AR1093845
      *                                                               *                    AR1093845
      *****************************************************************                    AR1093845
     C     #GLBDT        BEGSR                                                             AR1093845
      *                                                                                    AR1093845
     C** Access branch extension file                                                      AR1093845
     C                   CALL      'AOBRCXR0'                                              AR1093845
     C                   PARM      '*MSG   '     PRtCD                                     AR1093845
     C                   PARM      '*KEY   '     POptn                                     AR1093845
     C                   PARM      BTIBCA        @DSNB             3                       AR1093845
     C**** SDBRCX****    PARM      SDBRCX        DSFDY                            AR1093845 MD059723
     C     SDBRCX        PARM      SDBRCX        DSSDY                                      MD059723
      *                                                                                    AR1093845
      ** Database error if extension file record not found.                                AR1093845
     C                   IF        PRtCD <> *BLANKS                                        AR1093845
     C     *LOCK         IN        LDA                                                     AR1093845
     C**********         EVAL      DBFile = 'SDBRCHX1'                            AR1093845 MD059723
     C                   EVAL      DBFile = 'SDBRCHX0'                                      MD059723
     C                   EVAL      DBKey =  POptn                                          AR1093845
     C                   EVAL      DBase =  009                                            AR1093845
     C                   OUT       LDA                                                     AR1093845
     C                   EXSR      *PSSR                                                   AR1093845
     C                   ELSE                                                              AR1093845
      *                                                                                    AR1093845
      ** If extension file record is found, get local base currency's                      AR1093845
      ** trade account code, decimal positions, a/c type and section                       AR1093845
     C**** GTFRI**       IFEQ      'Y'                                            AR1093845 MD059723
     C     X0GTFRI       IFEQ      'Y'                                                      MD059723
      *                                                                                    AR1093845
     C************       MOVE      GLBCY         PCcy                             AR1093845 MD059723
     C                   MOVE      X0GLBCY       PCcy                                       MD059723
     C                   EXSR      SRCurr                                                  AR1093845
      *                                                                                    AR1093845
     C                   MOVEL     A6SPAE        #GLBTA           10 0                     AR1093845
     C                   Z-ADD     A6NBDP        #GLBDP            1 0                     AR1093845
     C                   Z-ADD     A6SPRT        #GLBSP           13 8                     AR1093845
     C                   MOVE      A6MDIN        #GLBMD            1                       AR1093845
                                                                                           AR1093845
     C                   MOVE      *BLANKS       #GLBAT            1                       AR1093845
     C                   MOVE      *BLANKS       #GLBAS            2                       AR1093845
     C                   MOVE      #GLBTA        PAfnb                                     AR1093845
     C                   EXSR      SRAcod                                                  AR1093845
     C                   EVAL      #GLBAT = A5ACTY                                         AR1093845
     C                   EVAL      #GLBAS = A5ACSC                                         AR1093845
                                                                                           AR1093845
     C                   ELSE                                                              AR1093845
     C************       MOVE      BJCYCD        GLBCY                            AR1093845 MD059723
     C                   MOVE      BJCYCD        X0GLBCY                                    MD059723
     C                   END                                                               AR1093845
     C                   END                                                               AR1093845
      *                                                                                    AR1093845
     C                   ENDSR                                                             AR1093845
      *****************************************************************                    AR1093845
      /SPACE                                                                               AR1093845
      *****************************************************************                    AR1093845
      *                                                               *                    AR1093845
      *  SRFrgnCY2 - Transfer Foreign Currency Income and Expense     *                    AR1093845
      *              to Local Base CCY                                *                    AR1093845
      *                                                               *                    AR1093845
      * CALLS       SB1CON     - Conversion of amount to base ccy     *                    AR1093845
      *             #GLBCV     - Conversion of base ccy to local base *                    AR1093845
      *                          ccy.                                 *                    AR1093845
      * CALLED BY   Main                                              *                    AR1093845
      *                                                               *                    AR1093845
      * Subroutine based on SrFrgnCCY                                 *                    AR1093845
      *                                                               *                    AR1093845
      *****************************************************************                    AR1093845
     C     SRFRGNCY2     BEGSR                                                             AR1093845
                                                                                           AR1093845
      **                                                                                   AR1093845
      ** 1st Posting: Income or Expense a/c in foreign ccy                                 AR1093845
                                                                                           AR1093845
     C                   Z-ADD     HQBDTE        VALD                                      AR1093845
     C                   Z-ADD     BJRDNB        PSTD                                      AR1093845
                                                                                           AR1093845
     C                   EVAL      BRCA = A8BRCD                                           AR1093845
     C                   EVAL      CNUM = BTCUST                                           AR1093845
     C                   EVAL      CCY  = BTCYCD                                           AR1093845
     C                   MOVE      BTACCD        ACOD                                      AR1093845
     C                   MOVE      BTACSN        ACSQ                                      AR1093845
     C                   EVAL      ATYP = BTACTY                                           AR1093845
     C                   EVAL      ACSC = ACS(X)                                           AR1093845
     C                   EVAL      PNAR = PNARR(1)                                         AR1093845
                                                                                           AR1093845
     C                   Z-ADD     BTPTAM        PSTA                   53                 AR1093845
     C                   IF        *IN53  = '1'                                            AR1093845
     C                   Z-SUB     BTPTAM        PSTA                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   IF        BTDCIN = 'C'                                            AR1093845
     C                   MOVE      '0'           DRCR                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   MOVE      '1'           DRCR                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   IF        ATYP = 'R'                                              AR1093845
     C                   Z-ADD     1             RIND                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   Z-ADD     0             RIND                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   WRITE     APOSTPDF                                                AR1093845
                                                                                           AR1093845
      ** 2nd Posting: Position a/c in foreign ccy                                          AR1093845
                                                                                           AR1093845
     C                   EVAL      CNUM = A8BICN                                           AR1093845
     C                   EVAL      ATYP = TRDTY                                            AR1093845
     C                   EVAL      ACSC = TRDSC                                            AR1093845
     C                   MOVE      BLSPTA        ACOD                                      AR1093845
     C                   Z-ADD     1             ACSQ                                      AR1093845
                                                                                           AR1093845
     C                   IF        BTDCIN = 'C'                                            AR1093845
     C                   MOVE      '1'           DRCR                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   MOVE      '0'           DRCR                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   IF        ATYP = 'R'                                              AR1093845
     C                   Z-ADD     1             RIND                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   Z-ADD     0             RIND                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   WRITE     APOSTPDF                                                AR1093845
                                                                                           AR1093845
      ** Convert foreign currency amount to base currency                                  AR1093845
                                                                                           AR1093845
     C                   Z-ADD     0             PSTA                                      AR1093845
     C                   EXSR      SRConvert                                               AR1093845
     C                   MOVEL     A6SPAE        TACC                                       MD048076
                                                                                           AR1093845
      ** Convert foreign currency amount to local base currency                            AR1093845
     C                   EXSR      #GLBCV                                                  AR1093845
      **                                                                                   AR1093845
                                                                                           AR1093845
     C                   IF        #GLBC0 <> *ZERO                                         AR1093845
                                                                                           AR1093845
      **                                                                                   AR1093845
      ** Get trade type and sequence of spot trading account equiv.                        AR1093845
                                                                                           AR1093845
     C**********         MOVEL     #GLBTA        TACC                             AR1093845 MD048076
     C                   MOVE      *BLANKS       PAfnb                                     AR1093845
     C                   MOVE      TACC          PAfnb                                     AR1093845
     C                   EXSR      SRAcod                                                  AR1093845
     C                   EVAL      SRDTY = A5ACTY                                          AR1093845
     C                   EVAL      SRDSC = A5ACSC                                          AR1093845
                                                                                           AR1093845
      ** 3rd Posting: Income or Expense a/c in local base ccy                              AR1093845
                                                                                           AR1093845
     C************       EVAL      CCY  = GLBCY                                   AR1093845 MD059723
     C                   EVAL      CCY  = X0GLBCY                                           MD059723
     C                   MOVE      TACC          ACOD                                      AR1093845
     C                   EVAL      ATYP = SRDTY                                            AR1093845
     C                   EVAL      ACSC = SRDSC                                            AR1093845
                                                                                           AR1093845
     C                   IF        BTDCIN = 'C'                                            AR1093845
     C                   MOVE      '0'           DRCR                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   MOVE      '1'           DRCR                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   IF        ATYP = 'R'                                              AR1093845
     C                   Z-ADD     1             RIND                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   Z-ADD     0             RIND                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   WRITE     APOSTPDF                                                AR1093845
                                                                                           AR1093845
      ** 4th Posting: Equivalent a/c in local base ccy                                     AR1093845
                                                                                           AR1093845
     C                   IF        BKFCRC = 'B' OR                                         AR1093845
     C                             BKFCRC = 'C'                                            AR1093845
     C                   EVAL      CNUM = BTCUST                                           AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   IF        BKFCRC = 'B' OR                                         AR1093845
     C                             BKFCRC = 'S'                                            AR1093845
     C                   MOVE      BTACSN        ACSQ                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   MOVE      BTACCD        ACOD                                      AR1093845
     C                   EVAL      ATYP = BTACTY                                           AR1093845
     C                   EVAL      ACSC = ACS(X)                                           AR1093845
     C                   EVAL      PNAR = PNAR2                                            AR1093845
                                                                                           AR1093845
     C                   IF        BTDCIN = 'C'                                            AR1093845
     C                   MOVE      '1'           DRCR                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   MOVE      '0'           DRCR                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   IF        ATYP = 'R'                                              AR1093845
     C                   Z-ADD     1             RIND                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   Z-ADD     0             RIND                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   WRITE     APOSTPDF                                                AR1093845
                                                                                           AR1093845
      ** Additional postings when base currency trade and trade equivalent                 AR1093845
      ** accounts are used by installation                                                 AR1093845
                                                                                           AR1093845
     C                   IF        BSTACC <> *ZERO                                         AR1093845
     C                   EVAL      CNUM = A8BICN                                           AR1093845
     C                   EVAL      ATYP = TRDTY                                            AR1093845
     C                   EVAL      ACSC = TRDSC                                            AR1093845
     C                   MOVE      BLSPTA        ACOD                                      AR1093845
     C                   Z-ADD     1             ACSQ                                      AR1093845
     C                   EVAL      PNAR = PNARR(1)                                         AR1093845
                                                                                           AR1093845
     C                   IF        BTDCIN = 'D'                                            AR1093845
     C                   MOVE      '1'           DRCR                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   MOVE      '0'           DRCR                                      AR1093845
     C                   ENDIF                                                             AR1093845
     C                   IF        ATYP = 'R'                                              AR1093845
     C                   Z-ADD     1             RIND                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   Z-ADD     0             RIND                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   WRITE     APOSTPDF                                                AR1093845
                                                                                           AR1093845
     C                   EVAL      ATYP = BSDTY                                            AR1093845
     C                   EVAL      ACSC = BSDSC                                            AR1093845
     C                   Z-ADD     BSTACC        ACOD                                      AR1093845
                                                                                           AR1093845
     C                   IF        BTDCIN = 'D'                                            AR1093845
     C                   MOVE      '0'           DRCR                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   MOVE      '1'           DRCR                                      AR1093845
     C                   ENDIF                                                             AR1093845
     C                   IF        ATYP = 'R'                                              AR1093845
     C                   Z-ADD     1             RIND                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   Z-ADD     0             RIND                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   WRITE     APOSTPDF                                                AR1093845
                                                                                           AR1093845
     C                   ENDIF                                                             AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
      **                                                                                   AR1093845
      ** Maintain hash totals                                                              AR1093845
                                                                                           AR1093845
     C                   Z-ADD     0             SUBTOT                                    AR1093845
     C                   ADD       2             RECCNT                                    AR1093845
     C     BTPTAM        MULT      2             SUBTOT                                    AR1093845
     C                   IF        #GLBC0 <> *ZERO                                         AR1093845
     C                   DO        2                                                       AR1093845
     C                   ADD       #GLBC0        SUBTOT                                    AR1093845
     C                   ENDDO                                                             AR1093845
     C                   ADD       2             RECCNT                                    AR1093845
     C                   IF        BSTACC <> *ZERO                                         AR1093845
     C                   DO        2                                                       AR1093845
     C                   ADD       #GLBC0        SUBTOT                                    AR1093845
     C                   ENDDO                                                             AR1093845
     C                   ADD       2             RECCNT                                    AR1093845
     C                   ENDIF                                                             AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C     SUBTOT        DIV       1000          ZZAMT                                     AR1093845
     C                   IF        ZZAMT < *ZERO                                           AR1093845
     C                   Z-SUB     ZZAMT         ZZAMT                                     AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   Z-ADD     ZZAMT         ZZAMTI                                    AR1093845
     C                   MOVE      ZZAMT         ZZAMTD                                    AR1093845
     C                   ADD       ZZAMTD        ZZTOTD                                    AR1093845
                                                                                           AR1093845
     C                   IF        ZZTOTD < ZZAMTD                                         AR1093845
     C                   ADD       1             ZZAMTI                                    AR1093845
     C                   ENDIF                                                             AR1093845
     C                   ADD       ZZAMTI        ZZTOTI                                    AR1093845
                                                                                           AR1093845
     C     F2BEND        ENDSR                                                             AR1093845
      *****************************************************************                    AR1093845
      /EJECT                                                                               AR1093845
      *****************************************************************                    AR1093845
      *                                                               *                    AR1093845
      *  SRBaseCY2 - Transfer of Local Base Currency Income and       *                    AR1093845
      *              Expense to Retained Earnings                     *                    AR1093845
      *                                                               *                    AR1093845
      * CALLED BY   Main                                              *                    AR1093845
      *                                                               *                    AR1093845
      * Subroutine based on SrFrgnCCY                                 *                    AR1093845
      *                                                               *                    AR1093845
      *****************************************************************                    AR1093845
     C     SRBaseCY2     BEGSR                                                             AR1093845
                                                                                           AR1093845
      **                                                                                   AR1093845
     C                   IF        #GLBC0 <> *ZERO OR                                      AR1093845
     C*************                BTCYCD = GLBCY                                 AR1093845 MD059723
     C                             BTCYCD = X0GLBCY                                         MD059723
                                                                                           AR1093845
      ** 1st Posting: Income or Expense a/c in base ccy                                    AR1093845
                                                                                           AR1093845
     C*************      IF        BTCYCD = GLBCY                                 AR1093845 MD059723
     C                   IF        BTCYCD = X0GLBCY                                         MD059723
     C                   EVAL      CCY  = BTCYCD                                           AR1093845
                                                                                           AR1093845
     C                   Z-ADD     BTPTAM        PSTA                   53                 AR1093845
     C                   IF        *IN53  = '1'                                            AR1093845
     C                   Z-SUB     BTPTAM        PSTA                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   ELSE                                                              AR1093845
     C************       EVAL      CCY  = GLBCY                                   AR1093845 MD059723
     C                   EVAL      CCY  = X0GLBCY                                           MD059723
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   MOVE      BTACCD        ACOD                                      AR1093845
     C                   MOVE      BTACSN        ACSQ                                      AR1093845
     C**********         EVAL      CNUM = A8BICN                                  AR1093845 MD046073
     C                   EVAL      CNUM = BTCUST                                            MD046073
     C                   EVAL      ATYP = BTACTY                                           AR1093845
     C                   EVAL      ACSC = ACS(X)                                           AR1093845
     C                   EVAL      PNAR = PNARR(3)                                         AR1093845
                                                                                           AR1093845
     C                   Z-ADD     BJRDNB        PSTD                                      AR1093845
     C                   Z-ADD     HQBDTE        VALD                                      AR1093845
                                                                                           AR1093845
     C                   IF        BTDCIN = 'C'                                            AR1093845
     C                   MOVE      '0'           DRCR                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   MOVE      '1'           DRCR                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   IF        ATYP = 'R'                                              AR1093845
     C                   Z-ADD     1             RIND                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   Z-ADD     0             RIND                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   WRITE     APOSTPDF                                                AR1093845
                                                                                           AR1093845
      ** 2nd Posting: Retained earning a/c in base ccy                                     AR1093845
                                                                                           AR1093845
     C                   EVAL      CNUM = A8BICN                                           AR1093845
     C                   MOVE      BKPLAC        ACOD                                      AR1093845
     C                   Z-ADD     1             ACSQ                                      AR1093845
     C                   EVAL      ATYP = PLTY                                             AR1093845
     C                   EVAL      ACSC = PLSC                                             AR1093845
     C                   EVAL      PNAR = PNAR2                                            AR1093845
                                                                                           AR1093845
     C                   IF        BTDCIN = 'C'                                            AR1093845
     C                   MOVE      '1'           DRCR                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   MOVE      '0'           DRCR                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   IF        ATYP = 'R'                                              AR1093845
     C                   Z-ADD     1             RIND                                      AR1093845
     C                   ELSE                                                              AR1093845
     C                   Z-ADD     0             RIND                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   WRITE     APOSTPDF                                                AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
      **                                                                                   AR1093845
      ** Maintain hash totals                                                              AR1093845
                                                                                           AR1093845
     C                   Z-ADD     0             SUBTOT                                    AR1093845
     C************       IF        BTCYCD = GLBCY                                 AR1093845 MD059723
     C                   IF        BTCYCD = X0GLBCY                                         MD059723
     C                   ADD       2             RECCNT                                    AR1093845
     C     BTPTAM        MULT      2             SUBTOT                                    AR1093845
     C                   ELSE                                                              AR1093845
     C                   IF        #GLBC0 <> *ZERO                                         AR1093845
     C                   ADD       2             RECCNT                                    AR1093845
     C                   DO        2                                                       AR1093845
     C                   ADD       #GLBC0        SUBTOT                                    AR1093845
     C                   ENDDO                                                             AR1093845
     C                   ENDIF                                                             AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C     SUBTOT        DIV       1000          ZZAMT                                     AR1093845
     C                   IF        ZZAMT < *ZERO                                           AR1093845
     C                   Z-SUB     ZZAMT         ZZAMT                                     AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   Z-ADD     ZZAMT         ZZAMTI                                    AR1093845
     C                   MOVE      ZZAMT         ZZAMTD                                    AR1093845
     C                   ADD       ZZAMTD        ZZTOTD                                    AR1093845
                                                                                           AR1093845
     C                   IF        ZZTOTD < ZZAMTD                                         AR1093845
     C                   ADD       1             ZZAMTI                                    AR1093845
     C                   ENDIF                                                             AR1093845
     C                   ADD       ZZAMTI        ZZTOTI                                    AR1093845
                                                                                           AR1093845
     C                   ENDSR                                                             AR1093845
      *****************************************************************                    AR1093845
      /SPACE                                                                               AR1093845
      *****************************************************************                    AR1093845
      *       Conversion of amount to local base currency             *                    AR1093845
      *                                                               *                    AR1093845
      * #GLBCV    - Conversion of amount to local base currency.      *                    AR1093845
      *           - Includes using a 24,9 numberic work field for a   *                    AR1093845
      *             accurate calculation.                             *                    AR1093845
      * CALLS                                                         *                    AR1093845
      *                                                               *                    AR1093845
      * CALLED BY   SrFrgnCy2                                         *                    AR1093845
      *                                                               *                    AR1093845
      * FLDS USED -                                                   *                    AR1093845
      *                                                               *                    AR1093845
      *****************************************************************                    AR1093845
      *                                                                                    AR1093845
     C     #GLBCV        BEGSR                                                             AR1093845
                                                                                           AR1093845
      **                                                                                   AR1093845
      ** Set amount work field and convert using base rate of batch                        AR1093845
                                                                                           AR1093845
     C                   Z-ADD     0             #GLBC0                                    AR1093845
     C                   Z-ADD     0             #GLBC1                                    AR1093845
     C                   Z-ADD     0             #GLBC2                                    AR1093845
     C                   Z-ADD     0             #GLBC3                                    AR1093845
     C                   Z-ADD     BASAM0        AMT0                                      AR1093845
                                                                                           AR1093845
     C************       MOVE      GLBCY         PCcy                             AR1093845 MD059723
     C                   MOVE      X0GLBCY       PCcy                                       MD059723
     C                   EXSR      SRCurr                                                  AR1093845
      *                                                                                    AR1093845
     C                   MOVEL     A6SPAE        #GLBTA           10 0                     AR1093845
     C                   Z-ADD     A6NBDP        #GLBDP            1 0                     AR1093845
     C                   Z-ADD     A6SPRT        #GLBSP           13 8                     AR1093845
     C                   MOVE      A6MDIN        #GLBMD            1                       AR1093845
                                                                                           AR1093845
     C                   MOVE      *BLANKS       #GLBAT            1                       AR1093845
     C                   MOVE      *BLANKS       #GLBAS            2                       AR1093845
     C                   MOVE      #GLBTA        PAfnb                                     AR1093845
     C                   EXSR      SRAcod                                                  AR1093845
     C                   EVAL      #GLBAT = A5ACTY                                         AR1093845
     C                   EVAL      #GLBAS = A5ACSC                                         AR1093845
                                                                                           AR1093845
     C     A6NBDP        COMP      1                                  522021               AR1093845
     C                   IF        *IN52 = '1'                                             AR1093845
     C     A6NBDP        COMP      2                                  23  22               AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
      **                                                                                   AR1093845
      **  Calculates the local base currency eqvivalent using the                          AR1093845
      **  24,9 numeric work field.                                                         AR1093845
     C                   SELECT                                                            AR1093845
b1   C                   WHEN      #GLBMD = 'D'                                            AR1093845
b2   C                   IF        #GLBDP = 0                                              AR1093845
     C   20AMT0          MULT(H)   #GLBSP        #GLBC0                                    AR1093845
     C   21AMT1          MULT(H)   #GLBSP        #GLBC0                                    AR1093845
     C   22AMT2          MULT(H)   #GLBSP        #GLBC0                                    AR1093845
     C   23AMT3          MULT(H)   #GLBSP        #GLBC0                                    AR1093845
b3   C                   ELSEIF    #GLBDP = 1                                              AR1093845
     C   20AMT0          MULT(H)   #GLBSP        #GLBC1                                    AR1093845
     C   21AMT1          MULT(H)   #GLBSP        #GLBC1                                    AR1093845
     C   22AMT2          MULT(H)   #GLBSP        #GLBC1                                    AR1093845
     C   23AMT3          MULT(H)   #GLBSP        #GLBC1                                    AR1093845
b4   C                   ELSEIF    #GLBDP = 2                                              AR1093845
     C   20AMT0          MULT(H)   #GLBSP        #GLBC2                                    AR1093845
     C   21AMT1          MULT(H)   #GLBSP        #GLBC2                                    AR1093845
     C   22AMT2          MULT(H)   #GLBSP        #GLBC2                                    AR1093845
     C   23AMT3          MULT(H)   #GLBSP        #GLBC2                                    AR1093845
x4   C                   ELSE                                                              AR1093845
     C   20AMT0          MULT(H)   #GLBSP        #GLBC3                                    AR1093845
     C   21AMT1          MULT(H)   #GLBSP        #GLBC3                                    AR1093845
     C   22AMT2          MULT(H)   #GLBSP        #GLBC3                                    AR1093845
     C   23AMT3          MULT(H)   #GLBSP        #GLBC3                                    AR1093845
e4   C                   ENDIF                                                             AR1093845
b1   C                   WHEN      #GLBMD = 'M'                                            AR1093845
b2   C                   IF        #GLBDP = 0                                              AR1093845
     C   20AMT0          DIV(H)    #GLBSP        #GLBC0                                    AR1093845
     C   21AMT1          DIV(H)    #GLBSP        #GLBC0                                    AR1093845
     C   22AMT2          DIV(H)    #GLBSP        #GLBC0                                    AR1093845
     C   23AMT3          DIV(H)    #GLBSP        #GLBC0                                    AR1093845
b3   C                   ELSEIF    #GLBDP = 1                                              AR1093845
     C   20AMT0          DIV(H)    #GLBSP        #GLBC1                                    AR1093845
     C   21AMT1          DIV(H)    #GLBSP        #GLBC1                                    AR1093845
     C   22AMT2          DIV(H)    #GLBSP        #GLBC1                                    AR1093845
     C   23AMT3          DIV(H)    #GLBSP        #GLBC1                                    AR1093845
b4   C                   ELSEIF    #GLBDP = 2                                              AR1093845
     C   20AMT0          DIV(H)    #GLBSP        #GLBC2                                    AR1093845
     C   21AMT1          DIV(H)    #GLBSP        #GLBC2                                    AR1093845
     C   22AMT2          DIV(H)    #GLBSP        #GLBC2                                    AR1093845
     C   23AMT3          DIV(H)    #GLBSP        #GLBC2                                    AR1093845
x4   C                   ELSE                                                              AR1093845
     C   20AMT0          DIV(H)    #GLBSP        #GLBC3                                    AR1093845
     C   21AMT1          DIV(H)    #GLBSP        #GLBC3                                    AR1093845
     C   22AMT2          DIV(H)    #GLBSP        #GLBC3                                    AR1093845
     C   23AMT3          DIV(H)    #GLBSP        #GLBC3                                    AR1093845
e4   C                   ENDIF                                                             AR1093845
x1   C                   ENDSL                                                             AR1093845
                                                                                           AR1093845
      **                                                                                   AR1093845
      ** Set posting amount field                                                          AR1093845
                                                                                           AR1093845
     C                   Z-ADD     #GLBC0        PSTA                   54                 AR1093845
                                                                                           AR1093845
     C                   IF        *IN54 = '1'                                             AR1093845
     C                   Z-SUB     #GLBC0        PSTA                                      AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   ENDSR                                                             AR1093845
      *****************************************************************                    AR1093845
      *                                                                                    AR1093845
      *****************************************************************                    AR1093845
      * End of /COPY CDL087_103                                                            AR1093845
