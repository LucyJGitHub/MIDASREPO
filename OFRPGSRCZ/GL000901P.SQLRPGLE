     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Suggested Transfers Audit Report')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GL000901P - Midas OF Suggested Transfers Audit Report        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL176             Date 28Jul15               *
      *                 MD033486           Date 27Feb15               *
      *                 MD032132           Date 29Jan15               *
      *                 MD032130           Date 29Jan15               *
      *                 CGL158   *CREATE   Date 20Aug14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption (Recompile)                     *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL176 - Optimisation of Nostro Balances by Company          *
      *  MD033486 - Add new Beneficiary Account field                 *
      *  MD032132 - Incorrect status shown when transfer was          *
      *             completed                                         *
      *  MD032130 - Incorrect intitate date and time shown when only  *
      *             manual transfers were in a batch                  *
      *  CGL158 - Nostro Sweeping Rules Maintenance                   *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas OF Suggested Transfers Audit Report
     FGL000901P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN

      ** Midas OF Suggested Transfers - Audit
     FGL000901AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
     F                                     USROPN

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Bank Details - Secondary COB
     D SDSBNK        E DS                  EXTNAME(SDSBNKTD)
     D                                     PREFIX(S)

      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D MPHAS           DS             1
     D Phase1                  1      1

     ** File DS

     **   Midas OF Suggested Transfers Audit Table
     D SUTA          E DS                  EXTNAME(GLSUTATD)

      ** DS for Branch Caching
     D BranchDS        DS
     D BCode                          3
     D BDesc                         30

      ** DS for Currency Caching
     D CurrencyDS      DS
     D CCode                          3
     D CNDP                           1  0

      ** DS for Sub-Type Caching
     D SubTypeDS       DS
     D STCode                         4
     D STDesc                        35

      ** DS for Profit Centre Caching
     D ProfitDS        DS
     D PCCode                         4
     D PCDesc                        30

      ** DS for Book Code Caching
     D BookDS          DS
     D BkCode                         2
     D BkDesc                        30

     D Max             C                   CONST(100)
     **   Arrays for caching
     D BranchArray     S              3    DIM(Max)
     D BrcDescArray    S             30    DIM(Max)
     D CcyArray        S              3    DIM(Max)
     D NDPArray        S              1  0 DIM(Max)
     D SubTypeArray    S              4    DIM(Max)
     D STypeDescArray  S             35    DIM(Max)
     D PrfcArray       S              4    DIM(Max)
     D PrfcDescArray   S             30    DIM(Max)
     D BookCodeArray   S              2    DIM(Max)
     D BkCdeDescArray  S             30    DIM(Max)

     **   Other arrays for descriptions
     D SweepTypeArray  S             35    DIM(6) CTDATA PERRCD(1)
     D SettTypeArray   S             20    DIM(4) CTDATA PERRCD(1)
     D MonthArray      S              3    DIM(12) CTDATA PERRCD(12)

      ** File Information Data Structure for GL000901P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for GL000901AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** Data Structures for amound display

     D                 DS
     D   PRSTRA                1     15  0
     D   PRSTR0                1     15  0
     D   PRSTR1                1     15  0
     D   PRSTR2                1     15  0
     D   PRSTR3                1     15  0

     D                 DS
     D   PRBBAB                1     15  0
     D   PRBBB0                1     15  0
     D   PRBBB1                1     15  0
     D   PRBBB2                1     15  0
     D   PRBBB3                1     15  0

     D                 DS
     D   PRBBAA                1     15  0
     D   PRBBA0                1     15  0
     D   PRBBA1                1     15  0
     D   PRBBA2                1     15  0
     D   PRBBA3                1     15  0

     D                 DS
     D   PRPBAB                1     15  0
     D   PRPBB0                1     15  0
     D   PRPBB1                1     15  0
     D   PRPBB2                1     15  0
     D   PRPBB3                1     15  0

     D                 DS
     D   PRPBAA                1     15  0
     D   PRPBA0                1     15  0
     D   PRPBA1                1     15  0
     D   PRPBA2                1     15  0
     D   PRPBA3                1     15  0

     D                 DS
     D   PROBAB                1     15  0
     D   PROBB0                1     15  0
     D   PROBB1                1     15  0
     D   PROBB2                1     15  0
     D   PROBB3                1     15  0

     D                 DS
     D   PROBAA                1     15  0
     D   PROBA0                1     15  0
     D   PROBA1                1     15  0
     D   PROBA2                1     15  0
     D   PROBA3                1     15  0

     D                 DS
     D   PRTAMT                1     15  0
     D   PRTA10                1     15  0
     D   PRTA11                1     15  0
     D   PRTA12                1     15  0
     D   PRTA13                1     15  0

     D                 DS
     D   PRTAM2                1     15  0
     D   PRTA20                1     15  0
     D   PRTA21                1     15  0
     D   PRTA22                1     15  0
     D   PRTA23                1     15  0

     D                 DS
     D   PRMOSA                1     15  0
     D   PRMOS0                1     15  0
     D   PRMOS1                1     15  0
     D   PRMOS2                1     15  0
     D   PRMOS3                1     15  0

     D CustomerDS      DS
     D WShrtNam                1     10
     D WRptNam                11     30
     D WRptTown               31     40
     D WACNam                 41     60
     D WSwftID                61     72

     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

      ** Other fields used
     D A               S              3S 0 Inz
     D WBranch         S              3
     D WBranchDesc     S             30
     D WCcy            S              3
     D WCcyNBDP        S              1S 0
     D WDlTp           S              2
     D WDlSt           S              2
     D WDTST           S              4
     D WSTypeDesc      S             35
     D WProfit         S              4
     D WProfitDesc     S             30
     D WBook           S              2
     D WBookDesc       S             30

     D WNosc           S              2
     D WNCcy           S              3
     D WNosCnum        S              6
     D WNosAcsq        S              2  0
     D WNosAcod        S             10  0
     D WNosBrc         S              3
     D WNosACNo        S             10  0
     D WNosACName      S             20
     D WCnum           S              6
     D WPartial        S             21
     D WFull           S             24
     D WAcNo           S             10  0
     D WIban           S             35
     D WOrc            S             35
     D WInt            S             35

     D WRecSuTr        S              7S 0 Inz
     D Count           S              3S 0 Inz
     D DLTP            S              2    Inz
     D DTST            S              4    Inz
     D WCTMS           S             26    Inz
     D WITMS           S             26    Inz
     D CMONTH          S              2  0 Inz
     D IMONTH          S              2  0 Inz
     D InitDone        S              1
     D WITMST          S               Z
     D WRun            S              1
     D Rows            S              1  0 Inz

     D CGL159          S              1
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6

     D CGL176          S              1                                                     CGL176
     D P#Level         S              1                                                     CGL176
     D P#Entity        S              3                                                     CGL176
     D P#Company       S              1                                                     CGL176

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
     C                   If        CGL176 = 'Y' and P#Level = 'C'                           CGL176
      *                                                                                     CGL176	
     C                   If        P#Entity <> *Blanks and                                  CGL176
     C                             P#Entity = 'ALL'                                         CGL176
     C                   Eval      P#Company = 'A'                                          CGL176
      *                                                                                     CGL176	
      ** Set file pointer to first record and do initial read                               CGL176
     C/exec SQL                                                                             CGL176
     C+ declare LISTA cursor for                                                            CGL176
     C+ select * from GLSUTATD                                                              CGL176
     C+ order by                                                                            CGL176
     C+    BPCMCD, BPITMS, BPCTMS DESC, BPSLVL, BPCCY, BPBNOC                               CGL176
     C/end-exec                                                                             CGL176
      *                                                                                     CGL176	
     C/exec SQL                                                                             CGL176
     C+ open LISTA                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   If        P#Entity <> *Blanks and                                  CGL176
     C                             P#Entity <> 'ALL'                                        CGL176
     C                   Eval      P#Company = 'Y'                                          CGL176
      ** Set file pointer to first record and do initial read                               CGL176
     C/exec SQL                                                                             CGL176
     C+ declare LISTB cursor for                                                            CGL176
     C+ select * from GLSUTATD                                                              CGL176
     C+ where BPCMCD = :P#Entity                                                            CGL176
     C+ order by                                                                            CGL176
     C+    BPCMCD, BPITMS, BPCTMS DESC, BPSLVL, BPCCY, BPBNOC                               CGL176
     C/end-exec                                                                             CGL176
      *                                                                                     CGL176	
     C/exec SQL                                                                             CGL176
     C+ open LISTB                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   Else                                                               CGL176

      ** Set file pointer to first record and do initial read

     C/exec SQL
     C+ declare LIST cursor for
     C+ select * from GLSUTATD
     C+ order by
     C+    BPITMS, BPCTMS DESC, BPSLVL, BPCCY, BPBNOC
     C/end-exec

     C/exec SQL
     C+ open LIST
     C/end-exec
     C                   Endif                                                              CGL176

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 18
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C                   If        CGL176 = 'Y' and P#Company <> 'N'                        CGL176
     C                   If        P#Company = 'A'                                          CGL176
     C/exec SQL                                                                             CGL176
     C+ fetch next                                                                          CGL176
     C+ from LISTA                                                                          CGL176
     C+ into :SUTA                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   If        P#Company = 'Y'                                          CGL176
     C/exec SQL                                                                             CGL176
     C+ fetch next                                                                          CGL176
     C+ from LISTB                                                                          CGL176
     C+ into :SUTA                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   Else                                                               CGL176
     C/exec SQL
     C+ fetch next
     C+ from LIST
     C+ into :SUTA
     C/end-exec
     C                   Endif                                                              CGL176

      ** Read until end of file

     C                   CLEAR                   WITMST
     C                   DOW       SQLCode <> 100

     C                   IF        NOT %OPEN(GL000901P1)

     C                   OPEN      GL000901P1

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

     C                   ENDIF

     C                   EVAL      WRecSuTr = WRecSuTr + 1

      ** Print Report Header for every detail

     C                   EXSR      SRPrintHdr1

      ** Print Report Header 2 only once for each batch of confirm all

     C                   IF        WITMST <> BPITMS
     C                   EXSR      SRPrintHdr2
     C                   EVAL      WITMST = BPITMS
     C                   ENDIF

      ** Print details

     C                   EXSR      SRDetails

     C                   If        CGL176 = 'Y' and P#Company <> 'N'                        CGL176
     C                   If        P#Company = 'A'                                          CGL176
     C/exec SQL                                                                             CGL176
     C+ fetch next from LISTA                                                               CGL176
     C+ into :SUTA                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   If        P#Company = 'Y'                                          CGL176
     C/exec SQL                                                                             CGL176
     C+ fetch next from LISTB                                                               CGL176
     C+ into :SUTA                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   Else                                                               CGL176
     C/exec SQL
     C+ fetch next from LIST
     C+ into :SUTA
     C/end-exec
     C                   Endif                                                              CGL176
      ** close the current spooled file to generate a new one for a different Company       CGL176
     C                   If        CGL176 = 'Y' and P#Company <> 'N' and                    CGL176
     C                             SQLCode <> 100 and BPCMCD <> H2CMCD                      CGL176
     C                   EXSR      SRPrintFtr                                               CGL176
     C                   Close     GL000901P1                                               CGL176
     C                   ENDIF                                                              CGL176

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCode < 100

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 19
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C                   If        CGL176 = 'Y' and P#Company <> 'N'                        CGL176
     C                   If        P#Company = 'A'                                          CGL176
     C/exec SQL                                                                             CGL176
     C+ close LISTA                                                                         CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   If        P#Company = 'Y'                                          CGL176
     C/exec SQL                                                                             CGL176
     C+ close LISTB                                                                         CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   Else                                                               CGL176
     C/exec SQL
     C+ close LIST
     C/end-exec
     C                   Endif                                                              CGL176

     C                   EXSR      SRPrintFtr

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr1 - Print Header 1 Routine                         *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr1   BEGSR

     C                   EVAL      FTITLE = 'BANK POSITION OPTIMISATION ' +
     C                                      'AUDIT REPORT - SUGGESTED ' +
     C                                      'TRANSFERS'
     C                   EVAL      FUNDRS = '---------------------------' +
     C                                      '-------------------------' +
     C                                      '---------'
      ** Show Company code when CGL176 is enabled                                           CGL176
     C                   IF        CGL176 = 'Y' and P#Company <> 'N'                        CGL176
     C                   EVAL      H2CMCD = BPCMCD                                          CGL176
     C                   EVAL      *IN40 = *ON                                              CGL176
     C                   ENDIF                                                              CGL176
      *                                                                                     CGL176
     C                   WRITE     HEADER1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr2 - Print Header 2 Routine                         *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr2   BEGSR

     C                   CLEAR                   HEADER2

      ** CONFIRM
     C                   MOVEL     BPCTMS        WCTMS
     C                   EVAL      CMONTH = %DEC(%SUBST(WCTMS:6:2):2:0)

      ** If all transfers in a batch were rejected, do not output
      ** confirm date and time
     C                   IF        BPCUSR <> *BLANKS
     C                   EVAL      CDATE = %SUBST(WCTMS:9:2) +
     C                                      MonthArray(CMONTH) +
     C                                      %SUBST(WCTMS:3:2)
     C                   EVAL      CTIME = %SUBST(WCTMS:12:2) + ':' +
     C                                     %SUBST(WCTMS:15:2) + ':' +
     C                                     %SUBST(WCTMS:18:2)
     C                   EVAL      CUSER = BPCUSR
     C                   ENDIF

      ** INITIATE
      ** If all are manual transfers, do not output initiate date                           MD032130
      ** and time                                                                           MD032130
     C                   IF        BPIUSR <> *BLANKS                                        MD032130
     C                   MOVEL     BPITMS        WITMS
     C                   EVAL      IMONTH = %DEC(%SUBST(WITMS:6:2):2:0)
     C                   EVAL      IDATE = %SUBST(WITMS:9:2) +
     C                                      MonthArray(IMONTH) +
     C                                      %SUBST(WITMS:3:2)
     C                   EVAL      ITIME = %SUBST(WITMS:12:2) + ':' +
     C                                     %SUBST(WITMS:15:2) + ':' +
     C                                     %SUBST(WITMS:18:2)
     C                   ENDIF                                                              MD032130

     C                   WRITE     HEADER2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDetails  - Print Details                                   *
      *                                                               *
      *****************************************************************
     C     SrDetails     BEGSR

     C                   CLEAR                   DETAIL
     C                   IF        CGL159 = 'Y'
     C                   EVAL      *IN88 = *ON
     C                   ELSE
     C                   EVAL      *IN88 = *OFF
     C                   ENDIF

      ** Status
     C**********         IF        BPSTAT = 'S'                                             MD032132
     C                   IF        BPSTAT = 'C'                                             MD032132
     C**********         EVAL      PRSTAT = 'SUBMITTED'                                     MD032132
     C                   EVAL      PRSTAT = 'COMPLETED'                                     MD032132
     C                   ELSE
     C                   IF        BPRRPR = 'Y'
     C                   EVAL      PRSTAT = 'REJECTED from Repair'
     C                   ELSE
     C                   EVAL      PRSTAT = 'REJECTED'
     C                   ENDIF
     C                   ENDIF

      ** Rule Name
     C                   EVAL      PRRULE = BPRULE

      ** Manual Indicator
     C                   IF        BPMANU = 'Y'
     C                   EVAL      PRMANU = 'YES'
     C                   ELSE
     C                   EVAL      PRMANU = 'NO'
     C                   ENDIF

      ** Transfer Amount
     C                   EVAL      PRSTRA = BPSTRA

      ** Currency
     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN11 = *OFF
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      *IN13 = *OFF
     C                   EVAL      PRCCY = BPCCY
     C                   EVAL      A = %LOOKUP(BPCCY:CcyArray)
     C                   IF        A <> 0
     C                   Z-ADD     NDPArray(A)   WCcyNBDP
     C                   ELSE
     C                   EVAL      WCcy = BPCCY
     C                   EXSR      CurrencyCache
     C                   ENDIF
     C                   SELECT
     C                   WHEN      WCcyNBDP = 0
     C                   EVAL      *IN10 = *ON
     C                   WHEN      WCcyNBDP = 1
     C                   EVAL      *IN11 = *ON
     C                   WHEN      WCcyNBDP = 2
     C                   EVAL      *IN12 = *ON
     C                   WHEN      WCcyNBDP = 3
     C                   EVAL      *IN13 = *ON
     C                   ENDSL

      ** To/From Indicator
     C                   IF        BPTOFR = 'T'
     C                   EVAL      PRTOFR = 'TO'
     C                   ELSE
     C                   EVAL      PRTOFR = 'FROM'
     C                   ENDIF

      ** Base Nostro Code
     C                   EVAL      PRBNOC = BPBNOC
     C                   EVAL      WNosc = BPBNOC
     C                   EVAL      WNCcy = BPCCy
     C                   EXSR      GetNostDtls
     C                   IF        WNosACNo <> *ZEROS
     C                   EVAL      PRBNAC = %CHAR(WNosACNo)
     C                   ELSE
     C                   EVAL      PRBNAC = WNosBrc + WNosCnum + WNCcy +
     C                                      %CHAR(WNosAcod) + %CHAR(WNosAcsq)
     C                   ENDIF
     C                   EVAL      PRBNAM = WNosACName

      ** Base Nostro Branch
     C                   EVAL      A = %LOOKUP(BPBNBR:BranchArray)
     C                   IF        A <> 0
     C                   EVAL      WBranchDesc = BrcDescArray(A)
     C                   ELSE
     C                   EVAL      WBranch = BPBNBR
     C                   EXSR      BranchCache
     C                   ENDIF
     C                   EVAL      PRBNBR = BPBNBR + ' ' + WBranchDesc

      ** Estimated Base A/C Bal. Before
     C                   EVAL      PRBBAB = BPBBAB

      ** Estimated Base A/C Bal. After
     C                   EVAL      PRBBAA = BPBBAA

     C                   IF        BPCCY1 <> *BLANKS AND
     C                             BPPOOL <> *BLANKS

     C                   EVAL      *IN89 = *ON

      ** Base Pool
     C                   EVAL      PRPOOL = BPPOOL

      ** Estimated Pool Bal. Before
     C                   EVAL      PRPBAB = BPPBAB

      ** Estimated Pool Bal. After
     C                   EVAL      PRPBAA = BPPBAA

     C                   ENDIF

     C                   IF        BPONOC <> *BLANKS

      ** Other Nostro Code
     C                   EVAL      PRONOC = BPONOC
     C                   EVAL      WNosc = BPONOC
     C                   EVAL      WNCcy = BPCCy
     C                   EXSR      GetNostDtls
     C                   IF        WNosACNo <> *ZEROS
     C                   EVAL      PRONAC = %CHAR(WNosACNo)
     C                   ELSE
     C                   EVAL      PRONAC = WNosBrc + WNosCnum + WNCcy +
     C                                      %CHAR(WNosAcod) + %CHAR(WNosAcsq)
     C                   ENDIF
     C                   EVAL      PRONAM = WNosACName

      ** Other Nostro Branch
     C                   EVAL      A = %LOOKUP(BPONBR:BranchArray)
     C                   IF        A <> 0
     C                   EVAL      WBranchDesc = BrcDescArray(A)
     C                   ELSE
     C                   EVAL      WBranch = BPONBR
     C                   EXSR      BranchCache
     C                   ENDIF
     C                   EVAL      PRONBR = BPONBR + ' ' + WBranchDesc

      ** Estimated Other A/C Bal. Before
     C                   EVAL      PROBAB = BPOBAB

      ** Estimated Other A/C Bal. After
     C                   EVAL      PROBAA = BPOBAA

     C                   ENDIF

      ** External Party
     C                   IF        BPEXT1 <> *BLANKS
     C                   EVAL      PREXTP = BPEXT1
     C                   EVAL      A = %SCAN(' ':BPEXT1)
     C                   CLEAR                   CustomerDS
     C                   SELECT
     C                   WHEN      A = 7
     C                   EVAL      WCnum = BPEXT1
     C                   EXSR      GetCustDtls1
     C                   WHEN      A = 22
     C                   EVAL      WPartial = BPEXT1
     C                   EXSR      GetCustDtls2
     C                   WHEN      A = 11
     C                   MOVEL     BPEXT1        WAcNo
     C                   EXSR      GetCustDtls3
     C                   ENDSL
     C                   EVAL      PREXSN = WShrtNam
     C                   EVAL      PREXNM = WRptNam
     C                   EVAL      PREXTN = WRptTown
     C                   EVAL      PREXAM = WACNam
     C                   EVAL      PREXSI = WSwftID
     C                   ENDIF

      ** Sweep Level
     C                   EVAL      PRSLVL = %CHAR(BPSLVL)

      ** Sweep Type
     C                   IF        BPSTYP <> *BLANKS
     C                   Z-ADD     0             A
     C                   MOVE      BPSTYP        A
     C                   EVAL      PRSTYP = BPSTYP + ' ' + SweepTypeArray(A)
     C                   ENDIF

     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   IF        BPCCY1 <> *BLANKS

      ** Threshold Amount
     C                   EVAL      PRTAMT = BPTAMT

      ** Threshold Amount Currency
     C                   EVAL      PRCCY1 = BPCCY1
     C                   EVAL      A = %LOOKUP(BPCCY1:CcyArray)
     C                   IF        A <> 0
     C                   Z-ADD     NDPArray(A)   WCcyNBDP
     C                   ELSE
     C                   EVAL      WCcy = BPCCY1
     C                   EXSR      CurrencyCache
     C                   ENDIF
     C                   SELECT
     C                   WHEN      WCcyNBDP = 0
     C                   EVAL      *IN20 = *ON
     C                   WHEN      WCcyNBDP = 1
     C                   EVAL      *IN21 = *ON
     C                   WHEN      WCcyNBDP = 2
     C                   EVAL      *IN22 = *ON
     C                   WHEN      WCcyNBDP = 3
     C                   EVAL      *IN23 = *ON
     C                   ENDSL

      ** Debit/Credit Indicator
     C                   IF        BPTAMT <> 0
     C                   IF        BPDRCR = '0'
     C                   EVAL      PRDRCR = 'DEBIT'
     C                   ELSE
     C                   EVAL      PRDRCR = 'CREDIT'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      PRDRCR = *BLANKS
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   IF        BPSTYP = '6' AND
     C                             BPCCY2 <> *BLANKS

      ** Threshold Amount 2
     C                   EVAL      PRTAM2 = BPTAM2

      ** Threshold Amount Currency 2
     C                   EVAL      PRCCY2 = BPCCY2
     C                   EVAL      A = %LOOKUP(BPCCY2:CcyArray)
     C                   IF        A <> 0
     C                   Z-ADD     NDPArray(A)   WCcyNBDP
     C                   ELSE
     C                   EVAL      WCcy = BPCCY2
     C                   EXSR      CurrencyCache
     C                   ENDIF
     C                   SELECT
     C                   WHEN      WCcyNBDP = 0
     C                   EVAL      *IN30 = *ON
     C                   WHEN      WCcyNBDP = 1
     C                   EVAL      *IN31 = *ON
     C                   WHEN      WCcyNBDP = 2
     C                   EVAL      *IN32 = *ON
     C                   WHEN      WCcyNBDP = 3
     C                   EVAL      *IN33 = *ON
     C                   ENDSL

      ** Debit/Credit Indicator 2
     C                   IF        BPTAM2 <> 0
     C                   IF        BPDRC2 = '0'
     C                   EVAL      PRDRC2 = 'DEBIT'
     C                   ELSE
     C                   EVAL      PRDRC2 = 'CREDIT'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      PRDRC2 = *BLANKS
     C                   ENDIF

     C                   ENDIF

      ** Multiples of Sweep Amount
     C                   IF        BPCCY1 <> *BLANKS
     C                   EVAL      PRMOSA = BPMOSA
     C                   ENDIF

      ** Payment Subtype
     C                   IF        BPPSTY <> *BLANKS
     C                   SELECT
     C                   WHEN      BPAPIN = 'OPAY'
     C                   EVAL      WDlTp = 'OP'
     C                   WHEN      BPAPIN = 'IPAY'
     C                   EVAL      WDlTp = 'IN'
     C                   WHEN      BPAPIN = 'FTNT'
     C                   EVAL      WDlTp = 'NT'
     C                   ENDSL
     C                   EVAL      WDlSt = BPPSTY
     C                   EVAL      WDTST = WDlTp + WDlSt
     C                   EVAL      A = %LOOKUP(WDTST:SubTypeArray)
     C                   IF        A <> 0
     C                   EVAL      WSTypeDesc = STypeDescArray(A)
     C                   ELSE
     C                   EXSR      SubTypeCache
     C                   ENDIF
     C                   EVAL      PRPSTY = BPPSTY + ' ' + WSTypeDesc
     C                   ENDIF

      ** Profit Centre
     C                   IF        BPPRFC <> *BLANKS
     C                   EVAL      A = %LOOKUP(BPPRFC:PrfcArray)
     C                   IF        A <> 0
     C                   EVAL      WProfitDesc = PrfcDescArray(A)
     C                   ELSE
     C                   EVAL      WProfit = BPPRFC
     C                   EXSR      ProfitCache
     C                   ENDIF
     C                   EVAL      PRPRFC = BPPRFC + ' ' + WProfitDesc
     C                   ENDIF

      ** Book Code
     C                   IF        BPBOOK <> *BLANKS
     C                   EVAL      A = %LOOKUP(BPBOOK:BookCodeArray)
     C                   IF        A <> 0
     C                   EVAL      WBookDesc = BkCdeDescArray(A)
     C                   ELSE
     C                   EVAL      WBook = BPBOOK
     C                   EXSR      BookCache
     C                   ENDIF
     C                   EVAL      PRBOOK = BPBOOK + ' ' + WBookDesc
     C                   ENDIF

      ** Settlement Type
     C                   IF        BPSTTP <> *BLANKS
     C                   SELECT
     C                   WHEN      BPSTTP = '01'
     C                   EVAL      PRSTTP = BPSTTP + ' ' + SettTypeArray(1)
     C                   WHEN      BPSTTP = '02'
     C                   EVAL      PRSTTP = BPSTTP + ' ' + SettTypeArray(2)
     C                   WHEN      BPSTTP = '08'
     C                   EVAL      PRSTTP = BPSTTP + ' ' + SettTypeArray(3)
     C                   WHEN      BPSTTP = '10'
     C                   EVAL      PRSTTP = BPSTTP + ' ' + SettTypeArray(4)
     C                   ENDSL
     C                   ENDIF

      ** Swift Priority Code
     C                   IF        BPSWPC = 'U'
     C                   EVAL      PRSWPC = 'URGENT'
     C                   ELSE
     C                   EVAL      PRSWPC = 'NORMAL'
     C                   ENDIF

      ** Ordering Customer/Beneficiary
     C                   IF        BPOCUS <> *BLANKS
     C                   EVAL      PROCUS = BPOCUS
     C                   EVAL      A = %SCAN(' ':BPOCUS)
     C                   CLEAR                   CustomerDS
     C                   SELECT
     C                   WHEN      A = 11
     C                   MOVEL     BPOCUS        WAcNo
     C                   EXSR      GetCustDtls3
     C                   WHEN      A = 25
     C                   EVAL      WFull = BPOCUS
     C                   EXSR      GetCustDtls4
     C                   ENDSL
     C                   EVAL      PROCSN = WShrtNam
     C                   EVAL      PROCNM = WRptNam
     C                   EVAL      PROCTN = WRptTown
     C                   EVAL      PROCAM = WACNam
     C                   EVAL      PROCSI = WSwftID
     C                   ENDIF
                                                                                            MD033486
      ** Beneficiary Account                                                                MD033486
     C                   IF        BPBACT <> *BLANKS                                        MD033486
     C                   EVAL      PRBENE = BPBACT                                          MD033486
     C                   ELSE                                                               MD033486
     C                   EVAL      PRBENE = *BLANKS                                         MD033486
     C                   ENDIF                                                              MD033486

      ** Account with Bank/Ordering Bank 1-5
     C                   IF        BPORC1 <> *BLANKS AND
     C                             BPORC3 = *BLANKS AND
     C                             BPORC4 = *BLANKS AND
     C                             BPORC5 = *BLANKS
     C                   EVAL      PRORC1 = BPORC1
     C                   IF        %SUBST(BPORC1:1:1) = '/'
     C                   EVAL      WOrc = BPORC2
     C                   ELSE
     C                   EVAL      WOrc = BPORC1
     C                   ENDIF
     C                   EVAL      A = %SCAN(' ':WOrc)
     C                   CLEAR                   CustomerDS
     C                   IF        A = 7
     C                   EVAL      WCnum = WOrc
     C                   EXSR      GetCustDtls1
     C                   ELSE
     C                   EVAL      WIban = WOrc
     C                   EXSR      GetCustDtls5
     C                   ENDIF
     C                   EVAL      PRACSN = WShrtNam
     C                   EVAL      PRACNM = WRptNam
     C                   EVAL      PRACTN = WRptTown
     C                   EVAL      PRACAM = WACNam
     C                   EVAL      PRACID = WSwftID
     C                   ENDIF
     C                   EVAL      PRORC2 = BPORC2
     C                   EVAL      PRORC3 = BPORC3
     C                   EVAL      PRORC4 = BPORC4
     C                   EVAL      PRORC5 = BPORC5

      ** Intermediary 1-5
     C                   IF        BPCIB1 <> *BLANKS AND
     C                             BPCIB3 = *BLANKS AND
     C                             BPCIB4 = *BLANKS AND
     C                             BPCIB5 = *BLANKS
     C                   EVAL      PRCIB1 = BPCIB1
     C                   IF        %SUBST(BPCIB1:1:1) = '/'
     C                   EVAL      WInt = BPCIB2
     C                   ELSE
     C                   EVAL      WInt = BPCIB1
     C                   ENDIF
     C                   EVAL      A = %SCAN(' ':WInt)
     C                   CLEAR                   CustomerDS
     C                   IF        A = 7
     C                   EVAL      WCnum = WInt
     C                   EXSR      GetCustDtls1
     C                   ELSE
     C                   EVAL      WIban = WInt
     C                   EXSR      GetCustDtls5
     C                   ENDIF
     C                   EVAL      PRIBSN = WShrtNam
     C                   EVAL      PRIBNM = WRptNam
     C                   EVAL      PRIBTN = WRptTown
     C                   EVAL      PRIBAM = WACNam
     C                   EVAL      PRIBID = WSwftID
     C                   ENDIF
     C                   EVAL      PRCIB2 = BPCIB2
     C                   EVAL      PRCIB3 = BPCIB3
     C                   EVAL      PRCIB4 = BPCIB4
     C                   EVAL      PRCIB5 = BPCIB5

      ** Bank to Bank Information 1-4
     C                   EVAL      PRBBI1 = BPBBI1
     C                   EVAL      PRBBI2 = BPBBI2
     C                   EVAL      PRBBI3 = BPBBI3
     C                   EVAL      PRBBI4 = BPBBI4

     C** Initiate/Manual User
     C                   EVAL      PRIUSR = BPIUSR

      ** Reject User
     C                   EVAL      PRRUSR = BPRUSR

      ** Transaction Type
     C                   SELECT
     C                   WHEN      BPAPIN = 'OPAY'
     C                   EVAL      PRAPIN = 'Outgoing Payment'
     C                   WHEN      BPAPIN = 'IPAY'
     C                   EVAL      PRAPIN = 'Incoming Payment'
     C                   WHEN      BPAPIN = 'FTNT'
     C                   EVAL      PRAPIN = 'Nostro Transfer'
     C                   ENDSL

      ** Transaction Reference
     C                   EVAL      PRPREF = BPPREF

      ** Front Office ID
     C                   EVAL      PRFOID = BPFOID

     C                   WRITE     DETAIL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintFtr - Print Footer Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintFtr    BEGSR

     C                   IF        WRecSuTr > 0

     C                   WRITE     FOOTER

     C                   ELSE

     C                   IF        NOT %OPEN(GL000901AU)
     C                   OPEN      GL000901AU
     C                   ENDIF
     C                   WRITE     HEADAU
     C                   WRITE     NODTLS

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
      *                                                                                     CGL176
      ** Entry parameters                                                                   CGL176
     C     *ENTRY        PLIST                                                              CGL176
     C                   PARM                    P#Level                                    CGL176
     C                   PARM                    P#Entity                                   CGL176

      ** Set off program indicators

     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
     C                   EVAL      InitDone = *BLANKS

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

     C     *Dtaara       Define                  MPhas
     C                   In        MPhas

      ** Access Bank details
      **   Retrieve Run day number

     C     Phase1        IFEQ      'A'
     C/exec SQL
     C+ select *
     C+ into :SDBANK
     C+ from SDBANKPD
     C/end-exec

     C     SQLCOD        IFNE      *Zeros
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RRPTDS = BJURPT
     C                   ENDIF

     C                   ELSE
     C/exec SQL
     C+ select *
     C+ into :SDSBNK
     C+ from SDSBNKTD
     C/end-exec

     C     SQLCOD        IFNE      *Zeros
     C     *LOCK         In        LDA
     C                   Eval      DBKey = '*FIRST'
     C                   Eval      DBFile = 'SDSBNKTD'
     C                   Eval      DBase = 2
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Else
     C                   Eval      SDBANK = SDSBNK
     C                   Eval      RRPTDS = BJURPT
     C                   Endif
     C                   ENDIF

      ** Determine if CGL159 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL159'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CGL159 = 'Y'
     C                   ELSE
     C                   EVAL      CGL159 = 'N'
     C                   ENDIF

      ** Determine if CGL176 is installed                                                   CGL176
     C                   EVAL      P#Company = 'N'                                          CGL176
     C                   EVAL      CGL176= 'N'                                              CGL176
     C                   EVAL      *IN40 = *OFF                                             CGL176
     C                   CALL      'AOSARDR0'                                               CGL176
     C                   PARM      *BLANKS       PRTCD                                      CGL176
     C                   PARM      '*VERIFY'     POPTN                                      CGL176
     C                   PARM      'CGL176'      PSARD                                      CGL176
     C     SCSARD        PARM      SCSARD        DSFDY                                      CGL176
      *                                                                                     CGL176
     C                   IF        PRTCD = *BLANKS                                          CGL176
     C                   EVAL      CGL176 = 'Y'                                             CGL176
     C                   ENDIF                                                              CGL176

      ** Cache branch, ccurency, payment sub-type,
      ** profit centre, and book code details

     C                   EXSR      BranchCache
     C                   EXSR      CurrencyCache
     C                   EXSR      SubTypeCache
     C                   EXSR      ProfitCache
     C                   EXSR      BookCache
      *
     C                   EVAL      InitDone = 'Y'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BranchCache - Branch Details Caching                         *
      *                                                               *
      *****************************************************************
     C     BranchCache   BEGSR

     C                   IF        InitDone = *BLANKS

     C/exec SQL
     C+ declare LIST1 cursor for
     C+ select A8BRCD, A8BRNM from SDBRCHPD
     C+ where A8RECI = 'D'
     C+ order by A8BRCD
     C/end-exec

     C/exec SQL
     C+ open LIST1
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
     C+ from LIST1
     C+ into :BranchDS
     C/end-exec

     C                   EVAL      Count = *ZERO

      ** Read until end of file or Array is full
     C                   DOW       SQLCode <> 100 and
     C                             Count < Max

     C                   EVAL      Count = Count + 1
     C                   EVAL      BranchArray(Count) = BCode
     C                   EVAL      BrcDescArray(Count) = BDesc

     C/exec SQL
     C+ fetch next from LIST1
     C+ into :BranchDS
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF) and array not yet full
     C                   If        SQLCode < 100 and
     C                             Count <> Max
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LIST1
     C/end-exec

     C                   ELSE

     C/EXEC SQL
     C+ Select A8BRNM
     C+ into   :WBranchDesc
     C+ from SDBRCHPD
     C+ where A8BRCD = :WBranch
     C/END-EXEC

     C/EXEC SQL
     C+ Get diagnostics :Rows = ROW_COUNT
     C/END-EXEC

     C                   If        SQLCode <> 0 and
     C                             SQLCode <> 100 or
     C                             Rows = 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CurrencyCache - Currency Details Caching                     *
      *                                                               *
      *****************************************************************
     C     CurrencyCache BEGSR

     C                   IF        InitDone = *BLANKS

     C/exec SQL
     C+ declare LIST2 cursor for
     C+ select A6CYCD, A6NBDP from SDCURRPD
     C+ where A6RECI = 'D'
     C+ order by A6CYCD
     C/end-exec

     C/exec SQL
     C+ open LIST2
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LIST2
     C+ into :CurrencyDS
     C/end-exec

     C                   EVAL      Count = *ZERO

      ** Read until end of file or Array is full
     C                   DOW       SQLCode <> 100 and
     C                             Count < Max

     C                   EVAL      Count = Count + 1
     C                   EVAL      CcyArray(Count) = CCode
     C                   EVAL      NDPArray(Count) = CNDP

     C/exec SQL
     C+ fetch next from LIST2
     C+ into :CurrencyDS
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF) and array not yet full
     C                   If        SQLCode < 100 and
     C                             Count <> Max
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 7
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LIST2
     C/end-exec

     C                   ELSE

     C/EXEC SQL
     C+ Select A6NBDP
     C+ into   :WCcyNBDP
     C+ from SDCURRPD
     C+ where A6CYCD = :WCcy
     C/END-EXEC

     C/EXEC SQL
     C+ Get diagnostics :Rows = ROW_COUNT
     C/END-EXEC

     C                   If        SQLCode <> 0 and
     C                             SQLCode <> 100 or
     C                             Rows = 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 8
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SubTypeCache - Payment Sub-type Details Caching              *
      *                                                               *
      *****************************************************************
     C     SubTypeCache  BEGSR

     C                   IF        InitDone = *BLANKS

     C/exec SQL
     C+ declare LIST3 cursor for
     C+ select DTPE11 concat DLST11, NARR11 from FDDTSTPD
     C+ where DTPE11 = 'OP' OR DTPE11 = 'IN' OR DTPE11 = 'NT'
     C+ order by DTPE11, DLST11
     C/end-exec

     C/exec SQL
     C+ open LIST3
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 9
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LIST3
     C+ into :SubTypeDS
     C/end-exec

     C                   EVAL      Count = *ZERO

      ** Read until end of file or Array is full
     C                   DOW       SQLCode <> 100 and
     C                             Count < Max

     C                   EVAL      Count = Count + 1
     C                   EVAL      SubTypeArray(Count) = STCode
     C                   EVAL      STypeDescArray(Count) = STDesc

     C/exec SQL
     C+ fetch next from LIST3
     C+ into :SubTypeDS
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF) and array not yet full
     C                   If        SQLCode < 100 and
     C                             Count <> Max
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 10
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LIST3
     C/end-exec


     C                   ELSE

     C/EXEC SQL
     C+ Select NARR11
     C+ into   :WSTypeDesc
     C+ from FDDTSTPD
     C+ where DTPE11 = :WDlTp and DLST11 = :WDlSt
     C/END-EXEC

     C/EXEC SQL
     C+ Get diagnostics :Rows = ROW_COUNT
     C/END-EXEC

     C                   If        SQLCode <> 0 and
     C                             SQLCode <> 100 or
     C                             Rows = 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 11
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ProfitCache - Profit Centre Details Caching                  *
      *                                                               *
      *****************************************************************
     C     ProfitCache   BEGSR

     C                   IF        InitDone = *BLANKS

     C/exec SQL
     C+ declare LIST4 cursor for
     C+ select DSPCCD, DSPCDS from SDPRFCPD
     C+ order by DSPCCD
     C/end-exec

     C/exec SQL
     C+ open LIST4
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 12
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LIST4
     C+ into :ProfitDS
     C/end-exec

     C                   EVAL      Count = *ZERO

      ** Read until end of file or Array is full
     C                   DOW       SQLCode <> 100 and
     C                             Count < Max

     C                   EVAL      Count = Count + 1
     C                   EVAL      PrfcArray(Count) = PCCode
     C                   EVAL      PrfcDescArray(Count) = PCDesc

     C/exec SQL
     C+ fetch next from LIST4
     C+ into :ProfitDS
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF) and array not yet full
     C                   If        SQLCode < 100 and
     C                             Count <> Max
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 13
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LIST4
     C/end-exec

     C                   ELSE

     C/EXEC SQL
     C+ Select DSPCDS
     C+ into   :WProfitDesc
     C+ from SDPRFCPD
     C+ where DSPCCD = :WProfit
     C/END-EXEC

     C/EXEC SQL
     C+ Get diagnostics :Rows = ROW_COUNT
     C/END-EXEC

     C                   If        SQLCode <> 0 and
     C                             SQLCode <> 100 or
     C                             Rows = 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 14
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BookCache - Book Code Details Caching                        *
      *                                                               *
      *****************************************************************
     C     BookCache     BEGSR

     C                   IF        InitDone = *BLANKS

     C/exec SQL
     C+ declare LIST5 cursor for
     C+ select BDBKCD, BDBKD from SDBOOKPD
     C+ order by BDBKCD
     C/end-exec

     C/exec SQL
     C+ open LIST5
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 15
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LIST5
     C+ into :BookDS
     C/end-exec

     C                   EVAL      Count = *ZERO

      ** Read until end of file or Array is full
     C                   DOW       SQLCode <> 100 and
     C                             Count < Max

     C                   EVAL      Count = Count + 1
     C                   EVAL      BookCodeArray(Count) = BkCode
     C                   EVAL      BkCdeDescArray(Count) = BkDesc

     C/exec SQL
     C+ fetch next from LIST5
     C+ into :BookDS
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF) and array not yet full
     C                   If        SQLCode < 100 and
     C                             Count <> Max
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 16
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LIST5
     C/end-exec

     C                   ELSE

     C/EXEC SQL
     C+ Select BDBKD
     C+ into   :WBookDesc
     C+ from SDBOOKPD
     C+ where BDBKCD = :WBook
     C/END-EXEC

     C/EXEC SQL
     C+ Get diagnostics :Rows = ROW_COUNT
     C/END-EXEC

     C                   If        SQLCode <> 0 and
     C                             SQLCode <> 100 or
     C                             Rows = 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 17
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetNostDtls - Nostro Account Details                         *
      *                                                               *
      *****************************************************************
     C     GetNostDtls   BEGSR

     C/exec SQL
     C+ Select A.CNUM, A.BRCA, A.ACOD, A.ACSQ, A.ACNO, A.ANAM
     C+ into :WNosCnum, :WNosBrc, :WNosAcod, :WNosAcsq,
     C+ :WNosACNo, :WNosACName
     C+ from ACCNTAB A
     C+ left join SDNOSTPD B on
     C+ A.CNUM = B.A7CUST and
     C+ A.CCY = B.A7CYCD  and
     C+ A.BRCA = B.A7BRCD and
     C+ A.ACOD = B.A7ACCD and
     C+ A.ACSQ = B.A7ACSN
     C+ where B.A7CYCD = :WNCcy and
     C+ B.A7NONB = :WNosc
     C/end-exec

     C                   If        SQLCode <> 0 and
     C                             SQLCode <> 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 20
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCustDtls1 - Customer Details using customer number        *
      *                                                               *
      *****************************************************************
     C     GetCustDtls1  BEGSR

     C/exec SQL
     C+ Select BBCSSN, BBCRNM, BBCRTN, BBCSID
     C+ into :WShrtNam, :WRptNam, :WRptTown, :WSwftID
     C+ from SDCUSTPD
     C+ where BBCUST = :WCnum
     C/end-exec

     C                   If        SQLCode <> 0 and
     C                             SQLCode <> 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 21
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCustDtls2 - Customer Details using partial account        *
      *                                                               *
      *****************************************************************
     C     GetCustDtls2  BEGSR

     C/exec SQL
     C+ Select BBCSSN, BBCRNM, BBCRTN, ANAM, BBCSID
     C+ into :WShrtNam, :WRptNam, :WRptTown, :WAcNam, :WSwftID
     C+ from V_ZACCNTAB
     C+ where BRCHACNO = :WPartial
     C/end-exec

     C                   If        SQLCode <> 0 and
     C                             SQLCode <> 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 22
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCustDtls3 - Customer Details using retail number          *
      *                                                               *
      *****************************************************************
     C     GetCustDtls3  BEGSR

     C/exec SQL
     C+ Select BBCSSN, BBCRNM, BBCRTN, ANAM, BBCSID
     C+ into :WShrtNam, :WRptNam, :WRptTown, :WAcNam, :WSwftID
     C+ from V_ZACCNTAB
     C+ where ACNO = :WAcNo
     C/end-exec

     C                   If        SQLCode <> 0 and
     C                             SQLCode <> 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 23
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCustDtls4 - Customer Details using Full GL account        *
      *                                                               *
      *****************************************************************
     C     GetCustDtls4  BEGSR

     C/exec SQL
     C+ Select BBCSSN, BBCRNM, BBCRTN, ANAM, BBCSID
     C+ into :WShrtNam, :WRptNam, :WRptTown, :WAcNam, :WSwftID
     C+ from V_ZACCNTAB
     C+ where BRFACNO = :WFull
     C/end-exec

     C                   If        SQLCode <> 0 and
     C                             SQLCode <> 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 24
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCustDtls5 - Customer Details using IBAN Number            *
      *                                                               *
      *****************************************************************
     C     GetCustDtls5  BEGSR

     C/exec SQL
     C+ Select BBCSSN, BBCRNM, BBCRTN, ANAM, BBCSID
     C+ into :WShrtNam, :WRptNam, :WRptTown, :WAcNam, :WSwftID
     C+ from V_ZACCNTAB
     C+ where IBAN = :WIban
     C/end-exec

     C                   If        SQLCode <> 0 and
     C                             SQLCode <> 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 25
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

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

     C                   IF        NOT %OPEN(GL000901AU)
     C                   OPEN      GL000901AU
     C                   ENDIF
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR

     C                   RETURN

     C                   ENDSR
      /EJECT
      *****************************************************************
**    SweepTypeArray
Minimum
Maximum
Specified balance on account
Specified balance on pool
Start of day balance on account
Minimum and Maximum
**    SettTypeArray
Settlement by Telex
Settlement by Paper
Settlement by SWIFT
Settlement by CHAPS
**    MonthArray
JanfebMarAprMayJunJulAugSepOctNovDec
