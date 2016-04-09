     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Accounting Rules Generated Posting Report')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GL000584P*-*Midas*OF*Accounting*Rules*Generated*Posting*******                     MD029739
      *  DI000584P - Midas OF Accounting Rules Generated Posting      *                     MD029739
      *              Report                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029739 *RENAMED* Date 15Aug14               *
      *  Prev Amend No. MD024772           Date 03Feb14               *
      *                 MD024513           Date 23Jan14               *
      *                 MD024113           Date 17Dec13               *
      *                 MD023743           Date 29Nov13               *
      *                 MD023825           Date 28Nov13               *
      *                 MD023837           Date 27Nov13               *
      *                 MD023628           Date 18Nov13               *
      *                 CGL135A  *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029739 - File renaming for integration layer.              *
      *  MD024772 - Problems with Accounting Interface postings and   *
      *             enquiries.                                        *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules.                                            *
      *  MD024113 - Setup of posting amount not correct for imbalance *
      *             Item                                              *
      *  MD023743 - Matching Rules Check Changes to include DR/CR ind *
      *  MD023825 - Missing reports called during Accounting Rules    *
      *             Process                                           *
      *  MD023837 - Triggers on tables GLACMNTD, GLACBHTD, GLACBDTD   *
      *             failed (Recompile)                                *
      *  MD023628 - Accounting Rules Process                          *
      *  CGL135A - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GL Accounting Rules Audit/List report - Detail
     F***GL000584P1O E             PRINTER INFSR(*PSSR)                                     MD029739
     FDI000584P1O    E             PRINTER INFSR(*PSSR)                                     MD029739
     F                                     INFDS(SPOOL1)
 
      ** Midas GL Accounting Rules List report - Audit list
     F***GL000584AUO E             PRINTER INFDS(SPOOLU)                                    MD029739
     FDI000584AUO    E             PRINTER INFDS(SPOOLU)                                    MD029739
     F                                     INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  Extname(DSSDY)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     ** File DS
     **   Midas GL Accounting Rules
     D*ACBD*****     E DS                  EXTNAME(GLACBDTD)                                MD029739
     D ACBD          E DS                  EXTNAME(DIACBDTD)                                MD029739
 
 
      ** File Information Data Structure for SD000764P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD000764AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Parameter data
     D PData           DS
     D  Data                   1    100A
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PSARD           S              6
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameter for ZDATE2
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
 
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
 
      ** Other fields used
     D WRun            S              1A   Inz
     D WRecNo          S              7S 0 Inz
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D CGL145          S              1A
 
     D WField          S             21A
     D PEdtCode        S              1A
     D PDecPlace       S              1  0
     D WAmount         S             15  0
 
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
 
      ** Set file pointer to first record and do initial read.
 
     C/exec SQL
     C+ declare LIST cursor for
     C*+*elect** from GLACBDTD                                                              MD029739
     C+ select * from DIACBDTD                                                              MD029739
     C+ order by
     C+       BDBTID,
     C+       BDBKBR,
     C+       BDDPCD
     C/end-exec
 
     C/exec SQL
     C+ open LIST
     C/end-exec
 
      ** Handle SQL Error (if not %EOF)
 
     C                   If        SQLCOD < 0
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   EndIf
 
 
     C/exec SQL
     C+ fetch next
     C+ from LIST
     C+ into: ACBD
     C/end-exec
 
      ** Read Accounting Rules Batch Details until end of file
 
     C                   DOW       SQLCode <> 100
                                                                                            MD023825
     C                   IF        Pmode <> 'A' or BDGERP <> 'Y'                            MD023825
 
      ** Print Report Header 1
 
     C                   EXSR      SRPrintHdr1
 
      ** Print Report Header 2
 
     C                   EXSR      SRPrintHdr2
 
      ** Print Details
 
     C                   EXSR      SRPrintDtl
 
     C                   EVAL      WRecNo = WRecNo + 1
 
     C                   ENDIF                                                              MD023825
                                                                                            MD023825
     C/exec SQL
     C+ fetch next from LIST
     C+ into :ACBD
     C/end-exec
 
     C                   ENDDO
 
      ** Handle SQL Error (if not %EOF)
 
     C                   If        SQLCode < 100
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   EndIf
 
     C/exec SQL
     C+ close LIST
     C/end-exec
 
     C                   EXSR      SRPrintFtr
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
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
 
     C                   WRITE     HEADER2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintDtl - Print Detail Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintDtl    BEGSR
 
      ** Set up Details
 
     C                   CLEAR                   DETAIL
 
      ** Batch ID
 
     C                   EVAL      PEBTID = BDBTID
 
      ** Status
 
     C                   SELECT
     C                   WHEN      BDCRST = 'I'
     C                   EVAL      PESTAT = 'Missing Accounting Rule'
     C                   WHEN      BDCRST = 'U'
     C                   EVAL      PESTAT = 'Missing Accounting Rule with ' +
     C                                      'posting generation'
     C                   WHEN      BDCRST = 'M'
     C                   EVAL      PESTAT = 'Matched Accounting Rule'
     C                   ENDSL
 
      ** Booking Branch
 
     C                   EVAL      PEBKBR = BDBKBR
 
      ** Department
 
     C                   EVAL      PEDPCD = BDDPCD
 
      ** Currency
 
     C                   EVAL      PECCY  = BDCCY
 
      ** Event Amount
 
     C                   EXSR      GetCurrDtls                                  MD023743
     C                   EVAL      WField = *BLANKS                             MD023743
     C                   EVAL      WAmount = *Zeros                             MD023743
     C                   EVAL      PDecPlace = *Zeros                           MD023743
     C                   MOVE      BDEVTA        WAmount                        MD023743
     C                   EVAL      PDecPlace = A6NBDP                           MD023743
     C                   EXSR      FormatAmount                                 MD023743
     C                   MOVE      WField        PEEVTA                         MD023743
 
      ** DR/CR
 
     C                   EVAL      PEDCIP = BDDCIP
 
      ** Posting Date
 
     C                   EVAL      ZDAYNO = BDPSTD
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANK        ZADATE
 
     C                   MOVEL     ZDATE         PEPSTD
 
      ** Event Date
 
     C                   EVAL      ZDAYNO = BDEVTD
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANK        ZADATE
 
     C                   MOVEL     ZDATE         PEEVTD
 
      ** Narrative
 
     C                   EVAL      PENARR = BDNARR
     C                   EVAL      PENAR2 = BDNAR2
     C                   EVAL      PENAR3 = BDNAR3
     C                   EVAL      PENAR4 = BDNAR4
     C                   EVAL      PENAR5 = BDNAR5
     C                   EVAL      PENAR6 = BDNAR6
     C                   EVAL      PENAR7 = BDNAR7
 
      ** Sett A/c DR
 
     C                   EVAL      PESADR = BDSADR
 
      ** Sett A/c CR
 
     C                   EVAL      PESACR = BDSACR
 
      ** Customers: Counterparty
 
     C                   EVAL      PECTPY = BDCTPY
 
      ** Depot
 
     C                   EVAL      PEDPCN = BDDPCN
 
      ** Issuing
 
     C                   EVAL      PEISCN = BDISCN
 
      ** Associated
 
     C                   EVAL      PEASCN = BDASCN
 
      ** MatchField1
 
     C                   EVAL      PESMT1 = BDSMT1
 
      ** MatchField2
 
     C                   EVAL      PESMT2 = BDSMT2
 
      ** MatchField3
 
     C                   EVAL      PESMT3 = BDSMT3
 
      ** MatchField4
 
     C                   EVAL      PESMT4 = BDSMT4
 
      ** MatchField5
 
     C                   EVAL      PESMT5 = BDSMT5
 
      ** MatchField6
 
     C                   EVAL      PESMT6 = BDSMT6
 
      ** MatchField7
 
     C                   EVAL      PESMT7 = BDSMT7
 
      ** MatchField8
 
     C                   EVAL      PESMT8 = BDSMT8
 
      ** MatchField9
 
     C                   EVAL      PESMT9 = BDSMT9
 
      ** MatchField10
 
     C                   EVAL      PESMT10 = BDSMT10
 
      ** DR/CR
 
     C                   EVAL      PEDCRD = BDDCIP
 
      ** Profit Centre
 
     C                   EVAL      PEPFCT = BDPFCT
 
      ** SWIFT Ref
 
     C                   EVAL      PESWFR = BDSWFR
 
      ** Cheque No
 
     C                   MOVE      BDCHQN        PECHQN
 
      ** Book Code
 
     C                   EVAL      PEBKCD = BDBKCD
 
      ** Source Customer
 
     C                   EVAL      PESRCN = BDSRCN
                                                                                            MD024513
      ** Unique ID Identifier                                                               MD024513
                                                                                            MD024513
     C                   EVAL      PEUNID = BDUNID                                          MD024513
                                                                                            MD024513
      ** Description                                                                        MD024513
                                                                                            MD024513
     C                   EVAL      PEDESC = BDDESC                                          MD024513
                                                                                            MD024772
      ** Customer Account from Interface                                                    MD024772
                                                                                            MD024772
     C                   EVAL      PICUSA = BICUSA                                          MD024772
                                                                                            MD024772
      ** Transaction Sub Type from Interface                                                MD024772
                                                                                            MD024772
     C                   EVAL      PITSTY = BITSTY                                          MD024772
 
      ** Reversal Ind
 
     C                   EVAL      PERVID = BDRVID
 
 
     C                   IF        CGL145 = 'Y'
     C                   EVAL      *IN80 = *ON
 
      ** Customer Source Account ID
 
     C                   EVAL      PECSAI = BDCSAI
 
      ** Operation Type
 
     C                   EVAL      PEOPTP = BDOPTP
 
      ** Forecast Reference
 
     C                   EVAL      PEFCRF = BDFCRF
 
     C                   ENDIF
 
      ** Print Report Headers for every new page
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRPrintHdr1
     C                   EXSR      SRPrintHdr2
     C                   ENDIF
 
     C                   WRITE     DETAIL
 
      ** Debit 1
      ** =======
 
      ** Debit - Retail Transaction Type
 
     C                   IF        BDDCIN  = 'D'
 
     C                   EVAL      PETTLE = 'Debit'
     C                   MOVE      BDTTDR        PETTDR
 
     C                   WRITE     DBCR01
 
     C                   IF        BDLXDCI1 <> ' '
     C                   EVAL      PETITL = 'Debit 1'
     C                   EVAL      PEDRCR = 'DR'
 
      ** Narrative Code
 
     C                   EVAL      PENRCD = BDNADR1
 
      ** Received Narrative
 
     C                   EVAL      PERCNR = BDRNDR1
 
      ** Posting Reference
 
     C                   EVAL      PEPSRF = BDPRFD1
 
      ** Branch
 
     C****************** EVAL      PEBRCH = BDBCDR1                             MD024113
     C                   EVAL      PEBRCH = BDIBCA                              MD024113
 
      ** Customer
 
     C****************** MOVE      BDCNDR1       PECUST                         MD024113
     C                   MOVEL     BDACID        PECUST                         MD024113
 
      ** Currency
 
     C                   EVAL      PECURR = BDCYCD
 
      ** Account Code
 
     C****************** EVAL      PEACOD = BDACDR1                             MD024113
     C                   MOVEL     BDACCD        PEACOD                         MD024113
 
      ** Account Sequence
 
     C****************** EVAL      PESEQN = BDASDR1                             MD024113
     C                   MOVEL     BDACSN        PESEQN                         MD024113
 
      ** Amount
 
     C****************** EXSR      GetCurrDtls                                  MD023743
     C****************** EVAL      WField = *BLANKS                             MD023743
     C****************** EVAL      WAmount = *Zeros                             MD023743
     C****************** EVAL      PDecPlace = *Zeros                           MD023743
     C****************** MOVE      BDLXPTA1      WAmount                        MD023743
     C****************** EVAL      PDecPlace = A6NBDP                           MD023743
     C****************** EXSR      FormatAmount                                 MD023743
     C****************** MOVE      WField        PEAMNT                         MD023743
     C                   MOVE      BDPTAM        PEAMNT                         MD023743
 
 
      ** Narrative
 
     C                   EVAL      PETEXT = BDINAR
 
      ** Posting Date
 
     C****************** EVAL      ZDAYNO = BDNPSDT                             MD023628
                                                                                MD023628
     C****************** CALL      'ZDATE2'                                     MD023628
     C****************** PARM                    ZDAYNO                         MD023628
     C****************** PARM                    BJDFIN                         MD023628
     C****************** PARM      *ZERO         ZDATE                          MD023628
     C****************** PARM      *BLANK        ZADATE                         MD023628
                                                                                MD023628
     C****************** MOVEL     ZADATE        PEPSDT                         MD023628
     C                   MOVEL     BDNPSDT       PEPSDT                         MD023628
 
      ** Value Date
 
     C*******************MOVE      BDVLDT        ZDAYNO                         MD023743
                                                                                MD023743
     C*******************CALL      'ZDATE2'                                     MD023743
     C*******************PARM                    ZDAYNO                         MD023743
     C*******************PARM                    BJDFIN                         MD023743
     C*******************PARM      *ZERO         ZDATE                          MD023743
     C*******************PARM      *BLANK        ZADATE                         MD023743
                                                                                MD023743
     C*******************MOVEL     ZADATE        PEVLDT                         MD023743
     C                   MOVEL     BDVLDT        PEVLDT                         MD023743
 
      ** Transaction type
 
     C                   EVAL      PETRAN = BDTRTY
 
      ** Transaction reference
 
     C                   EVAL      PERFUP = BDBTNB
     C                   EVAL      PERFDW = BDBINB
 
      ** Extended Narrative
 
     C                   IF        BDADIF1 = BDNAR2 AND BDADIF2 = BDNAR3
     C                             AND BDADIF3 = BDNAR4 AND BDADIF4 = BDNAR5
     C                             AND BDADIF5 = BDNAR6 AND BDADIF6 = BDNAR7
 
     C                   EVAL      PENAR1 = 'see narrative above'
 
     C                   WRITE     DET01
 
     C                   ELSE
 
     C                   EVAL      PENAR1 = BDADIF1
 
     C                   WRITE     DET01
 
     C                   EVAL      PENRR2 = BDADIF2
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF3
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF4
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF5
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF6
     C                   WRITE     DET02
 
     C                   ENDIF
     C                   ENDIF
 
      ** Debit 2
      ** =======
 
     C                   IF        BDLXDCI2 <> ' '
     C                   CLEAR                   DET01
     C                   CLEAR                   DET02
     C                   EVAL      PETITL = 'Debit 2'
     C                   EVAL      PEDRCR = 'DR'
 
      ** Narrative Code
 
     C                   EVAL      PENRCD = BDNADR2
 
      ** Received Narrative
 
     C                   EVAL      PERCNR = BDRNDR2
 
      ** Posting Reference
 
     C                   EVAL      PEPSRF = BDPRFD2
 
      ** Branch
 
     C****************** EVAL      PEBRCH = BDBCDR2                             MD024113
     C                   EVAL      PEBRCH = BDIBCA                              MD024113
 
      ** Customer
 
     C****************** MOVE      BDCNDR2       PECUST                         MD024113
     C                   MOVEL     BDACID        PECUST                         MD024113
 
      ** Currency
 
     C                   EVAL      PECURR = BDCYCD
 
      ** Account Code
 
     C****************** EVAL      PEACOD = BDACDR2                             MD024113
     C                   MOVEL     BDACCD        PEACOD                         MD024113
 
      ** Account Sequence
 
     C****************** EVAL      PESEQN = BDASDR2                             MD024113
     C                   MOVEL     BDACSN        PESEQN                         MD024113
 
      ** Amount
 
     C****************** EXSR      GetCurrDtls                                  MD023743
     C****************** EVAL      WField = *BLANKS                             MD023743
     C****************** EVAL      WAmount = *Zeros                             MD023743
     C****************** EVAL      PDecPlace = *Zeros                           MD023743
     C****************** MOVE      BDLXPTA2      WAmount                        MD023743
     C****************** EVAL      PDecPlace = A6NBDP                           MD023743
     C****************** EXSR      FormatAmount                                 MD023743
     C****************** MOVE      WField        PEAMNT                         MD023743
     C                   MOVE      BDPTAM        PEAMNT                         MD023743
 
      ** Narrative
 
     C                   EVAL      PETEXT = BDINAR
 
      ** Posting Date
 
     C****************** EVAL      ZDAYNO = BDNPSDT                             MD023628
                                                                                MD023628
     C****************** CALL      'ZDATE2'                                     MD023628
     C****************** PARM                    ZDAYNO                         MD023628
     C****************** PARM                    BJDFIN                         MD023628
     C****************** PARM      *ZERO         ZDATE                          MD023628
     C****************** PARM      *BLANK        ZADATE                         MD023628
                                                                                MD023628
     C****************** MOVEL     ZADATE        PEPSDT                         MD023628
     C                   MOVEL     BDNPSDT       PEPSDT                         MD023628
 
      ** Value Date
 
     C*******************MOVE      BDVLDT        ZDAYNO                         MD023743
                                                                                MD023743
     C*******************CALL      'ZDATE2'                                     MD023743
     C*******************PARM                    ZDAYNO                         MD023743
     C*******************PARM                    BJDFIN                         MD023743
     C*******************PARM      *ZERO         ZDATE                          MD023743
     C*******************PARM      *BLANK        ZADATE                         MD023743
                                                                                MD023743
     C*******************MOVEL     ZADATE        PEVLDT                         MD023743
     C                   MOVEL     BDVLDT        PEVLDT                         MD023743
 
      ** Transaction type
 
     C                   EVAL      PETRAN = BDTRTY
 
      ** Transaction reference
 
     C                   EVAL      PERFUP = BDBTNB
     C                   EVAL      PERFDW = BDBINB
 
      ** Extended Narrative
 
     C                   IF        BDADIF1 = BDNAR2 AND BDADIF2 = BDNAR3
     C                             AND BDADIF3 = BDNAR4 AND BDADIF4 = BDNAR5
     C                             AND BDADIF5 = BDNAR6 AND BDADIF6 = BDNAR7
 
     C                   EVAL      PENAR1 = 'see narrative above'
 
     C                   WRITE     DET01
 
     C                   ELSE
 
     C                   EVAL      PENAR1 = BDADIF1
 
     C                   WRITE     DET01
 
     C                   EVAL      PENRR2 = BDADIF2
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF3
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF4
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF5
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF6
     C                   WRITE     DET02
 
     C                   ENDIF
     C                   ENDIF
 
      ** Debit 3
      ** =======
 
     C                   IF        BDLXDCI3 <> ' '
     C                   CLEAR                   DET01
     C                   CLEAR                   DET02
     C                   EVAL      PETITL = 'Debit 3'
     C                   EVAL      PEDRCR = 'DR'
 
      ** Narrative Code
 
     C                   EVAL      PENRCD = BDNADR3
 
      ** Received Narrative
 
     C                   EVAL      PERCNR = BDRNDR3
 
      ** Posting Reference
 
     C                   EVAL      PEPSRF = BDPRFD3
 
      ** Branch
 
     C****************** EVAL      PEBRCH = BDBCDR3                             MD024113
     C                   EVAL      PEBRCH = BDIBCA                              MD024113
 
      ** Customer
 
     C****************** MOVE      BDCNDR3       PECUST                         MD024113
     C                   MOVEL     BDACID        PECUST                         MD024113
 
      ** Currency
 
     C                   EVAL      PECURR = BDCYCD
 
      ** Account Code
 
     C****************** EVAL      PEACOD = BDACDR3                             MD024113
     C                   MOVEL     BDACCD        PEACOD                         MD024113
 
      ** Account Sequence
 
     C****************** EVAL      PESEQN = BDASDR3                             MD024113
     C                   MOVEL     BDACSN        PESEQN                         MD024113
 
      ** Amount
 
     C****************** EXSR      GetCurrDtls                                  MD023743
     C****************** EVAL      WField = *BLANKS                             MD023743
     C****************** EVAL      WAmount = *Zeros                             MD023743
     C****************** EVAL      PDecPlace = *Zeros                           MD023743
     C****************** MOVE      BDLXPTA3      WAmount                        MD023743
     C****************** EVAL      PDecPlace = A6NBDP                           MD023743
     C****************** EXSR      FormatAmount                                 MD023743
     C****************** MOVE      WField        PEAMNT                         MD023743
     C                   MOVE      BDPTAM        PEAMNT                         MD023743
 
      ** Narrative
 
     C                   EVAL      PETEXT = BDINAR
 
      ** Posting Date
 
     C****************** EVAL      ZDAYNO = BDNPSDT                             MD023628
                                                                                MD023628
     C****************** CALL      'ZDATE2'                                     MD023628
     C****************** PARM                    ZDAYNO                         MD023628
     C****************** PARM                    BJDFIN                         MD023628
     C****************** PARM      *ZERO         ZDATE                          MD023628
     C****************** PARM      *BLANK        ZADATE                         MD023628
                                                                                MD023628
     C****************** MOVEL     ZADATE        PEPSDT                         MD023628
     C                   MOVEL     BDNPSDT       PEPSDT                         MD023628
 
      ** Value Date
 
     C*******************MOVE      BDVLDT        ZDAYNO                         MD023743
                                                                                MD023743
     C*******************CALL      'ZDATE2'                                     MD023743
     C*******************PARM                    ZDAYNO                         MD023743
     C*******************PARM                    BJDFIN                         MD023743
     C*******************PARM      *ZERO         ZDATE                          MD023743
     C*******************PARM      *BLANK        ZADATE                         MD023743
                                                                                MD023743
     C*******************MOVEL     ZADATE        PEVLDT                         MD023743
     C                   MOVEL     BDVLDT        PEVLDT                         MD023743
 
      ** Transaction type
 
     C                   EVAL      PETRAN = BDTRTY
 
      ** Transaction reference
 
     C                   EVAL      PERFUP = BDBTNB
     C                   EVAL      PERFDW = BDBINB
 
      ** Extended Narrative
 
     C                   IF        BDADIF1 = BDNAR2 AND BDADIF2 = BDNAR3
     C                             AND BDADIF3 = BDNAR4 AND BDADIF4 = BDNAR5
     C                             AND BDADIF5 = BDNAR6 AND BDADIF6 = BDNAR7
 
     C                   EVAL      PENAR1 = 'see narrative above'
 
     C                   WRITE     DET01
 
     C                   ELSE
 
     C                   EVAL      PENAR1 = BDADIF1
 
     C                   WRITE     DET01
 
     C                   EVAL      PENRR2 = BDADIF2
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF3
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF4
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF5
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF6
     C                   WRITE     DET02
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Credit 1
      ** ========
 
      ** Credit - Retail Transaction Type
 
     C                   IF        BDDCIN  = 'C'
     C                   EVAL      PETTLE = 'Credit'
     C                   MOVE      BDTTCR        PETTDR
 
     C                   WRITE     DBCR01
 
     C                   IF        BDLXDCI1 <> ' '
     C                   CLEAR                   DET01
     C                   CLEAR                   DET02
     C                   EVAL      PETITL = 'Credit 1'
     C                   EVAL      PEDRCR = 'CR'
 
      ** Narrative Code
 
     C                   EVAL      PENRCD = BDNACR1
 
      ** Received Narrative
 
     C                   EVAL      PERCNR = BDRNCR1
 
      ** Posting Reference
 
     C                   EVAL      PEPSRF = BDPRFC1
 
      ** Branch
 
     C****************** EVAL      PEBRCH = BDBCCR1                             MD024113
     C                   EVAL      PEBRCH = BDIBCA                              MD024113
 
      ** Customer
 
     C****************** MOVE      BDCNCR1       PECUST                         MD024113
     C                   MOVEL     BDACID        PECUST                         MD024113
 
      ** Currency
 
     C                   EVAL      PECURR = BDCYCD
 
      ** Account Code
 
     C****************** EVAL      PEACOD = BDACCR1                             MD024113
     C                   MOVEL     BDACCD        PEACOD                         MD024113
 
      ** Account Sequence
 
     C****************** EVAL      PESEQN = BDASCR1                             MD024113
     C                   MOVEL     BDACSN        PESEQN                         MD024113
 
      ** Amount
 
     C****************** EXSR      GetCurrDtls                                  MD023743
     C****************** EVAL      WField = *BLANKS                             MD023743
     C****************** EVAL      WAmount = *Zeros                             MD023743
     C****************** EVAL      PDecPlace = *Zeros                           MD023743
     C****************** MOVE      BDLXPTA1      WAmount                        MD023743
     C****************** EVAL      PDecPlace = A6NBDP                           MD023743
     C****************** EXSR      FormatAmount                                 MD023743
     C****************** MOVE      WField        PEAMNT                         MD023743
     C                   MOVE      BDPTAM        PEAMNT                         MD023743
 
      ** Narrative
 
     C                   EVAL      PETEXT = BDINAR
 
      ** Posting Date
 
     C****************** EVAL      ZDAYNO = BDNPSDT                             MD023628
                                                                                MD023628
     C****************** CALL      'ZDATE2'                                     MD023628
     C****************** PARM                    ZDAYNO                         MD023628
     C****************** PARM                    BJDFIN                         MD023628
     C****************** PARM      *ZERO         ZDATE                          MD023628
     C****************** PARM      *BLANK        ZADATE                         MD023628
                                                                                MD023628
     C****************** MOVEL     ZADATE        PEPSDT                         MD023628
     C                   MOVEL     BDNPSDT       PEPSDT                         MD023628
 
      ** Value Date
 
     C*******************MOVE      BDVLDT        ZDAYNO                         MD023743
                                                                                MD023743
     C*******************CALL      'ZDATE2'                                     MD023743
     C*******************PARM                    ZDAYNO                         MD023743
     C*******************PARM                    BJDFIN                         MD023743
     C*******************PARM      *ZERO         ZDATE                          MD023743
     C*******************PARM      *BLANK        ZADATE                         MD023743
                                                                                MD023743
     C*******************MOVEL     ZADATE        PEVLDT                         MD023743
     C                   MOVEL     BDVLDT        PEVLDT                         MD023743
 
      ** Transaction type
 
     C                   EVAL      PETRAN = BDTRTY
 
      ** Transaction reference
 
     C                   EVAL      PERFUP = BDBTNB
     C                   EVAL      PERFDW = BDBINB
 
      ** Extended Narrative
 
     C                   IF        BDADIF1 = BDNAR2 AND BDADIF2 = BDNAR3
     C                             AND BDADIF3 = BDNAR4 AND BDADIF4 = BDNAR5
     C                             AND BDADIF5 = BDNAR6 AND BDADIF6 = BDNAR7
 
     C                   EVAL      PENAR1 = 'see narrative above'
 
     C                   WRITE     DET01
 
     C                   ELSE
 
     C                   EVAL      PENAR1 = BDADIF1
 
     C                   WRITE     DET01
 
     C                   EVAL      PENRR2 = BDADIF2
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF3
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF4
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF5
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF6
     C                   WRITE     DET02
 
     C                   ENDIF
     C                   ENDIF
 
      ** Credit 2
      ** ========
 
     C                   IF        BDLXDCI2 <> ' '
     C                   CLEAR                   DET01
     C                   CLEAR                   DET02
     C                   EVAL      PETITL = 'Credit 2'
     C                   EVAL      PEDRCR = 'CR'
 
      ** Narrative Code
 
     C                   EVAL      PENRCD = BDNACR2
 
      ** Received Narrative
 
     C                   EVAL      PERCNR = BDRNCR2
 
      ** Posting Reference
 
     C                   EVAL      PEPSRF = BDPRFC2
 
      ** Branch
 
     C****************** EVAL      PEBRCH = BDBCCR2                             MD024113
     C                   EVAL      PEBRCH = BDIBCA                              MD024113
 
      ** Customer
 
     C****************** MOVE      BDCNCR2       PECUST                         MD024113
     C                   MOVEL     BDACID        PECUST                         MD024113
 
      ** Currency
 
     C                   EVAL      PECURR = BDCYCD
 
      ** Account Code
 
     C****************** EVAL      PEACOD = BDACCR2                             MD024113
     C                   MOVEL     BDACCD        PEACOD                         MD024113
 
      ** Account Sequence
 
     C****************** EVAL      PESEQN = BDASCR2                             MD024113
     C                   MOVEL     BDACSN        PESEQN                         MD024113
 
      ** Amount
 
     C****************** EXSR      GetCurrDtls                                  MD023743
     C****************** EVAL      WField = *BLANKS                             MD023743
     C****************** EVAL      WAmount = *Zeros                             MD023743
     C****************** EVAL      PDecPlace = *Zeros                           MD023743
     C****************** MOVE      BDLXPTA2      WAmount                        MD023743
     C****************** EVAL      PDecPlace = A6NBDP                           MD023743
     C****************** EXSR      FormatAmount                                 MD023743
     C****************** MOVE      WField        PEAMNT                         MD023743
     C                   MOVE      BDPTAM        PEAMNT                         MD023743
 
      ** Narrative
 
     C                   EVAL      PETEXT = BDINAR
 
      ** Posting Date
 
     C****************** EVAL      ZDAYNO = BDNPSDT                             MD023628
                                                                                MD023628
     C****************** CALL      'ZDATE2'                                     MD023628
     C****************** PARM                    ZDAYNO                         MD023628
     C****************** PARM                    BJDFIN                         MD023628
     C****************** PARM      *ZERO         ZDATE                          MD023628
     C****************** PARM      *BLANK        ZADATE                         MD023628
                                                                                MD023628
     C****************** MOVEL     ZADATE        PEPSDT                         MD023628
     C                   MOVEL     BDNPSDT       PEPSDT                         MD023628
 
      ** Value Date
 
     C*******************MOVE      BDVLDT        ZDAYNO                         MD023743
                                                                                MD023743
     C*******************CALL      'ZDATE2'                                     MD023743
     C*******************PARM                    ZDAYNO                         MD023743
     C*******************PARM                    BJDFIN                         MD023743
     C*******************PARM      *ZERO         ZDATE                          MD023743
     C*******************PARM      *BLANK        ZADATE                         MD023743
                                                                                MD023743
     C*******************MOVEL     ZADATE        PEVLDT                         MD023743
     C                   MOVEL     BDVLDT        PEVLDT                         MD023743
 
      ** Transaction type
 
     C                   EVAL      PETRAN = BDTRTY
 
      ** Transaction reference
 
     C                   EVAL      PERFUP = BDBTNB
     C                   EVAL      PERFDW = BDBINB
 
      ** Extended Narrative
 
     C                   IF        BDADIF1 = BDNAR2 AND BDADIF2 = BDNAR3
     C                             AND BDADIF3 = BDNAR4 AND BDADIF4 = BDNAR5
     C                             AND BDADIF5 = BDNAR6 AND BDADIF6 = BDNAR7
 
     C                   EVAL      PENAR1 = 'see narrative above'
 
     C                   WRITE     DET01
 
     C                   ELSE
 
     C                   EVAL      PENAR1 = BDADIF1
 
     C                   WRITE     DET01
 
     C                   EVAL      PENRR2 = BDADIF2
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF3
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF4
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF5
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF6
     C                   WRITE     DET02
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Credit 3
      ** ========
 
     C                   IF        BDLXDCI3 <> ' '
     C                   CLEAR                   DET01
     C                   CLEAR                   DET02
     C                   EVAL      PETITL = 'Credit 3'
     C                   EVAL      PEDRCR = 'CR'
 
      ** Narrative Code
 
     C                   EVAL      PENRCD = BDNACR3
 
      ** Received Narrative
 
     C                   EVAL      PERCNR = BDRNCR3
 
      ** Posting Reference
 
     C                   EVAL      PEPSRF = BDPRFC3
 
      ** Branch
 
     C****************** EVAL      PEBRCH = BDBCCR3                             MD024113
     C                   EVAL      PEBRCH = BDIBCA                              MD024113
 
      ** Customer
 
     C****************** MOVE      BDCNCR3       PECUST                         MD024113
     C                   MOVEL     BDACID        PECUST                         MD024113
 
      ** Currency
 
     C                   EVAL      PECURR = BDCYCD
 
      ** Account Code
 
     C****************** EVAL      PEACOD = BDACCR3                             MD024113
     C                   MOVEL     BDACCD        PEACOD                         MD024113
 
      ** Account Sequence
 
     C****************** EVAL      PESEQN = BDASCR3                             MD024113
     C                   MOVEL     BDACSN        PESEQN                         MD024113
 
      ** Amount
 
     C****************** EXSR      GetCurrDtls                                  MD023743
     C****************** EVAL      WField = *BLANKS                             MD023743
     C****************** EVAL      WAmount = *Zeros                             MD023743
     C****************** EVAL      PDecPlace = *Zeros                           MD023743
     C****************** MOVE      BDLXPTA3      WAmount                        MD023743
     C****************** EVAL      PDecPlace = A6NBDP                           MD023743
     C****************** EXSR      FormatAmount                                 MD023743
     C****************** MOVE      WField        PEAMNT                         MD023743
     C                   MOVE      BDPTAM        PEAMNT                         MD023743
 
      ** Narrative
 
     C                   EVAL      PETEXT = BDINAR
 
      ** Posting Date
 
     C****************** EVAL      ZDAYNO = BDNPSDT                             MD023628
                                                                                MD023628
     C****************** CALL      'ZDATE2'                                     MD023628
     C****************** PARM                    ZDAYNO                         MD023628
     C****************** PARM                    BJDFIN                         MD023628
     C****************** PARM      *ZERO         ZDATE                          MD023628
     C****************** PARM      *BLANK        ZADATE                         MD023628
                                                                                MD023628
     C****************** MOVEL     ZADATE        PEPSDT                         MD023628
     C                   MOVEL     BDNPSDT       PEPSDT                         MD023628
 
      ** Value Date
 
     C*******************MOVE      BDVLDT        ZDAYNO                         MD023743
                                                                                MD023743
     C*******************CALL      'ZDATE2'                                     MD023743
     C*******************PARM                    ZDAYNO                         MD023743
     C*******************PARM                    BJDFIN                         MD023743
     C*******************PARM      *ZERO         ZDATE                          MD023743
     C*******************PARM      *BLANK        ZADATE                         MD023743
                                                                                MD023743
     C*******************MOVEL     ZADATE        PEVLDT                         MD023743
     C                   MOVEL     BDVLDT        PEVLDT                         MD023743
 
      ** Transaction type
 
     C                   EVAL      PETRAN = BDTRTY
 
      ** Transaction reference
 
     C                   EVAL      PERFUP = BDBTNB
     C                   EVAL      PERFDW = BDBINB
 
      ** Extended Narrative
 
     C                   IF        BDADIF1 = BDNAR2 AND BDADIF2 = BDNAR3
     C                             AND BDADIF3 = BDNAR4 AND BDADIF4 = BDNAR5
     C                             AND BDADIF5 = BDNAR6 AND BDADIF6 = BDNAR7
 
     C                   EVAL      PENAR1 = 'see narrative above'
 
     C                   WRITE     DET01
 
     C                   ELSE
 
     C                   EVAL      PENAR1 = BDADIF1
 
     C                   WRITE     DET01
 
     C                   EVAL      PENRR2 = BDADIF2
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF3
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF4
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF5
     C                   WRITE     DET02
     C                   EVAL      PENRR2 = BDADIF6
     C                   WRITE     DET02
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        Pmode = 'A'                                              MD023825
     C/EXEC SQL
     C*+UPDATE*GLACBDTD  SET BDGERP = 'Y'                                                   MD029739
     C+ UPDATE DIACBDTD  SET BDGERP = 'Y'                                                   MD029739
     C**where*BDBTID = :BDBTID and BDBKBR = :BDBKBR  and BDDPCD = :BDDPCD                   MD023825
     C**********        and BDCCY = :BDCCY                                                  MD023825
     C+ where current of LIST                                                               MD023825
     C/END-EXEC
     C                   ENDIF                                                              MD023825
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintFtr - Print Footer Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintFtr    BEGSR
 
     C                   IF        WRecNo > 0
     C                   WRITE     FOOTER
     C                   ENDIF
 
     C                   EXSR      SRAudit
 
     C                   ENDSR
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
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      BDCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
 
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
 
      ** Check CGL145 feature
 
     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       PRtCd
     C                   Parm      '*VERIFY'     POptn
     C                   Parm      'CGL145'      PSARD
     C                   Parm                    DSFDY
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'CGL145'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      CGL145 = 'N'
     C                   ELSE
     C                   EVAL      CGL145 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blanks       ZSerr
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
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
