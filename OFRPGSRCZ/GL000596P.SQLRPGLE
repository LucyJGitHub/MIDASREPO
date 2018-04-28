     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Bank Position COB Report')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000596P - Midas OF Bank Position COB Report                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD027241           Date 29May14               *
      *  Prev Amend No. MD027156           Date 23May14               *
      *                 MD026777           Date 14May14               *
      *                 MD026759           Date 14May14               *
      *                 MD026756           Date 09May14               *
      *                 CGL153   *Create   Date 14Feb14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
     ** File DS
 
     D BPOW          E DS                  EXTNAME(SDBPOWTD)
     D NOS2          E DS                  EXTNAME(SDNOST2D)
     D EERT          E DS                  EXTNAME(SDEERTTD)
     D TNOS          E DS                  EXTNAME(GLTNOSTD)
     D NOST          E DS                  EXTNAME(SDNOSTPD)
 
 
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PSARD           S              6
 
      ** Parameter variables for AOSVALR0 string
     D SVALK1          S             20
     D SVAL1           S            200
     D SVALK2          S             20
     D SVAL2           S            200
     D SVALK3          S             20
     D SVAL3           S            200
     D SVALK4          S             20
     D SVAL4           S            200
     D SVALK5          S             20
     D SVAL5           S            200
     D SVALK6          S             20
     D SVAL6           S            200
     D SVALK7          S             20
     D SVAL7           S            200
     D SVALK8          S             20
     D SVAL8           S            200
     D SVALK9          S             20
     D SVAL9           S            200
     D SVALK0          S             20
     D SVAL10          S            200
 
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
     D PNB0            S             15P 0
     D PCCY            S              3A
     D PBRCA           S              3A
     D PACCD           S             10A
     D PACNO           S             10A
     D PCUST           S              6A
     D PACSN           S              2A
     D PDecPlace       S              1  0
     D WAmount         S             15  0
     D WAmount2        S             15  0
     D WPrvPool        S             10
     D WADDAMT         S             13P 0
     D WSubTot         S             16P 0
     D WTotal          S             17P 0
     D WPDBASE         S             17P 0
     D WA6NBDP         S              1P 0
     D WPOOL           S             10
     D WA7ACSN         S              2
     D WBJRDNB         S             15
     D WNONB           S              2P 0
     D WBRANCH         S              3
     D W_LDBL          S             15P 0
     D W_ANAM          S             20
     D W_ZONE          S             10
     D InputAmnt       S             15  0
     D ExchRate        S             13  8
     D MultDivInd      S              1
     D FrCurrency      S              3
     D ToCurrency      S              3
     D FrDecPlace      S              1  0
     D ToDecPlace      S              1  0
     D OutputAmnt      S             15  0
 
     D sqlString       S          32000A   Varying
     D                                     Inz
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
 
      ** Extract different data to workfile
 
     C                   EXSR      SRWrkFile
 
      ** Do processing for the print
 
     C/exec SQL
     C+ declare LISTA cursor for
     C+ select * from SDBPOWTD
     C+ order by
     C+       BPPOOL
     C+      ,BPCCY
     C+      ,BPNOSC
     C+      ,BPACCT
     C/end-exec
 
     C/exec SQL
     C+ open LISTA
     C/end-exec
 
      ** Handle SQL Error (if not %EOF)
 
     C                   If        SQLCOD < 0
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   EndIf
 
     C/exec SQL
     C+ fetch next
     C+ from LISTA
     C+ into :BPOW
     C/end-exec
 
      ** Bank Position details
 
     C                   EVAL      WPrvPool = *BLANKS
     C                   EVAL      WSubTot = 0
     C                   EVAL      WTotal  = 0
 
     C                   Z-ADD     0             WPDBASE
 
     C                   DOW       SQLCode <> 100
 
      ** Count
 
     C                   EVAL      WRecNo = WRecNo + 1
 
 
     C                   EVAL      PDCCY  = BPCCY
     C                   IF        BPCCY <> BJCYCD
 
      ***   base rate currency decimal places
 
     C                   MOVE      BJCYCD        PCCY
     C                   EXSR      GetCurrDtls
     C                   MOVE      A6NBDP        WA6NBDP
     C                   ELSE
     C                   Z-ADD     0             WA6NBDP
     C                   ENDIF
     C                   MOVE      BPCCY         PCCY
     C                   EXSR      GetCurrDtls
 
      ** Account details
 
     C                   EVAL      PDACCT = BPACCT
 
      ** Cleared Balance
 
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = BPCLBL
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PDCLBL
 
 
      ** Forecast Balance
 
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = BPFAMT
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PDFAMT
 
      ** Projected Balance
 
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = BPPAMT
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PDPAMT
 
      ** Unreconciled Balance
 
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = BPUAMT
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PDUAMT
 
      ** Statement Balance
 
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = BPSAMT
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PDSAMT
 
      ** Estimated Balance
 
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount2 =  BPCLBL + BPFAMT + BPPAMT + BPUAMT
     C                   EVAL      WAmount = WAmount2
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PDESBL
 
 
      ** Estimated Exchange Rate
 
     C                   EVAL      PDERAT = BPERAT
 
      ** Spot Rate Indicator
 
     C                   EVAL      PDSPOT = BPSPOT
 
      ** Estimated Balance in Base currency
 
     C                   IF        BPCCY = BJCYCD
     C                   EVAL      PDBASE = PDESBL
     C                   EVAL      WPDBASE = WAmount2
     C                   ELSE
     C                   EVAL      InputAmnt = WAmount2
     C                   EVAL      ExchRate = BPERAT
     C                   EVAL      MultDivInd = BPMDIN
     C                   EVAL      FrCurrency = BPCCY
     C                   EVAL      ToCurrency = BJCYCD
     C                   EVAL      FrDecPlace = A6NBDP
     C                   EVAL      ToDecPlace = WA6NBDP
     C                   EXSR      ConvertBase
     C                   EVAL      WPDBASE = OutPutAmnt
 
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = WPDBASE
     C                   EVAL      PDecPlace = WA6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PDBASE
 
     C                   ENDIF
 
 
      ** Print Report Headers for every new page
 
     C                   IF        WRecNo = 1
     C                   EVAL      PRTLN1 = 70
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRPrintHdr1
     C                   EXSR      SRPrintHdr2
     C                   EXSR      SRPrintHdr3
     C                   ENDIF
 
     C                   IF        WRecno > 1
     C                             and WPrvPool <> BPPOOL
 
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = WSubTot
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PDSUB
 
     C                   EVAL      RqdLn1 = 2                                               MD027156
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 MD027156
                                                                                            MD027156
     C                   IF        DifLn1 <= RqdLn1                                         MD027156
     C                   EXSR      SRPrintHdr1                                              MD027156
     C                   EXSR      SRPrintHdr2                                              MD027156
     C                   ENDIF                                                              MD027156
     C                   WRITE     SUBPOOL
     C                   EVAL      WSubTot = 0
     C                   ENDIF
 
      **** Accumulate Estimate Balance in base currency
 
     C                   EVAL      WSubTot = WSubTot + WPDBASE
     C                   EVAL      WTotal  = WTotal  + WPDBASE
 
     C                   IF        WPrvPool <> BPPOOL
     C                             AND BPPOOL <> *HIVAL
     C                   IF        BPPOOL = *HIVAL
     C                   EVAL      PDPOOL2 = *BLANKS
     C                   ELSE
     C                   EVAL      PDPOOL2 = BPPOOL
     C                   ENDIF
     C                   EVAL      PDNOSN2 = *BLANKS
     C                   EVAL      PDCCY2 = BJCYCD
     C                   EVAL      RqdLn1 = 1                                               MD027156
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 MD027156
                                                                                            MD027156
     C                   IF        DifLn1 <= RqdLn1                                         MD027156
     C                   EXSR      SRPrintHdr1                                              MD027156
     C                   EXSR      SRPrintHdr2                                              MD027156
     C                   ENDIF                                                              MD027156
     C                   WRITE     DETAIL2
     C                   ENDIF
 
     C                   IF        BPPOOL = *HIVAL
     C                   EVAL      PDPOOL = BPCCY + BPNOSC
     C                   ELSE
     C                   EVAL      PDPOOL = '   ' + BPCCY + BPNOSC
     C                   ENDIF
 
     C                   EVAL      PDNOSN  = BPNOSN
 
     C                   EVAL      RqdLn1 = 2                                               MD027156
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 MD027156
                                                                                            MD027156
     C                   IF        DifLn1 <= RqdLn1                                         MD027156
     C                   EXSR      SRPrintHdr1                                              MD027156
     C                   EXSR      SRPrintHdr2                                              MD027156
     C                   ENDIF                                                              MD027156
     C                   WRITE     DETAIL
 
     C                   EVAL      WPrvPool = BPPOOL
 
     C/exec SQL
     C+ fetch next from LISTA
     C+ into :BPOW
     C/end-exec
 
     C                   ENDDO
 
 
      ** Handle SQL Error (if not %EOF)
 
     C                   If        SQLCode < 100
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 003
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   EndIf
 
     C/exec SQL
     C+ close LISTA
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
      *  SRWrkFile - Work file                                        *
      *                                                               *
      *****************************************************************
     C     SRWrkFile     BEGSR
 
     C/exec SQL
     C+ declare LISTB cursor for
     C+ select *
     C+ from SDNOSTPD
     C+ order by
     C+   A7CYCD
     C+  ,A7NONB
     C/end-exec
 
     C/exec SQL
     C+ open LISTB
     C/end-exec
 
      ** Handle SQL Error (if not %EOF)
 
     C                   If        SQLCOD < 0
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 004
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   EndIf
 
     C/exec SQL
     C+ fetch next
     C+ from LISTB
     C+ into :NOST
     C/end-exec
 
 
     C                   DOW       SQLCode <> 100
 
      ** POOL
 
     C                   EXSR      RetrievePOOL
 
      ** Nostro Code
 
     C                   EVAL      BPNOSC = A7NONB
 
      ** Currency
 
     C                   EVAL      BPCCY  = A7CYCD
 
      ** Account
 
     C                   MOVE      A7ACSN        WA7ACSN
     C                   EVAL      BPACCT  = A7BRCD + A7CUST + A7CYCD + A7ACCD
     C                                       + WA7ACSN
 
      ** Ledger balance
 
     C                   MOVE      A7ACCD        PACCD
     C                   MOVE      A7ACSN        PACSN
     C                   MOVE      A7CUST        PCUST
     C                   MOVE      A7CYCD        PCCY
     C                   MOVE      A7BRCD        PBRCA
     C                   EVAL      BPNOSN = *BLANKS
     C                   EXSR      GetAcctDtls
     C                   EVAL      BPCLBL = W_LDBL
     C                   EVAL      BPNOSN = W_ANAM
 
      ** Projected Balance
 
     C                   EXSR      ProjectedBAL
 
 
      ** Forecast Balance
 
     C                   EXSR      ForecastBAL
 
      ** Unreconciled Balance
 
     C                   EXSR      UnreconBAL
 
 
      ** Statement Balance   - still on hold!!!!
 
     C                   EVAL      BPSAMT = 0
 
 
      ** Estimated Exchange Rate and Spot Rate Indicator
 
     C                   EXSR      RateandSpot
 
      ** Insert to file
 
     C/EXEC SQL
     C+ insert into SDBPOWTD
     C+ (
     C+  BPPOOL
     C+ ,BPCCY
     C+ ,BPNOSC
     C+ ,BPNOSN
     C+ ,BPACCT
     C+ ,BPCLBL
     C+ ,BPFAMT
     C+ ,BPPAMT
     C+ ,BPUAMT
     C+ ,BPSAMT
     C+ ,BPERAT
     C+ ,BPMDIN
     C+ ,BPSPOT
     C+ )
     C+ Values
     C+ (
     C+  :BPPOOL
     C+ ,:BPCCY
     C+ ,:BPNOSC
     C+ ,:BPNOSN
     C+ ,:BPACCT
     C+ ,:BPCLBL
     C+ ,:BPFAMT
     C+ ,:BPPAMT
     C+ ,:BPUAMT
     C+ ,:BPSAMT
     C+ ,:BPERAT
     C+ ,:BPMDIN
     C+ ,:BPSPOT
     C+ )
     C/END-EXEC
 
 
     C/exec SQL
     C+ fetch next from LISTB
     C+ into :NOST
     C/end-exec
 
     C                   ENDDO
 
      ** Handle SQL Error (if not %EOF)
 
     C                   If        SQLCode < 100
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 005
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   EndIf
 
     C/exec SQL
     C+ close LISTB
     C/end-exec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RetrievePOOL - Retrieve Pool                                 *
      *                                                               *
      *****************************************************************
     C     RetrievePOOL  BEGSR
 
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
                                                                                            MD026777
     C/exec SQL                                                                             MD026777
     C+ select COALESCE(POOL,' ') into :WPOOL from SDBPOLTD                                 MD026777
     C+ where SUBSTR(DDCYCD,1,3) = :A7CYCD                                                  MD026777
     C+     and DDNONB = :A7NONB                                                            MD026777
     C+     and ZONE  = :W_ZONE                                                             MD026777
     C+     and COALESCE(POOL,' ') <> ' '                                                   MD026777
     C+ order by                                                                            MD026777
     C+       POOL DESC                                                                     MD026777
     C/end-exec                                                                             MD026777
 
     C                   IF        SQLCODE <> 0 or WPOOL = *BLANKS
     C                   EVAL      BPPOOL = *HIVAL
     C                   ELSE
     C                   EVAL      BPPOOL = WPOOL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ProjectedBAL - Projected Balance                             *
      *                                                               *
      *****************************************************************
     C     ProjectedBAL  BEGSR
 
     C                   EVAL      WADDAMT = 0
     C                   MOVEL     BJRDNB        WBJRDNB
     C                   MOVE      A7NONB        WNONB
     C                   EVAL      BPPAMT = 0
 
     C/exec SQL
     C+ select
     C+    COALESCE(PNB0,0)
     C+ into
     C+   :PNB0
     C+ from GLPRONOW0
     C+ where RECI = 'D'
     C+   and CCY  = :A7CYCD
     C+   and NOSN = :WNONB
     C+   and PND0 = :BJRDNB
     C/end-exec
 
     C                   IF        SQLCODE = 0
     C                   EVAL      WADDAMT = PNB0
 
     C                   IF        WADDAMT = 0
     C                   EVAL      BPPAMT = 0
     C                   ELSE
     C                   EVAL      BPPAMT = WADDAMT - BPCLBL
     C                   ENDIF
 
     C                   ELSE
 
     C/exec SQL
     C+ select SUM(COALESCE(TMVAM,0)) into :WADDAMT from GLRSACMW0
     C+ where CCYD = :A7CYCD
     C+   and A7NONB = :A7NONB
     C+   and VUDT = :BJRDNB
     C/end-exec
 
     C                   IF        SQLCODE = 0
     C                   EVAL      BPPAMT = WADDAMT
     C                   ENDIF
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ForecastBAL - Forecast Balance                               *
      *                                                               *
      *****************************************************************
     C     ForecastBAL   BEGSR
 
     C                   EVAL      BPFAMT = 0
 
     C/exec SQL
     C+ select * into :TNOS from GLTNOSTD
     C+ where NCCYCD = :A7CYCD
     C+   and NCNONB = :A7NONB
     C/end-exec
 
     C                   EVAL      BPFAMT = 0
     C                   IF        SQLCODE = 0
     C                   IF        NCDAT0 = BJRDNB
     C                   EVAL      BPFAMT = NCAMT0
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UnreconBAL  - Unreconciled Balance                           *
      *                                                               *
      *****************************************************************
     C     UnreconBAL    BEGSR
 
     C                   EVAL      BPUAMT = 0
 
     C/exec SQL
     C+ select * INTO :NOS2 from SDNOST2D
     C+ where
     C+       ERNONB = :A7NONB
     C+   and ERCYCD = :A7CYCD
     C/end-exec
 
     C                   IF        SQLCODE = 0
     C                   MOVE      *BLANKS       WBRANCH
     C                   IF        ERBRCA = *BLANKS
     C                   EVAL      WBRANCH = A7BRCD
     C                   ELSE
     C                   EVAL      WBRANCH = ERBRCA
     C                   ENDIF
 
     C                   IF        ERACCD <> 0 and ERACSN <> 0
     C                   MOVE      ERACCD        PACCD
     C                   MOVE      ERACSN        PACSN
     C                   MOVE      A7CUST        PCUST
     C                   MOVE      ERCYCD        PCCY
     C                   MOVE      WBRANCH       PBRCA
     C                   EXSR      GetAcctDtls
     C                   EVAL      BPUAMT = W_LDBL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RateandSpot - Rate and Spot Indicator                        *
      *                                                               *
      *****************************************************************
     C     RateandSpot   BEGSR
 
     C                   EVAL      BPERAT = 0
 
     C/exec SQL
     C+ select * into :EERT from SDEERTTD
     C+ where
     C+       (ERCCY  = :A7CYCD
     C+   and ERNOSC = :A7NONB
     C+   and ERTCCY = :BJCYCD
     C+   and ERDATE = :BJRDNB)
     C+    or (ERCUST = :A7CUST
     C+   and ERCCY  = :A7CYCD
     C+   and ERTCCY = :BJCYCD
     C+   and ERDATE = :BJRDNB)
     C+ order by
     C********ERTMST DESC                                                                 MD026756
     C+       ERNOSC DESC                                                                 MD026756
     C+      ,ERTMST DESC                                                                 MD026756
     C/end-exec
 
     C                   IF        (SQLCODE <> 0 AND SQLCODE <> -811)
     C                               OR EREXRT = 0
     C                   EVAL      BPSPOT = 'Y'
     C                   EVAL      BPERAT = 0
     C                   MOVE      BPCCY         PCCY
     C                   EXSR      GetCurrDtls
     C     PRtCd         IFEQ      *BLANKS
     C                   EVAL      BPERAT = A6SPRT
     C                   EVAL      BPMDIN = A6MDIN
     C                   ENDIF
     C                   ELSE
     C                   EVAL      BPERAT = EREXRT
     C                   EVAL      BPSPOT = 'N'
     C                   EVAL      BPMDIN = ERMDIN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetAcctDtls - Get Account Details (Account Name)             *
      *                                                               *
      *****************************************************************
     C     GetAcctDtls   BEGSR
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      *BLANKS       PACNO
     C                   PARM                    PCUST
     C                   PARM                    PCCY
     C                   PARM                    PACCD
     C                   PARM                    PACSN
     C                   PARM                    PBRCA
     C     SDACCT        PARM      SDACCT        DSSDY
 
     C     PRtCd         IFEQ      *BLANKS
     C                   EVAL      W_LDBL = A_LDBL
     C                   EVAL      W_ANAM = A_ANAM
     C                   ELSE
     C                   Z-ADD     *ZERO         W_LDBL
     C                   MOVE      *BLANKS       W_ANAM
     C                   ENDIF
 
     C                   ENDSR
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
     C     SRPrintFtr    BEGSR
 
     C                   IF        WRecNo > 0
 
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = WSubTot
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PDSUB
 
     C                   EVAL      PDBCUR = BJCYCD
 
     C                   EVAL      RqdLn1 = 2                                               MD027156
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 MD027156
                                                                                            MD027156
     C                   IF        DifLn1 <= RqdLn1                                         MD027156
     C                   EXSR      SRPrintHdr1                                              MD027156
     C                   EXSR      SRPrintHdr2                                              MD027156
     C                   ENDIF                                                              MD027156
     C                   If        WPrvPool <> *Blanks and                                  MD027241
     C                             WPrvPool <> *HIVAL                                       MD027241
     C                   WRITE     SUBPOOL
     C                   Endif                                                              MD027241
 
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = WTotal
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PDTOT
 
     C                   EVAL      RqdLn1 = 6                                               MD026777
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 MD026777
                                                                                            MD026777
     C                   IF        DifLn1 <= RqdLn1                                         MD026777
     C                   EXSR      SRPrintHdr1                                              MD026777
     C                   EXSR      SRPrintHdr2                                              MD026777
     C                   ENDIF                                                              MD026777
 
     C                   WRITE     TOTAL
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
 
 
      * Retrieve the system value
 
     C                   EVAL      SVALK1 = 'ZoneSystemName'
     C                   CALL      'AOSVALR0'
     C                   PARM                    PRtCd
     C                   PARM                    SVALK1
     C                   PARM                    SVAL1
     C                   PARM                    SVALK2
     C                   PARM                    SVAL2
     C                   PARM                    SVALK3
     C                   PARM                    SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10
 
      ** If the system value is not found then issue a database error
 
     C     PRtCd         IFNE      '       '
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     SVAL1         W_ZONE
 
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
