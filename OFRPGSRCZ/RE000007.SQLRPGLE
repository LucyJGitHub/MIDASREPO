     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  RE000007 - Midas OF Generation of Modelo 123                 *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD034332           Date 31Mar15               *
      *                 CRE104  *CREATE    Date 31Mar15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034332 - Resultado a ingresar field on the generated       *
      *             Modelo 123 report has erroneous value             *
      *  CRE104 - Modelo 123 and 193 Reports                          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¶ F-specs                              ¶
      ** ¶ =======                              ¶
      ** +--------------------------------------+

      ** Midas OF Suggested Transfers Audit Report
     FRE000007P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN

      ** Midas OF Suggested Transfers - Audit
     FRE000007AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
     F                                     USROPN


      ** +--------------------------------------+
      ** ¶ D-specs: Arrays and Data Structures  ¶
      ** ¶ =======  ==========================  ¶
      ** +--------------------------------------+

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC@      E                     EXTFLD(QQDFAC)

      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)

      ** External DS for Additional Customer Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)

      ** File DS
      ** External data structure for Modelo 123 Audit File
     D REM123        E DS                  EXTNAME(RE123ATD)

      ** Midas Interest and WHT extract Intermediary File
     D INTERFILE     E DS                  EXTNAME(RE123ITD)

     **   Midas OF Modelo 123 Extract File
     D M123E         E DS                  EXTNAME(RE123ETD)

      ** Output DS
     D RPARMX          DS           100
     D  PBranch                1      3A
     D  PMonth            				 4      5A
     D  PYear 			            	 6	     9A
     D  PCompflag             10     10A
     D  PTotalInc             11     27A
     D  PFiller               28    100A

     D WRKFILE         DS
     D  WKCNUM                 1      6A
     D  WKCCY                  7      9A
     D  WKVALD                10     14S 0
     D  WKTOTI                15     31S 0
     D  WKTWTH                32     48S 0

      ** File Information Data Structure for RE000007P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for RE000007AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** Data Structures for amount display

     D                 DS
     D   PGINTA                1     17  0
     D   PGINT0                1     17  0
     D   PGINT1                1     17  0
     D   PGINT2                1     17  0
     D   PGINT3                1     17  0
     D   PGINTB                1     17  0

     D                 DS
     D   PTWHDA                1     17  0
     D   PTWHD0                1     17  0
     D   PTWHD1                1     17  0
     D   PTWHD2                1     17  0
     D   PTWHD3                1     17  0
     D   PTWHDB                1     17  0

     D                 DS
     D   PIP99A                1     17  0
     D   PIP990                1     17  0
     D   PIP991                1     17  0
     D   PIP992                1     17  0
     D   PIP993                1     17  0
     D   PIP99B                1     17  0


     D                 DS
     D   PNP99A                1     17  0
     D   PNP990                1     17  0
     D   PNP991                1     17  0
     D   PNP992                1     17  0
     D   PNP993                1     17  0
     D   PNP99B                1     17  0

     D                 DS
     D   PTWHTA                1     17  0
     D   PTWHT0                1     17  0
     D   PTWHT1                1     17  0
     D   PTWHT2                1     17  0
     D   PTWHT3                1     17  0
     D   PTWHTB                1     17  0

     D                 DS
     D   PTWPTA                1     17  0
     D   PTWPT0                1     17  0
     D   PTWPT1                1     17  0
     D   PTWPT2                1     17  0
     D   PTWPT3                1     17  0
     D   PTWPTB                1     17  0

     D                 DS
     D   PTINCA                1     17  0
     D   PTINC0                1     17  0
     D   PTINC1                1     17  0
     D   PTINC2                1     17  0
     D   PTINC3                1     17  0
     D   PTINCB                1     17  0

     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¶ D-specs: Declared variables          ¶
      ** ¶ =======  ==================          ¶
      ** +--------------------------------------+
     D WRUN            S              1A

      ** Entry Parameters
     D PRYEAR          S              4A
     D PRTAXP          S             13A
     D PRBRCA          S              3A
     D PRCTEL          S              9A

      ** Parameters for access object programs
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PCCY            S              3A

      ** System Values details
     D PSysVal1        C                   CONST('LocalAuthTaxBranch')
     D PSysVal2        C                   CONST('PostValBasisRptGen')

      ** Convert lower case and accented char to upper case
     D UC              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ+
     D                                      —«AEIOUAEIOUAOU'
     D LW              C                   'abcdefghijklmnopqrstuvwxyz+
     D                                      ÒÁ·ÈÌÛ˙¡…Õ”⁄™∫‹'

      ** Convert special char to space
     D ALLOW           C                   ' ABCDEFGHIJKLMNOPQRSTUVWXYZ+
     D                                      —«0123456789'

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

      ** Parameters for GL0765
     D @RETURN         S              7a
     D @FrmCcy         S              3A
     D @ToCcy          S              3A
     D @PDATE          S              5  0
     D @AMT            S             19  0

      ** Work fields
     D LBRCA           S              3A
     D LPOST           S              1A

     D LTAX            S              9A
     D LNAME1          S             35A
     D CHARFLD         S             40A

     D CustNum         S              6A
     D TotalIncome     S             17S 0
     D TotalTax        S             17S 0
     D W2TINC          S             17S 0
     D TotalCount      S              9S 0
     D ATotalInc       S             17S 0

     D RSEQ            S              5A
     D RLEV            S              1A
     D RRENT           S              3A
     D XCompFlag       S              1A
     D WCCY            S              3A

      ** Parameters for ZSFILE
     D PLevel          S              1
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¶                                                            ¶
      ** ¶ *InzSR is executed at program activation.                  ¶
      ** ¶                                                            ¶
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   EXSR      SRDefault
     C                   EXSR      SRRetail
     C                   EXSR      SRDealing
     C                   EXSR      SRExtract
     C                   EXSR      SRAudit
     C                   EXSR      SRReport
     C                   EXSR      SREnd

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRetail - Process Retail Routine                            *
      *                                                               *
      *****************************************************************
     C     SRRetail      BEGSR

     C                   EXSR      SRClearVar

     C                   IF        LPOST = 'V'

     C                   IF        PBranch = 'ALL'

     C/exec SQL
     C+ open RELISTVA
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from RELISTVA into: WRKFILE
     C/end-exec

     C                   ELSE

     C/exec SQL
     C+ open RELISTV
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from RELISTV into: WRKFILE
     C/end-exec

     C                   ENDIF

     C                   ELSEIF    LPOST = 'P'

     C                   IF        PBranch = 'ALL'

     C/exec SQL
     C+ open RELISTPA
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from RELISTPA into: WRKFILE
     C/end-exec

     C                   ELSE

     C/exec SQL
     C+ open RELISTP
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from RELISTP into: WRKFILE
     C/end-exec

     C                   ENDIF

     C                   ENDIF

      ** Handle SQL Error

     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 7
     C                   EXSR      SRSQLErr
     C                   ENDIF

     C                   EVAL      CustNum = WKCNUM

     C                   DOW       SQLCode <> 100

     C                   IF        CustNum <> WKCNUM
     C                             and CustNum <> *Blanks

     C/exec sql
     C+ insert into RE123ITD
     C+  (M2CNUM, M2TOTI, M2TWTH)
     C+ values
     C+  (:CustNum, :TotalIncome, :TotalTax)
     C/end-exec

     C                   EVAL      CustNum = WKCNUM
     C                   Z-ADD     *ZEROS        TotalIncome
     C                   Z-ADD     *ZEROS        TotalTax

     C                   ENDIF

      ** Total Gross Income
     C                   Z-ADD     WKTOTI        @AMT
     C                   EXSR      SRGL0765
     C                   EVAL      TotalIncome = TotalIncome + @AMT

      ** Total Tax Withheld
     C                   Z-ADD     WKTWTH        @AMT
     C                   EXSR      SRGL0765
     C                   EVAL      TotalTax = TotalTax + @AMT

     C                   IF        LPOST = 'V'

     C                   IF        PBranch = 'ALL'
     C/exec sql
     C+ fetch next
     C+ from RELISTVA into: WRKFILE
     C/end-exec

     C                   ELSE

     C/exec sql
     C+ fetch next
     C+ from RELISTV into: WRKFILE
     C/end-exec

     C                   ENDIF

     C                   ELSEIF    LPOST = 'P'

     C                   IF        PBranch = 'ALL'

     C/exec sql
     C+ fetch next
     C+ from RELISTPA into: WRKFILE
     C/end-exec

     C                   ELSE

     C/exec sql
     C+ fetch next
     C+ from RELISTP into: WRKFILE
     C/end-exec

     C                   ENDIF

     C                   ENDIF

     C                   ENDDO

     C                   IF        CustNum  =  WKCNUM
     C                             and CustNum <> *Blanks
     C/exec sql
     C+ insert into RE123ITD
     C+  (M2CNUM, M2TOTI, M2TWTH)
     C+ values
     C+  (:CustNum, :TotalIncome, :TotalTax)
     C/end-exec
     C                   ENDIF

     C                   IF        LPOST = 'V'

     C                   IF        PBranch = 'ALL'

     C/exec sql
     C+ close RELISTVA
     C/end-exec

     C                   ELSE
     C/exec sql
     C+ close RELISTV
     C/end-exec

     C                   ENDIF

     C                   ELSEIF    LPOST = 'P'

     C                   IF        PBranch = 'ALL'

     C/exec sql
     C+ close RELISTPA
     C/end-exec

     C                   ELSE

     C/exec sql
     C+ close RELISTP
     C/end-exec

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDealing - Process Dealing Routine                          *
      *                                                               *
      *****************************************************************
     C     SRDealing     BEGSR

     C                   EXSR      SRClearVar

     C                   IF        LPOST = 'V'

     C                   IF        PBranch = 'ALL'

     C/exec SQL
     C+ open DLLISTVA
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from DLLISTVA into: WRKFILE
     C/end-exec

     C                   ELSE

     C/exec SQL
     C+ open DLLISTV
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from DLLISTV into: WRKFILE
     C/end-exec

     C                   ENDIF

     C                   ELSEIF    LPOST = 'P'

     C                   IF        PBranch = 'ALL'

     C/exec SQL
     C+ open DLLISTPA
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from DLLISTPA into: WRKFILE
     C/end-exec

     C                   ELSE

     C/exec SQL
     C+ open DLLISTP
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from DLLISTP into: WRKFILE
     C/end-exec

     C                   ENDIF

     C                   ENDIF

      ** Handle SQL Error

     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 8
     C                   EXSR      SRSQLErr
     C                   ENDIF

     C                   EVAL      CustNum = WKCNUM

     C                   DOW       SQLCode <> 100

     C                   IF        CustNum <> WKCNUM
     C                             and CustNum <> *Blanks

     C/exec sql
     C+ insert into RE123ITD
     C+  (M2CNUM, M2TOTI, M2TWTH)
     C+ values
     C+  (:CustNum, :TotalIncome, :TotalTax)
     C/end-exec

     C                   EVAL      CustNum = WKCNUM
     C                   Z-ADD     *ZEROS        TotalIncome
     C                   Z-ADD     *ZEROS        TotalTax

     C                   ENDIF

      ** Total Gross Income
     C                   Z-ADD     WKTOTI        @AMT
     C                   EXSR      SRGL0765
     C                   EVAL      TotalIncome = TotalIncome + @AMT

      ** Total Tax Withheld
     C                   Z-ADD     WKTWTH        @AMT
     C                   EXSR      SRGL0765
     C                   EVAL      TotalTax = TotalTax + @AMT

     C                   IF        LPOST = 'V'

     C                   IF        PBranch = 'ALL'

     C/exec sql
     C+ fetch next
     C+ from DLLISTVA into: WRKFILE
     C/end-exec

     C                   ELSE

     C/exec sql
     C+ fetch next
     C+ from DLLISTV into: WRKFILE
     C/end-exec

     C                   ENDIF

     C                   ELSEIF    LPOST = 'P'

     C                   IF        PBranch = 'ALL'

     C/exec sql
     C+ fetch next
     C+ from DLLISTPA into: WRKFILE
     C/end-exec

     C                   ELSE

     C/exec sql
     C+ fetch next
     C+ from DLLISTP into: WRKFILE
     C/end-exec

     C                   ENDIF

     C                   ENDIF

     C                   ENDDO

     C                   IF        CustNum  =  WKCNUM
     C                             and CustNum <> *Blanks
     C/exec sql
     C+ insert into RE123ITD
     C+  (M2CNUM, M2TOTI, M2TWTH)
     C+ values
     C+  (:CustNum, :TotalIncome, :TotalTax)
     C/end-exec
     C                   ENDIF

     C                   IF        LPOST = 'V'

     C                   IF        PBranch = 'ALL'

     C/exec sql
     C+ close DLLISTVA
     C/end-exec

     C                   ELSE

     C/exec sql
     C+ close DLLISTV
     C/end-exec

     C                   ENDIF

     C                   ELSEIF    LPOST = 'P'

     C                   IF        PBranch = 'ALL'

     C/exec sql
     C+ close DLLISTPA
     C/end-exec

     C                   ELSE

     C/exec sql
     C+ close DLLISTP
     C/end-exec

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtract - Extract RE123ETD Total Routine                   *
      *                                                               *
      *****************************************************************
     C     SRExtract     BEGSR

     C                   Z-ADD     *ZEROS        TotalCount
     C                   Z-ADD     *ZEROS        TotalIncome
     C                   Z-ADD     *ZEROS        TotalTax

      ** Update Total Income and Total Tax

     C/exec sql
     C+ select count(distinct(M2CNUM)),
     C+        sum(M2TOTI),
     C+        sum(M2TWTH)
     C+  into  :TotalCount,
     C+        :TotalIncome,
     C+        :TotalTax
     C+   from RE123ITD
     C/end-exec

     C                   IF        SQLCode <> 100

     C                   EVAL      W2TINC = TotalTax - MAPTRN

      ** If Negative income, store and return to
      ** calling program

     C                   IF        W2TINC < 0
     C                   EVAL      ATotalInc = %ABS(W2TINC)
     C                   MOVE      ATotalInc     PTotalInc
     C                   EVAL      %SUBST(PTotalInc:1:1) = 'N'
     C                   ENDIF

     C/exec sql
     C+ update RE123ETD
     C+   Set M2NRCL =  :TotalCount,
     C+       M2GINT =  :TotalIncome,
     C+       M2TWHD =  :TotalTax,
     C+       M2TWHT =  :TotalTax,
     C+       M2TINC =  :W2TINC
     C+   Where M2PERD = :PMonth and M2YEAR = :PYear
     C/END-EXEC

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Update RE123ATD Audit File                         *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR

     C/exec sql
     C+ update RE123ATD
     C+   Set MTOINT =  :TotalTax
     C+ where
     C+ MMNREQ = :PMonth and MYRREQ = :PYear and MMBRCH = :PBranch
     C/end-exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReport - Generate Modelo 123 Report                        *
      *                                                               *
      *****************************************************************
     C     SRReport      BEGSR

      ** Retrieve records in the Extract File

     C/exec sql
     C+ select * into :M123E from RE123ETD
     C+ where M2PERD = :PMonth and M2YEAR = :PYear
     C/end-exec

     C/exec sql
     C+ Select * into :REM123 from RE123ATD where
     C+ MMNREQ = :PMonth and MYRREQ = :PYear and MMBRCH = :PBranch
     C/end-exec

     C                   IF        NOT %OPEN(RE000007P1)

     C                   OPEN      RE000007P1

      ** Ensure Detail Spool File recorded by RCF.
     C                   EVAL      ZSnum = SFNUM1
     C                   CALL      'ZSFILE'
     C                   PARM                    RSeq
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

      ** Print Report Header 1

     C                   EXSR      SRPrintHdr1

      ** Print Report Header 2

     C                   EXSR      SRPrintHdr2

      ** Print Details

     C                   EXSR      SRDetails

      ** Print Footer

     C                   EXSR      SRPrintFtr

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr1 - Print Header 1 Routine                         *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr1   BEGSR

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

      ** Entity NIF
     C                   EVAL      PRENIF = M2ENIF

      ** Entity Surname
     C                   EVAL      PRESUR = M2ESUR

      ** Year
     C                   EVAL      PRYEAR = M2YEAR

      ** Period (Month)
     C                   EVAL      PRPERD = M2PERD

     C                   WRITE     HEADER2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDetails  - Print Details Routine                           *
      *                                                               *
      *****************************************************************
     C     SrDetails     BEGSR

     C                   CLEAR                   DETAIL

     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN11 = *OFF
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      *IN13 = *OFF
     C                   EVAL      *IN14 = *OFF
     C                   EVAL      *IN15 = *OFF
     C                   EVAL      *IN16 = *OFF
     C                   EVAL      *IN17 = *OFF
     C                   EVAL      *IN18 = *OFF
     C                   EVAL      *IN19 = *OFF
     C                   EVAL      *IN20 = *OFF

      ** Number of Reported Clients
     C                   EVAL      PRNRCL = M2NRCL

      ** Gross Interest Income
     C                   EVAL      PGINTA = M2GINT
     C                   IF        PGINTA = 0
     C                   EVAL      *IN14 = *ON
     C                   ENDIF

      ** Tax Withheld
     C                   EVAL      PTWHDA = M2TWHD
     C                   IF        PTWHDA = 0
     C                   EVAL      *IN15 = *ON
     C                   ENDIF

      ** Interest Prior to 1999
     C                   EVAL      PIP99A = M2IP99
     C                   IF        PIP99A = 0
     C                   EVAL      *IN16 = *ON
     C                   ENDIF

      ** Normalization Prior to 1999
     C                   EVAL      PNP99A = M2NP99
     C                   IF        PNP99A = 0
     C                   EVAL      *IN17 = *ON
     C                   ENDIF

      ** Total Withholding Tax
     C                   EVAL      PTWHTA = M2TWHT
     C                   IF        PTWHTA = 0
     C                   EVAL      *IN18 = *ON
     C                   ENDIF

      ** Total Tax Withheld from Previous Tax Returns
     C                   EVAL      PTWPTA = M2TWPT
     C                   IF        PTWPTA = 0
     C                   EVAL      *IN19 = *ON
     C                   ENDIF

      ** Total Income
     C                   EVAL      PTINCA = M2TINC
     C**********         EVAL      PTINCA = M2TWPT                                          MD034332
     C                   IF        PTINCA = 0
     C                   EVAL      *IN20 = *ON
     C                   ENDIF

     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      *IN10 = *ON
     C                   WHEN      A6NBDP = 1
     C                   EVAL      *IN11 = *ON
     C                   WHEN      A6NBDP = 2
     C                   EVAL      *IN12 = *ON
     C                   WHEN      A6NBDP = 3
     C                   EVAL      *IN13 = *ON
     C                   ENDSL

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

     C                   CLEAR                   FOOTER

     ** Contact Person
     C                   EVAL      PRPRSN = MCPRSN

     ** Contact Telephone
     C                   EVAL      PRPHON = MCPHON

     C                   WRITE     FOOTER

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault - Process Default Subroutine                       *
      *                                                               *
      *****************************************************************
     C     SRDefault     BEGSR

     C                   EXSR      SRAcctDetails

      ** Move default values to RE123ETD

     C/exec sql
     C+ insert into RE123ETD
     C+ (
     C+   M2SMID, M2MODL, M2PAGE, M2EMID, M2APGI, M2TYPD, M2EORM,
     C+   M2ENIF, M2ESUR, M2ENAM, M2YEAR, M2PERD, M2IP99, M2NP99,
     C+   M2IBAN, M2AEAT, M2ADME, M2RTRN, M2PTID, M2TWPT, M2NRCL,
     C+   M2GINT, M2TWHD, M2TWHT, M2TINC
     C+ )
     C+ values
     C+ (
     C+   '<T', '123', '01', '000>', ' ', 'I', '</T12301000>',
     C+   :LTAX, :LNAME1, ' ', :PYear, :PMonth, 0, 0,
     C+   ' ', ' ', ' ', :XCompFlag, :MPTRID, :MAPTRN,0,
     C+   0, 0, 0, 0
     C+ )
     C/end-exec

     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 10
     C                   EXSR      SRSQLErr
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcctDetails -  Get Account Details Routine                 *
      *                                                               *
      *****************************************************************
     C     SRAcctDetails BEGSR

      ** Retrieve Internal Customer
     C/exec sql
     C+ select * into :SDBRCH from SDBRCHPD
     C+ where A8BRCD = :LBRCA
     C/end-exec

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EXSR      SRSQLErr
     C                   ENDIF

      ** Retrieve Tax Identification
     C/exec sql
     C+ select * into :SDACUS from SDACUSPD
     C+ where E5CUST = :A8BICN
     C/end-exec

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EXSR      SRSQLErr
     C                   ELSE
     C                   EVAL      LTAX = E5TINO
     C                   ENDIF

      ** Retrieve Customer Name and Address Line 1
     C/exec sql
     C+ select * into :SDCUST from SDCUSTPD
     C+ where BBCUST = :A8BICN
     C/end-exec

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EXSR      SRSQLErr
     C                   ELSE

     C                   EVAL      CHARFLD = BBCNA1
     C                   EXSR      SRConChar
     C                   EVAL      LNAME1 =  CHARFLD
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
     C                   PARM                    RSEQ
     C                   PARM                    RLEV
     C                   PARM                    RRENT
     C                   PARM                    RPARMX


      ** Set off program indicators

     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA

     C/exec sql
     C+ select * into :SDBANK from SDBANKPD
     C/end-exec

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EXSR      SRSQLErr
     C                   ENDIF

     C/exec sql
     C+ select * into :SDCURR from SDCURRPD
     C+ where A6CYCD = :BJLCCY
     C/end-exec

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EXSR      SRSQLErr
     C                   ENDIF

      ** Retrieve the system value
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       @RETURN
     C                   PARM      PSysVal1      SVALK1
     C                   PARM      *BLANKS       SVAL1
     C                   PARM      PSysVal2      SVALK2
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

      ** If the system values are not found then issue a database error

     C     @RETURN       IFNE      *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   LBRCA
     C                   CLEAR                   LPOST

     C                   EVAL      LPOST    =  SVAL2

     C                   IF        PCompFlag = 'Y'
     C                   EVAL      XCompFlag = 'X'
     C                   ELSE
     C                   EVAL      XCompFlag = *Blanks
     C                   ENDIF

      ** Retrieve records in the Audit File

     C/exec sql
     C+ Select * into :REM123 from RE123ATD where
     C+ MMNREQ = :PMonth and MYRREQ = :PYear and MMBRCH = :PBranch
     C/end-exec

      ** Prepare Retail and Dealing File

     C                   IF        PBranch = 'ALL'
     C                   EVAL      LBRCA = SVAL1
     C                   EXSR      SRPrepareAll
     C                   ELSE
     C                   EVAL      LBRCA = PBranch
     C                   EXSR      SRPrepareBrc
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConChar - Convert Character Routine                        *
      *                                                               *
      *****************************************************************
     C     SRConChar     BEGSR

      ** Change lower case to upper case and accented character

     C                   EVAL      CHARFLD = %XLATE(LW:UC:CHARFLD)

      ** Replace special character to blank

     C                   DOW       %CHECK(ALLOW:%TRIMR(CHARFLD)) > 0
     C                   EVAL      CHARFLD = %REPLACE(' ': CHARFLD:
     C                                 %CHECK(ALLOW: %TRIMR(CHARFLD)): 1)
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrepareAll - Prepare File depending if records should      *
      *                 consider Posting Date or Value Date for       *
      *                 all branches residing in Spain                *
      *                                                               *
      *****************************************************************
     C     SRPrepareAll  BEGSR

     C                   SELECT

      ** When Value Date is the defined system value

     C                   WHEN      LPOST = 'V'

     C/exec sql
     C+ declare RELISTVA cursor for
     C+ select RECNUM, RECCY, REVALD, REINTA, RETAXA
     C+     from REIWHTTD where
     C+       (REVALD >= :MSDATE and REVALD <= :MEDATE) and
     C+          REBRCA in (select A8BRCD
     C+            from SDBRCHPD where A8BICN in (select BBCUST
     C+              from SDCUSTPD where BBCOLC in (select A4CNCD
     C+                from SDCTRYPD where A4ISOC = 'ES')))
     C+ order by RECNUM, RECCY, REVALD
     C/end-exec

     C/exec sql
     C+ declare DLLISTVA cursor for
     C+ select DLCNUM, DLCCY, DLVALD, DLINTA, DLTAXA
     C+     from DLIWHTTD where
     C+       (DLVALD >= :MSDATE and DLVALD <= :MEDATE) and
     C+          DLBRCA in (select A8BRCD
     C+            from SDBRCHPD where A8BICN in (select BBCUST
     C+              from SDCUSTPD where BBCOLC in (select A4CNCD
     C+                from SDCTRYPD where A4ISOC = 'ES')))
     C+ order by DLCNUM, DLCCY, DLVALD
     C/end-exec

      ** When Posting Date is the defined systen value

     C                   WHEN      LPOST = 'P'

     C/exec sql
     C+ declare RELISTPA cursor for
     C+ select RECNUM, RECCY, REVALD, REINTA, RETAXA
     C+     from REIWHTTD where
     C+       (REPSTD >= :MSDATE and REPSTD <= :MEDATE) and
     C+          REBRCA IN (select A8BRCD
     C+            FROM SDBRCHPD where A8BICN in (select BBCUST
     C+              from SDCUSTPD where BBCOLC in (select A4CNCD
     C+                from SDCTRYPD where A4ISOC = 'ES')))
     C+ order by RECNUM, RECCY, REVALD
     C/end-exec

     C/exec sql
     C+ Declare DLLISTPA cursor for
     C+ select DLCNUM, DLCCY, DLVALD, DLINTA, DLTAXA
     C+     from DLIWHTTD where
     C+       (DLPSTD >= :MSDATE and DLPSTD <= :MEDATE) and
     C+          DLBRCA IN (select A8BRCD
     C+            from SDBRCHPD where A8BICN in (SELECT BBCUST
     C+              from SDCUSTPD where BBCOLC in (select A4CNCD
     C+                from SDCTRYPD where A4ISOC = 'ES')))
     C+ order by DLCNUM, DLCCY, DLPSTD
     C/end-exec

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrepareBrc - Prepare File depending if records should      *
      *                 consider Posting Date or Value Date for a     *
      *                 specific branch residing in Spain             *
      *                                                               *
      *****************************************************************
     C     SRPrepareBrc  BEGSR

     C                   SELECT
     C                   WHEN      LPOST = 'V'

     C/exec SQL
     C+ Declare RELISTV cursor for
     C+ SELECT RECNUM, RECCY, REVALD, REINTA, RETAXA
     C+     FROM REIWHTTD WHERE
     C+       (REVALD >= :MSDATE AND REVALD <= :MEDATE) AND
     C+          REBRCA = :PBranch
     C+ ORDER BY RECNUM, RECCY, REVALD
     C/end-exec

     C/exec SQL
     C+ Declare DLLISTV cursor for
     C+ SELECT DLCNUM, DLCCY, DLVALD, DLINTA, DLTAXA
     C+     FROM DLIWHTTD WHERE
     C+       (DLVALD >= :MSDATE AND DLVALD <= :MEDATE) AND
     C+          DLBRCA = :PBranch
     C+ ORDER BY DLCNUM, DLCCY, DLVALD
     C/end-exec

     C                   WHEN      LPOST = 'P'

     C/exec SQL
     C+ Declare RELISTP cursor for
     C+ SELECT RECNUM, RECCY, REVALD, REINTA, RETAXA
     C+     FROM REIWHTTD WHERE
     C+       (REPSTD >= :MSDATE AND REPSTD <= :MEDATE) AND
     C+          REBRCA = :PBranch
     C+ ORDER BY RECNUM, RECCY, REPSTD
     C/end-exec

     C/exec SQL
     C+ Declare DLLISTP cursor for
     C+ SELECT DLCNUM, DLCCY, DLVALD, DLINTA, DLTAXA
     C+     FROM DLIWHTTD WHERE
     C+       (DLPSTD >= :MSDATE AND DLPSTD <= :MEDATE) AND
     C+          DLBRCA = :PBranch
     C+ order by DLCNUM, DLCCY, DLPSTD
     C/end-exec

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGL0765 - Call GL0765 Routine                               *
      *                                                               *
      *****************************************************************
     C     SRGL0765      BEGSR

     C                   IF        WKCCY <>  BJLCCY

     C                   Z-ADD     WKVALD        @PDATE

     C                   CALL      'GL0765'
     C                   PARM      *BLANKS       @RETURN
     C                   PARM      WKCCY         @FrmCcy
     C                   PARM      BJLCCY        @ToCcy
     C                   PARM                    @PDATE
     C                   PARM                    @AMT

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSQLErr - SQL Error Detail Routine                          *
      *                                                               *
      *****************************************************************
     C     SRSQLErr      BEGSR

     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClearVar - Clear Working Variables                         *
      *                                                               *
      *****************************************************************
     C     SRClearVar    BEGSR

     C                   Z-ADD     *ZEROS        TotalIncome
     C                   Z-ADD     *ZEROS        TotalTax
     C                   EVAL      CustNum = *Blanks

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - End Program Routine                                  *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR

     C                   EVAL      *INLR = *ON
     C                   RETURN

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

     C                   IF        NOT %OPEN(RE000007AU)
     C                   OPEN      RE000007AU
     C                   ENDIF
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR

     C                   RETURN

     C                   ENDSR
