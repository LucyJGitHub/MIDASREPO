     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Forecast Credit Line Avail Bal calc - COB')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000702 - Midas OF Forecast Credit Line Avail Bal calcul    *
      *             Rebuild (COB)                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD024191           Date 08Jan14               *
      *  Prev Amend No. MD024013           Date 12Dec13               *
      *                 CGL145B  *CREATE   Date 29Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024191 - Program failed when Facility file is empty        *
      *  MD024013 - Conversion rate not correct                       *
      *  CGL145B - Subsidiaries Daily Sweeping Forecast               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A_)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D                                     PREFIX(S_)
 
     **   Midas OF Midas OF Forecast Credit line Available Balance Table
     D FOCL          E DS                  EXTNAME(GLFOCLTD)
     D                                     PREFIX(F_)
 
      ** Midas OF Individual Forecast
     D FORIT         E DS                  EXTNAME(GLFORITD)
 
     D FCLTYM        E DS                  EXTNAME(FCLTYFM)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Copyright array
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
 
      ** Local Data Area for database error details
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Account
     D KAccnt          DS
     D  KBRCA                  1      3
     D  KCNUM                  4      9
     D  KCCY                  10     12
     D  KACOD                 13     22  0
     D  KACSQ                 23     24  0
 
     D                 DS
     D  RUN0                   1      3P 0
     D  RUN1                   4      6P 0
     D  RUN2                   7      9P 0
     D  RUN3                  10     12P 0
     D  RUN4                  13     15P 0
     D  RUN5                  16     18P 0
     D  RUN6                  19     21P 0
     D  RUN7                  22     24P 0
     D  RUN8                  25     27P 0
     D  RUN9                  28     30P 0
     D**RUNS********           1     30P 0                                                  MD024191
     D  RUNS                   1     30P 0 INZ(0)                                           MD024191
     D                                     DIM(10) ASCEND
 
     D                 DS
     D  CLDAT0                 1      5  0
     D  CLDAT1                 6     10  0
     D  CLDAT2                11     15  0
     D  CLDAT3                16     20  0
     D  CLDAT4                21     25  0
     D  CLDAT5                26     30  0
     D  CLDAT6                31     35  0
     D  CLDAT7                36     40  0
     D  CLDAT8                41     45  0
     D  CLDAT9                46     50  0
     D  CLDATS                 1     50  0
     D                                     DIM(10) ASCEND
 
     DForeBal          DS
     D  CLFTB0                 1     15  0
     D  CLFTB1                16     30  0
     D  CLFTB2                31     45  0
     D  CLFTB3                46     60  0
     D  CLFTB4                61     75  0
     D  CLFTB5                76     90  0
     D  CLFTB6                91    105  0
     D  CLFTB7               106    120  0
     D  CLFTB8               121    135  0
     D  CLFTB9               136    150  0
     D  CLFTBS                 1    150  0
     D                                     DIM(10) ASCEND
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PCcy            S              3
 
      ** Paramaters for ZXRATE                                                              MD024013
     D  ZRATE1         S             13P 8                                                  MD024013
     D  ZMDI1          S              1A                                                    MD024013
     D  ZRATE2         S             13P 8                                                  MD024013
     D  ZMDI2          S              1A                                                    MD024013
     D  ZRATEX         S             13P 8                                                  MD024013
     D  ZMDIX          S              1A                                                    MD024013
                                                                                            MD024013
      ** Parameters for ZCONVZ1
     D ZEXCH           S             13  8                                                  MD024013
     D ZMD             S              1                                                     MD024013
     D PAmnt           S             15  0
     D PFrXRate        S             13  8
     D PFrMDIn         S              1
     D PFrCCY          S              3
     D PToCCY          S              3
     D PFrDecPlace     S              1  0
     D PToDecPlace     S              1  0
     D POutAmt         S             15  0
 
      ** Other fields used
     D KkBrca          S              3A
     D KkFcus          S              6A
     D KkFact          S              3  0
     D KkFcno          S              2  0
     D X               S              2  0
     D WRun            S              1A   Inz
     D WIncl           S              1A
     D WNetCR          S              1A
     D WOnce           S              1A
     D WProc           S              1A
     D WFound          S              1A
     D WConvFAmt       S             15  0
     D WConvOFAmt      S             15  0
     D WFrXrate        S                   LIKE(A6SPRT)
     D WFrMDIn         S                   LIKE(A6MDIN)
     D WFrDecPlace     S                   LIKE(A6NBDP)
     D WToXrate        S                   LIKE(A6SPRT)                                     MD024013
     D WToMDIn         S                   LIKE(A6MDIN)                                     MD024013
     D WToDecPlace     S                   LIKE(A6NBDP)
     D PSysVal         S             20    DIM(10)
     D PCurSet         S            200    DIM(10)
     D SVFACN          S             24A
     D SVSQLCode       S             10  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      *  MAIN PROCEDURE                                               *
      *****************************************************************
 
     C                   EXSR      SRReadFORI
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      *  PROGRAM END                                                  *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadFORI - Subroutine to read Individual Foreacasts        *
      *                                                               *
      *****************************************************************
     C     SRReadFORI    BEGSR
 
      ** Set file pointer to first record and do initial read
      ** Include forecast transactions that are:
      ** live, Actual Amount = 0, Actual is Zero Flag = N, Projected on Retail = 'Y'
 
     C/exec SQL
     C+ declare CUR1 cursor for
     C+ select * from GLFORITD
     C+ where
     C+       IFRECI = 'D'  and
     C+       IFFACN <> ' ' and
     C+       IFACTL = 0    and
     C+       IFPROR = 'Y'  and
     C+       IFACZR = 'N'
     C+ order by
     C+       IFFACN
     C/end-exec
 
     C/exec SQL
     C+ open CUR1
     C/end-exec
 
      ** Handle SQL Error (if not %EOF)
 
     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBase = 3
     C                   EVAL      DBFile = 'SQL STM'
     C                   EVAL      DBKey = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C/exec SQL
     C+ fetch next
     C+ from CUR1
     C+ into :FORIT
     C/end-exec
 
      ** Read Individual forecast table until end of file
 
     C                   DOW       SQLCode <> 100
 
      ** Accumulate for this account
     C                   EVAL      CLFTBS = *ZEROS
     C                   EVAL      SVFACN = IFFACN
     C                   EVAL      WOnce =  'N'
 
     C                   DOW       IFFACN = SVFACN AND
     C                             SQLCode <> 100
 
      ** Access Account record
 
     C                   IF        WOnce =  'N'
     C                   EXSR      SRReadAcc
     C                   EVAL      WOnce =  'Y'
     C                   ENDIF
 
      ** Process Individual forecasts when needed
 
     C                   If        WProc =  'Y'
     C                   EXSR      SRProcFORI
     C                   End
 
     C/exec SQL
     C+ fetch next
     C+ from CUR1
     C+ into :FORIT
     C/end-exec
 
     C                   ENDDO
 
      ** Output to Total forecasts table if needed
 
     C                   If        WProc =  'Y'
     C                   EVAL      SVSQLCode = SQLCode
 
     C                   If        WFound =  'N'
     C                   EXSR      SROutTABF
     C                   Else
     C                   EXSR      SRUpdTABF
     C                   End
 
     C                   EVAL      SQLCode = SVSQLCode
     C                   End
 
     C                   ENDDO
 
      ** Handle SQL Error (if %EOF)
 
     C                   IF        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBase = 4
     C                   EVAL      DBFile = 'SQL STM'
     C                   EVAL      DBKey = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C/exec SQL
     C+ close CUR1
     C/end-exec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadAcc  - Access Account                                  *
      *                                                               *
      *****************************************************************
     C     SRReadAcc     BEGSR
 
     C                   EVAL      KAccnt = IFFACN
 
      * If the Retail account is not linked to a Facility do not process it
 
     C                   MOVE      KCNUM         @CUST             6
     C                   MOVE      KCCY          @CCY              3
     C                   MOVE      KACOD         @ACCD            10
     C                   MOVE      KACSQ         @ACSN             2
     C                   MOVE      KBRCA         @BRCA             3
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      *BLANKS       @ACNO            10
     C                   PARM                    @CUST
     C                   PARM                    @CCY
     C                   PARM                    @ACCD
     C                   PARM                    @ACSN
     C                   PARM                    @BRCA
     C     SDACCT        PARM      SDACCT        DSSDY
 
     C                   IF        PRTCD = *BLANKS and A_FCCU = *Blanks
     C                             and A_FACT = 0 and A_FCNO = 0
     C                             or  PRTCD <> *Blanks
     C                   Eval      WProc = 'N'
     C                   Else
 
     C                   Eval      WProc = 'Y'
 
     C                   EVAL      KkBrca = A_BRCA
     C                   EVAL      KkFCUS = A_FCCU
     C                   EVAL      KkFACT = A_FACT
     C                   EVAL      KkFCNO = A_FCNO
 
      * Retrieve Facility currency from FCLTYFM
 
     C/exec SQL
     C+ select
     C+       CNUM
     C+     , FACT
     C+     , FCNO
     C+     , FCCY
     C+ into
     C+       :CNUM
     C+     , :FACT
     C+     , :FCNO
     C+     , :FCCY
     C+ from FCLTYFM
     C+ where
     C+       CNUM = :KkFCUS and
     C+       FACT = :KkFACT and
     C+       FCNO = :KkFCNO
     C/end-exec
 
      * Retrieve Facility table from FCLTYFN
 
     C/exec SQL
     C+ select
     C+       CNUM
     C+     , FACT
     C+     , FCNO
     C+     , RUN0
     C+     , RUN1
     C+     , RUN2
     C+     , RUN3
     C+     , RUN4
     C+     , RUN5
     C+     , RUN6
     C+     , RUN7
     C+     , RUN8
     C+     , RUN9
     C+ into
     C+       :CNUM
     C+     , :FACT
     C+     , :FCNO
     C+     , :RUN0
     C+     , :RUN1
     C+     , :RUN2
     C+     , :RUN3
     C+     , :RUN4
     C+     , :RUN5
     C+     , :RUN6
     C+     , :RUN7
     C+     , :RUN8
     C+     , :RUN9
     C+ from FCLTYFN
     C+ where
     C+       CNUM = :KkFCUS and
     C+       FACT = :KkFACT and
     C+       FCNO = :KkFCNO
     C/end-exec
 
      * Retrieve GLFOCLTD record if already created for this facility
 
     C/exec SQL
     C+ select *
     C+ into: FOCL
     C+ from GLFOCLTD
     C+ where
     C+       CLBRCA = :KkBrca and
     C+       CLFCUS = :KkFCUS and
     C+       CLFACT = :KkFACT and
     C+       CLFCNO = :KkFCNO
     C/end-exec
 
      ** If record found in GLFOCLTD
 
     C                   IF        SQLCOD = 0
     C                   EVAL      WFound = 'Y'
 
      ** Set Forecast Amount in the table
 
     C                   EVAL      CLFTB0    = F_CLFTB0
     C                   EVAL      CLFTB1    = F_CLFTB1
     C                   EVAL      CLFTB2    = F_CLFTB2
     C                   EVAL      CLFTB3    = F_CLFTB3
     C                   EVAL      CLFTB4    = F_CLFTB4
     C                   EVAL      CLFTB5    = F_CLFTB5
     C                   EVAL      CLFTB6    = F_CLFTB6
     C                   EVAL      CLFTB7    = F_CLFTB7
     C                   EVAL      CLFTB8    = F_CLFTB8
     C                   EVAL      CLFTB9    = F_CLFTB9
 
     C                   ELSE
     C                   EVAL      WFound = 'N'
     C                   END
 
     C                   END
 
      ** Set Forecast Dates from Available balance dates
      ** only if Forecast is processed                                                      MD024191
     C                   If        WProc =  'Y'                                             MD024191
 
     C                   EVAL      X = 1
     C                   DOW       X <= 10
     C                   EVAL      CLDATS(X) = RUNS(X)
     C                   EVAL      X = X + 1
     C                   ENDDO
 
     C                   End                                                                MD024191
                                                                                            MD024191
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcFORI - Process individual forecasts                    *
      *                                                               *
      *****************************************************************
     C     SRPRocFORI    BEGSR
 
      ** Convert Forecast Amount to Facility Currency
 
     C                   IF        IFCCY <> FCCY
     C                   EXSR      SRConvert
     C                   ELSE
     C                   EVAL      WConvFAmt  = IFAMNT
     C                   ENDIF
 
      ** Compute for Forecast Total Available Balance
 
     C                   EXSR      SRForeBal
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvert - Convert Forecast Amount to Facility Currency     *
      *                                                               *
      *****************************************************************
     C     SRConvert     BEGSR
 
      ** Retrieve currency details for FROM currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      IFCCY         PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PrtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = IFCCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WFrXrate = A6SPRT
     C                   EVAL      WFrMDIn  = A6MDIN
     C                   EVAL      WFrDecPlace = A6NBDP
     C                   ENDIF
 
      ** Retrieve currency details for TO currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POPTN
     C                   PARM      FCCY          PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = FCCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WToXrate = A6SPRT                                        MD024013
     C                   EVAL      WToMDIn  = A6MDIN                                        MD024013
     C                   EVAL      WToDecPlace = A6NBDP
     C                   ENDIF
 
      *                                                                                     MD024013
     C                   Z-ADD     WFrXrate      ZRATE1                                     MD024013
     C                   MOVE      WFrMDIn       ZMDI1                                      MD024013
     C                   Z-ADD     WToXrate      ZRATE2                                     MD024013
     C                   MOVE      WToMDIn       ZMDI2                                      MD024013
     C                   CALL      'ZXRATE'                                                 MD024013
     C                   PARM                    ZRATE1                                     MD024013
     C                   PARM                    ZMDI1                                      MD024013
     C                   PARM                    ZRATE2                                     MD024013
     C                   PARM                    ZMDI2                                      MD024013
     C                   PARM                    ZRATEX                                     MD024013
     C                   PARM                    ZMDIX                                      MD024013
                                                                                            MD024013
     C                   Z-ADD     ZRATEX        ZEXCH                                      MD024013
     C                   MOVE      ZMDIX         ZMD                                        MD024013
                                                                                            MD024013
      ** Convert Forecast Amount
 
     C                   CALL      'ZCONVZ1'
     C                   PARM      IFAMNT        PAmnt
     C**********         PARM      WFrXRate      PFrXRate                                   MD024013
     C**********         PARM      WFrMDIn       PFrMDIn                                    MD024013
     C                   PARM                    Zexch                                      MD024013
     C                   PARM                    Zmd                                        MD024013
     C                   PARM      IFCCY         PFrCCY
     C                   PARM      FCCY          PToCCY
     C                   PARM      WFrDecPlace   PFrDecPlace
     C                   PARM      WToDecPlace   PToDecPlace
     C                   PARM                    POutAmt
 
     C                   EVAL      WConvFAmt = POutAmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRForeBal - Calculate Forecast Total Available Balance       *
      *                                                               *
      *****************************************************************
     C     SRForeBal     BEGSR
 
      ** Update Balances
 
     C                   EVAL      X = 1
 
     C                   DOW       X <= 10
 
     C                   IF        (IFDATE <= CLDATS(X)
     C                             AND WIncl = 'Y')
     C                             or (IFDATE <= CLDATS(X) and IFDATE >= BJRDNB
     C                             AND WIncl = 'N')
     C                   EXSR      SRCalFBal
     C                   ENDIF
 
     C                   ADD       1             X
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalFBal - Subroutine to Calculate Forecast Balance         *
      *                                                               *
      *****************************************************************
     C     SRCalFBal     BEGSR
 
      ** If the feature CLE025 is on and Include Net CR = 'N', then omit Credit
      ** Forecast (i.e positive amount)
 
     C                   IF        CLE025 = 'Y' and WNetCR = 'N'
     C                             and WConvFAmt > 0
     C                   LEAVESR
     C                   END
 
      ** Update Forecast Balances
     C                   EVAL      CLFTBS(X)  = CLFTBS(X)  + WConvFAmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROutTABF - Subroutine to output to Total Forecasts table    *
      *                                                               *
      *****************************************************************
     C     SROutTABF     BEGSR
 
     C/exec SQL
     C+ insert into GLFOCLTD
     C+    ( CLBRCA
     C+     ,CLFCUS
     C+     ,CLFACT
     C+     ,CLFCNO
     C+     ,CLDAT0
     C+     ,CLDAT1
     C+     ,CLDAT2
     C+     ,CLDAT3
     C+     ,CLDAT4
     C+     ,CLDAT5
     C+     ,CLDAT6
     C+     ,CLDAT7
     C+     ,CLDAT8
     C+     ,CLDAT9
     C+     ,CLFTB0
     C+     ,CLFTB1
     C+     ,CLFTB2
     C+     ,CLFTB3
     C+     ,CLFTB4
     C+     ,CLFTB5
     C+     ,CLFTB6
     C+     ,CLFTB7
     C+     ,CLFTB8
     C+     ,CLFTB9)
     C+ values
     C+    ( :KkBrca
     C+     ,:KkFCUS
     C+     ,:KkFACT
     C+     ,:KkFCNO
     C+     ,:CLDAT0
     C+     ,:CLDAT1
     C+     ,:CLDAT2
     C+     ,:CLDAT3
     C+     ,:CLDAT4
     C+     ,:CLDAT5
     C+     ,:CLDAT6
     C+     ,:CLDAT7
     C+     ,:CLDAT8
     C+     ,:CLDAT9
     C+     ,:CLFTB0
     C+     ,:CLFTB1
     C+     ,:CLFTB2
     C+     ,:CLFTB3
     C+     ,:CLFTB4
     C+     ,:CLFTB5
     C+     ,:CLFTB6
     C+     ,:CLFTB7
     C+     ,:CLFTB8
     C+     ,:CLFTB9 )
     C/end-exec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdTABF - Subroutine to update to Credit Line Forecasts table
      *                                                               *
      *****************************************************************
     C     SRUpdTABF     BEGSR
 
     C/exec SQL
     C+ update GLFOCLTD set
     C+    ( CLBRCA
     C+     ,CLFCUS
     C+     ,CLFACT
     C+     ,CLFCNO
     C+     ,CLDAT0
     C+     ,CLDAT1
     C+     ,CLDAT2
     C+     ,CLDAT3
     C+     ,CLDAT4
     C+     ,CLDAT5
     C+     ,CLDAT6
     C+     ,CLDAT7
     C+     ,CLDAT8
     C+     ,CLDAT9
     C+     ,CLFTB0
     C+     ,CLFTB1
     C+     ,CLFTB2
     C+     ,CLFTB3
     C+     ,CLFTB4
     C+     ,CLFTB5
     C+     ,CLFTB6
     C+     ,CLFTB7
     C+     ,CLFTB8
     C+     ,CLFTB9)
     C+ =
     C+    ( :KkBrca
     C+     ,:KkFCUS
     C+     ,:KkFACT
     C+     ,:KkFCNO
     C+     ,:CLDAT0
     C+     ,:CLDAT1
     C+     ,:CLDAT2
     C+     ,:CLDAT3
     C+     ,:CLDAT4
     C+     ,:CLDAT5
     C+     ,:CLDAT6
     C+     ,:CLDAT7
     C+     ,:CLDAT8
     C+     ,:CLDAT9
     C+     ,:CLFTB0
     C+     ,:CLFTB1
     C+     ,:CLFTB2
     C+     ,:CLFTB3
     C+     ,:CLFTB4
     C+     ,:CLFTB5
     C+     ,:CLFTB6
     C+     ,:CLFTB7
     C+     ,:CLFTB8
     C+     ,:CLFTB9 )
     C+ where CLBRCA = :KkBrca and
     C+ CLFCUS = :KkFcus  and
     C+ CLFACT = :KkFact and
     C+ CLFCNO = :KkFcno
     C/end-exec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Set off program indicators
 
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Establish switchable features
 
     C                   MOVE      'N'           CLE025            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CLE025'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE025
     C                   EVAL      PSysVal(2) = 'ForecastAppyNetForCL'
     C                   END
 
     C                   EVAL      PSysVal(1) = 'ForecastIncUnmatched'
 
      ** Retrieve System Values
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PSysVal(1)
     C                   PARM                    PCurSet(1)
     C                   PARM                    PSysVal(2)
     C                   PARM                    PCurSet(2)
     C                   PARM                    PSysVal(3)
     C                   PARM                    PCurSet(3)
     C                   PARM                    PSysVal(4)
     C                   PARM                    PCurSet(4)
     C                   PARM                    PSysVal(5)
     C                   PARM                    PCurSet(5)
     C                   PARM                    PSysVal(6)
     C                   PARM                    PCurSet(6)
     C                   PARM                    PSysVal(7)
     C                   PARM                    PCurSet(7)
     C                   PARM                    PSysVal(8)
     C                   PARM                    PCurSet(8)
     C                   PARM                    PSysVal(9)
     C                   PARM                    PCurSet(9)
     C                   PARM                    PSysVal(10)
     C                   PARM                    PCurSet(10)
 
      ** Check if database error occured
 
     C                   FOR       X = 1 TO 10
 
     C                   IF        PCurSet(X) = '*NRF' OR
     C                             PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey   = PSysVal(X)
     C                   EVAL      DBFile  = 'SDSVALPD'
     C                   EVAL      DBase   = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   EVAL      WIncl = PCurSet(1)
 
     C                   IF        CLE025 = 'Y'
     C                   EVAL      WNetCR = PCurSet(2)
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   EVAL      PRtCd = '*ERROR'
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2013
