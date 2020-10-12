     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Bank Position COB Report')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000596P - Midas OF Bank Position COB Report                *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD034975           Date 23Oct15               *
      *                 CGL176             Date 05Aug15               *
      *                 MD031573           Date 11Dec14               *
      *                 CGL159             Date 27Aug14               *
      *                 MD027241           Date 29May14               *
      *                 MD027156           Date 23May14               *
      *                 MD026777           Date 14May14               *
      *                 MD026759           Date 14May14               *
      *                 MD026756           Date 09May14               *
      *                 CGL153   *Create   Date 14Feb14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      * MD034975 - Bank position report not reflecting future or today*
      *            mvmts for transit accounts.                        *
      *  CGL176 - Optimisation of Nostro Balances by Company          *
      *  MD031573 - Change Ledger Balance to Cleared Balance          *
      *  CGL159 - Optimisation of Cash Positions                      *
      *  MD027241 - Report should not show sub total for nostros not  *
      *             in a pool.                                        *
      *  MD027156 - GLC000596 component is looping. Overflow error.   *
      *  MD026777 - Pools are not displayed in the report             *
      *  MD026759 - Incorrect column headers in the Bank Position COB *
      *             Report (Recompile)                                *
      *  MD026756 - Estimated Exchange Rate not correct               *
      *  CGL153 - Bank Position Report                                *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas OF Foreacast Audit/List report - Detail
     FGL000596P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN                                           CGL176

      ** Midas OF Foreacast Audit/List report - Audit
     FGL000596AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A_)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CGL159
     ** External DS for SAR Details                                                           CGL159
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL159

     ** File DS
                                                                                              CGL159
     D BPOW          E DS                  EXTNAME(SDNOSTW0)                                  CGL159
     D SDEX          E DS                  EXTNAME(SDEXRTTD)                                  CGL159
     D                                     PREFIX(S)                                          CGL159

     D*BPOW*****     E DS                  EXTNAME(SDBPOWTD)                                  CGL159
     D*NOS2*****     E DS                  EXTNAME(SDNOST2D)                                  CGL159
     D*EERT*****     E DS                  EXTNAME(SDEERTTD)                                  CGL159
     D*TNOS*****     E DS                  EXTNAME(GLTNOSTD)                                  CGL159
     D*NOST*****     E DS                  EXTNAME(SDNOSTPD)                                  CGL159


      ** File Information Data Structure for GL000596P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for GL000591AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
                                                                                              CGL159
      ** Nostro Code                                                                          CGL159
     D NOSVAR          DS                                                                     CGL159
     D  NOSNUM                 4      5                                                       CGL159

     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PSARD           S              6

      ***Parameter*variables*for*AOSVALR0*string***********************                       CGL159
     D*SVALK1***       S             20                                                       CGL159
     D*SVAL1****       S            200                                                       CGL159
     D*SVALK2***       S             20                                                       CGL159
     D*SVAL2****       S            200                                                       CGL159
     D*SVALK3***       S             20                                                       CGL159
     D*SVAL3****       S            200                                                       CGL159
     D*SVALK4***       S             20                                                       CGL159
     D*SVAL4****       S            200                                                       CGL159
     D*SVALK5***       S             20                                                       CGL159
     D*SVAL5****       S            200                                                       CGL159
     D*SVALK6***       S             20                                                       CGL159
     D*SVAL6****       S            200                                                       CGL159
     D*SVALK7***       S             20                                                       CGL159
     D*SVAL7****       S            200                                                       CGL159
     D*SVALK8***       S             20                                                       CGL159
     D*SVAL8****       S            200                                                       CGL159
     D*SVALK9***       S             20                                                       CGL159
     D*SVAL9****       S            200                                                       CGL159
     D*SVALK0***       S             20                                                       CGL159
     D*SVAL10***       S            200                                                       CGL159

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3

      ** Other fields used
     D WRun            S              1A   Inz
     D WRecNo          S              7S 0 Inz
     D RqdLn1          S              3  0
     D DifLn1          S              4  0

     D WField          S             21A
     D PEdtCode        S              1A
     D*PNB0*****       S             15P 0                                                    CGL159
     D PCCY            S              3A
     D*PBRCA****       S              3A                                                      CGL159
     D*PACCD****       S             10A                                                      CGL159
     D*PACNO****       S             10A                                                      CGL159
     D*PCUST****       S              6A                                                      CGL159
     D*PACSN****       S              2A                                                      CGL159
     D PDecPlace       S              1  0
     D WAmount         S             15  0
     D WAmount2        S             15  0
     D WPrvPool        S             10
     D*WADDAMT**       S             13P 0                                                    CGL159
     D WSubTot         S             16P 0
     D WTotal          S             17P 0
     D WPDBASE         S             17P 0
     D*WA6NBDP**       S              1P 0                                                    CGL159
     D*WPOOL****       S             10                                                       CGL159
     D*WA7ACSN**       S              2                                                       CGL159
     D*WBJRDNB**       S             15                                                       CGL159
     D*WNONB****       S              2P 0                                                    CGL159
     D*WBRANCH**       S              3                                                       CGL159
     D*W_LDBL***       S             15P 0                                                    CGL159
     D*W_ANAM***       S             20                                                       CGL159
     D*W_ZONE***       S             10                                                       CGL159
     D*InputAmnt       S             15  0                                                    CGL159
     D*ExchRate*       S             13  8                                                    CGL159
     D*MultDivInd      S              1                                                       CGL159
     D*FrCurrency      S              3                                                       CGL159
     D*ToCurrency      S              3                                                       CGL159
     D*FrDecPlace      S              1  0                                                    CGL159
     D*ToDecPlace      S              1  0                                                    CGL159
     D*OutputAmnt      S             15  0                                                    CGL159

     D*sqlString       S          32000A   Varying                                            CGL159
     D**********                           Inz                                                CGL159
                                                                                              CGL159
      ** Base CCY details                                                                     CGL159
     D BA6CYCD         S              3A                                                      CGL159
     D BA6SPRT         S             13S 8                                                    CGL159
     D BA6NBDP         S              1S 0                                                    CGL159
     D BA6MDIN         S              1A                                                      CGL159
                                                                                              CGL159
      ** Pivot CCY details                                                                    CGL159
     D PA6CYCD         S              3A                                                      CGL159
     D PA6SPRT         S             13S 8                                                    CGL159
     D PA6NBDP         S              1S 0                                                    CGL159
     D PA6MDIN         S              1A                                                      CGL159
                                                                                              CGL159
      ** Nostro CCY details                                                                   CGL159
     D DA6CYCD         S              3A                                                      CGL159
     D DA6SPRT         S             13S 8                                                    CGL159
     D DA6NBDP         S              1S 0                                                    CGL159
     D DA6MDIN         S              1A                                                      CGL159
                                                                                              CGL159
      ** Parameters for ZCCYCN                                                                CGL159
     D PaSpRt1         S             13  8                                                    CGL159
     D PaSpRt2         S             13  8                                                    CGL159
     D WkRate          S             13  8                                                    CGL159
     D WkMDIn          S              1                                                       CGL159
     D PaMDIn1         S              1                                                       CGL159
     D PaMDIn2         S              1                                                       CGL159
                                                                                              CGL159
      ** Parameters for ZCONVZ1                                                               CGL159
     D InputAmnt       S             15  0                                                    CGL159
     D ExchRate        S             13  8                                                    CGL159
     D MultDivInd      S              1                                                       CGL159
     D FrCurrency      S              3                                                       CGL159
     D ToCurrency      S              3                                                       CGL159
     D FrDecPlace      S              1  0                                                    CGL159
     D ToDecPlace      S              1  0                                                    CGL159
     D OutputAmnt      S             15  0                                                    CGL159
                                                                                              CGL159
      ** Working variables for CGL159                                                         CGL159
     D WPDPIVOT        S             17P 0                                                    CGL159
     D WPrvPCCY        S              3                                                       CGL159
     D WPrvMDIN        S              1                                                       CGL159
     D WPrvSPRT        S             13S 8                                                    CGL159
     D WPrvNBDP        S              1S 0                                                    CGL159
     D SQLTEMP         S              3S 0                                                    CGL159
                                                                                              CGL159
     D EXCHANGE1       S             13S 8                                                    CGL159
     D MDINDCTR1       S              1A                                                      CGL159
     D EXCHANGE2       S             13S 8                                                    CGL159
     D MDINDCTR2       S              1A                                                      CGL159
                                                                                              CGL159
     D TEMPACCT        S             10A                                                      CGL159
     D TEMPACSQ        S              2A                                                      CGL159
     D HEADVAR         S              1A                                                      CGL159
     D CGL159          S              1A                                                      CGL159
                                                                                              CGL159
     D CGL176          S              1                                                       CGL176

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

                                                                                              CGL159
     C                   EXSR      SELSQLRTN                                                  CGL159
                                                                                              CGL159
     C**********         IF        CGL159 = 'Y'                                        CGL159 CGL176
     C                   SELECT                                                               CGL176
     C                   WHEN      CGL159 = 'Y' AND CGL176 = 'N'                              CGL176
     C/exec SQL                                                                               CGL159
     C+ open LISTA                                                                            CGL159
     C/end-exec                                                                               CGL159
     C**********         ELSE                                                          CGL159 CGL176
     C                   WHEN      CGL176 = 'Y'                                               CGL176
     C/exec SQL                                                                               CGL176
     C+ open LISTC                                                                            CGL176
     C/end-exec                                                                               CGL176
     C                   OTHER                                                                CGL176
     C/exec SQL                                                                               CGL159
     C+ open LISTB                                                                            CGL159
     C/end-exec                                                                               CGL159
     C**********         ENDIF                                                         CGL159 CGL176
     C                   ENDSL                                                                CGL176
                                                                                              CGL159
      ** Handle SQL Error (if not %EOF)                                                       CGL159
                                                                                              CGL159
     C                   EVAL      SQLTEMP = SQLCOD                                           CGL159
     C                   If        SQLTEMP < 0                                                CGL159
                                                                                              CGL159
     C     *LOCK         IN        LDA                                                        CGL159
     C                   EVAL      DBASE = 002                                                CGL159
     C                   EVAL      DBFILE = 'SQL STM'                                         CGL159
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                               CGL159
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                     CGL159
     C                   OUT       LDA                                                        CGL159
     C                   EXSR      *PSSR                                                      CGL159
                                                                                              CGL159
     C                   EndIf                                                                CGL159
                                                                                              CGL159
     C**********         IF        CGl159 = 'Y'                                        CGL159 CGL176
     C                   SELECT                                                               CGL176
     C                   WHEN      CGL159 = 'Y' AND CGL176 = 'N'                              CGL176
     C/exec SQL                                                                               CGL159
     C+ fetch next                                                                            CGL159
     C+ from LISTA                                                                            CGL159
     C+ into :BPOW                                                                            CGL159
     C/end-exec                                                                               CGL159
     C**********         ELSE                                                          CGL159 CGL176
     C                   WHEN      CGL176 = 'Y'                                               CGL176
     C/exec SQL                                                                               CGL176
     C+ fetch next                                                                            CGL176
     C+ from LISTC                                                                            CGL176
     C+ into :BPOW                                                                            CGL176
     C/end-exec                                                                               CGL176
     C                   OTHER                                                                CGL176
     C/exec SQL                                                                               CGL159
     C+ fetch next                                                                            CGL159
     C+ from LISTB                                                                            CGL159
     C+ into :BPOW                                                                            CGL159
     C/end-exec                                                                               CGL159
     C**********         ENDIF                                                         CGL159 CGL176
     C                   ENDSL                                                                CGL176
                                                                                              CGL159
      ** Bank Position details                                                                CGL159
                                                                                              CGL159
     C                   EVAL      WPrvPool = *BLANKS                                         CGL159
     C                   EVAL      WPrvPCCY = *BLANKS                                         CGL159
     C                   EVAL      WPrvMDIN = *BLANKS                                         CGL159
     C                   EVAL      WPrvSPRT = 0                                               CGL159
     C                   EVAL      WPrvNBDP = 0                                               CGL159
     C                   EVAL      WTotal  = 0                                                CGL159
     C                   EVAL      HEADVAR = 'N'                                              CGL159
     C                   Z-ADD     0             WPDBASE                                      CGL159
     C                   Z-ADD     0             WPDPIVOT                                     CGL159
                                                                                              CGL159
     C                   EVAL      SQLTEMP = SQLCOD                                           CGL176
     C                   DOW       SQLTEMP <> 100                                             CGL159
                                                                                              CGL159
     C                   IF        NOT %OPEN(GL000596P1)                                      CGL176
     C                   OPEN      GL000596P1                                                 CGL176
      ** Ensure Detail Spool File recorded by RCF.                                            CGL176
                                                                                              CGL176
     C                   EVAL      ZSnum = SFNUM1                                             CGL176
                                                                                              CGL176
     C                   CALL      'ZSFILE'                                                   CGL176
     C                   PARM                    PSeq                                         CGL176
     C                   PARM      *Blanks       SEnty                                        CGL176
     C                   PARM                    SFILE1                                       CGL176
     C                   PARM                    ZSnum                                        CGL176
     C                   PARM      *Blanks       ZSerr                                        CGL176

     C                   IF        ZSErr = 'Y'                                                CGL176
     C                   EVAL      *INU7 = *On                                                CGL176
     C                   EVAL      *INU8 = *On                                                CGL176
     C                   EVAL      *INLR = *On                                                CGL176
     C                   RETURN                                                               CGL176
     C                   ENDIF                                                                CGL176
     C                   ENDIF                                                                CGL176
      ** Count                                                                                CGL159
                                                                                              CGL159
     C                   EVAL      WRecNo = WRecNo + 1                                        CGL159
                                                                                              CGL159
      ** Get PIVOT CCY Details                                                                CGL159
     C                   IF        P1PCCY <> *BLANKS                                          CGL159
     C                   EVAL      PCCY = P1PCCY                                              CGL159
     C                   EXSR      GetCurrDtls                                                CGL159
     C                   EVAL      PA6CYCD  =   A6CYCD                                        CGL159
     C                   EVAL      PA6SPRT  =   A6SPRT                                        CGL159
     C                   EVAL      PA6NBDP  =   A6NBDP                                        CGL159
     C                   EVAL      PA6MDIN  =   A6MDIN                                        CGL159
     C                   ELSE                                                                 CGL159
     C                   EVAL      PA6CYCD  =   BA6CYCD                                       CGL159
     C                   EVAL      PA6SPRT  =   BA6SPRT                                       CGL159
     C                   EVAL      PA6NBDP  =   BA6NBDP                                       CGL159
     C                   EVAL      PA6MDIN  =   BA6MDIN                                       CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
      ** Get DETAIL CCY Details                                                               CGL159
     C                   EVAL      PCCY = NOSRCCRY                                            CGL159
     C                   EXSR      GetCurrDtls                                                CGL159
     C                   EVAL      DA6CYCD  =   A6CYCD                                        CGL159
     C                   EVAL      DA6SPRT  =   A6SPRT                                        CGL159
     C                   EVAL      DA6NBDP  =   A6NBDP                                        CGL159
     C                   EVAL      DA6MDIN  =   A6MDIN                                        CGL159
                                                                                              CGL159
                                                                                              CGL159
      ** Account Number                                                                       CGL159
                                                                                              CGL159
     C                   EVAL      TEMPACCT = *BLANKS                                         CGL159
     C                   EVAL      TEMPACSQ = *BLANKS                                         CGL159
                                                                                              CGL159
     C                   IF        ATYP = 'R' AND ACNO <> *ZEROS                              CGL159
     C                   MOVE      ACNO          TEMPACCT                                     CGL159
     C                   EVAL      PDACCT = TEMPACCT                                          CGL159
                                                                                              CGL159
     C                   ELSE                                                                 CGL159
     C                   MOVE      ACOD          TEMPACCT                                     CGL159
     C                   MOVE      ACSQ          TEMPACSQ                                     CGL159
                                                                                              CGL159
     C                   EVAL      PDACCT = BRCA + CNUM + CCY + TEMPACCT +                    CGL159
     C                                      TEMPACSQ                                          CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
      ** Ledger Balance                                                                       CGL159
                                                                                              CGL159
     C                   EVAL      WField = *BLANKS                                           CGL159
     C                   EVAL      WAmount = *Zeros                                           CGL159
     C                   EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount = LEDGER_BAL                              CGL159 MD031573
     C                   EVAL      WAmount = CLEAR00001                                     MD031573
     C                   EVAL      PDecPlace = DA6NBDP                                        CGL159
     C                   EXSR      FormatAmount                                               CGL159
     C                   MOVE      WField        PDCLBL                                       CGL159
                                                                                              CGL159
      ** Forecast Balance                                                                     CGL159
                                                                                              CGL159
     C                   EVAL      WField = *BLANKS                                           CGL159
     C                   EVAL      WAmount = *Zeros                                           CGL159
     C                   EVAL      PDecPlace = *Zeros                                         CGL159
     C                   EVAL      WAmount = NCAMT0                                           CGL159
     C                   EVAL      PDecPlace = DA6NBDP                                        CGL159
     C                   EXSR      FormatAmount                                               CGL159
     C                   MOVE      WField        PDFAMT                                       CGL159
                                                                                              CGL159
      ** Projected Balance                                                                    CGL159
                                                                                              CGL159
     C                   EVAL      WField = *BLANKS                                           CGL159
     C                   EVAL      WAmount = *Zeros                                           CGL159
     C                   EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount = PNB0 - LEDGER_BAL                       CGL159 MD031573
     C                   EVAL      WAmount = PNB0 - CLEAR00001                              MD031573
     C                   EVAL      PDecPlace = DA6NBDP                                        CGL159
     C                   EXSR      FormatAmount                                               CGL159
     C                   MOVE      WField        PDPAMT                                       CGL159
                                                                                              CGL159
      ** Unreconciled Balance                                                                 CGL159
                                                                                              CGL159
     C                   EVAL      WField = *BLANKS                                           CGL159
     C                   EVAL      WAmount = *Zeros                                           CGL159
     C                   EVAL      PDecPlace = *Zeros                                         CGL159
     C                   IF        UNREC_TYP <> 'R'                                         MD034975
     C                   EVAL      WAmount = UNREC_BAL                                        CGL159
     C                   ELSE                                                               MD034975
     C                   EVAL      WAmount = UNREC_B0                                       MD034975
     C                   ENDIF                                                              MD034975
     C                   EVAL      PDecPlace = DA6NBDP                                        CGL159
     C                   EXSR      FormatAmount                                               CGL159
     C                   MOVE      WField        PDUAMT                                       CGL159
                                                                                              CGL159
      ** Estimated Balance                                                                    CGL159
                                                                                              CGL159
     C                   EVAL      WField = *BLANKS                                           CGL159
     C                   EVAL      WAmount = *Zeros                                           CGL159
     C                   EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount2 =  LEDGER_BAL +                          CGL159 MD031573
     C**********                               (NCAMT0 + (PNB0 - LEDGER_BAL)) +      CGL159 MD031573
     C                   IF        UNREC_TYP <> 'R'                                         MD034975
     C                   EVAL      WAmount2 =  CLEAR00001 +                                 MD031573
     C                                         (NCAMT0 + (PNB0 - CLEAR00001)) +             MD031573
     C                                         UNREC_BAL                                      CGL159
     C                   ELSE                                                               MD034975
     C                   EVAL      WAmount2 =  CLEAR00001 +                                 MD034975
     C                                         (NCAMT0 + (PNB0 - CLEAR00001)) +             MD034975
     C                                         UNREC_B0                                     MD034975
     C                   ENDIF                                                              MD034975
     C                   EVAL      WAmount = WAmount2                                         CGL159
     C                   EVAL      PDecPlace = DA6NBDP                                        CGL159
     C                   EXSR      FormatAmount                                               CGL159
     C                   MOVE      WField        PDESBL                                       CGL159
                                                                                              CGL159
      ** Get Exchange Rate for Estimated Balance in Base CCY                                  CGL159
                                                                                              CGL159
     C/EXEC SQL                                                                               CGL159
     C+ Select * into :SDEX from SDEXRTTD                                                     CGL159
     C+    Where ERNOSP =  :NOSRPOOL AND                                                      CGL159
     C+          ERCCY  =  :P1PCCY                                                            CGL159
     C/END-EXEC                                                                               CGL159
                                                                                              CGL159
     C                   IF        SQLCode <> 0                                               CGL159
                                                                                              CGL159
     C                   EVAL      PaSpRt1    =   PA6SPRT                                     CGL159
     C                   EVAL      PaMDIn1    =   PA6MDIN                                     CGL159
     C                   EVAL      PaSpRt2    =   BA6SPRT                                     CGL159
     C                   EVAL      PaMDIn2    =   BA6MDIN                                     CGL159
     C                   EXSR      GetSpotRate                                                CGL159
     C                   EVAL      EXCHANGE2  =   WkRate                                      CGL159
     C                   EVAL      MDINDCTR2  =   WkMDIn                                      CGL159
     C                   ELSE                                                                 CGL159
     C                   EVAL      EXCHANGE2  =   SEREXRT                                     CGL159
     C                   EVAL      MDINDCTR2  =   SERMDIN                                     CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
                                                                                              CGL159
      ** Estimated Exchange Rate and Spot Rate Indicator                                      CGL159
                                                                                              CGL159
     C                   EVAL      NOSVAR = NOSRCODE                                          CGL159
     C/EXEC SQL                                                                               CGL159
     C+ Select * into :SDEX from SDEXRTTD                                                     CGL159
     C+    Where ERCCY  =  :NOSRCCRY and                                                      CGL159
     C+          ERNOSC =  :NOSNUM   and                                                      CGL159
     C+          ERTCCY =  :P1PCCY                                                            CGL159
     C/END-EXEC                                                                               CGL159
                                                                                              CGL159
     C                   IF        SQLCode <> 0                                               CGL159
                                                                                              CGL159
     C                   EVAL      PaSpRt1 =  DA6SPRT                                         CGL159
     C                   EVAL      PaMDIn1 =  DA6MDIN                                         CGL159
     C                   EVAL      PaSpRt2 =  PA6SPRT                                         CGL159
     C                   EVAL      PaMDIn2 =  PA6MDIN                                         CGL159
     C                   EXSR      GetSpotRate                                                CGL159
     C                   EVAL      PDERAT = WkRate                                            CGL159
     C                   EVAL      PDSPOT = 'Y'                                               CGL159
     C                   EVAL      MDINDCTR1 = WkMDIn                                         CGL159
                                                                                              CGL159
     C                   ELSE                                                                 CGL159
     C                   EVAL      PDERAT = SEREXRT                                           CGL159
     C                   EVAL      PDSPOT = 'N'                                               CGL159
     C                   EVAL      MDINDCTR1 = SERMDIN                                        CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   EVAL      EXCHANGE1 = PDERAT                                         CGL159
                                                                                              CGL159
                                                                                              CGL159
      ** Estimated Balance in Pivot CCY                                                       CGL159
                                                                                              CGL159
     C                   EVAL      InputAmnt  =  WAmount2                                     CGL159
     C                   EVAL      FrCurrency =  DA6CYCD                                      CGL159
     C                   EVAL      ToCurrency =  PA6CYCD                                      CGL159
     C                   EVAL      FrDecPlace =  DA6NBDP                                      CGL159
     C                   EVAL      ToDecPlace =  PA6NBDP                                      CGL159
     C                   EVAL      ExchRate   =  EXCHANGE1                                    CGL159
     C                   EVAL      MultDivInd =  MDINDCTR1                                    CGL159
     C                   EXSR      ConvertAmount                                              CGL159
                                                                                              CGL159
     C                   EVAL      WField    =  *BLANKS                                       CGL159
     C                   EVAL      WAmount   =  *Zeros                                        CGL159
     C                   EVAL      PDecPlace =  *Zeros                                        CGL159
     C                   EVAL      PDecPlace =  PA6NBDP                                       CGL159
     C                   EVAL      WAmount   =  OutPutAmnt                                    CGL159
     C                   EXSR      FormatAmount                                               CGL159
     C                   IF        P1PCCY <> *BLANKS                                          CGL159
     C                   MOVE      WField        PDPVOT                                       CGL159
     C                   ELSE                                                                 CGL159
     C                   MOVE      *BLANKS       PDPVOT                                       CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   IF        CGl159 = 'N'                                               CGL159
     C                   MOVE      *BLANKS       PDPVOT                                       CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   EVAL      WPDPIVOT  =  WPDPIVOT + OutPutAmnt                         CGL159
                                                                                              CGL159
                                                                                              CGL159
      ** Estimated Balance in Base currency                                                   CGL159
                                                                                              CGL159
     C                   EVAL      InputAmnt  =  OutPutAmnt                                   CGL159
     C                   EVAL      FrCurrency =  PA6CYCD                                      CGL159
     C                   EVAL      ToCurrency =  BA6CYCD                                      CGL159
     C                   EVAL      FrDecPlace =  PA6NBDP                                      CGL159
     C                   EVAL      ToDecPlace =  BA6NBDP                                      CGL159
     C                   EVAL      ExchRate   =  EXCHANGE2                                    CGL159
     C                   EVAL      MultDivInd =  MDINDCTR2                                    CGL159
     C                   EXSR      ConvertAmount                                              CGL159
                                                                                              CGL159
     C                   EVAL      WField =   *BLANKS                                         CGL159
     C                   EVAL      WAmount   = *Zeros                                         CGL159
     C                   EVAL      PDecPlace = *Zeros                                         CGL159
     C                   EVAL      PDecPlace = BA6NBDP                                        CGL159
     C                   EVAL      WAmount = OutPutAmnt                                       CGL159
     C                   EXSR      FormatAmount                                               CGL159
                                                                                              CGL159
     C                   IF        P1PCCY = BA6CYCD OR P1PCCY = *BLANKS                       CGL159
     C                   MOVE      WField        PDBASE                                       CGL159
     C                   ELSE                                                                 CGL159
     C                   MOVE      *BLANKS       PDBASE                                       CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   EVAL      WPDBASE  =  WPDBASE + OutPutAmnt                           CGL159
                                                                                              CGL159
                                                                                              CGL159
      ** Print Report Headers for every new page                                              CGL159
                                                                                              CGL159
     C                   IF        WRecNo = 1                                                 CGL159
     C                   EVAL      PRTLN1 = 70                                                CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   EVAL      RqdLn1 = 4                                                 CGL159
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                   CGL159
                                                                                              CGL159
     C                   IF        DifLn1 <= RqdLn1                                           CGL159
     C                   EXSR      SRPrintHdr1                                                CGL159
     C                   EXSR      SRPrintHdr2                                                CGL159
     C                   EXSR      SRPrintHdr3                                                CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
      ** Grand Total of  Estimated Balance in base currency                                   CGL159
                                                                                              CGL159
     C                   EVAL      WTotal  = WTotal  + OutPutAmnt                             CGL159
                                                                                              CGL159
     C                   EVAL      PDCCY2  = *BLANKS                                          CGL159
     C                   EVAL      PDPOOL2 = *BLANKS                                          CGL159
     C                   EVAL      PDNOSN2 = *BLANKS                                          CGL159
                                                                                              CGL159
     C                   IF        WPrvPool <> NOSRPOOL                                       CGL159
     C                   EVAL      PDPOOL2 =  NOSRPOOL                                        CGL159
     C                   EVAL      PDCCY2  =  P1PCCY                                          CGL159
     C                   EVAL      PDNOSN2 =  P1PDSC                                          CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   IF        NOSRPOOL <> *BLANKS                                        CGL159
     C                   EVAL      RqdLn1 = 1                                                 CGL159
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                   CGL159
                                                                                              CGL159
     C                   IF        DifLn1 <= RqdLn1                                           CGL159
     C                   EXSR      SRPrintHdr1                                                CGL159
     C                   EXSR      SRPrintHdr2                                                CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   IF        CGL159 = 'Y'                                               CGL159
     C                   WRITE     DETAIL2                                                    CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   EVAL      PDPOOL =  NOSRCODE                                         CGL159
     C                   EVAL      PDCCY  =  NOSRCCRY                                         CGL159
     C                   EVAL      PDNOSN =  NPLDSC                                           CGL159
                                                                                              CGL159
     C                   EVAL      RqdLn1 = 2                                                 CGL159
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                   CGL159
                                                                                              CGL159
     C                   IF        DifLn1 <= RqdLn1                                           CGL159
     C                   EXSR      SRPrintHdr1                                                CGL159
     C                   EXSR      SRPrintHdr2                                                CGL159
     C                   ENDIF                                                                CGL159
     C                   WRITE     DETAIL                                                     CGL159
                                                                                              CGL159
     C                   EVAL      WPrvPool = NOSRPOOL                                        CGL159
     C                   EVAL      WPrvPCCY = P1PCCY                                          CGL159
     C                   EVAL      WPrvMDIN = PA6MDIN                                         CGL159
     C                   EVAL      WPrvSPRT = PA6SPRT                                         CGL159
     C                   EVAL      WPrvNBDP = PA6NBDP                                         CGL159
                                                                                              CGL159
     C**********         IF        CGL159 = 'Y'                                        CGL159 CGL176
     C                   SELECT                                                               CGL176
     C                   WHEN      CGL159 = 'Y' AND CGL176 = 'N'                              CGL176
     C/exec SQL                                                                               CGL159
     C+ fetch next from LISTA                                                                 CGL159
     C+ into :BPOW                                                                            CGL159
     C/end-exec                                                                               CGL159
     C**********         ELSE                                                          CGL159 CGL176
     C                   WHEN      CGL176 = 'Y'                                               CGL176
     C/exec SQL                                                                               CGL176
     C+ fetch next from LISTC                                                                 CGL176
     C+ into :BPOW                                                                            CGL176
     C/end-exec                                                                               CGL176
     C                   OTHER                                                                CGL176
     C/exec SQL                                                                               CGL159
     C+ fetch next from LISTB                                                                 CGL159
     C+ into :BPOW                                                                            CGL159
     C/end-exec                                                                               CGL159
     C**********         ENDIF                                                         CGL159 CGL176
     C                   ENDSL                                                                CGL176
                                                                                              CGL159
     C                   EVAL      SQLTEMP = SQLCOD                                           CGL159
                                                                                              CGL159
      ** GET SUB-TOTAL                                                                        CGL159
                                                                                              CGL159
     C                   IF        WRecno > 1                                                 CGL159
     C                             and WPrvPool <> NOSRPOOL                                   CGL159
     C                   EXSR      GETSUBTOTAL                                                CGL159
                                                                                              CGL159
     C                   EVAL      RqdLn1 = 2                                                 CGL159
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                   CGL159
                                                                                              CGL159
     C                   IF        DifLn1 <= RqdLn1                                           CGL159
     C                   EXSR      SRPrintHdr1                                                CGL159
     C                   EXSR      SRPrintHdr2                                                CGL159
     C                   EVAL      HEADVAR = 'Y'                                              CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   IF        CGL159 = 'Y'                                               CGL159
     C                   EVAL      RqdLn1 = 5                                                 CGL176
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                   CGL176
     C                   IF        DifLn1 <= RqdLn1                                           CGL176
     C                   EXSR      SRPrintHdr1                                                CGL176
     C                   EXSR      SRPrintHdr2                                                CGL176
     C                   EXSR      SRPrintHdr3                                                CGL176
     C                   EVAL      HEADVAR = 'N'                                              CGL176
     C                   ENDIF                                                                CGL176
     C                   WRITE     SUBPOOL                                                    CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   IF        HEADVAR = 'Y'                                              CGL159
     C                   EXSR      SRPrintHdr3                                                CGL159
     C                   EVAL      HEADVAR = 'N'                                              CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   CLEAR                   SUBPOOL                                      CGL159
     C                   Z-ADD     0             WPDBASE                                      CGL159
     C                   Z-ADD     0             WPDPIVOT                                     CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   IF        CGL176 = 'Y' AND SQLTEMP <> 100 AND                        CGL176
     C                             A8CMCD <> PDCMCD                                           CGL176
     C                   EXSR      SRPrintFooter                                              CGL176
     C                   CLOSE     GL000596P1                                                 CGL176
     C                   EVAL      WRecno = 0                                                 CGL176
     C                   ENDIF                                                                CGL176
     C                   ENDDO                                                                CGL159
                                                                                              CGL159
                                                                                              CGL159
      ** Handle SQL Error (if not %EOF)                                                       CGL159
                                                                                              CGL159
     C                   If        SQLTEMP < 100                                              CGL159
                                                                                              CGL159
     C     *LOCK         IN        LDA                                                        CGL159
     C                   EVAL      DBASE = 003                                                CGL159
     C                   EVAL      DBFILE = 'SQL STM'                                         CGL159
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                               CGL159
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                     CGL159
     C                   OUT       LDA                                                        CGL159
     C                   EXSR      *PSSR                                                      CGL159
                                                                                              CGL159
     C                   EndIf                                                                CGL159
                                                                                              CGL159
     C**********         IF        CGL159 = 'Y'                                        CGL159 CGL176
     C                   SELECT                                                               CGL176
     C                   WHEN      CGL159 = 'Y' AND CGL176 = 'N'                              CGL176
     C/exec SQL                                                                               CGL159
     C+ close LISTA                                                                           CGL159
     C/end-exec                                                                               CGL159
     C**********         ELSE                                                          CGL159 CGL176
     C                   WHEN      CGL176 = 'Y'                                               CGL176
     C/exec SQL                                                                               CGL176
     C+ close LISTC                                                                           CGL176
     C/end-exec                                                                               CGL176
     C                   OTHER                                                                CGL176
     C/exec SQL                                                                               CGL159
     C+ close LISTB                                                                           CGL159
     C/end-exec                                                                               CGL159
     C**********         ENDIF                                                         CGL159 CGL176
     C                   ENDSL                                                                CGL176
                                                                                              CGL159
     C                   EXSR      SRPrintFooter                                              CGL159
                                                                                              CGL159
     C                   EVAL      *INLR = *ON                                                CGL159
                                                                                              CGL159
     C                   RETURN                                                               CGL159
                                                                                              CGL159
      ***Extract*different*data*to*workfile****************************                       CGL159
      *********                                                                               CGL159
     C*********          EXSR      SRWrkFile                                                  CGL159
      *********                                                                               CGL159
      ***Do*processing*for*the*print***********************************                       CGL159
      *********                                                                               CGL159
     C*/exec*SQL                                                                              CGL159
     C***declare LISTA cursor for                                                             CGL159
     C***select * from SDBPOWTD                                                               CGL159
     C***order*by                                                                             CGL159
     C*********BPPOOL                                                                         CGL159
     C********,BPCCY                                                                          CGL159
     C********,BPNOSC                                                                         CGL159
     C********,BPACCT                                                                         CGL159
     C*/end-exec                                                                              CGL159
      *********                                                                               CGL159
     C*/exec*SQL                                                                              CGL159
     C**open*LISTA                                                                            CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
      ***Handle*SQL*Error*(if*not*%EOF)********************************                       CGL159
      **********                                                                              CGL159
     C**********         If        SQLCOD < 0                                                 CGL159
      **********                                                                              CGL159
     C******LOCK         IN        LDA                                                        CGL159
     C**********         EVAL      DBASE = 002                                                CGL159
     C**********         EVAL      DBFILE = 'SQL STM'                                         CGL159
     C**********         EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                               CGL159
     C**********                         + ';  SQLCOD : ' + %char(SQLCOD)                     CGL159
     C**********         OUT       LDA                                                        CGL159
     C**********         EXSR      *PSSR                                                      CGL159
      **********                                                                              CGL159
     C**********         EndIf                                                                CGL159
      **********                                                                              CGL159
     C*/exec*SQL                                                                              CGL159
     C**fetch*next                                                                            CGL159
     C**from*LISTA                                                                            CGL159
     C**into*:BPOW                                                                            CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
      ***Bank*Position*details*****************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      WPrvPool = *BLANKS                                         CGL159
     C**********         EVAL      WSubTot = 0                                                CGL159
     C**********         EVAL      WTotal  = 0                                                CGL159
      **********                                                                              CGL159
     C**********         Z-ADD     0             WPDBASE                                      CGL159
      **********                                                                              CGL159
     C**********         DOW       SQLCode <> 100                                             CGL159
      **********                                                                              CGL159
      ***Count*********************************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      WRecNo = WRecNo + 1                                        CGL159
      **********                                                                              CGL159
      **********                                                                              CGL159
     C**********         EVAL      PDCCY  = BPCCY                                             CGL159
     C**********         IF        BPCCY <> BJCYCD                                            CGL159
      **********                                                                              CGL159
      ******base*rate*currency*decimal*places**************************                       CGL159
      **********                                                                              CGL159
     C**********         MOVE      BJCYCD        PCCY                                         CGL159
     C**********         EXSR      GetCurrDtls                                                CGL159
     C**********         MOVE      A6NBDP        WA6NBDP                                      CGL159
     C**********         ELSE                                                                 CGL159
     C**********         Z-ADD     0             WA6NBDP                                      CGL159
     C**********         ENDIF                                                                CGL159
     C**********         MOVE      BPCCY         PCCY                                         CGL159
     C**********         EXSR      GetCurrDtls                                                CGL159
      **********                                                                              CGL159
      ***Account*details***********************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      PDACCT = BPACCT                                            CGL159
      **********                                                                              CGL159
      ***Cleared*Balance***********************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      WField = *BLANKS                                           CGL159
     C**********         EVAL      WAmount = *Zeros                                           CGL159
     C**********         EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount = BPCLBL                                           CGL159
     C**********         EVAL      PDecPlace = A6NBDP                                         CGL159
     C**********         EXSR      FormatAmount                                               CGL159
     C**********         MOVE      WField        PDCLBL                                       CGL159
      **********                                                                              CGL159
      **********                                                                              CGL159
      ***Forecast*Balance**********************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      WField = *BLANKS                                           CGL159
     C**********         EVAL      WAmount = *Zeros                                           CGL159
     C**********         EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount = BPFAMT                                           CGL159
     C**********         EVAL      PDecPlace = A6NBDP                                         CGL159
     C**********         EXSR      FormatAmount                                               CGL159
     C**********         MOVE      WField        PDFAMT                                       CGL159
      **********                                                                              CGL159
      ***Projected*Balance*********************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      WField = *BLANKS                                           CGL159
     C**********         EVAL      WAmount = *Zeros                                           CGL159
     C**********         EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount = BPPAMT                                           CGL159
     C**********         EVAL      PDecPlace = A6NBDP                                         CGL159
     C**********         EXSR      FormatAmount                                               CGL159
     C**********         MOVE      WField        PDPAMT                                       CGL159
      **********                                                                              CGL159
      ***Unreconciled*Balance******************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      WField = *BLANKS                                           CGL159
     C**********         EVAL      WAmount = *Zeros                                           CGL159
     C**********         EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount = BPUAMT                                           CGL159
     C**********         EVAL      PDecPlace = A6NBDP                                         CGL159
     C**********         EXSR      FormatAmount                                               CGL159
     C**********         MOVE      WField        PDUAMT                                       CGL159
      **********                                                                              CGL159
      ***Statement*Balance*********************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      WField = *BLANKS                                           CGL159
     C**********         EVAL      WAmount = *Zeros                                           CGL159
     C**********         EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount = BPSAMT                                           CGL159
     C**********         EVAL      PDecPlace = A6NBDP                                         CGL159
     C**********         EXSR      FormatAmount                                               CGL159
     C**********         MOVE      WField        PDSAMT                                       CGL159
      **********                                                                              CGL159
      ***Estimated*Balance*********************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      WField = *BLANKS                                           CGL159
     C**********         EVAL      WAmount = *Zeros                                           CGL159
     C**********         EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount2 =  BPCLBL + BPFAMT + BPPAMT + BPUAMT              CGL159
     C**********         EVAL      WAmount = WAmount2                                         CGL159
     C**********         EVAL      PDecPlace = A6NBDP                                         CGL159
     C**********         EXSR      FormatAmount                                               CGL159
     C**********         MOVE      WField        PDESBL                                       CGL159
      **********                                                                              CGL159
      **********                                                                              CGL159
      ***Estimated*Exchange*Rate***************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      PDERAT = BPERAT                                            CGL159
      **********                                                                              CGL159
      ***Spot*Rate*Indicator*******************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      PDSPOT = BPSPOT                                            CGL159
      **********                                                                              CGL159
      ***Estimated*Balance*in*Base*currency****************************                       CGL159
      **********                                                                              CGL159
     C**********         IF        BPCCY = BJCYCD                                             CGL159
     C**********         EVAL      PDBASE = PDESBL                                            CGL159
     C**********         EVAL      WPDBASE = WAmount2                                         CGL159
     C**********         ELSE                                                                 CGL159
     C**********         EVAL      InputAmnt = WAmount2                                       CGL159
     C**********         EVAL      ExchRate = BPERAT                                          CGL159
     C**********         EVAL      MultDivInd = BPMDIN                                        CGL159
     C**********         EVAL      FrCurrency = BPCCY                                         CGL159
     C**********         EVAL      ToCurrency = BJCYCD                                        CGL159
     C**********         EVAL      FrDecPlace = A6NBDP                                        CGL159
     C**********         EVAL      ToDecPlace = WA6NBDP                                       CGL159
     C**********         EXSR      ConvertBase                                                CGL159
     C**********         EVAL      WPDBASE = OutPutAmnt                                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      WField = *BLANKS                                           CGL159
     C**********         EVAL      WAmount = *Zeros                                           CGL159
     C**********         EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount = WPDBASE                                          CGL159
     C**********         EVAL      PDecPlace = WA6NBDP                                        CGL159
     C**********         EXSR      FormatAmount                                               CGL159
     C**********         MOVE      WField        PDBASE                                       CGL159
      **********                                                                              CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
      **********                                                                              CGL159
      ***Print*Report*Headers*for*every*new*page***********************                       CGL159
      **********                                                                              CGL159
     C**********         IF        WRecNo = 1                                                 CGL159
     C**********         EVAL      PRTLN1 = 70                                                CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         EVAL      RqdLn1 = 4                                                 CGL159
     C**********         EVAL      DifLn1 = OFLLN1 - PRTLN1                                   CGL159
      **********                                                                              CGL159
     C**********         IF        DifLn1 <= RqdLn1                                           CGL159
     C**********         EXSR      SRPrintHdr1                                                CGL159
     C**********         EXSR      SRPrintHdr2                                                CGL159
     C**********         EXSR      SRPrintHdr3                                                CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         IF        WRecno > 1                                                 CGL159
     C**********                   and WPrvPool <> BPPOOL                                     CGL159
      **********                                                                              CGL159
     C**********         EVAL      WField = *BLANKS                                           CGL159
     C**********         EVAL      WAmount = *Zeros                                           CGL159
     C**********         EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount = WSubTot                                          CGL159
     C**********         EVAL      PDecPlace = A6NBDP                                         CGL159
     C**********         EXSR      FormatAmount                                               CGL159
     C**********         MOVE      WField        PDSUB                                        CGL159
      **********                                                                              CGL159
     C**********         EVAL      RqdLn1 = 2                                        MD027156 CGL159
     C**********         EVAL      DifLn1 = OFLLN1 - PRTLN1                          MD027156 CGL159
      **********                                                                     MD027156 CGL159
     C**********         IF        DifLn1 <= RqdLn1                                  MD027156 CGL159
     C**********         EXSR      SRPrintHdr1                                       MD027156 CGL159
     C**********         EXSR      SRPrintHdr2                                       MD027156 CGL159
     C**********         ENDIF                                                       MD027156 CGL159
     C**********         WRITE     SUBPOOL                                                    CGL159
     C**********         EVAL      WSubTot = 0                                                CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
      *****Accumulate*Estimate*Balance*in*base*currency****************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      WSubTot = WSubTot + WPDBASE                                CGL159
     C**********         EVAL      WTotal  = WTotal  + WPDBASE                                CGL159
      **********                                                                              CGL159
     C**********         IF        WPrvPool <> BPPOOL                                         CGL159
     C**********                   AND BPPOOL <> *HIVAL                                       CGL159
     C**********         IF        BPPOOL = *HIVAL                                            CGL159
     C**********         EVAL      PDPOOL2 = *BLANKS                                          CGL159
     C**********         ELSE                                                                 CGL159
     C**********         EVAL      PDPOOL2 = BPPOOL                                           CGL159
     C**********         ENDIF                                                                CGL159
     C**********         EVAL      PDNOSN2 = *BLANKS                                          CGL159
     C**********         EVAL      PDCCY2 = BJCYCD                                            CGL159
     C**********         EVAL      RqdLn1 = 1                                        MD027156 CGL159
     C**********         EVAL      DifLn1 = OFLLN1 - PRTLN1                          MD027156 CGL159
      **********                                                                     MD027156 CGL159
     C**********         IF        DifLn1 <= RqdLn1                                  MD027156 CGL159
     C**********         EXSR      SRPrintHdr1                                       MD027156 CGL159
     C**********         EXSR      SRPrintHdr2                                       MD027156 CGL159
     C**********         ENDIF                                                       MD027156 CGL159
     C**********         WRITE     DETAIL2                                                    CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         IF        BPPOOL = *HIVAL                                            CGL159
     C**********         EVAL      PDPOOL = BPCCY + BPNOSC                                    CGL159
     C**********         ELSE                                                                 CGL159
     C**********         EVAL      PDPOOL = '   ' + BPCCY + BPNOSC                            CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         EVAL      PDNOSN  = BPNOSN                                           CGL159
      **********                                                                              CGL159
     C**********         EVAL      RqdLn1 = 2                                        MD027156 CGL159
     C**********         EVAL      DifLn1 = OFLLN1 - PRTLN1                          MD027156 CGL159
      **********                                                                     MD027156 CGL159
     C**********         IF        DifLn1 <= RqdLn1                                  MD027156 CGL159
     C**********         EXSR      SRPrintHdr1                                       MD027156 CGL159
     C**********         EXSR      SRPrintHdr2                                       MD027156 CGL159
     C**********         ENDIF                                                       MD027156 CGL159
     C**********         WRITE     DETAIL                                                     CGL159
      **********                                                                              CGL159
     C**********         EVAL      WPrvPool = BPPOOL                                          CGL159
      **********                                                                              CGL159
     C*/exec*SQL                                                                              CGL159
     C**fetch*next from LISTA                                                                 CGL159
     C**into*:BPOW                                                                            CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
     C**********         ENDDO                                                                CGL159
      **********                                                                              CGL159
      **********                                                                              CGL159
      ***Handle*SQL*Error*(if*not*%EOF)********************************                       CGL159
      **********                                                                              CGL159
     C**********         If        SQLCode < 100                                              CGL159
      **********                                                                              CGL159
     C******LOCK         IN        LDA                                                        CGL159
     C**********         EVAL      DBASE = 003                                                CGL159
     C**********         EVAL      DBFILE = 'SQL STM'                                         CGL159
     C**********         EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                               CGL159
     C**********                         + ';  SQLCOD : ' + %char(SQLCOD)                     CGL159
     C**********         OUT       LDA                                                        CGL159
     C**********         EXSR      *PSSR                                                      CGL159
      **********                                                                              CGL159
     C**********         EndIf                                                                CGL159
      **********                                                                              CGL159
     C*/exec*SQL                                                                              CGL159
     C**close*LISTA                                                                           CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
     C**********         EXSR      SRPrintFtr                                                 CGL159
      **********                                                                              CGL159
     C**********         EVAL      *INLR = *ON                                                CGL159
      **********                                                                              CGL159
     C**********         RETURN                                                               CGL159
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT                                                                                  CGL159
      *****************************************************************                       CGL159
      *                                                               *                       CGL159
      *  SELSQLRTN - Select SQL Routine                               *                       CGL159
      *                                                               *                       CGL159
      *****************************************************************                       CGL159
     C     SELSQLRTN     BEGSR                                                                CGL159
                                                                                              CGL159
      ** Clear BPOW data structure to initialize null values with blanks or zeros             CGL176
     C                   CLEAR                   BPOW                                         CGL176
     C**********         IF        CGL159 = 'Y'                                        CGL159 CGL176
     C                   SELECT                                                               CGL176
     C                   WHEN      CGL159 = 'Y'  AND CGL176 = 'N'                             CGL176
                                                                                              CGL159
     C/exec SQL                                                                               CGL159
     C+ declare LISTA cursor for                                                              CGL159
     C+ SELECT IFNULL(NOSRPOOL, ' '),                                                         CGL159
     C+        IFNULL(P1PCCY, ' '),                                                           CGL159
     C+        IFNULL(P1PDSC, ' '),                                                           CGL159
     C+        IFNULL(POOLCOUNT, 0),                                                          CGL159
     C+        IFNULL(NOSRCCRY, ' '),                                                         CGL159
     C+        IFNULL(NOSRNO, 0),                                                             CGL159
     C+        IFNULL(NOSRCODE, ' '),                                                         CGL159
     C*********IFNULL(LEDGER_BAL, 0),                                                CGL159 MD031573
     C+        IFNULL(CLEAR00001, 0),                                                       MD031573
     C+        IFNULL(UNREC_BAL, 0),                                                          CGL159
     C+        IFNULL(NPLDSC, ' '),                                                           CGL159
     C+        IFNULL(EREXRT, 0),                                                             CGL159
     C+        IFNULL(ERMDIN, ' '),                                                           CGL159
     C+        IFNULL(ERDATE, 0),                                                             CGL159
     C+        IFNULL(EREXRT1, 0),                                                            CGL159
     C+        IFNULL(ERMDIN1, ' '),                                                          CGL159
     C+        IFNULL(ERDATE1, 0),                                                            CGL159
     C+        IFNULL(EREXRT2, 0),                                                            CGL159
     C+        IFNULL(ERMDIN2, ' '),                                                          CGL159
     C+        IFNULL(ERDATE2, 0),                                                            CGL159
     C+        IFNULL(EREXRT3, 0),                                                            CGL159
     C+        IFNULL(ERMDIN3, ' '),                                                          CGL159
     C+        IFNULL(ERDATE3, 0),                                                            CGL159
     C+        IFNULL(POOLRATE, 0),                                                           CGL159
     C+        IFNULL(POOLMDIN, ' '),                                                         CGL159
     C+        IFNULL(POOLRATEDATE, 0),                                                       CGL159
     C+        IFNULL(NCAMT0, 0),                                                             CGL159
     C+        IFNULL(NCAMT1, 0),                                                             CGL159
     C+        IFNULL(NCAMT2, 0),                                                             CGL159
     C+        IFNULL(NCAMT3, 0),                                                             CGL159
     C+        IFNULL(NCAMT4, 0),                                                             CGL159
     C+        IFNULL(NCAMT5, 0),                                                             CGL159
     C+        IFNULL(NCAMT6, 0),                                                             CGL159
     C+        IFNULL(NCAMT7, 0),                                                             CGL159
     C+        IFNULL(NCAMT8, 0),                                                             CGL159
     C+        IFNULL(NCAMT9, 0),                                                             CGL159
     C+        IFNULL(PNB0, 0),                                                               CGL159
     C+        IFNULL(PNB1, 0),                                                               CGL159
     C+        IFNULL(PNB2, 0),                                                               CGL159
     C+        IFNULL(PNB3, 0),                                                               CGL159
     C+        IFNULL(PNB4, 0),                                                               CGL159
     C+        IFNULL(PND0, 0),                                                               CGL159
     C+        IFNULL(PND1, 0),                                                               CGL159
     C+        IFNULL(PND2, 0),                                                               CGL159
     C+        IFNULL(PND3, 0),                                                               CGL159
     C+        IFNULL(PND4, 0),                                                               CGL159
     C+        IFNULL(BRCA, ' '),                                                             CGL159
     C+        IFNULL(CNUM, ' '),                                                             CGL159
     C+        IFNULL(CCY,  ' '),                                                             CGL159
     C+        IFNULL(ACOD, 0),                                                               CGL159
     C+        IFNULL(ACSQ, 0),                                                               CGL159
     C+        IFNULL(ATYP, ' '),                                                             CGL159
     C+        IFNULL(ACNO, 0),                                                               CGL159
     C+        IFNULL(STSST, 0)                                                               CGL159
     C+        ,IFNULL(A8CMCD, ' ')                                                         MD034975
     C+        ,IFNULL(UNREC_B0, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B1, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B2, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B3, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B4, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B5, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B6, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_TYP, ' ')                                                      MD034975
     C+   FROM SDNOSTW0                                                                       CGL159
     C+   WHERE PND0 = :BJRDNB                                                                CGL159
     C+   ORDER BY                                                                            CGL159
     C+      CASE WHEN NOSRPOOL = ' ' THEN 1 ELSE 0 END,                                      CGL159
     C+      NOSRPOOL ASC,                                                                    CGL159
     C+      P1PCCY ASC,                                                                      CGL159
     C+      NOSRCODE ASC                                                                     CGL159
     C/end-exec                                                                               CGL159
                                                                                              CGL159
     C**********         ELSE                                                          CGL159 CGL176
     C                   WHEN      CGL176 = 'Y'                                               CGL176

     C/exec SQL                                                                               CGL176
     C+ declare LISTC cursor for                                                              CGL176
     C+ SELECT IFNULL(NOSRPOOL, ' '),                                                         CGL176
     C+        IFNULL(P1PCCY, ' '),                                                           CGL176
     C+        IFNULL(P1PDSC, ' '),                                                           CGL176
     C+        IFNULL(POOLCOUNT, 0),                                                          CGL176
     C+        IFNULL(NOSRCCRY, ' '),                                                         CGL176
     C+        IFNULL(NOSRNO, 0),                                                             CGL176
     C+        IFNULL(NOSRCODE, ' '),                                                         CGL176
     C+        IFNULL(CLEAR00001, 0),                                                         CGL176
     C+        IFNULL(UNREC_BAL, 0),                                                          CGL176
     C+        IFNULL(NPLDSC, ' '),                                                           CGL176
     C+        IFNULL(EREXRT, 0),                                                             CGL176
     C+        IFNULL(ERMDIN, ' '),                                                           CGL176
     C+        IFNULL(ERDATE, 0),                                                             CGL176
     C+        IFNULL(EREXRT1, 0),                                                            CGL176
     C+        IFNULL(ERMDIN1, ' '),                                                          CGL176
     C+        IFNULL(ERDATE1, 0),                                                            CGL176
     C+        IFNULL(EREXRT2, 0),                                                            CGL176
     C+        IFNULL(ERMDIN2, ' '),                                                          CGL176
     C+        IFNULL(ERDATE2, 0),                                                            CGL176
     C+        IFNULL(EREXRT3, 0),                                                            CGL176
     C+        IFNULL(ERMDIN3, ' '),                                                          CGL176
     C+        IFNULL(ERDATE3, 0),                                                            CGL176
     C+        IFNULL(POOLRATE, 0),                                                           CGL176
     C+        IFNULL(POOLMDIN, ' '),                                                         CGL176
     C+        IFNULL(POOLRATEDATE, 0),                                                       CGL176
     C+        IFNULL(NCAMT0, 0),                                                             CGL176
     C+        IFNULL(NCAMT1, 0),                                                             CGL176
     C+        IFNULL(NCAMT2, 0),                                                             CGL176
     C+        IFNULL(NCAMT3, 0),                                                             CGL176
     C+        IFNULL(NCAMT4, 0),                                                             CGL176
     C+        IFNULL(NCAMT5, 0),                                                             CGL176
     C+        IFNULL(NCAMT6, 0),                                                             CGL176
     C+        IFNULL(NCAMT7, 0),                                                             CGL176
     C+        IFNULL(NCAMT8, 0),                                                             CGL176
     C+        IFNULL(NCAMT9, 0),                                                             CGL176
     C+        IFNULL(PNB0, 0),                                                               CGL176
     C+        IFNULL(PNB1, 0),                                                               CGL176
     C+        IFNULL(PNB2, 0),                                                               CGL176
     C+        IFNULL(PNB3, 0),                                                               CGL176
     C+        IFNULL(PNB4, 0),                                                               CGL176
     C+        IFNULL(PND0, 0),                                                               CGL176
     C+        IFNULL(PND1, 0),                                                               CGL176
     C+        IFNULL(PND2, 0),                                                               CGL176
     C+        IFNULL(PND3, 0),                                                               CGL176
     C+        IFNULL(PND4, 0),                                                               CGL176
     C+        IFNULL(BRCA, ' '),                                                             CGL176
     C+        IFNULL(CNUM, ' '),                                                             CGL176
     C+        IFNULL(CCY,  ' '),                                                             CGL176
     C+        IFNULL(ACOD, 0),                                                               CGL176
     C+        IFNULL(ACSQ, 0),                                                               CGL176
     C+        IFNULL(ATYP, ' '),                                                             CGL176
     C+        IFNULL(ACNO, 0),                                                               CGL176
     C+        IFNULL(STSST, 0),                                                              CGL176
     C+        IFNULL(A8CMCD, ' ')                                                            CGL176
     C+        ,IFNULL(UNREC_B0, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B1, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B2, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B3, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B4, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B5, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B6, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_TYP, ' ')                                                      MD034975
     C+   FROM SDNOSTW0                                                                       CGL176
     C+   WHERE PND0 = :BJRDNB                                                                CGL176
     C+   ORDER BY                                                                            CGL176
     C+      A8CMCD ASC,                                                                      CGL176
     C+      CASE WHEN NOSRPOOL = ' ' THEN 1 ELSE 0 END,                                      CGL176
     C+      NOSRPOOL ASC,                                                                    CGL176
     C+      P1PCCY ASC,                                                                      CGL176
     C+      NOSRCODE ASC                                                                     CGL176
     C/end-exec                                                                               CGL176
     C                   OTHER                                                                CGL176
                                                                                              CGL159
     C/exec SQL                                                                               CGL159
     C+ declare LISTB cursor for                                                              CGL159
     C+ SELECT IFNULL(NOSRPOOL, ' '),                                                         CGL159
     C+        IFNULL(P1PCCY, ' '),                                                           CGL159
     C+        IFNULL(P1PDSC, ' '),                                                           CGL159
     C+        IFNULL(POOLCOUNT, 0),                                                          CGL159
     C+        IFNULL(NOSRCCRY, ' '),                                                         CGL159
     C+        IFNULL(NOSRNO, 0),                                                             CGL159
     C+        IFNULL(NOSRCODE, ' '),                                                         CGL159
     C*********IFNULL(LEDGER_BAL, 0),                                                CGL159 MD031573
     C+        IFNULL(CLEAR00001, 0),                                                       MD031573
     C+        IFNULL(UNREC_BAL, 0),                                                          CGL159
     C+        IFNULL(NPLDSC, ' '),                                                           CGL159
     C+        IFNULL(EREXRT, 0),                                                             CGL159
     C+        IFNULL(ERMDIN, ' '),                                                           CGL159
     C+        IFNULL(ERDATE, 0),                                                             CGL159
     C+        IFNULL(EREXRT1, 0),                                                            CGL159
     C+        IFNULL(ERMDIN1, ' '),                                                          CGL159
     C+        IFNULL(ERDATE1, 0),                                                            CGL159
     C+        IFNULL(EREXRT2, 0),                                                            CGL159
     C+        IFNULL(ERMDIN2, ' '),                                                          CGL159
     C+        IFNULL(ERDATE2, 0),                                                            CGL159
     C+        IFNULL(EREXRT3, 0),                                                            CGL159
     C+        IFNULL(ERMDIN3, ' '),                                                          CGL159
     C+        IFNULL(ERDATE3, 0),                                                            CGL159
     C+        IFNULL(POOLRATE, 0),                                                           CGL159
     C+        IFNULL(POOLMDIN, ' '),                                                         CGL159
     C+        IFNULL(POOLRATEDATE, 0),                                                       CGL159
     C+        IFNULL(NCAMT0, 0),                                                             CGL159
     C+        IFNULL(NCAMT1, 0),                                                             CGL159
     C+        IFNULL(NCAMT2, 0),                                                             CGL159
     C+        IFNULL(NCAMT3, 0),                                                             CGL159
     C+        IFNULL(NCAMT4, 0),                                                             CGL159
     C+        IFNULL(NCAMT5, 0),                                                             CGL159
     C+        IFNULL(NCAMT6, 0),                                                             CGL159
     C+        IFNULL(NCAMT7, 0),                                                             CGL159
     C+        IFNULL(NCAMT8, 0),                                                             CGL159
     C+        IFNULL(NCAMT9, 0),                                                             CGL159
     C+        IFNULL(PNB0, 0),                                                               CGL159
     C+        IFNULL(PNB1, 0),                                                               CGL159
     C+        IFNULL(PNB2, 0),                                                               CGL159
     C+        IFNULL(PNB3, 0),                                                               CGL159
     C+        IFNULL(PNB4, 0),                                                               CGL159
     C+        IFNULL(PND0, 0),                                                               CGL159
     C+        IFNULL(PND1, 0),                                                               CGL159
     C+        IFNULL(PND2, 0),                                                               CGL159
     C+        IFNULL(PND3, 0),                                                               CGL159
     C+        IFNULL(PND4, 0),                                                               CGL159
     C+        IFNULL(BRCA, ' '),                                                             CGL159
     C+        IFNULL(CNUM, ' '),                                                             CGL159
     C+        IFNULL(CCY,  ' '),                                                             CGL159
     C+        IFNULL(ACOD, 0),                                                               CGL159
     C+        IFNULL(ACSQ, 0),                                                               CGL159
     C+        IFNULL(ATYP, ' '),                                                             CGL159
     C+        IFNULL(ACNO, 0),                                                               CGL159
     C+        IFNULL(STSST, 0)                                                               CGL159
     C+        ,IFNULL(A8CMCD, ' ')                                                         MD034975
     C+        ,IFNULL(UNREC_B0, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B1, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B2, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B3, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B4, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B5, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_B6, 0)                                                         MD034975
     C+        ,IFNULL(UNREC_TYP, ' ')                                                      MD034975
     C+   FROM SDNOSTW0                                                                       CGL159
     C+   WHERE PND0 = :BJRDNB                                                                CGL159
     C+   ORDER BY                                                                            CGL159
     C+      NOSRCODE ASC,                                                                    CGL159
     C+      P1PCCY ASC                                                                       CGL159
     C/end-exec                                                                               CGL159
                                                                                              CGL159
     C**********         ENDIF                                                         CGL159 CGL176
     C                   ENDSL                                                                CGL176
                                                                                              CGL159
     C                   ENDSR                                                                CGL159
                                                                                              CGL159
      *****************************************************************                       CGL159
      /EJECT                                                                                  CGL159
      *****************************************************************                       CGL159
      *                                                               *                       CGL159
      *  GETSUBTOTAL - Get Subtotal Details                           *                       CGL159
      *                                                               *                       CGL159
      *****************************************************************                       CGL159
     C     GETSUBTOTAL   BEGSR                                                                CGL159
                                                                                              CGL159
      ** Sub-Total Exchange Rate and Spot Rate                                                CGL159
                                                                                              CGL159
     C/EXEC SQL                                                                               CGL159
     C+ Select * into :SDEX from SDEXRTTD                                                     CGL159
     C+    Where ERNOSP =  :WPrvPool AND                                                      CGL159
     C+          ERCCY  =  :WPrvPCCY                                                          CGL159
     C/END-EXEC                                                                               CGL159
                                                                                              CGL159
     C                   IF        SQLCode <> 0                                               CGL159
                                                                                              CGL159
     C                   EVAL      PaSpRt1    =   WPrvSPRT                                    CGL159
     C                   EVAL      PaMDIn1    =   WPrvMDIN                                    CGL159
     C                   EVAL      PaSpRt2    =   BA6SPRT                                     CGL159
     C                   EVAL      PaMDIn2    =   BA6MDIN                                     CGL159
     C                   EXSR      GetSpotRate                                                CGL159
     C                   EVAL      SUBEXC     =   WkRate                                      CGL159
     C                   EVAL      SUBSPT     =   'Y'                                         CGL159
     C                   ELSE                                                                 CGL159
     C                   EVAL      SUBEXC     =   SEREXRT                                     CGL159
     C                   EVAL      SUBSPT     =   'N'                                         CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
                                                                                              CGL159
      ** Sub-TOTAL in BASE                                                                    CGL159
     C                   EVAL      WField     =  *BLANKS                                      CGL159
     C                   EVAL      WAmount    =  *Zeros                                       CGL159
     C                   EVAL      PDecPlace  =  *Zeros                                       CGL159
     C                   EVAL      WAmount    =  WPDBASE                                      CGL159
     C                   EVAL      PDecPlace  =  BA6NBDP                                      CGL159
     C                   EXSR      FormatAmount                                               CGL159
     C                   MOVE      WField        SUBBAS                                       CGL159
                                                                                              CGL159
      ** Sub-TOTAL in PIVOT                                                                   CGL159
     C                   EVAL      WField     =  *BLANKS                                      CGL159
     C                   EVAL      WAmount    =  *Zeros                                       CGL159
     C                   EVAL      PDecPlace  =  *Zeros                                       CGL159
     C                   EVAL      WAmount    =  WPDPIVOT                                     CGL159
     C                   EVAL      PDecPlace  =  WPrvNBDP                                     CGL159
     C                   EXSR      FormatAmount                                               CGL159
     C                   MOVE      WField        SUBPVT                                       CGL159
                                                                                              CGL159
      ** Sub-TOTAL Estimated Balance                                                          CGL159
     C                   EVAL      SUBEST = SUBPVT                                            CGL159
                                                                                              CGL159
     C                   ENDSR                                                                CGL159
      *****************************************************************                       CGL159
      /EJECT                                                                                  CGL159
      *****************************************************************                       CGL159
      *                                                               *                       CGL159
      *  ConvertAmount -  Convert Amount to CCY Equivalent            *                       CGL159
      *                                                               *                       CGL159
      *****************************************************************                       CGL159
     C     ConvertAmount BEGSR                                                                CGL159
                                                                                              CGL159
     C                   CALL      'ZCONVZ1'                                                  CGL159
     C                   PARM                    InputAmnt                                    CGL159
     C                   PARM                    ExchRate                                     CGL159
     C                   PARM                    MultDivInd                                   CGL159
     C                   PARM                    FrCurrency                                   CGL159
     C                   PARM                    ToCurrency                                   CGL159
     C                   PARM                    FrDecPlace                                   CGL159
     C                   PARM                    ToDecPlace                                   CGL159
     C                   PARM      *ZERO         OutputAmnt                                   CGL159
                                                                                              CGL159
     C                   ENDSR                                                                CGL159
                                                                                              CGL159
      *****************************************************************                       CGL159
      /EJECT                                                                                  CGL159
      *****************************************************************                       CGL159
      *                                                               *                       CGL159
      *  GetSpotRate - Get Spot Rate                                  *                       CGL159
      *                                                               *                       CGL159
      *****************************************************************                       CGL159
     C     GetSpotRate   BEGSR                                                                CGL159
                                                                                              CGL159
     C                   CALL      'ZXRATE'                                                   CGL159
     C                   PARM                    PaSpRt1                                      CGL159
     C                   PARM                    PaMDIn1                                      CGL159
     C                   PARM                    PaSpRt2                                      CGL159
     C                   PARM                    PaMDIn2                                      CGL159
                                                                                              CGL159
     C                   PARM                    WkRate                                       CGL159
     C                   PARM                    WkMDIn                                       CGL159
                                                                                              CGL159
     C                   ENDSR                                                                CGL159
      *****************************************************************                       CGL159
      /EJECT                                                                                  CGL159
      *****************************************************************                       CGL159
      *                                                               *                       CGL159
      *  SRPrintFooter - Print Footer routine                         *                       CGL159
      *                                                               *                       CGL159
      *****************************************************************                       CGL159
     C     SRPrintFooter BEGSR                                                                CGL159
                                                                                              CGL159
     C                   IF        WRecNo > 0                                                 CGL159
                                                                                              CGL159
     C                   EXSR      GETSUBTOTAL                                                CGL159
                                                                                              CGL159
     C                   EVAL      PDBCUR = BJCYCD                                            CGL159
                                                                                              CGL159
     C                   EVAL      RqdLn1 = 2                                                 CGL159
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                   CGL159
                                                                                              CGL159
     C                   IF        DifLn1 <= RqdLn1                                           CGL159
     C                   EXSR      SRPrintHdr1                                                CGL159
     C                   EXSR      SRPrintHdr2                                                CGL159
     C                   ENDIF                                                                CGL159
     C                   If        WPrvPool <> *Blanks                                        CGL159
                                                                                              CGL159
     C                   IF        CGL159 = 'Y'                                               CGL159
     C                   WRITE     SUBPOOL                                                    CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   Endif                                                                CGL159
                                                                                              CGL159
     C                   EVAL      WField = *BLANKS                                           CGL159
     C                   EVAL      WAmount = *Zeros                                           CGL159
     C                   EVAL      PDecPlace = *Zeros                                         CGL159
     C                   EVAL      WAmount = WTotal                                           CGL159
     C                   EVAL      PDecPlace = BA6NBDP                                        CGL159
     C                   EXSR      FormatAmount                                               CGL159
     C                   MOVE      WField        PDTOT                                        CGL159
                                                                                              CGL159
     C                   EVAL      RqdLn1 = 6                                                 CGL159
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                   CGL159
                                                                                              CGL159
     C                   IF        DifLn1 <= RqdLn1                                           CGL159
     C                   EXSR      SRPrintHdr1                                                CGL159
     C                   EXSR      SRPrintHdr2                                                CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   WRITE     TOTAL                                                      CGL159
     C                   WRITE     FOOTER                                                     CGL159
     C                   ENDIF                                                                CGL159
                                                                                              CGL159
     C                   ENDSR                                                                CGL159
      *****************************************************************                       CGL159
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrkFile - Work file                                        *
      *                                                               *
      *****************************************************************
     C*****SRWrkFile     BEGSR                                                                CGL159
      **********                                                                              CGL159
     C*/exec*SQL                                                                              CGL159
     C**declare LISTB cursor for                                                              CGL159
     C**select**                                                                              CGL159
     C**from*SDNOSTPD                                                                         CGL159
     C**order*by                                                                              CGL159
     C****A7CYCD                                                                              CGL159
     C***,A7NONB                                                                              CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
     C*/exec*SQL                                                                              CGL159
     C**open*LISTB                                                                            CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
      ***Handle*SQL*Error*(if*not*%EOF)********************************                       CGL159
      **********                                                                              CGL159
     C**********         If        SQLCOD < 0                                                 CGL159
      **********                                                                              CGL159
     C******LOCK         IN        LDA                                                        CGL159
     C**********         EVAL      DBASE = 004                                                CGL159
     C**********         EVAL      DBFILE = 'SQL STM'                                         CGL159
     C**********         EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                               CGL159
     C**********                         + ';  SQLCOD : ' + %char(SQLCOD)                     CGL159
     C**********         OUT       LDA                                                        CGL159
     C**********         EXSR      *PSSR                                                      CGL159
      **********                                                                              CGL159
     C**********         EndIf                                                                CGL159
      **********                                                                              CGL159
     C*/exec*SQL                                                                              CGL159
     C**fetch*next                                                                            CGL159
     C**from*LISTB                                                                            CGL159
     C**into*:NOST                                                                            CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
      **********                                                                              CGL159
     C**********         DOW       SQLCode <> 100                                             CGL159
      **********                                                                              CGL159
      ***POOL**********************************************************                       CGL159
      **********                                                                              CGL159
     C**********         EXSR      RetrievePOOL                                               CGL159
      **********                                                                              CGL159
      ***Nostro*Code***************************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      BPNOSC = A7NONB                                            CGL159
      **********                                                                              CGL159
      ***Currency******************************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      BPCCY  = A7CYCD                                            CGL159
      **********                                                                              CGL159
      ***Account*******************************************************                       CGL159
      **********                                                                              CGL159
     C**********         MOVE      A7ACSN        WA7ACSN                                      CGL159
     C**********         EVAL      BPACCT  = A7BRCD + A7CUST + A7CYCD + A7ACCD                CGL159
     C**********                             + WA7ACSN                                        CGL159
      **********                                                                              CGL159
      ***Ledger*balance************************************************                       CGL159
      **********                                                                              CGL159
     C**********         MOVE      A7ACCD        PACCD                                        CGL159
     C**********         MOVE      A7ACSN        PACSN                                        CGL159
     C**********         MOVE      A7CUST        PCUST                                        CGL159
     C**********         MOVE      A7CYCD        PCCY                                         CGL159
     C**********         MOVE      A7BRCD        PBRCA                                        CGL159
     C**********         EVAL      BPNOSN = *BLANKS                                           CGL159
     C**********         EXSR      GetAcctDtls                                                CGL159
     C**********         EVAL      BPCLBL = W_LDBL                                            CGL159
     C**********         EVAL      BPNOSN = W_ANAM                                            CGL159
      **********                                                                              CGL159
      ***Projected*Balance*********************************************                       CGL159
      **********                                                                              CGL159
     C**********         EXSR      ProjectedBAL                                               CGL159
      **********                                                                              CGL159
      **********                                                                              CGL159
      ***Forecast*Balance**********************************************                       CGL159
      **********                                                                              CGL159
     C**********         EXSR      ForecastBAL                                                CGL159
      **********                                                                              CGL159
      ***Unreconciled*Balance******************************************                       CGL159
      **********                                                                              CGL159
     C**********         EXSR      UnreconBAL                                                 CGL159
      **********                                                                              CGL159
      **********                                                                              CGL159
      ***Statement*Balance***-*still*on*hold!!!!***********************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      BPSAMT = 0                                                 CGL159
      **********                                                                              CGL159
      **********                                                                              CGL159
      ***Estimated*Exchange*Rate*and*Spot*Rate*Indicator***************                       CGL159
      **********                                                                              CGL159
     C**********         EXSR      RateandSpot                                                CGL159
      **********                                                                              CGL159
      ***Insert*to*file************************************************                       CGL159
      **********                                                                              CGL159
     C*/EXEC SQL                                                                              CGL159
     C**insert*into*SDBPOWTD*******************************************                       CGL159
     C**(******                                                                               CGL159
     C** BPPOOL                                                                               CGL159
     C**,BPCCY*                                                                               CGL159
     C**,BPNOSC                                                                               CGL159
     C**,BPNOSN                                                                               CGL159
     C**,BPACCT                                                                               CGL159
     C**,BPCLBL                                                                               CGL159
     C**,BPFAMT                                                                               CGL159
     C**,BPPAMT                                                                               CGL159
     C**,BPUAMT                                                                               CGL159
     C**,BPSAMT                                                                               CGL159
     C**,BPERAT                                                                               CGL159
     C**,BPMDIN                                                                               CGL159
     C**,BPSPOT                                                                               CGL159
     C**)*******                                                                              CGL159
     C**Values**                                                                              CGL159
     C**(*******                                                                              CGL159
     C** :BPPOOL                                                                              CGL159
     C**,:BPCCY*                                                                              CGL159
     C**,:BPNOSC                                                                              CGL159
     C**,:BPNOSN                                                                              CGL159
     C**,:BPACCT                                                                              CGL159
     C**,:BPCLBL                                                                              CGL159
     C**,:BPFAMT                                                                              CGL159
     C**,:BPPAMT                                                                              CGL159
     C**,:BPUAMT                                                                              CGL159
     C**,:BPSAMT                                                                              CGL159
     C**,:BPERAT                                                                              CGL159
     C**,:BPMDIN                                                                              CGL159
     C**,:BPSPOT                                                                              CGL159
     C**)*******                                                                              CGL159
     C*/END-EXEC                                                                              CGL159
      **********                                                                              CGL159
      **********                                                                              CGL159
     C*/exec SQL                                                                              CGL159
     C**fetch*next from LISTB                                                                 CGL159
     C**into*:NOST                                                                            CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
     C**********         ENDDO                                                                CGL159
      **********                                                                              CGL159
      ***Handle*SQL*Error*(if*not*%EOF)********************************                       CGL159
      **********                                                                              CGL159
     C**********         If        SQLCode < 100                                              CGL159
      **********                                                                              CGL159
     C******LOCK         IN        LDA                                                        CGL159
     C**********         EVAL      DBASE = 005                                                CGL159
     C**********         EVAL      DBFILE = 'SQL STM'                                         CGL159
     C**********         EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                               CGL159
     C**********                         + ';  SQLCOD : ' + %char(SQLCOD)                     CGL159
     C**********         OUT       LDA                                                        CGL159
     C**********         EXSR      *PSSR                                                      CGL159
      **********                                                                              CGL159
     C**********         EndIf                                                                CGL159
      **********                                                                              CGL159
     C*/exec*SQL                                                                              CGL159
     C**close*LISTB                                                                           CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
     C**********         ENDSR                                                                CGL159
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RetrievePOOL - Retrieve Pool                                 *
      *                                                               *
      *****************************************************************
     C*****RetrievePOOL  BEGSR                                                                CGL159
      **********                                                                              CGL159
     C**********         EVAL      sqlString =                                              MD026777
     C**********                   'select COALESCE(POOL,'' '')' +                          MD026777
     C**********                   'into :WPOOL from T_GZNOSREX' +                          MD026777
     C**********                   'where SUBSTR(DDCYCD,1,3) = :A7CYCD' +                   MD026777
     C**********                   '    and DDNONB = :A7NONB' +                             MD026777
     C**********                   '    and ZONE  = :W_ZONE'  +                             MD026777
     C**********                   '    and COALESCE(POOL,'' '') <> '' ''' +                MD026777
     C**********                   'order by' +                                             MD026777
     C**********                   '      POOL DESC'                                        MD026777
     C**********                                                                            MD026777
     C**/exec SQL                                                                           MD026777
     c**+*******         execute immediate :sqlString                                       MD026777
     C**/end-exec                                                                           MD026777
      **********                                                                     MD026777 CGL159
     C*/exec*SQL                                                                     MD026777 CGL159
     C**select*COALESCE(POOL,' ') into :WPOOL from SDBPOLTD                          MD026777 CGL159
     C**where*SUBSTR(DDCYCD,1,3) = :A7CYCD                                           MD026777 CGL159
     C******and*DDNONB = :A7NONB                                                     MD026777 CGL159
     C******and*ZONE  = :W_ZONE                                                      MD026777 CGL159
     C******and*COALESCE(POOL,' ') <> ' '                                            MD026777 CGL159
     C**order*by                                                                     MD026777 CGL159
     C********POOL DESC                                                              MD026777 CGL159
     C*/end-exec                                                                     MD026777 CGL159
      **********                                                                              CGL159
     C**********         IF        SQLCODE <> 0 or WPOOL = *BLANKS                            CGL159
     C**********         EVAL      BPPOOL = *HIVAL                                            CGL159
     C**********         ELSE                                                                 CGL159
     C**********         EVAL      BPPOOL = WPOOL                                             CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         ENDSR                                                                CGL159
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ProjectedBAL - Projected Balance                             *
      *                                                               *
      *****************************************************************
     C*****ProjectedBAL  BEGSR                                                                CGL159
      **********                                                                              CGL159
     C**********         EVAL      WADDAMT = 0                                                CGL159
     C**********         MOVEL     BJRDNB        WBJRDNB                                      CGL159
     C**********         MOVE      A7NONB        WNONB                                        CGL159
     C**********         EVAL      BPPAMT = 0                                                 CGL159
      **********                                                                              CGL159
     C*/exec*SQL                                                                              CGL159
     C**select                                                                                CGL159
     C*****COALESCE(PNB0,0)                                                                   CGL159
     C**into****                                                                              CGL159
     C****:PNB0*                                                                              CGL159
     C**from*GLPRONOW0                                                                        CGL159
     C**where*RECI = 'D'                                                                      CGL159
     C****and*CCY  = :A7CYCD                                                                  CGL159
     C****and*NOSN = :WNONB                                                                   CGL159
     C****and*PND0 = :BJRDNB                                                                  CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
     C**********         IF        SQLCODE = 0                                                CGL159
     C**********         EVAL      WADDAMT = PNB0                                             CGL159
      **********                                                                              CGL159
     C**********         IF        WADDAMT = 0                                                CGL159
     C**********         EVAL      BPPAMT = 0                                                 CGL159
     C**********         ELSE                                                                 CGL159
     C**********         EVAL      BPPAMT = WADDAMT - BPCLBL                                  CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         ELSE                                                                 CGL159
      **********                                                                              CGL159
     C*/exec*SQL                                                                              CGL159
     C**select*SUM(COALESCE(TMVAM,0)) into :WADDAMT from GLRSACMW0                            CGL159
     C**where*CCYD = :A7CYCD                                                                  CGL159
     C****and*A7NONB = :A7NONB                                                                CGL159
     C****and*VUDT = :BJRDNB                                                                  CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
     C**********         IF        SQLCODE = 0                                                CGL159
     C**********         EVAL      BPPAMT = WADDAMT                                           CGL159
     C**********         ENDIF                                                                CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
      **********                                                                              CGL159
     C**********         ENDSR                                                                CGL159
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ForecastBAL - Forecast Balance                               *
      *                                                               *
      *****************************************************************
     C*****ForecastBAL   BEGSR                                                                CGL159
      **********                                                                              CGL159
     C**********         EVAL      BPFAMT = 0                                                 CGL159
      **********                                                                              CGL159
     C*/exec*SQL                                                                              CGL159
     C**select** into :TNOS from GLTNOSTD                                                     CGL159
     C**where*NCCYCD = :A7CYCD                                                                CGL159
     C****and*NCNONB = :A7NONB                                                                CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
     C**********         EVAL      BPFAMT = 0                                                 CGL159
     C**********         IF        SQLCODE = 0                                                CGL159
     C**********         IF        NCDAT0 = BJRDNB                                            CGL159
     C**********         EVAL      BPFAMT = NCAMT0                                            CGL159
     C**********         ENDIF                                                                CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         ENDSR                                                                CGL159
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UnreconBAL  - Unreconciled Balance                           *
      *                                                               *
      *****************************************************************
     C*****UnreconBAL    BEGSR                                                                CGL159
      **********                                                                              CGL159
     C**********         EVAL      BPUAMT = 0                                                 CGL159
      **********                                                                              CGL159
     C*/exec*SQL                                                                              CGL159
     C**select** INTO :NOS2 from SDNOST2D                                                     CGL159
     C**where***                                                                              CGL159
     C********ERNONB = :A7NONB                                                                CGL159
     C****and*ERCYCD = :A7CYCD                                                                CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
     C**********         IF        SQLCODE = 0                                                CGL159
     C**********         MOVE      *BLANKS       WBRANCH                                      CGL159
     C**********         IF        ERBRCA = *BLANKS                                           CGL159
     C**********         EVAL      WBRANCH = A7BRCD                                           CGL159
     C**********         ELSE                                                                 CGL159
     C**********         EVAL      WBRANCH = ERBRCA                                           CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         IF        ERACCD <> 0 and ERACSN <> 0                                CGL159
     C**********         MOVE      ERACCD        PACCD                                        CGL159
     C**********         MOVE      ERACSN        PACSN                                        CGL159
     C**********         MOVE      A7CUST        PCUST                                        CGL159
     C**********         MOVE      ERCYCD        PCCY                                         CGL159
     C**********         MOVE      WBRANCH       PBRCA                                        CGL159
     C**********         EXSR      GetAcctDtls                                                CGL159
     C**********         EVAL      BPUAMT = W_LDBL                                            CGL159
     C**********         ENDIF                                                                CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         ENDSR                                                                CGL159
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RateandSpot - Rate and Spot Indicator                        *
      *                                                               *
      *****************************************************************
     C*****RateandSpot   BEGSR                                                                CGL159
      **********                                                                              CGL159
     C**********         EVAL      BPERAT = 0                                                 CGL159
      **********                                                                              CGL159
     C*/exec SQL                                                                              CGL159
     C**select** into :EERT from SDEERTTD                                                     CGL159
     C**where***                                                                              CGL159
     C********(ERCCY  = :A7CYCD                                                               CGL159
     C****and*ERNOSC = :A7NONB                                                                CGL159
     C****and*ERTCCY = :BJCYCD                                                                CGL159
     C****and*ERDATE = :BJRDNB)                                                               CGL159
     C*****or*(ERCUST = :A7CUST                                                               CGL159
     C****and*ERCCY  = :A7CYCD                                                                CGL159
     C****and*ERTCCY = :BJCYCD                                                                CGL159
     C****and*ERDATE = :BJRDNB)                                                               CGL159
     C**order*by                                                                              CGL159
     C********ERTMST DESC                                                                 MD026756
     C********ERNOSC DESC                                                            MD026756 CGL159
     C*******,ERTMST DESC                                                            MD026756 CGL159
     C*/end-exec                                                                              CGL159
      **********                                                                              CGL159
     C**********         IF        (SQLCODE <> 0 AND SQLCODE <> -811)                         CGL159
     C**********                     OR EREXRT = 0                                            CGL159
     C**********         EVAL      BPSPOT = 'Y'                                               CGL159
     C**********         EVAL      BPERAT = 0                                                 CGL159
     C**********         MOVE      BPCCY         PCCY                                         CGL159
     C**********         EXSR      GetCurrDtls                                                CGL159
     C*****PRtCd         IFEQ      *BLANKS                                                    CGL159
     C**********         EVAL      BPERAT = A6SPRT                                            CGL159
     C**********         EVAL      BPMDIN = A6MDIN                                            CGL159
     C**********         ENDIF                                                                CGL159
     C**********         ELSE                                                                 CGL159
     C**********         EVAL      BPERAT = EREXRT                                            CGL159
     C**********         EVAL      BPSPOT = 'N'                                               CGL159
     C**********         EVAL      BPMDIN = ERMDIN                                            CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         ENDSR                                                                CGL159
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetAcctDtls - Get Account Details (Account Name)             *
      *                                                               *
      *****************************************************************
     C*****GetAcctDtls   BEGSR                                                                CGL159
      **********                                                                              CGL159
     C**********         CALL      'AOACCTR0'                                                 CGL159
     C**********         PARM      *BLANKS       PRtCd                                        CGL159
     C**********         PARM      '*KEY    '    POptn                                        CGL159
     C**********         PARM      *BLANKS       PACNO                                        CGL159
     C**********         PARM                    PCUST                                        CGL159
     C**********         PARM                    PCCY                                         CGL159
     C**********         PARM                    PACCD                                        CGL159
     C**********         PARM                    PACSN                                        CGL159
     C**********         PARM                    PBRCA                                        CGL159
     C*****SDACCT        PARM      SDACCT        DSSDY                                        CGL159
      **********                                                                              CGL159
     C*****PRtCd         IFEQ      *BLANKS                                                    CGL159
     C**********         EVAL      W_LDBL = A_LDBL                                            CGL159
     C**********         EVAL      W_ANAM = A_ANAM                                            CGL159
     C**********         ELSE                                                                 CGL159
     C**********         Z-ADD     *ZERO         W_LDBL                                       CGL159
     C**********         MOVE      *BLANKS       W_ANAM                                       CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         ENDSR                                                                CGL159
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ConvertBase - Convert to Base Currency equivalent            *
      *                                                               *
      *****************************************************************
     C     ConvertBase   BEGSR

     C                   CALL      'ZCONVZ1'
     C                   PARM                    InputAmnt        15 0
     C                   PARM                    ExchRate         13 8
     C                   PARM                    MultDivInd        1
     C                   PARM                    FrCurrency        3
     C                   PARM                    ToCurrency        3
     C                   PARM                    FrDecPlace        1 0
     C                   PARM                    ToDecPlace        1 0
     C                   PARM      *ZERO         OutputAmnt       15 0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FormatAmount - Format Amount Routine                         *
      *                                                               *
      *****************************************************************
     C     FormatAmount  BEGSR

      ** If non-zero, format amount
     C                   IF        WAmount <> 0

     C                   CALL      'ZSEDIT'
     C                   PARM                    WAmount
     C                   PARM                    PDecPlace
     C                   PARM      'J'           PEdtCode
     C                   PARM                    WField

     C                   ELSE

      * If zero, check number of decimal places
     C                   IF        PDecPlace = 0
     C                   EVAL      WField = '                   0 '
     C                   ELSEIF    PDecPlace = 1
     C                   EVAL      WField = '                 0.0 '
     C                   ELSEIF    PDecPlace = 2
     C                   EVAL      WField = '                0.00 '
     C                   ELSEIF    PDecPlace = 3
     C                   EVAL      WField = '               0.000 '
     C                   ELSEIF    PDecPlace = 4
     C                   EVAL      WField = '              0.0000 '
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCurrDtls - Get Currency Details                           *
      *                                                               *
      *****************************************************************
     C     GetCurrDtls   BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY    '    POptn
     C                   PARM                    PCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr1- Print Header 1 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr1   BEGSR

     C                   WRITE     HEADER1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr2- Print Header 2 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr2   BEGSR

      ** Set up Header 2 details

     C                   CLEAR                   HEADER2

      ** Prepare the Header Title to be used (must be centered)

     C                   IF        PMode = 'A'
     C                   EVAL      *IN50 = *OFF
     C                   ELSE
     C                   EVAL      *IN50 = *ON
     C                   ENDIF

      *
      ** Show Company code when CGL176 is enabled                                           CGL176
     C                   IF        CGL176 = 'Y'                                             CGL176
     C                   EVAL      PDCMCD = A8CMCD                                          CGL176
     C                   EVAL      *IN40 = *ON                                              CGL176
     C                   ENDIF                                                              CGL176
      *                                                                                     CGL176

     C                   WRITE     HEADER2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr3- Print Header 3 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr3   BEGSR

     C                   EVAL      PDBCUR = BJCYCD

     C                   WRITE     HEADER3

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintFtr - Print Footer Routine                            *
      *                                                               *
      *****************************************************************
     C*****SRPrintFtr    BEGSR                                                                CGL159
      **********                                                                              CGL159
     C**********         IF        WRecNo > 0                                                 CGL159
      **********                                                                              CGL159
     C**********         EVAL      WField = *BLANKS                                           CGL159
     C**********         EVAL      WAmount = *Zeros                                           CGL159
     C**********         EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount = WSubTot                                          CGL159
     C**********         EVAL      PDecPlace = A6NBDP                                         CGL159
     C**********         EXSR      FormatAmount                                               CGL159
     C**********         MOVE      WField        PDSUB                                        CGL159
      **********                                                                              CGL159
     C**********         EVAL      PDBCUR = BJCYCD                                            CGL159
      **********                                                                              CGL159
     C**********         EVAL      RqdLn1 = 2                                        MD027156 CGL159
     C**********         EVAL      DifLn1 = OFLLN1 - PRTLN1                          MD027156 CGL159
      **********                                                                     MD027156 CGL159
     C**********         IF        DifLn1 <= RqdLn1                                  MD027156 CGL159
     C**********         EXSR      SRPrintHdr1                                       MD027156 CGL159
     C**********         EXSR      SRPrintHdr2                                       MD027156 CGL159
     C**********         ENDIF                                                       MD027156 CGL159
     C**********         If        WPrvPool <> *Blanks and                           MD027241 CGL159
     C**********                   WPrvPool <> *HIVAL                                MD027241 CGL159
     C**********         WRITE     SUBPOOL                                                    CGL159
     C**********         Endif                                                       MD027241 CGL159
      **********                                                                              CGL159
     C**********         EVAL      WField = *BLANKS                                           CGL159
     C**********         EVAL      WAmount = *Zeros                                           CGL159
     C**********         EVAL      PDecPlace = *Zeros                                         CGL159
     C**********         EVAL      WAmount = WTotal                                           CGL159
     C**********         EVAL      PDecPlace = A6NBDP                                         CGL159
     C**********         EXSR      FormatAmount                                               CGL159
     C**********         MOVE      WField        PDTOT                                        CGL159
      **********                                                                              CGL159
     C**********         EVAL      RqdLn1 = 6                                        MD026777 CGL159
     C**********         EVAL      DifLn1 = OFLLN1 - PRTLN1                          MD026777 CGL159
      **********                                                                     MD026777 CGL159
     C**********         IF        DifLn1 <= RqdLn1                                  MD026777 CGL159
     C**********         EXSR      SRPrintHdr1                                       MD026777 CGL159
     C**********         EXSR      SRPrintHdr2                                       MD026777 CGL159
     C**********         ENDIF                                                       MD026777 CGL159
      **********                                                                              CGL159
     C**********         WRITE     TOTAL                                                      CGL159
     C**********         WRITE     FOOTER                                                     CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         EXSR      SRAudit                                                    CGL159
      **********                                                                              CGL159
     C**********         ENDSR                                                                CGL159
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR

      ** Ensure Audit Spool File recorded by RCF.

     C                   EVAL      ZSnumU = SFNUMU

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *InU7 = *On
     C                   EVAL      *InU8 = *On
     C                   EVAL      *InLR = *On
     C                   RETURN
     C                   ENDIF

     C                   WRITE     HEADAU

     C                   EVAL      RCOUNT = WRecNo

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE

      ** If there is a record read, write audit control report.

     C                   IF        WRecNo <> 0
     C                   WRITE     CONTROL
     C                   ELSE

      ** Or, if no records read, Output "No Details" message.

     C                   WRITE     NODTLS
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

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty

      ** Set off program indicators

     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

      ** Access Bank details
      **   Retrieve Run day number

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
     C                   ELSE
     C                   EVAL      RRPTDS = BJURPT
     C                   ENDIF

      ** Ensure Detail Spool File recorded by RCF.

     C**********         EVAL      ZSnum = SFNUM1                                             CGL176

     C**********         CALL      'ZSFILE'                                                   CGL176
     C**********         PARM                    PSeq                                         CGL176
     C**********         PARM      *Blanks       SEnty                                        CGL176
     C**********         PARM                    SFILE1                                       CGL176
     C**********         PARM                    ZSnum                                        CGL176
     C**********         PARM      *Blanks       ZSerr                                        CGL176

     C**********         IF        ZSErr = 'Y'                                                CGL176
     C**********         EVAL      *INU7 = *On                                                CGL176
     C**********         EVAL      *INU8 = *On                                                CGL176
     C**********         EVAL      *INLR = *On                                                CGL176
     C**********         RETURN                                                               CGL176
     C**********         ENDIF                                                                CGL176
                                                                                              CGL159
      ** Get BASE CCY Details                                                                 CGL159
     C                   EVAL      PCCY = BJCYCD                                              CGL159
     C                   EXSR      GetCurrDtls                                                CGL159
     C                   EVAL      BA6CYCD  =   A6CYCD                                        CGL159
     C                   EVAL      BA6SPRT  =   A6SPRT                                        CGL159
     C                   EVAL      BA6NBDP  =   A6NBDP                                        CGL159
     C                   EVAL      BA6MDIN  =   A6MDIN                                        CGL159
                                                                                              CGL159
                                                                                              CGL159
      ** Check if CGL159 is On.                                                               CGL159
      *                                                                                       CGL159
     C                   EVAL      CGL159 = 'N'                                               CGL159
      *                                                                                       CGL159
     C                   CALL      'AOSARDR0'                                                 CGL159
     C                   PARM      *Blanks       @RTCD                                        CGL159
     C                   PARM      '*VERIFY'     @OPTN                                        CGL159
     C                   PARM      'CGL159'      @SARD                                        CGL159
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL159
      *                                                                                       CGL159
     C                   IF        @RTCD = *Blanks                                            CGL159
     C                   EVAL      CGL159 = 'Y'                                               CGL159
     C                   ENDIF                                                                CGL159

      ** Check if CGL176 is On.                                                               CGL176
      *                                                                                       CGL176
     C                   EVAL      CGL176 = 'N'                                               CGL176
      *                                                                                       CGL176
     C                   CALL      'AOSARDR0'                                                 CGL176
     C                   PARM      *Blanks       @RTCD                                        CGL176
     C                   PARM      '*VERIFY'     @OPTN                                        CGL176
     C                   PARM      'CGL176'      @SARD                                        CGL176
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL176
      *                                                                                       CGL176
     C                   IF        @RTCD = *Blanks                                            CGL176
     C                   EVAL      CGL176 = 'Y'                                               CGL176
     C                   ENDIF                                                                CGL176


      **Retrieve*the*system*value**************************************                       CGL159
      **********                                                                              CGL159
     C**********         EVAL      SVALK1 = 'ZoneSystemName'                                  CGL159
     C**********         CALL      'AOSVALR0'                                                 CGL159
     C**********         PARM                    PRtCd                                        CGL159
     C**********         PARM                    SVALK1                                       CGL159
     C**********         PARM                    SVAL1                                        CGL159
     C**********         PARM                    SVALK2                                       CGL159
     C**********         PARM                    SVAL2                                        CGL159
     C**********         PARM                    SVALK3                                       CGL159
     C**********         PARM                    SVAL3                                        CGL159
     C**********         PARM                    SVALK4                                       CGL159
     C**********         PARM                    SVAL4                                        CGL159
     C**********         PARM                    SVALK5                                       CGL159
     C**********         PARM                    SVAL5                                        CGL159
     C**********         PARM                    SVALK6                                       CGL159
     C**********         PARM                    SVAL6                                        CGL159
     C**********         PARM                    SVALK7                                       CGL159
     C**********         PARM                    SVAL7                                        CGL159
     C**********         PARM                    SVALK8                                       CGL159
     C**********         PARM                    SVAL8                                        CGL159
     C**********         PARM                    SVALK9                                       CGL159
     C**********         PARM                    SVAL9                                        CGL159
     C**********         PARM                    SVALK0                                       CGL159
     C**********         PARM                    SVAL10                                       CGL159
      **********                                                                              CGL159
      ***If*the*system*value*is*not*found*then*issue*a*database*error**                       CGL159
      **********                                                                              CGL159
     C*****PRtCd         IFNE      '       '                                                  CGL159
     C**********         EXSR      *PSSR                                                      CGL159
     C**********         ENDIF                                                                CGL159
      **********                                                                              CGL159
     C**********         MOVEL     SVAL1         W_ZONE                                       CGL159
      **********                                                                              CGL159
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
     C                   EVAL      ReturnCode = '*ERROR'

     C                   EXSR      SRAUDIT

     C                   RETURN

     C                   ENDSR
      /EJECT
      *****************************************************************
