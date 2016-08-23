     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Bank Position Optimisation Audit Report')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GL000900P - Midas OF Bank Position Optimisation Audit Report *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CGL176             Date 28Jul15               *
      *  Prev Amend No. MD032130           Date 29Jan15               *
      *                 CGL158   *CREATE   Date 20Aug14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL176 - Optimisation of Nostro Balances by Company          *
      *  MD032130 - Incorrect initiate date and time shown when only  *
      *             manual transfers were in a batch                  *
      *  CGL158 - Bank Position Management Audit                      *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas OF Bank Position Management Audit Report
     FGL000900P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN

      ** Bank Position Management Audit Report - AU
     FGL000900AUO    E             PRINTER INFDS(SPOOLU)
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
     D BPAU          E DS                  EXTNAME(GLBPAUTD)

      ** DS for Currency Caching
     D CurrencyDS      DS
     D CCode                          3
     D CNDP                           1  0

     D Max             C                   CONST(100)
     D CcyArray        S              3    DIM(Max)
     D NDPArray        S              1  0 DIM(Max)
     D MonthArray      S              3    DIM(12) CTDATA PERRCD(12)

      ** File Information Data Structure for GL000900P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for GL000900AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** Data Structures for amount display

     D                 DS
     D   PRCLDB                1     15  0
     D   PRCLD0                1     15  0
     D   PRCLD1                1     15  0
     D   PRCLD2                1     15  0
     D   PRCLD3                1     15  0

     D                 DS
     D   PRFORB                1     15  0
     D   PRFOR0                1     15  0
     D   PRFOR1                1     15  0
     D   PRFOR2                1     15  0
     D   PRFOR3                1     15  0

     D                 DS
     D   PRPROB                1     15  0
     D   PRPRO0                1     15  0
     D   PRPRO1                1     15  0
     D   PRPRO2                1     15  0
     D   PRPRO3                1     15  0

     D                 DS
     D   PRUNRB                1     15  0
     D   PRUNR0                1     15  0
     D   PRUNR1                1     15  0
     D   PRUNR2                1     15  0
     D   PRUNR3                1     15  0

     D                 DS
     D   PRESTB                1     15  0
     D   PREST0                1     15  0
     D   PREST1                1     15  0
     D   PREST2                1     15  0
     D   PREST3                1     15  0

     D                 DS
     D   PRESTP                1     15  0
     D   PRESP0                1     15  0
     D   PRESP1                1     15  0
     D   PRESP2                1     15  0
     D   PRESP3                1     15  0

     D                 DS
     D   PRESTA                1     15  0
     D   PRESB0                1     15  0
     D   PRESB1                1     15  0
     D   PRESB2                1     15  0
     D   PRESB3                1     15  0

     D                 DS
     D   PRSUTR                1     15  0
     D   PRSUT0                1     15  0
     D   PRSUT1                1     15  0
     D   PRSUT2                1     15  0
     D   PRSUT3                1     15  0

     D                 DS
     D   PRSUTA                1     15  0
     D   PRSBA0                1     15  0
     D   PRSBA1                1     15  0
     D   PRSBA2                1     15  0
     D   PRSBA3                1     15  0

     D                 DS
     D   PRSUTB                1     15  0
     D   PRSBB0                1     15  0
     D   PRSBB1                1     15  0
     D   PRSBB2                1     15  0
     D   PRSBB3                1     15  0

     D                 DS
     D   PRTESP                1     15  0
     D   PRTEP0                1     15  0
     D   PRTEP1                1     15  0
     D   PRTEP2                1     15  0
     D   PRTEP3                1     15  0

     D                 DS
     D   PRTESB                1     15  0
     D   PRTEB0                1     15  0
     D   PRTEB1                1     15  0
     D   PRTEB2                1     15  0
     D   PRTEB3                1     15  0

     D                 DS
     D   PRTSUP                1     15  0
     D   PRTSP0                1     15  0
     D   PRTSP1                1     15  0
     D   PRTSP2                1     15  0
     D   PRTSP3                1     15  0

     D                 DS
     D   PRTSUB                1     15  0
     D   PRTSB0                1     15  0
     D   PRTSB1                1     15  0
     D   PRTSB2                1     15  0
     D   PRTSB3                1     15  0

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
     D WCcy            S              3
     D WCcyNBDP        S              1S 0
     D WRecBpAu        S              7S 0 Inz
     D WCTMS           S             26    Inz
     D WITMS           S             26    Inz
     D CMONTH          S              2  0 Inz
     D IMONTH          S              2  0 Inz
     D InitDone        S              1
     D WITMST          S               Z
     D WRun            S              1
     D Rows            S              1  0 Inz
     D BaseCcy         S              3
     D BaseNDP         S              1  0
     D BaseFnd         S              1
     D Count           S              3S 0 Inz
     D PrtHdr3         S              1
     D TotBPESTP       S             15  0
     D TotBPSUTP       S             15  0
     D WPOOL           S             10
     D WBPPCCY         S              3
     D WBPMDP          S              1
     D WBPERTP         S             13  8
     D PoolNDP         S              1  0
     D WPRTESB         S             15  0
     D WPRTSUB         S             15  0

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
     C+ select * from GLBPAUTD                                                              CGL176
     C+ order by                                                                            CGL176
     C+    BPCMCD, BPITMS, BPCTMS DESC,                                                     CGL176
     C+    case when BPPOOL = ' ' then 2 else 1 end, BPPOOL,                                CGL176
     C+    BPCURR, BPNOSC                                                                   CGL176
     C/end-exec                                                                             CGL176
      *                                                                                     CGL176
     C/exec SQL                                                                             CGL176
     C+ open LISTA                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   ENDIF

     C                   If        P#Entity <> *Blanks and                                  CGL176
     C                             P#Entity <> 'ALL'                                        CGL176
     C                   Eval      P#Company = 'Y'                                          CGL176
      ** Set file pointer to first record and do initial read                               CGL176
     C/exec SQL                                                                             CGL176
     C+ declare LISTB cursor for                                                            CGL176
     C+ select * from GLBPAUTD                                                              CGL176
     C+ where BPCMCD = :P#Entity                                                            CGL176
     C+ order by                                                                            CGL176
     C+    BPCMCD, BPITMS, BPCTMS DESC,                                                     CGL176
     C+    case when BPPOOL = ' ' then 2 else 1 end, BPPOOL,                                CGL176
     C+    BPCURR, BPNOSC                                                                   CGL176
     C/end-exec                                                                             CGL176
      *                                                                                     CGL176
     C/exec SQL                                                                             CGL176
     C+ open LISTB                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   ENDIF                                                              CGL176
      *                                                                                     CGL176
     C                   Else                                                               CGL176
      *
      ** Set file pointer to first record and do initial read

     C/exec SQL
     C+ declare LIST cursor for
     C+ select * from GLBPAUTD
     C+ order by
     C+    BPITMS, BPCTMS DESC,
     C+    case when BPPOOL = ' ' then 2 else 1 end, BPPOOL,
     C+    BPCURR, BPNOSC
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
     C+ into :BPAU                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   If        P#Company = 'Y'                                          CGL176
     C/exec SQL                                                                             CGL176
     C+ fetch next                                                                          CGL176
     C+ from LISTB                                                                          CGL176
     C+ into :BPAU                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   Else                                                               CGL176
     C/exec SQL
     C+ fetch next
     C+ from LIST
     C+ into :BPAU
     C/end-exec
     C                   Endif                                                              CGL176

      ** Read until end of file

     C                   CLEAR                   WITMST
     C                   DOW       SQLCode <> 100

     C                   IF        NOT %OPEN(GL000900P1)

     C                   OPEN      GL000900P1

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

     C                   EVAL      WRecBpAU = WRecBpAU + 1
     C                   EVAL      PrtHdr3 = 'N'

      ** Print Total for previous pool

     C                   IF        WPOOL <> BPPOOL AND
     C                             WPOOL <> *BLANKS AND
     C                             CGL159 = 'Y'

     C                   IF        (OFLLN1 - PRTLN1) <= 3
     C                   EXSR      SRPrintHdr1
     C                   ENDIF
     C                   EXSR      SRPrintPoolT
     C                   EVAL      TotBPESTP = 0
     C                   EVAL      TotBPSUTP = 0
     C                   CLEAR                   POOLT

     C                   ENDIF

      ** Print Report Header 2 only once for each batch of confirm all

     C                   IF        WITMST <> BPITMS
     C                   EXSR      SRPrintHdr1
     C                   EXSR      SRPrintHdr2
     C                   EVAL      WITMST = BPITMS
     C                   EVAL      WPOOL = *BLANKS
     C                   EVAL      PrtHdr3 = 'Y'
     C                   ENDIF

      ** Print Header for the new pool

     C                   IF        WPOOL <> BPPOOL AND
     C                             CGL159 = 'Y'

     C                   IF        BPPOOL <> *BLANKS
     C                   IF        (OFLLN1 - PRTLN1) <= 13
     C                   EXSR      SRPrintHdr1
     C                   ENDIF
     C                   EXSR      SRPrintPoolH
     C                   EVAL      WBPPCCY = BPPCCY
     C                   EVAL      WBPMDP = BPMDP
     C                   EVAL      WBPERTP = BPERTP
     C                   ENDIF

     C                   EVAL      PrtHdr3 = 'Y'
     C                   EVAL      WPOOL = BPPOOL
     C                   ENDIF

     C                   IF        WPOOL = *BLANKS AND
     C                             BPPOOL = *BLANKS AND
     C                             (OFLLN1 - PRTLN1) <= 5
     C                   EVAL      PrtHdr3 = 'Y'
     C                   ENDIF
     C
      ** Print Report Header 3 for every new page or pool or
      ** initiate timestamp

     C                   IF        PrtHdr3 = 'Y'
     C                   IF        (OFLLN1 - PRTLN1) <= 10
     C                   EXSR      SRPrintHdr1
     C                   ENDIF
     C                   EXSR      SRPrintHdr3
     C                   ENDIF

      ** Print details

     C                   IF        (OFLLN1 - PRTLN1) <= 5
     C                   EXSR      SRPrintHdr1
     C                   ENDIF
     C                   EXSR      SRDetails

     C                   If        CGL176 = 'Y' and P#Company <> 'N'                        CGL176
     C                   If        P#Company = 'A'                                          CGL176
     C/exec SQL                                                                             CGL176
     C+ fetch next from LISTA                                                               CGL176
     C+ into :BPAU                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   If        P#Company = 'Y'                                          CGL176
     C/exec SQL                                                                             CGL176
     C+ fetch next from LISTB                                                               CGL176
     C+ into :BPAU                                                                          CGL176
     C/end-exec                                                                             CGL176
     C                   Endif                                                              CGL176
     C                   Else                                                               CGL176
     C/exec SQL
     C+ fetch next from LIST
     C+ into :BPAU
     C/end-exec
     C                   Endif                                                              CGL176
      ** close the current spooled file to generate a new one for a different Company       CGL176
     C                   If        CGL176 = 'Y' and P#Company <> 'N' and                    CGL176
     C                             SQLCode <> 100 and BPCMCD <> H2CMCD                      CGL176
     C                   EXSR      SRPrintFtr                                               CGL176
     C                   Close     GL000900P1                                               CGL176
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
     C                                      'AUDIT REPORT'
     C                   EVAL      FUNDRS = '---------------------------' +
     C                                      '------------'
      *                                                                                     CGL176
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
      ** If all are Manual Transfers, do not output Initiate Date                           MD032130
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
      *  SRPrintHdr3 - Print Header 3 Routine                         *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr3   BEGSR

     C                   WRITE     HEADER3

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintPoolH - Print Pool Header                             *
      *                                                               *
      *****************************************************************
     C     SRPrintPoolH  BEGSR

     C                   CLEAR                   POOLH

      ** Pool
     C                   EVAL      PRPOOL = BPPOOL

      ** Pool Description
     C                   EVAL      PRPOOD = BPPOOD

      ** Pivot Currency
     C                   EVAL      PRPCCY = BPPCCY

      ** Exchange Rate Pivot to Base
     C                   EVAL      PRERTP = BPERTP

     C                   WRITE     POOLH

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintPoolT - Print Pool Total                              *
      *                                                               *
      *****************************************************************
     C     SRPrintPoolT  BEGSR


      ** Pool estimated balance in Pivot ccy
     C                   EVAL      PRTESP = TotBPESTP
     C                   EVAL      PRCESP = WBPPCCY

      ** Pool estimated balance in Base ccy
     C                   CALL      'ZCONVZ1'
     C                   PARM                    TotBPESTP
     C                   PARM                    WBPERTP
     C                   PARM                    WBPMDP
     C                   PARM                    WBPPCCY
     C                   PARM                    BaseCcy
     C                   PARM                    PoolNDP
     C                   PARM                    BaseNDP
     C                   PARM                    WPRTESB

     C                   Z-ADD     WPRTESB       PRTESB
     C                   EVAL      PRCESB = BaseCcy

      ** Pool suggested balance in Pivot ccy
     C                   EVAL      PRTSUP = TotBPSUTP
     C                   EVAL      PRCSSP = WBPPCCY

      ** Pool suggested balance in Base ccy
     C                   CALL      'ZCONVZ1'
     C                   PARM                    TotBPSUTP
     C                   PARM                    WBPERTP
     C                   PARM                    WBPMDP
     C                   PARM                    WBPPCCY
     C                   PARM                    BaseCcy
     C                   PARM                    PoolNDP
     C                   PARM                    BaseNDP
     C                   PARM                    WPRTSUB

     C                   Z-ADD     WPRTSUB       PRTSUB
     C                   EVAL      PRCSSB = BaseCcy

     C                   WRITE     POOLT

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

     C                   IF        WPOOL <> *BLANKS
     C                   EVAL      *IN89 = *ON
     C                   EVAL      TotBPESTP = TotBPESTP + BPESTP
     C                   EVAL      TotBPSUTP = TotBPSUTP + BPSUTP
     C                   ENDIF

      *** Currency decimal places retrieval

      ** Base currency
     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN11 = *OFF
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      *IN13 = *OFF
     C                   SELECT
     C                   WHEN      BaseNDP = 0
     C                   EVAL      *IN10 = *ON
     C                   WHEN      BaseNDP = 1
     C                   EVAL      *IN11 = *ON
     C                   WHEN      BaseNDP = 2
     C                   EVAL      *IN12 = *ON
     C                   WHEN      BaseNDP = 3
     C                   EVAL      *IN13 = *ON
     C                   ENDSL

      ** Nostro currency
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      A = %LOOKUP(BPCURR:CcyArray)
     C                   IF        A <> 0
     C                   Z-ADD     NDPArray(A)   WCcyNBDP
     C                   ELSE
     C                   EVAL      WCcy = BPCURR
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

      ** Pivot currency
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   IF        BPPCCY <> *BLANKS
     C                   EVAL      A = %LOOKUP(BPPCCY:CcyArray)
     C                   IF        A <> 0
     C                   Z-ADD     NDPArray(A)   WCcyNBDP
     C                   ELSE
     C                   EVAL      WCcy = BPPCCY
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
     C                   EVAL      PoolNDP = WCcyNBDP
     C                   ENDIF

      ** Nostro
     C                   EVAL      PRNOST = BPCURR + BPNOSC
     C                   EVAL      PRNOSD = BPNOSD
     C                   EVAL      PRACNO = BPACNO

      ** Initiate User
     C                   EVAL      PRIUSR = BPIUSR

      ** Cleared Balance
     C                   EVAL      PRCLDB = BPCLDB
     C                   EVAL      PRCCYC = BPCURR

      ** Forecast Balance
     C                   EVAL      PRFORB = BPFORB
     C                   EVAL      PRCCYF = BPCURR

      ** Projected Balance
     C                   EVAL      PRPROB = BPPROB
     C                   EVAL      PRCCYP = BPCURR

      ** Unreconciled Balance
     C                   EVAL      PRUNRB = BPUNRB
     C                   EVAL      PRCCYU = BPCURR

      ** Estimated Balance
     C                   EVAL      PRESTB = BPESTB
     C                   EVAL      PRCCYE = BPCURR

      ** Estimated Balance in Pivot Ccy
     C                   EVAL      PRESTP = BPESTP
     C                   EVAL      PRCYEP = BPPCCY

      ** Estimated Balance in Base Ccy
     C                   EVAL      PRESTA = BPESTA
     C                   EVAL      PRCYEB = BaseCCy

      ** Estimated Exchange rate
     C                   EVAL      PREXRT = BPEXRT

      ** Suggested Transfers
     C                   EVAL      PRSUTR = BPSUTR
     C                   EVAL      PRCCYS = BPCURR

      ** Suggested Balance in A/C Ccy
     C                   EVAL      PRSUTA = BPSUTA
     C                   EVAL      PRCYSA = BPCURR

      ** Suggested Balance in Base Ccy
     C                   EVAL      PRSUTB = BPSUTB
     C                   EVAL      PRCYSB = BaseCcy

      ** Spot Rate Indicator
     C                   EVAL      PRSPRT = BPSPRT

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

     C                   IF        WRecBpAU > 0

     C                   IF        (OFLLN1 - PRTLN1) <= 3
     C                   EXSR      SRPrintHdr1
     C                   ENDIF
     C                   WRITE     FOOTER

     C                   ELSE

     C                   IF        NOT %OPEN(GL000900AU)
     C                   OPEN      GL000900AU
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
     C                   EVAL      BaseCcy = BJCYCD
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
     C                   EVAL      BaseCcy = BJCYCD
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
     C                   EVAL      *IN87 = *ON
     C                   ELSE
     C                   EVAL      CGL159 = 'N'
     C                   EVAL      *IN87 = *OFF
     C                   ENDIF

      ** Determine if CGL176 is installed                                                   CGL176
     C                   EVAL      P#Company = 'N'                                          CGL176
     C                   EVAL      *IN40 = *OFF                                             CGL176
     C                   EVAL      CGL176= 'N'                                              CGL176
     C                   CALL      'AOSARDR0'                                               CGL176
     C                   PARM      *BLANKS       PRTCD                                      CGL176
     C                   PARM      '*VERIFY'     POPTN                                      CGL176
     C                   PARM      'CGL176'      PSARD                                      CGL176
     C     SCSARD        PARM      SCSARD        DSFDY                                      CGL176
      *                                                                                     CGL176
     C                   IF        PRTCD = *BLANKS                                          CGL176
     C                   EVAL      CGL176 = 'Y'                                             CGL176
     C                   ENDIF                                                              CGL176
      *
      ** Cache currency and number of decimal places

     C                   EVAL      BaseFnd = 'N'
     C                   EXSR      CurrencyCache
     C                   EVAL      InitDone = 'Y'

     C                   IF        BaseFnd = 'N'
     C                   EVAL      WCcy = BaseCcy
     C                   EXSR      CurrencyCache
     C                   EVAL      BaseFnd = 'Y'
     C                   EVAL      BaseNDP = WCcyNBDP
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
     C                   IF        CCode = BaseCCy
     C                   EVAL      BaseNDP = CNDP
     C                   EVAL      BaseFnd = 'Y'
     C                   ENDIF

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

     C                   IF        NOT %OPEN(GL000900AU)
     C                   OPEN      GL000900AU
     C                   ENDIF
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR

     C                   RETURN

     C                   ENDSR
      /EJECT
      *****************************************************************
**    MonthArray
JanfebMarAprMayJunJulAugSepOctNovDec
