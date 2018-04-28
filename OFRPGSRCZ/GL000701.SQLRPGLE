     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Forecast Credit Line Avail Bal Calc - I/C')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000701 - Midas OF Forecast Credit Line Available Balance   *
      *             Calculation - Input cycle                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL153             Date 05Feb14               *
      *  Prev Amend No. MD024086           Date 13Dec13               *
      *                 MD024013           Date 12Dec13               *
      *                 MD023902           Date 03Dec13               *
      *                 CGL145B  *Create   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL153 - Bank Position Report                                *
      *  MD024086 - 'Actual is zero' not tested                       *
      *  MD024013 - Conversion rate not correct                       *
      *  MD023902 - Issue on Credit Line Balance with Project on      *
      *             Retail set to N                                   *
      *  CGL145B - Subsidiaries Daily Sweeping Forecast               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFCLTY1    IF   E           K DISK
 
     FGLFOCLI0  UF A E           K DISK
      ** Midas OF Forecast Credit line Available Balance
 
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
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A_)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
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
     D  RUNS                   1     30P 0
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
 
     D Param           DS
     D  PActCode               1      1
     D  PStatus                2     11
     D  PBranch               12     14
     D  PCust                 15     20
     D  PCurr                 21     23
     D  PACODX                24     33
     D  PACSQX                34     35
     D  PFCurr                36     38
     D  PFDateX               39     43
     D  PFAmtX                44     58
     D  PAAmtX                59     73
     D  PAAZero               74     74
     D  PAProjRet             75     75
     D  POFAmtX               76     90
     D  POAAmtX               91    105
     D  POAZero              106    106
     D  POProjRet            107    107
     D  PNostroCode          108    109                                                       CGL153
     D  PAProjNos            110    110                                                       CGL153
     D  POProjNos            111    111                                                       CGL153
     D**Filler**             108    500                                                       CGL153
     D  Filler               112    500                                                       CGL153
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
     D X               S              2  0
     D WRun            S              1A   Inz
     D NETCR           S              1A
     D KkBrca          S              3A
     D KkFcus          S              6A
     D KkFact          S              3  0
     D KkFcno          S              2  0
     D PFDate          S              5  0 INZ(0)
     D PFAmt           S             15  0 INZ(0)
     D PAAmt           S             15  0 INZ(0)
     D PAcod           S             10  0 INZ(0)
     D PAcsq           S              2  0 INZ(0)
     D POFAmt          S             15  0 INZ(0)
     D POAAmt          S             15  0 INZ(0)
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Check Transaction Received
 
     C                   EXSR      SRCheck
 
      ** End Program
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *                                                               *
      *  SRCheck - Check Transaction Received                         *
      *                                                               *
      *****************************************************************
     C     SRCheck       BEGSR
 
      ** Convert only if amounts passed are non blanks
 
     C                   IF        PFDatex <> *Blanks
     C                   EVAL      PFDate = %Dec(%Trim(PFDatex):5:0)
     C                   ENDIF
 
     C                   IF        PFAmtX <> *Blanks
     C                   EVAL      PFAmt = %Dec(%Trim(PFAmtX):15:0)
     C                   ENDIF
 
     C                   IF        PAAmtX <> *Blanks
     C                   EVAL      PAAmt = %Dec(%Trim(PAAmtX):15:0)
     C                   ENDIF
 
     C                   IF        PAcodX <> *Blanks
     C                   EVAL      PAcod = %Dec(%Trim(PAcodX):10:0)
     C                   ENDIF
 
     C                   IF        PacsqX <> *Blanks
     C                   EVAL      Pacsq = %Dec(%Trim(PacsqX):2:0)
     C                   ENDIF
 
     C                   IF        POFAmtX <> *Blanks
     C                   EVAL      POFAmt = %Dec(%Trim(POFAmtX):15:0)
     C                   ENDIF
 
     C                   IF        POAAmtX <> *Blanks
     C                   EVAL      POAAmt = %Dec(%Trim(POAAmtX):15:0)
     C                   ENDIF
 
      * Verify that the transaction received must be processed
 
      *If CLE025 is on and
      *If the system value Forecast Net Credit is 'N' and
      *Insert mode
      *=> omit Credit Forecast (i.e positive Forecast amount)
      *
     C                   IF        CLE025 = 'Y' and NETCR = 'N'
     C                             and PActCode = 'I' and PFAmt > 0
     C                   LEAVESR
     C                   ENDIF
                                                                                            MD023902
      ** If Insert mode and Projected on Retail = 'N'                                       MD023902
      ** or Delete mode and Projected on Retail = 'N'                                       MD023902
      ** => omit Forecast                                                                   MD023902
      *                                                                                     MD023902
     C                   If        PActCode = 'I' and PAProjRet <> 'Y'                      MD023902
     C                             or PActCode = 'D' and PAProjRet <> 'Y'                   MD023902
     C                   LEAVESR                                                            MD023902
     C                   ENDIF                                                              MD023902
 
     C                   EVAL      KBrca  = PBranch
     C                   EVAL      KCnum  = PCust
     C                   EVAL      KCcy   = PCurr
     C                   EVAL      KAcod  = PAcod
     C                   EVAL      KAcsq  = PAcsq
 
      * If the Retail account is not linked to a Facility leave program
 
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
     C                   LEAVESR
     C                   Else
 
     C                   EVAL      KkBrca = A_BRCA
     C                   EVAL      KkFCUS = A_FCCU
     C                   EVAL      KkFACT = A_FACT
     C                   EVAL      KkFCNO = A_FCNO
 
      * Retrieve Facility currency
 
     C     KkFac         CHAIN     FCLTY1
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   Movel     KkFact        DBKey
     C                   EVAL      DBFile = 'FCLTY1 '
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Access the Forecast Credit line Available balance file
 
     C     KkFor         CHAIN     GLFOCLI0
 
     C                   IF        NOT%FOUND
 
      ** Set Total Credit line Available Amount to zero
 
     C                   EVAL      CLFTBS = *ZEROS
 
      ** Set Total Credit line Dates from Facility file dates
 
     C                   EVAL      X = 1
     C                   DOW       X <= 10
     C                   EVAL      CLDATS(X) = RUNS(X)
     C                   EVAL      X = X + 1
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Convert amount if Forecast Currency if not equal
      ** to Facility Currency
 
     C                   IF        FCCY <> PFCurr
     C                   EXSR      SRConvert
     C                   ELSE
     C                   EVAL      WConvFAmt  = PFAmt
     C                   EVAL      WConvOFAmt = POFAmt
     C                   ENDIF
 
      ** Compute for Forecast Total Available Balance
 
     C                   EXSR      SRForeBal
 
      ** Update file
 
     C                   IF        %FOUND
     C                   UPDATE    GLFOCLD0
     C                   ELSE
 
      ** Set up file fields
 
     C                   EXSR      SRField
 
     C                   WRITE     GLFOCLD0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRField   - Set up file fields
      *                                                               *
      *****************************************************************
     C     SRField       BEGSR
 
     C                   EVAL      CLBRCA = KkBrca
     C                   EVAL      CLFCUS = KkFcus
     C                   EVAL      CLFACT = KkFact
     C                   EVAL      CLFCNO = KkFcno
 
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
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      PFCurr        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PFCurr
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WFrXrate = A6SPRT
     C                   EVAL      WFrMDIn  = A6MDIN
     C                   EVAL      WFrDecPlace = A6NBDP
     C                   ENDIF
 
      ** Retrieve currency details for TO   currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      FCCY          PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = FCCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 005
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
 
      ** Convert Forecast Amount
 
     C                   CALL      'ZCONVZ1'
     C                   PARM      PFAmt         PAmnt
     C**********         PARM      WFrXRate      PFrXRate                                   MD024013
     C**********         PARM      WFrMDIn       PFrMDIn                                    MD024013
     C                   PARM                    Zexch                                      MD024013
     C                   PARM                    Zmd                                        MD024013
     C                   PARM      PFCurr        PFrCCY
     C                   PARM      FCCY          PToCCY
     C                   PARM      WFrDecPlace   PFrDecPlace
     C                   PARM      WToDecPlace   PToDecPlace
     C                   PARM                    POutAmt
 
     C                   EVAL      WConvFAmt = POutAmt
 
      ** Convert Original Forecast Amount
 
     C                   CALL      'ZCONVZ1'
     C                   PARM      POFAmt        PAmnt
     C**********         PARM      WFrXRate      PFrXRate                                   MD024013
     C**********         PARM      WFrMDIn       PFrMDIn                                    MD024013
     C                   PARM                    Zexch                                      MD024013
     C                   PARM                    Zmd                                        MD024013
     C                   PARM      PFCurr        PFrCCY
     C                   PARM      FCCY          PToCCY
     C                   PARM      WFrDecPlace   PFrDecPlace
     C                   PARM      WToDecPlace   PToDecPlace
     C                   PARM                    POutAmt
 
     C                   EVAL      WConvOFAmt = POutAmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRForeBal - Calculate the Forecast Total Balance             *
      *                                                               *
      *****************************************************************
     C     SRForeBal     BEGSR
 
      ** Update Balances
 
     C                   EVAL      X = 1
 
     C                   DOW       X <= 10
 
     C                   IF        PFDate <= CLDATS(X)
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
 
      ** Update Forecast Balance for Debit Transaction on WIP or
      ** Credit Transaction on Authorise or
      ** Rejected Debit Transactions
 
      *If CLE025 is on and
      *If the system value Forecast Net Credit is 'N'
      *=> omit Credit Forecast (i.e positive Forecast amount)
      *
     C                   IF        CLE025 = 'Y' and NETCR = 'N'
     C                             and PFAmt > 0
     C                   EVAL      WConvFAmt = 0
     C                   ENDIF
 
     C                   IF        PStatus = 'COMPLETE' AND PFAmt < 0
     C                             OR PStatus = 'AUTHORISE' AND PFAmt > 0
 
     C                   SELECT
 
      ** On Insert: add up the forecast amount
 
     C                   WHEN      PActCode = 'I'
     C                   IF        PAAmt = *Zero
     C                             AND PAAZero <> 'Y'                                       MD024086
     C                   EVAL      CLFTBS(X)  = CLFTBS(X)  + WConvFAmt
     C                   ENDIF
 
      ** On Amend:
      ** If forecast amount was changed remove the original forecast amount
      **    and add the new forcast amount
      ** If Actual Amount is changed OR Project on Retail flag is changed
      **    from 'Y' to 'N', reduce the original forecast amount
      ** If Project on Retail flag is changed from 'N' to 'Y', add forecast
      **    amount
 
     C                   WHEN      PActCode = 'A'
 
     C                   IF        PAAmt = *ZERO and POAAmt = *ZERO
     C                             AND PAProjRet = 'Y'                                      MD023902
     C                             AND PAAZero <> 'Y'                                       MD024086
     C                   EVAL      CLFTBS(X)  = CLFTBS(X)  + WConvFAmt
     C                   END                                                                MD023902
     C                   IF        POAAmt = *ZERO AND POProjRet = 'Y'                       MD023902
     C                   EVAL      CLFTBS(X)  = CLFTBS(X) - WConvOFAmt
     C                   ENDIF
     C**********         IF        PAAmt <> *ZERO and POAAmt = *ZERO                        MD023902
     C**********                   OR PAProjRet = 'N' AND POProjRet = 'Y'                   MD023902
     C**********         EVAL      CLFTBS(X)  = CLFTBS(X) - WConvOFAmt                      MD023902
     C**********         ENDIF                                                              MD023902
     C**********         IF        PAProjRet = 'Y' AND POProjRet = 'N'                      MD023902
     C**********         EVAL      CLFTBS(X)  = CLFTBS(X)  + WConvFAmt                      MD023902
     C**********         ENDIF                                                              MD023902
 
      ** On delete: reduce the forecast amount
 
     C                   WHEN      PActCode = 'D'
     C                   IF        PAAmt = *Zero
     C                   EVAL      CLFTBS(X)  = CLFTBS(X)  - WConvFAmt
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
      ** Update Forecast Balance when transaction if rejected
 
     C                   IF        PStatus = 'REJECT' AND PFAmt < 0
     C                   IF        PActCode = 'I' OR PActCode = 'A'
     C                   EVAL      CLFTBS(X)  = CLFTBS(X)  - WConvFAmt
     C                   ELSE
     C                   EVAL      CLFTBS(X)  = CLFTBS(X)  + WConvFAmt
     C                   ENDIF
     C                   IF        PActCode = 'A'
     C                   EVAL      CLFTBS(X)  = CLFTBS(X)  + WConvOFAmt
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Input Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    Param
 
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
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Establish switchable features
      *
     C                   MOVE      'N'           CLE025            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CLE025'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE025
     C                   EVAL      PSysVal(1) = 'ForecastAppyNetForCL'
 
      ** Retrieve System Values
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD
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
 
     C                   IF        PCurSet(X) = '*NRF'
     C                                      OR
     C                             PRTCD <> *BLANKS
     C                               AND PRTCD <> '*NRF'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY   = PSysVal(X)
     C                   EVAL      DBFILE  = 'SDSVALPD'
     C                   EVAL      DBASE   = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   EVAL      NETCR = PCurSet(1)
     C                   ENDIF
 
     C     KkFac         KLIST
     C                   KFLD                    KkBrca
     C                   KFLD                    KkFcus
     C                   KFLD                    KkFact
     C                   KFLD                    KkFcno
 
     C     KkFor         KLIST
     C                   KFLD                    KkBrca
     C                   KFLD                    KkFcus
     C                   KFLD                    KkFact
     C                   KFLD                    KkFcno
 
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
     C                   EVAL      PRTCD = '*ERROR'
 
     C                   RETURN
 
     C                   ENDSR
