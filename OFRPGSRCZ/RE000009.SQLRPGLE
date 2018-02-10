     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  RE000009 - Midas OF Generation of Modelo 193                 *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE104  *CREATE    Date 04Mar15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE104 - Modelo 123 and 193 Reports                          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** | F-specs                              |
      ** | =======                              |
      ** +--------------------------------------+

      ** Midas OF Modelo 193 Report Production - Audit
     FRE000009P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN

      ** Midas OF Modelo 193 Report Production - Audit
     FRE000009AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
     F                                     USROPN


      ** +--------------------------------------+
      ** | D-specs: Arrays and Data Structures  |
      ** | =======  ==========================  |
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
     **   Midas RE Interest and WHT extract
     D REITAX        E DS                  EXTNAME(REIWHTTD)

     **   Midas DL Interest and WHT extract
     D DLITAX        E DS                  EXTNAME(DLIWHTTD)

     **   Midas Interest and WHT extract Intermediary File
     D INTERFILE     E DS                  EXTNAME(RE193ITD)

     **   Midas Extract Type 1 File
     D TYPE1FILE     E DS                  EXTNAME(RE1931TD)

     **   Midas Extract Type 1 File
     D TYPE2FILE     E DS                  EXTNAME(RE1932TD)

     **   Midas Modelo 193 Audit File
     D AUDITFILE     E DS                  EXTNAME(RE193ATD)

      ** Output DS
     D/COPY ZACPYSRC,STD_D_SPEC
     D WRKFILE         DS
     D  MXCNUM                 1      6A
     D  MXCCY                  7      9A
     D  MXVALD                10     14S 0
     D  MXTOTI                15     31S 0
     D  MXTWTH                32     48S 0

      ** File Information Data Structure for RE000009P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for RE000009AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** Data Structures for amount display

      ** Gross Income Type 1
     D                 DS
     D   PTGROSSA              1     15  0
     D   PTGROSS3              1     15  0
     D   PTGROSS2              1     15  0
     D   PTGROSS1              1     15  0
     D   PTGROSS0              1     15  0


      ** Withholding Tax Type 1
     D                 DS
     D   PTWTAXA               1     15  0
     D   PTWTAX3               1     15  0
     D   PTWTAX2               1     15  0
     D   PTWTAX1               1     15  0
     D   PTWTAX0               1     15  0


      ** Total Withholding Tax Type 1
     D                 DS
     D   PTHTAXA               1     15  0
     D   PTHTAX3               1     15  0
     D   PTHTAX2               1     15  0
     D   PTHTAX1               1     15  0
     D   PTHTAX0               1     15  0


      ** Gross Income Type 2
     D                 DS
     D   PTCGROSSA             1     13  0
     D   PTCGROSS31            1     13  0
     D   PTCGROSS21            1     13  0
     D   PTCGROSS11            1     13  0
     D   PTCGROSS01            1     13  0

     D                 DS
     D   PTCGROSSB             1     13  0
     D   PTCGROSS32            1     13  0
     D   PTCGROSS22            1     13  0
     D   PTCGROSS12            1     13  0
     D   PTCGROSS02            1     13  0

     D                 DS
     D   PTCGROSSC             1     13  0
     D   PTCGROSS33            1     13  0
     D   PTCGROSS23            1     13  0
     D   PTCGROSS13            1     13  0
     D   PTCGROSS03            1     13  0

     D                 DS
     D   PTCGROSSD             1     13  0
     D   PTCGROSS34            1     13  0
     D   PTCGROSS24            1     13  0
     D   PTCGROSS14            1     13  0
     D   PTCGROSS04            1     13  0

     D                 DS
     D   PTCGROSSE             1     13  0
     D   PTCGROSS35            1     13  0
     D   PTCGROSS25            1     13  0
     D   PTCGROSS15            1     13  0
     D   PTCGROSS05            1     13  0


      ** Gross Income Type 2
     D                 DS
     D   PTCTAXA               1     13  0
     D   PTCTAX31              1     13  0
     D   PTCTAX21              1     13  0
     D   PTCTAX11              1     13  0
     D   PTCTAX01              1     13  0

     D                 DS
     D   PTCTAXB               1     13  0
     D   PTCTAX32              1     13  0
     D   PTCTAX22              1     13  0
     D   PTCTAX12              1     13  0
     D   PTCTAX02              1     13  0

     D                 DS
     D   PTCTAXC               1     13  0
     D   PTCTAX33              1     13  0
     D   PTCTAX23              1     13  0
     D   PTCTAX13              1     13  0
     D   PTCTAX03              1     13  0

     D                 DS
     D   PTCTAXD               1     13  0
     D   PTCTAX34              1     13  0
     D   PTCTAX24              1     13  0
     D   PTCTAX14              1     13  0
     D   PTCTAX04              1     13  0

     D                 DS
     D   PTCTAXE               1     13  0
     D   PTCTAX35              1     13  0
     D   PTCTAX25              1     13  0
     D   PTCTAX15              1     13  0
     D   PTCTAX05              1     13  0


      ** Withholding Tax Type 2
     D                 DS
     D   PTDTAXA               1     13  0
     D   PTDTAX31              1     13  0
     D   PTDTAX21              1     13  0
     D   PTDTAX11              1     13  0
     D   PTDTAX01              1     13  0

     D                 DS
     D   PTDTAXB               1     13  0
     D   PTDTAX32              1     13  0
     D   PTDTAX22              1     13  0
     D   PTDTAX12              1     13  0
     D   PTDTAX02              1     13  0

     D                 DS
     D   PTDTAXC               1     13  0
     D   PTDTAX33              1     13  0
     D   PTDTAX23              1     13  0
     D   PTDTAX13              1     13  0
     D   PTDTAX03              1     13  0

     D                 DS
     D   PTDTAXD               1     13  0
     D   PTDTAX34              1     13  0
     D   PTDTAX24              1     13  0
     D   PTDTAX14              1     13  0
     D   PTDTAX04              1     13  0

     D                 DS
     D   PTDTAXE               1     13  0
     D   PTDTAX35              1     13  0
     D   PTDTAX25              1     13  0
     D   PTDTAX15              1     13  0
     D   PTDTAX05              1     13  0


     D RPARMX          DS           100
     D  PRBRCA                 1      3A
     D  PRYEAR                 4      7A
     D  PRFLAG                 8      8A
     D  PFiller                9    100A

      ** +--------------------------------------+
      ** | D-specs: Declared variables          |
      ** | =======  ==================          |
      ** +--------------------------------------+

     D WRUN            S              1A

      ** Parameters for ZSFILE
     D PLevel          S              1
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

      ** Parameters for access object programs
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PCCY            S              3A

      ** System Values details
     D PSysVal1        C                   CONST('LocalAuthTaxBranch')
     D PSysVal2        C                   CONST('PostValBasisRptGen')
     D PSysVal3        C                   CONST('ModeloPercNature')

      ** Convert lower case and accented char to upper case
     D UC              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ+
     D                                      ÑÇAEIOUAEIOUAOU'
     D LW              C                   'abcdefghijklmnopqrstuvwxyz+
     D                                      ñçáéíóúÁÉÍÓÚªºÜ'

      ** Convert special char to space
     D ALLOW           C                   ' ABCDEFGHIJKLMNOPQRSTUVWXYZ+
     D                                      ÑÇ0123456789'

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

      ** Entry Parameter
     D RSEQ            S              5A
     D RLEV            S              1A
     D RRENT           S              3A

      ** Work fields
     D LBRCA           S              3A
     D LBRCA2          S              3A
     D LPOST           S              1A
     D LPERC           S              2A

     D LTAX            S              9A
     D LZIP            S              2A
     D LRETN           S              1A
     D LTAXR           S              9A
     D LNAME1          S             35A
     D LUSER           S             40A
     D CHARFLD         S             40A

     D PRTAXR          S             13S 0
     D PRTAXP          S             13S 0
     D PRCTEL          S              9S 0
     D PRCPER          S             40A

     D BranchALL       S              1A
     D CustNum         S              6A
     D TotalIncome     S             15S 0
     D TotalTax        S             15S 0
     D TotalCount      S              9S 0
     D TaxRate         S              4S 0
     D CheckWrite      S              1A
     D PSPERC          S              2S 0
     D PRINTCOUNT      S              2S 0

     D POST1           S              5S 0
     D POST2           S              5S 0
     D VALD1           S              5S 0
     D VALD2           S              5S 0

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** |                                                            |
      ** | *InzSR is executed at program activation.                  |
      ** |                                                            |
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   EXSR      SRDefType1
     C                   EXSR      SRDriver1
     C                   EXSR      SRDriver2
     C                   EXSR      SRUpdate1
     C                   EXSR      SRDefType2
     C                   EXSR      SRReport
     C                   EXSR      SREndProgram

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDriver1 - Process Retail File Driver Routine               *
      *                                                               *
      *****************************************************************
     C     SRDriver1     BEGSR

     C                   EXSR      SRClearVar
     C                   EXSR      SRPostValue

      ** Set file pointer to first record and do initial read.

     C                   IF        BranchALL = 'Y'

     C/exec SQL
     C+ Declare LISTA cursor for
     C+ SELECT RECNUM, RECCY, REVALD, REINTA, RETAXA
     C+     FROM REIWHTTD WHERE
     C+       (REPSTD >= :POST1 AND REPSTD <= :POST2) AND
     C+       (REVALD >= :VALD1 AND REVALD <= :VALD2) AND
     C+          REBRCA IN (SELECT A8BRCD
     C+            FROM SDBRCHPD WHERE A8BICN IN (SELECT BBCUST
     C+              FROM SDCUSTPD WHERE BBCOLC IN (SELECT A4CNCD
     C+                FROM SDCTRYPD WHERE A4ISOC = 'ES')))
     C+ ORDER BY RECNUM, RECCY, REVALD
     C/end-exec

     C/exec SQL
     C+ open LISTA
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from LISTA into: WRKFILE
     C/end-exec
     C                   ELSE

     C/exec SQL
     C+ Declare LISTB cursor for
     C+ SELECT RECNUM, RECCY, REVALD, REINTA, RETAXA
     C+    FROM REIWHTTD
     C+       WHERE REBRCA = :PRBRCA AND
     C+         (REPSTD >= :POST1 AND REPSTD <= :POST2) AND
     C+         (REVALD >= :VALD1 AND REVALD <= :VALD2)
     C+ ORDER BY RECNUM, RECCY, REVALD
     C/end-exec

     C/exec SQL
     C+ open LISTB
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from LISTB into: WRKFILE
     C/end-exec
     C                   ENDIF

      ** Handle SQL Error
     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 7
     C                   EXSR      SRSQLErr
     C                   EndIf

      ** Read the Retail Interest and WHT Extract

     C                   EVAL      CustNum  =  MXCNUM

     C                   IF        MXCNUM <> *Blanks

     C                   DOW       SQLCode <> 100

     C                   EVAL      CheckWrite = 'Y'

     C                   IF        CustNum  <>  MXCNUM
     C/EXEC SQL
     C+ INSERT INTO RE193ITD
     C+  (M9CNUM, M9TOTI, M9TWTH)
     C+ VALUES
     C+  (:CustNum, :TotalIncome, :TotalTax)
     C/END-EXEC
     C                   EVAL      CustNum  =  MXCNUM
     C                   Z-ADD     *ZEROS        TotalIncome
     C                   Z-ADD     *ZEROS        TotalTax
     C                   ENDIF

      ** Total Gross Income
     C                   Z-ADD     MXTOTI        @AMT
     C                   EXSR      SRGL0765
     C                   EVAL      TotalIncome = TotalIncome + @AMT

      ** Total Tax Withheld
     C                   Z-ADD     MXTWTH        @AMT
     C                   EXSR      SRGL0765
     C                   EVAL      TotalTax = TotalTax + @AMT


     C                   IF        BranchALL = 'Y'
     C/exec SQL
     C+ fetch next from LISTA
     C+   into :WRKFILE
     C/end-exec
     C                   ELSE
     C/exec SQL
     C+ fetch next from LISTB
     C+   into :WRKFILE
     C/end-exec
     C                   ENDIF


     C                   ENDDO

     C                   ENDIF

     C                   IF        CustNum  =  MXCNUM and
     C                             CheckWrite = 'Y'
     C/EXEC SQL
     C+ INSERT INTO RE193ITD
     C+  (M9CNUM, M9TOTI, M9TWTH)
     C+ VALUES
     C+  (:CustNum, :TotalIncome, :TotalTax)
     C/END-EXEC
     C                   ENDIF

     C                   IF        BranchALL = 'Y'
     C/exec SQL
     C+ close LISTA
     C/end-exec
     C                   ELSE
     C/exec SQL
     C+ close LISTB
     C/end-exec
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDriver2 - Process Dealing File Driver Routine              *
      *                                                               *
      *****************************************************************
     C     SRDriver2     BEGSR

     C                   EXSR      SRClearVar
     C                   EXSR      SRPostValue

      ** Set file pointer to first record and do initial read.

     C                   IF        BranchALL = 'Y'

     C/exec SQL
     C+ Declare LISTC cursor for
     C+ SELECT DLCNUM, DLCCY, DLVALD, DLINTA, DLTAXA
     C+     FROM DLIWHTTD WHERE
     C+       (DLPSTD >= :POST1 AND DLPSTD <= :POST2) AND
     C+       (DLVALD >= :VALD1 AND DLVALD <= :VALD2) AND
     C+          DLBRCA IN (SELECT A8BRCD
     C+            FROM SDBRCHPD WHERE A8BICN IN (SELECT BBCUST
     C+              FROM SDCUSTPD WHERE BBCOLC IN (SELECT A4CNCD
     C+                FROM SDCTRYPD WHERE A4ISOC = 'ES')))
     C+ ORDER BY DLCNUM, DLCCY, DLVALD
     C/end-exec

     C/exec SQL
     C+ open LISTC
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from LISTC into: WRKFILE
     C/end-exec
     C                   ELSE

     C/exec SQL
     C+ declare LISTD cursor for
     C+ SELECT DLCNUM, DLCCY, DLVALD, DLINTA, DLTAXA
     C+    FROM DLIWHTTD
     C+       WHERE DLBRCA = :PRBRCA AND
     C+         (DLPSTD >= :POST1 AND DLPSTD <= :POST2) AND
     C+         (DLVALD >= :VALD1 AND DLVALD <= :VALD2)
     C+ ORDER BY DLCNUM, DLCCY, DLPSTD, DLVALD
     C/end-exec

     C/exec SQL
     C+ open LISTD
     C/end-exec
     C/exec SQL

     C+ fetch next
     C+ from LISTD into: WRKFILE
     C/end-exec

     C                   ENDIF

      ** Handle SQL Error
     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 8
     C                   EXSR      SRSQLErr
     C                   EndIf

      ** Read the Dealing Interest and WHT Extract

     C                   EVAL      CustNum  =  MXCNUM

     C                   IF        MXCNUM <> *Blanks

     C                   DOW       SQLCode <> 100

     C                   EVAL      CheckWrite = 'Y'

     C                   IF        CustNum  <>  MXCNUM

     C/EXEC SQL
     C+ Select * into :INTERFILE from RE193ITD
     C+    Where M9CNUM = :CustNum
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0
     C/EXEC SQL
     C+ INSERT INTO RE193ITD
     C+  (M9CNUM, M9TOTI, M9TWTH)
     C+ VALUES
     C+  (:CustNum, :TotalIncome, :TotalTax)
     C/END-EXEC
     C                   ELSE
     C                   EVAL      TotalIncome = TotalIncome + M9TOTI
     C                   EVAL      TotalTax = TotalTax + M9TWTH
     C/exec SQL
     C+ update RE193ITD
     C+   Set  M9TOTI  =  :TotalIncome,
     C+        M9TWTH  =  :TotalTax
     C+     Where M9CNUM = :CustNum
     C/END-EXEC
     C                   ENDIF

     C                   EVAL      CustNum  =  MXCNUM
     C                   Z-ADD     *ZEROS        TotalIncome
     C                   Z-ADD     *ZEROS        TotalTax
     C                   ENDIF

      ** Total Gross Income
     C                   Z-ADD     MXTOTI        @AMT
     C                   EXSR      SRGL0765
     C                   EVAL      TotalIncome = TotalIncome + @AMT

      ** Total Tax Withheld
     C                   Z-ADD     MXTWTH        @AMT
     C                   EXSR      SRGL0765
     C                   EVAL      TotalTax = TotalTax + @AMT


     C                   IF        BranchALL = 'Y'
     C/exec SQL
     C+ fetch next from LISTC
     C+ into :WRKFILE
     C/end-exec
     C                   ELSE
     C/exec SQL
     C+ fetch next from LISTD
     C+ into :WRKFILE
     C/end-exec
     C                   ENDIF


     C                   ENDDO

     C                   ENDIF

     C                   IF        CustNum  =  MXCNUM AND
     C                             CheckWrite = 'Y'

     C/EXEC SQL
     C+ Select * into :INTERFILE from RE193ITD
     C+    Where M9CNUM = :CustNum
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0
     C/EXEC SQL
     C+ INSERT INTO RE193ITD
     C+  (M9CNUM, M9TOTI, M9TWTH)
     C+ VALUES
     C+  (:CustNum, :TotalIncome, :TotalTax)
     C/END-EXEC
     C                   ELSE
     C                   EVAL      TotalIncome = TotalIncome + M9TOTI
     C                   EVAL      TotalTax = TotalTax + M9TWTH
     C/exec SQL
     C+ update RE193ITD
     C+   Set M9TOTI  =  :TotalIncome,
     C+       M9TWTH  =  :TotalTax
     C+     Where M9CNUM = :CustNum
     C/END-EXEC
     C                   ENDIF

     C                   ENDIF

     C                   IF        BranchALL = 'Y'
     C/exec SQL
     C+ close LISTC
     C/end-exec
     C                   ELSE
     C/exec SQL
     C+ close LISTD
     C/end-exec
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate1 - Update RE1931TD Total Routine                    *
      *                                                               *
      *****************************************************************
     C     SRUpdate1     BEGSR

     C                   Z-ADD     *ZEROS        TotalCount
     C                   Z-ADD     *ZEROS        TotalIncome
     C                   Z-ADD     *ZEROS        TotalTax

      ** Update Total Income and Total Tax

     C/exec SQL
     C+ SELECT COUNT(DISTINCT(M9CNUM)),
     C+        SUM(M9TOTI),
     C+        SUM(M9TWTH)
     C+  INTO  :TotalCount,
     C+        :TotalIncome,
     C+        :TotalTax
     C+   FROM RE193ITD
     C/end-exec


     C                   IF        SQLCode <> 100

     C/EXEC SQL
     C+ update RE1931TD
     C+   Set M9NRCL   =  :TotalCount,
     C+       M9GINT   =  :TotalIncome,
     C+       M9TWHD   =  :TotalTax,
     C+       M9TWHT   =  :TotalTax
     C+   Where M9YEAR = :PRYEAR
     C/END-EXEC

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefType1 - Process Default Type 1 Routine                  *
      *                                                               *
      *****************************************************************
     C     SRDefType1    BEGSR

     C                   EXSR      SRAcctDetails

      ** Initial '1'  write to RE1931TD

     C/EXEC SQL
     C+ INSERT INTO RE1931TD
     C+ (
     C+   M9RECT, M9MODL, M9YEAR, M9ENIF, M9ESUR, M9TTYP,
     C+   M9CTEL, M9CPER, M9TRID, M9STRN, M9RTRN, M9PTID,
     C+   M9NRCL, M9GINT, M9TWHD, M9TWHT, M9FILL, M9CHRG,
     C+   M9ENTN, M9FI2L, M9AEAT
     C+ )
     C+ VALUES
     C+ (
     C+   '1',  '193',  :PRYEAR,  :LTAX ,  :LNAME1,  'T',
     C+   :PRCTEL,  :LUSER,  :PRTAXR,  ' ',  :LRETN,  :PRTAXP,
     C+   0,  0,  0,  0,  ' ',  0,
     C+   ' ',  ' ',  ' '
     C+
     C+ )
     C/END-EXEC

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefType2 - Process Default Type 2 Routine                  *
      *                                                               *
      *****************************************************************
     C     SRDefType2    BEGSR

      ** Read Extract Type 1 File

     C/exec SQL
     C+ SELECT * INTO :TYPE1FILE from RE1931TD
     C/end-exec

      ** Read Intermediary File

     C/exec SQL
     C+ Declare LISTE cursor for
     C+ SELECT * FROM RE193ITD
     C+ ORDER BY M9CNUM
     C/end-exec

     C/exec SQL
     C+ open LISTE
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from LISTE into: INTERFILE
     C/end-exec

      ** Handle SQL Error
     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 10
     C                   EXSR      SRSQLErr
     C                   EndIf

      ** Read the Intermediary File

     C                   DOW       SQLCode <> 100

     C                   EXSR      SRAcctDetails2

     C/EXEC SQL
     C+ INSERT INTO RE1932TD
     C+ (
     C+   M9REC2, M9MOD2, M9YEA2, M9ENI2, M9CNI2, M9LEG2,
     C+   M9CNA2, M9INT2, M9PRV2, M9KEY2, M9SND2, M9PKY2,
     C+   M9PNT2, M9PTP2, M9CTP2, M9CCV2, M9PND2, M9YR22,
     C+   M9PRT2, M9GIN2, M9FLL2, M9RDA2, M9TWH2, M9WTR2,
     C+   M9TTH2, M9FL22, M9CUN2, M9LNS2, M9LNM2, M9CMP2,
     C+   M9GUA2, M9FL32
     C+ )
     C+ VALUES
     C+ (
     C+   '2',  '193',  :M9YEAR,  :M9ENIF,  :LTAX,   ' ',
     C+   :LNAME1,  ' ' ,  :LZIP,   0 ,   ' ',   'C',
     C+   :LPERC,     0 ,   ' ' ,  ' ' ,  ' ' ,   0,
     C+   '1'   ,   :M9TOTI,   ' ' ,   0  ,  :M9TWTH,  :TAXRATE,
     C+   :M9TWTH,  ' ' ,   ' ' ,   0  ,   0  ,   0 ,
     C+    0    ,   ' '
     C+ )
     C/END-EXEC

     C/exec SQL
     C+ fetch next from LISTE
     C+ into :INTERFILE
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LISTE
     C/end-exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcctDetails -  Get Account Details Routine                 *
      *                                                               *
      *****************************************************************
     C     SRAcctDetails BEGSR

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

     C                   EVAL      LRETN = *BLANKS
     C                   IF        PRFLAG = 'Y'
     C                   EVAL      LRETN = 'S'
     C                   ENDIF

     C                   EVAL      CHARFLD = PRCPER
     C                   EXSR      SRConChar
     C                   EVAL      LUSER  =  CHARFLD

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcctDetails2 -  Get Account Details for Type 2 Routine    *
      *                                                               *
      *****************************************************************
     C     SRAcctDetails2BEGSR

      ** Retrieve Tax Identification
     C/exec sql
     C+ select * into :SDACUS from SDACUSPD
     C+ where E5CUST = :M9CNUM
     C/end-exec

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 11
     C                   EXSR      SRSQLErr
     C                   ELSE
     C                   EVAL      LTAX = E5TINO
     C                   CLEAR                   LZIP
     C                   MOVEL     E5ZIPC        LZIP
     C                   ENDIF

      ** Retrieve Customer Name and Address Line 1 for Type 2
     C/exec sql
     C+ select * into :SDCUST from SDCUSTPD
     C+ where BBCUST = :M9CNUM
     C/end-exec

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 12
     C                   EXSR      SRSQLErr
     C                   ELSE

     C                   EVAL      CHARFLD = BBCNA1
     C                   EXSR      SRConChar
     C                   EVAL      LNAME1 =  CHARFLD
     C                   ENDIF

     C                   EVAL(H)   TaxRate = (M9TOTI / M9TWTH) * 100

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
     C                   PARM      *BLANKS       SVAL2
     C                   PARM      PSysVal3      SVALK3
     C                   PARM      *BLANKS       SVAL3
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
     C                   CLEAR                   LBRCA2
     C                   CLEAR                   LPOST
     C                   CLEAR                   LPERC

     C                   EVAL      LPOST    =  SVAL2


      ** Check if Branch = *Blanks or 'ALL'

     C                   EVAL      BranchALL = *BLANKS

     C                   IF        PRBRCA = *BLANKS OR PRBRCA = 'ALL'
     C                   EVAL      BranchALL = 'Y'
     C                   EVAL      LBRCA    =  SVAL1
     C                   EVAL      LBRCA2   =  'ALL'
     C                   ELSE
     C                   EVAL      BranchALL = 'N'
     C                   EVAL      LBRCA    =  PRBRCA
     C                   EVAL      LBRCA2   =  PRBRCA
     C                   ENDIF

     C                   MOVEL     SVAL3         LPERC

     C/EXEC SQL
     C+ Select * into :AUDITFILE from RE193ATD
     C+    Where NYRREQ = :PRYEAR AND NTBRCA = :LBRCA2
     C/END-EXEC
      *

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 13
     C                   EXSR      SRSQLErr
     C                   ENDIF

     C                   EVAL      PRTAXR = NTRTID
     C                   EVAL      PRTAXP = NPTRID
     C                   EVAL      PRCTEL = NCTELP
     C                   EVAL      PRCPER = NCPERS

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
      *  SRPostValue - Determine if Posting Date or Value Date        *
      *                                                               *
      *****************************************************************
     C     SRPostValue   BEGSR

     C                   SELECT
     C                   WHEN      LPOST = 'V'
     C                   Z-ADD     1             POST1
     C                   Z-ADD     99999         POST2
     C                   Z-ADD     NSDATE        VALD1
     C                   Z-ADD     NEDATE        VALD2

     C                   WHEN      LPOST = 'P'
     C                   Z-ADD     NSDATE        POST1
     C                   Z-ADD     NEDATE        POST2
     C                   Z-ADD     1             VALD1
     C                   Z-ADD     99999         VALD2
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

     C                   IF        MXCCY <>  BJLCCY

     C                   Z-ADD     MXVALD        @PDATE

     C                   CALL      'GL0765'
     C                   PARM      *BLANKS       @RETURN
     C                   PARM      MXCCY         @FrmCcy
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

     C                   CLEAR                   WRKFILE
     C                   CLEAR                   CheckWrite
     C                   Z-ADD     *ZEROS        TotalIncome
     C                   Z-ADD     *ZEROS        TotalTax
     C                   EVAL      CustNum = *BLANKS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReport - Generate Modelo 193 Report                        *
      *                                                               *
      *****************************************************************
     C     SRReport      BEGSR
      ** Retrieve records in the Extract File

     C/exec SQL
     C+ SELECT * INTO :TYPE1FILE from RE1931TD
     C/end-exec

     C                   IF        NOT %OPEN(RE000009P1)

     C                   OPEN      RE000009P1

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

      ** Print Details

     C                   EXSR      SRDetails


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr1 - Print Header 1 Routine                         *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr1   BEGSR

     C                   CLEAR                   HEADER1
     C                   EXSR      SRGetDecimal

     C                   EVAL      PTNIF1    =   M9ENIF

     C                   IF        M9CTEL    <>  *ZERO
     C                   EVAL      PTTEL     =   %CHAR(M9CTEL)
     C                   ENDIF

     C                   EVAL      PTYEAR    =   M9YEAR
     C                   EVAL      PTNIF2    =   M9ENIF
     C                   EVAL      PTNAME    =   M9ESUR

     C                   IF        M9TRID    <>  *ZERO
     C                   EVAL      PTTAXR    =   %CHAR(M9TRID)
     C                   ENDIF

     C                   EVAL      PTSUST    =   M9RTRN

     C                   IF        M9PTID    <>  *ZERO
     C                   EVAL      PTTAXP    =   %CHAR(M9PTID)
     C                   ENDIF

     C                   EVAL      PTCOUNT   =   M9NRCL
     C                   EVAL      PTGROSSA  =   M9GINT
     C                   EVAL      PTWTAXA   =   M9TWHD
     C                   EVAL      PTHTAXA   =   M9TWHT

     C                   WRITE     HEADER1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDetails  - Print Details Routine                           *
      *                                                               *
      *****************************************************************
     C     SrDetails     BEGSR

      ** Set file pointer to first record and do initial read.

     C/exec SQL
     C+ Declare LISTF cursor for
     C+ SELECT * FROM RE1932TD
     C+   Order by M9CNI2
     C/end-exec

     C/exec SQL
     C+ open LISTF
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from LISTF into: TYPE2FILE
     C/end-exec

      ** Handle SQL Error
     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 14
     C                   EXSR      SRSQLErr
     C                   EndIf

      ** Read the Type 2 File

     C                   EXSR      SRClearFields
     C                   EVAL      PRINTCOUNT = 1

     C                   DOW       SQLCode <> 100


     C                   EXSR      SRWriteDetail

     C/exec SQL
     C+ fetch next from LISTF
     C+   into :TYPE2FILE
     C/end-exec

     C                   ENDDO

     C                   IF        PRINTCOUNT <> 1
     C
     C                   IF        PTCLAVE1 = *BLANK
     C                   MOVEA     '111'         *IN(60)
     C                   ENDIF

     C                   IF        PTCLAVE2 = *BLANK
     C                   MOVEA     '111'         *IN(63)
     C                   ENDIF

     C                   IF        PTCLAVE3 = *BLANK
     C                   MOVEA     '111'         *IN(66)
     C                   ENDIF

     C                   IF        PTCLAVE4 = *BLANK
     C                   MOVEA     '111'         *IN(69)
     C                   ENDIF

     C                   IF        PTCLAVE5 = *BLANK
     C                   MOVEA     '111'         *IN(72)
     C                   ENDIF

     C                   WRITE     DETAIL
     C                   ENDIF

     C/exec SQL
     C+ close LISTF
     C/end-exec
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteDetail - Write Detail Routine                         *
      *                                                               *
      *****************************************************************
     C     SRWriteDetail BEGSR

     C                   SELECT

      ** Perceptor 1
     C                   WHEN      PRINTCOUNT = 1
     C                   EVAL      PTCLAVE1   =   'C'
     C                   EVAL      PTTIPO1    =   '1'
     C                   EVAL      PTNIFC1    =   M9CNI2
     C                   EVAL      PTCUST1    =   M9CNA2
     C                   EVAL      PTZIP1     =   M9PRV2
     C                   EVAL      PTRATE1    =   M9WTR2

     C                   MOVEL     M9PNT2        PSPERC
     C                   EVAL      PTPERC1    = %EDITC(PSPERC : '4')

     C                   EVAL      PTCGROSSA  =   M9GIN2
     C                   EVAL      PTCTAXA    =   M9GIN2
     C                   EVAL      PTDTAXA    =   M9TWH2
     C                   EVAL      PRINTCOUNT = PRINTCOUNT + 1

      ** Perceptor 2
     C                   WHEN      PRINTCOUNT = 2
     C                   EVAL      PTCLAVE2   =   'C'
     C                   EVAL      PTTIPO2    =   '1'
     C                   EVAL      PTNIFC2    =   M9CNI2
     C                   EVAL      PTCUST2    =   M9CNA2
     C                   EVAL      PTZIP2     =   M9PRV2
     C                   EVAL      PTRATE2    =   M9WTR2

     C                   MOVEL     M9PNT2        PSPERC
     C                   EVAL      PTPERC2    = %EDITC(PSPERC : '4')

     C                   EVAL      PTCGROSSB  =   M9GIN2
     C                   EVAL      PTCTAXB    =   M9GIN2
     C                   EVAL      PTDTAXB    =   M9TWH2
     C                   EVAL      PRINTCOUNT = PRINTCOUNT + 1

      ** Perceptor 3
     C                   WHEN      PRINTCOUNT = 3
     C                   EVAL      PTCLAVE3   =   'C'
     C                   EVAL      PTTIPO3    =   '1'
     C                   EVAL      PTNIFC3    =   M9CNI2
     C                   EVAL      PTCUST3    =   M9CNA2
     C                   EVAL      PTZIP3     =   M9PRV2
     C                   EVAL      PTRATE3    =   M9WTR2

     C                   MOVEL     M9PNT2        PSPERC
     C                   EVAL      PTPERC3    = %EDITC(PSPERC : '4')

     C                   EVAL      PTCGROSSC  =   M9GIN2
     C                   EVAL      PTCTAXC    =   M9GIN2
     C                   EVAL      PTDTAXC    =   M9TWH2
     C                   EVAL      PRINTCOUNT = PRINTCOUNT + 1

      ** Perceptor 4
     C                   WHEN      PRINTCOUNT = 4
     C                   EVAL      PTCLAVE4   =   'C'
     C                   EVAL      PTTIPO4    =   '1'
     C                   EVAL      PTNIFC4    =   M9CNI2
     C                   EVAL      PTCUST4    =   M9CNA2
     C                   EVAL      PTZIP4     =   M9PRV2
     C                   EVAL      PTRATE4    =   M9WTR2

     C                   MOVEL     M9PNT2        PSPERC
     C                   EVAL      PTPERC4    = %EDITC(PSPERC : '4')

     C                   EVAL      PTCGROSSD  =   M9GIN2
     C                   EVAL      PTCTAXD    =   M9GIN2
     C                   EVAL      PTDTAXD    =   M9TWH2
     C                   EVAL      PRINTCOUNT = PRINTCOUNT + 1

      ** Perceptor 5
     C                   WHEN      PRINTCOUNT = 5
     C                   EVAL      PTCLAVE5   =   'C'
     C                   EVAL      PTTIPO5    =   '1'
     C                   EVAL      PTNIFC5    =   M9CNI2
     C                   EVAL      PTCUST5    =   M9CNA2
     C                   EVAL      PTZIP5     =   M9PRV2
     C                   EVAL      PTRATE5    =   M9WTR2

     C                   MOVEL     M9PNT2        PSPERC
     C                   EVAL      PTPERC5    = %EDITC(PSPERC : '4')

     C                   EVAL      PTCGROSSE  =   M9GIN2
     C                   EVAL      PTCTAXE    =   M9GIN2
     C                   EVAL      PTDTAXE    =   M9TWH2
     C                   EVAL      PRINTCOUNT = PRINTCOUNT + 1
     C                   ENDSL


      ** Print Details

     C                   IF        PRINTCOUNT = 6
     C                   WRITE     DETAIL
     C                   EVAL      PRINTCOUNT = 1
     C                   EXSR      SRClearFields
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetDecimal  Get Decimal Place Routine                      *
      *                                                               *
      *****************************************************************
     C     SRGetDecimal  BEGSR

     C                   MOVEA     '0000'        *IN(50)
     C                   MOVEA     '0000000'     *IN(60)
     C                   MOVEA     '00000000'    *IN(67)

     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL      *IN50 = *ON
     C                   WHEN      A6NBDP = 1
     C                   EVAL      *IN51 = *ON
     C                   WHEN      A6NBDP = 2
     C                   EVAL      *IN52 = *ON
     C                   WHEN      A6NBDP = 3
     C                   EVAL      *IN53 = *ON
     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClearFields - Clear Report Working Fields Routine          *
      *                                                               *
      *****************************************************************
     C     SRClearFields BEGSR

     C                   CLEAR                   DETAIL
     C                   CLEAR                   PSPERC
     C                   CLEAR                   PTCGROSSA
     C                   CLEAR                   PTCTAXA
     C                   CLEAR                   PTDTAXA
     C                   CLEAR                   PTCGROSSB
     C                   CLEAR                   PTCTAXB
     C                   CLEAR                   PTDTAXB
     C                   CLEAR                   PTCGROSSC
     C                   CLEAR                   PTCTAXC
     C                   CLEAR                   PTDTAXC
     C                   CLEAR                   PTCGROSSD
     C                   CLEAR                   PTCTAXD
     C                   CLEAR                   PTDTAXD
     C                   CLEAR                   PTCGROSSE
     C                   CLEAR                   PTCTAXE
     C                   CLEAR                   PTDTAXE

     C                   EVAL      PTNIFA     =   M9ENIF
     C                   EVAL      PTYEARA    =   M9YEAR

     C                   IF        M9TRID    <>  *ZERO
     C                   EVAL      PTTAXRA   =   %CHAR(M9TRID)
     C                   ENDIF

     C                   EXSR      SRGetDecimal

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndProgram - End Program Routine                           *
      *                                                               *
      *****************************************************************
     C     SREndProgram  BEGSR

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

     C                   IF        NOT %OPEN(RE000009AU)
     C                   OPEN      RE000009AU
     C                   ENDIF
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR

     C                   RETURN

     C                   ENDSR
